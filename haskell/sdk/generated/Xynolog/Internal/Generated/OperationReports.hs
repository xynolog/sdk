-- Generated from protocol/specs/src/client/types/JobEvent.json and protocol/specs/src/client/types/UploadProgress.json; do not edit.
-- Regenerate: make generate (codegen/lib/client_types/haskell.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.OperationReports (JobEvent (..), UploadEvent (..)) where

import Data.Aeson (ToJSON (..), object, (.=))
import Data.Text (Text)
import Xynolog.Internal.Transport (FrameRefusal (..))
import Xynolog.Types (JobCreatedResultResponse, JobFailCommand, JobProgress, ResourceId)

data JobEvent completion = Created JobCreatedResultResponse | Progress JobProgress | Failed JobFailCommand | Refused FrameRefusal | Complete completion deriving (Eq, Show)

instance (ToJSON completion) => ToJSON (JobEvent completion) where
  toJSON (Created value0) = object ["kind" .= ("created" :: Text), "data" .= value0]
  toJSON (Progress value0) = object ["kind" .= ("progress" :: Text), "data" .= value0]
  toJSON (Failed value0) = object ["kind" .= ("failed" :: Text), "data" .= value0]
  toJSON (Refused value0) = object ["kind" .= ("refused" :: Text), "data" .= object ["channel" .= frameRefusalChannel value0, "member" .= frameRefusalMember value0, "reason" .= frameRefusalReason value0]]
  toJSON (Complete value0) = object ["kind" .= ("complete" :: Text), "data" .= value0]

data UploadEvent = UploadStarted (Maybe Integer) | UploadProgress Integer (Maybe Integer) | UploadFinished ResourceId deriving (Eq, Show)

instance ToJSON UploadEvent where
  toJSON (UploadStarted value0) = object (["phase" .= ("started" :: Text)] ++ maybe [] (\stated -> ["totalBytes" .= stated]) value0)
  toJSON (UploadProgress value0 value1) = object (["phase" .= ("progress" :: Text), "bytesUploaded" .= value0] ++ maybe [] (\stated -> ["totalBytes" .= stated]) value1)
  toJSON (UploadFinished value0) = object ["phase" .= ("finished" :: Text), "resourceId" .= value0]
