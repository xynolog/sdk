-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DiscoveryRead (DiscoveryRead (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.DiscoveryAbsent
import Xynolog.Internal.Generated.Models.DiscoveryManaged
import Xynolog.Internal.Generated.Models.DiscoveryUnchanged

data DiscoveryRead = DiscoveryReadDiscoveryAbsent DiscoveryAbsent | DiscoveryReadDiscoveryManaged DiscoveryManaged | DiscoveryReadDiscoveryUnchanged DiscoveryUnchanged deriving (Eq, Show)

instance FromJSON DiscoveryRead where parseJSON = checked "DiscoveryRead" $ \value -> readMember "DiscoveryRead" [([Signature {signatureKind = ObjectKind, signatureRequired = ["kind", "reason"], signatureAllowed = Just ["kind", "reason", "diagnostic"], signatureFixed = [("kind", [String "absent"]), ("reason", [String "not-found", String "not-json", String "invalid", String "unsupported-version", String "unreadable"])], signaturePattern = Nothing, signatureValues = Nothing}], DiscoveryReadDiscoveryAbsent <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["kind", "kbs"], signatureAllowed = Just ["kind", "kbs"], signatureFixed = [("kind", [String "managed"])], signaturePattern = Nothing, signatureValues = Nothing}], DiscoveryReadDiscoveryManaged <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["kind"], signatureAllowed = Just ["kind"], signatureFixed = [("kind", [String "unchanged"])], signaturePattern = Nothing, signatureValues = Nothing}], DiscoveryReadDiscoveryUnchanged <$> parseJSON value)] value

instance ToJSON DiscoveryRead where
  toJSON (DiscoveryReadDiscoveryAbsent value) = toJSON value
  toJSON (DiscoveryReadDiscoveryManaged value) = toJSON value
  toJSON (DiscoveryReadDiscoveryUnchanged value) = toJSON value
