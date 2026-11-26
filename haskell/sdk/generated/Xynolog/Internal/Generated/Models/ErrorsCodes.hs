-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ErrorsCodes (ErrorsCodes (..), ErrorsCodesBusRequest (..), ErrorsCodesBusRequestCodesItem (..), ErrorsCodesBusRequestCodesItemWire (..), errorsCodesBusRequestCodesItemWireText, ErrorsCodesControl (..), ErrorsCodesControlCodesItem (..), ErrorsCodesJob (..), ErrorsCodesJobCodesItem (..), ErrorsCodesKbIdentity (..), ErrorsCodesKbIdentityCodesItem (..), ErrorsCodesSession (..), ErrorsCodesSessionCodesItem (..), ErrorsCodesSignIn (..), ErrorsCodesSignInCodesItem (..), ErrorsCodesSpanRefusal (..), ErrorsCodesSpanRefusalCodesItem (..), ErrorsCodesTransport (..), ErrorsCodesTransportCodesItem (..), ErrorsCodesTransportCodesItemNoStatus (..), ErrorsCodesTransportCodesItemStatus (..), ErrorsCodesTransportCodesItemStatusFrom (..), ErrorsCodesTransportCodesItemStatusLimitRefusalsItem (..), ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCode (..), errorsCodesTransportCodesItemStatusLimitRefusalsItemCodeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.HttpStatus

data ErrorsCodes = ErrorsCodes
  { errorsCodesComment :: Text,
    errorsCodesBusRequest :: ErrorsCodesBusRequest,
    errorsCodesTransport :: ErrorsCodesTransport,
    errorsCodesJob :: ErrorsCodesJob,
    errorsCodesSession :: ErrorsCodesSession,
    errorsCodesSignIn :: ErrorsCodesSignIn,
    errorsCodesKbIdentity :: ErrorsCodesKbIdentity,
    errorsCodesSpanRefusal :: ErrorsCodesSpanRefusal,
    errorsCodesControl :: ErrorsCodesControl
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodes where parseJSON = checked "ErrorsCodes" $ withObject "ErrorsCodes" (\fields -> ErrorsCodes <$> (fields .: "$comment") <*> (fields .: "busRequest") <*> (fields .: "transport") <*> (fields .: "job") <*> (fields .: "session") <*> (fields .: "signIn") <*> (fields .: "kbIdentity") <*> (fields .: "spanRefusal") <*> (fields .: "control"))

instance ToJSON ErrorsCodes where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (errorsCodesComment value))], [("busRequest", toJSON (errorsCodesBusRequest value))], [("transport", toJSON (errorsCodesTransport value))], [("job", toJSON (errorsCodesJob value))], [("session", toJSON (errorsCodesSession value))], [("signIn", toJSON (errorsCodesSignIn value))], [("kbIdentity", toJSON (errorsCodesKbIdentity value))], [("spanRefusal", toJSON (errorsCodesSpanRefusal value))], [("control", toJSON (errorsCodesControl value))]]))

