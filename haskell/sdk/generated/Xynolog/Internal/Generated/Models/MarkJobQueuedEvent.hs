-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkJobQueuedEvent (MarkJobQueuedEvent (..), MarkJobQueuedEventJobType (..), markJobQueuedEventJobTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.MarkJobParams
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data MarkJobQueuedEvent = MarkJobQueuedEvent
  { markJobQueuedEventJobId :: JobId,
    markJobQueuedEventJobType :: MarkJobQueuedEventJobType,
    markJobQueuedEventResourceId :: ResourceId,
    markJobQueuedEventUserId :: UserId,
    markJobQueuedEventParams :: MarkJobParams
  }
  deriving (Eq, Show)

instance FromJSON MarkJobQueuedEvent where parseJSON = checked "MarkJobQueuedEvent" $ withObject "MarkJobQueuedEvent" (\fields -> MarkJobQueuedEvent <$> (fields .: "jobId") <*> (fields .: "jobType") <*> (fields .: "resourceId") <*> (fields .: "userId") <*> (fields .: "params"))

instance ToJSON MarkJobQueuedEvent where toJSON value = Object (KM.fromList (concat [[("jobId", toJSON (markJobQueuedEventJobId value))], [("jobType", toJSON (markJobQueuedEventJobType value))], [("resourceId", toJSON (markJobQueuedEventResourceId value))], [("userId", toJSON (markJobQueuedEventUserId value))], [("params", toJSON (markJobQueuedEventParams value))]]))

data MarkJobQueuedEventJobType = MarkJobQueuedEventJobTypeMark deriving (Eq, Show)

instance FromJSON MarkJobQueuedEventJobType where parseJSON = checked "MarkJobQueuedEventJobType" $ \value -> if value == String "mark" then pure MarkJobQueuedEventJobTypeMark else fail "unknown enumeration member"

instance ToJSON MarkJobQueuedEventJobType where toJSON MarkJobQueuedEventJobTypeMark = String "mark"

markJobQueuedEventJobTypeText :: MarkJobQueuedEventJobType -> Text
markJobQueuedEventJobTypeText MarkJobQueuedEventJobTypeMark = "mark"
