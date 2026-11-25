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
    scoredResourceAbout :: Maybe OneOrMoreStrings,
    scoredResourceArchived :: Maybe Bool,
    scoredResourceAvailableFormats :: Maybe [Text],
    scoredResourceConformsTo :: Maybe OneOrMoreUris,
    scoredResourceDateCreated :: Maybe Text,
    scoredResourceDateModified :: Maybe Text,
    scoredResourceDescription :: Maybe Text,
    scoredResourceEntityTypes :: Maybe [Text],
    scoredResourceGenerator :: Maybe OneOrMoreAgents,
    scoredResourceHasPart :: Maybe [Text],
    scoredResourceIdentifier :: Maybe ResourceDescriptorIdentifier,
    scoredResourceIsDraft :: Maybe Bool,
    scoredResourceIsPartOf :: Maybe [Text],
    scoredResourceLicense :: Maybe Text,
    scoredResourceMatchReason :: Maybe Text,
    scoredResourceName :: Text,
    scoredResourceOriginatedFrom :: Maybe Text,
    scoredResourceRepresentations :: ResourceDescriptorRepresentations,
    scoredResourceSameAs :: Maybe [Text],
    scoredResourceScore :: Maybe Scientific,
    scoredResourceSourceAnnotationId :: Maybe AnnotationId,
    scoredResourceSourceResourceId :: Maybe ResourceId,
    scoredResourceVersion :: Maybe Text,
    scoredResourceWasAttributedTo :: Maybe OneOrMoreAgents,
    scoredResourceWasDerivedFrom :: Maybe ResourceDescriptorWasDerivedFrom,
    scoredResourceAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ScoredResource where parseJSON = checked "ScoredResource" $ withObject "ScoredResource" (\fields -> ScoredResource <$> (fields .: "@context") <*> (fields .: "@id") <*> optional fields "@type" <*> optional fields "about" <*> optional fields "archived" <*> optional fields "availableFormats" <*> optional fields "conformsTo" <*> optional fields "dateCreated" <*> optional fields "dateModified" <*> optional fields "description" <*> optional fields "entityTypes" <*> optional fields "generator" <*> optional fields "hasPart" <*> optional fields "identifier" <*> optional fields "isDraft" <*> optional fields "isPartOf" <*> optional fields "license" <*> optional fields "matchReason" <*> (fields .: "name") <*> optional fields "originatedFrom" <*> (fields .: "representations") <*> optional fields "sameAs" <*> optional fields "score" <*> optional fields "sourceAnnotationId" <*> optional fields "sourceResourceId" <*> optional fields "version" <*> optional fields "wasAttributedTo" <*> optional fields "wasDerivedFrom" <*> traverse parseJSON (withoutFields ["@context", "@id", "@type", "about", "archived", "availableFormats", "conformsTo", "dateCreated", "dateModified", "description", "entityTypes", "generator", "hasPart", "identifier", "isDraft", "isPartOf", "license", "matchReason", "name", "originatedFrom", "representations", "sameAs", "score", "sourceAnnotationId", "sourceResourceId", "version", "wasAttributedTo", "wasDerivedFrom"] fields))

instance ToJSON ScoredResource where toJSON value = Object (KM.fromList (concat [[("@context", toJSON (scoredResourceContext value))], [("@id", toJSON (scoredResourceId value))], optionalPair "@type" (scoredResourceType value), optionalPair "about" (scoredResourceAbout value), optionalPair "archived" (scoredResourceArchived value), optionalPair "availableFormats" (scoredResourceAvailableFormats value), optionalPair "conformsTo" (scoredResourceConformsTo value), optionalPair "dateCreated" (scoredResourceDateCreated value), optionalPair "dateModified" (scoredResourceDateModified value), optionalPair "description" (scoredResourceDescription value), optionalPair "entityTypes" (scoredResourceEntityTypes value), optionalPair "generator" (scoredResourceGenerator value), optionalPair "hasPart" (scoredResourceHasPart value), optionalPair "identifier" (scoredResourceIdentifier value), optionalPair "isDraft" (scoredResourceIsDraft value), optionalPair "isPartOf" (scoredResourceIsPartOf value), optionalPair "license" (scoredResourceLicense value), optionalPair "matchReason" (scoredResourceMatchReason value), [("name", toJSON (scoredResourceName value))], optionalPair "originatedFrom" (scoredResourceOriginatedFrom value), [("representations", toJSON (scoredResourceRepresentations value))], optionalPair "sameAs" (scoredResourceSameAs value), optionalPair "score" (scoredResourceScore value), optionalPair "sourceAnnotationId" (scoredResourceSourceAnnotationId value), optionalPair "sourceResourceId" (scoredResourceSourceResourceId value), optionalPair "version" (scoredResourceVersion value), optionalPair "wasAttributedTo" (scoredResourceWasAttributedTo value), optionalPair "wasDerivedFrom" (scoredResourceWasDerivedFrom value)]) <> fmap toJSON (withoutFields ["@context", "@id", "@type", "about", "archived", "availableFormats", "conformsTo", "dateCreated", "dateModified", "description", "entityTypes", "generator", "hasPart", "identifier", "isDraft", "isPartOf", "license", "matchReason", "name", "originatedFrom", "representations", "sameAs", "score", "sourceAnnotationId", "sourceResourceId", "version", "wasAttributedTo", "wasDerivedFrom"] (scoredResourceAdditionalProperties value)))
