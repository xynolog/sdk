-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatherAnnotationComplete (GatherAnnotationComplete (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.GatheredContext

data GatherAnnotationComplete = GatherAnnotationComplete
  { gatherAnnotationCompleteAnnotationId :: AnnotationId,
    gatherAnnotationCompleteResponse :: GatheredContext
  }
  deriving (Eq, Show)

instance FromJSON GatherAnnotationComplete where parseJSON = checked "GatherAnnotationComplete" $ withObject "GatherAnnotationComplete" (\fields -> GatherAnnotationComplete <$> (fields .: "annotationId") <*> (fields .: "response"))

instance ToJSON GatherAnnotationComplete where toJSON value = Object (KM.fromList (concat [[("annotationId", toJSON (gatherAnnotationCompleteAnnotationId value))], [("response", toJSON (gatherAnnotationCompleteResponse value))]]))
