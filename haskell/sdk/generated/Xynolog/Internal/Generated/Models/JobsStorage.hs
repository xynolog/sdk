-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobsStorage (JobsStorage (..), JobsStorageBucket (..), JobsStorageConsumer (..), JobsStorageStream (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data JobsStorage = JobsStorage
  { jobsStorageBucket :: JobsStorageBucket,
    jobsStorageConsumer :: JobsStorageConsumer,
    jobsStorageStream :: JobsStorageStream
  }
  deriving (Eq, Show)

instance FromJSON JobsStorage where parseJSON = checked "JobsStorage" $ withObject "JobsStorage" (\fields -> JobsStorage <$> (fields .: "bucket") <*> (fields .: "consumer") <*> (fields .: "stream"))

instance ToJSON JobsStorage where toJSON value = Object (KM.fromList (concat [[("bucket", toJSON (jobsStorageBucket value))], [("consumer", toJSON (jobsStorageConsumer value))], [("stream", toJSON (jobsStorageStream value))]]))

data JobsStorageBucket = JobsStorageBucket
  { jobsStorageBucketName :: Text,
    jobsStorageBucketRecord :: Text
  }
  deriving (Eq, Show)

instance FromJSON JobsStorageBucket where parseJSON = checked "JobsStorageBucket" $ withObject "JobsStorageBucket" (\fields -> JobsStorageBucket <$> (fields .: "name") <*> (fields .: "record"))

instance ToJSON JobsStorageBucket where toJSON value = Object (KM.fromList (concat [[("name", toJSON (jobsStorageBucketName value))], [("record", toJSON (jobsStorageBucketRecord value))]]))

data JobsStorageConsumer = JobsStorageConsumer
  { jobsStorageConsumerDurableName :: Text
  }
  deriving (Eq, Show)

instance FromJSON JobsStorageConsumer where parseJSON = checked "JobsStorageConsumer" $ withObject "JobsStorageConsumer" (\fields -> JobsStorageConsumer <$> (fields .: "durableName"))

instance ToJSON JobsStorageConsumer where toJSON value = Object (KM.fromList (concat [[("durableName", toJSON (jobsStorageConsumerDurableName value))]]))

data JobsStorageStream = JobsStorageStream
  { jobsStorageStreamName :: Text,
    jobsStorageStreamSubjectRoot :: Text
  }
  deriving (Eq, Show)

instance FromJSON JobsStorageStream where parseJSON = checked "JobsStorageStream" $ withObject "JobsStorageStream" (\fields -> JobsStorageStream <$> (fields .: "name") <*> (fields .: "subjectRoot"))

instance ToJSON JobsStorageStream where toJSON value = Object (KM.fromList (concat [[("name", toJSON (jobsStorageStreamName value))], [("subjectRoot", toJSON (jobsStorageStreamSubjectRoot value))]]))
