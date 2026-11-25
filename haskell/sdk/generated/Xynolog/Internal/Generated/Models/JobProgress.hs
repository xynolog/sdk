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
  { jobProgressPercentage :: Scientific,
    jobProgressMessage :: Maybe JobProgressMessage,
    jobProgressAnnotationId :: Maybe AnnotationId,
    jobProgressCurrent :: Maybe JobProgressCurrent,
    jobProgressProcessed :: Maybe Integer,
    jobProgressTotal :: Maybe Integer,
    jobProgressEntitiesFound :: Maybe Integer,
    jobProgressEntitiesExpected :: Maybe Integer,
    jobProgressEntitiesEmitted :: Maybe Integer,
    jobProgressCompletedItems :: Maybe [JobProgressCompletedItemsItem],
    jobProgressRequestParams :: Maybe [JobProgressRequestParamsItem]
  }
  deriving (Eq, Show)

instance FromJSON JobProgress where parseJSON = checked "JobProgress" $ withObject "JobProgress" (\fields -> JobProgress <$> (fields .: "percentage") <*> optional fields "message" <*> optional fields "annotationId" <*> optional fields "current" <*> optional fields "processed" <*> optional fields "total" <*> optional fields "entitiesFound" <*> optional fields "entitiesExpected" <*> optional fields "entitiesEmitted" <*> optional fields "completedItems" <*> optional fields "requestParams")

instance ToJSON JobProgress where toJSON value = Object (KM.fromList (concat [[("percentage", toJSON (jobProgressPercentage value))], optionalPair "message" (jobProgressMessage value), optionalPair "annotationId" (jobProgressAnnotationId value), optionalPair "current" (jobProgressCurrent value), optionalPair "processed" (jobProgressProcessed value), optionalPair "total" (jobProgressTotal value), optionalPair "entitiesFound" (jobProgressEntitiesFound value), optionalPair "entitiesExpected" (jobProgressEntitiesExpected value), optionalPair "entitiesEmitted" (jobProgressEntitiesEmitted value), optionalPair "completedItems" (jobProgressCompletedItems value), optionalPair "requestParams" (jobProgressRequestParams value)]))

data JobProgressCompletedItemsItem = JobProgressCompletedItemsItem
  { jobProgressCompletedItemsItemValue :: Text,
    jobProgressCompletedItemsItemFoundCount :: Integer,
    jobProgressCompletedItemsItemPersistedCount :: Maybe Integer,
    jobProgressCompletedItemsItemUnderReported :: Maybe JobProgressCompletedItemsItemUnderReported
  }
  deriving (Eq, Show)

instance FromJSON JobProgressCompletedItemsItem where parseJSON = checked "JobProgressCompletedItemsItem" $ withObject "JobProgressCompletedItemsItem" (\fields -> JobProgressCompletedItemsItem <$> (fields .: "value") <*> (fields .: "foundCount") <*> optional fields "persistedCount" <*> optional fields "underReported")

instance ToJSON JobProgressCompletedItemsItem where toJSON value = Object (KM.fromList (concat [[("value", toJSON (jobProgressCompletedItemsItemValue value))], [("foundCount", toJSON (jobProgressCompletedItemsItemFoundCount value))], optionalPair "persistedCount" (jobProgressCompletedItemsItemPersistedCount value), optionalPair "underReported" (jobProgressCompletedItemsItemUnderReported value)]))

data JobProgressCompletedItemsItemUnderReported = JobProgressCompletedItemsItemUnderReported
  { jobProgressCompletedItemsItemUnderReportedPieces :: Integer,
    jobProgressCompletedItemsItemUnderReportedFound :: Integer,
    jobProgressCompletedItemsItemUnderReportedCounted :: Integer
  }
  deriving (Eq, Show)

instance FromJSON JobProgressCompletedItemsItemUnderReported where parseJSON = checked "JobProgressCompletedItemsItemUnderReported" $ withObject "JobProgressCompletedItemsItemUnderReported" (\fields -> JobProgressCompletedItemsItemUnderReported <$> (fields .: "pieces") <*> (fields .: "found") <*> (fields .: "counted"))

instance ToJSON JobProgressCompletedItemsItemUnderReported where toJSON value = Object (KM.fromList (concat [[("pieces", toJSON (jobProgressCompletedItemsItemUnderReportedPieces value))], [("found", toJSON (jobProgressCompletedItemsItemUnderReportedFound value))], [("counted", toJSON (jobProgressCompletedItemsItemUnderReportedCounted value))]]))

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
