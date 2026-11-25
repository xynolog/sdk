-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ClientTiming (ClientTiming (..), ClientTimingTimingItem (..), ClientTimingTimingItemValue (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.RetryBudget

data ClientTiming = ClientTiming
  { clientTimingComment :: Text,
    clientTimingTiming :: [ClientTimingTimingItem]
  }
  deriving (Eq, Show)

instance FromJSON ClientTiming where parseJSON = checked "ClientTiming" $ withObject "ClientTiming" (\fields -> ClientTiming <$> (fields .: "$comment") <*> (fields .: "timing"))

instance ToJSON ClientTiming where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (clientTimingComment value))], [("timing", toJSON (clientTimingTiming value))]]))

data ClientTimingTimingItem = ClientTimingTimingItem
  { clientTimingTimingItemName :: Text,
    clientTimingTimingItemValue :: ClientTimingTimingItemValue,
    clientTimingTimingItemDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON ClientTimingTimingItem where parseJSON = checked "ClientTimingTimingItem" $ withObject "ClientTimingTimingItem" (\fields -> ClientTimingTimingItem <$> (fields .: "name") <*> (fields .: "value") <*> (fields .: "docs"))

instance ToJSON ClientTimingTimingItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (clientTimingTimingItemName value))], [("value", toJSON (clientTimingTimingItemValue value))], [("docs", toJSON (clientTimingTimingItemDocs value))]]))

data ClientTimingTimingItemValue = ClientTimingTimingItemValueInteger Integer | ClientTimingTimingItemValueRetryBudget RetryBudget deriving (Eq, Show)

instance FromJSON ClientTimingTimingItemValue where parseJSON = checked "ClientTimingTimingItemValue" $ \value -> readMember "ClientTimingTimingItemValue" [([Signature {signatureKind = IntegerKind, signatureRequired = [], signatureAllowed = Nothing, signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], ClientTimingTimingItemValueInteger <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["attempts", "initialDelayMs", "maxDelayMs"], signatureAllowed = Just ["attempts", "initialDelayMs", "maxDelayMs"], signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], ClientTimingTimingItemValueRetryBudget <$> parseJSON value)] value

instance ToJSON ClientTimingTimingItemValue where
  toJSON (ClientTimingTimingItemValueInteger value) = toJSON value
  toJSON (ClientTimingTimingItemValueRetryBudget value) = toJSON value
