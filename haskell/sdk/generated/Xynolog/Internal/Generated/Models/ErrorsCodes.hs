-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ErrorsCodes (ErrorsCodes (..), ErrorsCodesBusRequest (..), ErrorsCodesBusRequestCodesItem (..), ErrorsCodesJob (..), ErrorsCodesJobCodesItem (..), ErrorsCodesTransport (..), ErrorsCodesTransportCodesItem (..), ErrorsCodesTransportCodesItemNoStatus (..), ErrorsCodesTransportCodesItemStatus (..), ErrorsCodesTransportCodesItemStatusFrom (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ArchivistMessages
import Xynolog.Internal.Generated.Models.HttpStatus

data ErrorsCodes = ErrorsCodes
  { errorsCodesComment :: Text,
    errorsCodesBusRequest :: ErrorsCodesBusRequest,
    errorsCodesTransport :: ErrorsCodesTransport,
    errorsCodesJob :: ErrorsCodesJob,
    errorsCodesSession :: ErrorsCodesJob,
    errorsCodesSignIn :: ErrorsCodesJob,
    errorsCodesKbIdentity :: ErrorsCodesJob,
    errorsCodesSpanRefusal :: ErrorsCodesJob,
    errorsCodesControl :: ErrorsCodesJob
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
    errorsCodesBusRequestCodesItemWire :: Maybe CommandErrorCode
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesBusRequestCodesItem where parseJSON = checked "ErrorsCodesBusRequestCodesItem" $ withObject "ErrorsCodesBusRequestCodesItem" (\fields -> ErrorsCodesBusRequestCodesItem <$> (fields .: "code") <*> (fields .: "docs") <*> optional fields "wire")

instance ToJSON ErrorsCodesBusRequestCodesItem where toJSON value = Object (KM.fromList (concat [[("code", toJSON (errorsCodesBusRequestCodesItemCode value))], [("docs", toJSON (errorsCodesBusRequestCodesItemDocs value))], optionalPair "wire" (errorsCodesBusRequestCodesItemWire value)]))

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

data ErrorsCodesTransport = ErrorsCodesTransport
  { errorsCodesTransportDocs :: Text,
    errorsCodesTransportUnclassified :: Text,
    errorsCodesTransportCodes :: [ErrorsCodesTransportCodesItem]
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesTransport where parseJSON = checked "ErrorsCodesTransport" $ withObject "ErrorsCodesTransport" (\fields -> ErrorsCodesTransport <$> (fields .: "docs") <*> (fields .: "unclassified") <*> (fields .: "codes"))

instance ToJSON ErrorsCodesTransport where toJSON value = Object (KM.fromList (concat [[("docs", toJSON (errorsCodesTransportDocs value))], [("unclassified", toJSON (errorsCodesTransportUnclassified value))], [("codes", toJSON (errorsCodesTransportCodes value))]]))

data ErrorsCodesTransportCodesItem = ErrorsCodesTransportCodesItemStatus ErrorsCodesTransportCodesItemStatus | ErrorsCodesTransportCodesItemStatusFrom ErrorsCodesTransportCodesItemStatusFrom | ErrorsCodesTransportCodesItemNoStatus ErrorsCodesTransportCodesItemNoStatus deriving (Eq, Show)

instance FromJSON ErrorsCodesTransportCodesItem where parseJSON = checked "ErrorsCodesTransportCodesItem" $ \value -> readMember "ErrorsCodesTransportCodesItem" [([Signature {signatureKind = ObjectKind, signatureRequired = ["code", "docs", "status"], signatureAllowed = Just ["code", "docs", "status"], signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], ErrorsCodesTransportCodesItemStatus <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["code", "docs", "statusFrom"], signatureAllowed = Just ["code", "docs", "statusFrom"], signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], ErrorsCodesTransportCodesItemStatusFrom <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["code", "docs"], signatureAllowed = Just ["code", "docs"], signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], ErrorsCodesTransportCodesItemNoStatus <$> parseJSON value)] value

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
    errorsCodesTransportCodesItemStatusStatus :: HttpStatus
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesTransportCodesItemStatus where parseJSON = checked "ErrorsCodesTransportCodesItemStatus" $ withObject "ErrorsCodesTransportCodesItemStatus" (\fields -> MkErrorsCodesTransportCodesItemStatus <$> (fields .: "code") <*> (fields .: "docs") <*> (fields .: "status"))

instance ToJSON ErrorsCodesTransportCodesItemStatus where toJSON value = Object (KM.fromList (concat [[("code", toJSON (errorsCodesTransportCodesItemStatusCode value))], [("docs", toJSON (errorsCodesTransportCodesItemStatusDocs value))], [("status", toJSON (errorsCodesTransportCodesItemStatusStatus value))]]))

data ErrorsCodesTransportCodesItemStatusFrom = MkErrorsCodesTransportCodesItemStatusFrom
  { errorsCodesTransportCodesItemStatusFromCode :: Text,
    errorsCodesTransportCodesItemStatusFromDocs :: Text,
    errorsCodesTransportCodesItemStatusFromStatusFrom :: HttpStatus
  }
  deriving (Eq, Show)

instance FromJSON ErrorsCodesTransportCodesItemStatusFrom where parseJSON = checked "ErrorsCodesTransportCodesItemStatusFrom" $ withObject "ErrorsCodesTransportCodesItemStatusFrom" (\fields -> MkErrorsCodesTransportCodesItemStatusFrom <$> (fields .: "code") <*> (fields .: "docs") <*> (fields .: "statusFrom"))

instance ToJSON ErrorsCodesTransportCodesItemStatusFrom where toJSON value = Object (KM.fromList (concat [[("code", toJSON (errorsCodesTransportCodesItemStatusFromCode value))], [("docs", toJSON (errorsCodesTransportCodesItemStatusFromDocs value))], [("statusFrom", toJSON (errorsCodesTransportCodesItemStatusFromStatusFrom value))]]))
