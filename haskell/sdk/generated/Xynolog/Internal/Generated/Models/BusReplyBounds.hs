-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BusReplyBounds (BusReplyBounds (..), BusReplyBoundsReplies (..), BusReplyBoundsRepliesAdditionalValue (..), BusReplyBoundsRepliesAdditionalValueAdditionalValue (..), BusReplyBoundsRepliesAdditionalValueAdditionalValueByValue (..), BusReplyBoundsRepliesAdditionalValueAdditionalValueGrowsValue (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data BusReplyBounds = BusReplyBounds
  { busReplyBoundsReplies :: BusReplyBoundsReplies
  }
  deriving (Eq, Show)

instance FromJSON BusReplyBounds where parseJSON = checked "BusReplyBounds" $ withObject "BusReplyBounds" (\fields -> BusReplyBounds <$> (fields .: "replies"))

instance ToJSON BusReplyBounds where toJSON value = Object (KM.fromList (concat [[("replies", toJSON (busReplyBoundsReplies value))]]))

data BusReplyBoundsReplies = BusReplyBoundsReplies
  { busReplyBoundsRepliesAdditionalProperties :: KM.KeyMap BusReplyBoundsRepliesAdditionalValue
  }
  deriving (Eq, Show)

instance FromJSON BusReplyBoundsReplies where parseJSON = checked "BusReplyBoundsReplies" $ withObject "BusReplyBoundsReplies" (\fields -> BusReplyBoundsReplies <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON BusReplyBoundsReplies where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (busReplyBoundsRepliesAdditionalProperties value)))

data BusReplyBoundsRepliesAdditionalValue = BusReplyBoundsRepliesAdditionalValue
  { busReplyBoundsRepliesAdditionalValueAdditionalProperties :: KM.KeyMap BusReplyBoundsRepliesAdditionalValueAdditionalValue
  }
  deriving (Eq, Show)

instance FromJSON BusReplyBoundsRepliesAdditionalValue where parseJSON = checked "BusReplyBoundsRepliesAdditionalValue" $ withObject "BusReplyBoundsRepliesAdditionalValue" (\fields -> BusReplyBoundsRepliesAdditionalValue <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON BusReplyBoundsRepliesAdditionalValue where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (busReplyBoundsRepliesAdditionalValueAdditionalProperties value)))

data BusReplyBoundsRepliesAdditionalValueAdditionalValue = BusReplyBoundsRepliesAdditionalValueAdditionalValueBy BusReplyBoundsRepliesAdditionalValueAdditionalValueByValue | BusReplyBoundsRepliesAdditionalValueAdditionalValueGrows BusReplyBoundsRepliesAdditionalValueAdditionalValueGrowsValue deriving (Eq, Show)

instance FromJSON BusReplyBoundsRepliesAdditionalValueAdditionalValue where parseJSON = checked "BusReplyBoundsRepliesAdditionalValueAdditionalValue" $ \value -> (BusReplyBoundsRepliesAdditionalValueAdditionalValueBy <$> parseJSON value) <|> (BusReplyBoundsRepliesAdditionalValueAdditionalValueGrows <$> parseJSON value)

instance ToJSON BusReplyBoundsRepliesAdditionalValueAdditionalValue where
  toJSON (BusReplyBoundsRepliesAdditionalValueAdditionalValueBy value) = toJSON value
  toJSON (BusReplyBoundsRepliesAdditionalValueAdditionalValueGrows value) = toJSON value

data BusReplyBoundsRepliesAdditionalValueAdditionalValueByValue = BusReplyBoundsRepliesAdditionalValueAdditionalValueByValue
  { busReplyBoundsRepliesAdditionalValueAdditionalValueByValueBy :: Text
  }
  deriving (Eq, Show)

instance FromJSON BusReplyBoundsRepliesAdditionalValueAdditionalValueByValue where parseJSON = checked "BusReplyBoundsRepliesAdditionalValueAdditionalValueByValue" $ withObject "BusReplyBoundsRepliesAdditionalValueAdditionalValueByValue" (\fields -> BusReplyBoundsRepliesAdditionalValueAdditionalValueByValue <$> (fields .: "by"))

instance ToJSON BusReplyBoundsRepliesAdditionalValueAdditionalValueByValue where toJSON value = Object (KM.fromList (concat [[("by", toJSON (busReplyBoundsRepliesAdditionalValueAdditionalValueByValueBy value))]]))

data BusReplyBoundsRepliesAdditionalValueAdditionalValueGrowsValue = BusReplyBoundsRepliesAdditionalValueAdditionalValueGrowsValue
  { busReplyBoundsRepliesAdditionalValueAdditionalValueGrowsValueGrows :: Text
  }
  deriving (Eq, Show)

instance FromJSON BusReplyBoundsRepliesAdditionalValueAdditionalValueGrowsValue where parseJSON = checked "BusReplyBoundsRepliesAdditionalValueAdditionalValueGrowsValue" $ withObject "BusReplyBoundsRepliesAdditionalValueAdditionalValueGrowsValue" (\fields -> BusReplyBoundsRepliesAdditionalValueAdditionalValueGrowsValue <$> (fields .: "grows"))

instance ToJSON BusReplyBoundsRepliesAdditionalValueAdditionalValueGrowsValue where toJSON value = Object (KM.fromList (concat [[("grows", toJSON (busReplyBoundsRepliesAdditionalValueAdditionalValueGrowsValueGrows value))]]))
