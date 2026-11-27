-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ControlRpcCodes (ControlRpcCodes (..), ControlRpcCodesCodesItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ErrorData

data ControlRpcCodes = ControlRpcCodes
  { controlRpcCodesComment :: Text,
    controlRpcCodesCodes :: [ControlRpcCodesCodesItem]
  }
  deriving (Eq, Show)

instance FromJSON ControlRpcCodes where parseJSON = checked "ControlRpcCodes" $ withObject "ControlRpcCodes" (\fields -> ControlRpcCodes <$> (fields .: "$comment") <*> (fields .: "codes"))

instance ToJSON ControlRpcCodes where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (controlRpcCodesComment value))], [("codes", toJSON (controlRpcCodesCodes value))]]))

data ControlRpcCodesCodesItem = ControlRpcCodesCodesItem
  { controlRpcCodesCodesItemNumber :: Integer,
    controlRpcCodesCodesItemName :: Text,
    controlRpcCodesCodesItemDocs :: Text,
    controlRpcCodesCodesItemData :: Maybe ErrorData
  }
  deriving (Eq, Show)

instance FromJSON ControlRpcCodesCodesItem where parseJSON = checked "ControlRpcCodesCodesItem" $ withObject "ControlRpcCodesCodesItem" (\fields -> ControlRpcCodesCodesItem <$> (fields .: "number") <*> (fields .: "name") <*> (fields .: "docs") <*> optional fields "data")

instance ToJSON ControlRpcCodesCodesItem where toJSON value = Object (KM.fromList (concat [[("number", toJSON (controlRpcCodesCodesItemNumber value))], [("name", toJSON (controlRpcCodesCodesItemName value))], [("docs", toJSON (controlRpcCodesCodesItemDocs value))], optionalPair "data" (controlRpcCodesCodesItemData value)]))
