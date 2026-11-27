package xynolog

// Match: searching, for what a reference could refer to, and for resources
// by text.

import (
	"context"

	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/bus"
)

// What a caller that states nothing is given. Every SDK sends the same: the
// cases of protocol/specs/src/client/surface.json hold each to it.
const matchCandidates = 10

// MatchNamespace is searching: for what a reference could refer to, and for
// resources by text.
type MatchNamespace struct {
	links *links
	live  *live
}

// Search is the candidates for a reference, given its gathered context: ten
// when Limit is nil, scored as the Librarian scores unasked when
// UseSemanticScoring is nil.
func (n *MatchNamespace) Search(resourceID api.ResourceId, referenceID api.AnnotationId, gathered api.GatheredContext, options api.MatchSearchOptions) *Running[api.MatchSearchResult] {
	limit := matchCandidates
	if options.Limit != nil {
		limit = *options.Limit
	}
	request := api.MatchSearchRequest{ResourceId: resourceID, ReferenceId: referenceID, Context: gathered, Limit: &limit, UseSemanticScoring: options.UseSemanticScoring}
	return &Running[api.MatchSearchResult]{links: n.links, work: func(ctx context.Context, _ func(api.MatchSearchResult)) (api.MatchSearchResult, error) {
		return ask(ctx, n.links, bus.MatchSearchRequested, request)
	}}
}

// RequestSearch signals that a search is wanted. The client's own state runs
// it, and answers under correlationID.
func (n *MatchNamespace) RequestSearch(input api.MatchSearchRequest, correlationID string) {
	signal(n.links, bus.MatchSearchRequested.Request(), input, Envelope{CorrelationID: correlationID})
}

// Resources is a page of the resources a search for search finds, among
// those filters admits: the Librarian's own page when filters states none.
// The text is matched lexically and, when nothing matches, by meaning: the
// answer's MatchKind says which it is.
func (n *MatchNamespace) Resources(search string, filters api.ResourceSearchFilters) *Cached[api.MatchResourcesResponse] {
	return keyed(n.links, n.live.matchedResources, searchKey{search: search, filters: sentKeyOf(filters)}, itself[api.MatchResourcesResponse], api.ResourceId{})
}
