-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatherAnnotationOptions (GatherAnnotationOptions (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject)
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec

data GatherAnnotationOptions = GatherAnnotationOptions
  { gatherAnnotationOptionsIncludeSourceContext :: Maybe Bool,
    gatherAnnotationOptionsIncludeTargetContext :: Maybe Bool,
    gatherAnnotationOptionsContextWindow :: Maybe Integer
  }
  deriving (Eq, Show)

instance FromJSON GatherAnnotationOptions where parseJSON = checked "GatherAnnotationOptions" $ withObject "GatherAnnotationOptions" (\fields -> GatherAnnotationOptions <$> optional fields "includeSourceContext" <*> optional fields "includeTargetContext" <*> optional fields "contextWindow")

instance ToJSON GatherAnnotationOptions where toJSON value = Object (KM.fromList (concat [optionalPair "includeSourceContext" (gatherAnnotationOptionsIncludeSourceContext value), optionalPair "includeTargetContext" (gatherAnnotationOptionsIncludeTargetContext value), optionalPair "contextWindow" (gatherAnnotationOptionsContextWindow value)]))
