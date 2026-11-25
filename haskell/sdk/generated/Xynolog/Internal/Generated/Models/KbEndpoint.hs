-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.KbEndpoint (KbEndpoint (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.HttpEndpoint
import Xynolog.Internal.Generated.Models.LocalEndpoint

data KbEndpoint = KbEndpointHttpEndpoint HttpEndpoint | KbEndpointLocalEndpoint LocalEndpoint deriving (Eq, Show)

instance FromJSON KbEndpoint where parseJSON = checked "KbEndpoint" $ \value -> readMember "KbEndpoint" [([Signature {signatureKind = ObjectKind, signatureRequired = ["kind", "host", "port", "protocol"], signatureAllowed = Nothing, signatureFixed = [("kind", [String "http"]), ("protocol", [String "http", String "https"])], signaturePattern = Nothing, signatureValues = Nothing}], KbEndpointHttpEndpoint <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["kind", "kbId"], signatureAllowed = Nothing, signatureFixed = [("kind", [String "local"])], signaturePattern = Nothing, signatureValues = Nothing}], KbEndpointLocalEndpoint <$> parseJSON value)] value

instance ToJSON KbEndpoint where
  toJSON (KbEndpointHttpEndpoint value) = toJSON value
  toJSON (KbEndpointLocalEndpoint value) = toJSON value
