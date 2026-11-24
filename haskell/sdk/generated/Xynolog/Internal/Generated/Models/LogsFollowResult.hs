-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.LogsFollowResult (LogsFollowResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data LogsFollowResult = LogsFollowResult
  { logsFollowResultServices :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON LogsFollowResult where parseJSON = checked "LogsFollowResult" $ withObject "LogsFollowResult" (\fields -> LogsFollowResult <$> (fields .: "services"))

instance ToJSON LogsFollowResult where toJSON value = Object (KM.fromList (concat [[("services", toJSON (logsFollowResultServices value))]]))
