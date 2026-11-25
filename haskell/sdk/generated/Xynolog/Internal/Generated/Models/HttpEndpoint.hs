-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.HttpEndpoint (HttpEndpoint (..), HttpEndpointKind (..), httpEndpointKindText, HttpEndpointProtocol (..), httpEndpointProtocolText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data HttpEndpoint = HttpEndpoint
  { httpEndpointHost :: Text,
    httpEndpointKind :: HttpEndpointKind,
    httpEndpointPort :: Integer,
    httpEndpointProtocol :: HttpEndpointProtocol
  }
  deriving (Eq, Show)

instance FromJSON HttpEndpoint where parseJSON = checked "HttpEndpoint" $ withObject "HttpEndpoint" (\fields -> HttpEndpoint <$> (fields .: "host") <*> (fields .: "kind") <*> (fields .: "port") <*> (fields .: "protocol"))

instance ToJSON HttpEndpoint where toJSON value = Object (KM.fromList (concat [[("host", toJSON (httpEndpointHost value))], [("kind", toJSON (httpEndpointKind value))], [("port", toJSON (httpEndpointPort value))], [("protocol", toJSON (httpEndpointProtocol value))]]))

data HttpEndpointKind = HttpEndpointKindHttp deriving (Eq, Show)

instance FromJSON HttpEndpointKind where parseJSON = checked "HttpEndpointKind" $ \value -> if value == String "http" then pure HttpEndpointKindHttp else fail "unknown enumeration member"

instance ToJSON HttpEndpointKind where toJSON HttpEndpointKindHttp = String "http"

httpEndpointKindText :: HttpEndpointKind -> Text
httpEndpointKindText HttpEndpointKindHttp = "http"

data HttpEndpointProtocol = HttpEndpointProtocolHttp | HttpEndpointProtocolHttps deriving (Eq, Show)

instance FromJSON HttpEndpointProtocol where parseJSON = checked "HttpEndpointProtocol" $ \value -> if value == String "http" then pure HttpEndpointProtocolHttp else if value == String "https" then pure HttpEndpointProtocolHttps else fail "unknown enumeration member"

instance ToJSON HttpEndpointProtocol where
  toJSON HttpEndpointProtocolHttp = String "http"
  toJSON HttpEndpointProtocolHttps = String "https"

httpEndpointProtocolText :: HttpEndpointProtocol -> Text
httpEndpointProtocolText HttpEndpointProtocolHttp = "http"
httpEndpointProtocolText HttpEndpointProtocolHttps = "https"
