-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ResourceDescriptor (ResourceDescriptor (..), ResourceDescriptorIdentifier (..), ResourceDescriptorIdentifierObjectValue (..), ResourceDescriptorRepresentations (..), ResourceDescriptorU40_context (..), ResourceDescriptorU40_contextListValueItem (..), ResourceDescriptorU40_contextListValueItemObjectValue (..), ResourceDescriptorU40_contextObjectValue (..), ResourceDescriptorWasDerivedFrom (..)) where

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
  { resourceDescriptorU40_context :: ResourceDescriptorU40_context,
    resourceDescriptorU40_id :: ResourceId,
    resourceDescriptorU40_type :: Maybe OneOrMoreStrings,
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

instance ToJSON ResourceDescriptor where toJSON value = Object (KM.fromList (concat [[("@context", toJSON (resourceDescriptorU40_context value))], [("@id", toJSON (resourceDescriptorU40_id value))], optionalPair "@type" (resourceDescriptorU40_type value), optionalPair "about" (resourceDescriptorAbout value), optionalPair "archived" (resourceDescriptorArchived value), optionalPair "availableFormats" (resourceDescriptorAvailableFormats value), optionalPair "conformsTo" (resourceDescriptorConformsTo value), optionalPair "dateCreated" (resourceDescriptorDateCreated value), optionalPair "dateModified" (resourceDescriptorDateModified value), optionalPair "description" (resourceDescriptorDescription value), optionalPair "entityTypes" (resourceDescriptorEntityTypes value), optionalPair "generator" (resourceDescriptorGenerator value), optionalPair "hasPart" (resourceDescriptorHasPart value), optionalPair "identifier" (resourceDescriptorIdentifier value), optionalPair "isDraft" (resourceDescriptorIsDraft value), optionalPair "isPartOf" (resourceDescriptorIsPartOf value), optionalPair "license" (resourceDescriptorLicense value), [("name", toJSON (resourceDescriptorName value))], optionalPair "originatedFrom" (resourceDescriptorOriginatedFrom value), [("representations", toJSON (resourceDescriptorRepresentations value))], optionalPair "sameAs" (resourceDescriptorSameAs value), optionalPair "sourceAnnotationId" (resourceDescriptorSourceAnnotationId value), optionalPair "sourceResourceId" (resourceDescriptorSourceResourceId value), optionalPair "version" (resourceDescriptorVersion value), optionalPair "wasAttributedTo" (resourceDescriptorWasAttributedTo value), optionalPair "wasDerivedFrom" (resourceDescriptorWasDerivedFrom value)]) <> fmap toJSON (withoutFields ["@context", "@id", "@type", "about", "archived", "availableFormats", "conformsTo", "dateCreated", "dateModified", "description", "entityTypes", "generator", "hasPart", "identifier", "isDraft", "isPartOf", "license", "name", "originatedFrom", "representations", "sameAs", "sourceAnnotationId", "sourceResourceId", "version", "wasAttributedTo", "wasDerivedFrom"] (resourceDescriptorAdditionalProperties value)))

data ResourceDescriptorIdentifier = ResourceDescriptorIdentifierText Text | ResourceDescriptorIdentifierList [Text] | ResourceDescriptorIdentifierObject ResourceDescriptorIdentifierObjectValue deriving (Eq, Show)

instance FromJSON ResourceDescriptorIdentifier where parseJSON = checked "ResourceDescriptorIdentifier" $ \value -> (ResourceDescriptorIdentifierText <$> parseJSON value) <|> (ResourceDescriptorIdentifierList <$> parseJSON value) <|> (ResourceDescriptorIdentifierObject <$> parseJSON value)

instance ToJSON ResourceDescriptorIdentifier where
  toJSON (ResourceDescriptorIdentifierText value) = toJSON value
  toJSON (ResourceDescriptorIdentifierList value) = toJSON value
  toJSON (ResourceDescriptorIdentifierObject value) = toJSON value

data ResourceDescriptorIdentifierObjectValue = ResourceDescriptorIdentifierObjectValue
  { resourceDescriptorIdentifierObjectValueU40_id :: Maybe Text,
    resourceDescriptorIdentifierObjectValueScheme :: Maybe Text,
    resourceDescriptorIdentifierObjectValueValue :: Maybe Text,
    resourceDescriptorIdentifierObjectValueAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ResourceDescriptorIdentifierObjectValue where parseJSON = checked "ResourceDescriptorIdentifierObjectValue" $ withObject "ResourceDescriptorIdentifierObjectValue" (\fields -> ResourceDescriptorIdentifierObjectValue <$> optional fields "@id" <*> optional fields "scheme" <*> optional fields "value" <*> traverse parseJSON (withoutFields ["@id", "scheme", "value"] fields))

instance ToJSON ResourceDescriptorIdentifierObjectValue where toJSON value = Object (KM.fromList (concat [optionalPair "@id" (resourceDescriptorIdentifierObjectValueU40_id value), optionalPair "scheme" (resourceDescriptorIdentifierObjectValueScheme value), optionalPair "value" (resourceDescriptorIdentifierObjectValueValue value)]) <> fmap toJSON (withoutFields ["@id", "scheme", "value"] (resourceDescriptorIdentifierObjectValueAdditionalProperties value)))

data ResourceDescriptorRepresentations = ResourceDescriptorRepresentationsRepresentation Representation | ResourceDescriptorRepresentationsList [Representation] deriving (Eq, Show)

instance FromJSON ResourceDescriptorRepresentations where parseJSON = checked "ResourceDescriptorRepresentations" $ \value -> (ResourceDescriptorRepresentationsRepresentation <$> parseJSON value) <|> (ResourceDescriptorRepresentationsList <$> parseJSON value)

instance ToJSON ResourceDescriptorRepresentations where
  toJSON (ResourceDescriptorRepresentationsRepresentation value) = toJSON value
  toJSON (ResourceDescriptorRepresentationsList value) = toJSON value

data ResourceDescriptorU40_context = ResourceDescriptorU40_contextText Text | ResourceDescriptorU40_contextObject ResourceDescriptorU40_contextObjectValue | ResourceDescriptorU40_contextList [ResourceDescriptorU40_contextListValueItem] deriving (Eq, Show)

instance FromJSON ResourceDescriptorU40_context where parseJSON = checked "ResourceDescriptorU40_context" $ \value -> (ResourceDescriptorU40_contextText <$> parseJSON value) <|> (ResourceDescriptorU40_contextObject <$> parseJSON value) <|> (ResourceDescriptorU40_contextList <$> parseJSON value)

instance ToJSON ResourceDescriptorU40_context where
  toJSON (ResourceDescriptorU40_contextText value) = toJSON value
  toJSON (ResourceDescriptorU40_contextObject value) = toJSON value
  toJSON (ResourceDescriptorU40_contextList value) = toJSON value

data ResourceDescriptorU40_contextListValueItem = ResourceDescriptorU40_contextListValueItemText Text | ResourceDescriptorU40_contextListValueItemObject ResourceDescriptorU40_contextListValueItemObjectValue deriving (Eq, Show)

instance FromJSON ResourceDescriptorU40_contextListValueItem where parseJSON = checked "ResourceDescriptorU40_contextListValueItem" $ \value -> (ResourceDescriptorU40_contextListValueItemText <$> parseJSON value) <|> (ResourceDescriptorU40_contextListValueItemObject <$> parseJSON value)

instance ToJSON ResourceDescriptorU40_contextListValueItem where
  toJSON (ResourceDescriptorU40_contextListValueItemText value) = toJSON value
  toJSON (ResourceDescriptorU40_contextListValueItemObject value) = toJSON value

data ResourceDescriptorU40_contextListValueItemObjectValue = ResourceDescriptorU40_contextListValueItemObjectValue
  { resourceDescriptorU40_contextListValueItemObjectValueAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ResourceDescriptorU40_contextListValueItemObjectValue where parseJSON = checked "ResourceDescriptorU40_contextListValueItemObjectValue" $ withObject "ResourceDescriptorU40_contextListValueItemObjectValue" (\fields -> ResourceDescriptorU40_contextListValueItemObjectValue <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ResourceDescriptorU40_contextListValueItemObjectValue where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (resourceDescriptorU40_contextListValueItemObjectValueAdditionalProperties value)))

data ResourceDescriptorU40_contextObjectValue = ResourceDescriptorU40_contextObjectValue
  { resourceDescriptorU40_contextObjectValueAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ResourceDescriptorU40_contextObjectValue where parseJSON = checked "ResourceDescriptorU40_contextObjectValue" $ withObject "ResourceDescriptorU40_contextObjectValue" (\fields -> ResourceDescriptorU40_contextObjectValue <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ResourceDescriptorU40_contextObjectValue where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (resourceDescriptorU40_contextObjectValueAdditionalProperties value)))

data ResourceDescriptorWasDerivedFrom = ResourceDescriptorWasDerivedFromResourceId ResourceId | ResourceDescriptorWasDerivedFromList [ResourceId] deriving (Eq, Show)

instance FromJSON ResourceDescriptorWasDerivedFrom where parseJSON = checked "ResourceDescriptorWasDerivedFrom" $ \value -> (ResourceDescriptorWasDerivedFromResourceId <$> parseJSON value) <|> (ResourceDescriptorWasDerivedFromList <$> parseJSON value)

instance ToJSON ResourceDescriptorWasDerivedFrom where
  toJSON (ResourceDescriptorWasDerivedFromResourceId value) = toJSON value
  toJSON (ResourceDescriptorWasDerivedFromList value) = toJSON value
