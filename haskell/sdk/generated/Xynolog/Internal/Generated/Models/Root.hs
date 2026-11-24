-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Root (Root (..), RootCurrent (..), rootCurrentText, RootPlacement (..), rootPlacementText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data Root = Root
  { rootCodespace :: Maybe Text,
    rootCodespaceState :: Maybe Text,
    rootConfig :: Maybe Text,
    rootConfigs :: Maybe [Text],
    rootCurrent :: Maybe RootCurrent,
    rootDid :: Maybe Text,
    rootForwardPort :: Maybe Integer,
    rootForwarded :: Maybe Bool,
    rootIdentityError :: Maybe Text,
    rootLastUsed :: Maybe Text,
    rootPath :: Maybe Text,
    rootPlacement :: RootPlacement,
    rootPresent :: Maybe Bool,
    rootReachable :: Maybe Bool,
    rootRegistered :: Bool,
    rootRepo :: Maybe Text,
    rootRunning :: Bool,
    rootSiteName :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON Root where parseJSON = checked "Root" $ withObject "Root" (\fields -> Root <$> optional fields "codespace" <*> optional fields "codespaceState" <*> optional fields "config" <*> optional fields "configs" <*> optional fields "current" <*> optional fields "did" <*> optional fields "forwardPort" <*> optional fields "forwarded" <*> optional fields "identityError" <*> optional fields "lastUsed" <*> optional fields "path" <*> (fields .: "placement") <*> optional fields "present" <*> optional fields "reachable" <*> (fields .: "registered") <*> optional fields "repo" <*> (fields .: "running") <*> optional fields "siteName")

instance ToJSON Root where toJSON value = Object (KM.fromList (concat [optionalPair "codespace" (rootCodespace value), optionalPair "codespaceState" (rootCodespaceState value), optionalPair "config" (rootConfig value), optionalPair "configs" (rootConfigs value), optionalPair "current" (rootCurrent value), optionalPair "did" (rootDid value), optionalPair "forwardPort" (rootForwardPort value), optionalPair "forwarded" (rootForwarded value), optionalPair "identityError" (rootIdentityError value), optionalPair "lastUsed" (rootLastUsed value), optionalPair "path" (rootPath value), [("placement", toJSON (rootPlacement value))], optionalPair "present" (rootPresent value), optionalPair "reachable" (rootReachable value), [("registered", toJSON (rootRegistered value))], optionalPair "repo" (rootRepo value), [("running", toJSON (rootRunning value))], optionalPair "siteName" (rootSiteName value)]))

data RootCurrent = RootCurrentCwd | RootCurrentXynologU2d_root deriving (Eq, Show)

instance FromJSON RootCurrent where parseJSON = checked "RootCurrent" $ \value -> if value == String "cwd" then pure RootCurrentCwd else if value == String "xynolog-root" then pure RootCurrentXynologU2d_root else fail "unknown enumeration member"

instance ToJSON RootCurrent where
  toJSON RootCurrentCwd = String "cwd"
  toJSON RootCurrentXynologU2d_root = String "xynolog-root"

rootCurrentText :: RootCurrent -> Text
rootCurrentText RootCurrentCwd = "cwd"
rootCurrentText RootCurrentXynologU2d_root = "xynolog-root"

data RootPlacement = RootPlacementLocal | RootPlacementCodespace deriving (Eq, Show)

instance FromJSON RootPlacement where parseJSON = checked "RootPlacement" $ \value -> if value == String "local" then pure RootPlacementLocal else if value == String "codespace" then pure RootPlacementCodespace else fail "unknown enumeration member"

instance ToJSON RootPlacement where
  toJSON RootPlacementLocal = String "local"
  toJSON RootPlacementCodespace = String "codespace"

rootPlacementText :: RootPlacement -> Text
rootPlacementText RootPlacementLocal = "local"
rootPlacementText RootPlacementCodespace = "codespace"
