-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ServiceStatus (ServiceStatus (..), ServiceStatusState (..), serviceStatusStateText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ServiceGroup

data ServiceStatus = ServiceStatus
  { serviceStatusContainerState :: Maybe Text,
    serviceStatusCounted :: Bool,
    serviceStatusGroup :: ServiceGroup,
    serviceStatusHealthy :: Bool,
    serviceStatusPage :: Maybe Text,
    serviceStatusProbe :: Maybe Text,
    serviceStatusProduct :: Maybe Text,
    serviceStatusRealm :: Maybe Text,
    serviceStatusRole :: Text,
    serviceStatusRunsOn :: Maybe Text,
    serviceStatusServes :: Maybe [Text],
    serviceStatusState :: ServiceStatusState
  }
  deriving (Eq, Show)

instance FromJSON ServiceStatus where parseJSON = checked "ServiceStatus" $ withObject "ServiceStatus" (\fields -> ServiceStatus <$> optional fields "containerState" <*> (fields .: "counted") <*> (fields .: "group") <*> (fields .: "healthy") <*> optional fields "page" <*> optional fields "probe" <*> optional fields "product" <*> optional fields "realm" <*> (fields .: "role") <*> optional fields "runsOn" <*> optional fields "serves" <*> (fields .: "state"))

instance ToJSON ServiceStatus where toJSON value = Object (KM.fromList (concat [optionalPair "containerState" (serviceStatusContainerState value), [("counted", toJSON (serviceStatusCounted value))], [("group", toJSON (serviceStatusGroup value))], [("healthy", toJSON (serviceStatusHealthy value))], optionalPair "page" (serviceStatusPage value), optionalPair "probe" (serviceStatusProbe value), optionalPair "product" (serviceStatusProduct value), optionalPair "realm" (serviceStatusRealm value), [("role", toJSON (serviceStatusRole value))], optionalPair "runsOn" (serviceStatusRunsOn value), optionalPair "serves" (serviceStatusServes value), [("state", toJSON (serviceStatusState value))]]))

data ServiceStatusState = ServiceStatusStateRunning | ServiceStatusStateStopped | ServiceStatusStateReachable | ServiceStatusStateUnreachable | ServiceStatusStateAbsent | ServiceStatusStateNotConfigured deriving (Eq, Show)

instance FromJSON ServiceStatusState where parseJSON = checked "ServiceStatusState" $ \value -> if value == String "running" then pure ServiceStatusStateRunning else if value == String "stopped" then pure ServiceStatusStateStopped else if value == String "reachable" then pure ServiceStatusStateReachable else if value == String "unreachable" then pure ServiceStatusStateUnreachable else if value == String "absent" then pure ServiceStatusStateAbsent else if value == String "not-configured" then pure ServiceStatusStateNotConfigured else fail "unknown enumeration member"

instance ToJSON ServiceStatusState where
  toJSON ServiceStatusStateRunning = String "running"
  toJSON ServiceStatusStateStopped = String "stopped"
  toJSON ServiceStatusStateReachable = String "reachable"
  toJSON ServiceStatusStateUnreachable = String "unreachable"
  toJSON ServiceStatusStateAbsent = String "absent"
  toJSON ServiceStatusStateNotConfigured = String "not-configured"

serviceStatusStateText :: ServiceStatusState -> Text
serviceStatusStateText ServiceStatusStateRunning = "running"
serviceStatusStateText ServiceStatusStateStopped = "stopped"
serviceStatusStateText ServiceStatusStateReachable = "reachable"
serviceStatusStateText ServiceStatusStateUnreachable = "unreachable"
serviceStatusStateText ServiceStatusStateAbsent = "absent"
serviceStatusStateText ServiceStatusStateNotConfigured = "not-configured"
