-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Binary (Binary (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

newtype Binary = Binary {binaryValue :: Text} deriving (Eq, Show)

instance FromJSON Binary where parseJSON = checked "Binary" $ \value -> Binary <$> parseJSON value

instance ToJSON Binary where toJSON (Binary value) = toJSON value
