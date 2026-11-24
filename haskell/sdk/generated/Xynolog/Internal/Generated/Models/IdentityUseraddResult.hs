-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.IdentityUseraddResult (IdentityUseraddResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data IdentityUseraddResult = IdentityUseraddResult
  { identityUseraddResultCreated :: Bool,
    identityUseraddResultEmail :: Text,
    identityUseraddResultGeneratedPassword :: Maybe Text,
    identityUseraddResultIdentity :: Text
  }
  deriving (Eq, Show)

instance FromJSON IdentityUseraddResult where parseJSON = checked "IdentityUseraddResult" $ withObject "IdentityUseraddResult" (\fields -> IdentityUseraddResult <$> (fields .: "created") <*> (fields .: "email") <*> optional fields "generatedPassword" <*> (fields .: "identity"))

instance ToJSON IdentityUseraddResult where toJSON value = Object (KM.fromList (concat [[("created", toJSON (identityUseraddResultCreated value))], [("email", toJSON (identityUseraddResultEmail value))], optionalPair "generatedPassword" (identityUseraddResultGeneratedPassword value), [("identity", toJSON (identityUseraddResultIdentity value))]]))
