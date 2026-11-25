-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.PrincipalProfileCommand (PrincipalProfileCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.UserId

data PrincipalProfileCommand = PrincipalProfileCommand
  { principalProfileCommandUserId :: Maybe UserId,
    principalProfileCommandName :: Text,
    principalProfileCommandAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON PrincipalProfileCommand where parseJSON = checked "PrincipalProfileCommand" $ withObject "PrincipalProfileCommand" (\fields -> PrincipalProfileCommand <$> optional fields "_userId" <*> (fields .: "name") <*> traverse parseJSON (withoutFields ["_userId", "name"] fields))

instance ToJSON PrincipalProfileCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (principalProfileCommandUserId value), [("name", toJSON (principalProfileCommandName value))]]) <> fmap toJSON (withoutFields ["_userId", "name"] (principalProfileCommandAdditionalProperties value)))
