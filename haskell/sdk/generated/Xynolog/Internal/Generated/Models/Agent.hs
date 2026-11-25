-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Agent (Agent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AgentOrganization
import Xynolog.Internal.Generated.Models.AgentPerson
import Xynolog.Internal.Generated.Models.AgentSoftware

data Agent = AgentAgentPerson AgentPerson | AgentAgentOrganization AgentOrganization | AgentAgentSoftware AgentSoftware deriving (Eq, Show)

instance FromJSON Agent where parseJSON = checked "Agent" $ \value -> readMember "Agent" [([Signature {signatureKind = ObjectKind, signatureRequired = ["@type"], signatureAllowed = Nothing, signatureFixed = [("@type", [String "Person"])], signaturePattern = Nothing, signatureValues = Nothing}], AgentAgentPerson <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["@type", "name"], signatureAllowed = Nothing, signatureFixed = [("@type", [String "Organization"])], signaturePattern = Nothing, signatureValues = Nothing}], AgentAgentOrganization <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["@type"], signatureAllowed = Nothing, signatureFixed = [("@type", [String "Software"])], signaturePattern = Nothing, signatureValues = Nothing}], AgentAgentSoftware <$> parseJSON value)] value

instance ToJSON Agent where
  toJSON (AgentAgentPerson value) = toJSON value
  toJSON (AgentAgentOrganization value) = toJSON value
  toJSON (AgentAgentSoftware value) = toJSON value
