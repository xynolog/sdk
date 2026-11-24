module Xynolog.Resources (getPrimaryRepresentation, getPrimaryMediaType, getResourceEntityTypes, decodeRepresentation) where

import Data.Text (Text)
import Xynolog.Internal.Text (decodeRepresentation)
import Xynolog.Types

getPrimaryRepresentation :: ResourceDescriptor -> Maybe Representation
getPrimaryRepresentation resource = case resourceDescriptorRepresentations resource of
  ResourceDescriptorRepresentationsRepresentation representation -> Just representation
  ResourceDescriptorRepresentationsList (representation : _) -> Just representation
  ResourceDescriptorRepresentationsList [] -> Nothing

getPrimaryMediaType :: ResourceDescriptor -> Maybe Text
getPrimaryMediaType = fmap representationMediaType . getPrimaryRepresentation

getResourceEntityTypes :: ResourceDescriptor -> [Text]
getResourceEntityTypes = maybe [] id . resourceDescriptorEntityTypes
