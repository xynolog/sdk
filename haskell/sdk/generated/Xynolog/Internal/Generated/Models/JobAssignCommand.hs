-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobAssignCommand (JobAssignCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.JobType
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data JobAssignCommand = JobAssignCommand
  { jobAssignCommandUserId :: Maybe UserId,
    jobAssignCommandHolder :: UserId,
    jobAssignCommandJobId :: JobId,
    jobAssignCommandJobType :: JobType,
    jobAssignCommandRequester :: UserId,
    jobAssignCommandResourceId :: ResourceId
  }
  deriving (Eq, Show)

instance FromJSON JobAssignCommand where parseJSON = checked "JobAssignCommand" $ withObject "JobAssignCommand" (\fields -> JobAssignCommand <$> optional fields "_userId" <*> (fields .: "holder") <*> (fields .: "jobId") <*> (fields .: "jobType") <*> (fields .: "requester") <*> (fields .: "resourceId"))

instance ToJSON JobAssignCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (jobAssignCommandUserId value), [("holder", toJSON (jobAssignCommandHolder value))], [("jobId", toJSON (jobAssignCommandJobId value))], [("jobType", toJSON (jobAssignCommandJobType value))], [("requester", toJSON (jobAssignCommandRequester value))], [("resourceId", toJSON (jobAssignCommandResourceId value))]]))
