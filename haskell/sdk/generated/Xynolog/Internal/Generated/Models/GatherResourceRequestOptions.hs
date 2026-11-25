-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatherResourceRequestOptions (GatherResourceRequestOptions (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data GatherResourceRequestOptions = GatherResourceRequestOptions
  { gatherResourceRequestOptionsDepth :: Integer,
    gatherResourceRequestOptionsExcludeEntityTypes :: Maybe [Text],
    gatherResourceRequestOptionsIncludeContent :: Bool,
    gatherResourceRequestOptionsIncludeSummary :: Bool,
    gatherResourceRequestOptionsMaxResources :: Integer
  }
  deriving (Eq, Show)

instance FromJSON GatherResourceRequestOptions where parseJSON = checked "GatherResourceRequestOptions" $ withObject "GatherResourceRequestOptions" (\fields -> GatherResourceRequestOptions <$> (fields .: "depth") <*> optional fields "excludeEntityTypes" <*> (fields .: "includeContent") <*> (fields .: "includeSummary") <*> (fields .: "maxResources"))

instance ToJSON GatherResourceRequestOptions where toJSON value = Object (KM.fromList (concat [[("depth", toJSON (gatherResourceRequestOptionsDepth value))], optionalPair "excludeEntityTypes" (gatherResourceRequestOptionsExcludeEntityTypes value), [("includeContent", toJSON (gatherResourceRequestOptionsIncludeContent value))], [("includeSummary", toJSON (gatherResourceRequestOptionsIncludeSummary value))], [("maxResources", toJSON (gatherResourceRequestOptionsMaxResources value))]]))
