-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MediaTypesRegistry (MediaTypesRegistry (..), MediaTypesRegistryExtensionAliases (..), MediaTypesRegistryMediaTypesItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.SupportedMediaType

data MediaTypesRegistry = MediaTypesRegistry
  { mediaTypesRegistryComment :: Text,
    mediaTypesRegistryRender :: [Text],
    mediaTypesRegistryAnchoring :: [Text],
    mediaTypesRegistryTextSource :: [Text],
    mediaTypesRegistryExtensionAliases :: MediaTypesRegistryExtensionAliases,
    mediaTypesRegistryMediaTypes :: [MediaTypesRegistryMediaTypesItem]
  }
  deriving (Eq, Show)

instance FromJSON MediaTypesRegistry where parseJSON = checked "MediaTypesRegistry" $ withObject "MediaTypesRegistry" (\fields -> MediaTypesRegistry <$> (fields .: "$comment") <*> (fields .: "render") <*> (fields .: "anchoring") <*> (fields .: "textSource") <*> (fields .: "extensionAliases") <*> (fields .: "mediaTypes"))

instance ToJSON MediaTypesRegistry where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (mediaTypesRegistryComment value))], [("render", toJSON (mediaTypesRegistryRender value))], [("anchoring", toJSON (mediaTypesRegistryAnchoring value))], [("textSource", toJSON (mediaTypesRegistryTextSource value))], [("extensionAliases", toJSON (mediaTypesRegistryExtensionAliases value))], [("mediaTypes", toJSON (mediaTypesRegistryMediaTypes value))]]))

data MediaTypesRegistryExtensionAliases = MediaTypesRegistryExtensionAliases
  { mediaTypesRegistryExtensionAliasesAdditionalProperties :: KM.KeyMap Text
  }
  deriving (Eq, Show)

instance FromJSON MediaTypesRegistryExtensionAliases where parseJSON = checked "MediaTypesRegistryExtensionAliases" $ withObject "MediaTypesRegistryExtensionAliases" (\fields -> MediaTypesRegistryExtensionAliases <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON MediaTypesRegistryExtensionAliases where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (mediaTypesRegistryExtensionAliasesAdditionalProperties value)))

data MediaTypesRegistryMediaTypesItem = MediaTypesRegistryMediaTypesItem
  { mediaTypesRegistryMediaTypesItemMediaType :: SupportedMediaType,
    mediaTypesRegistryMediaTypesItemExtension :: Text,
    mediaTypesRegistryMediaTypesItemLabel :: Text,
    mediaTypesRegistryMediaTypesItemRender :: Text,
    mediaTypesRegistryMediaTypesItemAnchoring :: Text,
    mediaTypesRegistryMediaTypesItemTextSource :: Text,
    mediaTypesRegistryMediaTypesItemAuthorable :: Bool,
    mediaTypesRegistryMediaTypesItemUploadable :: Bool,
    mediaTypesRegistryMediaTypesItemGeneratable :: Bool
  }
  deriving (Eq, Show)

instance FromJSON MediaTypesRegistryMediaTypesItem where parseJSON = checked "MediaTypesRegistryMediaTypesItem" $ withObject "MediaTypesRegistryMediaTypesItem" (\fields -> MediaTypesRegistryMediaTypesItem <$> (fields .: "mediaType") <*> (fields .: "extension") <*> (fields .: "label") <*> (fields .: "render") <*> (fields .: "anchoring") <*> (fields .: "textSource") <*> (fields .: "authorable") <*> (fields .: "uploadable") <*> (fields .: "generatable"))

instance ToJSON MediaTypesRegistryMediaTypesItem where toJSON value = Object (KM.fromList (concat [[("mediaType", toJSON (mediaTypesRegistryMediaTypesItemMediaType value))], [("extension", toJSON (mediaTypesRegistryMediaTypesItemExtension value))], [("label", toJSON (mediaTypesRegistryMediaTypesItemLabel value))], [("render", toJSON (mediaTypesRegistryMediaTypesItemRender value))], [("anchoring", toJSON (mediaTypesRegistryMediaTypesItemAnchoring value))], [("textSource", toJSON (mediaTypesRegistryMediaTypesItemTextSource value))], [("authorable", toJSON (mediaTypesRegistryMediaTypesItemAuthorable value))], [("uploadable", toJSON (mediaTypesRegistryMediaTypesItemUploadable value))], [("generatable", toJSON (mediaTypesRegistryMediaTypesItemGeneratable value))]]))
