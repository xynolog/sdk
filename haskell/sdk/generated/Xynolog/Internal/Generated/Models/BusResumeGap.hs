-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BusResumeGap (BusResumeGap (..), BusResumeGapReason (..), busResumeGapReasonText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data BusResumeGap = BusResumeGap
  { busResumeGapLastSeenId :: Text,
    busResumeGapReason :: BusResumeGapReason,
    busResumeGapScope :: ResourceId
  }
  deriving (Eq, Show)

instance FromJSON BusResumeGap where parseJSON = checked "BusResumeGap" $ withObject "BusResumeGap" (\fields -> BusResumeGap <$> (fields .: "lastSeenId") <*> (fields .: "reason") <*> (fields .: "scope"))

instance ToJSON BusResumeGap where toJSON value = Object (KM.fromList (concat [[("lastSeenId", toJSON (busResumeGapLastSeenId value))], [("reason", toJSON (busResumeGapReason value))], [("scope", toJSON (busResumeGapScope value))]]))

data BusResumeGapReason = BusResumeGapReasonUnparseableLastEventId | BusResumeGapReasonScopeMismatch | BusResumeGapReasonRetentionExceeded | BusResumeGapReasonQueryError deriving (Eq, Show)

instance FromJSON BusResumeGapReason where parseJSON = checked "BusResumeGapReason" $ \value -> if value == String "unparseable-last-event-id" then pure BusResumeGapReasonUnparseableLastEventId else if value == String "scope-mismatch" then pure BusResumeGapReasonScopeMismatch else if value == String "retention-exceeded" then pure BusResumeGapReasonRetentionExceeded else if value == String "query-error" then pure BusResumeGapReasonQueryError else fail "unknown enumeration member"

instance ToJSON BusResumeGapReason where
  toJSON BusResumeGapReasonUnparseableLastEventId = String "unparseable-last-event-id"
  toJSON BusResumeGapReasonScopeMismatch = String "scope-mismatch"
  toJSON BusResumeGapReasonRetentionExceeded = String "retention-exceeded"
  toJSON BusResumeGapReasonQueryError = String "query-error"

busResumeGapReasonText :: BusResumeGapReason -> Text
busResumeGapReasonText BusResumeGapReasonUnparseableLastEventId = "unparseable-last-event-id"
busResumeGapReasonText BusResumeGapReasonScopeMismatch = "scope-mismatch"
busResumeGapReasonText BusResumeGapReasonRetentionExceeded = "retention-exceeded"
busResumeGapReasonText BusResumeGapReasonQueryError = "query-error"
