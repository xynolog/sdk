-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.MarkJobParams (MarkJobParams (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AssessingJobParams
import Xynolog.Internal.Generated.Models.CommentingJobParams
import Xynolog.Internal.Generated.Models.HighlightingJobParams
import Xynolog.Internal.Generated.Models.LinkingJobParams
import Xynolog.Internal.Generated.Models.TaggingJobParams

data MarkJobParams = MarkJobParamsHighlightingJobParams HighlightingJobParams | MarkJobParamsCommentingJobParams CommentingJobParams | MarkJobParamsAssessingJobParams AssessingJobParams | MarkJobParamsLinkingJobParams LinkingJobParams | MarkJobParamsTaggingJobParams TaggingJobParams deriving (Eq, Show)

instance FromJSON MarkJobParams where parseJSON = checked "MarkJobParams" $ \value -> (MarkJobParamsHighlightingJobParams <$> parseJSON value) <|> (MarkJobParamsCommentingJobParams <$> parseJSON value) <|> (MarkJobParamsAssessingJobParams <$> parseJSON value) <|> (MarkJobParamsLinkingJobParams <$> parseJSON value) <|> (MarkJobParamsTaggingJobParams <$> parseJSON value)

instance ToJSON MarkJobParams where
  toJSON (MarkJobParamsHighlightingJobParams value) = toJSON value
  toJSON (MarkJobParamsCommentingJobParams value) = toJSON value
  toJSON (MarkJobParamsAssessingJobParams value) = toJSON value
  toJSON (MarkJobParamsLinkingJobParams value) = toJSON value
  toJSON (MarkJobParamsTaggingJobParams value) = toJSON value
