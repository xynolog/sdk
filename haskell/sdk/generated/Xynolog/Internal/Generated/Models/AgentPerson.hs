-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AgentPerson (AgentPerson (..), AgentPersonType (..), agentPersonTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data AgentPerson = AgentPerson
  { agentPersonId :: Maybe Text,
    agentPersonType :: AgentPersonType,
    agentPersonEmail :: Maybe Text,
    agentPersonEmailSha1 :: Maybe Text,
    agentPersonHomepage :: Maybe Text,
    agentPersonName :: Maybe Text,
    agentPersonNickname :: Maybe Text,
    agentPersonAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON AgentPerson where parseJSON = checked "AgentPerson" $ withObject "AgentPerson" (\fields -> AgentPerson <$> optional fields "@id" <*> (fields .: "@type") <*> optional fields "email" <*> optional fields "email_sha1" <*> optional fields "homepage" <*> optional fields "name" <*> optional fields "nickname" <*> traverse parseJSON (withoutFields ["@id", "@type", "email", "email_sha1", "homepage", "name", "nickname"] fields))

instance ToJSON AgentPerson where toJSON value = Object (KM.fromList (concat [optionalPair "@id" (agentPersonId value), [("@type", toJSON (agentPersonType value))], optionalPair "email" (agentPersonEmail value), optionalPair "email_sha1" (agentPersonEmailSha1 value), optionalPair "homepage" (agentPersonHomepage value), optionalPair "name" (agentPersonName value), optionalPair "nickname" (agentPersonNickname value)]) <> fmap toJSON (withoutFields ["@id", "@type", "email", "email_sha1", "homepage", "name", "nickname"] (agentPersonAdditionalProperties value)))

data AgentPersonType = AgentPersonTypePerson deriving (Eq, Show)

instance FromJSON AgentPersonType where parseJSON = checked "AgentPersonType" $ \value -> if value == String "Person" then pure AgentPersonTypePerson else fail "unknown enumeration member"

instance ToJSON AgentPersonType where toJSON AgentPersonTypePerson = String "Person"

agentPersonTypeText :: AgentPersonType -> Text
agentPersonTypeText AgentPersonTypePerson = "Person"
