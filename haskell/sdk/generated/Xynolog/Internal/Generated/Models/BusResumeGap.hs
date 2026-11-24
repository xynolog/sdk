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

data BusResumeGapReason = BusResumeGapReasonUnparseableU2d_lastU2d_eventU2d_id | BusResumeGapReasonScopeU2d_mismatch | BusResumeGapReasonRetentionU2d_exceeded | BusResumeGapReasonQueryU2d_error deriving (Eq, Show)

instance FromJSON BusResumeGapReason where parseJSON = checked "BusResumeGapReason" $ \value -> if value == String "unparseable-last-event-id" then pure BusResumeGapReasonUnparseableU2d_lastU2d_eventU2d_id else if value == String "scope-mismatch" then pure BusResumeGapReasonScopeU2d_mismatch else if value == String "retention-exceeded" then pure BusResumeGapReasonRetentionU2d_exceeded else if value == String "query-error" then pure BusResumeGapReasonQueryU2d_error else fail "unknown enumeration member"

instance ToJSON BusResumeGapReason where
  toJSON BusResumeGapReasonUnparseableU2d_lastU2d_eventU2d_id = String "unparseable-last-event-id"
  toJSON BusResumeGapReasonScopeU2d_mismatch = String "scope-mismatch"
  toJSON BusResumeGapReasonRetentionU2d_exceeded = String "retention-exceeded"
  toJSON BusResumeGapReasonQueryU2d_error = String "query-error"

busResumeGapReasonText :: BusResumeGapReason -> Text
busResumeGapReasonText BusResumeGapReasonUnparseableU2d_lastU2d_eventU2d_id = "unparseable-last-event-id"
busResumeGapReasonText BusResumeGapReasonScopeU2d_mismatch = "scope-mismatch"
busResumeGapReasonText BusResumeGapReasonRetentionU2d_exceeded = "retention-exceeded"
busResumeGapReasonText BusResumeGapReasonQueryU2d_error = "query-error"
