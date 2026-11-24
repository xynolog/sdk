-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobType (JobType (..), jobTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data JobType = JobTypeMark | JobTypeYield deriving (Eq, Show)

instance FromJSON JobType where parseJSON = checked "JobType" $ \value -> if value == String "mark" then pure JobTypeMark else if value == String "yield" then pure JobTypeYield else fail "unknown enumeration member"

instance ToJSON JobType where
  toJSON JobTypeMark = String "mark"
  toJSON JobTypeYield = String "yield"

jobTypeText :: JobType -> Text
jobTypeText JobTypeMark = "mark"
jobTypeText JobTypeYield = "yield"
