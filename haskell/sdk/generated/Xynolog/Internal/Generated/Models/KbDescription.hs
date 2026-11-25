-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.KbDescription (KbDescription (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data KbDescription = KbDescription
  { kbDescriptionName :: Text,
    kbDescriptionDomain :: Text,
    kbDescriptionGitBranch :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON KbDescription where parseJSON = checked "KbDescription" $ withObject "KbDescription" (\fields -> KbDescription <$> (fields .: "name") <*> (fields .: "domain") <*> optional fields "gitBranch")

instance ToJSON KbDescription where toJSON value = Object (KM.fromList (concat [[("name", toJSON (kbDescriptionName value))], [("domain", toJSON (kbDescriptionDomain value))], optionalPair "gitBranch" (kbDescriptionGitBranch value)]))
