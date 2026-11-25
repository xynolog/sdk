-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobClaimCommand (JobClaimCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobFilter
import Xynolog.Internal.Generated.Models.UserId

data JobClaimCommand = JobClaimCommand
  { jobClaimCommandRoles :: Maybe [Text],
    jobClaimCommandUserId :: Maybe UserId,
    jobClaimCommandAccepts :: [JobFilter]
  }
  deriving (Eq, Show)

instance FromJSON JobClaimCommand where parseJSON = checked "JobClaimCommand" $ withObject "JobClaimCommand" (\fields -> JobClaimCommand <$> optional fields "_roles" <*> optional fields "_userId" <*> (fields .: "accepts"))

instance ToJSON JobClaimCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_roles" (jobClaimCommandRoles value), optionalPair "_userId" (jobClaimCommandUserId value), [("accepts", toJSON (jobClaimCommandAccepts value))]]))
