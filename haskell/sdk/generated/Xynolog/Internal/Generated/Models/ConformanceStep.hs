-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ConformanceStep (ConformanceStep (..), ConformanceStepBranch10Value (..), ConformanceStepBranch10ValueStays (..), ConformanceStepBranch11Value (..), ConformanceStepBranch12Value (..), ConformanceStepBranch13Value (..), ConformanceStepBranch14Value (..), ConformanceStepBranch14ValueBackend (..), ConformanceStepBranch14ValueWith (..), ConformanceStepBranch15Value (..), ConformanceStepBranch16Value (..), ConformanceStepBranch16ValueObserve (..), ConformanceStepBranch17Value (..), ConformanceStepBranch18Value (..), ConformanceStepBranch19Value (..), ConformanceStepBranch1Value (..), ConformanceStepBranch1ValueLet (..), ConformanceStepBranch20Value (..), ConformanceStepBranch23Value (..), ConformanceStepBranch23ValueFetchesItem (..), ConformanceStepBranch24Value (..), ConformanceStepBranch25Value (..), ConformanceStepBranch26Value (..), ConformanceStepBranch27Value (..), ConformanceStepBranch28Value (..), ConformanceStepBranch2Value (..), ConformanceStepBranch2ValueWith (..), ConformanceStepBranch3Value (..), ConformanceStepBranch4Value (..), ConformanceStepBranch4ValueAbandoned (..), ConformanceStepBranch5Value (..), ConformanceStepBranch5ValueAt (..), ConformanceStepBranch5ValueHeaders (..), ConformanceStepBranch6Value (..), ConformanceStepBranch7Value (..), ConformanceStepBranch8Value (..), ConformanceStepBranch9Value (..), ConformanceStepBranch9ValueState (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.ConformanceBusFetch
import Xynolog.Internal.Generated.Models.ConformanceHttpFetch

data ConformanceStep = ConformanceStepBranch1 ConformanceStepBranch1Value | ConformanceStepBranch2 ConformanceStepBranch2Value | ConformanceStepBranch3 ConformanceStepBranch3Value | ConformanceStepBranch4 ConformanceStepBranch4Value | ConformanceStepBranch5 ConformanceStepBranch5Value | ConformanceStepBranch6 ConformanceStepBranch6Value | ConformanceStepBranch7 ConformanceStepBranch7Value | ConformanceStepBranch8 ConformanceStepBranch8Value | ConformanceStepBranch9 ConformanceStepBranch9Value | ConformanceStepBranch10 ConformanceStepBranch10Value | ConformanceStepBranch11 ConformanceStepBranch11Value | ConformanceStepBranch12 ConformanceStepBranch12Value | ConformanceStepBranch13 ConformanceStepBranch13Value | ConformanceStepBranch14 ConformanceStepBranch14Value | ConformanceStepBranch15 ConformanceStepBranch15Value | ConformanceStepBranch16 ConformanceStepBranch16Value | ConformanceStepBranch17 ConformanceStepBranch17Value | ConformanceStepBranch18 ConformanceStepBranch18Value | ConformanceStepBranch19 ConformanceStepBranch19Value | ConformanceStepBranch20 ConformanceStepBranch20Value | ConformanceStepBranch21 ConformanceBusFetch | ConformanceStepBranch22 ConformanceHttpFetch | ConformanceStepBranch23 ConformanceStepBranch23Value | ConformanceStepBranch24 ConformanceStepBranch24Value | ConformanceStepBranch25 ConformanceStepBranch25Value | ConformanceStepBranch26 ConformanceStepBranch26Value | ConformanceStepBranch27 ConformanceStepBranch27Value | ConformanceStepBranch28 ConformanceStepBranch28Value deriving (Eq, Show)

instance FromJSON ConformanceStep where parseJSON = checked "ConformanceStep" $ \value -> (ConformanceStepBranch1 <$> parseJSON value) <|> (ConformanceStepBranch2 <$> parseJSON value) <|> (ConformanceStepBranch3 <$> parseJSON value) <|> (ConformanceStepBranch4 <$> parseJSON value) <|> (ConformanceStepBranch5 <$> parseJSON value) <|> (ConformanceStepBranch6 <$> parseJSON value) <|> (ConformanceStepBranch7 <$> parseJSON value) <|> (ConformanceStepBranch8 <$> parseJSON value) <|> (ConformanceStepBranch9 <$> parseJSON value) <|> (ConformanceStepBranch10 <$> parseJSON value) <|> (ConformanceStepBranch11 <$> parseJSON value) <|> (ConformanceStepBranch12 <$> parseJSON value) <|> (ConformanceStepBranch13 <$> parseJSON value) <|> (ConformanceStepBranch14 <$> parseJSON value) <|> (ConformanceStepBranch15 <$> parseJSON value) <|> (ConformanceStepBranch16 <$> parseJSON value) <|> (ConformanceStepBranch17 <$> parseJSON value) <|> (ConformanceStepBranch18 <$> parseJSON value) <|> (ConformanceStepBranch19 <$> parseJSON value) <|> (ConformanceStepBranch20 <$> parseJSON value) <|> (ConformanceStepBranch21 <$> parseJSON value) <|> (ConformanceStepBranch22 <$> parseJSON value) <|> (ConformanceStepBranch23 <$> parseJSON value) <|> (ConformanceStepBranch24 <$> parseJSON value) <|> (ConformanceStepBranch25 <$> parseJSON value) <|> (ConformanceStepBranch26 <$> parseJSON value) <|> (ConformanceStepBranch27 <$> parseJSON value) <|> (ConformanceStepBranch28 <$> parseJSON value)

instance ToJSON ConformanceStep where
  toJSON (ConformanceStepBranch1 value) = toJSON value
  toJSON (ConformanceStepBranch2 value) = toJSON value
  toJSON (ConformanceStepBranch3 value) = toJSON value
  toJSON (ConformanceStepBranch4 value) = toJSON value
  toJSON (ConformanceStepBranch5 value) = toJSON value
  toJSON (ConformanceStepBranch6 value) = toJSON value
  toJSON (ConformanceStepBranch7 value) = toJSON value
  toJSON (ConformanceStepBranch8 value) = toJSON value
  toJSON (ConformanceStepBranch9 value) = toJSON value
  toJSON (ConformanceStepBranch10 value) = toJSON value
  toJSON (ConformanceStepBranch11 value) = toJSON value
  toJSON (ConformanceStepBranch12 value) = toJSON value
  toJSON (ConformanceStepBranch13 value) = toJSON value
  toJSON (ConformanceStepBranch14 value) = toJSON value
  toJSON (ConformanceStepBranch15 value) = toJSON value
  toJSON (ConformanceStepBranch16 value) = toJSON value
  toJSON (ConformanceStepBranch17 value) = toJSON value
  toJSON (ConformanceStepBranch18 value) = toJSON value
  toJSON (ConformanceStepBranch19 value) = toJSON value
  toJSON (ConformanceStepBranch20 value) = toJSON value
  toJSON (ConformanceStepBranch21 value) = toJSON value
  toJSON (ConformanceStepBranch22 value) = toJSON value
  toJSON (ConformanceStepBranch23 value) = toJSON value
  toJSON (ConformanceStepBranch24 value) = toJSON value
  toJSON (ConformanceStepBranch25 value) = toJSON value
  toJSON (ConformanceStepBranch26 value) = toJSON value
  toJSON (ConformanceStepBranch27 value) = toJSON value
  toJSON (ConformanceStepBranch28 value) = toJSON value

data ConformanceStepBranch10Value = ConformanceStepBranch10Value
  { conformanceStepBranch10ValueStays :: ConformanceStepBranch10ValueStays
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch10Value where parseJSON = checked "ConformanceStepBranch10Value" $ withObject "ConformanceStepBranch10Value" (\fields -> ConformanceStepBranch10Value <$> (fields .: "stays"))

instance ToJSON ConformanceStepBranch10Value where toJSON value = Object (KM.fromList (concat [[("stays", toJSON (conformanceStepBranch10ValueStays value))]]))

data ConformanceStepBranch10ValueStays = ConformanceStepBranch10ValueStaysInitial | ConformanceStepBranch10ValueStaysConnecting | ConformanceStepBranch10ValueStaysOpen | ConformanceStepBranch10ValueStaysReconnecting | ConformanceStepBranch10ValueStaysDegraded | ConformanceStepBranch10ValueStaysUnauthenticated | ConformanceStepBranch10ValueStaysClosed deriving (Eq, Show)

instance FromJSON ConformanceStepBranch10ValueStays where parseJSON = checked "ConformanceStepBranch10ValueStays" $ \value -> if value == String "initial" then pure ConformanceStepBranch10ValueStaysInitial else if value == String "connecting" then pure ConformanceStepBranch10ValueStaysConnecting else if value == String "open" then pure ConformanceStepBranch10ValueStaysOpen else if value == String "reconnecting" then pure ConformanceStepBranch10ValueStaysReconnecting else if value == String "degraded" then pure ConformanceStepBranch10ValueStaysDegraded else if value == String "unauthenticated" then pure ConformanceStepBranch10ValueStaysUnauthenticated else if value == String "closed" then pure ConformanceStepBranch10ValueStaysClosed else fail "unknown enumeration member"

instance ToJSON ConformanceStepBranch10ValueStays where
  toJSON ConformanceStepBranch10ValueStaysInitial = String "initial"
  toJSON ConformanceStepBranch10ValueStaysConnecting = String "connecting"
  toJSON ConformanceStepBranch10ValueStaysOpen = String "open"
  toJSON ConformanceStepBranch10ValueStaysReconnecting = String "reconnecting"
  toJSON ConformanceStepBranch10ValueStaysDegraded = String "degraded"
  toJSON ConformanceStepBranch10ValueStaysUnauthenticated = String "unauthenticated"
  toJSON ConformanceStepBranch10ValueStaysClosed = String "closed"

data ConformanceStepBranch11Value = ConformanceStepBranch11Value
  { conformanceStepBranch11ValueFrame :: Text,
    conformanceStepBranch11ValueIs :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch11Value where parseJSON = checked "ConformanceStepBranch11Value" $ withObject "ConformanceStepBranch11Value" (\fields -> ConformanceStepBranch11Value <$> (fields .: "frame") <*> (fields .: "is"))

instance ToJSON ConformanceStepBranch11Value where toJSON value = Object (KM.fromList (concat [[("frame", toJSON (conformanceStepBranch11ValueFrame value))], [("is", toJSON (conformanceStepBranch11ValueIs value))]]))

data ConformanceStepBranch12Value = ConformanceStepBranch12Value
  { conformanceStepBranch12ValueCount :: Integer,
    conformanceStepBranch12ValueFrames :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch12Value where parseJSON = checked "ConformanceStepBranch12Value" $ withObject "ConformanceStepBranch12Value" (\fields -> ConformanceStepBranch12Value <$> (fields .: "count") <*> (fields .: "frames"))

instance ToJSON ConformanceStepBranch12Value where toJSON value = Object (KM.fromList (concat [[("count", toJSON (conformanceStepBranch12ValueCount value))], [("frames", toJSON (conformanceStepBranch12ValueFrames value))]]))

data ConformanceStepBranch13Value = ConformanceStepBranch13Value
  { conformanceStepBranch13ValueError :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch13Value where parseJSON = checked "ConformanceStepBranch13Value" $ withObject "ConformanceStepBranch13Value" (\fields -> ConformanceStepBranch13Value <$> (fields .: "error"))

instance ToJSON ConformanceStepBranch13Value where toJSON value = Object (KM.fromList (concat [[("error", toJSON (conformanceStepBranch13ValueError value))]]))

data ConformanceStepBranch14Value = ConformanceStepBranch14Value
  { conformanceStepBranch14ValueBackend :: ConformanceStepBranch14ValueBackend,
    conformanceStepBranch14ValueWith :: Maybe ConformanceStepBranch14ValueWith
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch14Value where parseJSON = checked "ConformanceStepBranch14Value" $ withObject "ConformanceStepBranch14Value" (\fields -> ConformanceStepBranch14Value <$> (fields .: "backend") <*> optional fields "with")

instance ToJSON ConformanceStepBranch14Value where toJSON value = Object (KM.fromList (concat [[("backend", toJSON (conformanceStepBranch14ValueBackend value))], optionalPair "with" (conformanceStepBranch14ValueWith value)]))

data ConformanceStepBranch14ValueBackend = ConformanceStepBranch14ValueBackendListen | ConformanceStepBranch14ValueBackendEmit | ConformanceStepBranch14ValueBackendRecord | ConformanceStepBranch14ValueBackendContent | ConformanceStepBranch14ValueBackendDescription | ConformanceStepBranch14ValueBackendAnnotations | ConformanceStepBranch14ValueBackendAnchoredU2d_text | ConformanceStepBranch14ValueBackendUploaded | ConformanceStepBranch14ValueBackendRefuse | ConformanceStepBranch14ValueBackendUnanswered | ConformanceStepBranch14ValueBackendAnswerU2d_lost | ConformanceStepBranch14ValueBackendHold | ConformanceStepBranch14ValueBackendRelease | ConformanceStepBranch14ValueBackendRechunk | ConformanceStepBranch14ValueBackendCarry | ConformanceStepBranch14ValueBackendCut | ConformanceStepBranch14ValueBackendDown | ConformanceStepBranch14ValueBackendUp | ConformanceStepBranch14ValueBackendArchivist deriving (Eq, Show)

instance FromJSON ConformanceStepBranch14ValueBackend where parseJSON = checked "ConformanceStepBranch14ValueBackend" $ \value -> if value == String "listen" then pure ConformanceStepBranch14ValueBackendListen else if value == String "emit" then pure ConformanceStepBranch14ValueBackendEmit else if value == String "record" then pure ConformanceStepBranch14ValueBackendRecord else if value == String "content" then pure ConformanceStepBranch14ValueBackendContent else if value == String "description" then pure ConformanceStepBranch14ValueBackendDescription else if value == String "annotations" then pure ConformanceStepBranch14ValueBackendAnnotations else if value == String "anchored-text" then pure ConformanceStepBranch14ValueBackendAnchoredU2d_text else if value == String "uploaded" then pure ConformanceStepBranch14ValueBackendUploaded else if value == String "refuse" then pure ConformanceStepBranch14ValueBackendRefuse else if value == String "unanswered" then pure ConformanceStepBranch14ValueBackendUnanswered else if value == String "answer-lost" then pure ConformanceStepBranch14ValueBackendAnswerU2d_lost else if value == String "hold" then pure ConformanceStepBranch14ValueBackendHold else if value == String "release" then pure ConformanceStepBranch14ValueBackendRelease else if value == String "rechunk" then pure ConformanceStepBranch14ValueBackendRechunk else if value == String "carry" then pure ConformanceStepBranch14ValueBackendCarry else if value == String "cut" then pure ConformanceStepBranch14ValueBackendCut else if value == String "down" then pure ConformanceStepBranch14ValueBackendDown else if value == String "up" then pure ConformanceStepBranch14ValueBackendUp else if value == String "archivist" then pure ConformanceStepBranch14ValueBackendArchivist else fail "unknown enumeration member"

instance ToJSON ConformanceStepBranch14ValueBackend where
  toJSON ConformanceStepBranch14ValueBackendListen = String "listen"
  toJSON ConformanceStepBranch14ValueBackendEmit = String "emit"
  toJSON ConformanceStepBranch14ValueBackendRecord = String "record"
  toJSON ConformanceStepBranch14ValueBackendContent = String "content"
  toJSON ConformanceStepBranch14ValueBackendDescription = String "description"
  toJSON ConformanceStepBranch14ValueBackendAnnotations = String "annotations"
  toJSON ConformanceStepBranch14ValueBackendAnchoredU2d_text = String "anchored-text"
  toJSON ConformanceStepBranch14ValueBackendUploaded = String "uploaded"
  toJSON ConformanceStepBranch14ValueBackendRefuse = String "refuse"
  toJSON ConformanceStepBranch14ValueBackendUnanswered = String "unanswered"
  toJSON ConformanceStepBranch14ValueBackendAnswerU2d_lost = String "answer-lost"
  toJSON ConformanceStepBranch14ValueBackendHold = String "hold"
  toJSON ConformanceStepBranch14ValueBackendRelease = String "release"
  toJSON ConformanceStepBranch14ValueBackendRechunk = String "rechunk"
  toJSON ConformanceStepBranch14ValueBackendCarry = String "carry"
  toJSON ConformanceStepBranch14ValueBackendCut = String "cut"
  toJSON ConformanceStepBranch14ValueBackendDown = String "down"
  toJSON ConformanceStepBranch14ValueBackendUp = String "up"
  toJSON ConformanceStepBranch14ValueBackendArchivist = String "archivist"

data ConformanceStepBranch14ValueWith = ConformanceStepBranch14ValueWith
  { conformanceStepBranch14ValueWithAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch14ValueWith where parseJSON = checked "ConformanceStepBranch14ValueWith" $ withObject "ConformanceStepBranch14ValueWith" (\fields -> ConformanceStepBranch14ValueWith <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ConformanceStepBranch14ValueWith where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (conformanceStepBranch14ValueWithAdditionalProperties value)))

data ConformanceStepBranch15Value = ConformanceStepBranch15Value
  { conformanceStepBranch15ValueQuiet :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch15Value where parseJSON = checked "ConformanceStepBranch15Value" $ withObject "ConformanceStepBranch15Value" (\fields -> ConformanceStepBranch15Value <$> (fields .: "quiet"))

instance ToJSON ConformanceStepBranch15Value where toJSON value = Object (KM.fromList (concat [[("quiet", toJSON (conformanceStepBranch15ValueQuiet value))]]))

data ConformanceStepBranch16Value = ConformanceStepBranch16Value
  { conformanceStepBranch16ValueAs :: Text,
    conformanceStepBranch16ValueObserve :: ConformanceStepBranch16ValueObserve
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch16Value where parseJSON = checked "ConformanceStepBranch16Value" $ withObject "ConformanceStepBranch16Value" (\fields -> ConformanceStepBranch16Value <$> (fields .: "as") <*> (fields .: "observe"))

instance ToJSON ConformanceStepBranch16Value where toJSON value = Object (KM.fromList (concat [[("as", toJSON (conformanceStepBranch16ValueAs value))], [("observe", toJSON (conformanceStepBranch16ValueObserve value))]]))

data ConformanceStepBranch16ValueObserve = ConformanceStepBranch16ValueObserve
  { conformanceStepBranch16ValueObserveAnnotation :: Maybe Value,
    conformanceStepBranch16ValueObserveFilters :: Maybe Value,
    conformanceStepBranch16ValueObserveQuery :: Text,
    conformanceStepBranch16ValueObserveResource :: Maybe Value,
    conformanceStepBranch16ValueObserveSearch :: Maybe Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch16ValueObserve where parseJSON = checked "ConformanceStepBranch16ValueObserve" $ withObject "ConformanceStepBranch16ValueObserve" (\fields -> ConformanceStepBranch16ValueObserve <$> optional fields "annotation" <*> optional fields "filters" <*> (fields .: "query") <*> optional fields "resource" <*> optional fields "search")

instance ToJSON ConformanceStepBranch16ValueObserve where toJSON value = Object (KM.fromList (concat [optionalPair "annotation" (conformanceStepBranch16ValueObserveAnnotation value), optionalPair "filters" (conformanceStepBranch16ValueObserveFilters value), [("query", toJSON (conformanceStepBranch16ValueObserveQuery value))], optionalPair "resource" (conformanceStepBranch16ValueObserveResource value), optionalPair "search" (conformanceStepBranch16ValueObserveSearch value)]))

data ConformanceStepBranch17Value = ConformanceStepBranch17Value
  { conformanceStepBranch17ValueLeave :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch17Value where parseJSON = checked "ConformanceStepBranch17Value" $ withObject "ConformanceStepBranch17Value" (\fields -> ConformanceStepBranch17Value <$> (fields .: "leave"))

instance ToJSON ConformanceStepBranch17Value where toJSON value = Object (KM.fromList (concat [[("leave", toJSON (conformanceStepBranch17ValueLeave value))]]))

data ConformanceStepBranch18Value = ConformanceStepBranch18Value
  { conformanceStepBranch18ValueReaches :: Text,
    conformanceStepBranch18ValueState :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch18Value where parseJSON = checked "ConformanceStepBranch18Value" $ withObject "ConformanceStepBranch18Value" (\fields -> ConformanceStepBranch18Value <$> (fields .: "reaches") <*> (fields .: "state"))

instance ToJSON ConformanceStepBranch18Value where toJSON value = Object (KM.fromList (concat [[("reaches", toJSON (conformanceStepBranch18ValueReaches value))], [("state", toJSON (conformanceStepBranch18ValueState value))]]))

data ConformanceStepBranch19Value = ConformanceStepBranch19Value
  { conformanceStepBranch19ValueHolds :: Text,
    conformanceStepBranch19ValueState :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch19Value where parseJSON = checked "ConformanceStepBranch19Value" $ withObject "ConformanceStepBranch19Value" (\fields -> ConformanceStepBranch19Value <$> (fields .: "holds") <*> (fields .: "state"))

instance ToJSON ConformanceStepBranch19Value where toJSON value = Object (KM.fromList (concat [[("holds", toJSON (conformanceStepBranch19ValueHolds value))], [("state", toJSON (conformanceStepBranch19ValueState value))]]))

data ConformanceStepBranch1Value = ConformanceStepBranch1Value
  { conformanceStepBranch1ValueLet :: ConformanceStepBranch1ValueLet
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch1Value where parseJSON = checked "ConformanceStepBranch1Value" $ withObject "ConformanceStepBranch1Value" (\fields -> ConformanceStepBranch1Value <$> (fields .: "let"))

instance ToJSON ConformanceStepBranch1Value where toJSON value = Object (KM.fromList (concat [[("let", toJSON (conformanceStepBranch1ValueLet value))]]))

data ConformanceStepBranch1ValueLet = ConformanceStepBranch1ValueLet
  { conformanceStepBranch1ValueLetAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch1ValueLet where parseJSON = checked "ConformanceStepBranch1ValueLet" $ withObject "ConformanceStepBranch1ValueLet" (\fields -> ConformanceStepBranch1ValueLet <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ConformanceStepBranch1ValueLet where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (conformanceStepBranch1ValueLetAdditionalProperties value)))

data ConformanceStepBranch20Value = ConformanceStepBranch20Value
  { conformanceStepBranch20ValueCompletes :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch20Value where parseJSON = checked "ConformanceStepBranch20Value" $ withObject "ConformanceStepBranch20Value" (\fields -> ConformanceStepBranch20Value <$> (fields .: "completes"))

instance ToJSON ConformanceStepBranch20Value where toJSON value = Object (KM.fromList (concat [[("completes", toJSON (conformanceStepBranch20ValueCompletes value))]]))

data ConformanceStepBranch23Value = ConformanceStepBranch23Value
  { conformanceStepBranch23ValueFetches :: [ConformanceStepBranch23ValueFetchesItem]
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch23Value where parseJSON = checked "ConformanceStepBranch23Value" $ withObject "ConformanceStepBranch23Value" (\fields -> ConformanceStepBranch23Value <$> (fields .: "fetches"))

instance ToJSON ConformanceStepBranch23Value where toJSON value = Object (KM.fromList (concat [[("fetches", toJSON (conformanceStepBranch23ValueFetches value))]]))

data ConformanceStepBranch23ValueFetchesItem = ConformanceStepBranch23ValueFetchesItemBranch1 ConformanceBusFetch | ConformanceStepBranch23ValueFetchesItemBranch2 ConformanceHttpFetch deriving (Eq, Show)

instance FromJSON ConformanceStepBranch23ValueFetchesItem where parseJSON = checked "ConformanceStepBranch23ValueFetchesItem" $ \value -> (ConformanceStepBranch23ValueFetchesItemBranch1 <$> parseJSON value) <|> (ConformanceStepBranch23ValueFetchesItemBranch2 <$> parseJSON value)

instance ToJSON ConformanceStepBranch23ValueFetchesItem where
  toJSON (ConformanceStepBranch23ValueFetchesItemBranch1 value) = toJSON value
  toJSON (ConformanceStepBranch23ValueFetchesItemBranch2 value) = toJSON value

data ConformanceStepBranch24Value = ConformanceStepBranch24Value
  { conformanceStepBranch24ValueScopes :: [Value]
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch24Value where parseJSON = checked "ConformanceStepBranch24Value" $ withObject "ConformanceStepBranch24Value" (\fields -> ConformanceStepBranch24Value <$> (fields .: "scopes"))

instance ToJSON ConformanceStepBranch24Value where toJSON value = Object (KM.fromList (concat [[("scopes", toJSON (conformanceStepBranch24ValueScopes value))]]))

data ConformanceStepBranch25Value = ConformanceStepBranch25Value
  { conformanceStepBranch25ValueClaimed :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch25Value where parseJSON = checked "ConformanceStepBranch25Value" $ withObject "ConformanceStepBranch25Value" (\fields -> ConformanceStepBranch25Value <$> (fields .: "claimed"))

instance ToJSON ConformanceStepBranch25Value where toJSON value = Object (KM.fromList (concat [[("claimed", toJSON (conformanceStepBranch25ValueClaimed value))]]))

data ConformanceStepBranch26Value = ConformanceStepBranch26Value
  { conformanceStepBranch26ValueRefused :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch26Value where parseJSON = checked "ConformanceStepBranch26Value" $ withObject "ConformanceStepBranch26Value" (\fields -> ConformanceStepBranch26Value <$> (fields .: "refused"))

instance ToJSON ConformanceStepBranch26Value where toJSON value = Object (KM.fromList (concat [[("refused", toJSON (conformanceStepBranch26ValueRefused value))]]))

data ConformanceStepBranch27Value = ConformanceStepBranch27Value
  { conformanceStepBranch27ValueSignalled :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch27Value where parseJSON = checked "ConformanceStepBranch27Value" $ withObject "ConformanceStepBranch27Value" (\fields -> ConformanceStepBranch27Value <$> (fields .: "signalled"))

instance ToJSON ConformanceStepBranch27Value where toJSON value = Object (KM.fromList (concat [[("signalled", toJSON (conformanceStepBranch27ValueSignalled value))]]))

data ConformanceStepBranch28Value = ConformanceStepBranch28Value
  { conformanceStepBranch28ValueStalled :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch28Value where parseJSON = checked "ConformanceStepBranch28Value" $ withObject "ConformanceStepBranch28Value" (\fields -> ConformanceStepBranch28Value <$> (fields .: "stalled"))

instance ToJSON ConformanceStepBranch28Value where toJSON value = Object (KM.fromList (concat [[("stalled", toJSON (conformanceStepBranch28ValueStalled value))]]))

data ConformanceStepBranch2Value = ConformanceStepBranch2Value
  { conformanceStepBranch2ValueAs :: Maybe Text,
    conformanceStepBranch2ValueDriver :: Text,
    conformanceStepBranch2ValueFails :: Maybe Value,
    conformanceStepBranch2ValueReturns :: Maybe Value,
    conformanceStepBranch2ValueWith :: Maybe ConformanceStepBranch2ValueWith
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch2Value where parseJSON = checked "ConformanceStepBranch2Value" $ withObject "ConformanceStepBranch2Value" (\fields -> ConformanceStepBranch2Value <$> optional fields "as" <*> (fields .: "driver") <*> optional fields "fails" <*> optional fields "returns" <*> optional fields "with")

instance ToJSON ConformanceStepBranch2Value where toJSON value = Object (KM.fromList (concat [optionalPair "as" (conformanceStepBranch2ValueAs value), [("driver", toJSON (conformanceStepBranch2ValueDriver value))], optionalPair "fails" (conformanceStepBranch2ValueFails value), optionalPair "returns" (conformanceStepBranch2ValueReturns value), optionalPair "with" (conformanceStepBranch2ValueWith value)]))

data ConformanceStepBranch2ValueWith = ConformanceStepBranch2ValueWith
  { conformanceStepBranch2ValueWithAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch2ValueWith where parseJSON = checked "ConformanceStepBranch2ValueWith" $ withObject "ConformanceStepBranch2ValueWith" (\fields -> ConformanceStepBranch2ValueWith <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ConformanceStepBranch2ValueWith where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (conformanceStepBranch2ValueWithAdditionalProperties value)))

data ConformanceStepBranch3Value = ConformanceStepBranch3Value
  { conformanceStepBranch3ValueAbandon :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch3Value where parseJSON = checked "ConformanceStepBranch3Value" $ withObject "ConformanceStepBranch3Value" (\fields -> ConformanceStepBranch3Value <$> (fields .: "abandon"))

instance ToJSON ConformanceStepBranch3Value where toJSON value = Object (KM.fromList (concat [[("abandon", toJSON (conformanceStepBranch3ValueAbandon value))]]))

data ConformanceStepBranch4Value = ConformanceStepBranch4Value
  { conformanceStepBranch4ValueAbandoned :: Maybe ConformanceStepBranch4ValueAbandoned,
    conformanceStepBranch4ValueFails :: Maybe Value,
    conformanceStepBranch4ValueReturns :: Maybe Value,
    conformanceStepBranch4ValueSettles :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch4Value where parseJSON = checked "ConformanceStepBranch4Value" $ withObject "ConformanceStepBranch4Value" (\fields -> ConformanceStepBranch4Value <$> optional fields "abandoned" <*> optional fields "fails" <*> optional fields "returns" <*> (fields .: "settles"))

instance ToJSON ConformanceStepBranch4Value where toJSON value = Object (KM.fromList (concat [optionalPair "abandoned" (conformanceStepBranch4ValueAbandoned value), optionalPair "fails" (conformanceStepBranch4ValueFails value), optionalPair "returns" (conformanceStepBranch4ValueReturns value), [("settles", toJSON (conformanceStepBranch4ValueSettles value))]]))

data ConformanceStepBranch4ValueAbandoned = ConformanceStepBranch4ValueAbandonedTrue deriving (Eq, Show)

instance FromJSON ConformanceStepBranch4ValueAbandoned where parseJSON = checked "ConformanceStepBranch4ValueAbandoned" $ \value -> if value == Bool True then pure ConformanceStepBranch4ValueAbandonedTrue else fail "unknown enumeration member"

instance ToJSON ConformanceStepBranch4ValueAbandoned where toJSON ConformanceStepBranch4ValueAbandonedTrue = Bool True

data ConformanceStepBranch5Value = ConformanceStepBranch5Value
  { conformanceStepBranch5ValueAnswer :: Maybe Value,
    conformanceStepBranch5ValueAs :: Maybe Text,
    conformanceStepBranch5ValueAt :: Maybe ConformanceStepBranch5ValueAt,
    conformanceStepBranch5ValueBody :: Maybe Value,
    conformanceStepBranch5ValueFollows :: Maybe Text,
    conformanceStepBranch5ValueHeaders :: Maybe ConformanceStepBranch5ValueHeaders,
    conformanceStepBranch5ValueParams :: Maybe Value,
    conformanceStepBranch5ValueStatus :: Maybe Integer,
    conformanceStepBranch5ValueToken :: Maybe Value,
    conformanceStepBranch5ValueWaited :: Maybe Text,
    conformanceStepBranch5ValueWire :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch5Value where parseJSON = checked "ConformanceStepBranch5Value" $ withObject "ConformanceStepBranch5Value" (\fields -> ConformanceStepBranch5Value <$> optional fields "answer" <*> optional fields "as" <*> optional fields "at" <*> optional fields "body" <*> optional fields "follows" <*> optional fields "headers" <*> optional fields "params" <*> optional fields "status" <*> optional fields "token" <*> optional fields "waited" <*> (fields .: "wire"))

instance ToJSON ConformanceStepBranch5Value where toJSON value = Object (KM.fromList (concat [optionalPair "answer" (conformanceStepBranch5ValueAnswer value), optionalPair "as" (conformanceStepBranch5ValueAs value), optionalPair "at" (conformanceStepBranch5ValueAt value), optionalPair "body" (conformanceStepBranch5ValueBody value), optionalPair "follows" (conformanceStepBranch5ValueFollows value), optionalPair "headers" (conformanceStepBranch5ValueHeaders value), optionalPair "params" (conformanceStepBranch5ValueParams value), optionalPair "status" (conformanceStepBranch5ValueStatus value), optionalPair "token" (conformanceStepBranch5ValueToken value), optionalPair "waited" (conformanceStepBranch5ValueWaited value), [("wire", toJSON (conformanceStepBranch5ValueWire value))]]))

data ConformanceStepBranch5ValueAt = ConformanceStepBranch5ValueAtArrival | ConformanceStepBranch5ValueAtAnswer | ConformanceStepBranch5ValueAtLive deriving (Eq, Show)

instance FromJSON ConformanceStepBranch5ValueAt where parseJSON = checked "ConformanceStepBranch5ValueAt" $ \value -> if value == String "arrival" then pure ConformanceStepBranch5ValueAtArrival else if value == String "answer" then pure ConformanceStepBranch5ValueAtAnswer else if value == String "live" then pure ConformanceStepBranch5ValueAtLive else fail "unknown enumeration member"

instance ToJSON ConformanceStepBranch5ValueAt where
  toJSON ConformanceStepBranch5ValueAtArrival = String "arrival"
  toJSON ConformanceStepBranch5ValueAtAnswer = String "answer"
  toJSON ConformanceStepBranch5ValueAtLive = String "live"

data ConformanceStepBranch5ValueHeaders = ConformanceStepBranch5ValueHeaders
  { conformanceStepBranch5ValueHeadersAdditionalProperties :: KM.KeyMap Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch5ValueHeaders where parseJSON = checked "ConformanceStepBranch5ValueHeaders" $ withObject "ConformanceStepBranch5ValueHeaders" (\fields -> ConformanceStepBranch5ValueHeaders <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON ConformanceStepBranch5ValueHeaders where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (conformanceStepBranch5ValueHeadersAdditionalProperties value)))

data ConformanceStepBranch6Value = ConformanceStepBranch6Value
  { conformanceStepBranch6ValueCarried :: Text,
    conformanceStepBranch6ValueIs :: Value
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch6Value where parseJSON = checked "ConformanceStepBranch6Value" $ withObject "ConformanceStepBranch6Value" (\fields -> ConformanceStepBranch6Value <$> (fields .: "carried") <*> (fields .: "is"))

instance ToJSON ConformanceStepBranch6Value where toJSON value = Object (KM.fromList (concat [[("carried", toJSON (conformanceStepBranch6ValueCarried value))], [("is", toJSON (conformanceStepBranch6ValueIs value))]]))

data ConformanceStepBranch7Value = ConformanceStepBranch7Value
  { conformanceStepBranch7ValueClosed :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch7Value where parseJSON = checked "ConformanceStepBranch7Value" $ withObject "ConformanceStepBranch7Value" (\fields -> ConformanceStepBranch7Value <$> (fields .: "closed"))

instance ToJSON ConformanceStepBranch7Value where toJSON value = Object (KM.fromList (concat [[("closed", toJSON (conformanceStepBranch7ValueClosed value))]]))

data ConformanceStepBranch8Value = ConformanceStepBranch8Value
  { conformanceStepBranch8ValueProgress :: Text
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch8Value where parseJSON = checked "ConformanceStepBranch8Value" $ withObject "ConformanceStepBranch8Value" (\fields -> ConformanceStepBranch8Value <$> (fields .: "progress"))

instance ToJSON ConformanceStepBranch8Value where toJSON value = Object (KM.fromList (concat [[("progress", toJSON (conformanceStepBranch8ValueProgress value))]]))

data ConformanceStepBranch9Value = ConformanceStepBranch9Value
  { conformanceStepBranch9ValueState :: ConformanceStepBranch9ValueState
  }
  deriving (Eq, Show)

instance FromJSON ConformanceStepBranch9Value where parseJSON = checked "ConformanceStepBranch9Value" $ withObject "ConformanceStepBranch9Value" (\fields -> ConformanceStepBranch9Value <$> (fields .: "state"))

instance ToJSON ConformanceStepBranch9Value where toJSON value = Object (KM.fromList (concat [[("state", toJSON (conformanceStepBranch9ValueState value))]]))

data ConformanceStepBranch9ValueState = ConformanceStepBranch9ValueStateInitial | ConformanceStepBranch9ValueStateConnecting | ConformanceStepBranch9ValueStateOpen | ConformanceStepBranch9ValueStateReconnecting | ConformanceStepBranch9ValueStateDegraded | ConformanceStepBranch9ValueStateUnauthenticated | ConformanceStepBranch9ValueStateClosed deriving (Eq, Show)

instance FromJSON ConformanceStepBranch9ValueState where parseJSON = checked "ConformanceStepBranch9ValueState" $ \value -> if value == String "initial" then pure ConformanceStepBranch9ValueStateInitial else if value == String "connecting" then pure ConformanceStepBranch9ValueStateConnecting else if value == String "open" then pure ConformanceStepBranch9ValueStateOpen else if value == String "reconnecting" then pure ConformanceStepBranch9ValueStateReconnecting else if value == String "degraded" then pure ConformanceStepBranch9ValueStateDegraded else if value == String "unauthenticated" then pure ConformanceStepBranch9ValueStateUnauthenticated else if value == String "closed" then pure ConformanceStepBranch9ValueStateClosed else fail "unknown enumeration member"

instance ToJSON ConformanceStepBranch9ValueState where
  toJSON ConformanceStepBranch9ValueStateInitial = String "initial"
  toJSON ConformanceStepBranch9ValueStateConnecting = String "connecting"
  toJSON ConformanceStepBranch9ValueStateOpen = String "open"
  toJSON ConformanceStepBranch9ValueStateReconnecting = String "reconnecting"
  toJSON ConformanceStepBranch9ValueStateDegraded = String "degraded"
  toJSON ConformanceStepBranch9ValueStateUnauthenticated = String "unauthenticated"
  toJSON ConformanceStepBranch9ValueStateClosed = String "closed"
