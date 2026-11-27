-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AccessToken (AccessToken (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

newtype AccessToken = AccessToken {accessTokenValue :: Text} deriving (Eq, Show)

instance FromJSON AccessToken where parseJSON = checked "AccessToken" $ \value -> AccessToken <$> parseJSON value

instance ToJSON AccessToken where toJSON (AccessToken value) = toJSON value
