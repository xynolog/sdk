-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ClientRefresh (ClientRefresh (..), ClientRefreshQueriesItem (..), ClientRefreshQueriesItemAsks (..), ClientRefreshQueriesItemAsksPer (..), clientRefreshQueriesItemAsksPerText, ClientRefreshQueriesItemAsksPersisted (..), ClientRefreshQueriesItemAsksValue (..), ClientRefreshQueriesItemReads (..), ClientRefreshQueriesItemReadsPer (..), clientRefreshQueriesItemReadsPerText, ClientRefreshQueriesItemReadsPersisted (..), ClientRefreshQueriesItemReadsValue (..), ClientRefreshRefreshItem (..), ClientRefreshRefreshItemOn (..), ClientRefreshRefreshItemOnNames (..), ClientRefreshRefreshItemOnReach (..), clientRefreshRefreshItemOnReachText, ClientRefreshRefreshItemOnWhen (..), clientRefreshRefreshItemOnWhenText, ClientRefreshRefreshItemStream (..), ClientRefreshRefreshItemStreamStream (..), clientRefreshRefreshItemStreamStreamText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ClientRefresh = ClientRefresh
  { clientRefreshComment :: Text,
    clientRefreshQueries :: [ClientRefreshQueriesItem],
    clientRefreshRefresh :: [ClientRefreshRefreshItem]
  }
  deriving (Eq, Show)

instance FromJSON ClientRefresh where parseJSON = checked "ClientRefresh" $ withObject "ClientRefresh" (\fields -> ClientRefresh <$> (fields .: "$comment") <*> (fields .: "queries") <*> (fields .: "refresh"))

instance ToJSON ClientRefresh where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (clientRefreshComment value))], [("queries", toJSON (clientRefreshQueries value))], [("refresh", toJSON (clientRefreshRefresh value))]]))

data ClientRefreshQueriesItem = ClientRefreshQueriesItemAsks ClientRefreshQueriesItemAsks | ClientRefreshQueriesItemReads ClientRefreshQueriesItemReads deriving (Eq, Show)

instance FromJSON ClientRefreshQueriesItem where parseJSON = checked "ClientRefreshQueriesItem" $ \value -> readMember "ClientRefreshQueriesItem" [([Signature {signatureKind = ObjectKind, signatureRequired = ["name", "asks", "value", "docs"], signatureAllowed = Just ["name", "per", "asks", "persisted", "value", "docs"], signatureFixed = [("per", [String "resource", String "annotation", String "filters"]), ("persisted", [Bool True])], signaturePattern = Nothing, signatureValues = Nothing}], ClientRefreshQueriesItemAsks <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["name", "reads", "value", "docs"], signatureAllowed = Just ["name", "per", "reads", "persisted", "value", "docs"], signatureFixed = [("per", [String "resource", String "annotation", String "filters"]), ("persisted", [Bool True])], signaturePattern = Nothing, signatureValues = Nothing}], ClientRefreshQueriesItemReads <$> parseJSON value)] value

instance ToJSON ClientRefreshQueriesItem where
  toJSON (ClientRefreshQueriesItemAsks value) = toJSON value
  toJSON (ClientRefreshQueriesItemReads value) = toJSON value

