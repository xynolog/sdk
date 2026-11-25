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
    markJobCompleteCommandAttempt :: Maybe Integer,
    markJobCompleteCommandDurability :: Maybe DurabilityEvidence,
    markJobCompleteCommandJobId :: JobId,
    markJobCompleteCommandJobType :: MarkJobCompleteCommandJobType,
    markJobCompleteCommandResourceId :: ResourceId,
    markJobCompleteCommandResult :: Maybe MarkJobResult,
    markJobCompleteCommandAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON MarkJobCompleteCommand where parseJSON = checked "MarkJobCompleteCommand" $ withObject "MarkJobCompleteCommand" (\fields -> MarkJobCompleteCommand <$> optional fields "_userId" <*> optional fields "attempt" <*> optional fields "durability" <*> (fields .: "jobId") <*> (fields .: "jobType") <*> (fields .: "resourceId") <*> optional fields "result" <*> traverse parseJSON (withoutFields ["_userId", "attempt", "durability", "jobId", "jobType", "resourceId", "result"] fields))

instance ToJSON MarkJobCompleteCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (markJobCompleteCommandUserId value), optionalPair "attempt" (markJobCompleteCommandAttempt value), optionalPair "durability" (markJobCompleteCommandDurability value), [("jobId", toJSON (markJobCompleteCommandJobId value))], [("jobType", toJSON (markJobCompleteCommandJobType value))], [("resourceId", toJSON (markJobCompleteCommandResourceId value))], optionalPair "result" (markJobCompleteCommandResult value)]) <> fmap toJSON (withoutFields ["_userId", "attempt", "durability", "jobId", "jobType", "resourceId", "result"] (markJobCompleteCommandAdditionalProperties value)))

data MarkJobCompleteCommandJobType = MarkJobCompleteCommandJobTypeMark deriving (Eq, Show)

instance FromJSON MarkJobCompleteCommandJobType where parseJSON = checked "MarkJobCompleteCommandJobType" $ \value -> if value == String "mark" then pure MarkJobCompleteCommandJobTypeMark else fail "unknown enumeration member"

instance ToJSON MarkJobCompleteCommandJobType where toJSON MarkJobCompleteCommandJobTypeMark = String "mark"

markJobCompleteCommandJobTypeText :: MarkJobCompleteCommandJobType -> Text
markJobCompleteCommandJobTypeText MarkJobCompleteCommandJobTypeMark = "mark"
