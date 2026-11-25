-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnchorRect (AnchorRect (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Xynolog.Internal.Codec

data AnchorRect = AnchorRect
  { anchorRectX :: Scientific,
    anchorRectY :: Scientific,
    anchorRectWidth :: Scientific,
    anchorRectHeight :: Scientific,
    anchorRectTop :: Scientific,
    anchorRectRight :: Scientific,
    anchorRectBottom :: Scientific,
    anchorRectLeft :: Scientific
  }
  deriving (Eq, Show)

instance FromJSON AnchorRect where parseJSON = checked "AnchorRect" $ withObject "AnchorRect" (\fields -> AnchorRect <$> (fields .: "x") <*> (fields .: "y") <*> (fields .: "width") <*> (fields .: "height") <*> (fields .: "top") <*> (fields .: "right") <*> (fields .: "bottom") <*> (fields .: "left"))

instance ToJSON AnchorRect where toJSON value = Object (KM.fromList (concat [[("x", toJSON (anchorRectX value))], [("y", toJSON (anchorRectY value))], [("width", toJSON (anchorRectWidth value))], [("height", toJSON (anchorRectHeight value))], [("top", toJSON (anchorRectTop value))], [("right", toJSON (anchorRectRight value))], [("bottom", toJSON (anchorRectBottom value))], [("left", toJSON (anchorRectLeft value))]]))
