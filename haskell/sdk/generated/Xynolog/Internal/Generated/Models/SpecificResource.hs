-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SpecificResource (SpecificResource (..), SpecificResourceType (..), specificResourceTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.BodyPurpose
import Xynolog.Internal.Generated.Models.ResourceId

data SpecificResource = SpecificResource
  { specificResourceType :: SpecificResourceType,
    specificResourceSource :: ResourceId,
    specificResourcePurpose :: Maybe BodyPurpose
  }
  deriving (Eq, Show)

instance FromJSON SpecificResource where parseJSON = checked "SpecificResource" $ withObject "SpecificResource" (\fields -> SpecificResource <$> (fields .: "type") <*> (fields .: "source") <*> optional fields "purpose")

instance ToJSON SpecificResource where toJSON value = Object (KM.fromList (concat [[("type", toJSON (specificResourceType value))], [("source", toJSON (specificResourceSource value))], optionalPair "purpose" (specificResourcePurpose value)]))

data SpecificResourceType = SpecificResourceTypeSpecificResource deriving (Eq, Show)

instance FromJSON SpecificResourceType where parseJSON = checked "SpecificResourceType" $ \value -> if value == String "SpecificResource" then pure SpecificResourceTypeSpecificResource else fail "unknown enumeration member"

instance ToJSON SpecificResourceType where toJSON SpecificResourceTypeSpecificResource = String "SpecificResource"

specificResourceTypeText :: SpecificResourceType -> Text
specificResourceTypeText SpecificResourceTypeSpecificResource = "SpecificResource"
