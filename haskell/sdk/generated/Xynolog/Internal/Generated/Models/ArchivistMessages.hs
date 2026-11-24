-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ArchivistMessages (ArchivistMessages (..), ArchivistMessagesBootItem (..), ArchivistMessagesHttpItem (..), ArchivistMessagesHttpItemMethod (..), archivistMessagesHttpItemMethodText, ArchivistMessagesLoggedItem (..), ArchivistMessagesLoggedItemFields (..), ArchivistMessagesRefusalsItem (..), ArchivistMessagesRefusalsItemCode (..), archivistMessagesRefusalsItemCodeText, ArchivistMessagesUnauthorized (..), ArchivistMessagesUnsentItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.HttpStatus
import Xynolog.Internal.Generated.Models.LogLevel

data ArchivistMessages = ArchivistMessages
  { archivistMessagesBoot :: [ArchivistMessagesBootItem],
    archivistMessagesHttp :: [ArchivistMessagesHttpItem],
    archivistMessagesLogged :: [ArchivistMessagesLoggedItem],
    archivistMessagesRefusals :: [ArchivistMessagesRefusalsItem],
    archivistMessagesUnauthorized :: ArchivistMessagesUnauthorized,
    archivistMessagesUnsent :: [ArchivistMessagesUnsentItem]
  }
  deriving (Eq, Show)

instance FromJSON ArchivistMessages where parseJSON = checked "ArchivistMessages" $ withObject "ArchivistMessages" (\fields -> ArchivistMessages <$> (fields .: "boot") <*> (fields .: "http") <*> (fields .: "logged") <*> (fields .: "refusals") <*> (fields .: "unauthorized") <*> (fields .: "unsent"))

instance ToJSON ArchivistMessages where toJSON value = Object (KM.fromList (concat [[("boot", toJSON (archivistMessagesBoot value))], [("http", toJSON (archivistMessagesHttp value))], [("logged", toJSON (archivistMessagesLogged value))], [("refusals", toJSON (archivistMessagesRefusals value))], [("unauthorized", toJSON (archivistMessagesUnauthorized value))], [("unsent", toJSON (archivistMessagesUnsent value))]]))

data ArchivistMessagesBootItem = ArchivistMessagesBootItem
  { archivistMessagesBootItemName :: Text,
    archivistMessagesBootItemRefusal :: Text,
    archivistMessagesBootItemSituation :: Text
  }
  deriving (Eq, Show)

instance FromJSON ArchivistMessagesBootItem where parseJSON = checked "ArchivistMessagesBootItem" $ withObject "ArchivistMessagesBootItem" (\fields -> ArchivistMessagesBootItem <$> (fields .: "name") <*> (fields .: "refusal") <*> (fields .: "situation"))

instance ToJSON ArchivistMessagesBootItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (archivistMessagesBootItemName value))], [("refusal", toJSON (archivistMessagesBootItemRefusal value))], [("situation", toJSON (archivistMessagesBootItemSituation value))]]))

data ArchivistMessagesHttpItem = ArchivistMessagesHttpItem
  { archivistMessagesHttpItemCode :: Maybe Text,
    archivistMessagesHttpItemError :: Text,
    archivistMessagesHttpItemMethod :: ArchivistMessagesHttpItemMethod,
    archivistMessagesHttpItemName :: Text,
    archivistMessagesHttpItemRoute :: Text,
    archivistMessagesHttpItemSituation :: Text,
    archivistMessagesHttpItemStatus :: HttpStatus
  }
  deriving (Eq, Show)

instance FromJSON ArchivistMessagesHttpItem where parseJSON = checked "ArchivistMessagesHttpItem" $ withObject "ArchivistMessagesHttpItem" (\fields -> ArchivistMessagesHttpItem <$> optional fields "code" <*> (fields .: "error") <*> (fields .: "method") <*> (fields .: "name") <*> (fields .: "route") <*> (fields .: "situation") <*> (fields .: "status"))

