-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MemoryGraphConfig (MemoryGraphConfig (..), MemoryGraphConfigType (..), memoryGraphConfigTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data MemoryGraphConfig = MemoryGraphConfig
  { memoryGraphConfigType :: MemoryGraphConfigType
  }
  deriving (Eq, Show)

instance FromJSON MemoryGraphConfig where parseJSON = checked "MemoryGraphConfig" $ withObject "MemoryGraphConfig" (\fields -> MemoryGraphConfig <$> (fields .: "type"))

instance ToJSON MemoryGraphConfig where toJSON value = Object (KM.fromList (concat [[("type", toJSON (memoryGraphConfigType value))]]))

data MemoryGraphConfigType = MemoryGraphConfigTypeMemory deriving (Eq, Show)

instance FromJSON MemoryGraphConfigType where parseJSON = checked "MemoryGraphConfigType" $ \value -> if value == String "memory" then pure MemoryGraphConfigTypeMemory else fail "unknown enumeration member"

instance ToJSON MemoryGraphConfigType where toJSON MemoryGraphConfigTypeMemory = String "memory"

memoryGraphConfigTypeText :: MemoryGraphConfigType -> Text
memoryGraphConfigTypeText MemoryGraphConfigTypeMemory = "memory"
