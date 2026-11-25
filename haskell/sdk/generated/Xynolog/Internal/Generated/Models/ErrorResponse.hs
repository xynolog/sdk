-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ErrorResponse (ErrorResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ErrorResponse = ErrorResponse
  { errorResponseError :: Text,
    errorResponseCode :: Maybe Text,
    errorResponseHint :: Maybe Text,
    errorResponseDetails :: Maybe Value
  }
  deriving (Eq, Show)

instance FromJSON ErrorResponse where parseJSON = checked "ErrorResponse" $ withObject "ErrorResponse" (\fields -> ErrorResponse <$> (fields .: "error") <*> optional fields "code" <*> optional fields "hint" <*> optional fields "details")

instance ToJSON ErrorResponse where toJSON value = Object (KM.fromList (concat [[("error", toJSON (errorResponseError value))], optionalPair "code" (errorResponseCode value), optionalPair "hint" (errorResponseHint value), optionalPair "details" (errorResponseDetails value)]))
