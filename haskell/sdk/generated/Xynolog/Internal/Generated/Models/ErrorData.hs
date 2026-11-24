-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ErrorData (ErrorData (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.FieldFault
import Xynolog.Internal.Generated.Models.Target

data ErrorData = ErrorData
  { errorDataChoices :: Maybe [Target],
    errorDataCode :: Text,
    errorDataFields :: Maybe [FieldFault],
    errorDataMayStillRun :: Maybe Bool,
    errorDataRetryable :: Bool,
    errorDataSupported :: Maybe [Text]
  }
  deriving (Eq, Show)

instance FromJSON ErrorData where parseJSON = checked "ErrorData" $ withObject "ErrorData" (\fields -> ErrorData <$> optional fields "choices" <*> (fields .: "code") <*> optional fields "fields" <*> optional fields "mayStillRun" <*> (fields .: "retryable") <*> optional fields "supported")

instance ToJSON ErrorData where toJSON value = Object (KM.fromList (concat [optionalPair "choices" (errorDataChoices value), [("code", toJSON (errorDataCode value))], optionalPair "fields" (errorDataFields value), optionalPair "mayStillRun" (errorDataMayStillRun value), [("retryable", toJSON (errorDataRetryable value))], optionalPair "supported" (errorDataSupported value)]))
