-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.FragmentSelector (FragmentSelector (..), FragmentSelectorType (..), fragmentSelectorTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data FragmentSelector = FragmentSelector
  { fragmentSelectorType :: FragmentSelectorType,
    fragmentSelectorValue :: Text,
    fragmentSelectorConformsTo :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON FragmentSelector where parseJSON = checked "FragmentSelector" $ withObject "FragmentSelector" (\fields -> FragmentSelector <$> (fields .: "type") <*> (fields .: "value") <*> optional fields "conformsTo")

instance ToJSON FragmentSelector where toJSON value = Object (KM.fromList (concat [[("type", toJSON (fragmentSelectorType value))], [("value", toJSON (fragmentSelectorValue value))], optionalPair "conformsTo" (fragmentSelectorConformsTo value)]))

data FragmentSelectorType = FragmentSelectorTypeFragmentSelector deriving (Eq, Show)

instance FromJSON FragmentSelectorType where parseJSON = checked "FragmentSelectorType" $ \value -> if value == String "FragmentSelector" then pure FragmentSelectorTypeFragmentSelector else fail "unknown enumeration member"

instance ToJSON FragmentSelectorType where toJSON FragmentSelectorTypeFragmentSelector = String "FragmentSelector"

fragmentSelectorTypeText :: FragmentSelectorType -> Text
fragmentSelectorTypeText FragmentSelectorTypeFragmentSelector = "FragmentSelector"
