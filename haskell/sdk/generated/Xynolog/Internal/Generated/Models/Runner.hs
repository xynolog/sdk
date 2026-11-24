-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Runner (Runner (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject)
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec

data Runner = Runner
  { runnerAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON Runner where parseJSON = checked "Runner" $ withObject "Runner" (\fields -> Runner <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON Runner where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (runnerAdditionalProperties value)))
