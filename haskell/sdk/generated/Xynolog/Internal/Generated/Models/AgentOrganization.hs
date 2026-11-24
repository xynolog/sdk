-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AgentOrganization (AgentOrganization (..), AgentOrganizationU40_type (..), agentOrganizationU40_typeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data AgentOrganization = AgentOrganization
  { agentOrganizationU40_id :: Maybe Text,
    agentOrganizationU40_type :: AgentOrganizationU40_type,
    agentOrganizationHomepage :: Maybe Text,
    agentOrganizationName :: Text,
    agentOrganizationAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON AgentOrganization where parseJSON = checked "AgentOrganization" $ withObject "AgentOrganization" (\fields -> AgentOrganization <$> optional fields "@id" <*> (fields .: "@type") <*> optional fields "homepage" <*> (fields .: "name") <*> traverse parseJSON (withoutFields ["@id", "@type", "homepage", "name"] fields))

instance ToJSON AgentOrganization where toJSON value = Object (KM.fromList (concat [optionalPair "@id" (agentOrganizationU40_id value), [("@type", toJSON (agentOrganizationU40_type value))], optionalPair "homepage" (agentOrganizationHomepage value), [("name", toJSON (agentOrganizationName value))]]) <> fmap toJSON (withoutFields ["@id", "@type", "homepage", "name"] (agentOrganizationAdditionalProperties value)))

data AgentOrganizationU40_type = AgentOrganizationU40_typeOrganization deriving (Eq, Show)

instance FromJSON AgentOrganizationU40_type where parseJSON = checked "AgentOrganizationU40_type" $ \value -> if value == String "Organization" then pure AgentOrganizationU40_typeOrganization else fail "unknown enumeration member"

instance ToJSON AgentOrganizationU40_type where toJSON AgentOrganizationU40_typeOrganization = String "Organization"

agentOrganizationU40_typeText :: AgentOrganizationU40_type -> Text
agentOrganizationU40_typeText AgentOrganizationU40_typeOrganization = "Organization"
