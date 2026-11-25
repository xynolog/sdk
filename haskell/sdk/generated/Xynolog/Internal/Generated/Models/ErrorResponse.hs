-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ErrorResponse (ErrorResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ErrorResponse = ErrorResponse
  { errorResponseCode :: Maybe Text,
    errorResponseDetails :: Maybe Value,
    errorResponseError :: Text,
    errorResponseHint :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ErrorResponse where parseJSON = checked "ErrorResponse" $ withObject "ErrorResponse" (\fields -> ErrorResponse <$> optional fields "code" <*> optional fields "details" <*> (fields .: "error") <*> optional fields "hint")

instance ToJSON ErrorResponse where toJSON value = Object (KM.fromList (concat [optionalPair "code" (errorResponseCode value), optionalPair "details" (errorResponseDetails value), [("error", toJSON (errorResponseError value))], optionalPair "hint" (errorResponseHint value)]))
