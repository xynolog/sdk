-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkJobFilter (MarkJobFilter (..), MarkJobFilterJobType (..), markJobFilterJobTypeText, MarkJobFilterParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Motivation

data MarkJobFilter = MarkJobFilter
  { markJobFilterJobType :: MarkJobFilterJobType,
    markJobFilterParams :: MarkJobFilterParams
  }
  deriving (Eq, Show)

instance FromJSON MarkJobFilter where parseJSON = checked "MarkJobFilter" $ withObject "MarkJobFilter" (\fields -> MarkJobFilter <$> (fields .: "jobType") <*> (fields .: "params"))

instance ToJSON MarkJobFilter where toJSON value = Object (KM.fromList (concat [[("jobType", toJSON (markJobFilterJobType value))], [("params", toJSON (markJobFilterParams value))]]))

data MarkJobFilterJobType = MarkJobFilterJobTypeMark deriving (Eq, Show)

instance FromJSON MarkJobFilterJobType where parseJSON = checked "MarkJobFilterJobType" $ \value -> if value == String "mark" then pure MarkJobFilterJobTypeMark else fail "unknown enumeration member"

instance ToJSON MarkJobFilterJobType where toJSON MarkJobFilterJobTypeMark = String "mark"

markJobFilterJobTypeText :: MarkJobFilterJobType -> Text
markJobFilterJobTypeText MarkJobFilterJobTypeMark = "mark"

data MarkJobFilterParams = MarkJobFilterParams
  { markJobFilterParamsMotivation :: Motivation
  }
  deriving (Eq, Show)

instance FromJSON MarkJobFilterParams where parseJSON = checked "MarkJobFilterParams" $ withObject "MarkJobFilterParams" (\fields -> MarkJobFilterParams <$> (fields .: "motivation"))

instance ToJSON MarkJobFilterParams where toJSON value = Object (KM.fromList (concat [[("motivation", toJSON (markJobFilterParamsMotivation value))]]))
