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
    gatewayResponseHeadersEvery :: [GatewayResponseHeadersEveryItem],
    gatewayResponseHeadersRequestId :: Text,
    gatewayResponseHeadersAbsent :: [Text],
    gatewayResponseHeadersPreflight :: GatewayResponseHeadersPreflight
  }
  deriving (Eq, Show)

instance FromJSON GatewayResponseHeaders where parseJSON = checked "GatewayResponseHeaders" $ withObject "GatewayResponseHeaders" (\fields -> GatewayResponseHeaders <$> (fields .: "$comment") <*> (fields .: "every") <*> (fields .: "requestId") <*> (fields .: "absent") <*> (fields .: "preflight"))

instance ToJSON GatewayResponseHeaders where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (gatewayResponseHeadersComment value))], [("every", toJSON (gatewayResponseHeadersEvery value))], [("requestId", toJSON (gatewayResponseHeadersRequestId value))], [("absent", toJSON (gatewayResponseHeadersAbsent value))], [("preflight", toJSON (gatewayResponseHeadersPreflight value))]]))

data GatewayResponseHeadersEveryItem = GatewayResponseHeadersEveryItem
  { gatewayResponseHeadersEveryItemName :: Text,
    gatewayResponseHeadersEveryItemValue :: Text
  }
  deriving (Eq, Show)

instance FromJSON GatewayResponseHeadersEveryItem where parseJSON = checked "GatewayResponseHeadersEveryItem" $ withObject "GatewayResponseHeadersEveryItem" (\fields -> GatewayResponseHeadersEveryItem <$> (fields .: "name") <*> (fields .: "value"))

instance ToJSON GatewayResponseHeadersEveryItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (gatewayResponseHeadersEveryItemName value))], [("value", toJSON (gatewayResponseHeadersEveryItemValue value))]]))

data GatewayResponseHeadersPreflight = GatewayResponseHeadersPreflight
  { gatewayResponseHeadersPreflightStatus :: HttpStatus,
    gatewayResponseHeadersPreflightHeaders :: [GatewayResponseHeadersPreflightHeadersItem],
    gatewayResponseHeadersPreflightEchoes :: [GatewayResponseHeadersPreflightEchoesItem],
    gatewayResponseHeadersPreflightVary :: Text
  }
  deriving (Eq, Show)

instance FromJSON GatewayResponseHeadersPreflight where parseJSON = checked "GatewayResponseHeadersPreflight" $ withObject "GatewayResponseHeadersPreflight" (\fields -> GatewayResponseHeadersPreflight <$> (fields .: "status") <*> (fields .: "headers") <*> (fields .: "echoes") <*> (fields .: "vary"))

instance ToJSON GatewayResponseHeadersPreflight where toJSON value = Object (KM.fromList (concat [[("status", toJSON (gatewayResponseHeadersPreflightStatus value))], [("headers", toJSON (gatewayResponseHeadersPreflightHeaders value))], [("echoes", toJSON (gatewayResponseHeadersPreflightEchoes value))], [("vary", toJSON (gatewayResponseHeadersPreflightVary value))]]))

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
