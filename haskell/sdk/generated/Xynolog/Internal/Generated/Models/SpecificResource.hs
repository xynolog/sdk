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
  { specificResourcePurpose :: Maybe BodyPurpose,
    specificResourceSource :: ResourceId,
    specificResourceType :: SpecificResourceType,
    specificResourceAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON SpecificResource where parseJSON = checked "SpecificResource" $ withObject "SpecificResource" (\fields -> SpecificResource <$> optional fields "purpose" <*> (fields .: "source") <*> (fields .: "type") <*> traverse parseJSON (withoutFields ["purpose", "source", "type"] fields))

instance ToJSON SpecificResource where toJSON value = Object (KM.fromList (concat [optionalPair "purpose" (specificResourcePurpose value), [("source", toJSON (specificResourceSource value))], [("type", toJSON (specificResourceType value))]]) <> fmap toJSON (withoutFields ["purpose", "source", "type"] (specificResourceAdditionalProperties value)))

data SpecificResourceType = SpecificResourceTypeSpecificResource deriving (Eq, Show)

instance FromJSON SpecificResourceType where parseJSON = checked "SpecificResourceType" $ \value -> if value == String "SpecificResource" then pure SpecificResourceTypeSpecificResource else fail "unknown enumeration member"

instance ToJSON SpecificResourceType where toJSON SpecificResourceTypeSpecificResource = String "SpecificResource"

specificResourceTypeText :: SpecificResourceType -> Text
specificResourceTypeText SpecificResourceTypeSpecificResource = "SpecificResource"
