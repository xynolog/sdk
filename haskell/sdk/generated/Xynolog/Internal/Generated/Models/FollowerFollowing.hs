-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.FollowerFollowing (FollowerFollowing (..), FollowerFollowingSweep (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Xynolog.Internal.Codec

data FollowerFollowing = FollowerFollowing
  { followerFollowingRefused :: Integer,
    followerFollowingStopped :: Integer,
    followerFollowingStreamDrops :: Integer,
    followerFollowingSweep :: FollowerFollowingSweep
  }
  deriving (Eq, Show)

instance FromJSON FollowerFollowing where parseJSON = checked "FollowerFollowing" $ withObject "FollowerFollowing" (\fields -> FollowerFollowing <$> (fields .: "refused") <*> (fields .: "stopped") <*> (fields .: "streamDrops") <*> (fields .: "sweep"))

instance ToJSON FollowerFollowing where toJSON value = Object (KM.fromList (concat [[("refused", toJSON (followerFollowingRefused value))], [("stopped", toJSON (followerFollowingStopped value))], [("streamDrops", toJSON (followerFollowingStreamDrops value))], [("sweep", toJSON (followerFollowingSweep value))]]))

data FollowerFollowingSweep = FollowerFollowingSweepPending | FollowerFollowingSweepRunning | FollowerFollowingSweepDone | FollowerFollowingSweepDue deriving (Eq, Show)

instance FromJSON FollowerFollowingSweep where parseJSON = checked "FollowerFollowingSweep" $ \value -> if value == String "pending" then pure FollowerFollowingSweepPending else if value == String "running" then pure FollowerFollowingSweepRunning else if value == String "done" then pure FollowerFollowingSweepDone else if value == String "due" then pure FollowerFollowingSweepDue else fail "unknown enumeration member"

instance ToJSON FollowerFollowingSweep where
  toJSON FollowerFollowingSweepPending = String "pending"
  toJSON FollowerFollowingSweepRunning = String "running"
  toJSON FollowerFollowingSweepDone = String "done"
  toJSON FollowerFollowingSweepDue = String "due"
