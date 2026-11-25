-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowseResourceResult (BrowseResourceResult (..), BrowseResourceResultResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceDescriptor

data BrowseResourceResult = BrowseResourceResult
  { browseResourceResultResponse :: BrowseResourceResultResponse
  }
  deriving (Eq, Show)

instance FromJSON BrowseResourceResult where parseJSON = checked "BrowseResourceResult" $ withObject "BrowseResourceResult" (\fields -> BrowseResourceResult <$> (fields .: "response"))

instance ToJSON BrowseResourceResult where toJSON value = Object (KM.fromList (concat [[("response", toJSON (browseResourceResultResponse value))]]))

data BrowseResourceResultResponse = BrowseResourceResultResponse
  { browseResourceResultResponseLastSequence :: Integer,
    browseResourceResultResponseResource :: ResourceDescriptor
  }
  deriving (Eq, Show)

instance FromJSON BrowseResourceResultResponse where parseJSON = checked "BrowseResourceResultResponse" $ withObject "BrowseResourceResultResponse" (\fields -> BrowseResourceResultResponse <$> (fields .: "lastSequence") <*> (fields .: "resource"))

instance ToJSON BrowseResourceResultResponse where toJSON value = Object (KM.fromList (concat [[("lastSequence", toJSON (browseResourceResultResponseLastSequence value))], [("resource", toJSON (browseResourceResultResponseResource value))]]))
