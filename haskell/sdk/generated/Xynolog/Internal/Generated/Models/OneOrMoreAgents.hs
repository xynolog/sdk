-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.OneOrMoreAgents (OneOrMoreAgents (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Agent

data OneOrMoreAgents = OneOrMoreAgentsAgent Agent | OneOrMoreAgentsList [Agent] deriving (Eq, Show)

instance FromJSON OneOrMoreAgents where parseJSON = checked "OneOrMoreAgents" $ \value -> readMember "OneOrMoreAgents" [([Signature {signatureKind = ObjectKind, signatureRequired = ["@type"], signatureAllowed = Nothing, signatureFixed = [("@type", [String "Person"])], signaturePattern = Nothing, signatureValues = Nothing}, Signature {signatureKind = ObjectKind, signatureRequired = ["@type", "name"], signatureAllowed = Nothing, signatureFixed = [("@type", [String "Organization"])], signaturePattern = Nothing, signatureValues = Nothing}, Signature {signatureKind = ObjectKind, signatureRequired = ["@type"], signatureAllowed = Nothing, signatureFixed = [("@type", [String "Software"])], signaturePattern = Nothing, signatureValues = Nothing}], OneOrMoreAgentsAgent <$> parseJSON value), ([Signature {signatureKind = ListKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], OneOrMoreAgentsList <$> parseJSON value)] value

instance ToJSON OneOrMoreAgents where
  toJSON (OneOrMoreAgentsAgent value) = toJSON value
  toJSON (OneOrMoreAgentsList value) = toJSON value
