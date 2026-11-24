-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JanusGraphConfig (JanusGraphConfig (..), JanusGraphConfigType (..), janusGraphConfigTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data JanusGraphConfig = JanusGraphConfig
  { janusGraphConfigHost :: Text,
    janusGraphConfigPort :: Integer,
    janusGraphConfigType :: JanusGraphConfigType
  }
  deriving (Eq, Show)

instance FromJSON JanusGraphConfig where parseJSON = checked "JanusGraphConfig" $ withObject "JanusGraphConfig" (\fields -> JanusGraphConfig <$> (fields .: "host") <*> (fields .: "port") <*> (fields .: "type"))

instance ToJSON JanusGraphConfig where toJSON value = Object (KM.fromList (concat [[("host", toJSON (janusGraphConfigHost value))], [("port", toJSON (janusGraphConfigPort value))], [("type", toJSON (janusGraphConfigType value))]]))

data JanusGraphConfigType = JanusGraphConfigTypeJanusgraph deriving (Eq, Show)

instance FromJSON JanusGraphConfigType where parseJSON = checked "JanusGraphConfigType" $ \value -> if value == String "janusgraph" then pure JanusGraphConfigTypeJanusgraph else fail "unknown enumeration member"

instance ToJSON JanusGraphConfigType where toJSON JanusGraphConfigTypeJanusgraph = String "janusgraph"

janusGraphConfigTypeText :: JanusGraphConfigType -> Text
janusGraphConfigTypeText JanusGraphConfigTypeJanusgraph = "janusgraph"
