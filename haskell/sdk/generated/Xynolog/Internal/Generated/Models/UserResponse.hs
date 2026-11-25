-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.UserResponse (UserResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.UserId

data UserResponse = UserResponse
  { userResponseDid :: UserId,
    userResponseDomain :: Text,
    userResponseEmail :: Maybe Text,
    userResponseImage :: Maybe Text,
    userResponseName :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON UserResponse where parseJSON = checked "UserResponse" $ withObject "UserResponse" (\fields -> UserResponse <$> (fields .: "did") <*> (fields .: "domain") <*> (fields .: "email") <*> (fields .: "image") <*> (fields .: "name"))

instance ToJSON UserResponse where toJSON value = Object (KM.fromList (concat [[("did", toJSON (userResponseDid value))], [("domain", toJSON (userResponseDomain value))], [("email", toJSON (userResponseEmail value))], [("image", toJSON (userResponseImage value))], [("name", toJSON (userResponseName value))]]))
