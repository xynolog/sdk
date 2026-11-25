-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ResourceDescriptor (ResourceDescriptor (..), ResourceDescriptorContext (..), ResourceDescriptorContextItem (..), ResourceDescriptorContextItemObject (..), ResourceDescriptorContextObject (..), ResourceDescriptorIdentifier (..), ResourceDescriptorIdentifierObject (..), ResourceDescriptorRepresentations (..), ResourceDescriptorWasDerivedFrom (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.OneOrMoreAgents
import Xynolog.Internal.Generated.Models.OneOrMoreStrings
import Xynolog.Internal.Generated.Models.OneOrMoreUris
import Xynolog.Internal.Generated.Models.Representation
import Xynolog.Internal.Generated.Models.ResourceId

data ResourceDescriptor = ResourceDescriptor
  { resourceDescriptorContext :: ResourceDescriptorContext,
    resourceDescriptorId :: ResourceId,
    resourceDescriptorType :: Maybe OneOrMoreStrings,
    resourceDescriptorAbout :: Maybe OneOrMoreStrings,
    resourceDescriptorArchived :: Maybe Bool,
    resourceDescriptorAvailableFormats :: Maybe [Text],
    resourceDescriptorConformsTo :: Maybe OneOrMoreUris,
    resourceDescriptorDateCreated :: Maybe Text,
    resourceDescriptorDateModified :: Maybe Text,
    resourceDescriptorDescription :: Maybe Text,
    resourceDescriptorEntityTypes :: Maybe [Text],
    resourceDescriptorGenerator :: Maybe OneOrMoreAgents,
    resourceDescriptorHasPart :: Maybe [Text],
    resourceDescriptorIdentifier :: Maybe ResourceDescriptorIdentifier,
    resourceDescriptorIsDraft :: Maybe Bool,
    resourceDescriptorIsPartOf :: Maybe [Text],
    resourceDescriptorLicense :: Maybe Text,
    resourceDescriptorName :: Text,
    resourceDescriptorOriginatedFrom :: Maybe Text,
    resourceDescriptorRepresentations :: ResourceDescriptorRepresentations,
    resourceDescriptorSameAs :: Maybe [Text],
    resourceDescriptorSourceAnnotationId :: Maybe AnnotationId,
    resourceDescriptorSourceResourceId :: Maybe ResourceId,
    resourceDescriptorVersion :: Maybe Text,
    resourceDescriptorWasAttributedTo :: Maybe OneOrMoreAgents,
    resourceDescriptorWasDerivedFrom :: Maybe ResourceDescriptorWasDerivedFrom,
    resourceDescriptorAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ResourceDescriptor where parseJSON = checked "ResourceDescriptor" $ withObject "ResourceDescriptor" (\fields -> ResourceDescriptor <$> (fields .: "@context") <*> (fields .: "@id") <*> optional fields "@type" <*> optional fields "about" <*> optional fields "archived" <*> optional fields "availableFormats" <*> optional fields "conformsTo" <*> optional fields "dateCreated" <*> optional fields "dateModified" <*> optional fields "description" <*> optional fields "entityTypes" <*> optional fields "generator" <*> optional fields "hasPart" <*> optional fields "identifier" <*> optional fields "isDraft" <*> optional fields "isPartOf" <*> optional fields "license" <*> (fields .: "name") <*> optional fields "originatedFrom" <*> (fields .: "representations") <*> optional fields "sameAs" <*> optional fields "sourceAnnotationId" <*> optional fields "sourceResourceId" <*> optional fields "version" <*> optional fields "wasAttributedTo" <*> optional fields "wasDerivedFrom" <*> traverse parseJSON (withoutFields ["@context", "@id", "@type", "about", "archived", "availableFormats", "conformsTo", "dateCreated", "dateModified", "description", "entityTypes", "generator", "hasPart", "identifier", "isDraft", "isPartOf", "license", "name", "originatedFrom", "representations", "sameAs", "sourceAnnotationId", "sourceResourceId", "version", "wasAttributedTo", "wasDerivedFrom"] fields))

instance ToJSON ResourceDescriptor where toJSON value = Object (KM.fromList (concat [[("@context", toJSON (resourceDescriptorContext value))], [("@id", toJSON (resourceDescriptorId value))], optionalPair "@type" (resourceDescriptorType value), optionalPair "about" (resourceDescriptorAbout value), optionalPair "archived" (resourceDescriptorArchived value), optionalPair "availableFormats" (resourceDescriptorAvailableFormats value), optionalPair "conformsTo" (resourceDescriptorConformsTo value), optionalPair "dateCreated" (resourceDescriptorDateCreated value), optionalPair "dateModified" (resourceDescriptorDateModified value), optionalPair "description" (resourceDescriptorDescription value), optionalPair "entityTypes" (resourceDescriptorEntityTypes value), optionalPair "generator" (resourceDescriptorGenerator value), optionalPair "hasPart" (resourceDescriptorHasPart value), optionalPair "identifier" (resourceDescriptorIdentifier value), optionalPair "isDraft" (resourceDescriptorIsDraft value), optionalPair "isPartOf" (resourceDescriptorIsPartOf value), optionalPair "license" (resourceDescriptorLicense value), [("name", toJSON (resourceDescriptorName value))], optionalPair "originatedFrom" (resourceDescriptorOriginatedFrom value), [("representations", toJSON (resourceDescriptorRepresentations value))], optionalPair "sameAs" (resourceDescriptorSameAs value), optionalPair "sourceAnnotationId" (resourceDescriptorSourceAnnotationId value), optionalPair "sourceResourceId" (resourceDescriptorSourceResourceId value), optionalPair "version" (resourceDescriptorVersion value), optionalPair "wasAttributedTo" (resourceDescriptorWasAttributedTo value), optionalPair "wasDerivedFrom" (resourceDescriptorWasDerivedFrom value)]) <> fmap toJSON (withoutFields ["@context", "@id", "@type", "about", "archived", "availableFormats", "conformsTo", "dateCreated", "dateModified", "description", "entityTypes", "generator", "hasPart", "identifier", "isDraft", "isPartOf", "license", "name", "originatedFrom", "representations", "sameAs", "sourceAnnotationId", "sourceResourceId", "version", "wasAttributedTo", "wasDerivedFrom"] (resourceDescriptorAdditionalProperties value)))

data ResourceDescriptorContext = ResourceDescriptorContextText Text | ResourceDescriptorContextObject ResourceDescriptorContextObject | ResourceDescriptorContextList [ResourceDescriptorContextItem] deriving (Eq, Show)

instance FromJSON ResourceDescriptorContext where parseJSON = checked "ResourceDescriptorContext" $ \value -> (ResourceDescriptorContextText <$> parseJSON value) <|> (ResourceDescriptorContextObject <$> parseJSON value) <|> (ResourceDescriptorContextList <$> parseJSON value)

instance ToJSON ResourceDescriptorContext where
  toJSON (ResourceDescriptorContextText value) = toJSON value
  toJSON (ResourceDescriptorContextObject value) = toJSON value
  toJSON (ResourceDescriptorContextList value) = toJSON value

data ResourceDescriptorContextItem = ResourceDescriptorContextItemText Text | ResourceDescriptorContextItemObject ResourceDescriptorContextItemObject deriving (Eq, Show)

instance FromJSON ResourceDescriptorContextItem where parseJSON = checked "ResourceDescriptorContextItem" $ \value -> (ResourceDescriptorContextItemText <$> parseJSON value) <|> (ResourceDescriptorContextItemObject <$> parseJSON value)

instance ToJSON ResourceDescriptorContextItem where
  toJSON (ResourceDescriptorContextItemText value) = toJSON value
  toJSON (ResourceDescriptorContextItemObject value) = toJSON value

data ResourceDescriptorContextItemObject = MkResourceDescriptorContextItemObject
  { resourceDescriptorContextItemObjectAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ResourceDescriptorContextItemObject where parseJSON = checked "ResourceDescriptorContextItemObject" $ withObject "ResourceDescriptorContextItemObject" (\fields -> MkResourceDescriptorContextItemObject <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ResourceDescriptorContextItemObject where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (resourceDescriptorContextItemObjectAdditionalProperties value)))

data ResourceDescriptorContextObject = MkResourceDescriptorContextObject
  { resourceDescriptorContextObjectAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ResourceDescriptorContextObject where parseJSON = checked "ResourceDescriptorContextObject" $ withObject "ResourceDescriptorContextObject" (\fields -> MkResourceDescriptorContextObject <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ResourceDescriptorContextObject where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (resourceDescriptorContextObjectAdditionalProperties value)))

data ResourceDescriptorIdentifier = ResourceDescriptorIdentifierText Text | ResourceDescriptorIdentifierList [Text] | ResourceDescriptorIdentifierObject ResourceDescriptorIdentifierObject deriving (Eq, Show)

instance FromJSON ResourceDescriptorIdentifier where parseJSON = checked "ResourceDescriptorIdentifier" $ \value -> (ResourceDescriptorIdentifierText <$> parseJSON value) <|> (ResourceDescriptorIdentifierList <$> parseJSON value) <|> (ResourceDescriptorIdentifierObject <$> parseJSON value)

instance ToJSON ResourceDescriptorIdentifier where
  toJSON (ResourceDescriptorIdentifierText value) = toJSON value
  toJSON (ResourceDescriptorIdentifierList value) = toJSON value
  toJSON (ResourceDescriptorIdentifierObject value) = toJSON value

data ResourceDescriptorIdentifierObject = MkResourceDescriptorIdentifierObject
  { resourceDescriptorIdentifierObjectId :: Maybe Text,
    resourceDescriptorIdentifierObjectScheme :: Maybe Text,
    resourceDescriptorIdentifierObjectValue :: Maybe Text,
    resourceDescriptorIdentifierObjectAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ResourceDescriptorIdentifierObject where parseJSON = checked "ResourceDescriptorIdentifierObject" $ withObject "ResourceDescriptorIdentifierObject" (\fields -> MkResourceDescriptorIdentifierObject <$> optional fields "@id" <*> optional fields "scheme" <*> optional fields "value" <*> traverse parseJSON (withoutFields ["@id", "scheme", "value"] fields))

instance ToJSON ResourceDescriptorIdentifierObject where toJSON value = Object (KM.fromList (concat [optionalPair "@id" (resourceDescriptorIdentifierObjectId value), optionalPair "scheme" (resourceDescriptorIdentifierObjectScheme value), optionalPair "value" (resourceDescriptorIdentifierObjectValue value)]) <> fmap toJSON (withoutFields ["@id", "scheme", "value"] (resourceDescriptorIdentifierObjectAdditionalProperties value)))

data ResourceDescriptorRepresentations = ResourceDescriptorRepresentationsRepresentation Representation | ResourceDescriptorRepresentationsList [Representation] deriving (Eq, Show)

instance FromJSON ResourceDescriptorRepresentations where parseJSON = checked "ResourceDescriptorRepresentations" $ \value -> (ResourceDescriptorRepresentationsRepresentation <$> parseJSON value) <|> (ResourceDescriptorRepresentationsList <$> parseJSON value)

instance ToJSON ResourceDescriptorRepresentations where
  toJSON (ResourceDescriptorRepresentationsRepresentation value) = toJSON value
  toJSON (ResourceDescriptorRepresentationsList value) = toJSON value

data ResourceDescriptorWasDerivedFrom = ResourceDescriptorWasDerivedFromResourceId ResourceId | ResourceDescriptorWasDerivedFromList [ResourceId] deriving (Eq, Show)

instance FromJSON ResourceDescriptorWasDerivedFrom where parseJSON = checked "ResourceDescriptorWasDerivedFrom" $ \value -> (ResourceDescriptorWasDerivedFromResourceId <$> parseJSON value) <|> (ResourceDescriptorWasDerivedFromList <$> parseJSON value)

instance ToJSON ResourceDescriptorWasDerivedFrom where
  toJSON (ResourceDescriptorWasDerivedFromResourceId value) = toJSON value
  toJSON (ResourceDescriptorWasDerivedFromList value) = toJSON value
