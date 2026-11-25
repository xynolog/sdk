-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkCommitCommand (MarkCommitCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Annotation
import Xynolog.Internal.Generated.Models.JobId
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data MarkCommitCommand = MarkCommitCommand
  { markCommitCommandRoles :: Maybe [Text],
    markCommitCommandUserId :: Maybe UserId,
    markCommitCommandAnnotations :: [Annotation],
    markCommitCommandJobId :: Maybe JobId,
    markCommitCommandResourceId :: ResourceId,
    markCommitCommandAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON MarkCommitCommand where parseJSON = checked "MarkCommitCommand" $ withObject "MarkCommitCommand" (\fields -> MarkCommitCommand <$> optional fields "_roles" <*> optional fields "_userId" <*> (fields .: "annotations") <*> optional fields "jobId" <*> (fields .: "resourceId") <*> traverse parseJSON (withoutFields ["_roles", "_userId", "annotations", "jobId", "resourceId"] fields))

instance ToJSON MarkCommitCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_roles" (markCommitCommandRoles value), optionalPair "_userId" (markCommitCommandUserId value), [("annotations", toJSON (markCommitCommandAnnotations value))], optionalPair "jobId" (markCommitCommandJobId value), [("resourceId", toJSON (markCommitCommandResourceId value))]]) <> fmap toJSON (withoutFields ["_roles", "_userId", "annotations", "jobId", "resourceId"] (markCommitCommandAdditionalProperties value)))
