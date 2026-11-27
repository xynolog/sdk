import { BehaviorSubject, type Subscription } from 'rxjs';
import type { XynologClient } from '../../client';
import {
  watched,
  type AnnotationId,
  type components,
  type GatheredContext,
  type GatherResourceOptions,
  type ResourceId,
  type StateUnit,
  type Watched,
} from '@xynolog/core';

export interface GatherStateUnit extends StateUnit {
  context$: Watched<GatheredContext | null>;
  loading$: Watched<boolean>;
  error$: Watched<Error | null>;
  annotationId$: Watched<AnnotationId | null>;
  /**
   * Resource-gather state: SEPARATE slots from the annotation trio above —
   * the two gathers can be live at once (wizard closed mid-load, Generate
   * open), and one BehaviorSubject cannot represent both. One fact per
   * observable.
   */
  resourceContext$: Watched<GatheredContext | null>;
  resourceLoading$: Watched<boolean>;
  resourceError$: Watched<Error | null>;
  /**
   * Gather the context around an annotation of this unit's resource. Asked of
   * the unit itself, as every gather is: a gather asked of one resource's unit
   * reaches no other.
   */
  gatherAnnotation(
    annotationId: AnnotationId,
    options?: components['schemas']['GatherAnnotationOptions'],
  ): void;
  /** Gather a resource-focus context. */
  gatherResource(resourceId: ResourceId, options?: GatherResourceOptions): void;
}

export function createGatherStateUnit(
  client: XynologClient,
  resourceId: ResourceId,
): GatherStateUnit {
  const subs: Subscription[] = [];
  const context$ = new BehaviorSubject<GatheredContext | null>(null);
  const loading$ = new BehaviorSubject<boolean>(false);
  const error$ = new BehaviorSubject<Error | null>(null);
  const annotationId$ = new BehaviorSubject<AnnotationId | null>(null);
  const resourceContext$ = new BehaviorSubject<GatheredContext | null>(null);
  const resourceLoading$ = new BehaviorSubject<boolean>(false);
  const resourceError$ = new BehaviorSubject<Error | null>(null);
  // A completed BehaviorSubject still takes a value from `next`, which its
  // `getValue` then gives: once disposed, nothing here may set one. And
  // `gather.resource` is a Promise, not a stream, so a resolution arriving
  // after dispose is dropped here (A5b).
  let disposed = false;

  const gatherResource = (
    rid: ResourceId,
    options?: GatherResourceOptions,
  ): void => {
    if (disposed) return;
    resourceLoading$.next(true);
    resourceError$.next(null);
    resourceContext$.next(null);
    client.gather
      .resource(rid, options)
      .then((ctx) => {
        if (disposed) return;
        resourceContext$.next(ctx);
        resourceLoading$.next(false);
      })
      .catch((err: unknown) => {
        if (disposed) return;
        resourceError$.next(
          err instanceof Error ? err : new Error(String(err)),
        );
        resourceLoading$.next(false);
      });
  };

  const gatherAnnotation = (
    annotationId: AnnotationId,
    options?: components['schemas']['GatherAnnotationOptions'],
  ): void => {
    if (disposed) return;
    loading$.next(true);
    error$.next(null);
    context$.next(null);
    annotationId$.next(annotationId);

    const gatherSub = client.gather
      .annotation(resourceId, annotationId, options)
      .subscribe({
        next: (gathered) => {
          context$.next(gathered.response);
          loading$.next(false);
        },
        error: (err) => {
          error$.next(err instanceof Error ? err : new Error(String(err)));
          loading$.next(false);
        },
        complete: () => {
          loading$.next(false);
        },
      });
    subs.push(gatherSub);
  };

  return {
    context$: watched(context$),
    loading$: watched(loading$),
    error$: watched(error$),
    annotationId$: watched(annotationId$),
    resourceContext$: watched(resourceContext$),
    resourceLoading$: watched(resourceLoading$),
    resourceError$: watched(resourceError$),
    gatherAnnotation,
    gatherResource,
    dispose() {
      disposed = true;
      subs.forEach((s) => s.unsubscribe());
      context$.complete();
      loading$.complete();
      error$.complete();
      annotationId$.complete();
      resourceContext$.complete();
      resourceLoading$.complete();
      resourceError$.complete();
    },
  };
}
