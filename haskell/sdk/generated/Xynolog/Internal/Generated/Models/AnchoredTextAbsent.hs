-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.AnchoredTextAbsent (AnchoredTextAbsent (..), AnchoredTextAbsentKind (..), anchoredTextAbsentKindText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data AnchoredTextAbsent = AnchoredTextAbsent
  { anchoredTextAbsentKind :: AnchoredTextAbsentKind,
    anchoredTextAbsentAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON AnchoredTextAbsent where parseJSON = checked "AnchoredTextAbsent" $ withObject "AnchoredTextAbsent" (\fields -> AnchoredTextAbsent <$> (fields .: "kind") <*> traverse parseJSON (withoutFields ["kind"] fields))

instance ToJSON AnchoredTextAbsent where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (anchoredTextAbsentKind value))]]) <> fmap toJSON (withoutFields ["kind"] (anchoredTextAbsentAdditionalProperties value)))

data AnchoredTextAbsentKind = AnchoredTextAbsentKindNotU2d_yet | AnchoredTextAbsentKindNoU2d_map | AnchoredTextAbsentKindUnknown deriving (Eq, Show)

instance FromJSON AnchoredTextAbsentKind where parseJSON = checked "AnchoredTextAbsentKind" $ \value -> if value == String "not-yet" then pure AnchoredTextAbsentKindNotU2d_yet else if value == String "no-map" then pure AnchoredTextAbsentKindNoU2d_map else if value == String "unknown" then pure AnchoredTextAbsentKindUnknown else fail "unknown enumeration member"

instance ToJSON AnchoredTextAbsentKind where
  toJSON AnchoredTextAbsentKindNotU2d_yet = String "not-yet"
  toJSON AnchoredTextAbsentKindNoU2d_map = String "no-map"
  toJSON AnchoredTextAbsentKindUnknown = String "unknown"

anchoredTextAbsentKindText :: AnchoredTextAbsentKind -> Text
anchoredTextAbsentKindText AnchoredTextAbsentKindNotU2d_yet = "not-yet"
anchoredTextAbsentKindText AnchoredTextAbsentKindNoU2d_map = "no-map"
anchoredTextAbsentKindText AnchoredTextAbsentKindUnknown = "unknown"
