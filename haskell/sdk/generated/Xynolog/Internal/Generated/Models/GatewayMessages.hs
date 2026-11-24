-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatewayMessages (GatewayMessages (..), GatewayMessagesChallenges (..), GatewayMessagesFailuresItem (..), GatewayMessagesMessagesItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.HttpStatus

data GatewayMessages = GatewayMessages
  { gatewayMessagesChallenges :: GatewayMessagesChallenges,
    gatewayMessagesFailures :: [GatewayMessagesFailuresItem],
    gatewayMessagesMessages :: [GatewayMessagesMessagesItem]
  }
  deriving (Eq, Show)

instance FromJSON GatewayMessages where parseJSON = checked "GatewayMessages" $ withObject "GatewayMessages" (\fields -> GatewayMessages <$> (fields .: "challenges") <*> (fields .: "failures") <*> (fields .: "messages"))

instance ToJSON GatewayMessages where toJSON value = Object (KM.fromList (concat [[("challenges", toJSON (gatewayMessagesChallenges value))], [("failures", toJSON (gatewayMessagesFailures value))], [("messages", toJSON (gatewayMessagesMessages value))]]))

data GatewayMessagesChallenges = GatewayMessagesChallenges
  { gatewayMessagesChallengesNoCredential :: Text,
    gatewayMessagesChallengesRefused :: Text
  }
  deriving (Eq, Show)

instance FromJSON GatewayMessagesChallenges where parseJSON = checked "GatewayMessagesChallenges" $ withObject "GatewayMessagesChallenges" (\fields -> GatewayMessagesChallenges <$> (fields .: "noCredential") <*> (fields .: "refused"))

instance ToJSON GatewayMessagesChallenges where toJSON value = Object (KM.fromList (concat [[("noCredential", toJSON (gatewayMessagesChallengesNoCredential value))], [("refused", toJSON (gatewayMessagesChallengesRefused value))]]))

data GatewayMessagesFailuresItem = GatewayMessagesFailuresItem
  { gatewayMessagesFailuresItemCode :: Text,
    gatewayMessagesFailuresItemMessage :: Text,
    gatewayMessagesFailuresItemName :: Text,
    gatewayMessagesFailuresItemSituation :: Text
  }
  deriving (Eq, Show)

instance FromJSON GatewayMessagesFailuresItem where parseJSON = checked "GatewayMessagesFailuresItem" $ withObject "GatewayMessagesFailuresItem" (\fields -> GatewayMessagesFailuresItem <$> (fields .: "code") <*> (fields .: "message") <*> (fields .: "name") <*> (fields .: "situation"))

instance ToJSON GatewayMessagesFailuresItem where toJSON value = Object (KM.fromList (concat [[("code", toJSON (gatewayMessagesFailuresItemCode value))], [("message", toJSON (gatewayMessagesFailuresItemMessage value))], [("name", toJSON (gatewayMessagesFailuresItemName value))], [("situation", toJSON (gatewayMessagesFailuresItemSituation value))]]))

data GatewayMessagesMessagesItem = GatewayMessagesMessagesItem
  { gatewayMessagesMessagesItemCode :: Maybe Text,
    gatewayMessagesMessagesItemError :: Text,
    gatewayMessagesMessagesItemHint :: Maybe Text,
    gatewayMessagesMessagesItemName :: Text,
    gatewayMessagesMessagesItemSituation :: Text,
    gatewayMessagesMessagesItemStatus :: HttpStatus
  }
  deriving (Eq, Show)

instance FromJSON GatewayMessagesMessagesItem where parseJSON = checked "GatewayMessagesMessagesItem" $ withObject "GatewayMessagesMessagesItem" (\fields -> GatewayMessagesMessagesItem <$> optional fields "code" <*> (fields .: "error") <*> optional fields "hint" <*> (fields .: "name") <*> (fields .: "situation") <*> (fields .: "status"))

instance ToJSON GatewayMessagesMessagesItem where toJSON value = Object (KM.fromList (concat [optionalPair "code" (gatewayMessagesMessagesItemCode value), [("error", toJSON (gatewayMessagesMessagesItemError value))], optionalPair "hint" (gatewayMessagesMessagesItemHint value), [("name", toJSON (gatewayMessagesMessagesItemName value))], [("situation", toJSON (gatewayMessagesMessagesItemSituation value))], [("status", toJSON (gatewayMessagesMessagesItemStatus value))]]))
