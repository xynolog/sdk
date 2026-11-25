-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ConformanceDriverLine (ConformanceDriverLine (..), ConformanceDriverLineAbandoned (..), ConformanceDriverLineAbandonedAbandoned (..), ConformanceDriverLineClaimed (..), ConformanceDriverLineClaimedClaimed (..), ConformanceDriverLineCompleted (..), ConformanceDriverLineEmission (..), ConformanceDriverLineEmissionEmission (..), ConformanceDriverLineEmissionEmissionState (..), ConformanceDriverLineEmissionEmissionStateFailed (..), ConformanceDriverLineEmissionEmissionStateFailedStatus (..), conformanceDriverLineEmissionEmissionStateFailedStatusText, ConformanceDriverLineEmissionEmissionStatePending (..), ConformanceDriverLineEmissionEmissionStatePendingStatus (..), conformanceDriverLineEmissionEmissionStatePendingStatusText, ConformanceDriverLineEmissionEmissionStateReady (..), ConformanceDriverLineEmissionEmissionStateReadyStatus (..), conformanceDriverLineEmissionEmissionStateReadyStatusText, ConformanceDriverLineErrorStream (..), ConformanceDriverLineFailed (..), ConformanceDriverLineFrame (..), ConformanceDriverLineFrameFrame (..), ConformanceDriverLineMisuse (..), ConformanceDriverLineOk (..), ConformanceDriverLineProgress (..), ConformanceDriverLineProgressProgress (..), ConformanceDriverLineReady (..), ConformanceDriverLineReadyReady (..), ConformanceDriverLineRefused (..), ConformanceDriverLineSignalled (..), ConformanceDriverLineStalled (..), ConformanceDriverLineState (..), ConformanceDriverLineUnsupported (..), ConformanceDriverLineUnsupportedUnsupported (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ConformanceFailure
import Xynolog.Internal.Generated.Models.ResourceId

data ConformanceDriverLine = ConformanceDriverLineReady ConformanceDriverLineReady | ConformanceDriverLineOk ConformanceDriverLineOk | ConformanceDriverLineFailed ConformanceDriverLineFailed | ConformanceDriverLineAbandoned ConformanceDriverLineAbandoned | ConformanceDriverLineUnsupported ConformanceDriverLineUnsupported | ConformanceDriverLineMisuse ConformanceDriverLineMisuse | ConformanceDriverLineState ConformanceDriverLineState | ConformanceDriverLineFrame ConformanceDriverLineFrame | ConformanceDriverLineErrorStream ConformanceDriverLineErrorStream | ConformanceDriverLineProgress ConformanceDriverLineProgress | ConformanceDriverLineEmission ConformanceDriverLineEmission | ConformanceDriverLineCompleted ConformanceDriverLineCompleted | ConformanceDriverLineClaimed ConformanceDriverLineClaimed | ConformanceDriverLineRefused ConformanceDriverLineRefused | ConformanceDriverLineSignalled ConformanceDriverLineSignalled | ConformanceDriverLineStalled ConformanceDriverLineStalled deriving (Eq, Show)

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

data ConformanceDriverLineAbandoned = MkConformanceDriverLineAbandoned
  { conformanceDriverLineAbandonedAbandoned :: ConformanceDriverLineAbandonedAbandoned,
    conformanceDriverLineAbandonedId :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineAbandoned where parseJSON = checked "ConformanceDriverLineAbandoned" $ withObject "ConformanceDriverLineAbandoned" (\fields -> MkConformanceDriverLineAbandoned <$> (fields .: "abandoned") <*> (fields .: "id"))

instance ToJSON ConformanceDriverLineAbandoned where toJSON value = Object (KM.fromList (concat [[("abandoned", toJSON (conformanceDriverLineAbandonedAbandoned value))], [("id", toJSON (conformanceDriverLineAbandonedId value))]]))

data ConformanceDriverLineAbandonedAbandoned = ConformanceDriverLineAbandonedAbandonedTrue deriving (Eq, Show)

instance FromJSON ConformanceDriverLineAbandonedAbandoned where parseJSON = checked "ConformanceDriverLineAbandonedAbandoned" $ \value -> if value == Bool True then pure ConformanceDriverLineAbandonedAbandonedTrue else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineAbandonedAbandoned where toJSON ConformanceDriverLineAbandonedAbandonedTrue = Bool True

data ConformanceDriverLineClaimed = MkConformanceDriverLineClaimed
  { conformanceDriverLineClaimedClaimed :: ConformanceDriverLineClaimedClaimed
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineClaimed where parseJSON = checked "ConformanceDriverLineClaimed" $ withObject "ConformanceDriverLineClaimed" (\fields -> MkConformanceDriverLineClaimed <$> (fields .: "claimed"))

instance ToJSON ConformanceDriverLineClaimed where toJSON value = Object (KM.fromList (concat [[("claimed", toJSON (conformanceDriverLineClaimedClaimed value))]]))

data ConformanceDriverLineClaimedClaimed = ConformanceDriverLineClaimedClaimed
  { conformanceDriverLineClaimedClaimedAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineClaimedClaimed where parseJSON = checked "ConformanceDriverLineClaimedClaimed" $ withObject "ConformanceDriverLineClaimedClaimed" (\fields -> ConformanceDriverLineClaimedClaimed <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ConformanceDriverLineClaimedClaimed where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (conformanceDriverLineClaimedClaimedAdditionalProperties value)))

data ConformanceDriverLineCompleted = MkConformanceDriverLineCompleted
  { conformanceDriverLineCompletedCompleted :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineCompleted where parseJSON = checked "ConformanceDriverLineCompleted" $ withObject "ConformanceDriverLineCompleted" (\fields -> MkConformanceDriverLineCompleted <$> (fields .: "completed"))

instance ToJSON ConformanceDriverLineCompleted where toJSON value = Object (KM.fromList (concat [[("completed", toJSON (conformanceDriverLineCompletedCompleted value))]]))

data ConformanceDriverLineEmission = MkConformanceDriverLineEmission
  { conformanceDriverLineEmissionEmission :: ConformanceDriverLineEmissionEmission
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmission where parseJSON = checked "ConformanceDriverLineEmission" $ withObject "ConformanceDriverLineEmission" (\fields -> MkConformanceDriverLineEmission <$> (fields .: "emission"))

instance ToJSON ConformanceDriverLineEmission where toJSON value = Object (KM.fromList (concat [[("emission", toJSON (conformanceDriverLineEmissionEmission value))]]))

data ConformanceDriverLineEmissionEmission = ConformanceDriverLineEmissionEmission
  { conformanceDriverLineEmissionEmissionObserver :: Text,
    conformanceDriverLineEmissionEmissionState :: ConformanceDriverLineEmissionEmissionState
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmissionEmission where parseJSON = checked "ConformanceDriverLineEmissionEmission" $ withObject "ConformanceDriverLineEmissionEmission" (\fields -> ConformanceDriverLineEmissionEmission <$> (fields .: "observer") <*> (fields .: "state"))

instance ToJSON ConformanceDriverLineEmissionEmission where toJSON value = Object (KM.fromList (concat [[("observer", toJSON (conformanceDriverLineEmissionEmissionObserver value))], [("state", toJSON (conformanceDriverLineEmissionEmissionState value))]]))

data ConformanceDriverLineEmissionEmissionState = ConformanceDriverLineEmissionEmissionStatePending ConformanceDriverLineEmissionEmissionStatePending | ConformanceDriverLineEmissionEmissionStateReady ConformanceDriverLineEmissionEmissionStateReady | ConformanceDriverLineEmissionEmissionStateFailed ConformanceDriverLineEmissionEmissionStateFailed deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmissionEmissionState where parseJSON = checked "ConformanceDriverLineEmissionEmissionState" $ \value -> (ConformanceDriverLineEmissionEmissionStatePending <$> parseJSON value) <|> (ConformanceDriverLineEmissionEmissionStateReady <$> parseJSON value) <|> (ConformanceDriverLineEmissionEmissionStateFailed <$> parseJSON value)

instance ToJSON ConformanceDriverLineEmissionEmissionState where
  toJSON (ConformanceDriverLineEmissionEmissionStatePending value) = toJSON value
  toJSON (ConformanceDriverLineEmissionEmissionStateReady value) = toJSON value
  toJSON (ConformanceDriverLineEmissionEmissionStateFailed value) = toJSON value

data ConformanceDriverLineEmissionEmissionStateFailed = MkConformanceDriverLineEmissionEmissionStateFailed
  { conformanceDriverLineEmissionEmissionStateFailedError :: ConformanceFailure,
    conformanceDriverLineEmissionEmissionStateFailedStatus :: ConformanceDriverLineEmissionEmissionStateFailedStatus
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmissionEmissionStateFailed where parseJSON = checked "ConformanceDriverLineEmissionEmissionStateFailed" $ withObject "ConformanceDriverLineEmissionEmissionStateFailed" (\fields -> MkConformanceDriverLineEmissionEmissionStateFailed <$> (fields .: "error") <*> (fields .: "status"))

instance ToJSON ConformanceDriverLineEmissionEmissionStateFailed where toJSON value = Object (KM.fromList (concat [[("error", toJSON (conformanceDriverLineEmissionEmissionStateFailedError value))], [("status", toJSON (conformanceDriverLineEmissionEmissionStateFailedStatus value))]]))

data ConformanceDriverLineEmissionEmissionStateFailedStatus = ConformanceDriverLineEmissionEmissionStateFailedStatusFailed deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmissionEmissionStateFailedStatus where parseJSON = checked "ConformanceDriverLineEmissionEmissionStateFailedStatus" $ \value -> if value == String "failed" then pure ConformanceDriverLineEmissionEmissionStateFailedStatusFailed else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineEmissionEmissionStateFailedStatus where toJSON ConformanceDriverLineEmissionEmissionStateFailedStatusFailed = String "failed"

conformanceDriverLineEmissionEmissionStateFailedStatusText :: ConformanceDriverLineEmissionEmissionStateFailedStatus -> Text
conformanceDriverLineEmissionEmissionStateFailedStatusText ConformanceDriverLineEmissionEmissionStateFailedStatusFailed = "failed"

data ConformanceDriverLineEmissionEmissionStatePending = MkConformanceDriverLineEmissionEmissionStatePending
  { conformanceDriverLineEmissionEmissionStatePendingStatus :: ConformanceDriverLineEmissionEmissionStatePendingStatus
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmissionEmissionStatePending where parseJSON = checked "ConformanceDriverLineEmissionEmissionStatePending" $ withObject "ConformanceDriverLineEmissionEmissionStatePending" (\fields -> MkConformanceDriverLineEmissionEmissionStatePending <$> (fields .: "status"))

instance ToJSON ConformanceDriverLineEmissionEmissionStatePending where toJSON value = Object (KM.fromList (concat [[("status", toJSON (conformanceDriverLineEmissionEmissionStatePendingStatus value))]]))

data ConformanceDriverLineEmissionEmissionStatePendingStatus = ConformanceDriverLineEmissionEmissionStatePendingStatusPending deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmissionEmissionStatePendingStatus where parseJSON = checked "ConformanceDriverLineEmissionEmissionStatePendingStatus" $ \value -> if value == String "pending" then pure ConformanceDriverLineEmissionEmissionStatePendingStatusPending else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineEmissionEmissionStatePendingStatus where toJSON ConformanceDriverLineEmissionEmissionStatePendingStatusPending = String "pending"

conformanceDriverLineEmissionEmissionStatePendingStatusText :: ConformanceDriverLineEmissionEmissionStatePendingStatus -> Text
conformanceDriverLineEmissionEmissionStatePendingStatusText ConformanceDriverLineEmissionEmissionStatePendingStatusPending = "pending"

data ConformanceDriverLineEmissionEmissionStateReady = MkConformanceDriverLineEmissionEmissionStateReady
  { conformanceDriverLineEmissionEmissionStateReadyStatus :: ConformanceDriverLineEmissionEmissionStateReadyStatus,
    conformanceDriverLineEmissionEmissionStateReadyValue :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmissionEmissionStateReady where parseJSON = checked "ConformanceDriverLineEmissionEmissionStateReady" $ withObject "ConformanceDriverLineEmissionEmissionStateReady" (\fields -> MkConformanceDriverLineEmissionEmissionStateReady <$> (fields .: "status") <*> (fields .: "value"))

instance ToJSON ConformanceDriverLineEmissionEmissionStateReady where toJSON value = Object (KM.fromList (concat [[("status", toJSON (conformanceDriverLineEmissionEmissionStateReadyStatus value))], [("value", toJSON (conformanceDriverLineEmissionEmissionStateReadyValue value))]]))

data ConformanceDriverLineEmissionEmissionStateReadyStatus = ConformanceDriverLineEmissionEmissionStateReadyStatusReady deriving (Eq, Show)

instance FromJSON ConformanceDriverLineEmissionEmissionStateReadyStatus where parseJSON = checked "ConformanceDriverLineEmissionEmissionStateReadyStatus" $ \value -> if value == String "ready" then pure ConformanceDriverLineEmissionEmissionStateReadyStatusReady else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineEmissionEmissionStateReadyStatus where toJSON ConformanceDriverLineEmissionEmissionStateReadyStatusReady = String "ready"

conformanceDriverLineEmissionEmissionStateReadyStatusText :: ConformanceDriverLineEmissionEmissionStateReadyStatus -> Text
conformanceDriverLineEmissionEmissionStateReadyStatusText ConformanceDriverLineEmissionEmissionStateReadyStatusReady = "ready"

data ConformanceDriverLineErrorStream = MkConformanceDriverLineErrorStream
  { conformanceDriverLineErrorStreamError :: ConformanceFailure
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineErrorStream where parseJSON = checked "ConformanceDriverLineErrorStream" $ withObject "ConformanceDriverLineErrorStream" (\fields -> MkConformanceDriverLineErrorStream <$> (fields .: "error"))

instance ToJSON ConformanceDriverLineErrorStream where toJSON value = Object (KM.fromList (concat [[("error", toJSON (conformanceDriverLineErrorStreamError value))]]))

data ConformanceDriverLineFailed = MkConformanceDriverLineFailed
  { conformanceDriverLineFailedError :: ConformanceFailure,
    conformanceDriverLineFailedId :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineFailed where parseJSON = checked "ConformanceDriverLineFailed" $ withObject "ConformanceDriverLineFailed" (\fields -> MkConformanceDriverLineFailed <$> (fields .: "error") <*> (fields .: "id"))

instance ToJSON ConformanceDriverLineFailed where toJSON value = Object (KM.fromList (concat [[("error", toJSON (conformanceDriverLineFailedError value))], [("id", toJSON (conformanceDriverLineFailedId value))]]))

data ConformanceDriverLineFrame = MkConformanceDriverLineFrame
  { conformanceDriverLineFrameFrame :: ConformanceDriverLineFrameFrame
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineFrame where parseJSON = checked "ConformanceDriverLineFrame" $ withObject "ConformanceDriverLineFrame" (\fields -> MkConformanceDriverLineFrame <$> (fields .: "frame"))

instance ToJSON ConformanceDriverLineFrame where toJSON value = Object (KM.fromList (concat [[("frame", toJSON (conformanceDriverLineFrameFrame value))]]))

data ConformanceDriverLineFrameFrame = ConformanceDriverLineFrameFrame
  { conformanceDriverLineFrameFrameChannel :: Text,
    conformanceDriverLineFrameFrameCorrelationId :: Maybe Text,
    conformanceDriverLineFrameFramePayload :: Maybe Value,
    conformanceDriverLineFrameFrameScope :: Maybe ResourceId
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineFrameFrame where parseJSON = checked "ConformanceDriverLineFrameFrame" $ withObject "ConformanceDriverLineFrameFrame" (\fields -> ConformanceDriverLineFrameFrame <$> (fields .: "channel") <*> optional fields "correlationId" <*> optional fields "payload" <*> optional fields "scope")

instance ToJSON ConformanceDriverLineFrameFrame where toJSON value = Object (KM.fromList (concat [[("channel", toJSON (conformanceDriverLineFrameFrameChannel value))], optionalPair "correlationId" (conformanceDriverLineFrameFrameCorrelationId value), optionalPair "payload" (conformanceDriverLineFrameFramePayload value), optionalPair "scope" (conformanceDriverLineFrameFrameScope value)]))

data ConformanceDriverLineMisuse = MkConformanceDriverLineMisuse
  { conformanceDriverLineMisuseId :: Integer,
    conformanceDriverLineMisuseMisuse :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineMisuse where parseJSON = checked "ConformanceDriverLineMisuse" $ withObject "ConformanceDriverLineMisuse" (\fields -> MkConformanceDriverLineMisuse <$> (fields .: "id") <*> (fields .: "misuse"))

instance ToJSON ConformanceDriverLineMisuse where toJSON value = Object (KM.fromList (concat [[("id", toJSON (conformanceDriverLineMisuseId value))], [("misuse", toJSON (conformanceDriverLineMisuseMisuse value))]]))

data ConformanceDriverLineOk = MkConformanceDriverLineOk
  { conformanceDriverLineOkId :: Integer,
    conformanceDriverLineOkOk :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineOk where parseJSON = checked "ConformanceDriverLineOk" $ withObject "ConformanceDriverLineOk" (\fields -> MkConformanceDriverLineOk <$> (fields .: "id") <*> (fields .: "ok"))

instance ToJSON ConformanceDriverLineOk where toJSON value = Object (KM.fromList (concat [[("id", toJSON (conformanceDriverLineOkId value))], [("ok", toJSON (conformanceDriverLineOkOk value))]]))

data ConformanceDriverLineProgress = MkConformanceDriverLineProgress
  { conformanceDriverLineProgressProgress :: ConformanceDriverLineProgressProgress
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineProgress where parseJSON = checked "ConformanceDriverLineProgress" $ withObject "ConformanceDriverLineProgress" (\fields -> MkConformanceDriverLineProgress <$> (fields .: "progress"))

instance ToJSON ConformanceDriverLineProgress where toJSON value = Object (KM.fromList (concat [[("progress", toJSON (conformanceDriverLineProgressProgress value))]]))

data ConformanceDriverLineProgressProgress = ConformanceDriverLineProgressProgress
  { conformanceDriverLineProgressProgressBytesUploaded :: Integer,
    conformanceDriverLineProgressProgressTotalBytes :: Integer,
    conformanceDriverLineProgressProgressUpload :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineProgressProgress where parseJSON = checked "ConformanceDriverLineProgressProgress" $ withObject "ConformanceDriverLineProgressProgress" (\fields -> ConformanceDriverLineProgressProgress <$> (fields .: "bytesUploaded") <*> (fields .: "totalBytes") <*> (fields .: "upload"))

instance ToJSON ConformanceDriverLineProgressProgress where toJSON value = Object (KM.fromList (concat [[("bytesUploaded", toJSON (conformanceDriverLineProgressProgressBytesUploaded value))], [("totalBytes", toJSON (conformanceDriverLineProgressProgressTotalBytes value))], [("upload", toJSON (conformanceDriverLineProgressProgressUpload value))]]))

data ConformanceDriverLineReady = MkConformanceDriverLineReady
  { conformanceDriverLineReadyReady :: ConformanceDriverLineReadyReady
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineReady where parseJSON = checked "ConformanceDriverLineReady" $ withObject "ConformanceDriverLineReady" (\fields -> MkConformanceDriverLineReady <$> (fields .: "ready"))

instance ToJSON ConformanceDriverLineReady where toJSON value = Object (KM.fromList (concat [[("ready", toJSON (conformanceDriverLineReadyReady value))]]))

data ConformanceDriverLineReadyReady = ConformanceDriverLineReadyReadyTrue deriving (Eq, Show)

instance FromJSON ConformanceDriverLineReadyReady where parseJSON = checked "ConformanceDriverLineReadyReady" $ \value -> if value == Bool True then pure ConformanceDriverLineReadyReadyTrue else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineReadyReady where toJSON ConformanceDriverLineReadyReadyTrue = Bool True

data ConformanceDriverLineRefused = MkConformanceDriverLineRefused
  { conformanceDriverLineRefusedRefused :: ConformanceFailure
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineRefused where parseJSON = checked "ConformanceDriverLineRefused" $ withObject "ConformanceDriverLineRefused" (\fields -> MkConformanceDriverLineRefused <$> (fields .: "refused"))

instance ToJSON ConformanceDriverLineRefused where toJSON value = Object (KM.fromList (concat [[("refused", toJSON (conformanceDriverLineRefusedRefused value))]]))

data ConformanceDriverLineSignalled = MkConformanceDriverLineSignalled
  { conformanceDriverLineSignalledSignalled :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineSignalled where parseJSON = checked "ConformanceDriverLineSignalled" $ withObject "ConformanceDriverLineSignalled" (\fields -> MkConformanceDriverLineSignalled <$> (fields .: "signalled"))

instance ToJSON ConformanceDriverLineSignalled where toJSON value = Object (KM.fromList (concat [[("signalled", toJSON (conformanceDriverLineSignalledSignalled value))]]))

data ConformanceDriverLineStalled = MkConformanceDriverLineStalled
  { conformanceDriverLineStalledStalled :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineStalled where parseJSON = checked "ConformanceDriverLineStalled" $ withObject "ConformanceDriverLineStalled" (\fields -> MkConformanceDriverLineStalled <$> (fields .: "stalled"))

instance ToJSON ConformanceDriverLineStalled where toJSON value = Object (KM.fromList (concat [[("stalled", toJSON (conformanceDriverLineStalledStalled value))]]))

data ConformanceDriverLineState = MkConformanceDriverLineState
  { conformanceDriverLineStateState :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineState where parseJSON = checked "ConformanceDriverLineState" $ withObject "ConformanceDriverLineState" (\fields -> MkConformanceDriverLineState <$> (fields .: "state"))

instance ToJSON ConformanceDriverLineState where toJSON value = Object (KM.fromList (concat [[("state", toJSON (conformanceDriverLineStateState value))]]))

data ConformanceDriverLineUnsupported = MkConformanceDriverLineUnsupported
  { conformanceDriverLineUnsupportedId :: Integer,
    conformanceDriverLineUnsupportedUnsupported :: ConformanceDriverLineUnsupportedUnsupported
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineUnsupported where parseJSON = checked "ConformanceDriverLineUnsupported" $ withObject "ConformanceDriverLineUnsupported" (\fields -> MkConformanceDriverLineUnsupported <$> (fields .: "id") <*> (fields .: "unsupported"))

instance ToJSON ConformanceDriverLineUnsupported where toJSON value = Object (KM.fromList (concat [[("id", toJSON (conformanceDriverLineUnsupportedId value))], [("unsupported", toJSON (conformanceDriverLineUnsupportedUnsupported value))]]))

data ConformanceDriverLineUnsupportedUnsupported = ConformanceDriverLineUnsupportedUnsupportedTrue deriving (Eq, Show)

instance FromJSON ConformanceDriverLineUnsupportedUnsupported where parseJSON = checked "ConformanceDriverLineUnsupportedUnsupported" $ \value -> if value == Bool True then pure ConformanceDriverLineUnsupportedUnsupportedTrue else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineUnsupportedUnsupported where toJSON ConformanceDriverLineUnsupportedUnsupportedTrue = Bool True
