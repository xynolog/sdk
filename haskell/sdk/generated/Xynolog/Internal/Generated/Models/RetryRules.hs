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
    retryRulesRefresh :: RetryRulesRefresh,
    retryRulesTransport :: RetryRulesTransport
  }
  deriving (Eq, Show)

instance FromJSON RetryRules where parseJSON = checked "RetryRules" $ withObject "RetryRules" (\fields -> RetryRules <$> (fields .: "$comment") <*> (fields .: "boot") <*> (fields .: "job") <*> (fields .: "refresh") <*> (fields .: "transport"))

instance ToJSON RetryRules where toJSON value = Object (KM.fromList (concat [[("$comment", toJSON (retryRulesComment value))], [("boot", toJSON (retryRulesBoot value))], [("job", toJSON (retryRulesJob value))], [("refresh", toJSON (retryRulesRefresh value))], [("transport", toJSON (retryRulesTransport value))]]))

data RetryRulesBoot = RetryRulesBoot
  { retryRulesBootStatuses :: [HttpStatus]
  }
  deriving (Eq, Show)

instance FromJSON RetryRulesBoot where parseJSON = checked "RetryRulesBoot" $ withObject "RetryRulesBoot" (\fields -> RetryRulesBoot <$> (fields .: "statuses"))

instance ToJSON RetryRulesBoot where toJSON value = Object (KM.fromList (concat [[("statuses", toJSON (retryRulesBootStatuses value))]]))

data RetryRulesJob = RetryRulesJob
  { retryRulesJobStatusFrom :: HttpStatus,
    retryRulesJobStatuses :: [HttpStatus]
  }
  deriving (Eq, Show)

instance FromJSON RetryRulesJob where parseJSON = checked "RetryRulesJob" $ withObject "RetryRulesJob" (\fields -> RetryRulesJob <$> (fields .: "statusFrom") <*> (fields .: "statuses"))

instance ToJSON RetryRulesJob where toJSON value = Object (KM.fromList (concat [[("statusFrom", toJSON (retryRulesJobStatusFrom value))], [("statuses", toJSON (retryRulesJobStatuses value))]]))

data RetryRulesRefresh = RetryRulesRefresh
  { retryRulesRefreshNoResponse :: Bool,
    retryRulesRefreshStatusFrom :: HttpStatus,
    retryRulesRefreshStatuses :: [HttpStatus]
  }
  deriving (Eq, Show)

instance FromJSON RetryRulesRefresh where parseJSON = checked "RetryRulesRefresh" $ withObject "RetryRulesRefresh" (\fields -> RetryRulesRefresh <$> (fields .: "noResponse") <*> (fields .: "statusFrom") <*> (fields .: "statuses"))

instance ToJSON RetryRulesRefresh where toJSON value = Object (KM.fromList (concat [[("noResponse", toJSON (retryRulesRefreshNoResponse value))], [("statusFrom", toJSON (retryRulesRefreshStatusFrom value))], [("statuses", toJSON (retryRulesRefreshStatuses value))]]))

data RetryRulesTransport = RetryRulesTransport
  { retryRulesTransportIdempotentMethods :: [Text],
    retryRulesTransportStatuses :: [HttpStatus]
  }
  deriving (Eq, Show)

instance FromJSON RetryRulesTransport where parseJSON = checked "RetryRulesTransport" $ withObject "RetryRulesTransport" (\fields -> RetryRulesTransport <$> (fields .: "idempotentMethods") <*> (fields .: "statuses"))

instance ToJSON RetryRulesTransport where toJSON value = Object (KM.fromList (concat [[("idempotentMethods", toJSON (retryRulesTransportIdempotentMethods value))], [("statuses", toJSON (retryRulesTransportStatuses value))]]))
