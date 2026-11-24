-- | Open resources are per knowledge base. A failed check is not evidence
-- that a resource is gone; only an affirmative not-found verdict removes it.
module Xynolog.Registry.Resources (OpenResource (..), TabCheck (..), TabVerdict (..), applyTabChecks, sortOpenResources) where

import Data.List (sortOn)
import Data.Map.Strict qualified as Map
import Xynolog.Types

applyTabChecks :: [OpenResource] -> Map.Map ResourceId TabCheck -> [OpenResource]
applyTabChecks opened checks = concatMap apply opened
  where
    apply resource = case Map.lookup (openResourceId resource) checks of
      Just (TabCheckGone _) -> []
      Just (TabCheckReady checked) ->
        [ resource
            { openResourceName = tabCheckReadyValueName checked,
              openResourceMediaType = case tabCheckReadyValueMediaType checked of Nothing -> openResourceMediaType resource; Just media -> Just media
            }
        ]
      Just (TabCheckUnknown _) -> [resource]
      Nothing -> [resource]

sortOpenResources :: [OpenResource] -> [OpenResource]
sortOpenResources = sortOn (\resource -> (openResourceOrder resource, openResourceOpenedAt resource))
