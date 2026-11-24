-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.KbReadVerdict (KbReadVerdict (..), KbReadVerdictConflictValue (..), KbReadVerdictNoVerdictValue (..), KbReadVerdictRecordedValue (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.KbReadKind

data KbReadVerdict = KbReadVerdictRecorded KbReadVerdictRecordedValue | KbReadVerdictConflict KbReadVerdictConflictValue | KbReadVerdictNoVerdict KbReadVerdictNoVerdictValue deriving (Eq, Show)

instance FromJSON KbReadVerdict where parseJSON = checked "KbReadVerdict" $ \value -> (KbReadVerdictRecorded <$> parseJSON value) <|> (KbReadVerdictConflict <$> parseJSON value) <|> (KbReadVerdictNoVerdict <$> parseJSON value)

instance ToJSON KbReadVerdict where
  toJSON (KbReadVerdictRecorded value) = toJSON value
  toJSON (KbReadVerdictConflict value) = toJSON value
  toJSON (KbReadVerdictNoVerdict value) = toJSON value

data KbReadVerdictConflictValue = KbReadVerdictConflictValue
  { kbReadVerdictConflictValueKind :: KbReadKind,
    kbReadVerdictConflictValueObservedDid :: Text,
    kbReadVerdictConflictValueObservedName :: Text
  }
  deriving (Eq, Show)

instance FromJSON KbReadVerdictConflictValue where parseJSON = checked "KbReadVerdictConflictValue" $ withObject "KbReadVerdictConflictValue" (\fields -> KbReadVerdictConflictValue <$> (fields .: "kind") <*> (fields .: "observedDid") <*> (fields .: "observedName"))

instance ToJSON KbReadVerdictConflictValue where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (kbReadVerdictConflictValueKind value))], [("observedDid", toJSON (kbReadVerdictConflictValueObservedDid value))], [("observedName", toJSON (kbReadVerdictConflictValueObservedName value))]]))

data KbReadVerdictNoVerdictValue = KbReadVerdictNoVerdictValue
  { kbReadVerdictNoVerdictValueKind :: KbReadKind
  }
  deriving (Eq, Show)

instance FromJSON KbReadVerdictNoVerdictValue where parseJSON = checked "KbReadVerdictNoVerdictValue" $ withObject "KbReadVerdictNoVerdictValue" (\fields -> KbReadVerdictNoVerdictValue <$> (fields .: "kind"))

instance ToJSON KbReadVerdictNoVerdictValue where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (kbReadVerdictNoVerdictValueKind value))]]))

data KbReadVerdictRecordedValue = KbReadVerdictRecordedValue
  { kbReadVerdictRecordedValueKind :: KbReadKind
  }
  deriving (Eq, Show)

instance FromJSON KbReadVerdictRecordedValue where parseJSON = checked "KbReadVerdictRecordedValue" $ withObject "KbReadVerdictRecordedValue" (\fields -> KbReadVerdictRecordedValue <$> (fields .: "kind"))

instance ToJSON KbReadVerdictRecordedValue where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (kbReadVerdictRecordedValueKind value))]]))
