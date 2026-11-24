-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SecretRef (SecretRef (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data SecretRef = SecretRef
  { secretRefFromEnv :: Text
  }
  deriving (Eq, Show)

instance FromJSON SecretRef where parseJSON = checked "SecretRef" $ withObject "SecretRef" (\fields -> SecretRef <$> (fields .: "fromEnv"))

instance ToJSON SecretRef where toJSON value = Object (KM.fromList (concat [[("fromEnv", toJSON (secretRefFromEnv value))]]))
