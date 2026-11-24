-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.IdentityUseraddParams (IdentityUseraddParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion
import Xynolog.Internal.Generated.Models.LocalTarget

data IdentityUseraddParams = IdentityUseraddParams
  { identityUseraddParamsApiVersion :: ApiVersion,
    identityUseraddParamsEmail :: Text,
    identityUseraddParamsGeneratePassword :: Bool,
    identityUseraddParamsPassword :: Maybe Text,
    identityUseraddParamsTarget :: LocalTarget
  }
  deriving (Eq, Show)

instance FromJSON IdentityUseraddParams where parseJSON = checked "IdentityUseraddParams" $ withObject "IdentityUseraddParams" (\fields -> IdentityUseraddParams <$> (fields .: "apiVersion") <*> (fields .: "email") <*> (fields .: "generatePassword") <*> optional fields "password" <*> (fields .: "target"))

instance ToJSON IdentityUseraddParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (identityUseraddParamsApiVersion value))], [("email", toJSON (identityUseraddParamsEmail value))], [("generatePassword", toJSON (identityUseraddParamsGeneratePassword value))], optionalPair "password" (identityUseraddParamsPassword value), [("target", toJSON (identityUseraddParamsTarget value))]]))
