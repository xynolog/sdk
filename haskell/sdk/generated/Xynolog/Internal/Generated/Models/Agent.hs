-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Agent (Agent (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AgentOrganization
import Xynolog.Internal.Generated.Models.AgentPerson
import Xynolog.Internal.Generated.Models.AgentSoftware

data Agent = AgentAgentPerson AgentPerson | AgentAgentOrganization AgentOrganization | AgentAgentSoftware AgentSoftware deriving (Eq, Show)

instance FromJSON Agent where parseJSON = checked "Agent" $ \value -> (AgentAgentPerson <$> parseJSON value) <|> (AgentAgentOrganization <$> parseJSON value) <|> (AgentAgentSoftware <$> parseJSON value)

instance ToJSON Agent where
  toJSON (AgentAgentPerson value) = toJSON value
  toJSON (AgentAgentOrganization value) = toJSON value
  toJSON (AgentAgentSoftware value) = toJSON value
