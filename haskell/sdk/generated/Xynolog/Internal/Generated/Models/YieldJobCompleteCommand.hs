-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.YieldJobCompleteCommand (YieldJobCompleteCommand (..), YieldJobCompleteCommandJobType (..), yieldJobCompleteCommandJobTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.DurabilityEvidence
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId
import Xynolog.Internal.Generated.Models.YieldJobResult

data YieldJobCompleteCommand = YieldJobCompleteCommand
  { yieldJobCompleteCommandUserId :: Maybe UserId,
    yieldJobCompleteCommandResourceId :: ResourceId,
    yieldJobCompleteCommandJobId :: JobId,
    yieldJobCompleteCommandJobType :: YieldJobCompleteCommandJobType,
    yieldJobCompleteCommandAttempt :: Maybe Integer,
    yieldJobCompleteCommandAnnotationId :: Maybe AnnotationId,
    yieldJobCompleteCommandResult :: Maybe YieldJobResult,
    yieldJobCompleteCommandDurability :: Maybe DurabilityEvidence
  }
  deriving (Eq, Show)

instance FromJSON YieldJobCompleteCommand where parseJSON = checked "YieldJobCompleteCommand" $ withObject "YieldJobCompleteCommand" (\fields -> YieldJobCompleteCommand <$> optional fields "_userId" <*> (fields .: "resourceId") <*> (fields .: "jobId") <*> (fields .: "jobType") <*> optional fields "attempt" <*> optional fields "annotationId" <*> optional fields "result" <*> optional fields "durability")

instance ToJSON YieldJobCompleteCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (yieldJobCompleteCommandUserId value), [("resourceId", toJSON (yieldJobCompleteCommandResourceId value))], [("jobId", toJSON (yieldJobCompleteCommandJobId value))], [("jobType", toJSON (yieldJobCompleteCommandJobType value))], optionalPair "attempt" (yieldJobCompleteCommandAttempt value), optionalPair "annotationId" (yieldJobCompleteCommandAnnotationId value), optionalPair "result" (yieldJobCompleteCommandResult value), optionalPair "durability" (yieldJobCompleteCommandDurability value)]))

data YieldJobCompleteCommandJobType = YieldJobCompleteCommandJobTypeYield deriving (Eq, Show)

instance FromJSON YieldJobCompleteCommandJobType where parseJSON = checked "YieldJobCompleteCommandJobType" $ \value -> if value == String "yield" then pure YieldJobCompleteCommandJobTypeYield else fail "unknown enumeration member"

instance ToJSON YieldJobCompleteCommandJobType where toJSON YieldJobCompleteCommandJobTypeYield = String "yield"

yieldJobCompleteCommandJobTypeText :: YieldJobCompleteCommandJobType -> Text
yieldJobCompleteCommandJobTypeText YieldJobCompleteCommandJobTypeYield = "yield"
