-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ContextualSummaryResponse (ContextualSummaryResponse (..), ContextualSummaryResponseContext (..), ContextualSummaryResponseRelevantFields (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ResourceId

data ContextualSummaryResponse = ContextualSummaryResponse
  { contextualSummaryResponseContext :: ContextualSummaryResponseContext,
    contextualSummaryResponseRelevantFields :: ContextualSummaryResponseRelevantFields,
    contextualSummaryResponseSummary :: Text
  }
  deriving (Eq, Show)

instance FromJSON ContextualSummaryResponse where parseJSON = checked "ContextualSummaryResponse" $ withObject "ContextualSummaryResponse" (\fields -> ContextualSummaryResponse <$> (fields .: "context") <*> (fields .: "relevantFields") <*> (fields .: "summary"))

instance ToJSON ContextualSummaryResponse where toJSON value = Object (KM.fromList (concat [[("context", toJSON (contextualSummaryResponseContext value))], [("relevantFields", toJSON (contextualSummaryResponseRelevantFields value))], [("summary", toJSON (contextualSummaryResponseSummary value))]]))

data ContextualSummaryResponseContext = ContextualSummaryResponseContext
  { contextualSummaryResponseContextAfter :: Maybe Text,
    contextualSummaryResponseContextBefore :: Maybe Text,
    contextualSummaryResponseContextSelected :: Text
  }
  deriving (Eq, Show)

instance FromJSON ContextualSummaryResponseContext where parseJSON = checked "ContextualSummaryResponseContext" $ withObject "ContextualSummaryResponseContext" (\fields -> ContextualSummaryResponseContext <$> optional fields "after" <*> optional fields "before" <*> (fields .: "selected"))

instance ToJSON ContextualSummaryResponseContext where toJSON value = Object (KM.fromList (concat [optionalPair "after" (contextualSummaryResponseContextAfter value), optionalPair "before" (contextualSummaryResponseContextBefore value), [("selected", toJSON (contextualSummaryResponseContextSelected value))]]))

data ContextualSummaryResponseRelevantFields = ContextualSummaryResponseRelevantFields
  { contextualSummaryResponseRelevantFieldsEntityTypes :: [Text],
    contextualSummaryResponseRelevantFieldsResourceId :: ResourceId,
    contextualSummaryResponseRelevantFieldsResourceName :: Text
  }
  deriving (Eq, Show)

instance FromJSON ContextualSummaryResponseRelevantFields where parseJSON = checked "ContextualSummaryResponseRelevantFields" $ withObject "ContextualSummaryResponseRelevantFields" (\fields -> ContextualSummaryResponseRelevantFields <$> (fields .: "entityTypes") <*> (fields .: "resourceId") <*> (fields .: "resourceName"))

instance ToJSON ContextualSummaryResponseRelevantFields where toJSON value = Object (KM.fromList (concat [[("entityTypes", toJSON (contextualSummaryResponseRelevantFieldsEntityTypes value))], [("resourceId", toJSON (contextualSummaryResponseRelevantFieldsResourceId value))], [("resourceName", toJSON (contextualSummaryResponseRelevantFieldsResourceName value))]]))
