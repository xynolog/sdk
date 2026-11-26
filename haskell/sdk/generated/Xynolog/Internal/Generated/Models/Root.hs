-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Root (Root (..), RootCurrent (..), rootCurrentText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.DiscoveredKB

data Root = Root
  { rootPlacement :: DiscoveredKBPlacement,
    rootPath :: Maybe Text,
    rootPresent :: Maybe Bool,
    rootCurrent :: Maybe RootCurrent,
    rootRegistered :: Bool,
    rootRunning :: Bool,
    rootLastUsed :: Maybe Text,
    rootDid :: Maybe Text,
    rootSiteName :: Maybe Text,
    rootIdentityError :: Maybe Text,
    rootConfig :: Maybe Text,
    rootConfigs :: Maybe [Text],
    rootRepo :: Maybe Text,
    rootCodespace :: Maybe Text,
    rootCodespaceState :: Maybe Text,
    rootForwardPort :: Maybe Integer,
    rootForwarded :: Maybe Bool,
    rootReachable :: Maybe Bool
  }
  deriving (Eq, Show)

instance FromJSON Root where parseJSON = checked "Root" $ withObject "Root" (\fields -> Root <$> (fields .: "placement") <*> optional fields "path" <*> optional fields "present" <*> optional fields "current" <*> (fields .: "registered") <*> (fields .: "running") <*> optional fields "lastUsed" <*> optional fields "did" <*> optional fields "siteName" <*> optional fields "identityError" <*> optional fields "config" <*> optional fields "configs" <*> optional fields "repo" <*> optional fields "codespace" <*> optional fields "codespaceState" <*> optional fields "forwardPort" <*> optional fields "forwarded" <*> optional fields "reachable")

instance ToJSON Root where toJSON value = Object (KM.fromList (concat [[("placement", toJSON (rootPlacement value))], optionalPair "path" (rootPath value), optionalPair "present" (rootPresent value), optionalPair "current" (rootCurrent value), [("registered", toJSON (rootRegistered value))], [("running", toJSON (rootRunning value))], optionalPair "lastUsed" (rootLastUsed value), optionalPair "did" (rootDid value), optionalPair "siteName" (rootSiteName value), optionalPair "identityError" (rootIdentityError value), optionalPair "config" (rootConfig value), optionalPair "configs" (rootConfigs value), optionalPair "repo" (rootRepo value), optionalPair "codespace" (rootCodespace value), optionalPair "codespaceState" (rootCodespaceState value), optionalPair "forwardPort" (rootForwardPort value), optionalPair "forwarded" (rootForwarded value), optionalPair "reachable" (rootReachable value)]))

data RootCurrent = RootCurrentCwd | RootCurrentXynologRoot deriving (Eq, Show)

instance FromJSON RootCurrent where parseJSON = checked "RootCurrent" $ \value -> if value == String "cwd" then pure RootCurrentCwd else if value == String "xynolog-root" then pure RootCurrentXynologRoot else fail "unknown enumeration member"

instance ToJSON RootCurrent where
  toJSON RootCurrentCwd = String "cwd"
  toJSON RootCurrentXynologRoot = String "xynolog-root"

rootCurrentText :: RootCurrent -> Text
rootCurrentText RootCurrentCwd = "cwd"
rootCurrentText RootCurrentXynologRoot = "xynolog-root"
