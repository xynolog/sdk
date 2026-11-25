-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.KnowledgeBase (KnowledgeBase (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.KbEndpoint
import Xynolog.Internal.Generated.Models.KbRead

data KnowledgeBase = KnowledgeBase
  { knowledgeBaseDid :: Text,
    knowledgeBaseEndpoint :: KbEndpoint,
    knowledgeBaseId :: Text,
    knowledgeBaseLabel :: Text,
    knowledgeBaseLastRead :: Maybe KbRead
  }
  deriving (Eq, Show)

instance FromJSON KnowledgeBase where parseJSON = checked "KnowledgeBase" $ withObject "KnowledgeBase" (\fields -> KnowledgeBase <$> (fields .: "did") <*> (fields .: "endpoint") <*> (fields .: "id") <*> (fields .: "label") <*> optional fields "lastRead")

instance ToJSON KnowledgeBase where toJSON value = Object (KM.fromList (concat [[("did", toJSON (knowledgeBaseDid value))], [("endpoint", toJSON (knowledgeBaseEndpoint value))], [("id", toJSON (knowledgeBaseId value))], [("label", toJSON (knowledgeBaseLabel value))], optionalPair "lastRead" (knowledgeBaseLastRead value)]))
