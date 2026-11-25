-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GetReferencedByResponse (GetReferencedByResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.GetReferencedByResponseReferencedByItem

data GetReferencedByResponse = GetReferencedByResponse
  { getReferencedByResponseReferencedBy :: [GetReferencedByResponseReferencedByItem]
  }
  deriving (Eq, Show)

instance FromJSON GetReferencedByResponse where parseJSON = checked "GetReferencedByResponse" $ withObject "GetReferencedByResponse" (\fields -> GetReferencedByResponse <$> (fields .: "referencedBy"))

instance ToJSON GetReferencedByResponse where toJSON value = Object (KM.fromList (concat [[("referencedBy", toJSON (getReferencedByResponseReferencedBy value))]]))
