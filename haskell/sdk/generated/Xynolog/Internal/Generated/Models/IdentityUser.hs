-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.IdentityUser (IdentityUser (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data IdentityUser = IdentityUser
  { identityUserEmail :: Text,
    identityUserEnabled :: Bool,
    identityUserIdentity :: Text
  }
  deriving (Eq, Show)

instance FromJSON IdentityUser where parseJSON = checked "IdentityUser" $ withObject "IdentityUser" (\fields -> IdentityUser <$> (fields .: "email") <*> (fields .: "enabled") <*> (fields .: "identity"))

instance ToJSON IdentityUser where toJSON value = Object (KM.fromList (concat [[("email", toJSON (identityUserEmail value))], [("enabled", toJSON (identityUserEnabled value))], [("identity", toJSON (identityUserIdentity value))]]))
