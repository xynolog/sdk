-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ArchivistMessages (ArchivistMessages (..), ArchivistMessagesBootItem (..), ArchivistMessagesHttpItem (..), ArchivistMessagesHttpItemMethod (..), archivistMessagesHttpItemMethodText, ArchivistMessagesLoggedItem (..), ArchivistMessagesRefusalsItem (..), ArchivistMessagesRefusalsItemCode (..), archivistMessagesRefusalsItemCodeText, ArchivistMessagesUnauthorized (..), ArchivistMessagesUnsentItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.HttpStatus
import Xynolog.Internal.Generated.Models.LogLevel

data ArchivistMessages = ArchivistMessages
  { archivistMessagesComment :: Text,
    archivistMessagesBoot :: [ArchivistMessagesBootItem],
    archivistMessagesUnsent :: [ArchivistMessagesUnsentItem],
    archivistMessagesRefusals :: [ArchivistMessagesRefusalsItem],
    archivistMessagesUnauthorized :: ArchivistMessagesUnauthorized,
    archivistMessagesHttp :: [ArchivistMessagesHttpItem],
    archivistMessagesLogged :: [ArchivistMessagesLoggedItem]
  }
  deriving (Eq, Show)

instance FromJSON ArchivistMessages where parseJSON = checked "ArchivistMessages" $ withObject "ArchivistMessages" (\fields -> ArchivistMessages <$> (fields .: "$comment") <*> (fields .: "boot") <*> (fields .: "unsent") <*> (fields .: "refusals") <*> (fields .: "unauthorized") <*> (fields .: "http") <*> (fields .: "logged"))

instance ToJSON ArchivistMessages where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (archivistMessagesComment value))], [("boot", toJSON (archivistMessagesBoot value))], [("unsent", toJSON (archivistMessagesUnsent value))], [("refusals", toJSON (archivistMessagesRefusals value))], [("unauthorized", toJSON (archivistMessagesUnauthorized value))], [("http", toJSON (archivistMessagesHttp value))], [("logged", toJSON (archivistMessagesLogged value))]]))

data ArchivistMessagesBootItem = ArchivistMessagesBootItem
  { archivistMessagesBootItemName :: Text,
    archivistMessagesBootItemSituation :: Text,
    archivistMessagesBootItemRefusal :: Text
  }
  deriving (Eq, Show)

instance FromJSON ArchivistMessagesBootItem where parseJSON = checked "ArchivistMessagesBootItem" $ withObject "ArchivistMessagesBootItem" (\fields -> ArchivistMessagesBootItem <$> (fields .: "name") <*> (fields .: "situation") <*> (fields .: "refusal"))

instance ToJSON ArchivistMessagesBootItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (archivistMessagesBootItemName value))], [("situation", toJSON (archivistMessagesBootItemSituation value))], [("refusal", toJSON (archivistMessagesBootItemRefusal value))]]))

data ArchivistMessagesHttpItem = ArchivistMessagesHttpItem
  { archivistMessagesHttpItemName :: Text,
    archivistMessagesHttpItemMethod :: ArchivistMessagesHttpItemMethod,
    archivistMessagesHttpItemRoute :: Text,
    archivistMessagesHttpItemStatus :: HttpStatus,
    archivistMessagesHttpItemCode :: Maybe Text,
    archivistMessagesHttpItemSituation :: Text,
    archivistMessagesHttpItemError :: Text
  }
  deriving (Eq, Show)

instance FromJSON ArchivistMessagesHttpItem where parseJSON = checked "ArchivistMessagesHttpItem" $ withObject "ArchivistMessagesHttpItem" (\fields -> ArchivistMessagesHttpItem <$> (fields .: "name") <*> (fields .: "method") <*> (fields .: "route") <*> (fields .: "status") <*> optional fields "code" <*> (fields .: "situation") <*> (fields .: "error"))

instance ToJSON ArchivistMessagesHttpItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (archivistMessagesHttpItemName value))], [("method", toJSON (archivistMessagesHttpItemMethod value))], [("route", toJSON (archivistMessagesHttpItemRoute value))], [("status", toJSON (archivistMessagesHttpItemStatus value))], optionalPair "code" (archivistMessagesHttpItemCode value), [("situation", toJSON (archivistMessagesHttpItemSituation value))], [("error", toJSON (archivistMessagesHttpItemError value))]]))

data ArchivistMessagesHttpItemMethod = ArchivistMessagesHttpItemMethodGET | ArchivistMessagesHttpItemMethodPUT | ArchivistMessagesHttpItemMethodPOST deriving (Eq, Show)

instance FromJSON ArchivistMessagesHttpItemMethod where parseJSON = checked "ArchivistMessagesHttpItemMethod" $ \value -> if value == String "GET" then pure ArchivistMessagesHttpItemMethodGET else if value == String "PUT" then pure ArchivistMessagesHttpItemMethodPUT else if value == String "POST" then pure ArchivistMessagesHttpItemMethodPOST else fail "unknown enumeration member"

instance ToJSON ArchivistMessagesHttpItemMethod where
  toJSON ArchivistMessagesHttpItemMethodGET = String "GET"
  toJSON ArchivistMessagesHttpItemMethodPUT = String "PUT"
  toJSON ArchivistMessagesHttpItemMethodPOST = String "POST"

archivistMessagesHttpItemMethodText :: ArchivistMessagesHttpItemMethod -> Text
archivistMessagesHttpItemMethodText ArchivistMessagesHttpItemMethodGET = "GET"
archivistMessagesHttpItemMethodText ArchivistMessagesHttpItemMethodPUT = "PUT"
archivistMessagesHttpItemMethodText ArchivistMessagesHttpItemMethodPOST = "POST"

data ArchivistMessagesLoggedItem = ArchivistMessagesLoggedItem
  { archivistMessagesLoggedItemName :: Text,
    archivistMessagesLoggedItemLevel :: LogLevel,
    archivistMessagesLoggedItemSituation :: Text,
    archivistMessagesLoggedItemMessage :: Text,
    archivistMessagesLoggedItemFields :: KM.KeyMap Text
  }
  deriving (Eq, Show)

instance FromJSON ArchivistMessagesLoggedItem where parseJSON = checked "ArchivistMessagesLoggedItem" $ withObject "ArchivistMessagesLoggedItem" (\fields -> ArchivistMessagesLoggedItem <$> (fields .: "name") <*> (fields .: "level") <*> (fields .: "situation") <*> (fields .: "message") <*> (fields .: "fields"))

instance ToJSON ArchivistMessagesLoggedItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (archivistMessagesLoggedItemName value))], [("level", toJSON (archivistMessagesLoggedItemLevel value))], [("situation", toJSON (archivistMessagesLoggedItemSituation value))], [("message", toJSON (archivistMessagesLoggedItemMessage value))], [("fields", toJSON (archivistMessagesLoggedItemFields value))]]))

data ArchivistMessagesRefusalsItem = ArchivistMessagesRefusalsItem
  { archivistMessagesRefusalsItemName :: Text,
    archivistMessagesRefusalsItemOperations :: [Text],
    archivistMessagesRefusalsItemCode :: Maybe ArchivistMessagesRefusalsItemCode,
    archivistMessagesRefusalsItemSituation :: Text,
    archivistMessagesRefusalsItemMessage :: Text
  }
  deriving (Eq, Show)

instance FromJSON ArchivistMessagesRefusalsItem where parseJSON = checked "ArchivistMessagesRefusalsItem" $ withObject "ArchivistMessagesRefusalsItem" (\fields -> ArchivistMessagesRefusalsItem <$> (fields .: "name") <*> (fields .: "operations") <*> optional fields "code" <*> (fields .: "situation") <*> (fields .: "message"))

instance ToJSON ArchivistMessagesRefusalsItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (archivistMessagesRefusalsItemName value))], [("operations", toJSON (archivistMessagesRefusalsItemOperations value))], optionalPair "code" (archivistMessagesRefusalsItemCode value), [("situation", toJSON (archivistMessagesRefusalsItemSituation value))], [("message", toJSON (archivistMessagesRefusalsItemMessage value))]]))

