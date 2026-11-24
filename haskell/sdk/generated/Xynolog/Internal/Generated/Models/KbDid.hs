-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.KbDid (KbDid (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

newtype KbDid = KbDid {kbDidValue :: Text} deriving (Eq, Show)

instance FromJSON KbDid where parseJSON = checked "KbDid" $ \value -> KbDid <$> parseJSON value

instance ToJSON KbDid where toJSON (KbDid value) = toJSON value
