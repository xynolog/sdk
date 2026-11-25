-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.FrameAddEntityTypeCommand (FrameAddEntityTypeCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.UserId

data FrameAddEntityTypeCommand = FrameAddEntityTypeCommand
  { frameAddEntityTypeCommandUserId :: Maybe UserId,
    frameAddEntityTypeCommandTag :: Text
  }
  deriving (Eq, Show)

instance FromJSON FrameAddEntityTypeCommand where parseJSON = checked "FrameAddEntityTypeCommand" $ withObject "FrameAddEntityTypeCommand" (\fields -> FrameAddEntityTypeCommand <$> optional fields "_userId" <*> (fields .: "tag"))

instance ToJSON FrameAddEntityTypeCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (frameAddEntityTypeCommandUserId value), [("tag", toJSON (frameAddEntityTypeCommandTag value))]]))
