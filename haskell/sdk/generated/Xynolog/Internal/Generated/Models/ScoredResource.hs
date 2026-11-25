-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ScoredResource (ScoredResource (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.OneOrMoreAgents
import Xynolog.Internal.Generated.Models.OneOrMoreStrings
import Xynolog.Internal.Generated.Models.OneOrMoreUris
import Xynolog.Internal.Generated.Models.ResourceDescriptor
import Xynolog.Internal.Generated.Models.ResourceId

data ScoredResource = ScoredResource
  { scoredResourceContext :: ResourceDescriptorContext,
    scoredResourceId :: ResourceId,
    scoredResourceType :: Maybe OneOrMoreStrings,
    scoredResourceName :: Text,
    scoredResourceDescription :: Maybe Text,
    scoredResourceIdentifier :: Maybe ResourceDescriptorIdentifier,
    scoredResourceAbout :: Maybe OneOrMoreStrings,
    scoredResourceSameAs :: Maybe [Text],
    scoredResourceIsPartOf :: Maybe [Text],
    scoredResourceHasPart :: Maybe [Text],
    scoredResourceLicense :: Maybe Text,
    scoredResourceVersion :: Maybe Text,
    scoredResourceDateCreated :: Maybe Text,
    scoredResourceDateModified :: Maybe Text,
    scoredResourceWasDerivedFrom :: Maybe ResourceDescriptorWasDerivedFrom,
    scoredResourceWasAttributedTo :: Maybe OneOrMoreAgents,
    scoredResourceGenerator :: Maybe OneOrMoreAgents,
    scoredResourceConformsTo :: Maybe OneOrMoreUris,
    scoredResourceAvailableFormats :: Maybe [Text],
    scoredResourceRepresentations :: ResourceDescriptorRepresentations,
    scoredResourceArchived :: Maybe Bool,
    scoredResourceEntityTypes :: Maybe [Text],
    scoredResourceIsDraft :: Maybe Bool,
    scoredResourceSourceAnnotationId :: Maybe AnnotationId,
    scoredResourceSourceResourceId :: Maybe ResourceId,
    scoredResourceOriginatedFrom :: Maybe Text,
    scoredResourceScore :: Maybe Scientific,
    scoredResourceMatchReason :: Maybe Text,
    scoredResourceAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ScoredResource where parseJSON = checked "ScoredResource" $ withObject "ScoredResource" (\fields -> ScoredResource <$> (fields .: "@context") <*> (fields .: "@id") <*> optional fields "@type" <*> (fields .: "name") <*> optional fields "description" <*> optional fields "identifier" <*> optional fields "about" <*> optional fields "sameAs" <*> optional fields "isPartOf" <*> optional fields "hasPart" <*> optional fields "license" <*> optional fields "version" <*> optional fields "dateCreated" <*> optional fields "dateModified" <*> optional fields "wasDerivedFrom" <*> optional fields "wasAttributedTo" <*> optional fields "generator" <*> optional fields "conformsTo" <*> optional fields "availableFormats" <*> (fields .: "representations") <*> optional fields "archived" <*> optional fields "entityTypes" <*> optional fields "isDraft" <*> optional fields "sourceAnnotationId" <*> optional fields "sourceResourceId" <*> optional fields "originatedFrom" <*> optional fields "score" <*> optional fields "matchReason" <*> traverse parseJSON (withoutFields ["@context", "@id", "@type", "name", "description", "identifier", "about", "sameAs", "isPartOf", "hasPart", "license", "version", "dateCreated", "dateModified", "wasDerivedFrom", "wasAttributedTo", "generator", "conformsTo", "availableFormats", "representations", "archived", "entityTypes", "isDraft", "sourceAnnotationId", "sourceResourceId", "originatedFrom", "score", "matchReason"] fields))

instance ToJSON ScoredResource where toJSON value = Object (KM.fromList (concat [[("@context", toJSON (scoredResourceContext value))], [("@id", toJSON (scoredResourceId value))], optionalPair "@type" (scoredResourceType value), [("name", toJSON (scoredResourceName value))], optionalPair "description" (scoredResourceDescription value), optionalPair "identifier" (scoredResourceIdentifier value), optionalPair "about" (scoredResourceAbout value), optionalPair "sameAs" (scoredResourceSameAs value), optionalPair "isPartOf" (scoredResourceIsPartOf value), optionalPair "hasPart" (scoredResourceHasPart value), optionalPair "license" (scoredResourceLicense value), optionalPair "version" (scoredResourceVersion value), optionalPair "dateCreated" (scoredResourceDateCreated value), optionalPair "dateModified" (scoredResourceDateModified value), optionalPair "wasDerivedFrom" (scoredResourceWasDerivedFrom value), optionalPair "wasAttributedTo" (scoredResourceWasAttributedTo value), optionalPair "generator" (scoredResourceGenerator value), optionalPair "conformsTo" (scoredResourceConformsTo value), optionalPair "availableFormats" (scoredResourceAvailableFormats value), [("representations", toJSON (scoredResourceRepresentations value))], optionalPair "archived" (scoredResourceArchived value), optionalPair "entityTypes" (scoredResourceEntityTypes value), optionalPair "isDraft" (scoredResourceIsDraft value), optionalPair "sourceAnnotationId" (scoredResourceSourceAnnotationId value), optionalPair "sourceResourceId" (scoredResourceSourceResourceId value), optionalPair "originatedFrom" (scoredResourceOriginatedFrom value), optionalPair "score" (scoredResourceScore value), optionalPair "matchReason" (scoredResourceMatchReason value)]) <> fmap toJSON (withoutFields ["@context", "@id", "@type", "name", "description", "identifier", "about", "sameAs", "isPartOf", "hasPart", "license", "version", "dateCreated", "dateModified", "wasDerivedFrom", "wasAttributedTo", "generator", "conformsTo", "availableFormats", "representations", "archived", "entityTypes", "isDraft", "sourceAnnotationId", "sourceResourceId", "originatedFrom", "score", "matchReason"] (scoredResourceAdditionalProperties value)))
