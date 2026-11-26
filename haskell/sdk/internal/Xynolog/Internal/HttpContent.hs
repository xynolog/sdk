{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.HttpContent (newContent) where

import Control.Concurrent.STM
import Control.Exception (bracket_, throwIO)
import Control.Monad (unless)
import Control.Monad.IO.Class (liftIO)
import Data.Aeson (Value (..), encode, object, toJSON, (.=))
import Data.Aeson.Key qualified as Key
import Data.Aeson.KeyMap qualified as KM
import Data.ByteString qualified as Bytes
import Data.ByteString.Lazy qualified as Lazy
import Data.Char (ord)
import Data.IORef
import Data.Text qualified as Text
import Data.Text.Encoding (decodeUtf8With, encodeUtf8)
import Data.Text.Encoding.Error (lenientDecode)
import Data.UUID.Types qualified as UUID
import Network.HTTP.Client (RequestBody (..), brConsume, brRead, responseBody, responseHeaders)
import Numeric (showHex)
import OpenTelemetry.Attributes (toAttribute)
import OpenTelemetry.Trace.Core qualified as Trace
import Streaming.Prelude qualified as Stream
import Xynolog.Content qualified as Content
import Xynolog.ErrorCodes qualified as Code
import Xynolog.Errors
import Xynolog.Http.Routes
import Xynolog.Internal.BusLog qualified as BusLog
import Xynolog.Internal.Generated.OperationReports (UploadEvent (..))
import Xynolog.Internal.Generated.TelemetryKeys (attributeContentStream, attributeResourceId)
import Xynolog.Internal.Generated.TelemetryNames (spanContentGet, spanContentGetAnchoredText, spanContentGetAnnotations, spanContentGetGraph)
import Xynolog.Internal.Http
import Xynolog.Internal.Lifetime qualified as Lifetime
import Xynolog.Internal.Telemetry qualified as Telemetry
import Xynolog.Timing.Settings qualified as Settings
import Xynolog.Types

newContent :: Http -> IO Content.ContentTransport
newContent http = do
  life <- Lifetime.newLifetime "HTTP transport is closed"
  let owned :: IO result -> IO result
      owned = Lifetime.run life
      stream :: Bool -> Maybe Text.Text -> ResourceId -> (Text.Text -> Stream.Stream (Stream.Of Bytes.ByteString) IO () -> IO result) -> IO result
      stream streaming override resource consume = owned
        $ report http
        $ Telemetry.withSpan
          Trace.Client
          spanContentGet
          ((attributeResourceId, toAttribute (resourceIdValue resource)) : [(attributeContentStream, toAttribute True) | streaming])
        $ do
          BusLog.content (logger http) "GET" (object ["resourceId" .= resource])
          exchange http GetResourceRepresentation (Just resource) (pure (RequestBodyBS Bytes.empty)) Nothing override [] $ \response -> do
            media <-
              maybe
                (throwIO (TransportError Code.TransportError "Content response has no media type" Nothing Nothing))
                pure
                (lookup "Content-Type" (responseHeaders response))
            active <- newTVarIO True
            let chunks = do
                  bytes <- liftIO $ do
                    available <- atomically ((&&) <$> readTVar active <*> (not <$> Lifetime.isClosed life))
                    unless available (throwIO (TransportError Code.TransportError "Content reader is outside its response scope" Nothing Nothing))
                    brRead (responseBody response)
                  unless (Bytes.null bytes) (Stream.yield bytes >> chunks)
            bracket_ (pure ()) (atomically (writeTVar active False)) (consume (decodeUtf8With lenientDecode media) chunks)
      upload override asked progress = owned $ report http $ do
        let file = binaryValue (putBinaryRequestFile asked)
            format = putBinaryRequestFormat asked
            total = toInteger (Bytes.length file)
        fields <- case toJSON asked of Object fields -> pure (KM.delete "file" fields); _ -> throwIO (TransportError Code.TransportBadRequest "Upload request is not an object" Nothing Nothing)
        BusLog.content (logger http) "PUT" (Object fields)
        Telemetry.withUpload format (pure total) $ do
          _ <- checked asked
          key <- UUID.toText <$> httpNewId (options http)
          boundary <- UUID.toText <$> httpNewId (options http)
          unless
            (Text.all (\c -> c >= ' ' && c <= '~') format && not (Text.null format))
            (throwIO (TransportError Code.TransportBadRequest "Invalid multipart header value" Nothing Nothing))
          let quoted =
                encodeUtf8
                  . Text.concatMap
                    ( \c ->
                        if c < ' ' || c `elem` ['\DEL', '\r', '\n', '\\', '\"', '%']
                          then let hex = showHex (ord c) "" in "%" <> Text.pack (if length hex == 1 then '0' : hex else hex)
                          else Text.singleton c
                    )
              marker = encodeUtf8 boundary
              part name value = "--" <> marker <> "\r\nContent-Disposition: form-data; name=\"" <> quoted name <> "\"\r\n\r\n" <> value <> "\r\n"
              prefix =
                Bytes.concat [part (Key.toText name) (case value of String text -> encodeUtf8 text; _ -> Lazy.toStrict (encode value)) | (name, value) <- KM.toList fields]
                  <> "--"
                  <> marker
                  <> "\r\nContent-Disposition: form-data; name=\"file\"; filename=\""
                  <> quoted (putBinaryRequestName asked)
                  <> "\"\r\nContent-Type: "
                  <> encodeUtf8 format
                  <> "\r\n\r\n"
              suffix = "\r\n--" <> marker <> "--\r\n"
          progress (UploadStarted total)
          let give consume = do
                remaining <- newIORef [(prefix, pure ()), (file, progress (UploadProgress total total)), (suffix, pure ())]
                consume $ do
                  next <- atomicModifyIORef' remaining (\parts -> case dropWhile (Bytes.null . fst) parts of [] -> ([], Nothing); chunk : rest -> (rest, Just chunk))
                  case next of
                    Nothing -> pure Bytes.empty
                    Just (chunk, sent) -> sent >> pure chunk
              body = RequestBodyStream (fromIntegral (Bytes.length prefix + Bytes.length file + Bytes.length suffix)) give
          let uploadRoute = UploadResource :: HttpRoute ResourceUpload CreateResourceResponse
          media <- case routeRequestMediaType uploadRoute of
            Just value | value == "multipart/form-data" -> pure value
            _ -> throwIO (TransportError Code.TransportBadRequest "Upload route no longer accepts multipart" Nothing Nothing)
          exchange http uploadRoute Nothing (pure body) (Just key) override [("Content-Type", media <> "; boundary=" <> marker)] $ \response -> do
            bytes <- deadline http (Settings.httpRequestTimeoutMs (httpTiming (options http))) (Bytes.concat <$> brConsume (responseBody response))
            created <- readAnswer uploadRoute bytes
            progress (UploadFinished (createResourceResponseResourceId created))
            pure created
  let readNote :: ResourceId -> IO result -> IO result
      readNote resource action = BusLog.content (logger http) "GET" (object ["resourceId" .= resource]) >> action
  pure
    Content.ContentTransport
      { Content.putBinary = upload,
        Content.getBinaryStream = stream True,
        Content.getBinary = \override resource -> stream False override resource (\media chunks -> deadline http (Settings.httpRequestTimeoutMs (httpTiming (options http))) ((\bytes -> ResourceRepresentation {resourceRepresentationData = Binary bytes, resourceRepresentationContentType = media}) . Bytes.concat <$> Stream.toList_ chunks)),
        Content.getResourceGraph = \override resource -> owned (readNote resource (Telemetry.withSpan Trace.Client spanContentGetGraph [(attributeResourceId, toAttribute (resourceIdValue resource))] (json http GetResourceJsonLd (Just resource) override ()))),
        Content.getAnnotations = \override resource -> owned (readNote resource (Telemetry.withSpan Trace.Client spanContentGetAnnotations [(attributeResourceId, toAttribute (resourceIdValue resource))] (json http GetResourceAnnotations (Just resource) override ()))),
        Content.getAnchoredText = \override resource -> owned (readNote resource (Telemetry.withSpan Trace.Client spanContentGetAnchoredText [(attributeResourceId, toAttribute (resourceIdValue resource))] (json http GetResourceAnchoredText (Just resource) override ()))),
        Content.dispose = Lifetime.close life
      }
