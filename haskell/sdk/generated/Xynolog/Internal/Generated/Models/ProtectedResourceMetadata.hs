-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ProtectedResourceMetadata (ProtectedResourceMetadata (..), ProtectedResourceMetadataBearerMethodsSupportedItem (..), protectedResourceMetadataBearerMethodsSupportedItemText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ProtectedResourceMetadata = ProtectedResourceMetadata
  { protectedResourceMetadataAuthorizationServers :: [Text],
    protectedResourceMetadataBearerMethodsSupported :: [ProtectedResourceMetadataBearerMethodsSupportedItem],
    protectedResourceMetadataResource :: Text,
    protectedResourceMetadataResourceName :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ProtectedResourceMetadata where parseJSON = checked "ProtectedResourceMetadata" $ withObject "ProtectedResourceMetadata" (\fields -> ProtectedResourceMetadata <$> (fields .: "authorization_servers") <*> (fields .: "bearer_methods_supported") <*> (fields .: "resource") <*> optional fields "resource_name")

instance ToJSON ProtectedResourceMetadata where toJSON value = Object (KM.fromList (concat [[("authorization_servers", toJSON (protectedResourceMetadataAuthorizationServers value))], [("bearer_methods_supported", toJSON (protectedResourceMetadataBearerMethodsSupported value))], [("resource", toJSON (protectedResourceMetadataResource value))], optionalPair "resource_name" (protectedResourceMetadataResourceName value)]))

data ProtectedResourceMetadataBearerMethodsSupportedItem = ProtectedResourceMetadataBearerMethodsSupportedItemHeader deriving (Eq, Show)

instance FromJSON ProtectedResourceMetadataBearerMethodsSupportedItem where parseJSON = checked "ProtectedResourceMetadataBearerMethodsSupportedItem" $ \value -> if value == String "header" then pure ProtectedResourceMetadataBearerMethodsSupportedItemHeader else fail "unknown enumeration member"

instance ToJSON ProtectedResourceMetadataBearerMethodsSupportedItem where toJSON ProtectedResourceMetadataBearerMethodsSupportedItemHeader = String "header"

protectedResourceMetadataBearerMethodsSupportedItemText :: ProtectedResourceMetadataBearerMethodsSupportedItem -> Text
protectedResourceMetadataBearerMethodsSupportedItemText ProtectedResourceMetadataBearerMethodsSupportedItemHeader = "header"
