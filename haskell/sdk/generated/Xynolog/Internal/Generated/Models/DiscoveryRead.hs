-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.DiscoveryRead (DiscoveryRead (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.DiscoveryReadAbsent
import Xynolog.Internal.Generated.Models.DiscoveryReadManaged
import Xynolog.Internal.Generated.Models.DiscoveryReadUnchanged

data DiscoveryRead = DiscoveryReadDiscoveryReadAbsent DiscoveryReadAbsent | DiscoveryReadDiscoveryReadManaged DiscoveryReadManaged | DiscoveryReadDiscoveryReadUnchanged DiscoveryReadUnchanged deriving (Eq, Show)

instance FromJSON DiscoveryRead where parseJSON = checked "DiscoveryRead" $ \value -> readMember "DiscoveryRead" [([Signature {signatureKind = ObjectKind, signatureRequired = ["kind", "reason"], signatureAllowed = Just ["kind", "reason", "diagnostic"], signatureFixed = [("kind", [String "absent"])], signaturePattern = Nothing, signatureValues = Nothing}], DiscoveryReadDiscoveryReadAbsent <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["kind", "kbs"], signatureAllowed = Just ["kind", "kbs"], signatureFixed = [("kind", [String "managed"])], signaturePattern = Nothing, signatureValues = Nothing}], DiscoveryReadDiscoveryReadManaged <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["kind"], signatureAllowed = Just ["kind"], signatureFixed = [("kind", [String "unchanged"])], signaturePattern = Nothing, signatureValues = Nothing}], DiscoveryReadDiscoveryReadUnchanged <$> parseJSON value)] value

instance ToJSON DiscoveryRead where
  toJSON (DiscoveryReadDiscoveryReadAbsent value) = toJSON value
  toJSON (DiscoveryReadDiscoveryReadManaged value) = toJSON value
  toJSON (DiscoveryReadDiscoveryReadUnchanged value) = toJSON value
