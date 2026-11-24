-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AgentSoftware (AgentSoftware (..), AgentSoftwareParameters (..), AgentSoftwareU40_type (..), agentSoftwareU40_typeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data AgentSoftware = AgentSoftware
  { agentSoftwareU40_id :: Maybe Text,
    agentSoftwareU40_type :: AgentSoftwareU40_type,
    agentSoftwareModel :: Maybe Text,
    agentSoftwareName :: Maybe Text,
    agentSoftwareParameters :: Maybe AgentSoftwareParameters,
    agentSoftwareProvider :: Maybe Text,
    agentSoftwareAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON AgentSoftware where parseJSON = checked "AgentSoftware" $ withObject "AgentSoftware" (\fields -> AgentSoftware <$> optional fields "@id" <*> (fields .: "@type") <*> optional fields "model" <*> optional fields "name" <*> optional fields "parameters" <*> optional fields "provider" <*> traverse parseJSON (withoutFields ["@id", "@type", "model", "name", "parameters", "provider"] fields))

instance ToJSON AgentSoftware where toJSON value = Object (KM.fromList (concat [optionalPair "@id" (agentSoftwareU40_id value), [("@type", toJSON (agentSoftwareU40_type value))], optionalPair "model" (agentSoftwareModel value), optionalPair "name" (agentSoftwareName value), optionalPair "parameters" (agentSoftwareParameters value), optionalPair "provider" (agentSoftwareProvider value)]) <> fmap toJSON (withoutFields ["@id", "@type", "model", "name", "parameters", "provider"] (agentSoftwareAdditionalProperties value)))

data AgentSoftwareParameters = AgentSoftwareParameters
  { agentSoftwareParametersAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON AgentSoftwareParameters where parseJSON = checked "AgentSoftwareParameters" $ withObject "AgentSoftwareParameters" (\fields -> AgentSoftwareParameters <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON AgentSoftwareParameters where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (agentSoftwareParametersAdditionalProperties value)))

data AgentSoftwareU40_type = AgentSoftwareU40_typeSoftware deriving (Eq, Show)

instance FromJSON AgentSoftwareU40_type where parseJSON = checked "AgentSoftwareU40_type" $ \value -> if value == String "Software" then pure AgentSoftwareU40_typeSoftware else fail "unknown enumeration member"

instance ToJSON AgentSoftwareU40_type where toJSON AgentSoftwareU40_typeSoftware = String "Software"

agentSoftwareU40_typeText :: AgentSoftwareU40_type -> Text
agentSoftwareU40_typeText AgentSoftwareU40_typeSoftware = "Software"
