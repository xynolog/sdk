-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ClientDiscoveryAbsent (ClientDiscoveryAbsent (..), ClientDiscoveryAbsentReasonsItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ClientDiscoveryAbsent = ClientDiscoveryAbsent
  { clientDiscoveryAbsentComment :: Text,
    clientDiscoveryAbsentReasons :: [ClientDiscoveryAbsentReasonsItem]
  }
  deriving (Eq, Show)

instance FromJSON ClientDiscoveryAbsent where parseJSON = checked "ClientDiscoveryAbsent" $ withObject "ClientDiscoveryAbsent" (\fields -> ClientDiscoveryAbsent <$> (fields .: "$comment") <*> (fields .: "reasons"))

instance ToJSON ClientDiscoveryAbsent where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (clientDiscoveryAbsentComment value))], [("reasons", toJSON (clientDiscoveryAbsentReasons value))]]))

data ClientDiscoveryAbsentReasonsItem = ClientDiscoveryAbsentReasonsItem
  { clientDiscoveryAbsentReasonsItemReason :: Text,
    clientDiscoveryAbsentReasonsItemDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON ClientDiscoveryAbsentReasonsItem where parseJSON = checked "ClientDiscoveryAbsentReasonsItem" $ withObject "ClientDiscoveryAbsentReasonsItem" (\fields -> ClientDiscoveryAbsentReasonsItem <$> (fields .: "reason") <*> (fields .: "docs"))

instance ToJSON ClientDiscoveryAbsentReasonsItem where toJSON value = Object (KM.fromList (concat [[("reason", toJSON (clientDiscoveryAbsentReasonsItemReason value))], [("docs", toJSON (clientDiscoveryAbsentReasonsItemDocs value))]]))
