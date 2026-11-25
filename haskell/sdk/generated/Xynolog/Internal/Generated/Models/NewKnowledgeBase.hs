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
  { newKnowledgeBaseDid :: Text,
    newKnowledgeBaseEndpoint :: KbEndpoint,
    newKnowledgeBaseLabel :: Text,
    newKnowledgeBaseLastRead :: Maybe KbRead
  }
  deriving (Eq, Show)

instance FromJSON NewKnowledgeBase where parseJSON = checked "NewKnowledgeBase" $ withObject "NewKnowledgeBase" (\fields -> NewKnowledgeBase <$> (fields .: "did") <*> (fields .: "endpoint") <*> (fields .: "label") <*> optional fields "lastRead")

instance ToJSON NewKnowledgeBase where toJSON value = Object (KM.fromList (concat [[("did", toJSON (newKnowledgeBaseDid value))], [("endpoint", toJSON (newKnowledgeBaseEndpoint value))], [("label", toJSON (newKnowledgeBaseLabel value))], optionalPair "lastRead" (newKnowledgeBaseLastRead value)]))