instance ToJSON ArchivistMessagesHttpItem where toJSON value = Object (KM.fromList (concat [optionalPair "code" (archivistMessagesHttpItemCode value), [("error", toJSON (archivistMessagesHttpItemError value))], [("method", toJSON (archivistMessagesHttpItemMethod value))], [("name", toJSON (archivistMessagesHttpItemName value))], [("route", toJSON (archivistMessagesHttpItemRoute value))], [("situation", toJSON (archivistMessagesHttpItemSituation value))], [("status", toJSON (archivistMessagesHttpItemStatus value))]]))

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
  { archivistMessagesLoggedItemFields :: ArchivistMessagesLoggedItemFields,
    archivistMessagesLoggedItemLevel :: LogLevel,
    archivistMessagesLoggedItemMessage :: Text,
    archivistMessagesLoggedItemName :: Text,
    archivistMessagesLoggedItemSituation :: Text
  }
  deriving (Eq, Show)

instance FromJSON ArchivistMessagesLoggedItem where parseJSON = checked "ArchivistMessagesLoggedItem" $ withObject "ArchivistMessagesLoggedItem" (\fields -> ArchivistMessagesLoggedItem <$> (fields .: "fields") <*> (fields .: "level") <*> (fields .: "message") <*> (fields .: "name") <*> (fields .: "situation"))

instance ToJSON ArchivistMessagesLoggedItem where toJSON value = Object (KM.fromList (concat [[("fields", toJSON (archivistMessagesLoggedItemFields value))], [("level", toJSON (archivistMessagesLoggedItemLevel value))], [("message", toJSON (archivistMessagesLoggedItemMessage value))], [("name", toJSON (archivistMessagesLoggedItemName value))], [("situation", toJSON (archivistMessagesLoggedItemSituation value))]]))

data ArchivistMessagesLoggedItemFields = ArchivistMessagesLoggedItemFields
  { archivistMessagesLoggedItemFieldsAdditionalProperties :: KM.KeyMap Text
  }
  deriving (Eq, Show)

instance FromJSON ArchivistMessagesLoggedItemFields where parseJSON = checked "ArchivistMessagesLoggedItemFields" $ withObject "ArchivistMessagesLoggedItemFields" (\fields -> ArchivistMessagesLoggedItemFields <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ArchivistMessagesLoggedItemFields where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (archivistMessagesLoggedItemFieldsAdditionalProperties value)))

data ArchivistMessagesRefusalsItem = ArchivistMessagesRefusalsItem
  { archivistMessagesRefusalsItemCode :: Maybe ArchivistMessagesRefusalsItemCode,
    archivistMessagesRefusalsItemMessage :: Text,
    archivistMessagesRefusalsItemName :: Text,
    archivistMessagesRefusalsItemOperations :: [Text],
    archivistMessagesRefusalsItemSituation :: Text
  }
  deriving (Eq, Show)

instance FromJSON ArchivistMessagesRefusalsItem where parseJSON = checked "ArchivistMessagesRefusalsItem" $ withObject "ArchivistMessagesRefusalsItem" (\fields -> ArchivistMessagesRefusalsItem <$> optional fields "code" <*> (fields .: "message") <*> (fields .: "name") <*> (fields .: "operations") <*> (fields .: "situation"))

instance ToJSON ArchivistMessagesRefusalsItem where toJSON value = Object (KM.fromList (concat [optionalPair "code" (archivistMessagesRefusalsItemCode value), [("message", toJSON (archivistMessagesRefusalsItemMessage value))], [("name", toJSON (archivistMessagesRefusalsItemName value))], [("operations", toJSON (archivistMessagesRefusalsItemOperations value))], [("situation", toJSON (archivistMessagesRefusalsItemSituation value))]]))

data ArchivistMessagesRefusalsItemCode = ArchivistMessagesRefusalsItemCodePeerU2d_unavailable | ArchivistMessagesRefusalsItemCodeNotU2d_found | ArchivistMessagesRefusalsItemCodeUnauthorized | ArchivistMessagesRefusalsItemCodeNoneU2d_pending deriving (Eq, Show)

