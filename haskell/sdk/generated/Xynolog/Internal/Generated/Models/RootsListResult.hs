-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.RootsListResult (RootsListResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.Root

data RootsListResult = RootsListResult
  { rootsListResultRoots :: [Root],
    rootsListResultWarnings :: Maybe [Text]
  }
  deriving (Eq, Show)

instance FromJSON RootsListResult where parseJSON = checked "RootsListResult" $ withObject "RootsListResult" (\fields -> RootsListResult <$> (fields .: "roots") <*> optional fields "warnings")

instance ToJSON RootsListResult where toJSON value = Object (KM.fromList (concat [[("roots", toJSON (rootsListResultRoots value))], optionalPair "warnings" (rootsListResultWarnings value)]))
