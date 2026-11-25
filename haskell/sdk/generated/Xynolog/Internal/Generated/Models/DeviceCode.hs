-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DeviceCode (DeviceCode (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data DeviceCode = DeviceCode
  { deviceCodeUserCode :: Text,
    deviceCodeVerificationUri :: Text,
    deviceCodeVerificationUriComplete :: Maybe Text,
    deviceCodeExpiresIn :: Integer
  }
  deriving (Eq, Show)

instance FromJSON DeviceCode where parseJSON = checked "DeviceCode" $ withObject "DeviceCode" (\fields -> DeviceCode <$> (fields .: "userCode") <*> (fields .: "verificationUri") <*> optional fields "verificationUriComplete" <*> (fields .: "expiresIn"))

instance ToJSON DeviceCode where toJSON value = Object (KM.fromList (concat [[("userCode", toJSON (deviceCodeUserCode value))], [("verificationUri", toJSON (deviceCodeVerificationUri value))], optionalPair "verificationUriComplete" (deviceCodeVerificationUriComplete value), [("expiresIn", toJSON (deviceCodeExpiresIn value))]]))
