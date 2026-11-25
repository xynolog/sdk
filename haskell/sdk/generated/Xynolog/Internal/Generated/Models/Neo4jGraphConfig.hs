-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Neo4jGraphConfig (Neo4jGraphConfig (..), Neo4jGraphConfigType (..), neo4jGraphConfigTypeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data Neo4jGraphConfig = Neo4jGraphConfig
  { neo4jGraphConfigType :: Neo4jGraphConfigType,
    neo4jGraphConfigUri :: Text,
    neo4jGraphConfigUsername :: Text,
    neo4jGraphConfigPasswordEnv :: Text,
    neo4jGraphConfigDatabase :: Text
  }
  deriving (Eq, Show)

instance FromJSON Neo4jGraphConfig where parseJSON = checked "Neo4jGraphConfig" $ withObject "Neo4jGraphConfig" (\fields -> Neo4jGraphConfig <$> (fields .: "type") <*> (fields .: "uri") <*> (fields .: "username") <*> (fields .: "passwordEnv") <*> (fields .: "database"))

instance ToJSON Neo4jGraphConfig where toJSON value = Object (KM.fromList (concat [[("type", toJSON (neo4jGraphConfigType value))], [("uri", toJSON (neo4jGraphConfigUri value))], [("username", toJSON (neo4jGraphConfigUsername value))], [("passwordEnv", toJSON (neo4jGraphConfigPasswordEnv value))], [("database", toJSON (neo4jGraphConfigDatabase value))]]))

data Neo4jGraphConfigType = Neo4jGraphConfigTypeNeo4j deriving (Eq, Show)

instance FromJSON Neo4jGraphConfigType where parseJSON = checked "Neo4jGraphConfigType" $ \value -> if value == String "neo4j" then pure Neo4jGraphConfigTypeNeo4j else fail "unknown enumeration member"

instance ToJSON Neo4jGraphConfigType where toJSON Neo4jGraphConfigTypeNeo4j = String "neo4j"

neo4jGraphConfigTypeText :: Neo4jGraphConfigType -> Text
neo4jGraphConfigTypeText Neo4jGraphConfigTypeNeo4j = "neo4j"
