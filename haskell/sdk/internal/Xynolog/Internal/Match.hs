{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Match (MatchNamespace, newMatch, search, requestSearch, resources, controls, dispose) where

import Control.Concurrent.STM (STM)
import Data.Maybe (fromMaybe)
import Data.Text (Text)
import Xynolog.Bus qualified as Bus
import Xynolog.Channels
import Xynolog.Internal.Cache qualified as Cache
import Xynolog.Internal.Generated.CacheRefresh qualified as Fact
import Xynolog.Internal.Generated.OptionDefaults qualified as Option
import Xynolog.Internal.Generated.TimingSettings qualified as Timing
import Xynolog.Internal.Local qualified as Local
import Xynolog.Internal.Queries (cacheOptions, oneReport)
import Xynolog.Internal.Refresh qualified as Refresh
import Xynolog.Internal.Running qualified as Running
import Xynolog.Internal.Transport qualified as LocalBus
import Xynolog.Types

data MatchNamespace = MatchNamespace Bus.Bus LocalBus.EventBus Timing.Settings (Cache.Cache MatchResourcesRequest Fact.MatchedResourcesValue)

newMatch :: Bus.Bus -> LocalBus.EventBus -> Bus.BusOptions -> Timing.Settings -> IO MatchNamespace
newMatch wire local clock timing =
  MatchNamespace wire local timing
    <$> Cache.newCache
      (\input -> matchResourcesResultResponse <$> Bus.request wire MatchResourcesRequestedOperation input (Timing.busRequestTimeoutMs timing))
      (cacheOptions clock (const (pure (pure ()))))

search :: MatchNamespace -> ResourceId -> AnnotationId -> GatheredContext -> Maybe MatchSearchOptions -> IO (Running.Running MatchSearchResult MatchSearchResult)
search (MatchNamespace wire _ timing _) identity reference context options =
  oneReport $
    Bus.request
      wire
      MatchSearchRequestedOperation
      (MatchSearchRequest {matchSearchRequestContext = context, matchSearchRequestLimit = (Just (fromMaybe Option.matchSearchLimit (matchSearchOptionsLimit chosen))), matchSearchRequestReferenceId = reference, matchSearchRequestResourceId = identity, matchSearchRequestUseSemanticScoring = (matchSearchOptionsUseSemanticScoring chosen)})
      (Timing.busRequestTimeoutMs timing)
  where
    chosen = fromMaybe (MatchSearchOptions Nothing Nothing) options

requestSearch :: MatchNamespace -> MatchSearchRequest -> Text -> STM ()
requestSearch (MatchNamespace _ local _ _) input correlation = Local.signalWithCorrelation local MatchSearchRequested input NoScope (Just correlation)

resources :: MatchNamespace -> Text -> Maybe BrowseResourcesRequest -> Cache.Query MatchResourcesResponse
resources (MatchNamespace _ _ _ cache) text filters =
  Cache.query
    cache
    (MatchResourcesRequest {matchResourcesRequestArchived = (browseResourcesRequestArchived selected), matchResourcesRequestEntityType = (browseResourcesRequestEntityType selected), matchResourcesRequestLimit = (browseResourcesRequestLimit selected), matchResourcesRequestOffset = (browseResourcesRequestOffset selected), matchResourcesRequestSearch = text})
  where
    selected = fromMaybe (BrowseResourcesRequest {browseResourcesRequestArchived = Nothing, browseResourcesRequestEntityType = Nothing, browseResourcesRequestLimit = Nothing, browseResourcesRequestOffset = Nothing}) filters

controls :: MatchNamespace -> [(Fact.Query, Refresh.Acts)]
controls (MatchNamespace _ _ _ cache) =
  [ ( Fact.MatchedResources,
      Refresh.Acts
        (Refresh.cacheTargets cache (\_ _ -> True))
        Nothing
        Nothing
    )
  ]

dispose :: MatchNamespace -> IO ()
dispose (MatchNamespace _ _ _ cache) = Cache.dispose cache
