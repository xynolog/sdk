{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Codec
  ( checked,
    optional,
    optionalPair,
    withoutFields,
  )
where

import Data.Aeson (FromJSON (..), Object, ToJSON (..), Value)
import Data.Aeson.Key (Key)
import Data.Aeson.KeyMap qualified as KM
import Data.Aeson.Types (Parser)
import Data.Text (Text)
import Xynolog.Internal.Generated.Schemas (schemas)
import Xynolog.Internal.Schema (validateNamed)

checked :: Text -> (Value -> Parser value) -> Value -> Parser value
checked name parser value = either fail pure (validateNamed schemas name value) >> parser value

optional :: (FromJSON value) => Object -> Key -> Parser (Maybe value)
optional fields key = traverse parseJSON (KM.lookup key fields)

optionalPair :: (ToJSON value) => Key -> Maybe value -> [(Key, Value)]
optionalPair key = maybe [] (\value -> [(key, toJSON value)])

withoutFields :: [Key] -> KM.KeyMap value -> KM.KeyMap value
withoutFields names = KM.filterWithKey (\key _ -> key `notElem` names)
