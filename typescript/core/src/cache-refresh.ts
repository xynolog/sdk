// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/client/refresh.json
// Regenerate:  make generate  (codegen/lib/cache_refresh/typescript.ml)

import type { components } from './types';

/** The live queries a client's cache answers. */
export const CACHE_QUERIES = [
  'resource',
  'annotations',
  'annotation',
  'events',
  'referencedBy',
  'resources',
  'matchedResources',
  'entityTypes',
  'tagSchemas',
  'engines',
] as const;
export type CacheQuery = (typeof CACHE_QUERIES)[number];

/** The live queries whose answers a client keeps across its lives, for the person signed in. */
export const PERSISTED_QUERIES = [
  'resource',
  'annotations',
  'annotation',
  'entityTypes',
  'tagSchemas',
] as const;
export type PersistedQuery = (typeof PERSISTED_QUERIES)[number];

/** What each live query is asked for per: a resource, an annotation, or the filters it is asked with; `whole` for one asked for whole, whose one answer is kept under `wholeKey`. */
export const CACHE_PER = {
  resource: 'resource',
  annotations: 'resource',
  annotation: 'annotation',
  events: 'resource',
  referencedBy: 'resource',
  resources: 'filters',
  matchedResources: 'filters',
  entityTypes: 'whole',
  tagSchemas: 'whole',
  engines: 'whole',
} as const satisfies {
  readonly [Q in CacheQuery]: 'resource' | 'annotation' | 'filters' | 'whole';
};
export type CachePer = typeof CACHE_PER;

/** What each live query's cache holds, its `value`: the component, and the members within it the value is, outermost first. */
export const CACHE_VALUES = {
  resource: { component: 'ResourceDescriptor', members: [] },
  annotations: { component: 'GetAnnotationsResponse', members: [] },
  annotation: { component: 'Annotation', members: [] },
  events: { component: 'GetEventsResponse', members: ['events'] },
  referencedBy: {
    component: 'GetReferencedByResponse',
    members: ['referencedBy'],
  },
  resources: { component: 'ListResourcesResponse', members: [] },
  matchedResources: { component: 'MatchResourcesResponse', members: [] },
  entityTypes: {
    component: 'GetEntityTypesResponse',
    members: ['entityTypes'],
  },
  tagSchemas: { component: 'GetTagSchemasResponse', members: ['tagSchemas'] },
  engines: {
    component: 'BrowseEnginesResult',
    members: ['response', 'engines'],
  },
} as const satisfies {
  readonly [Q in CacheQuery]: {
    readonly component: keyof components['schemas'];
    readonly members: readonly string[];
  };
};

