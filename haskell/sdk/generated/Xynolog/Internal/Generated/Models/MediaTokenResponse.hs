-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MediaTokenResponse (MediaTokenResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data MediaTokenResponse = MediaTokenResponse
  { mediaTokenResponseToken :: Text
  }
  deriving (Eq, Show)

instance FromJSON MediaTokenResponse where parseJSON = checked "MediaTokenResponse" $ withObject "MediaTokenResponse" (\fields -> MediaTokenResponse <$> (fields .: "token"))

instance ToJSON MediaTokenResponse where toJSON value = Object (KM.fromList (concat [[("token", toJSON (mediaTokenResponseToken value))]]))
