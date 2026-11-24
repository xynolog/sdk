-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ProtectedResourceMetadata (ProtectedResourceMetadata (..), ProtectedResourceMetadataBearerU5f_methodsU5f_supportedItem (..), protectedResourceMetadataBearerU5f_methodsU5f_supportedItemText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ProtectedResourceMetadata = ProtectedResourceMetadata
  { protectedResourceMetadataAuthorizationU5f_servers :: [Text],
    protectedResourceMetadataBearerU5f_methodsU5f_supported :: [ProtectedResourceMetadataBearerU5f_methodsU5f_supportedItem],
    protectedResourceMetadataResource :: Text,
    protectedResourceMetadataResourceU5f_name :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ProtectedResourceMetadata where parseJSON = checked "ProtectedResourceMetadata" $ withObject "ProtectedResourceMetadata" (\fields -> ProtectedResourceMetadata <$> (fields .: "authorization_servers") <*> (fields .: "bearer_methods_supported") <*> (fields .: "resource") <*> optional fields "resource_name")

instance ToJSON ProtectedResourceMetadata where toJSON value = Object (KM.fromList (concat [[("authorization_servers", toJSON (protectedResourceMetadataAuthorizationU5f_servers value))], [("bearer_methods_supported", toJSON (protectedResourceMetadataBearerU5f_methodsU5f_supported value))], [("resource", toJSON (protectedResourceMetadataResource value))], optionalPair "resource_name" (protectedResourceMetadataResourceU5f_name value)]))

data ProtectedResourceMetadataBearerU5f_methodsU5f_supportedItem = ProtectedResourceMetadataBearerU5f_methodsU5f_supportedItemHeader deriving (Eq, Show)

instance FromJSON ProtectedResourceMetadataBearerU5f_methodsU5f_supportedItem where parseJSON = checked "ProtectedResourceMetadataBearerU5f_methodsU5f_supportedItem" $ \value -> if value == String "header" then pure ProtectedResourceMetadataBearerU5f_methodsU5f_supportedItemHeader else fail "unknown enumeration member"

instance ToJSON ProtectedResourceMetadataBearerU5f_methodsU5f_supportedItem where toJSON ProtectedResourceMetadataBearerU5f_methodsU5f_supportedItemHeader = String "header"

protectedResourceMetadataBearerU5f_methodsU5f_supportedItemText :: ProtectedResourceMetadataBearerU5f_methodsU5f_supportedItem -> Text
protectedResourceMetadataBearerU5f_methodsU5f_supportedItemText ProtectedResourceMetadataBearerU5f_methodsU5f_supportedItemHeader = "header"
