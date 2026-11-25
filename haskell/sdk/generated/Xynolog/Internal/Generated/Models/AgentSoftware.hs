-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AgentSoftware (AgentSoftware (..), AgentSoftwareParameters (..), AgentSoftwareType (..), agentSoftwareTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data AgentSoftware = AgentSoftware
  { agentSoftwareType :: AgentSoftwareType,
    agentSoftwareId :: Maybe Text,
    agentSoftwareName :: Maybe Text,
    agentSoftwareProvider :: Maybe Text,
    agentSoftwareModel :: Maybe Text,
    agentSoftwareParameters :: Maybe AgentSoftwareParameters,
    agentSoftwareAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON AgentSoftware where parseJSON = checked "AgentSoftware" $ withObject "AgentSoftware" (\fields -> AgentSoftware <$> (fields .: "@type") <*> optional fields "@id" <*> optional fields "name" <*> optional fields "provider" <*> optional fields "model" <*> optional fields "parameters" <*> traverse parseJSON (withoutFields ["@type", "@id", "name", "provider", "model", "parameters"] fields))

instance ToJSON AgentSoftware where toJSON value = Object (KM.fromList (concat [[("@type", toJSON (agentSoftwareType value))], optionalPair "@id" (agentSoftwareId value), optionalPair "name" (agentSoftwareName value), optionalPair "provider" (agentSoftwareProvider value), optionalPair "model" (agentSoftwareModel value), optionalPair "parameters" (agentSoftwareParameters value)]) <> fmap toJSON (withoutFields ["@type", "@id", "name", "provider", "model", "parameters"] (agentSoftwareAdditionalProperties value)))

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
