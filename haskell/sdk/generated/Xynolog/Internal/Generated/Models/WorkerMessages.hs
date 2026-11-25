-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.WorkerMessages (WorkerMessages (..), WorkerMessagesBootItem (..), WorkerMessagesBootItemOwnBootRefusal (..), WorkerMessagesBootItemSharedBootRefusal (..), WorkerMessagesDetailsItem (..), WorkerMessagesErrorsItem (..), WorkerMessagesJob (..), WorkerMessagesLoggedItem (..), WorkerMessagesLoggedItemFields (..), WorkerMessagesReasonsItem (..), WorkerMessagesWaitsItem (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.LogLevel

data WorkerMessages = WorkerMessages
  { workerMessagesComment :: Text,
    workerMessagesBoot :: [WorkerMessagesBootItem],
    workerMessagesReasons :: [WorkerMessagesReasonsItem],
    workerMessagesJob :: WorkerMessagesJob,
    workerMessagesErrors :: [WorkerMessagesErrorsItem],
    workerMessagesDetails :: [WorkerMessagesDetailsItem],
    workerMessagesWaits :: [WorkerMessagesWaitsItem],
    workerMessagesLogged :: [WorkerMessagesLoggedItem]
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessages where parseJSON = checked "WorkerMessages" $ withObject "WorkerMessages" (\fields -> WorkerMessages <$> (fields .: "$comment") <*> (fields .: "boot") <*> (fields .: "reasons") <*> (fields .: "job") <*> (fields .: "errors") <*> (fields .: "details") <*> (fields .: "waits") <*> (fields .: "logged"))

instance ToJSON WorkerMessages where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (workerMessagesComment value))], [("boot", toJSON (workerMessagesBoot value))], [("reasons", toJSON (workerMessagesReasons value))], [("job", toJSON (workerMessagesJob value))], [("errors", toJSON (workerMessagesErrors value))], [("details", toJSON (workerMessagesDetails value))], [("waits", toJSON (workerMessagesWaits value))], [("logged", toJSON (workerMessagesLogged value))]]))

data WorkerMessagesBootItem = WorkerMessagesBootItemOwnBootRefusal WorkerMessagesBootItemOwnBootRefusal | WorkerMessagesBootItemSharedBootRefusal WorkerMessagesBootItemSharedBootRefusal deriving (Eq, Show)

instance FromJSON WorkerMessagesBootItem where parseJSON = checked "WorkerMessagesBootItem" $ \value -> (WorkerMessagesBootItemOwnBootRefusal <$> parseJSON value) <|> (WorkerMessagesBootItemSharedBootRefusal <$> parseJSON value)

instance ToJSON WorkerMessagesBootItem where
  toJSON (WorkerMessagesBootItemOwnBootRefusal value) = toJSON value
  toJSON (WorkerMessagesBootItemSharedBootRefusal value) = toJSON value

data WorkerMessagesBootItemOwnBootRefusal = MkWorkerMessagesBootItemOwnBootRefusal
  { workerMessagesBootItemOwnBootRefusalName :: Text,
    workerMessagesBootItemOwnBootRefusalSituation :: Text,
    workerMessagesBootItemOwnBootRefusalRefusal :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesBootItemOwnBootRefusal where parseJSON = checked "WorkerMessagesBootItemOwnBootRefusal" $ withObject "WorkerMessagesBootItemOwnBootRefusal" (\fields -> MkWorkerMessagesBootItemOwnBootRefusal <$> (fields .: "name") <*> (fields .: "situation") <*> (fields .: "refusal"))

instance ToJSON WorkerMessagesBootItemOwnBootRefusal where toJSON value = Object (KM.fromList (concat [[("name", toJSON (workerMessagesBootItemOwnBootRefusalName value))], [("situation", toJSON (workerMessagesBootItemOwnBootRefusalSituation value))], [("refusal", toJSON (workerMessagesBootItemOwnBootRefusalRefusal value))]]))

data WorkerMessagesBootItemSharedBootRefusal = MkWorkerMessagesBootItemSharedBootRefusal
  { workerMessagesBootItemSharedBootRefusalName :: Text,
    workerMessagesBootItemSharedBootRefusalSituation :: Text,
    workerMessagesBootItemSharedBootRefusalBootRefusal :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesBootItemSharedBootRefusal where parseJSON = checked "WorkerMessagesBootItemSharedBootRefusal" $ withObject "WorkerMessagesBootItemSharedBootRefusal" (\fields -> MkWorkerMessagesBootItemSharedBootRefusal <$> (fields .: "name") <*> (fields .: "situation") <*> (fields .: "bootRefusal"))

instance ToJSON WorkerMessagesBootItemSharedBootRefusal where toJSON value = Object (KM.fromList (concat [[("name", toJSON (workerMessagesBootItemSharedBootRefusalName value))], [("situation", toJSON (workerMessagesBootItemSharedBootRefusalSituation value))], [("bootRefusal", toJSON (workerMessagesBootItemSharedBootRefusalBootRefusal value))]]))

data WorkerMessagesDetailsItem = WorkerMessagesDetailsItem
  { workerMessagesDetailsItemName :: Text,
    workerMessagesDetailsItemSituation :: Text,
    workerMessagesDetailsItemDetail :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesDetailsItem where parseJSON = checked "WorkerMessagesDetailsItem" $ withObject "WorkerMessagesDetailsItem" (\fields -> WorkerMessagesDetailsItem <$> (fields .: "name") <*> (fields .: "situation") <*> (fields .: "detail"))

instance ToJSON WorkerMessagesDetailsItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (workerMessagesDetailsItemName value))], [("situation", toJSON (workerMessagesDetailsItemSituation value))], [("detail", toJSON (workerMessagesDetailsItemDetail value))]]))

