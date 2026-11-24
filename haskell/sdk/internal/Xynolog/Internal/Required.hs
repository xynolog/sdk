{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Xynolog.Internal.Required (Fault (..), FaultReason (..), Shape, walk, faultOf, faultChannel, faultSaid, undecoded, channelValue, channelRead, faultHttp) where

import Control.Applicative ((<|>))
import Control.Monad (unless)
import Data.Aeson (FromJSON (..), Value (..), eitherDecodeStrict', withObject, (.!=), (.:), (.:?))
import Data.Aeson.Key qualified as Key
import Data.Aeson.KeyMap qualified as KM
import Data.Aeson.Types (Object, Parser)
import Data.Char (ord)
import Data.Foldable (toList)
import Data.List (sortOn)
import Data.Map.Strict qualified as Map
import Data.Maybe (fromMaybe, isJust, listToMaybe, mapMaybe)
import Data.Scientific (Scientific, floatingOrInteger)
import Data.Text (Text)
import Data.Text qualified as Text
import Data.Text.Encoding (encodeUtf8)
import Data.Vector qualified as Vector
import Xynolog.Internal.Generated.Required (shapesJSON)

data FaultReason = Lacks | Malformed deriving (Eq, Show)

data Fault = Fault {member :: Text, reason :: FaultReason} deriving (Eq, Show)

undecoded :: Fault
undecoded = Fault "" Malformed

faultSaid :: Fault -> Text
faultSaid (Fault way Lacks) = "it has no `" <> way <> "`"
faultSaid (Fault "" Malformed) = "it is malformed"
faultSaid (Fault way Malformed) = "its `" <> way <> "` is malformed"

-- | One term of a pattern, repeated at least its least and at most its most
-- times (Nothing: any number): a step, a text's next code point in one of its
-- ranges; or a group, the text's next code points one of its alternatives.
data Term = Step [(Int, Int)] Int (Maybe Int) | Group [[Term]] Int (Maybe Int)

data Discriminator = Discriminator Text (Map.Map Text Int)

data Shape = Shape
  { shapeRef :: Maybe Text,
    shapeKinds :: Maybe [Text],
    shapeEnum :: Maybe [Value],
    recognized :: Maybe [Text],
    shapePattern :: Maybe [Term],
    minLength :: Maybe Integer,
    maxLength :: Maybe Integer,
    minimumValue :: Maybe Scientific,
    maximumValue :: Maybe Scientific,
    minItems :: Maybe Integer,
    maxItems :: Maybe Integer,
    required :: [Text],
    members :: [(Text, Shape)],
    closed :: Maybe [Text],
    items :: Maybe Shape,
    values :: Maybe Shape,
    oneOf :: Maybe [Shape],
    discriminator :: Maybe Discriminator,
    allOf :: [Shape],
    notAll :: [[Text]],
    minMembers :: Maybe Integer,
    shapeNames :: Maybe Shape
  }

data Tables = Tables (Map.Map Text Shape) (Map.Map Text Shape) (Map.Map Text Shape)

only :: [Text] -> Object -> Parser ()
only allowed fields =
  let unread = filter (`notElem` allowed) (map Key.toText (KM.keys fields))
   in unless (null unread) (fail ("required-shape table gained an unread field: " ++ show unread))

instance FromJSON Term where
  parseJSON = withObject "required pattern term" $ \fields -> do
    only ["of", "either", "min", "max"] fields
    ranges <- fields .:? "of"
    alternatives <- fields .:? "either"
    least <- fields .: "min"
    most <- fields .:? "max"
    case (ranges, alternatives) of
      (Just stepRanges, Nothing) -> pure (Step stepRanges least most)
      (Nothing, Just groupAlternatives) -> pure (Group groupAlternatives least most)
      _ -> fail "a required pattern term is a step or a group"

instance FromJSON Discriminator where
  parseJSON = withObject "required discriminator" $ \fields -> do
    only ["property", "mapping"] fields
    Discriminator <$> fields .: "property" <*> fields .: "mapping"

instance FromJSON Shape where
  parseJSON = withObject "required shape" $ \fields -> do
    only ["ref", "kinds", "enum", "recognized", "pattern", "minLength", "maxLength", "minimum", "maximum", "minItems", "maxItems", "required", "members", "closed", "items", "values", "oneOf", "discriminator", "allOf", "notAll", "minMembers", "names"] fields
    kinds <- fields .:? "kinds"
    unless
      (maybe True (all (`elem` (["object", "array", "string", "integer", "number", "boolean", "null"] :: [Text]))) kinds)
      (fail "required-shape table gained an unread kind")
    Shape
      <$> fields .:? "ref"
      <*> pure kinds
      <*> fields .:? "enum"
      <*> fields .:? "recognized"
      <*> fields .:? "pattern"
      <*> fields .:? "minLength"
      <*> fields .:? "maxLength"
      <*> fields .:? "minimum"
      <*> fields .:? "maximum"
      <*> fields .:? "minItems"
      <*> fields .:? "maxItems"
      <*> fields .:? "required" .!= []
      <*> fields .:? "members" .!= []
      <*> fields .:? "closed"
      <*> fields .:? "items"
      <*> fields .:? "values"
      <*> fields .:? "oneOf"
      <*> fields .:? "discriminator"
      <*> fields .:? "allOf" .!= []
      <*> fields .:? "notAll" .!= []
      <*> fields .:? "minMembers"
      <*> fields .:? "names"

instance FromJSON Tables where
  parseJSON = withObject "required tables" $ \fields -> do
    only ["schemas", "channels", "http"] fields
    Tables <$> fields .: "schemas" <*> fields .: "channels" <*> fields .: "http"

tables :: Tables
tables = either (error . ("invalid generated required-shape table: " ++)) id (eitherDecodeStrict' (encodeUtf8 shapesJSON))

lookupShape :: Text -> Map.Map Text Shape -> Shape
lookupShape name = fromMaybe (error ("unknown generated required shape: " ++ Text.unpack name)) . Map.lookup name

resolved :: Shape -> Shape
resolved shape = case shapeRef shape of
  Nothing -> shape
  Just name -> let Tables schemas _ _ = tables in resolved (lookupShape name schemas)

allows :: Shape -> Value -> Bool
allows shape value = case shapeKinds (resolved shape) of
  Nothing -> True
  Just kinds -> case value of
    Object _ -> "object" `elem` kinds
    Array _ -> "array" `elem` kinds
    String _ -> "string" `elem` kinds
    Bool _ -> "boolean" `elem` kinds
    Null -> "null" `elem` kinds
    Number n -> "number" `elem` kinds || ("integer" `elem` kinds && case floatingOrInteger n :: Either Double Integer of Right _ -> True; Left _ -> False)

within :: Text -> Text -> Text
within "" name = name
within way name = way <> "." <> name

bounded :: (Ord number) => Maybe number -> number -> Maybe number -> Bool
bounded low value high = maybe True (<= value) low && maybe True (>= value) high

-- | Whether text, from offset at, is of terms, with rest taking what is left
-- after them: a step takes as many code points as it may and gives them back
-- one by one, and a group repeats as often as it may and gives repetitions
-- back the same way, until rest takes what is left.
series :: [Term] -> Int -> String -> (Int -> String -> Bool) -> Bool
series [] at text rest = rest at text
series (term : terms) at text rest = case term of
  Step ranges least most ->
    let taken = length (takeWhile (\character -> any (\(low, high) -> low <= ord character && ord character <= high) ranges) (maybe text (`take` text) most))
     in any (\count -> next (at + count) (drop count text)) [taken, taken - 1 .. least]
  Group alternatives least most -> repeated alternatives least most 0 at text next
  where
    next after left = series terms after left rest

-- | Whether text, from offset at, is of a group's alternatives repeated once
-- more than count times or more, then of next: a repetition past the group's
-- least takes at least one code point.
repeated :: [[Term]] -> Int -> Maybe Int -> Int -> Int -> String -> (Int -> String -> Bool) -> Bool
repeated alternatives least most count at text next =
  (maybe True (count <) most && any (\alternative -> series alternative at text again) alternatives)
    || (count >= least && next at text)
  where
    again after left = (count < least || after > at) && repeated alternatives least most (count + 1) after left next

stated :: Shape -> Value -> Bool
stated shape value =
  maybe True (value `elem`) (shapeEnum shape) && case value of
    String text ->
      bounded (minLength shape) (fromIntegral (Text.length text)) (maxLength shape)
        && maybe True (\terms -> series terms 0 (Text.unpack text) (\_ left -> null left)) (shapePattern shape)
    Number n -> bounded (minimumValue shape) n (maximumValue shape)
    Array array -> bounded (minItems shape) (fromIntegral (Vector.length array)) (maxItems shape)
    Object fields -> bounded (minMembers shape) (fromIntegral (KM.size fields)) Nothing
    _ -> True

first :: [Maybe value] -> Maybe value
first = foldr (<|>) Nothing

-- | A value's first fault against a shape, the value being at the way given
-- (empty for a value that is no member).
walk :: Shape -> Value -> Text -> Maybe Fault
walk original value way
  | not (allows own value && stated own value) = Just (Fault way Malformed)
  | otherwise = objectFault <|> arrayFault <|> unionFault <|> first [walk part value way | part <- allOf own]
  where
    own = resolved original
    objectFault = case value of
      Object fields ->
        let absent =
              [ Fault (within way name) Lacks
              | name <- required own,
                case KM.lookup (Key.fromText name) fields of
                  Nothing -> True
                  Just Null -> maybe False (not . (`allows` Null)) (lookup name (members own))
                  Just _ -> False
              ]
            memberFaults =
              [ walk shape actual (within way name)
              | (name, shape) <- members own,
                Just actual <- [KM.lookup (Key.fromText name) fields],
                actual /= Null
              ]
            named = sortOn id (map Key.toText (KM.keys fields))
            unknown = case closed own of
              Nothing -> []
              Just allowed -> [Fault (within way name) Malformed | name <- named, name `notElem` allowed]
            misnamed = case shapeNames own of
              Nothing -> []
              Just shape -> [Fault (within way name) Malformed | name <- named, isJust (walk shape (String name) "")]
            carried = [Fault way Malformed | set <- notAll own, all (\name -> KM.member (Key.fromText name) fields) set]
            valueFaults = case values own of
              Nothing -> []
              Just shape -> [walk shape actual way | (_, actual) <- sortOn (Key.toText . fst) (KM.toList fields)]
         in listToMaybe absent <|> first memberFaults <|> listToMaybe unknown <|> listToMaybe misnamed <|> listToMaybe carried <|> first valueFaults
      _ -> Nothing
    arrayFault = case (value, items own) of
      (Array list, Just shape) -> first [walk shape actual way | actual <- toList list]
      _ -> Nothing
    unionFault = case oneOf own of
      Nothing -> Nothing
      Just variants ->
        let candidates = case (value, discriminator own) of
              (Object fields, Just (Discriminator property mapping))
                | Just (String tag) <- KM.lookup (Key.fromText property) fields,
                  Just index <- Map.lookup tag mapping ->
                    if index < 0 || index >= length variants then error "invalid generated discriminator index" else [variants !! index]
              _ -> filter (`allows` value) variants
            faults = map (\candidate -> walk candidate value way) candidates
         in case candidates of
              [] -> Just (Fault way Malformed)
              _
                | any (== Nothing) faults -> Nothing
                | otherwise -> case mapMaybe id faults of fault : _ -> Just fault; [] -> error "union fault disappeared"

faultOf :: Text -> Value -> Maybe Fault
faultOf name value = let Tables schemas _ _ = tables in walk (lookupShape name schemas) value ""

faultChannel :: Text -> Value -> Maybe Fault
faultChannel name value = let Tables _ channels _ = tables in walk (lookupShape name channels) (channelValue name value) ""

-- | What a channel's typed reader decodes: its payload as read, without the
-- members its shape does not declare that start with an underscore.
channelValue :: Text -> Value -> Value
channelValue name (Object fields) =
  let Tables _ channels _ = tables
      shape = lookupShape name channels
      declared original =
        let own = resolved original
         in map fst (members own)
              ++ concatMap declared (fromMaybe [] (oneOf own) ++ allOf own)
      names = declared shape
   in Object (KM.filterWithKey (\key _ -> let text = Key.toText key in not (Text.isPrefixOf "_" text) || text `elem` names) (readObject shape fields))
channelValue _ value = value

-- | A channel's payload as its reader reads it.
channelRead :: Text -> Object -> Object
channelRead name = let Tables _ channels _ = tables in readObject (lookupShape name channels)

-- | An object as a reader reads it: a member whose shape names the texts it
-- is read as (`recognized`), and that holds a text none of them, is left out.
readObject :: Shape -> Object -> Object
readObject original = KM.mapMaybeWithKey kept
  where
    described shape = let own = resolved shape in members own ++ concatMap described (allOf own)
    shapes = described original
    kept key actual = case lookup (Key.toText key) shapes of
      Just shape | Just texts <- recognized (resolved shape), String text <- actual, text `notElem` texts -> Nothing
      Just shape -> Just (readValue shape actual)
      Nothing -> Just actual

readValue :: Shape -> Value -> Value
readValue shape (Object fields) = Object (readObject shape fields)
readValue shape (Array list) | Just inner <- items (resolved shape) = Array (fmap (readValue inner) list)
readValue _ value = value

faultHttp :: Text -> Value -> Maybe Fault
faultHttp name value = let Tables _ _ http = tables in walk (lookupShape name http) value ""
