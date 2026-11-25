-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.InferenceLimitsResult (InferenceLimitsResult (..), InferenceLimitsResultResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.EngineLimits

data InferenceLimitsResult = InferenceLimitsResult
  { inferenceLimitsResultResponse :: InferenceLimitsResultResponse
  }
  deriving (Eq, Show)

instance FromJSON InferenceLimitsResult where parseJSON = checked "InferenceLimitsResult" $ withObject "InferenceLimitsResult" (\fields -> InferenceLimitsResult <$> (fields .: "response"))

instance ToJSON InferenceLimitsResult where toJSON value = Object (KM.fromList (concat [[("response", toJSON (inferenceLimitsResultResponse value))]]))

data InferenceLimitsResultResponse = InferenceLimitsResultResponse
  { inferenceLimitsResultResponseLimits :: [EngineLimits]
  }
  deriving (Eq, Show)

instance FromJSON InferenceLimitsResultResponse where parseJSON = checked "InferenceLimitsResultResponse" $ withObject "InferenceLimitsResultResponse" (\fields -> InferenceLimitsResultResponse <$> (fields .: "limits"))

instance ToJSON InferenceLimitsResultResponse where toJSON value = Object (KM.fromList (concat [[("limits", toJSON (inferenceLimitsResultResponseLimits value))]]))
