{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

-- | Prove the knowledge base reached by a fresh credential. An address is
-- never an identity, and no DID is manufactured when the KB cannot say it.
module Xynolog.Registry.Identity
  ( ConnectionIdentity (..),
    IdentityUnverifiableError (..),
    describeConnection,
    samePlace,
  )
where

import Control.Exception (Exception, SomeAsyncException, SomeException, bracket, fromException, throwIO, try)
import Data.Map.Strict qualified as Map
import Data.Set qualified as Set
import Data.Text (Text)
import Data.Text qualified as Text
import Xynolog.Browse qualified as Browse
import Xynolog.Channels (Operation (BrowseKbRequestedOperation), channelName, operationChannels)
import Xynolog.Client qualified as Client
import Xynolog.ErrorCodes (BusRequestCode (BusRequestRejected), KbIdentityCode (..))
import Xynolog.Errors (BusRequestError (..))
import Xynolog.Gateway qualified as Gateway
import Xynolog.Http qualified as Http
import Xynolog.Identity qualified as Identity
import Xynolog.Types

data IdentityUnverifiableError = IdentityUnverifiableError
  { identityUnverifiableReason :: KbIdentityCode,
    identityUnverifiableDetail :: Text
  }
  deriving (Eq, Show)

instance Exception IdentityUnverifiableError

samePlace :: KbEndpoint -> KbEndpoint -> Bool
samePlace (KbEndpointHttpEndpoint one) (KbEndpointHttpEndpoint other) =
  httpEndpointProtocol one == httpEndpointProtocol other
    && Text.toLower (httpEndpointHost one) == Text.toLower (httpEndpointHost other)
    && httpEndpointPort one == httpEndpointPort other
samePlace (KbEndpointLocalEndpoint one) (KbEndpointLocalEndpoint other) = localEndpointKbId one == localEndpointKbId other
samePlace _ _ = False

describeConnection :: Http.HttpOptions -> HttpEndpoint -> Text -> IO ConnectionIdentity
describeConnection http target access = do
  base <- either (throwIO . IdentityUnverifiableError KbIdentityUnreachable) pure (Gateway.gatewayUrl target)
  let (_, result, failure) = operationChannels BrowseKbRequestedOperation
      options =
        http
          { Http.httpBaseUrl = base,
            Http.httpToken = pure (Just access),
            Http.httpRenewToken = const (pure Nothing),
            Http.httpGlobalChannels = Set.fromList [channelName result, channelName failure],
            Http.httpLoadPositions = pure Map.empty,
            Http.httpSavePosition = \_ _ -> pure ()
          }
  readBack <- try $ bracket (Client.fromHttp options Nothing) Client.dispose (Browse.kb . Client.browse)
  description <- case readBack of
    Right value -> pure value
    Left (problem :: SomeException) -> case fromException problem :: Maybe SomeAsyncException of
      Just _ -> throwIO problem
      Nothing ->
        throwIO
          ( IdentityUnverifiableError
              ( case fromException problem of
                  Just refusal | busRequestErrorCode refusal == BusRequestRejected -> KbIdentityNotReported
                  _ -> KbIdentityUnreachable
              )
              "The knowledge base could not establish its identity with the issued credential"
          )
  did <- either (throwIO . IdentityUnverifiableError KbIdentityNotReported . Text.pack) pure (Identity.kbDid (kbDescriptionDomain description))
  pure (ConnectionIdentity {connectionIdentityDescription = description, connectionIdentityDid = did})
