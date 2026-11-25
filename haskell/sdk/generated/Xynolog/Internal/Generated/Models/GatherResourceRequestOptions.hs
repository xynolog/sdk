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
    gatherResourceRequestOptionsMaxResources :: Integer,
    gatherResourceRequestOptionsIncludeContent :: Bool,
    gatherResourceRequestOptionsIncludeSummary :: Bool,
    gatherResourceRequestOptionsExcludeEntityTypes :: Maybe [Text]
  }
  deriving (Eq, Show)

instance FromJSON GatherResourceRequestOptions where parseJSON = checked "GatherResourceRequestOptions" $ withObject "GatherResourceRequestOptions" (\fields -> GatherResourceRequestOptions <$> (fields .: "depth") <*> (fields .: "maxResources") <*> (fields .: "includeContent") <*> (fields .: "includeSummary") <*> optional fields "excludeEntityTypes")

instance ToJSON GatherResourceRequestOptions where toJSON value = Object (KM.fromList (concat [[("depth", toJSON (gatherResourceRequestOptionsDepth value))], [("maxResources", toJSON (gatherResourceRequestOptionsMaxResources value))], [("includeContent", toJSON (gatherResourceRequestOptionsIncludeContent value))], [("includeSummary", toJSON (gatherResourceRequestOptionsIncludeSummary value))], optionalPair "excludeEntityTypes" (gatherResourceRequestOptionsExcludeEntityTypes value)]))