data WorkerMessagesErrorsItem = WorkerMessagesErrorsItem
  { workerMessagesErrorsItemName :: Text,
    workerMessagesErrorsItemSituation :: Text,
    workerMessagesErrorsItemError :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesErrorsItem where parseJSON = checked "WorkerMessagesErrorsItem" $ withObject "WorkerMessagesErrorsItem" (\fields -> WorkerMessagesErrorsItem <$> (fields .: "name") <*> (fields .: "situation") <*> (fields .: "error"))

instance ToJSON WorkerMessagesErrorsItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (workerMessagesErrorsItemName value))], [("situation", toJSON (workerMessagesErrorsItemSituation value))], [("error", toJSON (workerMessagesErrorsItemError value))]]))

data WorkerMessagesJob = WorkerMessagesJob
  { workerMessagesJobMark :: Text,
    workerMessagesJobYield :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesJob where parseJSON = checked "WorkerMessagesJob" $ withObject "WorkerMessagesJob" (\fields -> WorkerMessagesJob <$> (fields .: "mark") <*> (fields .: "yield"))

instance ToJSON WorkerMessagesJob where toJSON value = Object (KM.fromList (concat [[("mark", toJSON (workerMessagesJobMark value))], [("yield", toJSON (workerMessagesJobYield value))]]))

data WorkerMessagesLoggedItem = WorkerMessagesLoggedItem
  { workerMessagesLoggedItemName :: Text,
    workerMessagesLoggedItemLevel :: LogLevel,
    workerMessagesLoggedItemSituation :: Text,
    workerMessagesLoggedItemMessage :: Text,
    workerMessagesLoggedItemFields :: WorkerMessagesLoggedItemFields,
    workerMessagesLoggedItemCarries :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesLoggedItem where parseJSON = checked "WorkerMessagesLoggedItem" $ withObject "WorkerMessagesLoggedItem" (\fields -> WorkerMessagesLoggedItem <$> (fields .: "name") <*> (fields .: "level") <*> (fields .: "situation") <*> (fields .: "message") <*> (fields .: "fields") <*> (fields .: "carries"))

instance ToJSON WorkerMessagesLoggedItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (workerMessagesLoggedItemName value))], [("level", toJSON (workerMessagesLoggedItemLevel value))], [("situation", toJSON (workerMessagesLoggedItemSituation value))], [("message", toJSON (workerMessagesLoggedItemMessage value))], [("fields", toJSON (workerMessagesLoggedItemFields value))], [("carries", toJSON (workerMessagesLoggedItemCarries value))]]))

data WorkerMessagesLoggedItemFields = WorkerMessagesLoggedItemFields
  { workerMessagesLoggedItemFieldsAdditionalProperties :: KM.KeyMap Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesLoggedItemFields where parseJSON = checked "WorkerMessagesLoggedItemFields" $ withObject "WorkerMessagesLoggedItemFields" (\fields -> WorkerMessagesLoggedItemFields <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON WorkerMessagesLoggedItemFields where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (workerMessagesLoggedItemFieldsAdditionalProperties value)))

data WorkerMessagesReasonsItem = WorkerMessagesReasonsItem
  { workerMessagesReasonsItemName :: Text,
    workerMessagesReasonsItemSituation :: Text,
    workerMessagesReasonsItemLine :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesReasonsItem where parseJSON = checked "WorkerMessagesReasonsItem" $ withObject "WorkerMessagesReasonsItem" (\fields -> WorkerMessagesReasonsItem <$> (fields .: "name") <*> (fields .: "situation") <*> (fields .: "line"))

instance ToJSON WorkerMessagesReasonsItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (workerMessagesReasonsItemName value))], [("situation", toJSON (workerMessagesReasonsItemSituation value))], [("line", toJSON (workerMessagesReasonsItemLine value))]]))

data WorkerMessagesWaitsItem = WorkerMessagesWaitsItem
  { workerMessagesWaitsItemName :: Text,
    workerMessagesWaitsItemSituation :: Text,
    workerMessagesWaitsItemSaid :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesWaitsItem where parseJSON = checked "WorkerMessagesWaitsItem" $ withObject "WorkerMessagesWaitsItem" (\fields -> WorkerMessagesWaitsItem <$> (fields .: "name") <*> (fields .: "situation") <*> (fields .: "said"))

instance ToJSON WorkerMessagesWaitsItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (workerMessagesWaitsItemName value))], [("situation", toJSON (workerMessagesWaitsItemSituation value))], [("said", toJSON (workerMessagesWaitsItemSaid value))]]))
