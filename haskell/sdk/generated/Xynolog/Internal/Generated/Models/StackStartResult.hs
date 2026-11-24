-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.StackStartResult (StackStartResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.KnowledgeBaseStatus
import Xynolog.Internal.Generated.Models.ServiceStatus

data StackStartResult = StackStartResult
  { stackStartResultDryRun :: Bool,
    stackStartResultKnowledgeBase :: Maybe KnowledgeBaseStatus,
    stackStartResultShared :: Maybe [ServiceStatus]
  }
  deriving (Eq, Show)

instance FromJSON StackStartResult where parseJSON = checked "StackStartResult" $ withObject "StackStartResult" (\fields -> StackStartResult <$> (fields .: "dryRun") <*> optional fields "knowledgeBase" <*> optional fields "shared")

instance ToJSON StackStartResult where toJSON value = Object (KM.fromList (concat [[("dryRun", toJSON (stackStartResultDryRun value))], optionalPair "knowledgeBase" (stackStartResultKnowledgeBase value), optionalPair "shared" (stackStartResultShared value)]))
