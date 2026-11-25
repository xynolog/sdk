{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Codec
  ( Kind (..),
    Signature (..),
    admittedBy,
    checked,
    optional,
    optionalPair,
    readMember,
    withoutFields,
  )
where

import Data.Aeson (FromJSON (..), Object, ToJSON (..), Value (..))
import Data.Aeson.Key (Key)
import Data.Aeson.KeyMap qualified as KM
import Data.Aeson.Types (Parser)
import Data.Scientific (isInteger)
import Data.Text (Text)
import Data.Text qualified as T
import Xynolog.Internal.Generated.Schemas (schemas)
import Xynolog.Internal.Schema (matchesPattern, validateNamed)

checked :: Text -> (Value -> Parser value) -> Value -> Parser value
checked name parser value = either fail pure (validateNamed schemas name value) >> parser value

optional :: (FromJSON value) => Object -> Key -> Parser (Maybe value)
optional fields key = traverse parseJSON (KM.lookup key fields)

optionalPair :: (ToJSON value) => Key -> Maybe value -> [(Key, Value)]
optionalPair key = maybe [] (\value -> [(key, toJSON value)])

withoutFields :: [Key] -> KM.KeyMap value -> KM.KeyMap value
withoutFields names = KM.filterWithKey (\key _ -> key `notElem` names)

data Kind = TextKind | IntegerKind | NumberKind | BooleanKind | ListKind | ObjectKind | NullKind | AnyKind
  deriving (Eq, Show)

-- | What a union's member admits, as its schema states it: the kind of
-- value, the members an object of it requires, every member it allows if it
-- is closed, the values a member may take, the pattern text matches, and
-- every value it admits if it says.
data Signature = Signature
  { signatureKind :: Kind,
    signatureRequired :: [Key],
    signatureAllowed :: Maybe [Key],
    signatureFixed :: [(Key, [Value])],
    signaturePattern :: Maybe Text,
    signatureValues :: Maybe [Value]
  }
  deriving (Eq, Show)

ofKind :: Kind -> Value -> Bool
ofKind AnyKind _ = True
ofKind TextKind (String _) = True
ofKind IntegerKind (Number number) = isInteger number
ofKind NumberKind (Number _) = True
ofKind BooleanKind (Bool _) = True
ofKind ListKind (Array _) = True
ofKind ObjectKind (Object _) = True
ofKind NullKind Null = True
ofKind _ _ = False

-- | Whether the signature admits the value; a pattern Protocol states that
-- cannot be read is said.
admittedBy :: Signature -> Value -> Either String Bool
admittedBy signature value = do
  matched <- case (signaturePattern signature, value) of
    (Just expression, String text) -> matchesPattern expression text
    _ -> Right True
  pure
    ( matched
        && ofKind (signatureKind signature) value
        && maybe True (elem value) (signatureValues signature)
        && case value of
          Object members ->
            all (`KM.member` members) (signatureRequired signature)
              && maybe True (\allowed -> all (`elem` allowed) (KM.keys members)) (signatureAllowed signature)
              && all (\(name, values) -> maybe True (`elem` values) (KM.lookup name members)) (signatureFixed signature)
          _ -> True
    )

-- | The union @name@'s value read as the member whose signatures admit it.
-- The union's members admit no value in common, so no other could.
readMember :: Text -> [([Signature], Parser value)] -> Value -> Parser value
readMember name members value = either fail id (chosen members)
  where
    chosen [] = Left ("no member of " <> T.unpack name <> " admits the value")
    chosen ((signatures, parser) : rest) = do
      admitted <- or <$> traverse (`admittedBy` value) signatures
      if admitted then Right parser else chosen rest
