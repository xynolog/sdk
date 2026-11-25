-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkDeleteCommand (MarkDeleteCommand (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.ResourceId
import Xynolog.Internal.Generated.Models.UserId

data MarkDeleteCommand = MarkDeleteCommand
  { markDeleteCommandUserId :: Maybe UserId,
    markDeleteCommandAnnotationId :: AnnotationId,
    markDeleteCommandResourceId :: Maybe ResourceId,
    markDeleteCommandAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON MarkDeleteCommand where parseJSON = checked "MarkDeleteCommand" $ withObject "MarkDeleteCommand" (\fields -> MarkDeleteCommand <$> optional fields "_userId" <*> (fields .: "annotationId") <*> optional fields "resourceId" <*> traverse parseJSON (withoutFields ["_userId", "annotationId", "resourceId"] fields))

instance ToJSON MarkDeleteCommand where toJSON value = Object (KM.fromList (concat [optionalPair "_userId" (markDeleteCommandUserId value), [("annotationId", toJSON (markDeleteCommandAnnotationId value))], optionalPair "resourceId" (markDeleteCommandResourceId value)]) <> fmap toJSON (withoutFields ["_userId", "annotationId", "resourceId"] (markDeleteCommandAdditionalProperties value)))
