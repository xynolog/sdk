-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkDeleteOk (MarkDeleteOk (..), MarkDeleteOkResponse (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId

data MarkDeleteOk = MarkDeleteOk
  { markDeleteOkResponse :: MarkDeleteOkResponse
  }
  deriving (Eq, Show)

instance FromJSON MarkDeleteOk where parseJSON = checked "MarkDeleteOk" $ withObject "MarkDeleteOk" (\fields -> MarkDeleteOk <$> (fields .: "response"))

instance ToJSON MarkDeleteOk where toJSON value = Object (KM.fromList (concat [[("response", toJSON (markDeleteOkResponse value))]]))

data MarkDeleteOkResponse = MarkDeleteOkResponse
  { markDeleteOkResponseAnnotationId :: AnnotationId
  }
  deriving (Eq, Show)

instance FromJSON MarkDeleteOkResponse where parseJSON = checked "MarkDeleteOkResponse" $ withObject "MarkDeleteOkResponse" (\fields -> MarkDeleteOkResponse <$> (fields .: "annotationId"))

instance ToJSON MarkDeleteOkResponse where toJSON value = Object (KM.fromList (concat [[("annotationId", toJSON (markDeleteOkResponseAnnotationId value))]]))
