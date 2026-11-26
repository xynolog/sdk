-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ClientOptionDefaults (ClientOptionDefaults (..), ClientOptionDefaultsDefaultsItem (..), ClientOptionDefaultsDefaultsItemSchema (..), ClientOptionDefaultsDefaultsItemSchemaDateTime (..), ClientOptionDefaultsDefaultsItemSchemaDateTimeFormat (..), clientOptionDefaultsDefaultsItemSchemaDateTimeFormatText, ClientOptionDefaultsDefaultsItemSchemaDateTimeType (..), clientOptionDefaultsDefaultsItemSchemaDateTimeTypeText, ClientOptionDefaultsDefaultsItemSchemaReference (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ClientOptionDefaults = ClientOptionDefaults
  { clientOptionDefaultsComment :: Text,
    clientOptionDefaultsDefaults :: [ClientOptionDefaultsDefaultsItem]
  }
  deriving (Eq, Show)

instance FromJSON ClientOptionDefaults where parseJSON = checked "ClientOptionDefaults" $ withObject "ClientOptionDefaults" (\fields -> ClientOptionDefaults <$> (fields .: "$comment") <*> (fields .: "defaults"))

instance ToJSON ClientOptionDefaults where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (clientOptionDefaultsComment value))], [("defaults", toJSON (clientOptionDefaultsDefaults value))]]))

data ClientOptionDefaultsDefaultsItem = ClientOptionDefaultsDefaultsItem
  { clientOptionDefaultsDefaultsItemMethod :: Text,
    clientOptionDefaultsDefaultsItemParameter :: Text,
    clientOptionDefaultsDefaultsItemOption :: Maybe Text,
    clientOptionDefaultsDefaultsItemValue :: Value,
    clientOptionDefaultsDefaultsItemSchema :: Maybe ClientOptionDefaultsDefaultsItemSchema,
    clientOptionDefaultsDefaultsItemSends :: Maybe Text,
    clientOptionDefaultsDefaultsItemDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON ClientOptionDefaultsDefaultsItem where parseJSON = checked "ClientOptionDefaultsDefaultsItem" $ withObject "ClientOptionDefaultsDefaultsItem" (\fields -> ClientOptionDefaultsDefaultsItem <$> (fields .: "method") <*> (fields .: "parameter") <*> optional fields "option" <*> (fields .: "value") <*> optional fields "schema" <*> optional fields "sends" <*> (fields .: "docs"))

instance ToJSON ClientOptionDefaultsDefaultsItem where toJSON value = Object (KM.fromList (concat [[("method", toJSON (clientOptionDefaultsDefaultsItemMethod value))], [("parameter", toJSON (clientOptionDefaultsDefaultsItemParameter value))], optionalPair "option" (clientOptionDefaultsDefaultsItemOption value), [("value", toJSON (clientOptionDefaultsDefaultsItemValue value))], optionalPair "schema" (clientOptionDefaultsDefaultsItemSchema value), optionalPair "sends" (clientOptionDefaultsDefaultsItemSends value), [("docs", toJSON (clientOptionDefaultsDefaultsItemDocs value))]]))

data ClientOptionDefaultsDefaultsItemSchema = ClientOptionDefaultsDefaultsItemSchemaReference ClientOptionDefaultsDefaultsItemSchemaReference | ClientOptionDefaultsDefaultsItemSchemaDateTime ClientOptionDefaultsDefaultsItemSchemaDateTime deriving (Eq, Show)

instance FromJSON ClientOptionDefaultsDefaultsItemSchema where parseJSON = checked "ClientOptionDefaultsDefaultsItemSchema" $ \value -> readMember "ClientOptionDefaultsDefaultsItemSchema" [([Signature {signatureKind = ObjectKind, signatureRequired = ["$ref"], signatureAllowed = Just ["$ref"], signatureFixed = [], signaturePattern = Nothing, signatureValues = Nothing}], ClientOptionDefaultsDefaultsItemSchemaReference <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["type", "description"], signatureAllowed = Just ["type", "minimum", "format", "description"], signatureFixed = [("type", [String "integer", String "string", String "boolean"]), ("format", [String "date-time"])], signaturePattern = Nothing, signatureValues = Nothing}], ClientOptionDefaultsDefaultsItemSchemaDateTime <$> parseJSON value)] value

instance ToJSON ClientOptionDefaultsDefaultsItemSchema where
  toJSON (ClientOptionDefaultsDefaultsItemSchemaReference value) = toJSON value
  toJSON (ClientOptionDefaultsDefaultsItemSchemaDateTime value) = toJSON value

data ClientOptionDefaultsDefaultsItemSchemaDateTime = MkClientOptionDefaultsDefaultsItemSchemaDateTime
  { clientOptionDefaultsDefaultsItemSchemaDateTimeType :: ClientOptionDefaultsDefaultsItemSchemaDateTimeType,
    clientOptionDefaultsDefaultsItemSchemaDateTimeMinimum :: Maybe Integer,
    clientOptionDefaultsDefaultsItemSchemaDateTimeFormat :: Maybe ClientOptionDefaultsDefaultsItemSchemaDateTimeFormat,
    clientOptionDefaultsDefaultsItemSchemaDateTimeDescription :: Text
  }
  deriving (Eq, Show)

