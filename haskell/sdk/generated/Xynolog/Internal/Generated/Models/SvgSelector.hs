-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SvgSelector (SvgSelector (..), SvgSelectorType (..), svgSelectorTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data SvgSelector = SvgSelector
  { svgSelectorType :: SvgSelectorType,
    svgSelectorValue :: Text,
    svgSelectorAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON SvgSelector where parseJSON = checked "SvgSelector" $ withObject "SvgSelector" (\fields -> SvgSelector <$> (fields .: "type") <*> (fields .: "value") <*> traverse parseJSON (withoutFields ["type", "value"] fields))

instance ToJSON SvgSelector where toJSON value = Object (KM.fromList (concat [[("type", toJSON (svgSelectorType value))], [("value", toJSON (svgSelectorValue value))]]) <> fmap toJSON (withoutFields ["type", "value"] (svgSelectorAdditionalProperties value)))

data SvgSelectorType = SvgSelectorTypeSvgSelector deriving (Eq, Show)

instance FromJSON SvgSelectorType where parseJSON = checked "SvgSelectorType" $ \value -> if value == String "SvgSelector" then pure SvgSelectorTypeSvgSelector else fail "unknown enumeration member"

instance ToJSON SvgSelectorType where toJSON SvgSelectorTypeSvgSelector = String "SvgSelector"

svgSelectorTypeText :: SvgSelectorType -> Text
svgSelectorTypeText SvgSelectorTypeSvgSelector = "SvgSelector"
