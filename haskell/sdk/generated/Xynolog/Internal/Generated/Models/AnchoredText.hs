-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnchoredText (AnchoredText (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.PdfTextItem

data AnchoredText = AnchoredText
  { anchoredTextItems :: [PdfTextItem],
    anchoredTextText :: Text
  }
  deriving (Eq, Show)

instance FromJSON AnchoredText where parseJSON = checked "AnchoredText" $ withObject "AnchoredText" (\fields -> AnchoredText <$> (fields .: "items") <*> (fields .: "text"))

instance ToJSON AnchoredText where toJSON value = Object (KM.fromList (concat [[("items", toJSON (anchoredTextItems value))], [("text", toJSON (anchoredTextText value))]]))
