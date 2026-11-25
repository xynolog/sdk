-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.Representation (Representation (..), RepresentationRel (..), representationRelText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Scientific (Scientific)
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.OneOrMoreStrings
import Xynolog.Internal.Generated.Models.OneOrMoreUris

data Representation = Representation
  { representationId :: Maybe Text,
    representationType :: Maybe OneOrMoreStrings,
    representationByteSize :: Maybe Integer,
    representationChecksum :: Maybe Text,
    representationConformsTo :: Maybe OneOrMoreUris,
    representationCreated :: Maybe Text,
    representationDuration :: Maybe Scientific,
    representationEncoding :: Maybe Text,
    representationFilename :: Maybe Text,
    representationHeight :: Maybe Integer,
    representationLanguage :: Maybe Text,
    representationMediaType :: Text,
    representationModified :: Maybe Text,
    representationRel :: Maybe RepresentationRel,
    representationStorageUri :: Maybe Text,
    representationTags :: Maybe [Text],
    representationWidth :: Maybe Integer,
    representationAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON Representation where parseJSON = checked "Representation" $ withObject "Representation" (\fields -> Representation <$> optional fields "@id" <*> optional fields "@type" <*> optional fields "byteSize" <*> optional fields "checksum" <*> optional fields "conformsTo" <*> optional fields "created" <*> optional fields "duration" <*> optional fields "encoding" <*> optional fields "filename" <*> optional fields "height" <*> optional fields "language" <*> (fields .: "mediaType") <*> optional fields "modified" <*> optional fields "rel" <*> optional fields "storageUri" <*> optional fields "tags" <*> optional fields "width" <*> traverse parseJSON (withoutFields ["@id", "@type", "byteSize", "checksum", "conformsTo", "created", "duration", "encoding", "filename", "height", "language", "mediaType", "modified", "rel", "storageUri", "tags", "width"] fields))

instance ToJSON Representation where toJSON value = Object (KM.fromList (concat [optionalPair "@id" (representationId value), optionalPair "@type" (representationType value), optionalPair "byteSize" (representationByteSize value), optionalPair "checksum" (representationChecksum value), optionalPair "conformsTo" (representationConformsTo value), optionalPair "created" (representationCreated value), optionalPair "duration" (representationDuration value), optionalPair "encoding" (representationEncoding value), optionalPair "filename" (representationFilename value), optionalPair "height" (representationHeight value), optionalPair "language" (representationLanguage value), [("mediaType", toJSON (representationMediaType value))], optionalPair "modified" (representationModified value), optionalPair "rel" (representationRel value), optionalPair "storageUri" (representationStorageUri value), optionalPair "tags" (representationTags value), optionalPair "width" (representationWidth value)]) <> fmap toJSON (withoutFields ["@id", "@type", "byteSize", "checksum", "conformsTo", "created", "duration", "encoding", "filename", "height", "language", "mediaType", "modified", "rel", "storageUri", "tags", "width"] (representationAdditionalProperties value)))

data RepresentationRel = RepresentationRelOriginal | RepresentationRelThumbnail | RepresentationRelPreview | RepresentationRelOptimized | RepresentationRelDerived | RepresentationRelOther deriving (Eq, Show)

instance FromJSON RepresentationRel where parseJSON = checked "RepresentationRel" $ \value -> if value == String "original" then pure RepresentationRelOriginal else if value == String "thumbnail" then pure RepresentationRelThumbnail else if value == String "preview" then pure RepresentationRelPreview else if value == String "optimized" then pure RepresentationRelOptimized else if value == String "derived" then pure RepresentationRelDerived else if value == String "other" then pure RepresentationRelOther else fail "unknown enumeration member"

instance ToJSON RepresentationRel where
  toJSON RepresentationRelOriginal = String "original"
  toJSON RepresentationRelThumbnail = String "thumbnail"
  toJSON RepresentationRelPreview = String "preview"
  toJSON RepresentationRelOptimized = String "optimized"
  toJSON RepresentationRelDerived = String "derived"
  toJSON RepresentationRelOther = String "other"

representationRelText :: RepresentationRel -> Text
representationRelText RepresentationRelOriginal = "original"
representationRelText RepresentationRelThumbnail = "thumbnail"
representationRelText RepresentationRelPreview = "preview"
representationRelText RepresentationRelOptimized = "optimized"
representationRelText RepresentationRelDerived = "derived"
representationRelText RepresentationRelOther = "other"
