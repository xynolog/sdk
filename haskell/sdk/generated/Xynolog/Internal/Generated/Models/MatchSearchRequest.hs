-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MatchSearchRequest (MatchSearchRequest (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.GatheredContext
import Xynolog.Internal.Generated.Models.ResourceId

data MatchSearchRequest = MatchSearchRequest
  { matchSearchRequestResourceId :: ResourceId,
    matchSearchRequestReferenceId :: AnnotationId,
    matchSearchRequestContext :: GatheredContext,
    matchSearchRequestLimit :: Maybe Integer,
    matchSearchRequestUseSemanticScoring :: Maybe Bool
  }
  deriving (Eq, Show)

instance FromJSON MatchSearchRequest where parseJSON = checked "MatchSearchRequest" $ withObject "MatchSearchRequest" (\fields -> MatchSearchRequest <$> (fields .: "resourceId") <*> (fields .: "referenceId") <*> (fields .: "context") <*> optional fields "limit" <*> optional fields "useSemanticScoring")

instance ToJSON MatchSearchRequest where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (matchSearchRequestResourceId value))], [("referenceId", toJSON (matchSearchRequestReferenceId value))], [("context", toJSON (matchSearchRequestContext value))], optionalPair "limit" (matchSearchRequestLimit value), optionalPair "useSemanticScoring" (matchSearchRequestUseSemanticScoring value)]))
