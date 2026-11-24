-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.LocalTarget (LocalTarget (..), LocalTargetKind (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data LocalTarget = LocalTarget
  { localTargetKind :: LocalTargetKind,
    localTargetRoot :: Text
  }
  deriving (Eq, Show)

instance FromJSON LocalTarget where parseJSON = checked "LocalTarget" $ withObject "LocalTarget" (\fields -> LocalTarget <$> (fields .: "kind") <*> (fields .: "root"))

instance ToJSON LocalTarget where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (localTargetKind value))], [("root", toJSON (localTargetRoot value))]]))

data LocalTargetKind = LocalTargetKindLocal deriving (Eq, Show)

instance FromJSON LocalTargetKind where parseJSON = checked "LocalTargetKind" $ \value -> if value == String "local" then pure LocalTargetKindLocal else fail "unknown enumeration member"

instance ToJSON LocalTargetKind where toJSON LocalTargetKindLocal = String "local"
