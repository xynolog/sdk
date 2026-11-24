-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ArchivistLayout (ArchivistLayout (..), ArchivistLayoutAnchoredTextEntry (..), ArchivistLayoutAnchoredTextEntryTree (..), archivistLayoutAnchoredTextEntryTreeText, ArchivistLayoutAnchoredTextStamp (..), ArchivistLayoutAnchoredTextStampTree (..), archivistLayoutAnchoredTextStampTreeText, ArchivistLayoutEventFile (..), ArchivistLayoutEventStream (..), ArchivistLayoutEventStreamTree (..), archivistLayoutEventStreamTreeText, ArchivistLayoutStorageUriIndex (..), ArchivistLayoutStorageUriIndexTree (..), archivistLayoutStorageUriIndexTreeText, ArchivistLayoutSystemProjections (..), ArchivistLayoutSystemProjectionsFilesItem (..), ArchivistLayoutSystemProjectionsTree (..), archivistLayoutSystemProjectionsTreeText, ArchivistLayoutSystemStream (..), ArchivistLayoutSystemStreamTree (..), archivistLayoutSystemStreamTreeText, ArchivistLayoutView (..), ArchivistLayoutViewTree (..), archivistLayoutViewTreeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ArchivistLayout = ArchivistLayout
  { archivistLayoutAnchoredTextEntry :: ArchivistLayoutAnchoredTextEntry,
    archivistLayoutAnchoredTextStamp :: ArchivistLayoutAnchoredTextStamp,
    archivistLayoutEventFile :: ArchivistLayoutEventFile,
    archivistLayoutEventStream :: ArchivistLayoutEventStream,
    archivistLayoutStorageUriIndex :: ArchivistLayoutStorageUriIndex,
    archivistLayoutStoredEvent :: Value,
    archivistLayoutSystemProjections :: ArchivistLayoutSystemProjections,
    archivistLayoutSystemStream :: ArchivistLayoutSystemStream,
    archivistLayoutView :: ArchivistLayoutView
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayout where parseJSON = checked "ArchivistLayout" $ withObject "ArchivistLayout" (\fields -> ArchivistLayout <$> (fields .: "anchoredTextEntry") <*> (fields .: "anchoredTextStamp") <*> (fields .: "eventFile") <*> (fields .: "eventStream") <*> (fields .: "storageUriIndex") <*> (fields .: "storedEvent") <*> (fields .: "systemProjections") <*> (fields .: "systemStream") <*> (fields .: "view"))

instance ToJSON ArchivistLayout where toJSON value = Object (KM.fromList (concat [[("anchoredTextEntry", toJSON (archivistLayoutAnchoredTextEntry value))], [("anchoredTextStamp", toJSON (archivistLayoutAnchoredTextStamp value))], [("eventFile", toJSON (archivistLayoutEventFile value))], [("eventStream", toJSON (archivistLayoutEventStream value))], [("storageUriIndex", toJSON (archivistLayoutStorageUriIndex value))], [("storedEvent", toJSON (archivistLayoutStoredEvent value))], [("systemProjections", toJSON (archivistLayoutSystemProjections value))], [("systemStream", toJSON (archivistLayoutSystemStream value))], [("view", toJSON (archivistLayoutView value))]]))

data ArchivistLayoutAnchoredTextEntry = ArchivistLayoutAnchoredTextEntry
  { archivistLayoutAnchoredTextEntryPath :: Text,
    archivistLayoutAnchoredTextEntrySchema :: Value,
    archivistLayoutAnchoredTextEntryTree :: ArchivistLayoutAnchoredTextEntryTree
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutAnchoredTextEntry where parseJSON = checked "ArchivistLayoutAnchoredTextEntry" $ withObject "ArchivistLayoutAnchoredTextEntry" (\fields -> ArchivistLayoutAnchoredTextEntry <$> (fields .: "path") <*> (fields .: "schema") <*> (fields .: "tree"))

instance ToJSON ArchivistLayoutAnchoredTextEntry where toJSON value = Object (KM.fromList (concat [[("path", toJSON (archivistLayoutAnchoredTextEntryPath value))], [("schema", toJSON (archivistLayoutAnchoredTextEntrySchema value))], [("tree", toJSON (archivistLayoutAnchoredTextEntryTree value))]]))

data ArchivistLayoutAnchoredTextEntryTree = ArchivistLayoutAnchoredTextEntryTreeRoot | ArchivistLayoutAnchoredTextEntryTreeStateHome | ArchivistLayoutAnchoredTextEntryTreeAnchoredTextDir deriving (Eq, Show)

instance FromJSON ArchivistLayoutAnchoredTextEntryTree where parseJSON = checked "ArchivistLayoutAnchoredTextEntryTree" $ \value -> if value == String "root" then pure ArchivistLayoutAnchoredTextEntryTreeRoot else if value == String "stateHome" then pure ArchivistLayoutAnchoredTextEntryTreeStateHome else if value == String "anchoredTextDir" then pure ArchivistLayoutAnchoredTextEntryTreeAnchoredTextDir else fail "unknown enumeration member"

instance ToJSON ArchivistLayoutAnchoredTextEntryTree where
  toJSON ArchivistLayoutAnchoredTextEntryTreeRoot = String "root"
  toJSON ArchivistLayoutAnchoredTextEntryTreeStateHome = String "stateHome"
  toJSON ArchivistLayoutAnchoredTextEntryTreeAnchoredTextDir = String "anchoredTextDir"

archivistLayoutAnchoredTextEntryTreeText :: ArchivistLayoutAnchoredTextEntryTree -> Text
archivistLayoutAnchoredTextEntryTreeText ArchivistLayoutAnchoredTextEntryTreeRoot = "root"
archivistLayoutAnchoredTextEntryTreeText ArchivistLayoutAnchoredTextEntryTreeStateHome = "stateHome"
archivistLayoutAnchoredTextEntryTreeText ArchivistLayoutAnchoredTextEntryTreeAnchoredTextDir = "anchoredTextDir"

data ArchivistLayoutAnchoredTextStamp = ArchivistLayoutAnchoredTextStamp
  { archivistLayoutAnchoredTextStampPath :: Text,
    archivistLayoutAnchoredTextStampTree :: ArchivistLayoutAnchoredTextStampTree
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutAnchoredTextStamp where parseJSON = checked "ArchivistLayoutAnchoredTextStamp" $ withObject "ArchivistLayoutAnchoredTextStamp" (\fields -> ArchivistLayoutAnchoredTextStamp <$> (fields .: "path") <*> (fields .: "tree"))

instance ToJSON ArchivistLayoutAnchoredTextStamp where toJSON value = Object (KM.fromList (concat [[("path", toJSON (archivistLayoutAnchoredTextStampPath value))], [("tree", toJSON (archivistLayoutAnchoredTextStampTree value))]]))

data ArchivistLayoutAnchoredTextStampTree = ArchivistLayoutAnchoredTextStampTreeRoot | ArchivistLayoutAnchoredTextStampTreeStateHome | ArchivistLayoutAnchoredTextStampTreeAnchoredTextDir deriving (Eq, Show)

instance FromJSON ArchivistLayoutAnchoredTextStampTree where parseJSON = checked "ArchivistLayoutAnchoredTextStampTree" $ \value -> if value == String "root" then pure ArchivistLayoutAnchoredTextStampTreeRoot else if value == String "stateHome" then pure ArchivistLayoutAnchoredTextStampTreeStateHome else if value == String "anchoredTextDir" then pure ArchivistLayoutAnchoredTextStampTreeAnchoredTextDir else fail "unknown enumeration member"

instance ToJSON ArchivistLayoutAnchoredTextStampTree where
  toJSON ArchivistLayoutAnchoredTextStampTreeRoot = String "root"
  toJSON ArchivistLayoutAnchoredTextStampTreeStateHome = String "stateHome"
  toJSON ArchivistLayoutAnchoredTextStampTreeAnchoredTextDir = String "anchoredTextDir"

archivistLayoutAnchoredTextStampTreeText :: ArchivistLayoutAnchoredTextStampTree -> Text
archivistLayoutAnchoredTextStampTreeText ArchivistLayoutAnchoredTextStampTreeRoot = "root"
archivistLayoutAnchoredTextStampTreeText ArchivistLayoutAnchoredTextStampTreeStateHome = "stateHome"
archivistLayoutAnchoredTextStampTreeText ArchivistLayoutAnchoredTextStampTreeAnchoredTextDir = "anchoredTextDir"

data ArchivistLayoutEventFile = ArchivistLayoutEventFile
  { archivistLayoutEventFileDigits :: Integer,
    archivistLayoutEventFileFirst :: Integer,
    archivistLayoutEventFileMaxEvents :: Integer,
    archivistLayoutEventFileName :: Text
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutEventFile where parseJSON = checked "ArchivistLayoutEventFile" $ withObject "ArchivistLayoutEventFile" (\fields -> ArchivistLayoutEventFile <$> (fields .: "digits") <*> (fields .: "first") <*> (fields .: "maxEvents") <*> (fields .: "name"))

instance ToJSON ArchivistLayoutEventFile where toJSON value = Object (KM.fromList (concat [[("digits", toJSON (archivistLayoutEventFileDigits value))], [("first", toJSON (archivistLayoutEventFileFirst value))], [("maxEvents", toJSON (archivistLayoutEventFileMaxEvents value))], [("name", toJSON (archivistLayoutEventFileName value))]]))

data ArchivistLayoutEventStream = ArchivistLayoutEventStream
  { archivistLayoutEventStreamPath :: Text,
    archivistLayoutEventStreamTree :: ArchivistLayoutEventStreamTree
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutEventStream where parseJSON = checked "ArchivistLayoutEventStream" $ withObject "ArchivistLayoutEventStream" (\fields -> ArchivistLayoutEventStream <$> (fields .: "path") <*> (fields .: "tree"))

instance ToJSON ArchivistLayoutEventStream where toJSON value = Object (KM.fromList (concat [[("path", toJSON (archivistLayoutEventStreamPath value))], [("tree", toJSON (archivistLayoutEventStreamTree value))]]))

data ArchivistLayoutEventStreamTree = ArchivistLayoutEventStreamTreeRoot | ArchivistLayoutEventStreamTreeStateHome | ArchivistLayoutEventStreamTreeAnchoredTextDir deriving (Eq, Show)

instance FromJSON ArchivistLayoutEventStreamTree where parseJSON = checked "ArchivistLayoutEventStreamTree" $ \value -> if value == String "root" then pure ArchivistLayoutEventStreamTreeRoot else if value == String "stateHome" then pure ArchivistLayoutEventStreamTreeStateHome else if value == String "anchoredTextDir" then pure ArchivistLayoutEventStreamTreeAnchoredTextDir else fail "unknown enumeration member"

instance ToJSON ArchivistLayoutEventStreamTree where
  toJSON ArchivistLayoutEventStreamTreeRoot = String "root"
  toJSON ArchivistLayoutEventStreamTreeStateHome = String "stateHome"
  toJSON ArchivistLayoutEventStreamTreeAnchoredTextDir = String "anchoredTextDir"

archivistLayoutEventStreamTreeText :: ArchivistLayoutEventStreamTree -> Text
archivistLayoutEventStreamTreeText ArchivistLayoutEventStreamTreeRoot = "root"
archivistLayoutEventStreamTreeText ArchivistLayoutEventStreamTreeStateHome = "stateHome"
archivistLayoutEventStreamTreeText ArchivistLayoutEventStreamTreeAnchoredTextDir = "anchoredTextDir"

data ArchivistLayoutStorageUriIndex = ArchivistLayoutStorageUriIndex
  { archivistLayoutStorageUriIndexPath :: Text,
    archivistLayoutStorageUriIndexSchema :: Value,
    archivistLayoutStorageUriIndexTree :: ArchivistLayoutStorageUriIndexTree
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutStorageUriIndex where parseJSON = checked "ArchivistLayoutStorageUriIndex" $ withObject "ArchivistLayoutStorageUriIndex" (\fields -> ArchivistLayoutStorageUriIndex <$> (fields .: "path") <*> (fields .: "schema") <*> (fields .: "tree"))

instance ToJSON ArchivistLayoutStorageUriIndex where toJSON value = Object (KM.fromList (concat [[("path", toJSON (archivistLayoutStorageUriIndexPath value))], [("schema", toJSON (archivistLayoutStorageUriIndexSchema value))], [("tree", toJSON (archivistLayoutStorageUriIndexTree value))]]))

data ArchivistLayoutStorageUriIndexTree = ArchivistLayoutStorageUriIndexTreeRoot | ArchivistLayoutStorageUriIndexTreeStateHome | ArchivistLayoutStorageUriIndexTreeAnchoredTextDir deriving (Eq, Show)

instance FromJSON ArchivistLayoutStorageUriIndexTree where parseJSON = checked "ArchivistLayoutStorageUriIndexTree" $ \value -> if value == String "root" then pure ArchivistLayoutStorageUriIndexTreeRoot else if value == String "stateHome" then pure ArchivistLayoutStorageUriIndexTreeStateHome else if value == String "anchoredTextDir" then pure ArchivistLayoutStorageUriIndexTreeAnchoredTextDir else fail "unknown enumeration member"

instance ToJSON ArchivistLayoutStorageUriIndexTree where
  toJSON ArchivistLayoutStorageUriIndexTreeRoot = String "root"
  toJSON ArchivistLayoutStorageUriIndexTreeStateHome = String "stateHome"
  toJSON ArchivistLayoutStorageUriIndexTreeAnchoredTextDir = String "anchoredTextDir"

archivistLayoutStorageUriIndexTreeText :: ArchivistLayoutStorageUriIndexTree -> Text
archivistLayoutStorageUriIndexTreeText ArchivistLayoutStorageUriIndexTreeRoot = "root"
archivistLayoutStorageUriIndexTreeText ArchivistLayoutStorageUriIndexTreeStateHome = "stateHome"
archivistLayoutStorageUriIndexTreeText ArchivistLayoutStorageUriIndexTreeAnchoredTextDir = "anchoredTextDir"

data ArchivistLayoutSystemProjections = ArchivistLayoutSystemProjections
  { archivistLayoutSystemProjectionsFiles :: [ArchivistLayoutSystemProjectionsFilesItem],
    archivistLayoutSystemProjectionsPath :: Text,
    archivistLayoutSystemProjectionsTree :: ArchivistLayoutSystemProjectionsTree
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutSystemProjections where parseJSON = checked "ArchivistLayoutSystemProjections" $ withObject "ArchivistLayoutSystemProjections" (\fields -> ArchivistLayoutSystemProjections <$> (fields .: "files") <*> (fields .: "path") <*> (fields .: "tree"))

instance ToJSON ArchivistLayoutSystemProjections where toJSON value = Object (KM.fromList (concat [[("files", toJSON (archivistLayoutSystemProjectionsFiles value))], [("path", toJSON (archivistLayoutSystemProjectionsPath value))], [("tree", toJSON (archivistLayoutSystemProjectionsTree value))]]))

data ArchivistLayoutSystemProjectionsFilesItem = ArchivistLayoutSystemProjectionsFilesItem
  { archivistLayoutSystemProjectionsFilesItemName :: Text,
    archivistLayoutSystemProjectionsFilesItemSchema :: Value
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutSystemProjectionsFilesItem where parseJSON = checked "ArchivistLayoutSystemProjectionsFilesItem" $ withObject "ArchivistLayoutSystemProjectionsFilesItem" (\fields -> ArchivistLayoutSystemProjectionsFilesItem <$> (fields .: "name") <*> (fields .: "schema"))

instance ToJSON ArchivistLayoutSystemProjectionsFilesItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (archivistLayoutSystemProjectionsFilesItemName value))], [("schema", toJSON (archivistLayoutSystemProjectionsFilesItemSchema value))]]))

data ArchivistLayoutSystemProjectionsTree = ArchivistLayoutSystemProjectionsTreeRoot | ArchivistLayoutSystemProjectionsTreeStateHome | ArchivistLayoutSystemProjectionsTreeAnchoredTextDir deriving (Eq, Show)

instance FromJSON ArchivistLayoutSystemProjectionsTree where parseJSON = checked "ArchivistLayoutSystemProjectionsTree" $ \value -> if value == String "root" then pure ArchivistLayoutSystemProjectionsTreeRoot else if value == String "stateHome" then pure ArchivistLayoutSystemProjectionsTreeStateHome else if value == String "anchoredTextDir" then pure ArchivistLayoutSystemProjectionsTreeAnchoredTextDir else fail "unknown enumeration member"

instance ToJSON ArchivistLayoutSystemProjectionsTree where
  toJSON ArchivistLayoutSystemProjectionsTreeRoot = String "root"
  toJSON ArchivistLayoutSystemProjectionsTreeStateHome = String "stateHome"
  toJSON ArchivistLayoutSystemProjectionsTreeAnchoredTextDir = String "anchoredTextDir"

archivistLayoutSystemProjectionsTreeText :: ArchivistLayoutSystemProjectionsTree -> Text
archivistLayoutSystemProjectionsTreeText ArchivistLayoutSystemProjectionsTreeRoot = "root"
archivistLayoutSystemProjectionsTreeText ArchivistLayoutSystemProjectionsTreeStateHome = "stateHome"
archivistLayoutSystemProjectionsTreeText ArchivistLayoutSystemProjectionsTreeAnchoredTextDir = "anchoredTextDir"

data ArchivistLayoutSystemStream = ArchivistLayoutSystemStream
  { archivistLayoutSystemStreamPath :: Text,
    archivistLayoutSystemStreamTree :: ArchivistLayoutSystemStreamTree
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutSystemStream where parseJSON = checked "ArchivistLayoutSystemStream" $ withObject "ArchivistLayoutSystemStream" (\fields -> ArchivistLayoutSystemStream <$> (fields .: "path") <*> (fields .: "tree"))

instance ToJSON ArchivistLayoutSystemStream where toJSON value = Object (KM.fromList (concat [[("path", toJSON (archivistLayoutSystemStreamPath value))], [("tree", toJSON (archivistLayoutSystemStreamTree value))]]))

data ArchivistLayoutSystemStreamTree = ArchivistLayoutSystemStreamTreeRoot | ArchivistLayoutSystemStreamTreeStateHome | ArchivistLayoutSystemStreamTreeAnchoredTextDir deriving (Eq, Show)

instance FromJSON ArchivistLayoutSystemStreamTree where parseJSON = checked "ArchivistLayoutSystemStreamTree" $ \value -> if value == String "root" then pure ArchivistLayoutSystemStreamTreeRoot else if value == String "stateHome" then pure ArchivistLayoutSystemStreamTreeStateHome else if value == String "anchoredTextDir" then pure ArchivistLayoutSystemStreamTreeAnchoredTextDir else fail "unknown enumeration member"

instance ToJSON ArchivistLayoutSystemStreamTree where
  toJSON ArchivistLayoutSystemStreamTreeRoot = String "root"
  toJSON ArchivistLayoutSystemStreamTreeStateHome = String "stateHome"
  toJSON ArchivistLayoutSystemStreamTreeAnchoredTextDir = String "anchoredTextDir"

archivistLayoutSystemStreamTreeText :: ArchivistLayoutSystemStreamTree -> Text
archivistLayoutSystemStreamTreeText ArchivistLayoutSystemStreamTreeRoot = "root"
archivistLayoutSystemStreamTreeText ArchivistLayoutSystemStreamTreeStateHome = "stateHome"
archivistLayoutSystemStreamTreeText ArchivistLayoutSystemStreamTreeAnchoredTextDir = "anchoredTextDir"

data ArchivistLayoutView = ArchivistLayoutView
  { archivistLayoutViewPath :: Text,
    archivistLayoutViewSchema :: Value,
    archivistLayoutViewTree :: ArchivistLayoutViewTree
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutView where parseJSON = checked "ArchivistLayoutView" $ withObject "ArchivistLayoutView" (\fields -> ArchivistLayoutView <$> (fields .: "path") <*> (fields .: "schema") <*> (fields .: "tree"))

instance ToJSON ArchivistLayoutView where toJSON value = Object (KM.fromList (concat [[("path", toJSON (archivistLayoutViewPath value))], [("schema", toJSON (archivistLayoutViewSchema value))], [("tree", toJSON (archivistLayoutViewTree value))]]))

data ArchivistLayoutViewTree = ArchivistLayoutViewTreeRoot | ArchivistLayoutViewTreeStateHome | ArchivistLayoutViewTreeAnchoredTextDir deriving (Eq, Show)

instance FromJSON ArchivistLayoutViewTree where parseJSON = checked "ArchivistLayoutViewTree" $ \value -> if value == String "root" then pure ArchivistLayoutViewTreeRoot else if value == String "stateHome" then pure ArchivistLayoutViewTreeStateHome else if value == String "anchoredTextDir" then pure ArchivistLayoutViewTreeAnchoredTextDir else fail "unknown enumeration member"

instance ToJSON ArchivistLayoutViewTree where
  toJSON ArchivistLayoutViewTreeRoot = String "root"
  toJSON ArchivistLayoutViewTreeStateHome = String "stateHome"
  toJSON ArchivistLayoutViewTreeAnchoredTextDir = String "anchoredTextDir"

archivistLayoutViewTreeText :: ArchivistLayoutViewTree -> Text
archivistLayoutViewTreeText ArchivistLayoutViewTreeRoot = "root"
archivistLayoutViewTreeText ArchivistLayoutViewTreeStateHome = "stateHome"
archivistLayoutViewTreeText ArchivistLayoutViewTreeAnchoredTextDir = "anchoredTextDir"
