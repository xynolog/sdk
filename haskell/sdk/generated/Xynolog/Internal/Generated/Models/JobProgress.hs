-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobProgress (JobProgress (..), JobProgressCompletedItemsItem (..), JobProgressCompletedItemsItemUnderReported (..), JobProgressCurrent (..), JobProgressCurrentKind (..), jobProgressCurrentKindText, JobProgressRequestParamsItem (..), JobProgressRequestParamsItemLabel (..), jobProgressRequestParamsItemLabelText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.JobProgressMessage

data JobProgress = JobProgress
  { jobProgressAnnotationId :: Maybe AnnotationId,
    jobProgressCompletedItems :: Maybe [JobProgressCompletedItemsItem],
    jobProgressCurrent :: Maybe JobProgressCurrent,
    jobProgressEntitiesEmitted :: Maybe Integer,
    jobProgressEntitiesExpected :: Maybe Integer,
    jobProgressEntitiesFound :: Maybe Integer,
    jobProgressMessage :: Maybe JobProgressMessage,
    jobProgressPercentage :: Scientific,
    jobProgressProcessed :: Maybe Integer,
    jobProgressRequestParams :: Maybe [JobProgressRequestParamsItem],
    jobProgressTotal :: Maybe Integer
  }
  deriving (Eq, Show)

instance FromJSON JobProgress where parseJSON = checked "JobProgress" $ withObject "JobProgress" (\fields -> JobProgress <$> optional fields "annotationId" <*> optional fields "completedItems" <*> optional fields "current" <*> optional fields "entitiesEmitted" <*> optional fields "entitiesExpected" <*> optional fields "entitiesFound" <*> optional fields "message" <*> (fields .: "percentage") <*> optional fields "processed" <*> optional fields "requestParams" <*> optional fields "total")

instance ToJSON JobProgress where toJSON value = Object (KM.fromList (concat [optionalPair "annotationId" (jobProgressAnnotationId value), optionalPair "completedItems" (jobProgressCompletedItems value), optionalPair "current" (jobProgressCurrent value), optionalPair "entitiesEmitted" (jobProgressEntitiesEmitted value), optionalPair "entitiesExpected" (jobProgressEntitiesExpected value), optionalPair "entitiesFound" (jobProgressEntitiesFound value), optionalPair "message" (jobProgressMessage value), [("percentage", toJSON (jobProgressPercentage value))], optionalPair "processed" (jobProgressProcessed value), optionalPair "requestParams" (jobProgressRequestParams value), optionalPair "total" (jobProgressTotal value)]))

data JobProgressCompletedItemsItem = JobProgressCompletedItemsItem
  { jobProgressCompletedItemsItemFoundCount :: Integer,
    jobProgressCompletedItemsItemPersistedCount :: Maybe Integer,
    jobProgressCompletedItemsItemUnderReported :: Maybe JobProgressCompletedItemsItemUnderReported,
    jobProgressCompletedItemsItemValue :: Text
  }
  deriving (Eq, Show)

instance FromJSON JobProgressCompletedItemsItem where parseJSON = checked "JobProgressCompletedItemsItem" $ withObject "JobProgressCompletedItemsItem" (\fields -> JobProgressCompletedItemsItem <$> (fields .: "foundCount") <*> optional fields "persistedCount" <*> optional fields "underReported" <*> (fields .: "value"))

instance ToJSON JobProgressCompletedItemsItem where toJSON value = Object (KM.fromList (concat [[("foundCount", toJSON (jobProgressCompletedItemsItemFoundCount value))], optionalPair "persistedCount" (jobProgressCompletedItemsItemPersistedCount value), optionalPair "underReported" (jobProgressCompletedItemsItemUnderReported value), [("value", toJSON (jobProgressCompletedItemsItemValue value))]]))

data JobProgressCompletedItemsItemUnderReported = JobProgressCompletedItemsItemUnderReported
  { jobProgressCompletedItemsItemUnderReportedCounted :: Integer,
    jobProgressCompletedItemsItemUnderReportedFound :: Integer,
    jobProgressCompletedItemsItemUnderReportedPieces :: Integer
  }
  deriving (Eq, Show)

instance FromJSON JobProgressCompletedItemsItemUnderReported where parseJSON = checked "JobProgressCompletedItemsItemUnderReported" $ withObject "JobProgressCompletedItemsItemUnderReported" (\fields -> JobProgressCompletedItemsItemUnderReported <$> (fields .: "counted") <*> (fields .: "found") <*> (fields .: "pieces"))

instance ToJSON JobProgressCompletedItemsItemUnderReported where toJSON value = Object (KM.fromList (concat [[("counted", toJSON (jobProgressCompletedItemsItemUnderReportedCounted value))], [("found", toJSON (jobProgressCompletedItemsItemUnderReportedFound value))], [("pieces", toJSON (jobProgressCompletedItemsItemUnderReportedPieces value))]]))

data JobProgressCurrent = JobProgressCurrent
  { jobProgressCurrentKind :: JobProgressCurrentKind,
    jobProgressCurrentValue :: Text
  }
  deriving (Eq, Show)

instance FromJSON JobProgressCurrent where parseJSON = checked "JobProgressCurrent" $ withObject "JobProgressCurrent" (\fields -> JobProgressCurrent <$> (fields .: "kind") <*> (fields .: "value"))

instance ToJSON JobProgressCurrent where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (jobProgressCurrentKind value))], [("value", toJSON (jobProgressCurrentValue value))]]))

