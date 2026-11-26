-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.IdentifiersKinds (IdentifiersKinds (..), IdentifiersKindsKindsItem (..), IdentifiersKindsKindsItemAcceptsItem (..), IdentifiersKindsKindsItemRefusesItem (..), IdentifiersKindsOthersItem (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data IdentifiersKinds = IdentifiersKinds
  { identifiersKindsComment :: Text,
    identifiersKindsKinds :: [IdentifiersKindsKindsItem],
    identifiersKindsOthers :: [IdentifiersKindsOthersItem]
  }
  deriving (Eq, Show)

instance FromJSON IdentifiersKinds where parseJSON = checked "IdentifiersKinds" $ withObject "IdentifiersKinds" (\fields -> IdentifiersKinds <$> (fields .: "$comment") <*> (fields .: "kinds") <*> (fields .: "others"))

instance ToJSON IdentifiersKinds where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (identifiersKindsComment value))], [("kinds", toJSON (identifiersKindsKinds value))], [("others", toJSON (identifiersKindsOthers value))]]))

data IdentifiersKindsKindsItem = IdentifiersKindsKindsItem
  { identifiersKindsKindsItemSchema :: Text,
    identifiersKindsKindsItemProperties :: [Text],
    identifiersKindsKindsItemAccepts :: [IdentifiersKindsKindsItemAcceptsItem],
    identifiersKindsKindsItemRefuses :: [IdentifiersKindsKindsItemRefusesItem]
  }
  deriving (Eq, Show)

instance FromJSON IdentifiersKindsKindsItem where parseJSON = checked "IdentifiersKindsKindsItem" $ withObject "IdentifiersKindsKindsItem" (\fields -> IdentifiersKindsKindsItem <$> (fields .: "schema") <*> (fields .: "properties") <*> (fields .: "accepts") <*> (fields .: "refuses"))

instance ToJSON IdentifiersKindsKindsItem where toJSON value = Object (KM.fromList (concat [[("schema", toJSON (identifiersKindsKindsItemSchema value))], [("properties", toJSON (identifiersKindsKindsItemProperties value))], [("accepts", toJSON (identifiersKindsKindsItemAccepts value))], [("refuses", toJSON (identifiersKindsKindsItemRefuses value))]]))

data IdentifiersKindsKindsItemAcceptsItem = IdentifiersKindsKindsItemAcceptsItem
  { identifiersKindsKindsItemAcceptsItemId :: Text,
    identifiersKindsKindsItemAcceptsItemWhy :: Text
  }
  deriving (Eq, Show)

instance FromJSON IdentifiersKindsKindsItemAcceptsItem where parseJSON = checked "IdentifiersKindsKindsItemAcceptsItem" $ withObject "IdentifiersKindsKindsItemAcceptsItem" (\fields -> IdentifiersKindsKindsItemAcceptsItem <$> (fields .: "id") <*> (fields .: "why"))

instance ToJSON IdentifiersKindsKindsItemAcceptsItem where toJSON value = Object (KM.fromList (concat [[("id", toJSON (identifiersKindsKindsItemAcceptsItemId value))], [("why", toJSON (identifiersKindsKindsItemAcceptsItemWhy value))]]))

data IdentifiersKindsKindsItemRefusesItem = IdentifiersKindsKindsItemRefusesItem
  { identifiersKindsKindsItemRefusesItemId :: Text,
    identifiersKindsKindsItemRefusesItemWhy :: Text
  }
  deriving (Eq, Show)

instance FromJSON IdentifiersKindsKindsItemRefusesItem where parseJSON = checked "IdentifiersKindsKindsItemRefusesItem" $ withObject "IdentifiersKindsKindsItemRefusesItem" (\fields -> IdentifiersKindsKindsItemRefusesItem <$> (fields .: "id") <*> (fields .: "why"))

instance ToJSON IdentifiersKindsKindsItemRefusesItem where toJSON value = Object (KM.fromList (concat [[("id", toJSON (identifiersKindsKindsItemRefusesItemId value))], [("why", toJSON (identifiersKindsKindsItemRefusesItemWhy value))]]))

data IdentifiersKindsOthersItem = IdentifiersKindsOthersItem
  { identifiersKindsOthersItemProperty :: Text,
    identifiersKindsOthersItemDocs :: Text
  }
  deriving (Eq, Show)

instance FromJSON IdentifiersKindsOthersItem where parseJSON = checked "IdentifiersKindsOthersItem" $ withObject "IdentifiersKindsOthersItem" (\fields -> IdentifiersKindsOthersItem <$> (fields .: "property") <*> (fields .: "docs"))

instance ToJSON IdentifiersKindsOthersItem where toJSON value = Object (KM.fromList (concat [[("property", toJSON (identifiersKindsOthersItemProperty value))], [("docs", toJSON (identifiersKindsOthersItemDocs value))]]))
