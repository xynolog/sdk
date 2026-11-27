-- Generated from protocol/specs/src/client/option-defaults.json; do not edit.
-- Regenerate: make generate (codegen/lib/option_defaults/haskell.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.OptionDefaults (browseFilesDirPath, browseFilesSort, gatherResourceDepth, gatherResourceMaxResources, gatherResourceIncludeContent, gatherResourceIncludeSummary, matchSearchLimit) where

import Data.Text (Text)
import Xynolog.Types (BrowseDirectoryRequestSort (..))

-- | The directory listed: the knowledge base's root.
browseFilesDirPath :: Text
browseFilesDirPath = "."

-- | How the listing is ordered: by name.
browseFilesSort :: BrowseDirectoryRequestSort
browseFilesSort = BrowseDirectoryRequestSortName

-- | How many links out from the resource the graph reaches.
gatherResourceDepth :: Integer
gatherResourceDepth = 2

-- | The most resources the context holds.
gatherResourceMaxResources :: Integer
gatherResourceMaxResources = 10

-- | Whether the context carries the resources' text.
gatherResourceIncludeContent :: Bool
gatherResourceIncludeContent = True

-- | Whether the context carries a summary of the resource.
gatherResourceIncludeSummary :: Bool
gatherResourceIncludeSummary = False

-- | The most candidates the search answers.
matchSearchLimit :: Integer
matchSearchLimit = 10
