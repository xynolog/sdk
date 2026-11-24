-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.RootsInitResult (RootsInitResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data RootsInitResult = RootsInitResult
  { rootsInitResultPath :: Text
  }
  deriving (Eq, Show)

instance FromJSON RootsInitResult where parseJSON = checked "RootsInitResult" $ withObject "RootsInitResult" (\fields -> RootsInitResult <$> (fields .: "path"))

instance ToJSON RootsInitResult where toJSON value = Object (KM.fromList (concat [[("path", toJSON (rootsInitResultPath value))]]))
