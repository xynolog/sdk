{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

-- | Conditional HTTP reads of a launcher's whole discovery document.
module Xynolog.Http.Discovery (httpDiscovery) where

import Control.Concurrent.Async (race)
import Control.Concurrent.MVar (modifyMVar, newMVar)
import Control.Exception (try)
import Data.ByteString qualified as Bytes
import Data.Text (Text)
import Data.Text qualified as Text
import Data.Text.Encoding (decodeUtf8', decodeUtf8With)
import Data.Text.Encoding.Error (lenientDecode)
import Network.HTTP.Client
import Network.HTTP.Types (hAccept, hContentType, hETag, hIfNoneMatch, statusCode)
import Network.URI (parseURI, uriAuthority, uriFragment, uriScheme, uriUserInfo)
import Xynolog.Discovery
import Xynolog.Internal.Http (HttpClient (..))
import Xynolog.Retry qualified as Retry
import Xynolog.Timing.Settings qualified as Timing
import Xynolog.Types
  ( DiscoveryAbsent (..),
    DiscoveryAbsentKind (..),
    DiscoveryAbsentReason (..),
    DiscoveryRead (..),
    DiscoveryState (..),
    DiscoveryUnchanged (..),
    DiscoveryUnchangedKind (..),
  )

-- | The caller owns its HTTP pool. Reads are serial and bounded by the
-- caller's clock; only a complete managed document replaces the saved ETag.
httpDiscovery :: HttpClient -> Retry.RetryOptions -> Timing.TransportTiming -> Text -> IO DiscoveryTransport
httpDiscovery (HttpClient manager) time timing url = do
  case parseURI (Text.unpack url) of
    Just uri
      | uriScheme uri `elem` ["http:", "https:"]
          && null (uriFragment uri)
          && maybe False (null . uriUserInfo) (uriAuthority uri) ->
          pure ()
    _ -> ioError (userError "Discovery needs a credential-free HTTP URL")
  template <- parseRequest (Text.unpack url)
  tag <- newMVar Nothing
  pure $ DiscoveryTransport $ modifyMVar tag $ \previous -> do
    let request =
          template
            { requestHeaders = [(hAccept, "application/json")] ++ maybe [] (\value -> [(hIfNoneMatch, value)]) previous,
              checkResponse = \_ _ -> pure (),
              responseTimeout = responseTimeoutNone
            }
        readResponse = withResponse request manager $ \response -> do
          bytes <- Bytes.concat <$> brConsume (responseBody response)
          let code = statusCode (responseStatus response)
              headers = responseHeaders response
              contentType = maybe "" (Text.toLower . decodeUtf8With lenientDecode) (lookup hContentType headers)
              absent reason diagnostic = (previous, absentRead reason diagnostic)
          pure $
            if code == 304
              then (previous, DiscoveryReadDiscoveryUnchanged (DiscoveryUnchanged DiscoveryUnchangedKindUnchanged))
              else
                if code < 200 || code >= 300
                  then absent DiscoveryAbsentReasonNotFound ("HTTP " <> Text.pack (show code))
                  else
                    if not ("json" `Text.isInfixOf` contentType)
                      then absent DiscoveryAbsentReasonNotFound ("The content type is " <> contentType)
                      else case decodeUtf8' bytes of
                        Left _ -> absent DiscoveryAbsentReasonUnreadable "The discovery document is not UTF-8"
                        Right text -> case parseDiscoveryDocument text of
                          DiscoveryStateDiscoveryManaged managed -> (lookup hETag headers, DiscoveryReadDiscoveryManaged managed)
                          DiscoveryStateDiscoveryAbsent found -> (previous, DiscoveryReadDiscoveryAbsent found)
    now <- Retry.retryNow time
    answer <- try (race readResponse (Retry.retryWaitUntil time (now + Timing.httpRequestTimeoutMs timing * 1000000)))
    case answer of
      Left (_ :: HttpException) -> pure (previous, absentRead DiscoveryAbsentReasonUnreadable "The discovery request received no usable answer")
      Right (Right ()) -> pure (previous, absentRead DiscoveryAbsentReasonUnreadable "The discovery request deadline expired")
      Right (Left result) -> pure result

absentRead :: DiscoveryAbsentReason -> Text -> DiscoveryRead
absentRead reason diagnostic = DiscoveryReadDiscoveryAbsent (DiscoveryAbsent DiscoveryAbsentKindAbsent reason (Just diagnostic))
