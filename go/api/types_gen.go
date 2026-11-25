// Code generated from the component schemas of protocol/specs/src/openapi.json, the client types of protocol/specs/src/client/types and protocol/specs/src/client/discovery-absent.json — DO NOT EDIT.
//
// Regenerate: make generate (codegen/lib/go_types/go_types.ml)

package api

import "encoding/json"

// AboutParams launcher.about's params.
type AboutParams struct {
	// ApiVersion The version of the control API the request is written to.
	ApiVersion ApiVersion `json:"apiVersion"`
}

// AboutResult What the launcher is. A client asks this first, to learn
// whether it speaks to the launcher it found.
type AboutResult struct {
	// Version The version stamped into the launcher at build. Absent from a
	// development build, which states none.
	Version *string `json:"version,omitempty"`
	// Development Whether this is a development build: one with no version
	// stamped.
	Development bool `json:"development"`
	// Commit The commit it was built from, when stamped.
	Commit *string `json:"commit,omitempty"`
	// Built When it was built, when stamped.
	Built *string `json:"built,omitempty"`
	// ApiVersions Each version of the control API it speaks. A client that
	// speaks none of them stops here.
	ApiVersions []string `json:"apiVersions"`
	// ImageRegistry The registry its catalog's images come from.
	ImageRegistry string `json:"imageRegistry"`
	// Runtimes Each container runtime it drives, in the order it prefers them,
	// and whether this machine has it.
	Runtimes []RuntimeState `json:"runtimes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v AboutResult) MarshalJSON() ([]byte, error) {
	type written AboutResult
	v.ApiVersions = listOf(v.ApiVersions)
	v.Runtimes = listOf(v.Runtimes)
	return json.Marshal(written(v))
}

// Agent Web Annotation / W3C PROV Agent. Discriminated by @type — Person,
// Organization, or Software (named member schemas: AgentPerson,
// AgentOrganization, AgentSoftware). Software peers are first-class
// participants, not a sub-class of Person.
type Agent struct {
	union[AgentMember]
}

// AgentMember is a member of Agent: AgentPerson, AgentOrganization,
// AgentSoftware.
type AgentMember interface {
	memberOfAgent()
}

// Discriminator is the `@type` this value states.
func (u Agent) Discriminator() (string, error) { return u.stated("@type") }

// Member is the member this value is: the one whose schema admits it.
func (u Agent) Member() (any, error) { return u.member("Agent", agentMembers) }

// agentMembers is what each member of Agent admits, and how a value of it is
// read.
var agentMembers = []unionMember{
	{"AgentPerson", readAs[AgentPerson], []signature{{kind: objectKind, required: []string{"@type"}, fixed: []fixedValues{{"@type", []any{"Person"}}}}}},
	{"AgentOrganization", readAs[AgentOrganization], []signature{{kind: objectKind, required: []string{"@type", "name"}, fixed: []fixedValues{{"@type", []any{"Organization"}}}}}},
	{"AgentSoftware", readAs[AgentSoftware], []signature{{kind: objectKind, required: []string{"@type"}, fixed: []fixedValues{{"@type", []any{"Software"}}}}}},
}

func (Agent) memberOfOneOrMoreAgents() {}

// AgentOrganization An organization — the Organization branch of Agent.
type AgentOrganization struct {
	Type     AgentOrganizationType `json:"@type"`
	Id       *string               `json:"@id,omitempty"`
	Name     string                `json:"name"`
	Homepage *string               `json:"homepage,omitempty"`
	// AdditionalProperties is every member the schema does not name, as it came.
	AdditionalProperties map[string]any `json:"-"`
}

func (AgentOrganization) memberOfAgent()         {}
func (AgentOrganization) told() (string, string) { return "@type", "Organization" }

// MarshalJSON writes v with the members its schema does not name, and each
// list its schema requires that Go holds as nil as the empty list.
func (v AgentOrganization) MarshalJSON() ([]byte, error) {
	type written AgentOrganization
	return writeOpen(written(v), v.AdditionalProperties)
}

// UnmarshalJSON reads v, and each member its schema does not name into its
// AdditionalProperties.
func (v *AgentOrganization) UnmarshalJSON(raw []byte) error {
	type read AgentOrganization
	return readOpen(raw, (*read)(v), &v.AdditionalProperties)
}

type AgentOrganizationType string

// The values of AgentOrganizationType.
const (
	AgentOrganizationTypeOrganization AgentOrganizationType = "Organization"
)

// Valid is whether e is one of AgentOrganizationType's values.
func (e AgentOrganizationType) Valid() bool {
	switch e {
	case AgentOrganizationTypeOrganization:
		return true
	}
	return false
}

// AgentPerson A human participant — the Person branch of Agent.
type AgentPerson struct {
	Type AgentPersonType `json:"@type"`
	// Id DID-shaped identifier (e.g. did:web:host:users:email%40host)
	Id *string `json:"@id,omitempty"`
	// Name Display name. ABSENT until resolved: a Person is identified by `@id`
	// and nothing else, and what they are called is recorded once per change on
	// the knowledge base's own log and filled in when a record is read. An
	// artifact therefore never freezes a name, which is what lets a correction
	// reach every artifact its subject ever wrote. Absent also means genuinely
	// unknown — a DID this knowledge base has no profile for.
	Name      *string `json:"name,omitempty"`
	Nickname  *string `json:"nickname,omitempty"`
	Email     *string `json:"email,omitempty"`
	EmailSha1 *string `json:"email_sha1,omitempty"`
	Homepage  *string `json:"homepage,omitempty"`
	// AdditionalProperties is every member the schema does not name, as it came.
	AdditionalProperties map[string]any `json:"-"`
}

func (AgentPerson) memberOfAgent()         {}
func (AgentPerson) told() (string, string) { return "@type", "Person" }

// MarshalJSON writes v with the members its schema does not name, and each
// list its schema requires that Go holds as nil as the empty list.
func (v AgentPerson) MarshalJSON() ([]byte, error) {
	type written AgentPerson
	return writeOpen(written(v), v.AdditionalProperties)
}

// UnmarshalJSON reads v, and each member its schema does not name into its
// AdditionalProperties.
func (v *AgentPerson) UnmarshalJSON(raw []byte) error {
	type read AgentPerson
	return readOpen(raw, (*read)(v), &v.AdditionalProperties)
}

type AgentPersonType string

// The values of AgentPersonType.
const (
	AgentPersonTypePerson AgentPersonType = "Person"
)

// Valid is whether e is one of AgentPersonType's values.
func (e AgentPersonType) Valid() bool {
	switch e {
	case AgentPersonTypePerson:
		return true
	}
	return false
}

// AgentSoftware A software peer, the Software branch of Agent: an agent,
// which is an account as a person is. Its `provider` and `model` are what it
// says of itself, attributed to it and not checked; the knowledge base reads
// neither from its DID. Its `name` is no part of what it writes: what it last
// said it is called is its profile, and readers fill it in, as they do a
// person's. A generator the knowledge base supplies, for an agent that
// supplied none, carries `@type` and `@id` alone.
type AgentSoftware struct {
	Type AgentSoftwareType `json:"@type"`
	// Id The agent's DID: did:web:<domain>:agents:<subject>, its account at the
	// knowledge base's issuer
	Id *string `json:"@id,omitempty"`
	// Name What the agent last said it is called. ABSENT until resolved: filled
	// in from its profile when a record is read, as a Person's name is. Absent
	// also where it has said nothing. Not parsed.
	Name *string `json:"name,omitempty"`
	// Provider Inference provider (e.g. ollama, anthropic)
	Provider *string `json:"provider,omitempty"`
	// Model Model identifier (e.g. gemma2:27b, claude-3-5-sonnet)
	Model *string `json:"model,omitempty"`
	// Parameters Inference parameters (temperature, maxTokens, systemPrompt,
	// etc.). Runtime metadata, not part of identity.
	Parameters *map[string]any `json:"parameters,omitempty"`
	// AdditionalProperties is every member the schema does not name, as it came.
	AdditionalProperties map[string]any `json:"-"`
}

func (AgentSoftware) memberOfAgent()         {}
func (AgentSoftware) told() (string, string) { return "@type", "Software" }

// MarshalJSON writes v with the members its schema does not name, and each
// list its schema requires that Go holds as nil as the empty list.
func (v AgentSoftware) MarshalJSON() ([]byte, error) {
	type written AgentSoftware
	return writeOpen(written(v), v.AdditionalProperties)
}

// UnmarshalJSON reads v, and each member its schema does not name into its
// AdditionalProperties.
func (v *AgentSoftware) UnmarshalJSON(raw []byte) error {
	type read AgentSoftware
	return readOpen(raw, (*read)(v), &v.AdditionalProperties)
}

type AgentSoftwareType string

// The values of AgentSoftwareType.
const (
	AgentSoftwareTypeSoftware AgentSoftwareType = "Software"
)

// Valid is whether e is one of AgentSoftwareType's values.
func (e AgentSoftwareType) Valid() bool {
	switch e {
	case AgentSoftwareTypeSoftware:
		return true
	}
	return false
}

// AnchorMethod How a quoted selection was found in a text. Which word a span
// is found by is reconcile's rule
// (specs/src/annotations/reconcile-cases.json).
type AnchorMethod string

// The values of AnchorMethod.
const (
	AnchorMethodUniqueMatch      AnchorMethod = "unique-match"
	AnchorMethodContextRecovered AnchorMethod = "context-recovered"
	AnchorMethodFirstOfMany      AnchorMethod = "first-of-many"
	AnchorMethodFuzzyMatch       AnchorMethod = "fuzzy-match"
)

// Valid is whether e is one of AnchorMethod's values.
func (e AnchorMethod) Valid() bool {
	switch e {
	case AnchorMethodUniqueMatch, AnchorMethodContextRecovered, AnchorMethodFirstOfMany, AnchorMethodFuzzyMatch:
		return true
	}
	return false
}

// AnchorRect Where a clicked annotation's element is on the viewer's screen:
// its rectangle in viewport pixels, as a DOM rectangle states it. A viewer's
// own geometry: it rides a viewer's local frames, and a frame another
// participant's screen receives carries none.
type AnchorRect struct {
	// X The rectangle's horizontal origin.
	X float64 `json:"x"`
	// Y The rectangle's vertical origin.
	Y float64 `json:"y"`
	// Width The rectangle's width.
	Width float64 `json:"width"`
	// Height The rectangle's height.
	Height float64 `json:"height"`
	// Top The rectangle's top edge.
	Top float64 `json:"top"`
	// Right The rectangle's right edge.
	Right float64 `json:"right"`
	// Bottom The rectangle's bottom edge.
	Bottom float64 `json:"bottom"`
	// Left The rectangle's left edge.
	Left float64 `json:"left"`
}

// AnchoredText Text paired with the geometry that indexes it — the minimum
// needed to turn a range of the text, two offsets counted in Unicode code
// points, into a selection, or a rectangle into a quote. Whole-resource: a
// producer iterates page by page, but every consumer wants one map.
type AnchoredText struct {
	// Text Reading-order text of the whole resource.
	Text string `json:"text"`
	// Items Positioned runs indexing `text`, roughly one per word.
	Items []PdfTextItem `json:"items"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v AnchoredText) MarshalJSON() ([]byte, error) {
	type written AnchoredText
	v.Items = listOf(v.Items)
	return json.Marshal(written(v))
}

// AnchoredTextAbsent There is no coordinate map to serve, and WHY — the
// distinction a bare null could not carry. One member covers all three
// absences because none carries a payload; `kind` alone is the fact.
// Retryability is legible from the name, deliberately: a caller must not need
// a lookup table to decide whether to come back.
type AnchoredTextAbsent struct {
	// Kind Discriminant, sharing the `kind` field with the
	// ExtractedText/ExtractionDeclined members so the whole answer is one flat
	// union. `not-yet` — the resource's media type has text that is derived by
	// reading its content, and the store holds no entry for this content: the
	// Smelter has not read it yet, or the entry was lost (a loss the Smelter's
	// reconcile pass re-derives). RETRY. `no-map` — the resource's media type
	// has no derived text, so no entry exists and none will until the type is
	// given a reader. Decided by the media type alone, and answered at once.
	// TERMINAL. `unknown` — no content identity to look up: the resource is not
	// in the view store, or its primary representation carries no checksum.
	// TERMINAL.
	Kind AnchoredTextAbsentKind `json:"kind"`
}

func (AnchoredTextAbsent) memberOfAnchoredTextAnswer() {}

// AnchoredTextAbsentKind Discriminant, sharing the `kind` field with the
// ExtractedText/ExtractionDeclined members so the whole answer is one flat
// union. `not-yet` — the resource's media type has text that is derived by
// reading its content, and the store holds no entry for this content: the
// Smelter has not read it yet, or the entry was lost (a loss the Smelter's
// reconcile pass re-derives). RETRY. `no-map` — the resource's media type has
// no derived text, so no entry exists and none will until the type is given a
// reader. Decided by the media type alone, and answered at once. TERMINAL.
// `unknown` — no content identity to look up: the resource is not in the view
// store, or its primary representation carries no checksum. TERMINAL.
type AnchoredTextAbsentKind string

// The values of AnchoredTextAbsentKind.
const (
	AnchoredTextAbsentKindNotYet  AnchoredTextAbsentKind = "not-yet"
	AnchoredTextAbsentKindNoMap   AnchoredTextAbsentKind = "no-map"
	AnchoredTextAbsentKindUnknown AnchoredTextAbsentKind = "unknown"
)

// Valid is whether e is one of AnchoredTextAbsentKind's values.
func (e AnchoredTextAbsentKind) Valid() bool {
	switch e {
	case AnchoredTextAbsentKindNotYet, AnchoredTextAbsentKindNoMap, AnchoredTextAbsentKindUnknown:
		return true
	}
	return false
}

// AnchoredTextAnswer What a reader gets when it asks for a resource's
// coordinate map: the map, a stored decline, or a named absence. Distinct
// from `ExtractionOutcome` on purpose. That type is what the STORE holds and
// what an extractor RETURNS — neither of which can ever be 'not yet'. This is
// the read answer, which can, so widening ExtractionOutcome itself would have
// put an impossible state into the store's own type. Flat, one discriminant:
// every member carries `kind`, rather than nesting an outcome inside a status
// envelope and giving the wire two `kind` fields at different depths.
type AnchoredTextAnswer struct {
	union[AnchoredTextAnswerMember]
}

// AnchoredTextAnswerMember is a member of AnchoredTextAnswer: ExtractedText,
// ExtractionDeclined, AnchoredTextAbsent.
type AnchoredTextAnswerMember interface {
	memberOfAnchoredTextAnswer()
}

// Discriminator is the `kind` this value states.
func (u AnchoredTextAnswer) Discriminator() (string, error) { return u.stated("kind") }

// Member is the member this value is: the one whose schema admits it.
func (u AnchoredTextAnswer) Member() (any, error) {
	return u.member("AnchoredTextAnswer", anchoredTextAnswerMembers)
}

// anchoredTextAnswerMembers is what each member of AnchoredTextAnswer admits,
// and how a value of it is read.
var anchoredTextAnswerMembers = []unionMember{
	{"ExtractedText", readAs[ExtractedText], []signature{{kind: objectKind, required: []string{"text", "items", "kind", "method"}, fixed: []fixedValues{{"kind", []any{"extracted"}}, {"method", []any{"text-passthrough", "pdf-text-layer", "table", "form", "ocr"}}, {"pdfClass", []any{"A", "B", "C", "D", "E", "F", "G"}}}}}},
	{"ExtractionDeclined", readAs[ExtractionDeclined], []signature{{kind: objectKind, required: []string{"kind", "declined"}, fixed: []fixedValues{{"kind", []any{"declined"}}, {"declined", []any{"no-text-layer", "encrypted", "corrupt", "too-large"}}}}}},
	{"AnchoredTextAbsent", readAs[AnchoredTextAbsent], []signature{{kind: objectKind, required: []string{"kind"}, fixed: []fixedValues{{"kind", []any{"not-yet", "no-map", "unknown"}}}}}},
}

// AnchoredTextDeclinedEntry The bytes were declined: no text is extracted
// from them.
type AnchoredTextDeclinedEntry struct {
	// V The entry format.
	V AnchoredTextDeclinedEntryV `json:"v"`
	// Stamp The stamp the entry was derived under: the PDF reader's and the OCR
	// engine's. A reader takes the entry only when it equals the stamp the
	// Smelter last stated.
	Stamp string `json:"stamp"`
	// Declined Why extraction yielded nothing, by class.
	Declined ExtractionDeclinedReason `json:"declined"`
}

func (AnchoredTextDeclinedEntry) memberOfAnchoredTextEntry() {}

// AnchoredTextDeclinedEntryV The entry format.
type AnchoredTextDeclinedEntryV int

// The values of AnchoredTextDeclinedEntryV.
const (
	AnchoredTextDeclinedEntryV3 AnchoredTextDeclinedEntryV = 3
)

// Valid is whether e is one of AnchoredTextDeclinedEntryV's values.
func (e AnchoredTextDeclinedEntryV) Valid() bool {
	switch e {
	case AnchoredTextDeclinedEntryV3:
		return true
	}
	return false
}

// AnchoredTextEntries The keys of the entries the anchored-text store holds
// under the stamp last stated: one checksum for each set of bytes whose text
// is stored, in no order.
type AnchoredTextEntries struct {
	Checksums []string `json:"checksums"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v AnchoredTextEntries) MarshalJSON() ([]byte, error) {
	type written AnchoredTextEntries
	v.Checksums = listOf(v.Checksums)
	return json.Marshal(written(v))
}

// AnchoredTextEntry One entry of the anchored-text store: the file
// `<ab>/<cd>/<key>.json` under the store's directory, where the key is the
// SHA-256 of the bytes the text was extracted from, in hex. The Smelter
// derives it and stores it over the Archivist's HTTP surface
// (`AnchoredTextWrite`); the Archivist writes it, as compact JSON with `v`
// and `stamp` first, to a sibling temporary file renamed onto the path. The
// stamp the Smelter states (`AnchoredTextStamp`) is kept, followed by a
// newline, in the file `STAMP` at the store's root.
type AnchoredTextEntry struct {
	union[AnchoredTextEntryMember]
}

// AnchoredTextEntryMember is a member of AnchoredTextEntry:
// AnchoredTextExtractedEntry, AnchoredTextDeclinedEntry.
type AnchoredTextEntryMember interface {
	memberOfAnchoredTextEntry()
}

// Member is the member this value is: the one whose schema admits it.
func (u AnchoredTextEntry) Member() (any, error) {
	return u.member("AnchoredTextEntry", anchoredTextEntryMembers)
}

// anchoredTextEntryMembers is what each member of AnchoredTextEntry admits,
// and how a value of it is read.
var anchoredTextEntryMembers = []unionMember{
	{"AnchoredTextExtractedEntry", readAs[AnchoredTextExtractedEntry], []signature{{kind: objectKind, required: []string{"v", "stamp", "text", "lines", "method"}, allowed: []string{"v", "stamp", "text", "lines", "method", "pdfClass", "ocrConfidence", "unreadPages"}, fixed: []fixedValues{{"v", []any{3}}, {"method", []any{"text-passthrough", "pdf-text-layer", "table", "form", "ocr"}}, {"pdfClass", []any{"A", "B", "C", "D", "E", "F", "G"}}}}}},
	{"AnchoredTextDeclinedEntry", readAs[AnchoredTextDeclinedEntry], []signature{{kind: objectKind, required: []string{"v", "stamp", "declined"}, allowed: []string{"v", "stamp", "declined"}, fixed: []fixedValues{{"v", []any{3}}, {"declined", []any{"no-text-layer", "encrypted", "corrupt", "too-large"}}}}}},
}

// AnchoredTextExtractedEntry The text extracted from the bytes, where each
// word is on the page, and how it was extracted.
type AnchoredTextExtractedEntry struct {
	// V The entry format.
	V AnchoredTextExtractedEntryV `json:"v"`
	// Stamp The stamp the entry was derived under: the PDF reader's and the OCR
	// engine's. A reader takes the entry only when it equals the stamp the
	// Smelter last stated.
	Stamp string `json:"stamp"`
	// Text The extracted text.
	Text string `json:"text"`
	// Lines Where each word of `text` is, line by line, in reading order.
	Lines []AnchoredTextExtractedEntryLinesItem `json:"lines"`
	// Method How the text was extracted.
	Method ExtractionMethod `json:"method"`
	// PdfClass PDF classification, when the source was a PDF.
	PdfClass *PdfClass `json:"pdfClass,omitempty"`
	// OcrConfidence How well the engine read the pixels, when any of this text
	// came from OCR.
	OcrConfidence *OcrConfidence `json:"ocrConfidence,omitempty"`
	// UnreadPages 1-indexed pages this extraction could not read — present only
	// for partially covered documents (class C).
	UnreadPages *[]int `json:"unreadPages,omitempty"`
}

func (AnchoredTextExtractedEntry) memberOfAnchoredTextEntry() {}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v AnchoredTextExtractedEntry) MarshalJSON() ([]byte, error) {
	type written AnchoredTextExtractedEntry
	v.Lines = listOf(v.Lines)
	return json.Marshal(written(v))
}

// AnchoredTextExtractedEntryLinesItem One line of text: the words that share
// a page, a baseline and a height.
type AnchoredTextExtractedEntryLinesItem struct {
	// P The page, counted from 1.
	P int `json:"p"`
	// Y The line's vertical position in PDF points, from the bottom of the page.
	Y float64 `json:"y"`
	// H The line's height in PDF points.
	H float64 `json:"h"`
	// Words Each word as `[x, width, start, end]`: its horizontal position and
	// width in PDF points, and the offsets of its text in `text`, which are
	// whole numbers of Unicode code points from the start of `text`.
	Words [][]float64 `json:"words"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v AnchoredTextExtractedEntryLinesItem) MarshalJSON() ([]byte, error) {
	type written AnchoredTextExtractedEntryLinesItem
	v.Words = listOf(v.Words)
	return json.Marshal(written(v))
}

// AnchoredTextExtractedEntryV The entry format.
type AnchoredTextExtractedEntryV int

// The values of AnchoredTextExtractedEntryV.
const (
	AnchoredTextExtractedEntryV3 AnchoredTextExtractedEntryV = 3
)

// Valid is whether e is one of AnchoredTextExtractedEntryV's values.
func (e AnchoredTextExtractedEntryV) Valid() bool {
	switch e {
	case AnchoredTextExtractedEntryV3:
		return true
	}
	return false
}

// AnchoredTextStamp The stamp an anchored-text store's entries are taken
// under: which PDF reader and which OCR engine derived them. Its writer
// states it before it writes or lists an entry; an entry stored under another
// stamp is answered to no reader.
type AnchoredTextStamp struct {
	// Stamp The stamp: no white space, since it is held in a file of one line.
	Stamp string `json:"stamp"`
}

// AnchoredTextWrite A write of an anchored-text entry for the bytes of one
// resource: what the Smelter derived from them, and their checksum. The
// Archivist files the entry under the checksum, so every resource whose bytes
// those are has it, and refuses the write when the resource's first
// representation has other bytes.
type AnchoredTextWrite struct {
	// ContentChecksum The SHA-256 of the bytes the text was derived from, as 64
	// lower-case hexadecimal digits: the key the entry is filed under.
	ContentChecksum string            `json:"contentChecksum"`
	Entry           AnchoredTextEntry `json:"entry"`
}

type Annotation struct {
	// Context W3C Web Annotation JSON-LD context
	Context AnnotationContext `json:"@context"`
	// Type W3C Annotation type
	Type       AnnotationType `json:"type"`
	Id         AnnotationId   `json:"id"`
	Motivation Motivation     `json:"motivation"`
	// Target W3C Web Annotation target: the id of the resource annotated, when
	// the whole of it is, or an object with source and optional selector
	// (fragment)
	Target AnnotationTargetValue `json:"target"`
	// Body W3C Web Annotation body. Optional per the W3C spec — annotations
	// whose motivation alone is meaningful (highlighting) legitimately omit it.
	// Present values are either a single body or a non-empty array of bodies;
	// there is no empty array.
	Body *AnnotationBodies `json:"body,omitempty"`
	// Creator Web Annotation creator — who requested the annotation. DERIVED by
	// the knowledge base at write time, never accepted from an emitter (a
	// payload carrying it is refused): the verified emitter of the write, or,
	// when the write cites a job, the verified emitter of the job:create that
	// produced it. A Person for human-requested work; a Software peer for
	// autonomous-agent work.
	Creator *Agent `json:"creator,omitempty"`
	// Created When the annotation was MADE — the authoring moment, carried from
	// the event that created it. Not when a projection happened to write it: a
	// store that rebuilds from the log must preserve this value, never restamp
	// it.
	Created  string  `json:"created"`
	Modified *string `json:"modified,omitempty"`
	// Generator Web Annotation generator — the Software peer that produced the
	// annotation, when software did. Absent for a person's own annotation. An
	// emitter may supply it to carry the model's parameters, but its identity
	// must be the emitter's own: the knowledge base refuses a generator naming
	// anyone else, and supplies it from the verified emitter when omitted. One
	// producer per write — a write carrying the array form is refused.
	Generator *OneOrMoreAgents `json:"generator,omitempty"`
	// WasAttributedTo PROV-O wasAttributedTo — every party responsible for this
	// annotation, DERIVED by the knowledge base from `creator` and the verified
	// executor of the write: `[creator, generator]` when one agent requested the
	// work and software produced it; collapsed to the one agent when requester
	// and producer are the same. Never accepted from an emitter.
	WasAttributedTo *OneOrMoreAgents `json:"wasAttributedTo,omitempty"`
}

// AnnotationAddedPayload Payload for mark:added domain event
type AnnotationAddedPayload struct {
	Annotation Annotation `json:"annotation"`
	// ContentChecksum SHA-256 of resource content at annotation time
	ContentChecksum *string `json:"contentChecksum,omitempty"`
}

// AnnotationBodies What an annotation's `body` holds: one body, or a
// non-empty list of them. There is no empty list: an annotation with nothing
// to say has no `body`.
type AnnotationBodies struct {
	union[AnnotationBodiesMember]
}

// AnnotationBodiesMember is a member of AnnotationBodies: AnnotationBody,
// AnnotationBodiesList.
type AnnotationBodiesMember interface {
	memberOfAnnotationBodies()
}

// Member is the member this value is: the one whose schema admits it.
func (u AnnotationBodies) Member() (any, error) {
	return u.member("AnnotationBodies", annotationBodiesMembers)
}

// annotationBodiesMembers is what each member of AnnotationBodies admits, and
// how a value of it is read.
var annotationBodiesMembers = []unionMember{
	{"AnnotationBody", readAs[AnnotationBody], []signature{{kind: objectKind, required: []string{"type", "value"}, fixed: []fixedValues{{"type", []any{"TextualBody"}}, {"purpose", []any{"assessing", "bookmarking", "classifying", "commenting", "describing", "editing", "highlighting", "identifying", "linking", "moderating", "questioning", "replying", "tagging"}}}}, {kind: objectKind, required: []string{"type", "source"}, fixed: []fixedValues{{"type", []any{"SpecificResource"}}, {"purpose", []any{"assessing", "bookmarking", "classifying", "commenting", "describing", "editing", "highlighting", "identifying", "linking", "moderating", "questioning", "replying", "tagging"}}}}}},
	{"AnnotationBodiesList", readAs[AnnotationBodiesList], []signature{{kind: listKind}}},
}

// AnnotationBodiesList is a AnnotationBodies that is a list.
type AnnotationBodiesList []AnnotationBody

func (AnnotationBodiesList) memberOfAnnotationBodies() {}

// AnnotationBody An annotation's body: a TextualBody carries text the
// annotation states (entity tags, descriptions, comments), a SpecificResource
// points at what it links to. Tell them apart by `type`, which is required on
// both and single-valued — a consumer never has to probe for which fields
// happen to be present.
type AnnotationBody struct {
	union[AnnotationBodyMember]
}

// AnnotationBodyMember is a member of AnnotationBody: TextualBody,
// SpecificResource.
type AnnotationBodyMember interface {
	memberOfAnnotationBody()
}

// Discriminator is the `type` this value states.
func (u AnnotationBody) Discriminator() (string, error) { return u.stated("type") }

// Member is the member this value is: the one whose schema admits it.
func (u AnnotationBody) Member() (any, error) {
	return u.member("AnnotationBody", annotationBodyMembers)
}

// annotationBodyMembers is what each member of AnnotationBody admits, and how
// a value of it is read.
var annotationBodyMembers = []unionMember{
	{"TextualBody", readAs[TextualBody], []signature{{kind: objectKind, required: []string{"type", "value"}, fixed: []fixedValues{{"type", []any{"TextualBody"}}, {"purpose", []any{"assessing", "bookmarking", "classifying", "commenting", "describing", "editing", "highlighting", "identifying", "linking", "moderating", "questioning", "replying", "tagging"}}}}}},
	{"SpecificResource", readAs[SpecificResource], []signature{{kind: objectKind, required: []string{"type", "source"}, fixed: []fixedValues{{"type", []any{"SpecificResource"}}, {"purpose", []any{"assessing", "bookmarking", "classifying", "commenting", "describing", "editing", "highlighting", "identifying", "linking", "moderating", "questioning", "replying", "tagging"}}}}}},
}

func (AnnotationBody) memberOfAnnotationBodies() {}

// AnnotationBodyUpdatedPayload Payload for mark:body-updated domain event
type AnnotationBodyUpdatedPayload struct {
	AnnotationId AnnotationId    `json:"annotationId"`
	Operations   []BodyOperation `json:"operations"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v AnnotationBodyUpdatedPayload) MarshalJSON() ([]byte, error) {
	type written AnnotationBodyUpdatedPayload
	v.Operations = listOf(v.Operations)
	return json.Marshal(written(v))
}

// AnnotationContext W3C Web Annotation JSON-LD context
type AnnotationContext string

// The values of AnnotationContext.
const (
	AnnotationContextHttpWwwW3OrgNsAnnoJsonld AnnotationContext = "http://www.w3.org/ns/anno.jsonld"
)

// Valid is whether e is one of AnnotationContext's values.
func (e AnnotationContext) Valid() bool {
	switch e {
	case AnnotationContextHttpWwwW3OrgNsAnnoJsonld:
		return true
	}
	return false
}

// AnnotationRemovedPayload Payload for mark:removed domain event
type AnnotationRemovedPayload struct {
	AnnotationId AnnotationId `json:"annotationId"`
}

// AnnotationSelector What a target's `selector` holds: one W3C selector, or
// several of the same segment.
type AnnotationSelector struct {
	union[AnnotationSelectorMember]
}

// AnnotationSelectorMember is a member of AnnotationSelector: Selector,
// AnnotationSelectorList.
type AnnotationSelectorMember interface {
	memberOfAnnotationSelector()
}

// Member is the member this value is: the one whose schema admits it.
func (u AnnotationSelector) Member() (any, error) {
	return u.member("AnnotationSelector", annotationSelectorMembers)
}

// annotationSelectorMembers is what each member of AnnotationSelector admits,
// and how a value of it is read.
var annotationSelectorMembers = []unionMember{
	{"Selector", readAs[Selector], []signature{{kind: objectKind, required: []string{"type", "start", "end"}, fixed: []fixedValues{{"type", []any{"TextPositionSelector"}}}}, {kind: objectKind, required: []string{"type", "exact"}, fixed: []fixedValues{{"type", []any{"TextQuoteSelector"}}}}, {kind: objectKind, required: []string{"type", "value"}, fixed: []fixedValues{{"type", []any{"SvgSelector"}}}}, {kind: objectKind, required: []string{"type", "value"}, fixed: []fixedValues{{"type", []any{"FragmentSelector"}}}}}},
	{"AnnotationSelectorList", readAs[AnnotationSelectorList], []signature{{kind: listKind}}},
}

// AnnotationSelectorList is a AnnotationSelector that is a list.
type AnnotationSelectorList []Selector

func (AnnotationSelectorList) memberOfAnnotationSelector() {}

// AnnotationTarget W3C Web Annotation target object - source is required,
// selector is optional
type AnnotationTarget struct {
	// Type Stated by the annotation of a span: the target is a part of its
	// source, which the selector picks out. An annotation of a resource as a
	// whole states none.
	Type *AnnotationTargetType `json:"type,omitempty"`
	// Source The id of the resource being annotated
	Source ResourceId `json:"source"`
	// Selector Optional selector to identify a specific segment of the source
	// resource
	Selector *AnnotationSelector `json:"selector,omitempty"`
}

func (AnnotationTarget) memberOfAnnotationTargetValue() {}

// AnnotationTargetType Stated by the annotation of a span: the target is a
// part of its source, which the selector picks out. An annotation of a
// resource as a whole states none.
type AnnotationTargetType string

// The values of AnnotationTargetType.
const (
	AnnotationTargetTypeSpecificResource AnnotationTargetType = "SpecificResource"
)

// Valid is whether e is one of AnnotationTargetType's values.
func (e AnnotationTargetType) Valid() bool {
	switch e {
	case AnnotationTargetTypeSpecificResource:
		return true
	}
	return false
}

// AnnotationTargetValue W3C Web Annotation target: the id of the resource
// annotated, when the whole of it is, or an object with source and optional
// selector (fragment)
type AnnotationTargetValue struct {
	union[AnnotationTargetValueMember]
}

// AnnotationTargetValueMember is a member of AnnotationTargetValue:
// ResourceId, AnnotationTarget.
type AnnotationTargetValueMember interface {
	memberOfAnnotationTargetValue()
}

// Member is the member this value is: the one whose schema admits it.
func (u AnnotationTargetValue) Member() (any, error) {
	return u.member("AnnotationTargetValue", annotationTargetValueMembers)
}

// annotationTargetValueMembers is what each member of AnnotationTargetValue
// admits, and how a value of it is read.
var annotationTargetValueMembers = []unionMember{
	{"ResourceId", readAs[ResourceId], []signature{{kind: textKind}}},
	{"AnnotationTarget", readAs[AnnotationTarget], []signature{{kind: objectKind, required: []string{"source"}, fixed: []fixedValues{{"type", []any{"SpecificResource"}}}}}},
}

// AnnotationType W3C Annotation type
type AnnotationType string

// The values of AnnotationType.
const (
	AnnotationTypeAnnotation AnnotationType = "Annotation"
)

// Valid is whether e is one of AnnotationType's values.
func (e AnnotationType) Valid() bool {
	switch e {
	case AnnotationTypeAnnotation:
		return true
	}
	return false
}

// ApiVersion The group and version of the control API. Every request's params
// state it; a launcher refuses a version it does not speak with
// control.unsupported-api-version, and names the ones it does.
type ApiVersion string

// The values of ApiVersion.
const (
	ApiVersionControlXynologOrgV1alpha1 ApiVersion = "control.xynolog.org/v1alpha1"
)

// Valid is whether e is one of ApiVersion's values.
func (e ApiVersion) Valid() bool {
	switch e {
	case ApiVersionControlXynologOrgV1alpha1:
		return true
	}
	return false
}

// ArchivistConfig Everything the Archivist reads at boot: nothing in it is
// defaulted by the Archivist. The launcher writes it for the Archivist it
// starts, from the knowledge base's stack documents, and the Archivist reads
// it from the path its `--config` flag names (its image passes
// `/etc/xynolog/archivist.json`). Started without `--config`, or with a path
// that names no file, the Archivist refuses to start and says which. No
// secret is a value here. What the knowledge base says of itself is not here
// either: its name, its `site.domain` and its `git.sync` are read from the
// committed `.xynolog/config.yaml` of the tree at `root`. The Archivist's
// other inputs are the environment variables
// specs/src/service-environment/variables.json lists for it. A document that
// does not validate is refused at boot, naming each failing field.
type ArchivistConfig struct {
	// GatewayUrl The URL the Archivist reaches the gateway at: its only route to
	// the bus.
	GatewayUrl string `json:"gatewayUrl"`
	// Identity The issuer the Archivist's service account signs in at, and whose
	// tokens it admits callers of its HTTP surface by.
	Identity ServiceIdentity `json:"identity"`
	// Root The knowledge base's working tree: the directory holding `.xynolog/`.
	// The event log, the content and the committed config are under it.
	Root string `json:"root"`
	// StateHome The state volume, this knowledge base's alone: the Archivist
	// keeps the knowledge base's views and projections in it, at its top.
	StateHome string `json:"stateHome"`
	// AnchoredTextDir The anchored-text store, which only the Archivist mounts:
	// the Smelter stores each entry in it over HTTP, and the Archivist serves
	// it.
	AnchoredTextDir string           `json:"anchoredTextDir"`
	Engines         ArchivistEngines `json:"engines"`
	// Port The port the Archivist's HTTP surface answers on, `/health` included.
	Port int `json:"port"`
	// SkipRebuild Whether the Archivist serves the views it finds at boot
	// instead of rebuilding them from the event log first.
	SkipRebuild bool `json:"skipRebuild"`
	// Staging The bounds on how far the staging driver may run behind the
	// working tree, in milliseconds. A knowledge base that does not sync git
	// stages nothing, and reads neither.
	Staging   ArchivistConfigStaging `json:"staging"`
	LogLevel  LogLevel               `json:"logLevel"`
	LogFormat LogFormat              `json:"logFormat"`
}

// ArchivistConfigStaging The bounds on how far the staging driver may run
// behind the working tree, in milliseconds. A knowledge base that does not
// sync git stages nothing, and reads neither.
type ArchivistConfigStaging struct {
	// FlushMs The quiet period after the last change before pending changes are
	// staged.
	FlushMs int `json:"flushMs"`
	// MaxWaitMs The longest a change waits to be staged while others keep
	// arriving, measured from the oldest pending change.
	MaxWaitMs int `json:"maxWaitMs"`
}

// ArchivistDefaultEntityTypes archivist/default-entity-types.json: the entity
// types an Archivist seeds, in the order it seeds them.
type ArchivistDefaultEntityTypes struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// EntityTypes The default entity types, in seed order.
	EntityTypes []string `json:"entityTypes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ArchivistDefaultEntityTypes) MarshalJSON() ([]byte, error) {
	type written ArchivistDefaultEntityTypes
	v.EntityTypes = listOf(v.EntityTypes)
	return json.Marshal(written(v))
}

// ArchivistEngines The engine for each job and each Librarian actor, behind
// `browse:engines`: a provider and a model, and no credential. It is the
// knowledge base's Inference document's `engines` as they stand, with no
// fallback, so a job or an actor absent here has no engine.
type ArchivistEngines struct {
	// Jobs The engine each job is done with when software does it, keyed as a
	// job description is: by `jobType`, and for `mark` by motivation.
	Jobs ArchivistEnginesJobs `json:"jobs"`
	// Actors The engine each Librarian actor that calls a model asks.
	Actors ArchivistEnginesActors `json:"actors"`
}

// ArchivistEnginesActors The engine each Librarian actor that calls a model
// asks.
type ArchivistEnginesActors struct {
	Gatherer *Engine `json:"gatherer,omitempty"`
	Matcher  *Engine `json:"matcher,omitempty"`
}

// ArchivistEnginesJobs The engine each job is done with when software does
// it, keyed as a job description is: by `jobType`, and for `mark` by
// motivation.
type ArchivistEnginesJobs struct {
	// Mark The engine for `mark` jobs of each motivation.
	Mark  *ArchivistEnginesJobsMark `json:"mark,omitempty"`
	Yield *Engine                   `json:"yield,omitempty"`
}

// ArchivistEnginesJobsMark The engine for `mark` jobs of each motivation.
type ArchivistEnginesJobsMark struct {
	Highlighting *Engine `json:"highlighting,omitempty"`
	Commenting   *Engine `json:"commenting,omitempty"`
	Assessing    *Engine `json:"assessing,omitempty"`
	Linking      *Engine `json:"linking,omitempty"`
	Tagging      *Engine `json:"tagging,omitempty"`
}

// ArchivistEventsResponse A page of one stream's events from one sequence
// number, inclusive, in log order, and the sequence number of the stream's
// last event: the Archivist's answer to `GET /events/{resourceId}`.
type ArchivistEventsResponse struct {
	Events []StoredEventResponse `json:"events"`
	// LastSequence The sequence number of the stream's last event when it was
	// read: 0 for a stream with none. More events follow the page while its last
	// event's number is below it.
	LastSequence int `json:"lastSequence"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ArchivistEventsResponse) MarshalJSON() ([]byte, error) {
	type written ArchivistEventsResponse
	v.Events = listOf(v.Events)
	return json.Marshal(written(v))
}

// ArchivistHealth The Archivist's liveness answer: it serves, and the actors
// it hosts.
type ArchivistHealth struct {
	Status ArchivistHealthStatus `json:"status"`
	// Actors The record actors this process hosts: each of the enum's, once, in
	// the order the enum lists them.
	Actors []ArchivistHealthActorsItem `json:"actors"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ArchivistHealth) MarshalJSON() ([]byte, error) {
	type written ArchivistHealth
	v.Actors = listOf(v.Actors)
	return json.Marshal(written(v))
}

type ArchivistHealthActorsItem string

// The values of ArchivistHealthActorsItem.
const (
	ArchivistHealthActorsItemStower            ArchivistHealthActorsItem = "stower"
	ArchivistHealthActorsItemBrowser           ArchivistHealthActorsItem = "browser"
	ArchivistHealthActorsItemCloneTokenManager ArchivistHealthActorsItem = "cloneTokenManager"
)

// Valid is whether e is one of ArchivistHealthActorsItem's values.
func (e ArchivistHealthActorsItem) Valid() bool {
	switch e {
	case ArchivistHealthActorsItemStower, ArchivistHealthActorsItemBrowser, ArchivistHealthActorsItemCloneTokenManager:
		return true
	}
	return false
}

type ArchivistHealthStatus string

// The values of ArchivistHealthStatus.
const (
	ArchivistHealthStatusOk ArchivistHealthStatus = "ok"
)

// Valid is whether e is one of ArchivistHealthStatus's values.
func (e ArchivistHealthStatus) Valid() bool {
	switch e {
	case ArchivistHealthStatusOk:
		return true
	}
	return false
}

// ArchivistLayout archivist/layout.json: where the Archivist keeps the record
// on disk.
type ArchivistLayout struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// EventStream A resource's event stream: a directory of event files.
	EventStream ArchivistLayoutEventStream `json:"eventStream"`
	// SystemStream The knowledge base's own stream, of the events that name no
	// resource. It is not sharded.
	SystemStream ArchivistLayoutSystemStream `json:"systemStream"`
	// EventFile The files of a stream.
	EventFile ArchivistLayoutEventFile `json:"eventFile"`
	// StoredEvent The schema a stored event, one line of an event file, is.
	StoredEvent any `json:"storedEvent"`
	// View A resource's view, in the state directory.
	View ArchivistLayoutView `json:"view"`
	// SystemProjections The projections of what the `__system__` stream adds up
	// to, in the state directory.
	SystemProjections ArchivistLayoutSystemProjections `json:"systemProjections"`
	// StorageUriIndex An entry of the storage-uri index, which names the
	// resource whose content is at a storage URI.
	StorageUriIndex ArchivistLayoutStorageUriIndex `json:"storageUriIndex"`
	// AnchoredTextEntry An entry of the anchored-text store, keyed by the
	// checksum of the content it was extracted from.
	AnchoredTextEntry ArchivistLayoutAnchoredTextEntry `json:"anchoredTextEntry"`
	// AnchoredTextStamp The file holding the stamp the anchored-text store's
	// entries are taken under: the stamp, followed by a newline.
	AnchoredTextStamp ArchivistLayoutAnchoredTextStamp `json:"anchoredTextStamp"`
}

// ArchivistLayoutAnchoredTextEntry An entry of the anchored-text store, keyed
// by the checksum of the content it was extracted from.
type ArchivistLayoutAnchoredTextEntry struct {
	// Tree The tree the file is in: `root`, the working tree, `stateHome`, the
	// state directory, or `anchoredTextDir`, the anchored-text store.
	Tree ArchivistLayoutAnchoredTextEntryTree `json:"tree"`
	// Path Its path in its tree, `/`-separated.
	Path string `json:"path"`
	// Schema The schema an entry is.
	Schema any `json:"schema"`
}

// ArchivistLayoutAnchoredTextEntryTree The tree the file is in: `root`, the
// working tree, `stateHome`, the state directory, or `anchoredTextDir`, the
// anchored-text store.
type ArchivistLayoutAnchoredTextEntryTree string

// The values of ArchivistLayoutAnchoredTextEntryTree.
const (
	ArchivistLayoutAnchoredTextEntryTreeRoot            ArchivistLayoutAnchoredTextEntryTree = "root"
	ArchivistLayoutAnchoredTextEntryTreeStateHome       ArchivistLayoutAnchoredTextEntryTree = "stateHome"
	ArchivistLayoutAnchoredTextEntryTreeAnchoredTextDir ArchivistLayoutAnchoredTextEntryTree = "anchoredTextDir"
)

// Valid is whether e is one of ArchivistLayoutAnchoredTextEntryTree's values.
func (e ArchivistLayoutAnchoredTextEntryTree) Valid() bool {
	switch e {
	case ArchivistLayoutAnchoredTextEntryTreeRoot, ArchivistLayoutAnchoredTextEntryTreeStateHome, ArchivistLayoutAnchoredTextEntryTreeAnchoredTextDir:
		return true
	}
	return false
}

// ArchivistLayoutAnchoredTextStamp The file holding the stamp the
// anchored-text store's entries are taken under: the stamp, followed by a
// newline.
type ArchivistLayoutAnchoredTextStamp struct {
	// Tree The tree the file is in: `root`, the working tree, `stateHome`, the
	// state directory, or `anchoredTextDir`, the anchored-text store.
	Tree ArchivistLayoutAnchoredTextStampTree `json:"tree"`
	// Path Its path in its tree, `/`-separated.
	Path string `json:"path"`
}

// ArchivistLayoutAnchoredTextStampTree The tree the file is in: `root`, the
// working tree, `stateHome`, the state directory, or `anchoredTextDir`, the
// anchored-text store.
type ArchivistLayoutAnchoredTextStampTree string

// The values of ArchivistLayoutAnchoredTextStampTree.
const (
	ArchivistLayoutAnchoredTextStampTreeRoot            ArchivistLayoutAnchoredTextStampTree = "root"
	ArchivistLayoutAnchoredTextStampTreeStateHome       ArchivistLayoutAnchoredTextStampTree = "stateHome"
	ArchivistLayoutAnchoredTextStampTreeAnchoredTextDir ArchivistLayoutAnchoredTextStampTree = "anchoredTextDir"
)

// Valid is whether e is one of ArchivistLayoutAnchoredTextStampTree's values.
func (e ArchivistLayoutAnchoredTextStampTree) Valid() bool {
	switch e {
	case ArchivistLayoutAnchoredTextStampTreeRoot, ArchivistLayoutAnchoredTextStampTreeStateHome, ArchivistLayoutAnchoredTextStampTreeAnchoredTextDir:
		return true
	}
	return false
}

// ArchivistLayoutEventFile The files of a stream.
type ArchivistLayoutEventFile struct {
	// Name A file's name, `{number}` its number in `digits` decimal digits.
	Name string `json:"name"`
	// Digits How many decimal digits a file's number is written in, with leading
	// zeros.
	Digits int `json:"digits"`
	// First The first file's number. It is created, empty, with the stream's
	// directory.
	First int `json:"first"`
	// MaxEvents The most events a file holds.
	MaxEvents int `json:"maxEvents"`
}

// ArchivistLayoutEventStream A resource's event stream: a directory of event
// files.
type ArchivistLayoutEventStream struct {
	// Tree The tree the file is in: `root`, the working tree, `stateHome`, the
	// state directory, or `anchoredTextDir`, the anchored-text store.
	Tree ArchivistLayoutEventStreamTree `json:"tree"`
	// Path Its path in its tree, `/`-separated.
	Path string `json:"path"`
}

// ArchivistLayoutEventStreamTree The tree the file is in: `root`, the working
// tree, `stateHome`, the state directory, or `anchoredTextDir`, the
// anchored-text store.
type ArchivistLayoutEventStreamTree string

// The values of ArchivistLayoutEventStreamTree.
const (
	ArchivistLayoutEventStreamTreeRoot            ArchivistLayoutEventStreamTree = "root"
	ArchivistLayoutEventStreamTreeStateHome       ArchivistLayoutEventStreamTree = "stateHome"
	ArchivistLayoutEventStreamTreeAnchoredTextDir ArchivistLayoutEventStreamTree = "anchoredTextDir"
)

// Valid is whether e is one of ArchivistLayoutEventStreamTree's values.
func (e ArchivistLayoutEventStreamTree) Valid() bool {
	switch e {
	case ArchivistLayoutEventStreamTreeRoot, ArchivistLayoutEventStreamTreeStateHome, ArchivistLayoutEventStreamTreeAnchoredTextDir:
		return true
	}
	return false
}

// ArchivistLayoutStorageUriIndex An entry of the storage-uri index, which
// names the resource whose content is at a storage URI.
type ArchivistLayoutStorageUriIndex struct {
	// Tree The tree the file is in: `root`, the working tree, `stateHome`, the
	// state directory, or `anchoredTextDir`, the anchored-text store.
	Tree ArchivistLayoutStorageUriIndexTree `json:"tree"`
	// Path Its path in its tree, `/`-separated.
	Path string `json:"path"`
	// Schema The schema an entry is.
	Schema any `json:"schema"`
}

// ArchivistLayoutStorageUriIndexTree The tree the file is in: `root`, the
// working tree, `stateHome`, the state directory, or `anchoredTextDir`, the
// anchored-text store.
type ArchivistLayoutStorageUriIndexTree string

// The values of ArchivistLayoutStorageUriIndexTree.
const (
	ArchivistLayoutStorageUriIndexTreeRoot            ArchivistLayoutStorageUriIndexTree = "root"
	ArchivistLayoutStorageUriIndexTreeStateHome       ArchivistLayoutStorageUriIndexTree = "stateHome"
	ArchivistLayoutStorageUriIndexTreeAnchoredTextDir ArchivistLayoutStorageUriIndexTree = "anchoredTextDir"
)

// Valid is whether e is one of ArchivistLayoutStorageUriIndexTree's values.
func (e ArchivistLayoutStorageUriIndexTree) Valid() bool {
	switch e {
	case ArchivistLayoutStorageUriIndexTreeRoot, ArchivistLayoutStorageUriIndexTreeStateHome, ArchivistLayoutStorageUriIndexTreeAnchoredTextDir:
		return true
	}
	return false
}

// ArchivistLayoutSystemProjections The projections of what the `__system__`
// stream adds up to, in the state directory.
type ArchivistLayoutSystemProjections struct {
	// Tree The tree the file is in: `root`, the working tree, `stateHome`, the
	// state directory, or `anchoredTextDir`, the anchored-text store.
	Tree ArchivistLayoutSystemProjectionsTree `json:"tree"`
	// Path The directory that holds them, in its tree, `/`-separated.
	Path string `json:"path"`
	// Files Each projection's file.
	Files []ArchivistLayoutSystemProjectionsFilesItem `json:"files"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ArchivistLayoutSystemProjections) MarshalJSON() ([]byte, error) {
	type written ArchivistLayoutSystemProjections
	v.Files = listOf(v.Files)
	return json.Marshal(written(v))
}

type ArchivistLayoutSystemProjectionsFilesItem struct {
	// Name The file's name.
	Name string `json:"name"`
	// Schema The schema the projection is.
	Schema any `json:"schema"`
}

// ArchivistLayoutSystemProjectionsTree The tree the file is in: `root`, the
// working tree, `stateHome`, the state directory, or `anchoredTextDir`, the
// anchored-text store.
type ArchivistLayoutSystemProjectionsTree string

// The values of ArchivistLayoutSystemProjectionsTree.
const (
	ArchivistLayoutSystemProjectionsTreeRoot            ArchivistLayoutSystemProjectionsTree = "root"
	ArchivistLayoutSystemProjectionsTreeStateHome       ArchivistLayoutSystemProjectionsTree = "stateHome"
	ArchivistLayoutSystemProjectionsTreeAnchoredTextDir ArchivistLayoutSystemProjectionsTree = "anchoredTextDir"
)

// Valid is whether e is one of ArchivistLayoutSystemProjectionsTree's values.
func (e ArchivistLayoutSystemProjectionsTree) Valid() bool {
	switch e {
	case ArchivistLayoutSystemProjectionsTreeRoot, ArchivistLayoutSystemProjectionsTreeStateHome, ArchivistLayoutSystemProjectionsTreeAnchoredTextDir:
		return true
	}
	return false
}

// ArchivistLayoutSystemStream The knowledge base's own stream, of the events
// that name no resource. It is not sharded.
type ArchivistLayoutSystemStream struct {
	// Tree The tree the file is in: `root`, the working tree, `stateHome`, the
	// state directory, or `anchoredTextDir`, the anchored-text store.
	Tree ArchivistLayoutSystemStreamTree `json:"tree"`
	// Path Its path in its tree, `/`-separated.
	Path string `json:"path"`
}

// ArchivistLayoutSystemStreamTree The tree the file is in: `root`, the
// working tree, `stateHome`, the state directory, or `anchoredTextDir`, the
// anchored-text store.
type ArchivistLayoutSystemStreamTree string

// The values of ArchivistLayoutSystemStreamTree.
const (
	ArchivistLayoutSystemStreamTreeRoot            ArchivistLayoutSystemStreamTree = "root"
	ArchivistLayoutSystemStreamTreeStateHome       ArchivistLayoutSystemStreamTree = "stateHome"
	ArchivistLayoutSystemStreamTreeAnchoredTextDir ArchivistLayoutSystemStreamTree = "anchoredTextDir"
)

// Valid is whether e is one of ArchivistLayoutSystemStreamTree's values.
func (e ArchivistLayoutSystemStreamTree) Valid() bool {
	switch e {
	case ArchivistLayoutSystemStreamTreeRoot, ArchivistLayoutSystemStreamTreeStateHome, ArchivistLayoutSystemStreamTreeAnchoredTextDir:
		return true
	}
	return false
}

// ArchivistLayoutView A resource's view, in the state directory.
type ArchivistLayoutView struct {
	// Tree The tree the file is in: `root`, the working tree, `stateHome`, the
	// state directory, or `anchoredTextDir`, the anchored-text store.
	Tree ArchivistLayoutViewTree `json:"tree"`
	// Path Its path in its tree, `/`-separated.
	Path string `json:"path"`
	// Schema The schema a view is.
	Schema any `json:"schema"`
}

// ArchivistLayoutViewTree The tree the file is in: `root`, the working tree,
// `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text
// store.
type ArchivistLayoutViewTree string

// The values of ArchivistLayoutViewTree.
const (
	ArchivistLayoutViewTreeRoot            ArchivistLayoutViewTree = "root"
	ArchivistLayoutViewTreeStateHome       ArchivistLayoutViewTree = "stateHome"
	ArchivistLayoutViewTreeAnchoredTextDir ArchivistLayoutViewTree = "anchoredTextDir"
)

// Valid is whether e is one of ArchivistLayoutViewTree's values.
func (e ArchivistLayoutViewTree) Valid() bool {
	switch e {
	case ArchivistLayoutViewTreeRoot, ArchivistLayoutViewTreeStateHome, ArchivistLayoutViewTreeAnchoredTextDir:
		return true
	}
	return false
}

// ArchivistMessages archivist/messages.json: the words of the Archivist's own
// refusals, and of the messages it logs that a reader relies on.
type ArchivistMessages struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Boot Each refusal to start of the Archivist's own, written in
	// service-environment/boot-refusals.json's `line`.
	Boot []ArchivistMessagesBootItem `json:"boot"`
	// Unsent The failure a reply that cannot be sent is answered with instead,
	// on the operation's failure channel.
	Unsent []ArchivistMessagesUnsentItem `json:"unsent"`
	// Refusals Each refusal of an operation, on the operation's failure channel.
	Refusals []ArchivistMessagesRefusalsItem `json:"refusals"`
	// Unauthorized The refusal of every route of the HTTP surface but `/health`:
	// a token that is missing, or not of the knowledge base's issuer and
	// audience, or without the service role.
	Unauthorized ArchivistMessagesUnauthorized `json:"unauthorized"`
	// Http Each other error a route of the HTTP surface answers with.
	Http []ArchivistMessagesHttpItem `json:"http"`
	// Logged Each message the Archivist logs that a reader of its output relies
	// on.
	Logged []ArchivistMessagesLoggedItem `json:"logged"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ArchivistMessages) MarshalJSON() ([]byte, error) {
	type written ArchivistMessages
	v.Boot = listOf(v.Boot)
	v.Unsent = listOf(v.Unsent)
	v.Refusals = listOf(v.Refusals)
	v.Http = listOf(v.Http)
	v.Logged = listOf(v.Logged)
	return json.Marshal(written(v))
}

type ArchivistMessagesBootItem struct {
	// Name The situation's name.
	Name string `json:"name"`
	// Situation When it is written, and what fills each `{name}` of its text.
	Situation string `json:"situation"`
	// Refusal The refusal, in place of the line's `{refusal}`. A `{name}` in it
	// is filled with what the row's `situation` names, and nothing else in it
	// varies.
	Refusal string `json:"refusal"`
}

type ArchivistMessagesHttpItem struct {
	// Name The situation's name.
	Name string `json:"name"`
	// Method The route's method.
	Method ArchivistMessagesHttpItemMethod `json:"method"`
	// Route The route, as the Archivist's API names its path.
	Route  string     `json:"route"`
	Status HttpStatus `json:"status"`
	// Code The body's `code`, where it carries one.
	Code *string `json:"code,omitempty"`
	// Situation When it is written, and what fills each `{name}` of its text.
	Situation string `json:"situation"`
	// Error The body's `error`. A `{name}` in it is filled with what the row's
	// `situation` names, and nothing else in it varies.
	Error string `json:"error"`
}

// ArchivistMessagesHttpItemMethod The route's method.
type ArchivistMessagesHttpItemMethod string

// The values of ArchivistMessagesHttpItemMethod.
const (
	ArchivistMessagesHttpItemMethodGET  ArchivistMessagesHttpItemMethod = "GET"
	ArchivistMessagesHttpItemMethodPUT  ArchivistMessagesHttpItemMethod = "PUT"
	ArchivistMessagesHttpItemMethodPOST ArchivistMessagesHttpItemMethod = "POST"
)

// Valid is whether e is one of ArchivistMessagesHttpItemMethod's values.
func (e ArchivistMessagesHttpItemMethod) Valid() bool {
	switch e {
	case ArchivistMessagesHttpItemMethodGET, ArchivistMessagesHttpItemMethodPUT, ArchivistMessagesHttpItemMethodPOST:
		return true
	}
	return false
}

type ArchivistMessagesLoggedItem struct {
	// Name The situation's name.
	Name  string   `json:"name"`
	Level LogLevel `json:"level"`
	// Situation When it is written, and what fills each `{name}` of its text.
	Situation string `json:"situation"`
	// Message The line's message, word for word.
	Message string `json:"message"`
	// Fields The fields the line is logged with whose form is stated, by name:
	// each a text whose `{name}` is filled as the row's `situation` says. The
	// line may carry others.
	Fields map[string]string `json:"fields"`
}

type ArchivistMessagesRefusalsItem struct {
	// Name The situation's name.
	Name string `json:"name"`
	// Operations The operations it refuses: requests of bus/registry.json's
	// operations that the Archivist answers. `{channel}` in the message is the
	// one refused.
	Operations []string `json:"operations"`
	// Code Machine-readable failure class, for consumers that must BRANCH on why
	// a command failed rather than log it. Optional and deliberately sparse:
	// absent means 'no class declared', and every existing failure stays that
	// way. An enum rather than a free string so the vocabulary has an owner — an
	// unconstrained code is a mirror with no gate, and adding one should be a
	// deliberate spec change. `message` remains the human-readable text and is
	// unaffected. Members: `peer-unavailable` — the channel this command was
	// sent on has no subscriber, i.e. the service that answers it has not
	// connected yet. Transient by nature (a peer still starting), which is what
	// distinguishes it from a refusal: retrying is the correct response.
	// `not-found` — the resource this command addressed does not exist in this
	// knowledge base. A verdict, not a symptom: it is emitted only where the
	// answer comes from the event store, which is the system of record, and
	// never from a projection that may merely be lagging. Deterministic, so
	// unlike `peer-unavailable` retrying is pointless — and consumers may act
	// destructively on it (the SDK deletes a restored tab). Absence is not
	// denial: a future 'exists, but not for you' must travel as its own code,
	// never as this one. `unauthorized` — that code: the caller is authenticated
	// but not permitted to do what it asked. A verdict about the CALLER, not the
	// resource, so retrying under the same credential cannot succeed and a
	// consumer must never spin on it; emitted by `job:claim` for a caller whose
	// token carries no worker role. `none-pending` — a declined claim, not an
	// error: the queue holds no pending job of the requested types. Nothing went
	// wrong; the one code a consumer PARKS on, meaning 'nothing to do until a
	// wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying
	// neither is unclassified — a malformed record or a missing injection — and
	// a consumer treats it as 'log it, assume nothing'.
	Code *ArchivistMessagesRefusalsItemCode `json:"code,omitempty"`
	// Situation When it is written, and what fills each `{name}` of its text.
	Situation string `json:"situation"`
	// Message The failure's `message`. A `{name}` in it is filled with what the
	// row's `situation` names, and nothing else in it varies.
	Message string `json:"message"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ArchivistMessagesRefusalsItem) MarshalJSON() ([]byte, error) {
	type written ArchivistMessagesRefusalsItem
	v.Operations = listOf(v.Operations)
	return json.Marshal(written(v))
}

// ArchivistMessagesRefusalsItemCode Machine-readable failure class, for
// consumers that must BRANCH on why a command failed rather than log it.
// Optional and deliberately sparse: absent means 'no class declared', and
// every existing failure stays that way. An enum rather than a free string so
// the vocabulary has an owner — an unconstrained code is a mirror with no
// gate, and adding one should be a deliberate spec change. `message` remains
// the human-readable text and is unaffected. Members: `peer-unavailable` —
// the channel this command was sent on has no subscriber, i.e. the service
// that answers it has not connected yet. Transient by nature (a peer still
// starting), which is what distinguishes it from a refusal: retrying is the
// correct response. `not-found` — the resource this command addressed does
// not exist in this knowledge base. A verdict, not a symptom: it is emitted
// only where the answer comes from the event store, which is the system of
// record, and never from a projection that may merely be lagging.
// Deterministic, so unlike `peer-unavailable` retrying is pointless — and
// consumers may act destructively on it (the SDK deletes a restored tab).
// Absence is not denial: a future 'exists, but not for you' must travel as
// its own code, never as this one. `unauthorized` — that code: the caller is
// authenticated but not permitted to do what it asked. A verdict about the
// CALLER, not the resource, so retrying under the same credential cannot
// succeed and a consumer must never spin on it; emitted by `job:claim` for a
// caller whose token carries no worker role. `none-pending` — a declined
// claim, not an error: the queue holds no pending job of the requested types.
// Nothing went wrong; the one code a consumer PARKS on, meaning 'nothing to
// do until a wake-up'. Emitted by `job:claim` only. A `job:claim` refusal
// carrying neither is unclassified — a malformed record or a missing
// injection — and a consumer treats it as 'log it, assume nothing'.
type ArchivistMessagesRefusalsItemCode string

// The values of ArchivistMessagesRefusalsItemCode.
const (
	ArchivistMessagesRefusalsItemCodePeerUnavailable ArchivistMessagesRefusalsItemCode = "peer-unavailable"
	ArchivistMessagesRefusalsItemCodeNotFound        ArchivistMessagesRefusalsItemCode = "not-found"
	ArchivistMessagesRefusalsItemCodeUnauthorized    ArchivistMessagesRefusalsItemCode = "unauthorized"
	ArchivistMessagesRefusalsItemCodeNonePending     ArchivistMessagesRefusalsItemCode = "none-pending"
)

// Valid is whether e is one of ArchivistMessagesRefusalsItemCode's values.
func (e ArchivistMessagesRefusalsItemCode) Valid() bool {
	switch e {
	case ArchivistMessagesRefusalsItemCodePeerUnavailable, ArchivistMessagesRefusalsItemCodeNotFound, ArchivistMessagesRefusalsItemCodeUnauthorized, ArchivistMessagesRefusalsItemCodeNonePending:
		return true
	}
	return false
}

// ArchivistMessagesUnauthorized The refusal of every route of the HTTP
// surface but `/health`: a token that is missing, or not of the knowledge
// base's issuer and audience, or without the service role.
type ArchivistMessagesUnauthorized struct {
	Status HttpStatus `json:"status"`
	// Error The body's `error`.
	Error string `json:"error"`
	// Presented The `WWW-Authenticate` header when a token was presented.
	Presented string `json:"presented"`
	// Absent The `WWW-Authenticate` header when none was.
	Absent string `json:"absent"`
}

type ArchivistMessagesUnsentItem struct {
	// Name The situation's name.
	Name string `json:"name"`
	// Situation When it is written, and what fills each `{name}` of its text.
	Situation string `json:"situation"`
	// Message The failure's `message`. A `{name}` in it is filled with what the
	// row's `situation` names, and nothing else in it varies.
	Message string `json:"message"`
}

// ArchivistStream One stream of the event log, and where it stands: the
// resource it is of, or `__system__` for the knowledge base's own, and the
// sequence number of its last event.
type ArchivistStream struct {
	ResourceId ResourceId `json:"resourceId"`
	// LastSequence The sequence number of the stream's last event when it was
	// read: 0 for a stream with none.
	LastSequence int `json:"lastSequence"`
}

// ArchivistStreamsResponse Every stream of the event log, `__system__` among
// them, each with the sequence number of its last event, in no order: the
// Archivist's answer to `GET /events`.
type ArchivistStreamsResponse struct {
	Streams []ArchivistStream `json:"streams"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ArchivistStreamsResponse) MarshalJSON() ([]byte, error) {
	type written ArchivistStreamsResponse
	v.Streams = listOf(v.Streams)
	return json.Marshal(written(v))
}

// AssessingJobParams What an assessing job takes: passages of the resource
// are marked, each with an assessment the model writes.
type AssessingJobParams struct {
	Motivation AssessingJobParamsMotivation `json:"motivation"`
	// Instructions What to look for, in the caller's words. Added to the prompt.
	Instructions *string `json:"instructions,omitempty"`
	// Tone The stance the assessments are written from.
	Tone *AssessingJobParamsTone `json:"tone,omitempty"`
	// Density How many annotations to aim for per 2000 words of the resource.
	Density *float64 `json:"density,omitempty"`
	// Language The language the annotations' own text is written in. BCP 47.
	Language *string `json:"language,omitempty"`
	// SourceLanguage The language of the resource being read. BCP 47.
	SourceLanguage *string `json:"sourceLanguage,omitempty"`
}

func (AssessingJobParams) memberOfMarkJobParams() {}
func (AssessingJobParams) told() (string, string) { return "motivation", "assessing" }

type AssessingJobParamsMotivation string

// The values of AssessingJobParamsMotivation.
const (
	AssessingJobParamsMotivationAssessing AssessingJobParamsMotivation = "assessing"
)

// Valid is whether e is one of AssessingJobParamsMotivation's values.
func (e AssessingJobParamsMotivation) Valid() bool {
	switch e {
	case AssessingJobParamsMotivationAssessing:
		return true
	}
	return false
}

// AssessingJobParamsTone The stance the assessments are written from.
type AssessingJobParamsTone string

// The values of AssessingJobParamsTone.
const (
	AssessingJobParamsToneAnalytical   AssessingJobParamsTone = "analytical"
	AssessingJobParamsToneCritical     AssessingJobParamsTone = "critical"
	AssessingJobParamsToneBalanced     AssessingJobParamsTone = "balanced"
	AssessingJobParamsToneConstructive AssessingJobParamsTone = "constructive"
)

// Valid is whether e is one of AssessingJobParamsTone's values.
func (e AssessingJobParamsTone) Valid() bool {
	switch e {
	case AssessingJobParamsToneAnalytical, AssessingJobParamsToneCritical, AssessingJobParamsToneBalanced, AssessingJobParamsToneConstructive:
		return true
	}
	return false
}

// AttributedEvent A persisted event as a history reply carries it: the stored
// event, and the agent its `userId` identifies. The agent is derived when the
// reply is made — the DID read into a Person or a Software agent, and a
// Person's name filled in from the knowledge base's profiles — and is stored
// nowhere. A Person the record does not name carries no `name`.
type AttributedEvent struct {
	// Id Unique event ID (UUID)
	Id string `json:"id"`
	// Type Event type (flow verb name, e.g. mark:added)
	Type string `json:"type"`
	// Timestamp When the event occurred
	Timestamp string `json:"timestamp"`
	// UserId DID of the user who triggered the event
	UserId UserId `json:"userId"`
	// ResourceId Resource this event affects (absent for system events)
	ResourceId *ResourceId `json:"resourceId,omitempty"`
	// Version Event schema version
	Version int `json:"version"`
	// Payload Event-type-specific payload
	Payload  map[string]any `json:"payload"`
	Metadata EventMetadata  `json:"metadata"`
	// Agent Who `userId` is.
	Agent Agent `json:"agent"`
}

// AuthLoginParams auth.login's params.
type AuthLoginParams struct {
	// ApiVersion The version of the control API the request is written to.
	ApiVersion ApiVersion `json:"apiVersion"`
	// Target Which knowledge base's stack. Absent: the one the command line
	// chooses, standing where the control server was started.
	Target *Target `json:"target,omitempty"`
	// Runtime Keep to the local stacks, as --runtime does.
	Runtime *Runtime `json:"runtime,omitempty"`
}

// AuthLoginResult A completed sign-in, kept in the launcher's sign-in store.
// No token is in it.
type AuthLoginResult struct {
	// Key The stack's key in the sign-in store.
	Key string `json:"key"`
	// Who Who the gateway says is signed in: their email, else their DID.
	Who string `json:"who"`
	// Issuer The issuer the knowledge base named, where the person signed in.
	Issuer string `json:"issuer"`
}

// AuthLogoutParams auth.logout's params.
type AuthLogoutParams struct {
	// ApiVersion The version of the control API the request is written to.
	ApiVersion ApiVersion `json:"apiVersion"`
	// Target Which knowledge base's stack. Absent: the one the command line
	// chooses, standing where the control server was started.
	Target *Target `json:"target,omitempty"`
	// Runtime Keep to the local stacks, as --runtime does.
	Runtime *Runtime `json:"runtime,omitempty"`
}

// AuthLogoutResult The launcher's session for a stack, ended. Desktop's own
// session is not touched.
type AuthLogoutResult struct {
	// Key The stack's key in the sign-in store. Absent when no stack is
	// recorded.
	Key *string `json:"key,omitempty"`
	// WasSignedIn Whether a session was stored. false: nothing was done.
	WasSignedIn bool `json:"wasSignedIn"`
	// Revoked Whether the issuer revoked the session's refresh token. false with
	// wasSignedIn: the local token is forgotten, and the refresh token stays
	// valid at the issuer until it expires.
	Revoked bool `json:"revoked"`
}

// BeckonFocusEvent Emitted to draw attention to a resource: to one of its
// annotations, or, with no annotation, to the resource as a whole. The
// resource is always named. A focus on an annotation scrolls a viewer showing
// that resource to it, and a viewer showing a different resource ignores it —
// a deliberate ignore rather than a silent no-op. A focus on the resource as
// a whole brings that resource forward, opened if it is not open, at its top.
type BeckonFocusEvent struct {
	AnnotationId *AnnotationId `json:"annotationId,omitempty"`
	// ResourceId The resource this focus applies to, always named. With an
	// annotation it is a guard: a viewer showing a different resource ignores
	// the event. With none it is the resource the focus brings forward.
	ResourceId ResourceId `json:"resourceId"`
}

// BeckonHoverEvent Emitted when an annotation is hovered over for beckoning
type BeckonHoverEvent struct {
	AnnotationId *AnnotationId `json:"annotationId"`
}

// BeckonSparkleEvent Emitted when a sparkle effect is triggered on an
// annotation
type BeckonSparkleEvent struct {
	AnnotationId AnnotationId `json:"annotationId"`
}

// BeginAuthorizationOptions What starting an authorization-code grant is
// told: the knowledge base to sign in to, where the issuer sends the person
// back, and, re-authenticating, which registered knowledge base it is and
// what the person believed they chose.
type BeginAuthorizationOptions struct {
	Target HttpEndpoint `json:"target"`
	// RedirectUri Where the issuer sends the person back to.
	RedirectUri string `json:"redirectUri"`
	// KbId The registered knowledge base being re-authenticated, rather than a
	// new address connected to.
	KbId *string `json:"kbId,omitempty"`
	// ExpectedDid The knowledge base's DID the person believed they chose:
	// verified after, never assumed.
	ExpectedDid *string `json:"expectedDid,omitempty"`
	// ExpectedName The knowledge base's name the person believed they chose:
	// verified after, never assumed.
	ExpectedName *string `json:"expectedName,omitempty"`
}

// Binary Bytes held whole. They can be read more than once, and sent again
// when an upload is retried.
type (
	Binary = []byte
)

// BindBodyOperation One edit to a linking annotation's body list: add or
// remove a body item, or replace an existing one.
type BindBodyOperation struct {
	// Op The type of body operation
	Op BindBodyOperationOp `json:"op"`
	// Item Body item for add operations
	Item *AnnotationBody `json:"item,omitempty"`
	// OldItem Previous body item for replace operations
	OldItem *AnnotationBody `json:"oldItem,omitempty"`
	// NewItem Replacement body item for replace operations
	NewItem *AnnotationBody `json:"newItem,omitempty"`
}

// BindBodyOperationOp The type of body operation
type BindBodyOperationOp string

// The values of BindBodyOperationOp.
const (
	BindBodyOperationOpAdd     BindBodyOperationOp = "add"
	BindBodyOperationOpRemove  BindBodyOperationOp = "remove"
	BindBodyOperationOpReplace BindBodyOperationOp = "replace"
)

// Valid is whether e is one of BindBodyOperationOp's values.
func (e BindBodyOperationOp) Valid() bool {
	switch e {
	case BindBodyOperationOpAdd, BindBodyOperationOpRemove, BindBodyOperationOpReplace:
		return true
	}
	return false
}

// BindBodyUpdated Void success reply emitted on the bind:body-updated channel
// after bind:update-body has been applied, matched to the originating command
// by correlationId.
type BindBodyUpdated struct{}

// BindInitiateCommand Command payload sent on the bind:initiate bus channel
// to start a bind flow.
type BindInitiateCommand struct {
	// AnnotationId Branded AnnotationId of the annotation being bound
	AnnotationId AnnotationId `json:"annotationId"`
	// ResourceId Branded ResourceId of the resource being bound to
	ResourceId ResourceId `json:"resourceId"`
	// DefaultTitle Default title for the bound annotation
	DefaultTitle string `json:"defaultTitle"`
	// EntityTypes Entity types to associate with the annotation
	EntityTypes []string `json:"entityTypes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v BindInitiateCommand) MarshalJSON() ([]byte, error) {
	type written BindInitiateCommand
	v.EntityTypes = listOf(v.EntityTypes)
	return json.Marshal(written(v))
}

// BindUpdateBodyCommand Command payload sent on the bind:update-body bus
// channel to modify annotation bodies.
type BindUpdateBodyCommand struct {
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId *UserId `json:"_userId,omitempty"`
	// AnnotationId Branded AnnotationId of the annotation whose body is being
	// updated
	AnnotationId AnnotationId `json:"annotationId"`
	// ResourceId Branded ResourceId of the resource the annotation belongs to
	ResourceId ResourceId `json:"resourceId"`
	// Operations Ordered body-list edits to apply.
	Operations []BindBodyOperation `json:"operations"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v BindUpdateBodyCommand) MarshalJSON() ([]byte, error) {
	type written BindUpdateBodyCommand
	v.Operations = listOf(v.Operations)
	return json.Marshal(written(v))
}

// BodyOperation One change to an annotation's bodies: a body added, a body
// removed, or one body replaced by another.
type BodyOperation struct {
	union[BodyOperationMember]
}

// BodyOperationMember is a member of BodyOperation: BodyOperationAdd,
// BodyOperationRemove, BodyOperationReplace.
type BodyOperationMember interface {
	memberOfBodyOperation()
}

// Member is the member this value is: the one whose schema admits it.
func (u BodyOperation) Member() (any, error) { return u.member("BodyOperation", bodyOperationMembers) }

// bodyOperationMembers is what each member of BodyOperation admits, and how a
// value of it is read.
var bodyOperationMembers = []unionMember{
	{"BodyOperationAdd", readAs[BodyOperationAdd], []signature{{kind: objectKind, required: []string{"op", "item"}, fixed: []fixedValues{{"op", []any{"add"}}}}}},
	{"BodyOperationRemove", readAs[BodyOperationRemove], []signature{{kind: objectKind, required: []string{"op", "item"}, fixed: []fixedValues{{"op", []any{"remove"}}}}}},
	{"BodyOperationReplace", readAs[BodyOperationReplace], []signature{{kind: objectKind, required: []string{"op", "oldItem", "newItem"}, fixed: []fixedValues{{"op", []any{"replace"}}}}}},
}

type BodyOperationAdd struct {
	Op   BodyOperationAddOp `json:"op"`
	Item AnnotationBody     `json:"item"`
}

func (BodyOperationAdd) memberOfBodyOperation() {}

type BodyOperationAddOp string

// The values of BodyOperationAddOp.
const (
	BodyOperationAddOpAdd BodyOperationAddOp = "add"
)

// Valid is whether e is one of BodyOperationAddOp's values.
func (e BodyOperationAddOp) Valid() bool {
	switch e {
	case BodyOperationAddOpAdd:
		return true
	}
	return false
}

type BodyOperationRemove struct {
	Op   BodyOperationRemoveOp `json:"op"`
	Item AnnotationBody        `json:"item"`
}

func (BodyOperationRemove) memberOfBodyOperation() {}

type BodyOperationRemoveOp string

// The values of BodyOperationRemoveOp.
const (
	BodyOperationRemoveOpRemove BodyOperationRemoveOp = "remove"
)

// Valid is whether e is one of BodyOperationRemoveOp's values.
func (e BodyOperationRemoveOp) Valid() bool {
	switch e {
	case BodyOperationRemoveOpRemove:
		return true
	}
	return false
}

type BodyOperationReplace struct {
	Op      BodyOperationReplaceOp `json:"op"`
	OldItem AnnotationBody         `json:"oldItem"`
	NewItem AnnotationBody         `json:"newItem"`
}

func (BodyOperationReplace) memberOfBodyOperation() {}

type BodyOperationReplaceOp string

// The values of BodyOperationReplaceOp.
const (
	BodyOperationReplaceOpReplace BodyOperationReplaceOp = "replace"
)

// Valid is whether e is one of BodyOperationReplaceOp's values.
func (e BodyOperationReplaceOp) Valid() bool {
	switch e {
	case BodyOperationReplaceOpReplace:
		return true
	}
	return false
}

// BodyPurpose W3C Web Annotation body purpose vocabulary -
// https://www.w3.org/TR/annotation-vocab/#motivation
type BodyPurpose string

// The values of BodyPurpose.
const (
	BodyPurposeAssessing    BodyPurpose = "assessing"
	BodyPurposeBookmarking  BodyPurpose = "bookmarking"
	BodyPurposeClassifying  BodyPurpose = "classifying"
	BodyPurposeCommenting   BodyPurpose = "commenting"
	BodyPurposeDescribing   BodyPurpose = "describing"
	BodyPurposeEditing      BodyPurpose = "editing"
	BodyPurposeHighlighting BodyPurpose = "highlighting"
	BodyPurposeIdentifying  BodyPurpose = "identifying"
	BodyPurposeLinking      BodyPurpose = "linking"
	BodyPurposeModerating   BodyPurpose = "moderating"
	BodyPurposeQuestioning  BodyPurpose = "questioning"
	BodyPurposeReplying     BodyPurpose = "replying"
	BodyPurposeTagging      BodyPurpose = "tagging"
)

// Valid is whether e is one of BodyPurpose's values.
func (e BodyPurpose) Valid() bool {
	switch e {
	case BodyPurposeAssessing, BodyPurposeBookmarking, BodyPurposeClassifying, BodyPurposeCommenting, BodyPurposeDescribing, BodyPurposeEditing, BodyPurposeHighlighting, BodyPurposeIdentifying, BodyPurposeLinking, BodyPurposeModerating, BodyPurposeQuestioning, BodyPurposeReplying, BodyPurposeTagging:
		return true
	}
	return false
}

// BrowseAnnotationHistoryRequest Request to browse the history of an
// annotation
type BrowseAnnotationHistoryRequest struct {
	ResourceId   ResourceId   `json:"resourceId"`
	AnnotationId AnnotationId `json:"annotationId"`
}

// BrowseAnnotationHistoryResult Result of browsing annotation history
type BrowseAnnotationHistoryResult struct {
	Response GetAnnotationHistoryResponse `json:"response"`
}

// BrowseAnnotationRequest Request to browse a single annotation
type BrowseAnnotationRequest struct {
	ResourceId   ResourceId   `json:"resourceId"`
	AnnotationId AnnotationId `json:"annotationId"`
}

// BrowseAnnotationResult Result of browsing a single annotation
type BrowseAnnotationResult struct {
	Response GetAnnotationResponse `json:"response"`
}

// BrowseClickEvent An annotation was clicked — open it: the viewer selects
// its entry in the annotations panel and relays a focus signal to scroll to
// it. The annotation id is the whole address; it identifies exactly one
// annotation on exactly one resource, so no resource field is carried and
// none is needed to scope the event. Motivation is NOT on the wire either:
// the viewer derives it from the annotation the id names, so the wire states
// the fact once. A viewer that has not loaded that annotation finds nothing
// and does nothing. Emitted locally by every clickable annotation surface,
// and over the wire by a driver opening an annotation on another
// participant's screen.
type BrowseClickEvent struct {
	AnnotationId AnnotationId `json:"annotationId"`
	AnchorRect   *AnchorRect  `json:"anchorRect,omitempty"`
}

// BrowseDirectoryFailed The payload of `browse:directory-failed`: a
// CommandError that names the directory that could not be read.
type BrowseDirectoryFailed struct {
	// Code Machine-readable failure class, for consumers that must BRANCH on why
	// a command failed rather than log it. Optional and deliberately sparse:
	// absent means 'no class declared', and every existing failure stays that
	// way. An enum rather than a free string so the vocabulary has an owner — an
	// unconstrained code is a mirror with no gate, and adding one should be a
	// deliberate spec change. `message` remains the human-readable text and is
	// unaffected. Members: `peer-unavailable` — the channel this command was
	// sent on has no subscriber, i.e. the service that answers it has not
	// connected yet. Transient by nature (a peer still starting), which is what
	// distinguishes it from a refusal: retrying is the correct response.
	// `not-found` — the resource this command addressed does not exist in this
	// knowledge base. A verdict, not a symptom: it is emitted only where the
	// answer comes from the event store, which is the system of record, and
	// never from a projection that may merely be lagging. Deterministic, so
	// unlike `peer-unavailable` retrying is pointless — and consumers may act
	// destructively on it (the SDK deletes a restored tab). Absence is not
	// denial: a future 'exists, but not for you' must travel as its own code,
	// never as this one. `unauthorized` — that code: the caller is authenticated
	// but not permitted to do what it asked. A verdict about the CALLER, not the
	// resource, so retrying under the same credential cannot succeed and a
	// consumer must never spin on it; emitted by `job:claim` for a caller whose
	// token carries no worker role. `none-pending` — a declined claim, not an
	// error: the queue holds no pending job of the requested types. Nothing went
	// wrong; the one code a consumer PARKS on, meaning 'nothing to do until a
	// wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying
	// neither is unclassified — a malformed record or a missing injection — and
	// a consumer treats it as 'log it, assume nothing'.
	Code *CommandErrorCode `json:"code,omitempty"`
	// Message Human-readable error message
	Message string `json:"message"`
	// Details Optional additional context (stack trace, field name, etc.)
	Details *string `json:"details,omitempty"`
	// Path The path the read was asked for.
	Path string `json:"path"`
}

// BrowseDirectoryRequest Request to browse a directory listing
type BrowseDirectoryRequest struct {
	Path string                      `json:"path"`
	Sort *BrowseDirectoryRequestSort `json:"sort,omitempty"`
}

type BrowseDirectoryRequestSort string

// The values of BrowseDirectoryRequestSort.
const (
	BrowseDirectoryRequestSortName            BrowseDirectoryRequestSort = "name"
	BrowseDirectoryRequestSortMtime           BrowseDirectoryRequestSort = "mtime"
	BrowseDirectoryRequestSortAnnotationCount BrowseDirectoryRequestSort = "annotationCount"
)

// Valid is whether e is one of BrowseDirectoryRequestSort's values.
func (e BrowseDirectoryRequestSort) Valid() bool {
	switch e {
	case BrowseDirectoryRequestSortName, BrowseDirectoryRequestSortMtime, BrowseDirectoryRequestSortAnnotationCount:
		return true
	}
	return false
}

// BrowseDirectoryResult Result of browsing a directory listing
type BrowseDirectoryResult struct {
	Response BrowseDirectoryResultResponse `json:"response"`
}

type BrowseDirectoryResultResponse struct {
	Path    string           `json:"path"`
	Entries []DirectoryEntry `json:"entries"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v BrowseDirectoryResultResponse) MarshalJSON() ([]byte, error) {
	type written BrowseDirectoryResultResponse
	v.Entries = listOf(v.Entries)
	return json.Marshal(written(v))
}

// BrowseEnginesRequest Request for the knowledge base's engines: those its
// Inference document names
type BrowseEnginesRequest struct{}

// BrowseEnginesResult The knowledge base's engines: those its Inference
// document names, and the jobs it has each used for
type BrowseEnginesResult struct {
	Response BrowseEnginesResultResponse `json:"response"`
}

type BrowseEnginesResultResponse struct {
	Engines []EngineEntry `json:"engines"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v BrowseEnginesResultResponse) MarshalJSON() ([]byte, error) {
	type written BrowseEnginesResultResponse
	v.Engines = listOf(v.Engines)
	return json.Marshal(written(v))
}

// BrowseEntityTypeClickedEvent Emitted when an entity type is clicked in the
// browse panel
type BrowseEntityTypeClickedEvent struct {
	EntityType string `json:"entityType"`
}

// BrowseEntityTypesRequest Request to browse available entity types
type BrowseEntityTypesRequest struct{}

// BrowseEntityTypesResult Result of browsing entity types
type BrowseEntityTypesResult struct {
	Response GetEntityTypesResponse `json:"response"`
}

// BrowseEventsRequest Request to browse events for a resource
type BrowseEventsRequest struct {
	ResourceId ResourceId `json:"resourceId"`
	Type       *string    `json:"type,omitempty"`
	UserId     *UserId    `json:"userId,omitempty"`
	Limit      *int       `json:"limit,omitempty"`
}

// BrowseEventsResult Result of browsing events for a resource
type BrowseEventsResult struct {
	Response GetEventsResponse `json:"response"`
}

// BrowseExternalNavigateEvent Emitted when navigation to an external URL is
// requested
type BrowseExternalNavigateEvent struct {
	Url        string      `json:"url"`
	ResourceId *ResourceId `json:"resourceId,omitempty"`
}

type BrowseFilesResponse struct {
	// Path The directory path that was listed, relative to project root
	Path    string           `json:"path"`
	Entries []DirectoryEntry `json:"entries"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v BrowseFilesResponse) MarshalJSON() ([]byte, error) {
	type written BrowseFilesResponse
	v.Entries = listOf(v.Entries)
	return json.Marshal(written(v))
}

// BrowseKbRequest Request for the knowledge base's description of itself
type BrowseKbRequest struct{}

// BrowseKbResult Result of browse:kb-requested
type BrowseKbResult struct {
	Response KbDescription `json:"response"`
}

// BrowseLinkClickedEvent Emitted when a link is clicked in the browse panel
type BrowseLinkClickedEvent struct {
	Href  string  `json:"href"`
	Label *string `json:"label,omitempty"`
}

// BrowsePanelOpenEvent Emitted when a browse panel is opened
type BrowsePanelOpenEvent struct {
	Panel                string        `json:"panel"`
	ScrollToAnnotationId *AnnotationId `json:"scrollToAnnotationId,omitempty"`
	Motivation           *Motivation   `json:"motivation,omitempty"`
}

// BrowsePanelToggleEvent Emitted when a browse panel is toggled
type BrowsePanelToggleEvent struct {
	Panel string `json:"panel"`
}

// BrowseProfilesRequest Request for the profiles of some principals: the DIDs
// a reply mentions. Bounded by the question: a reader that has more asks in
// parts.
type BrowseProfilesRequest struct {
	// Dids The principals asked after.
	Dids []UserId `json:"dids"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v BrowseProfilesRequest) MarshalJSON() ([]byte, error) {
	type written BrowseProfilesRequest
	v.Dids = listOf(v.Dids)
	return json.Marshal(written(v))
}

// BrowseProfilesResult The profiles of the principals asked after: each that
// has one, keyed by DID. A DID with no profile is absent, and is named by no
// one.
type BrowseProfilesResult struct {
	Response BrowseProfilesResultResponse `json:"response"`
}

type BrowseProfilesResultResponse struct {
	// Profiles Each profile, keyed by DID.
	Profiles map[string]Profile `json:"profiles"`
}

// BrowseResourceCloseEvent Emitted when a resource is closed in the browse
// panel
type BrowseResourceCloseEvent struct {
	ResourceId ResourceId `json:"resourceId"`
}

// BrowseResourceOpenEvent Domain intent to open a resource in the viewer:
// emitted locally by in-app link handlers and remotely by the launcher's tour
// verbs; the viewer translates it to host routing (nav:push), which never
// crosses the wire. Deliberately not named 'navigate' — that word and the
// nav:* prefix belong to the host-local framework layer.
type BrowseResourceOpenEvent struct {
	ResourceId ResourceId `json:"resourceId"`
}

// BrowseResourceReorderEvent Emitted when resources are reordered in the
// browse panel
type BrowseResourceReorderEvent struct {
	OldIndex int `json:"oldIndex"`
	NewIndex int `json:"newIndex"`
}

// BrowseResourceRequest Request to browse a single resource
type BrowseResourceRequest struct {
	ResourceId ResourceId `json:"resourceId"`
}

// BrowseResourceResult A resource's descriptor, and the sequence number of
// the last of its events the descriptor reflects. Its annotations are not
// here: their number follows the document's, so they are read over HTTP (`GET
// /resources/{id}/annotations`).
type BrowseResourceResult struct {
	Response BrowseResourceResultResponse `json:"response"`
}

type BrowseResourceResultResponse struct {
	Resource ResourceDescriptor `json:"resource"`
	// LastSequence The sequence number of the resource's last event. A graph
	// read that follows a write waits for the graph projection to reach it.
	LastSequence int `json:"lastSequence"`
}

// BrowseResourceViewedEvent REPORT that a resource has loaded in a viewer —
// emitted on arrival by ANY means: a followed cue, an in-app link, the back
// button, a typed URL. Deliberately distinct from the imperative
// browse:resource-open: drive and report never share a channel, or the driver
// hears its own commands and one viewer's arrival steers another's page.
type BrowseResourceViewedEvent struct {
	ResourceId ResourceId `json:"resourceId"`
}

// BrowseResourcesRequest Request to browse resources with optional filtering
// and pagination
type BrowseResourcesRequest struct {
	Archived   *bool   `json:"archived,omitempty"`
	EntityType *string `json:"entityType,omitempty"`
	// Offset How many of the resources the filters admit are passed over before
	// the page begins.
	Offset *int `json:"offset,omitempty"`
	// Limit The most resources a page has.
	Limit *int `json:"limit,omitempty"`
}

// BrowseResourcesResult Result of browsing resources
type BrowseResourcesResult struct {
	Response ListResourcesResponse `json:"response"`
}

// BrowseRouterPushEvent Emitted when the browse panel requests a router
// navigation
type BrowseRouterPushEvent struct {
	Path   string  `json:"path"`
	Reason *string `json:"reason,omitempty"`
}

// BrowseTagSchemasRequest Request to browse registered tag schemas
type BrowseTagSchemasRequest struct{}

// BrowseTagSchemasResult Result of browsing tag schemas
type BrowseTagSchemasResult struct {
	Response GetTagSchemasResponse `json:"response"`
}

// Browser The shared Browser: one viewer for every knowledge base the machine
// reaches. It belongs to no knowledge base, so its document is kept in the
// launcher's state home, in `stack/browser.yaml`, not in a knowledge base's
// repository.
type Browser struct {
	ApiVersion StackApiVersion `json:"apiVersion"`
	Kind       BrowserKind     `json:"kind"`
	Metadata   Metadata        `json:"metadata"`
	// Spec How the Browser runs.
	Spec BrowserSpec `json:"spec"`
}

type BrowserKind string

// The values of BrowserKind.
const (
	BrowserKindBrowser BrowserKind = "Browser"
)

// Valid is whether e is one of BrowserKind's values.
func (e BrowserKind) Valid() bool {
	switch e {
	case BrowserKindBrowser:
		return true
	}
	return false
}

// BrowserSpec How the Browser runs.
type BrowserSpec struct {
	Image     Image     `json:"image"`
	Resources Resources `json:"resources"`
	// Port The port the Browser is published on, on this machine's loopback:
	// where a person opens it, and the origin the issuer's realm allows its
	// sign-in from.
	Port int `json:"port"`
}

// BusEmitAccepted Result of publishing one event. `subscribers` is the number
// of observers attached to the target subject at dispatch — the GLOBAL
// subject for an unscoped emit, the scoped one when `scope` is set. Zero
// means the signal reached nobody: /bus/subscribe enforces no channel
// allowlist and the emit handler publishes unconditionally, so a client can
// emit a channel no participant subscribes to and otherwise receive a clean
// 202 with no way to tell. Deliberately NOT named `delivered`: this is the
// count at dispatch, and a subscriber may still drop the frame downstream, so
// the field is named after what the server can actually observe.
type BusEmitAccepted struct {
	// Subscribers Observers on the target subject when the event was dispatched.
	// ABSENT means the gateway could not count: under a broker signal plane (the
	// KnowledgeBase document's `spec.messaging.signal.type: nats`) the event is
	// published to a fabric whose observers the gateway cannot see. The one zero
	// a broker plane states is a registry operation's request with a
	// `correlationId` that reached nobody, which the broker itself reports (no
	// responders). Never defaulted: a zero here is the claim that nobody was
	// listening, and a gateway that did not observe that never makes it.
	Subscribers *int `json:"subscribers,omitempty"`
}

// BusEmitRequest One event for the bus. `channel` names a channel of the bus
// registry (specs/src/bus/registry.json) and `payload` must match the schema
// the registry's `validate` names for it. `scope` publishes a resource-bound
// broadcast to that resource's subscribers only; everything else is unscoped.
// `clientId` and `correlationId` are routing facts beside the payload, never
// inside it.
type BusEmitRequest struct {
	// Channel A channel of the bus registry.
	Channel string `json:"channel"`
	// Payload The channel's payload, validated against the schema its registry
	// entry names. `_userId` and `_roles` are the gateway's to write: whatever a
	// caller puts there is replaced.
	Payload map[string]any `json:"payload"`
	// Scope The resource scope of a resource-bound broadcast. Publishers of
	// those broadcasts only; a command or request never carries one.
	Scope *ResourceId `json:"scope,omitempty"`
	// ClientId The address this request's reply is delivered to: the emit claims
	// `correlationId` for this clientId and the verified principal. Required
	// when `channel` is a registry operation's request and a correlationId is
	// present; ignored otherwise. An empty string counts as absent.
	ClientId *string `json:"clientId,omitempty"`
	// CorrelationId Pairs a reply with its request. On a registry operation's
	// request it claims the id: a second claim of a live id is refused with 409.
	// Replies carry it back on the frame, never in the payload.
	CorrelationId *string `json:"correlationId,omitempty"`
}

// BusEventMessage A bus frame on the stream: `event: bus-event`, an `id:`
// line, and one `data:` line holding the JSON-serialised BusFrame. This
// schema describes the message with `data` already parsed.
type BusEventMessage struct {
	Event BusEventMessageEvent `json:"event"`
	Id    string               `json:"id"`
	Data  BusFrame             `json:"data"`
}

func (BusEventMessage) memberOfBusStreamMessage() {}

type BusEventMessageEvent string

// The values of BusEventMessageEvent.
const (
	BusEventMessageEventBusEvent BusEventMessageEvent = "bus-event"
)

// Valid is whether e is one of BusEventMessageEvent's values.
func (e BusEventMessageEvent) Valid() bool {
	switch e {
	case BusEventMessageEventBusEvent:
		return true
	}
	return false
}

// BusFrame One frame of the bus stream, as the `data` line of a `bus-event`
// message carries it (JSON-serialised on one line). `payload` is the
// channel's payload as its registry entry declares it. A frame on a scoped
// subscription carries the scope it was published on; a correlated reply
// carries the `correlationId` of the request it answers.
type BusFrame struct {
	// Channel A channel of the bus registry (specs/src/bus/registry.json).
	Channel string `json:"channel"`
	// CorrelationId The request this frame answers. Present on correlated
	// replies; absent otherwise.
	CorrelationId *string `json:"correlationId,omitempty"`
	// Payload The channel's payload. A replayed persisted event is the stored
	// event itself, whose `metadata.sequenceNumber` the message id carries.
	Payload map[string]any `json:"payload"`
	// Scope The resource scope the frame was published on. Present exactly when
	// it arrived through a `scoped` entry of the subscription.
	Scope *ResourceId `json:"scope,omitempty"`
}

// BusPingMessage The heartbeat: `event: ping` with an empty `data:` line. The
// first is written once the stream has caught up (after any replay), then one
// every `x-xynolog-limits.heartbeatSeconds`. It carries no id, so it never
// disturbs a client's last-seen ids.
type BusPingMessage struct {
	Event BusPingMessageEvent `json:"event"`
	Data  string              `json:"data"`
}

func (BusPingMessage) memberOfBusStreamMessage() {}

type BusPingMessageEvent string

// The values of BusPingMessageEvent.
const (
	BusPingMessageEventPing BusPingMessageEvent = "ping"
)

// Valid is whether e is one of BusPingMessageEvent's values.
func (e BusPingMessageEvent) Valid() bool {
	switch e {
	case BusPingMessageEventPing:
		return true
	}
	return false
}

// BusReplyBounds bus/reply-bounds.json: each list or map an operation's reply
// carries that its own schema does not bound, and what bounds it.
type BusReplyBounds struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Replies Each operation, by its request's channel.
	Replies map[string]map[string]BusReplyBoundsRepliesValueValue `json:"replies"`
}

type BusReplyBoundsRepliesValueValue struct {
	union[BusReplyBoundsRepliesValueValueMember]
}

// BusReplyBoundsRepliesValueValueMember is a member of
// BusReplyBoundsRepliesValueValue: BusReplyBoundsRepliesValueValueBy,
// BusReplyBoundsRepliesValueValueGrows.
type BusReplyBoundsRepliesValueValueMember interface {
	memberOfBusReplyBoundsRepliesValueValue()
}

// Member is the member this value is: the one whose schema admits it.
func (u BusReplyBoundsRepliesValueValue) Member() (any, error) {
	return u.member("BusReplyBoundsRepliesValueValue", busReplyBoundsRepliesValueValueMembers)
}

// busReplyBoundsRepliesValueValueMembers is what each member of
// BusReplyBoundsRepliesValueValue admits, and how a value of it is read.
var busReplyBoundsRepliesValueValueMembers = []unionMember{
	{"BusReplyBoundsRepliesValueValueBy", readAs[BusReplyBoundsRepliesValueValueBy], []signature{{kind: objectKind, required: []string{"by"}, allowed: []string{"by"}}}},
	{"BusReplyBoundsRepliesValueValueGrows", readAs[BusReplyBoundsRepliesValueValueGrows], []signature{{kind: objectKind, required: []string{"grows"}, allowed: []string{"grows"}}}},
}

// BusReplyBoundsRepliesValueValueBy A list or map bounded by a member of the
// request.
type BusReplyBoundsRepliesValueValueBy struct {
	// By The member of the request that bounds it: an array, or an integer with
	// a maximum.
	By string `json:"by"`
}

func (BusReplyBoundsRepliesValueValueBy) memberOfBusReplyBoundsRepliesValueValue() {}

// BusReplyBoundsRepliesValueValueGrows A list or map not yet bounded, which
// grows.
type BusReplyBoundsRepliesValueValueGrows struct {
	// Grows What it grows with.
	Grows string `json:"grows"`
}

func (BusReplyBoundsRepliesValueValueGrows) memberOfBusReplyBoundsRepliesValueValue() {}

// BusResumeGap The payload of `bus:resume-gap`: a scope's `lastEventId` could
// not be honoured, so the client cannot trust that it has every persisted
// event of that scope and must refetch what it caches for it. Written by the
// gateway, never by a participant.
type BusResumeGap struct {
	// Scope The scope of the subscription entry whose watermark failed.
	Scope ResourceId `json:"scope"`
	// LastSeenId The watermark the entry carried.
	LastSeenId string `json:"lastSeenId"`
	// Reason `unparseable-last-event-id`: the watermark is not a
	// PersistedEventId. `scope-mismatch`: it names another scope.
	// `retention-exceeded`: the record no longer holds the events after it (what
	// it still holds is replayed first). `query-error`: the record could not be
	// read.
	Reason BusResumeGapReason `json:"reason"`
}

// BusResumeGapReason `unparseable-last-event-id`: the watermark is not a
// PersistedEventId. `scope-mismatch`: it names another scope.
// `retention-exceeded`: the record no longer holds the events after it (what
// it still holds is replayed first). `query-error`: the record could not be
// read.
type BusResumeGapReason string

// The values of BusResumeGapReason.
const (
	BusResumeGapReasonUnparseableLastEventId BusResumeGapReason = "unparseable-last-event-id"
	BusResumeGapReasonScopeMismatch          BusResumeGapReason = "scope-mismatch"
	BusResumeGapReasonRetentionExceeded      BusResumeGapReason = "retention-exceeded"
	BusResumeGapReasonQueryError             BusResumeGapReason = "query-error"
)

// Valid is whether e is one of BusResumeGapReason's values.
func (e BusResumeGapReason) Valid() bool {
	switch e {
	case BusResumeGapReasonUnparseableLastEventId, BusResumeGapReasonScopeMismatch, BusResumeGapReasonRetentionExceeded, BusResumeGapReasonQueryError:
		return true
	}
	return false
}

// BusStreamMessage Every message the bus stream carries. A client ignores an
// `event` it does not know; the gateway writes no other.
type BusStreamMessage struct {
	union[BusStreamMessageMember]
}

// BusStreamMessageMember is a member of BusStreamMessage: BusEventMessage,
// BusPingMessage.
type BusStreamMessageMember interface {
	memberOfBusStreamMessage()
}

// Member is the member this value is: the one whose schema admits it.
func (u BusStreamMessage) Member() (any, error) {
	return u.member("BusStreamMessage", busStreamMessageMembers)
}

// busStreamMessageMembers is what each member of BusStreamMessage admits, and
// how a value of it is read.
var busStreamMessageMembers = []unionMember{
	{"BusEventMessage", readAs[BusEventMessage], []signature{{kind: objectKind, required: []string{"event", "id", "data"}, allowed: []string{"event", "id", "data"}, fixed: []fixedValues{{"event", []any{"bus-event"}}}}}},
	{"BusPingMessage", readAs[BusPingMessage], []signature{{kind: objectKind, required: []string{"event", "data"}, allowed: []string{"event", "data"}, fixed: []fixedValues{{"event", []any{"ping"}}}}}},
}

// BusSubscribeRequest Subscription matrix for the bus stream. `global`
// channels are delivered unscoped; each `scoped` entry subscribes the
// connection to one resource scope's channels, optionally resuming from that
// scope's last-seen persisted event id. At least one global channel or one
// scoped entry is required, and no scope may appear in two entries.
type BusSubscribeRequest struct {
	// Global Unscoped channels to subscribe to.
	Global *[]string `json:"global,omitempty"`
	// PendingReplies Correlation ids of requests this client still awaits a
	// reply to. The gateway writes every reply it still retains for them (for
	// `x-xynolog-limits.replyRetentionSeconds` after it was published) as an
	// ordinary frame with its ReplyEventId, so a reply that also arrived live
	// dedups client-side. A client can have no more pending than it may have
	// unanswered requests, so this bound is also the number of unanswered
	// requests `POST /bus/emit` allows a client.
	PendingReplies *[]string `json:"pendingReplies,omitempty"`
	// Scoped Per-resource-scope subscriptions, at most 512 on one connection.
	// Scopes must be unique across entries.
	Scoped *[]BusSubscribeRequestScopedItem `json:"scoped,omitempty"`
	// ClientId Routing address for correlated replies: a UUID minted once per
	// bus-client lifetime — per actor, not per connection, so it survives a
	// reconnect and two overlapping connections share it. A correlated reply is
	// delivered to a connection only when its request was emitted under the same
	// clientId by the same principal. Not authentication — the bearer token
	// stays that — and never echoed into any payload or broadcast frame.
	ClientId string `json:"clientId"`
}

type BusSubscribeRequestScopedItem struct {
	// Scope Resource scope (a resourceId).
	Scope ResourceId `json:"scope"`
	// Channels Channels to subscribe within this scope.
	Channels []string `json:"channels"`
	// LastEventId This scope's last-seen PersistedEventId. The gateway replays
	// this scope's persisted events after it — those on the entry's channels —
	// before the live tail, and writes a scoped `bus:resume-gap` (BusResumeGap)
	// when it cannot cover the gap.
	LastEventId *string `json:"lastEventId,omitempty"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v BusSubscribeRequestScopedItem) MarshalJSON() ([]byte, error) {
	type written BusSubscribeRequestScopedItem
	v.Channels = listOf(v.Channels)
	return json.Marshal(written(v))
}

// Cancelled The client gives up on one of its requests. The launcher answers
// that request with control.cancelled, unless it has answered it already; a
// cancellation of a request it does not know is ignored.
type Cancelled struct {
	RequestId RequestId `json:"requestId"`
	// Reason Why, for the launcher's diagnostics.
	Reason *string `json:"reason,omitempty"`
}

// ClaimOptions What a worker's claiming of jobs is told: the jobs it takes,
// and how long it waits for what it waits on. A wait left out is
// client/timing.json's of the same name.
type ClaimOptions struct {
	// Accepts The jobs this claim takes. A job is handed over when it matches
	// any one of them.
	Accepts []JobFilter `json:"accepts"`
	// JobClaimTimeoutMs How long it waits for the answer to one claim, in
	// milliseconds.
	JobClaimTimeoutMs *int `json:"jobClaimTimeoutMs,omitempty"`
	// HeldJobStallMs How long a held job may show no activity before it is
	// called stalled, in milliseconds.
	HeldJobStallMs *int `json:"heldJobStallMs,omitempty"`
	// HeldJobStallCheckMs How often it looks at how long a held job has shown no
	// activity, in milliseconds.
	HeldJobStallCheckMs *int `json:"heldJobStallCheckMs,omitempty"`
	// MarkCommitTimeoutMs How long it waits for the record to acknowledge a
	// commit of annotations, in milliseconds.
	MarkCommitTimeoutMs *int `json:"markCommitTimeoutMs,omitempty"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ClaimOptions) MarshalJSON() ([]byte, error) {
	type written ClaimOptions
	v.Accepts = listOf(v.Accepts)
	return json.Marshal(written(v))
}

// ClientDiscoveryAbsent client/discovery-absent.json: why a client that read
// a launcher's discovery document found no launcher.
type ClientDiscoveryAbsent struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Reasons Each reason, and what it means.
	Reasons []ClientDiscoveryAbsentReasonsItem `json:"reasons"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ClientDiscoveryAbsent) MarshalJSON() ([]byte, error) {
	type written ClientDiscoveryAbsent
	v.Reasons = listOf(v.Reasons)
	return json.Marshal(written(v))
}

type ClientDiscoveryAbsentReasonsItem struct {
	// Reason The reason, as every SDK spells it.
	Reason string `json:"reason"`
	// Docs What it is, in prose.
	Docs string `json:"docs"`
}

// ClientRefresh client/refresh.json: what a Xynolog client asks again for,
// and when.
type ClientRefresh struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Queries The live queries.
	Queries []ClientRefreshQueriesItem `json:"queries"`
	// Refresh A row per trigger.
	Refresh []ClientRefreshRefreshItem `json:"refresh"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ClientRefresh) MarshalJSON() ([]byte, error) {
	type written ClientRefresh
	v.Queries = listOf(v.Queries)
	v.Refresh = listOf(v.Refresh)
	return json.Marshal(written(v))
}

type ClientRefreshQueriesItem struct {
	union[ClientRefreshQueriesItemMember]
}

// ClientRefreshQueriesItemMember is a member of ClientRefreshQueriesItem:
// ClientRefreshQueriesItemAsks, ClientRefreshQueriesItemReads.
type ClientRefreshQueriesItemMember interface {
	memberOfClientRefreshQueriesItem()
}

// Member is the member this value is: the one whose schema admits it.
func (u ClientRefreshQueriesItem) Member() (any, error) {
	return u.member("ClientRefreshQueriesItem", clientRefreshQueriesItemMembers)
}

// clientRefreshQueriesItemMembers is what each member of
// ClientRefreshQueriesItem admits, and how a value of it is read.
var clientRefreshQueriesItemMembers = []unionMember{
	{"ClientRefreshQueriesItemAsks", readAs[ClientRefreshQueriesItemAsks], []signature{{kind: objectKind, required: []string{"name", "asks", "value", "docs"}, allowed: []string{"name", "per", "asks", "persisted", "value", "docs"}, fixed: []fixedValues{{"per", []any{"resource", "annotation", "filters"}}, {"persisted", []any{true}}}}}},
	{"ClientRefreshQueriesItemReads", readAs[ClientRefreshQueriesItemReads], []signature{{kind: objectKind, required: []string{"name", "reads", "value", "docs"}, allowed: []string{"name", "per", "reads", "persisted", "value", "docs"}, fixed: []fixedValues{{"per", []any{"resource", "annotation", "filters"}}, {"persisted", []any{true}}}}}},
}

// ClientRefreshQueriesItemAsks A live query that asks an operation of the
// registry, by its request's channel.
type ClientRefreshQueriesItemAsks struct {
	// Name A query, by its name.
	Name string `json:"name"`
	// Per What one is kept per; absent, the knowledge base has one.
	Per *ClientRefreshQueriesItemAsksPer `json:"per,omitempty"`
	// Asks The channel's name.
	Asks string `json:"asks"`
	// Persisted Its answers are kept across a client's lives.
	Persisted *ClientRefreshQueriesItemAsksPersisted `json:"persisted,omitempty"`
	// Value A reference to the schema of its value.
	Value ClientRefreshQueriesItemAsksValue `json:"value"`
	// Docs What it is, in prose.
	Docs string `json:"docs"`
}

func (ClientRefreshQueriesItemAsks) memberOfClientRefreshQueriesItem() {}

// ClientRefreshQueriesItemAsksPer What one is kept per; absent, the knowledge
// base has one.
type ClientRefreshQueriesItemAsksPer string

// The values of ClientRefreshQueriesItemAsksPer.
const (
	ClientRefreshQueriesItemAsksPerResource   ClientRefreshQueriesItemAsksPer = "resource"
	ClientRefreshQueriesItemAsksPerAnnotation ClientRefreshQueriesItemAsksPer = "annotation"
	ClientRefreshQueriesItemAsksPerFilters    ClientRefreshQueriesItemAsksPer = "filters"
)

// Valid is whether e is one of ClientRefreshQueriesItemAsksPer's values.
func (e ClientRefreshQueriesItemAsksPer) Valid() bool {
	switch e {
	case ClientRefreshQueriesItemAsksPerResource, ClientRefreshQueriesItemAsksPerAnnotation, ClientRefreshQueriesItemAsksPerFilters:
		return true
	}
	return false
}

// ClientRefreshQueriesItemAsksPersisted Its answers are kept across a
// client's lives.
type ClientRefreshQueriesItemAsksPersisted bool

// The values of ClientRefreshQueriesItemAsksPersisted.
const (
	ClientRefreshQueriesItemAsksPersistedTrue ClientRefreshQueriesItemAsksPersisted = true
)

// Valid is whether e is one of ClientRefreshQueriesItemAsksPersisted's
// values.
func (e ClientRefreshQueriesItemAsksPersisted) Valid() bool {
	switch e {
	case ClientRefreshQueriesItemAsksPersistedTrue:
		return true
	}
	return false
}

// ClientRefreshQueriesItemAsksValue A reference to the schema of its value.
type ClientRefreshQueriesItemAsksValue struct {
	// Ref The $id of the schema of what its cache holds for a key: a component,
	// or a member within one.
	Ref string `json:"$ref"`
}

// ClientRefreshQueriesItemReads A live query that reads a GET of the
// gateway's API.
type ClientRefreshQueriesItemReads struct {
	// Name A query, by its name.
	Name string `json:"name"`
	// Per What one is kept per; absent, the knowledge base has one.
	Per *ClientRefreshQueriesItemReadsPer `json:"per,omitempty"`
	// Reads The GET of the gateway's API it reads.
	Reads string `json:"reads"`
	// Persisted Its answers are kept across a client's lives.
	Persisted *ClientRefreshQueriesItemReadsPersisted `json:"persisted,omitempty"`
	// Value A reference to the schema of its value.
	Value ClientRefreshQueriesItemReadsValue `json:"value"`
	// Docs What it is, in prose.
	Docs string `json:"docs"`
}

func (ClientRefreshQueriesItemReads) memberOfClientRefreshQueriesItem() {}

// ClientRefreshQueriesItemReadsPer What one is kept per; absent, the
// knowledge base has one.
type ClientRefreshQueriesItemReadsPer string

// The values of ClientRefreshQueriesItemReadsPer.
const (
	ClientRefreshQueriesItemReadsPerResource   ClientRefreshQueriesItemReadsPer = "resource"
	ClientRefreshQueriesItemReadsPerAnnotation ClientRefreshQueriesItemReadsPer = "annotation"
	ClientRefreshQueriesItemReadsPerFilters    ClientRefreshQueriesItemReadsPer = "filters"
)

// Valid is whether e is one of ClientRefreshQueriesItemReadsPer's values.
func (e ClientRefreshQueriesItemReadsPer) Valid() bool {
	switch e {
	case ClientRefreshQueriesItemReadsPerResource, ClientRefreshQueriesItemReadsPerAnnotation, ClientRefreshQueriesItemReadsPerFilters:
		return true
	}
	return false
}

// ClientRefreshQueriesItemReadsPersisted Its answers are kept across a
// client's lives.
type ClientRefreshQueriesItemReadsPersisted bool

// The values of ClientRefreshQueriesItemReadsPersisted.
const (
	ClientRefreshQueriesItemReadsPersistedTrue ClientRefreshQueriesItemReadsPersisted = true
)

// Valid is whether e is one of ClientRefreshQueriesItemReadsPersisted's
// values.
func (e ClientRefreshQueriesItemReadsPersisted) Valid() bool {
	switch e {
	case ClientRefreshQueriesItemReadsPersistedTrue:
		return true
	}
	return false
}

// ClientRefreshQueriesItemReadsValue A reference to the schema of its value.
type ClientRefreshQueriesItemReadsValue struct {
	// Ref The $id of the schema of what its cache holds for a key: a component,
	// or a member within one.
	Ref string `json:"$ref"`
}

type ClientRefreshRefreshItem struct {
	union[ClientRefreshRefreshItemMember]
}

// ClientRefreshRefreshItemMember is a member of ClientRefreshRefreshItem:
// ClientRefreshRefreshItemOn, ClientRefreshRefreshItemStream.
type ClientRefreshRefreshItemMember interface {
	memberOfClientRefreshRefreshItem()
}

// Member is the member this value is: the one whose schema admits it.
func (u ClientRefreshRefreshItem) Member() (any, error) {
	return u.member("ClientRefreshRefreshItem", clientRefreshRefreshItemMembers)
}

// clientRefreshRefreshItemMembers is what each member of
// ClientRefreshRefreshItem admits, and how a value of it is read.
var clientRefreshRefreshItemMembers = []unionMember{
	{"ClientRefreshRefreshItemOn", readAs[ClientRefreshRefreshItemOn], []signature{{kind: objectKind, required: []string{"on", "docs"}, allowed: []string{"on", "when", "reach", "names", "carries", "refetches", "writes", "removes", "docs"}, fixed: []fixedValues{{"when", []any{"enriched", "unenriched"}}, {"reach", []any{"subject", "held"}}}}}},
	{"ClientRefreshRefreshItemStream", readAs[ClientRefreshRefreshItemStream], []signature{{kind: objectKind, required: []string{"stream", "docs"}, allowed: []string{"stream", "reach", "refetches", "docs"}, fixed: []fixedValues{{"stream", []any{"reopened", "unreadable"}}, {"reach", []any{"subject", "held"}}}}}},
}

// ClientRefreshRefreshItemOn A row for a channel's events.
type ClientRefreshRefreshItemOn struct {
	// On The channel's name.
	On string `json:"on"`
	// When Which of a channel's two ways of event the row is for.
	When *ClientRefreshRefreshItemOnWhen `json:"when,omitempty"`
	// Reach Which keys the row reaches: the event's subject, or every key held.
	Reach *ClientRefreshRefreshItemOnReach `json:"reach,omitempty"`
	// Names Where in the event a subject row finds the resource and the
	// annotation it names.
	Names *ClientRefreshRefreshItemOnNames `json:"names,omitempty"`
	// Carries A way into the event's payload: the names of the members it passes
	// through and of its own, joined by dots.
	Carries *string `json:"carries,omitempty"`
	// Refetches The queries asked again.
	Refetches *[]string `json:"refetches,omitempty"`
	// Writes The queries whose new value the event carries.
	Writes *[]string `json:"writes,omitempty"`
	// Removes The queries whose entity the event says is gone.
	Removes *[]string `json:"removes,omitempty"`
	// Docs What it is, in prose.
	Docs string `json:"docs"`
}

func (ClientRefreshRefreshItemOn) memberOfClientRefreshRefreshItem() {}

// ClientRefreshRefreshItemOnNames Where in the event a subject row finds the
// resource and the annotation it names.
type ClientRefreshRefreshItemOnNames struct {
	// Resource A way into the event's payload: the names of the members it
	// passes through and of its own, joined by dots.
	Resource *string `json:"resource,omitempty"`
	// Annotation A way into the event's payload: the names of the members it
	// passes through and of its own, joined by dots.
	Annotation *string `json:"annotation,omitempty"`
}

// ClientRefreshRefreshItemOnReach Which keys the row reaches: the event's
// subject, or every key held.
type ClientRefreshRefreshItemOnReach string

// The values of ClientRefreshRefreshItemOnReach.
const (
	ClientRefreshRefreshItemOnReachSubject ClientRefreshRefreshItemOnReach = "subject"
	ClientRefreshRefreshItemOnReachHeld    ClientRefreshRefreshItemOnReach = "held"
)

// Valid is whether e is one of ClientRefreshRefreshItemOnReach's values.
func (e ClientRefreshRefreshItemOnReach) Valid() bool {
	switch e {
	case ClientRefreshRefreshItemOnReachSubject, ClientRefreshRefreshItemOnReachHeld:
		return true
	}
	return false
}

// ClientRefreshRefreshItemOnWhen Which of a channel's two ways of event the
// row is for.
type ClientRefreshRefreshItemOnWhen string

// The values of ClientRefreshRefreshItemOnWhen.
const (
	ClientRefreshRefreshItemOnWhenEnriched   ClientRefreshRefreshItemOnWhen = "enriched"
	ClientRefreshRefreshItemOnWhenUnenriched ClientRefreshRefreshItemOnWhen = "unenriched"
)

// Valid is whether e is one of ClientRefreshRefreshItemOnWhen's values.
func (e ClientRefreshRefreshItemOnWhen) Valid() bool {
	switch e {
	case ClientRefreshRefreshItemOnWhenEnriched, ClientRefreshRefreshItemOnWhenUnenriched:
		return true
	}
	return false
}

// ClientRefreshRefreshItemStream A row for what befalls the stream itself.
type ClientRefreshRefreshItemStream struct {
	// Stream `reopened`, the stream open again after a drop; or `unreadable`, an
	// event that cannot be read.
	Stream ClientRefreshRefreshItemStreamStream `json:"stream"`
	// Reach Which keys the row reaches: the event's subject, or every key held.
	Reach *ClientRefreshRefreshItemStreamReach `json:"reach,omitempty"`
	// Refetches The queries asked again.
	Refetches *[]string `json:"refetches,omitempty"`
	// Docs What it is, in prose.
	Docs string `json:"docs"`
}

func (ClientRefreshRefreshItemStream) memberOfClientRefreshRefreshItem() {}

// ClientRefreshRefreshItemStreamReach Which keys the row reaches: the event's
// subject, or every key held.
type ClientRefreshRefreshItemStreamReach string

// The values of ClientRefreshRefreshItemStreamReach.
const (
	ClientRefreshRefreshItemStreamReachSubject ClientRefreshRefreshItemStreamReach = "subject"
	ClientRefreshRefreshItemStreamReachHeld    ClientRefreshRefreshItemStreamReach = "held"
)

// Valid is whether e is one of ClientRefreshRefreshItemStreamReach's values.
func (e ClientRefreshRefreshItemStreamReach) Valid() bool {
	switch e {
	case ClientRefreshRefreshItemStreamReachSubject, ClientRefreshRefreshItemStreamReachHeld:
		return true
	}
	return false
}

// ClientRefreshRefreshItemStreamStream `reopened`, the stream open again
// after a drop; or `unreadable`, an event that cannot be read.
type ClientRefreshRefreshItemStreamStream string

// The values of ClientRefreshRefreshItemStreamStream.
const (
	ClientRefreshRefreshItemStreamStreamReopened   ClientRefreshRefreshItemStreamStream = "reopened"
	ClientRefreshRefreshItemStreamStreamUnreadable ClientRefreshRefreshItemStreamStream = "unreadable"
)

// Valid is whether e is one of ClientRefreshRefreshItemStreamStream's values.
func (e ClientRefreshRefreshItemStreamStream) Valid() bool {
	switch e {
	case ClientRefreshRefreshItemStreamStreamReopened, ClientRefreshRefreshItemStreamStreamUnreadable:
		return true
	}
	return false
}

// ClientSecretForm The form a service account that holds a client secret
// posts to its issuer's token endpoint for a client-credentials grant: its
// client id and secret in the body (RFC 6749 §2.3.1). An account that holds a
// key proves itself by the client assertion of client-assertion-cases.json
// instead.
type ClientSecretForm struct {
	// GrantType The grant, client-assertion-cases.json's grantType.
	GrantType ClientSecretFormGrantType `json:"grant_type"`
	// ClientId The account's client id.
	ClientId string `json:"client_id"`
	// ClientSecret The account's client secret.
	ClientSecret string `json:"client_secret"`
}

// ClientSecretFormGrantType The grant, client-assertion-cases.json's
// grantType.
type ClientSecretFormGrantType string

// The values of ClientSecretFormGrantType.
const (
	ClientSecretFormGrantTypeClientCredentials ClientSecretFormGrantType = "client_credentials"
)

// Valid is whether e is one of ClientSecretFormGrantType's values.
func (e ClientSecretFormGrantType) Valid() bool {
	switch e {
	case ClientSecretFormGrantTypeClientCredentials:
		return true
	}
	return false
}

// ClientTesting client/testing.json: the testing kit every SDK ships.
type ClientTesting struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// FaultActions What a faulty transport does to a request.
	FaultActions   []ClientTestingFaultActionsItem `json:"faultActions"`
	DelayMs        ClientTestingDelayMs            `json:"delayMs"`
	ScheduleLength ClientTestingScheduleLength     `json:"scheduleLength"`
	Slack          ClientTestingSlack              `json:"slack"`
	DeliveryOps    ClientTestingDeliveryOps        `json:"deliveryOps"`
	// Records The kit's records.
	Records []ClientTestingRecordsItem `json:"records"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ClientTesting) MarshalJSON() ([]byte, error) {
	type written ClientTesting
	v.FaultActions = listOf(v.FaultActions)
	v.Records = listOf(v.Records)
	return json.Marshal(written(v))
}

type ClientTestingDelayMs struct {
	// Docs What it is, in prose.
	Docs string `json:"docs"`
	// Minimum The fewest milliseconds a drawn delay is.
	Minimum int `json:"minimum"`
	// Maximum The most milliseconds a drawn delay is.
	Maximum int `json:"maximum"`
}

type ClientTestingDeliveryOps struct {
	// Docs What it is, in prose.
	Docs string `json:"docs"`
	// Ops The steps an interleaving is of.
	Ops []string `json:"ops"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ClientTestingDeliveryOps) MarshalJSON() ([]byte, error) {
	type written ClientTestingDeliveryOps
	v.Ops = listOf(v.Ops)
	return json.Marshal(written(v))
}

type ClientTestingFaultActionsItem struct {
	// Name The fault's type's name.
	Name string `json:"name"`
	// Kind The word that names the fault in a request log.
	Kind string `json:"kind"`
	// Docs What it is, in prose.
	Docs string `json:"docs"`
	// Holds The whole numbers the fault carries, by name.
	Holds []string `json:"holds"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ClientTestingFaultActionsItem) MarshalJSON() ([]byte, error) {
	type written ClientTestingFaultActionsItem
	v.Holds = listOf(v.Holds)
	return json.Marshal(written(v))
}

type ClientTestingRecordsItem struct {
	// Name The record's type's name.
	Name string `json:"name"`
	// Docs What it is, in prose.
	Docs string `json:"docs"`
	// Members The record's members, named as surface.json names members.
	Members []string `json:"members"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ClientTestingRecordsItem) MarshalJSON() ([]byte, error) {
	type written ClientTestingRecordsItem
	v.Members = listOf(v.Members)
	return json.Marshal(written(v))
}

type ClientTestingScheduleLength struct {
	// Docs What it is, in prose.
	Docs string `json:"docs"`
	// Minimum The fewest faults a drawn schedule is of.
	Minimum int `json:"minimum"`
	// Maximum The most faults a drawn schedule is of.
	Maximum int `json:"maximum"`
}

type ClientTestingSlack struct {
	// Docs What it is, in prose.
	Docs string `json:"docs"`
	// Times How many times its reckoned bound a case is given.
	Times int `json:"times"`
}

// ClientTiming client/timing.json: the timings every Xynolog client keeps.
type ClientTiming struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Timing Each timing.
	Timing []ClientTimingTimingItem `json:"timing"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ClientTiming) MarshalJSON() ([]byte, error) {
	type written ClientTiming
	v.Timing = listOf(v.Timing)
	return json.Marshal(written(v))
}

type ClientTimingTimingItem struct {
	// Name The timing's name: a duration's ends in Ms, a retry budget's in
	// Retry, a count's in Count.
	Name  string                      `json:"name"`
	Value ClientTimingTimingItemValue `json:"value"`
	// Docs What it is, in prose.
	Docs string `json:"docs"`
}

type ClientTimingTimingItemValue struct {
	union[ClientTimingTimingItemValueMember]
}

// ClientTimingTimingItemValueMember is a member of
// ClientTimingTimingItemValue: ClientTimingTimingItemValueInteger,
// RetryBudget.
type ClientTimingTimingItemValueMember interface {
	memberOfClientTimingTimingItemValue()
}

// Member is the member this value is: the one whose schema admits it.
func (u ClientTimingTimingItemValue) Member() (any, error) {
	return u.member("ClientTimingTimingItemValue", clientTimingTimingItemValueMembers)
}

// clientTimingTimingItemValueMembers is what each member of
// ClientTimingTimingItemValue admits, and how a value of it is read.
var clientTimingTimingItemValueMembers = []unionMember{
	{"ClientTimingTimingItemValueInteger", readAs[ClientTimingTimingItemValueInteger], []signature{{kind: integerKind}}},
	{"RetryBudget", readAs[RetryBudget], []signature{{kind: objectKind, required: []string{"attempts", "initialDelayMs", "maxDelayMs"}, allowed: []string{"attempts", "initialDelayMs", "maxDelayMs"}}}},
}

// ClientTimingTimingItemValueInteger is a ClientTimingTimingItemValue that is
// integer.
type ClientTimingTimingItemValueInteger int

func (ClientTimingTimingItemValueInteger) memberOfClientTimingTimingItemValue() {}

type CloneResourceWithTokenResponse struct {
	// Token Generated clone token
	Token string `json:"token"`
	// ExpiresAt ISO 8601 timestamp when token expires
	ExpiresAt string             `json:"expiresAt"`
	Resource  ResourceDescriptor `json:"resource"`
}

// CommandError Error response for failed bus commands. Replaces native Error
// objects on the EventBus so payloads are serializable and OpenAPI-typed.
type CommandError struct {
	// Code Machine-readable failure class, for consumers that must BRANCH on why
	// a command failed rather than log it. Optional and deliberately sparse:
	// absent means 'no class declared', and every existing failure stays that
	// way. An enum rather than a free string so the vocabulary has an owner — an
	// unconstrained code is a mirror with no gate, and adding one should be a
	// deliberate spec change. `message` remains the human-readable text and is
	// unaffected. Members: `peer-unavailable` — the channel this command was
	// sent on has no subscriber, i.e. the service that answers it has not
	// connected yet. Transient by nature (a peer still starting), which is what
	// distinguishes it from a refusal: retrying is the correct response.
	// `not-found` — the resource this command addressed does not exist in this
	// knowledge base. A verdict, not a symptom: it is emitted only where the
	// answer comes from the event store, which is the system of record, and
	// never from a projection that may merely be lagging. Deterministic, so
	// unlike `peer-unavailable` retrying is pointless — and consumers may act
	// destructively on it (the SDK deletes a restored tab). Absence is not
	// denial: a future 'exists, but not for you' must travel as its own code,
	// never as this one. `unauthorized` — that code: the caller is authenticated
	// but not permitted to do what it asked. A verdict about the CALLER, not the
	// resource, so retrying under the same credential cannot succeed and a
	// consumer must never spin on it; emitted by `job:claim` for a caller whose
	// token carries no worker role. `none-pending` — a declined claim, not an
	// error: the queue holds no pending job of the requested types. Nothing went
	// wrong; the one code a consumer PARKS on, meaning 'nothing to do until a
	// wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying
	// neither is unclassified — a malformed record or a missing injection — and
	// a consumer treats it as 'log it, assume nothing'.
	Code *CommandErrorCode `json:"code,omitempty"`
	// Message Human-readable error message
	Message string `json:"message"`
	// Details Optional additional context (stack trace, field name, etc.)
	Details *string `json:"details,omitempty"`
}

// CommandErrorCode Machine-readable failure class, for consumers that must
// BRANCH on why a command failed rather than log it. Optional and
// deliberately sparse: absent means 'no class declared', and every existing
// failure stays that way. An enum rather than a free string so the vocabulary
// has an owner — an unconstrained code is a mirror with no gate, and adding
// one should be a deliberate spec change. `message` remains the
// human-readable text and is unaffected. Members: `peer-unavailable` — the
// channel this command was sent on has no subscriber, i.e. the service that
// answers it has not connected yet. Transient by nature (a peer still
// starting), which is what distinguishes it from a refusal: retrying is the
// correct response. `not-found` — the resource this command addressed does
// not exist in this knowledge base. A verdict, not a symptom: it is emitted
// only where the answer comes from the event store, which is the system of
// record, and never from a projection that may merely be lagging.
// Deterministic, so unlike `peer-unavailable` retrying is pointless — and
// consumers may act destructively on it (the SDK deletes a restored tab).
// Absence is not denial: a future 'exists, but not for you' must travel as
// its own code, never as this one. `unauthorized` — that code: the caller is
// authenticated but not permitted to do what it asked. A verdict about the
// CALLER, not the resource, so retrying under the same credential cannot
// succeed and a consumer must never spin on it; emitted by `job:claim` for a
// caller whose token carries no worker role. `none-pending` — a declined
// claim, not an error: the queue holds no pending job of the requested types.
// Nothing went wrong; the one code a consumer PARKS on, meaning 'nothing to
// do until a wake-up'. Emitted by `job:claim` only. A `job:claim` refusal
// carrying neither is unclassified — a malformed record or a missing
// injection — and a consumer treats it as 'log it, assume nothing'.
type CommandErrorCode string

// The values of CommandErrorCode.
const (
	CommandErrorCodePeerUnavailable CommandErrorCode = "peer-unavailable"
	CommandErrorCodeNotFound        CommandErrorCode = "not-found"
	CommandErrorCodeUnauthorized    CommandErrorCode = "unauthorized"
	CommandErrorCodeNonePending     CommandErrorCode = "none-pending"
)

// Valid is whether e is one of CommandErrorCode's values.
func (e CommandErrorCode) Valid() bool {
	switch e {
	case CommandErrorCodePeerUnavailable, CommandErrorCodeNotFound, CommandErrorCodeUnauthorized, CommandErrorCodeNonePending:
		return true
	}
	return false
}

// CommentingJobParams What a commenting job takes: passages of the resource
// are marked, each with a comment the model writes.
type CommentingJobParams struct {
	Motivation CommentingJobParamsMotivation `json:"motivation"`
	// Instructions What to look for, in the caller's words. Added to the prompt.
	Instructions *string `json:"instructions,omitempty"`
	// Tone The voice the comments are written in.
	Tone *CommentingJobParamsTone `json:"tone,omitempty"`
	// Density How many annotations to aim for per 2000 words of the resource.
	Density *float64 `json:"density,omitempty"`
	// Language The language the annotations' own text is written in. BCP 47.
	Language *string `json:"language,omitempty"`
	// SourceLanguage The language of the resource being read. BCP 47.
	SourceLanguage *string `json:"sourceLanguage,omitempty"`
}

func (CommentingJobParams) memberOfMarkJobParams() {}
func (CommentingJobParams) told() (string, string) { return "motivation", "commenting" }

type CommentingJobParamsMotivation string

// The values of CommentingJobParamsMotivation.
const (
	CommentingJobParamsMotivationCommenting CommentingJobParamsMotivation = "commenting"
)

// Valid is whether e is one of CommentingJobParamsMotivation's values.
func (e CommentingJobParamsMotivation) Valid() bool {
	switch e {
	case CommentingJobParamsMotivationCommenting:
		return true
	}
	return false
}

// CommentingJobParamsTone The voice the comments are written in.
type CommentingJobParamsTone string

// The values of CommentingJobParamsTone.
const (
	CommentingJobParamsToneScholarly      CommentingJobParamsTone = "scholarly"
	CommentingJobParamsToneExplanatory    CommentingJobParamsTone = "explanatory"
	CommentingJobParamsToneConversational CommentingJobParamsTone = "conversational"
	CommentingJobParamsToneTechnical      CommentingJobParamsTone = "technical"
)

// Valid is whether e is one of CommentingJobParamsTone's values.
func (e CommentingJobParamsTone) Valid() bool {
	switch e {
	case CommentingJobParamsToneScholarly, CommentingJobParamsToneExplanatory, CommentingJobParamsToneConversational, CommentingJobParamsToneTechnical:
		return true
	}
	return false
}

// ConformanceBusFetch A request on the bus a live case expects the client to
// make, on this channel; `as` names its correlation id, for the backend to
// answer.
type ConformanceBusFetch struct {
	// Fetch The request's channel, a request of specs/src/bus/registry.json.
	Fetch   string `json:"fetch"`
	Payload any    `json:"payload,omitempty"`
	// As The request's correlation id, for the backend's answer.
	As string `json:"as"`
}

func (ConformanceBusFetch) memberOfConformanceStepFetchesFetchesItem() {}
func (ConformanceBusFetch) memberOfConformanceStep()                   {}

// ConformanceCase One case of the conformance corpus: a scenario every SDK's
// driver is put through, a JSON file of conformance/sdk/wire,
// conformance/sdk/live or conformance/worker/cases named by the case. What
// the client is asked to do, what the backend does around it, and the
// transcript a conforming client produces. conformance/sdk/README.md explains
// each step; the reader reads every file of the corpus through this schema.
type ConformanceCase struct {
	// About What the case holds a client to, in a sentence.
	About string `json:"about"`
	// Source Where the protocol or the spec states it.
	Source string `json:"source"`
	// Planes The signal planes the case runs on. Absent, it runs on both.
	Planes *[]ConformanceCasePlanesItem `json:"planes,omitempty"`
	// Tier A live case's tier: `fleet`, what every SDK with a live layer does,
	// or `parity`, what one that implements all of CACHE-SEMANTICS does.
	Tier *ConformanceCaseTier `json:"tier,omitempty"`
	// Telemetry Run the client exporting to an OTLP receiver, and once it has
	// exited hold what it exported to specs/src/sdk-telemetry/telemetry.json. A
	// worker case also holds the worker to a trace of its own for each job it
	// ran (conformance/worker/README.md).
	Telemetry *ConformanceCaseTelemetry `json:"telemetry,omitempty"`
	// Steps The steps, run in order.
	Steps []ConformanceStep `json:"steps"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ConformanceCase) MarshalJSON() ([]byte, error) {
	type written ConformanceCase
	v.Steps = listOf(v.Steps)
	return json.Marshal(written(v))
}

type ConformanceCasePlanesItem string

// The values of ConformanceCasePlanesItem.
const (
	ConformanceCasePlanesItemInProcess ConformanceCasePlanesItem = "in-process"
	ConformanceCasePlanesItemNats      ConformanceCasePlanesItem = "nats"
)

// Valid is whether e is one of ConformanceCasePlanesItem's values.
func (e ConformanceCasePlanesItem) Valid() bool {
	switch e {
	case ConformanceCasePlanesItemInProcess, ConformanceCasePlanesItemNats:
		return true
	}
	return false
}

// ConformanceCaseTelemetry Run the client exporting to an OTLP receiver, and
// once it has exited hold what it exported to
// specs/src/sdk-telemetry/telemetry.json. A worker case also holds the worker
// to a trace of its own for each job it ran (conformance/worker/README.md).
type ConformanceCaseTelemetry bool

// The values of ConformanceCaseTelemetry.
const (
	ConformanceCaseTelemetryTrue ConformanceCaseTelemetry = true
)

// Valid is whether e is one of ConformanceCaseTelemetry's values.
func (e ConformanceCaseTelemetry) Valid() bool {
	switch e {
	case ConformanceCaseTelemetryTrue:
		return true
	}
	return false
}

// ConformanceCaseTier A live case's tier: `fleet`, what every SDK with a live
// layer does, or `parity`, what one that implements all of CACHE-SEMANTICS
// does.
type ConformanceCaseTier string

// The values of ConformanceCaseTier.
const (
	ConformanceCaseTierFleet  ConformanceCaseTier = "fleet"
	ConformanceCaseTierParity ConformanceCaseTier = "parity"
)

// Valid is whether e is one of ConformanceCaseTier's values.
func (e ConformanceCaseTier) Valid() bool {
	switch e {
	case ConformanceCaseTierFleet, ConformanceCaseTierParity:
		return true
	}
	return false
}

// ConformanceDriverLine A line a conformance driver writes on its standard
// output, one JSON object each (conformance/sdk/README.md, "The driver
// protocol"; conformance/worker/README.md, "The worker driver"): that it is
// ready, an operation's outcome, or what its client observed as it happened.
// The suite refuses any other line.
type ConformanceDriverLine struct {
	union[ConformanceDriverLineMember]
}

// ConformanceDriverLineMember is a member of ConformanceDriverLine:
// ConformanceDriverLineReady, ConformanceDriverLineOk,
// ConformanceDriverLineFailed, ConformanceDriverLineAbandoned,
// ConformanceDriverLineUnsupported, ConformanceDriverLineMisuse,
// ConformanceDriverLineState, ConformanceDriverLineFrame,
// ConformanceDriverLineErrorStream, ConformanceDriverLineProgress,
// ConformanceDriverLineEmission, ConformanceDriverLineCompleted,
// ConformanceDriverLineClaimed, ConformanceDriverLineRefused,
// ConformanceDriverLineSignalled, ConformanceDriverLineStalled.
type ConformanceDriverLineMember interface {
	memberOfConformanceDriverLine()
}

// Member is the member this value is: the one whose schema admits it.
func (u ConformanceDriverLine) Member() (any, error) {
	return u.member("ConformanceDriverLine", conformanceDriverLineMembers)
}

// conformanceDriverLineMembers is what each member of ConformanceDriverLine
// admits, and how a value of it is read.
var conformanceDriverLineMembers = []unionMember{
	{"ConformanceDriverLineReady", readAs[ConformanceDriverLineReady], []signature{{kind: objectKind, required: []string{"ready"}, allowed: []string{"ready"}, fixed: []fixedValues{{"ready", []any{true}}}}}},
	{"ConformanceDriverLineOk", readAs[ConformanceDriverLineOk], []signature{{kind: objectKind, required: []string{"id", "ok"}, allowed: []string{"id", "ok"}}}},
	{"ConformanceDriverLineFailed", readAs[ConformanceDriverLineFailed], []signature{{kind: objectKind, required: []string{"id", "error"}, allowed: []string{"id", "error"}}}},
	{"ConformanceDriverLineAbandoned", readAs[ConformanceDriverLineAbandoned], []signature{{kind: objectKind, required: []string{"id", "abandoned"}, allowed: []string{"id", "abandoned"}, fixed: []fixedValues{{"abandoned", []any{true}}}}}},
	{"ConformanceDriverLineUnsupported", readAs[ConformanceDriverLineUnsupported], []signature{{kind: objectKind, required: []string{"id", "unsupported"}, allowed: []string{"id", "unsupported"}, fixed: []fixedValues{{"unsupported", []any{true}}}}}},
	{"ConformanceDriverLineMisuse", readAs[ConformanceDriverLineMisuse], []signature{{kind: objectKind, required: []string{"id", "misuse"}, allowed: []string{"id", "misuse"}}}},
	{"ConformanceDriverLineState", readAs[ConformanceDriverLineState], []signature{{kind: objectKind, required: []string{"state"}, allowed: []string{"state"}}}},
	{"ConformanceDriverLineFrame", readAs[ConformanceDriverLineFrame], []signature{{kind: objectKind, required: []string{"frame"}, allowed: []string{"frame"}}}},
	{"ConformanceDriverLineErrorStream", readAs[ConformanceDriverLineErrorStream], []signature{{kind: objectKind, required: []string{"error"}, allowed: []string{"error"}}}},
	{"ConformanceDriverLineProgress", readAs[ConformanceDriverLineProgress], []signature{{kind: objectKind, required: []string{"progress"}, allowed: []string{"progress"}}}},
	{"ConformanceDriverLineEmission", readAs[ConformanceDriverLineEmission], []signature{{kind: objectKind, required: []string{"emission"}, allowed: []string{"emission"}}}},
	{"ConformanceDriverLineCompleted", readAs[ConformanceDriverLineCompleted], []signature{{kind: objectKind, required: []string{"completed"}, allowed: []string{"completed"}}}},
	{"ConformanceDriverLineClaimed", readAs[ConformanceDriverLineClaimed], []signature{{kind: objectKind, required: []string{"claimed"}, allowed: []string{"claimed"}}}},
	{"ConformanceDriverLineRefused", readAs[ConformanceDriverLineRefused], []signature{{kind: objectKind, required: []string{"refused"}, allowed: []string{"refused"}}}},
	{"ConformanceDriverLineSignalled", readAs[ConformanceDriverLineSignalled], []signature{{kind: objectKind, required: []string{"signalled"}, allowed: []string{"signalled"}}}},
	{"ConformanceDriverLineStalled", readAs[ConformanceDriverLineStalled], []signature{{kind: objectKind, required: []string{"stalled"}, allowed: []string{"stalled"}}}},
}

// ConformanceDriverLineAbandoned The suite abandoned the operation, and the
// SDK reported nothing else.
type ConformanceDriverLineAbandoned struct {
	// Id The operation's id.
	Id int `json:"id"`
	// Abandoned It was abandoned.
	Abandoned ConformanceDriverLineAbandonedAbandoned `json:"abandoned"`
}

func (ConformanceDriverLineAbandoned) memberOfConformanceDriverLine() {}

// ConformanceDriverLineAbandonedAbandoned It was abandoned.
type ConformanceDriverLineAbandonedAbandoned bool

// The values of ConformanceDriverLineAbandonedAbandoned.
const (
	ConformanceDriverLineAbandonedAbandonedTrue ConformanceDriverLineAbandonedAbandoned = true
)

// Valid is whether e is one of ConformanceDriverLineAbandonedAbandoned's
// values.
func (e ConformanceDriverLineAbandonedAbandoned) Valid() bool {
	switch e {
	case ConformanceDriverLineAbandonedAbandonedTrue:
		return true
	}
	return false
}

// ConformanceDriverLineClaimed A worker driver: its worker claimed a job.
type ConformanceDriverLineClaimed struct {
	// Claimed The job, as the worker read the record.
	Claimed map[string]any `json:"claimed"`
}

func (ConformanceDriverLineClaimed) memberOfConformanceDriverLine() {}

// ConformanceDriverLineCompleted The live driver: the observer's live query
// completed.
type ConformanceDriverLineCompleted struct {
	// Completed The observer.
	Completed string `json:"completed"`
}

func (ConformanceDriverLineCompleted) memberOfConformanceDriverLine() {}

// ConformanceDriverLineEmission The live driver: an observer was given a
// state.
type ConformanceDriverLineEmission struct {
	// Emission The emission.
	Emission ConformanceDriverLineEmissionEmission `json:"emission"`
}

func (ConformanceDriverLineEmission) memberOfConformanceDriverLine() {}

// ConformanceDriverLineEmissionEmission The emission.
type ConformanceDriverLineEmissionEmission struct {
	// Observer The observer.
	Observer string `json:"observer"`
	// State The state.
	State ConformanceDriverLineEmissionEmissionState `json:"state"`
}

// ConformanceDriverLineEmissionEmissionState The state.
type ConformanceDriverLineEmissionEmissionState struct {
	union[ConformanceDriverLineEmissionEmissionStateMember]
}

// ConformanceDriverLineEmissionEmissionStateMember is a member of
// ConformanceDriverLineEmissionEmissionState:
// ConformanceDriverLineEmissionEmissionStatePending,
// ConformanceDriverLineEmissionEmissionStateReady,
// ConformanceDriverLineEmissionEmissionStateFailed.
type ConformanceDriverLineEmissionEmissionStateMember interface {
	memberOfConformanceDriverLineEmissionEmissionState()
}

// Member is the member this value is: the one whose schema admits it.
func (u ConformanceDriverLineEmissionEmissionState) Member() (any, error) {
	return u.member("ConformanceDriverLineEmissionEmissionState", conformanceDriverLineEmissionEmissionStateMembers)
}

// conformanceDriverLineEmissionEmissionStateMembers is what each member of
// ConformanceDriverLineEmissionEmissionState admits, and how a value of it is
// read.
var conformanceDriverLineEmissionEmissionStateMembers = []unionMember{
	{"ConformanceDriverLineEmissionEmissionStatePending", readAs[ConformanceDriverLineEmissionEmissionStatePending], []signature{{kind: objectKind, required: []string{"status"}, allowed: []string{"status"}, fixed: []fixedValues{{"status", []any{"pending"}}}}}},
	{"ConformanceDriverLineEmissionEmissionStateReady", readAs[ConformanceDriverLineEmissionEmissionStateReady], []signature{{kind: objectKind, required: []string{"status", "value"}, allowed: []string{"status", "value"}, fixed: []fixedValues{{"status", []any{"ready"}}}}}},
	{"ConformanceDriverLineEmissionEmissionStateFailed", readAs[ConformanceDriverLineEmissionEmissionStateFailed], []signature{{kind: objectKind, required: []string{"status", "error"}, allowed: []string{"status", "error"}, fixed: []fixedValues{{"status", []any{"failed"}}}}}},
}

type ConformanceDriverLineEmissionEmissionStateFailed struct {
	// Status The query failed.
	Status ConformanceDriverLineEmissionEmissionStateFailedStatus `json:"status"`
	// Error The failure.
	Error ConformanceFailure `json:"error"`
}

func (ConformanceDriverLineEmissionEmissionStateFailed) memberOfConformanceDriverLineEmissionEmissionState() {
}

// ConformanceDriverLineEmissionEmissionStateFailedStatus The query failed.
type ConformanceDriverLineEmissionEmissionStateFailedStatus string

// The values of ConformanceDriverLineEmissionEmissionStateFailedStatus.
const (
	ConformanceDriverLineEmissionEmissionStateFailedStatusFailed ConformanceDriverLineEmissionEmissionStateFailedStatus = "failed"
)

// Valid is whether e is one of
// ConformanceDriverLineEmissionEmissionStateFailedStatus's values.
func (e ConformanceDriverLineEmissionEmissionStateFailedStatus) Valid() bool {
	switch e {
	case ConformanceDriverLineEmissionEmissionStateFailedStatusFailed:
		return true
	}
	return false
}

type ConformanceDriverLineEmissionEmissionStatePending struct {
	// Status Nothing to show yet.
	Status ConformanceDriverLineEmissionEmissionStatePendingStatus `json:"status"`
}

func (ConformanceDriverLineEmissionEmissionStatePending) memberOfConformanceDriverLineEmissionEmissionState() {
}

// ConformanceDriverLineEmissionEmissionStatePendingStatus Nothing to show
// yet.
type ConformanceDriverLineEmissionEmissionStatePendingStatus string

// The values of ConformanceDriverLineEmissionEmissionStatePendingStatus.
const (
	ConformanceDriverLineEmissionEmissionStatePendingStatusPending ConformanceDriverLineEmissionEmissionStatePendingStatus = "pending"
)

// Valid is whether e is one of
// ConformanceDriverLineEmissionEmissionStatePendingStatus's values.
func (e ConformanceDriverLineEmissionEmissionStatePendingStatus) Valid() bool {
	switch e {
	case ConformanceDriverLineEmissionEmissionStatePendingStatusPending:
		return true
	}
	return false
}

type ConformanceDriverLineEmissionEmissionStateReady struct {
	// Status A value to show.
	Status ConformanceDriverLineEmissionEmissionStateReadyStatus `json:"status"`
	Value  any                                                   `json:"value"`
}

func (ConformanceDriverLineEmissionEmissionStateReady) memberOfConformanceDriverLineEmissionEmissionState() {
}

// ConformanceDriverLineEmissionEmissionStateReadyStatus A value to show.
type ConformanceDriverLineEmissionEmissionStateReadyStatus string

// The values of ConformanceDriverLineEmissionEmissionStateReadyStatus.
const (
	ConformanceDriverLineEmissionEmissionStateReadyStatusReady ConformanceDriverLineEmissionEmissionStateReadyStatus = "ready"
)

// Valid is whether e is one of
// ConformanceDriverLineEmissionEmissionStateReadyStatus's values.
func (e ConformanceDriverLineEmissionEmissionStateReadyStatus) Valid() bool {
	switch e {
	case ConformanceDriverLineEmissionEmissionStateReadyStatusReady:
		return true
	}
	return false
}

// ConformanceDriverLineErrorStream The error stream carried a failure.
type ConformanceDriverLineErrorStream struct {
	// Error The failure.
	Error ConformanceFailure `json:"error"`
}

func (ConformanceDriverLineErrorStream) memberOfConformanceDriverLine() {}

// ConformanceDriverLineFailed The SDK failed the operation.
type ConformanceDriverLineFailed struct {
	// Id The operation's id.
	Id int `json:"id"`
	// Error The failure.
	Error ConformanceFailure `json:"error"`
}

func (ConformanceDriverLineFailed) memberOfConformanceDriverLine() {}

// ConformanceDriverLineFrame A frame was delivered on a channel the driver
// listens to.
type ConformanceDriverLineFrame struct {
	// Frame The frame.
	Frame ConformanceDriverLineFrameFrame `json:"frame"`
}

func (ConformanceDriverLineFrame) memberOfConformanceDriverLine() {}

// ConformanceDriverLineFrameFrame The frame.
type ConformanceDriverLineFrameFrame struct {
	// Channel The channel.
	Channel string `json:"channel"`
	Payload any    `json:"payload,omitempty"`
	// CorrelationId The frame's correlation id, when it has one.
	CorrelationId *string `json:"correlationId,omitempty"`
	// Scope The frame's scope, when it has one.
	Scope *ResourceId `json:"scope,omitempty"`
}

// ConformanceDriverLineMisuse The suite's arguments made no sense: the
// suite's mistake, never the SDK's.
type ConformanceDriverLineMisuse struct {
	// Id The operation's id.
	Id int `json:"id"`
	// Misuse What made no sense.
	Misuse string `json:"misuse"`
}

func (ConformanceDriverLineMisuse) memberOfConformanceDriverLine() {}

// ConformanceDriverLineOk The operation succeeded.
type ConformanceDriverLineOk struct {
	// Id The operation's id.
	Id int `json:"id"`
	Ok any `json:"ok"`
}

func (ConformanceDriverLineOk) memberOfConformanceDriverLine() {}

// ConformanceDriverLineProgress An upload reported how much of it has been
// sent.
type ConformanceDriverLineProgress struct {
	// Progress The report.
	Progress ConformanceDriverLineProgressProgress `json:"progress"`
}

func (ConformanceDriverLineProgress) memberOfConformanceDriverLine() {}

// ConformanceDriverLineProgressProgress The report.
type ConformanceDriverLineProgressProgress struct {
	// Upload The `upload` operation's id.
	Upload int `json:"upload"`
	// BytesUploaded How many bytes it has sent.
	BytesUploaded int `json:"bytesUploaded"`
	// TotalBytes How many it will send.
	TotalBytes int `json:"totalBytes"`
}

// ConformanceDriverLineReady The driver can take operations.
type ConformanceDriverLineReady struct {
	// Ready Written once.
	Ready ConformanceDriverLineReadyReady `json:"ready"`
}

func (ConformanceDriverLineReady) memberOfConformanceDriverLine() {}

// ConformanceDriverLineReadyReady Written once.
type ConformanceDriverLineReadyReady bool

// The values of ConformanceDriverLineReadyReady.
const (
	ConformanceDriverLineReadyReadyTrue ConformanceDriverLineReadyReady = true
)

// Valid is whether e is one of ConformanceDriverLineReadyReady's values.
func (e ConformanceDriverLineReadyReady) Valid() bool {
	switch e {
	case ConformanceDriverLineReadyReadyTrue:
		return true
	}
	return false
}

// ConformanceDriverLineRefused A worker driver: a claim was refused.
type ConformanceDriverLineRefused struct {
	// Refused The refusal: with a code when the bus refused it, with none when
	// the worker did.
	Refused ConformanceFailure `json:"refused"`
}

func (ConformanceDriverLineRefused) memberOfConformanceDriverLine() {}

// ConformanceDriverLineSignalled A worker driver: a held job's cancellation
// was signalled.
type ConformanceDriverLineSignalled struct {
	// Signalled The job's id.
	Signalled string `json:"signalled"`
}

func (ConformanceDriverLineSignalled) memberOfConformanceDriverLine() {}

// ConformanceDriverLineStalled A worker driver: a held job stalled.
type ConformanceDriverLineStalled struct {
	// Stalled The job's id.
	Stalled string `json:"stalled"`
}

func (ConformanceDriverLineStalled) memberOfConformanceDriverLine() {}

// ConformanceDriverLineState The transport's connection state changed.
type ConformanceDriverLineState struct {
	// State The state it is in now: one a case's `state` step names
	// (ConformanceStep.json), or another the case never waits for.
	State string `json:"state"`
}

func (ConformanceDriverLineState) memberOfConformanceDriverLine() {}

// ConformanceDriverLineUnsupported The driver has no such operation. It says
// so at once, before it reads its next operation.
type ConformanceDriverLineUnsupported struct {
	// Id The operation's id.
	Id int `json:"id"`
	// Unsupported It has none.
	Unsupported ConformanceDriverLineUnsupportedUnsupported `json:"unsupported"`
}

func (ConformanceDriverLineUnsupported) memberOfConformanceDriverLine() {}

// ConformanceDriverLineUnsupportedUnsupported It has none.
type ConformanceDriverLineUnsupportedUnsupported bool

// The values of ConformanceDriverLineUnsupportedUnsupported.
const (
	ConformanceDriverLineUnsupportedUnsupportedTrue ConformanceDriverLineUnsupportedUnsupported = true
)

// Valid is whether e is one of ConformanceDriverLineUnsupportedUnsupported's
// values.
func (e ConformanceDriverLineUnsupportedUnsupported) Valid() bool {
	switch e {
	case ConformanceDriverLineUnsupportedUnsupportedTrue:
		return true
	}
	return false
}

// ConformanceFailure A failure as an SDK reports it to the suite
// (conformance/sdk/README.md, "The driver protocol"): its code, the status
// when a server stated one, and a job failure's class when it has one; and
// the SDK's own words for it.
type ConformanceFailure struct {
	// Code The SDK's code for it, from specs/src/errors/codes.json.
	Code *string `json:"code,omitempty"`
	// Status The HTTP status, when a server stated one.
	Status *int `json:"status,omitempty"`
	// FailureClass A job failure's class, when it has one.
	FailureClass *FailureClass `json:"failureClass,omitempty"`
	// Detail The SDK's words, for a person; nothing compares it.
	Detail string `json:"detail"`
}

// ConformanceHttpFetch A read over HTTP a live case expects the client to
// make: an operation of the gateway's API by its method and path, with the
// values its path carries. The stand-in Archivist answers it from what the
// case seeded.
type ConformanceHttpFetch struct {
	// Fetch The operation, by its method and path.
	Fetch  string `json:"fetch"`
	Params any    `json:"params,omitempty"`
}

func (ConformanceHttpFetch) memberOfConformanceStepFetchesFetchesItem() {}
func (ConformanceHttpFetch) memberOfConformanceStep()                   {}

// ConformanceImplementations The implementations manifest: the file a run of
// the conformance harness is given with --implementations, naming what the
// run holds to Protocol. Every service is run by the xynolog launcher, from
// the image the knowledge base's stack documents name
// (contract/LAUNCHER-CONTROL.md, service.run): an implementation is a
// knowledge base whose documents name its images, and another implementation
// is another manifest. Each SDK's drivers are programs the harness starts
// itself, since none is a service. There is no default manifest. The reader
// reads this schema in the table dialect and derives its model
// (Tables.Conformance_implementations), for the harness to decode a manifest
// by.
type ConformanceImplementations struct {
	// Launcher How the launcher's control API is served: the xynolog command,
	// run with control. A command and its arguments, as the harness starts it.
	// An argument that starts with ./ or ../ is a path, resolved against the
	// manifest's own directory; every other is passed as written.
	Launcher []string `json:"launcher"`
	// Target The knowledge base whose stack documents name each service's image,
	// and whose stack runs the record and index the suites need. A relative root
	// is resolved against the manifest's own directory.
	Target LocalTarget `json:"target"`
	// Sdks Each SDK's drivers, by the SDK's name: the programs the SDK and
	// worker suites talk to in its place (conformance/sdk/README.md, "The driver
	// protocol").
	Sdks map[string]ConformanceImplementationsSdksValue `json:"sdks"`
	// ModelCatalogue The model catalogue the implementation supplies, by its
	// path; a relative one is resolved against the manifest's own directory. The
	// Librarian's and the worker service's documents name one, so a run of
	// either suite without it refuses to start.
	ModelCatalogue *string `json:"modelCatalogue,omitempty"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ConformanceImplementations) MarshalJSON() ([]byte, error) {
	type written ConformanceImplementations
	v.Launcher = listOf(v.Launcher)
	return json.Marshal(written(v))
}

// ConformanceImplementationsSdksValue One SDK's drivers.
type ConformanceImplementationsSdksValue struct {
	// Wire How its wire driver is started. A command and its arguments, as the
	// harness starts it. An argument that starts with ./ or ../ is a path,
	// resolved against the manifest's own directory; every other is passed as
	// written.
	Wire *[]string `json:"wire,omitempty"`
	// Live How its live driver is started, and the tier of the live corpus the
	// SDK is held to.
	Live *ConformanceImplementationsSdksValueLive `json:"live,omitempty"`
	// Worker How its worker driver is started, when the SDK has a worker's
	// surface (conformance/worker/README.md). A command and its arguments, as
	// the harness starts it. An argument that starts with ./ or ../ is a path,
	// resolved against the manifest's own directory; every other is passed as
	// written.
	Worker *[]string `json:"worker,omitempty"`
	// Exempt The wire cases its driver cannot be put through, by the case's
	// name, each with why. The suite holds an exemption as it holds a case: the
	// driver must answer unsupported to what the case asks, or the exemption is
	// stale.
	Exempt *map[string]string `json:"exempt,omitempty"`
}

// ConformanceImplementationsSdksValueLive How its live driver is started, and
// the tier of the live corpus the SDK is held to.
type ConformanceImplementationsSdksValueLive struct {
	// Command How its live driver is started. A command and its arguments, as
	// the harness starts it. An argument that starts with ./ or ../ is a path,
	// resolved against the manifest's own directory; every other is passed as
	// written.
	Command []string `json:"command"`
	// Tier A live case's tier: `fleet`, what every SDK with a live layer does,
	// or `parity`, what one that implements all of CACHE-SEMANTICS does.
	Tier ConformanceImplementationsSdksValueLiveTier `json:"tier"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ConformanceImplementationsSdksValueLive) MarshalJSON() ([]byte, error) {
	type written ConformanceImplementationsSdksValueLive
	v.Command = listOf(v.Command)
	return json.Marshal(written(v))
}

// ConformanceImplementationsSdksValueLiveTier A live case's tier: `fleet`,
// what every SDK with a live layer does, or `parity`, what one that
// implements all of CACHE-SEMANTICS does.
type ConformanceImplementationsSdksValueLiveTier string

// The values of ConformanceImplementationsSdksValueLiveTier.
const (
	ConformanceImplementationsSdksValueLiveTierFleet  ConformanceImplementationsSdksValueLiveTier = "fleet"
	ConformanceImplementationsSdksValueLiveTierParity ConformanceImplementationsSdksValueLiveTier = "parity"
)

// Valid is whether e is one of ConformanceImplementationsSdksValueLiveTier's
// values.
func (e ConformanceImplementationsSdksValueLiveTier) Valid() bool {
	switch e {
	case ConformanceImplementationsSdksValueLiveTierFleet, ConformanceImplementationsSdksValueLiveTierParity:
		return true
	}
	return false
}

// ConformanceStep One step of a case of the conformance corpus
// (ConformanceCase.json): each is told apart by the member only it requires.
// conformance/sdk/README.md, "A case", says what each does.
type ConformanceStep struct {
	union[ConformanceStepMember]
}

// ConformanceStepMember is a member of ConformanceStep: ConformanceStepLet,
// ConformanceStepDriver, ConformanceStepAbandon, ConformanceStepSettles,
// ConformanceStepWire, ConformanceStepCarried, ConformanceStepClosed,
// ConformanceStepProgress, ConformanceStepState, ConformanceStepStays,
// ConformanceStepFrame, ConformanceStepFrames, ConformanceStepError,
// ConformanceStepBackend, ConformanceStepQuiet, ConformanceStepObserve,
// ConformanceStepLeave, ConformanceStepReaches, ConformanceStepHolds,
// ConformanceStepCompletes, ConformanceBusFetch, ConformanceHttpFetch,
// ConformanceStepFetches, ConformanceStepScopes, ConformanceStepClaimed,
// ConformanceStepRefused, ConformanceStepSignalled, ConformanceStepStalled.
type ConformanceStepMember interface {
	memberOfConformanceStep()
}

// Member is the member this value is: the one whose schema admits it.
func (u ConformanceStep) Member() (any, error) {
	return u.member("ConformanceStep", conformanceStepMembers)
}

// conformanceStepMembers is what each member of ConformanceStep admits, and
// how a value of it is read.
var conformanceStepMembers = []unionMember{
	{"ConformanceStepLet", readAs[ConformanceStepLet], []signature{{kind: objectKind, required: []string{"let"}, allowed: []string{"let"}}}},
	{"ConformanceStepDriver", readAs[ConformanceStepDriver], []signature{{kind: objectKind, required: []string{"driver"}, allowed: []string{"driver", "with", "returns", "fails", "as"}}}},
	{"ConformanceStepAbandon", readAs[ConformanceStepAbandon], []signature{{kind: objectKind, required: []string{"abandon"}, allowed: []string{"abandon"}}}},
	{"ConformanceStepSettles", readAs[ConformanceStepSettles], []signature{{kind: objectKind, required: []string{"settles"}, allowed: []string{"settles", "returns", "fails", "abandoned"}, fixed: []fixedValues{{"abandoned", []any{true}}}}}},
	{"ConformanceStepWire", readAs[ConformanceStepWire], []signature{{kind: objectKind, required: []string{"wire"}, allowed: []string{"wire", "at", "status", "params", "body", "token", "headers", "answer", "as", "follows", "waited"}, fixed: []fixedValues{{"at", []any{"arrival", "answer", "live"}}}}}},
	{"ConformanceStepCarried", readAs[ConformanceStepCarried], []signature{{kind: objectKind, required: []string{"carried", "is"}, allowed: []string{"carried", "is"}}}},
	{"ConformanceStepClosed", readAs[ConformanceStepClosed], []signature{{kind: objectKind, required: []string{"closed"}, allowed: []string{"closed"}}}},
	{"ConformanceStepProgress", readAs[ConformanceStepProgress], []signature{{kind: objectKind, required: []string{"progress"}, allowed: []string{"progress"}}}},
	{"ConformanceStepState", readAs[ConformanceStepState], []signature{{kind: objectKind, required: []string{"state"}, allowed: []string{"state"}, fixed: []fixedValues{{"state", []any{"initial", "connecting", "open", "reconnecting", "degraded", "unauthenticated", "closed"}}}}}},
	{"ConformanceStepStays", readAs[ConformanceStepStays], []signature{{kind: objectKind, required: []string{"stays"}, allowed: []string{"stays"}, fixed: []fixedValues{{"stays", []any{"initial", "connecting", "open", "reconnecting", "degraded", "unauthenticated", "closed"}}}}}},
	{"ConformanceStepFrame", readAs[ConformanceStepFrame], []signature{{kind: objectKind, required: []string{"frame", "is"}, allowed: []string{"frame", "is"}}}},
	{"ConformanceStepFrames", readAs[ConformanceStepFrames], []signature{{kind: objectKind, required: []string{"frames", "count"}, allowed: []string{"frames", "count"}}}},
	{"ConformanceStepError", readAs[ConformanceStepError], []signature{{kind: objectKind, required: []string{"error"}, allowed: []string{"error"}}}},
	{"ConformanceStepBackend", readAs[ConformanceStepBackend], []signature{{kind: objectKind, required: []string{"backend"}, allowed: []string{"backend", "with"}, fixed: []fixedValues{{"backend", []any{"listen", "emit", "record", "content", "description", "annotations", "anchored-text", "uploaded", "refuse", "unanswered", "answer-lost", "hold", "release", "rechunk", "carry", "cut", "down", "up", "archivist"}}}}}},
	{"ConformanceStepQuiet", readAs[ConformanceStepQuiet], []signature{{kind: objectKind, required: []string{"quiet"}, allowed: []string{"quiet"}}}},
	{"ConformanceStepObserve", readAs[ConformanceStepObserve], []signature{{kind: objectKind, required: []string{"observe", "as"}, allowed: []string{"observe", "as"}}}},
	{"ConformanceStepLeave", readAs[ConformanceStepLeave], []signature{{kind: objectKind, required: []string{"leave"}, allowed: []string{"leave"}}}},
	{"ConformanceStepReaches", readAs[ConformanceStepReaches], []signature{{kind: objectKind, required: []string{"reaches", "state"}, allowed: []string{"reaches", "state"}}}},
	{"ConformanceStepHolds", readAs[ConformanceStepHolds], []signature{{kind: objectKind, required: []string{"holds", "state"}, allowed: []string{"holds", "state"}}}},
	{"ConformanceStepCompletes", readAs[ConformanceStepCompletes], []signature{{kind: objectKind, required: []string{"completes"}, allowed: []string{"completes"}}}},
	{"ConformanceBusFetch", readAs[ConformanceBusFetch], []signature{{kind: objectKind, required: []string{"fetch", "as"}, allowed: []string{"fetch", "payload", "as"}}}},
	{"ConformanceHttpFetch", readAs[ConformanceHttpFetch], []signature{{kind: objectKind, required: []string{"fetch"}, allowed: []string{"fetch", "params"}}}},
	{"ConformanceStepFetches", readAs[ConformanceStepFetches], []signature{{kind: objectKind, required: []string{"fetches"}, allowed: []string{"fetches"}}}},
	{"ConformanceStepScopes", readAs[ConformanceStepScopes], []signature{{kind: objectKind, required: []string{"scopes"}, allowed: []string{"scopes"}}}},
	{"ConformanceStepClaimed", readAs[ConformanceStepClaimed], []signature{{kind: objectKind, required: []string{"claimed"}, allowed: []string{"claimed"}}}},
	{"ConformanceStepRefused", readAs[ConformanceStepRefused], []signature{{kind: objectKind, required: []string{"refused"}, allowed: []string{"refused"}}}},
	{"ConformanceStepSignalled", readAs[ConformanceStepSignalled], []signature{{kind: objectKind, required: []string{"signalled"}, allowed: []string{"signalled"}}}},
	{"ConformanceStepStalled", readAs[ConformanceStepStalled], []signature{{kind: objectKind, required: []string{"stalled"}, allowed: []string{"stalled"}}}},
}

// ConformanceStepAbandon Abandon an operation started with `as`, as its
// caller would.
type ConformanceStepAbandon struct {
	// Abandon The operation.
	Abandon string `json:"abandon"`
}

func (ConformanceStepAbandon) memberOfConformanceStep() {}

// ConformanceStepBackend The backend does something
// (conformance/sdk/README.md, "Backend directives").
type ConformanceStepBackend struct {
	// Backend The directive.
	Backend ConformanceStepBackendBackend `json:"backend"`
	// With The directive's arguments.
	With *map[string]any `json:"with,omitempty"`
}

func (ConformanceStepBackend) memberOfConformanceStep() {}

// ConformanceStepBackendBackend The directive.
type ConformanceStepBackendBackend string

// The values of ConformanceStepBackendBackend.
const (
	ConformanceStepBackendBackendListen       ConformanceStepBackendBackend = "listen"
	ConformanceStepBackendBackendEmit         ConformanceStepBackendBackend = "emit"
	ConformanceStepBackendBackendRecord       ConformanceStepBackendBackend = "record"
	ConformanceStepBackendBackendContent      ConformanceStepBackendBackend = "content"
	ConformanceStepBackendBackendDescription  ConformanceStepBackendBackend = "description"
	ConformanceStepBackendBackendAnnotations  ConformanceStepBackendBackend = "annotations"
	ConformanceStepBackendBackendAnchoredText ConformanceStepBackendBackend = "anchored-text"
	ConformanceStepBackendBackendUploaded     ConformanceStepBackendBackend = "uploaded"
	ConformanceStepBackendBackendRefuse       ConformanceStepBackendBackend = "refuse"
	ConformanceStepBackendBackendUnanswered   ConformanceStepBackendBackend = "unanswered"
	ConformanceStepBackendBackendAnswerLost   ConformanceStepBackendBackend = "answer-lost"
	ConformanceStepBackendBackendHold         ConformanceStepBackendBackend = "hold"
	ConformanceStepBackendBackendRelease      ConformanceStepBackendBackend = "release"
	ConformanceStepBackendBackendRechunk      ConformanceStepBackendBackend = "rechunk"
	ConformanceStepBackendBackendCarry        ConformanceStepBackendBackend = "carry"
	ConformanceStepBackendBackendCut          ConformanceStepBackendBackend = "cut"
	ConformanceStepBackendBackendDown         ConformanceStepBackendBackend = "down"
	ConformanceStepBackendBackendUp           ConformanceStepBackendBackend = "up"
	ConformanceStepBackendBackendArchivist    ConformanceStepBackendBackend = "archivist"
)

// Valid is whether e is one of ConformanceStepBackendBackend's values.
func (e ConformanceStepBackendBackend) Valid() bool {
	switch e {
	case ConformanceStepBackendBackendListen, ConformanceStepBackendBackendEmit, ConformanceStepBackendBackendRecord, ConformanceStepBackendBackendContent, ConformanceStepBackendBackendDescription, ConformanceStepBackendBackendAnnotations, ConformanceStepBackendBackendAnchoredText, ConformanceStepBackendBackendUploaded, ConformanceStepBackendBackendRefuse, ConformanceStepBackendBackendUnanswered, ConformanceStepBackendBackendAnswerLost, ConformanceStepBackendBackendHold, ConformanceStepBackendBackendRelease, ConformanceStepBackendBackendRechunk, ConformanceStepBackendBackendCarry, ConformanceStepBackendBackendCut, ConformanceStepBackendBackendDown, ConformanceStepBackendBackendUp, ConformanceStepBackendBackendArchivist:
		return true
	}
	return false
}

// ConformanceStepCarried The stream a wire step named has carried this frame
// to the client.
type ConformanceStepCarried struct {
	// Carried The stream.
	Carried string `json:"carried"`
	Is      any    `json:"is"`
}

func (ConformanceStepCarried) memberOfConformanceStep() {}

// ConformanceStepClaimed A worker case: the next job the worker reports as
// claimed, as it read the record.
type ConformanceStepClaimed struct {
	Claimed any `json:"claimed"`
}

func (ConformanceStepClaimed) memberOfConformanceStep() {}

// ConformanceStepClosed The request a `wire` step named has ended with no
// answer reaching the client: the client closed it, or the proxy kept the
// gateway's answer from it (`answer-lost`).
type ConformanceStepClosed struct {
	// Closed The request.
	Closed string `json:"closed"`
}

func (ConformanceStepClosed) memberOfConformanceStep() {}

// ConformanceStepCompletes Live: the observer's live query completes.
type ConformanceStepCompletes struct {
	// Completes The observer.
	Completes string `json:"completes"`
}

func (ConformanceStepCompletes) memberOfConformanceStep() {}

// ConformanceStepDriver Ask the driver for an operation. It must succeed,
// with `returns` when given, or fail with `fails`. With `as`, the step does
// not wait: a later `settles` step does.
type ConformanceStepDriver struct {
	// Driver The operation (conformance/sdk/README.md, "Operations").
	Driver string `json:"driver"`
	// With The operation's arguments.
	With    *map[string]any `json:"with,omitempty"`
	Returns any             `json:"returns,omitempty"`
	Fails   any             `json:"fails,omitempty"`
	// As The operation's name, for the `settles` or `abandon` step that ends it.
	As *string `json:"as,omitempty"`
}

func (ConformanceStepDriver) memberOfConformanceStep() {}

// ConformanceStepError The next failure on the client's error stream is this
// one.
type ConformanceStepError struct {
	Error any `json:"error"`
}

func (ConformanceStepError) memberOfConformanceStep() {}

// ConformanceStepFetches Live: the next requests the client makes of a
// service are these, in whatever order it makes them.
type ConformanceStepFetches struct {
	// Fetches The requests.
	Fetches []ConformanceStepFetchesFetchesItem `json:"fetches"`
}

func (ConformanceStepFetches) memberOfConformanceStep() {}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ConformanceStepFetches) MarshalJSON() ([]byte, error) {
	type written ConformanceStepFetches
	v.Fetches = listOf(v.Fetches)
	return json.Marshal(written(v))
}

type ConformanceStepFetchesFetchesItem struct {
	union[ConformanceStepFetchesFetchesItemMember]
}

// ConformanceStepFetchesFetchesItemMember is a member of
// ConformanceStepFetchesFetchesItem: ConformanceBusFetch,
// ConformanceHttpFetch.
type ConformanceStepFetchesFetchesItemMember interface {
	memberOfConformanceStepFetchesFetchesItem()
}

// Member is the member this value is: the one whose schema admits it.
func (u ConformanceStepFetchesFetchesItem) Member() (any, error) {
	return u.member("ConformanceStepFetchesFetchesItem", conformanceStepFetchesFetchesItemMembers)
}

// conformanceStepFetchesFetchesItemMembers is what each member of
// ConformanceStepFetchesFetchesItem admits, and how a value of it is read.
var conformanceStepFetchesFetchesItemMembers = []unionMember{
	{"ConformanceBusFetch", readAs[ConformanceBusFetch], []signature{{kind: objectKind, required: []string{"fetch", "as"}, allowed: []string{"fetch", "payload", "as"}}}},
	{"ConformanceHttpFetch", readAs[ConformanceHttpFetch], []signature{{kind: objectKind, required: []string{"fetch"}, allowed: []string{"fetch", "params"}}}},
}

// ConformanceStepFrame The next frame the client delivers on this channel is
// this one.
type ConformanceStepFrame struct {
	// Frame The channel.
	Frame string `json:"frame"`
	Is    any    `json:"is"`
}

func (ConformanceStepFrame) memberOfConformanceStep() {}

// ConformanceStepFrames The client delivers this many more frames on this
// channel. What they are is held, as every frame is, to what the gateway
// sent.
type ConformanceStepFrames struct {
	// Frames The channel.
	Frames string `json:"frames"`
	// Count How many more.
	Count int `json:"count"`
}

func (ConformanceStepFrames) memberOfConformanceStep() {}

// ConformanceStepHolds Live: the state the observer holds now is this one.
type ConformanceStepHolds struct {
	// Holds The observer.
	Holds string `json:"holds"`
	State any    `json:"state"`
}

func (ConformanceStepHolds) memberOfConformanceStep() {}

// ConformanceStepLeave Live: the observer stops observing.
type ConformanceStepLeave struct {
	// Leave The observer.
	Leave string `json:"leave"`
}

func (ConformanceStepLeave) memberOfConformanceStep() {}

// ConformanceStepLet Name values for later steps.
type ConformanceStepLet struct {
	// Let Each name, and the value it takes.
	Let map[string]any `json:"let"`
}

func (ConformanceStepLet) memberOfConformanceStep() {}

// ConformanceStepObserve Live: an observer, named by `as`, begins observing a
// live query.
type ConformanceStepObserve struct {
	// Observe The live query.
	Observe ConformanceStepObserveObserve `json:"observe"`
	// As The observer.
	As string `json:"as"`
}

func (ConformanceStepObserve) memberOfConformanceStep() {}

// ConformanceStepObserveObserve The live query.
type ConformanceStepObserveObserve struct {
	// Query The live query, by its name in specs/src/client/refresh.json.
	Query      string `json:"query"`
	Resource   any    `json:"resource,omitempty"`
	Annotation any    `json:"annotation,omitempty"`
	Search     any    `json:"search,omitempty"`
	Filters    any    `json:"filters,omitempty"`
}

// ConformanceStepProgress An upload started with `as`, and not yet settled,
// has reported all of it sent: every report states the same total, none
// states less than the one before, and the last states the total.
type ConformanceStepProgress struct {
	// Progress The upload.
	Progress string `json:"progress"`
}

func (ConformanceStepProgress) memberOfConformanceStep() {}

// ConformanceStepQuiet The client puts nothing more on the wire for this many
// milliseconds.
type ConformanceStepQuiet struct {
	// Quiet How long, in milliseconds.
	Quiet int `json:"quiet"`
}

func (ConformanceStepQuiet) memberOfConformanceStep() {}

// ConformanceStepReaches Live: the observer comes to hold this state.
type ConformanceStepReaches struct {
	// Reaches The observer.
	Reaches string `json:"reaches"`
	State   any    `json:"state"`
}

func (ConformanceStepReaches) memberOfConformanceStep() {}

// ConformanceStepRefused A worker case: the next refusal of a claim the
// worker reports.
type ConformanceStepRefused struct {
	Refused any `json:"refused"`
}

func (ConformanceStepRefused) memberOfConformanceStep() {}

// ConformanceStepScopes Live: the client's stream comes to name exactly these
// scopes.
type ConformanceStepScopes struct {
	// Scopes The scopes.
	Scopes []any `json:"scopes"`
}

func (ConformanceStepScopes) memberOfConformanceStep() {}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ConformanceStepScopes) MarshalJSON() ([]byte, error) {
	type written ConformanceStepScopes
	v.Scopes = listOf(v.Scopes)
	return json.Marshal(written(v))
}

// ConformanceStepSettles An operation started with `as` settles: it
// succeeded, with `returns` when given; or failed with `fails`; or,
// `abandoned`, it ended because the case abandoned it and reported nothing.
type ConformanceStepSettles struct {
	// Settles The operation.
	Settles string `json:"settles"`
	Returns any    `json:"returns,omitempty"`
	Fails   any    `json:"fails,omitempty"`
	// Abandoned It ended because the case abandoned it.
	Abandoned *ConformanceStepSettlesAbandoned `json:"abandoned,omitempty"`
}

func (ConformanceStepSettles) memberOfConformanceStep() {}

// ConformanceStepSettlesAbandoned It ended because the case abandoned it.
type ConformanceStepSettlesAbandoned bool

// The values of ConformanceStepSettlesAbandoned.
const (
	ConformanceStepSettlesAbandonedTrue ConformanceStepSettlesAbandoned = true
)

// Valid is whether e is one of ConformanceStepSettlesAbandoned's values.
func (e ConformanceStepSettlesAbandoned) Valid() bool {
	switch e {
	case ConformanceStepSettlesAbandonedTrue:
		return true
	}
	return false
}

// ConformanceStepSignalled A worker case: the next held job whose
// cancellation the worker says was signalled.
type ConformanceStepSignalled struct {
	Signalled any `json:"signalled"`
}

func (ConformanceStepSignalled) memberOfConformanceStep() {}

// ConformanceStepStalled A worker case: the next held job the worker says has
// stalled.
type ConformanceStepStalled struct {
	Stalled any `json:"stalled"`
}

func (ConformanceStepStalled) memberOfConformanceStep() {}

// ConformanceStepState The transport comes to report this state.
type ConformanceStepState struct {
	// State The state.
	State ConformanceStepStateState `json:"state"`
}

func (ConformanceStepState) memberOfConformanceStep() {}

// ConformanceStepStateState The state.
type ConformanceStepStateState string

// The values of ConformanceStepStateState.
const (
	ConformanceStepStateStateInitial         ConformanceStepStateState = "initial"
	ConformanceStepStateStateConnecting      ConformanceStepStateState = "connecting"
	ConformanceStepStateStateOpen            ConformanceStepStateState = "open"
	ConformanceStepStateStateReconnecting    ConformanceStepStateState = "reconnecting"
	ConformanceStepStateStateDegraded        ConformanceStepStateState = "degraded"
	ConformanceStepStateStateUnauthenticated ConformanceStepStateState = "unauthenticated"
	ConformanceStepStateStateClosed          ConformanceStepStateState = "closed"
)

// Valid is whether e is one of ConformanceStepStateState's values.
func (e ConformanceStepStateState) Valid() bool {
	switch e {
	case ConformanceStepStateStateInitial, ConformanceStepStateStateConnecting, ConformanceStepStateStateOpen, ConformanceStepStateStateReconnecting, ConformanceStepStateStateDegraded, ConformanceStepStateStateUnauthenticated, ConformanceStepStateStateClosed:
		return true
	}
	return false
}

// ConformanceStepStays The transport is in this state and has reported no
// other since the case last read its state.
type ConformanceStepStays struct {
	// Stays The state.
	Stays ConformanceStepStaysStays `json:"stays"`
}

func (ConformanceStepStays) memberOfConformanceStep() {}

// ConformanceStepStaysStays The state.
type ConformanceStepStaysStays string

// The values of ConformanceStepStaysStays.
const (
	ConformanceStepStaysStaysInitial         ConformanceStepStaysStays = "initial"
	ConformanceStepStaysStaysConnecting      ConformanceStepStaysStays = "connecting"
	ConformanceStepStaysStaysOpen            ConformanceStepStaysStays = "open"
	ConformanceStepStaysStaysReconnecting    ConformanceStepStaysStays = "reconnecting"
	ConformanceStepStaysStaysDegraded        ConformanceStepStaysStays = "degraded"
	ConformanceStepStaysStaysUnauthenticated ConformanceStepStaysStays = "unauthenticated"
	ConformanceStepStaysStaysClosed          ConformanceStepStaysStays = "closed"
)

// Valid is whether e is one of ConformanceStepStaysStays's values.
func (e ConformanceStepStaysStays) Valid() bool {
	switch e {
	case ConformanceStepStaysStaysInitial, ConformanceStepStaysStaysConnecting, ConformanceStepStaysStaysOpen, ConformanceStepStaysStaysReconnecting, ConformanceStepStaysStaysDegraded, ConformanceStepStaysStaysUnauthenticated, ConformanceStepStaysStaysClosed:
		return true
	}
	return false
}

// ConformanceStepWire The next request the client put on the wire is this
// operation, with each field given.
type ConformanceStepWire struct {
	// Wire The operation of the gateway's API, by its method and path.
	Wire string `json:"wire"`
	// At When it is read: on arrival, once answered (the default), or once its
	// stream has caught up.
	At *ConformanceStepWireAt `json:"at,omitempty"`
	// Status The status it was answered with.
	Status *int `json:"status,omitempty"`
	Params any  `json:"params,omitempty"`
	Body   any  `json:"body,omitempty"`
	Token  any  `json:"token,omitempty"`
	// Headers The request's headers named here, each as a pattern; headers not
	// named are not compared.
	Headers *map[string]any `json:"headers,omitempty"`
	Answer  any             `json:"answer,omitempty"`
	// As The request's name, for a later step.
	As *string `json:"as,omitempty"`
	// Follows A request named earlier, which was answered before this one
	// arrived.
	Follows *string `json:"follows,omitempty"`
	// Waited A request named earlier, answered with a Retry-After, which this
	// one waited out.
	Waited *string `json:"waited,omitempty"`
}

func (ConformanceStepWire) memberOfConformanceStep() {}

// ConformanceStepWireAt When it is read: on arrival, once answered (the
// default), or once its stream has caught up.
type ConformanceStepWireAt string

// The values of ConformanceStepWireAt.
const (
	ConformanceStepWireAtArrival ConformanceStepWireAt = "arrival"
	ConformanceStepWireAtAnswer  ConformanceStepWireAt = "answer"
	ConformanceStepWireAtLive    ConformanceStepWireAt = "live"
)

// Valid is whether e is one of ConformanceStepWireAt's values.
func (e ConformanceStepWireAt) Valid() bool {
	switch e {
	case ConformanceStepWireAtArrival, ConformanceStepWireAtAnswer, ConformanceStepWireAtLive:
		return true
	}
	return false
}

// ConnectionIdentity Who the knowledge base at an address says it is, asked
// with a token just issued, before any entry is made for it.
type ConnectionIdentity struct {
	// Did The did it reports for itself.
	Did UserId `json:"did"`
	// Description What it says of itself.
	Description KbDescription `json:"description"`
}

// ContentFormat Content format as a MIME type, optionally with parameters.
// The base type (everything before the first ';') MUST be a
// SupportedMediaType; parameters such as charset are preserved as metadata.
// Semantic validation happens in code at the create/yield boundary — there is
// deliberately no pattern here, the vocabulary lives in SupportedMediaType.
// Examples: text/plain, text/plain; charset=iso-8859-1, text/markdown;
// charset=windows-1252, image/png, application/pdf
type (
	ContentFormat = string
)

type ContextualSummaryResponse struct {
	Summary string `json:"summary"`
	// RelevantFields What the summary is of: the resource the annotation is on,
	// and the annotation's entity types.
	RelevantFields ContextualSummaryResponseRelevantFields `json:"relevantFields"`
	Context        ContextualSummaryResponseContext        `json:"context"`
}

type ContextualSummaryResponseContext struct {
	Before   *string `json:"before,omitempty"`
	Selected string  `json:"selected"`
	After    *string `json:"after,omitempty"`
}

// ContextualSummaryResponseRelevantFields What the summary is of: the
// resource the annotation is on, and the annotation's entity types.
type ContextualSummaryResponseRelevantFields struct {
	ResourceId   ResourceId `json:"resourceId"`
	ResourceName string     `json:"resourceName"`
	EntityTypes  []string   `json:"entityTypes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ContextualSummaryResponseRelevantFields) MarshalJSON() ([]byte, error) {
	type written ContextualSummaryResponseRelevantFields
	v.EntityTypes = listOf(v.EntityTypes)
	return json.Marshal(written(v))
}

// ControlCli control/cli.json: every option of the launcher commands the
// control API covers, and what it is in the API.
type ControlCli struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Commands Each command, by its name.
	Commands map[string]ControlCliCommandsValue `json:"commands"`
}

// ControlCliCommandsValue A command.
type ControlCliCommandsValue struct {
	// Parser The Go function in cli/internal/launcher whose switch reads the
	// command's options.
	Parser string `json:"parser"`
	// Method The method's name.
	Method string `json:"method"`
	// Positionals The command's operands, which no switch reads by name.
	Positionals *[]ControlCliCommandsValuePositionalsItem `json:"positionals,omitempty"`
	// Flags Each option, by its flag.
	Flags map[string]ControlCliCommandsValueFlagsValue `json:"flags"`
}

type ControlCliCommandsValueFlagsValue struct {
	union[ControlCliCommandsValueFlagsValueMember]
}

// ControlCliCommandsValueFlagsValueMember is a member of
// ControlCliCommandsValueFlagsValue: ControlCliCommandsValueFlagsValueFields,
// ControlCliCommandsValueFlagsValueMethod,
// ControlCliCommandsValueFlagsValueCliOnly.
type ControlCliCommandsValueFlagsValueMember interface {
	memberOfControlCliCommandsValueFlagsValue()
}

// Member is the member this value is: the one whose schema admits it.
func (u ControlCliCommandsValueFlagsValue) Member() (any, error) {
	return u.member("ControlCliCommandsValueFlagsValue", controlCliCommandsValueFlagsValueMembers)
}

// controlCliCommandsValueFlagsValueMembers is what each member of
// ControlCliCommandsValueFlagsValue admits, and how a value of it is read.
var controlCliCommandsValueFlagsValueMembers = []unionMember{
	{"ControlCliCommandsValueFlagsValueFields", readAs[ControlCliCommandsValueFlagsValueFields], []signature{{kind: objectKind, required: []string{"fields"}, allowed: []string{"fields", "notes"}}}},
	{"ControlCliCommandsValueFlagsValueMethod", readAs[ControlCliCommandsValueFlagsValueMethod], []signature{{kind: objectKind, required: []string{"method"}, allowed: []string{"method"}}}},
	{"ControlCliCommandsValueFlagsValueCliOnly", readAs[ControlCliCommandsValueFlagsValueCliOnly], []signature{{kind: objectKind, required: []string{"cliOnly"}, allowed: []string{"cliOnly"}}}},
}

// ControlCliCommandsValueFlagsValueCliOnly An option the API has no place
// for.
type ControlCliCommandsValueFlagsValueCliOnly struct {
	// CliOnly Why it has no place in the API.
	CliOnly string `json:"cliOnly"`
}

func (ControlCliCommandsValueFlagsValueCliOnly) memberOfControlCliCommandsValueFlagsValue() {}

// ControlCliCommandsValueFlagsValueFields An option that becomes params
// fields.
type ControlCliCommandsValueFlagsValueFields struct {
	// Fields The params fields it becomes, each `<method>.<field path>`.
	Fields []string `json:"fields"`
	// Notes What else a reader of the row must know.
	Notes *string `json:"notes,omitempty"`
}

func (ControlCliCommandsValueFlagsValueFields) memberOfControlCliCommandsValueFlagsValue() {}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ControlCliCommandsValueFlagsValueFields) MarshalJSON() ([]byte, error) {
	type written ControlCliCommandsValueFlagsValueFields
	v.Fields = listOf(v.Fields)
	return json.Marshal(written(v))
}

// ControlCliCommandsValueFlagsValueMethod An option that selects a method.
type ControlCliCommandsValueFlagsValueMethod struct {
	// Method The method's name.
	Method string `json:"method"`
}

func (ControlCliCommandsValueFlagsValueMethod) memberOfControlCliCommandsValueFlagsValue() {}

type ControlCliCommandsValuePositionalsItem struct {
	union[ControlCliCommandsValuePositionalsItemMember]
}

// ControlCliCommandsValuePositionalsItemMember is a member of
// ControlCliCommandsValuePositionalsItem:
// ControlCliCommandsValuePositionalsItemFields,
// ControlCliCommandsValuePositionalsItemCliOnly.
type ControlCliCommandsValuePositionalsItemMember interface {
	memberOfControlCliCommandsValuePositionalsItem()
}

// Member is the member this value is: the one whose schema admits it.
func (u ControlCliCommandsValuePositionalsItem) Member() (any, error) {
	return u.member("ControlCliCommandsValuePositionalsItem", controlCliCommandsValuePositionalsItemMembers)
}

// controlCliCommandsValuePositionalsItemMembers is what each member of
// ControlCliCommandsValuePositionalsItem admits, and how a value of it is
// read.
var controlCliCommandsValuePositionalsItemMembers = []unionMember{
	{"ControlCliCommandsValuePositionalsItemFields", readAs[ControlCliCommandsValuePositionalsItemFields], []signature{{kind: objectKind, required: []string{"name", "fields"}, allowed: []string{"name", "fields"}}}},
	{"ControlCliCommandsValuePositionalsItemCliOnly", readAs[ControlCliCommandsValuePositionalsItemCliOnly], []signature{{kind: objectKind, required: []string{"name", "cliOnly"}, allowed: []string{"name", "cliOnly"}}}},
}

// ControlCliCommandsValuePositionalsItemCliOnly An operand the API has no
// place for.
type ControlCliCommandsValuePositionalsItemCliOnly struct {
	// Name The operand, as its usage writes it.
	Name string `json:"name"`
	// CliOnly Why it has no place in the API.
	CliOnly string `json:"cliOnly"`
}

func (ControlCliCommandsValuePositionalsItemCliOnly) memberOfControlCliCommandsValuePositionalsItem() {
}

// ControlCliCommandsValuePositionalsItemFields An operand that becomes params
// fields.
type ControlCliCommandsValuePositionalsItemFields struct {
	// Name The operand, as its usage writes it.
	Name string `json:"name"`
	// Fields The params fields it becomes, each `<method>.<field path>`.
	Fields []string `json:"fields"`
}

func (ControlCliCommandsValuePositionalsItemFields) memberOfControlCliCommandsValuePositionalsItem() {
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ControlCliCommandsValuePositionalsItemFields) MarshalJSON() ([]byte, error) {
	type written ControlCliCommandsValuePositionalsItemFields
	v.Fields = listOf(v.Fields)
	return json.Marshal(written(v))
}

// ControlMethods control/methods.json: the control API's methods and
// notifications, and the schemas each names.
type ControlMethods struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// ApiVersion A schema of control/, by its $id.
	ApiVersion string `json:"apiVersion"`
	// ErrorData A schema of control/, by its $id.
	ErrorData     string                            `json:"errorData"`
	Methods       []ControlMethodsMethodsItem       `json:"methods"`
	Notifications []ControlMethodsNotificationsItem `json:"notifications"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ControlMethods) MarshalJSON() ([]byte, error) {
	type written ControlMethods
	v.Methods = listOf(v.Methods)
	v.Notifications = listOf(v.Notifications)
	return json.Marshal(written(v))
}

type ControlMethodsMethodsItem struct {
	// Name The method's name.
	Name string `json:"name"`
	// Params A schema of control/, by its $id.
	Params string `json:"params"`
	// Result A schema of control/, by its $id.
	Result string `json:"result"`
	// Exclusive Whether a request waits for every other exclusive request to
	// end, and holds the others off until it does.
	Exclusive bool `json:"exclusive"`
	// Sends The notifications a request may send besides notifications/progress.
	Sends []string `json:"sends"`
	// Docs What the method does.
	Docs string `json:"docs"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ControlMethodsMethodsItem) MarshalJSON() ([]byte, error) {
	type written ControlMethodsMethodsItem
	v.Sends = listOf(v.Sends)
	return json.Marshal(written(v))
}

type ControlMethodsNotificationsItem struct {
	// Name A notification's name.
	Name string `json:"name"`
	// From Which side sends it.
	From ControlMethodsNotificationsItemFrom `json:"from"`
	// Params A schema of control/, by its $id.
	Params string `json:"params"`
	// Docs What it says.
	Docs string `json:"docs"`
}

// ControlMethodsNotificationsItemFrom Which side sends it.
type ControlMethodsNotificationsItemFrom string

// The values of ControlMethodsNotificationsItemFrom.
const (
	ControlMethodsNotificationsItemFromClient   ControlMethodsNotificationsItemFrom = "client"
	ControlMethodsNotificationsItemFromLauncher ControlMethodsNotificationsItemFrom = "launcher"
)

// Valid is whether e is one of ControlMethodsNotificationsItemFrom's values.
func (e ControlMethodsNotificationsItemFrom) Valid() bool {
	switch e {
	case ControlMethodsNotificationsItemFromClient, ControlMethodsNotificationsItemFromLauncher:
		return true
	}
	return false
}

type CreateAnnotationRequest struct {
	Motivation Motivation       `json:"motivation"`
	Target     AnnotationTarget `json:"target"`
	// Body Optional body. Omit for annotations whose motivation alone is
	// meaningful (highlighting) or whose user-supplied content is empty. Shape
	// matches Annotation.body.
	Body *AnnotationBodies `json:"body,omitempty"`
}

// CreateFromTokenOptions What creating a resource from a clone token is told:
// the token, the clone's name and text, and whether the source is archived
// once the clone exists.
type CreateFromTokenOptions struct {
	Token string `json:"token"`
	Name  string `json:"name"`
	// Content The clone's text, uploaded as its content.
	Content         string `json:"content"`
	ArchiveOriginal *bool  `json:"archiveOriginal,omitempty"`
}

// CreateResourceResponse The id of the resource an upload created. The
// Archivist answers it (200) once it has stored the bytes and recorded the
// resource, and the gateway forwards it (202), so the id is the one the
// record minted and its creation event is persisted. What remains
// asynchronous is downstream projection: graph, views and vectors settle
// afterwards.
type CreateResourceResponse struct {
	// ResourceId The id of the newly created resource, as the record minted it.
	ResourceId ResourceId `json:"resourceId"`
}

// CursorsPath The file a follower of the record keeps its cursors in: for
// each log of the record it follows, the sequence number of the last event of
// it taken (contract/TRANSPORT-CONTRACT.md § What repairs a passing frame). A
// file of the service's own disk, never of the knowledge base: a service that
// finds none starts each log as it starts one with no cursor, so losing it
// costs time and never correctness.
type (
	CursorsPath = string
)

// DeviceCode What a device-authorization grant (RFC 8628) shows the person
// signing in: the code they enter, and where.
type DeviceCode struct {
	// UserCode The code the person enters at the issuer.
	UserCode string `json:"userCode"`
	// VerificationUri Where the person enters it.
	VerificationUri string `json:"verificationUri"`
	// VerificationUriComplete Where the person goes to sign in with the code
	// already entered, when the issuer gives one.
	VerificationUriComplete *string `json:"verificationUriComplete,omitempty"`
	// ExpiresIn How many seconds the code stays good for.
	ExpiresIn int `json:"expiresIn"`
}

type DirEntry struct {
	Type DirEntryType `json:"type"`
	// Name Entry name (basename)
	Name string `json:"name"`
	// Path Path relative to project root
	Path string `json:"path"`
	// Mtime Last modified time (ISO 8601)
	Mtime string `json:"mtime"`
}

func (DirEntry) memberOfDirectoryEntry() {}
func (DirEntry) told() (string, string)  { return "type", "dir" }

type DirEntryType string

// The values of DirEntryType.
const (
	DirEntryTypeDir DirEntryType = "dir"
)

// Valid is whether e is one of DirEntryType's values.
func (e DirEntryType) Valid() bool {
	switch e {
	case DirEntryTypeDir:
		return true
	}
	return false
}

// DirectoryEntry One entry in a directory listing: a file, which may carry
// the resource it was ingested as, or a subdirectory. Tell them apart by
// `type`, which is required on both and single-valued.
type DirectoryEntry struct {
	union[DirectoryEntryMember]
}

// DirectoryEntryMember is a member of DirectoryEntry: FileEntry, DirEntry.
type DirectoryEntryMember interface {
	memberOfDirectoryEntry()
}

// Discriminator is the `type` this value states.
func (u DirectoryEntry) Discriminator() (string, error) { return u.stated("type") }

// Member is the member this value is: the one whose schema admits it.
func (u DirectoryEntry) Member() (any, error) {
	return u.member("DirectoryEntry", directoryEntryMembers)
}

// directoryEntryMembers is what each member of DirectoryEntry admits, and how
// a value of it is read.
var directoryEntryMembers = []unionMember{
	{"FileEntry", readAs[FileEntry], []signature{{kind: objectKind, required: []string{"type", "name", "path", "size", "mtime", "tracked"}, allowed: []string{"type", "name", "path", "size", "mtime", "tracked", "resourceId", "entityTypes", "annotationCount", "creator"}, fixed: []fixedValues{{"type", []any{"file"}}}}}},
	{"DirEntry", readAs[DirEntry], []signature{{kind: objectKind, required: []string{"type", "name", "path", "mtime"}, allowed: []string{"type", "name", "path", "mtime"}, fixed: []fixedValues{{"type", []any{"dir"}}}}}},
}

// DiscoveredKB One knowledge base the Xynolog launcher manages on this
// machine, as published in the discovery document (see DiscoveryDocument).
// Endpoints and identity only — never credentials; login remains the
// consumer's per-KB business.
type DiscoveredKB struct {
	// Host Hostname the KB is reachable on from this machine (always "localhost"
	// — local stacks bind locally and codespace KBs arrive through a local port
	// forward)
	Host string `json:"host"`
	// Port Local TCP port of the KB's API (the gateway port for a local stack;
	// the allocated forward port for a codespace stack)
	Port int `json:"port"`
	// Placement Where the stack actually runs. "local": containers on this
	// machine. "codespace": a GitHub-hosted VM whose KB is port-forwarded here.
	Placement DiscoveredKBPlacement `json:"placement"`
	// Repo owner/name GitHub slug — present for codespace placements, where the
	// repo is the stack's identity
	Repo *string `json:"repo,omitempty"`
	// Did The KB's did:web identifier, from its committed .xynolog/config.yaml —
	// "did:web:" + its site.domain, verbatim. REQUIRED: a KB that declares no
	// domain has no identity to publish, and the launcher refuses to start it
	// rather than inventing or defaulting one. NOT unique within a document: a
	// did names the knowledge base, not a running copy of it, so a local clone
	// and a codespace of the same repo legitimately share one and both are
	// published. host:port is the unique field (at most one entry per address),
	// so consumers look up by ADDRESS and use the did to VERIFY that the copy
	// they reached is the KB they meant — an address alone cannot say which KB
	// is which, and an identity alone cannot say which copy.
	Did string `json:"did"`
	// SiteName Human-readable site name from the KB's .xynolog/config.yaml
	// (site.siteName), for display
	SiteName *string `json:"siteName,omitempty"`
	// ManagedBy The agent that owns this entry's lifecycle (the launcher writes
	// "xynolog-launcher"). Consumers treat managed entries as authoritative for
	// themselves — upsert on appearance, remove on disappearance — and never
	// touch entries they did not write.
	ManagedBy string `json:"managedBy"`
}

// DiscoveredKBPlacement Where the stack actually runs. "local": containers on
// this machine. "codespace": a GitHub-hosted VM whose KB is port-forwarded
// here.
type DiscoveredKBPlacement string

// The values of DiscoveredKBPlacement.
const (
	DiscoveredKBPlacementLocal     DiscoveredKBPlacement = "local"
	DiscoveredKBPlacementCodespace DiscoveredKBPlacement = "codespace"
)

// Valid is whether e is one of DiscoveredKBPlacement's values.
func (e DiscoveredKBPlacement) Valid() bool {
	switch e {
	case DiscoveredKBPlacementLocal, DiscoveredKBPlacementCodespace:
		return true
	}
	return false
}

// DiscoveryDocument The launcher's KB discovery document — the schema
// authority for <stateDir>/discovery/kbs.json, which the Xynolog CLI
// (xynolog/cli) regenerates on every stack mutation and the Browser container
// mounts read-only at /discovery. NOT an API endpoint: a static document
// fetched same-origin by browsers (via the Browser's static server). An empty
// kbs list is meaningful ("the launcher manages nothing right now") and
// distinct from an absent file.
type DiscoveryDocument struct {
	// Version Document schema version. Consumers MUST check it and ignore
	// documents they do not understand.
	Version DiscoveryDocumentVersion `json:"version"`
	// Kbs Every KB the launcher currently manages, local and forwarded
	Kbs []DiscoveredKB `json:"kbs"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v DiscoveryDocument) MarshalJSON() ([]byte, error) {
	type written DiscoveryDocument
	v.Kbs = listOf(v.Kbs)
	return json.Marshal(written(v))
}

// DiscoveryDocumentVersion Document schema version. Consumers MUST check it
// and ignore documents they do not understand.
type DiscoveryDocumentVersion int

// The values of DiscoveryDocumentVersion.
const (
	DiscoveryDocumentVersion1 DiscoveryDocumentVersion = 1
)

// Valid is whether e is one of DiscoveryDocumentVersion's values.
func (e DiscoveryDocumentVersion) Valid() bool {
	switch e {
	case DiscoveryDocumentVersion1:
		return true
	}
	return false
}

// DispatcherConfig Everything the dispatcher reads at boot: nothing in it is
// defaulted by the dispatcher. The launcher writes it for the dispatcher it
// starts, from the knowledge base's stack documents, and the dispatcher reads
// it from the path its `--config` flag names (its image passes
// `/etc/xynolog/dispatcher.json`). Started without `--config`, or with a path
// that names no file, the dispatcher refuses to start and says which. Secrets
// are never values here: a field that needs one names the environment
// variable holding it. The dispatcher's other inputs are the environment
// variables specs/src/service-environment/variables.json lists for it, and
// the ones this document names. A document that does not validate is refused
// at boot, naming each failing field.
type DispatcherConfig struct {
	Kb KbIdentity `json:"kb"`
	// GatewayUrl The URL the dispatcher reaches the gateway at: its only route
	// to the bus.
	GatewayUrl string `json:"gatewayUrl"`
	// Identity The issuer the dispatcher's service account signs in at.
	Identity ServiceIdentity `json:"identity"`
	// Queue The JetStream broker holding the job queue, whose layout is
	// specs/src/jobs/storage.json.
	Queue DispatcherConfigQueue `json:"queue"`
	// Port The port the dispatcher answers `/health` on.
	Port int `json:"port"`
	// Timing The queue's clocks, in milliseconds. The launcher writes the values
	// a deployment runs with; a test harness shrinks them.
	Timing    DispatcherConfigTiming `json:"timing"`
	LogLevel  LogLevel               `json:"logLevel"`
	LogFormat LogFormat              `json:"logFormat"`
}

// DispatcherConfigQueue The JetStream broker holding the job queue, whose
// layout is specs/src/jobs/storage.json.
type DispatcherConfigQueue struct {
	// Servers The broker's address (`host:port`, or several, comma-separated).
	Servers string `json:"servers"`
	// UserEnv The environment variable holding the broker user, when the broker
	// requires one.
	UserEnv *string `json:"userEnv,omitempty"`
	// PasswordEnv The environment variable holding the broker password, when the
	// broker requires one.
	PasswordEnv *string `json:"passwordEnv,omitempty"`
}

// DispatcherConfigTiming The queue's clocks, in milliseconds. The launcher
// writes the values a deployment runs with; a test harness shrinks them.
type DispatcherConfigTiming struct {
	// TickMs How often the queue re-announces pending jobs and sweeps for dead
	// workers. The re-announcement is insurance against a lost wake-up, not
	// dispatch.
	TickMs int `json:"tickMs"`
	// StaleRunningMs How long a running job may go without progress, a
	// checkpoint or a claim before its worker is presumed dead.
	StaleRunningMs int `json:"staleRunningMs"`
	// AckWaitMs How long the broker waits, after this dispatcher stops renewing
	// a job's lease, before redelivering its message.
	AckWaitMs int `json:"ackWaitMs"`
	// RetentionMs How long a concluded job is kept before it is deleted.
	RetentionMs int `json:"retentionMs"`
	// RetentionSweepMs How often concluded jobs past `retentionMs` are deleted.
	RetentionSweepMs int `json:"retentionSweepMs"`
	// ProgressWriteIntervalMs The least time between two progress writes for one
	// job; reports closer together than this are not written.
	ProgressWriteIntervalMs int `json:"progressWriteIntervalMs"`
	// BootDeadlineMs How long the dispatcher waits at boot for the broker before
	// it exits, so that a restart policy can retry.
	BootDeadlineMs int `json:"bootDeadlineMs"`
}

// DispatcherHealth The dispatcher's liveness answer. It answers only once its
// queue has connected and its bus pumps are attached, so a 200 means it can
// take work.
type DispatcherHealth struct {
	Status DispatcherHealthStatus `json:"status"`
	// Queue The queue it holds.
	Queue DispatcherHealthQueue `json:"queue"`
}

// DispatcherHealthQueue The queue it holds.
type DispatcherHealthQueue string

// The values of DispatcherHealthQueue.
const (
	DispatcherHealthQueueJetstream DispatcherHealthQueue = "jetstream"
)

// Valid is whether e is one of DispatcherHealthQueue's values.
func (e DispatcherHealthQueue) Valid() bool {
	switch e {
	case DispatcherHealthQueueJetstream:
		return true
	}
	return false
}

type DispatcherHealthStatus string

// The values of DispatcherHealthStatus.
const (
	DispatcherHealthStatusOk DispatcherHealthStatus = "ok"
)

// Valid is whether e is one of DispatcherHealthStatus's values.
func (e DispatcherHealthStatus) Valid() bool {
	switch e {
	case DispatcherHealthStatusOk:
		return true
	}
	return false
}

// DispatcherMessages dispatcher/messages.json: the words of the dispatcher's
// own refusals, and of the errors it writes into a job.
type DispatcherMessages struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Refusals Each refusal the dispatcher makes itself, on the operation's
	// failure channel.
	Refusals []DispatcherMessagesRefusalsItem `json:"refusals"`
	// Errors Each error the dispatcher writes into a job on its own, as a
	// `job:fail` would.
	Errors []DispatcherMessagesErrorsItem `json:"errors"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v DispatcherMessages) MarshalJSON() ([]byte, error) {
	type written DispatcherMessages
	v.Refusals = listOf(v.Refusals)
	v.Errors = listOf(v.Errors)
	return json.Marshal(written(v))
}

type DispatcherMessagesErrorsItem struct {
	// Name The situation's name.
	Name string `json:"name"`
	// Situation When it is written, and what fills each `{name}` of its text.
	Situation string `json:"situation"`
	// Error The `error` it writes into the job. A `{name}` in it is filled with
	// what the row's `situation` names, and nothing else in it varies.
	Error        string       `json:"error"`
	FailureClass FailureClass `json:"failureClass"`
}

type DispatcherMessagesRefusalsItem struct {
	// Name The situation's name.
	Name string `json:"name"`
	// Operation The operation it refuses: a request of bus/registry.json's
	// operations that the dispatcher answers.
	Operation string `json:"operation"`
	// Code Machine-readable failure class, for consumers that must BRANCH on why
	// a command failed rather than log it. Optional and deliberately sparse:
	// absent means 'no class declared', and every existing failure stays that
	// way. An enum rather than a free string so the vocabulary has an owner — an
	// unconstrained code is a mirror with no gate, and adding one should be a
	// deliberate spec change. `message` remains the human-readable text and is
	// unaffected. Members: `peer-unavailable` — the channel this command was
	// sent on has no subscriber, i.e. the service that answers it has not
	// connected yet. Transient by nature (a peer still starting), which is what
	// distinguishes it from a refusal: retrying is the correct response.
	// `not-found` — the resource this command addressed does not exist in this
	// knowledge base. A verdict, not a symptom: it is emitted only where the
	// answer comes from the event store, which is the system of record, and
	// never from a projection that may merely be lagging. Deterministic, so
	// unlike `peer-unavailable` retrying is pointless — and consumers may act
	// destructively on it (the SDK deletes a restored tab). Absence is not
	// denial: a future 'exists, but not for you' must travel as its own code,
	// never as this one. `unauthorized` — that code: the caller is authenticated
	// but not permitted to do what it asked. A verdict about the CALLER, not the
	// resource, so retrying under the same credential cannot succeed and a
	// consumer must never spin on it; emitted by `job:claim` for a caller whose
	// token carries no worker role. `none-pending` — a declined claim, not an
	// error: the queue holds no pending job of the requested types. Nothing went
	// wrong; the one code a consumer PARKS on, meaning 'nothing to do until a
	// wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying
	// neither is unclassified — a malformed record or a missing injection — and
	// a consumer treats it as 'log it, assume nothing'.
	Code *DispatcherMessagesRefusalsItemCode `json:"code,omitempty"`
	// Situation When it is written, and what fills each `{name}` of its text.
	Situation string `json:"situation"`
	// Message The failure's `message`. A `{name}` in it is filled with what the
	// row's `situation` names, and nothing else in it varies.
	Message string `json:"message"`
}

// DispatcherMessagesRefusalsItemCode Machine-readable failure class, for
// consumers that must BRANCH on why a command failed rather than log it.
// Optional and deliberately sparse: absent means 'no class declared', and
// every existing failure stays that way. An enum rather than a free string so
// the vocabulary has an owner — an unconstrained code is a mirror with no
// gate, and adding one should be a deliberate spec change. `message` remains
// the human-readable text and is unaffected. Members: `peer-unavailable` —
// the channel this command was sent on has no subscriber, i.e. the service
// that answers it has not connected yet. Transient by nature (a peer still
// starting), which is what distinguishes it from a refusal: retrying is the
// correct response. `not-found` — the resource this command addressed does
// not exist in this knowledge base. A verdict, not a symptom: it is emitted
// only where the answer comes from the event store, which is the system of
// record, and never from a projection that may merely be lagging.
// Deterministic, so unlike `peer-unavailable` retrying is pointless — and
// consumers may act destructively on it (the SDK deletes a restored tab).
// Absence is not denial: a future 'exists, but not for you' must travel as
// its own code, never as this one. `unauthorized` — that code: the caller is
// authenticated but not permitted to do what it asked. A verdict about the
// CALLER, not the resource, so retrying under the same credential cannot
// succeed and a consumer must never spin on it; emitted by `job:claim` for a
// caller whose token carries no worker role. `none-pending` — a declined
// claim, not an error: the queue holds no pending job of the requested types.
// Nothing went wrong; the one code a consumer PARKS on, meaning 'nothing to
// do until a wake-up'. Emitted by `job:claim` only. A `job:claim` refusal
// carrying neither is unclassified — a malformed record or a missing
// injection — and a consumer treats it as 'log it, assume nothing'.
type DispatcherMessagesRefusalsItemCode string

// The values of DispatcherMessagesRefusalsItemCode.
const (
	DispatcherMessagesRefusalsItemCodePeerUnavailable DispatcherMessagesRefusalsItemCode = "peer-unavailable"
	DispatcherMessagesRefusalsItemCodeNotFound        DispatcherMessagesRefusalsItemCode = "not-found"
	DispatcherMessagesRefusalsItemCodeUnauthorized    DispatcherMessagesRefusalsItemCode = "unauthorized"
	DispatcherMessagesRefusalsItemCodeNonePending     DispatcherMessagesRefusalsItemCode = "none-pending"
)

// Valid is whether e is one of DispatcherMessagesRefusalsItemCode's values.
func (e DispatcherMessagesRefusalsItemCode) Valid() bool {
	switch e {
	case DispatcherMessagesRefusalsItemCodePeerUnavailable, DispatcherMessagesRefusalsItemCodeNotFound, DispatcherMessagesRefusalsItemCodeUnauthorized, DispatcherMessagesRefusalsItemCodeNonePending:
		return true
	}
	return false
}

// DurabilityEvidence How a job's annotations were established as durable —
// the OBSERVATION, never a conclusion drawn from it. 'acknowledged': the
// event log confirmed the batch (mark:commit-ok). 'probe-confirmed': the
// acknowledgement was lost and a later read found the batch's last annotation
// present — true, but a weaker claim than an ack, since it rests on the log
// appending a batch in order and stopping at the first failure.
// 'probe-refused': the read returned a failure reply; note this does NOT
// assert the annotations are absent, because a read that failed for its own
// reasons answers on the same channel. 'probe-unreachable': no answer came at
// all, so nothing was established either way. ABSENT means the question never
// arose — a job that committed no annotations. Never defaulted: a
// manufactured value here is a claim nobody made, in a log nobody can
// rewrite.
type DurabilityEvidence string

// The values of DurabilityEvidence.
const (
	DurabilityEvidenceAcknowledged     DurabilityEvidence = "acknowledged"
	DurabilityEvidenceProbeConfirmed   DurabilityEvidence = "probe-confirmed"
	DurabilityEvidenceProbeRefused     DurabilityEvidence = "probe-refused"
	DurabilityEvidenceProbeUnreachable DurabilityEvidence = "probe-unreachable"
)

// Valid is whether e is one of DurabilityEvidence's values.
func (e DurabilityEvidence) Valid() bool {
	switch e {
	case DurabilityEvidenceAcknowledged, DurabilityEvidenceProbeConfirmed, DurabilityEvidenceProbeRefused, DurabilityEvidenceProbeUnreachable:
		return true
	}
	return false
}

// EmbeddingConfig The embedding provider a service asks for vectors, and what
// that kind of provider needs to be asked: one of the providers
// `xynolog-vectors` has, told apart by `type`. Two services that share an
// index name the same provider and the same model: a vector is compared only
// with vectors of the model that made it. A secret is never a value here: a
// provider's key is named by the environment variable that holds it.
type EmbeddingConfig struct {
	union[EmbeddingConfigMember]
}

// EmbeddingConfigMember is a member of EmbeddingConfig:
// OllamaEmbeddingConfig, VoyageEmbeddingConfig.
type EmbeddingConfigMember interface {
	memberOfEmbeddingConfig()
}

// Discriminator is the `type` this value states.
func (u EmbeddingConfig) Discriminator() (string, error) { return u.stated("type") }

// Member is the member this value is: the one whose schema admits it.
func (u EmbeddingConfig) Member() (any, error) {
	return u.member("EmbeddingConfig", embeddingConfigMembers)
}

// embeddingConfigMembers is what each member of EmbeddingConfig admits, and
// how a value of it is read.
var embeddingConfigMembers = []unionMember{
	{"OllamaEmbeddingConfig", readAs[OllamaEmbeddingConfig], []signature{{kind: objectKind, required: []string{"type", "model", "baseUrl"}, allowed: []string{"type", "model", "baseUrl"}, fixed: []fixedValues{{"type", []any{"ollama"}}}}}},
	{"VoyageEmbeddingConfig", readAs[VoyageEmbeddingConfig], []signature{{kind: objectKind, required: []string{"type", "model", "endpoint", "apiKeyEnv"}, allowed: []string{"type", "model", "endpoint", "apiKeyEnv"}, fixed: []fixedValues{{"type", []any{"voyage"}}}}}},
}

// EmbeddingRequests embedding/requests.json: how a service asks its embedding
// provider for the vectors of many texts.
type EmbeddingRequests struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Providers How each kind of provider is asked, by its `type`
	// (EmbeddingConfig): every kind, and no other.
	Providers map[string]EmbeddingRequestsProvidersValue `json:"providers"`
	// RequestSeconds How long each request has, counted from when it is sent and
	// not from when its batch began. Asking a busy provider again is within it.
	RequestSeconds int `json:"requestSeconds"`
	// Busy A request for the vectors of documents that the provider answers busy
	// is asked again, after each wait in turn, while the request's own time
	// allows the wait. A provider busy at every asking fails the request with
	// that status. A query is asked once.
	Busy EmbeddingRequestsBusy `json:"busy"`
	// StartAgain How many times, at most, a starting service asks again a
	// provider that answered 404, taken to be still fetching the model, or could
	// not be reached, taken to be still starting: within the time the service
	// has to start.
	StartAgain int `json:"startAgain"`
}

// EmbeddingRequestsBusy A request for the vectors of documents that the
// provider answers busy is asked again, after each wait in turn, while the
// request's own time allows the wait. A provider busy at every asking fails
// the request with that status. A query is asked once.
type EmbeddingRequestsBusy struct {
	// Statuses The statuses by which a provider says it is busy.
	Statuses []int `json:"statuses"`
	// AgainAfterSeconds The wait before each asking again, in order.
	AgainAfterSeconds []int `json:"againAfterSeconds"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v EmbeddingRequestsBusy) MarshalJSON() ([]byte, error) {
	type written EmbeddingRequestsBusy
	v.Statuses = listOf(v.Statuses)
	v.AgainAfterSeconds = listOf(v.AgainAfterSeconds)
	return json.Marshal(written(v))
}

type EmbeddingRequestsProvidersValue struct {
	// TextsPerRequest How many texts one request carries, at most: a batch is
	// cut into slices of this many, each one request, in the order of the texts.
	TextsPerRequest int `json:"textsPerRequest"`
	// AtOnce How many requests are made of the provider at once, however many
	// resources are being indexed.
	AtOnce int `json:"atOnce"`
}

// EmptyObject is an object with no properties.
type EmptyObject struct{}

func (EmptyObject) memberOfJobStoredProgress() {}
func (EmptyObject) memberOfJobStoredResult()   {}

// Engine An engine: an inference provider and a model, which software does a
// job or an actor's step with. An engine is not a principal: the principal
// that used one names it on each write it produced with it (`generator`). A
// person who does a job uses none.
type Engine struct {
	// Provider The inference provider: who serves the model. `anthropic`,
	// `google`, `openai` and `together` are those companies' own APIs.
	// `llamacpp`, `ollama` and `vllm` are servers a deployment runs or reaches,
	// each named for the server's software.
	Provider EngineProvider `json:"provider"`
	// Model The model identifier, as the provider names it.
	Model string `json:"model"`
}

// EngineEntry One of the knowledge base's engines: a provider and a model its
// Inference document names, and the jobs the document has it used for. An
// engine is not a principal: whichever worker claims a job does it, under its
// own account, and names on each write the engine it used, if any. Carries no
// inference limits: the services that hold the inference credentials report
// those (InferenceLimitsResult).
type EngineEntry struct {
	Engine Engine `json:"engine"`
	// Jobs The jobs the knowledge base's Inference document has this engine used
	// for, as a claim names them. Absent for an engine only Librarian actors
	// ask.
	Jobs *[]JobFilter `json:"jobs,omitempty"`
}

// EngineLimits The discovered limits of one engine.
type EngineLimits struct {
	Engine Engine          `json:"engine"`
	Limits InferenceLimits `json:"limits"`
}

// EngineProvider The inference provider: who serves the model. `anthropic`,
// `google`, `openai` and `together` are those companies' own APIs.
// `llamacpp`, `ollama` and `vllm` are servers a deployment runs or reaches,
// each named for the server's software.
type EngineProvider string

// The values of EngineProvider.
const (
	EngineProviderAnthropic EngineProvider = "anthropic"
	EngineProviderGoogle    EngineProvider = "google"
	EngineProviderLlamacpp  EngineProvider = "llamacpp"
	EngineProviderOllama    EngineProvider = "ollama"
	EngineProviderOpenai    EngineProvider = "openai"
	EngineProviderTogether  EngineProvider = "together"
	EngineProviderVllm      EngineProvider = "vllm"
)

// Valid is whether e is one of EngineProvider's values.
func (e EngineProvider) Valid() bool {
	switch e {
	case EngineProviderAnthropic, EngineProviderGoogle, EngineProviderLlamacpp, EngineProviderOllama, EngineProviderOpenai, EngineProviderTogether, EngineProviderVllm:
		return true
	}
	return false
}

// EnrichedResourceEvent Wire format for persisted events delivered over the
// bus SSE stream (GET /bus/subscribe). Extends StoredEventResponse with
// optional enrichment fields the EventStore populates from the materialized
// view at publish time (persistence → view → enrich → notification).
// Subscribers read the enrichment fields directly to update local caches
// without an additional fetch.
type EnrichedResourceEvent struct {
	// Id Unique event ID (UUID)
	Id string `json:"id"`
	// Type Event type (flow verb name, e.g. mark:added)
	Type string `json:"type"`
	// Timestamp When the event occurred
	Timestamp string `json:"timestamp"`
	// UserId DID of the user who triggered the event
	UserId UserId `json:"userId"`
	// ResourceId Resource this event affects (absent for system events)
	ResourceId *ResourceId `json:"resourceId,omitempty"`
	// Version Event schema version
	Version int `json:"version"`
	// Payload Event-type-specific payload
	Payload  map[string]any `json:"payload"`
	Metadata EventMetadata  `json:"metadata"`
	// Annotation Populated for events that mutate an annotation (mark:added,
	// mark:body-updated, mark:removed). Carries the post-materialization
	// annotation as it exists in the view, so subscribers can update local
	// caches in-place without refetching. Absent for events that don't touch
	// annotations.
	Annotation *Annotation `json:"annotation,omitempty"`
}

// EntityTagChangedPayload Payload for mark:entity-tag-added and
// mark:entity-tag-removed domain events
type EntityTagChangedPayload struct {
	EntityType string `json:"entityType"`
}

// EntityTypeAddedPayload Payload for frame:entity-type-added domain event
// (system-level, no resourceId — fan-out is global)
type EntityTypeAddedPayload struct {
	EntityType string `json:"entityType"`
}

// EntityTypesProjection The knowledge base's entity-type vocabulary: the file
// `projections/__system__/entitytypes.json` under the state directory, the
// sum of the `frame:entity-type-added` events. Written as JSON indented by
// two spaces.
type EntityTypesProjection struct {
	// EntityTypes Every entity type added, each once, sorted.
	EntityTypes []string `json:"entityTypes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v EntityTypesProjection) MarshalJSON() ([]byte, error) {
	type written EntityTypesProjection
	v.EntityTypes = listOf(v.EntityTypes)
	return json.Marshal(written(v))
}

// EphemeralEventId `e-<publishId>` — the id of any other frame, given once
// when the frame is published: the same on every connection that carries it,
// through every replica, so a copy arriving on two connections (a reconnect
// overlap) dedups. Never a resumption watermark.
type (
	EphemeralEventId = string
)

// ErrorData The data of a control error: the launcher's code for the failure,
// one of specs/src/errors/codes.json's control group, and what a client can
// act on. A request's failure is never only a message.
type ErrorData struct {
	// Code Why the request failed: a code of the control group of
	// specs/src/errors/codes.json.
	Code string `json:"code"`
	// Retryable Whether the same request can succeed sent again unchanged, once
	// something outside it changes: a start finishes, a runtime is installed, a
	// stack comes up.
	Retryable bool `json:"retryable"`
	// Fields For params the contract refuses: each fault, where it is.
	Fields *[]FieldFault `json:"fields,omitempty"`
	// Choices For control.target-required and control.target-ambiguous: each
	// target the request could have meant, to send again with one.
	Choices *[]Target `json:"choices,omitempty"`
	// Supported For control.unsupported-api-version: each version this launcher
	// speaks.
	Supported *[]string `json:"supported,omitempty"`
	// MayStillRun For a cancelled stack.start: whether services the start
	// launched may still be running. The launcher stops waiting, and stops
	// nothing.
	MayStillRun *bool `json:"mayStillRun,omitempty"`
}

// ErrorResponse The body of every error the gateway answers, whatever the
// status and whatever the route — including a path it does not serve.
type ErrorResponse struct {
	// Error What went wrong, in a sentence.
	Error string `json:"error"`
	// Code A machine-readable class, when the route defines one.
	Code *string `json:"code,omitempty"`
	// Hint What the caller can do about it, when there is something to say.
	Hint    *string `json:"hint,omitempty"`
	Details any     `json:"details,omitempty"`
}

// ErrorsCodes errors/codes.json: the error codes a Xynolog client reports, in
// one vocabulary for each kind of failure.
type ErrorsCodes struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// BusRequest Why a bus request did not resolve.
	BusRequest ErrorsCodesBusRequest `json:"busRequest"`
	// Transport The transport-neutral failure vocabulary.
	Transport ErrorsCodesTransport `json:"transport"`
	// Job A vocabulary that states nothing of its codes but each one's docs:
	// here, why a job its client follows ended without a result.
	Job ErrorsCodesJob `json:"job"`
	// Session A vocabulary that states nothing of its codes but each one's docs:
	// here, why a job its client follows ended without a result.
	Session ErrorsCodesSession `json:"session"`
	// SignIn A vocabulary that states nothing of its codes but each one's docs:
	// here, why a job its client follows ended without a result.
	SignIn ErrorsCodesSignIn `json:"signIn"`
	// KbIdentity A vocabulary that states nothing of its codes but each one's
	// docs: here, why a job its client follows ended without a result.
	KbIdentity ErrorsCodesKbIdentity `json:"kbIdentity"`
	// SpanRefusal A vocabulary that states nothing of its codes but each one's
	// docs: here, why a job its client follows ended without a result.
	SpanRefusal ErrorsCodesSpanRefusal `json:"spanRefusal"`
	// Control A vocabulary that states nothing of its codes but each one's docs:
	// here, why a job its client follows ended without a result.
	Control ErrorsCodesControl `json:"control"`
}

// ErrorsCodesBusRequest Why a bus request did not resolve.
type ErrorsCodesBusRequest struct {
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs string `json:"docs"`
	// UnrecognizedFailure The code, as every SDK names it.
	UnrecognizedFailure string `json:"unrecognizedFailure"`
	// Codes Each code, and the wire's `CommandError.code` it restates, where it
	// restates one.
	Codes []ErrorsCodesBusRequestCodesItem `json:"codes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ErrorsCodesBusRequest) MarshalJSON() ([]byte, error) {
	type written ErrorsCodesBusRequest
	v.Codes = listOf(v.Codes)
	return json.Marshal(written(v))
}

type ErrorsCodesBusRequestCodesItem struct {
	// Code The code, as every SDK names it.
	Code string `json:"code"`
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs string `json:"docs"`
	// Wire Machine-readable failure class, for consumers that must BRANCH on why
	// a command failed rather than log it. Optional and deliberately sparse:
	// absent means 'no class declared', and every existing failure stays that
	// way. An enum rather than a free string so the vocabulary has an owner — an
	// unconstrained code is a mirror with no gate, and adding one should be a
	// deliberate spec change. `message` remains the human-readable text and is
	// unaffected. Members: `peer-unavailable` — the channel this command was
	// sent on has no subscriber, i.e. the service that answers it has not
	// connected yet. Transient by nature (a peer still starting), which is what
	// distinguishes it from a refusal: retrying is the correct response.
	// `not-found` — the resource this command addressed does not exist in this
	// knowledge base. A verdict, not a symptom: it is emitted only where the
	// answer comes from the event store, which is the system of record, and
	// never from a projection that may merely be lagging. Deterministic, so
	// unlike `peer-unavailable` retrying is pointless — and consumers may act
	// destructively on it (the SDK deletes a restored tab). Absence is not
	// denial: a future 'exists, but not for you' must travel as its own code,
	// never as this one. `unauthorized` — that code: the caller is authenticated
	// but not permitted to do what it asked. A verdict about the CALLER, not the
	// resource, so retrying under the same credential cannot succeed and a
	// consumer must never spin on it; emitted by `job:claim` for a caller whose
	// token carries no worker role. `none-pending` — a declined claim, not an
	// error: the queue holds no pending job of the requested types. Nothing went
	// wrong; the one code a consumer PARKS on, meaning 'nothing to do until a
	// wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying
	// neither is unclassified — a malformed record or a missing injection — and
	// a consumer treats it as 'log it, assume nothing'.
	Wire *ErrorsCodesBusRequestCodesItemWire `json:"wire,omitempty"`
}

// ErrorsCodesBusRequestCodesItemWire Machine-readable failure class, for
// consumers that must BRANCH on why a command failed rather than log it.
// Optional and deliberately sparse: absent means 'no class declared', and
// every existing failure stays that way. An enum rather than a free string so
// the vocabulary has an owner — an unconstrained code is a mirror with no
// gate, and adding one should be a deliberate spec change. `message` remains
// the human-readable text and is unaffected. Members: `peer-unavailable` —
// the channel this command was sent on has no subscriber, i.e. the service
// that answers it has not connected yet. Transient by nature (a peer still
// starting), which is what distinguishes it from a refusal: retrying is the
// correct response. `not-found` — the resource this command addressed does
// not exist in this knowledge base. A verdict, not a symptom: it is emitted
// only where the answer comes from the event store, which is the system of
// record, and never from a projection that may merely be lagging.
// Deterministic, so unlike `peer-unavailable` retrying is pointless — and
// consumers may act destructively on it (the SDK deletes a restored tab).
// Absence is not denial: a future 'exists, but not for you' must travel as
// its own code, never as this one. `unauthorized` — that code: the caller is
// authenticated but not permitted to do what it asked. A verdict about the
// CALLER, not the resource, so retrying under the same credential cannot
// succeed and a consumer must never spin on it; emitted by `job:claim` for a
// caller whose token carries no worker role. `none-pending` — a declined
// claim, not an error: the queue holds no pending job of the requested types.
// Nothing went wrong; the one code a consumer PARKS on, meaning 'nothing to
// do until a wake-up'. Emitted by `job:claim` only. A `job:claim` refusal
// carrying neither is unclassified — a malformed record or a missing
// injection — and a consumer treats it as 'log it, assume nothing'.
type ErrorsCodesBusRequestCodesItemWire string

// The values of ErrorsCodesBusRequestCodesItemWire.
const (
	ErrorsCodesBusRequestCodesItemWirePeerUnavailable ErrorsCodesBusRequestCodesItemWire = "peer-unavailable"
	ErrorsCodesBusRequestCodesItemWireNotFound        ErrorsCodesBusRequestCodesItemWire = "not-found"
	ErrorsCodesBusRequestCodesItemWireUnauthorized    ErrorsCodesBusRequestCodesItemWire = "unauthorized"
	ErrorsCodesBusRequestCodesItemWireNonePending     ErrorsCodesBusRequestCodesItemWire = "none-pending"
)

// Valid is whether e is one of ErrorsCodesBusRequestCodesItemWire's values.
func (e ErrorsCodesBusRequestCodesItemWire) Valid() bool {
	switch e {
	case ErrorsCodesBusRequestCodesItemWirePeerUnavailable, ErrorsCodesBusRequestCodesItemWireNotFound, ErrorsCodesBusRequestCodesItemWireUnauthorized, ErrorsCodesBusRequestCodesItemWireNonePending:
		return true
	}
	return false
}

// ErrorsCodesControl A vocabulary that states nothing of its codes but each
// one's docs: here, why a job its client follows ended without a result.
type ErrorsCodesControl struct {
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs  string                        `json:"docs"`
	Codes []ErrorsCodesControlCodesItem `json:"codes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ErrorsCodesControl) MarshalJSON() ([]byte, error) {
	type written ErrorsCodesControl
	v.Codes = listOf(v.Codes)
	return json.Marshal(written(v))
}

type ErrorsCodesControlCodesItem struct {
	// Code The code, as every SDK names it.
	Code string `json:"code"`
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs string `json:"docs"`
}

// ErrorsCodesJob A vocabulary that states nothing of its codes but each one's
// docs: here, why a job its client follows ended without a result.
type ErrorsCodesJob struct {
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs  string                    `json:"docs"`
	Codes []ErrorsCodesJobCodesItem `json:"codes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ErrorsCodesJob) MarshalJSON() ([]byte, error) {
	type written ErrorsCodesJob
	v.Codes = listOf(v.Codes)
	return json.Marshal(written(v))
}

type ErrorsCodesJobCodesItem struct {
	// Code The code, as every SDK names it.
	Code string `json:"code"`
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs string `json:"docs"`
}

// ErrorsCodesKbIdentity A vocabulary that states nothing of its codes but
// each one's docs: here, why a job its client follows ended without a result.
type ErrorsCodesKbIdentity struct {
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs  string                           `json:"docs"`
	Codes []ErrorsCodesKbIdentityCodesItem `json:"codes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ErrorsCodesKbIdentity) MarshalJSON() ([]byte, error) {
	type written ErrorsCodesKbIdentity
	v.Codes = listOf(v.Codes)
	return json.Marshal(written(v))
}

type ErrorsCodesKbIdentityCodesItem struct {
	// Code The code, as every SDK names it.
	Code string `json:"code"`
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs string `json:"docs"`
}

// ErrorsCodesSession A vocabulary that states nothing of its codes but each
// one's docs: here, why a job its client follows ended without a result.
type ErrorsCodesSession struct {
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs  string                        `json:"docs"`
	Codes []ErrorsCodesSessionCodesItem `json:"codes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ErrorsCodesSession) MarshalJSON() ([]byte, error) {
	type written ErrorsCodesSession
	v.Codes = listOf(v.Codes)
	return json.Marshal(written(v))
}

type ErrorsCodesSessionCodesItem struct {
	// Code The code, as every SDK names it.
	Code string `json:"code"`
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs string `json:"docs"`
}

// ErrorsCodesSignIn A vocabulary that states nothing of its codes but each
// one's docs: here, why a job its client follows ended without a result.
type ErrorsCodesSignIn struct {
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs  string                       `json:"docs"`
	Codes []ErrorsCodesSignInCodesItem `json:"codes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ErrorsCodesSignIn) MarshalJSON() ([]byte, error) {
	type written ErrorsCodesSignIn
	v.Codes = listOf(v.Codes)
	return json.Marshal(written(v))
}

type ErrorsCodesSignInCodesItem struct {
	// Code The code, as every SDK names it.
	Code string `json:"code"`
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs string `json:"docs"`
}

// ErrorsCodesSpanRefusal A vocabulary that states nothing of its codes but
// each one's docs: here, why a job its client follows ended without a result.
type ErrorsCodesSpanRefusal struct {
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs  string                            `json:"docs"`
	Codes []ErrorsCodesSpanRefusalCodesItem `json:"codes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ErrorsCodesSpanRefusal) MarshalJSON() ([]byte, error) {
	type written ErrorsCodesSpanRefusal
	v.Codes = listOf(v.Codes)
	return json.Marshal(written(v))
}

type ErrorsCodesSpanRefusalCodesItem struct {
	// Code The code, as every SDK names it.
	Code string `json:"code"`
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs string `json:"docs"`
}

// ErrorsCodesTransport The transport-neutral failure vocabulary.
type ErrorsCodesTransport struct {
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs string `json:"docs"`
	// Unclassified The code, as every SDK names it.
	Unclassified string `json:"unclassified"`
	// Codes Each code, and the HTTP statuses it is read from.
	Codes []ErrorsCodesTransportCodesItem `json:"codes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ErrorsCodesTransport) MarshalJSON() ([]byte, error) {
	type written ErrorsCodesTransport
	v.Codes = listOf(v.Codes)
	return json.Marshal(written(v))
}

type ErrorsCodesTransportCodesItem struct {
	union[ErrorsCodesTransportCodesItemMember]
}

// ErrorsCodesTransportCodesItemMember is a member of
// ErrorsCodesTransportCodesItem: ErrorsCodesTransportCodesItemStatus,
// ErrorsCodesTransportCodesItemStatusFrom,
// ErrorsCodesTransportCodesItemNoStatus.
type ErrorsCodesTransportCodesItemMember interface {
	memberOfErrorsCodesTransportCodesItem()
}

// Member is the member this value is: the one whose schema admits it.
func (u ErrorsCodesTransportCodesItem) Member() (any, error) {
	return u.member("ErrorsCodesTransportCodesItem", errorsCodesTransportCodesItemMembers)
}

// errorsCodesTransportCodesItemMembers is what each member of
// ErrorsCodesTransportCodesItem admits, and how a value of it is read.
var errorsCodesTransportCodesItemMembers = []unionMember{
	{"ErrorsCodesTransportCodesItemStatus", readAs[ErrorsCodesTransportCodesItemStatus], []signature{{kind: objectKind, required: []string{"code", "docs", "status"}, allowed: []string{"code", "docs", "status"}}}},
	{"ErrorsCodesTransportCodesItemStatusFrom", readAs[ErrorsCodesTransportCodesItemStatusFrom], []signature{{kind: objectKind, required: []string{"code", "docs", "statusFrom"}, allowed: []string{"code", "docs", "statusFrom"}}}},
	{"ErrorsCodesTransportCodesItemNoStatus", readAs[ErrorsCodesTransportCodesItemNoStatus], []signature{{kind: objectKind, required: []string{"code", "docs"}, allowed: []string{"code", "docs"}}}},
}

// ErrorsCodesTransportCodesItemNoStatus A code no HTTP status is read as.
type ErrorsCodesTransportCodesItemNoStatus struct {
	// Code The code, as every SDK names it.
	Code string `json:"code"`
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs string `json:"docs"`
}

func (ErrorsCodesTransportCodesItemNoStatus) memberOfErrorsCodesTransportCodesItem() {}

// ErrorsCodesTransportCodesItemStatus A code read from one HTTP status.
type ErrorsCodesTransportCodesItemStatus struct {
	// Code The code, as every SDK names it.
	Code string `json:"code"`
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs   string     `json:"docs"`
	Status HttpStatus `json:"status"`
}

func (ErrorsCodesTransportCodesItemStatus) memberOfErrorsCodesTransportCodesItem() {}

// ErrorsCodesTransportCodesItemStatusFrom A code read from every HTTP status
// at or above one.
type ErrorsCodesTransportCodesItemStatusFrom struct {
	// Code The code, as every SDK names it.
	Code string `json:"code"`
	// Docs Its documentation, in prose: what a generated type or member says of
	// it.
	Docs       string     `json:"docs"`
	StatusFrom HttpStatus `json:"statusFrom"`
}

func (ErrorsCodesTransportCodesItemStatusFrom) memberOfErrorsCodesTransportCodesItem() {}

// EventMetadata Metadata added at persistence time. Part of every
// StoredEvent. Integrity is provided by git at the commit level (when gitSync
// is enabled), not by in-event metadata fields.
type EventMetadata struct {
	// SequenceNumber Monotonic position in the event log (ordering authority)
	SequenceNumber int `json:"sequenceNumber"`
}

// Expected What a person believed they were signing in to: the did and the
// name of the row they clicked, or of the entry they signed in to again.
type Expected struct {
	// Did The did they believed it has.
	Did string `json:"did"`
	// Name The name they believed it has. Absent when they had none.
	Name *string `json:"name,omitempty"`
}

// ExtractedText A successful extraction: the anchored text plus its
// provenance. The 'extracted' member of ExtractionOutcome, the record the
// anchored-text store holds.
type ExtractedText struct {
	// Text Reading-order text of the whole resource.
	Text string `json:"text"`
	// Items Positioned runs indexing `text`, roughly one per word.
	Items []PdfTextItem `json:"items"`
	// Kind Discriminant — both ExtractionOutcome members carry `kind`,
	// single-valued: the category here, the detail in `method`.
	Kind ExtractedTextKind `json:"kind"`
	// Method How the text was extracted.
	Method ExtractionMethod `json:"method"`
	// PdfClass PDF classification, when the source was a PDF.
	PdfClass *PdfClass `json:"pdfClass,omitempty"`
	// OcrConfidence How well the engine read the pixels, when any of this text
	// came from OCR.
	OcrConfidence *OcrConfidence `json:"ocrConfidence,omitempty"`
	// UnreadPages 1-indexed pages this extraction could not read — present only
	// for partially covered documents (class C).
	UnreadPages *[]int `json:"unreadPages,omitempty"`
}

func (ExtractedText) memberOfAnchoredTextAnswer() {}
func (ExtractedText) memberOfExtractionOutcome()  {}
func (ExtractedText) told() (string, string)      { return "kind", "extracted" }

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ExtractedText) MarshalJSON() ([]byte, error) {
	type written ExtractedText
	v.Items = listOf(v.Items)
	return json.Marshal(written(v))
}

// ExtractedTextKind Discriminant — both ExtractionOutcome members carry
// `kind`, single-valued: the category here, the detail in `method`.
type ExtractedTextKind string

// The values of ExtractedTextKind.
const (
	ExtractedTextKindExtracted ExtractedTextKind = "extracted"
)

// Valid is whether e is one of ExtractedTextKind's values.
func (e ExtractedTextKind) Valid() bool {
	switch e {
	case ExtractedTextKindExtracted:
		return true
	}
	return false
}

// ExtractionDeclined A named decline: extraction ran and yielded nothing, by
// class. A first-class, cacheable outcome — 'we ran and there was nothing'
// costs a full recognition pass to discover.
type ExtractionDeclined struct {
	// Kind Discriminant — both ExtractionOutcome members carry `kind`,
	// single-valued: the category here, the detail in `declined`.
	Kind ExtractionDeclinedKind `json:"kind"`
	// Declined Why extraction yielded nothing, by class.
	Declined ExtractionDeclinedReason `json:"declined"`
}

func (ExtractionDeclined) memberOfAnchoredTextAnswer() {}
func (ExtractionDeclined) memberOfExtractionOutcome()  {}
func (ExtractionDeclined) told() (string, string)      { return "kind", "declined" }

// ExtractionDeclinedKind Discriminant — both ExtractionOutcome members carry
// `kind`, single-valued: the category here, the detail in `declined`.
type ExtractionDeclinedKind string

// The values of ExtractionDeclinedKind.
const (
	ExtractionDeclinedKindDeclined ExtractionDeclinedKind = "declined"
)

// Valid is whether e is one of ExtractionDeclinedKind's values.
func (e ExtractionDeclinedKind) Valid() bool {
	switch e {
	case ExtractionDeclinedKindDeclined:
		return true
	}
	return false
}

// ExtractionDeclinedReason Why extraction yielded nothing, by class.
type ExtractionDeclinedReason string

// The values of ExtractionDeclinedReason.
const (
	ExtractionDeclinedReasonNoTextLayer ExtractionDeclinedReason = "no-text-layer"
	ExtractionDeclinedReasonEncrypted   ExtractionDeclinedReason = "encrypted"
	ExtractionDeclinedReasonCorrupt     ExtractionDeclinedReason = "corrupt"
	ExtractionDeclinedReasonTooLarge    ExtractionDeclinedReason = "too-large"
)

// Valid is whether e is one of ExtractionDeclinedReason's values.
func (e ExtractionDeclinedReason) Valid() bool {
	switch e {
	case ExtractionDeclinedReasonNoTextLayer, ExtractionDeclinedReasonEncrypted, ExtractionDeclinedReasonCorrupt, ExtractionDeclinedReasonTooLarge:
		return true
	}
	return false
}

// ExtractionMethod How a text was extracted: a plain text taken as it is, a
// PDF's text layer read, a grid written as rows, a filled form's values read,
// or pixels read by OCR.
type ExtractionMethod string

// The values of ExtractionMethod.
const (
	ExtractionMethodTextPassthrough ExtractionMethod = "text-passthrough"
	ExtractionMethodPdfTextLayer    ExtractionMethod = "pdf-text-layer"
	ExtractionMethodTable           ExtractionMethod = "table"
	ExtractionMethodForm            ExtractionMethod = "form"
	ExtractionMethodOcr             ExtractionMethod = "ocr"
)

// Valid is whether e is one of ExtractionMethod's values.
func (e ExtractionMethod) Valid() bool {
	switch e {
	case ExtractionMethodTextPassthrough, ExtractionMethodPdfTextLayer, ExtractionMethodTable, ExtractionMethodForm, ExtractionMethodOcr:
		return true
	}
	return false
}

// ExtractionOutcome The full outcome of text extraction for one
// representation — the record the anchored-text store holds and the wire
// serves. Discriminated on `kind`: 'extracted' — the anchored text with its
// provenance; 'declined' — a named decline. ocrConfidence is extraction
// quality for operators, deliberately not anchor confidence.
type ExtractionOutcome struct {
	union[ExtractionOutcomeMember]
}

// ExtractionOutcomeMember is a member of ExtractionOutcome: ExtractedText,
// ExtractionDeclined.
type ExtractionOutcomeMember interface {
	memberOfExtractionOutcome()
}

// Discriminator is the `kind` this value states.
func (u ExtractionOutcome) Discriminator() (string, error) { return u.stated("kind") }

// Member is the member this value is: the one whose schema admits it.
func (u ExtractionOutcome) Member() (any, error) {
	return u.member("ExtractionOutcome", extractionOutcomeMembers)
}

// extractionOutcomeMembers is what each member of ExtractionOutcome admits,
// and how a value of it is read.
var extractionOutcomeMembers = []unionMember{
	{"ExtractedText", readAs[ExtractedText], []signature{{kind: objectKind, required: []string{"text", "items", "kind", "method"}, fixed: []fixedValues{{"kind", []any{"extracted"}}, {"method", []any{"text-passthrough", "pdf-text-layer", "table", "form", "ocr"}}, {"pdfClass", []any{"A", "B", "C", "D", "E", "F", "G"}}}}}},
	{"ExtractionDeclined", readAs[ExtractionDeclined], []signature{{kind: objectKind, required: []string{"kind", "declined"}, fixed: []fixedValues{{"kind", []any{"declined"}}, {"declined", []any{"no-text-layer", "encrypted", "corrupt", "too-large"}}}}}},
}

// FailureClass The class of a job's failure, stated by the worker, where the
// failure is still typed: at the gateway it is already text, and classing a
// failure by its text is what this exists to avoid. A job no worker
// concluded, because its worker stopped reporting, is classed by the
// dispatcher, as 'transient'. Each value is a claim. 'transient': nothing
// about the request was judged (the worker's own bound ran out, the provider
// said not now), so another attempt may succeed. 'deterministic': the same
// request cannot succeed on a second attempt. 'withheld': the model's
// provider had the request and withheld its answer, by a refusal or a content
// filter, and the same request is withheld again; nothing broke. A
// 'deterministic' or a 'withheld' failure is not retried, whatever retry
// budget is left. ABSENT means the failure was not classified, which is not
// the claim 'transient' makes; it is retried as a transient one is. Only a
// failure known to be deterministic or withheld is called so: calling a
// transient failure either one halves reliability, where the reverse costs
// one wasted attempt.
type FailureClass string

// The values of FailureClass.
const (
	FailureClassTransient     FailureClass = "transient"
	FailureClassDeterministic FailureClass = "deterministic"
	FailureClassWithheld      FailureClass = "withheld"
)

// Valid is whether e is one of FailureClass's values.
func (e FailureClass) Valid() bool {
	switch e {
	case FailureClassTransient, FailureClassDeterministic, FailureClassWithheld:
		return true
	}
	return false
}

// FieldFault One fault in a request's params, named where it is.
type FieldFault struct {
	// Field Where in the params the fault is, as a JSON pointer (RFC 6901);
	// empty for the params as a whole.
	Field string `json:"field"`
	// Message What is wrong there.
	Message string `json:"message"`
}

type FileEntry struct {
	Type FileEntryType `json:"type"`
	// Name Entry name (basename)
	Name string `json:"name"`
	// Path Path relative to project root
	Path string `json:"path"`
	// Size File size in bytes
	Size int `json:"size"`
	// Mtime Last modified time (ISO 8601)
	Mtime string `json:"mtime"`
	// Tracked True if this file is a tracked resource in the Knowledge Base
	Tracked bool `json:"tracked"`
	// ResourceId Resource ID (only when tracked is true)
	ResourceId *ResourceId `json:"resourceId,omitempty"`
	// EntityTypes Entity types assigned to this resource (only when tracked is
	// true)
	EntityTypes *[]string `json:"entityTypes,omitempty"`
	// AnnotationCount Number of annotations on this resource (only when tracked
	// is true)
	AnnotationCount *int `json:"annotationCount,omitempty"`
	// Creator DID of the resource's creator — the first of its derived
	// `wasAttributedTo`, the requester as the knowledge base recorded it (only
	// when tracked is true)
	Creator *string `json:"creator,omitempty"`
}

func (FileEntry) memberOfDirectoryEntry() {}
func (FileEntry) told() (string, string)  { return "type", "file" }

type FileEntryType string

// The values of FileEntryType.
const (
	FileEntryTypeFile FileEntryType = "file"
)

// Valid is whether e is one of FileEntryType's values.
func (e FileEntryType) Valid() bool {
	switch e {
	case FileEntryTypeFile:
		return true
	}
	return false
}

// FollowerFollowing How far a follower of the record has followed it, as
// every follower says it at its health port (WEAVER.md § Health, SMELTER.md §
// Health).
type FollowerFollowing struct {
	// Sweep The latest sweep's phase: `pending` before its stream first opens,
	// `running`, `done`, or `due` where the record could not be listed and the
	// sweep is tried again.
	Sweep FollowerFollowingSweep `json:"sweep"`
	// Stopped How many resources' logs a failed taking has stopped until the
	// next sweep.
	Stopped int `json:"stopped"`
	// Refused How many events it refused as recorded since it started.
	Refused int `json:"refused"`
	// StreamDrops How many times its stream has dropped since it started.
	StreamDrops int `json:"streamDrops"`
}

// FollowerFollowingSweep The latest sweep's phase: `pending` before its
// stream first opens, `running`, `done`, or `due` where the record could not
// be listed and the sweep is tried again.
type FollowerFollowingSweep string

// The values of FollowerFollowingSweep.
const (
	FollowerFollowingSweepPending FollowerFollowingSweep = "pending"
	FollowerFollowingSweepRunning FollowerFollowingSweep = "running"
	FollowerFollowingSweepDone    FollowerFollowingSweep = "done"
	FollowerFollowingSweepDue     FollowerFollowingSweep = "due"
)

// Valid is whether e is one of FollowerFollowingSweep's values.
func (e FollowerFollowingSweep) Valid() bool {
	switch e {
	case FollowerFollowingSweepPending, FollowerFollowingSweepRunning, FollowerFollowingSweepDone, FollowerFollowingSweepDue:
		return true
	}
	return false
}

// FragmentSelector W3C Web Annotation FragmentSelector for media fragment
// identifiers (RFC 3778 for PDFs)
type FragmentSelector struct {
	Type FragmentSelectorType `json:"type"`
	// Value Media fragment identifier (e.g., 'page=1&viewrect=100,200,50,30' for
	// PDF)
	Value string `json:"value"`
	// ConformsTo URI identifying the fragment syntax specification
	ConformsTo *string `json:"conformsTo,omitempty"`
}

func (FragmentSelector) memberOfSelector()      {}
func (FragmentSelector) told() (string, string) { return "type", "FragmentSelector" }

type FragmentSelectorType string

// The values of FragmentSelectorType.
const (
	FragmentSelectorTypeFragmentSelector FragmentSelectorType = "FragmentSelector"
)

// Valid is whether e is one of FragmentSelectorType's values.
func (e FragmentSelectorType) Valid() bool {
	switch e {
	case FragmentSelectorTypeFragmentSelector:
		return true
	}
	return false
}

// FrameAddEntityTypeCommand Bus command to add a new entity type to the KB's
// vocabulary. Carried on the `frame:add-entity-type` channel — Frame is the
// schema-layer flow that owns vocabulary writes.
type FrameAddEntityTypeCommand struct {
	Tag string `json:"tag"`
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId *UserId `json:"_userId,omitempty"`
}

// FrameAddTagSchemaCommand Bus command to register a tag schema with the KB's
// runtime registry. Carried on the `frame:add-tag-schema` channel — Frame is
// the schema-layer flow that owns vocabulary writes. Most-recent registration
// of a given `schema.id` wins; the projection reflects the latest content.
// Identical re-registrations are silent; differing content overwrites and
// logs a warning.
type FrameAddTagSchemaCommand struct {
	Schema TagSchema `json:"schema"`
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId *UserId `json:"_userId,omitempty"`
}

// FrameRefusalReason Why a reader refused a frame, for its first fault:
// `lacks`, a member it lacks; `malformed`, a member that is not of its shape.
// A reader's rule (specs/src/bus/frame-cases.json).
type FrameRefusalReason string

// The values of FrameRefusalReason.
const (
	FrameRefusalReasonLacks     FrameRefusalReason = "lacks"
	FrameRefusalReasonMalformed FrameRefusalReason = "malformed"
)

// Valid is whether e is one of FrameRefusalReason's values.
func (e FrameRefusalReason) Valid() bool {
	switch e {
	case FrameRefusalReasonLacks, FrameRefusalReasonMalformed:
		return true
	}
	return false
}

// GatewayConfig Everything the gateway reads at boot: nothing in it is
// defaulted by the gateway. The launcher writes it for the gateway it starts
// — from the knowledge base's committed identity and its stack documents —
// and a gateway started any other way is given the same document at the path
// its `--config` flag names (the image passes `/etc/xynolog/gateway.json`).
// Started without `--config`, or with a path that names no file, the gateway
// refuses to start and says which. Secrets are never values here: a field
// that needs one names the environment variable holding it. The gateway's
// other inputs are the environment variables
// specs/src/service-environment/variables.json lists for it, and the ones
// this document names. A document that does not validate is refused at boot —
// the gateway exits without serving — and the refusal names each failing
// field by its JSON pointer.
type GatewayConfig struct {
	Kb KbIdentity `json:"kb"`
	// Port The port the gateway listens on, on every address the host has: IPv4
	// and IPv6.
	Port int `json:"port"`
	// PublicUrl The URL clients reach this gateway at: the `servers` entry of
	// the OpenAPI document it serves.
	PublicUrl string `json:"publicUrl"`
	// Identity The issuer this knowledge base trusts.
	Identity GatewayConfigIdentity `json:"identity"`
	// Archivist Where the Archivist listens.
	Archivist ServiceAddress `json:"archivist"`
	// Signal The signal plane: `in-process`, one gateway on its own fabric; or
	// `nats`, the fabric every replica on one broker shares, which requires
	// `servers` and a broker with JetStream.
	Signal    GatewayConfigSignal `json:"signal"`
	LogLevel  LogLevel            `json:"logLevel"`
	LogFormat LogFormat           `json:"logFormat"`
	// Capacity What this gateway process can hold, from the memory its
	// deployment gives it. `queuedBytes`: the bytes queued for all its streams
	// together; at it, a new stream is refused with 503 (`AtCapacity`, code
	// `capacity`) until the queues drain — each stream's own bound is
	// `x-xynolog-limits.pendingWriteBytes`. `connections`: the connections it
	// holds open at once; one past it is closed unanswered. The launcher derives
	// both from the memory it gives the gateway's container.
	Capacity GatewayConfigCapacity `json:"capacity"`
}

// GatewayConfigCapacity What this gateway process can hold, from the memory
// its deployment gives it. `queuedBytes`: the bytes queued for all its
// streams together; at it, a new stream is refused with 503 (`AtCapacity`,
// code `capacity`) until the queues drain — each stream's own bound is
// `x-xynolog-limits.pendingWriteBytes`. `connections`: the connections it
// holds open at once; one past it is closed unanswered. The launcher derives
// both from the memory it gives the gateway's container.
type GatewayConfigCapacity struct {
	QueuedBytes int `json:"queuedBytes"`
	Connections int `json:"connections"`
}

// GatewayConfigIdentity The issuer this knowledge base trusts.
type GatewayConfigIdentity struct {
	// Issuer The issuer URL, exactly as tokens carry it in `iss`.
	Issuer string `json:"issuer"`
	// SubjectClaim The claim a person's DID is built from:
	// `did:web:<domain>:users:<its value>`.
	SubjectClaim string `json:"subjectClaim"`
}

// GatewayConfigSignal The signal plane: `in-process`, one gateway on its own
// fabric; or `nats`, the fabric every replica on one broker shares, which
// requires `servers` and a broker with JetStream.
type GatewayConfigSignal struct {
	Type GatewayConfigSignalType `json:"type"`
	// Servers The broker's address (`host:port`, or several, comma-separated).
	// Required for `nats`.
	Servers *string `json:"servers,omitempty"`
	// UserEnv The environment variable holding the broker user, when the broker
	// requires one.
	UserEnv *string `json:"userEnv,omitempty"`
	// PasswordEnv The environment variable holding the broker password, when the
	// broker requires one.
	PasswordEnv *string `json:"passwordEnv,omitempty"`
}

type GatewayConfigSignalType string

// The values of GatewayConfigSignalType.
const (
	GatewayConfigSignalTypeInProcess GatewayConfigSignalType = "in-process"
	GatewayConfigSignalTypeNats      GatewayConfigSignalType = "nats"
)

// Valid is whether e is one of GatewayConfigSignalType's values.
func (e GatewayConfigSignalType) Valid() bool {
	switch e {
	case GatewayConfigSignalTypeInProcess, GatewayConfigSignalTypeNats:
		return true
	}
	return false
}

// GatewayMediaToken gateway/media-token.json: what a media token is.
type GatewayMediaToken struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Header Its JOSE header, exactly.
	Header GatewayMediaTokenHeader `json:"header"`
	// Claims Its claims beside `iat` and `exp`, each filled as the table says.
	Claims GatewayMediaTokenClaims `json:"claims"`
	// LifetimeSeconds `exp` less `iat`.
	LifetimeSeconds int `json:"lifetimeSeconds"`
}

// GatewayMediaTokenClaims Its claims beside `iat` and `exp`, each filled as
// the table says.
type GatewayMediaTokenClaims struct {
	Purpose GatewayMediaTokenClaimsPurpose `json:"purpose"`
	Iss     GatewayMediaTokenClaimsIss     `json:"iss"`
	Sub     GatewayMediaTokenClaimsSub     `json:"sub"`
}

type GatewayMediaTokenClaimsIss string

// The values of GatewayMediaTokenClaimsIss.
const (
	GatewayMediaTokenClaimsIssDomain GatewayMediaTokenClaimsIss = "{domain}"
)

// Valid is whether e is one of GatewayMediaTokenClaimsIss's values.
func (e GatewayMediaTokenClaimsIss) Valid() bool {
	switch e {
	case GatewayMediaTokenClaimsIssDomain:
		return true
	}
	return false
}

type GatewayMediaTokenClaimsPurpose string

// The values of GatewayMediaTokenClaimsPurpose.
const (
	GatewayMediaTokenClaimsPurposeMedia GatewayMediaTokenClaimsPurpose = "media"
)

// Valid is whether e is one of GatewayMediaTokenClaimsPurpose's values.
func (e GatewayMediaTokenClaimsPurpose) Valid() bool {
	switch e {
	case GatewayMediaTokenClaimsPurposeMedia:
		return true
	}
	return false
}

type GatewayMediaTokenClaimsSub string

// The values of GatewayMediaTokenClaimsSub.
const (
	GatewayMediaTokenClaimsSubResourceId GatewayMediaTokenClaimsSub = "{resourceId}"
)

// Valid is whether e is one of GatewayMediaTokenClaimsSub's values.
func (e GatewayMediaTokenClaimsSub) Valid() bool {
	switch e {
	case GatewayMediaTokenClaimsSubResourceId:
		return true
	}
	return false
}

// GatewayMediaTokenHeader Its JOSE header, exactly.
type GatewayMediaTokenHeader struct {
	Alg GatewayMediaTokenHeaderAlg `json:"alg"`
	Typ GatewayMediaTokenHeaderTyp `json:"typ"`
}

type GatewayMediaTokenHeaderAlg string

// The values of GatewayMediaTokenHeaderAlg.
const (
	GatewayMediaTokenHeaderAlgHS256 GatewayMediaTokenHeaderAlg = "HS256"
)

// Valid is whether e is one of GatewayMediaTokenHeaderAlg's values.
func (e GatewayMediaTokenHeaderAlg) Valid() bool {
	switch e {
	case GatewayMediaTokenHeaderAlgHS256:
		return true
	}
	return false
}

type GatewayMediaTokenHeaderTyp string

// The values of GatewayMediaTokenHeaderTyp.
const (
	GatewayMediaTokenHeaderTypJWT GatewayMediaTokenHeaderTyp = "JWT"
)

// Valid is whether e is one of GatewayMediaTokenHeaderTyp's values.
func (e GatewayMediaTokenHeaderTyp) Valid() bool {
	switch e {
	case GatewayMediaTokenHeaderTypJWT:
		return true
	}
	return false
}

// GatewayMessages gateway/messages.json: the words of the gateway's own
// refusals.
type GatewayMessages struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Messages Each refusal the gateway makes itself.
	Messages []GatewayMessagesMessagesItem `json:"messages"`
	// Failures Each failure frame the gateway delivers itself, on the stream of
	// the client whose request it answers.
	Failures []GatewayMessagesFailuresItem `json:"failures"`
	// Challenges The `WWW-Authenticate` of a 401.
	Challenges GatewayMessagesChallenges `json:"challenges"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v GatewayMessages) MarshalJSON() ([]byte, error) {
	type written GatewayMessages
	v.Messages = listOf(v.Messages)
	v.Failures = listOf(v.Failures)
	return json.Marshal(written(v))
}

// GatewayMessagesChallenges The `WWW-Authenticate` of a 401.
type GatewayMessagesChallenges struct {
	// NoCredential For a request that presents no credential. The challenge.
	// `{origin}` is the origin the Unauthorized response names: `http://` and
	// the request's `Host`, or, for a request that names none, the gateway's
	// `publicUrl`.
	NoCredential string `json:"noCredential"`
	// Refused For a request whose credential, a bearer token or a media token,
	// is refused. The challenge. `{origin}` is the origin the Unauthorized
	// response names: `http://` and the request's `Host`, or, for a request that
	// names none, the gateway's `publicUrl`.
	Refused string `json:"refused"`
}

type GatewayMessagesFailuresItem struct {
	// Name The situation's name.
	Name string `json:"name"`
	// Code Its `code`.
	Code string `json:"code"`
	// Situation When the gateway answers it, and what fills each `{name}` of its
	// texts.
	Situation string `json:"situation"`
	// Message Its text. A `{name}` in it is filled with what the row's
	// `situation` names, and nothing else in it varies.
	Message string `json:"message"`
}

type GatewayMessagesMessagesItem struct {
	// Name The situation's name.
	Name   string     `json:"name"`
	Status HttpStatus `json:"status"`
	// Code Its `code`, where it carries one: a LimitRefusal's, or the transport
	// code errors/codes.json names for its status.
	Code *string `json:"code,omitempty"`
	// Situation When the gateway answers it, and what fills each `{name}` of its
	// texts.
	Situation string `json:"situation"`
	// Error Its text. A `{name}` in it is filled with what the row's `situation`
	// names, and nothing else in it varies.
	Error string `json:"error"`
	// Hint Its `hint`, where it carries one.
	Hint *string `json:"hint,omitempty"`
}

// GatewayResponseHeaders gateway/response-headers.json: the headers on every
// response the gateway sends.
type GatewayResponseHeaders struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Every Each header every response carries, and its value.
	Every []GatewayResponseHeadersEveryItem `json:"every"`
	// RequestId The header that names the request.
	RequestId string `json:"requestId"`
	// Absent Each header no response carries.
	Absent []string `json:"absent"`
	// Preflight How the gateway answers an `OPTIONS` request.
	Preflight GatewayResponseHeadersPreflight `json:"preflight"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v GatewayResponseHeaders) MarshalJSON() ([]byte, error) {
	type written GatewayResponseHeaders
	v.Every = listOf(v.Every)
	v.Absent = listOf(v.Absent)
	return json.Marshal(written(v))
}

type GatewayResponseHeadersEveryItem struct {
	// Name A header's name, as HTTP spells it; a receiver reads it in any case.
	Name string `json:"name"`
	// Value Its value, exactly.
	Value string `json:"value"`
}

// GatewayResponseHeadersPreflight How the gateway answers an `OPTIONS`
// request.
type GatewayResponseHeadersPreflight struct {
	Status HttpStatus `json:"status"`
	// Headers Each header it carries beside those of `every`, and its value.
	Headers []GatewayResponseHeadersPreflightHeadersItem `json:"headers"`
	// Echoes Each header it carries when the request carries the header it
	// echoes, with that header's value.
	Echoes []GatewayResponseHeadersPreflightEchoesItem `json:"echoes"`
	// Vary The value of the `Vary` it carries when it echoes a header: the
	// request headers it echoes.
	Vary string `json:"vary"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v GatewayResponseHeadersPreflight) MarshalJSON() ([]byte, error) {
	type written GatewayResponseHeadersPreflight
	v.Headers = listOf(v.Headers)
	v.Echoes = listOf(v.Echoes)
	return json.Marshal(written(v))
}

type GatewayResponseHeadersPreflightEchoesItem struct {
	// Name A header's name, as HTTP spells it; a receiver reads it in any case.
	Name string `json:"name"`
	// Of The request's header whose value it carries.
	Of string `json:"of"`
}

type GatewayResponseHeadersPreflightHeadersItem struct {
	// Name A header's name, as HTTP spells it; a receiver reads it in any case.
	Name string `json:"name"`
	// Value Its value, exactly.
	Value string `json:"value"`
}

// GatherAnnotationComplete Completion payload emitted on the
// gather:annotation-complete bus channel when annotation context gathering
// finishes.
type GatherAnnotationComplete struct {
	// AnnotationId Branded AnnotationId of the annotation whose context was
	// gathered
	AnnotationId AnnotationId `json:"annotationId"`
	// Response The gathered annotation context (unified GatheredContext,
	// focus.kind:'annotation')
	Response GatheredContext `json:"response"`
}

// GatherAnnotationOptions Optional configuration for an annotation-focus
// gather, which windows text around a mark. Distinct from the resource-focus
// options (depth / maxResources / includeContent / includeSummary), which
// traverse the resource graph.
type GatherAnnotationOptions struct {
	// IncludeSourceContext Whether to include source context in the gathered
	// result
	IncludeSourceContext *bool `json:"includeSourceContext,omitempty"`
	// IncludeTargetContext Whether to include target context in the gathered
	// result
	IncludeTargetContext *bool `json:"includeTargetContext,omitempty"`
	// ContextWindow How much of the text on each side of the annotation to
	// include, counted in Unicode code points
	ContextWindow *int `json:"contextWindow,omitempty"`
}

// GatherAnnotationRequest Request payload sent on the gather:requested bus
// channel to gather context for an annotation.
type GatherAnnotationRequest struct {
	// AnnotationId Branded AnnotationId of the annotation to gather context for
	AnnotationId AnnotationId `json:"annotationId"`
	// ResourceId Branded ResourceId of the resource the annotation belongs to
	ResourceId ResourceId               `json:"resourceId"`
	Options    *GatherAnnotationOptions `json:"options,omitempty"`
}

// GatherFailed The payload of `gather:failed`: a CommandError that names the
// annotation whose context could not be gathered.
type GatherFailed struct {
	// Code Machine-readable failure class, for consumers that must BRANCH on why
	// a command failed rather than log it. Optional and deliberately sparse:
	// absent means 'no class declared', and every existing failure stays that
	// way. An enum rather than a free string so the vocabulary has an owner — an
	// unconstrained code is a mirror with no gate, and adding one should be a
	// deliberate spec change. `message` remains the human-readable text and is
	// unaffected. Members: `peer-unavailable` — the channel this command was
	// sent on has no subscriber, i.e. the service that answers it has not
	// connected yet. Transient by nature (a peer still starting), which is what
	// distinguishes it from a refusal: retrying is the correct response.
	// `not-found` — the resource this command addressed does not exist in this
	// knowledge base. A verdict, not a symptom: it is emitted only where the
	// answer comes from the event store, which is the system of record, and
	// never from a projection that may merely be lagging. Deterministic, so
	// unlike `peer-unavailable` retrying is pointless — and consumers may act
	// destructively on it (the SDK deletes a restored tab). Absence is not
	// denial: a future 'exists, but not for you' must travel as its own code,
	// never as this one. `unauthorized` — that code: the caller is authenticated
	// but not permitted to do what it asked. A verdict about the CALLER, not the
	// resource, so retrying under the same credential cannot succeed and a
	// consumer must never spin on it; emitted by `job:claim` for a caller whose
	// token carries no worker role. `none-pending` — a declined claim, not an
	// error: the queue holds no pending job of the requested types. Nothing went
	// wrong; the one code a consumer PARKS on, meaning 'nothing to do until a
	// wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying
	// neither is unclassified — a malformed record or a missing injection — and
	// a consumer treats it as 'log it, assume nothing'.
	Code *CommandErrorCode `json:"code,omitempty"`
	// Message Human-readable error message
	Message string `json:"message"`
	// Details Optional additional context (stack trace, field name, etc.)
	Details *string `json:"details,omitempty"`
	// AnnotationId The annotation the gather was asked for.
	AnnotationId AnnotationId `json:"annotationId"`
}

// GatherReferencedByRequest Request for the annotations elsewhere that refer
// to a resource. The Librarian answers from the graph.
type GatherReferencedByRequest struct {
	ResourceId ResourceId `json:"resourceId"`
	// Motivation The one motivation the annotations answered have. Every
	// annotation that refers to the resource is answered where none is stated.
	Motivation *Motivation `json:"motivation,omitempty"`
}

// GatherReferencedByResult The annotations elsewhere that refer to a resource
type GatherReferencedByResult struct {
	Response GetReferencedByResponse `json:"response"`
}

// GatherResourceComplete Completion payload emitted on the
// gather:resource-complete bus channel when resource context gathering
// finishes.
type GatherResourceComplete struct {
	// ResourceId Branded ResourceId of the resource whose context was gathered
	ResourceId ResourceId `json:"resourceId"`
	// Response The gathered resource context (unified GatheredContext,
	// focus.kind:'resource')
	Response GatheredContext `json:"response"`
}

// GatherResourceFailed The payload of `gather:resource-failed`: a
// CommandError that names the resource whose context could not be gathered.
type GatherResourceFailed struct {
	// Code Machine-readable failure class, for consumers that must BRANCH on why
	// a command failed rather than log it. Optional and deliberately sparse:
	// absent means 'no class declared', and every existing failure stays that
	// way. An enum rather than a free string so the vocabulary has an owner — an
	// unconstrained code is a mirror with no gate, and adding one should be a
	// deliberate spec change. `message` remains the human-readable text and is
	// unaffected. Members: `peer-unavailable` — the channel this command was
	// sent on has no subscriber, i.e. the service that answers it has not
	// connected yet. Transient by nature (a peer still starting), which is what
	// distinguishes it from a refusal: retrying is the correct response.
	// `not-found` — the resource this command addressed does not exist in this
	// knowledge base. A verdict, not a symptom: it is emitted only where the
	// answer comes from the event store, which is the system of record, and
	// never from a projection that may merely be lagging. Deterministic, so
	// unlike `peer-unavailable` retrying is pointless — and consumers may act
	// destructively on it (the SDK deletes a restored tab). Absence is not
	// denial: a future 'exists, but not for you' must travel as its own code,
	// never as this one. `unauthorized` — that code: the caller is authenticated
	// but not permitted to do what it asked. A verdict about the CALLER, not the
	// resource, so retrying under the same credential cannot succeed and a
	// consumer must never spin on it; emitted by `job:claim` for a caller whose
	// token carries no worker role. `none-pending` — a declined claim, not an
	// error: the queue holds no pending job of the requested types. Nothing went
	// wrong; the one code a consumer PARKS on, meaning 'nothing to do until a
	// wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying
	// neither is unclassified — a malformed record or a missing injection — and
	// a consumer treats it as 'log it, assume nothing'.
	Code *CommandErrorCode `json:"code,omitempty"`
	// Message Human-readable error message
	Message string `json:"message"`
	// Details Optional additional context (stack trace, field name, etc.)
	Details *string `json:"details,omitempty"`
	// ResourceId The resource the gather was asked for.
	ResourceId ResourceId `json:"resourceId"`
}

// GatherResourceOptions What gathering the context of a resource is told
// beside the resource: GatherResourceRequestOptions, each member of which a
// caller may leave out. client/surface.json's `gather.resource` cases state
// what is sent for one left out.
type GatherResourceOptions struct {
	// Depth How many links out from the resource the knowledge graph reaches,
	// nearest first: 1 is what the resource links to and what cites it, and each
	// further link out adds what those link to and what cites them
	Depth *int `json:"depth,omitempty"`
	// MaxResources Maximum number of related resources to include
	MaxResources *int `json:"maxResources,omitempty"`
	// IncludeContent Whether to include resource content in the gathered result
	IncludeContent *bool `json:"includeContent,omitempty"`
	// IncludeSummary Whether to include resource summaries in the gathered
	// result
	IncludeSummary *bool `json:"includeSummary,omitempty"`
	// ExcludeEntityTypes Entity types to exclude from the semantic recall built
	// into this context (caller-supplied; e.g. a chat consumer passes
	// ['Question'] so prior questions never ground answer generation). Optional;
	// default none.
	ExcludeEntityTypes *[]string `json:"excludeEntityTypes,omitempty"`
}

// GatherResourceRequest Request payload sent on the gather:resource-requested
// bus channel to gather context for a resource.
type GatherResourceRequest struct {
	// ResourceId Branded ResourceId of the resource to gather context for
	ResourceId ResourceId                   `json:"resourceId"`
	Options    GatherResourceRequestOptions `json:"options"`
}

// GatherResourceRequestOptions Gathering configuration
type GatherResourceRequestOptions struct {
	// Depth How many links out from the resource the knowledge graph reaches,
	// nearest first: 1 is what the resource links to and what cites it, and each
	// further link out adds what those link to and what cites them
	Depth int `json:"depth"`
	// MaxResources Maximum number of related resources to include
	MaxResources int `json:"maxResources"`
	// IncludeContent Whether to include resource content in the gathered result
	IncludeContent bool `json:"includeContent"`
	// IncludeSummary Whether to include resource summaries in the gathered
	// result
	IncludeSummary bool `json:"includeSummary"`
	// ExcludeEntityTypes Entity types to exclude from the semantic recall built
	// into this context (caller-supplied; e.g. a chat consumer passes
	// ['Question'] so prior questions never ground answer generation). Optional;
	// default none.
	ExcludeEntityTypes *[]string `json:"excludeEntityTypes,omitempty"`
}

// GatherSummaryRequest Request to generate an AI summary of an annotation
type GatherSummaryRequest struct {
	AnnotationId AnnotationId `json:"annotationId"`
	ResourceId   ResourceId   `json:"resourceId"`
}

// GatheredContext Context gathered for a gather.* call — consumed by yield.*
// (generation) and the matcher. A shared base (graph, semanticContext,
// metadata, inferredRelationshipSummary) plus a discriminated `focus` that
// names the anchor: an annotation or a whole resource.
type GatheredContext struct {
	// Focus The gather anchor. Discriminated on `kind`.
	Focus GatheredContextFocus `json:"focus"`
	// Graph Knowledge graph backbone — resources AND annotations as typed nodes.
	// The flattened views (connections, citedBy, siblings) are derived from
	// this.
	Graph KnowledgeGraph `json:"graph"`
	// SemanticContext Semantically similar passages from across the knowledge
	// base, found via vector search
	SemanticContext *GatheredContextSemanticContext `json:"semanticContext,omitempty"`
	// Metadata Context metadata about the focal anchor and its source
	Metadata GatheredContextMetadata `json:"metadata"`
	// InferredRelationshipSummary LLM-generated summary of the focal anchor's
	// relationships in the knowledge graph
	InferredRelationshipSummary *string `json:"inferredRelationshipSummary,omitempty"`
}

// GatheredContextFocus The gather anchor. Discriminated on `kind`.
type GatheredContextFocus struct {
	union[GatheredContextFocusMember]
}

// GatheredContextFocusMember is a member of GatheredContextFocus:
// GatheredContextFocusAnnotation, GatheredContextFocusResource.
type GatheredContextFocusMember interface {
	memberOfGatheredContextFocus()
}

// Member is the member this value is: the one whose schema admits it.
func (u GatheredContextFocus) Member() (any, error) {
	return u.member("GatheredContextFocus", gatheredContextFocusMembers)
}

// gatheredContextFocusMembers is what each member of GatheredContextFocus
// admits, and how a value of it is read.
var gatheredContextFocusMembers = []unionMember{
	{"GatheredContextFocusAnnotation", readAs[GatheredContextFocusAnnotation], []signature{{kind: objectKind, required: []string{"kind", "annotation", "sourceResource"}, fixed: []fixedValues{{"kind", []any{"annotation"}}}}}},
	{"GatheredContextFocusResource", readAs[GatheredContextFocusResource], []signature{{kind: objectKind, required: []string{"kind", "resource"}, fixed: []fixedValues{{"kind", []any{"resource"}}}}}},
}

// GatheredContextFocusAnnotation Annotation-anchored focus.
type GatheredContextFocusAnnotation struct {
	Kind GatheredContextFocusAnnotationKind `json:"kind"`
	// Annotation The annotation this context was gathered for
	Annotation Annotation `json:"annotation"`
	// SourceResource The resource containing the annotation
	SourceResource ResourceDescriptor `json:"sourceResource"`
	// Selected Text context around the annotation target
	Selected *GatheredContextFocusAnnotationSelected `json:"selected,omitempty"`
	// UserHint User-provided hint to supplement or replace the selected text for
	// search and generation
	UserHint *string `json:"userHint,omitempty"`
	// TargetResource The resource the annotation links to, if it is a resolved
	// reference. Dormant capability — produced/exposed but not yet consumed.
	TargetResource *ResourceDescriptor `json:"targetResource,omitempty"`
	// TargetContext Context about the annotation's link target. Dormant —
	// produced/exposed but not yet consumed.
	TargetContext *GatheredContextFocusAnnotationTargetContext `json:"targetContext,omitempty"`
}

func (GatheredContextFocusAnnotation) memberOfGatheredContextFocus() {}

type GatheredContextFocusAnnotationKind string

// The values of GatheredContextFocusAnnotationKind.
const (
	GatheredContextFocusAnnotationKindAnnotation GatheredContextFocusAnnotationKind = "annotation"
)

// Valid is whether e is one of GatheredContextFocusAnnotationKind's values.
func (e GatheredContextFocusAnnotationKind) Valid() bool {
	switch e {
	case GatheredContextFocusAnnotationKindAnnotation:
		return true
	}
	return false
}

// GatheredContextFocusAnnotationSelected Text context around the annotation
// target
type GatheredContextFocusAnnotationSelected struct {
	// Before Text appearing before the selected passage
	Before *string `json:"before,omitempty"`
	// Text The selected text passage (the annotation target)
	Text string `json:"text"`
	// After Text appearing after the selected passage
	After *string `json:"after,omitempty"`
}

// GatheredContextFocusAnnotationTargetContext Context about the annotation's
// link target. Dormant — produced/exposed but not yet consumed.
type GatheredContextFocusAnnotationTargetContext struct {
	Content string  `json:"content"`
	Summary *string `json:"summary,omitempty"`
}

// GatheredContextFocusResource Whole-resource focus.
type GatheredContextFocusResource struct {
	Kind GatheredContextFocusResourceKind `json:"kind"`
	// Resource The resource this context was gathered for
	Resource            ResourceDescriptor `json:"resource"`
	Summary             *string            `json:"summary,omitempty"`
	SuggestedReferences *[]string          `json:"suggestedReferences,omitempty"`
	// Content Resource content (included when requested)
	Content *GatheredContextFocusResourceContent `json:"content,omitempty"`
}

func (GatheredContextFocusResource) memberOfGatheredContextFocus() {}

// GatheredContextFocusResourceContent Resource content (included when
// requested)
type GatheredContextFocusResourceContent struct {
	// Main Content of the focal resource
	Main *string `json:"main,omitempty"`
	// Related Map of related resource IDs to their content
	Related *map[string]string `json:"related,omitempty"`
}

type GatheredContextFocusResourceKind string

// The values of GatheredContextFocusResourceKind.
const (
	GatheredContextFocusResourceKindResource GatheredContextFocusResourceKind = "resource"
)

// Valid is whether e is one of GatheredContextFocusResourceKind's values.
func (e GatheredContextFocusResourceKind) Valid() bool {
	switch e {
	case GatheredContextFocusResourceKindResource:
		return true
	}
	return false
}

// GatheredContextMetadata Context metadata about the focal anchor and its
// source
type GatheredContextMetadata struct {
	// ResourceType Type of source resource (e.g., 'document', 'image', 'video')
	ResourceType *string `json:"resourceType,omitempty"`
	// Language BCP 47 language tag of source content
	Language *string `json:"language,omitempty"`
	// EntityTypes Entity types associated with the focal anchor
	EntityTypes *[]string `json:"entityTypes,omitempty"`
	// EntityTypeFrequencies Global frequency counts for entity types (for
	// IDF-like weighting). A KB-wide statistic, not a neighborhood property —
	// kept here rather than on the graph.
	EntityTypeFrequencies *map[string]int `json:"entityTypeFrequencies,omitempty"`
}

// GatheredContextSemanticContext Semantically similar passages from across
// the knowledge base, found via vector search
type GatheredContextSemanticContext struct {
	// Similar Passages ranked by cosine similarity to the focal text
	Similar []SemanticMatch `json:"similar"`
	// ExcludedEntityTypes Entity types excluded from this recall — a record of
	// how `similar` was filtered (e.g. ['Question'] so answer-generation never
	// surfaces prior questions). Absent when no exclusion was applied.
	ExcludedEntityTypes *[]string `json:"excludedEntityTypes,omitempty"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v GatheredContextSemanticContext) MarshalJSON() ([]byte, error) {
	type written GatheredContextSemanticContext
	v.Similar = listOf(v.Similar)
	return json.Marshal(written(v))
}

// GenerationJobParams The parameters of a `yield` job: what it is asked to
// make (GenerationJobRequest) and the gathered context it is made from. The
// job's resource is derived from `context.focus` by the dispatcher (resource
// focus → focus.resource; annotation focus → focus.sourceResource, with the
// worker binding to focus.annotation), and the dispatcher refuses a parameter
// this schema does not name.
type GenerationJobParams struct {
	// Title Title of the generated resource. Not empty: the gateway refuses a
	// `job:create` whose title is.
	Title string `json:"title"`
	// StorageUri Storage URI for the generated resource's content —
	// AUTHORITATIVE: the worker writes exactly here and never derives a location
	// from the title. Not empty, and there is no fallback: the gateway refuses a
	// `job:create` whose storageUri is.
	StorageUri string `json:"storageUri"`
	// Prompt Refining instruction, composed with `task` (task = what, prompt =
	// how).
	Prompt *string `json:"prompt,omitempty"`
	// EntityTypes Entity-type tags to stamp on the synthesized resource. Used
	// both as a prompt bias for the generation worker and as the `entityTypes`
	// set on the resulting resource.
	EntityTypes *[]string `json:"entityTypes,omitempty"`
	// Language Annotation/resource body locale — language the generated resource
	// is written in (typically the user's UI locale). BCP-47.
	Language *string `json:"language,omitempty"`
	// SourceLanguage Source-resource locale — language of the resource being
	// referenced, used in the prompt so the LLM understands embedded
	// source-context snippets when source ≠ target language. BCP-47.
	SourceLanguage *string `json:"sourceLanguage,omitempty"`
	// Temperature Sampling temperature forwarded to the model.
	Temperature *float64 `json:"temperature,omitempty"`
	// MaxTokens Output token budget forwarded to the model. Length never
	// determines structure.
	MaxTokens *float64 `json:"maxTokens,omitempty"`
	// OutputMediaType Requested media type of the generated resource's content.
	// Default `text/markdown` at the worker, which validates it against its
	// supported output set and FAILS the job for anything it can't write — not a
	// silent fallback.
	OutputMediaType *SupportedMediaType `json:"outputMediaType,omitempty"`
	// Task What the model is asked to produce — the prompt's framing verb.
	// Canonical values ('resource', 'answer', 'summary') map to the worker's
	// tested framings; any other string is used VERBATIM as the framing
	// instruction (loud degrade: the worker warns, never silently falls back).
	// Unset ⇒ 'resource' (article framing).
	Task *string `json:"task,omitempty"`
	// Structure How the output is internally segmented — shape for text-bearing
	// media, subordinate to `outputMediaType` (never its peer). Canonical
	// values: 'prose' (flowing paragraphs), 'sections' (titled sections +
	// title), 'chat' (speaker-labeled turns); any other string becomes a
	// freeform "organize as: …" directive (loud degrade). Unset ⇒ NO structure
	// directive at all — the task framing and the model determine shape.
	Structure *string `json:"structure,omitempty"`
	// Cite Ask the model to cite its sources, by the ids the gathered context
	// labels its passages with. The model wraps the words a source supports as
	// `[[<id>: <claim>]]`, the ids of several sources separated by commas; a
	// bare `[[<id>]]` is replaced by the source's name. The worker checks every
	// id against the gathered context (an id it did not show is dropped, with a
	// warning), takes every token out of the stored content, and mints a W3C
	// linking annotation on the new resource over exactly the words each token
	// cites.
	Cite *bool `json:"cite,omitempty"`
	// Context The gathered context that grounds the generation. Its `focus`
	// names the anchor: the DISPATCHER derives the job's resourceId from it
	// (resource focus → focus.resource; annotation focus → focus.sourceResource,
	// with the worker auto-binding to focus.annotation) and REJECTS a
	// caller-supplied id — the context is authoritative. Under `cite`, the ids
	// its embedding carries are the only valid citation targets.
	Context GatheredContext `json:"context"`
}

// GenerationJobRequest What a `yield` job is asked to make: every parameter
// of GenerationJobParams but its `context`, the input the resource is made
// from. It is what an announcement of the job carries.
type GenerationJobRequest struct {
	// Title Title of the generated resource. Not empty: the gateway refuses a
	// `job:create` whose title is.
	Title string `json:"title"`
	// StorageUri Storage URI for the generated resource's content —
	// AUTHORITATIVE: the worker writes exactly here and never derives a location
	// from the title. Not empty, and there is no fallback: the gateway refuses a
	// `job:create` whose storageUri is.
	StorageUri string `json:"storageUri"`
	// Prompt Refining instruction, composed with `task` (task = what, prompt =
	// how).
	Prompt *string `json:"prompt,omitempty"`
	// EntityTypes Entity-type tags to stamp on the synthesized resource. Used
	// both as a prompt bias for the generation worker and as the `entityTypes`
	// set on the resulting resource.
	EntityTypes *[]string `json:"entityTypes,omitempty"`
	// Language Annotation/resource body locale — language the generated resource
	// is written in (typically the user's UI locale). BCP-47.
	Language *string `json:"language,omitempty"`
	// SourceLanguage Source-resource locale — language of the resource being
	// referenced, used in the prompt so the LLM understands embedded
	// source-context snippets when source ≠ target language. BCP-47.
	SourceLanguage *string `json:"sourceLanguage,omitempty"`
	// Temperature Sampling temperature forwarded to the model.
	Temperature *float64 `json:"temperature,omitempty"`
	// MaxTokens Output token budget forwarded to the model. Length never
	// determines structure.
	MaxTokens *float64 `json:"maxTokens,omitempty"`
	// OutputMediaType Requested media type of the generated resource's content.
	// Default `text/markdown` at the worker, which validates it against its
	// supported output set and FAILS the job for anything it can't write — not a
	// silent fallback.
	OutputMediaType *SupportedMediaType `json:"outputMediaType,omitempty"`
	// Task What the model is asked to produce — the prompt's framing verb.
	// Canonical values ('resource', 'answer', 'summary') map to the worker's
	// tested framings; any other string is used VERBATIM as the framing
	// instruction (loud degrade: the worker warns, never silently falls back).
	// Unset ⇒ 'resource' (article framing).
	Task *string `json:"task,omitempty"`
	// Structure How the output is internally segmented — shape for text-bearing
	// media, subordinate to `outputMediaType` (never its peer). Canonical
	// values: 'prose' (flowing paragraphs), 'sections' (titled sections +
	// title), 'chat' (speaker-labeled turns); any other string becomes a
	// freeform "organize as: …" directive (loud degrade). Unset ⇒ NO structure
	// directive at all — the task framing and the model determine shape.
	Structure *string `json:"structure,omitempty"`
	// Cite Ask the model to cite its sources, by the ids the gathered context
	// labels its passages with. The model wraps the words a source supports as
	// `[[<id>: <claim>]]`, the ids of several sources separated by commas; a
	// bare `[[<id>]]` is replaced by the source's name. The worker checks every
	// id against the gathered context (an id it did not show is dropped, with a
	// warning), takes every token out of the stored content, and mints a W3C
	// linking annotation on the new resource over exactly the words each token
	// cites.
	Cite *bool `json:"cite,omitempty"`
}

type GetAnnotationHistoryResponse struct {
	Events       []AttributedEvent `json:"events"`
	Total        float64           `json:"total"`
	AnnotationId AnnotationId      `json:"annotationId"`
	ResourceId   ResourceId        `json:"resourceId"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v GetAnnotationHistoryResponse) MarshalJSON() ([]byte, error) {
	type written GetAnnotationHistoryResponse
	v.Events = listOf(v.Events)
	return json.Marshal(written(v))
}

type GetAnnotationResponse struct {
	Annotation       Annotation          `json:"annotation"`
	Resource         *ResourceDescriptor `json:"resource"`
	ResolvedResource *ResourceDescriptor `json:"resolvedResource"`
}

type GetAnnotationsResponse struct {
	Annotations []Annotation `json:"annotations"`
	// Total Total number of annotations
	Total float64 `json:"total"`
	// Motivation Motivation filter applied (if any)
	Motivation *Motivation `json:"motivation,omitempty"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v GetAnnotationsResponse) MarshalJSON() ([]byte, error) {
	type written GetAnnotationsResponse
	v.Annotations = listOf(v.Annotations)
	return json.Marshal(written(v))
}

type GetEntityTypesResponse struct {
	EntityTypes []string `json:"entityTypes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v GetEntityTypesResponse) MarshalJSON() ([]byte, error) {
	type written GetEntityTypesResponse
	v.EntityTypes = listOf(v.EntityTypes)
	return json.Marshal(written(v))
}

type GetEventsResponse struct {
	Events     []AttributedEvent `json:"events"`
	Total      float64           `json:"total"`
	ResourceId ResourceId        `json:"resourceId"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v GetEventsResponse) MarshalJSON() ([]byte, error) {
	type written GetEventsResponse
	v.Events = listOf(v.Events)
	return json.Marshal(written(v))
}

type GetReferencedByResponse struct {
	ReferencedBy []GetReferencedByResponseReferencedByItem `json:"referencedBy"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v GetReferencedByResponse) MarshalJSON() ([]byte, error) {
	type written GetReferencedByResponse
	v.ReferencedBy = listOf(v.ReferencedBy)
	return json.Marshal(written(v))
}

type GetReferencedByResponseReferencedByItem struct {
	// Id Reference annotation ID
	Id AnnotationId `json:"id"`
	// ResourceName Name of the resource containing the reference. Absent where
	// no description of that resource is held, and where its name is empty.
	ResourceName *string                                       `json:"resourceName,omitempty"`
	Target       GetReferencedByResponseReferencedByItemTarget `json:"target"`
}

type GetReferencedByResponseReferencedByItemTarget struct {
	// Source ID of resource containing the reference
	Source   ResourceId                                            `json:"source"`
	Selector GetReferencedByResponseReferencedByItemTargetSelector `json:"selector"`
}

type GetReferencedByResponseReferencedByItemTargetSelector struct {
	// Exact The selected text that references this resource
	Exact string `json:"exact"`
}

type GetResourceByTokenResponse struct {
	SourceResource ResourceDescriptor `json:"sourceResource"`
	// ExpiresAt ISO 8601 timestamp when token expires
	ExpiresAt string `json:"expiresAt"`
}

type GetResourceResponse struct {
	Resource ResourceDescriptor `json:"resource"`
	// Annotations All annotations for the resource (highlights, references,
	// assessments, etc.)
	Annotations []Annotation `json:"annotations"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v GetResourceResponse) MarshalJSON() ([]byte, error) {
	type written GetResourceResponse
	v.Annotations = listOf(v.Annotations)
	return json.Marshal(written(v))
}

type GetTagSchemasResponse struct {
	TagSchemas []TagSchema `json:"tagSchemas"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v GetTagSchemasResponse) MarshalJSON() ([]byte, error) {
	type written GetTagSchemasResponse
	v.TagSchemas = listOf(v.TagSchemas)
	return json.Marshal(written(v))
}

// GraphAnnotationNode An annotation's graph presence. The node IS the
// annotation, so the full W3C object is required — selectors and body
// included, which is what lets a client place context annotations without a
// second fetch. Citations ride here too: an inbound reference is its linking
// annotation, anchored by an `annotation-of` edge to the resource it lives on
// and a `cites` edge to the focal resource.
type GraphAnnotationNode struct {
	// Id The AnnotationId — the same value as annotation.id
	Id   AnnotationId            `json:"id"`
	Type GraphAnnotationNodeType `json:"type"`
	// Label The annotation's motivation, as a display label
	Label string `json:"label"`
	// EntityTypes Entity types carried by the annotation
	EntityTypes *[]string       `json:"entityTypes,omitempty"`
	Annotation  Annotation      `json:"annotation"`
	Metadata    *map[string]any `json:"metadata,omitempty"`
}

func (GraphAnnotationNode) memberOfKnowledgeGraphNodesItem() {}
func (GraphAnnotationNode) told() (string, string)           { return "type", "annotation" }

type GraphAnnotationNodeType string

// The values of GraphAnnotationNodeType.
const (
	GraphAnnotationNodeTypeAnnotation GraphAnnotationNodeType = "annotation"
)

// Valid is whether e is one of GraphAnnotationNodeType's values.
func (e GraphAnnotationNodeType) Valid() bool {
	switch e {
	case GraphAnnotationNodeTypeAnnotation:
		return true
	}
	return false
}

// GraphConfig The graph database a service writes or reads, and what that
// kind of database needs to be reached: one of the kinds `xynolog-graph` has
// a store for, told apart by `type`. A secret is never a value here: a
// database's password is named by the environment variable that holds it.
type GraphConfig struct {
	union[GraphConfigMember]
}

// GraphConfigMember is a member of GraphConfig: Neo4jGraphConfig,
// JanusGraphConfig, NeptuneGraphConfig, MemoryGraphConfig.
type GraphConfigMember interface {
	memberOfGraphConfig()
}

// Discriminator is the `type` this value states.
func (u GraphConfig) Discriminator() (string, error) { return u.stated("type") }

// Member is the member this value is: the one whose schema admits it.
func (u GraphConfig) Member() (any, error) { return u.member("GraphConfig", graphConfigMembers) }

// graphConfigMembers is what each member of GraphConfig admits, and how a
// value of it is read.
var graphConfigMembers = []unionMember{
	{"Neo4jGraphConfig", readAs[Neo4jGraphConfig], []signature{{kind: objectKind, required: []string{"type", "uri", "username", "passwordEnv", "database"}, allowed: []string{"type", "uri", "username", "passwordEnv", "database"}, fixed: []fixedValues{{"type", []any{"neo4j"}}}}}},
	{"JanusGraphConfig", readAs[JanusGraphConfig], []signature{{kind: objectKind, required: []string{"type", "host", "port"}, allowed: []string{"type", "host", "port"}, fixed: []fixedValues{{"type", []any{"janusgraph"}}}}}},
	{"NeptuneGraphConfig", readAs[NeptuneGraphConfig], []signature{{kind: objectKind, required: []string{"type", "endpoint", "port"}, allowed: []string{"type", "endpoint", "port"}, fixed: []fixedValues{{"type", []any{"neptune"}}}}}},
	{"MemoryGraphConfig", readAs[MemoryGraphConfig], []signature{{kind: objectKind, required: []string{"type"}, allowed: []string{"type"}, fixed: []fixedValues{{"type", []any{"memory"}}}}}},
}

// GraphResourceNode A resource's presence in the gathered knowledge graph.
type GraphResourceNode struct {
	// Id The resource's ResourceId
	Id   ResourceId            `json:"id"`
	Type GraphResourceNodeType `json:"type"`
	// Label The resource's display name — its raw id when the resource's view
	// was missing at build time
	Label string `json:"label"`
	// EntityTypes Entity types on the resource
	EntityTypes *[]string       `json:"entityTypes,omitempty"`
	Metadata    *map[string]any `json:"metadata,omitempty"`
}

func (GraphResourceNode) memberOfKnowledgeGraphNodesItem() {}
func (GraphResourceNode) told() (string, string)           { return "type", "resource" }

type GraphResourceNodeType string

// The values of GraphResourceNodeType.
const (
	GraphResourceNodeTypeResource GraphResourceNodeType = "resource"
)

// Valid is whether e is one of GraphResourceNodeType's values.
func (e GraphResourceNodeType) Valid() bool {
	switch e {
	case GraphResourceNodeTypeResource:
		return true
	}
	return false
}

// GraphSchema graph/schema.json: the shape of the graph a store keeps, as a
// reader of the store finds it.
type GraphSchema struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Nodes Each kind of node the graph holds.
	Nodes GraphSchemaNodes `json:"nodes"`
	// Relationships Each kind of relationship the graph holds.
	Relationships GraphSchemaRelationships `json:"relationships"`
	// Stub A link's target the graph has not been given yet: a node of its kind
	// that holds its key and the marker, `true`, and nothing else. A node
	// without the marker is no stub.
	Stub GraphSchemaStub `json:"stub"`
}

// GraphSchemaNodes Each kind of node the graph holds.
type GraphSchemaNodes struct {
	// Resource A kind of node: its label, the codec row it holds, the property
	// it is one of its kind by, and the properties a reader finds one by.
	Resource GraphSchemaNodesResource `json:"resource"`
	// Annotation A kind of node: its label, the codec row it holds, the property
	// it is one of its kind by, and the properties a reader finds one by.
	Annotation GraphSchemaNodesAnnotation `json:"annotation"`
	// EntityType A kind of node: its label, the codec row it holds, the property
	// it is one of its kind by, and the properties a reader finds one by.
	EntityType GraphSchemaNodesEntityType `json:"entityType"`
}

// GraphSchemaNodesAnnotation A kind of node: its label, the codec row it
// holds, the property it is one of its kind by, and the properties a reader
// finds one by.
type GraphSchemaNodesAnnotation struct {
	// Label Its label.
	Label string `json:"label"`
	// Row The part of graph/codec-cases.json whose `properties` and `json` are
	// the node's properties. A node without one holds its key alone.
	Row *string `json:"row,omitempty"`
	// Key The property no two nodes of its kind share.
	Key string `json:"key"`
	// Lookups The properties other than its key that a reader finds a node of
	// its kind by.
	Lookups []string `json:"lookups"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v GraphSchemaNodesAnnotation) MarshalJSON() ([]byte, error) {
	type written GraphSchemaNodesAnnotation
	v.Lookups = listOf(v.Lookups)
	return json.Marshal(written(v))
}

// GraphSchemaNodesEntityType A kind of node: its label, the codec row it
// holds, the property it is one of its kind by, and the properties a reader
// finds one by.
type GraphSchemaNodesEntityType struct {
	// Label Its label.
	Label string `json:"label"`
	// Row The part of graph/codec-cases.json whose `properties` and `json` are
	// the node's properties. A node without one holds its key alone.
	Row *string `json:"row,omitempty"`
	// Key The property no two nodes of its kind share.
	Key string `json:"key"`
	// Lookups The properties other than its key that a reader finds a node of
	// its kind by.
	Lookups []string `json:"lookups"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v GraphSchemaNodesEntityType) MarshalJSON() ([]byte, error) {
	type written GraphSchemaNodesEntityType
	v.Lookups = listOf(v.Lookups)
	return json.Marshal(written(v))
}

// GraphSchemaNodesResource A kind of node: its label, the codec row it holds,
// the property it is one of its kind by, and the properties a reader finds
// one by.
type GraphSchemaNodesResource struct {
	// Label Its label.
	Label string `json:"label"`
	// Row The part of graph/codec-cases.json whose `properties` and `json` are
	// the node's properties. A node without one holds its key alone.
	Row *string `json:"row,omitempty"`
	// Key The property no two nodes of its kind share.
	Key string `json:"key"`
	// Lookups The properties other than its key that a reader finds a node of
	// its kind by.
	Lookups []string `json:"lookups"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v GraphSchemaNodesResource) MarshalJSON() ([]byte, error) {
	type written GraphSchemaNodesResource
	v.Lookups = listOf(v.Lookups)
	return json.Marshal(written(v))
}

// GraphSchemaRelationships Each kind of relationship the graph holds.
type GraphSchemaRelationships struct {
	// BelongsTo A kind of relationship: its type, the kind of node it goes from
	// and the kind it goes to, and what it says.
	BelongsTo GraphSchemaRelationshipsBelongsTo `json:"belongsTo"`
	// References A kind of relationship: its type, the kind of node it goes from
	// and the kind it goes to, and what it says.
	References GraphSchemaRelationshipsReferences `json:"references"`
	// TaggedAs A kind of relationship: its type, the kind of node it goes from
	// and the kind it goes to, and what it says.
	TaggedAs GraphSchemaRelationshipsTaggedAs `json:"taggedAs"`
}

// GraphSchemaRelationshipsBelongsTo A kind of relationship: its type, the
// kind of node it goes from and the kind it goes to, and what it says.
type GraphSchemaRelationshipsBelongsTo struct {
	// Type Its type.
	Type string `json:"type"`
	// From The kind of node it goes from, by its name under `nodes`.
	From string `json:"from"`
	// To The kind of node it goes to, by its name under `nodes`.
	To string `json:"to"`
	// Says What one says.
	Says string `json:"says"`
}

// GraphSchemaRelationshipsReferences A kind of relationship: its type, the
// kind of node it goes from and the kind it goes to, and what it says.
type GraphSchemaRelationshipsReferences struct {
	// Type Its type.
	Type string `json:"type"`
	// From The kind of node it goes from, by its name under `nodes`.
	From string `json:"from"`
	// To The kind of node it goes to, by its name under `nodes`.
	To string `json:"to"`
	// Says What one says.
	Says string `json:"says"`
}

// GraphSchemaRelationshipsTaggedAs A kind of relationship: its type, the kind
// of node it goes from and the kind it goes to, and what it says.
type GraphSchemaRelationshipsTaggedAs struct {
	// Type Its type.
	Type string `json:"type"`
	// From The kind of node it goes from, by its name under `nodes`.
	From string `json:"from"`
	// To The kind of node it goes to, by its name under `nodes`.
	To string `json:"to"`
	// Says What one says.
	Says string `json:"says"`
}

// GraphSchemaStub A link's target the graph has not been given yet: a node of
// its kind that holds its key and the marker, `true`, and nothing else. A
// node without the marker is no stub.
type GraphSchemaStub struct {
	// Node The kind of node a stub is, by its name under `nodes`.
	Node string `json:"node"`
	// Marker The property that marks a stub.
	Marker string `json:"marker"`
}

// HealthResponse Liveness: the process is up and serving. It asks nothing of
// the Archivist or the broker — a gateway that cannot reach them refuses to
// start, so one that answers here got past both at boot.
type HealthResponse struct {
	Status    string `json:"status"`
	Message   string `json:"message"`
	Version   string `json:"version"`
	Timestamp string `json:"timestamp"`
}

// HighlightingJobParams What a highlighting job takes: passages of the
// resource worth a reader's attention are marked, with no text of the job's
// own.
type HighlightingJobParams struct {
	Motivation HighlightingJobParamsMotivation `json:"motivation"`
	// Instructions What to look for, in the caller's words. Added to the prompt.
	Instructions *string `json:"instructions,omitempty"`
	// Density How many annotations to aim for per 2000 words of the resource.
	Density *float64 `json:"density,omitempty"`
	// SourceLanguage The language of the resource being read. BCP 47.
	SourceLanguage *string `json:"sourceLanguage,omitempty"`
}

func (HighlightingJobParams) memberOfMarkJobParams() {}
func (HighlightingJobParams) told() (string, string) { return "motivation", "highlighting" }

type HighlightingJobParamsMotivation string

// The values of HighlightingJobParamsMotivation.
const (
	HighlightingJobParamsMotivationHighlighting HighlightingJobParamsMotivation = "highlighting"
)

// Valid is whether e is one of HighlightingJobParamsMotivation's values.
func (e HighlightingJobParamsMotivation) Valid() bool {
	switch e {
	case HighlightingJobParamsMotivationHighlighting:
		return true
	}
	return false
}

// HostPort Where somebody else's daemon listens.
type HostPort struct {
	// Host A host name or address the stack's containers can reach.
	Host string `json:"host"`
	// Port The port it listens on.
	Port int `json:"port"`
}

// HttpEndpoint A knowledge base reached through its gateway, over HTTP. The
// gateway's origin is the protocol, the host in lowercase and the port; a
// host that is not a host's name is refused before it is put into a URL
// (specs/src/session/gateway-url-cases.json).
type HttpEndpoint struct {
	// Kind Discriminant: the endpoint is a gateway reached over HTTP.
	Kind HttpEndpointKind `json:"kind"`
	// Host The gateway's host, as a person or a discovery document gave it.
	Host string `json:"host"`
	// Port The gateway's port.
	Port int `json:"port"`
	// Protocol What the gateway is reached over.
	Protocol HttpEndpointProtocol `json:"protocol"`
}

func (HttpEndpoint) memberOfKbEndpoint()    {}
func (HttpEndpoint) told() (string, string) { return "kind", "http" }

// HttpEndpointKind Discriminant: the endpoint is a gateway reached over HTTP.
type HttpEndpointKind string

// The values of HttpEndpointKind.
const (
	HttpEndpointKindHttp HttpEndpointKind = "http"
)

// Valid is whether e is one of HttpEndpointKind's values.
func (e HttpEndpointKind) Valid() bool {
	switch e {
	case HttpEndpointKindHttp:
		return true
	}
	return false
}

// HttpEndpointProtocol What the gateway is reached over.
type HttpEndpointProtocol string

// The values of HttpEndpointProtocol.
const (
	HttpEndpointProtocolHttp  HttpEndpointProtocol = "http"
	HttpEndpointProtocolHttps HttpEndpointProtocol = "https"
)

// Valid is whether e is one of HttpEndpointProtocol's values.
func (e HttpEndpointProtocol) Valid() bool {
	switch e {
	case HttpEndpointProtocolHttp, HttpEndpointProtocolHttps:
		return true
	}
	return false
}

// HttpStatus An HTTP response's status code, as the tables state one. No API
// states it, so it is no component.
type (
	HttpStatus = int
)

// IdentifiersKinds identifiers/kinds.json: the kinds of id the protocol
// names, the properties that carry each, and the properties named like an id
// that carry something else.
type IdentifiersKinds struct {
	// Comment The rule the table states, in prose.
	Comment string                       `json:"$comment"`
	Kinds   []IdentifiersKindsKindsItem  `json:"kinds"`
	Others  []IdentifiersKindsOthersItem `json:"others"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v IdentifiersKinds) MarshalJSON() ([]byte, error) {
	type written IdentifiersKinds
	v.Kinds = listOf(v.Kinds)
	v.Others = listOf(v.Others)
	return json.Marshal(written(v))
}

type IdentifiersKindsKindsItem struct {
	// Schema The component under components/schemas that states the kind, by
	// name.
	Schema string `json:"schema"`
	// Properties The property names that always carry the kind.
	Properties []string `json:"properties"`
	// Accepts Strings the kind's rule takes.
	Accepts []IdentifiersKindsKindsItemAcceptsItem `json:"accepts"`
	// Refuses Strings the kind's rule does not take.
	Refuses []IdentifiersKindsKindsItemRefusesItem `json:"refuses"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v IdentifiersKindsKindsItem) MarshalJSON() ([]byte, error) {
	type written IdentifiersKindsKindsItem
	v.Properties = listOf(v.Properties)
	v.Accepts = listOf(v.Accepts)
	v.Refuses = listOf(v.Refuses)
	return json.Marshal(written(v))
}

type IdentifiersKindsKindsItemAcceptsItem struct {
	// Id A string the kind's rule is asked about.
	Id string `json:"id"`
	// Why What the case shows, in prose.
	Why string `json:"why"`
}

type IdentifiersKindsKindsItemRefusesItem struct {
	// Id A string the kind's rule is asked about.
	Id string `json:"id"`
	// Why What the case shows, in prose.
	Why string `json:"why"`
}

type IdentifiersKindsOthersItem struct {
	// Property A property named like an id.
	Property string `json:"property"`
	// Docs What it carries instead.
	Docs string `json:"docs"`
}

// IdentityUser An account in a knowledge base's launcher-managed identity
// realm. Passwords and tokens are never included.
type IdentityUser struct {
	// Email The account's sign-in name, normally its email address.
	Email string `json:"email"`
	// Identity The identity the account acts under in Xynolog.
	Identity string `json:"identity"`
	// Enabled Whether the identity provider currently allows this account to
	// sign in.
	Enabled bool `json:"enabled"`
}

// IdentityUseraddParams Create one account in the launcher-managed Keycloak
// realm for a specific local knowledge base.
type IdentityUseraddParams struct {
	ApiVersion ApiVersion  `json:"apiVersion"`
	Target     LocalTarget `json:"target"`
	// Email The email address that will sign in to this knowledge base.
	Email string `json:"email"`
	// Password The user's password. Secret: carried only in this local control
	// request, never in progress, diagnostics, or persistent state.
	Password *string `json:"password,omitempty"`
	// GeneratePassword Generate a random password in the launcher and return it
	// once in the result.
	GeneratePassword bool `json:"generatePassword"`
}

// IdentityUseraddResult The created account's sign-in identity. A generated
// password is present only in this one answer and is not stored by the
// launcher.
type IdentityUseraddResult struct {
	// Email The account's email address.
	Email string `json:"email"`
	// Identity The identity the account acts under in Xynolog.
	Identity string `json:"identity"`
	// Created Whether a new account was created.
	Created bool `json:"created"`
	// GeneratedPassword The generated password, returned once so the operator
	// can share it with the user. Absent when the operator supplied the
	// password.
	GeneratedPassword *string `json:"generatedPassword,omitempty"`
}

// IdentityUsersListParams List accounts in one local knowledge base's
// launcher-managed Keycloak realm.
type IdentityUsersListParams struct {
	ApiVersion ApiVersion  `json:"apiVersion"`
	Target     LocalTarget `json:"target"`
}

// IdentityUsersListResult Accounts in the selected knowledge base's
// launcher-managed identity realm.
type IdentityUsersListResult struct {
	// Users Accounts, sorted by sign-in name.
	Users []IdentityUser `json:"users"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v IdentityUsersListResult) MarshalJSON() ([]byte, error) {
	type written IdentityUsersListResult
	v.Users = listOf(v.Users)
	return json.Marshal(written(v))
}

// Image The container image a service runs, as a registry names it:
// `ghcr.io/xynolog/xynolog-gateway:latest`.
type (
	Image = string
)

// Inference The engines a machine uses for a knowledge base: the providers it
// reaches, and the provider and model each job and each Librarian actor is
// done with. A knowledge base's repository may carry several, one for each
// provider, and a machine chooses one.
type Inference struct {
	ApiVersion StackApiVersion `json:"apiVersion"`
	Kind       InferenceKind   `json:"kind"`
	Metadata   Metadata        `json:"metadata"`
	// Spec The providers, and the engine for each job and each Librarian actor.
	Spec InferenceSpec `json:"spec"`
}

type InferenceKind string

// The values of InferenceKind.
const (
	InferenceKindInference InferenceKind = "Inference"
)

// Valid is whether e is one of InferenceKind's values.
func (e InferenceKind) Valid() bool {
	switch e {
	case InferenceKindInference:
		return true
	}
	return false
}

// InferenceLimits A provider's actual ceilings for a model, discovered from
// the provider itself (Anthropic Models API; Ollama /api/show) — never
// hand-maintained constants. Semantics differ by provider shape: Anthropic
// reports maximum input tokens in contextTokens with a separate output
// ceiling in maxOutputTokens; Ollama reports the shared input+output window
// and mirrors it into both fields (there is no separate output ceiling), so
// maxOutputTokens === contextTokens signals a shared window.
type InferenceLimits struct {
	// ContextTokens The context window in tokens. Anthropic: maximum input
	// tokens (output has its own ceiling). Ollama: the shared input+output
	// window.
	ContextTokens float64 `json:"contextTokens"`
	// MaxOutputTokens Maximum output tokens per generation. Equal to
	// contextTokens when the provider has a single shared window.
	MaxOutputTokens float64 `json:"maxOutputTokens"`
	// AcceptsTemperature Whether this engine accepts a caller-supplied sampling
	// temperature, measured against the provider (Anthropic: an active probe at
	// discovery, because some models reject the parameter outright and the
	// Models API does not say; Ollama: always true). Consumers treat only an
	// explicit false as 'hide temperature controls' — absence means no claim.
	AcceptsTemperature *bool `json:"acceptsTemperature,omitempty"`
}

// InferenceLimitsRequest Request for the inference limits of the engines one
// service holds a client for. Answered on job:limits-requested by the worker,
// and on gather:limits-requested and match:limits-requested by the librarian:
// each service that holds an inference credential reports for its own
// engines, so no other service needs one.
type InferenceLimitsRequest struct{}

// InferenceLimitsResult The inference limits one service discovered for the
// engines it holds a client for. An engine whose discovery is currently
// unavailable is absent.
type InferenceLimitsResult struct {
	Response InferenceLimitsResultResponse `json:"response"`
}

type InferenceLimitsResultResponse struct {
	Limits []EngineLimits `json:"limits"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v InferenceLimitsResultResponse) MarshalJSON() ([]byte, error) {
	type written InferenceLimitsResultResponse
	v.Limits = listOf(v.Limits)
	return json.Marshal(written(v))
}

// InferenceSpec The providers, and the engine for each job and each Librarian
// actor.
type InferenceSpec struct {
	// Providers Each provider an engine names, and how it is reached.
	Providers map[string]Provider `json:"providers"`
	// Engines The engine each job is done with when software does it, and the
	// engine each Librarian actor asks.
	Engines ArchivistEngines `json:"engines"`
}

// IssuedTokens The tokens an issuer issued at the end of a sign-in.
type IssuedTokens struct {
	// Access The access token: short-lived, sent as a Bearer token.
	Access string `json:"access"`
	// Refresh The refresh token: what renews the access token without another
	// sign-in.
	Refresh string `json:"refresh"`
}

// Issuer The issuer the launcher runs for the knowledge bases on a machine,
// with a realm for each, and the database it keeps their realms in. It
// belongs to no knowledge base, so its document is kept in the launcher's
// state home, in `stack/issuer.yaml`, not in a knowledge base's repository. A
// knowledge base trusts it by naming `shared`; one trusting somebody else's
// issuer names it at `external`.
type Issuer struct {
	ApiVersion StackApiVersion `json:"apiVersion"`
	Kind       IssuerKind      `json:"kind"`
	Metadata   Metadata        `json:"metadata"`
	// Spec The issuer, where it is published, and the database it keeps its
	// realms in.
	Spec IssuerSpec `json:"spec"`
}

type IssuerKind string

// The values of IssuerKind.
const (
	IssuerKindIssuer IssuerKind = "Issuer"
)

// Valid is whether e is one of IssuerKind's values.
func (e IssuerKind) Valid() bool {
	switch e {
	case IssuerKindIssuer:
		return true
	}
	return false
}

// IssuerSpec The issuer, where it is published, and the database it keeps its
// realms in.
type IssuerSpec struct {
	// Type The issuer's driver: `keycloak`.
	Type      string    `json:"type"`
	Image     Image     `json:"image"`
	Resources Resources `json:"resources"`
	// Port The port the issuer is published on, on this machine: the origin of
	// every realm's `iss`, so the one number wherever the issuer is reached.
	Port int `json:"port"`
	// Database The database the issuer keeps its realms in.
	Database IssuerSpecDatabase `json:"database"`
}

// IssuerSpecDatabase The database the issuer keeps its realms in.
type IssuerSpecDatabase struct {
	// Type The database's driver: `postgres`.
	Type string `json:"type"`
	// Name The database the issuer keeps its realms in: a lowercase PostgreSQL
	// identifier, as PostgreSQL itself names an unquoted one. On a PostgreSQL
	// the launcher runs, the launcher creates it; on one somebody else runs
	// (`external`), it must already exist there.
	Name string `json:"name"`
	// User The user the issuer signs in as.
	User      string     `json:"user"`
	Image     *Image     `json:"image,omitempty"`
	Resources *Resources `json:"resources,omitempty"`
	// Port The port a PostgreSQL the launcher runs is published on, on this
	// machine, where the issuer reaches it. One somebody else runs is reached at
	// `external`.
	Port *int `json:"port,omitempty"`
	// External A database somebody else runs.
	External *IssuerSpecDatabaseExternal `json:"external,omitempty"`
}

// IssuerSpecDatabaseExternal A database somebody else runs.
type IssuerSpecDatabaseExternal struct {
	// Host A host name or address the issuer can reach.
	Host string `json:"host"`
	// Port The port it listens on.
	Port     int       `json:"port"`
	Password SecretRef `json:"password"`
}

// JanusGraphConfig A graph kept in a JanusGraph server, asked in Gremlin. No
// service has been run against one.
type JanusGraphConfig struct {
	Type JanusGraphConfigType `json:"type"`
	// Host The server's host.
	Host string `json:"host"`
	// Port The port its Gremlin endpoint listens on.
	Port int `json:"port"`
}

func (JanusGraphConfig) memberOfGraphConfig()   {}
func (JanusGraphConfig) told() (string, string) { return "type", "janusgraph" }

type JanusGraphConfigType string

// The values of JanusGraphConfigType.
const (
	JanusGraphConfigTypeJanusgraph JanusGraphConfigType = "janusgraph"
)

// Valid is whether e is one of JanusGraphConfigType's values.
func (e JanusGraphConfigType) Valid() bool {
	switch e {
	case JanusGraphConfigTypeJanusgraph:
		return true
	}
	return false
}

// Job A job as the dispatcher holds it. Its `status` decides which timestamps
// and outcome fields it carries. It is what a claim returns (`job:claimed`,
// always `running`) and what the queue stores, inside a JobRecord.
type Job struct {
	union[JobMember]
}

// JobMember is a member of Job: JobPending, JobRunning, JobComplete,
// JobFailed, JobCancelled.
type JobMember interface {
	memberOfJob()
}

// Discriminator is the `status` this value states.
func (u Job) Discriminator() (string, error) { return u.stated("status") }

// Member is the member this value is: the one whose schema admits it.
func (u Job) Member() (any, error) { return u.member("Job", jobMembers) }

// jobMembers is what each member of Job admits, and how a value of it is
// read.
var jobMembers = []unionMember{
	{"JobPending", readAs[JobPending], []signature{{kind: objectKind, required: []string{"status", "metadata", "params"}, allowed: []string{"status", "metadata", "params"}, fixed: []fixedValues{{"status", []any{"pending"}}}}}},
	{"JobRunning", readAs[JobRunning], []signature{{kind: objectKind, required: []string{"status", "metadata", "params", "startedAt", "progress"}, allowed: []string{"status", "metadata", "params", "startedAt", "progress"}, fixed: []fixedValues{{"status", []any{"running"}}}}}},
	{"JobComplete", readAs[JobComplete], []signature{{kind: objectKind, required: []string{"status", "metadata", "params", "startedAt", "completedAt", "result"}, allowed: []string{"status", "metadata", "params", "startedAt", "completedAt", "result"}, fixed: []fixedValues{{"status", []any{"complete"}}}}}},
	{"JobFailed", readAs[JobFailed], []signature{{kind: objectKind, required: []string{"status", "metadata", "params", "completedAt", "error"}, allowed: []string{"status", "metadata", "params", "startedAt", "completedAt", "error", "failureClass"}, fixed: []fixedValues{{"status", []any{"failed"}}, {"failureClass", []any{"transient", "deterministic", "withheld"}}}}}},
	{"JobCancelled", readAs[JobCancelled], []signature{{kind: objectKind, required: []string{"status", "metadata", "params", "completedAt"}, allowed: []string{"status", "metadata", "params", "startedAt", "completedAt"}, fixed: []fixedValues{{"status", []any{"cancelled"}}}}}},
}

// JobAssignCommand Bus command the dispatcher emits, under its own service
// identity, immediately after it accepts a job:claim — the correlated
// job:claimed reply is unchanged. The Stower persists it as job:assigned. It
// is the one fact only the dispatcher can vouch for: which holder took which
// job, and who requested it. A later write citing `jobId` is checked against
// the holder and its `creator` derived from the requester by reading the
// resource's own log, with nothing outside the record.
type JobAssignCommand struct {
	// UserId The dispatcher's service DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId  *UserId `json:"_userId,omitempty"`
	JobId   JobId   `json:"jobId"`
	JobType JobType `json:"jobType"`
	// ResourceId The job's resource — for a generation, the source it generates
	// from. The assignment is persisted on this resource's log.
	ResourceId ResourceId `json:"resourceId"`
	// Holder DID of the claimant whose claim was accepted — the `_userId` the
	// gateway stamped on the job:claim, restated by the dispatcher.
	Holder UserId `json:"holder"`
	// Requester DID of the emitter of the job:create that produced this job —
	// the `_userId` the gateway stamped on that create, restated by the
	// dispatcher.
	Requester UserId `json:"requester"`
}

// JobAssignedPayload Payload for job:assigned — the dispatcher's own record
// that it accepted a claim. Emitted by the dispatcher under its service
// identity after a successful job:claim (the correlated job:claimed reply is
// unchanged). This is the one fact only the dispatcher can vouch for: which
// holder took which job, and who requested it. The Stower persists it beside
// job:started so that a write citing `jobId` can be checked against the
// holder and its `creator` derived from the requester with no read outside
// the event log.
type JobAssignedPayload struct {
	JobId   JobId   `json:"jobId"`
	JobType JobType `json:"jobType"`
	// ResourceId The job's resource — for a generation, the source it generates
	// from. Job events are scoped here.
	ResourceId ResourceId `json:"resourceId"`
	// Holder DID of the emitter whose claim the dispatcher accepted. The bus
	// stamped it on the job:claim as `_userId`; the dispatcher restates it here
	// under its own identity.
	Holder UserId `json:"holder"`
	// Requester DID of the emitter of the job:create that produced this job. The
	// dispatcher restates the `_userId` the gateway stamped on that create.
	Requester UserId `json:"requester"`
}

// JobCancelCommand A worker's settling of a running job it holds whose work
// it has stopped for a cancellation — the queue moves the job to cancelled/.
// Distinct from JobCancelRequest (the client→worker REQUEST to stop): this is
// the worker announcing it did, so the running job is never yanked to
// cancelled/ out from under a live worker (the roach-motel race).
type JobCancelCommand struct {
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId     *UserId    `json:"_userId,omitempty"`
	ResourceId ResourceId `json:"resourceId"`
	JobId      JobId      `json:"jobId"`
	JobType    JobType    `json:"jobType"`
	// AnnotationId Annotation this job is attached to, when applicable. Lets the
	// UI route cancellation feedback to a specific annotation.
	AnnotationId *AnnotationId `json:"annotationId,omitempty"`
	// CompletedUnits The units the worker had finished when it stopped. Recorded
	// on the cancelled job's metadata so the work already done stays visible.
	CompletedUnits *[]string `json:"completedUnits,omitempty"`
	// UnitCursors The furthest each unit begun got, keyed by unit, with what it
	// had counted there — the grain `completedUnits` cannot express. A unit
	// named in `completedUnits` is stated here too, by the cursor it ended at: a
	// later attempt skips it whole and counts it by that cursor. A cursor never
	// says a unit is finished; only `completedUnits` does. Merged monotonically
	// per unit, finished or not: a stale snapshot must never move a cursor
	// backward.
	UnitCursors *map[string]UnitCursor `json:"unitCursors,omitempty"`
}

// JobCancelRequest Request to cancel one job, named by its id. A pending job
// is cancelled immediately by the dispatcher. A running job is cancelled only
// by the worker that holds it: the worker stops its work and settles the job
// with `job:cancel` (JobCancelCommand). The queue is never made to yank a
// running job out from under a live worker.
type JobCancelRequest struct {
	JobId JobId `json:"jobId"`
}

// JobCancelResult What a cancel did, in the `response` of `job:cancel-ok`:
// whether the queue acted on the job it named. A pending job is cancelled
// outright; a running one is left to its worker, so for it true means
// accepted, not stopped.
type JobCancelResult struct {
	// Cancelled True when the queue acted on the job; false when the job is
	// unknown or already over.
	Cancelled bool `json:"cancelled"`
}

// JobCancelled A job cancelled before it concluded.
type JobCancelled struct {
	Status   JobCancelledStatus `json:"status"`
	Metadata JobMetadata        `json:"metadata"`
	Params   JobParams          `json:"params"`
	// StartedAt When its claim was made; absent when it was cancelled while
	// pending.
	StartedAt *string `json:"startedAt,omitempty"`
	// CompletedAt When it was cancelled.
	CompletedAt string `json:"completedAt"`
}

func (JobCancelled) memberOfJob()           {}
func (JobCancelled) told() (string, string) { return "status", "cancelled" }

type JobCancelledStatus string

// The values of JobCancelledStatus.
const (
	JobCancelledStatusCancelled JobCancelledStatus = "cancelled"
)

// Valid is whether e is one of JobCancelledStatus's values.
func (e JobCancelledStatus) Valid() bool {
	switch e {
	case JobCancelledStatusCancelled:
		return true
	}
	return false
}

// JobCheckpointCommand Command to persist a running job's completed-unit
// checkpoint AT unit completion. Distinct from JobFailCommand's checkpoint,
// which lands only on a clean failure: a worker that dies (crash/OOM/kill)
// never emits job:fail, so this durable, unthrottled write is what lets the
// janitor's stale-running recovery resume a dead worker's job rather than
// redo its finished units.
type JobCheckpointCommand struct {
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId *UserId `json:"_userId,omitempty"`
	JobId  JobId   `json:"jobId"`
	// CompletedUnits Entity-type units whose annotations have been fully emitted
	// so far. Unioned into the running job's metadata checkpoint; a retry after
	// recovery skips them.
	CompletedUnits []string `json:"completedUnits"`
	// UnitCursors The furthest each unit begun got, keyed by unit, with what it
	// had counted there — the grain `completedUnits` cannot express. A unit
	// named in `completedUnits` is stated here too, by the cursor it ended at: a
	// later attempt skips it whole and counts it by that cursor. A cursor never
	// says a unit is finished; only `completedUnits` does. Merged monotonically
	// per unit, finished or not: a stale snapshot must never move a cursor
	// backward.
	UnitCursors *map[string]UnitCursor `json:"unitCursors,omitempty"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v JobCheckpointCommand) MarshalJSON() ([]byte, error) {
	type written JobCheckpointCommand
	v.CompletedUnits = listOf(v.CompletedUnits)
	return json.Marshal(written(v))
}

// JobClaimCommand Claim the NEXT pending job that matches one of `accepts`
// (atomic: pending → running). A job:queued announcement is a WAKE-UP, not a
// reservation: the claimed job may differ from the announced one, and two
// claims after one announcement both succeed on different jobs instead of
// racing for one. job:claimed carries the claimed job; job:claim-failed
// reports that nothing matching is pending.
type JobClaimCommand struct {
	// Accepts The jobs this claim takes. A job is handed over when it matches
	// any one of them.
	Accepts []JobFilter `json:"accepts"`
	// UserId Authenticated claimant's DID, injected by the /bus/emit gateway.
	// Clients do not set this. The dispatcher records it as the holder on
	// job:assigned.
	UserId *UserId `json:"_userId,omitempty"`
	// Roles The claimant's capabilities (the token's `roles`), injected by the
	// /bus/emit gateway. Clients do not set this. The dispatcher authorizes the
	// claim by capability — it admits the claim only when this carries the
	// worker role — so a claimant that is not a worker for this knowledge base
	// is refused before the queue is consulted.
	Roles *[]string `json:"_roles,omitempty"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v JobClaimCommand) MarshalJSON() ([]byte, error) {
	type written JobClaimCommand
	v.Accepts = listOf(v.Accepts)
	return json.Marshal(written(v))
}

// JobClaimedResult The reply to a successful `job:claim`: the claimed job,
// now running under the claimant.
type JobClaimedResult struct {
	Response JobRunning `json:"response"`
}

// JobComplete A job its worker completed.
type JobComplete struct {
	Status   JobCompleteStatus `json:"status"`
	Metadata JobMetadata       `json:"metadata"`
	Params   JobParams         `json:"params"`
	// StartedAt When the claim that completed it was made.
	StartedAt string `json:"startedAt"`
	// CompletedAt When it completed.
	CompletedAt string          `json:"completedAt"`
	Result      JobStoredResult `json:"result"`
}

func (JobComplete) memberOfJob()           {}
func (JobComplete) told() (string, string) { return "status", "complete" }

// JobCompleteCommand A job's worker says the job is complete. The result it
// carries is its verb's: a `mark` job's counts or the resource a `yield` job
// made, or a decline from either. A completion whose result is the other
// verb's is refused where the command is admitted.
type JobCompleteCommand struct {
	union[JobCompleteCommandMember]
}

// JobCompleteCommandMember is a member of JobCompleteCommand:
// MarkJobCompleteCommand, YieldJobCompleteCommand.
type JobCompleteCommandMember interface {
	memberOfJobCompleteCommand()
}

// Discriminator is the `jobType` this value states.
func (u JobCompleteCommand) Discriminator() (string, error) { return u.stated("jobType") }

// Member is the member this value is: the one whose schema admits it.
func (u JobCompleteCommand) Member() (any, error) {
	return u.member("JobCompleteCommand", jobCompleteCommandMembers)
}

// jobCompleteCommandMembers is what each member of JobCompleteCommand admits,
// and how a value of it is read.
var jobCompleteCommandMembers = []unionMember{
	{"MarkJobCompleteCommand", readAs[MarkJobCompleteCommand], []signature{{kind: objectKind, required: []string{"resourceId", "jobId", "jobType"}, fixed: []fixedValues{{"jobType", []any{"mark"}}, {"durability", []any{"acknowledged", "probe-confirmed", "probe-refused", "probe-unreachable"}}}}}},
	{"YieldJobCompleteCommand", readAs[YieldJobCompleteCommand], []signature{{kind: objectKind, required: []string{"resourceId", "jobId", "jobType"}, fixed: []fixedValues{{"jobType", []any{"yield"}}, {"durability", []any{"acknowledged", "probe-confirmed", "probe-refused", "probe-unreachable"}}}}}},
}

type JobCompleteStatus string

// The values of JobCompleteStatus.
const (
	JobCompleteStatusComplete JobCompleteStatus = "complete"
)

// Valid is whether e is one of JobCompleteStatus's values.
func (e JobCompleteStatus) Valid() bool {
	switch e {
	case JobCompleteStatusComplete:
		return true
	}
	return false
}

// JobCompletedPayload Payload for job:completed domain event
type JobCompletedPayload struct {
	JobId   JobId   `json:"jobId"`
	JobType JobType `json:"jobType"`
	// Attempt Which attempt produced this event, 1-based (a first run is 1).
	// ALWAYS present: the queue re-runs a failed job silently, so an operator
	// reading progress or a terminal record has no other way to tell a re-run
	// from a first run — and provider spend, already counted in
	// xynolog_inference_tokens_total, cannot be attributed to a repeated
	// document without it. Stated rather than inferred from absence, because
	// 'attempt 1' is a fact the emitter always knows.
	Attempt *int `json:"attempt,omitempty"`
	// AnnotationId Annotation this job was attached to, when applicable
	AnnotationId *AnnotationId `json:"annotationId,omitempty"`
	TotalSteps   *int          `json:"totalSteps,omitempty"`
	// FoundCount For detection: total entities found
	FoundCount *int `json:"foundCount,omitempty"`
	// ResultResourceId For generation: ID of generated resource
	ResultResourceId *ResourceId `json:"resultResourceId,omitempty"`
	// AnnotationUri For generation: URI of annotation that triggered generation
	AnnotationUri *string `json:"annotationUri,omitempty"`
	// Result Full result object for extensibility
	Result     *map[string]any     `json:"result,omitempty"`
	Durability *DurabilityEvidence `json:"durability,omitempty"`
}

// JobCreateCommand Create a job. A job description is its `jobType` and
// enough parameters to be well formed: a `mark` job names its resource and,
// in its parameters, its motivation; a `yield` job names its context.
type JobCreateCommand struct {
	union[JobCreateCommandMember]
}

// JobCreateCommandMember is a member of JobCreateCommand:
// MarkJobCreateCommand, YieldJobCreateCommand.
type JobCreateCommandMember interface {
	memberOfJobCreateCommand()
}

// Discriminator is the `jobType` this value states.
func (u JobCreateCommand) Discriminator() (string, error) { return u.stated("jobType") }

// Member is the member this value is: the one whose schema admits it.
func (u JobCreateCommand) Member() (any, error) {
	return u.member("JobCreateCommand", jobCreateCommandMembers)
}

// jobCreateCommandMembers is what each member of JobCreateCommand admits, and
// how a value of it is read.
var jobCreateCommandMembers = []unionMember{
	{"MarkJobCreateCommand", readAs[MarkJobCreateCommand], []signature{{kind: objectKind, required: []string{"jobType", "resourceId", "params"}, allowed: []string{"_userId", "_roles", "jobType", "resourceId", "params"}, fixed: []fixedValues{{"jobType", []any{"mark"}}}}}},
	{"YieldJobCreateCommand", readAs[YieldJobCreateCommand], []signature{{kind: objectKind, required: []string{"jobType", "params"}, allowed: []string{"_userId", "_roles", "jobType", "params"}, fixed: []fixedValues{{"jobType", []any{"yield"}}}}}},
}

// JobCreatedResult Result of a job:create command
type JobCreatedResult struct {
	Response JobCreatedResultResponse `json:"response"`
}

type JobCreatedResultResponse struct {
	JobId JobId `json:"jobId"`
}

// JobDeclined Result of a job that completed without doing its work because
// the resource could not be read. Distinct from a failure: nothing went
// wrong, there was simply no text to work with — an encrypted or damaged PDF,
// a scan whose text could not be recognized, or a document that yielded
// nothing. The reasons are the extraction vocabulary the Smelter reports on
// `smelt:settled`, MINUS `no-extractor`: a media type that can never yield
// text (a zip, an image) is a bad request rather than a decline, so a worker
// asked to detect over one throws and the job reports `job:fail`. Everything
// here is a resource-specific outcome — the same media type would have
// succeeded on a different document.
type JobDeclined struct {
	// Declined Always true. It is what tells a decline from the result of a job
	// that did its work, which never carries it.
	Declined JobDeclinedDeclined `json:"declined"`
	// Reason Why the resource could not be read. A CODE, not a sentence: the
	// client owns the wording, so a browser renders it in the user's language
	// and the CLI renders English terminal copy from the same value. A prose
	// `message` composed server-side would be English everywhere.
	Reason JobDeclinedReason `json:"reason"`
}

func (JobDeclined) memberOfJobResult()      {}
func (JobDeclined) memberOfMarkJobResult()  {}
func (JobDeclined) memberOfYieldJobResult() {}

// JobDeclinedDeclined Always true. It is what tells a decline from the result
// of a job that did its work, which never carries it.
type JobDeclinedDeclined bool

// The values of JobDeclinedDeclined.
const (
	JobDeclinedDeclinedTrue JobDeclinedDeclined = true
)

// Valid is whether e is one of JobDeclinedDeclined's values.
func (e JobDeclinedDeclined) Valid() bool {
	switch e {
	case JobDeclinedDeclinedTrue:
		return true
	}
	return false
}

// JobDeclinedReason Why the resource could not be read. A CODE, not a
// sentence: the client owns the wording, so a browser renders it in the
// user's language and the CLI renders English terminal copy from the same
// value. A prose `message` composed server-side would be English everywhere.
type JobDeclinedReason string

// The values of JobDeclinedReason.
const (
	JobDeclinedReasonNoTextLayer JobDeclinedReason = "no-text-layer"
	JobDeclinedReasonEncrypted   JobDeclinedReason = "encrypted"
	JobDeclinedReasonCorrupt     JobDeclinedReason = "corrupt"
	JobDeclinedReasonTooLarge    JobDeclinedReason = "too-large"
	JobDeclinedReasonEmpty       JobDeclinedReason = "empty"
)

// Valid is whether e is one of JobDeclinedReason's values.
func (e JobDeclinedReason) Valid() bool {
	switch e {
	case JobDeclinedReasonNoTextLayer, JobDeclinedReasonEncrypted, JobDeclinedReasonCorrupt, JobDeclinedReasonTooLarge, JobDeclinedReasonEmpty:
		return true
	}
	return false
}

// JobFailCommand Command to mark a job as failed
type JobFailCommand struct {
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId     *UserId    `json:"_userId,omitempty"`
	ResourceId ResourceId `json:"resourceId"`
	JobId      JobId      `json:"jobId"`
	JobType    JobType    `json:"jobType"`
	// Attempt Which attempt produced this event, 1-based (a first run is 1).
	// ALWAYS present: the queue re-runs a failed job silently, so an operator
	// reading progress or a terminal record has no other way to tell a re-run
	// from a first run — and provider spend, already counted in
	// xynolog_inference_tokens_total, cannot be attributed to a repeated
	// document without it. Stated rather than inferred from absence, because
	// 'attempt 1' is a fact the emitter always knows.
	Attempt *int `json:"attempt,omitempty"`
	// AnnotationId Annotation this job is attached to, when applicable. Lets the
	// UI route failure feedback (error toast, revert state) to a specific
	// annotation.
	AnnotationId *AnnotationId `json:"annotationId,omitempty"`
	Error        string        `json:"error"`
	// CompletedUnits Entity-type units whose annotations were fully emitted
	// before this failure (checkpointed resume). The queue records them on the
	// retried job's metadata; a retried claim skips them so completed work is
	// neither redone nor duplicated.
	CompletedUnits *[]string `json:"completedUnits,omitempty"`
	// UnitCursors The furthest each unit begun got, keyed by unit, with what it
	// had counted there — the grain `completedUnits` cannot express. A unit
	// named in `completedUnits` is stated here too, by the cursor it ended at: a
	// later attempt skips it whole and counts it by that cursor. A cursor never
	// says a unit is finished; only `completedUnits` does. Merged monotonically
	// per unit, finished or not: a stale snapshot must never move a cursor
	// backward.
	UnitCursors  *map[string]UnitCursor `json:"unitCursors,omitempty"`
	FailureClass *FailureClass          `json:"failureClass,omitempty"`
	// WillRetry Whether the queue will re-queue this job for another attempt.
	// Computed by the worker from the SAME rule the queue applies when it takes
	// the failure (specs/src/jobs/retry-cases.json, which every SDK and the
	// dispatcher run) using the retry budget carried on the claimed record.
	// FALSE (or absent) means this failure is TERMINAL: a client's job-watch
	// stream ends here. TRUE means the work continues on a fresh attempt — the
	// failure is an event, not the end, and a stream that terminated on it would
	// report a recovering run as a failed one.
	WillRetry  *bool               `json:"willRetry,omitempty"`
	Durability *DurabilityEvidence `json:"durability,omitempty"`
}

// JobFailed A job that failed and will not be retried.
type JobFailed struct {
	Status   JobFailedStatus `json:"status"`
	Metadata JobMetadata     `json:"metadata"`
	Params   JobParams       `json:"params"`
	// StartedAt When the last claim was made; absent when it failed without one.
	StartedAt *string `json:"startedAt,omitempty"`
	// CompletedAt When it failed.
	CompletedAt string `json:"completedAt"`
	// Error The failure's message.
	Error        string        `json:"error"`
	FailureClass *FailureClass `json:"failureClass,omitempty"`
}

func (JobFailed) memberOfJob()           {}
func (JobFailed) told() (string, string) { return "status", "failed" }

// JobFailedPayload Payload for the job:failed domain event — a permanent fact
// of the resource, not operational state. It carries the judgments the worker
// COMPUTED, not just its message: at the log they are otherwise
// unrecoverable, the only remaining witness being a flattened English string.
type JobFailedPayload struct {
	JobId   JobId   `json:"jobId"`
	JobType JobType `json:"jobType"`
	// Attempt Which attempt produced this event, 1-based (a first run is 1).
	// ALWAYS present: the queue re-runs a failed job silently, so an operator
	// reading progress or a terminal record has no other way to tell a re-run
	// from a first run — and provider spend, already counted in
	// xynolog_inference_tokens_total, cannot be attributed to a repeated
	// document without it. Stated rather than inferred from absence, because
	// 'attempt 1' is a fact the emitter always knows.
	Attempt *int `json:"attempt,omitempty"`
	// AnnotationId Annotation this job was attached to, when applicable
	AnnotationId *AnnotationId `json:"annotationId,omitempty"`
	Error        string        `json:"error"`
	FailureClass *FailureClass `json:"failureClass,omitempty"`
	// WillRetry Whether the worker computed that the queue would re-queue this
	// job (same predicate the queue applies, `willRetryAfter`). Absent means the
	// worker stated nothing. Without it a reader of the log cannot tell a run
	// recovering across several job:failed events from that many dead jobs.
	WillRetry  *bool               `json:"willRetry,omitempty"`
	Durability *DurabilityEvidence `json:"durability,omitempty"`
}

type JobFailedStatus string

// The values of JobFailedStatus.
const (
	JobFailedStatusFailed JobFailedStatus = "failed"
)

// Valid is whether e is one of JobFailedStatus's values.
func (e JobFailedStatus) Valid() bool {
	switch e {
	case JobFailedStatusFailed:
		return true
	}
	return false
}

// JobFilter Some jobs, named by fields of the job description: a partial
// description, at the description's own paths. A job matches when every field
// stated here equals the job's. A `mark` filter always states its motivation.
type JobFilter struct {
	union[JobFilterMember]
}

// JobFilterMember is a member of JobFilter: MarkJobFilter, YieldJobFilter.
type JobFilterMember interface {
	memberOfJobFilter()
}

// Discriminator is the `jobType` this value states.
func (u JobFilter) Discriminator() (string, error) { return u.stated("jobType") }

// Member is the member this value is: the one whose schema admits it.
func (u JobFilter) Member() (any, error) { return u.member("JobFilter", jobFilterMembers) }

// jobFilterMembers is what each member of JobFilter admits, and how a value
// of it is read.
var jobFilterMembers = []unionMember{
	{"MarkJobFilter", readAs[MarkJobFilter], []signature{{kind: objectKind, required: []string{"jobType", "params"}, allowed: []string{"jobType", "params"}, fixed: []fixedValues{{"jobType", []any{"mark"}}}}}},
	{"YieldJobFilter", readAs[YieldJobFilter], []signature{{kind: objectKind, required: []string{"jobType"}, allowed: []string{"jobType"}, fixed: []fixedValues{{"jobType", []any{"yield"}}}}}},
}

// JobMetadata What the dispatcher records about a job beside its parameters.
// `completedUnits` and `unitCursors` appear once a worker has checkpointed.
// `retryCount` counts the times the queue has put the job back to pending
// after a failure it classes as transient.
type JobMetadata struct {
	// Id The job's id: `job-` followed by a version 4 UUID written as 32
	// lowercase hex digits, without dashes.
	Id   JobId   `json:"id"`
	Type JobType `json:"type"`
	// UserId The DID of the principal whose `job:create` created the job.
	UserId UserId `json:"userId"`
	// Created When the job was created, as an ISO 8601 timestamp.
	Created    string `json:"created"`
	RetryCount int    `json:"retryCount"`
	// MaxRetries How many transient failures the queue retries: 0 for
	// generation, whose re-run produces different content; 1 for every other
	// type.
	MaxRetries int `json:"maxRetries"`
	// CompletedUnits The units a worker has finished, merged across checkpoints
	// and failures as a set.
	CompletedUnits *[]string `json:"completedUnits,omitempty"`
	// UnitCursors The furthest each unit begun got, keyed by unit, with what it
	// had counted there. A finished unit keeps its cursor: where it ended, and
	// its final counts.
	UnitCursors *map[string]UnitCursor `json:"unitCursors,omitempty"`
}

// JobParams A job's parameters as the Dispatcher holds them: the `params` of
// its `job:create`, and what the Dispatcher adds. It adds `resourceId`, the
// resource the job is about: a `mark` job's own, and for a `yield` job the
// one its context focuses on. For a tagging job it adds `schema`, the tag
// schema its `schemaId` names, so that whoever holds the job needs no
// registry. Nothing the caller sent is changed or removed.
type JobParams struct {
	ResourceId ResourceId `json:"resourceId"`
	// Schema The tag schema a tagging job's `schemaId` names, as the knowledge
	// base registered it when the job was created. On a tagging job, and on no
	// other.
	Schema *TagSchema `json:"schema,omitempty"`
	// AdditionalProperties is every member the schema does not name, as it came.
	AdditionalProperties map[string]any `json:"-"`
}

// MarshalJSON writes v with the members its schema does not name, and each
// list its schema requires that Go holds as nil as the empty list.
func (v JobParams) MarshalJSON() ([]byte, error) {
	type written JobParams
	return writeOpen(written(v), v.AdditionalProperties)
}

// UnmarshalJSON reads v, and each member its schema does not name into its
// AdditionalProperties.
func (v *JobParams) UnmarshalJSON(raw []byte) error {
	type read JobParams
	return readOpen(raw, (*read)(v), &v.AdditionalProperties)
}

// JobPending A job waiting for a worker to claim it.
type JobPending struct {
	Status   JobPendingStatus `json:"status"`
	Metadata JobMetadata      `json:"metadata"`
	Params   JobParams        `json:"params"`
}

func (JobPending) memberOfJob()           {}
func (JobPending) told() (string, string) { return "status", "pending" }

type JobPendingStatus string

// The values of JobPendingStatus.
const (
	JobPendingStatusPending JobPendingStatus = "pending"
)

// Valid is whether e is one of JobPendingStatus's values.
func (e JobPendingStatus) Valid() bool {
	switch e {
	case JobPendingStatusPending:
		return true
	}
	return false
}

// JobPollOptions How a job's `pollUntilComplete` asks for the job's status:
// how long it waits between its asks, and how long it goes on asking. A
// member left out is client/timing.json's: `jobPollMs` and
// `jobPollTimeoutMs`.
type JobPollOptions struct {
	// EveryMs How long it waits between one ask and the next, in milliseconds.
	EveryMs *int `json:"everyMs,omitempty"`
	// WithinMs How long it goes on asking, from its first ask, before it fails
	// as timed out, in milliseconds.
	WithinMs *int `json:"withinMs,omitempty"`
}

// JobProgress Progress report from a running job. The required field is
// `percentage`; `message` carries the coded phase and the rest are optional
// job-shape fields. This is the single progress shape for every job type —
// annotation workers and generation alike. Terminality is signalled on
// `job:complete` / `job:fail`, not here. A flow that iterates a user-chosen
// list (entity types for references, categories for tags) reports its
// position as one `current`/`processed`/`total` triple, the same shape for
// both, so a client never needs to know which flow it is drawing.
type JobProgress struct {
	// Percentage Completion percentage (0-100)
	Percentage float64 `json:"percentage"`
	// Message What the job is doing right now, as a code plus typed params; the
	// client renders the sentence. Optional: pure percentage heartbeats carry
	// none, and consumers render nothing message-shaped when it is absent.
	Message *JobProgressMessage `json:"message,omitempty"`
	// AnnotationId Annotation this job is attached to, when applicable. Echoed
	// inside JobProgress (in addition to the outer command envelope) so
	// consumers that only see the inner progress object (e.g. what
	// `yield.delegate` returns) can still route visual feedback to a specific
	// annotation.
	AnnotationId *AnnotationId `json:"annotationId,omitempty"`
	// Current What the run is working on right now. `kind` is a CODE the client
	// renders a localized name for; `value` is KB data (an entity type, a tag
	// category) shown verbatim — the same split as `requestParams`. Absent on
	// flows that iterate nothing, such as generation.
	Current *JobProgressCurrent `json:"current,omitempty"`
	// Processed Items completed so far, zero-based — the item in `current` is
	// the one after these. Paired with `total`.
	Processed *int `json:"processed,omitempty"`
	// Total Items this run will process in all.
	Total *int `json:"total,omitempty"`
	// EntitiesFound Entities found so far (a linking job)
	EntitiesFound *int `json:"entitiesFound,omitempty"`
	// EntitiesExpected Cumulative mentions the count-verifier priced across the
	// pieces accepted so far — the denominator for a real progress bar (found of
	// ~expected). Approximate by nature (the count saturates on very large
	// pieces) and monotonically growing within a run. ABSENT when the provider
	// does not verify detection yield, or before any piece has been priced: no
	// claim, never zero.
	EntitiesExpected *int `json:"entitiesExpected,omitempty"`
	// EntitiesEmitted Annotations emitted so far (a linking job)
	EntitiesEmitted *int `json:"entitiesEmitted,omitempty"`
	// CompletedItems Per-item results for the items already finished, for the
	// UI's completed log. Generic across flows for the same reason `current` is.
	CompletedItems *[]JobProgressCompletedItemsItem `json:"completedItems,omitempty"`
	// RequestParams Echoed job parameters for display in the progress UI.
	// `label` is a CODE, not a sentence — the client owns the wording, same rule
	// as the progress message. `value` is the user's own input (an entity-type
	// list, their instructions) and is deliberately NOT translated: it is their
	// words, not ours.
	RequestParams *[]JobProgressRequestParamsItem `json:"requestParams,omitempty"`
}

func (JobProgress) memberOfJobStoredProgress() {}

// JobProgressAnalyzing Analyzing the content.
type JobProgressAnalyzing struct {
	Code JobProgressAnalyzingCode `json:"code"`
}

func (JobProgressAnalyzing) memberOfJobProgressMessage() {}
func (JobProgressAnalyzing) told() (string, string)      { return "code", "analyzing" }

type JobProgressAnalyzingCode string

// The values of JobProgressAnalyzingCode.
const (
	JobProgressAnalyzingCodeAnalyzing JobProgressAnalyzingCode = "analyzing"
)

// Valid is whether e is one of JobProgressAnalyzingCode's values.
func (e JobProgressAnalyzingCode) Valid() bool {
	switch e {
	case JobProgressAnalyzingCodeAnalyzing:
		return true
	}
	return false
}

// JobProgressAnalyzingTags Analyzing the content against the tag schema.
type JobProgressAnalyzingTags struct {
	Code JobProgressAnalyzingTagsCode `json:"code"`
}

func (JobProgressAnalyzingTags) memberOfJobProgressMessage() {}
func (JobProgressAnalyzingTags) told() (string, string)      { return "code", "analyzing-tags" }

type JobProgressAnalyzingTagsCode string

// The values of JobProgressAnalyzingTagsCode.
const (
	JobProgressAnalyzingTagsCodeAnalyzingTags JobProgressAnalyzingTagsCode = "analyzing-tags"
)

// Valid is whether e is one of JobProgressAnalyzingTagsCode's values.
func (e JobProgressAnalyzingTagsCode) Valid() bool {
	switch e {
	case JobProgressAnalyzingTagsCodeAnalyzingTags:
		return true
	}
	return false
}

// JobProgressCompleteCreated Terminal success summary.
type JobProgressCompleteCreated struct {
	Code JobProgressCompleteCreatedCode `json:"code"`
	// Count How many annotations were created
	Count int `json:"count"`
	// Motivation The motivation of the job, and so of what it created. A client
	// words it in its own language.
	Motivation Motivation `json:"motivation"`
}

func (JobProgressCompleteCreated) memberOfJobProgressMessage() {}
func (JobProgressCompleteCreated) told() (string, string)      { return "code", "complete-created" }

type JobProgressCompleteCreatedCode string

// The values of JobProgressCompleteCreatedCode.
const (
	JobProgressCompleteCreatedCodeCompleteCreated JobProgressCompleteCreatedCode = "complete-created"
)

// Valid is whether e is one of JobProgressCompleteCreatedCode's values.
func (e JobProgressCompleteCreatedCode) Valid() bool {
	switch e {
	case JobProgressCompleteCreatedCodeCompleteCreated:
		return true
	}
	return false
}

// JobProgressCompleteGenerated Generation's terminal success. Deliberately
// generic — the client already holds the title it typed, and the outcome
// (name + resource link) travels on job:complete, not on progress.
// `truncated` qualifies the completion: the same bit `YieldJobDone.truncated`
// carries, so the two surfaces cannot drift.
type JobProgressCompleteGenerated struct {
	Code JobProgressCompleteGeneratedCode `json:"code"`
	// Truncated True when the model stopped at the maxTokens ceiling — the
	// artifact is cut off, not complete.
	Truncated bool `json:"truncated"`
}

func (JobProgressCompleteGenerated) memberOfJobProgressMessage() {}
func (JobProgressCompleteGenerated) told() (string, string)      { return "code", "complete-generated" }

type JobProgressCompleteGeneratedCode string

// The values of JobProgressCompleteGeneratedCode.
const (
	JobProgressCompleteGeneratedCodeCompleteGenerated JobProgressCompleteGeneratedCode = "complete-generated"
)

// Valid is whether e is one of JobProgressCompleteGeneratedCode's values.
func (e JobProgressCompleteGeneratedCode) Valid() bool {
	switch e {
	case JobProgressCompleteGeneratedCodeCompleteGenerated:
		return true
	}
	return false
}

type JobProgressCompletedItemsItem struct {
	// Value The item, shown verbatim.
	Value string `json:"value"`
	// FoundCount Annotations found for it.
	FoundCount int `json:"foundCount"`
	// PersistedCount Annotations actually persisted for it — post-dedupe and
	// post-durability-acknowledgement, so it counts what the event log holds,
	// not what the model proposed. Beside foundCount this is the per-unit yield
	// the sizing work is judged by. Present on flows whose units persist as they
	// complete (a linking job); the tagging flow reports the same fact as
	// byCategory on its result, because its annotations are built after the
	// per-category loop.
	PersistedCount *int `json:"persistedCount,omitempty"`
	// UnderReported Present only when pieces of this unit were accepted at the
	// subdivision floor while a count call said more was present. The unit
	// completed, but incompletely — this carries the EVIDENCE (found vs counted,
	// over how many pieces), never a judgment against any expected yield. Absent
	// means complete: genuinely absent, not defaulted.
	UnderReported *JobProgressCompletedItemsItemUnderReported `json:"underReported,omitempty"`
}

// JobProgressCompletedItemsItemUnderReported Present only when pieces of this
// unit were accepted at the subdivision floor while a count call said more
// was present. The unit completed, but incompletely — this carries the
// EVIDENCE (found vs counted, over how many pieces), never a judgment against
// any expected yield. Absent means complete: genuinely absent, not defaulted.
type JobProgressCompletedItemsItemUnderReported struct {
	// Pieces Floor-accepted pieces in this unit.
	Pieces int `json:"pieces"`
	// Found Annotations extraction did find on those pieces — every span
	// write-time-verified.
	Found int `json:"found"`
	// Counted Mentions the count calls reported across those pieces (approximate
	// by nature).
	Counted int `json:"counted"`
}

// JobProgressCreatingAnnotations Writing detected annotations back to the
// resource.
type JobProgressCreatingAnnotations struct {
	Code JobProgressCreatingAnnotationsCode `json:"code"`
	// Count How many annotations are being created
	Count int `json:"count"`
}

func (JobProgressCreatingAnnotations) memberOfJobProgressMessage() {}
func (JobProgressCreatingAnnotations) told() (string, string)      { return "code", "creating-annotations" }

type JobProgressCreatingAnnotationsCode string

// The values of JobProgressCreatingAnnotationsCode.
const (
	JobProgressCreatingAnnotationsCodeCreatingAnnotations JobProgressCreatingAnnotationsCode = "creating-annotations"
)

// Valid is whether e is one of JobProgressCreatingAnnotationsCode's values.
func (e JobProgressCreatingAnnotationsCode) Valid() bool {
	switch e {
	case JobProgressCreatingAnnotationsCodeCreatingAnnotations:
		return true
	}
	return false
}

// JobProgressCreatingResource Writing the generated resource.
type JobProgressCreatingResource struct {
	Code JobProgressCreatingResourceCode `json:"code"`
}

func (JobProgressCreatingResource) memberOfJobProgressMessage() {}
func (JobProgressCreatingResource) told() (string, string)      { return "code", "creating-resource" }

type JobProgressCreatingResourceCode string

// The values of JobProgressCreatingResourceCode.
const (
	JobProgressCreatingResourceCodeCreatingResource JobProgressCreatingResourceCode = "creating-resource"
)

// Valid is whether e is one of JobProgressCreatingResourceCode's values.
func (e JobProgressCreatingResourceCode) Valid() bool {
	switch e {
	case JobProgressCreatingResourceCodeCreatingResource:
		return true
	}
	return false
}

// JobProgressCreatingTagAnnotations Writing detected tag annotations back to
// the resource.
type JobProgressCreatingTagAnnotations struct {
	Code JobProgressCreatingTagAnnotationsCode `json:"code"`
	// Count How many annotations are being created
	Count int `json:"count"`
}

func (JobProgressCreatingTagAnnotations) memberOfJobProgressMessage() {}
func (JobProgressCreatingTagAnnotations) told() (string, string) {
	return "code", "creating-tag-annotations"
}

type JobProgressCreatingTagAnnotationsCode string

// The values of JobProgressCreatingTagAnnotationsCode.
const (
	JobProgressCreatingTagAnnotationsCodeCreatingTagAnnotations JobProgressCreatingTagAnnotationsCode = "creating-tag-annotations"
)

// Valid is whether e is one of JobProgressCreatingTagAnnotationsCode's
// values.
func (e JobProgressCreatingTagAnnotationsCode) Valid() bool {
	switch e {
	case JobProgressCreatingTagAnnotationsCodeCreatingTagAnnotations:
		return true
	}
	return false
}

// JobProgressCurrent What the run is working on right now. `kind` is a CODE
// the client renders a localized name for; `value` is KB data (an entity
// type, a tag category) shown verbatim — the same split as `requestParams`.
// Absent on flows that iterate nothing, such as generation.
type JobProgressCurrent struct {
	// Kind What sort of thing `value` is. Adding a variant means adding client
	// copy for it in every locale.
	Kind JobProgressCurrentKind `json:"kind"`
	// Value The item itself, shown verbatim and never translated.
	Value string `json:"value"`
}

// JobProgressCurrentKind What sort of thing `value` is. Adding a variant
// means adding client copy for it in every locale.
type JobProgressCurrentKind string

// The values of JobProgressCurrentKind.
const (
	JobProgressCurrentKindEntityType JobProgressCurrentKind = "entity-type"
	JobProgressCurrentKindCategory   JobProgressCurrentKind = "category"
)

// Valid is whether e is one of JobProgressCurrentKind's values.
func (e JobProgressCurrentKind) Valid() bool {
	switch e {
	case JobProgressCurrentKindEntityType, JobProgressCurrentKindCategory:
		return true
	}
	return false
}

// JobProgressDetectingEntities Entity detection, one entity type at a time.
type JobProgressDetectingEntities struct {
	Code JobProgressDetectingEntitiesCode `json:"code"`
	// EntityType Entity type currently being detected
	EntityType string `json:"entityType"`
}

func (JobProgressDetectingEntities) memberOfJobProgressMessage() {}
func (JobProgressDetectingEntities) told() (string, string)      { return "code", "detecting-entities" }

type JobProgressDetectingEntitiesCode string

// The values of JobProgressDetectingEntitiesCode.
const (
	JobProgressDetectingEntitiesCodeDetectingEntities JobProgressDetectingEntitiesCode = "detecting-entities"
)

// Valid is whether e is one of JobProgressDetectingEntitiesCode's values.
func (e JobProgressDetectingEntitiesCode) Valid() bool {
	switch e {
	case JobProgressDetectingEntitiesCodeDetectingEntities:
		return true
	}
	return false
}

// JobProgressGeneratingResource The model is generating the resource.
type JobProgressGeneratingResource struct {
	Code JobProgressGeneratingResourceCode `json:"code"`
}

func (JobProgressGeneratingResource) memberOfJobProgressMessage() {}
func (JobProgressGeneratingResource) told() (string, string)      { return "code", "generating-resource" }

type JobProgressGeneratingResourceCode string

// The values of JobProgressGeneratingResourceCode.
const (
	JobProgressGeneratingResourceCodeGeneratingResource JobProgressGeneratingResourceCode = "generating-resource"
)

// Valid is whether e is one of JobProgressGeneratingResourceCode's values.
func (e JobProgressGeneratingResourceCode) Valid() bool {
	switch e {
	case JobProgressGeneratingResourceCodeGeneratingResource:
		return true
	}
	return false
}

// JobProgressLoading Loading the resource content.
type JobProgressLoading struct {
	Code JobProgressLoadingCode `json:"code"`
}

func (JobProgressLoading) memberOfJobProgressMessage() {}
func (JobProgressLoading) told() (string, string)      { return "code", "loading" }

type JobProgressLoadingCode string

// The values of JobProgressLoadingCode.
const (
	JobProgressLoadingCodeLoading JobProgressLoadingCode = "loading"
)

// Valid is whether e is one of JobProgressLoadingCode's values.
func (e JobProgressLoadingCode) Valid() bool {
	switch e {
	case JobProgressLoadingCodeLoading:
		return true
	}
	return false
}

// JobProgressMessage What a running job is doing right now, as a code plus
// typed params — never a prose sentence. The producer reports what happened;
// each client renders it in the user's language (react-ui from its
// translations, the Go launcher from its English map). One named schema per
// code, discriminated on `code`, so generated clients get typed variants and
// copy-map completeness is statically checkable. The vocabulary is every
// report Xynolog's worker makes (contract/WORKER-SERVICE.md, D16 to D19 and
// Y8); extending it means adding a named variant here and copy in every
// client, gated by the locale-completeness check.
type JobProgressMessage struct {
	union[JobProgressMessageMember]
}

// JobProgressMessageMember is a member of JobProgressMessage:
// JobProgressLoading, JobProgressAnalyzing, JobProgressAnalyzingTags,
// JobProgressGeneratingResource, JobProgressCreatingResource,
// JobProgressCompleteGenerated, JobProgressDetectingEntities,
// JobProgressCreatingAnnotations, JobProgressCreatingTagAnnotations,
// JobProgressCompleteCreated.
type JobProgressMessageMember interface {
	memberOfJobProgressMessage()
}

// Discriminator is the `code` this value states.
func (u JobProgressMessage) Discriminator() (string, error) { return u.stated("code") }

// Member is the member this value is: the one whose schema admits it.
func (u JobProgressMessage) Member() (any, error) {
	return u.member("JobProgressMessage", jobProgressMessageMembers)
}

// jobProgressMessageMembers is what each member of JobProgressMessage admits,
// and how a value of it is read.
var jobProgressMessageMembers = []unionMember{
	{"JobProgressLoading", readAs[JobProgressLoading], []signature{{kind: objectKind, required: []string{"code"}, fixed: []fixedValues{{"code", []any{"loading"}}}}}},
	{"JobProgressAnalyzing", readAs[JobProgressAnalyzing], []signature{{kind: objectKind, required: []string{"code"}, fixed: []fixedValues{{"code", []any{"analyzing"}}}}}},
	{"JobProgressAnalyzingTags", readAs[JobProgressAnalyzingTags], []signature{{kind: objectKind, required: []string{"code"}, fixed: []fixedValues{{"code", []any{"analyzing-tags"}}}}}},
	{"JobProgressGeneratingResource", readAs[JobProgressGeneratingResource], []signature{{kind: objectKind, required: []string{"code"}, fixed: []fixedValues{{"code", []any{"generating-resource"}}}}}},
	{"JobProgressCreatingResource", readAs[JobProgressCreatingResource], []signature{{kind: objectKind, required: []string{"code"}, fixed: []fixedValues{{"code", []any{"creating-resource"}}}}}},
	{"JobProgressCompleteGenerated", readAs[JobProgressCompleteGenerated], []signature{{kind: objectKind, required: []string{"code", "truncated"}, fixed: []fixedValues{{"code", []any{"complete-generated"}}}}}},
	{"JobProgressDetectingEntities", readAs[JobProgressDetectingEntities], []signature{{kind: objectKind, required: []string{"code", "entityType"}, fixed: []fixedValues{{"code", []any{"detecting-entities"}}}}}},
	{"JobProgressCreatingAnnotations", readAs[JobProgressCreatingAnnotations], []signature{{kind: objectKind, required: []string{"code", "count"}, fixed: []fixedValues{{"code", []any{"creating-annotations"}}}}}},
	{"JobProgressCreatingTagAnnotations", readAs[JobProgressCreatingTagAnnotations], []signature{{kind: objectKind, required: []string{"code", "count"}, fixed: []fixedValues{{"code", []any{"creating-tag-annotations"}}}}}},
	{"JobProgressCompleteCreated", readAs[JobProgressCompleteCreated], []signature{{kind: objectKind, required: []string{"code", "count", "motivation"}, fixed: []fixedValues{{"code", []any{"complete-created"}}, {"motivation", []any{"assessing", "commenting", "highlighting", "linking", "tagging"}}}}}},
}

type JobProgressRequestParamsItem struct {
	// Label Which parameter this is. The client renders a localized name for it.
	Label JobProgressRequestParamsItemLabel `json:"label"`
	// Value The user's own input, shown verbatim.
	Value string `json:"value"`
}

// JobProgressRequestParamsItemLabel Which parameter this is. The client
// renders a localized name for it.
type JobProgressRequestParamsItemLabel string

// The values of JobProgressRequestParamsItemLabel.
const (
	JobProgressRequestParamsItemLabelEntityTypes  JobProgressRequestParamsItemLabel = "entity-types"
	JobProgressRequestParamsItemLabelInstructions JobProgressRequestParamsItemLabel = "instructions"
	JobProgressRequestParamsItemLabelTone         JobProgressRequestParamsItemLabel = "tone"
	JobProgressRequestParamsItemLabelDensity      JobProgressRequestParamsItemLabel = "density"
)

// Valid is whether e is one of JobProgressRequestParamsItemLabel's values.
func (e JobProgressRequestParamsItemLabel) Valid() bool {
	switch e {
	case JobProgressRequestParamsItemLabelEntityTypes, JobProgressRequestParamsItemLabelInstructions, JobProgressRequestParamsItemLabelTone, JobProgressRequestParamsItemLabelDensity:
		return true
	}
	return false
}

// JobQueuedEvent A pending job, announced when it is created and again at
// each tick while it waits. It carries the job description less the job's
// input, so that a party deciding whether to claim reads here what its claim
// would be matched against. It is a wake-up and not an offer of this job: a
// claim is answered with the next pending job it matches.
type JobQueuedEvent struct {
	union[JobQueuedEventMember]
}

// JobQueuedEventMember is a member of JobQueuedEvent: MarkJobQueuedEvent,
// YieldJobQueuedEvent.
type JobQueuedEventMember interface {
	memberOfJobQueuedEvent()
}

// Discriminator is the `jobType` this value states.
func (u JobQueuedEvent) Discriminator() (string, error) { return u.stated("jobType") }

// Member is the member this value is: the one whose schema admits it.
func (u JobQueuedEvent) Member() (any, error) {
	return u.member("JobQueuedEvent", jobQueuedEventMembers)
}

// jobQueuedEventMembers is what each member of JobQueuedEvent admits, and how
// a value of it is read.
var jobQueuedEventMembers = []unionMember{
	{"MarkJobQueuedEvent", readAs[MarkJobQueuedEvent], []signature{{kind: objectKind, required: []string{"jobId", "jobType", "resourceId", "userId", "params"}, fixed: []fixedValues{{"jobType", []any{"mark"}}}}}},
	{"YieldJobQueuedEvent", readAs[YieldJobQueuedEvent], []signature{{kind: objectKind, required: []string{"jobId", "jobType", "resourceId", "userId", "params"}, fixed: []fixedValues{{"jobType", []any{"yield"}}}}}},
}

// JobRecord One job as the queue stores it: the job, and when it last showed
// life. The dead-worker sweep reads `lastProgressAt`: a running job whose
// worker has reported nothing for the configured interval is presumed dead.
// Where the queue keeps these records is the job storage layout,
// specs/src/jobs/storage.json.
type JobRecord struct {
	Job Job `json:"job"`
	// LastProgressAt When the job was created, claimed, checkpointed or last
	// reported progress, as an ISO 8601 timestamp.
	LastProgressAt string `json:"lastProgressAt"`
}

// JobReportProgressCommand Command to report progress on a job
type JobReportProgressCommand struct {
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId     *UserId    `json:"_userId,omitempty"`
	ResourceId ResourceId `json:"resourceId"`
	JobId      JobId      `json:"jobId"`
	JobType    JobType    `json:"jobType"`
	// Attempt Which attempt produced this event, 1-based (a first run is 1).
	// ALWAYS present: the queue re-runs a failed job silently, so an operator
	// reading progress or a terminal record has no other way to tell a re-run
	// from a first run — and provider spend, already counted in
	// xynolog_inference_tokens_total, cannot be attributed to a repeated
	// document without it. Stated rather than inferred from absence, because
	// 'attempt 1' is a fact the emitter always knows.
	Attempt *int `json:"attempt,omitempty"`
	// AnnotationId Annotation this job is attached to, when applicable. Lets the
	// UI attach progress visuals to a specific annotation (e.g. a reference
	// whose generation is running).
	AnnotationId *AnnotationId `json:"annotationId,omitempty"`
	Percentage   float64       `json:"percentage"`
	Progress     *JobProgress  `json:"progress,omitempty"`
}

// JobResult What a job reports when it concludes without failing: a `mark`
// job's counts, the resource a `yield` job made, or a decline from either. A
// result has no discriminant of its own: the job description beside it says
// which job it answers, and the three share no member, so each is told from
// the others by what it alone carries.
type JobResult struct {
	union[JobResultMember]
}

// JobResultMember is a member of JobResult: MarkJobDone, YieldJobDone,
// JobDeclined.
type JobResultMember interface {
	memberOfJobResult()
}

// Member is the member this value is: the one whose schema admits it.
func (u JobResult) Member() (any, error) { return u.member("JobResult", jobResultMembers) }

// jobResultMembers is what each member of JobResult admits, and how a value
// of it is read.
var jobResultMembers = []unionMember{
	{"MarkJobDone", readAs[MarkJobDone], []signature{{kind: objectKind, required: []string{"found", "persisted"}, allowed: []string{"found", "persisted", "errors", "byCategory", "underReportedPieces", "uncheckedPieces"}}}},
	{"YieldJobDone", readAs[YieldJobDone], []signature{{kind: objectKind, required: []string{"resourceId", "resourceName", "truncated"}, allowed: []string{"resourceId", "resourceName", "truncated"}}}},
	{"JobDeclined", readAs[JobDeclined], []signature{{kind: objectKind, required: []string{"declined", "reason"}, allowed: []string{"declined", "reason"}, fixed: []fixedValues{{"declined", []any{true}}, {"reason", []any{"no-text-layer", "encrypted", "corrupt", "too-large", "empty"}}}}}},
}

func (JobResult) memberOfJobStoredResult() {}

// JobRunning A job a worker has claimed and not yet concluded.
type JobRunning struct {
	Status   JobRunningStatus `json:"status"`
	Metadata JobMetadata      `json:"metadata"`
	Params   JobParams        `json:"params"`
	// StartedAt When the claim that holds it was made, as an ISO 8601 timestamp.
	StartedAt string            `json:"startedAt"`
	Progress  JobStoredProgress `json:"progress"`
}

func (JobRunning) memberOfJob()           {}
func (JobRunning) told() (string, string) { return "status", "running" }

type JobRunningStatus string

// The values of JobRunningStatus.
const (
	JobRunningStatusRunning JobRunningStatus = "running"
)

// Valid is whether e is one of JobRunningStatus's values.
func (e JobRunningStatus) Valid() bool {
	switch e {
	case JobRunningStatusRunning:
		return true
	}
	return false
}

// JobStartCommand Command to start a job
type JobStartCommand struct {
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId     *UserId    `json:"_userId,omitempty"`
	ResourceId ResourceId `json:"resourceId"`
	JobId      JobId      `json:"jobId"`
	JobType    JobType    `json:"jobType"`
	// AnnotationId Annotation this job is attached to, when applicable. Set for
	// annotation-scoped jobs like generation (from a specific reference). Unset
	// for resource-scoped jobs like bulk reference/tag/highlight detection.
	AnnotationId *AnnotationId `json:"annotationId,omitempty"`
	// Attempt Which attempt produced this event, 1-based (a first run is 1).
	// ALWAYS present: the queue re-runs a failed job silently, so an operator
	// reading progress or a terminal record has no other way to tell a re-run
	// from a first run — and provider spend, already counted in
	// xynolog_inference_tokens_total, cannot be attributed to a repeated
	// document without it. Stated rather than inferred from absence, because
	// 'attempt 1' is a fact the emitter always knows.
	Attempt *int `json:"attempt,omitempty"`
}

// JobStartedPayload Payload for job:started domain event
type JobStartedPayload struct {
	JobId   JobId   `json:"jobId"`
	JobType JobType `json:"jobType"`
	// AnnotationId Annotation this job is attached to, when applicable
	AnnotationId *AnnotationId `json:"annotationId,omitempty"`
	TotalSteps   *int          `json:"totalSteps,omitempty"`
}

// JobStatusRequest Request to check the status of a job
type JobStatusRequest struct {
	JobId JobId `json:"jobId"`
}

type JobStatusResponse struct {
	JobId        JobId                   `json:"jobId"`
	Type         JobType                 `json:"type"`
	Status       JobStatusResponseStatus `json:"status"`
	UserId       UserId                  `json:"userId"`
	Created      string                  `json:"created"`
	StartedAt    *string                 `json:"startedAt,omitempty"`
	CompletedAt  *string                 `json:"completedAt,omitempty"`
	Error        *string                 `json:"error,omitempty"`
	FailureClass *FailureClass           `json:"failureClass,omitempty"`
	Progress     *JobStoredProgress      `json:"progress,omitempty"`
	Result       *JobStoredResult        `json:"result,omitempty"`
}

type JobStatusResponseStatus string

// The values of JobStatusResponseStatus.
const (
	JobStatusResponseStatusPending   JobStatusResponseStatus = "pending"
	JobStatusResponseStatusRunning   JobStatusResponseStatus = "running"
	JobStatusResponseStatusComplete  JobStatusResponseStatus = "complete"
	JobStatusResponseStatusFailed    JobStatusResponseStatus = "failed"
	JobStatusResponseStatusCancelled JobStatusResponseStatus = "cancelled"
)

// Valid is whether e is one of JobStatusResponseStatus's values.
func (e JobStatusResponseStatus) Valid() bool {
	switch e {
	case JobStatusResponseStatusPending, JobStatusResponseStatusRunning, JobStatusResponseStatusComplete, JobStatusResponseStatusFailed, JobStatusResponseStatusCancelled:
		return true
	}
	return false
}

// JobStatusResult Result of a job status request
type JobStatusResult struct {
	Response JobStatusResponse `json:"response"`
}

// JobStoredProgress A running job's progress as the dispatcher stores it: the
// last JobProgress its worker reported with `job:report-progress`, or an
// empty object before the first report.
type JobStoredProgress struct {
	union[JobStoredProgressMember]
}

// JobStoredProgressMember is a member of JobStoredProgress: JobProgress,
// EmptyObject.
type JobStoredProgressMember interface {
	memberOfJobStoredProgress()
}

// Member is the member this value is: the one whose schema admits it.
func (u JobStoredProgress) Member() (any, error) {
	return u.member("JobStoredProgress", jobStoredProgressMembers)
}

// jobStoredProgressMembers is what each member of JobStoredProgress admits,
// and how a value of it is read.
var jobStoredProgressMembers = []unionMember{
	{"JobProgress", readAs[JobProgress], []signature{{kind: objectKind, required: []string{"percentage"}}}},
	{"EmptyObject", readAs[EmptyObject], []signature{{kind: objectKind, allowed: []string{}}}},
}

// JobStoredResult A completed job's result as the dispatcher stores it: the
// result its worker reported with `job:complete`, or an empty object when it
// reported none.
type JobStoredResult struct {
	union[JobStoredResultMember]
}

// JobStoredResultMember is a member of JobStoredResult: JobResult,
// EmptyObject.
type JobStoredResultMember interface {
	memberOfJobStoredResult()
}

// Member is the member this value is: the one whose schema admits it.
func (u JobStoredResult) Member() (any, error) {
	return u.member("JobStoredResult", jobStoredResultMembers)
}

// jobStoredResultMembers is what each member of JobStoredResult admits, and
// how a value of it is read.
var jobStoredResultMembers = []unionMember{
	{"JobResult", readAs[JobResult], []signature{{kind: objectKind, required: []string{"found", "persisted"}, allowed: []string{"found", "persisted", "errors", "byCategory", "underReportedPieces", "uncheckedPieces"}}, {kind: objectKind, required: []string{"resourceId", "resourceName", "truncated"}, allowed: []string{"resourceId", "resourceName", "truncated"}}, {kind: objectKind, required: []string{"declined", "reason"}, allowed: []string{"declined", "reason"}, fixed: []fixedValues{{"declined", []any{true}}, {"reason", []any{"no-text-layer", "encrypted", "corrupt", "too-large", "empty"}}}}}},
	{"EmptyObject", readAs[EmptyObject], []signature{{kind: objectKind, allowed: []string{}}}},
}

// JobType What a job does, as the verb that asks for it: `mark` annotates a
// resource, `yield` makes one. A job description is its `jobType` and the
// parameters that verb takes; a `mark` job's parameters state its motivation.
type JobType string

// The values of JobType.
const (
	JobTypeMark  JobType = "mark"
	JobTypeYield JobType = "yield"
)

// Valid is whether e is one of JobType's values.
func (e JobType) Valid() bool {
	switch e {
	case JobTypeMark, JobTypeYield:
		return true
	}
	return false
}

// JobsBudgets jobs/budgets.json: the retry budget of each job type.
type JobsBudgets struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Budgets One row for each job type.
	Budgets []JobsBudgetsBudgetsItem `json:"budgets"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v JobsBudgets) MarshalJSON() ([]byte, error) {
	type written JobsBudgets
	v.Budgets = listOf(v.Budgets)
	return json.Marshal(written(v))
}

type JobsBudgetsBudgetsItem struct {
	JobType JobType `json:"jobType"`
	// MaxRetries How many times a failed attempt of a job of this type may be
	// retried: its record's `metadata.maxRetries`.
	MaxRetries int `json:"maxRetries"`
}

// JobsStorage jobs/storage.json: where the job queue keeps its state on the
// broker.
type JobsStorage struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Stream The work-queue stream every job is published into.
	Stream JobsStorageStream `json:"stream"`
	// Consumer The durable consumer that delivers each job to the dispatcher
	// holding its lease.
	Consumer JobsStorageConsumer `json:"consumer"`
	// Bucket The KV bucket that keeps one record per job, keyed by the job's id.
	Bucket JobsStorageBucket `json:"bucket"`
}

// JobsStorageBucket The KV bucket that keeps one record per job, keyed by the
// job's id.
type JobsStorageBucket struct {
	Name string `json:"name"`
	// Record The component schema each of the bucket's values is.
	Record string `json:"record"`
}

// JobsStorageConsumer The durable consumer that delivers each job to the
// dispatcher holding its lease.
type JobsStorageConsumer struct {
	DurableName string `json:"durableName"`
}

// JobsStorageStream The work-queue stream every job is published into.
type JobsStorageStream struct {
	Name string `json:"name"`
	// SubjectRoot The root of the subjects the stream captures: a job is
	// published on `<subjectRoot>.<jobType>`.
	SubjectRoot string `json:"subjectRoot"`
}

// KbDescription What a knowledge base says about itself, answered by the
// Archivist from the committed .xynolog/config.yaml and the working tree it
// holds. The only source clients use for a knowledge base's name and domain.
type KbDescription struct {
	// Name The committed project.name, or the knowledge base directory's name
	// when it commits no .xynolog/config.yaml.
	Name string `json:"name"`
	// Domain The committed site.domain: the knowledge base's permanent identity.
	// Its did is 'did:web:' + this domain (kbDid in @xynolog/core). It names
	// WHICH knowledge base this is, not which running copy: a local clone and a
	// codespace of one repo report the same domain, so use it to verify what you
	// connected to, never to select among copies. A knowledge base that commits
	// no .xynolog/config.yaml declares none, and is refused with
	// browse:kb-failed.
	Domain string `json:"domain"`
	// GitBranch The working tree's current git branch. Absent when the knowledge
	// base does not sync git (`git.sync` in its committed .xynolog/config.yaml),
	// and when its tree is not a git checkout.
	GitBranch *string `json:"gitBranch,omitempty"`
}

// KbDid A knowledge base's DID: `did:web:` and its domain. No API states one
// as such, so it is no component.
type (
	KbDid = string
)

// KbEndpoint How a knowledge base is reached: a gateway over HTTP, or a
// knowledge base the host process has loaded. Told apart by `kind`. Only what
// builds a transport, or signs in at an issuer, reads it.
type KbEndpoint struct {
	union[KbEndpointMember]
}

// KbEndpointMember is a member of KbEndpoint: HttpEndpoint, LocalEndpoint.
type KbEndpointMember interface {
	memberOfKbEndpoint()
}

// Discriminator is the `kind` this value states.
func (u KbEndpoint) Discriminator() (string, error) { return u.stated("kind") }

// Member is the member this value is: the one whose schema admits it.
func (u KbEndpoint) Member() (any, error) { return u.member("KbEndpoint", kbEndpointMembers) }

// kbEndpointMembers is what each member of KbEndpoint admits, and how a value
// of it is read.
var kbEndpointMembers = []unionMember{
	{"HttpEndpoint", readAs[HttpEndpoint], []signature{{kind: objectKind, required: []string{"kind", "host", "port", "protocol"}, fixed: []fixedValues{{"kind", []any{"http"}}, {"protocol", []any{"http", "https"}}}}}},
	{"LocalEndpoint", readAs[LocalEndpoint], []signature{{kind: objectKind, required: []string{"kind", "kbId"}, fixed: []fixedValues{{"kind", []any{"local"}}}}}},
}

// KbIdentity A knowledge base's committed identity (`project.name` and
// `site.domain` in its .xynolog/config.yaml), as a service's document names
// the knowledge base it serves. Its telemetry names it by its DID
// (`xynolog.kb`, specs/src/service-telemetry/telemetry.json).
type KbIdentity struct {
	// Name Its name. The gateway publishes it as its resource metadata's
	// `resource_name`.
	Name string `json:"name"`
	// Domain Its did:web domain: its permanent identity, the source of the
	// audience its tokens must carry, and the authority its people and agents
	// are named under.
	Domain string `json:"domain"`
}

// KbIdentityConflict A different knowledge base answers at a registered
// address. Both dids, because neither alone says what to do: a person has to
// recognise which knowledge base they registered and which one answers.
type KbIdentityConflict struct {
	// ExpectedDid The did the entry records.
	ExpectedDid string `json:"expectedDid"`
	// ObservedDid The did the knowledge base that answered reported.
	ObservedDid string `json:"observedDid"`
}

// KbRead When a knowledge base last described itself, and what it said beyond
// its name. A client shows it as current only while a session to the
// knowledge base is live, and as of `at` otherwise.
type KbRead struct {
	// At When the description arrived.
	At string `json:"at"`
	// GitBranch The branch of the knowledge base's working tree then. Absent
	// when the working tree was not a git checkout.
	GitBranch *string `json:"gitBranch,omitempty"`
}

// KbReadKind What reading the active knowledge base against its entry
// concluded.
type KbReadKind string

// The values of KbReadKind.
const (
	KbReadKindRecorded  KbReadKind = "recorded"
	KbReadKindConflict  KbReadKind = "conflict"
	KbReadKindNoVerdict KbReadKind = "no-verdict"
)

// Valid is whether e is one of KbReadKind's values.
func (e KbReadKind) Valid() bool {
	switch e {
	case KbReadKindRecorded, KbReadKindConflict, KbReadKindNoVerdict:
		return true
	}
	return false
}

// KbReadVerdict What a knowledge base said when it was asked to describe
// itself, read against the entry it was asked as.
type KbReadVerdict struct {
	union[KbReadVerdictMember]
}

// KbReadVerdictMember is a member of KbReadVerdict: KbReadVerdictRecorded,
// KbReadVerdictConflict, KbReadVerdictNoVerdict.
type KbReadVerdictMember interface {
	memberOfKbReadVerdict()
}

// Discriminator is the `kind` this value states.
func (u KbReadVerdict) Discriminator() (string, error) { return u.stated("kind") }

// Member is the member this value is: the one whose schema admits it.
func (u KbReadVerdict) Member() (any, error) { return u.member("KbReadVerdict", kbReadVerdictMembers) }

// kbReadVerdictMembers is what each member of KbReadVerdict admits, and how a
// value of it is read.
var kbReadVerdictMembers = []unionMember{
	{"KbReadVerdictRecorded", readAs[KbReadVerdictRecorded], []signature{{kind: objectKind, required: []string{"kind"}, allowed: []string{"kind"}, fixed: []fixedValues{{"kind", []any{"recorded"}}}}}},
	{"KbReadVerdictConflict", readAs[KbReadVerdictConflict], []signature{{kind: objectKind, required: []string{"kind", "observedDid", "observedName"}, allowed: []string{"kind", "observedDid", "observedName"}, fixed: []fixedValues{{"kind", []any{"conflict"}}}}}},
	{"KbReadVerdictNoVerdict", readAs[KbReadVerdictNoVerdict], []signature{{kind: objectKind, required: []string{"kind"}, allowed: []string{"kind"}, fixed: []fixedValues{{"kind", []any{"no-verdict"}}}}}},
}

// KbReadVerdictConflict A different knowledge base answered. Its did and the
// name it gave itself are here and nowhere else: the entry is as it was.
type KbReadVerdictConflict struct {
	// Kind What reading the active knowledge base against its entry concluded.
	Kind KbReadVerdictConflictKind `json:"kind"`
	// ObservedDid The did the knowledge base that answered reported.
	ObservedDid string `json:"observedDid"`
	// ObservedName The name the knowledge base that answered gave itself.
	ObservedName string `json:"observedName"`
}

func (KbReadVerdictConflict) memberOfKbReadVerdict() {}
func (KbReadVerdictConflict) told() (string, string) { return "kind", "conflict" }

// KbReadVerdictConflictKind What reading the active knowledge base against
// its entry concluded.
type KbReadVerdictConflictKind string

// The values of KbReadVerdictConflictKind.
const (
	KbReadVerdictConflictKindConflict KbReadVerdictConflictKind = "conflict"
)

// Valid is whether e is one of KbReadVerdictConflictKind's values.
func (e KbReadVerdictConflictKind) Valid() bool {
	switch e {
	case KbReadVerdictConflictKindConflict:
		return true
	}
	return false
}

// KbReadVerdictNoVerdict It did not answer, or could not say who it is.
// Evidence of nothing.
type KbReadVerdictNoVerdict struct {
	// Kind What reading the active knowledge base against its entry concluded.
	Kind KbReadVerdictNoVerdictKind `json:"kind"`
}

func (KbReadVerdictNoVerdict) memberOfKbReadVerdict() {}
func (KbReadVerdictNoVerdict) told() (string, string) { return "kind", "no-verdict" }

// KbReadVerdictNoVerdictKind What reading the active knowledge base against
// its entry concluded.
type KbReadVerdictNoVerdictKind string

// The values of KbReadVerdictNoVerdictKind.
const (
	KbReadVerdictNoVerdictKindNoVerdict KbReadVerdictNoVerdictKind = "no-verdict"
)

// Valid is whether e is one of KbReadVerdictNoVerdictKind's values.
func (e KbReadVerdictNoVerdictKind) Valid() bool {
	switch e {
	case KbReadVerdictNoVerdictKindNoVerdict:
		return true
	}
	return false
}

// KbReadVerdictRecorded It answered as that entry, and its name and branch
// are on the entry now.
type KbReadVerdictRecorded struct {
	// Kind What reading the active knowledge base against its entry concluded.
	Kind KbReadVerdictRecordedKind `json:"kind"`
}

func (KbReadVerdictRecorded) memberOfKbReadVerdict() {}
func (KbReadVerdictRecorded) told() (string, string) { return "kind", "recorded" }

// KbReadVerdictRecordedKind What reading the active knowledge base against
// its entry concluded.
type KbReadVerdictRecordedKind string

// The values of KbReadVerdictRecordedKind.
const (
	KbReadVerdictRecordedKindRecorded KbReadVerdictRecordedKind = "recorded"
)

// Valid is whether e is one of KbReadVerdictRecordedKind's values.
func (e KbReadVerdictRecordedKind) Valid() bool {
	switch e {
	case KbReadVerdictRecordedKindRecorded:
		return true
	}
	return false
}

// KbSessionStatus What the credential stored for a knowledge base says, read
// without asking anyone: `authenticated`, a token is stored and has not
// expired; `expired`, a token is stored and has expired; `signed-out`,
// nothing is stored.
type KbSessionStatus string

// The values of KbSessionStatus.
const (
	KbSessionStatusAuthenticated KbSessionStatus = "authenticated"
	KbSessionStatusExpired       KbSessionStatus = "expired"
	KbSessionStatusSignedOut     KbSessionStatus = "signed-out"
)

// Valid is whether e is one of KbSessionStatus's values.
func (e KbSessionStatus) Valid() bool {
	switch e {
	case KbSessionStatusAuthenticated, KbSessionStatusExpired, KbSessionStatusSignedOut:
		return true
	}
	return false
}

// KbTarget Where to connect to a knowledge base: an endpoint, and the labels
// a client keeps of it. It carries no identity: which knowledge base answers
// at an address is known only once it has been reached with a token and
// asked, so a target is what every caller can build before then, and a
// session's whole input. A client keeps it locally; it is never sent.
type KbTarget struct {
	// Id The key the client stores a session's credentials under. Two sessions
	// that share one storage have two ids, or each overwrites the other's
	// tokens. Whoever builds the target chooses it; none is made up.
	Id string `json:"id"`
	// Label What a person reads the knowledge base as. Once the knowledge base
	// has described itself, its own name.
	Label    string     `json:"label"`
	Endpoint KbEndpoint `json:"endpoint"`
}

// KnowledgeBase A registered knowledge base: a target, and what registering
// it took, the identity the knowledge base reported of itself when it was
// reached (`did`) among it. What a client's list of knowledge bases holds. A
// did says which knowledge base, not which running copy: a clone and a
// codespace of one repository are one knowledge base at two addresses and
// report one did. So an entry is looked up by its endpoint, and its did is
// what an answer is verified against; nothing selects by did. Its `label` and
// `lastRead` are written only from an answer that carried its did.
type KnowledgeBase struct {
	// Id The key the client stores a session's credentials under. Two sessions
	// that share one storage have two ids, or each overwrites the other's
	// tokens. Whoever builds the target chooses it; none is made up.
	Id string `json:"id"`
	// Label What a person reads the knowledge base as. Once the knowledge base
	// has described itself, its own name.
	Label    string     `json:"label"`
	Endpoint KbEndpoint `json:"endpoint"`
	// Did The did the knowledge base reported of itself.
	Did string `json:"did"`
	// LastRead The last time the knowledge base described itself. Absent until
	// it has, in an answer that carried this entry's did.
	LastRead *KbRead `json:"lastRead,omitempty"`
}

// KnowledgeBaseStatus One knowledge base's stack as xynolog status reads it:
// what it is, where it runs, and each of its own services. The services every
// knowledge base shares are reported once, in the snapshot's shared list.
type KnowledgeBaseStatus struct {
	// Name What the snapshot calls the knowledge base: the last segment of its
	// DID, or the whole DID where two would share one, or its key.
	Name string `json:"name"`
	// Key The knowledge base's key on this machine, which names its containers
	// and its state.
	Key string `json:"key"`
	// Recorded Whether a stack of it is recorded. When none is, its services are
	// found by name.
	Recorded bool `json:"recorded"`
	// Placement Where the stack actually runs. "local": containers on this
	// machine. "codespace": a GitHub-hosted VM whose KB is port-forwarded here.
	Placement KnowledgeBaseStatusPlacement `json:"placement"`
	// Root Its clone, for a local stack.
	Root *string `json:"root,omitempty"`
	// Repo owner/name GitHub slug — present for codespace placements, where the
	// repo is the stack's identity
	Repo *string `json:"repo,omitempty"`
	// Did The KB's did:web identifier, from its committed .xynolog/config.yaml —
	// "did:web:" + its site.domain, verbatim. REQUIRED: a KB that declares no
	// domain has no identity to publish, and the launcher refuses to start it
	// rather than inventing or defaulting one. NOT unique within a document: a
	// did names the knowledge base, not a running copy of it, so a local clone
	// and a codespace of the same repo legitimately share one and both are
	// published. host:port is the unique field (at most one entry per address),
	// so consumers look up by ADDRESS and use the did to VERIFY that the copy
	// they reached is the KB they meant — an address alone cannot say which KB
	// is which, and an identity alone cannot say which copy.
	Did *string `json:"did,omitempty"`
	// SiteName Human-readable site name from the KB's .xynolog/config.yaml
	// (site.siteName), for display
	SiteName *string `json:"siteName,omitempty"`
	// IdentityError Why its identity could not be read from its clone, when it
	// could not.
	IdentityError *string `json:"identityError,omitempty"`
	// Kb The knowledge base as the discovery document publishes it, when it
	// does.
	Kb *DiscoveredKB `json:"kb,omitempty"`
	// Runtime The runtime its record names.
	Runtime *Runtime `json:"runtime,omitempty"`
	// Gateway The base URL of its gateway, from its record.
	Gateway *string `json:"gateway,omitempty"`
	// SecretStore Where the values the launcher generates for it are kept, as
	// xynolog settings secret-store describes it.
	SecretStore *string `json:"secretStore,omitempty"`
	// Lan This machine's address on the network, when the stack is started with
	// network lan.
	Lan *string `json:"lan,omitempty"`
	// Starting Whether a xynolog start of it holds its start lock: its services
	// are not ready, whatever they report.
	Starting bool     `json:"starting"`
	Session  *Session `json:"session,omitempty"`
	// Healthy Whether each of its counted services, and the issuer it signs in
	// at, answers.
	Healthy bool `json:"healthy"`
	// Services Its own services, group by group, then the issuer it signs in at.
	// Empty for a codespace's, whose services its own launcher reports.
	Services []ServiceStatus `json:"services"`
	// Workload The ledger and job queue readings the launcher can attribute to
	// this knowledge base. A missing reading means the Collector has not
	// reported that metric, not that its value is zero.
	Workload *WorkloadStatus `json:"workload,omitempty"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v KnowledgeBaseStatus) MarshalJSON() ([]byte, error) {
	type written KnowledgeBaseStatus
	v.Services = listOf(v.Services)
	return json.Marshal(written(v))
}

// KnowledgeBaseStatusPlacement Where the stack actually runs. "local":
// containers on this machine. "codespace": a GitHub-hosted VM whose KB is
// port-forwarded here.
type KnowledgeBaseStatusPlacement string

// The values of KnowledgeBaseStatusPlacement.
const (
	KnowledgeBaseStatusPlacementLocal     KnowledgeBaseStatusPlacement = "local"
	KnowledgeBaseStatusPlacementCodespace KnowledgeBaseStatusPlacement = "codespace"
)

// Valid is whether e is one of KnowledgeBaseStatusPlacement's values.
func (e KnowledgeBaseStatusPlacement) Valid() bool {
	switch e {
	case KnowledgeBaseStatusPlacementLocal, KnowledgeBaseStatusPlacementCodespace:
		return true
	}
	return false
}

// KnowledgeGraph Knowledge graph gathered for an LLM context — a shared
// backbone in which resources AND annotations are typed nodes, connected by
// typed (optionally bidirectional) edges. Flattened views the
// matcher/generation read (connections, citedBy, siblings) are derived from
// these nodes/edges.
type KnowledgeGraph struct {
	Nodes []KnowledgeGraphNodesItem `json:"nodes"`
	Edges []KnowledgeGraphEdgesItem `json:"edges"`
	// Truncated Whether the graph stopped taking resources at its ceiling of 200
	// resource nodes, so that a resource within the depth asked for is not in
	// it. Present, and true, only then
	Truncated *bool `json:"truncated,omitempty"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v KnowledgeGraph) MarshalJSON() ([]byte, error) {
	type written KnowledgeGraph
	v.Nodes = listOf(v.Nodes)
	v.Edges = listOf(v.Edges)
	return json.Marshal(written(v))
}

type KnowledgeGraphEdgesItem struct {
	Source string `json:"source"`
	Target string `json:"target"`
	// Type Edge kind: `annotation-of` (an annotation → the resource it lives
	// on), `cites` (a citing linking annotation → the focal resource), or `link`
	// (a resource → a resource it links to)
	Type string `json:"type"`
	// Bidirectional Whether the connection goes both ways. Absent on a `link`
	// edge found through what cites a resource, which says nothing of the way
	// back
	Bidirectional *bool           `json:"bidirectional,omitempty"`
	Metadata      *map[string]any `json:"metadata,omitempty"`
}

type KnowledgeGraphNodesItem struct {
	union[KnowledgeGraphNodesItemMember]
}

// KnowledgeGraphNodesItemMember is a member of KnowledgeGraphNodesItem:
// GraphResourceNode, GraphAnnotationNode.
type KnowledgeGraphNodesItemMember interface {
	memberOfKnowledgeGraphNodesItem()
}

// Discriminator is the `type` this value states.
func (u KnowledgeGraphNodesItem) Discriminator() (string, error) { return u.stated("type") }

// Member is the member this value is: the one whose schema admits it.
func (u KnowledgeGraphNodesItem) Member() (any, error) {
	return u.member("KnowledgeGraphNodesItem", knowledgeGraphNodesItemMembers)
}

// knowledgeGraphNodesItemMembers is what each member of
// KnowledgeGraphNodesItem admits, and how a value of it is read.
var knowledgeGraphNodesItemMembers = []unionMember{
	{"GraphResourceNode", readAs[GraphResourceNode], []signature{{kind: objectKind, required: []string{"id", "type", "label"}, fixed: []fixedValues{{"type", []any{"resource"}}}}}},
	{"GraphAnnotationNode", readAs[GraphAnnotationNode], []signature{{kind: objectKind, required: []string{"id", "type", "label", "annotation"}, fixed: []fixedValues{{"type", []any{"annotation"}}}}}},
}

// KnowledgeIndex What a knowledge base's record is indexed into, and the
// services that keep and read the indexes: the Weaver's graph, the Smelter's
// vectors and anchored text, and the Librarian that answers from them. Each
// can be rebuilt from the record.
type KnowledgeIndex struct {
	ApiVersion StackApiVersion    `json:"apiVersion"`
	Kind       KnowledgeIndexKind `json:"kind"`
	Metadata   Metadata           `json:"metadata"`
	// Spec The indexes, the services that keep and read them, and the knowledge
	// base they index.
	Spec KnowledgeIndexSpec `json:"spec"`
}

type KnowledgeIndexKind string

// The values of KnowledgeIndexKind.
const (
	KnowledgeIndexKindKnowledgeIndex KnowledgeIndexKind = "KnowledgeIndex"
)

// Valid is whether e is one of KnowledgeIndexKind's values.
func (e KnowledgeIndexKind) Valid() bool {
	switch e {
	case KnowledgeIndexKindKnowledgeIndex:
		return true
	}
	return false
}

// KnowledgeIndexSpec The indexes, the services that keep and read them, and
// the knowledge base they index.
type KnowledgeIndexSpec struct {
	// KnowledgeBase The name of the KnowledgeBase document whose record this
	// indexes.
	KnowledgeBase string   `json:"knowledgeBase"`
	LogLevel      LogLevel `json:"logLevel"`
	// Graph The graph store the Weaver writes and the Librarian reads. The
	// knowledge base's graph is in the database its DID names
	// (specs/src/graph/database-cases.json): a Neo4j the launcher runs makes it
	// when it first starts, and one somebody else runs must already hold it.
	Graph KnowledgeIndexSpecGraph `json:"graph"`
	// Vectors The vector store the Smelter writes and the Librarian reads: the
	// one the launcher runs for the knowledge bases on a machine, at `shared`;
	// one of the knowledge base's own the launcher runs, from `image` with
	// `resources`; or somebody else's, at `external`. Exactly one of the three.
	Vectors KnowledgeIndexSpecVectors `json:"vectors"`
	// Embedding The model that turns text into vectors. Vectors made by one
	// model are not comparable with another's, so the model is the index's.
	Embedding KnowledgeIndexSpecEmbedding `json:"embedding"`
	// Librarian The Librarian: it answers gathers and searches from the indexes.
	Librarian KnowledgeIndexSpecLibrarian `json:"librarian"`
	// Smelter The Smelter: it writes the vectors and the anchored text.
	Smelter KnowledgeIndexSpecSmelter `json:"smelter"`
	// Weaver The Weaver: it writes the graph.
	Weaver KnowledgeIndexSpecWeaver `json:"weaver"`
}

// KnowledgeIndexSpecEmbedding The model that turns text into vectors. Vectors
// made by one model are not comparable with another's, so the model is the
// index's.
type KnowledgeIndexSpecEmbedding struct {
	// Type Who serves the model: `ollama`, or `voyage`.
	Type string `json:"type"`
	// Model The model, as its provider names it.
	Model string `json:"model"`
	// Chunking How a text is cut before it is embedded.
	Chunking KnowledgeIndexSpecEmbeddingChunking `json:"chunking"`
	// Endpoint Where the provider's API is reached. The shared Ollama is stated
	// by no endpoint.
	Endpoint *string    `json:"endpoint,omitempty"`
	ApiKey   *SecretRef `json:"apiKey,omitempty"`
}

// KnowledgeIndexSpecEmbeddingChunking How a text is cut before it is
// embedded.
type KnowledgeIndexSpecEmbeddingChunking struct {
	// ChunkSize The size of a piece.
	ChunkSize int `json:"chunkSize"`
	// Overlap How much of one piece the next repeats.
	Overlap int `json:"overlap"`
}

// KnowledgeIndexSpecGraph The graph store the Weaver writes and the Librarian
// reads. The knowledge base's graph is in the database its DID names
// (specs/src/graph/database-cases.json): a Neo4j the launcher runs makes it
// when it first starts, and one somebody else runs must already hold it.
type KnowledgeIndexSpecGraph struct {
	// Type The graph store's driver: `neo4j`.
	Type string `json:"type"`
	// Username The user the services sign in to the store as.
	Username  string     `json:"username"`
	Image     *Image     `json:"image,omitempty"`
	Resources *Resources `json:"resources,omitempty"`
	// External A graph store somebody else runs.
	External *KnowledgeIndexSpecGraphExternal `json:"external,omitempty"`
}

// KnowledgeIndexSpecGraphExternal A graph store somebody else runs.
type KnowledgeIndexSpecGraphExternal struct {
	// Uri Where it listens: `bolt://host:port`.
	Uri      string    `json:"uri"`
	Password SecretRef `json:"password"`
}

// KnowledgeIndexSpecLibrarian The Librarian: it answers gathers and searches
// from the indexes.
type KnowledgeIndexSpecLibrarian struct {
	Image     Image     `json:"image"`
	Resources Resources `json:"resources"`
	// Gather How a gather waits.
	Gather KnowledgeIndexSpecLibrarianGather `json:"gather"`
	// Search What a search by meaning keeps.
	Search KnowledgeIndexSpecLibrarianSearch `json:"search"`
}

// KnowledgeIndexSpecLibrarianGather How a gather waits.
type KnowledgeIndexSpecLibrarianGather struct {
	// SettleTimeoutMs How long a gather waits for the Smelter to settle a
	// resource, in milliseconds.
	SettleTimeoutMs int `json:"settleTimeoutMs"`
}

// KnowledgeIndexSpecLibrarianSearch What a search by meaning keeps.
type KnowledgeIndexSpecLibrarianSearch struct {
	// SemanticFloor The least similarity a hit by meaning must have.
	SemanticFloor float64 `json:"semanticFloor"`
}

// KnowledgeIndexSpecSmelter The Smelter: it writes the vectors and the
// anchored text.
type KnowledgeIndexSpecSmelter struct {
	Image     Image     `json:"image"`
	Resources Resources `json:"resources"`
	// PdfsAtOnce How many PDFs it works on at once. A page of a scan held for
	// OCR is large; one for each 2G of its memory is a reading of what fits.
	PdfsAtOnce int `json:"pdfsAtOnce"`
}

// KnowledgeIndexSpecVectors The vector store the Smelter writes and the
// Librarian reads: the one the launcher runs for the knowledge bases on a
// machine, at `shared`; one of the knowledge base's own the launcher runs,
// from `image` with `resources`; or somebody else's, at `external`. Exactly
// one of the three.
type KnowledgeIndexSpecVectors struct {
	// Type The vector store's driver: `qdrant`.
	Type string `json:"type"`
	// Shared The vector store the launcher runs for the knowledge bases on a
	// machine (the state home's VectorStore document). Each knowledge base keeps
	// its index in collections of its own there, so nothing is said of it here.
	Shared    *EmptyObject `json:"shared,omitempty"`
	Image     *Image       `json:"image,omitempty"`
	Resources *Resources   `json:"resources,omitempty"`
	// External A vector store somebody else runs, with the token each service
	// presents to it: the Smelter's may make, write and delete this knowledge
	// base's collections, and the Librarian's may read them.
	External *KnowledgeIndexSpecVectorsExternal `json:"external,omitempty"`
}

// KnowledgeIndexSpecVectorsExternal A vector store somebody else runs, with
// the token each service presents to it: the Smelter's may make, write and
// delete this knowledge base's collections, and the Librarian's may read
// them.
type KnowledgeIndexSpecVectorsExternal struct {
	// Host A host name or address the stack's containers can reach.
	Host string `json:"host"`
	// Port The port its REST API listens on.
	Port           int       `json:"port"`
	SmelterToken   SecretRef `json:"smelterToken"`
	LibrarianToken SecretRef `json:"librarianToken"`
}

// KnowledgeIndexSpecWeaver The Weaver: it writes the graph.
type KnowledgeIndexSpecWeaver struct {
	Image     Image     `json:"image"`
	Resources Resources `json:"resources"`
}

// LastEventIds Where a knowledge base's stream was: for each scope, a
// resource's id, the id of the last recorded event delivered on it.
type LastEventIds map[ResourceId]PersistedEventId

// LibrarianConfig Everything a Librarian reads at boot: nothing in it is
// defaulted by the Librarian. Whoever starts a Librarian writes it, from the
// knowledge base's stack documents, and the Librarian reads it from the path
// its `--config` flag names. This schema is the contract, and a Librarian
// needs no launcher. Started without `--config`, or with a path that names no
// file, the Librarian refuses to start and says which. No secret is a value
// here: the graph database's password, an embedding provider's key and a
// model provider's key are each named by the environment variable that holds
// it, and the Librarian's own service account is `XYNOLOG_OIDC_CLIENT_ID` and
// `XYNOLOG_OIDC_CLIENT_SECRET` in its environment. A document that does not
// validate is refused at boot, naming each failing field.
type LibrarianConfig struct {
	Kb KbIdentity `json:"kb"`
	// GatewayUrl The URL the Librarian reaches the gateway at: its route to the
	// bus.
	GatewayUrl string `json:"gatewayUrl"`
	// Identity The issuer the Librarian's service account signs in at.
	Identity ServiceIdentity `json:"identity"`
	// Archivist Where the Archivist listens. The Librarian reads a resource's
	// bytes from it, as its service account.
	Archivist ServiceAddress        `json:"archivist"`
	Graph     GraphConfig           `json:"graph"`
	Vectors   VectorsConfig         `json:"vectors"`
	Embedding EmbeddingConfig       `json:"embedding"`
	Matcher   LibrarianEngineConfig `json:"matcher"`
	Gatherer  LibrarianEngineConfig `json:"gatherer"`
	// ModelCatalogue The path of a model catalogue file: what each model of a
	// provider can take, for the providers whose own APIs do not say (`google`,
	// `openai`, `together`). A Librarian whose matcher or gatherer is of one of
	// those providers refuses to start where the file cannot be read, and where
	// it states nothing of that model. A Librarian with no such model does not
	// read it.
	ModelCatalogue string `json:"modelCatalogue"`
	// Gather The bound on a gather.
	Gather LibrarianConfigGather `json:"gather"`
	// Search The bound on a search by meaning.
	Search LibrarianConfigSearch `json:"search"`
	// Port The port the Librarian answers `/health` on.
	Port      int       `json:"port"`
	LogLevel  LogLevel  `json:"logLevel"`
	LogFormat LogFormat `json:"logFormat"`
}

// LibrarianConfigGather The bound on a gather.
type LibrarianConfigGather struct {
	// SettleTimeoutMs How long a gather around a resource waits for the
	// Smelter's decision on it before answering without similar passages, in
	// milliseconds.
	SettleTimeoutMs int `json:"settleTimeoutMs"`
}

// LibrarianConfigSearch The bound on a search by meaning.
type LibrarianConfigSearch struct {
	// SemanticFloor The least similarity a hit by meaning must have.
	SemanticFloor float64 `json:"semanticFloor"`
}

// LibrarianEngineConfig The engine a Librarian actor asks: which it is, and
// where its provider is reached.
type LibrarianEngineConfig struct {
	Engine Engine `json:"engine"`
	// BaseUrl The address the provider's API is reached at.
	BaseUrl string `json:"baseUrl"`
	// ApiKeyEnv The environment variable holding the provider's API key, when
	// the provider requires one.
	ApiKeyEnv *string `json:"apiKeyEnv,omitempty"`
}

// LibrarianHealth The Librarian's health answer (LIBRARIAN.md § Health). Its
// port opens last, after it has begun to take requests from the bus, so a
// Librarian whose health answers is answering.
type LibrarianHealth struct {
	Status LibrarianHealthStatus `json:"status"`
	// Kb The DID of the knowledge base it serves: the one its document names,
	// which that knowledge base said it is before the Librarian reached its
	// stores.
	Kb KbDid `json:"kb"`
	// Actors The two actors it runs, `matcher` and `gatherer`.
	Actors []LibrarianHealthActorsItem `json:"actors"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v LibrarianHealth) MarshalJSON() ([]byte, error) {
	type written LibrarianHealth
	v.Actors = listOf(v.Actors)
	return json.Marshal(written(v))
}

type LibrarianHealthActorsItem string

// The values of LibrarianHealthActorsItem.
const (
	LibrarianHealthActorsItemMatcher  LibrarianHealthActorsItem = "matcher"
	LibrarianHealthActorsItemGatherer LibrarianHealthActorsItem = "gatherer"
)

// Valid is whether e is one of LibrarianHealthActorsItem's values.
func (e LibrarianHealthActorsItem) Valid() bool {
	switch e {
	case LibrarianHealthActorsItemMatcher, LibrarianHealthActorsItemGatherer:
		return true
	}
	return false
}

type LibrarianHealthStatus string

// The values of LibrarianHealthStatus.
const (
	LibrarianHealthStatusOk LibrarianHealthStatus = "ok"
)

// Valid is whether e is one of LibrarianHealthStatus's values.
func (e LibrarianHealthStatus) Valid() bool {
	switch e {
	case LibrarianHealthStatusOk:
		return true
	}
	return false
}

type LibrarianPromptScore struct {
	Candidate float64 `json:"candidate"`
	Score     float64 `json:"score"`
}

// LimitRefusal An ErrorResponse that names, in `code`, the limit the request
// met.
type LimitRefusal struct {
	// Error What went wrong, in a sentence.
	Error string `json:"error"`
	// Code `streams`: the principal already holds as many streams as its
	// coefficient of `x-xynolog-limits.streamsPerPrincipal` allows. `emit-rate`:
	// the principal's emits have used its bucket, whose rate and burst are its
	// coefficient of `x-xynolog-limits.emitsPerPrincipal`, per gateway process.
	// `unanswered-requests`: the client already awaits as many replies as
	// `BusSubscribeRequest.pendingReplies` may name. `capacity`: the gateway
	// holds as many queued bytes as it can. `refusal-rate`: the request's
	// credential was refused, and the requests its holder has had refused have
	// used their allowance; it answers only a request whose token has already
	// failed verification, so it says what a 401 says, and a client that can
	// renew its token renews it and sends the request again rather than waiting
	// (contract/TRANSPORT-CONTRACT.md § A refused credential).
	Code LimitRefusalCode `json:"code"`
	// Hint What the caller can do about it, when there is something to say.
	Hint    *string `json:"hint,omitempty"`
	Details any     `json:"details,omitempty"`
}

// LimitRefusalCode `streams`: the principal already holds as many streams as
// its coefficient of `x-xynolog-limits.streamsPerPrincipal` allows.
// `emit-rate`: the principal's emits have used its bucket, whose rate and
// burst are its coefficient of `x-xynolog-limits.emitsPerPrincipal`, per
// gateway process. `unanswered-requests`: the client already awaits as many
// replies as `BusSubscribeRequest.pendingReplies` may name. `capacity`: the
// gateway holds as many queued bytes as it can. `refusal-rate`: the request's
// credential was refused, and the requests its holder has had refused have
// used their allowance; it answers only a request whose token has already
// failed verification, so it says what a 401 says, and a client that can
// renew its token renews it and sends the request again rather than waiting
// (contract/TRANSPORT-CONTRACT.md § A refused credential).
type LimitRefusalCode string

// The values of LimitRefusalCode.
const (
	LimitRefusalCodeStreams            LimitRefusalCode = "streams"
	LimitRefusalCodeEmitRate           LimitRefusalCode = "emit-rate"
	LimitRefusalCodeUnansweredRequests LimitRefusalCode = "unanswered-requests"
	LimitRefusalCodeCapacity           LimitRefusalCode = "capacity"
	LimitRefusalCodeRefusalRate        LimitRefusalCode = "refusal-rate"
)

// Valid is whether e is one of LimitRefusalCode's values.
func (e LimitRefusalCode) Valid() bool {
	switch e {
	case LimitRefusalCodeStreams, LimitRefusalCodeEmitRate, LimitRefusalCodeUnansweredRequests, LimitRefusalCodeCapacity, LimitRefusalCodeRefusalRate:
		return true
	}
	return false
}

// LinkingJobParams What a linking job takes: mentions of the named entity
// types are marked as references, each unresolved until it is bound to a
// resource.
type LinkingJobParams struct {
	Motivation LinkingJobParamsMotivation `json:"motivation"`
	// EntityTypes The entity types to find mentions of. Each is one the
	// knowledge base registers.
	EntityTypes []string `json:"entityTypes"`
	// IncludeDescriptiveReferences Whether a description that stands for an
	// entity ("the wily hero") counts as a mention of it, beside its name.
	IncludeDescriptiveReferences *bool `json:"includeDescriptiveReferences,omitempty"`
	// Language The language the annotations' own text is written in. BCP 47.
	Language *string `json:"language,omitempty"`
	// SourceLanguage The language of the resource being read. BCP 47.
	SourceLanguage *string `json:"sourceLanguage,omitempty"`
}

func (LinkingJobParams) memberOfMarkJobParams() {}
func (LinkingJobParams) told() (string, string) { return "motivation", "linking" }

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v LinkingJobParams) MarshalJSON() ([]byte, error) {
	type written LinkingJobParams
	v.EntityTypes = listOf(v.EntityTypes)
	return json.Marshal(written(v))
}

type LinkingJobParamsMotivation string

// The values of LinkingJobParamsMotivation.
const (
	LinkingJobParamsMotivationLinking LinkingJobParamsMotivation = "linking"
)

// Valid is whether e is one of LinkingJobParamsMotivation's values.
func (e LinkingJobParamsMotivation) Valid() bool {
	switch e {
	case LinkingJobParamsMotivationLinking:
		return true
	}
	return false
}

type ListResourcesResponse struct {
	Resources []ResourceDescriptor `json:"resources"`
	Total     float64              `json:"total"`
	Offset    float64              `json:"offset"`
	Limit     float64              `json:"limit"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ListResourcesResponse) MarshalJSON() ([]byte, error) {
	type written ListResourcesResponse
	v.Resources = listOf(v.Resources)
	return json.Marshal(written(v))
}

// LocalEndpoint A knowledge base the host process has loaded and reaches
// through a transport with no wire.
type LocalEndpoint struct {
	// Kind Discriminant: the endpoint is in the host process.
	Kind LocalEndpointKind `json:"kind"`
	// KbId Which loaded knowledge base, named by an id that means something to
	// the host process alone.
	KbId string `json:"kbId"`
}

func (LocalEndpoint) memberOfKbEndpoint()    {}
func (LocalEndpoint) told() (string, string) { return "kind", "local" }

// LocalEndpointKind Discriminant: the endpoint is in the host process.
type LocalEndpointKind string

// The values of LocalEndpointKind.
const (
	LocalEndpointKindLocal LocalEndpointKind = "local"
)

// Valid is whether e is one of LocalEndpointKind's values.
func (e LocalEndpointKind) Valid() bool {
	switch e {
	case LocalEndpointKindLocal:
		return true
	}
	return false
}

// LocalTarget A local knowledge base, named explicitly: the operations that
// act on one local stack and never resolve one for the caller (identity
// administration, a service's run).
type LocalTarget struct {
	// Kind Only a local stack.
	Kind LocalTargetKind `json:"kind"`
	// Root The knowledge base's clone, by its path.
	Root string `json:"root"`
}

// LocalTargetKind Only a local stack.
type LocalTargetKind string

// The values of LocalTargetKind.
const (
	LocalTargetKindLocal LocalTargetKind = "local"
)

// Valid is whether e is one of LocalTargetKind's values.
func (e LocalTargetKind) Valid() bool {
	switch e {
	case LocalTargetKindLocal:
		return true
	}
	return false
}

// LogFormat How each log line is written to stdout
// (service-telemetry/log-lines.json): `json`, one JSON object per line; or
// `simple`, a line of words followed by any metadata as JSON.
type LogFormat string

// The values of LogFormat.
const (
	LogFormatJson   LogFormat = "json"
	LogFormatSimple LogFormat = "simple"
)

// Valid is whether e is one of LogFormat's values.
func (e LogFormat) Valid() bool {
	switch e {
	case LogFormatJson, LogFormatSimple:
		return true
	}
	return false
}

// LogLevel How much a service logs: the least severe level it writes, from
// error, the most severe, to debug.
type LogLevel string

// The values of LogLevel.
const (
	LogLevelError LogLevel = "error"
	LogLevelWarn  LogLevel = "warn"
	LogLevelInfo  LogLevel = "info"
	LogLevelHttp  LogLevel = "http"
	LogLevelDebug LogLevel = "debug"
)

// Valid is whether e is one of LogLevel's values.
func (e LogLevel) Valid() bool {
	switch e {
	case LogLevelError, LogLevelWarn, LogLevelInfo, LogLevelHttp, LogLevelDebug:
		return true
	}
	return false
}

// LogRecord One line one of a stack's services wrote. The launcher removes
// from it each secret value the launcher generated or read; anything else the
// service wrote is the client's to handle. The launcher keeps no copy.
type LogRecord struct {
	RequestId RequestId `json:"requestId"`
	// Service The role whose container wrote the line, as xynolog status names
	// it.
	Service string `json:"service"`
	// Stream Which of the container's streams the line was on.
	Stream OutputStream `json:"stream"`
	// Line The line, without its newline.
	Line string `json:"line"`
	// ReceivedAt When the launcher read the line, in RFC 3339 with its fraction:
	// a container's own lines carry the time it wrote them, if any.
	ReceivedAt string `json:"receivedAt"`
}

// LogsFollowParams logs.follow's params.
type LogsFollowParams struct {
	// ApiVersion The version of the control API the request is written to.
	ApiVersion ApiVersion `json:"apiVersion"`
	// Target Which knowledge base's stack. Absent: the one the command line
	// chooses, standing where the control server was started.
	Target *Target `json:"target,omitempty"`
	// Runtime Keep to the local stacks, as --runtime does.
	Runtime *Runtime `json:"runtime,omitempty"`
	// Service Just this service's container, as --service names it. Absent: each
	// Xynolog service the stack runs.
	Service *string `json:"service,omitempty"`
}

// LogsFollowResult A follow whose every source ended on its own. A follow the
// client cancels is answered with control.cancelled.
type LogsFollowResult struct {
	// Services The services that were followed.
	Services []string `json:"services"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v LogsFollowResult) MarshalJSON() ([]byte, error) {
	type written LogsFollowResult
	v.Services = listOf(v.Services)
	return json.Marshal(written(v))
}

// MarkArchiveCommand Bus command to archive a resource and optionally remove
// its file.
type MarkArchiveCommand struct {
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId     *UserId    `json:"_userId,omitempty"`
	ResourceId ResourceId `json:"resourceId"`
	// StorageUri Optional: where the resource's bytes live, so the archive can
	// act on the file. An instruction to this handler, not a copy of the stored
	// fact (that lives on the primary Representation). Working-tree URI, only
	// file:// is supported.
	StorageUri *string `json:"storageUri,omitempty"`
	KeepFile   *bool   `json:"keepFile,omitempty"`
}

// MarkCommitCommand Bus command to persist a detection unit's annotations as
// one acknowledged batch. It is answered only after every annotation is in
// the event log, so a worker can gate unit completion on durability rather
// than on emission. The batch is the unit: a partial commit is reported as a
// failure, and the worker retries the whole unit, which is safe because
// annotation ids are deterministic: content-addressed, so re-emitting one is
// a no-op.
type MarkCommitCommand struct {
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId *UserId `json:"_userId,omitempty"`
	// Roles The emitter's capabilities (the token's `roles`), injected by the
	// /bus/emit gateway. Clients do not set this. An emitter carrying the worker
	// role must cite the job this batch fulfils in `jobId`; the Stower refuses
	// the batch otherwise.
	Roles *[]string `json:"_roles,omitempty"`
	// JobId The job this batch fulfils. Required when the emitter carries the
	// worker role; absent for self-initiated work (a person, or an agent acting
	// on its own). The knowledge base derives who requested these annotations
	// from the cited job's own events — the emitter never says who the work was
	// for.
	JobId *JobId `json:"jobId,omitempty"`
	// ResourceId Resource every annotation in this batch targets.
	ResourceId ResourceId `json:"resourceId"`
	// Annotations The unit's annotations, already built with deterministic ids.
	// Re-committing an identical batch is a no-op rather than a duplicate.
	Annotations []Annotation `json:"annotations"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v MarkCommitCommand) MarshalJSON() ([]byte, error) {
	type written MarkCommitCommand
	v.Annotations = listOf(v.Annotations)
	return json.Marshal(written(v))
}

// MarkCommitOk Durability acknowledgement for a mark:commit batch: every
// annotation named by the command is in the event log at the moment this is
// emitted.
type MarkCommitOk struct {
	// Response What the commit persisted.
	Response MarkCommitOkResponse `json:"response"`
}

// MarkCommitOkResponse What the commit persisted.
type MarkCommitOkResponse struct {
	// Persisted Annotations the command named that are durable in the event log.
	// Equals the batch size on success, on a first commit and on a retry alike —
	// the commit appends only what the resource does not already hold, so a
	// wholly-redundant retry has still succeeded and says so. Not an append
	// tally: a caller must never have to read a 0 as 'all good'.
	Persisted int `json:"persisted"`
	// AnnotationIds Ids the batch covers, whether appended now or already
	// present.
	AnnotationIds []AnnotationId `json:"annotationIds"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v MarkCommitOkResponse) MarshalJSON() ([]byte, error) {
	type written MarkCommitOkResponse
	v.AnnotationIds = listOf(v.AnnotationIds)
	return json.Marshal(written(v))
}

// MarkCreateOk Success reply after creating an annotation, matched to the
// originating command by correlationId.
type MarkCreateOk struct {
	Response MarkCreateOkResponse `json:"response"`
}

// MarkCreateOkResponse The created annotation's identity.
type MarkCreateOkResponse struct {
	AnnotationId AnnotationId `json:"annotationId"`
}

// MarkCreateRequest Raw annotation creation intent — bus handler assembles
// the W3C annotation
type MarkCreateRequest struct {
	ResourceId ResourceId              `json:"resourceId"`
	Request    CreateAnnotationRequest `json:"request"`
}

// MarkDelegateTimeoutEvent The payload of `mark:delegate-timeout`, a
// client-local signal: a delegated job went silent past its deadline, with no
// progress, no completion and no `job:fail`. A real job failure arrives as
// `job:fail` and never produces this.
type MarkDelegateTimeoutEvent struct {
	// ResourceId The resource the job was delegated for.
	ResourceId ResourceId `json:"resourceId"`
	Motivation Motivation `json:"motivation"`
}

// MarkDeleteCommand Bus command to delete an annotation.
type MarkDeleteCommand struct {
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId       *UserId      `json:"_userId,omitempty"`
	AnnotationId AnnotationId `json:"annotationId"`
	ResourceId   *ResourceId  `json:"resourceId,omitempty"`
}

// MarkDeleteOk Success reply after deleting an annotation, matched to the
// originating command by correlationId.
type MarkDeleteOk struct {
	// Response The deleted annotation's identity.
	Response MarkDeleteOkResponse `json:"response"`
}

// MarkDeleteOkResponse The deleted annotation's identity.
type MarkDeleteOkResponse struct {
	AnnotationId AnnotationId `json:"annotationId"`
}

// MarkJobCompleteCommand A `mark` job's worker says the job is complete, with
// what a `mark` job reports.
type MarkJobCompleteCommand struct {
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId     *UserId                       `json:"_userId,omitempty"`
	ResourceId ResourceId                    `json:"resourceId"`
	JobId      JobId                         `json:"jobId"`
	JobType    MarkJobCompleteCommandJobType `json:"jobType"`
	// Attempt Which attempt produced this event, 1-based (a first run is 1).
	// ALWAYS present: the queue re-runs a failed job silently, so an operator
	// reading progress or a terminal record has no other way to tell a re-run
	// from a first run — and provider spend, already counted in
	// xynolog_inference_tokens_total, cannot be attributed to a repeated
	// document without it. Stated rather than inferred from absence, because
	// 'attempt 1' is a fact the emitter always knows.
	Attempt    *int                `json:"attempt,omitempty"`
	Result     *MarkJobResult      `json:"result,omitempty"`
	Durability *DurabilityEvidence `json:"durability,omitempty"`
}

func (MarkJobCompleteCommand) memberOfJobCompleteCommand() {}
func (MarkJobCompleteCommand) told() (string, string)      { return "jobType", "mark" }

type MarkJobCompleteCommandJobType string

// The values of MarkJobCompleteCommandJobType.
const (
	MarkJobCompleteCommandJobTypeMark MarkJobCompleteCommandJobType = "mark"
)

// Valid is whether e is one of MarkJobCompleteCommandJobType's values.
func (e MarkJobCompleteCommandJobType) Valid() bool {
	switch e {
	case MarkJobCompleteCommandJobTypeMark:
		return true
	}
	return false
}

// MarkJobCreateCommand Create a `mark` job: annotate one resource for one
// motivation.
type MarkJobCreateCommand struct {
	// UserId The emitter's verified DID, injected by the gateway. Clients do not
	// set this.
	UserId *UserId `json:"_userId,omitempty"`
	// Roles The emitter's roles, injected by the gateway when it has any.
	// Clients do not set this.
	Roles   *[]string                   `json:"_roles,omitempty"`
	JobType MarkJobCreateCommandJobType `json:"jobType"`
	// ResourceId The resource to annotate.
	ResourceId ResourceId    `json:"resourceId"`
	Params     MarkJobParams `json:"params"`
}

func (MarkJobCreateCommand) memberOfJobCreateCommand() {}
func (MarkJobCreateCommand) told() (string, string)    { return "jobType", "mark" }

type MarkJobCreateCommandJobType string

// The values of MarkJobCreateCommandJobType.
const (
	MarkJobCreateCommandJobTypeMark MarkJobCreateCommandJobType = "mark"
)

// Valid is whether e is one of MarkJobCreateCommandJobType's values.
func (e MarkJobCreateCommandJobType) Valid() bool {
	switch e {
	case MarkJobCreateCommandJobTypeMark:
		return true
	}
	return false
}

// MarkJobDone What a `mark` job reports when it has done its work, whatever
// its motivation.
type MarkJobDone struct {
	// Found What the model proposed, before anything was checked against the
	// text.
	Found int `json:"found"`
	// Persisted What the log holds: the annotations committed, after the ones
	// that could not be anchored were dropped and repeats were collapsed.
	Persisted int `json:"persisted"`
	// Errors How many of the proposed could not be anchored in the text. Absent
	// means none.
	Errors *int `json:"errors,omitempty"`
	// ByCategory The annotations persisted per category. A tagging job's; absent
	// from every other.
	ByCategory *map[string]int `json:"byCategory,omitempty"`
	// UnderReportedPieces Total floor-accepted under-reported pieces across the
	// job's units. Absent means none — the per-unit evidence rides the terminal
	// progress frame's completedItems; this keeps the result self-describing
	// without the progress stream.
	UnderReportedPieces *int `json:"underReportedPieces,omitempty"`
	// UncheckedPieces Pieces whose yield was to be checked against a count and
	// was not: the count failed, was cut off, or answered no count. What they
	// found was kept unchecked. Absent means none: every piece that was to be
	// checked was. A job whose provider checks no yield has none.
	UncheckedPieces *int `json:"uncheckedPieces,omitempty"`
}

func (MarkJobDone) memberOfJobResult()     {}
func (MarkJobDone) memberOfMarkJobResult() {}

// MarkJobFilter `mark` jobs of one motivation.
type MarkJobFilter struct {
	JobType MarkJobFilterJobType `json:"jobType"`
	Params  MarkJobFilterParams  `json:"params"`
}

func (MarkJobFilter) memberOfJobFilter()     {}
func (MarkJobFilter) told() (string, string) { return "jobType", "mark" }

type MarkJobFilterJobType string

// The values of MarkJobFilterJobType.
const (
	MarkJobFilterJobTypeMark MarkJobFilterJobType = "mark"
)

// Valid is whether e is one of MarkJobFilterJobType's values.
func (e MarkJobFilterJobType) Valid() bool {
	switch e {
	case MarkJobFilterJobTypeMark:
		return true
	}
	return false
}

type MarkJobFilterParams struct {
	Motivation Motivation `json:"motivation"`
}

// MarkJobParams The parameters of a `mark` job, told apart by `motivation`.
// Each motivation takes its own parameters and no others: a parameter a job
// does not take is refused where the job is created.
type MarkJobParams struct {
	union[MarkJobParamsMember]
}

// MarkJobParamsMember is a member of MarkJobParams: HighlightingJobParams,
// CommentingJobParams, AssessingJobParams, LinkingJobParams,
// TaggingJobParams.
type MarkJobParamsMember interface {
	memberOfMarkJobParams()
}

// Discriminator is the `motivation` this value states.
func (u MarkJobParams) Discriminator() (string, error) { return u.stated("motivation") }

// Member is the member this value is: the one whose schema admits it.
func (u MarkJobParams) Member() (any, error) { return u.member("MarkJobParams", markJobParamsMembers) }

// markJobParamsMembers is what each member of MarkJobParams admits, and how a
// value of it is read.
var markJobParamsMembers = []unionMember{
	{"HighlightingJobParams", readAs[HighlightingJobParams], []signature{{kind: objectKind, required: []string{"motivation"}, allowed: []string{"motivation", "instructions", "density", "sourceLanguage"}, fixed: []fixedValues{{"motivation", []any{"highlighting"}}}}}},
	{"CommentingJobParams", readAs[CommentingJobParams], []signature{{kind: objectKind, required: []string{"motivation"}, allowed: []string{"motivation", "instructions", "tone", "density", "language", "sourceLanguage"}, fixed: []fixedValues{{"motivation", []any{"commenting"}}, {"tone", []any{"scholarly", "explanatory", "conversational", "technical"}}}}}},
	{"AssessingJobParams", readAs[AssessingJobParams], []signature{{kind: objectKind, required: []string{"motivation"}, allowed: []string{"motivation", "instructions", "tone", "density", "language", "sourceLanguage"}, fixed: []fixedValues{{"motivation", []any{"assessing"}}, {"tone", []any{"analytical", "critical", "balanced", "constructive"}}}}}},
	{"LinkingJobParams", readAs[LinkingJobParams], []signature{{kind: objectKind, required: []string{"motivation", "entityTypes"}, allowed: []string{"motivation", "entityTypes", "includeDescriptiveReferences", "language", "sourceLanguage"}, fixed: []fixedValues{{"motivation", []any{"linking"}}}}}},
	{"TaggingJobParams", readAs[TaggingJobParams], []signature{{kind: objectKind, required: []string{"motivation", "schemaId", "categories"}, allowed: []string{"motivation", "schemaId", "categories", "language", "sourceLanguage"}, fixed: []fixedValues{{"motivation", []any{"tagging"}}}}}},
}

// MarkJobQueuedEvent A pending `mark` job, announced with its parameters as
// it was created.
type MarkJobQueuedEvent struct {
	JobId   JobId                     `json:"jobId"`
	JobType MarkJobQueuedEventJobType `json:"jobType"`
	// ResourceId The resource the job is about.
	ResourceId ResourceId `json:"resourceId"`
	// UserId The DID of the principal whose `job:create` created the job.
	UserId UserId        `json:"userId"`
	Params MarkJobParams `json:"params"`
}

func (MarkJobQueuedEvent) memberOfJobQueuedEvent() {}
func (MarkJobQueuedEvent) told() (string, string)  { return "jobType", "mark" }

type MarkJobQueuedEventJobType string

// The values of MarkJobQueuedEventJobType.
const (
	MarkJobQueuedEventJobTypeMark MarkJobQueuedEventJobType = "mark"
)

// Valid is whether e is one of MarkJobQueuedEventJobType's values.
func (e MarkJobQueuedEventJobType) Valid() bool {
	switch e {
	case MarkJobQueuedEventJobTypeMark:
		return true
	}
	return false
}

// MarkJobResult What a `mark` job reports when it concludes without failing:
// its counts, or a decline. Neither names its kind: a decline is the one with
// `declined`.
type MarkJobResult struct {
	union[MarkJobResultMember]
}

// MarkJobResultMember is a member of MarkJobResult: MarkJobDone, JobDeclined.
type MarkJobResultMember interface {
	memberOfMarkJobResult()
}

// Member is the member this value is: the one whose schema admits it.
func (u MarkJobResult) Member() (any, error) { return u.member("MarkJobResult", markJobResultMembers) }

// markJobResultMembers is what each member of MarkJobResult admits, and how a
// value of it is read.
var markJobResultMembers = []unionMember{
	{"MarkJobDone", readAs[MarkJobDone], []signature{{kind: objectKind, required: []string{"found", "persisted"}, allowed: []string{"found", "persisted", "errors", "byCategory", "underReportedPieces", "uncheckedPieces"}}}},
	{"JobDeclined", readAs[JobDeclined], []signature{{kind: objectKind, required: []string{"declined", "reason"}, allowed: []string{"declined", "reason"}, fixed: []fixedValues{{"declined", []any{true}}, {"reason", []any{"no-text-layer", "encrypted", "corrupt", "too-large", "empty"}}}}}},
}

// MarkRequestedEvent Emitted when the user requests a new mark (annotation)
// on a resource
type MarkRequestedEvent struct {
	// Source The '@id' of the resource the mark belongs to (W3C target.source).
	// Routes the event to the right viewer/state unit when a host mounts many
	// viewers on one session.
	Source ResourceId `json:"source"`
	// Selector One or more W3C selectors
	Selector   AnnotationSelector `json:"selector"`
	Motivation Motivation         `json:"motivation"`
}

// MarkSubmitEvent Emitted when a mark is submitted with its annotation body
type MarkSubmitEvent struct {
	// Source The '@id' of the resource the mark belongs to (W3C target.source).
	// Routes the submit to the state unit bound to that resource — without it, N
	// mounted units each create the annotation (N copies on N resources).
	Source     ResourceId `json:"source"`
	Motivation Motivation `json:"motivation"`
	// Selector One or more W3C selectors
	Selector AnnotationSelector `json:"selector"`
	// Body Optional body. Omit for annotations whose motivation alone is
	// meaningful (e.g. highlighting) or whose user-supplied content is empty
	// (e.g. an assessing annotation saved without comment text). Shape matches
	// Annotation.body.
	Body *AnnotationBodies `json:"body,omitempty"`
}

// MarkUnarchiveCommand Bus command to unarchive a previously archived
// resource.
type MarkUnarchiveCommand struct {
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId     *UserId    `json:"_userId,omitempty"`
	ResourceId ResourceId `json:"resourceId"`
	// StorageUri Optional: where the resource's bytes are expected to be. When
	// present the handler VERIFIES the file exists and fails loudly if it does
	// not, rather than succeeding as a no-op. An instruction, not a copy of the
	// stored fact (that lives on the primary Representation). Working-tree URI,
	// only file:// is supported.
	StorageUri *string `json:"storageUri,omitempty"`
}

// MarkUpdateBodyCommand Bus command to update an annotation's body with patch
// operations.
type MarkUpdateBodyCommand struct {
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId       *UserId         `json:"_userId,omitempty"`
	AnnotationId AnnotationId    `json:"annotationId"`
	ResourceId   ResourceId      `json:"resourceId"`
	Operations   []BodyOperation `json:"operations"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v MarkUpdateBodyCommand) MarshalJSON() ([]byte, error) {
	type written MarkUpdateBodyCommand
	v.Operations = listOf(v.Operations)
	return json.Marshal(written(v))
}

// MarkUpdateEntityTypesCommand Bus command to replace the entity types on a
// resource.
type MarkUpdateEntityTypesCommand struct {
	ResourceId ResourceId `json:"resourceId"`
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId             *UserId  `json:"_userId,omitempty"`
	CurrentEntityTypes []string `json:"currentEntityTypes"`
	UpdatedEntityTypes []string `json:"updatedEntityTypes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v MarkUpdateEntityTypesCommand) MarshalJSON() ([]byte, error) {
	type written MarkUpdateEntityTypesCommand
	v.CurrentEntityTypes = listOf(v.CurrentEntityTypes)
	v.UpdatedEntityTypes = listOf(v.UpdatedEntityTypes)
	return json.Marshal(written(v))
}

// MatchQuality Which looser search found a quoted selection, stated of a span
// whose `anchorMethod` is `fuzzy-match` and only then. Which search finds it
// is reconcile's rule (specs/src/annotations/reconcile-cases.json).
type MatchQuality string

// The values of MatchQuality.
const (
	MatchQualityNormalized      MatchQuality = "normalized"
	MatchQualityCaseInsensitive MatchQuality = "case-insensitive"
	MatchQualityFuzzy           MatchQuality = "fuzzy"
)

// Valid is whether e is one of MatchQuality's values.
func (e MatchQuality) Valid() bool {
	switch e {
	case MatchQualityNormalized, MatchQualityCaseInsensitive, MatchQualityFuzzy:
		return true
	}
	return false
}

// MatchResourcesRequest Request to search the knowledge base's resources by
// text. The Librarian answers: it matches the text lexically, and when
// nothing matches, by meaning.
type MatchResourcesRequest struct {
	// Search The text to search for.
	Search     string  `json:"search"`
	Archived   *bool   `json:"archived,omitempty"`
	EntityType *string `json:"entityType,omitempty"`
	// Offset How many of the resources the search finds are passed over before
	// the page begins.
	Offset *int `json:"offset,omitempty"`
	// Limit The most resources a page has.
	Limit *int `json:"limit,omitempty"`
}

// MatchResourcesResponse One page of the resources a text search found, and
// which kind of answer it is.
type MatchResourcesResponse struct {
	Resources []ResourceDescriptor `json:"resources"`
	// Total How many resources the search found in all, and not only on this
	// page.
	Total int `json:"total"`
	// Offset How many of the resources the search found were passed over before
	// this page, as the request stated.
	Offset int `json:"offset"`
	// Limit The limit the search was made with.
	Limit int `json:"limit"`
	// MatchKind What kind of answer this is: 'lexical' — the resources matched
	// the query text; 'semantic' — no lexical match existed, and these resources
	// discuss the query per the vector index. Required so every producer labels
	// its answer; a UI can render semantic results as a different kind of page
	// ('no title matches, but these documents discuss it').
	MatchKind MatchResourcesResponseMatchKind `json:"matchKind"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v MatchResourcesResponse) MarshalJSON() ([]byte, error) {
	type written MatchResourcesResponse
	v.Resources = listOf(v.Resources)
	return json.Marshal(written(v))
}

// MatchResourcesResponseMatchKind What kind of answer this is: 'lexical' —
// the resources matched the query text; 'semantic' — no lexical match
// existed, and these resources discuss the query per the vector index.
// Required so every producer labels its answer; a UI can render semantic
// results as a different kind of page ('no title matches, but these documents
// discuss it').
type MatchResourcesResponseMatchKind string

// The values of MatchResourcesResponseMatchKind.
const (
	MatchResourcesResponseMatchKindLexical  MatchResourcesResponseMatchKind = "lexical"
	MatchResourcesResponseMatchKindSemantic MatchResourcesResponseMatchKind = "semantic"
)

// Valid is whether e is one of MatchResourcesResponseMatchKind's values.
func (e MatchResourcesResponseMatchKind) Valid() bool {
	switch e {
	case MatchResourcesResponseMatchKindLexical, MatchResourcesResponseMatchKindSemantic:
		return true
	}
	return false
}

// MatchResourcesResult Result of searching resources by text
type MatchResourcesResult struct {
	Response MatchResourcesResponse `json:"response"`
}

// MatchSearchFailed The payload of `match:search-failed`: a CommandError that
// names the reference whose candidates could not be searched for.
type MatchSearchFailed struct {
	// Code Machine-readable failure class, for consumers that must BRANCH on why
	// a command failed rather than log it. Optional and deliberately sparse:
	// absent means 'no class declared', and every existing failure stays that
	// way. An enum rather than a free string so the vocabulary has an owner — an
	// unconstrained code is a mirror with no gate, and adding one should be a
	// deliberate spec change. `message` remains the human-readable text and is
	// unaffected. Members: `peer-unavailable` — the channel this command was
	// sent on has no subscriber, i.e. the service that answers it has not
	// connected yet. Transient by nature (a peer still starting), which is what
	// distinguishes it from a refusal: retrying is the correct response.
	// `not-found` — the resource this command addressed does not exist in this
	// knowledge base. A verdict, not a symptom: it is emitted only where the
	// answer comes from the event store, which is the system of record, and
	// never from a projection that may merely be lagging. Deterministic, so
	// unlike `peer-unavailable` retrying is pointless — and consumers may act
	// destructively on it (the SDK deletes a restored tab). Absence is not
	// denial: a future 'exists, but not for you' must travel as its own code,
	// never as this one. `unauthorized` — that code: the caller is authenticated
	// but not permitted to do what it asked. A verdict about the CALLER, not the
	// resource, so retrying under the same credential cannot succeed and a
	// consumer must never spin on it; emitted by `job:claim` for a caller whose
	// token carries no worker role. `none-pending` — a declined claim, not an
	// error: the queue holds no pending job of the requested types. Nothing went
	// wrong; the one code a consumer PARKS on, meaning 'nothing to do until a
	// wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying
	// neither is unclassified — a malformed record or a missing injection — and
	// a consumer treats it as 'log it, assume nothing'.
	Code *CommandErrorCode `json:"code,omitempty"`
	// Message Human-readable error message
	Message string `json:"message"`
	// Details Optional additional context (stack trace, field name, etc.)
	Details *string `json:"details,omitempty"`
	// ReferenceId The reference the search was asked for.
	ReferenceId AnnotationId `json:"referenceId"`
}

// MatchSearchOptions What a search for what a reference could refer to is
// told beside the reference and its context: MatchSearchRequest's other
// members. client/surface.json's `match.search` cases state what is sent for
// one left out.
type MatchSearchOptions struct {
	// Limit Maximum number of candidate results to return
	Limit *int `json:"limit,omitempty"`
	// UseSemanticScoring Enable semantic similarity scoring in addition to
	// keyword matching
	UseSemanticScoring *bool `json:"useSemanticScoring,omitempty"`
}

// MatchSearchRequest Request payload sent on the match:search-request bus
// channel to find candidate matches.
type MatchSearchRequest struct {
	// ResourceId Resource ID the reference annotation belongs to. Used to scope
	// result events on the EventBus so the events-stream delivers them to
	// participants viewing this resource.
	ResourceId ResourceId `json:"resourceId"`
	// ReferenceId Annotation ID of the reference to search candidates for
	ReferenceId AnnotationId `json:"referenceId"`
	// Context Gathered context for the reference annotation
	Context GatheredContext `json:"context"`
	// Limit Maximum number of candidate results to return
	Limit *int `json:"limit,omitempty"`
	// UseSemanticScoring Enable semantic similarity scoring in addition to
	// keyword matching
	UseSemanticScoring *bool `json:"useSemanticScoring,omitempty"`
}

// MatchSearchResult Search results payload emitted on match:search-results
// SSE channel.
type MatchSearchResult struct {
	ReferenceId AnnotationId `json:"referenceId"`
	// Response The scored candidates, best first.
	Response []ScoredResource `json:"response"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v MatchSearchResult) MarshalJSON() ([]byte, error) {
	type written MatchSearchResult
	v.Response = listOf(v.Response)
	return json.Marshal(written(v))
}

type MediaTokenRequest struct {
	// ResourceId The resource ID to generate a media token for
	ResourceId ResourceId `json:"resourceId"`
}

type MediaTokenResponse struct {
	// Token Short-lived media token for use as ?token= query parameter on
	// resource URLs
	Token string `json:"token"`
}

// MediaTypesRegistry media-types/registry.json: the media types a knowledge
// base admits, and what the system can do with each.
type MediaTypesRegistry struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Render The viewers a reader mounts.
	Render []string `json:"render"`
	// Anchoring The annotation models.
	Anchoring []string `json:"anchoring"`
	// TextSource Where a type's text comes from.
	TextSource []string `json:"textSource"`
	// ExtensionAliases Each extension another stands for, by the extension that
	// stands for it.
	ExtensionAliases map[string]string `json:"extensionAliases"`
	// MediaTypes One row for each member of SupportedMediaType.
	MediaTypes []MediaTypesRegistryMediaTypesItem `json:"mediaTypes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v MediaTypesRegistry) MarshalJSON() ([]byte, error) {
	type written MediaTypesRegistry
	v.Render = listOf(v.Render)
	v.Anchoring = listOf(v.Anchoring)
	v.TextSource = listOf(v.TextSource)
	v.MediaTypes = listOf(v.MediaTypes)
	return json.Marshal(written(v))
}

type MediaTypesRegistryMediaTypesItem struct {
	MediaType SupportedMediaType `json:"mediaType"`
	// Extension A file extension, with its dot.
	Extension string `json:"extension"`
	// Label The name a person reads.
	Label string `json:"label"`
	// Render The viewer a reader mounts, one of `render`.
	Render string `json:"render"`
	// Anchoring The annotation model, one of `anchoring`.
	Anchoring string `json:"anchoring"`
	// TextSource Where its text comes from, one of `textSource`.
	TextSource  string `json:"textSource"`
	Authorable  bool   `json:"authorable"`
	Uploadable  bool   `json:"uploadable"`
	Generatable bool   `json:"generatable"`
}

// MemoryGraphConfig A graph held in the memory of the one process that is
// given it: for a test. It cannot be shared between processes, so a service
// that writes the graph for another to read, or reads what another wrote,
// refuses it.
type MemoryGraphConfig struct {
	Type MemoryGraphConfigType `json:"type"`
}

func (MemoryGraphConfig) memberOfGraphConfig()   {}
func (MemoryGraphConfig) told() (string, string) { return "type", "memory" }

type MemoryGraphConfigType string

// The values of MemoryGraphConfigType.
const (
	MemoryGraphConfigTypeMemory MemoryGraphConfigType = "memory"
)

// Valid is whether e is one of MemoryGraphConfigType's values.
func (e MemoryGraphConfigType) Valid() bool {
	switch e {
	case MemoryGraphConfigTypeMemory:
		return true
	}
	return false
}

// MemoryVectorsConfig A vector index held in the memory of the one process
// that is given it: for a test. It cannot be shared between processes, so a
// service that writes the index for another to search, or searches what
// another wrote, refuses it.
type MemoryVectorsConfig struct {
	Type MemoryVectorsConfigType `json:"type"`
}

func (MemoryVectorsConfig) memberOfVectorsConfig() {}
func (MemoryVectorsConfig) told() (string, string) { return "type", "memory" }

type MemoryVectorsConfigType string

// The values of MemoryVectorsConfigType.
const (
	MemoryVectorsConfigTypeMemory MemoryVectorsConfigType = "memory"
)

// Valid is whether e is one of MemoryVectorsConfigType's values.
func (e MemoryVectorsConfigType) Valid() bool {
	switch e {
	case MemoryVectorsConfigTypeMemory:
		return true
	}
	return false
}

// Metadata What names a document, as Kubernetes names an object. Documents
// refer to one another by `name`.
type Metadata struct {
	// Name The document's name: lower-case letters, digits and `-`, beginning
	// and ending with a letter or digit. It names the document, never the
	// knowledge base.
	Name string `json:"name"`
	// Namespace The Kubernetes namespace the document belongs in. The launcher
	// reads none.
	Namespace *string `json:"namespace,omitempty"`
	// Labels Kubernetes labels. The launcher reads none.
	Labels *map[string]string `json:"labels,omitempty"`
	// Annotations Kubernetes annotations. The launcher reads none.
	Annotations *map[string]string `json:"annotations,omitempty"`
}

// Motivation Xynolog-supported W3C Web Annotation motivations -
// https://www.w3.org/TR/annotation-vocab/#motivation
type Motivation string

// The values of Motivation.
const (
	MotivationAssessing    Motivation = "assessing"
	MotivationCommenting   Motivation = "commenting"
	MotivationHighlighting Motivation = "highlighting"
	MotivationLinking      Motivation = "linking"
	MotivationTagging      Motivation = "tagging"
)

// Valid is whether e is one of Motivation's values.
func (e Motivation) Valid() bool {
	switch e {
	case MotivationAssessing, MotivationCommenting, MotivationHighlighting, MotivationLinking, MotivationTagging:
		return true
	}
	return false
}

// Neo4jGraphConfig A graph kept in a Neo4j database.
type Neo4jGraphConfig struct {
	Type Neo4jGraphConfigType `json:"type"`
	// Uri Where the database is reached (`bolt://host:7687`).
	Uri string `json:"uri"`
	// Username The user the service connects as.
	Username string `json:"username"`
	// PasswordEnv The environment variable holding that user's password. The
	// password is never a value here.
	PasswordEnv string `json:"passwordEnv"`
	// Database Which of the server's databases holds the graph.
	Database string `json:"database"`
}

func (Neo4jGraphConfig) memberOfGraphConfig()   {}
func (Neo4jGraphConfig) told() (string, string) { return "type", "neo4j" }

type Neo4jGraphConfigType string

// The values of Neo4jGraphConfigType.
const (
	Neo4jGraphConfigTypeNeo4j Neo4jGraphConfigType = "neo4j"
)

// Valid is whether e is one of Neo4jGraphConfigType's values.
func (e Neo4jGraphConfigType) Valid() bool {
	switch e {
	case Neo4jGraphConfigTypeNeo4j:
		return true
	}
	return false
}

// NeptuneGraphConfig A graph kept in Amazon Neptune, asked in Gremlin. No
// service has been run against one.
type NeptuneGraphConfig struct {
	Type NeptuneGraphConfigType `json:"type"`
	// Endpoint The cluster's endpoint: its host name.
	Endpoint string `json:"endpoint"`
	// Port The port its Gremlin endpoint listens on.
	Port int `json:"port"`
}

func (NeptuneGraphConfig) memberOfGraphConfig()   {}
func (NeptuneGraphConfig) told() (string, string) { return "type", "neptune" }

type NeptuneGraphConfigType string

// The values of NeptuneGraphConfigType.
const (
	NeptuneGraphConfigTypeNeptune NeptuneGraphConfigType = "neptune"
)

// Valid is whether e is one of NeptuneGraphConfigType's values.
func (e NeptuneGraphConfigType) Valid() bool {
	switch e {
	case NeptuneGraphConfigTypeNeptune:
		return true
	}
	return false
}

// NewKnowledgeBase What registering a knowledge base takes: everything a
// registered one holds but its id, which the client's list makes. It has a
// did, because registering follows a sign-in: the knowledge base has already
// said what it is.
type NewKnowledgeBase struct {
	// Label What a person reads the knowledge base as. Once the knowledge base
	// has described itself, its own name.
	Label    string     `json:"label"`
	Endpoint KbEndpoint `json:"endpoint"`
	// Did The did the knowledge base reported of itself.
	Did string `json:"did"`
	// LastRead The last time the knowledge base described itself. Absent until
	// it has, in an answer that carried this entry's did.
	LastRead *KbRead `json:"lastRead,omitempty"`
}

// OcrConfidence How well an OCR engine read the pixels.
type OcrConfidence struct {
	// Mean Mean per-word confidence, 0-100.
	Mean float64 `json:"mean"`
	// LowConfidenceWords Words the engine was unsure of.
	LowConfidenceWords int `json:"lowConfidenceWords"`
	TotalWords         int `json:"totalWords"`
}

// OllamaEmbeddingConfig An embedding model served by an Ollama.
type OllamaEmbeddingConfig struct {
	Type OllamaEmbeddingConfigType `json:"type"`
	// Model The model asked for, by the name the Ollama serves it under.
	Model string `json:"model"`
	// BaseUrl The address the Ollama's API is reached at (`http://host:11434`).
	BaseUrl string `json:"baseUrl"`
}

func (OllamaEmbeddingConfig) memberOfEmbeddingConfig() {}
func (OllamaEmbeddingConfig) told() (string, string)   { return "type", "ollama" }

type OllamaEmbeddingConfigType string

// The values of OllamaEmbeddingConfigType.
const (
	OllamaEmbeddingConfigTypeOllama OllamaEmbeddingConfigType = "ollama"
)

// Valid is whether e is one of OllamaEmbeddingConfigType's values.
func (e OllamaEmbeddingConfigType) Valid() bool {
	switch e {
	case OllamaEmbeddingConfigTypeOllama:
		return true
	}
	return false
}

// OneOrMoreAgents One Agent, or a non-empty list of them: the parties PROV-O
// and the Web Annotation model let a resource or an annotation name in one
// place, as one agent or several.
type OneOrMoreAgents struct {
	union[OneOrMoreAgentsMember]
}

// OneOrMoreAgentsMember is a member of OneOrMoreAgents: Agent,
// OneOrMoreAgentsList.
type OneOrMoreAgentsMember interface {
	memberOfOneOrMoreAgents()
}

// Member is the member this value is: the one whose schema admits it.
func (u OneOrMoreAgents) Member() (any, error) {
	return u.member("OneOrMoreAgents", oneOrMoreAgentsMembers)
}

// oneOrMoreAgentsMembers is what each member of OneOrMoreAgents admits, and
// how a value of it is read.
var oneOrMoreAgentsMembers = []unionMember{
	{"Agent", readAs[Agent], []signature{{kind: objectKind, required: []string{"@type"}, fixed: []fixedValues{{"@type", []any{"Person"}}}}, {kind: objectKind, required: []string{"@type", "name"}, fixed: []fixedValues{{"@type", []any{"Organization"}}}}, {kind: objectKind, required: []string{"@type"}, fixed: []fixedValues{{"@type", []any{"Software"}}}}}},
	{"OneOrMoreAgentsList", readAs[OneOrMoreAgentsList], []signature{{kind: listKind}}},
}

// OneOrMoreAgentsList is a OneOrMoreAgents that is a list.
type OneOrMoreAgentsList []Agent

func (OneOrMoreAgentsList) memberOfOneOrMoreAgents() {}

// OneOrMoreStrings One string, or a non-empty list of them: a JSON-LD term
// that may take one value or several.
type OneOrMoreStrings struct {
	union[OneOrMoreStringsMember]
}

// OneOrMoreStringsMember is a member of OneOrMoreStrings:
// OneOrMoreStringsText, OneOrMoreStringsList.
type OneOrMoreStringsMember interface {
	memberOfOneOrMoreStrings()
}

// Member is the member this value is: the one whose schema admits it.
func (u OneOrMoreStrings) Member() (any, error) {
	return u.member("OneOrMoreStrings", oneOrMoreStringsMembers)
}

// oneOrMoreStringsMembers is what each member of OneOrMoreStrings admits, and
// how a value of it is read.
var oneOrMoreStringsMembers = []unionMember{
	{"OneOrMoreStringsText", readAs[OneOrMoreStringsText], []signature{{kind: textKind}}},
	{"OneOrMoreStringsList", readAs[OneOrMoreStringsList], []signature{{kind: listKind}}},
}

// OneOrMoreStringsList is a OneOrMoreStrings that is a list.
type OneOrMoreStringsList []string

func (OneOrMoreStringsList) memberOfOneOrMoreStrings() {}

// OneOrMoreStringsText is a OneOrMoreStrings that is text.
type OneOrMoreStringsText string

func (OneOrMoreStringsText) memberOfOneOrMoreStrings() {}

// OneOrMoreUris One URI, or a non-empty list of them: a JSON-LD term that may
// name one resource or several.
type OneOrMoreUris struct {
	union[OneOrMoreUrisMember]
}

// OneOrMoreUrisMember is a member of OneOrMoreUris: OneOrMoreUrisText,
// OneOrMoreUrisList.
type OneOrMoreUrisMember interface {
	memberOfOneOrMoreUris()
}

// Member is the member this value is: the one whose schema admits it.
func (u OneOrMoreUris) Member() (any, error) { return u.member("OneOrMoreUris", oneOrMoreUrisMembers) }

// oneOrMoreUrisMembers is what each member of OneOrMoreUris admits, and how a
// value of it is read.
var oneOrMoreUrisMembers = []unionMember{
	{"OneOrMoreUrisText", readAs[OneOrMoreUrisText], []signature{{kind: textKind}}},
	{"OneOrMoreUrisList", readAs[OneOrMoreUrisList], []signature{{kind: listKind}}},
}

// OneOrMoreUrisList is a OneOrMoreUris that is a list.
type OneOrMoreUrisList []string

func (OneOrMoreUrisList) memberOfOneOrMoreUris() {}

// OneOrMoreUrisText is a OneOrMoreUris that is text.
type OneOrMoreUrisText string

func (OneOrMoreUrisText) memberOfOneOrMoreUris() {}

// OpenResource A resource open in a knowledge base: which resource, the name
// it is shown by, when it was opened and its place among the others open
// there. A registry shows them by their places, and two in one place by when
// each was opened, first first.
type OpenResource struct {
	// Id The resource.
	Id ResourceId `json:"id"`
	// Name The name the resource is shown by.
	Name string `json:"name"`
	// OpenedAt When the resource was opened, in milliseconds since the Unix
	// epoch. Opening it again while it is open changes neither this nor its
	// place.
	OpenedAt int `json:"openedAt"`
	// Order The resource's place among those open in the knowledge base. One
	// opened is given the place after the last taken, so a place freed by
	// closing one is not given twice; a move gives each its place in the new
	// order, counted from 0.
	Order int `json:"order"`
	// MediaType The resource's media type, which its icon is chosen by. Absent
	// when it is not known.
	MediaType *string `json:"mediaType,omitempty"`
	// StorageUri Where the resource is in the knowledge base's working tree, as
	// a URI (file://docs/overview.md). Absent when it is not known.
	StorageUri *string `json:"storageUri,omitempty"`
}

// OutputStream Which of a container's streams a line was on.
type OutputStream string

// The values of OutputStream.
const (
	OutputStreamStdout OutputStream = "stdout"
	OutputStreamStderr OutputStream = "stderr"
)

// Valid is whether e is one of OutputStream's values.
func (e OutputStream) Valid() bool {
	switch e {
	case OutputStreamStdout, OutputStreamStderr:
		return true
	}
	return false
}

// PdfClass The class a PDF is sorted into, which decides how its text is
// read. smelter/extraction-cases.json states what each class is.
type PdfClass string

// The values of PdfClass.
const (
	PdfClassA PdfClass = "A"
	PdfClassB PdfClass = "B"
	PdfClassC PdfClass = "C"
	PdfClassD PdfClass = "D"
	PdfClassE PdfClass = "E"
	PdfClassF PdfClass = "F"
	PdfClassG PdfClass = "G"
)

// Valid is whether e is one of PdfClass's values.
func (e PdfClass) Valid() bool {
	switch e {
	case PdfClassA, PdfClassB, PdfClassC, PdfClassD, PdfClassE, PdfClassF, PdfClassG:
		return true
	}
	return false
}

// PdfCoordinate A rectangle on a page of a PDF, in PDF points, from the
// page's bottom-left corner with y increasing upward: what an RFC 3778
// fragment selector names.
type PdfCoordinate struct {
	// Page The page the rectangle is on.
	Page int `json:"page"`
	// X The rectangle's x.
	X float64 `json:"x"`
	// Y The rectangle's y.
	Y float64 `json:"y"`
	// Width The rectangle's width.
	Width float64 `json:"width"`
	// Height The rectangle's height.
	Height float64 `json:"height"`
}

// PdfTextItem One positioned text run. Coordinates are PDF points with the
// origin at the bottom-left of the page, Y increasing upward; the flip to
// canvas pixels happens in the browser.
type PdfTextItem struct {
	// Start Offset into AnchoredText.text, in Unicode code points from its
	// start, inclusive.
	Start int `json:"start"`
	// End Offset into AnchoredText.text, in Unicode code points from its start,
	// exclusive.
	End int `json:"end"`
	// Page 1-indexed page number.
	Page   int     `json:"page"`
	X      float64 `json:"x"`
	Y      float64 `json:"y"`
	Width  float64 `json:"width"`
	Height float64 `json:"height"`
}

// PendingAnnotation The annotation a mark state unit is composing, from the
// selection a request asked for, until it is submitted or cancelled.
type PendingAnnotation struct {
	Selector   AnnotationSelector `json:"selector"`
	Motivation Motivation         `json:"motivation"`
}

// PendingAuthorization What a sign-in by a page redirect remembers across the
// trip to the issuer and back: the verifier and the state the issuer's
// response must match, where the person was connecting, what they believed
// they were connecting to, and the issuer's endpoints, so its completion asks
// nothing twice.
type PendingAuthorization struct {
	// State What the issuer's response must carry back to belong to this
	// sign-in: random, as base64url.
	State string `json:"state"`
	// Verifier The PKCE code verifier (RFC 7636) the authorization code is
	// exchanged with: random, as base64url.
	Verifier string `json:"verifier"`
	// RedirectUri Where the issuer sends the person back to, named again when
	// the code is exchanged.
	RedirectUri string `json:"redirectUri"`
	// Target Where the person was connecting.
	Target HttpEndpoint `json:"target"`
	// Issuer The issuer the knowledge base trusts, and the endpoints of it a
	// client uses.
	Issuer PendingAuthorizationIssuer `json:"issuer"`
	// KbId The registered knowledge base being signed in to again. Absent when
	// it is none.
	KbId *string `json:"kbId,omitempty"`
	// ExpectedDid The did of what the person believed they clicked, checked
	// against the answer and never assumed. Absent when they named nothing.
	ExpectedDid *string `json:"expectedDid,omitempty"`
	// ExpectedName The name of what the person believed they clicked. Absent
	// when they named nothing.
	ExpectedName *string `json:"expectedName,omitempty"`
}

// PendingAuthorizationIssuer The issuer the knowledge base trusts, and the
// endpoints of it a client uses.
type PendingAuthorizationIssuer struct {
	// Issuer The issuer's identifier.
	Issuer string `json:"issuer"`
	// Authorization The issuer's authorization endpoint, where the person is
	// sent.
	Authorization string `json:"authorization"`
	// Token The issuer's token endpoint, where the code is exchanged.
	Token string `json:"token"`
	// Device The issuer's device authorization endpoint (RFC 8628). Absent when
	// the issuer has none.
	Device *string `json:"device,omitempty"`
	// Revocation The issuer's revocation endpoint (RFC 7009). Absent when the
	// issuer has none.
	Revocation *string `json:"revocation,omitempty"`
}

// PermissionDenied A request was refused for lack of permission.
type PermissionDenied struct {
	// Detail The refusal's own message, untranslated; null when it gave none.
	Detail *string `json:"detail"`
}

// PersistedEventId `p-<scope>-<sequenceNumber>` — the id of a persisted event
// delivered on a scoped subscription. Resumable: send it back as that scope's
// `lastEventId`. Stable across connections, so a client dedups by it.
type (
	PersistedEventId = string
)

// PrincipalProfileCommand Bus command saying what a principal is called. The
// gateway emits it when a principal ACTS, carrying the display name it just
// verified on its token; a principal may also emit it itself, for itself,
// which is how an agent, whose token carries no name, says what it is called.
// Either way the gateway stamps `_userId` with the sender's verified DID, so
// a principal names only itself. The Stower persists it as
// principal:profiled, and only when the name differs from the latest one
// recorded for that DID — so the log holds one line per name a principal has
// had, not one per act. A name is a fact ABOUT an identity, never part of the
// record of an act: no artifact carries it, and readers resolve it from the
// profiles projection. Emitted for a person and for an agent alike; never for
// a request that merely reads.
type PrincipalProfileCommand struct {
	// UserId The principal's DID, injected by the /bus/emit gateway from the
	// verified token. Clients do not set this.
	UserId *UserId `json:"_userId,omitempty"`
	// Name The display name: from the issuer's `name` claim, as verified on the
	// token that carried an act, or what the principal said of itself. A token
	// with no name produces no command from the gateway — the issuer is where a
	// person's name is set, and absence is recorded as absence.
	Name string `json:"name"`
}

// PrincipalProfiledPayload Payload for principal:profiled — what this
// principal is called, as the issuer's verified `name` claim said or as the
// principal said of itself, recorded once per change (system-level, no
// resourceId). The event's `userId` is the principal's DID; this payload is
// the fact about it. Provenance never reads it: every artifact joins on the
// DID alone, and this is projected into profiles.json for readers to resolve
// against. Two lines for one DID mean the name changed, and the timestamps
// say when — which is why no artifact ever had to freeze a copy.
type PrincipalProfiledPayload struct {
	// Name The display name as of this event: from the issuer's verified `name`
	// claim, or what the principal said of itself.
	Name string `json:"name"`
}

// Profile What a principal last said it is called, and when: the profile a
// `principal:profiled` event gives.
type Profile struct {
	// Name The name the principal last gave.
	Name string `json:"name"`
	// Since The timestamp of the event that gave it.
	Since string `json:"since"`
}

// ProfilesProjection What the principals of a knowledge base are called: the
// file `projections/__system__/profiles.json` under the state directory, the
// sum of the `principal:profiled` events. The Archivist writes it; the
// Archivist and the Librarian read it to name the principals a reply
// mentions. Written as JSON indented by two spaces.
type ProfilesProjection struct {
	// Profiles Each principal's current profile, keyed by its DID.
	Profiles map[string]Profile `json:"profiles"`
}

// Progress One line of what an operation is doing, as the command line would
// tell a person, without colour. A secret value the launcher generated or
// read never appears in one.
type Progress struct {
	RequestId RequestId `json:"requestId"`
	// Kind What the line is: narration (log, note), an outcome (ok, warn, fail),
	// a heading (banner, section), a timestamp (stamp), a runtime command about
	// to run (command), or text the operation printed (output).
	Kind ProgressKind `json:"kind"`
	// Text The line.
	Text string `json:"text"`
}

// ProgressKind What the line is: narration (log, note), an outcome (ok, warn,
// fail), a heading (banner, section), a timestamp (stamp), a runtime command
// about to run (command), or text the operation printed (output).
type ProgressKind string

// The values of ProgressKind.
const (
	ProgressKindLog     ProgressKind = "log"
	ProgressKindNote    ProgressKind = "note"
	ProgressKindOk      ProgressKind = "ok"
	ProgressKindWarn    ProgressKind = "warn"
	ProgressKindFail    ProgressKind = "fail"
	ProgressKindBanner  ProgressKind = "banner"
	ProgressKindSection ProgressKind = "section"
	ProgressKindStamp   ProgressKind = "stamp"
	ProgressKindCommand ProgressKind = "command"
	ProgressKindOutput  ProgressKind = "output"
)

// Valid is whether e is one of ProgressKind's values.
func (e ProgressKind) Valid() bool {
	switch e {
	case ProgressKindLog, ProgressKindNote, ProgressKindOk, ProgressKindWarn, ProgressKindFail, ProgressKindBanner, ProgressKindSection, ProgressKindStamp, ProgressKindCommand, ProgressKindOutput:
		return true
	}
	return false
}

// ProjectConfig A knowledge base's committed `.xynolog/config.yaml`: its
// name, whether its changes are staged in git, and its permanent identity. A
// deployment's documents never restate any of it.
type ProjectConfig struct {
	// Project The knowledge base's name.
	Project ProjectConfigProject `json:"project"`
	// Git How the knowledge base's changes reach git.
	Git ProjectConfigGit `json:"git"`
	// Site The knowledge base's identity.
	Site ProjectConfigSite `json:"site"`
}

// ProjectConfigGit How the knowledge base's changes reach git.
type ProjectConfigGit struct {
	// Sync Whether changes to the working tree and the event log are staged in
	// git as they are made.
	Sync bool `json:"sync"`
}

// ProjectConfigProject The knowledge base's name.
type ProjectConfigProject struct {
	// Name The knowledge base's name, which decides where its state is kept.
	Name string `json:"name"`
	// Version A version the knowledge base's author gives it. Nothing changes
	// it.
	Version *string `json:"version,omitempty"`
}

// ProjectConfigSite The knowledge base's identity.
type ProjectConfigSite struct {
	// Domain The knowledge base's permanent identity, in did:web's colon-path
	// form (`owner.github.io:repo`): stamped into every event it records, so
	// never a machine's address and never changed. With no white space in it,
	// which no DID holds (UserId.json).
	Domain string `json:"domain"`
	// SiteName The name people see for the knowledge base.
	SiteName string `json:"siteName"`
}

// ProtectedResourceMetadata OAuth 2.0 Protected Resource Metadata (RFC 9728):
// which authorization server this knowledge base trusts, served at
// /.well-known/oauth-protected-resource so a client — the Browser, an MCP
// client — learns where to send a user to sign in without configuration. A
// 401 from any protected route points here in its WWW-Authenticate challenge.
type ProtectedResourceMetadata struct {
	// Resource This knowledge base's resource identifier: its did:web identity
	// resolved to an https URL (did:web:example.github.io:my-kb identifies
	// https://example.github.io/my-kb). This is the exact value a token's aud
	// claim must carry. It is an identifier, not an address — nothing
	// dereferences it, and a knowledge base reached over http in local
	// development still names itself by the https form, which is what makes the
	// value stable across every host, port and proxy it is reached through.
	Resource string `json:"resource"`
	// AuthorizationServers Issuer identifiers whose tokens this resource accepts
	// — the configured identity issuer.
	AuthorizationServers []string `json:"authorization_servers"`
	// BearerMethodsSupported How a bearer token reaches this resource: the
	// Authorization header only.
	BearerMethodsSupported []ProtectedResourceMetadataBearerMethodsSupportedItem `json:"bearer_methods_supported"`
	// ResourceName The knowledge base's name, for a client's sign-in prompt.
	ResourceName *string `json:"resource_name,omitempty"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ProtectedResourceMetadata) MarshalJSON() ([]byte, error) {
	type written ProtectedResourceMetadata
	v.AuthorizationServers = listOf(v.AuthorizationServers)
	v.BearerMethodsSupported = listOf(v.BearerMethodsSupported)
	return json.Marshal(written(v))
}

type ProtectedResourceMetadataBearerMethodsSupportedItem string

// The values of ProtectedResourceMetadataBearerMethodsSupportedItem.
const (
	ProtectedResourceMetadataBearerMethodsSupportedItemHeader ProtectedResourceMetadataBearerMethodsSupportedItem = "header"
)

// Valid is whether e is one of
// ProtectedResourceMetadataBearerMethodsSupportedItem's values.
func (e ProtectedResourceMetadataBearerMethodsSupportedItem) Valid() bool {
	switch e {
	case ProtectedResourceMetadataBearerMethodsSupportedItemHeader:
		return true
	}
	return false
}

// Provider How an inference provider is reached.
type Provider struct {
	// BaseURL Where the provider's API is reached. Anthropic's own API, and the
	// shared Ollama, are stated by no baseURL.
	BaseURL *string    `json:"baseURL,omitempty"`
	ApiKey  *SecretRef `json:"apiKey,omitempty"`
}

// QdrantVectorsConfig A vector index kept in a Qdrant server, asked over its
// REST API with a token.
type QdrantVectorsConfig struct {
	Type QdrantVectorsConfigType `json:"type"`
	// Host The server's host.
	Host string `json:"host"`
	// Port The port its REST API listens on.
	Port int `json:"port"`
	// TokenEnv The environment variable holding the token the service presents
	// to the server on every request, which says what of the index it may read
	// and write. The token is never a value here.
	TokenEnv string `json:"tokenEnv"`
}

func (QdrantVectorsConfig) memberOfVectorsConfig() {}
func (QdrantVectorsConfig) told() (string, string) { return "type", "qdrant" }

type QdrantVectorsConfigType string

// The values of QdrantVectorsConfigType.
const (
	QdrantVectorsConfigTypeQdrant QdrantVectorsConfigType = "qdrant"
)

// Valid is whether e is one of QdrantVectorsConfigType's values.
func (e QdrantVectorsConfigType) Valid() bool {
	switch e {
	case QdrantVectorsConfigTypeQdrant:
		return true
	}
	return false
}

// QuotedText Words of a text, as a selection quotes them: the words
// themselves, and maybe the text just before and just after them, which tell
// apart the places they occur.
type QuotedText struct {
	// Exact The words quoted.
	Exact string `json:"exact"`
	// Prefix The text just before them.
	Prefix *string `json:"prefix,omitempty"`
	// Suffix The text just after them.
	Suffix *string `json:"suffix,omitempty"`
}

// ReconciledSpan Where a quoted selection was found in a text, and how it was
// found, told apart by `anchorMethod`, one of AnchorMethod's words: a fuzzy
// match also names its search, `matchQuality`, and no other states one.
type ReconciledSpan struct {
	union[ReconciledSpanMember]
}

// ReconciledSpanMember is a member of ReconciledSpan:
// ReconciledSpanUniqueMatch, ReconciledSpanContextRecovered,
// ReconciledSpanFirstOfMany, ReconciledSpanFuzzyMatch.
type ReconciledSpanMember interface {
	memberOfReconciledSpan()
}

// Discriminator is the `anchorMethod` this value states.
func (u ReconciledSpan) Discriminator() (string, error) { return u.stated("anchorMethod") }

// Member is the member this value is: the one whose schema admits it.
func (u ReconciledSpan) Member() (any, error) {
	return u.member("ReconciledSpan", reconciledSpanMembers)
}

// reconciledSpanMembers is what each member of ReconciledSpan admits, and how
// a value of it is read.
var reconciledSpanMembers = []unionMember{
	{"ReconciledSpanUniqueMatch", readAs[ReconciledSpanUniqueMatch], []signature{{kind: objectKind, required: []string{"start", "end", "exact", "anchorMethod"}, allowed: []string{"start", "end", "exact", "prefix", "suffix", "anchorMethod"}, fixed: []fixedValues{{"anchorMethod", []any{"unique-match"}}}}}},
	{"ReconciledSpanContextRecovered", readAs[ReconciledSpanContextRecovered], []signature{{kind: objectKind, required: []string{"start", "end", "exact", "anchorMethod"}, allowed: []string{"start", "end", "exact", "prefix", "suffix", "anchorMethod"}, fixed: []fixedValues{{"anchorMethod", []any{"context-recovered"}}}}}},
	{"ReconciledSpanFirstOfMany", readAs[ReconciledSpanFirstOfMany], []signature{{kind: objectKind, required: []string{"start", "end", "exact", "anchorMethod"}, allowed: []string{"start", "end", "exact", "prefix", "suffix", "anchorMethod"}, fixed: []fixedValues{{"anchorMethod", []any{"first-of-many"}}}}}},
	{"ReconciledSpanFuzzyMatch", readAs[ReconciledSpanFuzzyMatch], []signature{{kind: objectKind, required: []string{"start", "end", "exact", "anchorMethod", "matchQuality"}, allowed: []string{"start", "end", "exact", "prefix", "suffix", "anchorMethod", "matchQuality"}, fixed: []fixedValues{{"anchorMethod", []any{"fuzzy-match"}}, {"matchQuality", []any{"normalized", "case-insensitive", "fuzzy"}}}}}},
}

// ReconciledSpanContextRecovered The text has the words in more than one
// place, and the span is the first that fits every hint the quote gave.
type ReconciledSpanContextRecovered struct {
	// Start The offset the span starts at, in Unicode code points from the
	// text's start.
	Start int `json:"start"`
	// End The offset just past the span, in Unicode code points from the text's
	// start.
	End int `json:"end"`
	// Exact The words quoted.
	Exact string `json:"exact"`
	// Prefix The text just before them.
	Prefix *string `json:"prefix,omitempty"`
	// Suffix The text just after them.
	Suffix       *string                                    `json:"suffix,omitempty"`
	AnchorMethod ReconciledSpanContextRecoveredAnchorMethod `json:"anchorMethod"`
}

func (ReconciledSpanContextRecovered) memberOfReconciledSpan() {}
func (ReconciledSpanContextRecovered) told() (string, string) {
	return "anchorMethod", "context-recovered"
}

type ReconciledSpanContextRecoveredAnchorMethod string

// The values of ReconciledSpanContextRecoveredAnchorMethod.
const (
	ReconciledSpanContextRecoveredAnchorMethodContextRecovered ReconciledSpanContextRecoveredAnchorMethod = "context-recovered"
)

// Valid is whether e is one of ReconciledSpanContextRecoveredAnchorMethod's
// values.
func (e ReconciledSpanContextRecoveredAnchorMethod) Valid() bool {
	switch e {
	case ReconciledSpanContextRecoveredAnchorMethodContextRecovered:
		return true
	}
	return false
}

// ReconciledSpanFirstOfMany The text has the words in more than one place,
// and the span is the first, since the quote gave no hint or none fits.
type ReconciledSpanFirstOfMany struct {
	// Start The offset the span starts at, in Unicode code points from the
	// text's start.
	Start int `json:"start"`
	// End The offset just past the span, in Unicode code points from the text's
	// start.
	End int `json:"end"`
	// Exact The words quoted.
	Exact string `json:"exact"`
	// Prefix The text just before them.
	Prefix *string `json:"prefix,omitempty"`
	// Suffix The text just after them.
	Suffix       *string                               `json:"suffix,omitempty"`
	AnchorMethod ReconciledSpanFirstOfManyAnchorMethod `json:"anchorMethod"`
}

func (ReconciledSpanFirstOfMany) memberOfReconciledSpan() {}
func (ReconciledSpanFirstOfMany) told() (string, string)  { return "anchorMethod", "first-of-many" }

type ReconciledSpanFirstOfManyAnchorMethod string

// The values of ReconciledSpanFirstOfManyAnchorMethod.
const (
	ReconciledSpanFirstOfManyAnchorMethodFirstOfMany ReconciledSpanFirstOfManyAnchorMethod = "first-of-many"
)

// Valid is whether e is one of ReconciledSpanFirstOfManyAnchorMethod's
// values.
func (e ReconciledSpanFirstOfManyAnchorMethod) Valid() bool {
	switch e {
	case ReconciledSpanFirstOfManyAnchorMethodFirstOfMany:
		return true
	}
	return false
}

// ReconciledSpanFuzzyMatch The text has the words nowhere, and a looser
// search found the span: `matchQuality` names which.
type ReconciledSpanFuzzyMatch struct {
	// Start The offset the span starts at, in Unicode code points from the
	// text's start.
	Start int `json:"start"`
	// End The offset just past the span, in Unicode code points from the text's
	// start.
	End int `json:"end"`
	// Exact The words quoted.
	Exact string `json:"exact"`
	// Prefix The text just before them.
	Prefix *string `json:"prefix,omitempty"`
	// Suffix The text just after them.
	Suffix       *string                              `json:"suffix,omitempty"`
	AnchorMethod ReconciledSpanFuzzyMatchAnchorMethod `json:"anchorMethod"`
	MatchQuality MatchQuality                         `json:"matchQuality"`
}

func (ReconciledSpanFuzzyMatch) memberOfReconciledSpan() {}
func (ReconciledSpanFuzzyMatch) told() (string, string)  { return "anchorMethod", "fuzzy-match" }

type ReconciledSpanFuzzyMatchAnchorMethod string

// The values of ReconciledSpanFuzzyMatchAnchorMethod.
const (
	ReconciledSpanFuzzyMatchAnchorMethodFuzzyMatch ReconciledSpanFuzzyMatchAnchorMethod = "fuzzy-match"
)

// Valid is whether e is one of ReconciledSpanFuzzyMatchAnchorMethod's values.
func (e ReconciledSpanFuzzyMatchAnchorMethod) Valid() bool {
	switch e {
	case ReconciledSpanFuzzyMatchAnchorMethodFuzzyMatch:
		return true
	}
	return false
}

// ReconciledSpanUniqueMatch The text has the words in exactly one place.
type ReconciledSpanUniqueMatch struct {
	// Start The offset the span starts at, in Unicode code points from the
	// text's start.
	Start int `json:"start"`
	// End The offset just past the span, in Unicode code points from the text's
	// start.
	End int `json:"end"`
	// Exact The words quoted.
	Exact string `json:"exact"`
	// Prefix The text just before them.
	Prefix *string `json:"prefix,omitempty"`
	// Suffix The text just after them.
	Suffix       *string                               `json:"suffix,omitempty"`
	AnchorMethod ReconciledSpanUniqueMatchAnchorMethod `json:"anchorMethod"`
}

func (ReconciledSpanUniqueMatch) memberOfReconciledSpan() {}
func (ReconciledSpanUniqueMatch) told() (string, string)  { return "anchorMethod", "unique-match" }

type ReconciledSpanUniqueMatchAnchorMethod string

// The values of ReconciledSpanUniqueMatchAnchorMethod.
const (
	ReconciledSpanUniqueMatchAnchorMethodUniqueMatch ReconciledSpanUniqueMatchAnchorMethod = "unique-match"
)

// Valid is whether e is one of ReconciledSpanUniqueMatchAnchorMethod's
// values.
func (e ReconciledSpanUniqueMatchAnchorMethod) Valid() bool {
	switch e {
	case ReconciledSpanUniqueMatchAnchorMethodUniqueMatch:
		return true
	}
	return false
}

// ReplyEventId `e-<channel>:<correlationId>` — the id of a frame that carries
// a correlationId. Deterministic: the same reply has the same id on every
// connection, so a copy arriving on two connections (a reconnect overlap, or
// a replay of a retained reply) dedups. Never a resumption watermark.
type (
	ReplyEventId = string
)

// Representation A specific, byte-addressable rendition of a resource
// (file/asset/variant).
type Representation struct {
	// Id Stable ID for this representation.
	Id *string `json:"@id,omitempty"`
	// Type Type(s), e.g., schema:MediaObject.
	Type *OneOrMoreStrings `json:"@type,omitempty"`
	// MediaType MIME/media type (e.g., text/markdown, image/png).
	MediaType string `json:"mediaType"`
	// StorageUri Working-tree URI identifying where this rendition's bytes live.
	// Only file:// is supported (e.g. file://docs/overview.md). The single home
	// of the storage location: maintained across moves (yield:moved relocates
	// it), absent when the resource has no stored bytes.
	StorageUri *string `json:"storageUri,omitempty"`
	Filename   *string `json:"filename,omitempty"`
	// ByteSize Size of the payload in bytes.
	ByteSize *int `json:"byteSize,omitempty"`
	// Checksum The SHA-256 of the bytes, as 64 lower-case hexadecimal digits
	// with nothing before them. Whatever compares the checksums of two
	// representations compares this text.
	Checksum *string `json:"checksum,omitempty"`
	// Encoding Compression/transfer encoding if applicable.
	Encoding *string `json:"encoding,omitempty"`
	// Language IETF BCP 47 language tag (e.g., en, es-ES).
	Language *string `json:"language,omitempty"`
	// Width Pixels (images/video).
	Width *int `json:"width,omitempty"`
	// Height Pixels (images/video).
	Height *int `json:"height,omitempty"`
	// Duration Seconds (audio/video).
	Duration *float64 `json:"duration,omitempty"`
	Created  *string  `json:"created,omitempty"`
	Modified *string  `json:"modified,omitempty"`
	// ConformsTo Profile/shape the bytes conform to (e.g., a JSON profile or SVG
	// profile).
	ConformsTo *OneOrMoreUris `json:"conformsTo,omitempty"`
	Tags       *[]string      `json:"tags,omitempty"`
	// Rel Semantics of this rendition relative to the resource (e.g., original,
	// thumbnail, preview, derived).
	Rel *RepresentationRel `json:"rel,omitempty"`
	// AdditionalProperties is every member the schema does not name, as it came.
	AdditionalProperties map[string]any `json:"-"`
}

func (Representation) memberOfResourceDescriptorRepresentations() {}

// MarshalJSON writes v with the members its schema does not name, and each
// list its schema requires that Go holds as nil as the empty list.
func (v Representation) MarshalJSON() ([]byte, error) {
	type written Representation
	return writeOpen(written(v), v.AdditionalProperties)
}

// UnmarshalJSON reads v, and each member its schema does not name into its
// AdditionalProperties.
func (v *Representation) UnmarshalJSON(raw []byte) error {
	type read Representation
	return readOpen(raw, (*read)(v), &v.AdditionalProperties)
}

// RepresentationAddedPayload Payload for yield:representation-added domain
// event
type RepresentationAddedPayload struct {
	Representation Representation `json:"representation"`
}

// RepresentationNotFound The Archivist's 404 for a resource's bytes: an
// ErrorResponse whose `code` says which half of the lookup failed —
// `resource` when the record holds no such resource, `representation` when it
// holds the resource but not its bytes. Each reader answers the two
// differently.
type RepresentationNotFound struct {
	// Error What went wrong, in a sentence.
	Error string `json:"error"`
	// Code A machine-readable class, when the route defines one.
	Code RepresentationNotFoundCode `json:"code"`
	// Hint What the caller can do about it, when there is something to say.
	Hint    *string `json:"hint,omitempty"`
	Details any     `json:"details,omitempty"`
}

// RepresentationNotFoundCode A machine-readable class, when the route defines
// one.
type RepresentationNotFoundCode string

// The values of RepresentationNotFoundCode.
const (
	RepresentationNotFoundCodeResource       RepresentationNotFoundCode = "resource"
	RepresentationNotFoundCodeRepresentation RepresentationNotFoundCode = "representation"
)

// Valid is whether e is one of RepresentationNotFoundCode's values.
func (e RepresentationNotFoundCode) Valid() bool {
	switch e {
	case RepresentationNotFoundCodeResource, RepresentationNotFoundCodeRepresentation:
		return true
	}
	return false
}

// RepresentationRel Semantics of this rendition relative to the resource
// (e.g., original, thumbnail, preview, derived).
type RepresentationRel string

// The values of RepresentationRel.
const (
	RepresentationRelOriginal  RepresentationRel = "original"
	RepresentationRelThumbnail RepresentationRel = "thumbnail"
	RepresentationRelPreview   RepresentationRel = "preview"
	RepresentationRelOptimized RepresentationRel = "optimized"
	RepresentationRelDerived   RepresentationRel = "derived"
	RepresentationRelOther     RepresentationRel = "other"
)

// Valid is whether e is one of RepresentationRel's values.
func (e RepresentationRel) Valid() bool {
	switch e {
	case RepresentationRelOriginal, RepresentationRelThumbnail, RepresentationRelPreview, RepresentationRelOptimized, RepresentationRelDerived, RepresentationRelOther:
		return true
	}
	return false
}

// RepresentationRemovedPayload Payload for yield:representation-removed
// domain event
type RepresentationRemovedPayload struct {
	// Checksum Checksum of the representation to remove
	Checksum string `json:"checksum"`
}

// RequestId The request a notification is about: the JSON-RPC id its client
// gave it, as the client gave it.
type RequestId struct {
	union[RequestIdMember]
}

// RequestIdMember is a member of RequestId: RequestIdText, RequestIdInteger.
type RequestIdMember interface {
	memberOfRequestId()
}

// Member is the member this value is: the one whose schema admits it.
func (u RequestId) Member() (any, error) { return u.member("RequestId", requestIdMembers) }

// requestIdMembers is what each member of RequestId admits, and how a value
// of it is read.
var requestIdMembers = []unionMember{
	{"RequestIdText", readAs[RequestIdText], []signature{{kind: textKind}}},
	{"RequestIdInteger", readAs[RequestIdInteger], []signature{{kind: integerKind}}},
}

// RequestIdInteger is a RequestId that is integer.
type RequestIdInteger int

func (RequestIdInteger) memberOfRequestId() {}

// RequestIdText is a RequestId that is text.
type RequestIdText string

func (RequestIdText) memberOfRequestId() {}

// ResourceAnnotations The annotations on one resource, as its materialized
// view holds them.
type ResourceAnnotations struct {
	ResourceId ResourceId `json:"resourceId"`
	// Annotations Each annotation as the `mark:added` event that recorded it
	// carried it, with the body changes recorded since applied. In the order
	// they were first recorded.
	Annotations []Annotation `json:"annotations"`
	// Version How many of the resource's events the view has applied.
	Version int `json:"version"`
	// UpdatedAt The timestamp of the last event applied; the empty string before
	// any.
	UpdatedAt string `json:"updatedAt"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ResourceAnnotations) MarshalJSON() ([]byte, error) {
	type written ResourceAnnotations
	v.Annotations = listOf(v.Annotations)
	return json.Marshal(written(v))
}

// ResourceArchivedPayload Payload for mark:archived domain event
type ResourceArchivedPayload struct {
	Reason *string `json:"reason,omitempty"`
}

// ResourceClonedPayload Payload for yield:cloned domain event
type ResourceClonedPayload struct {
	Name            string        `json:"name"`
	Format          ContentFormat `json:"format"`
	ContentChecksum string        `json:"contentChecksum"`
	ContentByteSize *int          `json:"contentByteSize,omitempty"`
	// StorageUri Where the clone's bytes are, on the resource's primary
	// Representation — the same single home `yield:created` writes to.
	StorageUri       *string    `json:"storageUri,omitempty"`
	ParentResourceId ResourceId `json:"parentResourceId"`
	EntityTypes      *[]string  `json:"entityTypes,omitempty"`
	Language         *string    `json:"language,omitempty"`
	// Creator Who made the clone — the emitter, derived at write time. A clone
	// is never job-fulfilling. Absent on events written before derivation
	// existed, whose emitter was their only party.
	Creator *Agent `json:"creator,omitempty"`
	// WasAttributedTo PROV-O wasAttributedTo, derived at write time: the cloner
	// alone. The value the resource view carries.
	WasAttributedTo *OneOrMoreAgents `json:"wasAttributedTo,omitempty"`
}

// ResourceCreatedPayload Payload for yield:created domain event
type ResourceCreatedPayload struct {
	Name   string        `json:"name"`
	Format ContentFormat `json:"format"`
	// ContentChecksum SHA-256 of content
	ContentChecksum string    `json:"contentChecksum"`
	ContentByteSize *int      `json:"contentByteSize,omitempty"`
	EntityTypes     *[]string `json:"entityTypes,omitempty"`
	// StorageUri The creating instruction's URI, recorded on the event.
	// Append-only, so this value never changes — the LOCATION the projection
	// serves is maintained across moves and lives on the resource's primary
	// Representation, relocated by yield:moved. Optional: a resource may have no
	// bytes. Working-tree URI, only file:// is supported (e.g.
	// file://docs/overview.md).
	StorageUri *string `json:"storageUri,omitempty"`
	Language   *string `json:"language,omitempty"`
	IsDraft    *bool   `json:"isDraft,omitempty"`
	// JobId The job this resource was made in fulfilment of, when its create
	// cited one. A write that cites the same job on this resource, by the one
	// who made it, is attributed to that job's requester: the `creator` here.
	JobId *JobId `json:"jobId,omitempty"`
	// GeneratedFrom What this resource was generated from: the resource, and the
	// annotation on it when the generation was for one. The resource's
	// descriptor names the resource as `wasDerivedFrom`.
	GeneratedFrom    *ResourceCreatedPayloadGeneratedFrom `json:"generatedFrom,omitempty"`
	GenerationPrompt *string                              `json:"generationPrompt,omitempty"`
	Generator        *OneOrMoreAgents                     `json:"generator,omitempty"`
	// Creator Who requested this resource — derived by the knowledge base at
	// write time, never sent by the emitter. For a resource created in
	// fulfilment of a job, the requester recorded on that job's job:assigned;
	// otherwise the emitter itself. Absent on events written before derivation
	// existed, whose emitter was their only party.
	Creator *Agent `json:"creator,omitempty"`
	// WasAttributedTo PROV-O wasAttributedTo, derived at write time from
	// `creator` and the executor: both parties when they differ, one when they
	// are the same. The value the resource view carries; readers do not
	// re-derive it.
	WasAttributedTo *OneOrMoreAgents `json:"wasAttributedTo,omitempty"`
}

// ResourceCreatedPayloadGeneratedFrom What this resource was generated from:
// the resource, and the annotation on it when the generation was for one. The
// resource's descriptor names the resource as `wasDerivedFrom`.
type ResourceCreatedPayloadGeneratedFrom struct {
	ResourceId   ResourceId    `json:"resourceId"`
	AnnotationId *AnnotationId `json:"annotationId,omitempty"`
}

// ResourceDescriptor Metadata about a resource (1:1 with its URI). JSON-LD
// subject is @id. Link to concrete bytes via representations.
type ResourceDescriptor struct {
	// Context JSON-LD context; URI, object, or array of these.
	Context ResourceDescriptorContext `json:"@context"`
	// Id The id of the resource being described.
	Id ResourceId `json:"@id"`
	// Type Type(s) of the resource (IRIs/CURIEs via @context).
	Type        *OneOrMoreStrings `json:"@type,omitempty"`
	Name        string            `json:"name"`
	Description *string           `json:"description,omitempty"`
	// Identifier Persistent identifiers (e.g., DOI, URN).
	Identifier *ResourceDescriptorIdentifier `json:"identifier,omitempty"`
	// About Topics (IRIs or strings).
	About *OneOrMoreStrings `json:"about,omitempty"`
	// SameAs Equivalent/authoritative references.
	SameAs       *[]string `json:"sameAs,omitempty"`
	IsPartOf     *[]string `json:"isPartOf,omitempty"`
	HasPart      *[]string `json:"hasPart,omitempty"`
	License      *string   `json:"license,omitempty"`
	Version      *string   `json:"version,omitempty"`
	DateCreated  *string   `json:"dateCreated,omitempty"`
	DateModified *string   `json:"dateModified,omitempty"`
	// WasDerivedFrom W3C PROV: the resource, or resources, this one was derived
	// from, each by its id
	WasDerivedFrom *ResourceDescriptorWasDerivedFrom `json:"wasDerivedFrom,omitempty"`
	// WasAttributedTo W3C PROV — every party responsible for this resource,
	// derived by the knowledge base at creation from verified identities:
	// `[requester, generator]` for a resource a job produced, collapsed to the
	// one agent when the requester produced it. Never accepted from an emitter.
	WasAttributedTo *OneOrMoreAgents `json:"wasAttributedTo,omitempty"`
	// Generator Software peer that produced this resource (W3C Web Annotation
	// model). Its identity is the verified emitter of the create; the parameters
	// are the producer's to state.
	Generator *OneOrMoreAgents `json:"generator,omitempty"`
	// ConformsTo Profile/shape URI this resource description conforms to.
	ConformsTo *OneOrMoreUris `json:"conformsTo,omitempty"`
	// AvailableFormats Convenience set summarizing media types across
	// representations.
	AvailableFormats *[]string `json:"availableFormats,omitempty"`
	// Representations Managed or referenced byte-level renditions of this
	// resource.
	Representations ResourceDescriptorRepresentations `json:"representations"`
	// Archived Application-specific: Whether this resource is archived
	Archived *bool `json:"archived,omitempty"`
	// EntityTypes Application-specific: Entity types for this resource
	EntityTypes *[]string `json:"entityTypes,omitempty"`
	// IsDraft Application-specific: Whether this resource is a draft
	IsDraft *bool `json:"isDraft,omitempty"`
	// SourceAnnotationId Application-specific: ID of annotation that triggered
	// generation
	SourceAnnotationId *AnnotationId `json:"sourceAnnotationId,omitempty"`
	// SourceResourceId Application-specific: ID of source resource for
	// clones/derivatives
	SourceResourceId *ResourceId `json:"sourceResourceId,omitempty"`
	// OriginatedFrom Original URI from a source knowledge base when this
	// resource was imported
	OriginatedFrom *string `json:"originatedFrom,omitempty"`
	// AdditionalProperties is every member the schema does not name, as it came.
	AdditionalProperties map[string]any `json:"-"`
}

// MarshalJSON writes v with the members its schema does not name, and each
// list its schema requires that Go holds as nil as the empty list.
func (v ResourceDescriptor) MarshalJSON() ([]byte, error) {
	type written ResourceDescriptor
	return writeOpen(written(v), v.AdditionalProperties)
}

// UnmarshalJSON reads v, and each member its schema does not name into its
// AdditionalProperties.
func (v *ResourceDescriptor) UnmarshalJSON(raw []byte) error {
	type read ResourceDescriptor
	return readOpen(raw, (*read)(v), &v.AdditionalProperties)
}

// ResourceDescriptorContext JSON-LD context; URI, object, or array of these.
type ResourceDescriptorContext struct {
	union[ResourceDescriptorContextMember]
}

// ResourceDescriptorContextMember is a member of ResourceDescriptorContext:
// ResourceDescriptorContextText, ResourceDescriptorContextObject,
// ResourceDescriptorContextList.
type ResourceDescriptorContextMember interface {
	memberOfResourceDescriptorContext()
}

// Member is the member this value is: the one whose schema admits it.
func (u ResourceDescriptorContext) Member() (any, error) {
	return u.member("ResourceDescriptorContext", resourceDescriptorContextMembers)
}

// resourceDescriptorContextMembers is what each member of
// ResourceDescriptorContext admits, and how a value of it is read.
var resourceDescriptorContextMembers = []unionMember{
	{"ResourceDescriptorContextText", readAs[ResourceDescriptorContextText], []signature{{kind: textKind}}},
	{"ResourceDescriptorContextObject", readAs[ResourceDescriptorContextObject], []signature{{kind: objectKind}}},
	{"ResourceDescriptorContextList", readAs[ResourceDescriptorContextList], []signature{{kind: listKind}}},
}

type ResourceDescriptorContextItem struct {
	union[ResourceDescriptorContextItemMember]
}

// ResourceDescriptorContextItemMember is a member of
// ResourceDescriptorContextItem: ResourceDescriptorContextItemText,
// ResourceDescriptorContextItemObject.
type ResourceDescriptorContextItemMember interface {
	memberOfResourceDescriptorContextItem()
}

// Member is the member this value is: the one whose schema admits it.
func (u ResourceDescriptorContextItem) Member() (any, error) {
	return u.member("ResourceDescriptorContextItem", resourceDescriptorContextItemMembers)
}

// resourceDescriptorContextItemMembers is what each member of
// ResourceDescriptorContextItem admits, and how a value of it is read.
var resourceDescriptorContextItemMembers = []unionMember{
	{"ResourceDescriptorContextItemText", readAs[ResourceDescriptorContextItemText], []signature{{kind: textKind}}},
	{"ResourceDescriptorContextItemObject", readAs[ResourceDescriptorContextItemObject], []signature{{kind: objectKind}}},
}

// ResourceDescriptorContextItemObject is a ResourceDescriptorContextItem that
// is an object.
type ResourceDescriptorContextItemObject map[string]any

func (ResourceDescriptorContextItemObject) memberOfResourceDescriptorContextItem() {}

// ResourceDescriptorContextItemText is a ResourceDescriptorContextItem that
// is text.
type ResourceDescriptorContextItemText string

func (ResourceDescriptorContextItemText) memberOfResourceDescriptorContextItem() {}

// ResourceDescriptorContextList is a ResourceDescriptorContext that is a
// list.
type ResourceDescriptorContextList []ResourceDescriptorContextItem

func (ResourceDescriptorContextList) memberOfResourceDescriptorContext() {}

// ResourceDescriptorContextObject is a ResourceDescriptorContext that is an
// object.
type ResourceDescriptorContextObject map[string]any

func (ResourceDescriptorContextObject) memberOfResourceDescriptorContext() {}

// ResourceDescriptorContextText is a ResourceDescriptorContext that is text.
type ResourceDescriptorContextText string

func (ResourceDescriptorContextText) memberOfResourceDescriptorContext() {}

// ResourceDescriptorIdentifier Persistent identifiers (e.g., DOI, URN).
type ResourceDescriptorIdentifier struct {
	union[ResourceDescriptorIdentifierMember]
}

// ResourceDescriptorIdentifierMember is a member of
// ResourceDescriptorIdentifier: ResourceDescriptorIdentifierText,
// ResourceDescriptorIdentifierList, ResourceDescriptorIdentifierObject.
type ResourceDescriptorIdentifierMember interface {
	memberOfResourceDescriptorIdentifier()
}

// Member is the member this value is: the one whose schema admits it.
func (u ResourceDescriptorIdentifier) Member() (any, error) {
	return u.member("ResourceDescriptorIdentifier", resourceDescriptorIdentifierMembers)
}

// resourceDescriptorIdentifierMembers is what each member of
// ResourceDescriptorIdentifier admits, and how a value of it is read.
var resourceDescriptorIdentifierMembers = []unionMember{
	{"ResourceDescriptorIdentifierText", readAs[ResourceDescriptorIdentifierText], []signature{{kind: textKind}}},
	{"ResourceDescriptorIdentifierList", readAs[ResourceDescriptorIdentifierList], []signature{{kind: listKind}}},
	{"ResourceDescriptorIdentifierObject", readAs[ResourceDescriptorIdentifierObject], []signature{{kind: objectKind}}},
}

// ResourceDescriptorIdentifierList is a ResourceDescriptorIdentifier that is
// a list.
type ResourceDescriptorIdentifierList []string

func (ResourceDescriptorIdentifierList) memberOfResourceDescriptorIdentifier() {}

type ResourceDescriptorIdentifierObject struct {
	Id     *string `json:"@id,omitempty"`
	Value  *string `json:"value,omitempty"`
	Scheme *string `json:"scheme,omitempty"`
	// AdditionalProperties is every member the schema does not name, as it came.
	AdditionalProperties map[string]any `json:"-"`
}

func (ResourceDescriptorIdentifierObject) memberOfResourceDescriptorIdentifier() {}

// MarshalJSON writes v with the members its schema does not name, and each
// list its schema requires that Go holds as nil as the empty list.
func (v ResourceDescriptorIdentifierObject) MarshalJSON() ([]byte, error) {
	type written ResourceDescriptorIdentifierObject
	return writeOpen(written(v), v.AdditionalProperties)
}

// UnmarshalJSON reads v, and each member its schema does not name into its
// AdditionalProperties.
func (v *ResourceDescriptorIdentifierObject) UnmarshalJSON(raw []byte) error {
	type read ResourceDescriptorIdentifierObject
	return readOpen(raw, (*read)(v), &v.AdditionalProperties)
}

// ResourceDescriptorIdentifierText is a ResourceDescriptorIdentifier that is
// text.
type ResourceDescriptorIdentifierText string

func (ResourceDescriptorIdentifierText) memberOfResourceDescriptorIdentifier() {}

// ResourceDescriptorRepresentations Managed or referenced byte-level
// renditions of this resource.
type ResourceDescriptorRepresentations struct {
	union[ResourceDescriptorRepresentationsMember]
}

// ResourceDescriptorRepresentationsMember is a member of
// ResourceDescriptorRepresentations: Representation,
// ResourceDescriptorRepresentationsList.
type ResourceDescriptorRepresentationsMember interface {
	memberOfResourceDescriptorRepresentations()
}

// Member is the member this value is: the one whose schema admits it.
func (u ResourceDescriptorRepresentations) Member() (any, error) {
	return u.member("ResourceDescriptorRepresentations", resourceDescriptorRepresentationsMembers)
}

// resourceDescriptorRepresentationsMembers is what each member of
// ResourceDescriptorRepresentations admits, and how a value of it is read.
var resourceDescriptorRepresentationsMembers = []unionMember{
	{"Representation", readAs[Representation], []signature{{kind: objectKind, required: []string{"mediaType"}, fixed: []fixedValues{{"rel", []any{"original", "thumbnail", "preview", "optimized", "derived", "other"}}}}}},
	{"ResourceDescriptorRepresentationsList", readAs[ResourceDescriptorRepresentationsList], []signature{{kind: listKind}}},
}

// ResourceDescriptorRepresentationsList is a
// ResourceDescriptorRepresentations that is a list.
type ResourceDescriptorRepresentationsList []Representation

func (ResourceDescriptorRepresentationsList) memberOfResourceDescriptorRepresentations() {}

// ResourceDescriptorWasDerivedFrom W3C PROV: the resource, or resources, this
// one was derived from, each by its id
type ResourceDescriptorWasDerivedFrom struct {
	union[ResourceDescriptorWasDerivedFromMember]
}

// ResourceDescriptorWasDerivedFromMember is a member of
// ResourceDescriptorWasDerivedFrom: ResourceId,
// ResourceDescriptorWasDerivedFromList.
type ResourceDescriptorWasDerivedFromMember interface {
	memberOfResourceDescriptorWasDerivedFrom()
}

// Member is the member this value is: the one whose schema admits it.
func (u ResourceDescriptorWasDerivedFrom) Member() (any, error) {
	return u.member("ResourceDescriptorWasDerivedFrom", resourceDescriptorWasDerivedFromMembers)
}

// resourceDescriptorWasDerivedFromMembers is what each member of
// ResourceDescriptorWasDerivedFrom admits, and how a value of it is read.
var resourceDescriptorWasDerivedFromMembers = []unionMember{
	{"ResourceId", readAs[ResourceId], []signature{{kind: textKind}}},
	{"ResourceDescriptorWasDerivedFromList", readAs[ResourceDescriptorWasDerivedFromList], []signature{{kind: listKind}}},
}

// ResourceDescriptorWasDerivedFromList is a ResourceDescriptorWasDerivedFrom
// that is a list.
type ResourceDescriptorWasDerivedFromList []ResourceId

func (ResourceDescriptorWasDerivedFromList) memberOfResourceDescriptorWasDerivedFrom() {}

// ResourceErrorEvent A client-local notice that a command on a resource
// failed, for a UI to show: the payload of `mark:create-error`,
// `mark:delete-error` and `bind:body-error`. Emitted by the caller that
// awaited the command, which knows whose command failed on which resource.
// The `*-failed` wire replies are correlation plumbing and are not for this.
type ResourceErrorEvent struct {
	// ResourceId The resource the command addressed.
	ResourceId ResourceId `json:"resourceId"`
	// Message Human-readable error message.
	Message string `json:"message"`
}

func (ResourceId) memberOfAnnotationTargetValue()            {}
func (ResourceId) memberOfResourceDescriptorWasDerivedFrom() {}

// ResourceMovedPayload Payload for yield:moved domain event
type ResourceMovedPayload struct {
	// FromUri Previous file:// URI
	FromUri string `json:"fromUri"`
	// ToUri New file:// URI
	ToUri string `json:"toUri"`
}

// ResourceSearchFilters What a text search for resources is told beside its
// text: MatchResourcesRequest's other members. client/surface.json's
// `match.resources` cases state what is sent for one left out.
type ResourceSearchFilters struct {
	Archived   *bool   `json:"archived,omitempty"`
	EntityType *string `json:"entityType,omitempty"`
	// Offset How many of the resources the search finds are passed over before
	// the page begins.
	Offset *int `json:"offset,omitempty"`
	// Limit The most resources a page has.
	Limit *int `json:"limit,omitempty"`
}

// ResourceUnarchivedPayload Payload for mark:unarchived domain event (empty
// payload)
type ResourceUnarchivedPayload struct{}

// ResourceUpdatedPayload Payload for yield:updated domain event
type ResourceUpdatedPayload struct {
	// ContentChecksum SHA-256 of new content
	ContentChecksum string `json:"contentChecksum"`
	ContentByteSize *int   `json:"contentByteSize,omitempty"`
}

// ResourceUpload The multipart upload that creates a resource. A client sends
// it to the gateway's `POST /resources`; the gateway forwards it untouched to
// the Archivist's `POST /resources`, which stores the bytes and records the
// resource. One body, two hops.
type ResourceUpload struct {
	// Name Human-readable resource name
	Name string `json:"name"`
	// File Binary content
	File Binary `json:"file"`
	// Format Media type of the content (e.g. text/plain, text/markdown,
	// image/png)
	Format string `json:"format"`
	// StorageUri Where the content lives (file://... for local). Required — the
	// client names the location; the server does not derive one.
	StorageUri string `json:"storageUri"`
	// Language ISO 639-1 language code
	Language *string `json:"language,omitempty"`
	// EntityTypes JSON-stringified array of entity type names
	EntityTypes *string `json:"entityTypes,omitempty"`
	// SourceAnnotationId For AI-generated resources: the annotation that
	// triggered generation. Nested into generatedFrom.annotationId on the
	// persisted event.
	SourceAnnotationId *AnnotationId `json:"sourceAnnotationId,omitempty"`
	// SourceResourceId For AI-generated resources: the source resource the
	// generating annotation lives on. Nested into generatedFrom.resourceId on
	// the persisted event.
	SourceResourceId *ResourceId `json:"sourceResourceId,omitempty"`
	// GenerationPrompt For AI-generated resources: the prompt that drove
	// generation
	GenerationPrompt *string `json:"generationPrompt,omitempty"`
	// Generator For AI-generated resources: JSON-stringified Agent naming the
	// model/worker that produced the content. Its identity must be the uploading
	// agent's own — the knowledge base refuses a generator naming anyone else.
	// `creator` and `wasAttributedTo` are never sent; the knowledge base derives
	// them from the cited job.
	Generator *string `json:"generator,omitempty"`
	// JobId The job this resource fulfils, when a worker is creating it.
	// Forwarded onto yield:create; the knowledge base derives who requested the
	// resource from the cited job's own events, and refuses a worker-role create
	// that cites none. Absent for a person's own upload.
	JobId *JobId `json:"jobId,omitempty"`
	// IsDraft 'true' or 'false' — whether the resource is a draft
	IsDraft *string `json:"isDraft,omitempty"`
	// CloneToken A clone token from `yield:clone-token-requested`. With it, the
	// resource is created as a clone of the token's source, inheriting its
	// entity types; `language`, `entityTypes` and the generation fields are then
	// not read.
	CloneToken *string `json:"cloneToken,omitempty"`
	// ArchiveOriginal With `cloneToken`: 'true' archives the source once the
	// clone exists.
	ArchiveOriginal *string `json:"archiveOriginal,omitempty"`
}

// ResourceView A resource's materialized view: the file the Archivist writes
// at `resources/<ab>/<cd>/<resourceId>.json` under the knowledge base's state
// directory, and every reader of that file reads. It is what the resource's
// events add up to, and is rebuilt from the event log whenever it is missing.
// Written as JSON indented by two spaces, by writing a sibling temporary file
// and renaming it onto the path, so a reader sees a whole document or none.
type ResourceView struct {
	Resource    ResourceDescriptor  `json:"resource"`
	Annotations ResourceAnnotations `json:"annotations"`
	// LastSequence The sequence number of the last event applied. A graph read
	// that follows a write waits for the graph projection to reach it.
	LastSequence int `json:"lastSequence"`
}

// Resources What a container is given, in Kubernetes' spelling.
type Resources struct {
	// Limits The most a container may use.
	Limits ResourcesLimits `json:"limits"`
}

// ResourcesLimits The most a container may use.
type ResourcesLimits struct {
	// Memory The memory ceiling: a whole number of gigabytes or megabytes, `8G`
	// or `512M`.
	Memory string `json:"memory"`
}

// RetryBudget A retry budget: how many `attempts` are allowed, with a backoff
// that starts at `initialDelayMs` and doubles to `maxDelayMs`.
type RetryBudget struct {
	// Attempts How many attempts the budget allows.
	Attempts int `json:"attempts"`
	// InitialDelayMs The delay before the second attempt, in milliseconds.
	InitialDelayMs int `json:"initialDelayMs"`
	// MaxDelayMs The longest delay between attempts, in milliseconds.
	MaxDelayMs int `json:"maxDelayMs"`
}

func (RetryBudget) memberOfClientTimingTimingItemValue() {}

// Root One knowledge base this machine knows: a registered or running local
// clone, or a codespace stack recorded here. Registration, the directory, the
// stack and the forward are separate facts, each stated as it is.
type Root struct {
	// Placement Where the stack actually runs. "local": containers on this
	// machine. "codespace": a GitHub-hosted VM whose KB is port-forwarded here.
	Placement RootPlacement `json:"placement"`
	// Path For a local root: the clone's path.
	Path *string `json:"path,omitempty"`
	// Present For a local root: whether the directory exists. A registered root
	// whose directory is gone is kept, and says so.
	Present *bool `json:"present,omitempty"`
	// Current For a local root: how the control server's own directory selects
	// it, when it does — standing in it (cwd), or XYNOLOG_ROOT.
	Current *RootCurrent `json:"current,omitempty"`
	// Registered Whether the registry (roots.json) records it.
	Registered bool `json:"registered"`
	// Running Whether a stack of it is recorded on this machine.
	Running bool `json:"running"`
	// LastUsed When a command last used it, in RFC 3339, as the registry records
	// it.
	LastUsed *string `json:"lastUsed,omitempty"`
	// Did The KB's did:web identifier, from its committed .xynolog/config.yaml —
	// "did:web:" + its site.domain, verbatim. REQUIRED: a KB that declares no
	// domain has no identity to publish, and the launcher refuses to start it
	// rather than inventing or defaulting one. NOT unique within a document: a
	// did names the knowledge base, not a running copy of it, so a local clone
	// and a codespace of the same repo legitimately share one and both are
	// published. host:port is the unique field (at most one entry per address),
	// so consumers look up by ADDRESS and use the did to VERIFY that the copy
	// they reached is the KB they meant — an address alone cannot say which KB
	// is which, and an identity alone cannot say which copy.
	Did *string `json:"did,omitempty"`
	// SiteName Human-readable site name from the KB's .xynolog/config.yaml
	// (site.siteName), for display
	SiteName *string `json:"siteName,omitempty"`
	// IdentityError Why its identity could not be read from its clone, when it
	// could not.
	IdentityError *string `json:"identityError,omitempty"`
	// Config The Inference document a start of it runs, as the registry records
	// it.
	Config *string `json:"config,omitempty"`
	// Configs For a present local root: the Inference documents its clone has,
	// as start --config names them.
	Configs *[]string `json:"configs,omitempty"`
	// Repo owner/name GitHub slug — present for codespace placements, where the
	// repo is the stack's identity
	Repo *string `json:"repo,omitempty"`
	// Codespace For a codespace root: the codespace's name.
	Codespace *string `json:"codespace,omitempty"`
	// CodespaceState For a codespace root: GitHub's word for the codespace's
	// state (Available, Shutdown), when gh answered.
	CodespaceState *string `json:"codespaceState,omitempty"`
	// ForwardPort For a codespace root: the port on this machine its knowledge
	// base is forwarded to, when one is recorded.
	ForwardPort *int `json:"forwardPort,omitempty"`
	// Forwarded For a codespace root: whether the recorded forward is alive.
	Forwarded *bool `json:"forwarded,omitempty"`
	// Reachable For a codespace root: whether its knowledge base answers through
	// the forward.
	Reachable *bool `json:"reachable,omitempty"`
}

// RootCurrent For a local root: how the control server's own directory
// selects it, when it does — standing in it (cwd), or XYNOLOG_ROOT.
type RootCurrent string

// The values of RootCurrent.
const (
	RootCurrentCwd         RootCurrent = "cwd"
	RootCurrentXynologRoot RootCurrent = "xynolog-root"
)

// Valid is whether e is one of RootCurrent's values.
func (e RootCurrent) Valid() bool {
	switch e {
	case RootCurrentCwd, RootCurrentXynologRoot:
		return true
	}
	return false
}

// RootPlacement Where the stack actually runs. "local": containers on this
// machine. "codespace": a GitHub-hosted VM whose KB is port-forwarded here.
type RootPlacement string

// The values of RootPlacement.
const (
	RootPlacementLocal     RootPlacement = "local"
	RootPlacementCodespace RootPlacement = "codespace"
)

// Valid is whether e is one of RootPlacement's values.
func (e RootPlacement) Valid() bool {
	switch e {
	case RootPlacementLocal, RootPlacementCodespace:
		return true
	}
	return false
}

// RootsForgetParams roots.forget's params.
type RootsForgetParams struct {
	// ApiVersion The version of the control API the request is written to.
	ApiVersion ApiVersion `json:"apiVersion"`
	// Root The registered root to forget: its path, or its basename when only
	// one registered root has it.
	Root string `json:"root"`
}

// RootsForgetResult A forgotten registry row. Only the row is removed: no
// file of the clone, and none of its persistent stack state.
type RootsForgetResult struct {
	// Path The forgotten root's path.
	Path string `json:"path"`
	// DirectoryMissing Whether its directory was already gone.
	DirectoryMissing bool `json:"directoryMissing"`
	// PersistentState The key whose persistent stack state remains, when some
	// does and no surviving root shares its DID: xynolog clean --root <key>
	// removes it.
	PersistentState *string `json:"persistentState,omitempty"`
}

// RootsInitParams roots.init's params: the local directory, permanent
// identity, and optional configuration inputs xynolog init takes.
type RootsInitParams struct {
	ApiVersion ApiVersion `json:"apiVersion"`
	// Path Existing local directory in which to create the knowledge base.
	Path string `json:"path"`
	// Domain The permanent did:web domain, in colon-path form, such as
	// owner.github.io:repo.
	Domain string `json:"domain"`
	// Name Project name. Absent: the directory basename.
	Name *string `json:"name,omitempty"`
	// SiteName Human-readable site name. Absent: the project name.
	SiteName *string `json:"siteName,omitempty"`
	// Inference Inference provider for the generated local stack documents.
	Inference *RootsInitParamsInference `json:"inference,omitempty"`
	// Model The primary model bound to roles and jobs.
	Model *string `json:"model,omitempty"`
	// ModelLight A light model example emitted in the generated config.
	ModelLight *string `json:"modelLight,omitempty"`
	// Embedding Ollama embedding model name, without the ollama: prefix.
	Embedding *string `json:"embedding,omitempty"`
	// ConfigName Inference document name. Absent: the provider name.
	ConfigName *string `json:"configName,omitempty"`
	// AnthropicEndpoint Anthropic API base URL.
	AnthropicEndpoint *string `json:"anthropicEndpoint,omitempty"`
	// OllamaBase Local Ollama API base URL.
	OllamaBase *string `json:"ollamaBase,omitempty"`
	// OllamaRegistry Ollama registry base URL.
	OllamaRegistry *string `json:"ollamaRegistry,omitempty"`
}

// RootsInitParamsInference Inference provider for the generated local stack
// documents.
type RootsInitParamsInference string

// The values of RootsInitParamsInference.
const (
	RootsInitParamsInferenceAnthropic RootsInitParamsInference = "anthropic"
	RootsInitParamsInferenceOllama    RootsInitParamsInference = "ollama"
)

// Valid is whether e is one of RootsInitParamsInference's values.
func (e RootsInitParamsInference) Valid() bool {
	switch e {
	case RootsInitParamsInferenceAnthropic, RootsInitParamsInferenceOllama:
		return true
	}
	return false
}

// RootsInitResult The local directory where xynolog init created and
// registered the knowledge base.
type RootsInitResult struct {
	Path string `json:"path"`
}

// RootsListParams roots.list's params.
type RootsListParams struct {
	// ApiVersion The version of the control API the request is written to.
	ApiVersion ApiVersion `json:"apiVersion"`
}

// RootsListResult Every knowledge base this machine knows, as xynolog roots
// lists them: the local roots first, then the codespace stacks.
type RootsListResult struct {
	// Roots Each root.
	Roots []Root `json:"roots"`
	// Warnings What xynolog roots warns of without failing: an invalid
	// XYNOLOG_ROOT, a clone whose project file is refused.
	Warnings *[]string `json:"warnings,omitempty"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v RootsListResult) MarshalJSON() ([]byte, error) {
	type written RootsListResult
	v.Roots = listOf(v.Roots)
	return json.Marshal(written(v))
}

// RunInstance A run's instance, by the name its caller gave it: unique among
// the target's instances that run on this machine. A second dispatcher beside
// the first is another instance. The launcher names the instance's container
// from the target's key and this name.
type (
	RunInstance = string
)

// RunService One of a knowledge base's own services, which service.run runs:
// the seven Xynolog services, as service-telemetry/telemetry.json names them.
// The reader holds the two lists to each other.
type RunService string

// The values of RunService.
const (
	RunServiceArchivist  RunService = "archivist"
	RunServiceDispatcher RunService = "dispatcher"
	RunServiceGateway    RunService = "gateway"
	RunServiceLibrarian  RunService = "librarian"
	RunServiceSmelter    RunService = "smelter"
	RunServiceWeaver     RunService = "weaver"
	RunServiceWorker     RunService = "worker"
)

// Valid is whether e is one of RunService's values.
func (e RunService) Valid() bool {
	switch e {
	case RunServiceArchivist, RunServiceDispatcher, RunServiceGateway, RunServiceLibrarian, RunServiceSmelter, RunServiceWeaver, RunServiceWorker:
		return true
	}
	return false
}

// Runner Who runs a daemon: the launcher, from `image` with `resources`, or
// somebody else, reached at `external`. Exactly one of the two.
type Runner struct{}

// Runtime A container runtime the launcher drives, as --runtime names it:
// Apple container, Docker or Podman.
type Runtime string

// The values of Runtime.
const (
	RuntimeContainer Runtime = "container"
	RuntimeDocker    Runtime = "docker"
	RuntimePodman    Runtime = "podman"
)

// Valid is whether e is one of Runtime's values.
func (e Runtime) Valid() bool {
	switch e {
	case RuntimeContainer, RuntimeDocker, RuntimePodman:
		return true
	}
	return false
}

// RuntimeState One container runtime the launcher drives, and whether this
// machine has it.
type RuntimeState struct {
	Name Runtime `json:"name"`
	// Found Whether it is on the launcher's PATH.
	Found bool `json:"found"`
}

// ScoredResource A resource returned by a search, carrying its relevance
// score and the reason it matched.
type ScoredResource struct {
	// Context JSON-LD context; URI, object, or array of these.
	Context ResourceDescriptorContext `json:"@context"`
	// Id The id of the resource being described.
	Id ResourceId `json:"@id"`
	// Type Type(s) of the resource (IRIs/CURIEs via @context).
	Type        *OneOrMoreStrings `json:"@type,omitempty"`
	Name        string            `json:"name"`
	Description *string           `json:"description,omitempty"`
	// Identifier Persistent identifiers (e.g., DOI, URN).
	Identifier *ResourceDescriptorIdentifier `json:"identifier,omitempty"`
	// About Topics (IRIs or strings).
	About *OneOrMoreStrings `json:"about,omitempty"`
	// SameAs Equivalent/authoritative references.
	SameAs       *[]string `json:"sameAs,omitempty"`
	IsPartOf     *[]string `json:"isPartOf,omitempty"`
	HasPart      *[]string `json:"hasPart,omitempty"`
	License      *string   `json:"license,omitempty"`
	Version      *string   `json:"version,omitempty"`
	DateCreated  *string   `json:"dateCreated,omitempty"`
	DateModified *string   `json:"dateModified,omitempty"`
	// WasDerivedFrom W3C PROV: the resource, or resources, this one was derived
	// from, each by its id
	WasDerivedFrom *ResourceDescriptorWasDerivedFrom `json:"wasDerivedFrom,omitempty"`
	// WasAttributedTo W3C PROV — every party responsible for this resource,
	// derived by the knowledge base at creation from verified identities:
	// `[requester, generator]` for a resource a job produced, collapsed to the
	// one agent when the requester produced it. Never accepted from an emitter.
	WasAttributedTo *OneOrMoreAgents `json:"wasAttributedTo,omitempty"`
	// Generator Software peer that produced this resource (W3C Web Annotation
	// model). Its identity is the verified emitter of the create; the parameters
	// are the producer's to state.
	Generator *OneOrMoreAgents `json:"generator,omitempty"`
	// ConformsTo Profile/shape URI this resource description conforms to.
	ConformsTo *OneOrMoreUris `json:"conformsTo,omitempty"`
	// AvailableFormats Convenience set summarizing media types across
	// representations.
	AvailableFormats *[]string `json:"availableFormats,omitempty"`
	// Representations Managed or referenced byte-level renditions of this
	// resource.
	Representations ResourceDescriptorRepresentations `json:"representations"`
	// Archived Application-specific: Whether this resource is archived
	Archived *bool `json:"archived,omitempty"`
	// EntityTypes Application-specific: Entity types for this resource
	EntityTypes *[]string `json:"entityTypes,omitempty"`
	// IsDraft Application-specific: Whether this resource is a draft
	IsDraft *bool `json:"isDraft,omitempty"`
	// SourceAnnotationId Application-specific: ID of annotation that triggered
	// generation
	SourceAnnotationId *AnnotationId `json:"sourceAnnotationId,omitempty"`
	// SourceResourceId Application-specific: ID of source resource for
	// clones/derivatives
	SourceResourceId *ResourceId `json:"sourceResourceId,omitempty"`
	// OriginatedFrom Original URI from a source knowledge base when this
	// resource was imported
	OriginatedFrom *string `json:"originatedFrom,omitempty"`
	// Score Relevance score assigned by the matcher; higher is a better
	// candidate.
	Score *float64 `json:"score,omitempty"`
	// MatchReason Human-readable reason for the match.
	MatchReason *string `json:"matchReason,omitempty"`
	// AdditionalProperties is every member the schema does not name, as it came.
	AdditionalProperties map[string]any `json:"-"`
}

// MarshalJSON writes v with the members its schema does not name, and each
// list its schema requires that Go holds as nil as the empty list.
func (v ScoredResource) MarshalJSON() ([]byte, error) {
	type written ScoredResource
	return writeOpen(written(v), v.AdditionalProperties)
}

// UnmarshalJSON reads v, and each member its schema does not name into its
// AdditionalProperties.
func (v *ScoredResource) UnmarshalJSON(raw []byte) error {
	type read ScoredResource
	return readOpen(raw, (*read)(v), &v.AdditionalProperties)
}

// SdkTelemetryTelemetry sdk-telemetry/telemetry.json: the telemetry a Xynolog
// SDK's transports export over OTLP: its spans and metrics, the transport
// each comes from, and the attributes each carries.
type SdkTelemetryTelemetry struct {
	// Comment The rule the table states, in prose.
	Comment string                             `json:"$comment"`
	Spans   []SdkTelemetryTelemetrySpansItem   `json:"spans"`
	Metrics []SdkTelemetryTelemetryMetricsItem `json:"metrics"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v SdkTelemetryTelemetry) MarshalJSON() ([]byte, error) {
	type written SdkTelemetryTelemetry
	v.Spans = listOf(v.Spans)
	v.Metrics = listOf(v.Metrics)
	return json.Marshal(written(v))
}

type SdkTelemetryTelemetryMetricsItem struct {
	// Name The row's name; `{channel}` in it is the bus channel, and `{jobType}`
	// the job's type.
	Name string `json:"name"`
	// Transport The transport the row comes from: `bus`, the stream and emits;
	// `content`, uploads and reads.
	Transport SdkTelemetryTelemetryMetricsItemTransport `json:"transport"`
	// Instrument The metric's instrument.
	Instrument SdkTelemetryTelemetryMetricsItemInstrument `json:"instrument"`
	// Meaning What the row says.
	Meaning string `json:"meaning"`
	// Attributes The attributes the span carries.
	Attributes []SdkTelemetryTelemetryMetricsItemAttributesItem `json:"attributes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v SdkTelemetryTelemetryMetricsItem) MarshalJSON() ([]byte, error) {
	type written SdkTelemetryTelemetryMetricsItem
	v.Attributes = listOf(v.Attributes)
	return json.Marshal(written(v))
}

// SdkTelemetryTelemetryMetricsItemAttributesItem An attribute a row carries.
type SdkTelemetryTelemetryMetricsItemAttributesItem struct {
	// Key The attribute's key.
	Key string `json:"key"`
	// Only When alone the attribute is carried: a row's attribute without it is
	// carried every time.
	Only *string `json:"only,omitempty"`
	// Values The only values it carries, each of the type it is carried as: a
	// string or a boolean.
	Values *[]SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem `json:"values,omitempty"`
}

type SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem struct {
	union[SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemMember]
}

// SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemMember is a member
// of SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem:
// SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemText,
// SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean.
type SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemMember interface {
	memberOfSdkTelemetryTelemetryMetricsItemAttributesItemValuesItem()
}

// Member is the member this value is: the one whose schema admits it.
func (u SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem) Member() (any, error) {
	return u.member("SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem", sdkTelemetryTelemetryMetricsItemAttributesItemValuesItemMembers)
}

// sdkTelemetryTelemetryMetricsItemAttributesItemValuesItemMembers is what
// each member of SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem
// admits, and how a value of it is read.
var sdkTelemetryTelemetryMetricsItemAttributesItemValuesItemMembers = []unionMember{
	{"SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemText", readAs[SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemText], []signature{{kind: textKind}}},
	{"SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean", readAs[SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean], []signature{{kind: booleanKind}}},
}

// SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean is a
// SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem that is boolean.
type SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean bool

func (SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean) memberOfSdkTelemetryTelemetryMetricsItemAttributesItemValuesItem() {
}

// SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemText is a
// SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem that is text.
type SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemText string

func (SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemText) memberOfSdkTelemetryTelemetryMetricsItemAttributesItemValuesItem() {
}

// SdkTelemetryTelemetryMetricsItemInstrument The metric's instrument.
type SdkTelemetryTelemetryMetricsItemInstrument string

// The values of SdkTelemetryTelemetryMetricsItemInstrument.
const (
	SdkTelemetryTelemetryMetricsItemInstrumentCounter       SdkTelemetryTelemetryMetricsItemInstrument = "counter"
	SdkTelemetryTelemetryMetricsItemInstrumentUpDownCounter SdkTelemetryTelemetryMetricsItemInstrument = "up-down counter"
	SdkTelemetryTelemetryMetricsItemInstrumentGauge         SdkTelemetryTelemetryMetricsItemInstrument = "gauge"
	SdkTelemetryTelemetryMetricsItemInstrumentHistogram     SdkTelemetryTelemetryMetricsItemInstrument = "histogram"
)

// Valid is whether e is one of SdkTelemetryTelemetryMetricsItemInstrument's
// values.
func (e SdkTelemetryTelemetryMetricsItemInstrument) Valid() bool {
	switch e {
	case SdkTelemetryTelemetryMetricsItemInstrumentCounter, SdkTelemetryTelemetryMetricsItemInstrumentUpDownCounter, SdkTelemetryTelemetryMetricsItemInstrumentGauge, SdkTelemetryTelemetryMetricsItemInstrumentHistogram:
		return true
	}
	return false
}

// SdkTelemetryTelemetryMetricsItemTransport The transport the row comes from:
// `bus`, the stream and emits; `content`, uploads and reads.
type SdkTelemetryTelemetryMetricsItemTransport string

// The values of SdkTelemetryTelemetryMetricsItemTransport.
const (
	SdkTelemetryTelemetryMetricsItemTransportBus     SdkTelemetryTelemetryMetricsItemTransport = "bus"
	SdkTelemetryTelemetryMetricsItemTransportContent SdkTelemetryTelemetryMetricsItemTransport = "content"
)

// Valid is whether e is one of SdkTelemetryTelemetryMetricsItemTransport's
// values.
func (e SdkTelemetryTelemetryMetricsItemTransport) Valid() bool {
	switch e {
	case SdkTelemetryTelemetryMetricsItemTransportBus, SdkTelemetryTelemetryMetricsItemTransportContent:
		return true
	}
	return false
}

type SdkTelemetryTelemetrySpansItem struct {
	// Name The row's name; `{channel}` in it is the bus channel, and `{jobType}`
	// the job's type.
	Name string `json:"name"`
	// Transport The transport the row comes from: `bus`, the stream and emits;
	// `content`, uploads and reads.
	Transport SdkTelemetryTelemetrySpansItemTransport `json:"transport"`
	// Kind The span's kind, in OTLP's words.
	Kind SdkTelemetryTelemetrySpansItemKind `json:"kind"`
	// Meaning What the row says.
	Meaning string `json:"meaning"`
	// Attributes The attributes the span carries.
	Attributes []SdkTelemetryTelemetrySpansItemAttributesItem `json:"attributes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v SdkTelemetryTelemetrySpansItem) MarshalJSON() ([]byte, error) {
	type written SdkTelemetryTelemetrySpansItem
	v.Attributes = listOf(v.Attributes)
	return json.Marshal(written(v))
}

// SdkTelemetryTelemetrySpansItemAttributesItem An attribute a row carries.
type SdkTelemetryTelemetrySpansItemAttributesItem struct {
	// Key The attribute's key.
	Key string `json:"key"`
	// Only When alone the attribute is carried: a row's attribute without it is
	// carried every time.
	Only *string `json:"only,omitempty"`
	// Values The only values it carries, each of the type it is carried as: a
	// string or a boolean.
	Values *[]SdkTelemetryTelemetrySpansItemAttributesItemValuesItem `json:"values,omitempty"`
}

type SdkTelemetryTelemetrySpansItemAttributesItemValuesItem struct {
	union[SdkTelemetryTelemetrySpansItemAttributesItemValuesItemMember]
}

// SdkTelemetryTelemetrySpansItemAttributesItemValuesItemMember is a member of
// SdkTelemetryTelemetrySpansItemAttributesItemValuesItem:
// SdkTelemetryTelemetrySpansItemAttributesItemValuesItemText,
// SdkTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean.
type SdkTelemetryTelemetrySpansItemAttributesItemValuesItemMember interface {
	memberOfSdkTelemetryTelemetrySpansItemAttributesItemValuesItem()
}

// Member is the member this value is: the one whose schema admits it.
func (u SdkTelemetryTelemetrySpansItemAttributesItemValuesItem) Member() (any, error) {
	return u.member("SdkTelemetryTelemetrySpansItemAttributesItemValuesItem", sdkTelemetryTelemetrySpansItemAttributesItemValuesItemMembers)
}

// sdkTelemetryTelemetrySpansItemAttributesItemValuesItemMembers is what each
// member of SdkTelemetryTelemetrySpansItemAttributesItemValuesItem admits,
// and how a value of it is read.
var sdkTelemetryTelemetrySpansItemAttributesItemValuesItemMembers = []unionMember{
	{"SdkTelemetryTelemetrySpansItemAttributesItemValuesItemText", readAs[SdkTelemetryTelemetrySpansItemAttributesItemValuesItemText], []signature{{kind: textKind}}},
	{"SdkTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean", readAs[SdkTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean], []signature{{kind: booleanKind}}},
}

// SdkTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean is a
// SdkTelemetryTelemetrySpansItemAttributesItemValuesItem that is boolean.
type SdkTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean bool

func (SdkTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean) memberOfSdkTelemetryTelemetrySpansItemAttributesItemValuesItem() {
}

// SdkTelemetryTelemetrySpansItemAttributesItemValuesItemText is a
// SdkTelemetryTelemetrySpansItemAttributesItemValuesItem that is text.
type SdkTelemetryTelemetrySpansItemAttributesItemValuesItemText string

func (SdkTelemetryTelemetrySpansItemAttributesItemValuesItemText) memberOfSdkTelemetryTelemetrySpansItemAttributesItemValuesItem() {
}

// SdkTelemetryTelemetrySpansItemKind The span's kind, in OTLP's words.
type SdkTelemetryTelemetrySpansItemKind string

// The values of SdkTelemetryTelemetrySpansItemKind.
const (
	SdkTelemetryTelemetrySpansItemKindClient   SdkTelemetryTelemetrySpansItemKind = "client"
	SdkTelemetryTelemetrySpansItemKindConsumer SdkTelemetryTelemetrySpansItemKind = "consumer"
	SdkTelemetryTelemetrySpansItemKindInternal SdkTelemetryTelemetrySpansItemKind = "internal"
	SdkTelemetryTelemetrySpansItemKindProducer SdkTelemetryTelemetrySpansItemKind = "producer"
	SdkTelemetryTelemetrySpansItemKindServer   SdkTelemetryTelemetrySpansItemKind = "server"
)

// Valid is whether e is one of SdkTelemetryTelemetrySpansItemKind's values.
func (e SdkTelemetryTelemetrySpansItemKind) Valid() bool {
	switch e {
	case SdkTelemetryTelemetrySpansItemKindClient, SdkTelemetryTelemetrySpansItemKindConsumer, SdkTelemetryTelemetrySpansItemKindInternal, SdkTelemetryTelemetrySpansItemKindProducer, SdkTelemetryTelemetrySpansItemKindServer:
		return true
	}
	return false
}

// SdkTelemetryTelemetrySpansItemTransport The transport the row comes from:
// `bus`, the stream and emits; `content`, uploads and reads.
type SdkTelemetryTelemetrySpansItemTransport string

// The values of SdkTelemetryTelemetrySpansItemTransport.
const (
	SdkTelemetryTelemetrySpansItemTransportBus     SdkTelemetryTelemetrySpansItemTransport = "bus"
	SdkTelemetryTelemetrySpansItemTransportContent SdkTelemetryTelemetrySpansItemTransport = "content"
)

// Valid is whether e is one of SdkTelemetryTelemetrySpansItemTransport's
// values.
func (e SdkTelemetryTelemetrySpansItemTransport) Valid() bool {
	switch e {
	case SdkTelemetryTelemetrySpansItemTransportBus, SdkTelemetryTelemetrySpansItemTransportContent:
		return true
	}
	return false
}

// SecretRef A secret the document names and does not hold. The launcher hands
// it to the service that needs it, from where the reference says it is.
type SecretRef struct {
	// FromEnv The environment variable that holds the secret where the launcher
	// runs. Unset, the start that needs it is refused.
	FromEnv string `json:"fromEnv"`
}

// Selector One W3C selector: a way of finding a segment of a resource. Tell
// them apart by `type`, which is required on each and single-valued.
type Selector struct {
	union[SelectorMember]
}

// SelectorMember is a member of Selector: TextPositionSelector,
// TextQuoteSelector, SvgSelector, FragmentSelector.
type SelectorMember interface {
	memberOfSelector()
}

// Discriminator is the `type` this value states.
func (u Selector) Discriminator() (string, error) { return u.stated("type") }

// Member is the member this value is: the one whose schema admits it.
func (u Selector) Member() (any, error) { return u.member("Selector", selectorMembers) }

// selectorMembers is what each member of Selector admits, and how a value of
// it is read.
var selectorMembers = []unionMember{
	{"TextPositionSelector", readAs[TextPositionSelector], []signature{{kind: objectKind, required: []string{"type", "start", "end"}, fixed: []fixedValues{{"type", []any{"TextPositionSelector"}}}}}},
	{"TextQuoteSelector", readAs[TextQuoteSelector], []signature{{kind: objectKind, required: []string{"type", "exact"}, fixed: []fixedValues{{"type", []any{"TextQuoteSelector"}}}}}},
	{"SvgSelector", readAs[SvgSelector], []signature{{kind: objectKind, required: []string{"type", "value"}, fixed: []fixedValues{{"type", []any{"SvgSelector"}}}}}},
	{"FragmentSelector", readAs[FragmentSelector], []signature{{kind: objectKind, required: []string{"type", "value"}, fixed: []fixedValues{{"type", []any{"FragmentSelector"}}}}}},
}

func (Selector) memberOfAnnotationSelector() {}

type SemanticMatch struct {
	// Text The chunk text that matched
	Text string `json:"text"`
	// ResourceId Source resource ID
	ResourceId ResourceId `json:"resourceId"`
	// ResourceName The source resource's display name, resolved from its view at
	// gather time. Required: a match card must name its source, and corpus
	// matches routinely come from outside the graph neighborhood, so there is no
	// node to borrow a name from. A match whose source no longer resolves to a
	// view is dropped by the producer rather than served nameless.
	ResourceName string `json:"resourceName"`
	// AnnotationId Source annotation ID, if the match is from an annotation
	AnnotationId *AnnotationId `json:"annotationId,omitempty"`
	// Score Cosine similarity score (0-1)
	Score float64 `json:"score"`
	// EntityTypes Entity types on the matched passage
	EntityTypes *[]string `json:"entityTypes,omitempty"`
	// MachineRead True when this passage's text was recognized from pixels (OCR
	// of a scanned page) rather than read from the document. Absent means read
	// directly — the common case — so the flag is only present where it changes
	// how the text should be trusted. It travels with the passage because a
	// consumer receives the chunk with no document attached and cannot recompute
	// how the text was obtained.
	MachineRead *bool `json:"machineRead,omitempty"`
}

// ServiceAddress The host and port a service listens at.
type ServiceAddress struct {
	Host string `json:"host"`
	Port int    `json:"port"`
}

// ServiceEnvironmentBootRefusals service-environment/boot-refusals.json: what
// a service writes when it refuses to start on its configuration document or
// its environment.
type ServiceEnvironmentBootRefusals struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Services The services that refuse to start so.
	Services []ServiceEnvironmentBootRefusalsServicesItem `json:"services"`
	// Line The one line the service writes to stderr, its refusal in place of
	// `{refusal}`, before it exits.
	Line string `json:"line"`
	// ExitCode The status it exits with.
	ExitCode int `json:"exitCode"`
	// Refusals Each refusal.
	Refusals []ServiceEnvironmentBootRefusalsRefusalsItem `json:"refusals"`
	// Members Each line of the refusal `invalid`: one for each way the document
	// is not its schema's.
	Members []ServiceEnvironmentBootRefusalsMembersItem `json:"members"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ServiceEnvironmentBootRefusals) MarshalJSON() ([]byte, error) {
	type written ServiceEnvironmentBootRefusals
	v.Services = listOf(v.Services)
	v.Refusals = listOf(v.Refusals)
	v.Members = listOf(v.Members)
	return json.Marshal(written(v))
}

type ServiceEnvironmentBootRefusalsMembersItem struct {
	// Name The situation's name.
	Name string `json:"name"`
	// Situation When it is written, and what fills each `{name}` of its text.
	Situation string `json:"situation"`
	// Line The line, filled as the row's `situation` says.
	Line string `json:"line"`
}

type ServiceEnvironmentBootRefusalsRefusalsItem struct {
	// Name The situation's name.
	Name string `json:"name"`
	// Situation When it is written, and what fills each `{name}` of its text.
	Situation string `json:"situation"`
	// Refusal Its text. A `{name}` in it is filled with what the row's
	// `situation` names, and nothing else in it varies.
	Refusal string `json:"refusal"`
}

// ServiceEnvironmentBootRefusalsServicesItem A Xynolog service, by its name.
type ServiceEnvironmentBootRefusalsServicesItem string

// The values of ServiceEnvironmentBootRefusalsServicesItem.
const (
	ServiceEnvironmentBootRefusalsServicesItemArchivist  ServiceEnvironmentBootRefusalsServicesItem = "archivist"
	ServiceEnvironmentBootRefusalsServicesItemDispatcher ServiceEnvironmentBootRefusalsServicesItem = "dispatcher"
	ServiceEnvironmentBootRefusalsServicesItemGateway    ServiceEnvironmentBootRefusalsServicesItem = "gateway"
	ServiceEnvironmentBootRefusalsServicesItemLibrarian  ServiceEnvironmentBootRefusalsServicesItem = "librarian"
	ServiceEnvironmentBootRefusalsServicesItemSmelter    ServiceEnvironmentBootRefusalsServicesItem = "smelter"
	ServiceEnvironmentBootRefusalsServicesItemWeaver     ServiceEnvironmentBootRefusalsServicesItem = "weaver"
	ServiceEnvironmentBootRefusalsServicesItemWorker     ServiceEnvironmentBootRefusalsServicesItem = "worker"
)

// Valid is whether e is one of ServiceEnvironmentBootRefusalsServicesItem's
// values.
func (e ServiceEnvironmentBootRefusalsServicesItem) Valid() bool {
	switch e {
	case ServiceEnvironmentBootRefusalsServicesItemArchivist, ServiceEnvironmentBootRefusalsServicesItemDispatcher, ServiceEnvironmentBootRefusalsServicesItemGateway, ServiceEnvironmentBootRefusalsServicesItemLibrarian, ServiceEnvironmentBootRefusalsServicesItemSmelter, ServiceEnvironmentBootRefusalsServicesItemWeaver, ServiceEnvironmentBootRefusalsServicesItemWorker:
		return true
	}
	return false
}

// ServiceEnvironmentVariables service-environment/variables.json: every
// environment variable a Xynolog service reads, beside its configuration
// document.
type ServiceEnvironmentVariables struct {
	// Comment The rule the table states, in prose.
	Comment   string                                     `json:"$comment"`
	Variables []ServiceEnvironmentVariablesVariablesItem `json:"variables"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ServiceEnvironmentVariables) MarshalJSON() ([]byte, error) {
	type written ServiceEnvironmentVariables
	v.Variables = listOf(v.Variables)
	return json.Marshal(written(v))
}

type ServiceEnvironmentVariablesVariablesItem struct {
	// Name The variable's name.
	Name string `json:"name"`
	// Services The services that read it.
	Services []ServiceEnvironmentVariablesVariablesItemServicesItem `json:"services"`
	// ReadBy What reads it: the service's own code, or the OpenTelemetry SDK.
	ReadBy ServiceEnvironmentVariablesVariablesItemReadBy `json:"readBy"`
	// ProvidedBy What sets it where the launcher runs the service.
	ProvidedBy ServiceEnvironmentVariablesVariablesItemProvidedBy `json:"providedBy"`
	// Required Whether the service refuses to start without it.
	Required bool `json:"required"`
	// Effect What it does.
	Effect string `json:"effect"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ServiceEnvironmentVariablesVariablesItem) MarshalJSON() ([]byte, error) {
	type written ServiceEnvironmentVariablesVariablesItem
	v.Services = listOf(v.Services)
	return json.Marshal(written(v))
}

// ServiceEnvironmentVariablesVariablesItemProvidedBy What sets it where the
// launcher runs the service.
type ServiceEnvironmentVariablesVariablesItemProvidedBy string

// The values of ServiceEnvironmentVariablesVariablesItemProvidedBy.
const (
	ServiceEnvironmentVariablesVariablesItemProvidedByLauncher ServiceEnvironmentVariablesVariablesItemProvidedBy = "launcher"
	ServiceEnvironmentVariablesVariablesItemProvidedByImage    ServiceEnvironmentVariablesVariablesItemProvidedBy = "image"
	ServiceEnvironmentVariablesVariablesItemProvidedByOperator ServiceEnvironmentVariablesVariablesItemProvidedBy = "operator"
)

// Valid is whether e is one of
// ServiceEnvironmentVariablesVariablesItemProvidedBy's values.
func (e ServiceEnvironmentVariablesVariablesItemProvidedBy) Valid() bool {
	switch e {
	case ServiceEnvironmentVariablesVariablesItemProvidedByLauncher, ServiceEnvironmentVariablesVariablesItemProvidedByImage, ServiceEnvironmentVariablesVariablesItemProvidedByOperator:
		return true
	}
	return false
}

// ServiceEnvironmentVariablesVariablesItemReadBy What reads it: the service's
// own code, or the OpenTelemetry SDK.
type ServiceEnvironmentVariablesVariablesItemReadBy string

// The values of ServiceEnvironmentVariablesVariablesItemReadBy.
const (
	ServiceEnvironmentVariablesVariablesItemReadByService       ServiceEnvironmentVariablesVariablesItemReadBy = "service"
	ServiceEnvironmentVariablesVariablesItemReadByOpentelemetry ServiceEnvironmentVariablesVariablesItemReadBy = "opentelemetry"
)

// Valid is whether e is one of
// ServiceEnvironmentVariablesVariablesItemReadBy's values.
func (e ServiceEnvironmentVariablesVariablesItemReadBy) Valid() bool {
	switch e {
	case ServiceEnvironmentVariablesVariablesItemReadByService, ServiceEnvironmentVariablesVariablesItemReadByOpentelemetry:
		return true
	}
	return false
}

// ServiceEnvironmentVariablesVariablesItemServicesItem A Xynolog service, by
// its name.
type ServiceEnvironmentVariablesVariablesItemServicesItem string

// The values of ServiceEnvironmentVariablesVariablesItemServicesItem.
const (
	ServiceEnvironmentVariablesVariablesItemServicesItemArchivist  ServiceEnvironmentVariablesVariablesItemServicesItem = "archivist"
	ServiceEnvironmentVariablesVariablesItemServicesItemDispatcher ServiceEnvironmentVariablesVariablesItemServicesItem = "dispatcher"
	ServiceEnvironmentVariablesVariablesItemServicesItemGateway    ServiceEnvironmentVariablesVariablesItemServicesItem = "gateway"
	ServiceEnvironmentVariablesVariablesItemServicesItemLibrarian  ServiceEnvironmentVariablesVariablesItemServicesItem = "librarian"
	ServiceEnvironmentVariablesVariablesItemServicesItemSmelter    ServiceEnvironmentVariablesVariablesItemServicesItem = "smelter"
	ServiceEnvironmentVariablesVariablesItemServicesItemWeaver     ServiceEnvironmentVariablesVariablesItemServicesItem = "weaver"
	ServiceEnvironmentVariablesVariablesItemServicesItemWorker     ServiceEnvironmentVariablesVariablesItemServicesItem = "worker"
)

// Valid is whether e is one of
// ServiceEnvironmentVariablesVariablesItemServicesItem's values.
func (e ServiceEnvironmentVariablesVariablesItemServicesItem) Valid() bool {
	switch e {
	case ServiceEnvironmentVariablesVariablesItemServicesItemArchivist, ServiceEnvironmentVariablesVariablesItemServicesItemDispatcher, ServiceEnvironmentVariablesVariablesItemServicesItemGateway, ServiceEnvironmentVariablesVariablesItemServicesItemLibrarian, ServiceEnvironmentVariablesVariablesItemServicesItemSmelter, ServiceEnvironmentVariablesVariablesItemServicesItemWeaver, ServiceEnvironmentVariablesVariablesItemServicesItemWorker:
		return true
	}
	return false
}

// ServiceGroup A group of services, as xynolog status reports them and
// --group names them: a knowledge base's record and its index, the issuer
// that signs its accounts in, the knowledge workers where people and agents
// work on it, the providers of its models, and the telemetry that watches
// them all.
type ServiceGroup string

// The values of ServiceGroup.
const (
	ServiceGroupRecord           ServiceGroup = "record"
	ServiceGroupIndex            ServiceGroup = "index"
	ServiceGroupIssuer           ServiceGroup = "issuer"
	ServiceGroupKnowledgeWorkers ServiceGroup = "knowledge-workers"
	ServiceGroupProviders        ServiceGroup = "providers"
	ServiceGroupTelemetry        ServiceGroup = "telemetry"
)

// Valid is whether e is one of ServiceGroup's values.
func (e ServiceGroup) Valid() bool {
	switch e {
	case ServiceGroupRecord, ServiceGroupIndex, ServiceGroupIssuer, ServiceGroupKnowledgeWorkers, ServiceGroupProviders, ServiceGroupTelemetry:
		return true
	}
	return false
}

// ServiceHostParams service.host's params.
type ServiceHostParams struct {
	// ApiVersion The version of the control API the request is written to.
	ApiVersion ApiVersion `json:"apiVersion"`
	// Runtime The container runtime to ask, as --runtime names it. Absent: the
	// one the stack's record names, else the first installed one.
	Runtime *Runtime `json:"runtime,omitempty"`
}

// ServiceHostResult Where this machine and a run's instance meet, under a
// runtime: the address the launcher publishes an instance's ports on, and the
// address the instance reaches this machine's listeners at. A caller writes
// it into a document before the run.
type ServiceHostResult struct {
	Runtime Runtime `json:"runtime"`
	// Address The host address: an IP address or a host name, as the launcher's
	// own stack dials it under this runtime.
	Address string `json:"address"`
}

// ServiceIdentity The identity provider a service's account signs in at, by
// its issuer.
type ServiceIdentity struct {
	// Issuer The issuer URL, exactly as tokens carry it in `iss`.
	Issuer string `json:"issuer"`
}

// ServiceOutput notifications/serviceOutput: one line a run's instance wrote,
// from its start, every line, in the order of its stream, as the instance
// wrote it. The launcher gives an instance none of its own secrets (R2), and
// keeps no copy.
type ServiceOutput struct {
	RequestId RequestId    `json:"requestId"`
	Instance  RunInstance  `json:"instance"`
	Stream    OutputStream `json:"stream"`
	// Line The line, without its newline.
	Line string `json:"line"`
}

// ServiceRunParams service.run's params: one instance of one of a knowledge
// base's own services, run once from the image the target's stack documents
// name, unsupervised, on the caller's document, arguments and environment.
// contract/LAUNCHER-CONTROL.md, R1-R8.
type ServiceRunParams struct {
	// ApiVersion The version of the control API the request is written to.
	ApiVersion ApiVersion `json:"apiVersion"`
	// Target The knowledge base whose stack documents name the service's image,
	// and whose stack the instance belongs to: stack.stop of it removes the
	// instance too.
	Target LocalTarget `json:"target"`
	// Runtime The container runtime to ask, as --runtime names it. Absent: the
	// one the stack's record names, else the first installed one.
	Runtime *Runtime `json:"runtime,omitempty"`
	// Service The service whose image runs.
	Service  RunService  `json:"service"`
	Instance RunInstance `json:"instance"`
	// Document The configuration document's text, written as it is, at the path
	// the image's own arguments name: it need not be JSON. Absent: no file is at
	// that path.
	Document *string `json:"document,omitempty"`
	// Args The arguments the image's program is given in place of the image's
	// own (--config and the document's path). Absent: the image's own.
	Args *[]string `json:"args,omitempty"`
	// Environment Every variable the instance is given beside the image's own,
	// by name: nothing of the launcher's is added (R2). Empty: none.
	Environment map[string]string `json:"environment"`
	// Mounts Directories of this machine, each mounted read-write at its own
	// path, so that a path the document names is the same inside the instance
	// and out (R4). Empty: none.
	Mounts []string `json:"mounts"`
	// PathFirst Directories put before the image's PATH, in order, each mounted
	// at its own path. Empty: the image's PATH as it is.
	PathFirst []string `json:"pathFirst"`
	// Ports The ports the instance listens on, each published at the same number
	// on the host address (R3). Empty: none.
	Ports []int `json:"ports"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ServiceRunParams) MarshalJSON() ([]byte, error) {
	type written ServiceRunParams
	v.Mounts = listOf(v.Mounts)
	v.PathFirst = listOf(v.PathFirst)
	v.Ports = listOf(v.Ports)
	return json.Marshal(written(v))
}

// ServiceRunResult A run that ended: its instance exited. Sent once the
// instance's container has exited, after all of its output.
type ServiceRunResult struct {
	Instance RunInstance `json:"instance"`
	// ExitCode The instance's exit status: the service's own, since nothing
	// supervises it (R1). An instance a signal ended exits with 128 and the
	// signal's number: 143 for SIGTERM, 137 for SIGKILL.
	ExitCode int `json:"exitCode"`
	// RanMs Milliseconds from its container's start to its exit.
	RanMs int `json:"ranMs"`
}

// ServiceSignalParams service.signal's params: a signal for a run's instance.
type ServiceSignalParams struct {
	// ApiVersion The version of the control API the request is written to.
	ApiVersion ApiVersion `json:"apiVersion"`
	// Target The knowledge base whose stack documents name the service's image,
	// and whose stack the instance belongs to: stack.stop of it removes the
	// instance too.
	Target LocalTarget `json:"target"`
	// Runtime The container runtime to ask, as --runtime names it. Absent: the
	// one the stack's record names, else the first installed one.
	Runtime  *Runtime    `json:"runtime,omitempty"`
	Instance RunInstance `json:"instance"`
	// Signal term: SIGTERM, and SIGKILL 15 seconds later if it has not exited.
	// kill: SIGKILL, so nothing it would settle on the way out is settled.
	Signal ServiceSignalParamsSignal `json:"signal"`
}

// ServiceSignalParamsSignal term: SIGTERM, and SIGKILL 15 seconds later if it
// has not exited. kill: SIGKILL, so nothing it would settle on the way out is
// settled.
type ServiceSignalParamsSignal string

// The values of ServiceSignalParamsSignal.
const (
	ServiceSignalParamsSignalTerm ServiceSignalParamsSignal = "term"
	ServiceSignalParamsSignalKill ServiceSignalParamsSignal = "kill"
)

// Valid is whether e is one of ServiceSignalParamsSignal's values.
func (e ServiceSignalParamsSignal) Valid() bool {
	switch e {
	case ServiceSignalParamsSignalTerm, ServiceSignalParamsSignalKill:
		return true
	}
	return false
}

// ServiceSignalResult A signal sent, or not needed. The instance's exit is
// its run's answer, not this one.
type ServiceSignalResult struct {
	// Delivered Whether the instance still ran when the signal came. false: it
	// has exited, and its run's answer is on its way; nothing was sent.
	Delivered bool `json:"delivered"`
}

// ServiceStarted notifications/serviceStarted: a run's instance is running.
// Sent once, before any of its output.
type ServiceStarted struct {
	RequestId RequestId   `json:"requestId"`
	Instance  RunInstance `json:"instance"`
	// Container The runtime's name for the instance's container.
	Container string `json:"container"`
	// DocumentPath Where the instance reads its document: the path the image's
	// own arguments name. Present when the run gave a document.
	DocumentPath *string `json:"documentPath,omitempty"`
	// Address The host address the instance's ports are published on, as
	// service.host names it for the run's runtime.
	Address string `json:"address"`
}

// ServiceStatus One service, as xynolog status reads it: where it runs, its
// state, and whether it answers. Nothing is reported that the launcher did
// not observe: an endpoint is named only when the stack's record or the
// descriptor names one, and a page to open only when the service answers.
type ServiceStatus struct {
	// Role The service, as xynolog status names it.
	Role string `json:"role"`
	// Group The group it belongs to.
	Group ServiceGroup `json:"group"`
	// Product The product its driver names (Neo4j, Keycloak), when its record
	// names a driver.
	Product *string `json:"product,omitempty"`
	// RunsOn Where it runs: the runtime its container runs under, external
	// (somebody else runs it), or host (a process on this machine). Absent when
	// nothing runs it.
	RunsOn *string `json:"runsOn,omitempty"`
	// State running: its container runs. stopped: its container exists and does
	// not run (containerState says how). reachable, unreachable: somebody else
	// runs it, and its endpoint answers or does not. absent: there is no
	// container of it. not-configured: the stack's documents ask for none.
	State ServiceStatusState `json:"state"`
	// ContainerState The runtime's own word for a container that is not running
	// (exited, created).
	ContainerState *string `json:"containerState,omitempty"`
	// Healthy Whether its health endpoint answers.
	Healthy bool `json:"healthy"`
	// Counted Whether its health counts toward its knowledge base's: a service
	// the documents ask for none of, and a telemetry backend --no-observe leaves
	// out, do not.
	Counted bool `json:"counted"`
	// Probe The endpoint the launcher asks its health of: an http URL, or
	// tcp://host:port.
	Probe *string `json:"probe,omitempty"`
	// Page The page a person opens: the Browser, Jaeger's and Prometheus's
	// interfaces, the collector's metrics readout. Present only when the service
	// answers. The collector's OTLP receiver is never one.
	Page *string `json:"page,omitempty"`
	// Realm For the issuer the knowledge base signs in at, when it is the
	// machine's: its realm there.
	Realm *string `json:"realm,omitempty"`
	// Serves For a service several knowledge bases share: the name of each it
	// serves, as knowledgeBases names them.
	Serves *[]string `json:"serves,omitempty"`
}

// ServiceStatusState running: its container runs. stopped: its container
// exists and does not run (containerState says how). reachable, unreachable:
// somebody else runs it, and its endpoint answers or does not. absent: there
// is no container of it. not-configured: the stack's documents ask for none.
type ServiceStatusState string

// The values of ServiceStatusState.
const (
	ServiceStatusStateRunning       ServiceStatusState = "running"
	ServiceStatusStateStopped       ServiceStatusState = "stopped"
	ServiceStatusStateReachable     ServiceStatusState = "reachable"
	ServiceStatusStateUnreachable   ServiceStatusState = "unreachable"
	ServiceStatusStateAbsent        ServiceStatusState = "absent"
	ServiceStatusStateNotConfigured ServiceStatusState = "not-configured"
)

// Valid is whether e is one of ServiceStatusState's values.
func (e ServiceStatusState) Valid() bool {
	switch e {
	case ServiceStatusStateRunning, ServiceStatusStateStopped, ServiceStatusStateReachable, ServiceStatusStateUnreachable, ServiceStatusStateAbsent, ServiceStatusStateNotConfigured:
		return true
	}
	return false
}

// ServiceTelemetryLogLines service-telemetry/log-lines.json: the lines a
// service writes to its log, and the line of its supervisor it counts.
type ServiceTelemetryLogLines struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Logger The lines of a service's logger.
	Logger ServiceTelemetryLogLinesLogger `json:"logger"`
	// Bus A line of the bus log.
	Bus ServiceTelemetryLogLinesBus `json:"bus"`
	// Supervisor The line the supervisor writes when it starts a service.
	Supervisor ServiceTelemetryLogLinesSupervisor `json:"supervisor"`
}

// ServiceTelemetryLogLinesBus A line of the bus log.
type ServiceTelemetryLogLinesBus struct {
	// Line Its head.
	Line string `json:"line"`
	// Parts What follows the head, in order, each where there is one.
	Parts []ServiceTelemetryLogLinesBusPartsItem `json:"parts"`
	// Ops Each operation a line names.
	Ops []string `json:"ops"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ServiceTelemetryLogLinesBus) MarshalJSON() ([]byte, error) {
	type written ServiceTelemetryLogLinesBus
	v.Parts = listOf(v.Parts)
	v.Ops = listOf(v.Ops)
	return json.Marshal(written(v))
}

type ServiceTelemetryLogLinesBusPartsItem struct {
	// Part What it shows.
	Part string `json:"part"`
	// Text Its text.
	Text string `json:"text"`
	// Characters How many characters of it are shown, from its first.
	Characters *int `json:"characters,omitempty"`
}

// ServiceTelemetryLogLinesLogger The lines of a service's logger.
type ServiceTelemetryLogLinesLogger struct {
	// Services The services whose document names a LogFormat.
	Services []ServiceTelemetryLogLinesLoggerServicesItem `json:"services"`
	// Json A line of the `json` format.
	Json ServiceTelemetryLogLinesLoggerJson `json:"json"`
	// Simple A line of the `simple` format.
	Simple string `json:"simple"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ServiceTelemetryLogLinesLogger) MarshalJSON() ([]byte, error) {
	type written ServiceTelemetryLogLinesLogger
	v.Services = listOf(v.Services)
	return json.Marshal(written(v))
}

// ServiceTelemetryLogLinesLoggerJson A line of the `json` format.
type ServiceTelemetryLogLinesLoggerJson struct {
	// First Its first members, in order.
	First []string `json:"first"`
	// RequestId The member that names the request a line was logged while
	// answering.
	RequestId string `json:"requestId"`
	// Trace The members that name the active trace and span, in that order.
	Trace []string `json:"trace"`
	// Last Its last member: the moment.
	Last string `json:"last"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ServiceTelemetryLogLinesLoggerJson) MarshalJSON() ([]byte, error) {
	type written ServiceTelemetryLogLinesLoggerJson
	v.First = listOf(v.First)
	v.Trace = listOf(v.Trace)
	return json.Marshal(written(v))
}

type ServiceTelemetryLogLinesLoggerServicesItem string

// The values of ServiceTelemetryLogLinesLoggerServicesItem.
const (
	ServiceTelemetryLogLinesLoggerServicesItemArchivist  ServiceTelemetryLogLinesLoggerServicesItem = "archivist"
	ServiceTelemetryLogLinesLoggerServicesItemDispatcher ServiceTelemetryLogLinesLoggerServicesItem = "dispatcher"
	ServiceTelemetryLogLinesLoggerServicesItemGateway    ServiceTelemetryLogLinesLoggerServicesItem = "gateway"
)

// Valid is whether e is one of ServiceTelemetryLogLinesLoggerServicesItem's
// values.
func (e ServiceTelemetryLogLinesLoggerServicesItem) Valid() bool {
	switch e {
	case ServiceTelemetryLogLinesLoggerServicesItemArchivist, ServiceTelemetryLogLinesLoggerServicesItemDispatcher, ServiceTelemetryLogLinesLoggerServicesItemGateway:
		return true
	}
	return false
}

// ServiceTelemetryLogLinesSupervisor The line the supervisor writes when it
// starts a service.
type ServiceTelemetryLogLinesSupervisor struct {
	// Line The line.
	Line string `json:"line"`
	// Counted What a service counts the lines that hold of, for each of its
	// lives.
	Counted string `json:"counted"`
}

// ServiceTelemetryTelemetry service-telemetry/telemetry.json: the telemetry
// each Xynolog service exports over OTLP: its spans and metrics, the services
// that export each, and the attributes each carries.
type ServiceTelemetryTelemetry struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Sdk The services that reach the bus through an SDK, and for each the SDK
	// transports it uses, or of a transport it uses part of, the rows it
	// exports.
	Sdk      map[string][]string                     `json:"sdk"`
	Resource []ServiceTelemetryTelemetryResourceItem `json:"resource"`
	Spans    []ServiceTelemetryTelemetrySpansItem    `json:"spans"`
	Metrics  []ServiceTelemetryTelemetryMetricsItem  `json:"metrics"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ServiceTelemetryTelemetry) MarshalJSON() ([]byte, error) {
	type written ServiceTelemetryTelemetry
	v.Resource = listOf(v.Resource)
	v.Spans = listOf(v.Spans)
	v.Metrics = listOf(v.Metrics)
	return json.Marshal(written(v))
}

type ServiceTelemetryTelemetryMetricsItem struct {
	// Name The row's name; `{channel}` in it is the bus channel, and `{jobType}`
	// the job's type.
	Name string `json:"name"`
	// Services The services that export the row.
	Services []ServiceTelemetryTelemetryMetricsItemServicesItem `json:"services"`
	// Instrument The metric's instrument.
	Instrument ServiceTelemetryTelemetryMetricsItemInstrument `json:"instrument"`
	// When When the row arrives.
	When ServiceTelemetryTelemetryMetricsItemWhen `json:"when"`
	// Planes The only signal planes a gateway row arrives on.
	Planes *[]ServiceTelemetryTelemetryMetricsItemPlanesItem `json:"planes,omitempty"`
	// Meaning What the row says.
	Meaning string `json:"meaning"`
	// Attributes The attributes the span carries.
	Attributes []ServiceTelemetryTelemetryMetricsItemAttributesItem `json:"attributes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ServiceTelemetryTelemetryMetricsItem) MarshalJSON() ([]byte, error) {
	type written ServiceTelemetryTelemetryMetricsItem
	v.Services = listOf(v.Services)
	v.Attributes = listOf(v.Attributes)
	return json.Marshal(written(v))
}

// ServiceTelemetryTelemetryMetricsItemAttributesItem An attribute a row
// carries.
type ServiceTelemetryTelemetryMetricsItemAttributesItem struct {
	// Key The attribute's key.
	Key string `json:"key"`
	// Only When alone the attribute is carried: a row's attribute without it is
	// carried every time.
	Only *string `json:"only,omitempty"`
	// Values The only values it carries, each of the type it is carried as: a
	// string or a boolean.
	Values *[]ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem `json:"values,omitempty"`
}

type ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem struct {
	union[ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemMember]
}

// ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemMember is a
// member of ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem:
// ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemText,
// ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean.
type ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemMember interface {
	memberOfServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem()
}

// Member is the member this value is: the one whose schema admits it.
func (u ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem) Member() (any, error) {
	return u.member("ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem", serviceTelemetryTelemetryMetricsItemAttributesItemValuesItemMembers)
}

// serviceTelemetryTelemetryMetricsItemAttributesItemValuesItemMembers is what
// each member of ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem
// admits, and how a value of it is read.
var serviceTelemetryTelemetryMetricsItemAttributesItemValuesItemMembers = []unionMember{
	{"ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemText", readAs[ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemText], []signature{{kind: textKind}}},
	{"ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean", readAs[ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean], []signature{{kind: booleanKind}}},
}

// ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean is a
// ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem that is
// boolean.
type ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean bool

func (ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemBoolean) memberOfServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem() {
}

// ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemText is a
// ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem that is text.
type ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemText string

func (ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemText) memberOfServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem() {
}

// ServiceTelemetryTelemetryMetricsItemInstrument The metric's instrument.
type ServiceTelemetryTelemetryMetricsItemInstrument string

// The values of ServiceTelemetryTelemetryMetricsItemInstrument.
const (
	ServiceTelemetryTelemetryMetricsItemInstrumentCounter       ServiceTelemetryTelemetryMetricsItemInstrument = "counter"
	ServiceTelemetryTelemetryMetricsItemInstrumentUpDownCounter ServiceTelemetryTelemetryMetricsItemInstrument = "up-down counter"
	ServiceTelemetryTelemetryMetricsItemInstrumentGauge         ServiceTelemetryTelemetryMetricsItemInstrument = "gauge"
	ServiceTelemetryTelemetryMetricsItemInstrumentHistogram     ServiceTelemetryTelemetryMetricsItemInstrument = "histogram"
)

// Valid is whether e is one of
// ServiceTelemetryTelemetryMetricsItemInstrument's values.
func (e ServiceTelemetryTelemetryMetricsItemInstrument) Valid() bool {
	switch e {
	case ServiceTelemetryTelemetryMetricsItemInstrumentCounter, ServiceTelemetryTelemetryMetricsItemInstrumentUpDownCounter, ServiceTelemetryTelemetryMetricsItemInstrumentGauge, ServiceTelemetryTelemetryMetricsItemInstrumentHistogram:
		return true
	}
	return false
}

type ServiceTelemetryTelemetryMetricsItemPlanesItem string

// The values of ServiceTelemetryTelemetryMetricsItemPlanesItem.
const (
	ServiceTelemetryTelemetryMetricsItemPlanesItemInProcess ServiceTelemetryTelemetryMetricsItemPlanesItem = "in-process"
	ServiceTelemetryTelemetryMetricsItemPlanesItemNats      ServiceTelemetryTelemetryMetricsItemPlanesItem = "nats"
)

// Valid is whether e is one of
// ServiceTelemetryTelemetryMetricsItemPlanesItem's values.
func (e ServiceTelemetryTelemetryMetricsItemPlanesItem) Valid() bool {
	switch e {
	case ServiceTelemetryTelemetryMetricsItemPlanesItemInProcess, ServiceTelemetryTelemetryMetricsItemPlanesItemNats:
		return true
	}
	return false
}

// ServiceTelemetryTelemetryMetricsItemServicesItem A Xynolog service, by its
// name.
type ServiceTelemetryTelemetryMetricsItemServicesItem string

// The values of ServiceTelemetryTelemetryMetricsItemServicesItem.
const (
	ServiceTelemetryTelemetryMetricsItemServicesItemArchivist  ServiceTelemetryTelemetryMetricsItemServicesItem = "archivist"
	ServiceTelemetryTelemetryMetricsItemServicesItemDispatcher ServiceTelemetryTelemetryMetricsItemServicesItem = "dispatcher"
	ServiceTelemetryTelemetryMetricsItemServicesItemGateway    ServiceTelemetryTelemetryMetricsItemServicesItem = "gateway"
	ServiceTelemetryTelemetryMetricsItemServicesItemLibrarian  ServiceTelemetryTelemetryMetricsItemServicesItem = "librarian"
	ServiceTelemetryTelemetryMetricsItemServicesItemSmelter    ServiceTelemetryTelemetryMetricsItemServicesItem = "smelter"
	ServiceTelemetryTelemetryMetricsItemServicesItemWeaver     ServiceTelemetryTelemetryMetricsItemServicesItem = "weaver"
	ServiceTelemetryTelemetryMetricsItemServicesItemWorker     ServiceTelemetryTelemetryMetricsItemServicesItem = "worker"
)

// Valid is whether e is one of
// ServiceTelemetryTelemetryMetricsItemServicesItem's values.
func (e ServiceTelemetryTelemetryMetricsItemServicesItem) Valid() bool {
	switch e {
	case ServiceTelemetryTelemetryMetricsItemServicesItemArchivist, ServiceTelemetryTelemetryMetricsItemServicesItemDispatcher, ServiceTelemetryTelemetryMetricsItemServicesItemGateway, ServiceTelemetryTelemetryMetricsItemServicesItemLibrarian, ServiceTelemetryTelemetryMetricsItemServicesItemSmelter, ServiceTelemetryTelemetryMetricsItemServicesItemWeaver, ServiceTelemetryTelemetryMetricsItemServicesItemWorker:
		return true
	}
	return false
}

// ServiceTelemetryTelemetryMetricsItemWhen When the row arrives.
type ServiceTelemetryTelemetryMetricsItemWhen string

// The values of ServiceTelemetryTelemetryMetricsItemWhen.
const (
	ServiceTelemetryTelemetryMetricsItemWhenExport     ServiceTelemetryTelemetryMetricsItemWhen = "export"
	ServiceTelemetryTelemetryMetricsItemWhenTraffic    ServiceTelemetryTelemetryMetricsItemWhen = "traffic"
	ServiceTelemetryTelemetryMetricsItemWhenSupervised ServiceTelemetryTelemetryMetricsItemWhen = "supervised"
	ServiceTelemetryTelemetryMetricsItemWhenFatal      ServiceTelemetryTelemetryMetricsItemWhen = "fatal"
)

// Valid is whether e is one of ServiceTelemetryTelemetryMetricsItemWhen's
// values.
func (e ServiceTelemetryTelemetryMetricsItemWhen) Valid() bool {
	switch e {
	case ServiceTelemetryTelemetryMetricsItemWhenExport, ServiceTelemetryTelemetryMetricsItemWhenTraffic, ServiceTelemetryTelemetryMetricsItemWhenSupervised, ServiceTelemetryTelemetryMetricsItemWhenFatal:
		return true
	}
	return false
}

// ServiceTelemetryTelemetryResourceItem An attribute of the resource the
// services' spans and metrics are exported under.
type ServiceTelemetryTelemetryResourceItem struct {
	// Key The attribute's key.
	Key string `json:"key"`
	// Services The services that export the row.
	Services []ServiceTelemetryTelemetryResourceItemServicesItem `json:"services"`
	// Meaning What the attribute says.
	Meaning string `json:"meaning"`
	// Default Its value when nothing says another, with `{service}` the
	// service's name.
	Default *string `json:"default,omitempty"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ServiceTelemetryTelemetryResourceItem) MarshalJSON() ([]byte, error) {
	type written ServiceTelemetryTelemetryResourceItem
	v.Services = listOf(v.Services)
	return json.Marshal(written(v))
}

// ServiceTelemetryTelemetryResourceItemServicesItem A Xynolog service, by its
// name.
type ServiceTelemetryTelemetryResourceItemServicesItem string

// The values of ServiceTelemetryTelemetryResourceItemServicesItem.
const (
	ServiceTelemetryTelemetryResourceItemServicesItemArchivist  ServiceTelemetryTelemetryResourceItemServicesItem = "archivist"
	ServiceTelemetryTelemetryResourceItemServicesItemDispatcher ServiceTelemetryTelemetryResourceItemServicesItem = "dispatcher"
	ServiceTelemetryTelemetryResourceItemServicesItemGateway    ServiceTelemetryTelemetryResourceItemServicesItem = "gateway"
	ServiceTelemetryTelemetryResourceItemServicesItemLibrarian  ServiceTelemetryTelemetryResourceItemServicesItem = "librarian"
	ServiceTelemetryTelemetryResourceItemServicesItemSmelter    ServiceTelemetryTelemetryResourceItemServicesItem = "smelter"
	ServiceTelemetryTelemetryResourceItemServicesItemWeaver     ServiceTelemetryTelemetryResourceItemServicesItem = "weaver"
	ServiceTelemetryTelemetryResourceItemServicesItemWorker     ServiceTelemetryTelemetryResourceItemServicesItem = "worker"
)

// Valid is whether e is one of
// ServiceTelemetryTelemetryResourceItemServicesItem's values.
func (e ServiceTelemetryTelemetryResourceItemServicesItem) Valid() bool {
	switch e {
	case ServiceTelemetryTelemetryResourceItemServicesItemArchivist, ServiceTelemetryTelemetryResourceItemServicesItemDispatcher, ServiceTelemetryTelemetryResourceItemServicesItemGateway, ServiceTelemetryTelemetryResourceItemServicesItemLibrarian, ServiceTelemetryTelemetryResourceItemServicesItemSmelter, ServiceTelemetryTelemetryResourceItemServicesItemWeaver, ServiceTelemetryTelemetryResourceItemServicesItemWorker:
		return true
	}
	return false
}

type ServiceTelemetryTelemetrySpansItem struct {
	// Name The row's name; `{channel}` in it is the bus channel, and `{jobType}`
	// the job's type.
	Name string `json:"name"`
	// Services The services that export the row.
	Services []ServiceTelemetryTelemetrySpansItemServicesItem `json:"services"`
	// Kind The span's kind, in OTLP's words.
	Kind ServiceTelemetryTelemetrySpansItemKind `json:"kind"`
	// When When the row arrives.
	When ServiceTelemetryTelemetrySpansItemWhen `json:"when"`
	// Meaning What the row says.
	Meaning string `json:"meaning"`
	// Attributes The attributes the span carries.
	Attributes []ServiceTelemetryTelemetrySpansItemAttributesItem `json:"attributes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v ServiceTelemetryTelemetrySpansItem) MarshalJSON() ([]byte, error) {
	type written ServiceTelemetryTelemetrySpansItem
	v.Services = listOf(v.Services)
	v.Attributes = listOf(v.Attributes)
	return json.Marshal(written(v))
}

// ServiceTelemetryTelemetrySpansItemAttributesItem An attribute a row
// carries.
type ServiceTelemetryTelemetrySpansItemAttributesItem struct {
	// Key The attribute's key.
	Key string `json:"key"`
	// Only When alone the attribute is carried: a row's attribute without it is
	// carried every time.
	Only *string `json:"only,omitempty"`
	// Values The only values it carries, each of the type it is carried as: a
	// string or a boolean.
	Values *[]ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem `json:"values,omitempty"`
}

type ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem struct {
	union[ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemMember]
}

// ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemMember is a
// member of ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem:
// ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemText,
// ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean.
type ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemMember interface {
	memberOfServiceTelemetryTelemetrySpansItemAttributesItemValuesItem()
}

// Member is the member this value is: the one whose schema admits it.
func (u ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem) Member() (any, error) {
	return u.member("ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem", serviceTelemetryTelemetrySpansItemAttributesItemValuesItemMembers)
}

// serviceTelemetryTelemetrySpansItemAttributesItemValuesItemMembers is what
// each member of ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem
// admits, and how a value of it is read.
var serviceTelemetryTelemetrySpansItemAttributesItemValuesItemMembers = []unionMember{
	{"ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemText", readAs[ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemText], []signature{{kind: textKind}}},
	{"ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean", readAs[ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean], []signature{{kind: booleanKind}}},
}

// ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean is a
// ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem that is boolean.
type ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean bool

func (ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemBoolean) memberOfServiceTelemetryTelemetrySpansItemAttributesItemValuesItem() {
}

// ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemText is a
// ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem that is text.
type ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemText string

func (ServiceTelemetryTelemetrySpansItemAttributesItemValuesItemText) memberOfServiceTelemetryTelemetrySpansItemAttributesItemValuesItem() {
}

// ServiceTelemetryTelemetrySpansItemKind The span's kind, in OTLP's words.
type ServiceTelemetryTelemetrySpansItemKind string

// The values of ServiceTelemetryTelemetrySpansItemKind.
const (
	ServiceTelemetryTelemetrySpansItemKindClient   ServiceTelemetryTelemetrySpansItemKind = "client"
	ServiceTelemetryTelemetrySpansItemKindConsumer ServiceTelemetryTelemetrySpansItemKind = "consumer"
	ServiceTelemetryTelemetrySpansItemKindInternal ServiceTelemetryTelemetrySpansItemKind = "internal"
	ServiceTelemetryTelemetrySpansItemKindProducer ServiceTelemetryTelemetrySpansItemKind = "producer"
	ServiceTelemetryTelemetrySpansItemKindServer   ServiceTelemetryTelemetrySpansItemKind = "server"
)

// Valid is whether e is one of ServiceTelemetryTelemetrySpansItemKind's
// values.
func (e ServiceTelemetryTelemetrySpansItemKind) Valid() bool {
	switch e {
	case ServiceTelemetryTelemetrySpansItemKindClient, ServiceTelemetryTelemetrySpansItemKindConsumer, ServiceTelemetryTelemetrySpansItemKindInternal, ServiceTelemetryTelemetrySpansItemKindProducer, ServiceTelemetryTelemetrySpansItemKindServer:
		return true
	}
	return false
}

// ServiceTelemetryTelemetrySpansItemServicesItem A Xynolog service, by its
// name.
type ServiceTelemetryTelemetrySpansItemServicesItem string

// The values of ServiceTelemetryTelemetrySpansItemServicesItem.
const (
	ServiceTelemetryTelemetrySpansItemServicesItemArchivist  ServiceTelemetryTelemetrySpansItemServicesItem = "archivist"
	ServiceTelemetryTelemetrySpansItemServicesItemDispatcher ServiceTelemetryTelemetrySpansItemServicesItem = "dispatcher"
	ServiceTelemetryTelemetrySpansItemServicesItemGateway    ServiceTelemetryTelemetrySpansItemServicesItem = "gateway"
	ServiceTelemetryTelemetrySpansItemServicesItemLibrarian  ServiceTelemetryTelemetrySpansItemServicesItem = "librarian"
	ServiceTelemetryTelemetrySpansItemServicesItemSmelter    ServiceTelemetryTelemetrySpansItemServicesItem = "smelter"
	ServiceTelemetryTelemetrySpansItemServicesItemWeaver     ServiceTelemetryTelemetrySpansItemServicesItem = "weaver"
	ServiceTelemetryTelemetrySpansItemServicesItemWorker     ServiceTelemetryTelemetrySpansItemServicesItem = "worker"
)

// Valid is whether e is one of
// ServiceTelemetryTelemetrySpansItemServicesItem's values.
func (e ServiceTelemetryTelemetrySpansItemServicesItem) Valid() bool {
	switch e {
	case ServiceTelemetryTelemetrySpansItemServicesItemArchivist, ServiceTelemetryTelemetrySpansItemServicesItemDispatcher, ServiceTelemetryTelemetrySpansItemServicesItemGateway, ServiceTelemetryTelemetrySpansItemServicesItemLibrarian, ServiceTelemetryTelemetrySpansItemServicesItemSmelter, ServiceTelemetryTelemetrySpansItemServicesItemWeaver, ServiceTelemetryTelemetrySpansItemServicesItemWorker:
		return true
	}
	return false
}

// ServiceTelemetryTelemetrySpansItemWhen When the row arrives.
type ServiceTelemetryTelemetrySpansItemWhen string

// The values of ServiceTelemetryTelemetrySpansItemWhen.
const (
	ServiceTelemetryTelemetrySpansItemWhenExport     ServiceTelemetryTelemetrySpansItemWhen = "export"
	ServiceTelemetryTelemetrySpansItemWhenTraffic    ServiceTelemetryTelemetrySpansItemWhen = "traffic"
	ServiceTelemetryTelemetrySpansItemWhenSupervised ServiceTelemetryTelemetrySpansItemWhen = "supervised"
	ServiceTelemetryTelemetrySpansItemWhenFatal      ServiceTelemetryTelemetrySpansItemWhen = "fatal"
)

// Valid is whether e is one of ServiceTelemetryTelemetrySpansItemWhen's
// values.
func (e ServiceTelemetryTelemetrySpansItemWhen) Valid() bool {
	switch e {
	case ServiceTelemetryTelemetrySpansItemWhenExport, ServiceTelemetryTelemetrySpansItemWhenTraffic, ServiceTelemetryTelemetrySpansItemWhenSupervised, ServiceTelemetryTelemetrySpansItemWhenFatal:
		return true
	}
	return false
}

// Session The launcher's own stored sign-in for a stack (xynolog login),
// never Desktop's. No token is in it.
type Session struct {
	// State valid: the stack's gateway accepts the stored token. expired: it
	// refuses it (a refresh, or xynolog login, renews it). unverified: the stack
	// did not answer. none: nothing is stored.
	State SessionState `json:"state"`
	// Email The email the session was signed in as, when the store records one.
	Email *string `json:"email,omitempty"`
}

// SessionEndReason Why a session ended: `expired`, the issuer refused to
// renew its token; `refused`, the gateway refused a token its issuer had just
// issued.
type SessionEndReason string

// The values of SessionEndReason.
const (
	SessionEndReasonExpired SessionEndReason = "expired"
	SessionEndReasonRefused SessionEndReason = "refused"
)

// Valid is whether e is one of SessionEndReason's values.
func (e SessionEndReason) Valid() bool {
	switch e {
	case SessionEndReasonExpired, SessionEndReasonRefused:
		return true
	}
	return false
}

// SessionEnded A session ended, and why.
type SessionEnded struct {
	// Reason Why it ended.
	Reason SessionEndReason `json:"reason"`
}

// SessionJoinedEvent A participant opened a live connection to this KB — an
// SSE stream on /bus/subscribe. Presence is CONNECTION lifecycle, not login:
// a token can be minted and sit unused, so what this reports is that someone
// is WATCHING. One person with two tabs produces two of these, which is why
// connectionId is required — the DID alone cannot tell two connections apart,
// and a consumer that counts DIDs will undercount viewers.
type SessionJoinedEvent struct {
	// Participant DID of the authenticated principal on that connection. A
	// person or a software agent — the bus does not distinguish.
	Participant UserId `json:"participant"`
	// ConnectionId Identifies this connection for its lifetime. The matching
	// session:left carries the same value.
	ConnectionId string `json:"connectionId"`
}

// SessionLeftEvent A participant's live connection to this KB ended — the SSE
// stream aborted. Carries the same connectionId as the session:joined that
// opened it, so a consumer tracking who is present can retire the right
// connection rather than assuming one per participant.
type SessionLeftEvent struct {
	// Participant DID of the authenticated principal on that connection.
	Participant UserId `json:"participant"`
	// ConnectionId The connectionId announced by the matching session:joined.
	ConnectionId string `json:"connectionId"`
}

// SessionOauth session/oauth.json: the clients a Xynolog client signs in to
// the issuer as, and the scope every sign-in asks for.
type SessionOauth struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Clients The clients the realm registers.
	Clients []SessionOauthClientsItem `json:"clients"`
	// Scopes What every sign-in asks for.
	Scopes SessionOauthScopes `json:"scopes"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v SessionOauth) MarshalJSON() ([]byte, error) {
	type written SessionOauth
	v.Clients = listOf(v.Clients)
	return json.Marshal(written(v))
}

type SessionOauthClientsItem struct {
	// Name What the client is named by in every SDK.
	Name string `json:"name"`
	// Id The client id the realm registers.
	Id string `json:"id"`
	// Docs Its documentation, in prose.
	Docs string `json:"docs"`
}

// SessionOauthScopes What every sign-in asks for.
type SessionOauthScopes struct {
	// Value The scopes, separated by a space.
	Value string `json:"value"`
	// Docs Its documentation, in prose.
	Docs string `json:"docs"`
}

// SessionState valid: the stack's gateway accepts the stored token. expired:
// it refuses it (a refresh, or xynolog login, renews it). unverified: the
// stack did not answer. none: nothing is stored.
type SessionState string

// The values of SessionState.
const (
	SessionStateValid      SessionState = "valid"
	SessionStateExpired    SessionState = "expired"
	SessionStateUnverified SessionState = "unverified"
	SessionStateNone       SessionState = "none"
)

// Valid is whether e is one of SessionState's values.
func (e SessionState) Valid() bool {
	switch e {
	case SessionStateValid, SessionStateExpired, SessionStateUnverified, SessionStateNone:
		return true
	}
	return false
}

// Setting One setting the launcher keeps, as xynolog settings shows it.
type Setting struct {
	// Name Its name, as xynolog settings takes it.
	Name string `json:"name"`
	// Default Whether this is the machine-wide form of a knowledge-base setting
	// (secret-store --default).
	Default bool `json:"default"`
	// AppliesTo What it applies to: every knowledge base on this machine, or
	// one.
	AppliesTo SettingAppliesTo `json:"appliesTo"`
	// Values The values in effect, one per line xynolog settings shows.
	Values []SettingLine `json:"values"`
	// Settable Whether settings.set and settings.unset change it.
	Settable bool `json:"settable"`
	// ChangedBy For one they do not: how it is changed instead.
	ChangedBy *string `json:"changedBy,omitempty"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v Setting) MarshalJSON() ([]byte, error) {
	type written Setting
	v.Values = listOf(v.Values)
	return json.Marshal(written(v))
}

// SettingAppliesTo What it applies to: every knowledge base on this machine,
// or one.
type SettingAppliesTo string

// The values of SettingAppliesTo.
const (
	SettingAppliesToMachine       SettingAppliesTo = "machine"
	SettingAppliesToKnowledgeBase SettingAppliesTo = "knowledge-base"
)

// Valid is whether e is one of SettingAppliesTo's values.
func (e SettingAppliesTo) Valid() bool {
	switch e {
	case SettingAppliesToMachine, SettingAppliesToKnowledgeBase:
		return true
	}
	return false
}

// SettingLine One value of a setting, and where it came from, as xynolog
// settings shows it. A secret's value is never one: a secret setting shows
// where the value is kept.
type SettingLine struct {
	// Value The value in effect.
	Value string `json:"value"`
	// Source Where it came from: a record, a document, the default.
	Source string `json:"source"`
}

// SettingsGetParams settings.get's params.
type SettingsGetParams struct {
	// ApiVersion The version of the control API the request is written to.
	ApiVersion ApiVersion `json:"apiVersion"`
	// Name The setting, as xynolog settings names it.
	Name string `json:"name"`
	// Default The machine-wide form of a knowledge-base setting: --default.
	Default *bool `json:"default,omitempty"`
	// Root A knowledge base's clone, by path or by the basename of a registered
	// root, as --root takes it. Absent: the clone the control server was started
	// in.
	Root *string `json:"root,omitempty"`
}

// SettingsHoverDelayChangedEvent Emitted when the hover delay setting changes
type SettingsHoverDelayChangedEvent struct {
	HoverDelayMs int `json:"hoverDelayMs"`
}

// SettingsListParams settings.list's params.
type SettingsListParams struct {
	// ApiVersion The version of the control API the request is written to.
	ApiVersion ApiVersion `json:"apiVersion"`
	// Root A knowledge base's clone, by path or by the basename of a registered
	// root, as --root takes it. Absent: the clone the control server was started
	// in.
	Root *string `json:"root,omitempty"`
}

// SettingsListResult Every setting the launcher keeps: the machine's, then
// the knowledge base's.
type SettingsListResult struct {
	// Root The knowledge base whose settings are listed, when one resolved.
	Root *string `json:"root,omitempty"`
	// Unresolved Why no knowledge base resolved, when none did: its settings are
	// not listed.
	Unresolved *string `json:"unresolved,omitempty"`
	// Settings Each setting.
	Settings []Setting `json:"settings"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v SettingsListResult) MarshalJSON() ([]byte, error) {
	type written SettingsListResult
	v.Settings = listOf(v.Settings)
	return json.Marshal(written(v))
}

// SettingsLocaleChangedEvent Emitted when the UI locale setting changes
type SettingsLocaleChangedEvent struct {
	Locale string `json:"locale"`
}

// SettingsPathParams settings.path's params.
type SettingsPathParams struct {
	// ApiVersion The version of the control API the request is written to.
	ApiVersion ApiVersion `json:"apiVersion"`
	// Document Whose document: the Browser's, the worker's, the issuer's or the
	// vector store's.
	Document SettingsPathParamsDocument `json:"document"`
}

// SettingsPathParamsDocument Whose document: the Browser's, the worker's, the
// issuer's or the vector store's.
type SettingsPathParamsDocument string

// The values of SettingsPathParamsDocument.
const (
	SettingsPathParamsDocumentBrowser SettingsPathParamsDocument = "browser"
	SettingsPathParamsDocumentWorker  SettingsPathParamsDocument = "worker"
	SettingsPathParamsDocumentIssuer  SettingsPathParamsDocument = "issuer"
	SettingsPathParamsDocumentVectors SettingsPathParamsDocument = "vectors"
)

// Valid is whether e is one of SettingsPathParamsDocument's values.
func (e SettingsPathParamsDocument) Valid() bool {
	switch e {
	case SettingsPathParamsDocumentBrowser, SettingsPathParamsDocumentWorker, SettingsPathParamsDocumentIssuer, SettingsPathParamsDocumentVectors:
		return true
	}
	return false
}

// SettingsPathResult Where a machine document is. When there is none, it is
// written from the launcher's catalog first, as a start writes it; one that
// does not hold is refused, as a start refuses it.
type SettingsPathResult struct {
	// Path The document's path.
	Path string `json:"path"`
}

// SettingsSetParams settings.set's params.
type SettingsSetParams struct {
	// ApiVersion The version of the control API the request is written to.
	ApiVersion ApiVersion `json:"apiVersion"`
	// Name The setting, as xynolog settings names it.
	Name string `json:"name"`
	// Default The machine-wide form of a knowledge-base setting: --default.
	Default *bool `json:"default,omitempty"`
	// Root A knowledge base's clone, by path or by the basename of a registered
	// root, as --root takes it. Absent: the clone the control server was started
	// in.
	Root *string `json:"root,omitempty"`
	// Value The value, checked as a start would check it.
	Value string `json:"value"`
}

// SettingsThemeChangedEvent Emitted when the UI theme setting changes
type SettingsThemeChangedEvent struct {
	Theme SettingsThemeChangedEventTheme `json:"theme"`
}

type SettingsThemeChangedEventTheme string

// The values of SettingsThemeChangedEventTheme.
const (
	SettingsThemeChangedEventThemeLight  SettingsThemeChangedEventTheme = "light"
	SettingsThemeChangedEventThemeDark   SettingsThemeChangedEventTheme = "dark"
	SettingsThemeChangedEventThemeSystem SettingsThemeChangedEventTheme = "system"
)

// Valid is whether e is one of SettingsThemeChangedEventTheme's values.
func (e SettingsThemeChangedEventTheme) Valid() bool {
	switch e {
	case SettingsThemeChangedEventThemeLight, SettingsThemeChangedEventThemeDark, SettingsThemeChangedEventThemeSystem:
		return true
	}
	return false
}

// SettingsUnsetParams settings.unset's params.
type SettingsUnsetParams struct {
	// ApiVersion The version of the control API the request is written to.
	ApiVersion ApiVersion `json:"apiVersion"`
	// Name The setting, as xynolog settings names it.
	Name string `json:"name"`
	// Default The machine-wide form of a knowledge-base setting: --default.
	Default *bool `json:"default,omitempty"`
	// Root A knowledge base's clone, by path or by the basename of a registered
	// root, as --root takes it. Absent: the clone the control server was started
	// in.
	Root *string `json:"root,omitempty"`
}

// SignInOutcome The entry a sign-in landed on, and what the person believed,
// so a host can set the two against each other and say when they differ. The
// sign-in stands either way: the knowledge base that answered is the one
// reached.
type SignInOutcome struct {
	// Kb The entry the sign-in made or signed in to again.
	Kb KnowledgeBase `json:"kb"`
	// Expected What the person believed they were signing in to. Absent when
	// they named nothing.
	Expected *Expected `json:"expected,omitempty"`
}

// SignInStoreOwnerOnly sign-in-store/owner-only.json: how a writer keeps a
// directory and a file to its owner.
type SignInStoreOwnerOnly struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// DirectoryMode A mode, on a system that has modes.
	DirectoryMode SignInStoreOwnerOnlyDirectoryMode `json:"directoryMode"`
	// FileMode A mode, on a system that has modes.
	FileMode SignInStoreOwnerOnlyFileMode `json:"fileMode"`
	// DirectoryAccessList An access list, on Windows.
	DirectoryAccessList SignInStoreOwnerOnlyDirectoryAccessList `json:"directoryAccessList"`
	// FileAccessList An access list, on Windows.
	FileAccessList SignInStoreOwnerOnlyFileAccessList `json:"fileAccessList"`
}

// SignInStoreOwnerOnlyDirectoryAccessList An access list, on Windows.
type SignInStoreOwnerOnlyDirectoryAccessList struct {
	// Value The access list in SDDL, with `{owner}` where the owner's SID goes.
	Value string `json:"value"`
	Docs  string `json:"docs"`
}

// SignInStoreOwnerOnlyDirectoryMode A mode, on a system that has modes.
type SignInStoreOwnerOnlyDirectoryMode struct {
	// Value The mode, in octal.
	Value string `json:"value"`
	Docs  string `json:"docs"`
}

// SignInStoreOwnerOnlyFileAccessList An access list, on Windows.
type SignInStoreOwnerOnlyFileAccessList struct {
	// Value The access list in SDDL, with `{owner}` where the owner's SID goes.
	Value string `json:"value"`
	Docs  string `json:"docs"`
}

// SignInStoreOwnerOnlyFileMode A mode, on a system that has modes.
type SignInStoreOwnerOnlyFileMode struct {
	// Value The mode, in octal.
	Value string `json:"value"`
	Docs  string `json:"docs"`
}

// SignedIn What a completed sign-in learned, as a registry is handed it to
// record: where it was, who the knowledge base there says it is, the tokens,
// and what the person believed they were signing in to.
type SignedIn struct {
	// Endpoint Where the sign-in was.
	Endpoint KbEndpoint `json:"endpoint"`
	// Description What the knowledge base said of itself, asked with the new
	// token.
	Description KbDescription `json:"description"`
	// Session The tokens, as a registry keeps them.
	Session StoredSession `json:"session"`
	// KbId The registered knowledge base the person signed in to again. Absent
	// when it is none.
	KbId *string `json:"kbId,omitempty"`
	// ExpectedDid The did of what the person believed they clicked. Absent when
	// they named nothing.
	ExpectedDid *string `json:"expectedDid,omitempty"`
	// ExpectedName The name of what the person believed they clicked. Absent
	// when they named nothing.
	ExpectedName *string `json:"expectedName,omitempty"`
}

// SmeltRebuildAnchorsCommand Bus command to rebuild anchored-text artifacts
// by re-running extraction — every geometry-capable resource when resourceId
// is absent, one resource when present. Served by the Smelter, serialized
// (each unit can be a multi-second OCR pass), and never destructive: nothing
// is deleted first, stale entries are simply overwritten. Re-anchoring makes
// zero embedding calls — the vectors are already correct; only the derived
// map is re-made. Partial completion replies failed, with counts: a rebuild
// that quietly skipped resources would present exactly like a document with
// no text.
type SmeltRebuildAnchorsCommand struct {
	// ResourceId When present, re-anchor only this resource; otherwise every
	// geometry-capable resource in the catalog.
	ResourceId *ResourceId `json:"resourceId,omitempty"`
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId *UserId `json:"_userId,omitempty"`
}

// SmeltSettled The payload of `smelt:settled`: the Smelter's decision for one
// resource's content, keyed by the checksum of the bytes it inspected.
// `indexed`: the content is in the vector index. `skipped`: it declined, and
// `reason` says why.
type SmeltSettled struct {
	// ResourceId The resource whose content was inspected.
	ResourceId ResourceId `json:"resourceId"`
	// ContentChecksum The checksum of the bytes inspected.
	ContentChecksum string              `json:"contentChecksum"`
	Outcome         SmeltSettledOutcome `json:"outcome"`
	// Reason Why the content was skipped.
	Reason *SmeltSettledReason `json:"reason,omitempty"`
}

type SmeltSettledOutcome string

// The values of SmeltSettledOutcome.
const (
	SmeltSettledOutcomeIndexed SmeltSettledOutcome = "indexed"
	SmeltSettledOutcomeSkipped SmeltSettledOutcome = "skipped"
)

// Valid is whether e is one of SmeltSettledOutcome's values.
func (e SmeltSettledOutcome) Valid() bool {
	switch e {
	case SmeltSettledOutcomeIndexed, SmeltSettledOutcomeSkipped:
		return true
	}
	return false
}

// SmeltSettledReason Why the content was skipped.
type SmeltSettledReason string

// The values of SmeltSettledReason.
const (
	SmeltSettledReasonNoExtractor SmeltSettledReason = "no-extractor"
	SmeltSettledReasonEmpty       SmeltSettledReason = "empty"
	SmeltSettledReasonNoTextLayer SmeltSettledReason = "no-text-layer"
	SmeltSettledReasonEncrypted   SmeltSettledReason = "encrypted"
	SmeltSettledReasonCorrupt     SmeltSettledReason = "corrupt"
	SmeltSettledReasonTooLarge    SmeltSettledReason = "too-large"
)

// Valid is whether e is one of SmeltSettledReason's values.
func (e SmeltSettledReason) Valid() bool {
	switch e {
	case SmeltSettledReasonNoExtractor, SmeltSettledReasonEmpty, SmeltSettledReasonNoTextLayer, SmeltSettledReasonEncrypted, SmeltSettledReasonCorrupt, SmeltSettledReasonTooLarge:
		return true
	}
	return false
}

// SmelterChunking The two numbers a text is cut by before it is embedded,
// both in tokens, a token being taken as four code points.
type SmelterChunking struct {
	// ChunkSize The size of a chunk.
	ChunkSize int `json:"chunkSize"`
	// Overlap How much of a chunk the next one repeats.
	Overlap int `json:"overlap"`
}

// SmelterConfig Everything a Smelter reads at boot: nothing in it is
// defaulted by the Smelter. Whoever starts a Smelter writes it, from the
// knowledge base's stack documents, and the Smelter reads it from the path
// its `--config` flag names. This schema is the contract, and a Smelter needs
// no launcher. Started without `--config`, or with a path that names no file,
// the Smelter refuses to start and says which. No secret is a value here: an
// embedding provider's key is named by the environment variable that holds
// it, and the Smelter's own service account is `XYNOLOG_OIDC_CLIENT_ID` and
// `XYNOLOG_OIDC_CLIENT_SECRET` in its environment. A document that does not
// validate is refused at boot, naming each failing field.
type SmelterConfig struct {
	Kb KbIdentity `json:"kb"`
	// GatewayUrl The URL the Smelter reaches the gateway at: its route to the
	// bus.
	GatewayUrl string `json:"gatewayUrl"`
	// Identity The issuer the Smelter's service account signs in at.
	Identity ServiceIdentity `json:"identity"`
	// Archivist Where the Archivist listens. The Smelter reads a resource's
	// bytes from it, and keeps the anchored-text store there, as its service
	// account.
	Archivist ServiceAddress  `json:"archivist"`
	Embedding EmbeddingConfig `json:"embedding"`
	Vectors   VectorsConfig   `json:"vectors"`
	Chunking  SmelterChunking `json:"chunking"`
	// PdfsAtOnce How many PDFs the Smelter works on at once. Each one under way
	// holds its bytes, a page of a scan in pixels beside the OCR process reading
	// it, and its text and vectors, so whoever starts a Smelter sizes this with
	// the memory it gives it. Every other resource is indexed beside them.
	PdfsAtOnce  int         `json:"pdfsAtOnce"`
	CursorsPath CursorsPath `json:"cursorsPath"`
	// Port The port the Smelter answers `/health` on.
	Port      int       `json:"port"`
	LogLevel  LogLevel  `json:"logLevel"`
	LogFormat LogFormat `json:"logFormat"`
}

// SmelterHealth The Smelter's health answer (SMELTER.md § Health): seven
// members, each from what the Smelter holds, for it asks nothing of the
// gateway, its embedding provider or its vector database to answer. `status`
// is `ok` whenever it answers, and says what else is so in the members beside
// it.
type SmelterHealth struct {
	Status SmelterHealthStatus `json:"status"`
	// Kb The DID of the knowledge base it serves: the one its settings name,
	// which that knowledge base said it is before the Smelter reached its index.
	Kb KbDid `json:"kb"`
	// Stream The state of its own stream of the record, one of the seven of
	// TRANSPORT-HTTP.md § Connection lifecycle. Events are delivered to it while
	// it is `open`.
	Stream SmelterHealthStream `json:"stream"`
	// Following How far it has followed the record. Its sweep is also `due`
	// where its start's reconcile failed.
	Following FollowerFollowing `json:"following"`
	// EventsProcessed How many events it has applied since it started: events of
	// the kinds that do something, and not refused. Neither an event taken as
	// nothing nor the work of a reconcile or a rebuild is counted.
	EventsProcessed int `json:"eventsProcessed"`
	// Reconcile How far the latest reconcile has got: the pass's `summary` when
	// it is done, or its `error` when it failed.
	Reconcile SmelterHealthReconcile `json:"reconcile"`
	// Index What the Smelter holds its index to, and what this start did for
	// that.
	Index SmelterHealthIndex `json:"index"`
}

// SmelterHealthIndex What the Smelter holds its index to, and what this start
// did for that.
type SmelterHealthIndex struct {
	// Stamp The model and the cut it makes an index by.
	Stamp SmelterHealthIndexStamp `json:"stamp"`
	// MadeAnew Whether this start made the index again, as it does where the
	// index stated another stamp, or none.
	MadeAnew bool `json:"madeAnew"`
}

// SmelterHealthIndexStamp The model and the cut it makes an index by.
type SmelterHealthIndexStamp struct {
	// Embedding The embedding provider's kind and model.
	Embedding SmelterHealthIndexStampEmbedding `json:"embedding"`
	Chunking  SmelterChunking                  `json:"chunking"`
}

// SmelterHealthIndexStampEmbedding The embedding provider's kind and model.
type SmelterHealthIndexStampEmbedding struct {
	Type  string `json:"type"`
	Model string `json:"model"`
}

// SmelterHealthReconcile How far the latest reconcile has got: the pass's
// `summary` when it is done, or its `error` when it failed.
type SmelterHealthReconcile struct {
	Phase SmelterHealthReconcilePhase `json:"phase"`
	// Summary What the pass came to.
	Summary *SmelterReconcileSummary `json:"summary,omitempty"`
	// Error Why it failed.
	Error *string `json:"error,omitempty"`
}

type SmelterHealthReconcilePhase string

// The values of SmelterHealthReconcilePhase.
const (
	SmelterHealthReconcilePhasePending SmelterHealthReconcilePhase = "pending"
	SmelterHealthReconcilePhaseRunning SmelterHealthReconcilePhase = "running"
	SmelterHealthReconcilePhaseDone    SmelterHealthReconcilePhase = "done"
	SmelterHealthReconcilePhaseFailed  SmelterHealthReconcilePhase = "failed"
)

// Valid is whether e is one of SmelterHealthReconcilePhase's values.
func (e SmelterHealthReconcilePhase) Valid() bool {
	switch e {
	case SmelterHealthReconcilePhasePending, SmelterHealthReconcilePhaseRunning, SmelterHealthReconcilePhaseDone, SmelterHealthReconcilePhaseFailed:
		return true
	}
	return false
}

type SmelterHealthStatus string

// The values of SmelterHealthStatus.
const (
	SmelterHealthStatusOk SmelterHealthStatus = "ok"
)

// Valid is whether e is one of SmelterHealthStatus's values.
func (e SmelterHealthStatus) Valid() bool {
	switch e {
	case SmelterHealthStatusOk:
		return true
	}
	return false
}

// SmelterHealthStream The state of its own stream of the record, one of the
// seven of TRANSPORT-HTTP.md § Connection lifecycle. Events are delivered to
// it while it is `open`.
type SmelterHealthStream string

// The values of SmelterHealthStream.
const (
	SmelterHealthStreamInitial         SmelterHealthStream = "initial"
	SmelterHealthStreamConnecting      SmelterHealthStream = "connecting"
	SmelterHealthStreamOpen            SmelterHealthStream = "open"
	SmelterHealthStreamReconnecting    SmelterHealthStream = "reconnecting"
	SmelterHealthStreamDegraded        SmelterHealthStream = "degraded"
	SmelterHealthStreamUnauthenticated SmelterHealthStream = "unauthenticated"
	SmelterHealthStreamClosed          SmelterHealthStream = "closed"
)

// Valid is whether e is one of SmelterHealthStream's values.
func (e SmelterHealthStream) Valid() bool {
	switch e {
	case SmelterHealthStreamInitial, SmelterHealthStreamConnecting, SmelterHealthStreamOpen, SmelterHealthStreamReconnecting, SmelterHealthStreamDegraded, SmelterHealthStreamUnauthenticated, SmelterHealthStreamClosed:
		return true
	}
	return false
}

// SmelterMessages smelter/messages.json: the words of the Smelter's refusals,
// and of the messages it logs that a reader relies on.
type SmelterMessages struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Refusals Each refusal of an operation, on the operation's failure channel.
	Refusals []SmelterMessagesRefusalsItem `json:"refusals"`
	// Logged Each message the Smelter logs that a reader of its output relies
	// on.
	Logged []SmelterMessagesLoggedItem `json:"logged"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v SmelterMessages) MarshalJSON() ([]byte, error) {
	type written SmelterMessages
	v.Refusals = listOf(v.Refusals)
	v.Logged = listOf(v.Logged)
	return json.Marshal(written(v))
}

type SmelterMessagesLoggedItem struct {
	// Name The situation's name.
	Name  string   `json:"name"`
	Level LogLevel `json:"level"`
	// Situation When it is written, what fills each `{name}` of its fields, and
	// what each fact it carries says.
	Situation string `json:"situation"`
	// Message The line's message, word for word.
	Message string `json:"message"`
	// Fields The facts the line is logged with whose form is stated, by name:
	// each a text whose `{name}` is filled as the row's `situation` says. A fact
	// that is a number is its decimal digits.
	Fields map[string]string `json:"fields"`
	// Carries The facts the line is logged with beside `fields`, whose value the
	// row's `situation` says and whose form is not stated. The line may carry
	// others.
	Carries []string `json:"carries"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v SmelterMessagesLoggedItem) MarshalJSON() ([]byte, error) {
	type written SmelterMessagesLoggedItem
	v.Carries = listOf(v.Carries)
	return json.Marshal(written(v))
}

type SmelterMessagesRefusalsItem struct {
	// Name The situation's name.
	Name string `json:"name"`
	// Operation The operation it refuses: a request of bus/registry.json's
	// operations that the Smelter answers.
	Operation string `json:"operation"`
	// Situation When it is written, and what fills each `{name}` of its text.
	Situation string `json:"situation"`
	// Message The failure's `message`. A `{name}` in it is filled with what the
	// row's `situation` names, and nothing else in it varies.
	Message string `json:"message"`
}

// SmelterReconcileSummary What a Smelter's reconcile came to (SMELTER.md §
// Reconcile), as its health reports a pass that is done (SmelterHealth's
// `reconcile.summary`). The first four add up to how many resources it set
// out to index, less any whose indexing was no longer wanted when its turn
// came.
type SmelterReconcileSummary struct {
	// ResourcesEmbedded How many resources it set out to index were indexed.
	ResourcesEmbedded int `json:"resourcesEmbedded"`
	// ResourcesSkipped How many were skipped, by the reason each was skipped
	// for: a reason `smelt:settled` carries (SmeltSettled).
	ResourcesSkipped map[string]int `json:"resourcesSkipped"`
	// ResourcesUnavailable How many could not be read.
	ResourcesUnavailable int `json:"resourcesUnavailable"`
	// ResourcesFailed How many failed.
	ResourcesFailed int `json:"resourcesFailed"`
	// ResourcesRestamped How many resources it planned to rewrite the entity
	// types of.
	ResourcesRestamped int `json:"resourcesRestamped"`
	// ResourcesReanchored How many resources it planned to derive the anchored
	// text of again.
	ResourcesReanchored int `json:"resourcesReanchored"`
	// ResourceVectorsDeleted How many resources it planned to take out of the
	// index.
	ResourceVectorsDeleted int `json:"resourceVectorsDeleted"`
	// AnnotationsEmbedded How many annotations it planned to index.
	AnnotationsEmbedded int `json:"annotationsEmbedded"`
	// AnnotationsRestamped How many annotations it planned to rewrite the entity
	// types of.
	AnnotationsRestamped int `json:"annotationsRestamped"`
	// AnnotationVectorsDeleted How many annotations it planned to take out of
	// the index.
	AnnotationVectorsDeleted int `json:"annotationVectorsDeleted"`
	// ResourcesEligible How many resources of the catalog have text.
	ResourcesEligible int `json:"resourcesEligible"`
	// ResourcesIndexed How many resources have points when it ends.
	ResourcesIndexed int `json:"resourcesIndexed"`
}

type SpecificResource struct {
	Type SpecificResourceType `json:"type"`
	// Source The id of the resource this body leads to
	Source ResourceId `json:"source"`
	// Purpose Why this body is included
	Purpose *BodyPurpose `json:"purpose,omitempty"`
}

func (SpecificResource) memberOfAnnotationBody() {}
func (SpecificResource) told() (string, string)  { return "type", "SpecificResource" }

type SpecificResourceType string

// The values of SpecificResourceType.
const (
	SpecificResourceTypeSpecificResource SpecificResourceType = "SpecificResource"
)

// Valid is whether e is one of SpecificResourceType's values.
func (e SpecificResourceType) Valid() bool {
	switch e {
	case SpecificResourceTypeSpecificResource:
		return true
	}
	return false
}

// StackApiVersion The group and version of Xynolog's kinds. The group names
// who defines a kind, under the domain the knowledge bases' DIDs use; which
// knowledge base a document is about is said inside it.
type StackApiVersion string

// The values of StackApiVersion.
const (
	StackApiVersionXynologOrgV1alpha1 StackApiVersion = "xynolog.org/v1alpha1"
)

// Valid is whether e is one of StackApiVersion's values.
func (e StackApiVersion) Valid() bool {
	switch e {
	case StackApiVersionXynologOrgV1alpha1:
		return true
	}
	return false
}

// StackKnowledgeBase A knowledge base's record and the services that keep it:
// the Gateway, the Dispatcher, the Archivist, and the broker between them.
// They live and die with the knowledge base.
type StackKnowledgeBase struct {
	ApiVersion StackApiVersion        `json:"apiVersion"`
	Kind       StackKnowledgeBaseKind `json:"kind"`
	Metadata   Metadata               `json:"metadata"`
	// Spec The knowledge base's services, and how each runs.
	Spec StackKnowledgeBaseSpec `json:"spec"`
}

type StackKnowledgeBaseKind string

// The values of StackKnowledgeBaseKind.
const (
	StackKnowledgeBaseKindKnowledgeBase StackKnowledgeBaseKind = "KnowledgeBase"
)

// Valid is whether e is one of StackKnowledgeBaseKind's values.
func (e StackKnowledgeBaseKind) Valid() bool {
	switch e {
	case StackKnowledgeBaseKindKnowledgeBase:
		return true
	}
	return false
}

// StackKnowledgeBaseSpec The knowledge base's services, and how each runs.
type StackKnowledgeBaseSpec struct {
	LogLevel LogLevel `json:"logLevel"`
	// Gateway The Gateway: where every client and every service reaches the
	// knowledge base.
	Gateway StackKnowledgeBaseSpecGateway `json:"gateway"`
	// Dispatcher The Dispatcher: it hands queued jobs to workers.
	Dispatcher StackKnowledgeBaseSpecDispatcher `json:"dispatcher"`
	// Archivist The Archivist: it keeps the knowledge base's record in its
	// working tree.
	Archivist StackKnowledgeBaseSpecArchivist `json:"archivist"`
	// Messaging The broker the job queue and the signal plane share: the
	// launcher's, run from `image`, or somebody else's, at `external`.
	Messaging StackKnowledgeBaseSpecMessaging `json:"messaging"`
	// Issuer The issuer the knowledge base trusts: the one the launcher runs for
	// the knowledge bases on a machine, at `shared`, with the knowledge base's
	// own realm in it, or somebody else's, at `external`.
	Issuer StackKnowledgeBaseSpecIssuer `json:"issuer"`
}

// StackKnowledgeBaseSpecArchivist The Archivist: it keeps the knowledge
// base's record in its working tree.
type StackKnowledgeBaseSpecArchivist struct {
	Image     Image     `json:"image"`
	Resources Resources `json:"resources"`
	// Address Where the stack's services reach the Archivist, when that is
	// somewhere the launcher cannot see. Absent, they reach it where the
	// launcher places it.
	Address *HostPort `json:"address,omitempty"`
}

// StackKnowledgeBaseSpecDispatcher The Dispatcher: it hands queued jobs to
// workers.
type StackKnowledgeBaseSpecDispatcher struct {
	Image     Image     `json:"image"`
	Resources Resources `json:"resources"`
}

// StackKnowledgeBaseSpecGateway The Gateway: where every client and every
// service reaches the knowledge base.
type StackKnowledgeBaseSpecGateway struct {
	Image     Image     `json:"image"`
	Resources Resources `json:"resources"`
	// Port The port the Gateway is published on.
	Port int `json:"port"`
	// PublicURL Where clients reach the Gateway: the server its API document
	// names. A service of the stack reaches it where the launcher places it, on
	// `port`.
	PublicURL string `json:"publicURL"`
}

// StackKnowledgeBaseSpecIssuer The issuer the knowledge base trusts: the one
// the launcher runs for the knowledge bases on a machine, at `shared`, with
// the knowledge base's own realm in it, or somebody else's, at `external`.
type StackKnowledgeBaseSpecIssuer struct {
	// Shared The issuer the launcher runs for the knowledge bases on a machine
	// (the state home's Issuer document). The launcher creates the knowledge
	// base's realm in it.
	Shared *StackKnowledgeBaseSpecIssuerShared `json:"shared,omitempty"`
	// External An issuer somebody else runs.
	External *StackKnowledgeBaseSpecIssuerExternal `json:"external,omitempty"`
	// SubjectClaim The claim a person's DID is built from: did:web:<site
	// domain>:users:<its value>.
	SubjectClaim string `json:"subjectClaim"`
}

// StackKnowledgeBaseSpecIssuerExternal An issuer somebody else runs.
type StackKnowledgeBaseSpecIssuerExternal struct {
	// Type `oidc`, or `keycloak`.
	Type string `json:"type"`
	// Url The URL in its tokens' `iss` claim.
	Url string `json:"url"`
}

// StackKnowledgeBaseSpecIssuerShared The issuer the launcher runs for the
// knowledge bases on a machine (the state home's Issuer document). The
// launcher creates the knowledge base's realm in it.
type StackKnowledgeBaseSpecIssuerShared struct {
	// AccessTokenLifespan How long a token the realm mints stays valid, in
	// seconds: the window in which a disabled account can still act.
	AccessTokenLifespan int `json:"accessTokenLifespan"`
}

// StackKnowledgeBaseSpecMessaging The broker the job queue and the signal
// plane share: the launcher's, run from `image`, or somebody else's, at
// `external`.
type StackKnowledgeBaseSpecMessaging struct {
	// Jobs The Dispatcher's queue.
	Jobs StackKnowledgeBaseSpecMessagingJobs `json:"jobs"`
	// Signal The Gateway's signal plane.
	Signal    StackKnowledgeBaseSpecMessagingSignal `json:"signal"`
	Image     *Image                                `json:"image,omitempty"`
	Resources *Resources                            `json:"resources,omitempty"`
	// External A broker somebody else runs, serving this knowledge base alone: a
	// second knowledge base on it would share the job queue and, on a `nats`
	// signal plane, the frames and the gateway's record of pending replies. The
	// launcher refuses to start a knowledge base whose `servers` another
	// knowledge base on its machine names.
	External *StackKnowledgeBaseSpecMessagingExternal `json:"external,omitempty"`
}

// StackKnowledgeBaseSpecMessagingExternal A broker somebody else runs,
// serving this knowledge base alone: a second knowledge base on it would
// share the job queue and, on a `nats` signal plane, the frames and the
// gateway's record of pending replies. The launcher refuses to start a
// knowledge base whose `servers` another knowledge base on its machine names.
type StackKnowledgeBaseSpecMessagingExternal struct {
	// Servers Where it listens: `host:port`.
	Servers  string    `json:"servers"`
	User     SecretRef `json:"user"`
	Password SecretRef `json:"password"`
}

// StackKnowledgeBaseSpecMessagingJobs The Dispatcher's queue.
type StackKnowledgeBaseSpecMessagingJobs struct {
	// Type The queue's driver: `jetstream`.
	Type string `json:"type"`
}

// StackKnowledgeBaseSpecMessagingSignal The Gateway's signal plane.
type StackKnowledgeBaseSpecMessagingSignal struct {
	// Type `in-process`, one Gateway on its own fabric, or `nats`, on the
	// broker.
	Type string `json:"type"`
}

// StackStartParams stack.start's params: what xynolog start takes, but its
// help and its narration switches.
type StackStartParams struct {
	// ApiVersion The version of the control API the request is written to.
	ApiVersion ApiVersion `json:"apiVersion"`
	// Target Which knowledge base's stack. Absent: the one the command line
	// chooses, standing where the control server was started.
	Target *Target `json:"target,omitempty"`
	// Runtime The container runtime to ask, as --runtime names it. Absent: the
	// one the stack's record names, else every installed one.
	Runtime *Runtime `json:"runtime,omitempty"`
	// Config The Inference document to run, as --config names it. Absent: the
	// knowledge base's recorded preference, else the default.
	Config *string `json:"config,omitempty"`
	// Service Just this one service, as --service names it.
	Service *string `json:"service,omitempty"`
	// Group Just this one group of services, as --group names it.
	Group *ServiceGroup `json:"group,omitempty"`
	// CodespaceName For a codespace target: which of the repository's
	// codespaces, as --codespace names it.
	CodespaceName *string `json:"codespaceName,omitempty"`
	// Machine For a codespace target being created: its VM class, as --machine
	// names it.
	Machine *string `json:"machine,omitempty"`
	// IdleTimeout For a codespace target being created: inactivity before it
	// stops, as --idle-timeout takes it.
	IdleTimeout *string `json:"idleTimeout,omitempty"`
	// RetentionPeriod For a codespace target being created: how long a stopped
	// codespace is kept, as --retention-period takes it.
	RetentionPeriod *string `json:"retentionPeriod,omitempty"`
	// Observe Whether to start the telemetry backends, Jaeger and Prometheus.
	// false is --no-observe. Absent: true.
	Observe *bool `json:"observe,omitempty"`
	// OllamaCache Where a started Ollama keeps its models, as --ollama-cache
	// names it. Absent: the host's ~/.ollama when there is one, else the named
	// volume — what the command line's prompt does when nobody answers it.
	OllamaCache *StackStartParamsOllamaCache `json:"ollamaCache,omitempty"`
	// DryRun Whether to run nothing, and report each runtime command a start
	// would run as a command progress line.
	DryRun *bool `json:"dryRun,omitempty"`
}

// StackStartParamsOllamaCache Where a started Ollama keeps its models, as
// --ollama-cache names it. Absent: the host's ~/.ollama when there is one,
// else the named volume — what the command line's prompt does when nobody
// answers it.
type StackStartParamsOllamaCache string

// The values of StackStartParamsOllamaCache.
const (
	StackStartParamsOllamaCacheHost   StackStartParamsOllamaCache = "host"
	StackStartParamsOllamaCacheVolume StackStartParamsOllamaCache = "volume"
)

// Valid is whether e is one of StackStartParamsOllamaCache's values.
func (e StackStartParamsOllamaCache) Valid() bool {
	switch e {
	case StackStartParamsOllamaCacheHost, StackStartParamsOllamaCacheVolume:
		return true
	}
	return false
}

// StackStartResult A start that ran to its end: the stack as status reads it
// afterwards. A start that failed is an error, whatever it started before it
// did; its progress lines say what it did.
type StackStartResult struct {
	// DryRun Whether the start ran nothing.
	DryRun bool `json:"dryRun"`
	// KnowledgeBase The started knowledge base's stack, as status reads it after
	// the start. Absent from a dry run, and from a start of services no
	// knowledge base owns.
	KnowledgeBase *KnowledgeBaseStatus `json:"knowledgeBase,omitempty"`
	// Shared The shared services, as status reads them after the start. Absent
	// from a dry run.
	Shared *[]ServiceStatus `json:"shared,omitempty"`
}

// StackStopParams stack.stop's params: what xynolog stop takes, but its help.
type StackStopParams struct {
	// ApiVersion The version of the control API the request is written to.
	ApiVersion ApiVersion `json:"apiVersion"`
	// Target Which knowledge base's stack. Absent: the one the command line
	// chooses, standing where the control server was started.
	Target *Target `json:"target,omitempty"`
	// Runtime The container runtime to ask, as --runtime names it. Absent: the
	// one the stack's record names, else every installed one.
	Runtime *Runtime `json:"runtime,omitempty"`
	// Service Just this one service, as --service names it.
	Service *string `json:"service,omitempty"`
	// Group Just this one group of services, as --group names it.
	Group *ServiceGroup `json:"group,omitempty"`
	// Delete For a codespace target: destroy the codespace, state and all, and
	// forget its record. The command line's --delete. Refused without
	// deleteConfirmed.
	Delete *bool `json:"delete,omitempty"`
	// DeleteConfirmed That the person confirmed the deletion: delete is refused
	// with control.confirmation-required without it.
	DeleteConfirmed *bool `json:"deleteConfirmed,omitempty"`
	// DryRun Whether to stop nothing, and report each runtime command a stop
	// would run as a command progress line.
	DryRun *bool `json:"dryRun,omitempty"`
}

// StackStopResult A stop that ran to its end: what status reads afterwards. A
// stop that failed is an error.
type StackStopResult struct {
	// DryRun Whether the stop stopped nothing.
	DryRun bool `json:"dryRun"`
	// KnowledgeBases The knowledge bases still recorded, as status reads them
	// after the stop. Absent from a dry run.
	KnowledgeBases *[]KnowledgeBaseStatus `json:"knowledgeBases,omitempty"`
	// Shared The shared services, as status reads them after the stop. Absent
	// from a dry run.
	Shared *[]ServiceStatus `json:"shared,omitempty"`
}

type StatusResponse struct {
	Status          string                 `json:"status"`
	Version         string                 `json:"version"`
	Features        StatusResponseFeatures `json:"features"`
	Message         string                 `json:"message"`
	AuthenticatedAs *string                `json:"authenticatedAs,omitempty"`
}

type StatusResponseFeatures struct {
	SemanticContent string `json:"semanticContent"`
	Collaboration   string `json:"collaboration"`
}

// StatusSnapshotParams status.snapshot's params.
type StatusSnapshotParams struct {
	// ApiVersion The version of the control API the request is written to.
	ApiVersion ApiVersion `json:"apiVersion"`
	// Target Which knowledge base's stack. Absent: the one the command line
	// chooses, standing where the control server was started.
	Target *Target `json:"target,omitempty"`
	// Runtime The container runtime to ask, as --runtime names it. Absent: the
	// one the stack's record names, else every installed one.
	Runtime *Runtime `json:"runtime,omitempty"`
}

// StatusSnapshotResult What xynolog status reports: each knowledge base with
// its own services, and each service the knowledge bases share, once, with
// the knowledge bases it serves.
type StatusSnapshotResult struct {
	// KnowledgeBases The target's stack; with no target, the stack of the
	// knowledge base the control server stands in, else every recorded one.
	KnowledgeBases []KnowledgeBaseStatus `json:"knowledgeBases"`
	// Shared The services every knowledge base shares, group by group, and those
	// the machine serves for the knowledge bases that name them.
	Shared []ServiceStatus `json:"shared"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v StatusSnapshotResult) MarshalJSON() ([]byte, error) {
	type written StatusSnapshotResult
	v.KnowledgeBases = listOf(v.KnowledgeBases)
	v.Shared = listOf(v.Shared)
	return json.Marshal(written(v))
}

// StorageUriEntry One entry of the storage-uri index: the file
// `projections/storage-uri/<ab>/<cd>/<sha256 of the URI, hex>.json` under the
// state directory. It answers which resource's content is at a place in the
// working tree. Written as JSON indented by two spaces, `uri` first.
type StorageUriEntry struct {
	// Uri The `file://` URI of a place in the working tree, relative to the
	// knowledge base's root.
	Uri        string     `json:"uri"`
	ResourceId ResourceId `json:"resourceId"`
}

// StoredEventResponse A persisted domain event with metadata. Flat shape —
// event fields and metadata are peers.
type StoredEventResponse struct {
	// Id Unique event ID (UUID)
	Id string `json:"id"`
	// Type Event type (flow verb name, e.g. mark:added)
	Type string `json:"type"`
	// Timestamp When the event occurred
	Timestamp string `json:"timestamp"`
	// UserId DID of the user who triggered the event
	UserId UserId `json:"userId"`
	// ResourceId Resource this event affects (absent for system events)
	ResourceId *ResourceId `json:"resourceId,omitempty"`
	// Version Event schema version
	Version int `json:"version"`
	// Payload Event-type-specific payload
	Payload  map[string]any `json:"payload"`
	Metadata EventMetadata  `json:"metadata"`
}

// StoredSession What is kept of a sign-in: the tokens an issuer issued, the
// client they were issued to, and the issuer's endpoints a renewal and a
// sign-out need, learned once at sign-in so no session asks again. TOKENS,
// never a password. A stored value that lacks a member it requires is no
// session.
type StoredSession struct {
	// Access The access token: short-lived, sent as a Bearer token.
	Access string `json:"access"`
	// Refresh The refresh token: what renews the access token at the issuer
	// without another sign-in.
	Refresh string `json:"refresh"`
	// ClientId The client the tokens were issued to, which a renewal and a
	// revocation name.
	ClientId string `json:"clientId"`
	// TokenEndpoint The issuer's token endpoint, where the refresh grant is
	// made.
	TokenEndpoint string `json:"tokenEndpoint"`
	// RevocationEndpoint The issuer's revocation endpoint (RFC 7009), where a
	// sign-out tells it to forget the refresh token. Absent when the issuer has
	// none.
	RevocationEndpoint *string `json:"revocationEndpoint,omitempty"`
	// PersonKey Who the gateway said the sign-in's person is, as the key their
	// caches and stream position are kept under (`lastEventIdKeyPrefix`), never
	// the did itself. Written once the gateway names the person, on the sign-in
	// whose token it was asked about; a renewal keeps it, a new sign-in starts
	// without it, and forgetting the sign-in, however it is forgotten, reads it
	// first to delete what is kept under it. Absent for a sign-in whose gateway
	// has not yet named its person.
	PersonKey *string `json:"personKey,omitempty"`
}

// SupportedMediaType Base MIME types (no parameters) admitted by Xynolog.
// Membership is the create/yield gate — every member is storable, nameable,
// and uploadable. What more the system can do with a type (render, annotate,
// extract text, author) is curated per type in @xynolog/core's media-type
// registry, which is keyed by this enum.
type SupportedMediaType string

// The values of SupportedMediaType.
const (
	SupportedMediaTypeTextPlain                                                            SupportedMediaType = "text/plain"
	SupportedMediaTypeTextMarkdown                                                         SupportedMediaType = "text/markdown"
	SupportedMediaTypeTextHtml                                                             SupportedMediaType = "text/html"
	SupportedMediaTypeTextCss                                                              SupportedMediaType = "text/css"
	SupportedMediaTypeTextCsv                                                              SupportedMediaType = "text/csv"
	SupportedMediaTypeTextXml                                                              SupportedMediaType = "text/xml"
	SupportedMediaTypeApplicationJson                                                      SupportedMediaType = "application/json"
	SupportedMediaTypeApplicationXml                                                       SupportedMediaType = "application/xml"
	SupportedMediaTypeApplicationYaml                                                      SupportedMediaType = "application/yaml"
	SupportedMediaTypeApplicationXYaml                                                     SupportedMediaType = "application/x-yaml"
	SupportedMediaTypeApplicationPdf                                                       SupportedMediaType = "application/pdf"
	SupportedMediaTypeApplicationMsword                                                    SupportedMediaType = "application/msword"
	SupportedMediaTypeApplicationVndOpenxmlformatsOfficedocumentWordprocessingmlDocument   SupportedMediaType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
	SupportedMediaTypeApplicationVndMsExcel                                                SupportedMediaType = "application/vnd.ms-excel"
	SupportedMediaTypeApplicationVndOpenxmlformatsOfficedocumentSpreadsheetmlSheet         SupportedMediaType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
	SupportedMediaTypeApplicationVndMsPowerpoint                                           SupportedMediaType = "application/vnd.ms-powerpoint"
	SupportedMediaTypeApplicationVndOpenxmlformatsOfficedocumentPresentationmlPresentation SupportedMediaType = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
	SupportedMediaTypeApplicationZip                                                       SupportedMediaType = "application/zip"
	SupportedMediaTypeApplicationGzip                                                      SupportedMediaType = "application/gzip"
	SupportedMediaTypeApplicationXTar                                                      SupportedMediaType = "application/x-tar"
	SupportedMediaTypeApplicationX7zCompressed                                             SupportedMediaType = "application/x-7z-compressed"
	SupportedMediaTypeApplicationOctetStream                                               SupportedMediaType = "application/octet-stream"
	SupportedMediaTypeApplicationWasm                                                      SupportedMediaType = "application/wasm"
	SupportedMediaTypeImagePng                                                             SupportedMediaType = "image/png"
	SupportedMediaTypeImageJpeg                                                            SupportedMediaType = "image/jpeg"
	SupportedMediaTypeImageGif                                                             SupportedMediaType = "image/gif"
	SupportedMediaTypeImageWebp                                                            SupportedMediaType = "image/webp"
	SupportedMediaTypeImageSvgPlusXml                                                      SupportedMediaType = "image/svg+xml"
	SupportedMediaTypeImageBmp                                                             SupportedMediaType = "image/bmp"
	SupportedMediaTypeImageTiff                                                            SupportedMediaType = "image/tiff"
	SupportedMediaTypeImageXIcon                                                           SupportedMediaType = "image/x-icon"
	SupportedMediaTypeVideoMp4                                                             SupportedMediaType = "video/mp4"
	SupportedMediaTypeVideoMpeg                                                            SupportedMediaType = "video/mpeg"
	SupportedMediaTypeVideoWebm                                                            SupportedMediaType = "video/webm"
	SupportedMediaTypeVideoOgg                                                             SupportedMediaType = "video/ogg"
	SupportedMediaTypeVideoQuicktime                                                       SupportedMediaType = "video/quicktime"
	SupportedMediaTypeVideoXMsvideo                                                        SupportedMediaType = "video/x-msvideo"
	SupportedMediaTypeAudioMpeg                                                            SupportedMediaType = "audio/mpeg"
	SupportedMediaTypeAudioWav                                                             SupportedMediaType = "audio/wav"
	SupportedMediaTypeAudioOgg                                                             SupportedMediaType = "audio/ogg"
	SupportedMediaTypeAudioWebm                                                            SupportedMediaType = "audio/webm"
	SupportedMediaTypeAudioAac                                                             SupportedMediaType = "audio/aac"
	SupportedMediaTypeAudioFlac                                                            SupportedMediaType = "audio/flac"
	SupportedMediaTypeTextJavascript                                                       SupportedMediaType = "text/javascript"
	SupportedMediaTypeApplicationJavascript                                                SupportedMediaType = "application/javascript"
	SupportedMediaTypeTextXTypescript                                                      SupportedMediaType = "text/x-typescript"
	SupportedMediaTypeApplicationTypescript                                                SupportedMediaType = "application/typescript"
	SupportedMediaTypeTextXPython                                                          SupportedMediaType = "text/x-python"
	SupportedMediaTypeTextXJava                                                            SupportedMediaType = "text/x-java"
	SupportedMediaTypeTextXC                                                               SupportedMediaType = "text/x-c"
	SupportedMediaTypeTextXCPlusPlus                                                       SupportedMediaType = "text/x-c++"
	SupportedMediaTypeTextXCsharp                                                          SupportedMediaType = "text/x-csharp"
	SupportedMediaTypeTextXGo                                                              SupportedMediaType = "text/x-go"
	SupportedMediaTypeTextXRust                                                            SupportedMediaType = "text/x-rust"
	SupportedMediaTypeTextXRuby                                                            SupportedMediaType = "text/x-ruby"
	SupportedMediaTypeTextXPhp                                                             SupportedMediaType = "text/x-php"
	SupportedMediaTypeTextXSwift                                                           SupportedMediaType = "text/x-swift"
	SupportedMediaTypeTextXKotlin                                                          SupportedMediaType = "text/x-kotlin"
	SupportedMediaTypeTextXShell                                                           SupportedMediaType = "text/x-shell"
	SupportedMediaTypeFontWoff                                                             SupportedMediaType = "font/woff"
	SupportedMediaTypeFontWoff2                                                            SupportedMediaType = "font/woff2"
	SupportedMediaTypeFontTtf                                                              SupportedMediaType = "font/ttf"
	SupportedMediaTypeFontOtf                                                              SupportedMediaType = "font/otf"
)

// Valid is whether e is one of SupportedMediaType's values.
func (e SupportedMediaType) Valid() bool {
	switch e {
	case SupportedMediaTypeTextPlain, SupportedMediaTypeTextMarkdown, SupportedMediaTypeTextHtml, SupportedMediaTypeTextCss, SupportedMediaTypeTextCsv, SupportedMediaTypeTextXml, SupportedMediaTypeApplicationJson, SupportedMediaTypeApplicationXml, SupportedMediaTypeApplicationYaml, SupportedMediaTypeApplicationXYaml, SupportedMediaTypeApplicationPdf, SupportedMediaTypeApplicationMsword, SupportedMediaTypeApplicationVndOpenxmlformatsOfficedocumentWordprocessingmlDocument, SupportedMediaTypeApplicationVndMsExcel, SupportedMediaTypeApplicationVndOpenxmlformatsOfficedocumentSpreadsheetmlSheet, SupportedMediaTypeApplicationVndMsPowerpoint, SupportedMediaTypeApplicationVndOpenxmlformatsOfficedocumentPresentationmlPresentation, SupportedMediaTypeApplicationZip, SupportedMediaTypeApplicationGzip, SupportedMediaTypeApplicationXTar, SupportedMediaTypeApplicationX7zCompressed, SupportedMediaTypeApplicationOctetStream, SupportedMediaTypeApplicationWasm, SupportedMediaTypeImagePng, SupportedMediaTypeImageJpeg, SupportedMediaTypeImageGif, SupportedMediaTypeImageWebp, SupportedMediaTypeImageSvgPlusXml, SupportedMediaTypeImageBmp, SupportedMediaTypeImageTiff, SupportedMediaTypeImageXIcon, SupportedMediaTypeVideoMp4, SupportedMediaTypeVideoMpeg, SupportedMediaTypeVideoWebm, SupportedMediaTypeVideoOgg, SupportedMediaTypeVideoQuicktime, SupportedMediaTypeVideoXMsvideo, SupportedMediaTypeAudioMpeg, SupportedMediaTypeAudioWav, SupportedMediaTypeAudioOgg, SupportedMediaTypeAudioWebm, SupportedMediaTypeAudioAac, SupportedMediaTypeAudioFlac, SupportedMediaTypeTextJavascript, SupportedMediaTypeApplicationJavascript, SupportedMediaTypeTextXTypescript, SupportedMediaTypeApplicationTypescript, SupportedMediaTypeTextXPython, SupportedMediaTypeTextXJava, SupportedMediaTypeTextXC, SupportedMediaTypeTextXCPlusPlus, SupportedMediaTypeTextXCsharp, SupportedMediaTypeTextXGo, SupportedMediaTypeTextXRust, SupportedMediaTypeTextXRuby, SupportedMediaTypeTextXPhp, SupportedMediaTypeTextXSwift, SupportedMediaTypeTextXKotlin, SupportedMediaTypeTextXShell, SupportedMediaTypeFontWoff, SupportedMediaTypeFontWoff2, SupportedMediaTypeFontTtf, SupportedMediaTypeFontOtf:
		return true
	}
	return false
}

type SvgSelector struct {
	Type SvgSelectorType `json:"type"`
	// Value SVG markup defining the region (must include xmlns attribute)
	Value string `json:"value"`
}

func (SvgSelector) memberOfSelector()      {}
func (SvgSelector) told() (string, string) { return "type", "SvgSelector" }

type SvgSelectorType string

// The values of SvgSelectorType.
const (
	SvgSelectorTypeSvgSelector SvgSelectorType = "SvgSelector"
)

// Valid is whether e is one of SvgSelectorType's values.
func (e SvgSelectorType) Valid() bool {
	switch e {
	case SvgSelectorTypeSvgSelector:
		return true
	}
	return false
}

// TabCheck What checking one open resource against its knowledge base
// concluded. `gone` is the only verdict that closes it, and it means the
// knowledge base said the resource does not exist, not that the check failed:
// a failed transport, a timeout and a peer that is down are each `unknown`,
// and an unknown resource stays open.
type TabCheck struct {
	union[TabCheckMember]
}

// TabCheckMember is a member of TabCheck: TabCheckGone, TabCheckReady,
// TabCheckUnknown.
type TabCheckMember interface {
	memberOfTabCheck()
}

// Discriminator is the `verdict` this value states.
func (u TabCheck) Discriminator() (string, error) { return u.stated("verdict") }

// Member is the member this value is: the one whose schema admits it.
func (u TabCheck) Member() (any, error) { return u.member("TabCheck", tabCheckMembers) }

// tabCheckMembers is what each member of TabCheck admits, and how a value of
// it is read.
var tabCheckMembers = []unionMember{
	{"TabCheckGone", readAs[TabCheckGone], []signature{{kind: objectKind, required: []string{"verdict"}, allowed: []string{"verdict"}, fixed: []fixedValues{{"verdict", []any{"gone"}}}}}},
	{"TabCheckReady", readAs[TabCheckReady], []signature{{kind: objectKind, required: []string{"verdict", "name"}, allowed: []string{"verdict", "name", "mediaType"}, fixed: []fixedValues{{"verdict", []any{"ready"}}}}}},
	{"TabCheckUnknown", readAs[TabCheckUnknown], []signature{{kind: objectKind, required: []string{"verdict"}, allowed: []string{"verdict"}, fixed: []fixedValues{{"verdict", []any{"unknown"}}}}}},
}

// TabCheckGone The knowledge base said the resource does not exist.
type TabCheckGone struct {
	// Verdict What checking an open resource against its knowledge base
	// concluded.
	Verdict TabCheckGoneVerdict `json:"verdict"`
}

func (TabCheckGone) memberOfTabCheck()      {}
func (TabCheckGone) told() (string, string) { return "verdict", "gone" }

// TabCheckGoneVerdict What checking an open resource against its knowledge
// base concluded.
type TabCheckGoneVerdict string

// The values of TabCheckGoneVerdict.
const (
	TabCheckGoneVerdictGone TabCheckGoneVerdict = "gone"
)

// Valid is whether e is one of TabCheckGoneVerdict's values.
func (e TabCheckGoneVerdict) Valid() bool {
	switch e {
	case TabCheckGoneVerdictGone:
		return true
	}
	return false
}

// TabCheckReady The knowledge base has the resource, and said what it is
// called now.
type TabCheckReady struct {
	// Verdict What checking an open resource against its knowledge base
	// concluded.
	Verdict TabCheckReadyVerdict `json:"verdict"`
	// Name The name the knowledge base gave the resource.
	Name string `json:"name"`
	// MediaType The media type of its primary representation. Absent when it
	// said none.
	MediaType *string `json:"mediaType,omitempty"`
}

func (TabCheckReady) memberOfTabCheck()      {}
func (TabCheckReady) told() (string, string) { return "verdict", "ready" }

// TabCheckReadyVerdict What checking an open resource against its knowledge
// base concluded.
type TabCheckReadyVerdict string

// The values of TabCheckReadyVerdict.
const (
	TabCheckReadyVerdictReady TabCheckReadyVerdict = "ready"
)

// Valid is whether e is one of TabCheckReadyVerdict's values.
func (e TabCheckReadyVerdict) Valid() bool {
	switch e {
	case TabCheckReadyVerdictReady:
		return true
	}
	return false
}

// TabCheckUnknown The check found out nothing.
type TabCheckUnknown struct {
	// Verdict What checking an open resource against its knowledge base
	// concluded.
	Verdict TabCheckUnknownVerdict `json:"verdict"`
}

func (TabCheckUnknown) memberOfTabCheck()      {}
func (TabCheckUnknown) told() (string, string) { return "verdict", "unknown" }

// TabCheckUnknownVerdict What checking an open resource against its knowledge
// base concluded.
type TabCheckUnknownVerdict string

// The values of TabCheckUnknownVerdict.
const (
	TabCheckUnknownVerdictUnknown TabCheckUnknownVerdict = "unknown"
)

// Valid is whether e is one of TabCheckUnknownVerdict's values.
func (e TabCheckUnknownVerdict) Valid() bool {
	switch e {
	case TabCheckUnknownVerdictUnknown:
		return true
	}
	return false
}

// TabVerdict What checking an open resource against its knowledge base
// concluded.
type TabVerdict string

// The values of TabVerdict.
const (
	TabVerdictGone    TabVerdict = "gone"
	TabVerdictReady   TabVerdict = "ready"
	TabVerdictUnknown TabVerdict = "unknown"
)

// Valid is whether e is one of TabVerdict's values.
func (e TabVerdict) Valid() bool {
	switch e {
	case TabVerdictGone, TabVerdictReady, TabVerdictUnknown:
		return true
	}
	return false
}

// TagCategory A single category within a tag schema (e.g. 'Issue' in IRAC,
// 'distinguished' in legal-citation-treatment). Each category carries
// methodology-bound semantics: a name, a description, and examples used in
// the LLM prompt.
type TagCategory struct {
	Name        string   `json:"name"`
	Description string   `json:"description"`
	Examples    []string `json:"examples"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v TagCategory) MarshalJSON() ([]byte, error) {
	type written TagCategory
	v.Examples = listOf(v.Examples)
	return json.Marshal(written(v))
}

// TagSchema A structural-analysis schema (e.g. legal-irac, scientific-imrad,
// argument-toulmin). Defines a methodology framework as an id, name,
// description, domain hint, and an ordered list of categories. KBs and their
// skills register schemas with the runtime registry via
// `frame.addTagSchema(...)` at session start.
type TagSchema struct {
	Id          string `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	// Domain Free-form domain hint (e.g. 'legal', 'scientific', 'general'). Used
	// in the LLM prompt to tune the model's analysis voice. KB authors choose.
	Domain string        `json:"domain"`
	Tags   []TagCategory `json:"tags"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v TagSchema) MarshalJSON() ([]byte, error) {
	type written TagSchema
	v.Tags = listOf(v.Tags)
	return json.Marshal(written(v))
}

// TagSchemaAddedPayload Payload for frame:tag-schema-added domain event
// (system-level, no resourceId — fan-out is global to the KB).
type TagSchemaAddedPayload struct {
	Schema TagSchema `json:"schema"`
}

// TagSchemasProjection The knowledge base's tag schemas: the file
// `projections/__system__/tagschemas.json` under the state directory, the sum
// of the `frame:tag-schema-added` events. Written as JSON indented by two
// spaces.
type TagSchemasProjection struct {
	// TagSchemas Every tag schema added, sorted by `id`. A schema added again
	// under an `id` replaces the one held.
	TagSchemas []TagSchema `json:"tagSchemas"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v TagSchemasProjection) MarshalJSON() ([]byte, error) {
	type written TagSchemasProjection
	v.TagSchemas = listOf(v.TagSchemas)
	return json.Marshal(written(v))
}

// TaggingJobParams What a tagging job takes: passages of the resource are
// marked with categories of one tag schema.
type TaggingJobParams struct {
	Motivation TaggingJobParamsMotivation `json:"motivation"`
	// SchemaId The tag schema to tag by. It is one the knowledge base registers.
	SchemaId string `json:"schemaId"`
	// Categories The categories of that schema to tag with.
	Categories []string `json:"categories"`
	// Language The language the annotations' own text is written in. BCP 47.
	Language *string `json:"language,omitempty"`
	// SourceLanguage The language of the resource being read. BCP 47.
	SourceLanguage *string `json:"sourceLanguage,omitempty"`
}

func (TaggingJobParams) memberOfMarkJobParams() {}
func (TaggingJobParams) told() (string, string) { return "motivation", "tagging" }

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v TaggingJobParams) MarshalJSON() ([]byte, error) {
	type written TaggingJobParams
	v.Categories = listOf(v.Categories)
	return json.Marshal(written(v))
}

type TaggingJobParamsMotivation string

// The values of TaggingJobParamsMotivation.
const (
	TaggingJobParamsMotivationTagging TaggingJobParamsMotivation = "tagging"
)

// Valid is whether e is one of TaggingJobParamsMotivation's values.
func (e TaggingJobParamsMotivation) Valid() bool {
	switch e {
	case TaggingJobParamsMotivationTagging:
		return true
	}
	return false
}

// Target Which knowledge base an operation acts on: a local clone's stack, or
// a codespace's. The launcher resolves it as the command line resolves --root
// and --repo, and refuses a choice it would have to guess.
type Target struct {
	// Kind Where the stack runs: on this machine (local), or on a GitHub
	// codespace whose knowledge base is forwarded here (codespace).
	Kind TargetKind `json:"kind"`
	// Root For a local target: the knowledge base's clone, by path or by the
	// basename of a registered root, as --root takes it. Absent: the local stack
	// the command line chooses with --runtime, standing where the control server
	// was started.
	Root *string `json:"root,omitempty"`
	// Repo For a codespace target: the GitHub repository, as --repo takes it.
	Repo *string `json:"repo,omitempty"`
}

// TargetKind Where the stack runs: on this machine (local), or on a GitHub
// codespace whose knowledge base is forwarded here (codespace).
type TargetKind string

// The values of TargetKind.
const (
	TargetKindLocal     TargetKind = "local"
	TargetKindCodespace TargetKind = "codespace"
)

// Valid is whether e is one of TargetKind's values.
func (e TargetKind) Valid() bool {
	switch e {
	case TargetKindLocal, TargetKindCodespace:
		return true
	}
	return false
}

type TextPositionSelector struct {
	Type TextPositionSelectorType `json:"type"`
	// Start Offset into the resource's decoded text, exactly as decoded, in
	// Unicode code points from its start: where the selected text starts.
	Start int `json:"start"`
	// End Offset into the resource's decoded text, exactly as decoded, in
	// Unicode code points from its start: just past where the selected text
	// ends.
	End int `json:"end"`
}

func (TextPositionSelector) memberOfSelector()      {}
func (TextPositionSelector) told() (string, string) { return "type", "TextPositionSelector" }

type TextPositionSelectorType string

// The values of TextPositionSelectorType.
const (
	TextPositionSelectorTypeTextPositionSelector TextPositionSelectorType = "TextPositionSelector"
)

// Valid is whether e is one of TextPositionSelectorType's values.
func (e TextPositionSelectorType) Valid() bool {
	switch e {
	case TextPositionSelectorTypeTextPositionSelector:
		return true
	}
	return false
}

type TextQuoteSelector struct {
	Type   TextQuoteSelectorType `json:"type"`
	Exact  string                `json:"exact"`
	Prefix *string               `json:"prefix,omitempty"`
	Suffix *string               `json:"suffix,omitempty"`
}

func (TextQuoteSelector) memberOfSelector()      {}
func (TextQuoteSelector) told() (string, string) { return "type", "TextQuoteSelector" }

type TextQuoteSelectorType string

// The values of TextQuoteSelectorType.
const (
	TextQuoteSelectorTypeTextQuoteSelector TextQuoteSelectorType = "TextQuoteSelector"
)

// Valid is whether e is one of TextQuoteSelectorType's values.
func (e TextQuoteSelectorType) Valid() bool {
	switch e {
	case TextQuoteSelectorTypeTextQuoteSelector:
		return true
	}
	return false
}

// TextSpan A span of a text: the code points from `start` up to but not
// including `end`, the words they are, and maybe the text just before and
// just after them.
type TextSpan struct {
	// Start The offset the span starts at, in Unicode code points from the
	// text's start.
	Start int `json:"start"`
	// End The offset just past the span, in Unicode code points from the text's
	// start.
	End int `json:"end"`
	// Exact The words quoted.
	Exact string `json:"exact"`
	// Prefix The text just before them.
	Prefix *string `json:"prefix,omitempty"`
	// Suffix The text just after them.
	Suffix *string `json:"suffix,omitempty"`
}

type TextualBody struct {
	Type TextualBodyType `json:"type"`
	// Value The text content (e.g., entity type name)
	Value string `json:"value"`
	// Purpose Why this body is included
	Purpose *BodyPurpose `json:"purpose,omitempty"`
	// Format MIME type (defaults to text/plain)
	Format *string `json:"format,omitempty"`
	// Language BCP 47 language tag
	Language *string `json:"language,omitempty"`
}

func (TextualBody) memberOfAnnotationBody() {}
func (TextualBody) told() (string, string)  { return "type", "TextualBody" }

type TextualBodyType string

// The values of TextualBodyType.
const (
	TextualBodyTypeTextualBody TextualBodyType = "TextualBody"
)

// Valid is whether e is one of TextualBodyType's values.
func (e TextualBodyType) Valid() bool {
	switch e {
	case TextualBodyTypeTextualBody:
		return true
	}
	return false
}

// UnitCursor The furthest a single unit got, and what it had counted when it
// got there. A unit left partway is resumed from its cursor rather than
// redone. A finished unit keeps its cursor: `next` at the length of the text,
// `size` the size its last piece was cut at, and its final `found`, `emitted`
// and `errors`, so that an attempt that skips the unit still counts it. A
// cursor never says a unit is finished, wherever it stands: `completedUnits`
// does. A unit is an entity type for a linking job, a category for a tagging
// job, and the job's own motivation for every other — which is why a
// unit-grain checkpoint alone is too coarse: those three have exactly one
// unit, so nothing could be recorded until the whole document was done. MERGE
// IS MONOTONE PER UNIT, not a union. `completedUnits` is a set and converges
// under concurrent snapshots because a set only grows; a cursor converges
// only if a stale snapshot can never move it backward. IT CARRIES THE UNIT'S
// RUNNING TALLIES TOO, and they are required. A resumed unit counts only the
// chunks it actually runs, so without them a retry's terminal record reports
// the remainder of the document as if it were the whole — measured at a
// `found` of 19 where the document yielded 25. The position and the tallies
// are ONE observation of the same committed chunk; splitting them would let a
// resume take the saving and still report a number nobody can trust.
type UnitCursor struct {
	// Next Unicode code points of the text consumed once the last COMMITTED
	// chunk completed — the resume position, and the length of the text for a
	// unit whose last chunk it was. Deliberately the chunk's `next`, never its
	// `at`: the checkpoint must not lead the log, so it records where a chunk
	// that is already durable ended, not where the in-flight one began.
	// Recording `at` would make a resume re-run the chunk it already paid for.
	Next int `json:"next"`
	// Size The token size that last committed chunk was cut at — the calibration
	// the attempt paid for over the chunks before it. A resume seeds from this
	// and then takes ONE adaptive step, as if the last outcome were a failure,
	// which it was: the job died. Seeding alone would re-cut the failing piece
	// identically; opening at the default would discard the calibration.
	Size int `json:"size"`
	// Found Items detection has returned for this unit through the last
	// committed chunk — the numerator a resumed attempt continues from rather
	// than restarting at zero. Counts what the model reported, before dedupe.
	Found int `json:"found"`
	// Emitted Annotations actually committed for this unit through the last
	// committed chunk, after dedupe. With `found` and `errors` it is what the
	// job's terminal result reports, so a resumed unit seeds all three and its
	// record describes the whole document rather than one attempt's share.
	Emitted int `json:"emitted"`
	// Errors Items detection returned for this unit through the last committed
	// chunk that could not be anchored in the text. Carried with the other two
	// tallies so that a resumed job reports the whole document's, and not only
	// its last attempt's.
	Errors int `json:"errors"`
}

type UpdateAnnotationBodyRequest struct {
	// ResourceId Resource ID containing the annotation (required for O(1) Layer
	// 3 lookup)
	ResourceId ResourceId `json:"resourceId"`
	// Operations Array of body modification operations to apply
	Operations []BodyOperation `json:"operations"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v UpdateAnnotationBodyRequest) MarshalJSON() ([]byte, error) {
	type written UpdateAnnotationBodyRequest
	v.Operations = listOf(v.Operations)
	return json.Marshal(written(v))
}

// UploadProgress What an upload reports as it goes, told apart by `phase`:
// its size first, then the bytes sent so far, then the resource made.
type UploadProgress struct {
	union[UploadProgressMember]
}

// UploadProgressMember is a member of UploadProgress: UploadProgressStarted,
// UploadProgressProgress, UploadProgressFinished.
type UploadProgressMember interface {
	memberOfUploadProgress()
}

// Discriminator is the `phase` this value states.
func (u UploadProgress) Discriminator() (string, error) { return u.stated("phase") }

// Member is the member this value is: the one whose schema admits it.
func (u UploadProgress) Member() (any, error) {
	return u.member("UploadProgress", uploadProgressMembers)
}

// uploadProgressMembers is what each member of UploadProgress admits, and how
// a value of it is read.
var uploadProgressMembers = []unionMember{
	{"UploadProgressStarted", readAs[UploadProgressStarted], []signature{{kind: objectKind, required: []string{"phase", "totalBytes"}, allowed: []string{"phase", "totalBytes"}, fixed: []fixedValues{{"phase", []any{"started"}}}}}},
	{"UploadProgressProgress", readAs[UploadProgressProgress], []signature{{kind: objectKind, required: []string{"phase", "bytesUploaded", "totalBytes"}, allowed: []string{"phase", "bytesUploaded", "totalBytes"}, fixed: []fixedValues{{"phase", []any{"progress"}}}}}},
	{"UploadProgressFinished", readAs[UploadProgressFinished], []signature{{kind: objectKind, required: []string{"phase", "resourceId"}, allowed: []string{"phase", "resourceId"}, fixed: []fixedValues{{"phase", []any{"finished"}}}}}},
}

// UploadProgressFinished The upload ended, and the resource is made.
type UploadProgressFinished struct {
	Phase      UploadProgressFinishedPhase `json:"phase"`
	ResourceId ResourceId                  `json:"resourceId"`
}

func (UploadProgressFinished) memberOfUploadProgress() {}
func (UploadProgressFinished) told() (string, string)  { return "phase", "finished" }

type UploadProgressFinishedPhase string

// The values of UploadProgressFinishedPhase.
const (
	UploadProgressFinishedPhaseFinished UploadProgressFinishedPhase = "finished"
)

// Valid is whether e is one of UploadProgressFinishedPhase's values.
func (e UploadProgressFinishedPhase) Valid() bool {
	switch e {
	case UploadProgressFinishedPhaseFinished:
		return true
	}
	return false
}

// UploadProgressProgress Bytes were sent.
type UploadProgressProgress struct {
	Phase UploadProgressProgressPhase `json:"phase"`
	// BytesUploaded How many bytes are sent so far.
	BytesUploaded int `json:"bytesUploaded"`
	// TotalBytes How many bytes the upload is.
	TotalBytes int `json:"totalBytes"`
}

func (UploadProgressProgress) memberOfUploadProgress() {}
func (UploadProgressProgress) told() (string, string)  { return "phase", "progress" }

type UploadProgressProgressPhase string

// The values of UploadProgressProgressPhase.
const (
	UploadProgressProgressPhaseProgress UploadProgressProgressPhase = "progress"
)

// Valid is whether e is one of UploadProgressProgressPhase's values.
func (e UploadProgressProgressPhase) Valid() bool {
	switch e {
	case UploadProgressProgressPhaseProgress:
		return true
	}
	return false
}

// UploadProgressStarted The upload began.
type UploadProgressStarted struct {
	Phase UploadProgressStartedPhase `json:"phase"`
	// TotalBytes How many bytes the upload is.
	TotalBytes int `json:"totalBytes"`
}

func (UploadProgressStarted) memberOfUploadProgress() {}
func (UploadProgressStarted) told() (string, string)  { return "phase", "started" }

type UploadProgressStartedPhase string

// The values of UploadProgressStartedPhase.
const (
	UploadProgressStartedPhaseStarted UploadProgressStartedPhase = "started"
)

// Valid is whether e is one of UploadProgressStartedPhase's values.
func (e UploadProgressStartedPhase) Valid() bool {
	switch e {
	case UploadProgressStartedPhaseStarted:
		return true
	}
	return false
}

// UserAction A sign-in waits for a person: open the verification page and
// enter the code. The code is sent here and nowhere else — in no progress
// line, no log record and no diagnostic.
type UserAction struct {
	RequestId RequestId `json:"requestId"`
	// VerificationUri The page where the person enters the code.
	VerificationUri string `json:"verificationUri"`
	// VerificationUriComplete The page with the code already in it, when the
	// issuer offers one.
	VerificationUriComplete *string `json:"verificationUriComplete,omitempty"`
	// UserCode The code the person enters.
	UserCode string `json:"userCode"`
	// ExpiresInSeconds How long the code is good for, from when it was issued.
	ExpiresInSeconds int `json:"expiresInSeconds"`
}

// UserResponse The authenticated principal, as this knowledge base names it.
// The `did` is the identity: it is what the bus stamps on every event, what
// resource creation is attributed to, and what a client must compare against
// to recognise its own work in the data. It is the only identifier: a row id
// would appear nowhere else in the system and correlate with nothing. The
// remaining fields exist to be displayed, and all of them come from the
// token's own claims.
type UserResponse struct {
	// Did The authenticated principal's DID: `did:web:<domain>:agents:<subject>`
	// for an agent, whose token's `kind` claim is `agent`, and
	// `did:web:<domain>:users:<subject>` for a person, where the subject is the
	// issuer claim the knowledge base names its principals by
	// (`identity.subjectClaim`).
	Did UserId `json:"did"`
	// Email The address the token carries, when it carries one: an agent's
	// account need not have one.
	Email *string `json:"email"`
	Name  *string `json:"name"`
	Image *string `json:"image"`
	// Domain The knowledge base's domain: the authority the principal is named
	// under.
	Domain string `json:"domain"`
}

// VectorStore The vector store the launcher runs for the knowledge bases on a
// machine, each knowledge base's index in collections of its own. It belongs
// to no knowledge base, so its document is kept in the launcher's state home,
// in `stack/vectors.yaml`, not in a knowledge base's repository. A knowledge
// base keeps its index in it by naming `shared` at `spec.vectors`.
type VectorStore struct {
	ApiVersion StackApiVersion `json:"apiVersion"`
	Kind       VectorStoreKind `json:"kind"`
	Metadata   Metadata        `json:"metadata"`
	// Spec The vector store, and where it is published.
	Spec VectorStoreSpec `json:"spec"`
}

type VectorStoreKind string

// The values of VectorStoreKind.
const (
	VectorStoreKindVectorStore VectorStoreKind = "VectorStore"
)

// Valid is whether e is one of VectorStoreKind's values.
func (e VectorStoreKind) Valid() bool {
	switch e {
	case VectorStoreKindVectorStore:
		return true
	}
	return false
}

// VectorStoreSpec The vector store, and where it is published.
type VectorStoreSpec struct {
	// Type The vector store's driver: `qdrant`.
	Type      string    `json:"type"`
	Image     Image     `json:"image"`
	Resources Resources `json:"resources"`
	// Port The port the vector store is published on, on this machine, where
	// every knowledge base's Smelter and Librarian reach it.
	Port int `json:"port"`
}

// VectorsConfig The vector index a service writes or searches, and what that
// kind of index needs to be reached: one of the kinds `xynolog-vectors` has a
// store for, told apart by `type`.
type VectorsConfig struct {
	union[VectorsConfigMember]
}

// VectorsConfigMember is a member of VectorsConfig: QdrantVectorsConfig,
// MemoryVectorsConfig.
type VectorsConfigMember interface {
	memberOfVectorsConfig()
}

// Discriminator is the `type` this value states.
func (u VectorsConfig) Discriminator() (string, error) { return u.stated("type") }

// Member is the member this value is: the one whose schema admits it.
func (u VectorsConfig) Member() (any, error) { return u.member("VectorsConfig", vectorsConfigMembers) }

// vectorsConfigMembers is what each member of VectorsConfig admits, and how a
// value of it is read.
var vectorsConfigMembers = []unionMember{
	{"QdrantVectorsConfig", readAs[QdrantVectorsConfig], []signature{{kind: objectKind, required: []string{"type", "host", "port", "tokenEnv"}, allowed: []string{"type", "host", "port", "tokenEnv"}, fixed: []fixedValues{{"type", []any{"qdrant"}}}}}},
	{"MemoryVectorsConfig", readAs[MemoryVectorsConfig], []signature{{kind: objectKind, required: []string{"type"}, allowed: []string{"type"}, fixed: []fixedValues{{"type", []any{"memory"}}}}}},
}

// VoyageEmbeddingConfig An embedding model served by Voyage AI. No service
// has been run against Voyage itself.
type VoyageEmbeddingConfig struct {
	Type VoyageEmbeddingConfigType `json:"type"`
	// Model The model asked for, by Voyage's name for it.
	Model string `json:"model"`
	// Endpoint The whole address of Voyage's embeddings call
	// (`https://api.voyageai.com/v1/embeddings`).
	Endpoint string `json:"endpoint"`
	// ApiKeyEnv The environment variable holding the Voyage API key. The key is
	// never a value here.
	ApiKeyEnv string `json:"apiKeyEnv"`
}

func (VoyageEmbeddingConfig) memberOfEmbeddingConfig() {}
func (VoyageEmbeddingConfig) told() (string, string)   { return "type", "voyage" }

type VoyageEmbeddingConfigType string

// The values of VoyageEmbeddingConfigType.
const (
	VoyageEmbeddingConfigTypeVoyage VoyageEmbeddingConfigType = "voyage"
)

// Valid is whether e is one of VoyageEmbeddingConfigType's values.
func (e VoyageEmbeddingConfigType) Valid() bool {
	switch e {
	case VoyageEmbeddingConfigTypeVoyage:
		return true
	}
	return false
}

// WeaveApplied The payload of `weave:applied`: the Weaver has applied a
// resource's events to the graph up to this sequence number. Emitted after
// applying an event, or a batch's last event.
type WeaveApplied struct {
	// ResourceId The resource whose events were applied.
	ResourceId ResourceId `json:"resourceId"`
	// SequenceNumber The resource-stream sequence of the last applied event.
	SequenceNumber int `json:"sequenceNumber"`
}

// WeaveRebuildCommand Bus command to rebuild the graph projection from the
// event log — the whole graph when resourceId is absent, one resource when
// present. Served by the Weaver; replaces direct rebuild access, which does
// not survive the Weaver's container split.
type WeaveRebuildCommand struct {
	// ResourceId When present, rebuild only this resource; otherwise clear and
	// rebuild the entire graph.
	ResourceId *ResourceId `json:"resourceId,omitempty"`
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId *UserId `json:"_userId,omitempty"`
}

// WeaverConfig Everything a Weaver reads at boot: nothing in it is defaulted
// by the Weaver. The launcher writes it for the Weaver it starts, from the
// knowledge base's stack documents, and the Weaver reads it from the path its
// `--config` flag names (its image passes `/etc/xynolog/weaver.json`).
// Whoever starts a Weaver another way writes the same document: this schema
// is the contract, and a Weaver needs no launcher. Started without
// `--config`, or with a path that names no file, the Weaver refuses to start
// and says which. No secret is a value here: the graph database's password is
// named by the environment variable that holds it, and the Weaver's own
// service account is `XYNOLOG_OIDC_CLIENT_ID` and
// `XYNOLOG_OIDC_CLIENT_SECRET` in its environment. A document that does not
// validate is refused at boot, naming each failing field.
type WeaverConfig struct {
	Kb KbIdentity `json:"kb"`
	// GatewayUrl The URL the Weaver reaches the gateway at: its route to the
	// bus.
	GatewayUrl string `json:"gatewayUrl"`
	// Identity The issuer the Weaver's service account signs in at.
	Identity ServiceIdentity `json:"identity"`
	// Archivist Where the Archivist listens. The Weaver reads the record by
	// position from it, and a resource's annotations, as its service account.
	Archivist   ServiceAddress `json:"archivist"`
	Graph       GraphConfig    `json:"graph"`
	CursorsPath CursorsPath    `json:"cursorsPath"`
	// Port The port the Weaver answers `/health` on.
	Port      int       `json:"port"`
	LogLevel  LogLevel  `json:"logLevel"`
	LogFormat LogFormat `json:"logFormat"`
}

// WeaverHealth The Weaver's health answer (WEAVER.md § Health). `status` is
// `ok` whenever the Weaver answers: it says nothing of whether the Weaver can
// reach the gateway or the graph.
type WeaverHealth struct {
	Status WeaverHealthStatus `json:"status"`
	// Kb The DID of the knowledge base it serves: the one its settings name,
	// which that knowledge base said it is before the Weaver connected to the
	// graph database.
	Kb        KbDid             `json:"kb"`
	Following FollowerFollowing `json:"following"`
	// Reconcile How far the reconcile its first sweep is followed by has got
	// (WEAVER.md § Reconcile): the pass's `summary` when it is done, or its
	// `error` when it failed.
	Reconcile WeaverHealthReconcile `json:"reconcile"`
}

// WeaverHealthReconcile How far the reconcile its first sweep is followed by
// has got (WEAVER.md § Reconcile): the pass's `summary` when it is done, or
// its `error` when it failed.
type WeaverHealthReconcile struct {
	Phase WeaverHealthReconcilePhase `json:"phase"`
	// Summary What the pass found and did.
	Summary *WeaverHealthReconcileSummary `json:"summary,omitempty"`
	// Error Why it failed.
	Error *string `json:"error,omitempty"`
}

type WeaverHealthReconcilePhase string

// The values of WeaverHealthReconcilePhase.
const (
	WeaverHealthReconcilePhasePending WeaverHealthReconcilePhase = "pending"
	WeaverHealthReconcilePhaseRunning WeaverHealthReconcilePhase = "running"
	WeaverHealthReconcilePhaseDone    WeaverHealthReconcilePhase = "done"
	WeaverHealthReconcilePhaseFailed  WeaverHealthReconcilePhase = "failed"
)

// Valid is whether e is one of WeaverHealthReconcilePhase's values.
func (e WeaverHealthReconcilePhase) Valid() bool {
	switch e {
	case WeaverHealthReconcilePhasePending, WeaverHealthReconcilePhaseRunning, WeaverHealthReconcilePhaseDone, WeaverHealthReconcilePhaseFailed:
		return true
	}
	return false
}

// WeaverHealthReconcileSummary What the pass found and did.
type WeaverHealthReconcileSummary struct {
	// ResourcesChecked How many resources it checked.
	ResourcesChecked int `json:"resourcesChecked"`
	// Divergent How many of them were divergent: the graph held them otherwise
	// than the record.
	Divergent int `json:"divergent"`
	// Healed How many divergent resources it rebuilt.
	Healed int `json:"healed"`
	// HealFailures How many it did not heal, because the rebuild stopped at an
	// event it could not apply.
	HealFailures int `json:"healFailures"`
	// Orphaned How many orphaned views it found: resources the catalog lists and
	// the record holds no events for. Each is counted, and not healed.
	Orphaned int `json:"orphaned"`
}

type WeaverHealthStatus string

// The values of WeaverHealthStatus.
const (
	WeaverHealthStatusOk WeaverHealthStatus = "ok"
)

// Valid is whether e is one of WeaverHealthStatus's values.
func (e WeaverHealthStatus) Valid() bool {
	switch e {
	case WeaverHealthStatusOk:
		return true
	}
	return false
}

// WorkerAnswerFormats worker/answer-formats.json: the element of the array
// each kind of detection asks a model for.
type WorkerAnswerFormats struct {
	// Comment The rule the table states, in prose.
	Comment string                           `json:"$comment"`
	Formats []WorkerAnswerFormatsFormatsItem `json:"formats"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v WorkerAnswerFormats) MarshalJSON() ([]byte, error) {
	type written WorkerAnswerFormats
	v.Formats = listOf(v.Formats)
	return json.Marshal(written(v))
}

type WorkerAnswerFormatsFormatsItem struct {
	// Name A motivation a `mark` job takes, or `count`.
	Name string `json:"name"`
	// About What an element is, in prose.
	About string `json:"about"`
	// Element The JSON Schema of one element of the answer.
	Element any `json:"element"`
}

// WorkerConfig Everything a worker reads at boot: nothing in it is defaulted
// by the worker. The launcher writes it for the machine's worker, from the
// knowledge bases on that worker's list: each local knowledge base as its
// start places it, from its stack documents, and each added by `xynolog
// worker kb add`, offered the engines of the local one it was added from. The
// worker reads it from the path its `--config` flag names (its image passes
// `/etc/xynolog/worker.json`). Whoever starts a worker another way writes the
// same document: this schema is the contract, and a worker needs no launcher.
// Started without `--config`, or with a path that names no file, the worker
// refuses to start and says which. No secret is a value here: a provider's
// key is named by the environment variable that holds it, and the key the
// worker signs in with at every knowledge base is `XYNOLOG_OIDC_CLIENT_KEY`
// in its environment, an RSA private key; each knowledge base names the
// client that holds its public half there. A document that does not validate
// is refused at boot, naming each failing field.
type WorkerConfig struct {
	// KnowledgeBases The knowledge bases this worker does jobs for. At each it
	// signs in, confirms which knowledge base it reached and claims for its
	// engines, apart from every other: one knowledge base's trouble stops that
	// knowledge base's work alone (`contract/WORKER-SERVICE.md` § Knowledge
	// bases). No two name one `domain`, which the worker refuses at boot.
	KnowledgeBases []WorkerKnowledgeBaseConfig `json:"knowledgeBases"`
	// ModelCatalogue The path of a model catalogue file: what each model of a
	// provider can take, for the providers whose own APIs do not say (`google`,
	// `openai`, `together`). A worker with an engine of one of those providers
	// refuses to start where the file cannot be read, and where it states
	// nothing of that engine's model. A worker with no such engine does not read
	// it.
	ModelCatalogue string `json:"modelCatalogue"`
	// Port The port the worker answers `/health` on.
	Port      int       `json:"port"`
	LogLevel  LogLevel  `json:"logLevel"`
	LogFormat LogFormat `json:"logFormat"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v WorkerConfig) MarshalJSON() ([]byte, error) {
	type written WorkerConfig
	v.KnowledgeBases = listOf(v.KnowledgeBases)
	return json.Marshal(written(v))
}

// WorkerEngineConfig One engine a worker runs: which it is, the jobs the
// worker claims to do with it, and where its provider is reached.
type WorkerEngineConfig struct {
	Engine Engine `json:"engine"`
	// Jobs The jobs the worker claims to do with this engine, as a claim names
	// them (`job:claim`'s `accepts`): it claims with these filters and no other.
	Jobs []JobFilter `json:"jobs"`
	// BaseUrl The address the provider's API is reached at.
	BaseUrl string `json:"baseUrl"`
	// ApiKeyEnv The environment variable holding the provider's API key, when
	// the provider requires one.
	ApiKeyEnv *string `json:"apiKeyEnv,omitempty"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v WorkerEngineConfig) MarshalJSON() ([]byte, error) {
	type written WorkerEngineConfig
	v.Jobs = listOf(v.Jobs)
	return json.Marshal(written(v))
}

// WorkerEngineHealth One engine at one knowledge base: which it is, the jobs
// it claims, and what its claims can say of themselves (WORKER-CONTRACT V1).
type WorkerEngineHealth struct {
	Engine Engine `json:"engine"`
	// Jobs The jobs it claims, as its claims state them.
	Jobs []JobFilter `json:"jobs"`
	// LastQueuedEventAt When a `job:queued` last reached it, or null.
	LastQueuedEventAt *string `json:"lastQueuedEventAt"`
	// LastClaimAt When it was last handed a job, or null. A claim answered with
	// none pending is not one.
	LastClaimAt *string `json:"lastClaimAt"`
	// LastFinishedAt When a job it held last settled, or null.
	LastFinishedAt *string `json:"lastFinishedAt"`
	// LastActivityAt When it was last active, or null.
	LastActivityAt *string `json:"lastActivityAt"`
	// ActiveJob The job it holds, or null.
	ActiveJob *WorkerEngineHealthActiveJob `json:"activeJob"`
	// JobsCompleted How many jobs it has completed since the service started.
	JobsCompleted int `json:"jobsCompleted"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v WorkerEngineHealth) MarshalJSON() ([]byte, error) {
	type written WorkerEngineHealth
	v.Jobs = listOf(v.Jobs)
	return json.Marshal(written(v))
}

// WorkerEngineHealthActiveJob The job it holds, or null.
type WorkerEngineHealthActiveJob struct {
	JobId JobId   `json:"jobId"`
	Type  JobType `json:"type"`
	// Since When it was handed the job.
	Since string `json:"since"`
}

// WorkerHealth The Worker service's health answer (WORKER-SERVICE H1). It
// answers only once a knowledge base of its document is confirmed, so a 200
// means it is working somewhere.
type WorkerHealth struct {
	Status WorkerHealthStatus `json:"status"`
	// KnowledgeBases One entry for each of the document's `knowledgeBases`, in
	// its order.
	KnowledgeBases []WorkerKnowledgeBaseHealth `json:"knowledgeBases"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v WorkerHealth) MarshalJSON() ([]byte, error) {
	type written WorkerHealth
	v.KnowledgeBases = listOf(v.KnowledgeBases)
	return json.Marshal(written(v))
}

type WorkerHealthStatus string

// The values of WorkerHealthStatus.
const (
	WorkerHealthStatusOk WorkerHealthStatus = "ok"
)

// Valid is whether e is one of WorkerHealthStatus's values.
func (e WorkerHealthStatus) Valid() bool {
	switch e {
	case WorkerHealthStatusOk:
		return true
	}
	return false
}

// WorkerKnowledgeBaseConfig One knowledge base a worker does jobs for: which
// it is, where its gateway is, the account the worker signs in as there, and
// the engines it offers it. The worker signs in, confirms the knowledge base
// and claims at each knowledge base apart from every other.
type WorkerKnowledgeBaseConfig struct {
	// Domain The knowledge base's did:web domain, as it answers
	// `browse:kb-requested`: which knowledge base this is. The worker confirms
	// it there before it claims, and refuses a knowledge base that answers
	// another domain, or none.
	Domain string `json:"domain"`
	// GatewayUrl The URL the worker reaches the knowledge base's gateway at: its
	// route to the bus and to a resource's bytes, and the only address of the
	// knowledge base it holds.
	GatewayUrl string `json:"gatewayUrl"`
	// Identity Where the worker signs in for this knowledge base, and as which
	// client.
	Identity WorkerKnowledgeBaseConfigIdentity `json:"identity"`
	// Engines The engines the worker offers this knowledge base, and the jobs it
	// does with each: its own choice, on its own providers' keys. It claims each
	// engine's jobs there for it, so a job no engine here is used for is not
	// claimed at this knowledge base.
	Engines []WorkerEngineConfig `json:"engines"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v WorkerKnowledgeBaseConfig) MarshalJSON() ([]byte, error) {
	type written WorkerKnowledgeBaseConfig
	v.Engines = listOf(v.Engines)
	return json.Marshal(written(v))
}

// WorkerKnowledgeBaseConfigIdentity Where the worker signs in for this
// knowledge base, and as which client.
type WorkerKnowledgeBaseConfigIdentity struct {
	// Issuer The issuer URL, exactly as tokens carry it in `iss`.
	Issuer string `json:"issuer"`
	// ClientId The client the issuer holds the public half of the worker's key
	// on: the worker's account at this knowledge base. It is also what the
	// worker says it is called there (`principal:profile`).
	ClientId string `json:"clientId"`
}

// WorkerKnowledgeBaseHealth One knowledge base the worker serves, as its
// health says it. `did` and `engines` are there while it is `working`, and
// only then.
type WorkerKnowledgeBaseHealth struct {
	// Domain The entry's `domain`.
	Domain string `json:"domain"`
	// State `starting`: signing in, opening its stream, confirming it, or
	// waiting to start again. `working`: confirmed, its engines claiming.
	// `refused`: refused, until the service is started again.
	State WorkerKnowledgeBaseHealthState `json:"state"`
	// Did The agent's DID at this knowledge base, as its gateway named it.
	Did *string `json:"did,omitempty"`
	// Engines One entry for each of the entry's engines, in its order.
	Engines *[]WorkerEngineHealth `json:"engines,omitempty"`
}

// WorkerKnowledgeBaseHealthState `starting`: signing in, opening its stream,
// confirming it, or waiting to start again. `working`: confirmed, its engines
// claiming. `refused`: refused, until the service is started again.
type WorkerKnowledgeBaseHealthState string

// The values of WorkerKnowledgeBaseHealthState.
const (
	WorkerKnowledgeBaseHealthStateStarting WorkerKnowledgeBaseHealthState = "starting"
	WorkerKnowledgeBaseHealthStateWorking  WorkerKnowledgeBaseHealthState = "working"
	WorkerKnowledgeBaseHealthStateRefused  WorkerKnowledgeBaseHealthState = "refused"
)

// Valid is whether e is one of WorkerKnowledgeBaseHealthState's values.
func (e WorkerKnowledgeBaseHealthState) Valid() bool {
	switch e {
	case WorkerKnowledgeBaseHealthStateStarting, WorkerKnowledgeBaseHealthStateWorking, WorkerKnowledgeBaseHealthStateRefused:
		return true
	}
	return false
}

// WorkerMessages worker/messages.json: the words of a Worker service's
// refusals to start, of the errors it fails a job with, and of the messages
// it logs that a reader relies on.
type WorkerMessages struct {
	// Comment The rule the table states, in prose.
	Comment string `json:"$comment"`
	// Boot Each refusal to start, written in
	// service-environment/boot-refusals.json's `line`.
	Boot []WorkerMessagesBootItem `json:"boot"`
	// Reasons Each line of the `{reasons}` of `invalid`.
	Reasons []WorkerMessagesReasonsItem `json:"reasons"`
	// Job How an error names the job, by its type, as `{job}`: `{motivation}` is
	// a mark job's motivation.
	Job WorkerMessagesJob `json:"job"`
	// Errors Each error a job is failed with that is the worker's own: the
	// `error` of its `job:fail`.
	Errors []WorkerMessagesErrorsItem `json:"errors"`
	// Details Each `{detail}` of `unreadable`.
	Details []WorkerMessagesDetailsItem `json:"details"`
	// Waits Each `{said}` of `wait-stated`.
	Waits []WorkerMessagesWaitsItem `json:"waits"`
	// Logged Each message a Worker service logs that a reader of its output
	// relies on.
	Logged []WorkerMessagesLoggedItem `json:"logged"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v WorkerMessages) MarshalJSON() ([]byte, error) {
	type written WorkerMessages
	v.Boot = listOf(v.Boot)
	v.Reasons = listOf(v.Reasons)
	v.Errors = listOf(v.Errors)
	v.Details = listOf(v.Details)
	v.Waits = listOf(v.Waits)
	v.Logged = listOf(v.Logged)
	return json.Marshal(written(v))
}

type WorkerMessagesBootItem struct {
	union[WorkerMessagesBootItemMember]
}

// WorkerMessagesBootItemMember is a member of WorkerMessagesBootItem:
// WorkerMessagesBootItemOwnBootRefusal,
// WorkerMessagesBootItemSharedBootRefusal.
type WorkerMessagesBootItemMember interface {
	memberOfWorkerMessagesBootItem()
}

// Member is the member this value is: the one whose schema admits it.
func (u WorkerMessagesBootItem) Member() (any, error) {
	return u.member("WorkerMessagesBootItem", workerMessagesBootItemMembers)
}

// workerMessagesBootItemMembers is what each member of WorkerMessagesBootItem
// admits, and how a value of it is read.
var workerMessagesBootItemMembers = []unionMember{
	{"WorkerMessagesBootItemOwnBootRefusal", readAs[WorkerMessagesBootItemOwnBootRefusal], []signature{{kind: objectKind, required: []string{"name", "situation", "refusal"}, allowed: []string{"name", "situation", "refusal"}}}},
	{"WorkerMessagesBootItemSharedBootRefusal", readAs[WorkerMessagesBootItemSharedBootRefusal], []signature{{kind: objectKind, required: []string{"name", "situation", "bootRefusal"}, allowed: []string{"name", "situation", "bootRefusal"}}}},
}

type WorkerMessagesBootItemOwnBootRefusal struct {
	// Name The situation's name.
	Name string `json:"name"`
	// Situation When it is written, and what fills each `{name}` of its text.
	Situation string `json:"situation"`
	// Refusal The refusal, in place of the line's `{refusal}`. A `{name}` in it
	// is filled with what the row's `situation` names, and nothing else in it
	// varies.
	Refusal string `json:"refusal"`
}

func (WorkerMessagesBootItemOwnBootRefusal) memberOfWorkerMessagesBootItem() {}

type WorkerMessagesBootItemSharedBootRefusal struct {
	// Name The situation's name.
	Name string `json:"name"`
	// Situation When it is written. What fills its text is the shared row's.
	Situation string `json:"situation"`
	// BootRefusal The `name` of the row of
	// service-environment/boot-refusals.json's `refusals` that is this refusal,
	// with `{service}` `worker` and `{schema}` `WorkerConfig`.
	BootRefusal string `json:"bootRefusal"`
}

func (WorkerMessagesBootItemSharedBootRefusal) memberOfWorkerMessagesBootItem() {}

type WorkerMessagesDetailsItem struct {
	// Name The situation's name.
	Name string `json:"name"`
	// Situation When it is written, and what fills each `{name}` of its text.
	Situation string `json:"situation"`
	// Detail The detail. A `{name}` in it is filled with what the row's
	// `situation` names, and nothing else in it varies.
	Detail string `json:"detail"`
}

type WorkerMessagesErrorsItem struct {
	// Name The situation's name.
	Name string `json:"name"`
	// Situation When it is written, and what fills each `{name}` of its text.
	Situation string `json:"situation"`
	// Error The error. `{job}` in it is the job, as `job` names it. A `{name}`
	// in it is filled with what the row's `situation` names, and nothing else in
	// it varies.
	Error string `json:"error"`
}

// WorkerMessagesJob How an error names the job, by its type, as `{job}`:
// `{motivation}` is a mark job's motivation.
type WorkerMessagesJob struct {
	Mark  string `json:"mark"`
	Yield string `json:"yield"`
}

type WorkerMessagesLoggedItem struct {
	// Name The situation's name.
	Name  string   `json:"name"`
	Level LogLevel `json:"level"`
	// Situation When it is written, what fills each `{name}` of its fields, and
	// what each fact it carries says.
	Situation string `json:"situation"`
	// Message The line's message, word for word.
	Message string `json:"message"`
	// Fields The facts the line is logged with whose form is stated, by name:
	// each a text whose `{name}` is filled as the row's `situation` says. A fact
	// that is a number is its decimal digits.
	Fields map[string]string `json:"fields"`
	// Carries The facts the line is logged with beside `fields`, whose value the
	// row's `situation` says and whose form is not stated. The line may carry
	// others.
	Carries []string `json:"carries"`
}

// MarshalJSON writes v, each list its schema requires that Go holds as nil
// written as the empty list.
func (v WorkerMessagesLoggedItem) MarshalJSON() ([]byte, error) {
	type written WorkerMessagesLoggedItem
	v.Carries = listOf(v.Carries)
	return json.Marshal(written(v))
}

type WorkerMessagesReasonsItem struct {
	// Name The situation's name.
	Name string `json:"name"`
	// Situation When it is written, and what fills each `{name}` of its text.
	Situation string `json:"situation"`
	// Line The line, indented by two spaces. A `{name}` in it is filled with
	// what the row's `situation` names, and nothing else in it varies.
	Line string `json:"line"`
}

type WorkerMessagesWaitsItem struct {
	// Name The situation's name.
	Name string `json:"name"`
	// Situation When it is written, and what fills each `{name}` of its text.
	Situation string `json:"situation"`
	// Said The wait, as the header stated it. A `{name}` in it is filled with
	// what the row's `situation` names, and nothing else in it varies.
	Said string `json:"said"`
}

// WorkerPool The shared worker that does knowledge bases' jobs: its image,
// its memory and its log level. They are shared, not any knowledge base's, so
// its document is kept in the launcher's state home, in `stack/workers.yaml`,
// not in a knowledge base's repository. A knowledge base's jobs are done when
// its Inference document gives a job an engine. A worker needs only the
// Gateway, and an issuer's token with the worker's role.
type WorkerPool struct {
	ApiVersion StackApiVersion `json:"apiVersion"`
	Kind       WorkerPoolKind  `json:"kind"`
	Metadata   Metadata        `json:"metadata"`
	// Spec How the worker runs.
	Spec WorkerPoolSpec `json:"spec"`
}

type WorkerPoolKind string

// The values of WorkerPoolKind.
const (
	WorkerPoolKindWorkerPool WorkerPoolKind = "WorkerPool"
)

// Valid is whether e is one of WorkerPoolKind's values.
func (e WorkerPoolKind) Valid() bool {
	switch e {
	case WorkerPoolKindWorkerPool:
		return true
	}
	return false
}

// WorkerPoolSpec How the worker runs.
type WorkerPoolSpec struct {
	LogLevel LogLevel `json:"logLevel"`
	// Worker The Worker.
	Worker WorkerPoolSpecWorker `json:"worker"`
}

// WorkerPoolSpecWorker The Worker.
type WorkerPoolSpecWorker struct {
	Image     Image     `json:"image"`
	Resources Resources `json:"resources"`
}

// WorkloadStatus A knowledge base's operational readings from Collector
// metrics. Request-tracking occupancy and queue depth are current gauges;
// completed and failed are worker counters since that worker process started.
// Missing readings are unknown, never zero.
type WorkloadStatus struct {
	// Ledger The Gateway's request tracking: correlation IDs it currently holds
	// so replies can be routed to the app client that sent each request, and the
	// tracking capacity.
	Ledger *WorkloadStatusLedger `json:"ledger,omitempty"`
	// Queue Current Dispatcher depth and, when the worker has emitted counters,
	// completed and failed work since worker start. These are different
	// measurements and time windows.
	Queue *WorkloadStatusQueue `json:"queue,omitempty"`
}

// WorkloadStatusLedger The Gateway's request tracking: correlation IDs it
// currently holds so replies can be routed to the app client that sent each
// request, and the tracking capacity.
type WorkloadStatusLedger struct {
	// Claims Number of request IDs currently held to route replies to their
	// requesting app clients. Includes requests still waiting for a reply and
	// recently answered requests still within the tracking window.
	Claims int `json:"claims"`
	// Capacity The maximum number of IDs held in this Gateway's local tracking
	// projection.
	Capacity int `json:"capacity"`
}

// WorkloadStatusQueue Current Dispatcher depth and, when the worker has
// emitted counters, completed and failed work since worker start. These are
// different measurements and time windows.
type WorkloadStatusQueue struct {
	// Pending Jobs currently waiting for a worker.
	Pending int `json:"pending"`
	// Running Jobs currently claimed by workers.
	Running int `json:"running"`
	// Completed Jobs completed since worker start.
	Completed *int `json:"completed,omitempty"`
	// Failed Jobs finally failed since worker start.
	Failed *int `json:"failed,omitempty"`
}

// YieldCloneCreateCommand Bus command to create a cloned resource from a
// clone token. Bytes are stored by the upload path BEFORE this command is
// emitted, because bytes travel over HTTP and never over the bus — the
// command carries the storage coordinates, never content.
type YieldCloneCreateCommand struct {
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId *UserId `json:"_userId,omitempty"`
	Token  string  `json:"token"`
	Name   string  `json:"name"`
	// StorageUri Where the caller already wrote the clone's bytes — an
	// instruction, not a copy of the stored fact (that lives on the primary
	// Representation). Bytes are stored through the byte door BEFORE this
	// command is sent, so this names an existing file. Working-tree URI, only
	// file:// is supported.
	StorageUri      string        `json:"storageUri"`
	ContentChecksum string        `json:"contentChecksum"`
	ByteSize        int           `json:"byteSize"`
	Format          ContentFormat `json:"format"`
	ArchiveOriginal *bool         `json:"archiveOriginal,omitempty"`
}

// YieldCloneCreated Success response after creating a cloned resource.
type YieldCloneCreated struct {
	Response YieldedResource `json:"response"`
}

// YieldClonePersistCommand Command: stow an already-uploaded clone's bytes
// and append `yield:cloned`. The INNER half of the clone flow.
// `yield:clone-create` reaches the CloneTokenManager, which alone can
// validate the token and read the source's entity types; it then emits this
// so the Stower — the only appendEvent caller — writes the domain event.
// Distinct from `yield:create` because a clone is a distinct operation, not a
// creation with an extra field. It REQUIRES a parent, and that requirement is
// what a separate command expresses: an optional `parentResourceId` on the
// create command could not say that a clone without a parent is not a clone.
// `ResourceClonedPayload` requires it for the same reason. Generated
// resources are NOT clones: they carry provenance in `generatedFrom` and stay
// on `yield:create`.
type YieldClonePersistCommand struct {
	// UserId Injected by the gateway from the authenticated principal; never
	// supplied by a wire caller.
	UserId *UserId `json:"_userId,omitempty"`
	Name   string  `json:"name"`
	// StorageUri The caller's instruction for WHERE the bytes are — the uploader
	// wrote them before emitting this. The stored location lives on the clone's
	// primary Representation, the one home of a storage URI.
	StorageUri      string        `json:"storageUri"`
	ContentChecksum string        `json:"contentChecksum"`
	ByteSize        int           `json:"byteSize"`
	Format          ContentFormat `json:"format"`
	Language        *string       `json:"language,omitempty"`
	// EntityTypes Inherited from the source resource by the CloneTokenManager,
	// which is the only party that knows the token is valid.
	EntityTypes *[]string `json:"entityTypes,omitempty"`
	// ParentResourceId The resource this one is cloned FROM. Required: it is
	// what makes this a clone rather than a creation.
	ParentResourceId ResourceId `json:"parentResourceId"`
}

// YieldClonePersistOk Success reply after cloning a resource, matched to the
// originating command by correlationId.
type YieldClonePersistOk struct {
	// Response The clone's identity — a new resource, distinct from its parent.
	Response YieldedResource `json:"response"`
}

// YieldCloneResourceRequest Bus command to request cloning a resource using a
// clone token.
type YieldCloneResourceRequest struct {
	Token string `json:"token"`
}

// YieldCloneTokenRequest Bus command to request a clone token for a resource.
type YieldCloneTokenRequest struct {
	ResourceId ResourceId `json:"resourceId"`
}

// YieldCreateCommand Bus command to create a yielded resource in the
// knowledge base.
type YieldCreateCommand struct {
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId *UserId `json:"_userId,omitempty"`
	// Roles The emitter's capabilities (the token's `roles`), injected by the
	// /bus/emit gateway. Clients do not set this. An emitter carrying the worker
	// role must cite the job this resource fulfils in `jobId`; the Stower
	// refuses the create otherwise.
	Roles *[]string `json:"_roles,omitempty"`
	// JobId The job this resource fulfils. Required when the emitter carries the
	// worker role; absent for self-initiated work (a person, or an agent acting
	// on its own). The knowledge base derives who requested this resource from
	// the cited job's own events — the emitter never says who the work was for.
	JobId *JobId `json:"jobId,omitempty"`
	Name  string `json:"name"`
	// StorageUri The caller's instruction for WHERE the bytes are — not a copy
	// of the stored fact. The stored location lives on the resource's primary
	// Representation (`Representation.storageUri`), which is its single home;
	// this field is the message that puts it there. Working-tree URI, only
	// file:// is supported (e.g. file://docs/overview.md).
	StorageUri       string                           `json:"storageUri"`
	ContentChecksum  string                           `json:"contentChecksum"`
	ByteSize         int                              `json:"byteSize"`
	Format           ContentFormat                    `json:"format"`
	Language         *string                          `json:"language,omitempty"`
	EntityTypes      *[]string                        `json:"entityTypes,omitempty"`
	IsDraft          *bool                            `json:"isDraft,omitempty"`
	GeneratedFrom    *YieldCreateCommandGeneratedFrom `json:"generatedFrom,omitempty"`
	GenerationPrompt *string                          `json:"generationPrompt,omitempty"`
	// Generator The Software peer that produced the content, when software did.
	// Its identity must be the emitter's own — the knowledge base refuses a
	// generator naming anyone else, and supplies it from the verified emitter
	// when omitted. `creator` and `wasAttributedTo` are never sent; the
	// knowledge base derives them from the emitter and the cited job.
	Generator *OneOrMoreAgents `json:"generator,omitempty"`
}

type YieldCreateCommandGeneratedFrom struct {
	ResourceId   *ResourceId   `json:"resourceId,omitempty"`
	AnnotationId *AnnotationId `json:"annotationId,omitempty"`
}

// YieldCreateOk Success reply after creating a yielded resource, matched to
// the originating command by correlationId.
type YieldCreateOk struct {
	// Response The created resource's identity.
	Response YieldedResource `json:"response"`
}

// YieldJobCompleteCommand A `yield` job's worker says the job is complete,
// with what a `yield` job reports.
type YieldJobCompleteCommand struct {
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId     *UserId                        `json:"_userId,omitempty"`
	ResourceId ResourceId                     `json:"resourceId"`
	JobId      JobId                          `json:"jobId"`
	JobType    YieldJobCompleteCommandJobType `json:"jobType"`
	// Attempt Which attempt produced this event, 1-based (a first run is 1).
	// ALWAYS present: the queue re-runs a failed job silently, so an operator
	// reading progress or a terminal record has no other way to tell a re-run
	// from a first run — and provider spend, already counted in
	// xynolog_inference_tokens_total, cannot be attributed to a repeated
	// document without it. Stated rather than inferred from absence, because
	// 'attempt 1' is a fact the emitter always knows.
	Attempt *int `json:"attempt,omitempty"`
	// AnnotationId The annotation the job's context was focused on, when it was
	// focused on one. Lets a client route the completion to that annotation.
	AnnotationId *AnnotationId       `json:"annotationId,omitempty"`
	Result       *YieldJobResult     `json:"result,omitempty"`
	Durability   *DurabilityEvidence `json:"durability,omitempty"`
}

func (YieldJobCompleteCommand) memberOfJobCompleteCommand() {}
func (YieldJobCompleteCommand) told() (string, string)      { return "jobType", "yield" }

type YieldJobCompleteCommandJobType string

// The values of YieldJobCompleteCommandJobType.
const (
	YieldJobCompleteCommandJobTypeYield YieldJobCompleteCommandJobType = "yield"
)

// Valid is whether e is one of YieldJobCompleteCommandJobType's values.
func (e YieldJobCompleteCommandJobType) Valid() bool {
	switch e {
	case YieldJobCompleteCommandJobTypeYield:
		return true
	}
	return false
}

// YieldJobCreateCommand Create a `yield` job: make a resource from a gathered
// context. It names no resource of its own: the job is about the resource its
// context focuses on, which the Dispatcher reads from `params.context.focus`.
type YieldJobCreateCommand struct {
	// UserId The emitter's verified DID, injected by the gateway. Clients do not
	// set this.
	UserId *UserId `json:"_userId,omitempty"`
	// Roles The emitter's roles, injected by the gateway when it has any.
	// Clients do not set this.
	Roles   *[]string                    `json:"_roles,omitempty"`
	JobType YieldJobCreateCommandJobType `json:"jobType"`
	Params  GenerationJobParams          `json:"params"`
}

func (YieldJobCreateCommand) memberOfJobCreateCommand() {}
func (YieldJobCreateCommand) told() (string, string)    { return "jobType", "yield" }

type YieldJobCreateCommandJobType string

// The values of YieldJobCreateCommandJobType.
const (
	YieldJobCreateCommandJobTypeYield YieldJobCreateCommandJobType = "yield"
)

// Valid is whether e is one of YieldJobCreateCommandJobType's values.
func (e YieldJobCreateCommandJobType) Valid() bool {
	switch e {
	case YieldJobCreateCommandJobTypeYield:
		return true
	}
	return false
}

// YieldJobDone What a `yield` job reports when it has made its resource. The
// worker creates the resource first (the create round trip returns its id),
// then emits job:complete carrying it, so resourceId is always present on the
// wire.
type YieldJobDone struct {
	// ResourceId ID of the generated resource, obtained by the worker from the
	// create round-trip before job:complete is emitted
	ResourceId ResourceId `json:"resourceId"`
	// ResourceName Name of the generated resource
	ResourceName string `json:"resourceName"`
	// Truncated True when the model stopped at the maxTokens ceiling — the
	// artifact is cut off, not complete. Derived at the producer from the
	// provider's stopReason ('max_tokens' → true); required because the worker
	// always knows.
	Truncated bool `json:"truncated"`
}

func (YieldJobDone) memberOfJobResult()      {}
func (YieldJobDone) memberOfYieldJobResult() {}

// YieldJobFilter `yield` jobs.
type YieldJobFilter struct {
	JobType YieldJobFilterJobType `json:"jobType"`
}

func (YieldJobFilter) memberOfJobFilter()     {}
func (YieldJobFilter) told() (string, string) { return "jobType", "yield" }

type YieldJobFilterJobType string

// The values of YieldJobFilterJobType.
const (
	YieldJobFilterJobTypeYield YieldJobFilterJobType = "yield"
)

// Valid is whether e is one of YieldJobFilterJobType's values.
func (e YieldJobFilterJobType) Valid() bool {
	switch e {
	case YieldJobFilterJobTypeYield:
		return true
	}
	return false
}

// YieldJobQueuedEvent A pending `yield` job, announced with what it is asked
// to make and without its `context`.
type YieldJobQueuedEvent struct {
	JobId   JobId                      `json:"jobId"`
	JobType YieldJobQueuedEventJobType `json:"jobType"`
	// ResourceId The resource the job is about.
	ResourceId ResourceId `json:"resourceId"`
	// UserId The DID of the principal whose `job:create` created the job.
	UserId UserId               `json:"userId"`
	Params GenerationJobRequest `json:"params"`
}

func (YieldJobQueuedEvent) memberOfJobQueuedEvent() {}
func (YieldJobQueuedEvent) told() (string, string)  { return "jobType", "yield" }

type YieldJobQueuedEventJobType string

// The values of YieldJobQueuedEventJobType.
const (
	YieldJobQueuedEventJobTypeYield YieldJobQueuedEventJobType = "yield"
)

// Valid is whether e is one of YieldJobQueuedEventJobType's values.
func (e YieldJobQueuedEventJobType) Valid() bool {
	switch e {
	case YieldJobQueuedEventJobTypeYield:
		return true
	}
	return false
}

// YieldJobResult What a `yield` job reports when it concludes without
// failing: the resource it made, or a decline. Neither names its kind: a
// decline is the one with `declined`.
type YieldJobResult struct {
	union[YieldJobResultMember]
}

// YieldJobResultMember is a member of YieldJobResult: YieldJobDone,
// JobDeclined.
type YieldJobResultMember interface {
	memberOfYieldJobResult()
}

// Member is the member this value is: the one whose schema admits it.
func (u YieldJobResult) Member() (any, error) {
	return u.member("YieldJobResult", yieldJobResultMembers)
}

// yieldJobResultMembers is what each member of YieldJobResult admits, and how
// a value of it is read.
var yieldJobResultMembers = []unionMember{
	{"YieldJobDone", readAs[YieldJobDone], []signature{{kind: objectKind, required: []string{"resourceId", "resourceName", "truncated"}, allowed: []string{"resourceId", "resourceName", "truncated"}}}},
	{"JobDeclined", readAs[JobDeclined], []signature{{kind: objectKind, required: []string{"declined", "reason"}, allowed: []string{"declined", "reason"}, fixed: []fixedValues{{"declined", []any{true}}, {"reason", []any{"no-text-layer", "encrypted", "corrupt", "too-large", "empty"}}}}}},
}

// YieldUpdateCommand Bus command to update a yielded resource's storage
// content.
type YieldUpdateCommand struct {
	// UserId Authenticated user's DID, injected by the /bus/emit gateway.
	// Clients do not set this.
	UserId     *UserId    `json:"_userId,omitempty"`
	ResourceId ResourceId `json:"resourceId"`
	// StorageUri The caller's instruction for WHERE the bytes are — not a copy
	// of the stored fact. The stored location lives on the resource's primary
	// Representation (`Representation.storageUri`), which is its single home;
	// this field is the message that puts it there. Working-tree URI, only
	// file:// is supported (e.g. file://docs/overview.md).
	StorageUri      string `json:"storageUri"`
	ContentChecksum string `json:"contentChecksum"`
	ByteSize        int    `json:"byteSize"`
}

// YieldUpdateOk Success reply after updating a yielded resource, matched to
// the originating command by correlationId.
type YieldUpdateOk struct {
	// Response The updated resource's identity.
	Response YieldedResource `json:"response"`
}

// YieldedResource The resource a yield command wrote, by its id.
type YieldedResource struct {
	ResourceId ResourceId `json:"resourceId"`
}

// DiscoveryAbsentReason is why no launcher was found.
type DiscoveryAbsentReason string

const (
	// DiscoveryAbsentReasonNotFound: There is no document where it was looked
	// for: no file, an HTTP status that is not success, or a page that is not
	// JSON.
	DiscoveryAbsentReasonNotFound DiscoveryAbsentReason = "not-found"
	// DiscoveryAbsentReasonNotJson: There is a document, and it is not JSON.
	DiscoveryAbsentReasonNotJson DiscoveryAbsentReason = "not-json"
	// DiscoveryAbsentReasonInvalid: It is JSON, and not a discovery document:
	// one entry that is not what the schema says makes the whole document
	// invalid, since a partial reading would hide a running knowledge base
	// without a trace.
	DiscoveryAbsentReasonInvalid DiscoveryAbsentReason = "invalid"
	// DiscoveryAbsentReasonUnsupportedVersion: It is a discovery document of a
	// version this client does not speak, and is not read in part.
	DiscoveryAbsentReasonUnsupportedVersion DiscoveryAbsentReason = "unsupported-version"
	// DiscoveryAbsentReasonUnreadable: It could not be read at all: the file
	// could not be opened or decoded, or the request got no answer by its
	// deadline.
	DiscoveryAbsentReasonUnreadable DiscoveryAbsentReason = "unreadable"
)