data ClientRefreshQueriesItemAsks = MkClientRefreshQueriesItemAsks
  { clientRefreshQueriesItemAsksName :: Text,
    clientRefreshQueriesItemAsksPer :: Maybe ClientRefreshQueriesItemAsksPer,
    clientRefreshQueriesItemAsksAsks :: Text,
    clientRefreshQueriesItemAsksPersisted :: Maybe ClientRefreshQueriesItemAsksPersisted,
    clientRefreshQueriesItemAsksValue :: ClientRefreshQueriesItemAsksValue,
    clientRefreshQueriesItemAsksDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON ClientRefreshQueriesItemAsks where parseJSON = checked "ClientRefreshQueriesItemAsks" $ withObject "ClientRefreshQueriesItemAsks" (\fields -> MkClientRefreshQueriesItemAsks <$> (fields .: "name") <*> optional fields "per" <*> (fields .: "asks") <*> optional fields "persisted" <*> (fields .: "value") <*> (fields .: "docs"))

instance ToJSON ClientRefreshQueriesItemAsks where toJSON value = Object (KM.fromList (concat [[("name", toJSON (clientRefreshQueriesItemAsksName value))], optionalPair "per" (clientRefreshQueriesItemAsksPer value), [("asks", toJSON (clientRefreshQueriesItemAsksAsks value))], optionalPair "persisted" (clientRefreshQueriesItemAsksPersisted value), [("value", toJSON (clientRefreshQueriesItemAsksValue value))], [("docs", toJSON (clientRefreshQueriesItemAsksDocs value))]]))

data ClientRefreshQueriesItemAsksPer = ClientRefreshQueriesItemAsksPerResource | ClientRefreshQueriesItemAsksPerAnnotation | ClientRefreshQueriesItemAsksPerFilters deriving (Eq, Show)

instance FromJSON ClientRefreshQueriesItemAsksPer where parseJSON = checked "ClientRefreshQueriesItemAsksPer" $ \value -> if value == String "resource" then pure ClientRefreshQueriesItemAsksPerResource else if value == String "annotation" then pure ClientRefreshQueriesItemAsksPerAnnotation else if value == String "filters" then pure ClientRefreshQueriesItemAsksPerFilters else fail "unknown enumeration member"

instance ToJSON ClientRefreshQueriesItemAsksPer where
  toJSON ClientRefreshQueriesItemAsksPerResource = String "resource"
  toJSON ClientRefreshQueriesItemAsksPerAnnotation = String "annotation"
  toJSON ClientRefreshQueriesItemAsksPerFilters = String "filters"

clientRefreshQueriesItemAsksPerText :: ClientRefreshQueriesItemAsksPer -> Text
clientRefreshQueriesItemAsksPerText ClientRefreshQueriesItemAsksPerResource = "resource"
clientRefreshQueriesItemAsksPerText ClientRefreshQueriesItemAsksPerAnnotation = "annotation"
clientRefreshQueriesItemAsksPerText ClientRefreshQueriesItemAsksPerFilters = "filters"

data ClientRefreshQueriesItemAsksPersisted = ClientRefreshQueriesItemAsksPersistedTrue deriving (Eq, Show)

instance FromJSON ClientRefreshQueriesItemAsksPersisted where parseJSON = checked "ClientRefreshQueriesItemAsksPersisted" $ \value -> if value == Bool True then pure ClientRefreshQueriesItemAsksPersistedTrue else fail "unknown enumeration member"

instance ToJSON ClientRefreshQueriesItemAsksPersisted where toJSON ClientRefreshQueriesItemAsksPersistedTrue = Bool True

data ClientRefreshQueriesItemAsksValue = ClientRefreshQueriesItemAsksValue
  { clientRefreshQueriesItemAsksValueRef :: Text
  }
  deriving (Eq, Show)

instance FromJSON ClientRefreshQueriesItemAsksValue where parseJSON = checked "ClientRefreshQueriesItemAsksValue" $ withObject "ClientRefreshQueriesItemAsksValue" (\fields -> ClientRefreshQueriesItemAsksValue <$> (fields .: "$ref"))

instance ToJSON ClientRefreshQueriesItemAsksValue where toJSON value = Object (KM.fromList (concat [[("$ref", toJSON (clientRefreshQueriesItemAsksValueRef value))]]))

data ClientRefreshQueriesItemReads = MkClientRefreshQueriesItemReads
  { clientRefreshQueriesItemReadsName :: Text,
    clientRefreshQueriesItemReadsPer :: Maybe ClientRefreshQueriesItemReadsPer,
    clientRefreshQueriesItemReadsReads :: Text,
    clientRefreshQueriesItemReadsPersisted :: Maybe ClientRefreshQueriesItemReadsPersisted,
    clientRefreshQueriesItemReadsValue :: ClientRefreshQueriesItemReadsValue,
    clientRefreshQueriesItemReadsDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON ClientRefreshQueriesItemReads where parseJSON = checked "ClientRefreshQueriesItemReads" $ withObject "ClientRefreshQueriesItemReads" (\fields -> MkClientRefreshQueriesItemReads <$> (fields .: "name") <*> optional fields "per" <*> (fields .: "reads") <*> optional fields "persisted" <*> (fields .: "value") <*> (fields .: "docs"))

instance ToJSON ClientRefreshQueriesItemReads where toJSON value = Object (KM.fromList (concat [[("name", toJSON (clientRefreshQueriesItemReadsName value))], optionalPair "per" (clientRefreshQueriesItemReadsPer value), [("reads", toJSON (clientRefreshQueriesItemReadsReads value))], optionalPair "persisted" (clientRefreshQueriesItemReadsPersisted value), [("value", toJSON (clientRefreshQueriesItemReadsValue value))], [("docs", toJSON (clientRefreshQueriesItemReadsDocs value))]]))

data ClientRefreshQueriesItemReadsPer = ClientRefreshQueriesItemReadsPerResource | ClientRefreshQueriesItemReadsPerAnnotation | ClientRefreshQueriesItemReadsPerFilters deriving (Eq, Show)

instance FromJSON ClientRefreshQueriesItemReadsPer where parseJSON = checked "ClientRefreshQueriesItemReadsPer" $ \value -> if value == String "resource" then pure ClientRefreshQueriesItemReadsPerResource else if value == String "annotation" then pure ClientRefreshQueriesItemReadsPerAnnotation else if value == String "filters" then pure ClientRefreshQueriesItemReadsPerFilters else fail "unknown enumeration member"

instance ToJSON ClientRefreshQueriesItemReadsPer where
  toJSON ClientRefreshQueriesItemReadsPerResource = String "resource"
  toJSON ClientRefreshQueriesItemReadsPerAnnotation = String "annotation"
  toJSON ClientRefreshQueriesItemReadsPerFilters = String "filters"

clientRefreshQueriesItemReadsPerText :: ClientRefreshQueriesItemReadsPer -> Text
clientRefreshQueriesItemReadsPerText ClientRefreshQueriesItemReadsPerResource = "resource"
clientRefreshQueriesItemReadsPerText ClientRefreshQueriesItemReadsPerAnnotation = "annotation"
clientRefreshQueriesItemReadsPerText ClientRefreshQueriesItemReadsPerFilters = "filters"

data ClientRefreshQueriesItemReadsPersisted = ClientRefreshQueriesItemReadsPersistedTrue deriving (Eq, Show)

instance FromJSON ClientRefreshQueriesItemReadsPersisted where parseJSON = checked "ClientRefreshQueriesItemReadsPersisted" $ \value -> if value == Bool True then pure ClientRefreshQueriesItemReadsPersistedTrue else fail "unknown enumeration member"

instance ToJSON ClientRefreshQueriesItemReadsPersisted where toJSON ClientRefreshQueriesItemReadsPersistedTrue = Bool True

data ClientRefreshQueriesItemReadsValue = ClientRefreshQueriesItemReadsValue
  { clientRefreshQueriesItemReadsValueRef :: Text
  }
  deriving (Eq, Show)

instance FromJSON ClientRefreshQueriesItemReadsValue where parseJSON = checked "ClientRefreshQueriesItemReadsValue" $ withObject "ClientRefreshQueriesItemReadsValue" (\fields -> ClientRefreshQueriesItemReadsValue <$> (fields .: "$ref"))

instance ToJSON ClientRefreshQueriesItemReadsValue where toJSON value = Object (KM.fromList (concat [[("$ref", toJSON (clientRefreshQueriesItemReadsValueRef value))]]))

data ClientRefreshRefreshItem = ClientRefreshRefreshItemOn ClientRefreshRefreshItemOn | ClientRefreshRefreshItemStream ClientRefreshRefreshItemStream deriving (Eq, Show)

instance FromJSON ClientRefreshRefreshItem where parseJSON = checked "ClientRefreshRefreshItem" $ \value -> readMember "ClientRefreshRefreshItem" [([Signature {signatureKind = ObjectKind, signatureRequired = ["on", "docs"], signatureAllowed = Just ["on", "when", "reach", "names", "carries", "refetches", "writes", "removes", "docs"], signatureFixed = [("when", [String "enriched", String "unenriched"]), ("reach", [String "subject", String "held"])], signaturePattern = Nothing, signatureValues = Nothing}], ClientRefreshRefreshItemOn <$> parseJSON value), ([Signature {signatureKind = ObjectKind, signatureRequired = ["stream", "docs"], signatureAllowed = Just ["stream", "reach", "refetches", "docs"], signatureFixed = [("stream", [String "reopened", String "unreadable"]), ("reach", [String "subject", String "held"])], signaturePattern = Nothing, signatureValues = Nothing}], ClientRefreshRefreshItemStream <$> parseJSON value)] value

instance ToJSON ClientRefreshRefreshItem where
  toJSON (ClientRefreshRefreshItemOn value) = toJSON value
  toJSON (ClientRefreshRefreshItemStream value) = toJSON value

data ClientRefreshRefreshItemOn = MkClientRefreshRefreshItemOn
  { clientRefreshRefreshItemOnOn :: Text,
    clientRefreshRefreshItemOnWhen :: Maybe ClientRefreshRefreshItemOnWhen,
    clientRefreshRefreshItemOnReach :: Maybe ClientRefreshRefreshItemOnReach,
    clientRefreshRefreshItemOnNames :: Maybe ClientRefreshRefreshItemOnNames,
    clientRefreshRefreshItemOnCarries :: Maybe Text,
    clientRefreshRefreshItemOnRefetches :: Maybe [Text],
    clientRefreshRefreshItemOnWrites :: Maybe [Text],
    clientRefreshRefreshItemOnRemoves :: Maybe [Text],
    clientRefreshRefreshItemOnDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON ClientRefreshRefreshItemOn where parseJSON = checked "ClientRefreshRefreshItemOn" $ withObject "ClientRefreshRefreshItemOn" (\fields -> MkClientRefreshRefreshItemOn <$> (fields .: "on") <*> optional fields "when" <*> optional fields "reach" <*> optional fields "names" <*> optional fields "carries" <*> optional fields "refetches" <*> optional fields "writes" <*> optional fields "removes" <*> (fields .: "docs"))

instance ToJSON ClientRefreshRefreshItemOn where toJSON value = Object (KM.fromList (concat [[("on", toJSON (clientRefreshRefreshItemOnOn value))], optionalPair "when" (clientRefreshRefreshItemOnWhen value), optionalPair "reach" (clientRefreshRefreshItemOnReach value), optionalPair "names" (clientRefreshRefreshItemOnNames value), optionalPair "carries" (clientRefreshRefreshItemOnCarries value), optionalPair "refetches" (clientRefreshRefreshItemOnRefetches value), optionalPair "writes" (clientRefreshRefreshItemOnWrites value), optionalPair "removes" (clientRefreshRefreshItemOnRemoves value), [("docs", toJSON (clientRefreshRefreshItemOnDocs value))]]))

data ClientRefreshRefreshItemOnNames = ClientRefreshRefreshItemOnNames
  { clientRefreshRefreshItemOnNamesResource :: Maybe Text,
    clientRefreshRefreshItemOnNamesAnnotation :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ClientRefreshRefreshItemOnNames where parseJSON = checked "ClientRefreshRefreshItemOnNames" $ withObject "ClientRefreshRefreshItemOnNames" (\fields -> ClientRefreshRefreshItemOnNames <$> optional fields "resource" <*> optional fields "annotation")

instance ToJSON ClientRefreshRefreshItemOnNames where toJSON value = Object (KM.fromList (concat [optionalPair "resource" (clientRefreshRefreshItemOnNamesResource value), optionalPair "annotation" (clientRefreshRefreshItemOnNamesAnnotation value)]))

data ClientRefreshRefreshItemOnReach = ClientRefreshRefreshItemOnReachSubject | ClientRefreshRefreshItemOnReachHeld deriving (Eq, Show)

instance FromJSON ClientRefreshRefreshItemOnReach where parseJSON = checked "ClientRefreshRefreshItemOnReach" $ \value -> if value == String "subject" then pure ClientRefreshRefreshItemOnReachSubject else if value == String "held" then pure ClientRefreshRefreshItemOnReachHeld else fail "unknown enumeration member"

instance ToJSON ClientRefreshRefreshItemOnReach where
  toJSON ClientRefreshRefreshItemOnReachSubject = String "subject"
  toJSON ClientRefreshRefreshItemOnReachHeld = String "held"

clientRefreshRefreshItemOnReachText :: ClientRefreshRefreshItemOnReach -> Text
clientRefreshRefreshItemOnReachText ClientRefreshRefreshItemOnReachSubject = "subject"
clientRefreshRefreshItemOnReachText ClientRefreshRefreshItemOnReachHeld = "held"

data ClientRefreshRefreshItemOnWhen = ClientRefreshRefreshItemOnWhenEnriched | ClientRefreshRefreshItemOnWhenUnenriched deriving (Eq, Show)

instance FromJSON ClientRefreshRefreshItemOnWhen where parseJSON = checked "ClientRefreshRefreshItemOnWhen" $ \value -> if value == String "enriched" then pure ClientRefreshRefreshItemOnWhenEnriched else if value == String "unenriched" then pure ClientRefreshRefreshItemOnWhenUnenriched else fail "unknown enumeration member"

instance ToJSON ClientRefreshRefreshItemOnWhen where
  toJSON ClientRefreshRefreshItemOnWhenEnriched = String "enriched"
  toJSON ClientRefreshRefreshItemOnWhenUnenriched = String "unenriched"

clientRefreshRefreshItemOnWhenText :: ClientRefreshRefreshItemOnWhen -> Text
clientRefreshRefreshItemOnWhenText ClientRefreshRefreshItemOnWhenEnriched = "enriched"
clientRefreshRefreshItemOnWhenText ClientRefreshRefreshItemOnWhenUnenriched = "unenriched"

data ClientRefreshRefreshItemStream = MkClientRefreshRefreshItemStream
  { clientRefreshRefreshItemStreamStream :: ClientRefreshRefreshItemStreamStream,
    clientRefreshRefreshItemStreamReach :: Maybe ClientRefreshRefreshItemOnReach,
    clientRefreshRefreshItemStreamRefetches :: Maybe [Text],
    clientRefreshRefreshItemStreamDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON ClientRefreshRefreshItemStream where parseJSON = checked "ClientRefreshRefreshItemStream" $ withObject "ClientRefreshRefreshItemStream" (\fields -> MkClientRefreshRefreshItemStream <$> (fields .: "stream") <*> optional fields "reach" <*> optional fields "refetches" <*> (fields .: "docs"))

instance ToJSON ClientRefreshRefreshItemStream where toJSON value = Object (KM.fromList (concat [[("stream", toJSON (clientRefreshRefreshItemStreamStream value))], optionalPair "reach" (clientRefreshRefreshItemStreamReach value), optionalPair "refetches" (clientRefreshRefreshItemStreamRefetches value), [("docs", toJSON (clientRefreshRefreshItemStreamDocs value))]]))

data ClientRefreshRefreshItemStreamStream = ClientRefreshRefreshItemStreamStreamReopened | ClientRefreshRefreshItemStreamStreamUnreadable deriving (Eq, Show)

instance FromJSON ClientRefreshRefreshItemStreamStream where parseJSON = checked "ClientRefreshRefreshItemStreamStream" $ \value -> if value == String "reopened" then pure ClientRefreshRefreshItemStreamStreamReopened else if value == String "unreadable" then pure ClientRefreshRefreshItemStreamStreamUnreadable else fail "unknown enumeration member"

instance ToJSON ClientRefreshRefreshItemStreamStream where
  toJSON ClientRefreshRefreshItemStreamStreamReopened = String "reopened"
  toJSON ClientRefreshRefreshItemStreamStreamUnreadable = String "unreadable"

clientRefreshRefreshItemStreamStreamText :: ClientRefreshRefreshItemStreamStream -> Text
clientRefreshRefreshItemStreamStreamText ClientRefreshRefreshItemStreamStreamReopened = "reopened"
clientRefreshRefreshItemStreamStreamText ClientRefreshRefreshItemStreamStreamUnreadable = "unreadable"
