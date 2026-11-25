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
    identityUseraddParamsTarget :: LocalTarget,
    identityUseraddParamsEmail :: Text,
    identityUseraddParamsPassword :: Maybe Text,
    identityUseraddParamsGeneratePassword :: Bool
  }
  deriving (Eq, Show)

instance FromJSON IdentityUseraddParams where parseJSON = checked "IdentityUseraddParams" $ withObject "IdentityUseraddParams" (\fields -> IdentityUseraddParams <$> (fields .: "apiVersion") <*> (fields .: "target") <*> (fields .: "email") <*> optional fields "password" <*> (fields .: "generatePassword"))

instance ToJSON IdentityUseraddParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (identityUseraddParamsApiVersion value))], [("target", toJSON (identityUseraddParamsTarget value))], [("email", toJSON (identityUseraddParamsEmail value))], optionalPair "password" (identityUseraddParamsPassword value), [("generatePassword", toJSON (identityUseraddParamsGeneratePassword value))]]))