instance FromJSON ClientOptionDefaultsDefaultsItemSchemaDateTime where parseJSON = checked "ClientOptionDefaultsDefaultsItemSchemaDateTime" $ withObject "ClientOptionDefaultsDefaultsItemSchemaDateTime" (\fields -> MkClientOptionDefaultsDefaultsItemSchemaDateTime <$> (fields .: "type") <*> optional fields "minimum" <*> optional fields "format" <*> (fields .: "description"))

instance ToJSON ClientOptionDefaultsDefaultsItemSchemaDateTime where toJSON value = Object (KM.fromList (concat [[("type", toJSON (clientOptionDefaultsDefaultsItemSchemaDateTimeType value))], optionalPair "minimum" (clientOptionDefaultsDefaultsItemSchemaDateTimeMinimum value), optionalPair "format" (clientOptionDefaultsDefaultsItemSchemaDateTimeFormat value), [("description", toJSON (clientOptionDefaultsDefaultsItemSchemaDateTimeDescription value))]]))

data ClientOptionDefaultsDefaultsItemSchemaDateTimeFormat = ClientOptionDefaultsDefaultsItemSchemaDateTimeFormatDateTime deriving (Eq, Show)

instance FromJSON ClientOptionDefaultsDefaultsItemSchemaDateTimeFormat where parseJSON = checked "ClientOptionDefaultsDefaultsItemSchemaDateTimeFormat" $ \value -> if value == String "date-time" then pure ClientOptionDefaultsDefaultsItemSchemaDateTimeFormatDateTime else fail "unknown enumeration member"

instance ToJSON ClientOptionDefaultsDefaultsItemSchemaDateTimeFormat where toJSON ClientOptionDefaultsDefaultsItemSchemaDateTimeFormatDateTime = String "date-time"

clientOptionDefaultsDefaultsItemSchemaDateTimeFormatText :: ClientOptionDefaultsDefaultsItemSchemaDateTimeFormat -> Text
clientOptionDefaultsDefaultsItemSchemaDateTimeFormatText ClientOptionDefaultsDefaultsItemSchemaDateTimeFormatDateTime = "date-time"

data ClientOptionDefaultsDefaultsItemSchemaDateTimeType = ClientOptionDefaultsDefaultsItemSchemaDateTimeTypeInteger | ClientOptionDefaultsDefaultsItemSchemaDateTimeTypeString | ClientOptionDefaultsDefaultsItemSchemaDateTimeTypeBoolean deriving (Eq, Show)

instance FromJSON ClientOptionDefaultsDefaultsItemSchemaDateTimeType where parseJSON = checked "ClientOptionDefaultsDefaultsItemSchemaDateTimeType" $ \value -> if value == String "integer" then pure ClientOptionDefaultsDefaultsItemSchemaDateTimeTypeInteger else if value == String "string" then pure ClientOptionDefaultsDefaultsItemSchemaDateTimeTypeString else if value == String "boolean" then pure ClientOptionDefaultsDefaultsItemSchemaDateTimeTypeBoolean else fail "unknown enumeration member"

instance ToJSON ClientOptionDefaultsDefaultsItemSchemaDateTimeType where
  toJSON ClientOptionDefaultsDefaultsItemSchemaDateTimeTypeInteger = String "integer"
  toJSON ClientOptionDefaultsDefaultsItemSchemaDateTimeTypeString = String "string"
  toJSON ClientOptionDefaultsDefaultsItemSchemaDateTimeTypeBoolean = String "boolean"

clientOptionDefaultsDefaultsItemSchemaDateTimeTypeText :: ClientOptionDefaultsDefaultsItemSchemaDateTimeType -> Text
clientOptionDefaultsDefaultsItemSchemaDateTimeTypeText ClientOptionDefaultsDefaultsItemSchemaDateTimeTypeInteger = "integer"
clientOptionDefaultsDefaultsItemSchemaDateTimeTypeText ClientOptionDefaultsDefaultsItemSchemaDateTimeTypeString = "string"
clientOptionDefaultsDefaultsItemSchemaDateTimeTypeText ClientOptionDefaultsDefaultsItemSchemaDateTimeTypeBoolean = "boolean"

data ClientOptionDefaultsDefaultsItemSchemaReference = MkClientOptionDefaultsDefaultsItemSchemaReference
  { clientOptionDefaultsDefaultsItemSchemaReferenceRef :: Text
  }
  deriving (Eq, Show)

instance FromJSON ClientOptionDefaultsDefaultsItemSchemaReference where parseJSON = checked "ClientOptionDefaultsDefaultsItemSchemaReference" $ withObject "ClientOptionDefaultsDefaultsItemSchemaReference" (\fields -> MkClientOptionDefaultsDefaultsItemSchemaReference <$> (fields .: "$ref"))

instance ToJSON ClientOptionDefaultsDefaultsItemSchemaReference where toJSON value = Object (KM.fromList (concat [[("$ref", toJSON (clientOptionDefaultsDefaultsItemSchemaReferenceRef value))]]))