data ArchivistMessagesRefusalsItemCode = ArchivistMessagesRefusalsItemCodePeerUnavailable | ArchivistMessagesRefusalsItemCodeNotFound | ArchivistMessagesRefusalsItemCodeUnauthorized | ArchivistMessagesRefusalsItemCodeNonePending deriving (Eq, Show)

instance FromJSON ArchivistMessagesRefusalsItemCode where parseJSON = checked "ArchivistMessagesRefusalsItemCode" $ \value -> if value == String "peer-unavailable" then pure ArchivistMessagesRefusalsItemCodePeerUnavailable else if value == String "not-found" then pure ArchivistMessagesRefusalsItemCodeNotFound else if value == String "unauthorized" then pure ArchivistMessagesRefusalsItemCodeUnauthorized else if value == String "none-pending" then pure ArchivistMessagesRefusalsItemCodeNonePending else fail "unknown enumeration member"

instance ToJSON ArchivistMessagesRefusalsItemCode where
  toJSON ArchivistMessagesRefusalsItemCodePeerUnavailable = String "peer-unavailable"
  toJSON ArchivistMessagesRefusalsItemCodeNotFound = String "not-found"
  toJSON ArchivistMessagesRefusalsItemCodeUnauthorized = String "unauthorized"
  toJSON ArchivistMessagesRefusalsItemCodeNonePending = String "none-pending"

archivistMessagesRefusalsItemCodeText :: ArchivistMessagesRefusalsItemCode -> Text
archivistMessagesRefusalsItemCodeText ArchivistMessagesRefusalsItemCodePeerUnavailable = "peer-unavailable"
archivistMessagesRefusalsItemCodeText ArchivistMessagesRefusalsItemCodeNotFound = "not-found"
archivistMessagesRefusalsItemCodeText ArchivistMessagesRefusalsItemCodeUnauthorized = "unauthorized"
archivistMessagesRefusalsItemCodeText ArchivistMessagesRefusalsItemCodeNonePending = "none-pending"

data ArchivistMessagesUnauthorized = ArchivistMessagesUnauthorized
  { archivistMessagesUnauthorizedStatus :: HttpStatus,
    archivistMessagesUnauthorizedError :: Text,
    archivistMessagesUnauthorizedPresented :: Text,
    archivistMessagesUnauthorizedAbsent :: Text
  }
  deriving (Eq, Show)

instance FromJSON ArchivistMessagesUnauthorized where parseJSON = checked "ArchivistMessagesUnauthorized" $ withObject "ArchivistMessagesUnauthorized" (\fields -> ArchivistMessagesUnauthorized <$> (fields .: "status") <*> (fields .: "error") <*> (fields .: "presented") <*> (fields .: "absent"))

instance ToJSON ArchivistMessagesUnauthorized where toJSON value = Object (KM.fromList (concat [[("status", toJSON (archivistMessagesUnauthorizedStatus value))], [("error", toJSON (archivistMessagesUnauthorizedError value))], [("presented", toJSON (archivistMessagesUnauthorizedPresented value))], [("absent", toJSON (archivistMessagesUnauthorizedAbsent value))]]))

data ArchivistMessagesUnsentItem = ArchivistMessagesUnsentItem
  { archivistMessagesUnsentItemName :: Text,
    archivistMessagesUnsentItemSituation :: Text,
    archivistMessagesUnsentItemMessage :: Text
  }
  deriving (Eq, Show)

instance FromJSON ArchivistMessagesUnsentItem where parseJSON = checked "ArchivistMessagesUnsentItem" $ withObject "ArchivistMessagesUnsentItem" (\fields -> ArchivistMessagesUnsentItem <$> (fields .: "name") <*> (fields .: "situation") <*> (fields .: "message"))

instance ToJSON ArchivistMessagesUnsentItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (archivistMessagesUnsentItemName value))], [("situation", toJSON (archivistMessagesUnsentItemSituation value))], [("message", toJSON (archivistMessagesUnsentItemMessage value))]]))
