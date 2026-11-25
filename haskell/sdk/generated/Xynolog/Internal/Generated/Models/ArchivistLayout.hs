-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ArchivistLayout (ArchivistLayout (..), ArchivistLayoutAnchoredTextEntry (..), ArchivistLayoutAnchoredTextEntryTree (..), archivistLayoutAnchoredTextEntryTreeText, ArchivistLayoutAnchoredTextStamp (..), ArchivistLayoutAnchoredTextStampTree (..), archivistLayoutAnchoredTextStampTreeText, ArchivistLayoutEventFile (..), ArchivistLayoutEventStream (..), ArchivistLayoutEventStreamTree (..), archivistLayoutEventStreamTreeText, ArchivistLayoutStorageUriIndex (..), ArchivistLayoutStorageUriIndexTree (..), archivistLayoutStorageUriIndexTreeText, ArchivistLayoutSystemProjections (..), ArchivistLayoutSystemProjectionsFilesItem (..), ArchivistLayoutSystemProjectionsTree (..), archivistLayoutSystemProjectionsTreeText, ArchivistLayoutSystemStream (..), ArchivistLayoutSystemStreamTree (..), archivistLayoutSystemStreamTreeText, ArchivistLayoutView (..), ArchivistLayoutViewTree (..), archivistLayoutViewTreeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ArchivistLayout = ArchivistLayout
  { archivistLayoutComment :: Text,
    archivistLayoutEventStream :: ArchivistLayoutEventStream,
    archivistLayoutSystemStream :: ArchivistLayoutSystemStream,
    archivistLayoutEventFile :: ArchivistLayoutEventFile,
    archivistLayoutStoredEvent :: Value,
    archivistLayoutView :: ArchivistLayoutView,
    archivistLayoutSystemProjections :: ArchivistLayoutSystemProjections,
    archivistLayoutStorageUriIndex :: ArchivistLayoutStorageUriIndex,
    archivistLayoutAnchoredTextEntry :: ArchivistLayoutAnchoredTextEntry,
    archivistLayoutAnchoredTextStamp :: ArchivistLayoutAnchoredTextStamp
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayout where parseJSON = checked "ArchivistLayout" $ withObject "ArchivistLayout" (\fields -> ArchivistLayout <$> (fields .: "$comment") <*> (fields .: "eventStream") <*> (fields .: "systemStream") <*> (fields .: "eventFile") <*> (fields .: "storedEvent") <*> (fields .: "view") <*> (fields .: "systemProjections") <*> (fields .: "storageUriIndex") <*> (fields .: "anchoredTextEntry") <*> (fields .: "anchoredTextStamp"))

instance ToJSON ArchivistLayout where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (archivistLayoutComment value))], [("eventStream", toJSON (archivistLayoutEventStream value))], [("systemStream", toJSON (archivistLayoutSystemStream value))], [("eventFile", toJSON (archivistLayoutEventFile value))], [("storedEvent", toJSON (archivistLayoutStoredEvent value))], [("view", toJSON (archivistLayoutView value))], [("systemProjections", toJSON (archivistLayoutSystemProjections value))], [("storageUriIndex", toJSON (archivistLayoutStorageUriIndex value))], [("anchoredTextEntry", toJSON (archivistLayoutAnchoredTextEntry value))], [("anchoredTextStamp", toJSON (archivistLayoutAnchoredTextStamp value))]]))

