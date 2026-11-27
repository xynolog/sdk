(* What each cache refresh writer writes of the test's [written] table. *)

let go =
  {xx|// Code generated from protocol/specs/src/client/refresh.json; DO NOT EDIT.
//
// Regenerate: make generate (codegen/lib/cache_refresh/go.ml)

package xynolog

import (
	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/bus"
)

// The live queries a client's cache answers.
const (
	// resource event remove stream gap scope gap value refetch stream annotation
	// cache value frame cache scope remove write stream subject cache xxxxxxxxx
	// a closes it.
	CacheQueryThing CacheQuery = "thing"

	// query event event key annotation held remove refetch query annotation
	// frame value resource client scope reply remove query cache key scope
	// subject value frame reply annotation held a closes it.
	CacheQueryItems CacheQuery = "items"

	// Names.
	CacheQueryNames CacheQuery = "names"

	// Deep.
	CacheQueryDeep CacheQuery = "deep"

	// Labels.
	CacheQueryLabels CacheQuery = "labels"
)

// CacheQueries is every live query, in the table's order.
var CacheQueries = []CacheQuery{CacheQueryThing, CacheQueryItems, CacheQueryNames, CacheQueryDeep, CacheQueryLabels}

// PersistedCacheQueries is every live query a client keeps in its storage,
// in the table's order: each under its name (CacheKey).
var PersistedCacheQueries = []CacheQuery{CacheQueryThing, CacheQueryDeep}

// The type of the value each live query's cache holds for a key: the table's
// `value`, a component or a member within one.
type (
	thingValue  = api.Thing
	itemsValue  = []api.Item
	namesValue  = []string
	deepValue   = []api.Item
	labelsValue = string
)

// The triggers of the table.
const (
	CacheRefreshReopened    CacheRefreshTrigger = "reopened"
	CacheRefreshUnreadable  CacheRefreshTrigger = "unreadable"
	CacheRefreshDemoChanged CacheRefreshTrigger = "demo:changed"
	CacheRefreshDemoSaid    CacheRefreshTrigger = "demo:said"
)

// CacheRefreshChannels is each trigger of the table that is a channel of the
// bus, in the table's order.
var CacheRefreshChannels = []CacheRefreshTrigger{CacheRefreshDemoChanged, CacheRefreshDemoSaid}

// CacheRefreshTable is each trigger's rows.
var CacheRefreshTable = map[CacheRefreshTrigger][]CacheRefresh{
	// Docs.
	CacheRefreshReopened: {
		{Reach: CacheRefreshReachHeld, Refetches: []CacheQuery{CacheQueryThing, CacheQueryNames}},
	},

	// Docs.
	CacheRefreshUnreadable: {
		{Reach: CacheRefreshReachHeld, Refetches: []CacheQuery{CacheQueryThing, CacheQueryItems, CacheQueryNames}},
	},

	// enriched: It changed, and says how. unenriched: It changed.
	CacheRefreshDemoChanged: {
		{When: CacheRefreshWhenEnriched, Reach: CacheRefreshReachSubject, Names: CacheRefreshNames{Resource: CacheRefreshWay{"resourceId"}, Annotation: CacheRefreshWay{"annotation", "id"}}, Carries: CacheRefreshWay{"annotation"}, Refetches: []CacheQuery{CacheQueryThing}, Writes: []CacheQuery{CacheQueryItems}},
		{When: CacheRefreshWhenUnenriched, Reach: CacheRefreshReachSubject, Names: CacheRefreshNames{Resource: CacheRefreshWay{"resourceId"}, Annotation: CacheRefreshWay{"payload", "annotationId"}}, Refetches: []CacheQuery{CacheQueryItems, CacheQueryThing}, Removes: []CacheQuery{CacheQueryNames}},
	},

	// Something */ was said.
	CacheRefreshDemoSaid: {
		{Reach: CacheRefreshReachSubject, Refetches: []CacheQuery{CacheQueryNames}},
	},
}

// cacheRefreshReadings is how each channel of the table reads a frame:
// whether its payload is one of the channel's.
var cacheRefreshReadings = map[CacheRefreshTrigger]func(Frame) bool{
	CacheRefreshDemoChanged: scopedReadingOf(bus.DemoChanged),
	CacheRefreshDemoSaid:    readingOf(bus.DemoSaid),
}

// cacheActs is what the client's refresher does to each live query a row acts
// on. A query a row comes to act on is a method it lacks.
type cacheActs interface {
	refetchThing(reach CacheRefreshReach, subject cacheSubject)
	refetchItems(reach CacheRefreshReach, subject cacheSubject)
	refetchNames(reach CacheRefreshReach, subject cacheSubject)
	writeItems(subject cacheSubject)
	removeNames(subject cacheSubject)
}

// applyRefresh applies row to what subject names, by acts: its writes, its
// removes, then its refetches.
func applyRefresh(acts cacheActs, row CacheRefresh, subject cacheSubject) {
	for _, query := range row.Writes {
		switch query {
		case CacheQueryItems:
			acts.writeItems(subject)
		}
	}
	for _, query := range row.Removes {
		switch query {
		case CacheQueryNames:
			acts.removeNames(subject)
		}
	}
	for _, query := range row.Refetches {
		switch query {
		case CacheQueryThing:
			acts.refetchThing(row.Reach, subject)
		case CacheQueryItems:
			acts.refetchItems(row.Reach, subject)
		case CacheQueryNames:
			acts.refetchNames(row.Reach, subject)
		}
	}
}

// attach has the caches of the queries the table persists keep their values
// in persistence from now on, each beginning with what it kept.
func (v *live) attach(persistence *CachePersistence) {
	keepIn(v.thing, persistence, CacheQueryThing)
	keepIn(v.deep, persistence, CacheQueryDeep)
}
|xx}

let python =
  {xx|# Generated from protocol/specs/src/client/refresh.json; do not edit.
# Regenerate: make generate (codegen/lib/cache_refresh/python.ml)
# ruff: noqa: E501, I001, RUF002, RUF022, RUF100

"""What a Xynolog client asks again for, and when.

A client's live queries answer from a cache. This table says what each event
on the bus, the reopening of a dropped stream, and an event that cannot be
read, does to it: which queries are asked for again, which are written with
what the event carries, and which are gone. And it says where in an event its
row finds the resource and the annotation it names, and the value it carries.
"""

from collections.abc import Mapping
from dataclasses import dataclass
from types import MappingProxyType
from typing import Final, Literal, final

__all__ = [
    "CACHE_QUERIES",
    "CACHE_REFRESH",
    "CACHE_REFRESH_CHANNELS",
    "CacheQuery",
    "CacheRefresh",
    "CacheRefreshChannel",
    "CacheRefreshReach",
    "CacheRefreshTrigger",
    "CacheRefreshWay",
    "CacheRefreshWhen",
]

# The live queries a client's cache answers.
type CacheQuery = Literal[
    # resource event remove stream gap scope gap value refetch stream annotation cache value
    # frame cache scope remove write stream subject cache xxxxxxxxx a closes it.
    "thing",
    # query event event key annotation held remove refetch query annotation frame value resource
    # client scope reply remove query cache key scope subject value frame reply annotation held
    # a closes it.
    "items",
    # Names.
    "names",
    # Deep.
    "deep",
    # Labels.
    "labels",
]

CACHE_QUERIES: Final[tuple[CacheQuery, ...]] = (
    "thing",
    "items",
    "names",
    "deep",
    "labels",
)

# Which of a split channel's two kinds of event a row is for.
type CacheRefreshWhen = Literal["enriched", "unenriched"]

# `subject`: the keys the event names. `held`: every key the client holds.
type CacheRefreshReach = Literal["subject", "held"]

# What each trigger is: a channel whose events are it; `reopened`, the
# stream open again after a drop; or `unreadable`, an event on one of the
# table's channels that cannot be read.
type CacheRefreshTrigger = Literal[
    "reopened",
    "unreadable",
    "demo:changed",
    "demo:said",
]

# The triggers that are channels of the bus.
type CacheRefreshChannel = Literal[
    "demo:changed",
    "demo:said",
]

CACHE_REFRESH_CHANNELS: Final[tuple[CacheRefreshChannel, ...]] = (
    "demo:changed",
    "demo:said",
)

# A way to a member of an event (the frame's payload): the names of the
# members it is within, and its own.
type CacheRefreshWay = tuple[str, ...]


@final
@dataclass(frozen=True, slots=True, kw_only=True)
class CacheRefresh:
    """What one trigger does to the cache."""

    reach: CacheRefreshReach
    names_resource: CacheRefreshWay | None = None
    """The way to the resource a `subject` row reaches (a ResourceId)."""
    names_annotation: CacheRefreshWay | None = None
    """The way to the annotation a `subject` row reaches (an AnnotationId)."""
    carries: CacheRefreshWay | None = None
    """The way to the value the row writes (an Annotation). On a split channel, its presence is what makes an event enriched."""
    refetches: tuple[CacheQuery, ...] = ()
    """Asked for again, the value shown meanwhile."""
    writes: tuple[CacheQuery, ...] = ()
    """Written with the value the event carries."""
    removes: tuple[CacheQuery, ...] = ()
    """Gone: the key fails as `bus.not-found`."""
    when: CacheRefreshWhen | None = None


CACHE_REFRESH: Final[Mapping[CacheRefreshTrigger, tuple[CacheRefresh, ...]]] = MappingProxyType(
    {
        # Docs.
        "reopened": (CacheRefresh(reach="held", refetches=("thing", "names")),),
        # Docs.
        "unreadable": (CacheRefresh(reach="held", refetches=("thing", "items", "names")),),
        # enriched: It changed, and says how. unenriched: It changed.
        "demo:changed": (
            CacheRefresh(
                reach="subject",
                names_resource=("resourceId",),
                names_annotation=("annotation", "id"),
                carries=("annotation",),
                refetches=("thing",),
                writes=("items",),
                when="enriched",
            ),
            CacheRefresh(
                reach="subject",
                names_resource=("resourceId",),
                names_annotation=("payload", "annotationId"),
                refetches=("items", "thing"),
                removes=("names",),
                when="unenriched",
            ),
        ),
        # Something */ was said.
        "demo:said": (CacheRefresh(reach="subject", refetches=("names",)),),
    }
)
|xx}

let typescript =
  {xx|// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/client/refresh.json
// Regenerate:  make generate  (codegen/lib/cache_refresh/typescript.ml)

import type { components } from './types';

/** The live queries a client's cache answers. */
export const CACHE_QUERIES = [
  'thing',
  'items',
  'names',
  'deep',
  'labels',
] as const;
export type CacheQuery = (typeof CACHE_QUERIES)[number];

/** The live queries whose answers a client keeps across its lives, for the person signed in. */
export const PERSISTED_QUERIES = [
  'thing',
  'deep',
] as const;
export type PersistedQuery = (typeof PERSISTED_QUERIES)[number];

/** What each live query is asked for per: a resource, an annotation, or the filters it is asked with; `whole` for one asked for whole, whose one answer is kept under `wholeKey`. */
export const CACHE_PER = {
  'thing': 'resource',
  'items': 'resource',
  'names': 'whole',
  'deep': 'annotation',
  'labels': 'filters',
} as const satisfies { readonly [Q in CacheQuery]: 'resource' | 'annotation' | 'filters' | 'whole' };
export type CachePer = typeof CACHE_PER;

/** What each live query's cache holds, its `value`: the component, and the members within it the value is, outermost first. */
export const CACHE_VALUES = {
  'thing': { component: 'Thing', members: [] },
  'items': { component: 'Thing', members: [
    'items',
  ] },
  'names': { component: 'Thing', members: [
    'inner',
    'names',
  ] },
  'deep': { component: 'Thing', members: [
    'items',
  ] },
  'labels': { component: 'Thing', members: [
    'loose',
    'deep',
  ] },
} as const satisfies { readonly [Q in CacheQuery]: { readonly component: keyof components['schemas']; readonly members: readonly string[] } };

/** The type of what each live query's cache holds: `CACHE_VALUES`'s component, member within member. */
export interface CacheValues {
  'thing': components['schemas']['Thing'];
  'items': components['schemas']['Thing']['items'];
  'names': components['schemas']['Thing']['inner']['names'];
  'deep': components['schemas']['Thing']['items'];
  'labels': components['schemas']['Thing']['loose']['deep'];
}

/** Which of a split channel's two kinds of event a row is for. */
export type CacheRefreshWhen = 'enriched' | 'unenriched';

/** A way to a member of an event: the names of the members it is within, and its own. */
export type CacheRefreshWay = readonly string[];

/** What one trigger does to the cache. */
export interface CacheRefresh {
  readonly when?: CacheRefreshWhen;
  /** `subject`: the keys the event names. `held`: every key the client holds. */
  readonly reach: 'subject' | 'held';
  /** Where in the event the keys a `subject` row reaches are: the way to the resource it names (a ResourceId), and to the annotation (an AnnotationId). */
  readonly names: { readonly resource?: CacheRefreshWay; readonly annotation?: CacheRefreshWay };
  /** The way to the value the row writes (an Annotation). On a split channel, its presence is what makes an event enriched. */
  readonly carries?: CacheRefreshWay;
  /** Asked for again, the value shown meanwhile. */
  readonly refetches: readonly CacheQuery[];
  /** Written with the value the event carries. */
  readonly writes: readonly CacheQuery[];
  /** Gone: the key fails as `bus.not-found`. */
  readonly removes: readonly CacheQuery[];
}

/** What each trigger does: a channel's events; `reopened`, the stream open again after a drop; or `unreadable`, an event on one of these channels that cannot be read. */
export const CACHE_REFRESH = {
  /** Docs. */
  'reopened': [
    { reach: 'held', names: {}, refetches: [
      'thing',
      'names',
    ], writes: [], removes: [] },
  ],
  /** Docs. */
  'unreadable': [
    { reach: 'held', names: {}, refetches: [
      'thing',
      'items',
      'names',
    ], writes: [], removes: [] },
  ],
  /** enriched: It changed, and says how. unenriched: It changed. */
  'demo:changed': [
    { when: 'enriched', reach: 'subject', names: { resource: [
      'resourceId',
    ], annotation: [
      'annotation',
      'id',
    ] }, carries: [
      'annotation',
    ], refetches: [
      'thing',
    ], writes: [
      'items',
    ], removes: [] },
    { when: 'unenriched', reach: 'subject', names: { resource: [
      'resourceId',
    ], annotation: [
      'payload',
      'annotationId',
    ] }, refetches: [
      'items',
      'thing',
    ], writes: [], removes: [
      'names',
    ] },
  ],
  /** Something *\/ was said. */
  'demo:said': [
    { reach: 'subject', names: {}, refetches: [
      'names',
    ], writes: [], removes: [] },
  ],
} as const satisfies Record<string, readonly CacheRefresh[]>;

export type CacheRefreshTrigger = keyof typeof CACHE_REFRESH;

/** The triggers that are channels of the bus. */
export const CACHE_REFRESH_CHANNELS = [
  'demo:changed',
  'demo:said',
] as const;
export type CacheRefreshChannel = (typeof CACHE_REFRESH_CHANNELS)[number];
|xx}

let haskell =
  {xx|-- Generated from protocol/specs/src/client/refresh.json; do not edit.
-- Regenerate: make generate (codegen/lib/cache_refresh/haskell.ml)
{-# LANGUAGE OverloadedStrings #-}

module Xynolog.Internal.Generated.CacheRefresh (Query (..), ThingValue, ItemsValue, NamesValue, DeepValue, LabelsValue, Reach (..), Ways (..), Row (..), rows, channels, reopened, unreadable) where

import Data.Text (Text)
import Xynolog.Internal.Generated.Models.Item (Item)
import Xynolog.Internal.Generated.Models.Thing (Thing)

data Query = Thing | Items | Names | Deep | Labels deriving (Eq, Ord, Show, Enum, Bounded)

-- | The type of the value each live query's cache holds for a key: the table's `value`, a component or a member
-- within one.
type ThingValue = Thing

type ItemsValue = [Item]

type NamesValue = [Text]

type DeepValue = [Item]

type LabelsValue = Text

data Reach = Subject | Held deriving (Eq, Show)

-- | Where in its event a row finds the resource it names, the annotation it names, and the value it carries.
data Ways = Ways (Maybe [Text]) (Maybe [Text]) (Maybe [Text]) deriving (Eq, Show)

data Row = Row Text (Maybe Text) Reach Ways [Query] [Query] [Query] deriving (Eq, Show)

rows :: [Row]
rows = [Row "reopened" Nothing Held (Ways Nothing Nothing Nothing) [Thing, Names] [] [], Row "unreadable" Nothing Held (Ways Nothing Nothing Nothing) [Thing, Items, Names] [] [], Row "demo:changed" (Just "enriched") Subject (Ways (Just ["resourceId"]) (Just ["annotation", "id"]) (Just ["annotation"])) [Thing] [Items] [], Row "demo:changed" (Just "unenriched") Subject (Ways (Just ["resourceId"]) (Just ["payload", "annotationId"]) Nothing) [Items, Thing] [] [Names], Row "demo:said" Nothing Subject (Ways Nothing Nothing Nothing) [Names] [] []]

-- | The triggers that are channels of the bus.
channels :: [Text]
channels = ["demo:changed", "demo:said"]

reopened, unreadable :: Text
reopened = "reopened"
unreadable = "unreadable"
|xx}

let live_queries =
  {xx|-- Generated from protocol/specs/src/client/refresh.json; do not edit.
-- Regenerate: make generate (codegen/lib/cache_refresh/haskell.ml)
{-# LANGUAGE OverloadedStrings #-}

module LiveQueries (LiveQuery (..)) where

import Data.Aeson (FromJSON (..), withText)

data LiveQuery = Thing | Items | Names | Deep | Labels deriving (Eq, Show)

instance FromJSON LiveQuery where
  parseJSON = withText "LiveQuery" $ \value -> case value of
    "thing" -> pure Thing
    "items" -> pure Items
    "names" -> pure Names
    "deep" -> pure Deep
    "labels" -> pure Labels
    _ -> fail "unknown live query"
|xx}
