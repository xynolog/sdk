-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.RunInstance (RunInstance (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

newtype RunInstance = RunInstance {runInstanceValue :: Text} deriving (Eq, Show)

instance FromJSON RunInstance where parseJSON = checked "RunInstance" $ \value -> RunInstance <$> parseJSON value

instance ToJSON RunInstance where toJSON (RunInstance value) = toJSON value
