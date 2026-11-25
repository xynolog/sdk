-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.IdentityUseraddResult (IdentityUseraddResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data IdentityUseraddResult = IdentityUseraddResult
  { identityUseraddResultEmail :: Text,
    identityUseraddResultIdentity :: Text,
    identityUseraddResultCreated :: Bool,
    identityUseraddResultGeneratedPassword :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON IdentityUseraddResult where parseJSON = checked "IdentityUseraddResult" $ withObject "IdentityUseraddResult" (\fields -> IdentityUseraddResult <$> (fields .: "email") <*> (fields .: "identity") <*> (fields .: "created") <*> optional fields "generatedPassword")

instance ToJSON IdentityUseraddResult where toJSON value = Object (KM.fromList (concat [[("email", toJSON (identityUseraddResultEmail value))], [("identity", toJSON (identityUseraddResultIdentity value))], [("created", toJSON (identityUseraddResultCreated value))], optionalPair "generatedPassword" (identityUseraddResultGeneratedPassword value)]))
