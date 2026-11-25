-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkUpdateBodyCommand (MarkUpdateBodyCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.BodyOperation
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data MarkUpdateBodyCommand = MarkUpdateBodyCommand
  { markUpdateBodyCommandUserId :: Maybe UserId,
    markUpdateBodyCommandAnnotationId :: AnnotationId,
    markUpdateBodyCommandResourceId :: ResourceId,
    markUpdateBodyCommandOperations :: [BodyOperation]
  }
  deriving (Eq, Show)

instance FromJSON MarkUpdateBodyCommand where parseJSON = checked "MarkUpdateBodyCommand" $ withObject "MarkUpdateBodyCommand" (\fields -> MarkUpdateBodyCommand <$> optional fields "_userId" <*> (fields .: "annotationId") <*> (fields .: "resourceId") <*> (fields .: "operations"))

instance ToJSON MarkUpdateBodyCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (markUpdateBodyCommandUserId value), [("annotationId", toJSON (markUpdateBodyCommandAnnotationId value))], [("resourceId", toJSON (markUpdateBodyCommandResourceId value))], [("operations", toJSON (markUpdateBodyCommandOperations value))]]))
