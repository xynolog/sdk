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
  { yieldJobCompleteCommandU5f_userId :: Maybe UserId,
    yieldJobCompleteCommandAnnotationId :: Maybe AnnotationId,
    yieldJobCompleteCommandAttempt :: Maybe Integer,
    yieldJobCompleteCommandDurability :: Maybe DurabilityEvidence,
    yieldJobCompleteCommandJobId :: JobId,
    yieldJobCompleteCommandJobType :: YieldJobCompleteCommandJobType,
    yieldJobCompleteCommandResourceId :: ResourceId,
    yieldJobCompleteCommandResult :: Maybe YieldJobResult,
    yieldJobCompleteCommandAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON YieldJobCompleteCommand where parseJSON = checked "YieldJobCompleteCommand" $ withObject "YieldJobCompleteCommand" (\fields -> YieldJobCompleteCommand <$> optional fields "_userId" <*> optional fields "annotationId" <*> optional fields "attempt" <*> optional fields "durability" <*> (fields .: "jobId") <*> (fields .: "jobType") <*> (fields .: "resourceId") <*> optional fields "result" <*> traverse parseJSON (withoutFields ["_userId", "annotationId", "attempt", "durability", "jobId", "jobType", "resourceId", "result"] fields))

instance ToJSON YieldJobCompleteCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (yieldJobCompleteCommandU5f_userId value), optionalPair "annotationId" (yieldJobCompleteCommandAnnotationId value), optionalPair "attempt" (yieldJobCompleteCommandAttempt value), optionalPair "durability" (yieldJobCompleteCommandDurability value), [("jobId", toJSON (yieldJobCompleteCommandJobId value))], [("jobType", toJSON (yieldJobCompleteCommandJobType value))], [("resourceId", toJSON (yieldJobCompleteCommandResourceId value))], optionalPair "result" (yieldJobCompleteCommandResult value)]) <> fmap toJSON (withoutFields ["_userId", "annotationId", "attempt", "durability", "jobId", "jobType", "resourceId", "result"] (yieldJobCompleteCommandAdditionalProperties value)))

data YieldJobCompleteCommandJobType = YieldJobCompleteCommandJobTypeYield deriving (Eq, Show)

instance FromJSON YieldJobCompleteCommandJobType where parseJSON = checked "YieldJobCompleteCommandJobType" $ \value -> if value == String "yield" then pure YieldJobCompleteCommandJobTypeYield else fail "unknown enumeration member"

instance ToJSON YieldJobCompleteCommandJobType where toJSON YieldJobCompleteCommandJobTypeYield = String "yield"

yieldJobCompleteCommandJobTypeText :: YieldJobCompleteCommandJobType -> Text
yieldJobCompleteCommandJobTypeText YieldJobCompleteCommandJobTypeYield = "yield"
