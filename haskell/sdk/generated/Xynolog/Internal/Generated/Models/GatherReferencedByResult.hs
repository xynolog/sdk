-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatherReferencedByResult (GatherReferencedByResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.GetReferencedByResponse

data GatherReferencedByResult = GatherReferencedByResult
  { gatherReferencedByResultResponse :: GetReferencedByResponse
  }
  deriving (Eq, Show)

instance FromJSON GatherReferencedByResult where parseJSON = checked "GatherReferencedByResult" $ withObject "GatherReferencedByResult" (\fields -> GatherReferencedByResult <$> (fields .: "response"))

instance ToJSON GatherReferencedByResult where toJSON value = Object (KM.fromList (concat [[("response", toJSON (gatherReferencedByResultResponse value))]]))
