-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatewayResponseHeaders (GatewayResponseHeaders (..), GatewayResponseHeadersEveryItem (..), GatewayResponseHeadersPreflight (..), GatewayResponseHeadersPreflightEchoesItem (..), GatewayResponseHeadersPreflightHeadersItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.HttpStatus

data GatewayResponseHeaders = GatewayResponseHeaders
  { gatewayResponseHeadersComment :: Text,
    gatewayResponseHeadersAbsent :: [Text],
    gatewayResponseHeadersEvery :: [GatewayResponseHeadersEveryItem],
    gatewayResponseHeadersPreflight :: GatewayResponseHeadersPreflight,
    gatewayResponseHeadersRequestId :: Text
  }
  deriving (Eq, Show)

instance FromJSON GatewayResponseHeaders where parseJSON = checked "GatewayResponseHeaders" $ withObject "GatewayResponseHeaders" (\fields -> GatewayResponseHeaders <$> (fields .: "$comment") <*> (fields .: "absent") <*> (fields .: "every") <*> (fields .: "preflight") <*> (fields .: "requestId"))

instance ToJSON GatewayResponseHeaders where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (gatewayResponseHeadersComment value))], [("absent", toJSON (gatewayResponseHeadersAbsent value))], [("every", toJSON (gatewayResponseHeadersEvery value))], [("preflight", toJSON (gatewayResponseHeadersPreflight value))], [("requestId", toJSON (gatewayResponseHeadersRequestId value))]]))

data GatewayResponseHeadersEveryItem = GatewayResponseHeadersEveryItem
  { gatewayResponseHeadersEveryItemName :: Text,
    gatewayResponseHeadersEveryItemValue :: Text
  }
  deriving (Eq, Show)

instance FromJSON GatewayResponseHeadersEveryItem where parseJSON = checked "GatewayResponseHeadersEveryItem" $ withObject "GatewayResponseHeadersEveryItem" (\fields -> GatewayResponseHeadersEveryItem <$> (fields .: "name") <*> (fields .: "value"))

instance ToJSON GatewayResponseHeadersEveryItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (gatewayResponseHeadersEveryItemName value))], [("value", toJSON (gatewayResponseHeadersEveryItemValue value))]]))

data GatewayResponseHeadersPreflight = GatewayResponseHeadersPreflight
  { gatewayResponseHeadersPreflightEchoes :: [GatewayResponseHeadersPreflightEchoesItem],
    gatewayResponseHeadersPreflightHeaders :: [GatewayResponseHeadersPreflightHeadersItem],
    gatewayResponseHeadersPreflightStatus :: HttpStatus,
    gatewayResponseHeadersPreflightVary :: Text
  }
  deriving (Eq, Show)

instance FromJSON GatewayResponseHeadersPreflight where parseJSON = checked "GatewayResponseHeadersPreflight" $ withObject "GatewayResponseHeadersPreflight" (\fields -> GatewayResponseHeadersPreflight <$> (fields .: "echoes") <*> (fields .: "headers") <*> (fields .: "status") <*> (fields .: "vary"))

instance ToJSON GatewayResponseHeadersPreflight where toJSON value = Object (KM.fromList (concat [[("echoes", toJSON (gatewayResponseHeadersPreflightEchoes value))], [("headers", toJSON (gatewayResponseHeadersPreflightHeaders value))], [("status", toJSON (gatewayResponseHeadersPreflightStatus value))], [("vary", toJSON (gatewayResponseHeadersPreflightVary value))]]))

data GatewayResponseHeadersPreflightEchoesItem = GatewayResponseHeadersPreflightEchoesItem
  { gatewayResponseHeadersPreflightEchoesItemName :: Text,
    gatewayResponseHeadersPreflightEchoesItemOf :: Text
  }
  deriving (Eq, Show)

instance FromJSON GatewayResponseHeadersPreflightEchoesItem where parseJSON = checked "GatewayResponseHeadersPreflightEchoesItem" $ withObject "GatewayResponseHeadersPreflightEchoesItem" (\fields -> GatewayResponseHeadersPreflightEchoesItem <$> (fields .: "name") <*> (fields .: "of"))

instance ToJSON GatewayResponseHeadersPreflightEchoesItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (gatewayResponseHeadersPreflightEchoesItemName value))], [("of", toJSON (gatewayResponseHeadersPreflightEchoesItemOf value))]]))

data GatewayResponseHeadersPreflightHeadersItem = GatewayResponseHeadersPreflightHeadersItem
  { gatewayResponseHeadersPreflightHeadersItemName :: Text,
    gatewayResponseHeadersPreflightHeadersItemValue :: Text
  }
  deriving (Eq, Show)

instance FromJSON GatewayResponseHeadersPreflightHeadersItem where parseJSON = checked "GatewayResponseHeadersPreflightHeadersItem" $ withObject "GatewayResponseHeadersPreflightHeadersItem" (\fields -> GatewayResponseHeadersPreflightHeadersItem <$> (fields .: "name") <*> (fields .: "value"))

instance ToJSON GatewayResponseHeadersPreflightHeadersItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (gatewayResponseHeadersPreflightHeadersItemName value))], [("value", toJSON (gatewayResponseHeadersPreflightHeadersItemValue value))]]))
