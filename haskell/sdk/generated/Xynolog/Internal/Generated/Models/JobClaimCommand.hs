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
  { jobClaimCommandAccepts :: [JobFilter],
    jobClaimCommandUserId :: Maybe UserId,
    jobClaimCommandRoles :: Maybe [Text]
  }
  deriving (Eq, Show)

instance FromJSON JobClaimCommand where parseJSON = checked "JobClaimCommand" $ withObject "JobClaimCommand" (\fields -> JobClaimCommand <$> (fields .: "accepts") <*> optional fields "_userId" <*> optional fields "_roles")

instance ToJSON JobClaimCommand where toJSON value = Object (KM.fromList (concat [[("accepts", toJSON (jobClaimCommandAccepts value))], optionalPair "_userId" (jobClaimCommandUserId value), optionalPair "_roles" (jobClaimCommandRoles value)]))
