-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.TextPositionSelector (TextPositionSelector (..), TextPositionSelectorType (..), textPositionSelectorTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data TextPositionSelector = TextPositionSelector
  { textPositionSelectorEnd :: Integer,
    textPositionSelectorStart :: Integer,
    textPositionSelectorType :: TextPositionSelectorType,
    textPositionSelectorAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON TextPositionSelector where parseJSON = checked "TextPositionSelector" $ withObject "TextPositionSelector" (\fields -> TextPositionSelector <$> (fields .: "end") <*> (fields .: "start") <*> (fields .: "type") <*> traverse parseJSON (withoutFields ["end", "start", "type"] fields))

instance ToJSON TextPositionSelector where toJSON value = Object (KM.fromList (concat [[("end", toJSON (textPositionSelectorEnd value))], [("start", toJSON (textPositionSelectorStart value))], [("type", toJSON (textPositionSelectorType value))]]) <> fmap toJSON (withoutFields ["end", "start", "type"] (textPositionSelectorAdditionalProperties value)))

data TextPositionSelectorType = TextPositionSelectorTypeTextPositionSelector deriving (Eq, Show)

instance FromJSON TextPositionSelectorType where parseJSON = checked "TextPositionSelectorType" $ \value -> if value == String "TextPositionSelector" then pure TextPositionSelectorTypeTextPositionSelector else fail "unknown enumeration member"

instance ToJSON TextPositionSelectorType where toJSON TextPositionSelectorTypeTextPositionSelector = String "TextPositionSelector"

textPositionSelectorTypeText :: TextPositionSelectorType -> Text
textPositionSelectorTypeText TextPositionSelectorTypeTextPositionSelector = "TextPositionSelector"
