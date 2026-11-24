-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.LibrarianPromptScore (LibrarianPromptScore (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Xynolog.Internal.Codec

data LibrarianPromptScore = LibrarianPromptScore
  { librarianPromptScoreCandidate :: Scientific,
    librarianPromptScoreScore :: Scientific
  }
  deriving (Eq, Show)

instance FromJSON LibrarianPromptScore where parseJSON = checked "LibrarianPromptScore" $ withObject "LibrarianPromptScore" (\fields -> LibrarianPromptScore <$> (fields .: "candidate") <*> (fields .: "score"))

instance ToJSON LibrarianPromptScore where toJSON value = Object (KM.fromList (concat [[("candidate", toJSON (librarianPromptScoreCandidate value))], [("score", toJSON (librarianPromptScoreScore value))]]))
