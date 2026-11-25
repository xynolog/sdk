-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.FollowerFollowing (FollowerFollowing (..), FollowerFollowingSweep (..), followerFollowingSweepText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data FollowerFollowing = FollowerFollowing
  { followerFollowingSweep :: FollowerFollowingSweep,
    followerFollowingStopped :: Integer,
    followerFollowingRefused :: Integer,
    followerFollowingStreamDrops :: Integer
  }
  deriving (Eq, Show)

instance FromJSON FollowerFollowing where parseJSON = checked "FollowerFollowing" $ withObject "FollowerFollowing" (\fields -> FollowerFollowing <$> (fields .: "sweep") <*> (fields .: "stopped") <*> (fields .: "refused") <*> (fields .: "streamDrops"))

instance ToJSON FollowerFollowing where toJSON value = Object (KM.fromList (concat [[("sweep", toJSON (followerFollowingSweep value))], [("stopped", toJSON (followerFollowingStopped value))], [("refused", toJSON (followerFollowingRefused value))], [("streamDrops", toJSON (followerFollowingStreamDrops value))]]))

data FollowerFollowingSweep = FollowerFollowingSweepPending | FollowerFollowingSweepRunning | FollowerFollowingSweepDone | FollowerFollowingSweepDue deriving (Eq, Show)

instance FromJSON FollowerFollowingSweep where parseJSON = checked "FollowerFollowingSweep" $ \value -> if value == String "pending" then pure FollowerFollowingSweepPending else if value == String "running" then pure FollowerFollowingSweepRunning else if value == String "done" then pure FollowerFollowingSweepDone else if value == String "due" then pure FollowerFollowingSweepDue else fail "unknown enumeration member"

instance ToJSON FollowerFollowingSweep where
  toJSON FollowerFollowingSweepPending = String "pending"
  toJSON FollowerFollowingSweepRunning = String "running"
  toJSON FollowerFollowingSweepDone = String "done"
  toJSON FollowerFollowingSweepDue = String "due"

followerFollowingSweepText :: FollowerFollowingSweep -> Text
followerFollowingSweepText FollowerFollowingSweepPending = "pending"
followerFollowingSweepText FollowerFollowingSweepRunning = "running"
followerFollowingSweepText FollowerFollowingSweepDone = "done"
followerFollowingSweepText FollowerFollowingSweepDue = "due"
