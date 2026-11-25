-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.LinkingJobParams (LinkingJobParams (..), LinkingJobParamsMotivation (..), linkingJobParamsMotivationText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data LinkingJobParams = LinkingJobParams
  { linkingJobParamsMotivation :: LinkingJobParamsMotivation,
    linkingJobParamsEntityTypes :: [Text],
    linkingJobParamsIncludeDescriptiveReferences :: Maybe Bool,
    linkingJobParamsLanguage :: Maybe Text,
    linkingJobParamsSourceLanguage :: Maybe Text
  }
  deriving (Eq, Show)

instance FromJSON LinkingJobParams where parseJSON = checked "LinkingJobParams" $ withObject "LinkingJobParams" (\fields -> LinkingJobParams <$> (fields .: "motivation") <*> (fields .: "entityTypes") <*> optional fields "includeDescriptiveReferences" <*> optional fields "language" <*> optional fields "sourceLanguage")

instance ToJSON LinkingJobParams where toJSON value = Object (KM.fromList (concat [[("motivation", toJSON (linkingJobParamsMotivation value))], [("entityTypes", toJSON (linkingJobParamsEntityTypes value))], optionalPair "includeDescriptiveReferences" (linkingJobParamsIncludeDescriptiveReferences value), optionalPair "language" (linkingJobParamsLanguage value), optionalPair "sourceLanguage" (linkingJobParamsSourceLanguage value)]))

data LinkingJobParamsMotivation = LinkingJobParamsMotivationLinking deriving (Eq, Show)

instance FromJSON LinkingJobParamsMotivation where parseJSON = checked "LinkingJobParamsMotivation" $ \value -> if value == String "linking" then pure LinkingJobParamsMotivationLinking else fail "unknown enumeration member"

instance ToJSON LinkingJobParamsMotivation where toJSON LinkingJobParamsMotivationLinking = String "linking"

linkingJobParamsMotivationText :: LinkingJobParamsMotivation -> Text
linkingJobParamsMotivationText LinkingJobParamsMotivationLinking = "linking"
