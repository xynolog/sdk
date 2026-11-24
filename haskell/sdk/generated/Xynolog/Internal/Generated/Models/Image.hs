-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Image (Image (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

newtype Image = Image {imageValue :: Text} deriving (Eq, Show)

instance FromJSON Image where parseJSON = checked "Image" $ \value -> Image <$> parseJSON value

instance ToJSON Image where toJSON (Image value) = toJSON value
