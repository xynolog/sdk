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
  { anchoredTextText :: Text,
    anchoredTextItems :: [PdfTextItem]
  }
  deriving (Eq, Show)

instance FromJSON AnchoredText where parseJSON = checked "AnchoredText" $ withObject "AnchoredText" (\fields -> AnchoredText <$> (fields .: "text") <*> (fields .: "items"))

instance ToJSON AnchoredText where toJSON value = Object (KM.fromList (concat [[("text", toJSON (anchoredTextText value))], [("items", toJSON (anchoredTextItems value))]]))
