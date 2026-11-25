-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AgentOrganization (AgentOrganization (..), AgentOrganizationType (..), agentOrganizationTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data AgentOrganization = AgentOrganization
  { agentOrganizationType :: AgentOrganizationType,
    agentOrganizationId :: Maybe Text,
    agentOrganizationName :: Text,
    agentOrganizationHomepage :: Maybe Text,
    agentOrganizationAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON AgentOrganization where parseJSON = checked "AgentOrganization" $ withObject "AgentOrganization" (\fields -> AgentOrganization <$> (fields .: "@type") <*> optional fields "@id" <*> (fields .: "name") <*> optional fields "homepage" <*> traverse parseJSON (withoutFields ["@type", "@id", "name", "homepage"] fields))

instance ToJSON AgentOrganization where toJSON value = Object (KM.fromList (concat [[("@type", toJSON (agentOrganizationType value))], optionalPair "@id" (agentOrganizationId value), [("name", toJSON (agentOrganizationName value))], optionalPair "homepage" (agentOrganizationHomepage value)]) <> fmap toJSON (withoutFields ["@type", "@id", "name", "homepage"] (agentOrganizationAdditionalProperties value)))

data AgentOrganizationType = AgentOrganizationTypeOrganization deriving (Eq, Show)

instance FromJSON AgentOrganizationType where parseJSON = checked "AgentOrganizationType" $ \value -> if value == String "Organization" then pure AgentOrganizationTypeOrganization else fail "unknown enumeration member"

instance ToJSON AgentOrganizationType where toJSON AgentOrganizationTypeOrganization = String "Organization"

agentOrganizationTypeText :: AgentOrganizationType -> Text
agentOrganizationTypeText AgentOrganizationTypeOrganization = "Organization"
