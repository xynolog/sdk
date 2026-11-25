-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MatchSearchFailed (MatchSearchFailed (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.CommandError

data MatchSearchFailed = MatchSearchFailed
  { matchSearchFailedCode :: Maybe CommandErrorCode,
    matchSearchFailedMessage :: Text,
    matchSearchFailedDetails :: Maybe Text,
    matchSearchFailedReferenceId :: AnnotationId
  }
  deriving (Eq, Show)

instance FromJSON MatchSearchFailed where parseJSON = checked "MatchSearchFailed" $ withObject "MatchSearchFailed" (\fields -> MatchSearchFailed <$> optional fields "code" <*> (fields .: "message") <*> optional fields "details" <*> (fields .: "referenceId"))

instance ToJSON MatchSearchFailed where toJSON value = Object (KM.fromList (concat [optionalPair "code" (matchSearchFailedCode value), [("message", toJSON (matchSearchFailedMessage value))], optionalPair "details" (matchSearchFailedDetails value), [("referenceId", toJSON (matchSearchFailedReferenceId value))]]))
