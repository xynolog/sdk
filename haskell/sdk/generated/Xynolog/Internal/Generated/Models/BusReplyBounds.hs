-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.BusReplyBounds (BusReplyBounds (..), BusReplyBoundsRepliesValueValue (..), BusReplyBoundsRepliesValueValueBy (..), BusReplyBoundsRepliesValueValueGrows (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data BusReplyBounds = BusReplyBounds
  { busReplyBoundsComment :: Text,
    busReplyBoundsReplies :: KM.KeyMap (KM.KeyMap BusReplyBoundsRepliesValueValue)
  }
  deriving (Eq, Show)

instance FromJSON BusReplyBounds where parseJSON = checked "BusReplyBounds" $ withObject "BusReplyBounds" (\fields -> BusReplyBounds <$> (fields .: "$comment") <*> (fields .: "replies"))

instance ToJSON BusReplyBounds where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (busReplyBoundsComment value))], [("replies", toJSON (busReplyBoundsReplies value))]]))

data BusReplyBoundsRepliesValueValue = BusReplyBoundsRepliesValueValueBy BusReplyBoundsRepliesValueValueBy | BusReplyBoundsRepliesValueValueGrows BusReplyBoundsRepliesValueValueGrows deriving (Eq, Show)

instance FromJSON BusReplyBoundsRepliesValueValue where parseJSON = checked "BusReplyBoundsRepliesValueValue" $ \value -> (BusReplyBoundsRepliesValueValueBy <$> parseJSON value) <|> (BusReplyBoundsRepliesValueValueGrows <$> parseJSON value)

instance ToJSON BusReplyBoundsRepliesValueValue where
  toJSON (BusReplyBoundsRepliesValueValueBy value) = toJSON value
  toJSON (BusReplyBoundsRepliesValueValueGrows value) = toJSON value

data BusReplyBoundsRepliesValueValueBy = MkBusReplyBoundsRepliesValueValueBy
  { busReplyBoundsRepliesValueValueByBy :: Text
  }
  deriving (Eq, Show)

instance FromJSON BusReplyBoundsRepliesValueValueBy where parseJSON = checked "BusReplyBoundsRepliesValueValueBy" $ withObject "BusReplyBoundsRepliesValueValueBy" (\fields -> MkBusReplyBoundsRepliesValueValueBy <$> (fields .: "by"))

instance ToJSON BusReplyBoundsRepliesValueValueBy where toJSON value = Object (KM.fromList (concat [[("by", toJSON (busReplyBoundsRepliesValueValueByBy value))]]))

data BusReplyBoundsRepliesValueValueGrows = MkBusReplyBoundsRepliesValueValueGrows
  { busReplyBoundsRepliesValueValueGrowsGrows :: Text
  }
  deriving (Eq, Show)

instance FromJSON BusReplyBoundsRepliesValueValueGrows where parseJSON = checked "BusReplyBoundsRepliesValueValueGrows" $ withObject "BusReplyBoundsRepliesValueValueGrows" (\fields -> MkBusReplyBoundsRepliesValueValueGrows <$> (fields .: "grows"))

instance ToJSON BusReplyBoundsRepliesValueValueGrows where toJSON value = Object (KM.fromList (concat [[("grows", toJSON (busReplyBoundsRepliesValueValueGrowsGrows value))]]))
