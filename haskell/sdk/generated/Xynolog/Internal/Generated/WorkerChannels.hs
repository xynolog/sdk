-- Generated from protocol/specs/src/client/surface.json and bus/registry.json; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/worker.ml)
module Xynolog.Internal.Generated.WorkerChannels (jobClaimChannels, jobCommitChannels) where

import Data.Text (Text)
import Xynolog.Channels

jobClaimChannels :: [Text]
jobClaimChannels = [channelName JobClaimed, channelName JobClaimFailed, channelName JobQueued, channelName JobCancelRequested]

jobCommitChannels :: [Text]
jobCommitChannels = [channelName MarkCommitOk, channelName MarkCommitFailed, channelName BrowseAnnotationResult, channelName BrowseAnnotationFailed]
