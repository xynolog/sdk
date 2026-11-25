-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseKbResult (BrowseKbResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.KbDescription

data BrowseKbResult = BrowseKbResult
  { browseKbResultResponse :: KbDescription
  }
  deriving (Eq, Show)

instance FromJSON BrowseKbResult where parseJSON = checked "BrowseKbResult" $ withObject "BrowseKbResult" (\fields -> BrowseKbResult <$> (fields .: "response"))

instance ToJSON BrowseKbResult where toJSON value = Object (KM.fromList (concat [[("response", toJSON (browseKbResultResponse value))]]))
