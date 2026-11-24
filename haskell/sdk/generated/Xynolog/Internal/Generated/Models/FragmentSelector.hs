-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.FragmentSelector (FragmentSelector (..), FragmentSelectorType (..), fragmentSelectorTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data FragmentSelector = FragmentSelector
  { fragmentSelectorConformsTo :: Maybe Text,
    fragmentSelectorType :: FragmentSelectorType,
    fragmentSelectorValue :: Text,
    fragmentSelectorAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON FragmentSelector where parseJSON = checked "FragmentSelector" $ withObject "FragmentSelector" (\fields -> FragmentSelector <$> optional fields "conformsTo" <*> (fields .: "type") <*> (fields .: "value") <*> traverse parseJSON (withoutFields ["conformsTo", "type", "value"] fields))

instance ToJSON FragmentSelector where toJSON value = Object (KM.fromList (concat [optionalPair "conformsTo" (fragmentSelectorConformsTo value), [("type", toJSON (fragmentSelectorType value))], [("value", toJSON (fragmentSelectorValue value))]]) <> fmap toJSON (withoutFields ["conformsTo", "type", "value"] (fragmentSelectorAdditionalProperties value)))

data FragmentSelectorType = FragmentSelectorTypeFragmentSelector deriving (Eq, Show)

instance FromJSON FragmentSelectorType where parseJSON = checked "FragmentSelectorType" $ \value -> if value == String "FragmentSelector" then pure FragmentSelectorTypeFragmentSelector else fail "unknown enumeration member"

instance ToJSON FragmentSelectorType where toJSON FragmentSelectorTypeFragmentSelector = String "FragmentSelector"

fragmentSelectorTypeText :: FragmentSelectorType -> Text
fragmentSelectorTypeText FragmentSelectorTypeFragmentSelector = "FragmentSelector"
