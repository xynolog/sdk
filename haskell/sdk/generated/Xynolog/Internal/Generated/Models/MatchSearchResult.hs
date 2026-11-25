-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MatchSearchResult (MatchSearchResult (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.ScoredResource

data MatchSearchResult = MatchSearchResult
  { matchSearchResultReferenceId :: AnnotationId,
    matchSearchResultResponse :: [ScoredResource]
  }
  deriving (Eq, Show)

instance FromJSON MatchSearchResult where parseJSON = checked "MatchSearchResult" $ withObject "MatchSearchResult" (\fields -> MatchSearchResult <$> (fields .: "referenceId") <*> (fields .: "response"))

instance ToJSON MatchSearchResult where toJSON value = Object (KM.fromList (concat [[("referenceId", toJSON (matchSearchResultReferenceId value))], [("response", toJSON (matchSearchResultResponse value))]]))
