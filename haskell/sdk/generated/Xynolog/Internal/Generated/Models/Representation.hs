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
    representationMediaType :: Text,
    representationStorageUri :: Maybe Text,
    representationFilename :: Maybe Text,
    representationByteSize :: Maybe Integer,
    representationChecksum :: Maybe Text,
    representationEncoding :: Maybe Text,
    representationLanguage :: Maybe Text,
    representationWidth :: Maybe Integer,
    representationHeight :: Maybe Integer,
    representationDuration :: Maybe Scientific,
    representationCreated :: Maybe Text,
    representationModified :: Maybe Text,
    representationConformsTo :: Maybe OneOrMoreUris,
    representationTags :: Maybe [Text],
    representationRel :: Maybe RepresentationRel,
    representationAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON Representation where parseJSON = checked "Representation" $ withObject "Representation" (\fields -> Representation <$> optional fields "@id" <*> optional fields "@type" <*> (fields .: "mediaType") <*> optional fields "storageUri" <*> optional fields "filename" <*> optional fields "byteSize" <*> optional fields "checksum" <*> optional fields "encoding" <*> optional fields "language" <*> optional fields "width" <*> optional fields "height" <*> optional fields "duration" <*> optional fields "created" <*> optional fields "modified" <*> optional fields "conformsTo" <*> optional fields "tags" <*> optional fields "rel" <*> traverse parseJSON (withoutFields ["@id", "@type", "mediaType", "storageUri", "filename", "byteSize", "checksum", "encoding", "language", "width", "height", "duration", "created", "modified", "conformsTo", "tags", "rel"] fields))

instance ToJSON Representation where toJSON value = Object (KM.fromList (concat [optionalPair "@id" (representationId value), optionalPair "@type" (representationType value), [("mediaType", toJSON (representationMediaType value))], optionalPair "storageUri" (representationStorageUri value), optionalPair "filename" (representationFilename value), optionalPair "byteSize" (representationByteSize value), optionalPair "checksum" (representationChecksum value), optionalPair "encoding" (representationEncoding value), optionalPair "language" (representationLanguage value), optionalPair "width" (representationWidth value), optionalPair "height" (representationHeight value), optionalPair "duration" (representationDuration value), optionalPair "created" (representationCreated value), optionalPair "modified" (representationModified value), optionalPair "conformsTo" (representationConformsTo value), optionalPair "tags" (representationTags value), optionalPair "rel" (representationRel value)]) <> fmap toJSON (withoutFields ["@id", "@type", "mediaType", "storageUri", "filename", "byteSize", "checksum", "encoding", "language", "width", "height", "duration", "created", "modified", "conformsTo", "tags", "rel"] (representationAdditionalProperties value)))

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
