-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SmelterReconcileSummary (SmelterReconcileSummary (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec

data SmelterReconcileSummary = SmelterReconcileSummary
  { smelterReconcileSummaryResourcesEmbedded :: Integer,
    smelterReconcileSummaryResourcesSkipped :: KM.KeyMap Integer,
    smelterReconcileSummaryResourcesUnavailable :: Integer,
    smelterReconcileSummaryResourcesFailed :: Integer,
    smelterReconcileSummaryResourcesRestamped :: Integer,
    smelterReconcileSummaryResourcesReanchored :: Integer,
    smelterReconcileSummaryResourceVectorsDeleted :: Integer,
    smelterReconcileSummaryAnnotationsEmbedded :: Integer,
    smelterReconcileSummaryAnnotationsRestamped :: Integer,
    smelterReconcileSummaryAnnotationVectorsDeleted :: Integer,
    smelterReconcileSummaryResourcesEligible :: Integer,
    smelterReconcileSummaryResourcesIndexed :: Integer
  }
  deriving (Eq, Show)

instance FromJSON SmelterReconcileSummary where parseJSON = checked "SmelterReconcileSummary" $ withObject "SmelterReconcileSummary" (\fields -> SmelterReconcileSummary <$> (fields .: "resourcesEmbedded") <*> (fields .: "resourcesSkipped") <*> (fields .: "resourcesUnavailable") <*> (fields .: "resourcesFailed") <*> (fields .: "resourcesRestamped") <*> (fields .: "resourcesReanchored") <*> (fields .: "resourceVectorsDeleted") <*> (fields .: "annotationsEmbedded") <*> (fields .: "annotationsRestamped") <*> (fields .: "annotationVectorsDeleted") <*> (fields .: "resourcesEligible") <*> (fields .: "resourcesIndexed"))

instance ToJSON SmelterReconcileSummary where toJSON value = Object (KM.fromList (concat [[("resourcesEmbedded", toJSON (smelterReconcileSummaryResourcesEmbedded value))], [("resourcesSkipped", toJSON (smelterReconcileSummaryResourcesSkipped value))], [("resourcesUnavailable", toJSON (smelterReconcileSummaryResourcesUnavailable value))], [("resourcesFailed", toJSON (smelterReconcileSummaryResourcesFailed value))], [("resourcesRestamped", toJSON (smelterReconcileSummaryResourcesRestamped value))], [("resourcesReanchored", toJSON (smelterReconcileSummaryResourcesReanchored value))], [("resourceVectorsDeleted", toJSON (smelterReconcileSummaryResourceVectorsDeleted value))], [("annotationsEmbedded", toJSON (smelterReconcileSummaryAnnotationsEmbedded value))], [("annotationsRestamped", toJSON (smelterReconcileSummaryAnnotationsRestamped value))], [("annotationVectorsDeleted", toJSON (smelterReconcileSummaryAnnotationVectorsDeleted value))], [("resourcesEligible", toJSON (smelterReconcileSummaryResourcesEligible value))], [("resourcesIndexed", toJSON (smelterReconcileSummaryResourcesIndexed value))]]))