/** The type of what each live query's cache holds: `CACHE_VALUES`'s component, member within member. */
export interface CacheValues {
  resource: components['schemas']['ResourceDescriptor'];
  annotations: components['schemas']['GetAnnotationsResponse'];
  annotation: components['schemas']['Annotation'];
  events: components['schemas']['GetEventsResponse']['events'];
  referencedBy: components['schemas']['GetReferencedByResponse']['referencedBy'];
  resources: components['schemas']['ListResourcesResponse'];
  matchedResources: components['schemas']['MatchResourcesResponse'];
  entityTypes: components['schemas']['GetEntityTypesResponse']['entityTypes'];
  tagSchemas: components['schemas']['GetTagSchemasResponse']['tagSchemas'];
  engines: components['schemas']['BrowseEnginesResult']['response']['engines'];
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
  readonly names: {
    readonly resource?: CacheRefreshWay;
    readonly annotation?: CacheRefreshWay;
  };
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
  /** The stream is open again after a drop. Events every client hears carry no position, so the ones published meanwhile are lost and nothing replays them: the client asks again for everything they feed. What a resource's own scope feeds needs nothing here: its events are replayed from where the client left off, or `bus:resume-gap` says they could not be. */
  reopened: [
    {
      reach: 'held',
      names: {},
      refetches: [
        'resources',
        'matchedResources',
        'resource',
        'entityTypes',
        'tagSchemas',
        'engines',
      ],
      writes: [],
      removes: [],
    },
  ],
  /** A frame on a channel of this table that its reading refuses, or one a member of which the row names is present and is not what it names: something changed and nothing says what, so every key held is asked for again, as after a gap. */
  unreadable: [
    {
      reach: 'held',
      names: {},
      refetches: [
        'resource',
        'annotations',
        'annotation',
        'events',
        'referencedBy',
        'resources',
        'matchedResources',
        'entityTypes',
        'tagSchemas',
        'engines',
      ],
      writes: [],
      removes: [],
    },
  ],
  /** The gateway could not replay what a scope missed: everything held of that resource, and of its annotations, is asked for again. */
  'bus:resume-gap': [
    {
      reach: 'subject',
      names: { resource: ['scope'] },
      refetches: [
        'annotations',
        'annotation',
        'resource',
        'events',
        'referencedBy',
      ],
      writes: [],
      removes: [],
    },
  ],
  /** An annotation was added to the resource. */
  'mark:added': [
    {
      reach: 'subject',
      names: { resource: ['resourceId'] },
      refetches: ['annotations', 'events'],
      writes: [],
      removes: [],
    },
  ],
  /** An annotation was removed from the resource. */
  'mark:removed': [
    {
      reach: 'subject',
      names: {
        resource: ['resourceId'],
        annotation: ['payload', 'annotationId'],
      },
      refetches: ['annotations', 'events'],
      writes: [],
      removes: ['annotation'],
    },
  ],
  /** The reply to this client's own deletion: the annotation is gone whether or not the client holds the scope that would tell it so. */
  'mark:delete-ok': [
    {
      reach: 'subject',
      names: { annotation: ['response', 'annotationId'] },
      refetches: [],
      writes: [],
      removes: ['annotation'],
    },
  ],
  /** enriched: An annotation's body changed, and the event carries the annotation as it now is. unenriched: An annotation's body changed, and the event could not say what it now is. */
  'mark:body-updated': [
    {
      when: 'enriched',
      reach: 'subject',
      names: { resource: ['resourceId'], annotation: ['annotation', 'id'] },
      carries: ['annotation'],
      refetches: ['events'],
      writes: ['annotations', 'annotation'],
      removes: [],
    },
    {
      when: 'unenriched',
      reach: 'subject',
      names: {
        resource: ['resourceId'],
        annotation: ['payload', 'annotationId'],
      },
      refetches: ['annotations', 'annotation', 'events'],
      writes: [],
      removes: [],
    },
  ],
  /** An entity tag was added to the resource. */
  'mark:entity-tag-added': [
    {
      reach: 'subject',
      names: { resource: ['resourceId'] },
      refetches: ['annotations', 'resource', 'events'],
      writes: [],
      removes: [],
    },
  ],
  /** An entity tag was removed from the resource. */
  'mark:entity-tag-removed': [
    {
      reach: 'subject',
      names: { resource: ['resourceId'] },
      refetches: ['annotations', 'resource', 'events'],
      writes: [],
      removes: [],
    },
  ],
  /** The resource was archived, which its description states and lists filter on. */
  'mark:archived': [
    {
      reach: 'subject',
      names: { resource: ['resourceId'] },
      refetches: ['resource', 'resources', 'matchedResources'],
      writes: [],
      removes: [],
    },
  ],
  /** The resource was unarchived. */
  'mark:unarchived': [
    {
      reach: 'subject',
      names: { resource: ['resourceId'] },
      refetches: ['resource', 'resources', 'matchedResources'],
      writes: [],
      removes: [],
    },
  ],
  /** A resource was created. */
  'yield:created': [
    {
      reach: 'subject',
      names: { resource: ['resourceId'] },
      refetches: ['resource', 'resources', 'matchedResources'],
      writes: [],
      removes: [],
    },
  ],
  /** A resource was updated. */
  'yield:updated': [
    {
      reach: 'subject',
      names: { resource: ['resourceId'] },
      refetches: ['resource', 'resources', 'matchedResources'],
      writes: [],
      removes: [],
    },
  ],
  /** A resource was created as a clone. */
  'yield:cloned': [
    {
      reach: 'subject',
      names: { resource: ['resourceId'] },
      refetches: ['resource', 'resources', 'matchedResources'],
      writes: [],
      removes: [],
    },
  ],
  /** A resource was renamed or moved. */
  'yield:moved': [
    {
      reach: 'subject',
      names: { resource: ['resourceId'] },
      refetches: ['resource', 'resources', 'matchedResources'],
      writes: [],
      removes: [],
    },
  ],
  /** An entity type was added to the knowledge base. */
  'frame:entity-type-added': [
    {
      reach: 'subject',
      names: {},
      refetches: ['entityTypes'],
      writes: [],
      removes: [],
    },
  ],
  /** A tag schema was added to the knowledge base. */
  'frame:tag-schema-added': [
    {
      reach: 'subject',
      names: {},
      refetches: ['tagSchemas'],
      writes: [],
      removes: [],
    },
  ],
} as const satisfies Record<string, readonly CacheRefresh[]>;

export type CacheRefreshTrigger = keyof typeof CACHE_REFRESH;

/** The triggers that are channels of the bus. */
export const CACHE_REFRESH_CHANNELS = [
  'bus:resume-gap',
  'mark:added',
  'mark:removed',
  'mark:delete-ok',
  'mark:body-updated',
  'mark:entity-tag-added',
  'mark:entity-tag-removed',
  'mark:archived',
  'mark:unarchived',
  'yield:created',
  'yield:updated',
  'yield:cloned',
  'yield:moved',
  'frame:entity-type-added',
  'frame:tag-schema-added',
] as const;
export type CacheRefreshChannel = (typeof CACHE_REFRESH_CHANNELS)[number];
