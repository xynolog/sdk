package xynolog

// Gather: assembling the context a model is given, and what refers to a
// resource.

import (
	"context"

	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/bus"
)

// GatherResourceDefaults is what Gather.Resource is given when nothing else
// is stated: each option's default of option_defaults_gen.go.
func GatherResourceDefaults() api.GatherResourceRequestOptions {
	return api.GatherResourceRequestOptions{
		Depth:          gatherResourceDepth,
		MaxResources:   gatherResourceMaxResources,
		IncludeContent: gatherResourceIncludeContent,
		IncludeSummary: gatherResourceIncludeSummary,
	}
}

// GatherNamespace is assembling the context a model is given, and what
// refers to a resource.
type GatherNamespace struct {
	links *links
	live  *live
}

// Annotation is the context around one annotation, as options say: the
// window and the source's context and the target's each as stated, and as
// the gatherer decides when nil. Options none of which is stated are not
// sent.
func (n *GatherNamespace) Annotation(resourceID api.ResourceId, annotationID api.AnnotationId, options api.GatherAnnotationOptions) *Running[api.GatherAnnotationComplete] {
	request := api.GatherAnnotationRequest{AnnotationId: annotationID, ResourceId: resourceID}
	if options != (api.GatherAnnotationOptions{}) {
		request.Options = &options
	}
	return &Running[api.GatherAnnotationComplete]{links: n.links, work: func(ctx context.Context, _ func(api.GatherAnnotationComplete)) (api.GatherAnnotationComplete, error) {
		return ask(ctx, n.links, bus.GatherRequested, request)
	}}
}

// Resource is the context around a whole resource, gathered as options say
// (GatherResourceDefaults, when nothing else is to be stated). Depth is how
// many links out from the resource the graph reaches, 1 to 3, nearest first:
// what a resource links to and what cites it are both followed. An empty
// exclusion excludes nothing, and is not sent.
func (n *GatherNamespace) Resource(ctx context.Context, resourceID api.ResourceId, options api.GatherResourceRequestOptions) (api.GatheredContext, error) {
	if options.ExcludeEntityTypes != nil && len(*options.ExcludeEntityTypes) == 0 {
		options.ExcludeEntityTypes = nil
	}
	gathered, err := ask(ctx, n.links, bus.GatherResourceRequested, api.GatherResourceRequest{ResourceId: resourceID, Options: options})
	return gathered.Response, err
}

// ReferencedBy is the annotations elsewhere that refer to a resource.
// Watching it holds the resource's scope.
func (n *GatherNamespace) ReferencedBy(resourceID api.ResourceId) *Cached[[]api.GetReferencedByResponseReferencedByItem] {
	return keyed(n.links, n.live.referencedBy, resourceID, itself[[]api.GetReferencedByResponseReferencedByItem], resourceID)
}
