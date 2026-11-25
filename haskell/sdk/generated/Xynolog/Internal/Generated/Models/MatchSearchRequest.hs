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
  { matchSearchRequestContext :: GatheredContext,
    matchSearchRequestLimit :: Maybe Integer,
    matchSearchRequestReferenceId :: AnnotationId,
    matchSearchRequestResourceId :: ResourceId,
    matchSearchRequestUseSemanticScoring :: Maybe Bool
  }
  deriving (Eq, Show)

instance FromJSON MatchSearchRequest where parseJSON = checked "MatchSearchRequest" $ withObject "MatchSearchRequest" (\fields -> MatchSearchRequest <$> (fields .: "context") <*> optional fields "limit" <*> (fields .: "referenceId") <*> (fields .: "resourceId") <*> optional fields "useSemanticScoring")

instance ToJSON MatchSearchRequest where toJSON value = Object (KM.fromList (concat [[("context", toJSON (matchSearchRequestContext value))], optionalPair "limit" (matchSearchRequestLimit value), [("referenceId", toJSON (matchSearchRequestReferenceId value))], [("resourceId", toJSON (matchSearchRequestResourceId value))], optionalPair "useSemanticScoring" (matchSearchRequestUseSemanticScoring value)]))
