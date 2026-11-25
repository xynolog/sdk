-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.LogRecord (LogRecord (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.OutputStream
import Xynolog.Internal.Generated.Models.RequestId

data LogRecord = LogRecord
  { logRecordRequestId :: RequestId,
    logRecordService :: Text,
    logRecordStream :: OutputStream,
    logRecordLine :: Text,
    logRecordReceivedAt :: Text
  }
  deriving (Eq, Show)

instance FromJSON LogRecord where parseJSON = checked "LogRecord" $ withObject "LogRecord" (\fields -> LogRecord <$> (fields .: "requestId") <*> (fields .: "service") <*> (fields .: "stream") <*> (fields .: "line") <*> (fields .: "receivedAt"))

instance ToJSON LogRecord where toJSON value = Object (KM.fromList (concat [[("requestId", toJSON (logRecordRequestId value))], [("service", toJSON (logRecordService value))], [("stream", toJSON (logRecordStream value))], [("line", toJSON (logRecordLine value))], [("receivedAt", toJSON (logRecordReceivedAt value))]]))
