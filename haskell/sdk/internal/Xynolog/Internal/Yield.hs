{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Yield (YieldNamespace, newYield, resource, delegate, cloneToken, fromToken, createFromToken, clone) where

import Control.Concurrent.STM (STM)
import Data.Maybe (fromMaybe)
import Data.Scientific (Scientific)
import Data.Text (Text)
import Data.Text.Encoding (encodeUtf8)
import Xynolog.Bus qualified as Bus
import Xynolog.Channels
import Xynolog.Content qualified as Content
import Xynolog.Internal.DelegatedVerbs qualified as Verb
import Xynolog.Internal.Delegation qualified as Delegation
import Xynolog.Internal.Local qualified as Local
import Xynolog.Internal.Running qualified as Running
import Xynolog.Internal.Transport qualified as LocalBus
import Xynolog.MediaTypes qualified as Media
import Xynolog.Resources qualified as Resources
import Xynolog.Timing.Settings qualified as Timing
import Xynolog.Types

data YieldNamespace = YieldNamespace Bus.Bus LocalBus.EventBus Content.ContentTransport Timing.Settings Delegation.Follower

newYield :: Bus.Bus -> LocalBus.EventBus -> Content.ContentTransport -> Timing.Settings -> Delegation.Follower -> YieldNamespace
newYield = YieldNamespace

resource :: YieldNamespace -> ResourceUploadMetadata -> Content.ReplayableBody -> IO (Running.Running Delegation.UploadEvent CreateResourceResponse)
resource (YieldNamespace _ _ content _ follower) metadata body = Running.newRunning $ \report -> Delegation.run follower (Content.putBinary content Nothing metadata body report)

delegate :: YieldNamespace -> GenerationJobParams -> Maybe Scientific -> IO (Running.Running (Delegation.JobEvent YieldJobCompleteCommand) YieldJobCompleteCommand)
delegate (YieldNamespace _ _ _ timing follower) params stall =
  Delegation.follow
    follower
    (JobCreateCommandYieldJobCreateCommand (YieldJobCreateCommand Nothing Nothing YieldJobCreateCommandJobTypeYield params))
    Verb.yield
    identity
    (Just (fromMaybe (Delegation.deriveStallDeadlineMs timing (generationJobParamsMaxTokens params)) stall))
  where
    identity = case gatheredContextFocus (generationJobParamsContext params) of
      GatheredContextFocusAnnotation focus -> resourceDescriptorU40_id (gatheredContextFocusAnnotationValueSourceResource focus)
      GatheredContextFocusResource focus -> resourceDescriptorU40_id (gatheredContextFocusResourceValueResource focus)

cloneToken :: YieldNamespace -> ResourceId -> IO CloneResourceWithTokenResponse
cloneToken (YieldNamespace wire _ _ timing _) identity =
  cloneResourceWithTokenResponseBusEnvelopeResponse
    <$> Bus.request wire YieldCloneTokenRequestedOperation (YieldCloneTokenRequest identity mempty) (Timing.busRequestTimeoutMs timing)

fromToken :: YieldNamespace -> Text -> IO ResourceDescriptor
fromToken (YieldNamespace wire _ _ timing _) token =
  getResourceByTokenResponseSourceResource . getResourceByTokenResponseBusEnvelopeResponse
    <$> Bus.request wire YieldCloneResourceRequestedOperation (YieldCloneResourceRequest token mempty) (Timing.busRequestTimeoutMs timing)

createFromToken :: YieldNamespace -> CreateFromTokenOptions -> IO CreateResourceResponse
createFromToken namespace@(YieldNamespace _ _ content _ follower) (CreateFromTokenOptions archiveOriginal text name token) = Delegation.run follower $ do
  source <- fromToken namespace token
  let format = Media.cloneFormat (Resources.getPrimaryMediaType source)
  file <- either (ioError . userError . show) pure (Media.storageFileName name format)
  let metadata =
        ResourceUploadMetadata
          { resourceUploadMetadataArchiveOriginal = fmap (\value -> if value then "true" else "false") archiveOriginal,
            resourceUploadMetadataCloneToken = Just token,
            resourceUploadMetadataEntityTypes = Nothing,
            resourceUploadMetadataFormat = format,
            resourceUploadMetadataGenerationPrompt = Nothing,
            resourceUploadMetadataGenerator = Nothing,
            resourceUploadMetadataIsDraft = Nothing,
            resourceUploadMetadataJobId = Nothing,
            resourceUploadMetadataLanguage = Nothing,
            resourceUploadMetadataName = name,
            resourceUploadMetadataSourceAnnotationId = Nothing,
            resourceUploadMetadataSourceResourceId = Nothing,
            resourceUploadMetadataStorageUri = "file://" <> file,
            resourceUploadMetadataAdditionalProperties = mempty
          }
  Content.putBinary content Nothing metadata (Content.bytesBody (encodeUtf8 text)) (const (pure ()))

clone :: YieldNamespace -> STM ()
clone (YieldNamespace _ local _ _ _) = Local.signal local YieldClone EmptyBusPayload NoScope
