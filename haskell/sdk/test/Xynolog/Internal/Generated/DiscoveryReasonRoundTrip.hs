-- Generated from protocol/specs/src/client/discovery-absent.json and protocol/specs/src/client/surface.json; do not edit.
-- Regenerate: make generate (codegen/lib/error_codes/haskell.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.DiscoveryReasonRoundTrip (roundTripError) where

import Data.Aeson (Value, parseJSON, toJSON)
import Data.Aeson.Types (parseEither)
import Data.Text (Text)
import Xynolog.Discovery.Reasons

roundTripError :: Text -> Value -> Either String Value
roundTripError family value = case family of
  "discoveryAbsent" -> toJSON <$> (parseEither parseJSON value :: Either String DiscoveryAbsentCode)
  _ -> Left "unknown error-code family"
