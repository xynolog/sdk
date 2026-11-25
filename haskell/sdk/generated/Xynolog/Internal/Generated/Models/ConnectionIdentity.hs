-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ConnectionIdentity (ConnectionIdentity (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.KbDescription
import Xynolog.Internal.Generated.Models.UserId

data ConnectionIdentity = ConnectionIdentity
  { connectionIdentityDid :: UserId,
    connectionIdentityDescription :: KbDescription
  }
  deriving (Eq, Show)

instance FromJSON ConnectionIdentity where parseJSON = checked "ConnectionIdentity" $ withObject "ConnectionIdentity" (\fields -> ConnectionIdentity <$> (fields .: "did") <*> (fields .: "description"))

instance ToJSON ConnectionIdentity where toJSON value = Object (KM.fromList (concat [[("did", toJSON (connectionIdentityDid value))], [("description", toJSON (connectionIdentityDescription value))]]))
