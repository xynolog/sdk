-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BodyPurpose (BodyPurpose (..), bodyPurposeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..))
import Data.Text (Text)
import Xynolog.Internal.Codec

data BodyPurpose = BodyPurposeAssessing | BodyPurposeBookmarking | BodyPurposeClassifying | BodyPurposeCommenting | BodyPurposeDescribing | BodyPurposeEditing | BodyPurposeHighlighting | BodyPurposeIdentifying | BodyPurposeLinking | BodyPurposeModerating | BodyPurposeQuestioning | BodyPurposeReplying | BodyPurposeTagging deriving (Eq, Show)

instance FromJSON BodyPurpose where parseJSON = checked "BodyPurpose" $ \value -> if value == String "assessing" then pure BodyPurposeAssessing else if value == String "bookmarking" then pure BodyPurposeBookmarking else if value == String "classifying" then pure BodyPurposeClassifying else if value == String "commenting" then pure BodyPurposeCommenting else if value == String "describing" then pure BodyPurposeDescribing else if value == String "editing" then pure BodyPurposeEditing else if value == String "highlighting" then pure BodyPurposeHighlighting else if value == String "identifying" then pure BodyPurposeIdentifying else if value == String "linking" then pure BodyPurposeLinking else if value == String "moderating" then pure BodyPurposeModerating else if value == String "questioning" then pure BodyPurposeQuestioning else if value == String "replying" then pure BodyPurposeReplying else if value == String "tagging" then pure BodyPurposeTagging else fail "unknown enumeration member"

instance ToJSON BodyPurpose where
  toJSON BodyPurposeAssessing = String "assessing"
  toJSON BodyPurposeBookmarking = String "bookmarking"
  toJSON BodyPurposeClassifying = String "classifying"
  toJSON BodyPurposeCommenting = String "commenting"
  toJSON BodyPurposeDescribing = String "describing"
  toJSON BodyPurposeEditing = String "editing"
  toJSON BodyPurposeHighlighting = String "highlighting"
  toJSON BodyPurposeIdentifying = String "identifying"
  toJSON BodyPurposeLinking = String "linking"
  toJSON BodyPurposeModerating = String "moderating"
  toJSON BodyPurposeQuestioning = String "questioning"
  toJSON BodyPurposeReplying = String "replying"
  toJSON BodyPurposeTagging = String "tagging"

bodyPurposeText :: BodyPurpose -> Text
bodyPurposeText BodyPurposeAssessing = "assessing"
bodyPurposeText BodyPurposeBookmarking = "bookmarking"
bodyPurposeText BodyPurposeClassifying = "classifying"
bodyPurposeText BodyPurposeCommenting = "commenting"
bodyPurposeText BodyPurposeDescribing = "describing"
bodyPurposeText BodyPurposeEditing = "editing"
bodyPurposeText BodyPurposeHighlighting = "highlighting"
bodyPurposeText BodyPurposeIdentifying = "identifying"
bodyPurposeText BodyPurposeLinking = "linking"
bodyPurposeText BodyPurposeModerating = "moderating"
bodyPurposeText BodyPurposeQuestioning = "questioning"
bodyPurposeText BodyPurposeReplying = "replying"
bodyPurposeText BodyPurposeTagging = "tagging"
