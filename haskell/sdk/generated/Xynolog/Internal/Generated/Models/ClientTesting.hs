-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.ClientTesting (ClientTesting (..), ClientTestingDelayMs (..), ClientTestingDeliveryOps (..), ClientTestingFaultActionsItem (..), ClientTestingRecordsItem (..), ClientTestingScheduleLength (..), ClientTestingSlack (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec

data ClientTesting = ClientTesting
  { clientTestingComment :: Text,
    clientTestingFaultActions :: [ClientTestingFaultActionsItem],
    clientTestingDelayMs :: ClientTestingDelayMs,
    clientTestingScheduleLength :: ClientTestingScheduleLength,
    clientTestingSlack :: ClientTestingSlack,
    clientTestingDeliveryOps :: ClientTestingDeliveryOps,
    clientTestingRecords :: [ClientTestingRecordsItem]
  }
  deriving (Eq, Show)

instance FromJSON ClientTesting where parseJSON = checked "ClientTesting" $ withObject "ClientTesting" (\fields -> ClientTesting <$> (fields .: "$comment") <*> (fields .: "faultActions") <*> (fields .: "delayMs") <*> (fields .: "scheduleLength") <*> (fields .: "slack") <*> (fields .: "deliveryOps") <*> (fields .: "records"))

instance ToJSON ClientTesting where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (clientTestingComment value))], [("faultActions", toJSON (clientTestingFaultActions value))], [("delayMs", toJSON (clientTestingDelayMs value))], [("scheduleLength", toJSON (clientTestingScheduleLength value))], [("slack", toJSON (clientTestingSlack value))], [("deliveryOps", toJSON (clientTestingDeliveryOps value))], [("records", toJSON (clientTestingRecords value))]]))

data ClientTestingDelayMs = ClientTestingDelayMs
  { clientTestingDelayMsDocs :: Text,
    clientTestingDelayMsMinimum :: Integer,
    clientTestingDelayMsMaximum :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ClientTestingDelayMs where parseJSON = checked "ClientTestingDelayMs" $ withObject "ClientTestingDelayMs" (\fields -> ClientTestingDelayMs <$> (fields .: "docs") <*> (fields .: "minimum") <*> (fields .: "maximum"))

instance ToJSON ClientTestingDelayMs where toJSON value = Object (KM.fromList (concat [[("docs", toJSON (clientTestingDelayMsDocs value))], [("minimum", toJSON (clientTestingDelayMsMinimum value))], [("maximum", toJSON (clientTestingDelayMsMaximum value))]]))

data ClientTestingDeliveryOps = ClientTestingDeliveryOps
  { clientTestingDeliveryOpsDocs :: Text,
    clientTestingDeliveryOpsOps :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON ClientTestingDeliveryOps where parseJSON = checked "ClientTestingDeliveryOps" $ withObject "ClientTestingDeliveryOps" (\fields -> ClientTestingDeliveryOps <$> (fields .: "docs") <*> (fields .: "ops"))

instance ToJSON ClientTestingDeliveryOps where toJSON value = Object (KM.fromList (concat [[("docs", toJSON (clientTestingDeliveryOpsDocs value))], [("ops", toJSON (clientTestingDeliveryOpsOps value))]]))

data ClientTestingFaultActionsItem = ClientTestingFaultActionsItem
  { clientTestingFaultActionsItemName :: Text,
    clientTestingFaultActionsItemKind :: Text,
    clientTestingFaultActionsItemDocs :: Text,
    clientTestingFaultActionsItemHolds :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON ClientTestingFaultActionsItem where parseJSON = checked "ClientTestingFaultActionsItem" $ withObject "ClientTestingFaultActionsItem" (\fields -> ClientTestingFaultActionsItem <$> (fields .: "name") <*> (fields .: "kind") <*> (fields .: "docs") <*> (fields .: "holds"))

instance ToJSON ClientTestingFaultActionsItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (clientTestingFaultActionsItemName value))], [("kind", toJSON (clientTestingFaultActionsItemKind value))], [("docs", toJSON (clientTestingFaultActionsItemDocs value))], [("holds", toJSON (clientTestingFaultActionsItemHolds value))]]))

data ClientTestingRecordsItem = ClientTestingRecordsItem
  { clientTestingRecordsItemName :: Text,
    clientTestingRecordsItemDocs :: Text,
    clientTestingRecordsItemMembers :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON ClientTestingRecordsItem where parseJSON = checked "ClientTestingRecordsItem" $ withObject "ClientTestingRecordsItem" (\fields -> ClientTestingRecordsItem <$> (fields .: "name") <*> (fields .: "docs") <*> (fields .: "members"))

instance ToJSON ClientTestingRecordsItem where toJSON value = Object (KM.fromList (concat [[("name", toJSON (clientTestingRecordsItemName value))], [("docs", toJSON (clientTestingRecordsItemDocs value))], [("members", toJSON (clientTestingRecordsItemMembers value))]]))

data ClientTestingScheduleLength = ClientTestingScheduleLength
  { clientTestingScheduleLengthDocs :: Text,
    clientTestingScheduleLengthMinimum :: Integer,
    clientTestingScheduleLengthMaximum :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ClientTestingScheduleLength where parseJSON = checked "ClientTestingScheduleLength" $ withObject "ClientTestingScheduleLength" (\fields -> ClientTestingScheduleLength <$> (fields .: "docs") <*> (fields .: "minimum") <*> (fields .: "maximum"))

instance ToJSON ClientTestingScheduleLength where toJSON value = Object (KM.fromList (concat [[("docs", toJSON (clientTestingScheduleLengthDocs value))], [("minimum", toJSON (clientTestingScheduleLengthMinimum value))], [("maximum", toJSON (clientTestingScheduleLengthMaximum value))]]))

data ClientTestingSlack = ClientTestingSlack
  { clientTestingSlackDocs :: Text,
    clientTestingSlackTimes :: Integer
  }
  deriving (Eq, Show)

instance FromJSON ClientTestingSlack where parseJSON = checked "ClientTestingSlack" $ withObject "ClientTestingSlack" (\fields -> ClientTestingSlack <$> (fields .: "docs") <*> (fields .: "times"))

instance ToJSON ClientTestingSlack where toJSON value = Object (KM.fromList (concat [[("docs", toJSON (clientTestingSlackDocs value))], [("times", toJSON (clientTestingSlackTimes value))]]))
