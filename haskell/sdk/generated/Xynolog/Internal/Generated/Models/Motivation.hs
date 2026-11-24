-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Motivation (Motivation (..), motivationText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data Motivation = MotivationAssessing | MotivationCommenting | MotivationHighlighting | MotivationLinking | MotivationTagging deriving (Eq, Show)

instance FromJSON Motivation where parseJSON = checked "Motivation" $ \value -> if value == String "assessing" then pure MotivationAssessing else if value == String "commenting" then pure MotivationCommenting else if value == String "highlighting" then pure MotivationHighlighting else if value == String "linking" then pure MotivationLinking else if value == String "tagging" then pure MotivationTagging else fail "unknown enumeration member"

instance ToJSON Motivation where
  toJSON MotivationAssessing = String "assessing"
  toJSON MotivationCommenting = String "commenting"
  toJSON MotivationHighlighting = String "highlighting"
  toJSON MotivationLinking = String "linking"
  toJSON MotivationTagging = String "tagging"

motivationText :: Motivation -> Text
motivationText MotivationAssessing = "assessing"
motivationText MotivationCommenting = "commenting"
motivationText MotivationHighlighting = "highlighting"
motivationText MotivationLinking = "linking"
motivationText MotivationTagging = "tagging"
