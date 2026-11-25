-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AgentOrganization (AgentOrganization (..), AgentOrganizationType (..), agentOrganizationTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data AgentOrganization = AgentOrganization
  { agentOrganizationId :: Maybe Text,
    agentOrganizationType :: AgentOrganizationType,
    agentOrganizationHomepage :: Maybe Text,
    agentOrganizationName :: Text,
    agentOrganizationAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON AgentOrganization where parseJSON = checked "AgentOrganization" $ withObject "AgentOrganization" (\fields -> AgentOrganization <$> optional fields "@id" <*> (fields .: "@type") <*> optional fields "homepage" <*> (fields .: "name") <*> traverse parseJSON (withoutFields ["@id", "@type", "homepage", "name"] fields))

instance ToJSON AgentOrganization where toJSON value = Object (KM.fromList (concat [optionalPair "@id" (agentOrganizationId value), [("@type", toJSON (agentOrganizationType value))], optionalPair "homepage" (agentOrganizationHomepage value), [("name", toJSON (agentOrganizationName value))]]) <> fmap toJSON (withoutFields ["@id", "@type", "homepage", "name"] (agentOrganizationAdditionalProperties value)))

data AgentOrganizationType = AgentOrganizationTypeOrganization deriving (Eq, Show)

instance FromJSON AgentOrganizationType where parseJSON = checked "AgentOrganizationType" $ \value -> if value == String "Organization" then pure AgentOrganizationTypeOrganization else fail "unknown enumeration member"

instance ToJSON AgentOrganizationType where toJSON AgentOrganizationTypeOrganization = String "Organization"

agentOrganizationTypeText :: AgentOrganizationType -> Text
agentOrganizationTypeText AgentOrganizationTypeOrganization = "Organization"
