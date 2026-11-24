-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.StackStopResult (StackStopResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.KnowledgeBaseStatus
import Xynolog.Internal.Generated.Models.ServiceStatus

data StackStopResult = StackStopResult
  { stackStopResultDryRun :: Bool,
    stackStopResultKnowledgeBases :: Maybe [KnowledgeBaseStatus],
    stackStopResultShared :: Maybe [ServiceStatus]
  }
  deriving (Eq, Show)

instance FromJSON StackStopResult where parseJSON = checked "StackStopResult" $ withObject "StackStopResult" (\fields -> StackStopResult <$> (fields .: "dryRun") <*> optional fields "knowledgeBases" <*> optional fields "shared")

instance ToJSON StackStopResult where toJSON value = Object (KM.fromList (concat [[("dryRun", toJSON (stackStopResultDryRun value))], optionalPair "knowledgeBases" (stackStopResultKnowledgeBases value), optionalPair "shared" (stackStopResultShared value)]))
