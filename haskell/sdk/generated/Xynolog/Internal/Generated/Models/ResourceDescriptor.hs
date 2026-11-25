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
    resourceDescriptorName :: Text,
    resourceDescriptorDescription :: Maybe Text,
    resourceDescriptorIdentifier :: Maybe ResourceDescriptorIdentifier,
    resourceDescriptorAbout :: Maybe OneOrMoreStrings,
    resourceDescriptorSameAs :: Maybe [Text],
    resourceDescriptorIsPartOf :: Maybe [Text],
    resourceDescriptorHasPart :: Maybe [Text],
    resourceDescriptorLicense :: Maybe Text,
    resourceDescriptorVersion :: Maybe Text,
    resourceDescriptorDateCreated :: Maybe Text,
    resourceDescriptorDateModified :: Maybe Text,
    resourceDescriptorWasDerivedFrom :: Maybe ResourceDescriptorWasDerivedFrom,
    resourceDescriptorWasAttributedTo :: Maybe OneOrMoreAgents,
    resourceDescriptorGenerator :: Maybe OneOrMoreAgents,
    resourceDescriptorConformsTo :: Maybe OneOrMoreUris,
    resourceDescriptorAvailableFormats :: Maybe [Text],
    resourceDescriptorRepresentations :: ResourceDescriptorRepresentations,
    resourceDescriptorArchived :: Maybe Bool,
    resourceDescriptorEntityTypes :: Maybe [Text],
    resourceDescriptorIsDraft :: Maybe Bool,
    resourceDescriptorSourceAnnotationId :: Maybe AnnotationId,
    resourceDescriptorSourceResourceId :: Maybe ResourceId,
    resourceDescriptorOriginatedFrom :: Maybe Text,
    resourceDescriptorAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ResourceDescriptor where parseJSON = checked "ResourceDescriptor" $ withObject "ResourceDescriptor" (\fields -> ResourceDescriptor <$> (fields .: "@context") <*> (fields .: "@id") <*> optional fields "@type" <*> (fields .: "name") <*> optional fields "description" <*> optional fields "identifier" <*> optional fields "about" <*> optional fields "sameAs" <*> optional fields "isPartOf" <*> optional fields "hasPart" <*> optional fields "license" <*> optional fields "version" <*> optional fields "dateCreated" <*> optional fields "dateModified" <*> optional fields "wasDerivedFrom" <*> optional fields "wasAttributedTo" <*> optional fields "generator" <*> optional fields "conformsTo" <*> optional fields "availableFormats" <*> (fields .: "representations") <*> optional fields "archived" <*> optional fields "entityTypes" <*> optional fields "isDraft" <*> optional fields "sourceAnnotationId" <*> optional fields "sourceResourceId" <*> optional fields "originatedFrom" <*> traverse parseJSON (withoutFields ["@context", "@id", "@type", "name", "description", "identifier", "about", "sameAs", "isPartOf", "hasPart", "license", "version", "dateCreated", "dateModified", "wasDerivedFrom", "wasAttributedTo", "generator", "conformsTo", "availableFormats", "representations", "archived", "entityTypes", "isDraft", "sourceAnnotationId", "sourceResourceId", "originatedFrom"] fields))

instance ToJSON ResourceDescriptor where toJSON value = Object (KM.fromList (concat [[("@context", toJSON (resourceDescriptorContext value))], [("@id", toJSON (resourceDescriptorId value))], optionalPair "@type" (resourceDescriptorType value), [("name", toJSON (resourceDescriptorName value))], optionalPair "description" (resourceDescriptorDescription value), optionalPair "identifier" (resourceDescriptorIdentifier value), optionalPair "about" (resourceDescriptorAbout value), optionalPair "sameAs" (resourceDescriptorSameAs value), optionalPair "isPartOf" (resourceDescriptorIsPartOf value), optionalPair "hasPart" (resourceDescriptorHasPart value), optionalPair "license" (resourceDescriptorLicense value), optionalPair "version" (resourceDescriptorVersion value), optionalPair "dateCreated" (resourceDescriptorDateCreated value), optionalPair "dateModified" (resourceDescriptorDateModified value), optionalPair "wasDerivedFrom" (resourceDescriptorWasDerivedFrom value), optionalPair "wasAttributedTo" (resourceDescriptorWasAttributedTo value), optionalPair "generator" (resourceDescriptorGenerator value), optionalPair "conformsTo" (resourceDescriptorConformsTo value), optionalPair "availableFormats" (resourceDescriptorAvailableFormats value), [("representations", toJSON (resourceDescriptorRepresentations value))], optionalPair "archived" (resourceDescriptorArchived value), optionalPair "entityTypes" (resourceDescriptorEntityTypes value), optionalPair "isDraft" (resourceDescriptorIsDraft value), optionalPair "sourceAnnotationId" (resourceDescriptorSourceAnnotationId value), optionalPair "sourceResourceId" (resourceDescriptorSourceResourceId value), optionalPair "originatedFrom" (resourceDescriptorOriginatedFrom value)]) <> fmap toJSON (withoutFields ["@context", "@id", "@type", "name", "description", "identifier", "about", "sameAs", "isPartOf", "hasPart", "license", "version", "dateCreated", "dateModified", "wasDerivedFrom", "wasAttributedTo", "generator", "conformsTo", "availableFormats", "representations", "archived", "entityTypes", "isDraft", "sourceAnnotationId", "sourceResourceId", "originatedFrom"] (resourceDescriptorAdditionalProperties value)))

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
    resourceDescriptorIdentifierObjectValue :: Maybe Text,
    resourceDescriptorIdentifierObjectScheme :: Maybe Text,
    resourceDescriptorIdentifierObjectAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ResourceDescriptorIdentifierObject where parseJSON = checked "ResourceDescriptorIdentifierObject" $ withObject "ResourceDescriptorIdentifierObject" (\fields -> MkResourceDescriptorIdentifierObject <$> optional fields "@id" <*> optional fields "value" <*> optional fields "scheme" <*> traverse parseJSON (withoutFields ["@id", "value", "scheme"] fields))

instance ToJSON ResourceDescriptorIdentifierObject where toJSON value = Object (KM.fromList (concat [optionalPair "@id" (resourceDescriptorIdentifierObjectId value), optionalPair "value" (resourceDescriptorIdentifierObjectValue value), optionalPair "scheme" (resourceDescriptorIdentifierObjectScheme value)]) <> fmap toJSON (withoutFields ["@id", "value", "scheme"] (resourceDescriptorIdentifierObjectAdditionalProperties value)))

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
