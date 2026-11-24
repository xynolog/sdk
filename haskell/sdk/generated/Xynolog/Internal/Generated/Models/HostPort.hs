-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.HostPort (HostPort (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data HostPort = HostPort
  { hostPortHost :: Text,
    hostPortPort :: Integer
  }
  deriving (Eq, Show)

instance FromJSON HostPort where parseJSON = checked "HostPort" $ withObject "HostPort" (\fields -> HostPort <$> (fields .: "host") <*> (fields .: "port"))

instance ToJSON HostPort where toJSON value = Object (KM.fromList (concat [[("host", toJSON (hostPortHost value))], [("port", toJSON (hostPortPort value))]]))
