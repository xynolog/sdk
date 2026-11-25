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
  { contextualSummaryResponseSummary :: Text,
    contextualSummaryResponseRelevantFields :: ContextualSummaryResponseRelevantFields,
    contextualSummaryResponseContext :: ContextualSummaryResponseContext
  }
  deriving (Eq, Show)

instance FromJSON ContextualSummaryResponse where parseJSON = checked "ContextualSummaryResponse" $ withObject "ContextualSummaryResponse" (\fields -> ContextualSummaryResponse <$> (fields .: "summary") <*> (fields .: "relevantFields") <*> (fields .: "context"))

instance ToJSON ContextualSummaryResponse where toJSON value = Object (KM.fromList (concat [[("summary", toJSON (contextualSummaryResponseSummary value))], [("relevantFields", toJSON (contextualSummaryResponseRelevantFields value))], [("context", toJSON (contextualSummaryResponseContext value))]]))

data ContextualSummaryResponseContext = ContextualSummaryResponseContext
  { contextualSummaryResponseContextBefore :: Maybe Text,
    contextualSummaryResponseContextSelected :: Text,
    contextualSummaryResponseContextAfter :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON ContextualSummaryResponseContext where parseJSON = checked "ContextualSummaryResponseContext" $ withObject "ContextualSummaryResponseContext" (\fields -> ContextualSummaryResponseContext <$> optional fields "before" <*> (fields .: "selected") <*> optional fields "after")

instance ToJSON ContextualSummaryResponseContext where toJSON value = Object (KM.fromList (concat [optionalPair "before" (contextualSummaryResponseContextBefore value), [("selected", toJSON (contextualSummaryResponseContextSelected value))], optionalPair "after" (contextualSummaryResponseContextAfter value)]))

data ContextualSummaryResponseRelevantFields = ContextualSummaryResponseRelevantFields
  { contextualSummaryResponseRelevantFieldsResourceId :: ResourceId,
    contextualSummaryResponseRelevantFieldsResourceName :: Text,
    contextualSummaryResponseRelevantFieldsEntityTypes :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON ContextualSummaryResponseRelevantFields where parseJSON = checked "ContextualSummaryResponseRelevantFields" $ withObject "ContextualSummaryResponseRelevantFields" (\fields -> ContextualSummaryResponseRelevantFields <$> (fields .: "resourceId") <*> (fields .: "resourceName") <*> (fields .: "entityTypes"))

instance ToJSON ContextualSummaryResponseRelevantFields where toJSON value = Object (KM.fromList (concat [[("resourceId", toJSON (contextualSummaryResponseRelevantFieldsResourceId value))], [("resourceName", toJSON (contextualSummaryResponseRelevantFieldsResourceName value))], [("entityTypes", toJSON (contextualSummaryResponseRelevantFieldsEntityTypes value))]]))
