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
  { serviceStatusRole :: Text,
    serviceStatusGroup :: ServiceGroup,
    serviceStatusProduct :: Maybe Text,
    serviceStatusRunsOn :: Maybe Text,
    serviceStatusState :: ServiceStatusState,
    serviceStatusContainerState :: Maybe Text,
    serviceStatusHealthy :: Bool,
    serviceStatusCounted :: Bool,
    serviceStatusProbe :: Maybe Text,
    serviceStatusPage :: Maybe Text,
    serviceStatusRealm :: Maybe Text,
    serviceStatusServes :: Maybe [Text]
  }
  deriving (Eq, Show)

instance FromJSON ServiceStatus where parseJSON = checked "ServiceStatus" $ withObject "ServiceStatus" (\fields -> ServiceStatus <$> (fields .: "role") <*> (fields .: "group") <*> optional fields "product" <*> optional fields "runsOn" <*> (fields .: "state") <*> optional fields "containerState" <*> (fields .: "healthy") <*> (fields .: "counted") <*> optional fields "probe" <*> optional fields "page" <*> optional fields "realm" <*> optional fields "serves")

instance ToJSON ServiceStatus where toJSON value = Object (KM.fromList (concat [[("role", toJSON (serviceStatusRole value))], [("group", toJSON (serviceStatusGroup value))], optionalPair "product" (serviceStatusProduct value), optionalPair "runsOn" (serviceStatusRunsOn value), [("state", toJSON (serviceStatusState value))], optionalPair "containerState" (serviceStatusContainerState value), [("healthy", toJSON (serviceStatusHealthy value))], [("counted", toJSON (serviceStatusCounted value))], optionalPair "probe" (serviceStatusProbe value), optionalPair "page" (serviceStatusPage value), optionalPair "realm" (serviceStatusRealm value), optionalPair "serves" (serviceStatusServes value)]))

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
