-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.IdentityUsersListParams (IdentityUsersListParams (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ApiVersion
import Xynolog.Internal.Generated.Models.LocalTarget

data IdentityUsersListParams = IdentityUsersListParams
  { identityUsersListParamsApiVersion :: ApiVersion,
    identityUsersListParamsTarget :: LocalTarget
  }
  deriving (Eq, Show)

instance FromJSON IdentityUsersListParams where parseJSON = checked "IdentityUsersListParams" $ withObject "IdentityUsersListParams" (\fields -> IdentityUsersListParams <$> (fields .: "apiVersion") <*> (fields .: "target"))

instance ToJSON IdentityUsersListParams where toJSON value = Object (KM.fromList (concat [[("apiVersion", toJSON (identityUsersListParamsApiVersion value))], [("target", toJSON (identityUsersListParamsTarget value))]]))
