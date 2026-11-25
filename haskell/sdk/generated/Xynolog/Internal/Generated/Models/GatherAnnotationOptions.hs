-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatherAnnotationOptions (GatherAnnotationOptions (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject)
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec

data GatherAnnotationOptions = GatherAnnotationOptions
  { gatherAnnotationOptionsContextWindow :: Maybe Integer,
    gatherAnnotationOptionsIncludeSourceContext :: Maybe Bool,
    gatherAnnotationOptionsIncludeTargetContext :: Maybe Bool
  }
  deriving (Eq, Show)

instance FromJSON GatherAnnotationOptions where parseJSON = checked "GatherAnnotationOptions" $ withObject "GatherAnnotationOptions" (\fields -> GatherAnnotationOptions <$> optional fields "contextWindow" <*> optional fields "includeSourceContext" <*> optional fields "includeTargetContext")

instance ToJSON GatherAnnotationOptions where toJSON value = Object (KM.fromList (concat [optionalPair "contextWindow" (gatherAnnotationOptionsContextWindow value), optionalPair "includeSourceContext" (gatherAnnotationOptionsIncludeSourceContext value), optionalPair "includeTargetContext" (gatherAnnotationOptionsIncludeTargetContext value)]))