data JobProgressCurrentKind = JobProgressCurrentKindEntityType | JobProgressCurrentKindCategory deriving (Eq, Show)

instance FromJSON JobProgressCurrentKind where parseJSON = checked "JobProgressCurrentKind" $ \value -> if value == String "entity-type" then pure JobProgressCurrentKindEntityType else if value == String "category" then pure JobProgressCurrentKindCategory else fail "unknown enumeration member"

instance ToJSON JobProgressCurrentKind where
  toJSON JobProgressCurrentKindEntityType = String "entity-type"
  toJSON JobProgressCurrentKindCategory = String "category"

jobProgressCurrentKindText :: JobProgressCurrentKind -> Text
jobProgressCurrentKindText JobProgressCurrentKindEntityType = "entity-type"
jobProgressCurrentKindText JobProgressCurrentKindCategory = "category"

data JobProgressRequestParamsItem = JobProgressRequestParamsItem
  { jobProgressRequestParamsItemLabel :: JobProgressRequestParamsItemLabel,
    jobProgressRequestParamsItemValue :: Text
  }
  deriving (Eq, Show)

instance FromJSON JobProgressRequestParamsItem where parseJSON = checked "JobProgressRequestParamsItem" $ withObject "JobProgressRequestParamsItem" (\fields -> JobProgressRequestParamsItem <$> (fields .: "label") <*> (fields .: "value"))

instance ToJSON JobProgressRequestParamsItem where toJSON value = Object (KM.fromList (concat [[("label", toJSON (jobProgressRequestParamsItemLabel value))], [("value", toJSON (jobProgressRequestParamsItemValue value))]]))

data JobProgressRequestParamsItemLabel = JobProgressRequestParamsItemLabelEntityTypes | JobProgressRequestParamsItemLabelInstructions | JobProgressRequestParamsItemLabelTone | JobProgressRequestParamsItemLabelDensity deriving (Eq, Show)

instance FromJSON JobProgressRequestParamsItemLabel where parseJSON = checked "JobProgressRequestParamsItemLabel" $ \value -> if value == String "entity-types" then pure JobProgressRequestParamsItemLabelEntityTypes else if value == String "instructions" then pure JobProgressRequestParamsItemLabelInstructions else if value == String "tone" then pure JobProgressRequestParamsItemLabelTone else if value == String "density" then pure JobProgressRequestParamsItemLabelDensity else fail "unknown enumeration member"

instance ToJSON JobProgressRequestParamsItemLabel where
  toJSON JobProgressRequestParamsItemLabelEntityTypes = String "entity-types"
  toJSON JobProgressRequestParamsItemLabelInstructions = String "instructions"
  toJSON JobProgressRequestParamsItemLabelTone = String "tone"
  toJSON JobProgressRequestParamsItemLabelDensity = String "density"

jobProgressRequestParamsItemLabelText :: JobProgressRequestParamsItemLabel -> Text
jobProgressRequestParamsItemLabelText JobProgressRequestParamsItemLabelEntityTypes = "entity-types"
jobProgressRequestParamsItemLabelText JobProgressRequestParamsItemLabelInstructions = "instructions"
jobProgressRequestParamsItemLabelText JobProgressRequestParamsItemLabelTone = "tone"
jobProgressRequestParamsItemLabelText JobProgressRequestParamsItemLabelDensity = "density"
