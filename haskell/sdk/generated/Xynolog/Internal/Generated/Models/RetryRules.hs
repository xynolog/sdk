-- Generated from protocol/specs/src; do not edit.
-- Regenerate: make generate (codegen/lib/haskell_sdk/haskell_sdk.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.Models.RetryRules (RetryRules (..), RetryRulesBoot (..), RetryRulesJob (..), RetryRulesRefresh (..), RetryRulesTransport (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value (..), withObject, (.:))
import Data.Aeson.KeyMap qualified as KM
import Data.Text (Text)
import Xynolog.Internal.Codec
import Xynolog.Internal.Generated.Models.HttpStatus

data RetryRules = RetryRules
  { retryRulesComment :: Text,
    retryRulesBoot :: RetryRulesBoot,
    retryRulesJob :: RetryRulesJob,
    retryRulesTransport :: RetryRulesTransport,
    retryRulesRefresh :: RetryRulesRefresh
  }
  deriving (Eq, Show)

instance FromJSON RetryRules where parseJSON = checked "RetryRules" $ withObject "RetryRules" (\fields -> RetryRules <$> (fields .: "$comment") <*> (fields .: "boot") <*> (fields .: "job") <*> (fields .: "transport") <*> (fields .: "refresh"))

instance ToJSON RetryRules where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (retryRulesComment value))], [("boot", toJSON (retryRulesBoot value))], [("job", toJSON (retryRulesJob value))], [("transport", toJSON (retryRulesTransport value))], [("refresh", toJSON (retryRulesRefresh value))]]))

data RetryRulesBoot = RetryRulesBoot
  { retryRulesBootStatuses :: [HttpStatus]
  }
  deriving (Eq, Show)

instance FromJSON RetryRulesBoot where parseJSON = checked "RetryRulesBoot" $ withObject "RetryRulesBoot" (\fields -> RetryRulesBoot <$> (fields .: "statuses"))

instance ToJSON RetryRulesBoot where toJSON value = Object (KM.fromList (concat [[("statuses", toJSON (retryRulesBootStatuses value))]]))

data RetryRulesJob = RetryRulesJob
  { retryRulesJobStatuses :: [HttpStatus],
    retryRulesJobStatusFrom :: HttpStatus
  }
  deriving (Eq, Show)

instance FromJSON RetryRulesJob where parseJSON = checked "RetryRulesJob" $ withObject "RetryRulesJob" (\fields -> RetryRulesJob <$> (fields .: "statuses") <*> (fields .: "statusFrom"))

instance ToJSON RetryRulesJob where toJSON value = Object (KM.fromList (concat [[("statuses", toJSON (retryRulesJobStatuses value))], [("statusFrom", toJSON (retryRulesJobStatusFrom value))]]))

data RetryRulesRefresh = RetryRulesRefresh
  { retryRulesRefreshStatuses :: [HttpStatus],
    retryRulesRefreshStatusFrom :: HttpStatus,
    retryRulesRefreshNoResponse :: Bool
  }
  deriving (Eq, Show)

instance FromJSON RetryRulesRefresh where parseJSON = checked "RetryRulesRefresh" $ withObject "RetryRulesRefresh" (\fields -> RetryRulesRefresh <$> (fields .: "statuses") <*> (fields .: "statusFrom") <*> (fields .: "noResponse"))

instance ToJSON RetryRulesRefresh where toJSON value = Object (KM.fromList (concat [[("statuses", toJSON (retryRulesRefreshStatuses value))], [("statusFrom", toJSON (retryRulesRefreshStatusFrom value))], [("noResponse", toJSON (retryRulesRefreshNoResponse value))]]))

data RetryRulesTransport = RetryRulesTransport
  { retryRulesTransportStatuses :: [HttpStatus],
    retryRulesTransportIdempotentMethods :: [Text]
  }
  deriving (Eq, Show)

instance FromJSON RetryRulesTransport where parseJSON = checked "RetryRulesTransport" $ withObject "RetryRulesTransport" (\fields -> RetryRulesTransport <$> (fields .: "statuses") <*> (fields .: "idempotentMethods"))

instance ToJSON RetryRulesTransport where toJSON value = Object (KM.fromList (concat [[("statuses", toJSON (retryRulesTransportStatuses value))], [("idempotentMethods", toJSON (retryRulesTransportIdempotentMethods value))]]))
