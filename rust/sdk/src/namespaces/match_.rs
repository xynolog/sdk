//! Match: searching, for what a reference could refer to and for resources
//! by text. The second is a query (`Cached`): it answers from the client's
//! cache, and the client's refresher (`super::refresher`) keeps it true.

use crate::cache::Cache;
use crate::cached::{Cached, Keyed};
use crate::channels::{MatchResourcesRequested, MatchSearchRequested};
use crate::client::Links;
use crate::option_defaults::MATCH_SEARCH_LIMIT;
use crate::running::Running;
use crate::state_unit::StateUnit;
use crate::transport::Envelope;
use crate::types::{
    AnnotationId, GatheredContext, MatchResourcesRequest, MatchResourcesResponse,
    MatchSearchOptions, MatchSearchRequest, MatchSearchResult, ResourceId, ResourceSearchFilters,
};

/// A search for resources: the text, and which resources it is among.
pub(super) type ResourceSearch = (String, ResourceSearchFilters);

pub struct MatchNamespace {
    links: Links,
    /// What each search asked for found. Kept as long as the client is.
    pub(super) matched_resources: Cache<ResourceSearch, MatchResourcesResponse>,
}

impl MatchNamespace {
    pub(crate) fn new(links: Links) -> MatchNamespace {
        let matched_resources = Cache::new({
            let links = links.clone();
            move |(search, filters): ResourceSearch| {
                let links = links.clone();
                async move {
                    let request = MatchResourcesRequest {
                        search,
                        limit: filters.limit,
                        offset: filters.offset,
                        archived: filters.archived,
                        entity_type: filters.entity_type,
                    };
                    let answer = links.request::<MatchResourcesRequested>(&request).await?;
                    Ok(answer.response)
                }
            }
        });
        MatchNamespace {
            links,
            matched_resources,
        }
    }

    /// End the query: every watcher's stream ends.
    pub(crate) fn dispose(&self) {
        self.matched_resources.dispose();
    }

    /// A page of the resources among those `filters` admits that a search
    /// for `search` finds, kept per search and set of filters: the page they
    /// state, and the service's own when they state none. The text is
    /// matched lexically and, when nothing matches, by meaning: the
    /// answer's `match_kind` says which it is. A search is a query's
    /// answer: it is asked for again when a resource is created, updated,
    /// cloned or moved, and when a dropped stream reopens, and not by a
    /// change to a resource whose scope the client does not hold.
    pub fn resources(
        &self,
        search: &str,
        filters: ResourceSearchFilters,
    ) -> Cached<MatchResourcesResponse> {
        Cached::of(Keyed {
            cache: self.matched_resources.clone(),
            key: (search.to_owned(), filters),
            view: |value| value,
            scope: None,
        })
    }

    /// Candidates for a reference, given its gathered context. A search
    /// that states no limit asks for `MATCH_SEARCH_LIMIT`, and one that does not say how it
    /// is scored is scored as the service decides.
    pub fn search(
        &self,
        resource_id: &ResourceId,
        reference_id: &AnnotationId,
        context: GatheredContext,
        options: MatchSearchOptions,
    ) -> Running<MatchSearchResult> {
        let links = self.links.clone();
        let request = MatchSearchRequest {
            resource_id: resource_id.clone(),
            reference_id: reference_id.clone(),
            context,
            limit: Some(options.limit.unwrap_or(MATCH_SEARCH_LIMIT)),
            use_semantic_scoring: options.use_semantic_scoring,
        };
        Running::new(|_| async move { links.request::<MatchSearchRequested>(&request).await })
    }

    /// Signal: a search is wanted. The client's own state runs it, and
    /// answers under `correlation_id`.
    pub fn request_search(&self, input: MatchSearchRequest, correlation_id: &str) {
        self.links.signal::<MatchSearchRequested>(
            &input,
            Envelope {
                correlation_id: Some(correlation_id.to_owned()),
                scope: None,
            },
        );
    }
}

impl Drop for MatchNamespace {
    fn drop(&mut self) {
        self.dispose();
    }
}
