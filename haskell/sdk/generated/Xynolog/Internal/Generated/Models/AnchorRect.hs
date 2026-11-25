-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnchorRect (AnchorRect (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Xynolog.Internal.Codec

data AnchorRect = AnchorRect
  { anchorRectBottom :: Scientific,
    anchorRectHeight :: Scientific,
    anchorRectLeft :: Scientific,
    anchorRectRight :: Scientific,
    anchorRectTop :: Scientific,
    anchorRectWidth :: Scientific,
    anchorRectX :: Scientific,
    anchorRectY :: Scientific
  }
  deriving (Eq, Show)

instance FromJSON AnchorRect where parseJSON = checked "AnchorRect" $ withObject "AnchorRect" (\fields -> AnchorRect <$> (fields .: "bottom") <*> (fields .: "height") <*> (fields .: "left") <*> (fields .: "right") <*> (fields .: "top") <*> (fields .: "width") <*> (fields .: "x") <*> (fields .: "y"))

instance ToJSON AnchorRect where toJSON value = Object (KM.fromList (concat [[("bottom", toJSON (anchorRectBottom value))], [("height", toJSON (anchorRectHeight value))], [("left", toJSON (anchorRectLeft value))], [("right", toJSON (anchorRectRight value))], [("top", toJSON (anchorRectTop value))], [("width", toJSON (anchorRectWidth value))], [("x", toJSON (anchorRectX value))], [("y", toJSON (anchorRectY value))]]))
