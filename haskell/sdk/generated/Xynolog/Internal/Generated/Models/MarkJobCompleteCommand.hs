-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkJobCompleteCommand (MarkJobCompleteCommand (..), MarkJobCompleteCommandJobType (..), markJobCompleteCommandJobTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.DurabilityEvidence
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.MarkJobResult
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data MarkJobCompleteCommand = MarkJobCompleteCommand
  { markJobCompleteCommandUserId :: Maybe UserId,
    markJobCompleteCommandResourceId :: ResourceId,
    markJobCompleteCommandJobId :: JobId,
    markJobCompleteCommandJobType :: MarkJobCompleteCommandJobType,
    markJobCompleteCommandAttempt :: Maybe Integer,
    markJobCompleteCommandResult :: Maybe MarkJobResult,
    markJobCompleteCommandDurability :: Maybe DurabilityEvidence
  }
  deriving (Eq, Show)

instance FromJSON MarkJobCompleteCommand where parseJSON = checked "MarkJobCompleteCommand" $ withObject "MarkJobCompleteCommand" (\fields -> MarkJobCompleteCommand <$> optional fields "_userId" <*> (fields .: "resourceId") <*> (fields .: "jobId") <*> (fields .: "jobType") <*> optional fields "attempt" <*> optional fields "result" <*> optional fields "durability")

instance ToJSON MarkJobCompleteCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (markJobCompleteCommandUserId value), [("resourceId", toJSON (markJobCompleteCommandResourceId value))], [("jobId", toJSON (markJobCompleteCommandJobId value))], [("jobType", toJSON (markJobCompleteCommandJobType value))], optionalPair "attempt" (markJobCompleteCommandAttempt value), optionalPair "result" (markJobCompleteCommandResult value), optionalPair "durability" (markJobCompleteCommandDurability value)]))

data MarkJobCompleteCommandJobType = MarkJobCompleteCommandJobTypeMark deriving (Eq, Show)

instance FromJSON MarkJobCompleteCommandJobType where parseJSON = checked "MarkJobCompleteCommandJobType" $ \value -> if value == String "mark" then pure MarkJobCompleteCommandJobTypeMark else fail "unknown enumeration member"

instance ToJSON MarkJobCompleteCommandJobType where toJSON MarkJobCompleteCommandJobTypeMark = String "mark"

markJobCompleteCommandJobTypeText :: MarkJobCompleteCommandJobType -> Text
markJobCompleteCommandJobTypeText MarkJobCompleteCommandJobTypeMark = "mark"
