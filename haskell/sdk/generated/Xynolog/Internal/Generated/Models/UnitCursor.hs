-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.UnitCursor (UnitCursor (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec

data UnitCursor = UnitCursor
  { unitCursorNext :: Integer,
    unitCursorSize :: Integer,
    unitCursorFound :: Integer,
    unitCursorEmitted :: Integer,
    unitCursorErrors :: Integer
  }
  deriving (Eq, Show)

instance FromJSON UnitCursor where parseJSON = checked "UnitCursor" $ withObject "UnitCursor" (\fields -> UnitCursor <$> (fields .: "next") <*> (fields .: "size") <*> (fields .: "found") <*> (fields .: "emitted") <*> (fields .: "errors"))

instance ToJSON UnitCursor where toJSON value = Object (KM.fromList (concat [[("next", toJSON (unitCursorNext value))], [("size", toJSON (unitCursorSize value))], [("found", toJSON (unitCursorFound value))], [("emitted", toJSON (unitCursorEmitted value))], [("errors", toJSON (unitCursorErrors value))]]))
