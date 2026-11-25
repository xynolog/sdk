-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.YieldJobQueuedEvent (YieldJobQueuedEvent (..), YieldJobQueuedEventJobType (..), yieldJobQueuedEventJobTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.GenerationJobRequest
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data YieldJobQueuedEvent = YieldJobQueuedEvent
  { yieldJobQueuedEventJobId :: JobId,
    yieldJobQueuedEventJobType :: YieldJobQueuedEventJobType,
    yieldJobQueuedEventResourceId :: ResourceId,
    yieldJobQueuedEventUserId :: UserId,
    yieldJobQueuedEventParams :: GenerationJobRequest
  }
  deriving (Eq, Show)

instance FromJSON YieldJobQueuedEvent where parseJSON = checked "YieldJobQueuedEvent" $ withObject "YieldJobQueuedEvent" (\fields -> YieldJobQueuedEvent <$> (fields .: "jobId") <*> (fields .: "jobType") <*> (fields .: "resourceId") <*> (fields .: "userId") <*> (fields .: "params"))

instance ToJSON YieldJobQueuedEvent where toJSON value = Object (KM.fromList (concat [[("jobId", toJSON (yieldJobQueuedEventJobId value))], [("jobType", toJSON (yieldJobQueuedEventJobType value))], [("resourceId", toJSON (yieldJobQueuedEventResourceId value))], [("userId", toJSON (yieldJobQueuedEventUserId value))], [("params", toJSON (yieldJobQueuedEventParams value))]]))

data YieldJobQueuedEventJobType = YieldJobQueuedEventJobTypeYield deriving (Eq, Show)

instance FromJSON YieldJobQueuedEventJobType where parseJSON = checked "YieldJobQueuedEventJobType" $ \value -> if value == String "yield" then pure YieldJobQueuedEventJobTypeYield else fail "unknown enumeration member"

instance ToJSON YieldJobQueuedEventJobType where toJSON YieldJobQueuedEventJobTypeYield = String "yield"

yieldJobQueuedEventJobTypeText :: YieldJobQueuedEventJobType -> Text
yieldJobQueuedEventJobTypeText YieldJobQueuedEventJobTypeYield = "yield"
