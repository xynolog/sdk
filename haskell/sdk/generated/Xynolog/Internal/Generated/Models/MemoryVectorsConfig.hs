-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MemoryVectorsConfig (MemoryVectorsConfig (..), MemoryVectorsConfigType (..), memoryVectorsConfigTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data MemoryVectorsConfig = MemoryVectorsConfig
  { memoryVectorsConfigType :: MemoryVectorsConfigType
  }
  deriving (Eq, Show)

instance FromJSON MemoryVectorsConfig where parseJSON = checked "MemoryVectorsConfig" $ withObject "MemoryVectorsConfig" (\fields -> MemoryVectorsConfig <$> (fields .: "type"))

instance ToJSON MemoryVectorsConfig where toJSON value = Object (KM.fromList (concat [[("type", toJSON (memoryVectorsConfigType value))]]))

data MemoryVectorsConfigType = MemoryVectorsConfigTypeMemory deriving (Eq, Show)

instance FromJSON MemoryVectorsConfigType where parseJSON = checked "MemoryVectorsConfigType" $ \value -> if value == String "memory" then pure MemoryVectorsConfigTypeMemory else fail "unknown enumeration member"

instance ToJSON MemoryVectorsConfigType where toJSON MemoryVectorsConfigTypeMemory = String "memory"

memoryVectorsConfigTypeText :: MemoryVectorsConfigType -> Text
memoryVectorsConfigTypeText MemoryVectorsConfigTypeMemory = "memory"
