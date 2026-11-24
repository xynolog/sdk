-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.RepresentationNotFound (RepresentationNotFound (..), RepresentationNotFoundCode (..), representationNotFoundCodeText) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data RepresentationNotFound = RepresentationNotFound
  { representationNotFoundCode :: RepresentationNotFoundCode,
    representationNotFoundDetails :: Maybe Value,
    representationNotFoundError :: Text,
    representationNotFoundHint :: Maybe Text,
    representationNotFoundAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON RepresentationNotFound where parseJSON = checked "RepresentationNotFound" $ withObject "RepresentationNotFound" (\fields -> RepresentationNotFound <$> (fields .: "code") <*> optional fields "details" <*> (fields .: "error") <*> optional fields "hint" <*> traverse parseJSON (withoutFields ["code", "details", "error", "hint"] fields))

instance ToJSON RepresentationNotFound where toJSON value = Object (KM.fromList (concat [[("code", toJSON (representationNotFoundCode value))], optionalPair "details" (representationNotFoundDetails value), [("error", toJSON (representationNotFoundError value))], optionalPair "hint" (representationNotFoundHint value)]) <> fmap toJSON (withoutFields ["code", "details", "error", "hint"] (representationNotFoundAdditionalProperties value)))

data RepresentationNotFoundCode = RepresentationNotFoundCodeResource | RepresentationNotFoundCodeRepresentation deriving (Eq, Show)

instance FromJSON RepresentationNotFoundCode where parseJSON = checked "RepresentationNotFoundCode" $ \value -> if value == String "resource" then pure RepresentationNotFoundCodeResource else if value == String "representation" then pure RepresentationNotFoundCodeRepresentation else fail "unknown enumeration member"

instance ToJSON RepresentationNotFoundCode where
  toJSON RepresentationNotFoundCodeResource = String "resource"
  toJSON RepresentationNotFoundCodeRepresentation = String "representation"

representationNotFoundCodeText :: RepresentationNotFoundCode -> Text
representationNotFoundCodeText RepresentationNotFoundCodeResource = "resource"
representationNotFoundCodeText RepresentationNotFoundCodeRepresentation = "representation"
