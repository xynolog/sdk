-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatherFailed (GatherFailed (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.ArchivistMessages

data GatherFailed = GatherFailed
  { gatherFailedCode :: Maybe CommandErrorCode,
    gatherFailedMessage :: Text,
    gatherFailedDetails :: Maybe Text,
    gatherFailedAnnotationId :: AnnotationId
  }
  deriving (Eq, Show)

instance FromJSON GatherFailed where parseJSON = checked "GatherFailed" $ withObject "GatherFailed" (\fields -> GatherFailed <$> optional fields "code" <*> (fields .: "message") <*> optional fields "details" <*> (fields .: "annotationId"))

instance ToJSON GatherFailed where toJSON value = Object (KM.fromList (concat [optionalPair "code" (gatherFailedCode value), [("message", toJSON (gatherFailedMessage value))], optionalPair "details" (gatherFailedDetails value), [("annotationId", toJSON (gatherFailedAnnotationId value))]]))
