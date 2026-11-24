{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.RetryPolicy (RetryRule (..), ruleName, retryable, repeatableMethod) where

import Data.Text (Text)
import Data.Text qualified as T
import Xynolog.Tables (retryRules)
import Xynolog.Types

data RetryRule = Boot | Job | Transport | Refresh deriving (Eq, Ord, Show, Enum, Bounded)

ruleName :: RetryRule -> Text
ruleName Boot = "boot"
ruleName Job = "job"
ruleName Transport = "transport"
ruleName Refresh = "refresh"

retryable :: RetryRule -> Maybe Int -> Maybe Text -> Bool -> Bool
retryable Boot status _ _ = maybe False (among (retryRulesBootStatuses (retryRulesBoot retryRules))) status
retryable Job status _ _ =
  let rule = retryRulesJob retryRules
   in maybe False (\value -> among (retryRulesJobStatuses rule) value || from (retryRulesJobStatusFrom rule) value) status
retryable Transport status method keyed =
  maybe False (among (retryRulesTransportStatuses (retryRulesTransport retryRules))) status
    && (keyed || maybe False repeatableMethod method)
retryable Refresh status _ _ =
  let rule = retryRulesRefresh retryRules
   in maybe (retryRulesRefreshNoResponse rule) (\value -> among (retryRulesRefreshStatuses rule) value || from (retryRulesRefreshStatusFrom rule) value) status

repeatableMethod :: Text -> Bool
repeatableMethod method = T.toUpper method `elem` retryRulesTransportIdempotentMethods (retryRulesTransport retryRules)

among :: [HttpStatus] -> Int -> Bool
among statuses value = toInteger value `elem` map httpStatusValue statuses

from :: HttpStatus -> Int -> Bool
from bound value = toInteger value >= httpStatusValue bound
