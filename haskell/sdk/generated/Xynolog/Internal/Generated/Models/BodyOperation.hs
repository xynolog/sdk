-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BodyOperation (BodyOperation (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.BodyOperationAdd
import Xynolog.Internal.Generated.Models.BodyOperationRemove
import Xynolog.Internal.Generated.Models.BodyOperationReplace

data BodyOperation = BodyOperationBodyOperationAdd BodyOperationAdd | BodyOperationBodyOperationRemove BodyOperationRemove | BodyOperationBodyOperationReplace BodyOperationReplace deriving (Eq, Show)

instance FromJSON BodyOperation where parseJSON = checked "BodyOperation" $ \value -> (BodyOperationBodyOperationAdd <$> parseJSON value) <|> (BodyOperationBodyOperationRemove <$> parseJSON value) <|> (BodyOperationBodyOperationReplace <$> parseJSON value)

instance ToJSON BodyOperation where
  toJSON (BodyOperationBodyOperationAdd value) = toJSON value
  toJSON (BodyOperationBodyOperationRemove value) = toJSON value
  toJSON (BodyOperationBodyOperationReplace value) = toJSON value
