-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Progress (Progress (..), ProgressKind (..), progressKindText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.RequestId

data Progress = Progress
  { progressRequestId :: RequestId,
    progressKind :: ProgressKind,
    progressText :: Text
  }
  deriving (Eq, Show)

instance FromJSON Progress where parseJSON = checked "Progress" $ withObject "Progress" (\fields -> Progress <$> (fields .: "requestId") <*> (fields .: "kind") <*> (fields .: "text"))

instance ToJSON Progress where toJSON value = Object (KM.fromList (concat [[("requestId", toJSON (progressRequestId value))], [("kind", toJSON (progressKind value))], [("text", toJSON (progressText value))]]))

data ProgressKind = ProgressKindLog | ProgressKindNote | ProgressKindOk | ProgressKindWarn | ProgressKindFail | ProgressKindBanner | ProgressKindSection | ProgressKindStamp | ProgressKindCommand | ProgressKindOutput deriving (Eq, Show)

instance FromJSON ProgressKind where parseJSON = checked "ProgressKind" $ \value -> if value == String "log" then pure ProgressKindLog else if value == String "note" then pure ProgressKindNote else if value == String "ok" then pure ProgressKindOk else if value == String "warn" then pure ProgressKindWarn else if value == String "fail" then pure ProgressKindFail else if value == String "banner" then pure ProgressKindBanner else if value == String "section" then pure ProgressKindSection else if value == String "stamp" then pure ProgressKindStamp else if value == String "command" then pure ProgressKindCommand else if value == String "output" then pure ProgressKindOutput else fail "unknown enumeration member"

instance ToJSON ProgressKind where
  toJSON ProgressKindLog = String "log"
  toJSON ProgressKindNote = String "note"
  toJSON ProgressKindOk = String "ok"
  toJSON ProgressKindWarn = String "warn"
  toJSON ProgressKindFail = String "fail"
  toJSON ProgressKindBanner = String "banner"
  toJSON ProgressKindSection = String "section"
  toJSON ProgressKindStamp = String "stamp"
  toJSON ProgressKindCommand = String "command"
  toJSON ProgressKindOutput = String "output"

progressKindText :: ProgressKind -> Text
progressKindText ProgressKindLog = "log"
progressKindText ProgressKindNote = "note"
progressKindText ProgressKindOk = "ok"
progressKindText ProgressKindWarn = "warn"
progressKindText ProgressKindFail = "fail"
progressKindText ProgressKindBanner = "banner"
progressKindText ProgressKindSection = "section"
progressKindText ProgressKindStamp = "stamp"
progressKindText ProgressKindCommand = "command"
progressKindText ProgressKindOutput = "output"