data ErrorsCodesBusRequest = ErrorsCodesBusRequest
  { errorsCodesBusRequestDocs :: Text,
    errorsCodesBusRequestUnrecognizedFailure :: Text,
    errorsCodesBusRequestCodes :: [ErrorsCodesBusRequestCodesItem]
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesBusRequest where parseJSON = checked "ErrorsCodesBusRequest" $ withObject "ErrorsCodesBusRequest" (\fields -> ErrorsCodesBusRequest <$> (fields .: "docs") <*> (fields .: "unrecognizedFailure") <*> (fields .: "codes"))

instance ToJSON ErrorsCodesBusRequest where toJSON value = Object (KM.fromList (concat [[("docs", toJSON (errorsCodesBusRequestDocs value))], [("unrecognizedFailure", toJSON (errorsCodesBusRequestUnrecognizedFailure value))], [("codes", toJSON (errorsCodesBusRequestCodes value))]]))

data ErrorsCodesBusRequestCodesItem = ErrorsCodesBusRequestCodesItem
  { errorsCodesBusRequestCodesItemCode :: Text,
    errorsCodesBusRequestCodesItemDocs :: Text,
    errorsCodesBusRequestCodesItemWire :: Maybe ErrorsCodesBusRequestCodesItemWire
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesBusRequestCodesItem where parseJSON = checked "ErrorsCodesBusRequestCodesItem" $ withObject "ErrorsCodesBusRequestCodesItem" (\fields -> ErrorsCodesBusRequestCodesItem <$> (fields .: "code") <*> (fields .: "docs") <*> optional fields "wire")

instance ToJSON ErrorsCodesBusRequestCodesItem where toJSON value = Object (KM.fromList (concat [[("code", toJSON (errorsCodesBusRequestCodesItemCode value))], [("docs", toJSON (errorsCodesBusRequestCodesItemDocs value))], optionalPair "wire" (errorsCodesBusRequestCodesItemWire value)]))

data ErrorsCodesBusRequestCodesItemWire = ErrorsCodesBusRequestCodesItemWirePeerUnavailable | ErrorsCodesBusRequestCodesItemWireNotFound | ErrorsCodesBusRequestCodesItemWireUnauthorized | ErrorsCodesBusRequestCodesItemWireNonePending deriving (Eq, Show)

instance FromJSON ErrorsCodesBusRequestCodesItemWire where parseJSON = checked "ErrorsCodesBusRequestCodesItemWire" $ \value -> if value == String "peer-unavailable" then pure ErrorsCodesBusRequestCodesItemWirePeerUnavailable else if value == String "not-found" then pure ErrorsCodesBusRequestCodesItemWireNotFound else if value == String "unauthorized" then pure ErrorsCodesBusRequestCodesItemWireUnauthorized else if value == String "none-pending" then pure ErrorsCodesBusRequestCodesItemWireNonePending else fail "unknown enumeration member"

instance ToJSON ErrorsCodesBusRequestCodesItemWire where
  toJSON ErrorsCodesBusRequestCodesItemWirePeerUnavailable = String "peer-unavailable"
  toJSON ErrorsCodesBusRequestCodesItemWireNotFound = String "not-found"
  toJSON ErrorsCodesBusRequestCodesItemWireUnauthorized = String "unauthorized"
  toJSON ErrorsCodesBusRequestCodesItemWireNonePending = String "none-pending"

errorsCodesBusRequestCodesItemWireText :: ErrorsCodesBusRequestCodesItemWire -> Text
errorsCodesBusRequestCodesItemWireText ErrorsCodesBusRequestCodesItemWirePeerUnavailable = "peer-unavailable"
errorsCodesBusRequestCodesItemWireText ErrorsCodesBusRequestCodesItemWireNotFound = "not-found"
errorsCodesBusRequestCodesItemWireText ErrorsCodesBusRequestCodesItemWireUnauthorized = "unauthorized"
errorsCodesBusRequestCodesItemWireText ErrorsCodesBusRequestCodesItemWireNonePending = "none-pending"

data ErrorsCodesControl = ErrorsCodesControl
  { errorsCodesControlDocs :: Text,
    errorsCodesControlCodes :: [ErrorsCodesControlCodesItem]
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesControl where parseJSON = checked "ErrorsCodesControl" $ withObject "ErrorsCodesControl" (\fields -> ErrorsCodesControl <$> (fields .: "docs") <*> (fields .: "codes"))

instance ToJSON ErrorsCodesControl where toJSON value = Object (KM.fromList (concat [[("docs", toJSON (errorsCodesControlDocs value))], [("codes", toJSON (errorsCodesControlCodes value))]]))

data ErrorsCodesControlCodesItem = ErrorsCodesControlCodesItem
  { errorsCodesControlCodesItemCode :: Text,
    errorsCodesControlCodesItemDocs :: Text,
    errorsCodesControlCodesItemRpc :: Integer,
    errorsCodesControlCodesItemRetryable :: Bool
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesControlCodesItem where parseJSON = checked "ErrorsCodesControlCodesItem" $ withObject "ErrorsCodesControlCodesItem" (\fields -> ErrorsCodesControlCodesItem <$> (fields .: "code") <*> (fields .: "docs") <*> (fields .: "rpc") <*> (fields .: "retryable"))

instance ToJSON ErrorsCodesControlCodesItem where toJSON value = Object (KM.fromList (concat [[("code", toJSON (errorsCodesControlCodesItemCode value))], [("docs", toJSON (errorsCodesControlCodesItemDocs value))], [("rpc", toJSON (errorsCodesControlCodesItemRpc value))], [("retryable", toJSON (errorsCodesControlCodesItemRetryable value))]]))

data ErrorsCodesJob = ErrorsCodesJob
  { errorsCodesJobDocs :: Text,
    errorsCodesJobCodes :: [ErrorsCodesJobCodesItem]
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesJob where parseJSON = checked "ErrorsCodesJob" $ withObject "ErrorsCodesJob" (\fields -> ErrorsCodesJob <$> (fields .: "docs") <*> (fields .: "codes"))

instance ToJSON ErrorsCodesJob where toJSON value = Object (KM.fromList (concat [[("docs", toJSON (errorsCodesJobDocs value))], [("codes", toJSON (errorsCodesJobCodes value))]]))

data ErrorsCodesJobCodesItem = ErrorsCodesJobCodesItem
  { errorsCodesJobCodesItemCode :: Text,
    errorsCodesJobCodesItemDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesJobCodesItem where parseJSON = checked "ErrorsCodesJobCodesItem" $ withObject "ErrorsCodesJobCodesItem" (\fields -> ErrorsCodesJobCodesItem <$> (fields .: "code") <*> (fields .: "docs"))

instance ToJSON ErrorsCodesJobCodesItem where toJSON value = Object (KM.fromList (concat [[("code", toJSON (errorsCodesJobCodesItemCode value))], [("docs", toJSON (errorsCodesJobCodesItemDocs value))]]))

data ErrorsCodesKbIdentity = ErrorsCodesKbIdentity
  { errorsCodesKbIdentityDocs :: Text,
    errorsCodesKbIdentityCodes :: [ErrorsCodesKbIdentityCodesItem]
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesKbIdentity where parseJSON = checked "ErrorsCodesKbIdentity" $ withObject "ErrorsCodesKbIdentity" (\fields -> ErrorsCodesKbIdentity <$> (fields .: "docs") <*> (fields .: "codes"))

instance ToJSON ErrorsCodesKbIdentity where toJSON value = Object (KM.fromList (concat [[("docs", toJSON (errorsCodesKbIdentityDocs value))], [("codes", toJSON (errorsCodesKbIdentityCodes value))]]))

data ErrorsCodesKbIdentityCodesItem = ErrorsCodesKbIdentityCodesItem
  { errorsCodesKbIdentityCodesItemCode :: Text,
    errorsCodesKbIdentityCodesItemDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesKbIdentityCodesItem where parseJSON = checked "ErrorsCodesKbIdentityCodesItem" $ withObject "ErrorsCodesKbIdentityCodesItem" (\fields -> ErrorsCodesKbIdentityCodesItem <$> (fields .: "code") <*> (fields .: "docs"))

instance ToJSON ErrorsCodesKbIdentityCodesItem where toJSON value = Object (KM.fromList (concat [[("code", toJSON (errorsCodesKbIdentityCodesItemCode value))], [("docs", toJSON (errorsCodesKbIdentityCodesItemDocs value))]]))

data ErrorsCodesSession = ErrorsCodesSession
  { errorsCodesSessionDocs :: Text,
    errorsCodesSessionCodes :: [ErrorsCodesSessionCodesItem]
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesSession where parseJSON = checked "ErrorsCodesSession" $ withObject "ErrorsCodesSession" (\fields -> ErrorsCodesSession <$> (fields .: "docs") <*> (fields .: "codes"))

instance ToJSON ErrorsCodesSession where toJSON value = Object (KM.fromList (concat [[("docs", toJSON (errorsCodesSessionDocs value))], [("codes", toJSON (errorsCodesSessionCodes value))]]))

data ErrorsCodesSessionCodesItem = ErrorsCodesSessionCodesItem
  { errorsCodesSessionCodesItemCode :: Text,
    errorsCodesSessionCodesItemDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesSessionCodesItem where parseJSON = checked "ErrorsCodesSessionCodesItem" $ withObject "ErrorsCodesSessionCodesItem" (\fields -> ErrorsCodesSessionCodesItem <$> (fields .: "code") <*> (fields .: "docs"))

instance ToJSON ErrorsCodesSessionCodesItem where toJSON value = Object (KM.fromList (concat [[("code", toJSON (errorsCodesSessionCodesItemCode value))], [("docs", toJSON (errorsCodesSessionCodesItemDocs value))]]))

data ErrorsCodesSignIn = ErrorsCodesSignIn
  { errorsCodesSignInDocs :: Text,
    errorsCodesSignInCodes :: [ErrorsCodesSignInCodesItem]
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesSignIn where parseJSON = checked "ErrorsCodesSignIn" $ withObject "ErrorsCodesSignIn" (\fields -> ErrorsCodesSignIn <$> (fields .: "docs") <*> (fields .: "codes"))

instance ToJSON ErrorsCodesSignIn where toJSON value = Object (KM.fromList (concat [[("docs", toJSON (errorsCodesSignInDocs value))], [("codes", toJSON (errorsCodesSignInCodes value))]]))

data ErrorsCodesSignInCodesItem = ErrorsCodesSignInCodesItem
  { errorsCodesSignInCodesItemCode :: Text,
    errorsCodesSignInCodesItemDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesSignInCodesItem where parseJSON = checked "ErrorsCodesSignInCodesItem" $ withObject "ErrorsCodesSignInCodesItem" (\fields -> ErrorsCodesSignInCodesItem <$> (fields .: "code") <*> (fields .: "docs"))

instance ToJSON ErrorsCodesSignInCodesItem where toJSON value = Object (KM.fromList (concat [[("code", toJSON (errorsCodesSignInCodesItemCode value))], [("docs", toJSON (errorsCodesSignInCodesItemDocs value))]]))

data ErrorsCodesSpanRefusal = ErrorsCodesSpanRefusal
  { errorsCodesSpanRefusalDocs :: Text,
    errorsCodesSpanRefusalCodes :: [ErrorsCodesSpanRefusalCodesItem]
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesSpanRefusal where parseJSON = checked "ErrorsCodesSpanRefusal" $ withObject "ErrorsCodesSpanRefusal" (\fields -> ErrorsCodesSpanRefusal <$> (fields .: "docs") <*> (fields .: "codes"))

instance ToJSON ErrorsCodesSpanRefusal where toJSON value = Object (KM.fromList (concat [[("docs", toJSON (errorsCodesSpanRefusalDocs value))], [("codes", toJSON (errorsCodesSpanRefusalCodes value))]]))

data ErrorsCodesSpanRefusalCodesItem = ErrorsCodesSpanRefusalCodesItem
  { errorsCodesSpanRefusalCodesItemCode :: Text,
    errorsCodesSpanRefusalCodesItemDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesSpanRefusalCodesItem where parseJSON = checked "ErrorsCodesSpanRefusalCodesItem" $ withObject "ErrorsCodesSpanRefusalCodesItem" (\fields -> ErrorsCodesSpanRefusalCodesItem <$> (fields .: "code") <*> (fields .: "docs"))

instance ToJSON ErrorsCodesSpanRefusalCodesItem where toJSON value = Object (KM.fromList (concat [[("code", toJSON (errorsCodesSpanRefusalCodesItemCode value))], [("docs", toJSON (errorsCodesSpanRefusalCodesItemDocs value))]]))

data ErrorsCodesTransport = ErrorsCodesTransport
  { errorsCodesTransportDocs :: Text,
    errorsCodesTransportUnclassified :: Text,
    errorsCodesTransportCodes :: [ErrorsCodesTransportCodesItem]
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesTransport where parseJSON = checked "ErrorsCodesTransport" $ withObject "ErrorsCodesTransport" (\fields -> ErrorsCodesTransport <$> (fields .: "docs") <*> (fields .: "unclassified") <*> (fields .: "codes"))

instance ToJSON ErrorsCodesTransport where toJSON value = Object (KM.fromList (concat [[("docs", toJSON (errorsCodesTransportDocs value))], [("unclassified", toJSON (errorsCodesTransportUnclassified value))], [("codes", toJSON (errorsCodesTransportCodes value))]]))

data ErrorsCodesTransportCodesItem = ErrorsCodesTransportCodesItemStatus ErrorsCodesTransportCodesItemStatus | ErrorsCodesTransportCodesItemStatusFrom ErrorsCodesTransportCodesItemStatusFrom | ErrorsCodesTransportCodesItemNoStatus ErrorsCodesTransportCodesItemNoStatus deriving (Eq, Show)

instance FromJSON ErrorsCodesTransportCodesItem where parseJSON = checked "ErrorsCodesTransportCodesItem" $ \value -> readMember "ErrorsCodesTransportCodesItem" [([Signature {signatureKind = ObjectKind, signatureRequired = ["code", "docs", "status"], signatureAllowed = Just ["code", "docs", "status", "limitRefusals"], signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], ErrorsCodesTransportCodesItemStatus <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["code", "docs", "statusFrom"], signatureAllowed = Just ["code", "docs", "statusFrom"], signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], ErrorsCodesTransportCodesItemStatusFrom <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["code", "docs"], signatureAllowed = Just ["code", "docs"], signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], ErrorsCodesTransportCodesItemNoStatus <$> parseJSON value)] value

instance ToJSON ErrorsCodesTransportCodesItem where
  toJSON (ErrorsCodesTransportCodesItemStatus value) = toJSON value
  toJSON (ErrorsCodesTransportCodesItemStatusFrom value) = toJSON value
  toJSON (ErrorsCodesTransportCodesItemNoStatus value) = toJSON value

data ErrorsCodesTransportCodesItemNoStatus = MkErrorsCodesTransportCodesItemNoStatus
  { errorsCodesTransportCodesItemNoStatusCode :: Text,
    errorsCodesTransportCodesItemNoStatusDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesTransportCodesItemNoStatus where parseJSON = checked "ErrorsCodesTransportCodesItemNoStatus" $ withObject "ErrorsCodesTransportCodesItemNoStatus" (\fields -> MkErrorsCodesTransportCodesItemNoStatus <$> (fields .: "code") <*> (fields .: "docs"))

instance ToJSON ErrorsCodesTransportCodesItemNoStatus where toJSON value = Object (KM.fromList (concat [[("code", toJSON (errorsCodesTransportCodesItemNoStatusCode value))], [("docs", toJSON (errorsCodesTransportCodesItemNoStatusDocs value))]]))

data ErrorsCodesTransportCodesItemStatus = MkErrorsCodesTransportCodesItemStatus
  { errorsCodesTransportCodesItemStatusCode :: Text,
    errorsCodesTransportCodesItemStatusDocs :: Text,
    errorsCodesTransportCodesItemStatusStatus :: HttpStatus,
    errorsCodesTransportCodesItemStatusLimitRefusals :: Maybe [ErrorsCodesTransportCodesItemStatusLimitRefusalsItem]
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesTransportCodesItemStatus where parseJSON = checked "ErrorsCodesTransportCodesItemStatus" $ withObject "ErrorsCodesTransportCodesItemStatus" (\fields -> MkErrorsCodesTransportCodesItemStatus <$> (fields .: "code") <*> (fields .: "docs") <*> (fields .: "status") <*> optional fields "limitRefusals")

instance ToJSON ErrorsCodesTransportCodesItemStatus where toJSON value = Object (KM.fromList (concat [[("code", toJSON (errorsCodesTransportCodesItemStatusCode value))], [("docs", toJSON (errorsCodesTransportCodesItemStatusDocs value))], [("status", toJSON (errorsCodesTransportCodesItemStatusStatus value))], optionalPair "limitRefusals" (errorsCodesTransportCodesItemStatusLimitRefusals value)]))

data ErrorsCodesTransportCodesItemStatusFrom = MkErrorsCodesTransportCodesItemStatusFrom
  { errorsCodesTransportCodesItemStatusFromCode :: Text,
    errorsCodesTransportCodesItemStatusFromDocs :: Text,
    errorsCodesTransportCodesItemStatusFromStatusFrom :: HttpStatus
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesTransportCodesItemStatusFrom where parseJSON = checked "ErrorsCodesTransportCodesItemStatusFrom" $ withObject "ErrorsCodesTransportCodesItemStatusFrom" (\fields -> MkErrorsCodesTransportCodesItemStatusFrom <$> (fields .: "code") <*> (fields .: "docs") <*> (fields .: "statusFrom"))

instance ToJSON ErrorsCodesTransportCodesItemStatusFrom where toJSON value = Object (KM.fromList (concat [[("code", toJSON (errorsCodesTransportCodesItemStatusFromCode value))], [("docs", toJSON (errorsCodesTransportCodesItemStatusFromDocs value))], [("statusFrom", toJSON (errorsCodesTransportCodesItemStatusFromStatusFrom value))]]))

data ErrorsCodesTransportCodesItemStatusLimitRefusalsItem = ErrorsCodesTransportCodesItemStatusLimitRefusalsItem
  { errorsCodesTransportCodesItemStatusLimitRefusalsItemStatus :: HttpStatus,
    errorsCodesTransportCodesItemStatusLimitRefusalsItemCode :: ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCode
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesTransportCodesItemStatusLimitRefusalsItem where parseJSON = checked "ErrorsCodesTransportCodesItemStatusLimitRefusalsItem" $ withObject "ErrorsCodesTransportCodesItemStatusLimitRefusalsItem" (\fields -> ErrorsCodesTransportCodesItemStatusLimitRefusalsItem <$> (fields .: "status") <*> (fields .: "code"))

instance ToJSON ErrorsCodesTransportCodesItemStatusLimitRefusalsItem where toJSON value = Object (KM.fromList (concat [[("status", toJSON (errorsCodesTransportCodesItemStatusLimitRefusalsItemStatus value))], [("code", toJSON (errorsCodesTransportCodesItemStatusLimitRefusalsItemCode value))]]))

data ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCode = ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeStreams | ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeEmitRate | ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeUnansweredRequests | ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeCapacity | ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeRefusalRate deriving (Eq, Show)

instance FromJSON ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCode where parseJSON = checked "ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCode" $ \value -> if value == String "streams" then pure ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeStreams else if value == String "emit-rate" then pure ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeEmitRate else if value == String "unanswered-requests" then pure ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeUnansweredRequests else if value == String "capacity" then pure ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeCapacity else if value == String "refusal-rate" then pure ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeRefusalRate else fail "unknown enumeration member"

instance ToJSON ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCode where
  toJSON ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeStreams = String "streams"
  toJSON ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeEmitRate = String "emit-rate"
  toJSON ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeUnansweredRequests = String "unanswered-requests"
  toJSON ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeCapacity = String "capacity"
  toJSON ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeRefusalRate = String "refusal-rate"

errorsCodesTransportCodesItemStatusLimitRefusalsItemCodeText :: ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCode -> Text
errorsCodesTransportCodesItemStatusLimitRefusalsItemCodeText ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeStreams = "streams"
errorsCodesTransportCodesItemStatusLimitRefusalsItemCodeText ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeEmitRate = "emit-rate"
errorsCodesTransportCodesItemStatusLimitRefusalsItemCodeText ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeUnansweredRequests = "unanswered-requests"
errorsCodesTransportCodesItemStatusLimitRefusalsItemCodeText ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeCapacity = "capacity"
errorsCodesTransportCodesItemStatusLimitRefusalsItemCodeText ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeRefusalRate = "refusal-rate"
