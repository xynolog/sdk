-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.KbRead (KbRead (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data KbRead = KbRead
  { kbReadAt :: Text,
    kbReadGitBranch :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON KbRead where parseJSON = checked "KbRead" $ withObject "KbRead" (\fields -> KbRead <$> (fields .: "at") <*> optional fields "gitBranch")

instance ToJSON KbRead where toJSON value = Object (KM.fromList (concat [[("at", toJSON (kbReadAt value))], optionalPair "gitBranch" (kbReadGitBranch value)]))
