-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.WeaveRebuildCommand (WeaveRebuildCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject)
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data WeaveRebuildCommand = WeaveRebuildCommand
  { weaveRebuildCommandUserId :: Maybe UserId,
    weaveRebuildCommandResourceId :: Maybe ResourceId,
    weaveRebuildCommandAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON WeaveRebuildCommand where parseJSON = checked "WeaveRebuildCommand" $ withObject "WeaveRebuildCommand" (\fields -> WeaveRebuildCommand <$> optional fields "_userId" <*> optional fields "resourceId" <*> traverse parseJSON (withoutFields ["_userId", "resourceId"] fields))

instance ToJSON WeaveRebuildCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (weaveRebuildCommandUserId value), optionalPair "resourceId" (weaveRebuildCommandResourceId value)]) <> fmap toJSON (withoutFields ["_userId", "resourceId"] (weaveRebuildCommandAdditionalProperties value)))
