-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BindUpdateBodyCommand (BindUpdateBodyCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.BindBodyOperation
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data BindUpdateBodyCommand = BindUpdateBodyCommand
  { bindUpdateBodyCommandUserId :: Maybe UserId,
    bindUpdateBodyCommandAnnotationId :: AnnotationId,
    bindUpdateBodyCommandResourceId :: ResourceId,
    bindUpdateBodyCommandOperations :: [BindBodyOperation]
  }
  deriving (Eq, Show)

instance FromJSON BindUpdateBodyCommand where parseJSON = checked "BindUpdateBodyCommand" $ withObject "BindUpdateBodyCommand" (\fields -> BindUpdateBodyCommand <$> optional fields "_userId" <*> (fields .: "annotationId") <*> (fields .: "resourceId") <*> (fields .: "operations"))

instance ToJSON BindUpdateBodyCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (bindUpdateBodyCommandUserId value), [("annotationId", toJSON (bindUpdateBodyCommandAnnotationId value))], [("resourceId", toJSON (bindUpdateBodyCommandResourceId value))], [("operations", toJSON (bindUpdateBodyCommandOperations value))]]))
