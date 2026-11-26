-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.SignInStoreOwnerOnly (SignInStoreOwnerOnly (..), SignInStoreOwnerOnlyDirectoryAccessList (..), SignInStoreOwnerOnlyDirectoryMode (..), SignInStoreOwnerOnlyFileAccessList (..), SignInStoreOwnerOnlyFileMode (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data SignInStoreOwnerOnly = SignInStoreOwnerOnly
  { signInStoreOwnerOnlyComment :: Text,
    signInStoreOwnerOnlyDirectoryMode :: SignInStoreOwnerOnlyDirectoryMode,
    signInStoreOwnerOnlyFileMode :: SignInStoreOwnerOnlyFileMode,
    signInStoreOwnerOnlyDirectoryAccessList :: SignInStoreOwnerOnlyDirectoryAccessList,
    signInStoreOwnerOnlyFileAccessList :: SignInStoreOwnerOnlyFileAccessList
  }
  deriving (Eq, Show)

instance FromJSON SignInStoreOwnerOnly where parseJSON = checked "SignInStoreOwnerOnly" $ withObject "SignInStoreOwnerOnly" (\fields -> SignInStoreOwnerOnly <$> (fields .: "$comment") <*> (fields .: "directoryMode") <*> (fields .: "fileMode") <*> (fields .: "directoryAccessList") <*> (fields .: "fileAccessList"))

instance ToJSON SignInStoreOwnerOnly where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (signInStoreOwnerOnlyComment value))], [("directoryMode", toJSON (signInStoreOwnerOnlyDirectoryMode value))], [("fileMode", toJSON (signInStoreOwnerOnlyFileMode value))], [("directoryAccessList", toJSON (signInStoreOwnerOnlyDirectoryAccessList value))], [("fileAccessList", toJSON (signInStoreOwnerOnlyFileAccessList value))]]))

data SignInStoreOwnerOnlyDirectoryAccessList = SignInStoreOwnerOnlyDirectoryAccessList
  { signInStoreOwnerOnlyDirectoryAccessListValue :: Text,
    signInStoreOwnerOnlyDirectoryAccessListDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON SignInStoreOwnerOnlyDirectoryAccessList where parseJSON = checked "SignInStoreOwnerOnlyDirectoryAccessList" $ withObject "SignInStoreOwnerOnlyDirectoryAccessList" (\fields -> SignInStoreOwnerOnlyDirectoryAccessList <$> (fields .: "value") <*> (fields .: "docs"))

instance ToJSON SignInStoreOwnerOnlyDirectoryAccessList where toJSON value = Object (KM.fromList (concat [[("value", toJSON (signInStoreOwnerOnlyDirectoryAccessListValue value))], [("docs", toJSON (signInStoreOwnerOnlyDirectoryAccessListDocs value))]]))

data SignInStoreOwnerOnlyDirectoryMode = SignInStoreOwnerOnlyDirectoryMode
  { signInStoreOwnerOnlyDirectoryModeValue :: Text,
    signInStoreOwnerOnlyDirectoryModeDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON SignInStoreOwnerOnlyDirectoryMode where parseJSON = checked "SignInStoreOwnerOnlyDirectoryMode" $ withObject "SignInStoreOwnerOnlyDirectoryMode" (\fields -> SignInStoreOwnerOnlyDirectoryMode <$> (fields .: "value") <*> (fields .: "docs"))

instance ToJSON SignInStoreOwnerOnlyDirectoryMode where toJSON value = Object (KM.fromList (concat [[("value", toJSON (signInStoreOwnerOnlyDirectoryModeValue value))], [("docs", toJSON (signInStoreOwnerOnlyDirectoryModeDocs value))]]))

data SignInStoreOwnerOnlyFileAccessList = SignInStoreOwnerOnlyFileAccessList
  { signInStoreOwnerOnlyFileAccessListValue :: Text,
    signInStoreOwnerOnlyFileAccessListDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON SignInStoreOwnerOnlyFileAccessList where parseJSON = checked "SignInStoreOwnerOnlyFileAccessList" $ withObject "SignInStoreOwnerOnlyFileAccessList" (\fields -> SignInStoreOwnerOnlyFileAccessList <$> (fields .: "value") <*> (fields .: "docs"))

instance ToJSON SignInStoreOwnerOnlyFileAccessList where toJSON value = Object (KM.fromList (concat [[("value", toJSON (signInStoreOwnerOnlyFileAccessListValue value))], [("docs", toJSON (signInStoreOwnerOnlyFileAccessListDocs value))]]))

data SignInStoreOwnerOnlyFileMode = SignInStoreOwnerOnlyFileMode
  { signInStoreOwnerOnlyFileModeValue :: Text,
    signInStoreOwnerOnlyFileModeDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON SignInStoreOwnerOnlyFileMode where parseJSON = checked "SignInStoreOwnerOnlyFileMode" $ withObject "SignInStoreOwnerOnlyFileMode" (\fields -> SignInStoreOwnerOnlyFileMode <$> (fields .: "value") <*> (fields .: "docs"))

instance ToJSON SignInStoreOwnerOnlyFileMode where toJSON value = Object (KM.fromList (concat [[("value", toJSON (signInStoreOwnerOnlyFileModeValue value))], [("docs", toJSON (signInStoreOwnerOnlyFileModeDocs value))]]))
