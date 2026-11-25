-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.GatherFailed (GatherFailed (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.CommandError

data GatherFailed = GatherFailed
  { gatherFailedAnnotationId :: AnnotationId,
    gatherFailedCode :: Maybe CommandErrorCode,
    gatherFailedDetails :: Maybe Text,
    gatherFailedMessage :: Text
  }
  deriving (Eq, Show)

instance FromJSON GatherFailed where parseJSON = checked "GatherFailed" $ withObject "GatherFailed" (\fields -> GatherFailed <$> (fields .: "annotationId") <*> optional fields "code" <*> optional fields "details" <*> (fields .: "message"))

instance ToJSON GatherFailed where toJSON value = Object (KM.fromList (concat [[("annotationId", toJSON (gatherFailedAnnotationId value))], optionalPair "code" (gatherFailedCode value), optionalPair "details" (gatherFailedDetails value), [("message", toJSON (gatherFailedMessage value))]]))
