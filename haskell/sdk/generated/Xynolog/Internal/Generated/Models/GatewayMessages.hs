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
  { gatewayMessagesComment :: Text,
    gatewayMessagesMessages :: [GatewayMessagesMessagesItem],
    gatewayMessagesFailures :: [GatewayMessagesFailuresItem],
    gatewayMessagesChallenges :: GatewayMessagesChallenges
  }
  deriving (Eq, Show)

instance FromJSON GatewayMessages where parseJSON = checked "GatewayMessages" $ withObject "GatewayMessages" (\fields -> GatewayMessages <$> (fields .: "$comment") <*> (fields .: "messages") <*> (fields .: "failures") <*> (fields .: "challenges"))

instance ToJSON GatewayMessages where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (gatewayMessagesComment value))], [("messages", toJSON (gatewayMessagesMessages value))], [("failures", toJSON (gatewayMessagesFailures value))], [("challenges", toJSON (gatewayMessagesChallenges value))]]))

data GatewayMessagesChallenges = GatewayMessagesChallenges
  { gatewayMessagesChallengesNoCredential :: Text,
    gatewayMessagesChallengesRefused :: Text
  }
  deriving (Eq, Show)

instance FromJSON GatewayMessagesChallenges where parseJSON = checked "GatewayMessagesChallenges" $ withObject "GatewayMessagesChallenges" (\fields -> GatewayMessagesChallenges <$> (fields .: "noCredential") <*> (fields .: "refused"))

instance ToJSON GatewayMessagesChallenges where toJSON value = Object (KM.fromList (concat [[("noCredential", toJSON (gatewayMessagesChallengesNoCredential value))], [("refused", toJSON (gatewayMessagesChallengesRefused value))]]))

data GatewayMessagesFailuresItem = GatewayMessagesFailuresItem
  { gatewayMessagesFailuresItemName :: Text,
    gatewayMessagesFailuresItemCode :: Text,
    gatewayMessagesFailuresItemSituation :: Text,
    gatewayMessagesFailuresItemMessage :: Text
  }
  deriving (Eq, Show)

instance FromJSON GatewayMessagesFailuresItem where parseJSON = checked "GatewayMessagesFailuresItem" $ withObject "GatewayMessagesFailuresItem" (\fields -> GatewayMessagesFailuresItem <$> (fields .: "name") <*> (fields .: "code") <*> (fields .: "situation") <*> (fields .: "message"))

instance ToJSON GatewayMessagesFailuresItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (gatewayMessagesFailuresItemName value))], [("code", toJSON (gatewayMessagesFailuresItemCode value))], [("situation", toJSON (gatewayMessagesFailuresItemSituation value))], [("message", toJSON (gatewayMessagesFailuresItemMessage value))]]))

data GatewayMessagesMessagesItem = GatewayMessagesMessagesItem
  { gatewayMessagesMessagesItemName :: Text,
    gatewayMessagesMessagesItemStatus :: HttpStatus,
    gatewayMessagesMessagesItemCode :: Maybe Text,
    gatewayMessagesMessagesItemSituation :: Text,
    gatewayMessagesMessagesItemError :: Text,
    gatewayMessagesMessagesItemHint :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON GatewayMessagesMessagesItem where parseJSON = checked "GatewayMessagesMessagesItem" $ withObject "GatewayMessagesMessagesItem" (\fields -> GatewayMessagesMessagesItem <$> (fields .: "name") <*> (fields .: "status") <*> optional fields "code" <*> (fields .: "situation") <*> (fields .: "error") <*> optional fields "hint")

instance ToJSON GatewayMessagesMessagesItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (gatewayMessagesMessagesItemName value))], [("status", toJSON (gatewayMessagesMessagesItemStatus value))], optionalPair "code" (gatewayMessagesMessagesItemCode value), [("situation", toJSON (gatewayMessagesMessagesItemSituation value))], [("error", toJSON (gatewayMessagesMessagesItemError value))], optionalPair "hint" (gatewayMessagesMessagesItemHint value)]))
