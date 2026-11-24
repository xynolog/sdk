"""Match: searching, for what a reference could refer to and for resources by text."""

from typing import Final, final

from xynolog.cached import Cached, Keyed, itself
from xynolog.identifiers import AnnotationId, ResourceId
from xynolog.namespaces.links import Links
from xynolog.namespaces.live import LIST_LIMIT, Live
from xynolog.operations import MATCH_SEARCH_REQUESTED
from xynolog.running import Running
from xynolog.types import GatheredContext, MatchResourcesRequest, MatchResourcesResponse, MatchSearchRequest, MatchSearchResult

__all__ = ["MatchNamespace"]

# What a caller that states nothing is given. Every SDK asks for as many: the
# cases of protocol/specs/src/client/surface.json hold each to it.
_CANDIDATES: Final = 10


@final
class MatchNamespace:
    """See the module's documentation."""

    def __init__(self, links: Links, live: Live) -> None:
        self._links: Final = links
        self._live: Final = live

    def search(
        self,
        resource_id: ResourceId,
        reference_id: AnnotationId,
        context: GatheredContext,
        *,
        limit: int | None = None,
        use_semantic_scoring: bool | None = None,
    ) -> Running[MatchSearchResult]:
        """Candidates for a reference, given its gathered context: ten, scored semantically, when nothing else is stated."""
        request = MatchSearchRequest(
            resource_id=resource_id,
            reference_id=reference_id,
            context=context,
            limit=_CANDIDATES if limit is None else limit,
            use_semantic_scoring=True if use_semantic_scoring is None else use_semantic_scoring,
        )
        return Running(lambda _: self._links.run(self._links.request(MATCH_SEARCH_REQUESTED, request)))

    def request_search(self, input: MatchSearchRequest, correlation_id: str) -> None:
        """Signal: a search is wanted. The client's own state runs it, and answers under `correlation_id`."""
        self._links.signal(MATCH_SEARCH_REQUESTED.request, input, correlation_id=correlation_id)

    def resources(
        self,
        search: str,
        *,
        archived: bool | None = None,
        entity_type: str | None = None,
        offset: int | None = None,
        limit: int | None = None,
    ) -> Cached[MatchResourcesResponse]:
        """A page of the resources a search for `search` finds, among those the filters admit: the first hundred when nothing is stated.

        `offset` of them are passed over before the page begins.

        The text is matched lexically and, when nothing matches, by meaning:
        the answer's `match_kind` says which it is.
        """
        return self._live.query(
            Keyed(
                self._live.searches,
                MatchResourcesRequest(
                    search=search,
                    archived=archived,
                    entity_type=entity_type,
                    offset=offset or 0,
                    limit=LIST_LIMIT if limit is None else limit,
                ),
                itself,
            )
        )
