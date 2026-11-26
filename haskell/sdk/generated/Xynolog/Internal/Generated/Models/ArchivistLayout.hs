-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ArchivistLayout (ArchivistLayout (..), ArchivistLayoutAnchoredTextEntry (..), ArchivistLayoutAnchoredTextStamp (..), ArchivistLayoutEventFile (..), ArchivistLayoutEventStream (..), ArchivistLayoutEventStreamTree (..), archivistLayoutEventStreamTreeText, ArchivistLayoutStorageUriIndex (..), ArchivistLayoutSystemProjections (..), ArchivistLayoutSystemProjectionsFilesItem (..), ArchivistLayoutSystemStream (..), ArchivistLayoutView (..)) where

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
  { archivistLayoutAnchoredTextEntryTree :: ArchivistLayoutEventStreamTree,
    archivistLayoutAnchoredTextEntryPath :: Text,
    archivistLayoutAnchoredTextEntrySchema :: Value
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutAnchoredTextEntry where parseJSON = checked "ArchivistLayoutAnchoredTextEntry" $ withObject "ArchivistLayoutAnchoredTextEntry" (\fields -> ArchivistLayoutAnchoredTextEntry <$> (fields .: "tree") <*> (fields .: "path") <*> (fields .: "schema"))

instance ToJSON ArchivistLayoutAnchoredTextEntry where toJSON value = Object (KM.fromList (concat [[("tree", toJSON (archivistLayoutAnchoredTextEntryTree value))], [("path", toJSON (archivistLayoutAnchoredTextEntryPath value))], [("schema", toJSON (archivistLayoutAnchoredTextEntrySchema value))]]))

data ArchivistLayoutAnchoredTextStamp = ArchivistLayoutAnchoredTextStamp
  { archivistLayoutAnchoredTextStampTree :: ArchivistLayoutEventStreamTree,
    archivistLayoutAnchoredTextStampPath :: Text
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutAnchoredTextStamp where parseJSON = checked "ArchivistLayoutAnchoredTextStamp" $ withObject "ArchivistLayoutAnchoredTextStamp" (\fields -> ArchivistLayoutAnchoredTextStamp <$> (fields .: "tree") <*> (fields .: "path"))

instance ToJSON ArchivistLayoutAnchoredTextStamp where toJSON value = Object (KM.fromList (concat [[("tree", toJSON (archivistLayoutAnchoredTextStampTree value))], [("path", toJSON (archivistLayoutAnchoredTextStampPath value))]]))

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
  { archivistLayoutStorageUriIndexTree :: ArchivistLayoutEventStreamTree,
    archivistLayoutStorageUriIndexPath :: Text,
    archivistLayoutStorageUriIndexSchema :: Value
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutStorageUriIndex where parseJSON = checked "ArchivistLayoutStorageUriIndex" $ withObject "ArchivistLayoutStorageUriIndex" (\fields -> ArchivistLayoutStorageUriIndex <$> (fields .: "tree") <*> (fields .: "path") <*> (fields .: "schema"))

instance ToJSON ArchivistLayoutStorageUriIndex where toJSON value = Object (KM.fromList (concat [[("tree", toJSON (archivistLayoutStorageUriIndexTree value))], [("path", toJSON (archivistLayoutStorageUriIndexPath value))], [("schema", toJSON (archivistLayoutStorageUriIndexSchema value))]]))

data ArchivistLayoutSystemProjections = ArchivistLayoutSystemProjections
  { archivistLayoutSystemProjectionsTree :: ArchivistLayoutEventStreamTree,
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

data ArchivistLayoutSystemStream = ArchivistLayoutSystemStream
  { archivistLayoutSystemStreamTree :: ArchivistLayoutEventStreamTree,
    archivistLayoutSystemStreamPath :: Text
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutSystemStream where parseJSON = checked "ArchivistLayoutSystemStream" $ withObject "ArchivistLayoutSystemStream" (\fields -> ArchivistLayoutSystemStream <$> (fields .: "tree") <*> (fields .: "path"))

instance ToJSON ArchivistLayoutSystemStream where toJSON value = Object (KM.fromList (concat [[("tree", toJSON (archivistLayoutSystemStreamTree value))], [("path", toJSON (archivistLayoutSystemStreamPath value))]]))

data ArchivistLayoutView = ArchivistLayoutView
  { archivistLayoutViewTree :: ArchivistLayoutEventStreamTree,
    archivistLayoutViewPath :: Text,
    archivistLayoutViewSchema :: Value
  }
  deriving (Eq, Show)

instance FromJSON ArchivistLayoutView where parseJSON = checked "ArchivistLayoutView" $ withObject "ArchivistLayoutView" (\fields -> ArchivistLayoutView <$> (fields .: "tree") <*> (fields .: "path") <*> (fields .: "schema"))

instance ToJSON ArchivistLayoutView where toJSON value = Object (KM.fromList (concat [[("tree", toJSON (archivistLayoutViewTree value))], [("path", toJSON (archivistLayoutViewPath value))], [("schema", toJSON (archivistLayoutViewSchema value))]]))
