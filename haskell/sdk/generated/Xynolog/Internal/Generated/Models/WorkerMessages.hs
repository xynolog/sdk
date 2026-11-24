-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.WorkerMessages (WorkerMessages (..), WorkerMessagesBootItem (..), WorkerMessagesBootItemOwnBootRefusalValue (..), WorkerMessagesBootItemSharedBootRefusalValue (..), WorkerMessagesDetailsItem (..), WorkerMessagesErrorsItem (..), WorkerMessagesJob (..), WorkerMessagesLoggedItem (..), WorkerMessagesLoggedItemFields (..), WorkerMessagesReasonsItem (..), WorkerMessagesWaitsItem (..)) where

import Control.Applicative ((<|>))
import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.LogLevel

data WorkerMessages = WorkerMessages
  { workerMessagesBoot :: [WorkerMessagesBootItem],
    workerMessagesDetails :: [WorkerMessagesDetailsItem],
    workerMessagesErrors :: [WorkerMessagesErrorsItem],
    workerMessagesJob :: WorkerMessagesJob,
    workerMessagesLogged :: [WorkerMessagesLoggedItem],
    workerMessagesReasons :: [WorkerMessagesReasonsItem],
    workerMessagesWaits :: [WorkerMessagesWaitsItem]
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessages where parseJSON = checked "WorkerMessages" $ withObject "WorkerMessages" (\fields -> WorkerMessages <$> (fields .: "boot") <*> (fields .: "details") <*> (fields .: "errors") <*> (fields .: "job") <*> (fields .: "logged") <*> (fields .: "reasons") <*> (fields .: "waits"))

instance ToJSON WorkerMessages where toJSON value = Object (KM.fromList (concat [[("boot", toJSON (workerMessagesBoot value))], [("details", toJSON (workerMessagesDetails value))], [("errors", toJSON (workerMessagesErrors value))], [("job", toJSON (workerMessagesJob value))], [("logged", toJSON (workerMessagesLogged value))], [("reasons", toJSON (workerMessagesReasons value))], [("waits", toJSON (workerMessagesWaits value))]]))

data WorkerMessagesBootItem = WorkerMessagesBootItemOwnBootRefusal WorkerMessagesBootItemOwnBootRefusalValue | WorkerMessagesBootItemSharedBootRefusal WorkerMessagesBootItemSharedBootRefusalValue deriving (Eq, Show)

instance FromJSON WorkerMessagesBootItem where parseJSON = checked "WorkerMessagesBootItem" $ \value -> (WorkerMessagesBootItemOwnBootRefusal <$> parseJSON value) <|> (WorkerMessagesBootItemSharedBootRefusal <$> parseJSON value)

instance ToJSON WorkerMessagesBootItem where
  toJSON (WorkerMessagesBootItemOwnBootRefusal value) = toJSON value
  toJSON (WorkerMessagesBootItemSharedBootRefusal value) = toJSON value

data WorkerMessagesBootItemOwnBootRefusalValue = WorkerMessagesBootItemOwnBootRefusalValue
  { workerMessagesBootItemOwnBootRefusalValueName :: Text,
    workerMessagesBootItemOwnBootRefusalValueRefusal :: Text,
    workerMessagesBootItemOwnBootRefusalValueSituation :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesBootItemOwnBootRefusalValue where parseJSON = checked "WorkerMessagesBootItemOwnBootRefusalValue" $ withObject "WorkerMessagesBootItemOwnBootRefusalValue" (\fields -> WorkerMessagesBootItemOwnBootRefusalValue <$> (fields .: "name") <*> (fields .: "refusal") <*> (fields .: "situation"))

instance ToJSON WorkerMessagesBootItemOwnBootRefusalValue where toJSON value = Object (KM.fromList (concat [[("name", toJSON (workerMessagesBootItemOwnBootRefusalValueName value))], [("refusal", toJSON (workerMessagesBootItemOwnBootRefusalValueRefusal value))], [("situation", toJSON (workerMessagesBootItemOwnBootRefusalValueSituation value))]]))

data WorkerMessagesBootItemSharedBootRefusalValue = WorkerMessagesBootItemSharedBootRefusalValue
  { workerMessagesBootItemSharedBootRefusalValueBootRefusal :: Text,
    workerMessagesBootItemSharedBootRefusalValueName :: Text,
    workerMessagesBootItemSharedBootRefusalValueSituation :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesBootItemSharedBootRefusalValue where parseJSON = checked "WorkerMessagesBootItemSharedBootRefusalValue" $ withObject "WorkerMessagesBootItemSharedBootRefusalValue" (\fields -> WorkerMessagesBootItemSharedBootRefusalValue <$> (fields .: "bootRefusal") <*> (fields .: "name") <*> (fields .: "situation"))

instance ToJSON WorkerMessagesBootItemSharedBootRefusalValue where toJSON value = Object (KM.fromList (concat [[("bootRefusal", toJSON (workerMessagesBootItemSharedBootRefusalValueBootRefusal value))], [("name", toJSON (workerMessagesBootItemSharedBootRefusalValueName value))], [("situation", toJSON (workerMessagesBootItemSharedBootRefusalValueSituation value))]]))

data WorkerMessagesDetailsItem = WorkerMessagesDetailsItem
  { workerMessagesDetailsItemDetail :: Text,
    workerMessagesDetailsItemName :: Text,
    workerMessagesDetailsItemSituation :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesDetailsItem where parseJSON = checked "WorkerMessagesDetailsItem" $ withObject "WorkerMessagesDetailsItem" (\fields -> WorkerMessagesDetailsItem <$> (fields .: "detail") <*> (fields .: "name") <*> (fields .: "situation"))

instance ToJSON WorkerMessagesDetailsItem where toJSON value = Object (KM.fromList (concat [[("detail", toJSON (workerMessagesDetailsItemDetail value))], [("name", toJSON (workerMessagesDetailsItemName value))], [("situation", toJSON (workerMessagesDetailsItemSituation value))]]))

data WorkerMessagesErrorsItem = WorkerMessagesErrorsItem
  { workerMessagesErrorsItemError :: Text,
    workerMessagesErrorsItemName :: Text,
    workerMessagesErrorsItemSituation :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesErrorsItem where parseJSON = checked "WorkerMessagesErrorsItem" $ withObject "WorkerMessagesErrorsItem" (\fields -> WorkerMessagesErrorsItem <$> (fields .: "error") <*> (fields .: "name") <*> (fields .: "situation"))

instance ToJSON WorkerMessagesErrorsItem where toJSON value = Object (KM.fromList (concat [[("error", toJSON (workerMessagesErrorsItemError value))], [("name", toJSON (workerMessagesErrorsItemName value))], [("situation", toJSON (workerMessagesErrorsItemSituation value))]]))

data WorkerMessagesJob = WorkerMessagesJob
  { workerMessagesJobMark :: Text,
    workerMessagesJobYield :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesJob where parseJSON = checked "WorkerMessagesJob" $ withObject "WorkerMessagesJob" (\fields -> WorkerMessagesJob <$> (fields .: "mark") <*> (fields .: "yield"))

instance ToJSON WorkerMessagesJob where toJSON value = Object (KM.fromList (concat [[("mark", toJSON (workerMessagesJobMark value))], [("yield", toJSON (workerMessagesJobYield value))]]))

data WorkerMessagesLoggedItem = WorkerMessagesLoggedItem
  { workerMessagesLoggedItemCarries :: [Text],
    workerMessagesLoggedItemFields :: WorkerMessagesLoggedItemFields,
    workerMessagesLoggedItemLevel :: LogLevel,
    workerMessagesLoggedItemMessage :: Text,
    workerMessagesLoggedItemName :: Text,
    workerMessagesLoggedItemSituation :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesLoggedItem where parseJSON = checked "WorkerMessagesLoggedItem" $ withObject "WorkerMessagesLoggedItem" (\fields -> WorkerMessagesLoggedItem <$> (fields .: "carries") <*> (fields .: "fields") <*> (fields .: "level") <*> (fields .: "message") <*> (fields .: "name") <*> (fields .: "situation"))

instance ToJSON WorkerMessagesLoggedItem where toJSON value = Object (KM.fromList (concat [[("carries", toJSON (workerMessagesLoggedItemCarries value))], [("fields", toJSON (workerMessagesLoggedItemFields value))], [("level", toJSON (workerMessagesLoggedItemLevel value))], [("message", toJSON (workerMessagesLoggedItemMessage value))], [("name", toJSON (workerMessagesLoggedItemName value))], [("situation", toJSON (workerMessagesLoggedItemSituation value))]]))

data WorkerMessagesLoggedItemFields = WorkerMessagesLoggedItemFields
  { workerMessagesLoggedItemFieldsAdditionalProperties :: KM.KeyMap Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesLoggedItemFields where parseJSON = checked "WorkerMessagesLoggedItemFields" $ withObject "WorkerMessagesLoggedItemFields" (\fields -> WorkerMessagesLoggedItemFields <$> traverse parseJSON (withoutFields [] fields))

instance ToJSON WorkerMessagesLoggedItemFields where toJSON value = Object (KM.fromList (concat []) <> fmap toJSON (withoutFields [] (workerMessagesLoggedItemFieldsAdditionalProperties value)))

data WorkerMessagesReasonsItem = WorkerMessagesReasonsItem
  { workerMessagesReasonsItemLine :: Text,
    workerMessagesReasonsItemName :: Text,
    workerMessagesReasonsItemSituation :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesReasonsItem where parseJSON = checked "WorkerMessagesReasonsItem" $ withObject "WorkerMessagesReasonsItem" (\fields -> WorkerMessagesReasonsItem <$> (fields .: "line") <*> (fields .: "name") <*> (fields .: "situation"))

instance ToJSON WorkerMessagesReasonsItem where toJSON value = Object (KM.fromList (concat [[("line", toJSON (workerMessagesReasonsItemLine value))], [("name", toJSON (workerMessagesReasonsItemName value))], [("situation", toJSON (workerMessagesReasonsItemSituation value))]]))

data WorkerMessagesWaitsItem = WorkerMessagesWaitsItem
  { workerMessagesWaitsItemName :: Text,
    workerMessagesWaitsItemSaid :: Text,
    workerMessagesWaitsItemSituation :: Text
  }
  deriving (Eq, Show)

instance FromJSON WorkerMessagesWaitsItem where parseJSON = checked "WorkerMessagesWaitsItem" $ withObject "WorkerMessagesWaitsItem" (\fields -> WorkerMessagesWaitsItem <$> (fields .: "name") <*> (fields .: "said") <*> (fields .: "situation"))

instance ToJSON WorkerMessagesWaitsItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (workerMessagesWaitsItemName value))], [("said", toJSON (workerMessagesWaitsItemSaid value))], [("situation", toJSON (workerMessagesWaitsItemSituation value))]]))
