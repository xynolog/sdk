-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobAssignedPayload (JobAssignedPayload (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.JobType
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data JobAssignedPayload = JobAssignedPayload
  { jobAssignedPayloadHolder :: UserId,
    jobAssignedPayloadJobId :: JobId,
    jobAssignedPayloadJobType :: JobType,
    jobAssignedPayloadRequester :: UserId,
    jobAssignedPayloadResourceId :: ResourceId
  }
  deriving (Eq, Show)

instance FromJSON JobAssignedPayload where parseJSON = checked "JobAssignedPayload" $ withObject "JobAssignedPayload" (\fields -> JobAssignedPayload <$> (fields .: "holder") <*> (fields .: "jobId") <*> (fields .: "jobType") <*> (fields .: "requester") <*> (fields .: "resourceId"))

instance ToJSON JobAssignedPayload where toJSON value = Object (KM.fromList (concat [[("holder", toJSON (jobAssignedPayloadHolder value))], [("jobId", toJSON (jobAssignedPayloadJobId value))], [("jobType", toJSON (jobAssignedPayloadJobType value))], [("requester", toJSON (jobAssignedPayloadRequester value))], [("resourceId", toJSON (jobAssignedPayloadResourceId value))]]))
