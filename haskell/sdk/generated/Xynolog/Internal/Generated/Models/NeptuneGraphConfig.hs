-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.NeptuneGraphConfig (NeptuneGraphConfig (..), NeptuneGraphConfigType (..), neptuneGraphConfigTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data NeptuneGraphConfig = NeptuneGraphConfig
  { neptuneGraphConfigEndpoint :: Text,
    neptuneGraphConfigPort :: Integer,
    neptuneGraphConfigType :: NeptuneGraphConfigType
  }
  deriving (Eq, Show)

instance FromJSON NeptuneGraphConfig where parseJSON = checked "NeptuneGraphConfig" $ withObject "NeptuneGraphConfig" (\fields -> NeptuneGraphConfig <$> (fields .: "endpoint") <*> (fields .: "port") <*> (fields .: "type"))

instance ToJSON NeptuneGraphConfig where toJSON value = Object (KM.fromList (concat [[("endpoint", toJSON (neptuneGraphConfigEndpoint value))], [("port", toJSON (neptuneGraphConfigPort value))], [("type", toJSON (neptuneGraphConfigType value))]]))

data NeptuneGraphConfigType = NeptuneGraphConfigTypeNeptune deriving (Eq, Show)

instance FromJSON NeptuneGraphConfigType where parseJSON = checked "NeptuneGraphConfigType" $ \value -> if value == String "neptune" then pure NeptuneGraphConfigTypeNeptune else fail "unknown enumeration member"

instance ToJSON NeptuneGraphConfigType where toJSON NeptuneGraphConfigTypeNeptune = String "neptune"

neptuneGraphConfigTypeText :: NeptuneGraphConfigType -> Text
neptuneGraphConfigTypeText NeptuneGraphConfigTypeNeptune = "neptune"
