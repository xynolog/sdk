-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkCreateOkResponse (MarkCreateOkResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId

data MarkCreateOkResponse = MarkCreateOkResponse
  { markCreateOkResponseAnnotationId :: AnnotationId
  }
  deriving (Eq, Show)

instance FromJSON MarkCreateOkResponse where parseJSON = checked "MarkCreateOkResponse" $ withObject "MarkCreateOkResponse" (\fields -> MarkCreateOkResponse <$> (fields .: "annotationId"))

instance ToJSON MarkCreateOkResponse where toJSON value = Object (KM.fromList (concat [[("annotationId", toJSON (markCreateOkResponseAnnotationId value))]]))
