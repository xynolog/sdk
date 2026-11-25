-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobMetadata (JobMetadata (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.JobType
import Xynolog.Internal.Generated.Models.UnitCursor
import Xynolog.Internal.Generated.Models.UserId

data JobMetadata = JobMetadata
  { jobMetadataId :: JobId,
    jobMetadataType :: JobType,
    jobMetadataUserId :: UserId,
    jobMetadataCreated :: Text,
    jobMetadataRetryCount :: Integer,
    jobMetadataMaxRetries :: Integer,
    jobMetadataCompletedUnits :: Maybe [Text],
    jobMetadataUnitCursors :: Maybe (KM.KeyMap UnitCursor)
  }
  deriving (Eq, Show)

instance FromJSON JobMetadata where parseJSON = checked "JobMetadata" $ withObject "JobMetadata" (\fields -> JobMetadata <$> (fields .: "id") <*> (fields .: "type") <*> (fields .: "userId") <*> (fields .: "created") <*> (fields .: "retryCount") <*> (fields .: "maxRetries") <*> optional fields "completedUnits" <*> optional fields "unitCursors")

instance ToJSON JobMetadata where toJSON value = Object (KM.fromList (concat [[("id", toJSON (jobMetadataId value))], [("type", toJSON (jobMetadataType value))], [("userId", toJSON (jobMetadataUserId value))], [("created", toJSON (jobMetadataCreated value))], [("retryCount", toJSON (jobMetadataRetryCount value))], [("maxRetries", toJSON (jobMetadataMaxRetries value))], optionalPair "completedUnits" (jobMetadataCompletedUnits value), optionalPair "unitCursors" (jobMetadataUnitCursors value)]))
