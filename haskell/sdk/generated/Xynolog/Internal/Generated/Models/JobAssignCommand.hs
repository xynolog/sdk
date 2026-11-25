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
    jobAssignCommandJobId :: JobId,
    jobAssignCommandJobType :: JobType,
    jobAssignCommandResourceId :: ResourceId,
    jobAssignCommandHolder :: UserId,
    jobAssignCommandRequester :: UserId
  }
  deriving (Eq, Show)

instance FromJSON JobAssignCommand where parseJSON = checked "JobAssignCommand" $ withObject "JobAssignCommand" (\fields -> JobAssignCommand <$> optional fields "_userId" <*> (fields .: "jobId") <*> (fields .: "jobType") <*> (fields .: "resourceId") <*> (fields .: "holder") <*> (fields .: "requester"))

instance ToJSON JobAssignCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (jobAssignCommandUserId value), [("jobId", toJSON (jobAssignCommandJobId value))], [("jobType", toJSON (jobAssignCommandJobType value))], [("resourceId", toJSON (jobAssignCommandResourceId value))], [("holder", toJSON (jobAssignCommandHolder value))], [("requester", toJSON (jobAssignCommandRequester value))]]))
