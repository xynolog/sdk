//! Gather: assembling the context a model is given, and what refers to a
//! resource. The second is a query (`Cached`): it answers from the client's
//! cache, and the client's refresher (`super::refresher`) keeps it true.

use crate::cache::Cache;
use crate::cached::{Cached, Keyed};
use crate::channels::{GatherReferencedByRequested, GatherRequested, GatherResourceRequested};
use crate::client::Links;
use crate::errors::XynologError;
use crate::running::Running;
use crate::state_unit::StateUnit;
use crate::types::{AnnotationId, ResourceId};
use crate::types::{
    GatherAnnotationComplete, GatherAnnotationOptions, GatherAnnotationRequest,
    GatherReferencedByRequest, GatherResourceOptions, GatherResourceRequest,
    GatherResourceRequestOptions, GatheredContext, GetReferencedByResponseReferencedByItem,
};

/// An annotation elsewhere that refers to a resource.
pub(super) type ReferencedBy = GetReferencedByResponseReferencedByItem;

/// How much of the source an annotation's context takes, in characters,
/// when its caller states no window. Every SDK sends the same: the cases of
/// protocol/specs/src/client/surface.json hold each to it.
const CONTEXT_WINDOW: u16 = 2000;

/// What a resource's context takes when its caller states nothing: two hops
/// of the graph, ten resources, their content, and no summary. Held by the
/// same cases.
const DEPTH: u16 = 2;
const MAX_RESOURCES: u16 = 10;
const INCLUDE_CONTENT: bool = true;
const INCLUDE_SUMMARY: bool = false;

pub struct GatherNamespace {
    links: Links,
    /// What refers to each resource asked about. Kept as long as the client
    /// is: an answer of the graph, asked for again by the next client.
    pub(super) referenced_by: Cache<ResourceId, Vec<ReferencedBy>>,
}

impl GatherNamespace {
    pub(crate) fn new(links: Links) -> GatherNamespace {
        let referenced_by = Cache::new({
            let links = links.clone();
            move |resource_id: ResourceId| {
                let links = links.clone();
                async move {
                    let answer = links
                        .request::<GatherReferencedByRequested>(&GatherReferencedByRequest {
                            resource_id,
                            motivation: None,
                        })
                        .await?;
                    Ok(answer.response.referenced_by)
                }
            }
        });
        GatherNamespace {
            links,
            referenced_by,
        }
    }

    /// End the query: every watcher's stream ends.
    pub(crate) fn dispose(&self) {
        self.referenced_by.dispose();
    }

    /// The annotations elsewhere that refer to a resource, kept per
    /// resource. Watching it holds the resource's scope.
    pub fn referenced_by(
        &self,
        resource_id: &ResourceId,
    ) -> Cached<Vec<GetReferencedByResponseReferencedByItem>> {
        Cached::of(Keyed {
            cache: self.referenced_by.clone(),
            key: resource_id.clone(),
            view: |value| value,
            scope: Some((self.links.transport.clone(), resource_id.clone())),
        })
    }

    /// The context around one annotation, as `options` say: a window of two
    /// thousand characters of its source when they state none, and the
    /// source's context and the target's each included or left out as
    /// stated, and as the gatherer decides when not.
    pub fn annotation(
        &self,
        resource_id: &ResourceId,
        annotation_id: &AnnotationId,
        options: GatherAnnotationOptions,
    ) -> Running<GatherAnnotationComplete> {
        let links = self.links.clone();
        let request = GatherAnnotationRequest {
            annotation_id: annotation_id.clone(),
            resource_id: resource_id.clone(),
            options: Some(GatherAnnotationOptions {
                context_window: Some(options.context_window.unwrap_or(CONTEXT_WINDOW)),
                ..options
            }),
        };
        Running::new(|_| async move { links.request::<GatherRequested>(&request).await })
    }

    /// The context around a whole resource. An empty exclusion excludes
    /// nothing, and is not sent.
    pub async fn resource(
        &self,
        resource_id: &ResourceId,
        options: GatherResourceOptions,
    ) -> Result<GatheredContext, XynologError> {
        let GatherResourceOptions {
            depth,
            max_resources,
            include_content,
            include_summary,
            exclude_entity_types,
        } = options;
        let gathered = self
            .links
            .request::<GatherResourceRequested>(&GatherResourceRequest {
                resource_id: resource_id.clone(),
                options: GatherResourceRequestOptions {
                    depth: depth.unwrap_or(DEPTH),
                    max_resources: max_resources.unwrap_or(MAX_RESOURCES),
                    include_content: include_content.unwrap_or(INCLUDE_CONTENT),
                    include_summary: include_summary.unwrap_or(INCLUDE_SUMMARY),
                    exclude_entity_types: exclude_entity_types.filter(|types| !types.is_empty()),
                },
            })
            .await?;
        Ok(gathered.response)
    }
}

impl Drop for GatherNamespace {
    fn drop(&mut self) {
        self.dispose();
    }
}
