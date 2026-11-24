-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ConformanceFailure (ConformanceFailure (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.FailureClass

data ConformanceFailure = ConformanceFailure
  { conformanceFailureCode :: Maybe Text,
    conformanceFailureDetail :: Text,
    conformanceFailureFailureClass :: Maybe FailureClass,
    conformanceFailureStatus :: Maybe Integer
  }
  deriving (Eq, Show)

instance FromJSON ConformanceFailure where parseJSON = checked "ConformanceFailure" $ withObject "ConformanceFailure" (\fields -> ConformanceFailure <$> optional fields "code" <*> (fields .: "detail") <*> optional fields "failureClass" <*> optional fields "status")

instance ToJSON ConformanceFailure where toJSON value = Object (KM.fromList (concat [optionalPair "code" (conformanceFailureCode value), [("detail", toJSON (conformanceFailureDetail value))], optionalPair "failureClass" (conformanceFailureFailureClass value), optionalPair "status" (conformanceFailureStatus value)]))
