-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AgentSoftware (AgentSoftware (..), AgentSoftwareParameters (..), AgentSoftwareType (..), agentSoftwareTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data AgentSoftware = AgentSoftware
  { agentSoftwareId :: Maybe Text,
    agentSoftwareType :: AgentSoftwareType,
    agentSoftwareModel :: Maybe Text,
    agentSoftwareName :: Maybe Text,
    agentSoftwareParameters :: Maybe AgentSoftwareParameters,
    agentSoftwareProvider :: Maybe Text,
    agentSoftwareAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON AgentSoftware where parseJSON = checked "AgentSoftware" $ withObject "AgentSoftware" (\fields -> AgentSoftware <$> optional fields "@id" <*> (fields .: "@type") <*> optional fields "model" <*> optional fields "name" <*> optional fields "parameters" <*> optional fields "provider" <*> traverse parseJSON (withoutFields ["@id", "@type", "model", "name", "parameters", "provider"] fields))

instance ToJSON AgentSoftware where toJSON value = Object (KM.fromList (concat [optionalPair "@id" (agentSoftwareId value), [("@type", toJSON (agentSoftwareType value))], optionalPair "model" (agentSoftwareModel value), optionalPair "name" (agentSoftwareName value), optionalPair "parameters" (agentSoftwareParameters value), optionalPair "provider" (agentSoftwareProvider value)]) <> fmap toJSON (withoutFields ["@id", "@type", "model", "name", "parameters", "provider"] (agentSoftwareAdditionalProperties value)))

data AgentSoftwareParameters = AgentSoftwareParameters
  { agentSoftwareParametersAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON AgentSoftwareParameters where parseJSON = checked "AgentSoftwareParameters" $ withObject "AgentSoftwareParameters" (\fields -> AgentSoftwareParameters <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON AgentSoftwareParameters where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (agentSoftwareParametersAdditionalProperties value)))

data AgentSoftwareType = AgentSoftwareTypeSoftware deriving (Eq, Show)

instance FromJSON AgentSoftwareType where parseJSON = checked "AgentSoftwareType" $ \value -> if value == String "Software" then pure AgentSoftwareTypeSoftware else fail "unknown enumeration member"

instance ToJSON AgentSoftwareType where toJSON AgentSoftwareTypeSoftware = String "Software"

agentSoftwareTypeText :: AgentSoftwareType -> Text
agentSoftwareTypeText AgentSoftwareTypeSoftware = "Software"
