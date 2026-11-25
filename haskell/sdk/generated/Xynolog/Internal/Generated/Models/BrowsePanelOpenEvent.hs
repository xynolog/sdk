-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BrowsePanelOpenEvent (BrowsePanelOpenEvent (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.AnnotationId
import Xynolog.Internal.Generated.Models.Motivation

data BrowsePanelOpenEvent = BrowsePanelOpenEvent
  { browsePanelOpenEventPanel :: Text,
    browsePanelOpenEventScrollToAnnotationId :: Maybe AnnotationId,
    browsePanelOpenEventMotivation :: Maybe Motivation
  }
  deriving (Eq, Show)

instance FromJSON BrowsePanelOpenEvent where parseJSON = checked "BrowsePanelOpenEvent" $ withObject "BrowsePanelOpenEvent" (\fields -> BrowsePanelOpenEvent <$> (fields .: "panel") <*> optional fields "scrollToAnnotationId" <*> optional fields "motivation")

instance ToJSON BrowsePanelOpenEvent where toJSON value = Object (KM.fromList (concat [[("panel", toJSON (browsePanelOpenEventPanel value))], optionalPair "scrollToAnnotationId" (browsePanelOpenEventScrollToAnnotationId value), optionalPair "motivation" (browsePanelOpenEventMotivation value)]))
