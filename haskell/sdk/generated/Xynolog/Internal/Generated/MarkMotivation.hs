-- Generated from protocol/specs/src/components/schemas/MarkJobParams.json and protocol/specs/src/components/schemas/Motivation.json; do not edit.
-- Regenerate: make generate (codegen/lib/job_storage/job_storage.ml)
module Xynolog.Internal.Generated.MarkMotivation (markMotivation) where

import Xynolog.Types (MarkJobParams (..), Motivation (..))

markMotivation :: MarkJobParams -> Motivation
markMotivation (MarkJobParamsHighlightingJobParams _) = MotivationHighlighting
markMotivation (MarkJobParamsCommentingJobParams _) = MotivationCommenting
markMotivation (MarkJobParamsAssessingJobParams _) = MotivationAssessing
markMotivation (MarkJobParamsLinkingJobParams _) = MotivationLinking
markMotivation (MarkJobParamsTaggingJobParams _) = MotivationTagging
