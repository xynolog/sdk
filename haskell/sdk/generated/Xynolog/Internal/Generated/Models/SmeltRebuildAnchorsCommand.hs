-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SmeltRebuildAnchorsCommand (SmeltRebuildAnchorsCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject)
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data SmeltRebuildAnchorsCommand = SmeltRebuildAnchorsCommand
  { smeltRebuildAnchorsCommandUserId :: Maybe UserId,
    smeltRebuildAnchorsCommandResourceId :: Maybe ResourceId,
    smeltRebuildAnchorsCommandAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON SmeltRebuildAnchorsCommand where parseJSON = checked "SmeltRebuildAnchorsCommand" $ withObject "SmeltRebuildAnchorsCommand" (\fields -> SmeltRebuildAnchorsCommand <$> optional fields "_userId" <*> optional fields "resourceId" <*> traverse parseJSON (withoutFields ["_userId", "resourceId"] fields))

instance ToJSON SmeltRebuildAnchorsCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (smeltRebuildAnchorsCommandUserId value), optionalPair "resourceId" (smeltRebuildAnchorsCommandResourceId value)]) <> fmap toJSON (withoutFields ["_userId", "resourceId"] (smeltRebuildAnchorsCommandAdditionalProperties value)))
