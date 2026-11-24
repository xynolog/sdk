-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ConformanceDriverLine (ConformanceDriverLine (..), ConformanceDriverLineAbandonedValue (..), ConformanceDriverLineAbandonedValueAbandoned (..), ConformanceDriverLineClaimedValue (..), ConformanceDriverLineClaimedValueClaimed (..), ConformanceDriverLineCompletedValue (..), ConformanceDriverLineEmissionValue (..), ConformanceDriverLineEmissionValueEmission (..), ConformanceDriverLineEmissionValueEmissionState (..), ConformanceDriverLineEmissionValueEmissionStateFailedValue (..), ConformanceDriverLineEmissionValueEmissionStateFailedValueStatus (..), conformanceDriverLineEmissionValueEmissionStateFailedValueStatusText, ConformanceDriverLineEmissionValueEmissionStatePendingValue (..), ConformanceDriverLineEmissionValueEmissionStatePendingValueStatus (..), conformanceDriverLineEmissionValueEmissionStatePendingValueStatusText, ConformanceDriverLineEmissionValueEmissionStateReadyValue (..), ConformanceDriverLineEmissionValueEmissionStateReadyValueStatus (..), conformanceDriverLineEmissionValueEmissionStateReadyValueStatusText, ConformanceDriverLineErrorStreamValue (..), ConformanceDriverLineFailedValue (..), ConformanceDriverLineFrameValue (..), ConformanceDriverLineFrameValueFrame (..), ConformanceDriverLineMisuseValue (..), ConformanceDriverLineOkValue (..), ConformanceDriverLineProgressValue (..), ConformanceDriverLineProgressValueProgress (..), ConformanceDriverLineReadyValue (..), ConformanceDriverLineReadyValueReady (..), ConformanceDriverLineRefusedValue (..), ConformanceDriverLineSignalledValue (..), ConformanceDriverLineStalledValue (..), ConformanceDriverLineStateValue (..), ConformanceDriverLineUnsupportedValue (..), ConformanceDriverLineUnsupportedValueUnsupported (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ConformanceFailure
import Xynolog.Internal.Generated.Models.ResourceId

data ConformanceDriverLine = ConformanceDriverLineReady ConformanceDriverLineReadyValue | ConformanceDriverLineOk ConformanceDriverLineOkValue | ConformanceDriverLineFailed ConformanceDriverLineFailedValue | ConformanceDriverLineAbandoned ConformanceDriverLineAbandonedValue | ConformanceDriverLineUnsupported ConformanceDriverLineUnsupportedValue | ConformanceDriverLineMisuse ConformanceDriverLineMisuseValue | ConformanceDriverLineState ConformanceDriverLineStateValue | ConformanceDriverLineFrame ConformanceDriverLineFrameValue | ConformanceDriverLineErrorStream ConformanceDriverLineErrorStreamValue | ConformanceDriverLineProgress ConformanceDriverLineProgressValue | ConformanceDriverLineEmission ConformanceDriverLineEmissionValue | ConformanceDriverLineCompleted ConformanceDriverLineCompletedValue | ConformanceDriverLineClaimed ConformanceDriverLineClaimedValue | ConformanceDriverLineRefused ConformanceDriverLineRefusedValue | ConformanceDriverLineSignalled ConformanceDriverLineSignalledValue | ConformanceDriverLineStalled ConformanceDriverLineStalledValue deriving (Eq, Show)

instance FromJSON ConformanceDriverLine where parseJSON = checked "ConformanceDriverLine" $ \value -> (ConformanceDriverLineReady <$> parseJSON value) <|> (ConformanceDriverLineOk <$> parseJSON value) <|> (ConformanceDriverLineFailed <$> parseJSON value) <|> (ConformanceDriverLineAbandoned <$> parseJSON value) <|> (ConformanceDriverLineUnsupported <$> parseJSON value) <|> (ConformanceDriverLineMisuse <$> parseJSON value) <|> (ConformanceDriverLineState <$> parseJSON value) <|> (ConformanceDriverLineFrame <$> parseJSON value) <|> (ConformanceDriverLineErrorStream <$> parseJSON value) <|> (ConformanceDriverLineProgress <$> parseJSON value) <|> (ConformanceDriverLineEmission <$> parseJSON value) <|> (ConformanceDriverLineCompleted <$> parseJSON value) <|> (ConformanceDriverLineClaimed <$> parseJSON value) <|> (ConformanceDriverLineRefused <$> parseJSON value) <|> (ConformanceDriverLineSignalled <$> parseJSON value) <|> (ConformanceDriverLineStalled <$> parseJSON value)

instance ToJSON ConformanceDriverLine where
  toJSON (ConformanceDriverLineReady value) = toJSON value
  toJSON (ConformanceDriverLineOk value) = toJSON value
  toJSON (ConformanceDriverLineFailed value) = toJSON value
  toJSON (ConformanceDriverLineAbandoned value) = toJSON value
  toJSON (ConformanceDriverLineUnsupported value) = toJSON value
  toJSON (ConformanceDriverLineMisuse value) = toJSON value
  toJSON (ConformanceDriverLineState value) = toJSON value
  toJSON (ConformanceDriverLineFrame value) = toJSON value
  toJSON (ConformanceDriverLineErrorStream value) = toJSON value
  toJSON (ConformanceDriverLineProgress value) = toJSON value
  toJSON (ConformanceDriverLineEmission value) = toJSON value
  toJSON (ConformanceDriverLineCompleted value) = toJSON value
  toJSON (ConformanceDriverLineClaimed value) = toJSON value
  toJSON (ConformanceDriverLineRefused value) = toJSON value
  toJSON (ConformanceDriverLineSignalled value) = toJSON value
  toJSON (ConformanceDriverLineStalled value) = toJSON value

data ConformanceDriverLineAbandonedValue = ConformanceDriverLineAbandonedValue
  { conformanceDriverLineAbandonedValueAbandoned :: ConformanceDriverLineAbandonedValueAbandoned,
    conformanceDriverLineAbandonedValueId :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineAbandonedValue where parseJSON = checked "ConformanceDriverLineAbandonedValue" $ withObject "ConformanceDriverLineAbandonedValue" (\fields -> ConformanceDriverLineAbandonedValue <$> (fields .: "abandoned") <*> (fields .: "id"))

instance ToJSON ConformanceDriverLineAbandonedValue where toJSON value = Object (KM.fromList (concat [[("abandoned", toJSON (conformanceDriverLineAbandonedValueAbandoned value))], [("id", toJSON (conformanceDriverLineAbandonedValueId value))]]))

data ConformanceDriverLineAbandonedValueAbandoned = ConformanceDriverLineAbandonedValueAbandonedTrue deriving (Eq, Show)

instance FromJSON ConformanceDriverLineAbandonedValueAbandoned where parseJSON = checked "ConformanceDriverLineAbandonedValueAbandoned" $ \value -> if value == Bool True then pure ConformanceDriverLineAbandonedValueAbandonedTrue else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineAbandonedValueAbandoned where toJSON ConformanceDriverLineAbandonedValueAbandonedTrue = Bool True

data ConformanceDriverLineClaimedValue = ConformanceDriverLineClaimedValue
  { conformanceDriverLineClaimedValueClaimed :: ConformanceDriverLineClaimedValueClaimed
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineClaimedValue where parseJSON = checked "ConformanceDriverLineClaimedValue" $ withObject "ConformanceDriverLineClaimedValue" (\fields -> ConformanceDriverLineClaimedValue <$> (fields .: "claimed"))

instance ToJSON ConformanceDriverLineClaimedValue where toJSON value = Object (KM.fromList (concat [[("claimed", toJSON (conformanceDriverLineClaimedValueClaimed value))]]))

data ConformanceDriverLineClaimedValueClaimed = ConformanceDriverLineClaimedValueClaimed
  { conformanceDriverLineClaimedValueClaimedAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineClaimedValueClaimed where parseJSON = checked "ConformanceDriverLineClaimedValueClaimed" $ withObject "ConformanceDriverLineClaimedValueClaimed" (\fields -> ConformanceDriverLineClaimedValueClaimed <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ConformanceDriverLineClaimedValueClaimed where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (conformanceDriverLineClaimedValueClaimedAdditionalProperties value)))

data ConformanceDriverLineCompletedValue = ConformanceDriverLineCompletedValue
  { conformanceDriverLineCompletedValueCompleted :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineCompletedValue where parseJSON = checked "ConformanceDriverLineCompletedValue" $ withObject "ConformanceDriverLineCompletedValue" (\fields -> ConformanceDriverLineCompletedValue <$> (fields .: "completed"))

instance ToJSON ConformanceDriverLineCompletedValue where toJSON value = Object (KM.fromList (concat [[("completed", toJSON (conformanceDriverLineCompletedValueCompleted value))]]))

data ConformanceDriverLineEmissionValue = ConformanceDriverLineEmissionValue
  { conformanceDriverLineEmissionValueEmission :: ConformanceDriverLineEmissionValueEmission
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmissionValue where parseJSON = checked "ConformanceDriverLineEmissionValue" $ withObject "ConformanceDriverLineEmissionValue" (\fields -> ConformanceDriverLineEmissionValue <$> (fields .: "emission"))

instance ToJSON ConformanceDriverLineEmissionValue where toJSON value = Object (KM.fromList (concat [[("emission", toJSON (conformanceDriverLineEmissionValueEmission value))]]))

data ConformanceDriverLineEmissionValueEmission = ConformanceDriverLineEmissionValueEmission
  { conformanceDriverLineEmissionValueEmissionObserver :: Text,
    conformanceDriverLineEmissionValueEmissionState :: ConformanceDriverLineEmissionValueEmissionState
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmissionValueEmission where parseJSON = checked "ConformanceDriverLineEmissionValueEmission" $ withObject "ConformanceDriverLineEmissionValueEmission" (\fields -> ConformanceDriverLineEmissionValueEmission <$> (fields .: "observer") <*> (fields .: "state"))

instance ToJSON ConformanceDriverLineEmissionValueEmission where toJSON value = Object (KM.fromList (concat [[("observer", toJSON (conformanceDriverLineEmissionValueEmissionObserver value))], [("state", toJSON (conformanceDriverLineEmissionValueEmissionState value))]]))

data ConformanceDriverLineEmissionValueEmissionState = ConformanceDriverLineEmissionValueEmissionStatePending ConformanceDriverLineEmissionValueEmissionStatePendingValue | ConformanceDriverLineEmissionValueEmissionStateReady ConformanceDriverLineEmissionValueEmissionStateReadyValue | ConformanceDriverLineEmissionValueEmissionStateFailed ConformanceDriverLineEmissionValueEmissionStateFailedValue deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmissionValueEmissionState where parseJSON = checked "ConformanceDriverLineEmissionValueEmissionState" $ \value -> (ConformanceDriverLineEmissionValueEmissionStatePending <$> parseJSON value) <|> (ConformanceDriverLineEmissionValueEmissionStateReady <$> parseJSON value) <|> (ConformanceDriverLineEmissionValueEmissionStateFailed <$> parseJSON value)

instance ToJSON ConformanceDriverLineEmissionValueEmissionState where
  toJSON (ConformanceDriverLineEmissionValueEmissionStatePending value) = toJSON value
  toJSON (ConformanceDriverLineEmissionValueEmissionStateReady value) = toJSON value
  toJSON (ConformanceDriverLineEmissionValueEmissionStateFailed value) = toJSON value

data ConformanceDriverLineEmissionValueEmissionStateFailedValue = ConformanceDriverLineEmissionValueEmissionStateFailedValue
  { conformanceDriverLineEmissionValueEmissionStateFailedValueError :: ConformanceFailure,
    conformanceDriverLineEmissionValueEmissionStateFailedValueStatus :: ConformanceDriverLineEmissionValueEmissionStateFailedValueStatus
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmissionValueEmissionStateFailedValue where parseJSON = checked "ConformanceDriverLineEmissionValueEmissionStateFailedValue" $ withObject "ConformanceDriverLineEmissionValueEmissionStateFailedValue" (\fields -> ConformanceDriverLineEmissionValueEmissionStateFailedValue <$> (fields .: "error") <*> (fields .: "status"))

instance ToJSON ConformanceDriverLineEmissionValueEmissionStateFailedValue where toJSON value = Object (KM.fromList (concat [[("error", toJSON (conformanceDriverLineEmissionValueEmissionStateFailedValueError value))], [("status", toJSON (conformanceDriverLineEmissionValueEmissionStateFailedValueStatus value))]]))

data ConformanceDriverLineEmissionValueEmissionStateFailedValueStatus = ConformanceDriverLineEmissionValueEmissionStateFailedValueStatusFailed deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmissionValueEmissionStateFailedValueStatus where parseJSON = checked "ConformanceDriverLineEmissionValueEmissionStateFailedValueStatus" $ \value -> if value == String "failed" then pure ConformanceDriverLineEmissionValueEmissionStateFailedValueStatusFailed else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineEmissionValueEmissionStateFailedValueStatus where toJSON ConformanceDriverLineEmissionValueEmissionStateFailedValueStatusFailed = String "failed"

conformanceDriverLineEmissionValueEmissionStateFailedValueStatusText :: ConformanceDriverLineEmissionValueEmissionStateFailedValueStatus -> Text
conformanceDriverLineEmissionValueEmissionStateFailedValueStatusText ConformanceDriverLineEmissionValueEmissionStateFailedValueStatusFailed = "failed"

data ConformanceDriverLineEmissionValueEmissionStatePendingValue = ConformanceDriverLineEmissionValueEmissionStatePendingValue
  { conformanceDriverLineEmissionValueEmissionStatePendingValueStatus :: ConformanceDriverLineEmissionValueEmissionStatePendingValueStatus
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmissionValueEmissionStatePendingValue where parseJSON = checked "ConformanceDriverLineEmissionValueEmissionStatePendingValue" $ withObject "ConformanceDriverLineEmissionValueEmissionStatePendingValue" (\fields -> ConformanceDriverLineEmissionValueEmissionStatePendingValue <$> (fields .: "status"))

instance ToJSON ConformanceDriverLineEmissionValueEmissionStatePendingValue where toJSON value = Object (KM.fromList (concat [[("status", toJSON (conformanceDriverLineEmissionValueEmissionStatePendingValueStatus value))]]))

data ConformanceDriverLineEmissionValueEmissionStatePendingValueStatus = ConformanceDriverLineEmissionValueEmissionStatePendingValueStatusPending deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmissionValueEmissionStatePendingValueStatus where parseJSON = checked "ConformanceDriverLineEmissionValueEmissionStatePendingValueStatus" $ \value -> if value == String "pending" then pure ConformanceDriverLineEmissionValueEmissionStatePendingValueStatusPending else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineEmissionValueEmissionStatePendingValueStatus where toJSON ConformanceDriverLineEmissionValueEmissionStatePendingValueStatusPending = String "pending"

conformanceDriverLineEmissionValueEmissionStatePendingValueStatusText :: ConformanceDriverLineEmissionValueEmissionStatePendingValueStatus -> Text
conformanceDriverLineEmissionValueEmissionStatePendingValueStatusText ConformanceDriverLineEmissionValueEmissionStatePendingValueStatusPending = "pending"

data ConformanceDriverLineEmissionValueEmissionStateReadyValue = ConformanceDriverLineEmissionValueEmissionStateReadyValue
  { conformanceDriverLineEmissionValueEmissionStateReadyValueStatus :: ConformanceDriverLineEmissionValueEmissionStateReadyValueStatus,
    conformanceDriverLineEmissionValueEmissionStateReadyValueValue :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmissionValueEmissionStateReadyValue where parseJSON = checked "ConformanceDriverLineEmissionValueEmissionStateReadyValue" $ withObject "ConformanceDriverLineEmissionValueEmissionStateReadyValue" (\fields -> ConformanceDriverLineEmissionValueEmissionStateReadyValue <$> (fields .: "status") <*> (fields .: "value"))

instance ToJSON ConformanceDriverLineEmissionValueEmissionStateReadyValue where toJSON value = Object (KM.fromList (concat [[("status", toJSON (conformanceDriverLineEmissionValueEmissionStateReadyValueStatus value))], [("value", toJSON (conformanceDriverLineEmissionValueEmissionStateReadyValueValue value))]]))

data ConformanceDriverLineEmissionValueEmissionStateReadyValueStatus = ConformanceDriverLineEmissionValueEmissionStateReadyValueStatusReady deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmissionValueEmissionStateReadyValueStatus where parseJSON = checked "ConformanceDriverLineEmissionValueEmissionStateReadyValueStatus" $ \value -> if value == String "ready" then pure ConformanceDriverLineEmissionValueEmissionStateReadyValueStatusReady else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineEmissionValueEmissionStateReadyValueStatus where toJSON ConformanceDriverLineEmissionValueEmissionStateReadyValueStatusReady = String "ready"

conformanceDriverLineEmissionValueEmissionStateReadyValueStatusText :: ConformanceDriverLineEmissionValueEmissionStateReadyValueStatus -> Text
conformanceDriverLineEmissionValueEmissionStateReadyValueStatusText ConformanceDriverLineEmissionValueEmissionStateReadyValueStatusReady = "ready"

data ConformanceDriverLineErrorStreamValue = ConformanceDriverLineErrorStreamValue
  { conformanceDriverLineErrorStreamValueError :: ConformanceFailure
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineErrorStreamValue where parseJSON = checked "ConformanceDriverLineErrorStreamValue" $ withObject "ConformanceDriverLineErrorStreamValue" (\fields -> ConformanceDriverLineErrorStreamValue <$> (fields .: "error"))

instance ToJSON ConformanceDriverLineErrorStreamValue where toJSON value = Object (KM.fromList (concat [[("error", toJSON (conformanceDriverLineErrorStreamValueError value))]]))

data ConformanceDriverLineFailedValue = ConformanceDriverLineFailedValue
  { conformanceDriverLineFailedValueError :: ConformanceFailure,
    conformanceDriverLineFailedValueId :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineFailedValue where parseJSON = checked "ConformanceDriverLineFailedValue" $ withObject "ConformanceDriverLineFailedValue" (\fields -> ConformanceDriverLineFailedValue <$> (fields .: "error") <*> (fields .: "id"))

instance ToJSON ConformanceDriverLineFailedValue where toJSON value = Object (KM.fromList (concat [[("error", toJSON (conformanceDriverLineFailedValueError value))], [("id", toJSON (conformanceDriverLineFailedValueId value))]]))

data ConformanceDriverLineFrameValue = ConformanceDriverLineFrameValue
  { conformanceDriverLineFrameValueFrame :: ConformanceDriverLineFrameValueFrame
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineFrameValue where parseJSON = checked "ConformanceDriverLineFrameValue" $ withObject "ConformanceDriverLineFrameValue" (\fields -> ConformanceDriverLineFrameValue <$> (fields .: "frame"))

instance ToJSON ConformanceDriverLineFrameValue where toJSON value = Object (KM.fromList (concat [[("frame", toJSON (conformanceDriverLineFrameValueFrame value))]]))

data ConformanceDriverLineFrameValueFrame = ConformanceDriverLineFrameValueFrame
  { conformanceDriverLineFrameValueFrameChannel :: Text,
    conformanceDriverLineFrameValueFrameCorrelationId :: Maybe Text,
    conformanceDriverLineFrameValueFramePayload :: Maybe Value,
    conformanceDriverLineFrameValueFrameScope :: Maybe ResourceId
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineFrameValueFrame where parseJSON = checked "ConformanceDriverLineFrameValueFrame" $ withObject "ConformanceDriverLineFrameValueFrame" (\fields -> ConformanceDriverLineFrameValueFrame <$> (fields .: "channel") <*> optional fields "correlationId" <*> optional fields "payload" <*> optional fields "scope")

instance ToJSON ConformanceDriverLineFrameValueFrame where toJSON value = Object (KM.fromList (concat [[("channel", toJSON (conformanceDriverLineFrameValueFrameChannel value))], optionalPair "correlationId" (conformanceDriverLineFrameValueFrameCorrelationId value), optionalPair "payload" (conformanceDriverLineFrameValueFramePayload value), optionalPair "scope" (conformanceDriverLineFrameValueFrameScope value)]))

data ConformanceDriverLineMisuseValue = ConformanceDriverLineMisuseValue
  { conformanceDriverLineMisuseValueId :: Integer,
    conformanceDriverLineMisuseValueMisuse :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineMisuseValue where parseJSON = checked "ConformanceDriverLineMisuseValue" $ withObject "ConformanceDriverLineMisuseValue" (\fields -> ConformanceDriverLineMisuseValue <$> (fields .: "id") <*> (fields .: "misuse"))

instance ToJSON ConformanceDriverLineMisuseValue where toJSON value = Object (KM.fromList (concat [[("id", toJSON (conformanceDriverLineMisuseValueId value))], [("misuse", toJSON (conformanceDriverLineMisuseValueMisuse value))]]))

data ConformanceDriverLineOkValue = ConformanceDriverLineOkValue
  { conformanceDriverLineOkValueId :: Integer,
    conformanceDriverLineOkValueOk :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineOkValue where parseJSON = checked "ConformanceDriverLineOkValue" $ withObject "ConformanceDriverLineOkValue" (\fields -> ConformanceDriverLineOkValue <$> (fields .: "id") <*> (fields .: "ok"))

instance ToJSON ConformanceDriverLineOkValue where toJSON value = Object (KM.fromList (concat [[("id", toJSON (conformanceDriverLineOkValueId value))], [("ok", toJSON (conformanceDriverLineOkValueOk value))]]))

data ConformanceDriverLineProgressValue = ConformanceDriverLineProgressValue
  { conformanceDriverLineProgressValueProgress :: ConformanceDriverLineProgressValueProgress
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineProgressValue where parseJSON = checked "ConformanceDriverLineProgressValue" $ withObject "ConformanceDriverLineProgressValue" (\fields -> ConformanceDriverLineProgressValue <$> (fields .: "progress"))

instance ToJSON ConformanceDriverLineProgressValue where toJSON value = Object (KM.fromList (concat [[("progress", toJSON (conformanceDriverLineProgressValueProgress value))]]))

data ConformanceDriverLineProgressValueProgress = ConformanceDriverLineProgressValueProgress
  { conformanceDriverLineProgressValueProgressBytesUploaded :: Integer,
    conformanceDriverLineProgressValueProgressTotalBytes :: Integer,
    conformanceDriverLineProgressValueProgressUpload :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineProgressValueProgress where parseJSON = checked "ConformanceDriverLineProgressValueProgress" $ withObject "ConformanceDriverLineProgressValueProgress" (\fields -> ConformanceDriverLineProgressValueProgress <$> (fields .: "bytesUploaded") <*> (fields .: "totalBytes") <*> (fields .: "upload"))

instance ToJSON ConformanceDriverLineProgressValueProgress where toJSON value = Object (KM.fromList (concat [[("bytesUploaded", toJSON (conformanceDriverLineProgressValueProgressBytesUploaded value))], [("totalBytes", toJSON (conformanceDriverLineProgressValueProgressTotalBytes value))], [("upload", toJSON (conformanceDriverLineProgressValueProgressUpload value))]]))

data ConformanceDriverLineReadyValue = ConformanceDriverLineReadyValue
  { conformanceDriverLineReadyValueReady :: ConformanceDriverLineReadyValueReady
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineReadyValue where parseJSON = checked "ConformanceDriverLineReadyValue" $ withObject "ConformanceDriverLineReadyValue" (\fields -> ConformanceDriverLineReadyValue <$> (fields .: "ready"))

instance ToJSON ConformanceDriverLineReadyValue where toJSON value = Object (KM.fromList (concat [[("ready", toJSON (conformanceDriverLineReadyValueReady value))]]))

data ConformanceDriverLineReadyValueReady = ConformanceDriverLineReadyValueReadyTrue deriving (Eq, Show)

instance FromJSON ConformanceDriverLineReadyValueReady where parseJSON = checked "ConformanceDriverLineReadyValueReady" $ \value -> if value == Bool True then pure ConformanceDriverLineReadyValueReadyTrue else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineReadyValueReady where toJSON ConformanceDriverLineReadyValueReadyTrue = Bool True

data ConformanceDriverLineRefusedValue = ConformanceDriverLineRefusedValue
  { conformanceDriverLineRefusedValueRefused :: ConformanceFailure
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineRefusedValue where parseJSON = checked "ConformanceDriverLineRefusedValue" $ withObject "ConformanceDriverLineRefusedValue" (\fields -> ConformanceDriverLineRefusedValue <$> (fields .: "refused"))

instance ToJSON ConformanceDriverLineRefusedValue where toJSON value = Object (KM.fromList (concat [[("refused", toJSON (conformanceDriverLineRefusedValueRefused value))]]))

data ConformanceDriverLineSignalledValue = ConformanceDriverLineSignalledValue
  { conformanceDriverLineSignalledValueSignalled :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineSignalledValue where parseJSON = checked "ConformanceDriverLineSignalledValue" $ withObject "ConformanceDriverLineSignalledValue" (\fields -> ConformanceDriverLineSignalledValue <$> (fields .: "signalled"))

instance ToJSON ConformanceDriverLineSignalledValue where toJSON value = Object (KM.fromList (concat [[("signalled", toJSON (conformanceDriverLineSignalledValueSignalled value))]]))

data ConformanceDriverLineStalledValue = ConformanceDriverLineStalledValue
  { conformanceDriverLineStalledValueStalled :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineStalledValue where parseJSON = checked "ConformanceDriverLineStalledValue" $ withObject "ConformanceDriverLineStalledValue" (\fields -> ConformanceDriverLineStalledValue <$> (fields .: "stalled"))

instance ToJSON ConformanceDriverLineStalledValue where toJSON value = Object (KM.fromList (concat [[("stalled", toJSON (conformanceDriverLineStalledValueStalled value))]]))

data ConformanceDriverLineStateValue = ConformanceDriverLineStateValue
  { conformanceDriverLineStateValueState :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineStateValue where parseJSON = checked "ConformanceDriverLineStateValue" $ withObject "ConformanceDriverLineStateValue" (\fields -> ConformanceDriverLineStateValue <$> (fields .: "state"))

instance ToJSON ConformanceDriverLineStateValue where toJSON value = Object (KM.fromList (concat [[("state", toJSON (conformanceDriverLineStateValueState value))]]))

data ConformanceDriverLineUnsupportedValue = ConformanceDriverLineUnsupportedValue
  { conformanceDriverLineUnsupportedValueId :: Integer,
    conformanceDriverLineUnsupportedValueUnsupported :: ConformanceDriverLineUnsupportedValueUnsupported
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineUnsupportedValue where parseJSON = checked "ConformanceDriverLineUnsupportedValue" $ withObject "ConformanceDriverLineUnsupportedValue" (\fields -> ConformanceDriverLineUnsupportedValue <$> (fields .: "id") <*> (fields .: "unsupported"))

instance ToJSON ConformanceDriverLineUnsupportedValue where toJSON value = Object (KM.fromList (concat [[("id", toJSON (conformanceDriverLineUnsupportedValueId value))], [("unsupported", toJSON (conformanceDriverLineUnsupportedValueUnsupported value))]]))

data ConformanceDriverLineUnsupportedValueUnsupported = ConformanceDriverLineUnsupportedValueUnsupportedTrue deriving (Eq, Show)

instance FromJSON ConformanceDriverLineUnsupportedValueUnsupported where parseJSON = checked "ConformanceDriverLineUnsupportedValueUnsupported" $ \value -> if value == Bool True then pure ConformanceDriverLineUnsupportedValueUnsupportedTrue else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineUnsupportedValueUnsupported where toJSON ConformanceDriverLineUnsupportedValueUnsupportedTrue = Bool True
