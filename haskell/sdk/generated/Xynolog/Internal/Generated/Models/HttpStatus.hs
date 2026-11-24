-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.HttpStatus (HttpStatus (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec

newtype HttpStatus = HttpStatus {httpStatusValue :: Integer} deriving (Eq, Show)

instance FromJSON HttpStatus where parseJSON = checked "HttpStatus" $ \value -> HttpStatus <$> parseJSON value

instance ToJSON HttpStatus where toJSON (HttpStatus value) = toJSON value
