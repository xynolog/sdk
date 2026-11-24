-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.IdentityUsersListResult (IdentityUsersListResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.IdentityUser

data IdentityUsersListResult = IdentityUsersListResult
  { identityUsersListResultUsers :: [IdentityUser]
  }
  deriving (Eq, Show)

instance FromJSON IdentityUsersListResult where parseJSON = checked "IdentityUsersListResult" $ withObject "IdentityUsersListResult" (\fields -> IdentityUsersListResult <$> (fields .: "users"))

instance ToJSON IdentityUsersListResult where toJSON value = Object (KM.fromList (concat [[("users", toJSON (identityUsersListResultUsers value))]]))
