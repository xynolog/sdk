-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.LocalesRegistry (LocalesRegistry (..), LocalesRegistryLocalesItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data LocalesRegistry = LocalesRegistry
  { localesRegistryComment :: Text,
    localesRegistryLocales :: [LocalesRegistryLocalesItem]
  }
  deriving (Eq, Show)

instance FromJSON LocalesRegistry where parseJSON = checked "LocalesRegistry" $ withObject "LocalesRegistry" (\fields -> LocalesRegistry <$> (fields .: "$comment") <*> (fields .: "locales"))

instance ToJSON LocalesRegistry where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (localesRegistryComment value))], [("locales", toJSON (localesRegistryLocales value))]]))

data LocalesRegistryLocalesItem = LocalesRegistryLocalesItem
  { localesRegistryLocalesItemCode :: Text,
    localesRegistryLocalesItemNativeName :: Text,
    localesRegistryLocalesItemEnglishName :: Text
  }
  deriving (Eq, Show)

instance FromJSON LocalesRegistryLocalesItem where parseJSON = checked "LocalesRegistryLocalesItem" $ withObject "LocalesRegistryLocalesItem" (\fields -> LocalesRegistryLocalesItem <$> (fields .: "code") <*> (fields .: "nativeName") <*> (fields .: "englishName"))

instance ToJSON LocalesRegistryLocalesItem where toJSON value = Object (KM.fromList (concat [[("code", toJSON (localesRegistryLocalesItemCode value))], [("nativeName", toJSON (localesRegistryLocalesItemNativeName value))], [("englishName", toJSON (localesRegistryLocalesItemEnglishName value))]]))
