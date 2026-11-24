-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.OneOrMoreAgents (OneOrMoreAgents (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Agent

data OneOrMoreAgents = OneOrMoreAgentsAgent Agent | OneOrMoreAgentsList [Agent] deriving (Eq, Show)

instance FromJSON OneOrMoreAgents where parseJSON = checked "OneOrMoreAgents" $ \value -> (OneOrMoreAgentsAgent <$> parseJSON value) <|> (OneOrMoreAgentsList <$> parseJSON value)

instance ToJSON OneOrMoreAgents where
  toJSON (OneOrMoreAgentsAgent value) = toJSON value
  toJSON (OneOrMoreAgentsList value) = toJSON value
