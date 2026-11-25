-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.NewKnowledgeBase (NewKnowledgeBase (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.KbEndpoint
import Xynolog.Internal.Generated.Models.KbRead

data NewKnowledgeBase = NewKnowledgeBase
  { newKnowledgeBaseLabel :: Text,
    newKnowledgeBaseEndpoint :: KbEndpoint,
    newKnowledgeBaseDid :: Text,
    newKnowledgeBaseLastRead :: Maybe KbRead
  }
  deriving (Eq, Show)

instance FromJSON NewKnowledgeBase where parseJSON = checked "NewKnowledgeBase" $ withObject "NewKnowledgeBase" (\fields -> NewKnowledgeBase <$> (fields .: "label") <*> (fields .: "endpoint") <*> (fields .: "did") <*> optional fields "lastRead")

instance ToJSON NewKnowledgeBase where toJSON value = Object (KM.fromList (concat [[("label", toJSON (newKnowledgeBaseLabel value))], [("endpoint", toJSON (newKnowledgeBaseEndpoint value))], [("did", toJSON (newKnowledgeBaseDid value))], optionalPair "lastRead" (newKnowledgeBaseLastRead value)]))
