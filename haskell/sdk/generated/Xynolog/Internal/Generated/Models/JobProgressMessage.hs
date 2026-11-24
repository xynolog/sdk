-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.JobProgressMessage (JobProgressMessage (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..))
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.JobProgressAnalyzing
import Xynolog.Internal.Generated.Models.JobProgressAnalyzingTags
import Xynolog.Internal.Generated.Models.JobProgressCompleteCreated
import Xynolog.Internal.Generated.Models.JobProgressCompleteGenerated
import Xynolog.Internal.Generated.Models.JobProgressCreatingAnnotations
import Xynolog.Internal.Generated.Models.JobProgressCreatingResource
import Xynolog.Internal.Generated.Models.JobProgressCreatingTagAnnotations
import Xynolog.Internal.Generated.Models.JobProgressDetectingEntities
import Xynolog.Internal.Generated.Models.JobProgressGeneratingResource
import Xynolog.Internal.Generated.Models.JobProgressLoading

data JobProgressMessage = JobProgressMessageJobProgressLoading JobProgressLoading | JobProgressMessageJobProgressAnalyzing JobProgressAnalyzing | JobProgressMessageJobProgressAnalyzingTags JobProgressAnalyzingTags | JobProgressMessageJobProgressGeneratingResource JobProgressGeneratingResource | JobProgressMessageJobProgressCreatingResource JobProgressCreatingResource | JobProgressMessageJobProgressCompleteGenerated JobProgressCompleteGenerated | JobProgressMessageJobProgressDetectingEntities JobProgressDetectingEntities | JobProgressMessageJobProgressCreatingAnnotations JobProgressCreatingAnnotations | JobProgressMessageJobProgressCreatingTagAnnotations JobProgressCreatingTagAnnotations | JobProgressMessageJobProgressCompleteCreated JobProgressCompleteCreated deriving (Eq, Show)

instance FromJSON JobProgressMessage where parseJSON = checked "JobProgressMessage" $ \value -> (JobProgressMessageJobProgressLoading <$> parseJSON value) <|> (JobProgressMessageJobProgressAnalyzing <$> parseJSON value) <|> (JobProgressMessageJobProgressAnalyzingTags <$> parseJSON value) <|> (JobProgressMessageJobProgressGeneratingResource <$> parseJSON value) <|> (JobProgressMessageJobProgressCreatingResource <$> parseJSON value) <|> (JobProgressMessageJobProgressCompleteGenerated <$> parseJSON value) <|> (JobProgressMessageJobProgressDetectingEntities <$> parseJSON value) <|> (JobProgressMessageJobProgressCreatingAnnotations <$> parseJSON value) <|> (JobProgressMessageJobProgressCreatingTagAnnotations <$> parseJSON value) <|> (JobProgressMessageJobProgressCompleteCreated <$> parseJSON value)

instance ToJSON JobProgressMessage where
  toJSON (JobProgressMessageJobProgressLoading value) = toJSON value
  toJSON (JobProgressMessageJobProgressAnalyzing value) = toJSON value
  toJSON (JobProgressMessageJobProgressAnalyzingTags value) = toJSON value
  toJSON (JobProgressMessageJobProgressGeneratingResource value) = toJSON value
  toJSON (JobProgressMessageJobProgressCreatingResource value) = toJSON value
  toJSON (JobProgressMessageJobProgressCompleteGenerated value) = toJSON value
  toJSON (JobProgressMessageJobProgressDetectingEntities value) = toJSON value
  toJSON (JobProgressMessageJobProgressCreatingAnnotations value) = toJSON value
  toJSON (JobProgressMessageJobProgressCreatingTagAnnotations value) = toJSON value
  toJSON (JobProgressMessageJobProgressCompleteCreated value) = toJSON value
