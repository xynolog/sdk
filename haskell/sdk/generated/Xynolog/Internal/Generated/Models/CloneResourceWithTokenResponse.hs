-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.CloneResourceWithTokenResponse (CloneResourceWithTokenResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceDescriptor

data CloneResourceWithTokenResponse = CloneResourceWithTokenResponse
  { cloneResourceWithTokenResponseExpiresAt :: Text,
    cloneResourceWithTokenResponseResource :: ResourceDescriptor,
    cloneResourceWithTokenResponseToken :: Text
  }
  deriving (Eq, Show)

instance FromJSON CloneResourceWithTokenResponse where parseJSON = checked "CloneResourceWithTokenResponse" $ withObject "CloneResourceWithTokenResponse" (\fields -> CloneResourceWithTokenResponse <$> (fields .: "expiresAt") <*> (fields .: "resource") <*> (fields .: "token"))

instance ToJSON CloneResourceWithTokenResponse where toJSON value = Object (KM.fromList (concat [[("expiresAt", toJSON (cloneResourceWithTokenResponseExpiresAt value))], [("resource", toJSON (cloneResourceWithTokenResponseResource value))], [("token", toJSON (cloneResourceWithTokenResponseToken value))]]))
