{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Gateway (GatewayOperations (..), gatewayUrl) where

import Data.Aeson (toJSON)
import Data.Text (Text)
import Data.Text qualified as T
import Xynolog.HostName (isValidHostname)
import Xynolog.Internal.Generated.Schemas (schemas)
import Xynolog.Internal.Schema (validateNamed)
import Xynolog.Types

data GatewayOperations = GatewayOperations
  { getCurrentUser :: Maybe Text -> IO UserResponse,
    getMediaToken :: ResourceId -> IO MediaTokenResponse,
    getProtectedResourceMetadata :: IO ProtectedResourceMetadata,
    healthCheck :: IO HealthResponse,
    getStatus :: IO StatusResponse
  }

-- Preserve a numeric-looking host as a name; URL parsers may reinterpret it.
gatewayUrl :: HttpEndpoint -> Either Text Text
gatewayUrl endpoint = do
  either (Left . T.pack) Right (validateNamed schemas "HttpEndpoint" (toJSON endpoint))
  if not (isValidHostname (httpEndpointHost endpoint))
    then Left "invalid gateway hostname"
    else
      Right
        ( httpEndpointProtocolText (httpEndpointProtocol endpoint)
            <> "://"
            <> T.toLower (httpEndpointHost endpoint)
            <> ":"
            <> T.pack (show (httpEndpointPort endpoint))
        )
