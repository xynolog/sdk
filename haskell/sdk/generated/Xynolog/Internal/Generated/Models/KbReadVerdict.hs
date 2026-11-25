-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.KbReadVerdict (KbReadVerdict (..), KbReadVerdictConflict (..), KbReadVerdictNoVerdict (..), KbReadVerdictRecorded (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.KbReadKind

data KbReadVerdict = KbReadVerdictRecorded KbReadVerdictRecorded | KbReadVerdictConflict KbReadVerdictConflict | KbReadVerdictNoVerdict KbReadVerdictNoVerdict deriving (Eq, Show)

instance FromJSON KbReadVerdict where parseJSON = checked "KbReadVerdict" $ \value -> readMember "KbReadVerdict" [([Signature {signatureKind = ObjectKind, signatureRequired = ["kind"], signatureAllowed = Just ["kind"], signatureFixed = [("kind", [String "recorded"])], signaturePattern = Nothing, signatureValues = Nothing}], KbReadVerdictRecorded <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["kind", "observedDid", "observedName"], signatureAllowed = Just ["kind", "observedDid", "observedName"], signatureFixed = [("kind", [String "conflict"])], signaturePattern = Nothing, signatureValues = Nothing}], KbReadVerdictConflict <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["kind"], signatureAllowed = Just ["kind"], signatureFixed = [("kind", [String "no-verdict"])], signaturePattern = Nothing, signatureValues = Nothing}], KbReadVerdictNoVerdict <$> parseJSON value)] value

instance ToJSON KbReadVerdict where
  toJSON (KbReadVerdictRecorded value) = toJSON value
  toJSON (KbReadVerdictConflict value) = toJSON value
  toJSON (KbReadVerdictNoVerdict value) = toJSON value

data KbReadVerdictConflict = MkKbReadVerdictConflict
  { kbReadVerdictConflictKind :: KbReadKind,
    kbReadVerdictConflictObservedDid :: Text,
    kbReadVerdictConflictObservedName :: Text
  }
  deriving (Eq, Show)

instance FromJSON KbReadVerdictConflict where parseJSON = checked "KbReadVerdictConflict" $ withObject "KbReadVerdictConflict" (\fields -> MkKbReadVerdictConflict <$> (fields .: "kind") <*> (fields .: "observedDid") <*> (fields .: "observedName"))

instance ToJSON KbReadVerdictConflict where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (kbReadVerdictConflictKind value))], [("observedDid", toJSON (kbReadVerdictConflictObservedDid value))], [("observedName", toJSON (kbReadVerdictConflictObservedName value))]]))

data KbReadVerdictNoVerdict = MkKbReadVerdictNoVerdict
  { kbReadVerdictNoVerdictKind :: KbReadKind
  }
  deriving (Eq, Show)

instance FromJSON KbReadVerdictNoVerdict where parseJSON = checked "KbReadVerdictNoVerdict" $ withObject "KbReadVerdictNoVerdict" (\fields -> MkKbReadVerdictNoVerdict <$> (fields .: "kind"))

instance ToJSON KbReadVerdictNoVerdict where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (kbReadVerdictNoVerdictKind value))]]))

data KbReadVerdictRecorded = MkKbReadVerdictRecorded
  { kbReadVerdictRecordedKind :: KbReadKind
  }
  deriving (Eq, Show)

instance FromJSON KbReadVerdictRecorded where parseJSON = checked "KbReadVerdictRecorded" $ withObject "KbReadVerdictRecorded" (\fields -> MkKbReadVerdictRecorded <$> (fields .: "kind"))

instance ToJSON KbReadVerdictRecorded where toJSON value = Object (KM.fromList (concat [[("kind", toJSON (kbReadVerdictRecordedKind value))]]))
