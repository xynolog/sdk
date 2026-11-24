-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ConformanceDriverLine (ConformanceDriverLine (..), ConformanceDriverLineBranch10Value (..), ConformanceDriverLineBranch10ValueProgress (..), ConformanceDriverLineBranch11Value (..), ConformanceDriverLineBranch11ValueEmission (..), ConformanceDriverLineBranch11ValueEmissionState (..), ConformanceDriverLineBranch11ValueEmissionStateBranch1Value (..), ConformanceDriverLineBranch11ValueEmissionStateBranch1ValueStatus (..), ConformanceDriverLineBranch11ValueEmissionStateBranch2Value (..), ConformanceDriverLineBranch11ValueEmissionStateBranch2ValueStatus (..), ConformanceDriverLineBranch11ValueEmissionStateBranch3Value (..), ConformanceDriverLineBranch11ValueEmissionStateBranch3ValueStatus (..), ConformanceDriverLineBranch12Value (..), ConformanceDriverLineBranch13Value (..), ConformanceDriverLineBranch13ValueClaimed (..), ConformanceDriverLineBranch14Value (..), ConformanceDriverLineBranch15Value (..), ConformanceDriverLineBranch16Value (..), ConformanceDriverLineBranch1Value (..), ConformanceDriverLineBranch1ValueReady (..), ConformanceDriverLineBranch2Value (..), ConformanceDriverLineBranch3Value (..), ConformanceDriverLineBranch4Value (..), ConformanceDriverLineBranch4ValueAbandoned (..), ConformanceDriverLineBranch5Value (..), ConformanceDriverLineBranch5ValueUnsupported (..), ConformanceDriverLineBranch6Value (..), ConformanceDriverLineBranch7Value (..), ConformanceDriverLineBranch8Value (..), ConformanceDriverLineBranch8ValueFrame (..), ConformanceDriverLineBranch9Value (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ConformanceFailure
import Xynolog.Internal.Generated.Models.ResourceId

data ConformanceDriverLine = ConformanceDriverLineBranch1 ConformanceDriverLineBranch1Value | ConformanceDriverLineBranch2 ConformanceDriverLineBranch2Value | ConformanceDriverLineBranch3 ConformanceDriverLineBranch3Value | ConformanceDriverLineBranch4 ConformanceDriverLineBranch4Value | ConformanceDriverLineBranch5 ConformanceDriverLineBranch5Value | ConformanceDriverLineBranch6 ConformanceDriverLineBranch6Value | ConformanceDriverLineBranch7 ConformanceDriverLineBranch7Value | ConformanceDriverLineBranch8 ConformanceDriverLineBranch8Value | ConformanceDriverLineBranch9 ConformanceDriverLineBranch9Value | ConformanceDriverLineBranch10 ConformanceDriverLineBranch10Value | ConformanceDriverLineBranch11 ConformanceDriverLineBranch11Value | ConformanceDriverLineBranch12 ConformanceDriverLineBranch12Value | ConformanceDriverLineBranch13 ConformanceDriverLineBranch13Value | ConformanceDriverLineBranch14 ConformanceDriverLineBranch14Value | ConformanceDriverLineBranch15 ConformanceDriverLineBranch15Value | ConformanceDriverLineBranch16 ConformanceDriverLineBranch16Value deriving (Eq, Show)

instance FromJSON ConformanceDriverLine where parseJSON = checked "ConformanceDriverLine" $ \value -> (ConformanceDriverLineBranch1 <$> parseJSON value) <|> (ConformanceDriverLineBranch2 <$> parseJSON value) <|> (ConformanceDriverLineBranch3 <$> parseJSON value) <|> (ConformanceDriverLineBranch4 <$> parseJSON value) <|> (ConformanceDriverLineBranch5 <$> parseJSON value) <|> (ConformanceDriverLineBranch6 <$> parseJSON value) <|> (ConformanceDriverLineBranch7 <$> parseJSON value) <|> (ConformanceDriverLineBranch8 <$> parseJSON value) <|> (ConformanceDriverLineBranch9 <$> parseJSON value) <|> (ConformanceDriverLineBranch10 <$> parseJSON value) <|> (ConformanceDriverLineBranch11 <$> parseJSON value) <|> (ConformanceDriverLineBranch12 <$> parseJSON value) <|> (ConformanceDriverLineBranch13 <$> parseJSON value) <|> (ConformanceDriverLineBranch14 <$> parseJSON value) <|> (ConformanceDriverLineBranch15 <$> parseJSON value) <|> (ConformanceDriverLineBranch16 <$> parseJSON value)

instance ToJSON ConformanceDriverLine where
  toJSON (ConformanceDriverLineBranch1 value) = toJSON value
  toJSON (ConformanceDriverLineBranch2 value) = toJSON value
  toJSON (ConformanceDriverLineBranch3 value) = toJSON value
  toJSON (ConformanceDriverLineBranch4 value) = toJSON value
  toJSON (ConformanceDriverLineBranch5 value) = toJSON value
  toJSON (ConformanceDriverLineBranch6 value) = toJSON value
  toJSON (ConformanceDriverLineBranch7 value) = toJSON value
  toJSON (ConformanceDriverLineBranch8 value) = toJSON value
  toJSON (ConformanceDriverLineBranch9 value) = toJSON value
  toJSON (ConformanceDriverLineBranch10 value) = toJSON value
  toJSON (ConformanceDriverLineBranch11 value) = toJSON value
  toJSON (ConformanceDriverLineBranch12 value) = toJSON value
  toJSON (ConformanceDriverLineBranch13 value) = toJSON value
  toJSON (ConformanceDriverLineBranch14 value) = toJSON value
  toJSON (ConformanceDriverLineBranch15 value) = toJSON value
  toJSON (ConformanceDriverLineBranch16 value) = toJSON value

data ConformanceDriverLineBranch10Value = ConformanceDriverLineBranch10Value
  { conformanceDriverLineBranch10ValueProgress :: ConformanceDriverLineBranch10ValueProgress
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch10Value where parseJSON = checked "ConformanceDriverLineBranch10Value" $ withObject "ConformanceDriverLineBranch10Value" (\fields -> ConformanceDriverLineBranch10Value <$> (fields .: "progress"))

instance ToJSON ConformanceDriverLineBranch10Value where toJSON value = Object (KM.fromList (concat [[("progress", toJSON (conformanceDriverLineBranch10ValueProgress value))]]))

data ConformanceDriverLineBranch10ValueProgress = ConformanceDriverLineBranch10ValueProgress
  { conformanceDriverLineBranch10ValueProgressBytesUploaded :: Integer,
    conformanceDriverLineBranch10ValueProgressTotalBytes :: Integer,
    conformanceDriverLineBranch10ValueProgressUpload :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch10ValueProgress where parseJSON = checked "ConformanceDriverLineBranch10ValueProgress" $ withObject "ConformanceDriverLineBranch10ValueProgress" (\fields -> ConformanceDriverLineBranch10ValueProgress <$> (fields .: "bytesUploaded") <*> (fields .: "totalBytes") <*> (fields .: "upload"))

instance ToJSON ConformanceDriverLineBranch10ValueProgress where toJSON value = Object (KM.fromList (concat [[("bytesUploaded", toJSON (conformanceDriverLineBranch10ValueProgressBytesUploaded value))], [("totalBytes", toJSON (conformanceDriverLineBranch10ValueProgressTotalBytes value))], [("upload", toJSON (conformanceDriverLineBranch10ValueProgressUpload value))]]))

data ConformanceDriverLineBranch11Value = ConformanceDriverLineBranch11Value
  { conformanceDriverLineBranch11ValueEmission :: ConformanceDriverLineBranch11ValueEmission
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch11Value where parseJSON = checked "ConformanceDriverLineBranch11Value" $ withObject "ConformanceDriverLineBranch11Value" (\fields -> ConformanceDriverLineBranch11Value <$> (fields .: "emission"))

instance ToJSON ConformanceDriverLineBranch11Value where toJSON value = Object (KM.fromList (concat [[("emission", toJSON (conformanceDriverLineBranch11ValueEmission value))]]))

data ConformanceDriverLineBranch11ValueEmission = ConformanceDriverLineBranch11ValueEmission
  { conformanceDriverLineBranch11ValueEmissionObserver :: Text,
    conformanceDriverLineBranch11ValueEmissionState :: ConformanceDriverLineBranch11ValueEmissionState
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch11ValueEmission where parseJSON = checked "ConformanceDriverLineBranch11ValueEmission" $ withObject "ConformanceDriverLineBranch11ValueEmission" (\fields -> ConformanceDriverLineBranch11ValueEmission <$> (fields .: "observer") <*> (fields .: "state"))

instance ToJSON ConformanceDriverLineBranch11ValueEmission where toJSON value = Object (KM.fromList (concat [[("observer", toJSON (conformanceDriverLineBranch11ValueEmissionObserver value))], [("state", toJSON (conformanceDriverLineBranch11ValueEmissionState value))]]))

data ConformanceDriverLineBranch11ValueEmissionState = ConformanceDriverLineBranch11ValueEmissionStateBranch1 ConformanceDriverLineBranch11ValueEmissionStateBranch1Value | ConformanceDriverLineBranch11ValueEmissionStateBranch2 ConformanceDriverLineBranch11ValueEmissionStateBranch2Value | ConformanceDriverLineBranch11ValueEmissionStateBranch3 ConformanceDriverLineBranch11ValueEmissionStateBranch3Value deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch11ValueEmissionState where parseJSON = checked "ConformanceDriverLineBranch11ValueEmissionState" $ \value -> (ConformanceDriverLineBranch11ValueEmissionStateBranch1 <$> parseJSON value) <|> (ConformanceDriverLineBranch11ValueEmissionStateBranch2 <$> parseJSON value) <|> (ConformanceDriverLineBranch11ValueEmissionStateBranch3 <$> parseJSON value)

instance ToJSON ConformanceDriverLineBranch11ValueEmissionState where
  toJSON (ConformanceDriverLineBranch11ValueEmissionStateBranch1 value) = toJSON value
  toJSON (ConformanceDriverLineBranch11ValueEmissionStateBranch2 value) = toJSON value
  toJSON (ConformanceDriverLineBranch11ValueEmissionStateBranch3 value) = toJSON value

data ConformanceDriverLineBranch11ValueEmissionStateBranch1Value = ConformanceDriverLineBranch11ValueEmissionStateBranch1Value
  { conformanceDriverLineBranch11ValueEmissionStateBranch1ValueStatus :: ConformanceDriverLineBranch11ValueEmissionStateBranch1ValueStatus
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch11ValueEmissionStateBranch1Value where parseJSON = checked "ConformanceDriverLineBranch11ValueEmissionStateBranch1Value" $ withObject "ConformanceDriverLineBranch11ValueEmissionStateBranch1Value" (\fields -> ConformanceDriverLineBranch11ValueEmissionStateBranch1Value <$> (fields .: "status"))

instance ToJSON ConformanceDriverLineBranch11ValueEmissionStateBranch1Value where toJSON value = Object (KM.fromList (concat [[("status", toJSON (conformanceDriverLineBranch11ValueEmissionStateBranch1ValueStatus value))]]))

data ConformanceDriverLineBranch11ValueEmissionStateBranch1ValueStatus = ConformanceDriverLineBranch11ValueEmissionStateBranch1ValueStatusPending deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch11ValueEmissionStateBranch1ValueStatus where parseJSON = checked "ConformanceDriverLineBranch11ValueEmissionStateBranch1ValueStatus" $ \value -> if value == String "pending" then pure ConformanceDriverLineBranch11ValueEmissionStateBranch1ValueStatusPending else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineBranch11ValueEmissionStateBranch1ValueStatus where toJSON ConformanceDriverLineBranch11ValueEmissionStateBranch1ValueStatusPending = String "pending"

data ConformanceDriverLineBranch11ValueEmissionStateBranch2Value = ConformanceDriverLineBranch11ValueEmissionStateBranch2Value
  { conformanceDriverLineBranch11ValueEmissionStateBranch2ValueStatus :: ConformanceDriverLineBranch11ValueEmissionStateBranch2ValueStatus,
    conformanceDriverLineBranch11ValueEmissionStateBranch2ValueValue :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch11ValueEmissionStateBranch2Value where parseJSON = checked "ConformanceDriverLineBranch11ValueEmissionStateBranch2Value" $ withObject "ConformanceDriverLineBranch11ValueEmissionStateBranch2Value" (\fields -> ConformanceDriverLineBranch11ValueEmissionStateBranch2Value <$> (fields .: "status") <*> (fields .: "value"))

instance ToJSON ConformanceDriverLineBranch11ValueEmissionStateBranch2Value where toJSON value = Object (KM.fromList (concat [[("status", toJSON (conformanceDriverLineBranch11ValueEmissionStateBranch2ValueStatus value))], [("value", toJSON (conformanceDriverLineBranch11ValueEmissionStateBranch2ValueValue value))]]))

data ConformanceDriverLineBranch11ValueEmissionStateBranch2ValueStatus = ConformanceDriverLineBranch11ValueEmissionStateBranch2ValueStatusReady deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch11ValueEmissionStateBranch2ValueStatus where parseJSON = checked "ConformanceDriverLineBranch11ValueEmissionStateBranch2ValueStatus" $ \value -> if value == String "ready" then pure ConformanceDriverLineBranch11ValueEmissionStateBranch2ValueStatusReady else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineBranch11ValueEmissionStateBranch2ValueStatus where toJSON ConformanceDriverLineBranch11ValueEmissionStateBranch2ValueStatusReady = String "ready"

data ConformanceDriverLineBranch11ValueEmissionStateBranch3Value = ConformanceDriverLineBranch11ValueEmissionStateBranch3Value
  { conformanceDriverLineBranch11ValueEmissionStateBranch3ValueError :: ConformanceFailure,
    conformanceDriverLineBranch11ValueEmissionStateBranch3ValueStatus :: ConformanceDriverLineBranch11ValueEmissionStateBranch3ValueStatus
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch11ValueEmissionStateBranch3Value where parseJSON = checked "ConformanceDriverLineBranch11ValueEmissionStateBranch3Value" $ withObject "ConformanceDriverLineBranch11ValueEmissionStateBranch3Value" (\fields -> ConformanceDriverLineBranch11ValueEmissionStateBranch3Value <$> (fields .: "error") <*> (fields .: "status"))

instance ToJSON ConformanceDriverLineBranch11ValueEmissionStateBranch3Value where toJSON value = Object (KM.fromList (concat [[("error", toJSON (conformanceDriverLineBranch11ValueEmissionStateBranch3ValueError value))], [("status", toJSON (conformanceDriverLineBranch11ValueEmissionStateBranch3ValueStatus value))]]))

data ConformanceDriverLineBranch11ValueEmissionStateBranch3ValueStatus = ConformanceDriverLineBranch11ValueEmissionStateBranch3ValueStatusFailed deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch11ValueEmissionStateBranch3ValueStatus where parseJSON = checked "ConformanceDriverLineBranch11ValueEmissionStateBranch3ValueStatus" $ \value -> if value == String "failed" then pure ConformanceDriverLineBranch11ValueEmissionStateBranch3ValueStatusFailed else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineBranch11ValueEmissionStateBranch3ValueStatus where toJSON ConformanceDriverLineBranch11ValueEmissionStateBranch3ValueStatusFailed = String "failed"

data ConformanceDriverLineBranch12Value = ConformanceDriverLineBranch12Value
  { conformanceDriverLineBranch12ValueCompleted :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch12Value where parseJSON = checked "ConformanceDriverLineBranch12Value" $ withObject "ConformanceDriverLineBranch12Value" (\fields -> ConformanceDriverLineBranch12Value <$> (fields .: "completed"))

instance ToJSON ConformanceDriverLineBranch12Value where toJSON value = Object (KM.fromList (concat [[("completed", toJSON (conformanceDriverLineBranch12ValueCompleted value))]]))

data ConformanceDriverLineBranch13Value = ConformanceDriverLineBranch13Value
  { conformanceDriverLineBranch13ValueClaimed :: ConformanceDriverLineBranch13ValueClaimed
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch13Value where parseJSON = checked "ConformanceDriverLineBranch13Value" $ withObject "ConformanceDriverLineBranch13Value" (\fields -> ConformanceDriverLineBranch13Value <$> (fields .: "claimed"))

instance ToJSON ConformanceDriverLineBranch13Value where toJSON value = Object (KM.fromList (concat [[("claimed", toJSON (conformanceDriverLineBranch13ValueClaimed value))]]))

data ConformanceDriverLineBranch13ValueClaimed = ConformanceDriverLineBranch13ValueClaimed
  { conformanceDriverLineBranch13ValueClaimedAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch13ValueClaimed where parseJSON = checked "ConformanceDriverLineBranch13ValueClaimed" $ withObject "ConformanceDriverLineBranch13ValueClaimed" (\fields -> ConformanceDriverLineBranch13ValueClaimed <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ConformanceDriverLineBranch13ValueClaimed where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (conformanceDriverLineBranch13ValueClaimedAdditionalProperties value)))

data ConformanceDriverLineBranch14Value = ConformanceDriverLineBranch14Value
  { conformanceDriverLineBranch14ValueRefused :: ConformanceFailure
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch14Value where parseJSON = checked "ConformanceDriverLineBranch14Value" $ withObject "ConformanceDriverLineBranch14Value" (\fields -> ConformanceDriverLineBranch14Value <$> (fields .: "refused"))

instance ToJSON ConformanceDriverLineBranch14Value where toJSON value = Object (KM.fromList (concat [[("refused", toJSON (conformanceDriverLineBranch14ValueRefused value))]]))

data ConformanceDriverLineBranch15Value = ConformanceDriverLineBranch15Value
  { conformanceDriverLineBranch15ValueSignalled :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch15Value where parseJSON = checked "ConformanceDriverLineBranch15Value" $ withObject "ConformanceDriverLineBranch15Value" (\fields -> ConformanceDriverLineBranch15Value <$> (fields .: "signalled"))

instance ToJSON ConformanceDriverLineBranch15Value where toJSON value = Object (KM.fromList (concat [[("signalled", toJSON (conformanceDriverLineBranch15ValueSignalled value))]]))

data ConformanceDriverLineBranch16Value = ConformanceDriverLineBranch16Value
  { conformanceDriverLineBranch16ValueStalled :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch16Value where parseJSON = checked "ConformanceDriverLineBranch16Value" $ withObject "ConformanceDriverLineBranch16Value" (\fields -> ConformanceDriverLineBranch16Value <$> (fields .: "stalled"))

instance ToJSON ConformanceDriverLineBranch16Value where toJSON value = Object (KM.fromList (concat [[("stalled", toJSON (conformanceDriverLineBranch16ValueStalled value))]]))

data ConformanceDriverLineBranch1Value = ConformanceDriverLineBranch1Value
  { conformanceDriverLineBranch1ValueReady :: ConformanceDriverLineBranch1ValueReady
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch1Value where parseJSON = checked "ConformanceDriverLineBranch1Value" $ withObject "ConformanceDriverLineBranch1Value" (\fields -> ConformanceDriverLineBranch1Value <$> (fields .: "ready"))

instance ToJSON ConformanceDriverLineBranch1Value where toJSON value = Object (KM.fromList (concat [[("ready", toJSON (conformanceDriverLineBranch1ValueReady value))]]))

data ConformanceDriverLineBranch1ValueReady = ConformanceDriverLineBranch1ValueReadyTrue deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch1ValueReady where parseJSON = checked "ConformanceDriverLineBranch1ValueReady" $ \value -> if value == Bool True then pure ConformanceDriverLineBranch1ValueReadyTrue else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineBranch1ValueReady where toJSON ConformanceDriverLineBranch1ValueReadyTrue = Bool True

data ConformanceDriverLineBranch2Value = ConformanceDriverLineBranch2Value
  { conformanceDriverLineBranch2ValueId :: Integer,
    conformanceDriverLineBranch2ValueOk :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch2Value where parseJSON = checked "ConformanceDriverLineBranch2Value" $ withObject "ConformanceDriverLineBranch2Value" (\fields -> ConformanceDriverLineBranch2Value <$> (fields .: "id") <*> (fields .: "ok"))

instance ToJSON ConformanceDriverLineBranch2Value where toJSON value = Object (KM.fromList (concat [[("id", toJSON (conformanceDriverLineBranch2ValueId value))], [("ok", toJSON (conformanceDriverLineBranch2ValueOk value))]]))

data ConformanceDriverLineBranch3Value = ConformanceDriverLineBranch3Value
  { conformanceDriverLineBranch3ValueError :: ConformanceFailure,
    conformanceDriverLineBranch3ValueId :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch3Value where parseJSON = checked "ConformanceDriverLineBranch3Value" $ withObject "ConformanceDriverLineBranch3Value" (\fields -> ConformanceDriverLineBranch3Value <$> (fields .: "error") <*> (fields .: "id"))

instance ToJSON ConformanceDriverLineBranch3Value where toJSON value = Object (KM.fromList (concat [[("error", toJSON (conformanceDriverLineBranch3ValueError value))], [("id", toJSON (conformanceDriverLineBranch3ValueId value))]]))

data ConformanceDriverLineBranch4Value = ConformanceDriverLineBranch4Value
  { conformanceDriverLineBranch4ValueAbandoned :: ConformanceDriverLineBranch4ValueAbandoned,
    conformanceDriverLineBranch4ValueId :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch4Value where parseJSON = checked "ConformanceDriverLineBranch4Value" $ withObject "ConformanceDriverLineBranch4Value" (\fields -> ConformanceDriverLineBranch4Value <$> (fields .: "abandoned") <*> (fields .: "id"))

instance ToJSON ConformanceDriverLineBranch4Value where toJSON value = Object (KM.fromList (concat [[("abandoned", toJSON (conformanceDriverLineBranch4ValueAbandoned value))], [("id", toJSON (conformanceDriverLineBranch4ValueId value))]]))

data ConformanceDriverLineBranch4ValueAbandoned = ConformanceDriverLineBranch4ValueAbandonedTrue deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch4ValueAbandoned where parseJSON = checked "ConformanceDriverLineBranch4ValueAbandoned" $ \value -> if value == Bool True then pure ConformanceDriverLineBranch4ValueAbandonedTrue else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineBranch4ValueAbandoned where toJSON ConformanceDriverLineBranch4ValueAbandonedTrue = Bool True

data ConformanceDriverLineBranch5Value = ConformanceDriverLineBranch5Value
  { conformanceDriverLineBranch5ValueId :: Integer,
    conformanceDriverLineBranch5ValueUnsupported :: ConformanceDriverLineBranch5ValueUnsupported
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch5Value where parseJSON = checked "ConformanceDriverLineBranch5Value" $ withObject "ConformanceDriverLineBranch5Value" (\fields -> ConformanceDriverLineBranch5Value <$> (fields .: "id") <*> (fields .: "unsupported"))

instance ToJSON ConformanceDriverLineBranch5Value where toJSON value = Object (KM.fromList (concat [[("id", toJSON (conformanceDriverLineBranch5ValueId value))], [("unsupported", toJSON (conformanceDriverLineBranch5ValueUnsupported value))]]))

data ConformanceDriverLineBranch5ValueUnsupported = ConformanceDriverLineBranch5ValueUnsupportedTrue deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch5ValueUnsupported where parseJSON = checked "ConformanceDriverLineBranch5ValueUnsupported" $ \value -> if value == Bool True then pure ConformanceDriverLineBranch5ValueUnsupportedTrue else fail "unknown enumeration member"

instance ToJSON ConformanceDriverLineBranch5ValueUnsupported where toJSON ConformanceDriverLineBranch5ValueUnsupportedTrue = Bool True

data ConformanceDriverLineBranch6Value = ConformanceDriverLineBranch6Value
  { conformanceDriverLineBranch6ValueId :: Integer,
    conformanceDriverLineBranch6ValueMisuse :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch6Value where parseJSON = checked "ConformanceDriverLineBranch6Value" $ withObject "ConformanceDriverLineBranch6Value" (\fields -> ConformanceDriverLineBranch6Value <$> (fields .: "id") <*> (fields .: "misuse"))

instance ToJSON ConformanceDriverLineBranch6Value where toJSON value = Object (KM.fromList (concat [[("id", toJSON (conformanceDriverLineBranch6ValueId value))], [("misuse", toJSON (conformanceDriverLineBranch6ValueMisuse value))]]))

data ConformanceDriverLineBranch7Value = ConformanceDriverLineBranch7Value
  { conformanceDriverLineBranch7ValueState :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch7Value where parseJSON = checked "ConformanceDriverLineBranch7Value" $ withObject "ConformanceDriverLineBranch7Value" (\fields -> ConformanceDriverLineBranch7Value <$> (fields .: "state"))

instance ToJSON ConformanceDriverLineBranch7Value where toJSON value = Object (KM.fromList (concat [[("state", toJSON (conformanceDriverLineBranch7ValueState value))]]))

data ConformanceDriverLineBranch8Value = ConformanceDriverLineBranch8Value
  { conformanceDriverLineBranch8ValueFrame :: ConformanceDriverLineBranch8ValueFrame
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch8Value where parseJSON = checked "ConformanceDriverLineBranch8Value" $ withObject "ConformanceDriverLineBranch8Value" (\fields -> ConformanceDriverLineBranch8Value <$> (fields .: "frame"))

instance ToJSON ConformanceDriverLineBranch8Value where toJSON value = Object (KM.fromList (concat [[("frame", toJSON (conformanceDriverLineBranch8ValueFrame value))]]))

data ConformanceDriverLineBranch8ValueFrame = ConformanceDriverLineBranch8ValueFrame
  { conformanceDriverLineBranch8ValueFrameChannel :: Text,
    conformanceDriverLineBranch8ValueFrameCorrelationId :: Maybe Text,
    conformanceDriverLineBranch8ValueFramePayload :: Maybe Value,
    conformanceDriverLineBranch8ValueFrameScope :: Maybe ResourceId
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch8ValueFrame where parseJSON = checked "ConformanceDriverLineBranch8ValueFrame" $ withObject "ConformanceDriverLineBranch8ValueFrame" (\fields -> ConformanceDriverLineBranch8ValueFrame <$> (fields .: "channel") <*> optional fields "correlationId" <*> optional fields "payload" <*> optional fields "scope")

instance ToJSON ConformanceDriverLineBranch8ValueFrame where toJSON value = Object (KM.fromList (concat [[("channel", toJSON (conformanceDriverLineBranch8ValueFrameChannel value))], optionalPair "correlationId" (conformanceDriverLineBranch8ValueFrameCorrelationId value), optionalPair "payload" (conformanceDriverLineBranch8ValueFramePayload value), optionalPair "scope" (conformanceDriverLineBranch8ValueFrameScope value)]))

data ConformanceDriverLineBranch9Value = ConformanceDriverLineBranch9Value
  { conformanceDriverLineBranch9ValueError :: ConformanceFailure
  }
  deriving (Eq, Show)

instance FromJSON ConformanceDriverLineBranch9Value where parseJSON = checked "ConformanceDriverLineBranch9Value" $ withObject "ConformanceDriverLineBranch9Value" (\fields -> ConformanceDriverLineBranch9Value <$> (fields .: "error"))

instance ToJSON ConformanceDriverLineBranch9Value where toJSON value = Object (KM.fromList (concat [[("error", toJSON (conformanceDriverLineBranch9ValueError value))]]))
