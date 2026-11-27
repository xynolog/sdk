-- Generated from protocol/specs/src/client/types/SearchState.json; do not edit.
-- Regenerate: make generate (codegen/lib/client_types/haskell.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.SearchState (SearchState (..)) where

import Data.Aeson (ToJSON (..), object, (.=))

data SearchState r = SearchState
  { searchStateResults :: [r],
    searchStateIsSearching :: Bool
  }
  deriving (Eq, Show)

instance (ToJSON r) => ToJSON (SearchState r) where toJSON record = object ["results" .= searchStateResults record, "isSearching" .= searchStateIsSearching record]
