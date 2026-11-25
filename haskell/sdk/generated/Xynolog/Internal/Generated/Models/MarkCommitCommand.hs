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
  { markCommitCommandUserId :: Maybe UserId,
    markCommitCommandRoles :: Maybe [Text],
    markCommitCommandJobId :: Maybe JobId,
    markCommitCommandResourceId :: ResourceId,
    markCommitCommandAnnotations :: [Annotation]
  }
  deriving (Eq, Show)

instance FromJSON MarkCommitCommand where parseJSON = checked "MarkCommitCommand" $ withObject "MarkCommitCommand" (\fields -> MarkCommitCommand <$> optional fields "_userId" <*> optional fields "_roles" <*> optional fields "jobId" <*> (fields .: "resourceId") <*> (fields .: "annotations"))

instance ToJSON MarkCommitCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (markCommitCommandUserId value), optionalPair "_roles" (markCommitCommandRoles value), optionalPair "jobId" (markCommitCommandJobId value), [("resourceId", toJSON (markCommitCommandResourceId value))], [("annotations", toJSON (markCommitCommandAnnotations value))]]))
