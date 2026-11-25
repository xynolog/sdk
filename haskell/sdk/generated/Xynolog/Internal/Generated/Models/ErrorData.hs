-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ErrorData (ErrorData (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.ErrorCodes (ControlCode (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.FieldFault
import Xynolog.Internal.Generated.Models.Target

data ErrorData = ErrorData
  { errorDataCode :: ControlCode,
    errorDataRetryable :: Bool,
    errorDataFields :: Maybe [FieldFault],
    errorDataChoices :: Maybe [Target],
    errorDataSupported :: Maybe [Text],
    errorDataMayStillRun :: Maybe Bool
  }
  deriving (Eq, Show)

instance FromJSON ErrorData where parseJSON = checked "ErrorData" $ withObject "ErrorData" (\fields -> ErrorData <$> (fields .: "code") <*> (fields .: "retryable") <*> optional fields "fields" <*> optional fields "choices" <*> optional fields "supported" <*> optional fields "mayStillRun")

instance ToJSON ErrorData where toJSON value = Object (KM.fromList (concat [[("code", toJSON (errorDataCode value))], [("retryable", toJSON (errorDataRetryable value))], optionalPair "fields" (errorDataFields value), optionalPair "choices" (errorDataChoices value), optionalPair "supported" (errorDataSupported value), optionalPair "mayStillRun" (errorDataMayStillRun value)]))
