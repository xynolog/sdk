// Code generated from protocol/specs/src/session/stored.json; DO NOT EDIT.
//
// Regenerate: make generate (codegen/lib/stored/stored.ml)

package registry

// KnowledgeBasesKey: The registered knowledge bases: a JSON list of
// KnowledgeBase (components/schemas/KnowledgeBase.json).
const KnowledgeBasesKey = "xynolog.knowledgeBases"

// ActiveKey: The id of the active knowledge base. Nothing is kept under it
// while none is active.
const ActiveKey = "xynolog.activeKnowledgeBaseId"

// OpenResourcesByKbKey: What is open in each knowledge base: a JSON object
// from a knowledge base's id to the list of its open resources, each an
// `openResource`.
const OpenResourcesByKbKey = "xynolog.openResourcesByKb"

// LastViewedResourceByKbKey: Where the person was in each knowledge base: a
// JSON object from a knowledge base's id to the id of the resource last
// viewed in it.
const LastViewedResourceByKbKey = "xynolog.lastViewedResourceByKb"

// sessionKeyPrefix: A knowledge base's stored session is kept under this
// followed by the knowledge base's id.
const sessionKeyPrefix = "xynolog.session."
