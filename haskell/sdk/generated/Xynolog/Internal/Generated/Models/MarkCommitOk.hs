-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkCommitOk (MarkCommitOk (..), MarkCommitOkResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId

data MarkCommitOk = MarkCommitOk
  { markCommitOkResponse :: MarkCommitOkResponse
  }
  deriving (Eq, Show)

instance FromJSON MarkCommitOk where parseJSON = checked "MarkCommitOk" $ withObject "MarkCommitOk" (\fields -> MarkCommitOk <$> (fields .: "response"))

instance ToJSON MarkCommitOk where toJSON value = Object (KM.fromList (concat [[("response", toJSON (markCommitOkResponse value))]]))

data MarkCommitOkResponse = MarkCommitOkResponse
  { markCommitOkResponsePersisted :: Integer,
    markCommitOkResponseAnnotationIds :: [AnnotationId]
  }
  deriving (Eq, Show)

instance FromJSON MarkCommitOkResponse where parseJSON = checked "MarkCommitOkResponse" $ withObject "MarkCommitOkResponse" (\fields -> MarkCommitOkResponse <$> (fields .: "persisted") <*> (fields .: "annotationIds"))

instance ToJSON MarkCommitOkResponse where toJSON value = Object (KM.fromList (concat [[("persisted", toJSON (markCommitOkResponsePersisted value))], [("annotationIds", toJSON (markCommitOkResponseAnnotationIds value))]]))
