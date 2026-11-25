-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.UpdateAnnotationBodyRequest (UpdateAnnotationBodyRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.BodyOperation
import Xynolog.Internal.Generated.Models.ResourceId

data UpdateAnnotationBodyRequest = UpdateAnnotationBodyRequest
  { updateAnnotationBodyRequestResourceId :: ResourceId,
    updateAnnotationBodyRequestOperations :: [BodyOperation]
  }
  deriving (Eq, Show)

instance FromJSON UpdateAnnotationBodyRequest where parseJSON = checked "UpdateAnnotationBodyRequest" $ withObject "UpdateAnnotationBodyRequest" (\fields -> UpdateAnnotationBodyRequest <$> (fields .: "resourceId") <*> (fields .: "operations"))

instance ToJSON UpdateAnnotationBodyRequest where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (updateAnnotationBodyRequestResourceId value))], [("operations", toJSON (updateAnnotationBodyRequestOperations value))]]))
