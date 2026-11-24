-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.RootsForgetResult (RootsForgetResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data RootsForgetResult = RootsForgetResult
  { rootsForgetResultDirectoryMissing :: Bool,
    rootsForgetResultPath :: Text,
    rootsForgetResultPersistentState :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON RootsForgetResult where parseJSON = checked "RootsForgetResult" $ withObject "RootsForgetResult" (\fields -> RootsForgetResult <$> (fields .: "directoryMissing") <*> (fields .: "path") <*> optional fields "persistentState")

instance ToJSON RootsForgetResult where toJSON value = Object (KM.fromList (concat [[("directoryMissing", toJSON (rootsForgetResultDirectoryMissing value))], [("path", toJSON (rootsForgetResultPath value))], optionalPair "persistentState" (rootsForgetResultPersistentState value)]))
