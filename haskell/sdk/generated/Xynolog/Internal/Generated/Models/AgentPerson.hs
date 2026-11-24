-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AgentPerson (AgentPerson (..), AgentPersonU40_type (..), agentPersonU40_typeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data AgentPerson = AgentPerson
  { agentPersonU40_id :: Maybe Text,
    agentPersonU40_type :: AgentPersonU40_type,
    agentPersonEmail :: Maybe Text,
    agentPersonEmailU5f_sha1 :: Maybe Text,
    agentPersonHomepage :: Maybe Text,
    agentPersonName :: Maybe Text,
    agentPersonNickname :: Maybe Text,
    agentPersonAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON AgentPerson where parseJSON = checked "AgentPerson" $ withObject "AgentPerson" (\fields -> AgentPerson <$> optional fields "@id" <*> (fields .: "@type") <*> optional fields "email" <*> optional fields "email_sha1" <*> optional fields "homepage" <*> optional fields "name" <*> optional fields "nickname" <*> traverse parseJSON (withoutFields ["@id", "@type", "email", "email_sha1", "homepage", "name", "nickname"] fields))

instance ToJSON AgentPerson where toJSON value = Object (KM.fromList (concat [optionalPair "@id" (agentPersonU40_id value), [("@type", toJSON (agentPersonU40_type value))], optionalPair "email" (agentPersonEmail value), optionalPair "email_sha1" (agentPersonEmailU5f_sha1 value), optionalPair "homepage" (agentPersonHomepage value), optionalPair "name" (agentPersonName value), optionalPair "nickname" (agentPersonNickname value)]) <> fmap toJSON (withoutFields ["@id", "@type", "email", "email_sha1", "homepage", "name", "nickname"] (agentPersonAdditionalProperties value)))

data AgentPersonU40_type = AgentPersonU40_typePerson deriving (Eq, Show)

instance FromJSON AgentPersonU40_type where parseJSON = checked "AgentPersonU40_type" $ \value -> if value == String "Person" then pure AgentPersonU40_typePerson else fail "unknown enumeration member"

instance ToJSON AgentPersonU40_type where toJSON AgentPersonU40_typePerson = String "Person"

agentPersonU40_typeText :: AgentPersonU40_type -> Text
agentPersonU40_typeText AgentPersonU40_typePerson = "Person"