instance FromJSON ArchivistMessagesRefusalsItemCode where parseJSON = checked "ArchivistMessagesRefusalsItemCode" $ \value -> if value == String "peer-unavailable" then pure ArchivistMessagesRefusalsItemCodePeerU2d_unavailable else if value == String "not-found" then pure ArchivistMessagesRefusalsItemCodeNotU2d_found else if value == String "unauthorized" then pure ArchivistMessagesRefusalsItemCodeUnauthorized else if value == String "none-pending" then pure ArchivistMessagesRefusalsItemCodeNoneU2d_pending else fail "unknown enumeration member"

instance ToJSON ArchivistMessagesRefusalsItemCode where
  toJSON ArchivistMessagesRefusalsItemCodePeerU2d_unavailable = String "peer-unavailable"
  toJSON ArchivistMessagesRefusalsItemCodeNotU2d_found = String "not-found"
  toJSON ArchivistMessagesRefusalsItemCodeUnauthorized = String "unauthorized"
  toJSON ArchivistMessagesRefusalsItemCodeNoneU2d_pending = String "none-pending"

archivistMessagesRefusalsItemCodeText :: ArchivistMessagesRefusalsItemCode -> Text
archivistMessagesRefusalsItemCodeText ArchivistMessagesRefusalsItemCodePeerU2d_unavailable = "peer-unavailable"
archivistMessagesRefusalsItemCodeText ArchivistMessagesRefusalsItemCodeNotU2d_found = "not-found"
archivistMessagesRefusalsItemCodeText ArchivistMessagesRefusalsItemCodeUnauthorized = "unauthorized"
archivistMessagesRefusalsItemCodeText ArchivistMessagesRefusalsItemCodeNoneU2d_pending = "none-pending"

data ArchivistMessagesUnauthorized = ArchivistMessagesUnauthorized
  { archivistMessagesUnauthorizedAbsent :: Text,
    archivistMessagesUnauthorizedError :: Text,
    archivistMessagesUnauthorizedPresented :: Text,
    archivistMessagesUnauthorizedStatus :: HttpStatus
  }
  deriving (Eq, Show)

instance FromJSON ArchivistMessagesUnauthorized where parseJSON = checked "ArchivistMessagesUnauthorized" $ withObject "ArchivistMessagesUnauthorized" (\fields -> ArchivistMessagesUnauthorized <$> (fields .: "absent") <*> (fields .: "error") <*> (fields .: "presented") <*> (fields .: "status"))

instance ToJSON ArchivistMessagesUnauthorized where toJSON value = Object (KM.fromList (concat [[("absent", toJSON (archivistMessagesUnauthorizedAbsent value))], [("error", toJSON (archivistMessagesUnauthorizedError value))], [("presented", toJSON (archivistMessagesUnauthorizedPresented value))], [("status", toJSON (archivistMessagesUnauthorizedStatus value))]]))

data ArchivistMessagesUnsentItem = ArchivistMessagesUnsentItem
  { archivistMessagesUnsentItemMessage :: Text,
    archivistMessagesUnsentItemName :: Text,
    archivistMessagesUnsentItemSituation :: Text
  }
  deriving (Eq, Show)

instance FromJSON ArchivistMessagesUnsentItem where parseJSON = checked "ArchivistMessagesUnsentItem" $ withObject "ArchivistMessagesUnsentItem" (\fields -> ArchivistMessagesUnsentItem <$> (fields .: "message") <*> (fields .: "name") <*> (fields .: "situation"))

instance ToJSON ArchivistMessagesUnsentItem where toJSON value = Object (KM.fromList (concat [[("message", toJSON (archivistMessagesUnsentItemMessage value))], [("name", toJSON (archivistMessagesUnsentItemName value))], [("situation", toJSON (archivistMessagesUnsentItemSituation value))]]))
