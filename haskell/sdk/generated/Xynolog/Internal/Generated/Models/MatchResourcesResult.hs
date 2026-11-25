-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MatchResourcesResult (MatchResourcesResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.MatchResourcesResponse

data MatchResourcesResult = MatchResourcesResult
  { matchResourcesResultResponse :: MatchResourcesResponse
  }
  deriving (Eq, Show)

instance FromJSON MatchResourcesResult where parseJSON = checked "MatchResourcesResult" $ withObject "MatchResourcesResult" (\fields -> MatchResourcesResult <$> (fields .: "response"))

instance ToJSON MatchResourcesResult where toJSON value = Object (KM.fromList (concat [[("response", toJSON (matchResourcesResultResponse value))]]))
