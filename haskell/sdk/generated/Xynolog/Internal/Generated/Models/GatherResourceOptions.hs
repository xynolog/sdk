-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatherResourceOptions (GatherResourceOptions (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject)
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data GatherResourceOptions = GatherResourceOptions
  { gatherResourceOptionsDepth :: Maybe Integer,
    gatherResourceOptionsMaxResources :: Maybe Integer,
    gatherResourceOptionsIncludeContent :: Maybe Bool,
    gatherResourceOptionsIncludeSummary :: Maybe Bool,
    gatherResourceOptionsExcludeEntityTypes :: Maybe [Text]
  }
  deriving (Eq, Show)

instance FromJSON GatherResourceOptions where parseJSON = checked "GatherResourceOptions" $ withObject "GatherResourceOptions" (\fields -> GatherResourceOptions <$> optional fields "depth" <*> optional fields "maxResources" <*> optional fields "includeContent" <*> optional fields "includeSummary" <*> optional fields "excludeEntityTypes")

instance ToJSON GatherResourceOptions where toJSON value = Object (KM.fromList (concat [optionalPair "depth" (gatherResourceOptionsDepth value), optionalPair "maxResources" (gatherResourceOptionsMaxResources value), optionalPair "includeContent" (gatherResourceOptionsIncludeContent value), optionalPair "includeSummary" (gatherResourceOptionsIncludeSummary value), optionalPair "excludeEntityTypes" (gatherResourceOptionsExcludeEntityTypes value)]))
