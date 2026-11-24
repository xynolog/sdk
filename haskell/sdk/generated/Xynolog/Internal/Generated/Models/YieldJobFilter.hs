-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.YieldJobFilter (YieldJobFilter (..), YieldJobFilterJobType (..), yieldJobFilterJobTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data YieldJobFilter = YieldJobFilter
  { yieldJobFilterJobType :: YieldJobFilterJobType
  }
  deriving (Eq, Show)

instance FromJSON YieldJobFilter where parseJSON = checked "YieldJobFilter" $ withObject "YieldJobFilter" (\fields -> YieldJobFilter <$> (fields .: "jobType"))

instance ToJSON YieldJobFilter where toJSON value = Object (KM.fromList (concat [[("jobType", toJSON (yieldJobFilterJobType value))]]))

data YieldJobFilterJobType = YieldJobFilterJobTypeYield deriving (Eq, Show)

instance FromJSON YieldJobFilterJobType where parseJSON = checked "YieldJobFilterJobType" $ \value -> if value == String "yield" then pure YieldJobFilterJobTypeYield else fail "unknown enumeration member"

instance ToJSON YieldJobFilterJobType where toJSON YieldJobFilterJobTypeYield = String "yield"

yieldJobFilterJobTypeText :: YieldJobFilterJobType -> Text
yieldJobFilterJobTypeText YieldJobFilterJobTypeYield = "yield"