data ArchivistLayoutAnchoredTextEntry = ArchivistLayoutAnchoredTextEntry
  { archivistLayoutAnchoredTextEntryTree :: ArchivistLayoutAnchoredTextEntryTree,
    archivistLayoutAnchoredTextEntryPath :: Text,
    archivistLayoutAnchoredTextEntrySchema :: Value
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutAnchoredTextEntry where parseJSON = checked "ArchivistLayoutAnchoredTextEntry" $ withObject "ArchivistLayoutAnchoredTextEntry" (\fields -> ArchivistLayoutAnchoredTextEntry <$> (fields .: "tree") <*> (fields .: "path") <*> (fields .: "schema"))

instance ToJSON ArchivistLayoutAnchoredTextEntry where toJSON value = Object (KM.fromList (concat [[("tree", toJSON (archivistLayoutAnchoredTextEntryTree value))], [("path", toJSON (archivistLayoutAnchoredTextEntryPath value))], [("schema", toJSON (archivistLayoutAnchoredTextEntrySchema value))]]))

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
  { archivistLayoutAnchoredTextStampTree :: ArchivistLayoutAnchoredTextStampTree,
    archivistLayoutAnchoredTextStampPath :: Text
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutAnchoredTextStamp where parseJSON = checked "ArchivistLayoutAnchoredTextStamp" $ withObject "ArchivistLayoutAnchoredTextStamp" (\fields -> ArchivistLayoutAnchoredTextStamp <$> (fields .: "tree") <*> (fields .: "path"))

instance ToJSON ArchivistLayoutAnchoredTextStamp where toJSON value = Object (KM.fromList (concat [[("tree", toJSON (archivistLayoutAnchoredTextStampTree value))], [("path", toJSON (archivistLayoutAnchoredTextStampPath value))]]))

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
  { archivistLayoutEventFileName :: Text,
    archivistLayoutEventFileDigits :: Integer,
    archivistLayoutEventFileFirst :: Integer,
    archivistLayoutEventFileMaxEvents :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutEventFile where parseJSON = checked "ArchivistLayoutEventFile" $ withObject "ArchivistLayoutEventFile" (\fields -> ArchivistLayoutEventFile <$> (fields .: "name") <*> (fields .: "digits") <*> (fields .: "first") <*> (fields .: "maxEvents"))

instance ToJSON ArchivistLayoutEventFile where toJSON value = Object (KM.fromList (concat [[("name", toJSON (archivistLayoutEventFileName value))], [("digits", toJSON (archivistLayoutEventFileDigits value))], [("first", toJSON (archivistLayoutEventFileFirst value))], [("maxEvents", toJSON (archivistLayoutEventFileMaxEvents value))]]))

data ArchivistLayoutEventStream = ArchivistLayoutEventStream
  { archivistLayoutEventStreamTree :: ArchivistLayoutEventStreamTree,
    archivistLayoutEventStreamPath :: Text
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutEventStream where parseJSON = checked "ArchivistLayoutEventStream" $ withObject "ArchivistLayoutEventStream" (\fields -> ArchivistLayoutEventStream <$> (fields .: "tree") <*> (fields .: "path"))

instance ToJSON ArchivistLayoutEventStream where toJSON value = Object (KM.fromList (concat [[("tree", toJSON (archivistLayoutEventStreamTree value))], [("path", toJSON (archivistLayoutEventStreamPath value))]]))

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
  { archivistLayoutStorageUriIndexTree :: ArchivistLayoutStorageUriIndexTree,
    archivistLayoutStorageUriIndexPath :: Text,
    archivistLayoutStorageUriIndexSchema :: Value
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutStorageUriIndex where parseJSON = checked "ArchivistLayoutStorageUriIndex" $ withObject "ArchivistLayoutStorageUriIndex" (\fields -> ArchivistLayoutStorageUriIndex <$> (fields .: "tree") <*> (fields .: "path") <*> (fields .: "schema"))

instance ToJSON ArchivistLayoutStorageUriIndex where toJSON value = Object (KM.fromList (concat [[("tree", toJSON (archivistLayoutStorageUriIndexTree value))], [("path", toJSON (archivistLayoutStorageUriIndexPath value))], [("schema", toJSON (archivistLayoutStorageUriIndexSchema value))]]))

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
  { archivistLayoutSystemProjectionsTree :: ArchivistLayoutSystemProjectionsTree,
    archivistLayoutSystemProjectionsPath :: Text,
    archivistLayoutSystemProjectionsFiles :: [ArchivistLayoutSystemProjectionsFilesItem]
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutSystemProjections where parseJSON = checked "ArchivistLayoutSystemProjections" $ withObject "ArchivistLayoutSystemProjections" (\fields -> ArchivistLayoutSystemProjections <$> (fields .: "tree") <*> (fields .: "path") <*> (fields .: "files"))

instance ToJSON ArchivistLayoutSystemProjections where toJSON value = Object (KM.fromList (concat [[("tree", toJSON (archivistLayoutSystemProjectionsTree value))], [("path", toJSON (archivistLayoutSystemProjectionsPath value))], [("files", toJSON (archivistLayoutSystemProjectionsFiles value))]]))

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
  { archivistLayoutSystemStreamTree :: ArchivistLayoutSystemStreamTree,
    archivistLayoutSystemStreamPath :: Text
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutSystemStream where parseJSON = checked "ArchivistLayoutSystemStream" $ withObject "ArchivistLayoutSystemStream" (\fields -> ArchivistLayoutSystemStream <$> (fields .: "tree") <*> (fields .: "path"))

instance ToJSON ArchivistLayoutSystemStream where toJSON value = Object (KM.fromList (concat [[("tree", toJSON (archivistLayoutSystemStreamTree value))], [("path", toJSON (archivistLayoutSystemStreamPath value))]]))

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
  { archivistLayoutViewTree :: ArchivistLayoutViewTree,
    archivistLayoutViewPath :: Text,
    archivistLayoutViewSchema :: Value
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutView where parseJSON = checked "ArchivistLayoutView" $ withObject "ArchivistLayoutView" (\fields -> ArchivistLayoutView <$> (fields .: "tree") <*> (fields .: "path") <*> (fields .: "schema"))

instance ToJSON ArchivistLayoutView where toJSON value = Object (KM.fromList (concat [[("tree", toJSON (archivistLayoutViewTree value))], [("path", toJSON (archivistLayoutViewPath value))], [("schema", toJSON (archivistLayoutViewSchema value))]]))

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
