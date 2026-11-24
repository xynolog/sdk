// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/rust_types/rust_types.ml)
/// launcher.about's params.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct AboutParams {
    /// The version of the control API the request is written to.
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
}

schema!(AboutParams);

/// What the launcher is. A client asks this first, to learn whether it speaks to the launcher it found.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct AboutResult {
    /// The version stamped into the launcher at build. Absent from a development build, which states none.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub version: Option<String>,
    /// Whether this is a development build: one with no version stamped.
    pub development: bool,
    /// The commit it was built from, when stamped.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub commit: Option<String>,
    /// When it was built, when stamped.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub built: Option<String>,
    /// Each version of the control API it speaks. A client that speaks none of them stops here.
    #[serde(rename = "apiVersions")]
    pub api_versions: Vec<String>,
    /// The registry its catalog's images come from.
    #[serde(rename = "imageRegistry")]
    pub image_registry: String,
    /// Each container runtime it drives, in the order it prefers them, and whether this machine has it.
    pub runtimes: Vec<RuntimeState>,
}

impl AboutResult {
    /// The `AboutResult` that states these and nothing else.
    pub fn new(
        development: bool,
        api_versions: Vec<String>,
        image_registry: impl Into<String>,
        runtimes: Vec<RuntimeState>,
    ) -> Self {
        Self {
            version: None,
            development,
            commit: None,
            built: None,
            api_versions,
            image_registry: image_registry.into(),
            runtimes,
        }
    }
}

schema!(AboutResult);

/// Web Annotation / W3C PROV Agent. Discriminated by @type — Person, Organization, or Software (named member schemas: AgentPerson, AgentOrganization, AgentSoftware). Software peers are first-class participants, not a sub-class of Person.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Serialize)]
#[serde(untagged)]
pub enum Agent {
    Person(AgentPerson),
    Organization(AgentOrganization),
    Software(AgentSoftware),
}

impl<'de> serde::Deserialize<'de> for Agent {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("@type").and_then(serde_json::Value::as_str) {
            Some("Person") => serde_json::from_value(value).map(Agent::Person),
            Some("Organization") => serde_json::from_value(value).map(Agent::Organization),
            Some("Software") => serde_json::from_value(value).map(Agent::Software),
            _ => {
                return Err(serde::de::Error::custom(
                    "a Agent states a `@type` that is one of `Person`, `Organization`, `Software`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

member!(Agent::Person(AgentPerson));
member!(Agent::Organization(AgentOrganization));
member!(Agent::Software(AgentSoftware));
schema!(Agent);

/// An organization — the Organization branch of Agent.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct AgentOrganization {
    #[serde(rename = "@type")]
    pub r#type: AgentOrganizationType,
    #[serde(rename = "@id")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub id: Option<String>,
    pub name: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub homepage: Option<String>,
    /// Every property the schema does not name, as it came.
    #[serde(flatten)]
    pub rest: serde_json::Map<String, serde_json::Value>,
}

impl AgentOrganization {
    /// The `AgentOrganization` that states these and nothing else.
    pub fn new(name: impl Into<String>) -> Self {
        Self {
            r#type: AgentOrganizationType::Organization,
            id: None,
            name: name.into(),
            homepage: None,
            rest: serde_json::Map::new(),
        }
    }
}

schema!(AgentOrganization);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum AgentOrganizationType {
    #[serde(rename = "Organization")]
    Organization,
}

impl AgentOrganizationType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            AgentOrganizationType::Organization => "Organization",
        }
    }
}

/// A human participant — the Person branch of Agent.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct AgentPerson {
    #[serde(rename = "@type")]
    pub r#type: AgentPersonType,
    /// DID-shaped identifier (e.g. did:web:host:users:email%40host)
    #[serde(rename = "@id")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub id: Option<String>,
    /// Display name. ABSENT until resolved: a Person is identified by `@id` and nothing else, and what they are called is recorded once per change on the knowledge base's own log and filled in when a record is read. An artifact therefore never freezes a name, which is what lets a correction reach every artifact its subject ever wrote. Absent also means genuinely unknown — a DID this knowledge base has no profile for.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub name: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub nickname: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub email: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub email_sha1: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub homepage: Option<String>,
    /// Every property the schema does not name, as it came.
    #[serde(flatten)]
    pub rest: serde_json::Map<String, serde_json::Value>,
}

impl Default for AgentPerson {
    fn default() -> Self {
        Self::new()
    }
}

impl AgentPerson {
    /// The `AgentPerson` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            r#type: AgentPersonType::Person,
            id: None,
            name: None,
            nickname: None,
            email: None,
            email_sha1: None,
            homepage: None,
            rest: serde_json::Map::new(),
        }
    }
}

schema!(AgentPerson);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum AgentPersonType {
    #[serde(rename = "Person")]
    Person,
}

impl AgentPersonType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            AgentPersonType::Person => "Person",
        }
    }
}

/// A software peer, the Software branch of Agent: an agent, which is an account as a person is. Its `provider` and `model` are what it says of itself, attributed to it and not checked; the knowledge base reads neither from its DID. Its `name` is no part of what it writes: what it last said it is called is its profile, and readers fill it in, as they do a person's. A generator the knowledge base supplies, for an agent that supplied none, carries `@type` and `@id` alone.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct AgentSoftware {
    #[serde(rename = "@type")]
    pub r#type: AgentSoftwareType,
    /// The agent's DID: did:web:<domain>:agents:<subject>, its account at the knowledge base's issuer
    #[serde(rename = "@id")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub id: Option<String>,
    /// What the agent last said it is called. ABSENT until resolved: filled in from its profile when a record is read, as a Person's name is. Absent also where it has said nothing. Not parsed.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub name: Option<String>,
    /// Inference provider (e.g. ollama, anthropic)
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub provider: Option<String>,
    /// Model identifier (e.g. gemma2:27b, claude-3-5-sonnet)
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub model: Option<String>,
    /// Inference parameters (temperature, maxTokens, systemPrompt, etc.). Runtime metadata, not part of identity.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub parameters: Option<serde_json::Map<String, serde_json::Value>>,
    /// Every property the schema does not name, as it came.
    #[serde(flatten)]
    pub rest: serde_json::Map<String, serde_json::Value>,
}

impl Default for AgentSoftware {
    fn default() -> Self {
        Self::new()
    }
}

impl AgentSoftware {
    /// The `AgentSoftware` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            r#type: AgentSoftwareType::Software,
            id: None,
            name: None,
            provider: None,
            model: None,
            parameters: None,
            rest: serde_json::Map::new(),
        }
    }
}

schema!(AgentSoftware);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum AgentSoftwareType {
    #[serde(rename = "Software")]
    Software,
}

impl AgentSoftwareType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            AgentSoftwareType::Software => "Software",
        }
    }
}

/// How a quoted selection was found in a text. Which word a span is found by is reconcile's rule (specs/src/annotations/reconcile-cases.json).
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum AnchorMethod {
    #[serde(rename = "unique-match")]
    UniqueMatch,
    #[serde(rename = "context-recovered")]
    ContextRecovered,
    #[serde(rename = "first-of-many")]
    FirstOfMany,
    #[serde(rename = "fuzzy-match")]
    FuzzyMatch,
}

impl AnchorMethod {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            AnchorMethod::UniqueMatch => "unique-match",
            AnchorMethod::ContextRecovered => "context-recovered",
            AnchorMethod::FirstOfMany => "first-of-many",
            AnchorMethod::FuzzyMatch => "fuzzy-match",
        }
    }
}

schema!(AnchorMethod);

/// Where a clicked annotation's element is on the viewer's screen: its rectangle in viewport pixels, as a DOM rectangle states it. A viewer's own geometry: it rides a viewer's local frames, and a frame another participant's screen receives carries none.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct AnchorRect {
    /// The rectangle's horizontal origin.
    pub x: f64,
    /// The rectangle's vertical origin.
    pub y: f64,
    /// The rectangle's width.
    pub width: f64,
    /// The rectangle's height.
    pub height: f64,
    /// The rectangle's top edge.
    pub top: f64,
    /// The rectangle's right edge.
    pub right: f64,
    /// The rectangle's bottom edge.
    pub bottom: f64,
    /// The rectangle's left edge.
    pub left: f64,
}

schema!(AnchorRect);

/// Text paired with the geometry that indexes it — the minimum needed to turn a range of the text, two offsets counted in Unicode code points, into a selection, or a rectangle into a quote. Whole-resource: a producer iterates page by page, but every consumer wants one map.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct AnchoredText {
    /// Reading-order text of the whole resource.
    pub text: String,
    /// Positioned runs indexing `text`, roughly one per word.
    pub items: Vec<PdfTextItem>,
}

schema!(AnchoredText);

/// There is no coordinate map to serve, and WHY — the distinction a bare null could not carry.
///
/// One member covers all three absences because none carries a payload; `kind` alone is the fact. Retryability is legible from the name, deliberately: a caller must not need a lookup table to decide whether to come back.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct AnchoredTextAbsent {
    /// Discriminant, sharing the `kind` field with the ExtractedText/ExtractionDeclined members so the whole answer is one flat union.
    ///
    /// `not-yet` — the resource's media type has text that is derived by reading its content, and the store holds no entry for this content: the Smelter has not read it yet, or the entry was lost (a loss the Smelter's reconcile pass re-derives). RETRY.
    ///
    /// `no-map` — the resource's media type has no derived text, so no entry exists and none will until the type is given a reader. Decided by the media type alone, and answered at once. TERMINAL.
    ///
    /// `unknown` — no content identity to look up: the resource is not in the view store, or its primary representation carries no checksum. TERMINAL.
    pub kind: AnchoredTextAbsentKind,
}

schema!(AnchoredTextAbsent);

/// Discriminant, sharing the `kind` field with the ExtractedText/ExtractionDeclined members so the whole answer is one flat union.
///
/// `not-yet` — the resource's media type has text that is derived by reading its content, and the store holds no entry for this content: the Smelter has not read it yet, or the entry was lost (a loss the Smelter's reconcile pass re-derives). RETRY.
///
/// `no-map` — the resource's media type has no derived text, so no entry exists and none will until the type is given a reader. Decided by the media type alone, and answered at once. TERMINAL.
///
/// `unknown` — no content identity to look up: the resource is not in the view store, or its primary representation carries no checksum. TERMINAL.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum AnchoredTextAbsentKind {
    #[serde(rename = "not-yet")]
    NotYet,
    #[serde(rename = "no-map")]
    NoMap,
    #[serde(rename = "unknown")]
    Unknown,
}

impl AnchoredTextAbsentKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            AnchoredTextAbsentKind::NotYet => "not-yet",
            AnchoredTextAbsentKind::NoMap => "no-map",
            AnchoredTextAbsentKind::Unknown => "unknown",
        }
    }
}

/// What a reader gets when it asks for a resource's coordinate map: the map, a stored decline, or a named absence.
///
/// Distinct from `ExtractionOutcome` on purpose. That type is what the STORE holds and what an extractor RETURNS — neither of which can ever be 'not yet'. This is the read answer, which can, so widening ExtractionOutcome itself would have put an impossible state into the store's own type.
///
/// Flat, one discriminant: every member carries `kind`, rather than nesting an outcome inside a status envelope and giving the wire two `kind` fields at different depths.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum AnchoredTextAnswer {
    ExtractedText(ExtractedText),
    ExtractionDeclined(ExtractionDeclined),
    AnchoredTextAbsent(AnchoredTextAbsent),
}

member!(AnchoredTextAnswer::ExtractedText(ExtractedText));
member!(AnchoredTextAnswer::ExtractionDeclined(ExtractionDeclined));
member!(AnchoredTextAnswer::AnchoredTextAbsent(AnchoredTextAbsent));
schema!(AnchoredTextAnswer);

/// The bytes were declined: no text is extracted from them.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct AnchoredTextDeclinedEntry {
    /// The entry format.
    pub v: i64,
    /// The stamp the entry was derived under: the PDF reader's and the OCR engine's. A reader takes the entry only when it equals the stamp the Smelter last stated.
    pub stamp: String,
    /// Why extraction yielded nothing, by class.
    pub declined: ExtractionDeclinedReason,
}

impl AnchoredTextDeclinedEntry {
    /// The one `v` a `AnchoredTextDeclinedEntry` states.
    pub const V: i64 = 3;

    /// The `AnchoredTextDeclinedEntry` that states these and nothing else.
    pub fn new(stamp: impl Into<String>, declined: ExtractionDeclinedReason) -> Self {
        Self {
            v: Self::V,
            stamp: stamp.into(),
            declined,
        }
    }
}

schema!(AnchoredTextDeclinedEntry);

/// The keys of the entries the anchored-text store holds under the stamp last stated: one checksum for each set of bytes whose text is stored, in no order.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct AnchoredTextEntries {
    pub checksums: Vec<String>,
}

schema!(AnchoredTextEntries);

/// One entry of the anchored-text store: the file `<ab>/<cd>/<key>.json` under the store's directory, where the key is the SHA-256 of the bytes the text was extracted from, in hex. The Smelter derives it and stores it over the Archivist's HTTP surface (`AnchoredTextWrite`); the Archivist writes it, as compact JSON with `v` and `stamp` first, to a sibling temporary file renamed onto the path. The stamp the Smelter states (`AnchoredTextStamp`) is kept, followed by a newline, in the file `STAMP` at the store's root.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum AnchoredTextEntry {
    ExtractedEntry(AnchoredTextExtractedEntry),
    DeclinedEntry(AnchoredTextDeclinedEntry),
}

member!(AnchoredTextEntry::ExtractedEntry(
    AnchoredTextExtractedEntry,
));
member!(AnchoredTextEntry::DeclinedEntry(AnchoredTextDeclinedEntry));
schema!(AnchoredTextEntry);

/// The text extracted from the bytes, where each word is on the page, and how it was extracted.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct AnchoredTextExtractedEntry {
    /// The entry format.
    pub v: i64,
    /// The stamp the entry was derived under: the PDF reader's and the OCR engine's. A reader takes the entry only when it equals the stamp the Smelter last stated.
    pub stamp: String,
    /// The extracted text.
    pub text: String,
    /// Where each word of `text` is, line by line, in reading order.
    pub lines: Vec<AnchoredTextExtractedEntryLinesItem>,
    /// How the text was extracted.
    pub method: ExtractionMethod,
    /// PDF classification, when the source was a PDF.
    #[serde(rename = "pdfClass")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub pdf_class: Option<PdfClass>,
    /// How well the engine read the pixels, when any of this text came from OCR.
    #[serde(rename = "ocrConfidence")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub ocr_confidence: Option<OcrConfidence>,
    /// 1-indexed pages this extraction could not read — present only for partially covered documents (class C).
    #[serde(rename = "unreadPages")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub unread_pages: Option<Vec<i64>>,
}

impl AnchoredTextExtractedEntry {
    /// The one `v` a `AnchoredTextExtractedEntry` states.
    pub const V: i64 = 3;

    /// The `AnchoredTextExtractedEntry` that states these and nothing else.
    pub fn new(
        stamp: impl Into<String>,
        text: impl Into<String>,
        lines: Vec<AnchoredTextExtractedEntryLinesItem>,
        method: ExtractionMethod,
    ) -> Self {
        Self {
            v: Self::V,
            stamp: stamp.into(),
            text: text.into(),
            lines,
            method,
            pdf_class: None,
            ocr_confidence: None,
            unread_pages: None,
        }
    }
}

schema!(AnchoredTextExtractedEntry);

/// One line of text: the words that share a page, a baseline and a height.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct AnchoredTextExtractedEntryLinesItem {
    /// The page, counted from 1.
    pub p: i64,
    /// The line's vertical position in PDF points, from the bottom of the page.
    pub y: f64,
    /// The line's height in PDF points.
    pub h: f64,
    /// Each word as `[x, width, start, end]`: its horizontal position and width in PDF points, and the offsets of its text in `text`, which are whole numbers of Unicode code points from the start of `text`.
    pub words: Vec<Vec<f64>>,
}

/// The stamp an anchored-text store's entries are taken under: which PDF reader and which OCR engine derived them. Its writer states it before it writes or lists an entry; an entry stored under another stamp is answered to no reader.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct AnchoredTextStamp {
    /// The stamp: no white space, since it is held in a file of one line.
    pub stamp: String,
}

schema!(AnchoredTextStamp);

/// A write of an anchored-text entry for the bytes of one resource: what the Smelter derived from them, and their checksum. The Archivist files the entry under the checksum, so every resource whose bytes those are has it, and refuses the write when the resource's first representation has other bytes.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct AnchoredTextWrite {
    /// The SHA-256 of the bytes the text was derived from, as 64 lower-case hexadecimal digits: the key the entry is filed under.
    #[serde(rename = "contentChecksum")]
    pub content_checksum: String,
    pub entry: AnchoredTextEntry,
}

schema!(AnchoredTextWrite);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct Annotation {
    /// W3C Web Annotation JSON-LD context
    #[serde(rename = "@context")]
    pub context: AnnotationContext,
    /// W3C Annotation type
    pub r#type: AnnotationType,
    pub id: AnnotationId,
    pub motivation: Motivation,
    /// W3C Web Annotation target: the id of the resource annotated, when the whole of it is, or an object with source and optional selector (fragment)
    pub target: AnnotationTargetValue,
    /// W3C Web Annotation body. Optional per the W3C spec — annotations whose motivation alone is meaningful (highlighting) legitimately omit it. Present values are either a single body or a non-empty array of bodies; there is no empty array.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub body: Option<AnnotationBodies>,
    /// Web Annotation creator — who requested the annotation. DERIVED by the knowledge base at write time, never accepted from an emitter (a payload carrying it is refused): the verified emitter of the write, or, when the write cites a job, the verified emitter of the job:create that produced it. A Person for human-requested work; a Software peer for autonomous-agent work.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub creator: Option<Agent>,
    /// When the annotation was MADE — the authoring moment, carried from the event that created it. Not when a projection happened to write it: a store that rebuilds from the log must preserve this value, never restamp it.
    pub created: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub modified: Option<String>,
    /// Web Annotation generator — the Software peer that produced the annotation, when software did. Absent for a person's own annotation. An emitter may supply it to carry the model's parameters, but its identity must be the emitter's own: the knowledge base refuses a generator naming anyone else, and supplies it from the verified emitter when omitted. One producer per write — a write carrying the array form is refused.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub generator: Option<OneOrMoreAgents>,
    /// PROV-O wasAttributedTo — every party responsible for this annotation, DERIVED by the knowledge base from `creator` and the verified executor of the write: `[creator, generator]` when one agent requested the work and software produced it; collapsed to the one agent when requester and producer are the same. Never accepted from an emitter.
    #[serde(rename = "wasAttributedTo")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub was_attributed_to: Option<OneOrMoreAgents>,
}

impl Annotation {
    /// The `Annotation` that states these and nothing else.
    pub fn new(
        id: AnnotationId,
        motivation: Motivation,
        target: AnnotationTargetValue,
        created: impl Into<String>,
    ) -> Self {
        Self {
            context: AnnotationContext::HttpWwwW3OrgNsAnnoJsonld,
            r#type: AnnotationType::Annotation,
            id,
            motivation,
            target,
            body: None,
            creator: None,
            created: created.into(),
            modified: None,
            generator: None,
            was_attributed_to: None,
        }
    }
}

schema!(Annotation);

/// Payload for mark:added domain event
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct AnnotationAddedPayload {
    pub annotation: Annotation,
    /// SHA-256 of resource content at annotation time
    #[serde(rename = "contentChecksum")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub content_checksum: Option<String>,
}

impl AnnotationAddedPayload {
    /// The `AnnotationAddedPayload` that states these and nothing else.
    pub fn new(annotation: Annotation) -> Self {
        Self {
            annotation,
            content_checksum: None,
        }
    }
}

schema!(AnnotationAddedPayload);

/// What an annotation's `body` holds: one body, or a non-empty list of them. There is no empty list: an annotation with nothing to say has no `body`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum AnnotationBodies {
    AnnotationBody(AnnotationBody),
    List(Vec<AnnotationBody>),
}

member!(AnnotationBodies::AnnotationBody(AnnotationBody));
schema!(AnnotationBodies);

/// An annotation's body: a TextualBody carries text the annotation states (entity tags, descriptions, comments), a SpecificResource points at what it links to. Tell them apart by `type`, which is required on both and single-valued — a consumer never has to probe for which fields happen to be present.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Serialize)]
#[serde(untagged)]
pub enum AnnotationBody {
    TextualBody(TextualBody),
    SpecificResource(SpecificResource),
}

impl<'de> serde::Deserialize<'de> for AnnotationBody {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("type").and_then(serde_json::Value::as_str) {
            Some("TextualBody") => serde_json::from_value(value).map(AnnotationBody::TextualBody),
            Some("SpecificResource") => {
                serde_json::from_value(value).map(AnnotationBody::SpecificResource)
            }
            _ => {
                return Err(serde::de::Error::custom(
                    "a AnnotationBody states a `type` that is one of `TextualBody`, `SpecificResource`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

member!(AnnotationBody::TextualBody(TextualBody));
member!(AnnotationBody::SpecificResource(SpecificResource));
schema!(AnnotationBody);

/// Payload for mark:body-updated domain event
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct AnnotationBodyUpdatedPayload {
    #[serde(rename = "annotationId")]
    pub annotation_id: AnnotationId,
    pub operations: Vec<BodyOperation>,
}

schema!(AnnotationBodyUpdatedPayload);

/// W3C Web Annotation JSON-LD context
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum AnnotationContext {
    #[serde(rename = "http://www.w3.org/ns/anno.jsonld")]
    HttpWwwW3OrgNsAnnoJsonld,
}

impl AnnotationContext {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            AnnotationContext::HttpWwwW3OrgNsAnnoJsonld => "http://www.w3.org/ns/anno.jsonld",
        }
    }
}

/// An annotation's id: a name, never the annotation's URI. 1 to 128 of the letters `A`–`Z` and `a`–`z`, the digits, `_` and `-`. It is one segment of a URL and one name in a file system, and it is held to that wherever it enters: a gateway refuses a payload that carries anything else. How one is made is no part of the rule.
#[derive(
    Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
#[serde(try_from = "String", into = "String")]
pub struct AnnotationId(String);

impl AnnotationId {
    /// The rule a value is held to, as the spec writes it.
    pub const PATTERN: &'static str = "^[A-Za-z0-9_-]{1,128}$";

    /// The pattern as the rule `new` holds a value to.
    const RULE: Rule = Rule {
        prefix: "",
        admitted: Admitted::Of(&[('A', 'Z'), ('a', 'z'), ('0', '9'), ('_', '_'), ('-', '-')]),
        least: 1,
        most: Some(128),
    };

    /// `value` as a `AnnotationId`, or that it is not one.
    pub fn new(value: impl Into<String>) -> Result<AnnotationId, InvalidIdentifier> {
        let value = value.into();
        if AnnotationId::RULE.admits(&value) {
            Ok(AnnotationId(value))
        } else {
            Err(InvalidIdentifier {
                kind: "AnnotationId",
                pattern: AnnotationId::PATTERN,
                value,
            })
        }
    }

    pub fn as_str(&self) -> &str {
        &self.0
    }
}

impl std::fmt::Display for AnnotationId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(&self.0)
    }
}

impl std::ops::Deref for AnnotationId {
    type Target = str;

    fn deref(&self) -> &str {
        &self.0
    }
}

impl AsRef<str> for AnnotationId {
    fn as_ref(&self) -> &str {
        &self.0
    }
}

impl std::str::FromStr for AnnotationId {
    type Err = InvalidIdentifier;

    fn from_str(value: &str) -> Result<AnnotationId, InvalidIdentifier> {
        AnnotationId::new(value)
    }
}

impl TryFrom<String> for AnnotationId {
    type Error = InvalidIdentifier;

    fn try_from(value: String) -> Result<AnnotationId, InvalidIdentifier> {
        AnnotationId::new(value)
    }
}

impl From<AnnotationId> for String {
    fn from(id: AnnotationId) -> String {
        id.0
    }
}

impl PartialEq<str> for AnnotationId {
    fn eq(&self, other: &str) -> bool {
        self.0 == other
    }
}

impl PartialEq<&str> for AnnotationId {
    fn eq(&self, other: &&str) -> bool {
        self.0 == *other
    }
}

schema!(AnnotationId);

/// Payload for mark:removed domain event
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct AnnotationRemovedPayload {
    #[serde(rename = "annotationId")]
    pub annotation_id: AnnotationId,
}

schema!(AnnotationRemovedPayload);

/// What a target's `selector` holds: one W3C selector, or several of the same segment.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum AnnotationSelector {
    Selector(Selector),
    List(Vec<Selector>),
}

member!(AnnotationSelector::Selector(Selector));
schema!(AnnotationSelector);

/// W3C Web Annotation target object - source is required, selector is optional
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct AnnotationTarget {
    /// Stated by the annotation of a span: the target is a part of its source, which the selector picks out. An annotation of a resource as a whole states none.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub r#type: Option<AnnotationTargetType>,
    /// The id of the resource being annotated
    pub source: ResourceId,
    /// Optional selector to identify a specific segment of the source resource
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub selector: Option<AnnotationSelector>,
}

impl AnnotationTarget {
    /// The `AnnotationTarget` that states these and nothing else.
    pub fn new(source: ResourceId) -> Self {
        Self {
            r#type: None,
            source,
            selector: None,
        }
    }
}

schema!(AnnotationTarget);

/// Stated by the annotation of a span: the target is a part of its source, which the selector picks out. An annotation of a resource as a whole states none.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum AnnotationTargetType {
    #[serde(rename = "SpecificResource")]
    SpecificResource,
}

impl AnnotationTargetType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            AnnotationTargetType::SpecificResource => "SpecificResource",
        }
    }
}

/// W3C Web Annotation target: the id of the resource annotated, when the whole of it is, or an object with source and optional selector (fragment)
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum AnnotationTargetValue {
    ResourceId(ResourceId),
    AnnotationTarget(AnnotationTarget),
}

member!(AnnotationTargetValue::AnnotationTarget(AnnotationTarget));

/// W3C Annotation type
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum AnnotationType {
    #[serde(rename = "Annotation")]
    Annotation,
}

impl AnnotationType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            AnnotationType::Annotation => "Annotation",
        }
    }
}

/// The group and version of the control API. Every request's params state it; a launcher refuses a version it does not speak with control.unsupported-api-version, and names the ones it does.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ApiVersion {
    #[serde(rename = "control.xynolog.org/v1alpha1")]
    ControlXynologOrgV1alpha1,
}

impl ApiVersion {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ApiVersion::ControlXynologOrgV1alpha1 => "control.xynolog.org/v1alpha1",
        }
    }
}

schema!(ApiVersion);

/// Everything the Archivist reads at boot: nothing in it is defaulted by the Archivist. The launcher writes it for the Archivist it starts, from the knowledge base's stack documents, and the Archivist reads it from the path its `--config` flag names (its image passes `/etc/xynolog/archivist.json`). Started without `--config`, or with a path that names no file, the Archivist refuses to start and says which. No secret is a value here. What the knowledge base says of itself is not here either: its name, its `site.domain` and its `git.sync` are read from the committed `.xynolog/config.yaml` of the tree at `root`. The Archivist's other inputs are the environment variables specs/src/service-environment/variables.json lists for it. A document that does not validate is refused at boot, naming each failing field.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistConfig {
    /// The URL the Archivist reaches the gateway at: its only route to the bus.
    #[serde(rename = "gatewayUrl")]
    pub gateway_url: String,
    /// The issuer the Archivist's service account signs in at, and whose tokens it admits callers of its HTTP surface by.
    pub identity: ServiceIdentity,
    /// The knowledge base's working tree: the directory holding `.xynolog/`. The event log, the content and the committed config are under it.
    pub root: String,
    /// The state volume, this knowledge base's alone: the Archivist keeps the knowledge base's views and projections in it, at its top.
    #[serde(rename = "stateHome")]
    pub state_home: String,
    /// The anchored-text store, which only the Archivist mounts: the Smelter stores each entry in it over HTTP, and the Archivist serves it.
    #[serde(rename = "anchoredTextDir")]
    pub anchored_text_dir: String,
    pub engines: ArchivistEngines,
    /// The port the Archivist's HTTP surface answers on, `/health` included.
    pub port: u16,
    /// Whether the Archivist serves the views it finds at boot instead of rebuilding them from the event log first.
    #[serde(rename = "skipRebuild")]
    pub skip_rebuild: bool,
    /// The bounds on how far the staging driver may run behind the working tree, in milliseconds. A knowledge base that does not sync git stages nothing, and reads neither.
    pub staging: ArchivistConfigStaging,
    #[serde(rename = "logLevel")]
    pub log_level: LogLevel,
    #[serde(rename = "logFormat")]
    pub log_format: LogFormat,
}

schema!(ArchivistConfig);

/// The bounds on how far the staging driver may run behind the working tree, in milliseconds. A knowledge base that does not sync git stages nothing, and reads neither.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistConfigStaging {
    /// The quiet period after the last change before pending changes are staged.
    #[serde(rename = "flushMs")]
    pub flush_ms: u64,
    /// The longest a change waits to be staged while others keep arriving, measured from the oldest pending change.
    #[serde(rename = "maxWaitMs")]
    pub max_wait_ms: u64,
}

/// archivist/default-entity-types.json: the entity types an Archivist seeds, in the order it seeds them.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistDefaultEntityTypes {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    /// The default entity types, in seed order.
    #[serde(rename = "entityTypes")]
    pub entity_types: Vec<String>,
}

schema!(ArchivistDefaultEntityTypes);

/// The engine for each job and each Librarian actor, behind `browse:engines`: a provider and a model, and no credential. It is the knowledge base's Inference document's `engines` as they stand, with no fallback, so a job or an actor absent here has no engine.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistEngines {
    /// The engine each job is done with when software does it, keyed as a job description is: by `jobType`, and for `mark` by motivation.
    pub jobs: ArchivistEnginesJobs,
    /// The engine each Librarian actor that calls a model asks.
    pub actors: ArchivistEnginesActors,
}

schema!(ArchivistEngines);

/// The engine each Librarian actor that calls a model asks.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistEnginesActors {
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub gatherer: Option<Engine>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub matcher: Option<Engine>,
}

/// The engine each job is done with when software does it, keyed as a job description is: by `jobType`, and for `mark` by motivation.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistEnginesJobs {
    /// The engine for `mark` jobs of each motivation.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub mark: Option<ArchivistEnginesJobsMark>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub r#yield: Option<Engine>,
}

/// The engine for `mark` jobs of each motivation.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistEnginesJobsMark {
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub highlighting: Option<Engine>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub commenting: Option<Engine>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub assessing: Option<Engine>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub linking: Option<Engine>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub tagging: Option<Engine>,
}

/// A page of one stream's events from one sequence number, inclusive, in log order, and the sequence number of the stream's last event: the Archivist's answer to `GET /events/{resourceId}`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct ArchivistEventsResponse {
    pub events: Vec<StoredEventResponse>,
    /// The sequence number of the stream's last event when it was read: 0 for a stream with none. More events follow the page while its last event's number is below it.
    #[serde(rename = "lastSequence")]
    pub last_sequence: u64,
}

schema!(ArchivistEventsResponse);

/// The Archivist's liveness answer: it serves, and the actors it hosts.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct ArchivistHealth {
    pub status: ArchivistHealthStatus,
    /// The record actors this process hosts: each of the enum's, once, in the order the enum lists them.
    pub actors: Vec<ArchivistHealthActorsItem>,
}

impl ArchivistHealth {
    /// The `ArchivistHealth` that states these and nothing else.
    pub fn new(actors: Vec<ArchivistHealthActorsItem>) -> Self {
        Self {
            status: ArchivistHealthStatus::Ok,
            actors,
        }
    }
}

schema!(ArchivistHealth);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ArchivistHealthActorsItem {
    #[serde(rename = "stower")]
    Stower,
    #[serde(rename = "browser")]
    Browser,
    #[serde(rename = "cloneTokenManager")]
    CloneTokenManager,
}

impl ArchivistHealthActorsItem {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ArchivistHealthActorsItem::Stower => "stower",
            ArchivistHealthActorsItem::Browser => "browser",
            ArchivistHealthActorsItem::CloneTokenManager => "cloneTokenManager",
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ArchivistHealthStatus {
    #[serde(rename = "ok")]
    Ok,
}

impl ArchivistHealthStatus {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ArchivistHealthStatus::Ok => "ok",
        }
    }
}

/// archivist/layout.json: where the Archivist keeps the record on disk.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistLayout {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    /// A resource's event stream: a directory of event files.
    #[serde(rename = "eventStream")]
    pub event_stream: ArchivistLayoutEventStream,
    /// The knowledge base's own stream, of the events that name no resource. It is not sharded.
    #[serde(rename = "systemStream")]
    pub system_stream: ArchivistLayoutSystemStream,
    /// The files of a stream.
    #[serde(rename = "eventFile")]
    pub event_file: ArchivistLayoutEventFile,
    /// The schema a stored event, one line of an event file, is.
    #[serde(rename = "storedEvent")]
    pub stored_event: serde_json::Value,
    /// A resource's view, in the state directory.
    pub view: ArchivistLayoutView,
    /// The projections of what the `__system__` stream adds up to, in the state directory.
    #[serde(rename = "systemProjections")]
    pub system_projections: ArchivistLayoutSystemProjections,
    /// An entry of the storage-uri index, which names the resource whose content is at a storage URI.
    #[serde(rename = "storageUriIndex")]
    pub storage_uri_index: ArchivistLayoutStorageUriIndex,
    /// An entry of the anchored-text store, keyed by the checksum of the content it was extracted from.
    #[serde(rename = "anchoredTextEntry")]
    pub anchored_text_entry: ArchivistLayoutAnchoredTextEntry,
    /// The file holding the stamp the anchored-text store's entries are taken under: the stamp, followed by a newline.
    #[serde(rename = "anchoredTextStamp")]
    pub anchored_text_stamp: ArchivistLayoutAnchoredTextStamp,
}

schema!(ArchivistLayout);

/// An entry of the anchored-text store, keyed by the checksum of the content it was extracted from.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistLayoutAnchoredTextEntry {
    /// The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store.
    pub tree: ArchivistLayoutAnchoredTextEntryTree,
    /// Its path in its tree, `/`-separated.
    pub path: String,
    /// The schema an entry is.
    pub schema: serde_json::Value,
}

/// The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ArchivistLayoutAnchoredTextEntryTree {
    #[serde(rename = "root")]
    Root,
    #[serde(rename = "stateHome")]
    StateHome,
    #[serde(rename = "anchoredTextDir")]
    AnchoredTextDir,
}

impl ArchivistLayoutAnchoredTextEntryTree {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ArchivistLayoutAnchoredTextEntryTree::Root => "root",
            ArchivistLayoutAnchoredTextEntryTree::StateHome => "stateHome",
            ArchivistLayoutAnchoredTextEntryTree::AnchoredTextDir => "anchoredTextDir",
        }
    }
}

/// The file holding the stamp the anchored-text store's entries are taken under: the stamp, followed by a newline.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistLayoutAnchoredTextStamp {
    /// The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store.
    pub tree: ArchivistLayoutAnchoredTextStampTree,
    /// Its path in its tree, `/`-separated.
    pub path: String,
}

/// The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ArchivistLayoutAnchoredTextStampTree {
    #[serde(rename = "root")]
    Root,
    #[serde(rename = "stateHome")]
    StateHome,
    #[serde(rename = "anchoredTextDir")]
    AnchoredTextDir,
}

impl ArchivistLayoutAnchoredTextStampTree {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ArchivistLayoutAnchoredTextStampTree::Root => "root",
            ArchivistLayoutAnchoredTextStampTree::StateHome => "stateHome",
            ArchivistLayoutAnchoredTextStampTree::AnchoredTextDir => "anchoredTextDir",
        }
    }
}

/// The files of a stream.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistLayoutEventFile {
    /// A file's name, `{number}` its number in `digits` decimal digits.
    pub name: String,
    /// How many decimal digits a file's number is written in, with leading zeros.
    pub digits: u64,
    /// The first file's number. It is created, empty, with the stream's directory.
    pub first: u64,
    /// The most events a file holds.
    #[serde(rename = "maxEvents")]
    pub max_events: u64,
}

/// A resource's event stream: a directory of event files.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistLayoutEventStream {
    /// The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store.
    pub tree: ArchivistLayoutEventStreamTree,
    /// Its path in its tree, `/`-separated.
    pub path: String,
}

/// The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ArchivistLayoutEventStreamTree {
    #[serde(rename = "root")]
    Root,
    #[serde(rename = "stateHome")]
    StateHome,
    #[serde(rename = "anchoredTextDir")]
    AnchoredTextDir,
}

impl ArchivistLayoutEventStreamTree {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ArchivistLayoutEventStreamTree::Root => "root",
            ArchivistLayoutEventStreamTree::StateHome => "stateHome",
            ArchivistLayoutEventStreamTree::AnchoredTextDir => "anchoredTextDir",
        }
    }
}

/// An entry of the storage-uri index, which names the resource whose content is at a storage URI.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistLayoutStorageUriIndex {
    /// The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store.
    pub tree: ArchivistLayoutStorageUriIndexTree,
    /// Its path in its tree, `/`-separated.
    pub path: String,
    /// The schema an entry is.
    pub schema: serde_json::Value,
}

/// The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ArchivistLayoutStorageUriIndexTree {
    #[serde(rename = "root")]
    Root,
    #[serde(rename = "stateHome")]
    StateHome,
    #[serde(rename = "anchoredTextDir")]
    AnchoredTextDir,
}

impl ArchivistLayoutStorageUriIndexTree {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ArchivistLayoutStorageUriIndexTree::Root => "root",
            ArchivistLayoutStorageUriIndexTree::StateHome => "stateHome",
            ArchivistLayoutStorageUriIndexTree::AnchoredTextDir => "anchoredTextDir",
        }
    }
}

/// The projections of what the `__system__` stream adds up to, in the state directory.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistLayoutSystemProjections {
    /// The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store.
    pub tree: ArchivistLayoutSystemProjectionsTree,
    /// The directory that holds them, in its tree, `/`-separated.
    pub path: String,
    /// Each projection's file.
    pub files: Vec<ArchivistLayoutSystemProjectionsFilesItem>,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistLayoutSystemProjectionsFilesItem {
    /// The file's name.
    pub name: String,
    /// The schema the projection is.
    pub schema: serde_json::Value,
}

/// The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ArchivistLayoutSystemProjectionsTree {
    #[serde(rename = "root")]
    Root,
    #[serde(rename = "stateHome")]
    StateHome,
    #[serde(rename = "anchoredTextDir")]
    AnchoredTextDir,
}

impl ArchivistLayoutSystemProjectionsTree {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ArchivistLayoutSystemProjectionsTree::Root => "root",
            ArchivistLayoutSystemProjectionsTree::StateHome => "stateHome",
            ArchivistLayoutSystemProjectionsTree::AnchoredTextDir => "anchoredTextDir",
        }
    }
}

/// The knowledge base's own stream, of the events that name no resource. It is not sharded.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistLayoutSystemStream {
    /// The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store.
    pub tree: ArchivistLayoutSystemStreamTree,
    /// Its path in its tree, `/`-separated.
    pub path: String,
}

/// The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ArchivistLayoutSystemStreamTree {
    #[serde(rename = "root")]
    Root,
    #[serde(rename = "stateHome")]
    StateHome,
    #[serde(rename = "anchoredTextDir")]
    AnchoredTextDir,
}

impl ArchivistLayoutSystemStreamTree {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ArchivistLayoutSystemStreamTree::Root => "root",
            ArchivistLayoutSystemStreamTree::StateHome => "stateHome",
            ArchivistLayoutSystemStreamTree::AnchoredTextDir => "anchoredTextDir",
        }
    }
}

/// A resource's view, in the state directory.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistLayoutView {
    /// The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store.
    pub tree: ArchivistLayoutViewTree,
    /// Its path in its tree, `/`-separated.
    pub path: String,
    /// The schema a view is.
    pub schema: serde_json::Value,
}

/// The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ArchivistLayoutViewTree {
    #[serde(rename = "root")]
    Root,
    #[serde(rename = "stateHome")]
    StateHome,
    #[serde(rename = "anchoredTextDir")]
    AnchoredTextDir,
}

impl ArchivistLayoutViewTree {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ArchivistLayoutViewTree::Root => "root",
            ArchivistLayoutViewTree::StateHome => "stateHome",
            ArchivistLayoutViewTree::AnchoredTextDir => "anchoredTextDir",
        }
    }
}

/// archivist/messages.json: the words of the Archivist's own refusals, and of the messages it logs that a reader relies on.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistMessages {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    /// Each refusal to start of the Archivist's own, written in service-environment/boot-refusals.json's `line`.
    pub boot: Vec<ArchivistMessagesBootItem>,
    /// The failure a reply that cannot be sent is answered with instead, on the operation's failure channel.
    pub unsent: Vec<ArchivistMessagesUnsentItem>,
    /// Each refusal of an operation, on the operation's failure channel.
    pub refusals: Vec<ArchivistMessagesRefusalsItem>,
    /// The refusal of every route of the HTTP surface but `/health`: a token that is missing, or not of the knowledge base's issuer and audience, or without the service role.
    pub unauthorized: ArchivistMessagesUnauthorized,
    /// Each other error a route of the HTTP surface answers with.
    pub http: Vec<ArchivistMessagesHttpItem>,
    /// Each message the Archivist logs that a reader of its output relies on.
    pub logged: Vec<ArchivistMessagesLoggedItem>,
}

schema!(ArchivistMessages);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistMessagesBootItem {
    /// The situation's name.
    pub name: String,
    /// When it is written, and what fills each `{name}` of its text.
    pub situation: String,
    /// The refusal, in place of the line's `{refusal}`. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.
    pub refusal: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistMessagesHttpItem {
    /// The situation's name.
    pub name: String,
    /// The route's method.
    pub method: ArchivistMessagesHttpItemMethod,
    /// The route, as the Archivist's API names its path.
    pub route: String,
    pub status: HttpStatus,
    /// The body's `code`, where it carries one.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub code: Option<String>,
    /// When it is written, and what fills each `{name}` of its text.
    pub situation: String,
    /// The body's `error`. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.
    pub error: String,
}

impl ArchivistMessagesHttpItem {
    /// The `ArchivistMessagesHttpItem` that states these and nothing else.
    pub fn new(
        name: impl Into<String>,
        method: ArchivistMessagesHttpItemMethod,
        route: impl Into<String>,
        status: HttpStatus,
        situation: impl Into<String>,
        error: impl Into<String>,
    ) -> Self {
        Self {
            name: name.into(),
            method,
            route: route.into(),
            status,
            code: None,
            situation: situation.into(),
            error: error.into(),
        }
    }
}

/// The route's method.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ArchivistMessagesHttpItemMethod {
    #[serde(rename = "GET")]
    GET,
    #[serde(rename = "PUT")]
    PUT,
    #[serde(rename = "POST")]
    POST,
}

impl ArchivistMessagesHttpItemMethod {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ArchivistMessagesHttpItemMethod::GET => "GET",
            ArchivistMessagesHttpItemMethod::PUT => "PUT",
            ArchivistMessagesHttpItemMethod::POST => "POST",
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistMessagesLoggedItem {
    /// The situation's name.
    pub name: String,
    pub level: LogLevel,
    /// When it is written, and what fills each `{name}` of its text.
    pub situation: String,
    /// The line's message, word for word.
    pub message: String,
    /// The fields the line is logged with whose form is stated, by name: each a text whose `{name}` is filled as the row's `situation` says. The line may carry others.
    pub fields: std::collections::BTreeMap<String, String>,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistMessagesRefusalsItem {
    /// The situation's name.
    pub name: String,
    /// The operations it refuses: requests of bus/registry.json's operations that the Archivist answers. `{channel}` in the message is the one refused.
    pub operations: Vec<String>,
    /// Machine-readable failure class, for consumers that must BRANCH on why a command failed rather than log it. Optional and deliberately sparse: absent means 'no class declared', and every existing failure stays that way. An enum rather than a free string so the vocabulary has an owner — an unconstrained code is a mirror with no gate, and adding one should be a deliberate spec change. `message` remains the human-readable text and is unaffected. Members: `peer-unavailable` — the channel this command was sent on has no subscriber, i.e. the service that answers it has not connected yet. Transient by nature (a peer still starting), which is what distinguishes it from a refusal: retrying is the correct response. `not-found` — the resource this command addressed does not exist in this knowledge base. A verdict, not a symptom: it is emitted only where the answer comes from the event store, which is the system of record, and never from a projection that may merely be lagging. Deterministic, so unlike `peer-unavailable` retrying is pointless — and consumers may act destructively on it (the SDK deletes a restored tab). Absence is not denial: a future 'exists, but not for you' must travel as its own code, never as this one. `unauthorized` — that code: the caller is authenticated but not permitted to do what it asked. A verdict about the CALLER, not the resource, so retrying under the same credential cannot succeed and a consumer must never spin on it; emitted by `job:claim` for a caller whose token carries no worker role. `none-pending` — a declined claim, not an error: the queue holds no pending job of the requested types. Nothing went wrong; the one code a consumer PARKS on, meaning 'nothing to do until a wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying neither is unclassified — a malformed record or a missing injection — and a consumer treats it as 'log it, assume nothing'.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub code: Option<ArchivistMessagesRefusalsItemCode>,
    /// When it is written, and what fills each `{name}` of its text.
    pub situation: String,
    /// The failure's `message`. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.
    pub message: String,
}

impl ArchivistMessagesRefusalsItem {
    /// The `ArchivistMessagesRefusalsItem` that states these and nothing else.
    pub fn new(
        name: impl Into<String>,
        operations: Vec<String>,
        situation: impl Into<String>,
        message: impl Into<String>,
    ) -> Self {
        Self {
            name: name.into(),
            operations,
            code: None,
            situation: situation.into(),
            message: message.into(),
        }
    }
}

/// Machine-readable failure class, for consumers that must BRANCH on why a command failed rather than log it. Optional and deliberately sparse: absent means 'no class declared', and every existing failure stays that way. An enum rather than a free string so the vocabulary has an owner — an unconstrained code is a mirror with no gate, and adding one should be a deliberate spec change. `message` remains the human-readable text and is unaffected. Members: `peer-unavailable` — the channel this command was sent on has no subscriber, i.e. the service that answers it has not connected yet. Transient by nature (a peer still starting), which is what distinguishes it from a refusal: retrying is the correct response. `not-found` — the resource this command addressed does not exist in this knowledge base. A verdict, not a symptom: it is emitted only where the answer comes from the event store, which is the system of record, and never from a projection that may merely be lagging. Deterministic, so unlike `peer-unavailable` retrying is pointless — and consumers may act destructively on it (the SDK deletes a restored tab). Absence is not denial: a future 'exists, but not for you' must travel as its own code, never as this one. `unauthorized` — that code: the caller is authenticated but not permitted to do what it asked. A verdict about the CALLER, not the resource, so retrying under the same credential cannot succeed and a consumer must never spin on it; emitted by `job:claim` for a caller whose token carries no worker role. `none-pending` — a declined claim, not an error: the queue holds no pending job of the requested types. Nothing went wrong; the one code a consumer PARKS on, meaning 'nothing to do until a wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying neither is unclassified — a malformed record or a missing injection — and a consumer treats it as 'log it, assume nothing'.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ArchivistMessagesRefusalsItemCode {
    #[serde(rename = "peer-unavailable")]
    PeerUnavailable,
    #[serde(rename = "not-found")]
    NotFound,
    #[serde(rename = "unauthorized")]
    Unauthorized,
    #[serde(rename = "none-pending")]
    NonePending,
}

impl ArchivistMessagesRefusalsItemCode {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ArchivistMessagesRefusalsItemCode::PeerUnavailable => "peer-unavailable",
            ArchivistMessagesRefusalsItemCode::NotFound => "not-found",
            ArchivistMessagesRefusalsItemCode::Unauthorized => "unauthorized",
            ArchivistMessagesRefusalsItemCode::NonePending => "none-pending",
        }
    }
}

/// The refusal of every route of the HTTP surface but `/health`: a token that is missing, or not of the knowledge base's issuer and audience, or without the service role.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistMessagesUnauthorized {
    pub status: HttpStatus,
    /// The body's `error`.
    pub error: String,
    /// The `WWW-Authenticate` header when a token was presented.
    pub presented: String,
    /// The `WWW-Authenticate` header when none was.
    pub absent: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistMessagesUnsentItem {
    /// The situation's name.
    pub name: String,
    /// When it is written, and what fills each `{name}` of its text.
    pub situation: String,
    /// The failure's `message`. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.
    pub message: String,
}

/// One stream of the event log, and where it stands: the resource it is of, or `__system__` for the knowledge base's own, and the sequence number of its last event.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistStream {
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// The sequence number of the stream's last event when it was read: 0 for a stream with none.
    #[serde(rename = "lastSequence")]
    pub last_sequence: u64,
}

schema!(ArchivistStream);

/// Every stream of the event log, `__system__` among them, each with the sequence number of its last event, in no order: the Archivist's answer to `GET /events`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ArchivistStreamsResponse {
    pub streams: Vec<ArchivistStream>,
}

schema!(ArchivistStreamsResponse);

/// What an assessing job takes: passages of the resource are marked, each with an assessment the model writes.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct AssessingJobParams {
    pub motivation: AssessingJobParamsMotivation,
    /// What to look for, in the caller's words. Added to the prompt.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub instructions: Option<String>,
    /// The stance the assessments are written from.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub tone: Option<AssessingJobParamsTone>,
    /// How many annotations to aim for per 2000 words of the resource.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub density: Option<f64>,
    /// The language the annotations' own text is written in. BCP 47.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub language: Option<String>,
    /// The language of the resource being read. BCP 47.
    #[serde(rename = "sourceLanguage")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub source_language: Option<String>,
}

impl Default for AssessingJobParams {
    fn default() -> Self {
        Self::new()
    }
}

impl AssessingJobParams {
    /// The `AssessingJobParams` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            motivation: AssessingJobParamsMotivation::Assessing,
            instructions: None,
            tone: None,
            density: None,
            language: None,
            source_language: None,
        }
    }
}

schema!(AssessingJobParams);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum AssessingJobParamsMotivation {
    #[serde(rename = "assessing")]
    Assessing,
}

impl AssessingJobParamsMotivation {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            AssessingJobParamsMotivation::Assessing => "assessing",
        }
    }
}

/// The stance the assessments are written from.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum AssessingJobParamsTone {
    #[serde(rename = "analytical")]
    Analytical,
    #[serde(rename = "critical")]
    Critical,
    #[serde(rename = "balanced")]
    Balanced,
    #[serde(rename = "constructive")]
    Constructive,
}

impl AssessingJobParamsTone {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            AssessingJobParamsTone::Analytical => "analytical",
            AssessingJobParamsTone::Critical => "critical",
            AssessingJobParamsTone::Balanced => "balanced",
            AssessingJobParamsTone::Constructive => "constructive",
        }
    }
}

/// A persisted event as a history reply carries it: the stored event, and the agent its `userId` identifies. The agent is derived when the reply is made — the DID read into a Person or a Software agent, and a Person's name filled in from the knowledge base's profiles — and is stored nowhere. A Person the record does not name carries no `name`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct AttributedEvent {
    /// Unique event ID (UUID)
    pub id: String,
    /// Event type (flow verb name, e.g. mark:added)
    pub r#type: String,
    /// When the event occurred
    pub timestamp: String,
    /// DID of the user who triggered the event
    #[serde(rename = "userId")]
    pub user_id: UserId,
    /// Resource this event affects (absent for system events)
    #[serde(rename = "resourceId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resource_id: Option<ResourceId>,
    /// Event schema version
    pub version: i64,
    /// Event-type-specific payload
    pub payload: serde_json::Map<String, serde_json::Value>,
    pub metadata: EventMetadata,
    /// Who `userId` is.
    pub agent: Agent,
}

impl AttributedEvent {
    /// The `AttributedEvent` that states these and nothing else.
    #[allow(clippy::too_many_arguments)]
    pub fn new(
        id: impl Into<String>,
        r#type: impl Into<String>,
        timestamp: impl Into<String>,
        user_id: UserId,
        version: i64,
        payload: serde_json::Map<String, serde_json::Value>,
        metadata: EventMetadata,
        agent: Agent,
    ) -> Self {
        Self {
            id: id.into(),
            r#type: r#type.into(),
            timestamp: timestamp.into(),
            user_id,
            resource_id: None,
            version,
            payload,
            metadata,
            agent,
        }
    }
}

schema!(AttributedEvent);

/// auth.login's params.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct AuthLoginParams {
    /// The version of the control API the request is written to.
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    /// Which knowledge base's stack. Absent: the one the command line chooses, standing where the control server was started.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub target: Option<Target>,
    /// Keep to the local stacks, as --runtime does.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub runtime: Option<Runtime>,
}

impl AuthLoginParams {
    /// The `AuthLoginParams` that states these and nothing else.
    pub fn new(api_version: ApiVersion) -> Self {
        Self {
            api_version,
            target: None,
            runtime: None,
        }
    }
}

schema!(AuthLoginParams);

/// A completed sign-in, kept in the launcher's sign-in store. No token is in it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct AuthLoginResult {
    /// The stack's key in the sign-in store.
    pub key: String,
    /// Who the gateway says is signed in: their email, else their DID.
    pub who: String,
    /// The issuer the knowledge base named, where the person signed in.
    pub issuer: String,
}

schema!(AuthLoginResult);

/// auth.logout's params.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct AuthLogoutParams {
    /// The version of the control API the request is written to.
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    /// Which knowledge base's stack. Absent: the one the command line chooses, standing where the control server was started.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub target: Option<Target>,
    /// Keep to the local stacks, as --runtime does.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub runtime: Option<Runtime>,
}

impl AuthLogoutParams {
    /// The `AuthLogoutParams` that states these and nothing else.
    pub fn new(api_version: ApiVersion) -> Self {
        Self {
            api_version,
            target: None,
            runtime: None,
        }
    }
}

schema!(AuthLogoutParams);

/// The launcher's session for a stack, ended. Desktop's own session is not touched.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct AuthLogoutResult {
    /// The stack's key in the sign-in store. Absent when no stack is recorded.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub key: Option<String>,
    /// Whether a session was stored. false: nothing was done.
    #[serde(rename = "wasSignedIn")]
    pub was_signed_in: bool,
    /// Whether the issuer revoked the session's refresh token. false with wasSignedIn: the local token is forgotten, and the refresh token stays valid at the issuer until it expires.
    pub revoked: bool,
}

impl AuthLogoutResult {
    /// The `AuthLogoutResult` that states these and nothing else.
    pub fn new(was_signed_in: bool, revoked: bool) -> Self {
        Self {
            key: None,
            was_signed_in,
            revoked,
        }
    }
}

schema!(AuthLogoutResult);

/// Emitted to draw attention to a resource: to one of its annotations, or, with no annotation, to the resource as a whole. The resource is always named. A focus on an annotation scrolls a viewer showing that resource to it, and a viewer showing a different resource ignores it — a deliberate ignore rather than a silent no-op. A focus on the resource as a whole brings that resource forward, opened if it is not open, at its top.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BeckonFocusEvent {
    #[serde(rename = "annotationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotation_id: Option<AnnotationId>,
    /// The resource this focus applies to, always named. With an annotation it is a guard: a viewer showing a different resource ignores the event. With none it is the resource the focus brings forward.
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
}

impl BeckonFocusEvent {
    /// The `BeckonFocusEvent` that states these and nothing else.
    pub fn new(resource_id: ResourceId) -> Self {
        Self {
            annotation_id: None,
            resource_id,
        }
    }
}

schema!(BeckonFocusEvent);

/// Emitted when an annotation is hovered over for beckoning
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BeckonHoverEvent {
    #[serde(rename = "annotationId")]
    pub annotation_id: Option<AnnotationId>,
}

schema!(BeckonHoverEvent);

/// Emitted when a sparkle effect is triggered on an annotation
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BeckonSparkleEvent {
    #[serde(rename = "annotationId")]
    pub annotation_id: AnnotationId,
}

schema!(BeckonSparkleEvent);

/// What starting an authorization-code grant is told: the knowledge base to sign in to, where the issuer sends the person back, and, re-authenticating, which registered knowledge base it is and what the person believed they chose.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct BeginAuthorizationOptions {
    pub target: HttpEndpoint,
    /// Where the issuer sends the person back to.
    #[serde(rename = "redirectUri")]
    pub redirect_uri: String,
    /// The registered knowledge base being re-authenticated, rather than a new address connected to.
    #[serde(rename = "kbId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub kb_id: Option<String>,
    /// The knowledge base's DID the person believed they chose: verified after, never assumed.
    #[serde(rename = "expectedDid")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub expected_did: Option<String>,
    /// The knowledge base's name the person believed they chose: verified after, never assumed.
    #[serde(rename = "expectedName")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub expected_name: Option<String>,
}

impl BeginAuthorizationOptions {
    /// The `BeginAuthorizationOptions` that states these and nothing else.
    pub fn new(target: HttpEndpoint, redirect_uri: impl Into<String>) -> Self {
        Self {
            target,
            redirect_uri: redirect_uri.into(),
            kb_id: None,
            expected_did: None,
            expected_name: None,
        }
    }
}

schema!(BeginAuthorizationOptions);

/// One edit to a linking annotation's body list: add or remove a body item, or replace an existing one.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BindBodyOperation {
    /// The type of body operation
    pub op: BindBodyOperationOp,
    /// Body item for add operations
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub item: Option<AnnotationBody>,
    /// Previous body item for replace operations
    #[serde(rename = "oldItem")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub old_item: Option<AnnotationBody>,
    /// Replacement body item for replace operations
    #[serde(rename = "newItem")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub new_item: Option<AnnotationBody>,
}

impl BindBodyOperation {
    /// The `BindBodyOperation` that states these and nothing else.
    pub fn new(op: BindBodyOperationOp) -> Self {
        Self {
            op,
            item: None,
            old_item: None,
            new_item: None,
        }
    }
}

schema!(BindBodyOperation);

/// The type of body operation
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum BindBodyOperationOp {
    #[serde(rename = "add")]
    Add,
    #[serde(rename = "remove")]
    Remove,
    #[serde(rename = "replace")]
    Replace,
}

impl BindBodyOperationOp {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            BindBodyOperationOp::Add => "add",
            BindBodyOperationOp::Remove => "remove",
            BindBodyOperationOp::Replace => "replace",
        }
    }
}

/// Void success reply emitted on the bind:body-updated channel after bind:update-body has been applied, matched to the originating command by correlationId.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct BindBodyUpdated {}

schema!(BindBodyUpdated);

/// Command payload sent on the bind:initiate bus channel to start a bind flow.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BindInitiateCommand {
    /// Branded AnnotationId of the annotation being bound
    #[serde(rename = "annotationId")]
    pub annotation_id: AnnotationId,
    /// Branded ResourceId of the resource being bound to
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// Default title for the bound annotation
    #[serde(rename = "defaultTitle")]
    pub default_title: String,
    /// Entity types to associate with the annotation
    #[serde(rename = "entityTypes")]
    pub entity_types: Vec<String>,
}

schema!(BindInitiateCommand);

/// Command payload sent on the bind:update-body bus channel to modify annotation bodies.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BindUpdateBodyCommand {
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    /// Branded AnnotationId of the annotation whose body is being updated
    #[serde(rename = "annotationId")]
    pub annotation_id: AnnotationId,
    /// Branded ResourceId of the resource the annotation belongs to
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// Ordered body-list edits to apply.
    pub operations: Vec<BindBodyOperation>,
}

impl BindUpdateBodyCommand {
    /// The `BindUpdateBodyCommand` that states these and nothing else.
    pub fn new(
        annotation_id: AnnotationId,
        resource_id: ResourceId,
        operations: Vec<BindBodyOperation>,
    ) -> Self {
        Self {
            _user_id: None,
            annotation_id,
            resource_id,
            operations,
        }
    }
}

schema!(BindUpdateBodyCommand);

/// One change to an annotation's bodies: a body added, a body removed, or one body replaced by another.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum BodyOperation {
    Add(BodyOperationAdd),
    Remove(BodyOperationRemove),
    Replace(BodyOperationReplace),
}

member!(BodyOperation::Add(BodyOperationAdd));
member!(BodyOperation::Remove(BodyOperationRemove));
member!(BodyOperation::Replace(BodyOperationReplace));
schema!(BodyOperation);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BodyOperationAdd {
    pub op: BodyOperationAddOp,
    pub item: AnnotationBody,
}

impl BodyOperationAdd {
    /// The `BodyOperationAdd` that states these and nothing else.
    pub fn new(item: AnnotationBody) -> Self {
        Self {
            op: BodyOperationAddOp::Add,
            item,
        }
    }
}

schema!(BodyOperationAdd);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum BodyOperationAddOp {
    #[serde(rename = "add")]
    Add,
}

impl BodyOperationAddOp {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            BodyOperationAddOp::Add => "add",
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BodyOperationRemove {
    pub op: BodyOperationRemoveOp,
    pub item: AnnotationBody,
}

impl BodyOperationRemove {
    /// The `BodyOperationRemove` that states these and nothing else.
    pub fn new(item: AnnotationBody) -> Self {
        Self {
            op: BodyOperationRemoveOp::Remove,
            item,
        }
    }
}

schema!(BodyOperationRemove);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum BodyOperationRemoveOp {
    #[serde(rename = "remove")]
    Remove,
}

impl BodyOperationRemoveOp {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            BodyOperationRemoveOp::Remove => "remove",
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BodyOperationReplace {
    pub op: BodyOperationReplaceOp,
    #[serde(rename = "oldItem")]
    pub old_item: AnnotationBody,
    #[serde(rename = "newItem")]
    pub new_item: AnnotationBody,
}

impl BodyOperationReplace {
    /// The `BodyOperationReplace` that states these and nothing else.
    pub fn new(old_item: AnnotationBody, new_item: AnnotationBody) -> Self {
        Self {
            op: BodyOperationReplaceOp::Replace,
            old_item,
            new_item,
        }
    }
}

schema!(BodyOperationReplace);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum BodyOperationReplaceOp {
    #[serde(rename = "replace")]
    Replace,
}

impl BodyOperationReplaceOp {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            BodyOperationReplaceOp::Replace => "replace",
        }
    }
}

/// W3C Web Annotation body purpose vocabulary - https://www.w3.org/TR/annotation-vocab/#motivation
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum BodyPurpose {
    #[serde(rename = "assessing")]
    Assessing,
    #[serde(rename = "bookmarking")]
    Bookmarking,
    #[serde(rename = "classifying")]
    Classifying,
    #[serde(rename = "commenting")]
    Commenting,
    #[serde(rename = "describing")]
    Describing,
    #[serde(rename = "editing")]
    Editing,
    #[serde(rename = "highlighting")]
    Highlighting,
    #[serde(rename = "identifying")]
    Identifying,
    #[serde(rename = "linking")]
    Linking,
    #[serde(rename = "moderating")]
    Moderating,
    #[serde(rename = "questioning")]
    Questioning,
    #[serde(rename = "replying")]
    Replying,
    #[serde(rename = "tagging")]
    Tagging,
}

impl BodyPurpose {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            BodyPurpose::Assessing => "assessing",
            BodyPurpose::Bookmarking => "bookmarking",
            BodyPurpose::Classifying => "classifying",
            BodyPurpose::Commenting => "commenting",
            BodyPurpose::Describing => "describing",
            BodyPurpose::Editing => "editing",
            BodyPurpose::Highlighting => "highlighting",
            BodyPurpose::Identifying => "identifying",
            BodyPurpose::Linking => "linking",
            BodyPurpose::Moderating => "moderating",
            BodyPurpose::Questioning => "questioning",
            BodyPurpose::Replying => "replying",
            BodyPurpose::Tagging => "tagging",
        }
    }
}

schema!(BodyPurpose);

/// Request to browse the history of an annotation
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseAnnotationHistoryRequest {
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    #[serde(rename = "annotationId")]
    pub annotation_id: AnnotationId,
}

schema!(BrowseAnnotationHistoryRequest);

/// Result of browsing annotation history
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct BrowseAnnotationHistoryResult {
    pub response: GetAnnotationHistoryResponse,
}

schema!(BrowseAnnotationHistoryResult);

/// Request to browse a single annotation
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseAnnotationRequest {
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    #[serde(rename = "annotationId")]
    pub annotation_id: AnnotationId,
}

schema!(BrowseAnnotationRequest);

/// Result of browsing a single annotation
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct BrowseAnnotationResult {
    pub response: GetAnnotationResponse,
}

schema!(BrowseAnnotationResult);

/// An annotation was clicked — open it: the viewer selects its entry in the annotations panel and relays a focus signal to scroll to it. The annotation id is the whole address; it identifies exactly one annotation on exactly one resource, so no resource field is carried and none is needed to scope the event. Motivation is NOT on the wire either: the viewer derives it from the annotation the id names, so the wire states the fact once. A viewer that has not loaded that annotation finds nothing and does nothing. Emitted locally by every clickable annotation surface, and over the wire by a driver opening an annotation on another participant's screen.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct BrowseClickEvent {
    #[serde(rename = "annotationId")]
    pub annotation_id: AnnotationId,
    #[serde(rename = "anchorRect")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub anchor_rect: Option<AnchorRect>,
}

impl BrowseClickEvent {
    /// The `BrowseClickEvent` that states these and nothing else.
    pub fn new(annotation_id: AnnotationId) -> Self {
        Self {
            annotation_id,
            anchor_rect: None,
        }
    }
}

schema!(BrowseClickEvent);

/// The payload of `browse:directory-failed`: a CommandError that names the directory that could not be read.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseDirectoryFailed {
    /// Machine-readable failure class, for consumers that must BRANCH on why a command failed rather than log it. Optional and deliberately sparse: absent means 'no class declared', and every existing failure stays that way. An enum rather than a free string so the vocabulary has an owner — an unconstrained code is a mirror with no gate, and adding one should be a deliberate spec change. `message` remains the human-readable text and is unaffected. Members: `peer-unavailable` — the channel this command was sent on has no subscriber, i.e. the service that answers it has not connected yet. Transient by nature (a peer still starting), which is what distinguishes it from a refusal: retrying is the correct response. `not-found` — the resource this command addressed does not exist in this knowledge base. A verdict, not a symptom: it is emitted only where the answer comes from the event store, which is the system of record, and never from a projection that may merely be lagging. Deterministic, so unlike `peer-unavailable` retrying is pointless — and consumers may act destructively on it (the SDK deletes a restored tab). Absence is not denial: a future 'exists, but not for you' must travel as its own code, never as this one. `unauthorized` — that code: the caller is authenticated but not permitted to do what it asked. A verdict about the CALLER, not the resource, so retrying under the same credential cannot succeed and a consumer must never spin on it; emitted by `job:claim` for a caller whose token carries no worker role. `none-pending` — a declined claim, not an error: the queue holds no pending job of the requested types. Nothing went wrong; the one code a consumer PARKS on, meaning 'nothing to do until a wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying neither is unclassified — a malformed record or a missing injection — and a consumer treats it as 'log it, assume nothing'.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub code: Option<CommandErrorCode>,
    /// Human-readable error message
    pub message: String,
    /// Optional additional context (stack trace, field name, etc.)
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub details: Option<String>,
    /// The path the read was asked for.
    pub path: String,
}

impl BrowseDirectoryFailed {
    /// The `BrowseDirectoryFailed` that states these and nothing else.
    pub fn new(message: impl Into<String>, path: impl Into<String>) -> Self {
        Self {
            code: None,
            message: message.into(),
            details: None,
            path: path.into(),
        }
    }
}

schema!(BrowseDirectoryFailed);

/// Request to browse a directory listing
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseDirectoryRequest {
    pub path: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub sort: Option<BrowseDirectoryRequestSort>,
}

impl BrowseDirectoryRequest {
    /// The `BrowseDirectoryRequest` that states these and nothing else.
    pub fn new(path: impl Into<String>) -> Self {
        Self {
            path: path.into(),
            sort: None,
        }
    }
}

schema!(BrowseDirectoryRequest);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum BrowseDirectoryRequestSort {
    #[serde(rename = "name")]
    Name,
    #[serde(rename = "mtime")]
    Mtime,
    #[serde(rename = "annotationCount")]
    AnnotationCount,
}

impl BrowseDirectoryRequestSort {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            BrowseDirectoryRequestSort::Name => "name",
            BrowseDirectoryRequestSort::Mtime => "mtime",
            BrowseDirectoryRequestSort::AnnotationCount => "annotationCount",
        }
    }
}

/// Result of browsing a directory listing
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseDirectoryResult {
    pub response: BrowseDirectoryResultResponse,
}

schema!(BrowseDirectoryResult);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseDirectoryResultResponse {
    pub path: String,
    pub entries: Vec<DirectoryEntry>,
}

schema!(BrowseDirectoryResultResponse);

/// Request for the knowledge base's engines: those its Inference document names
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct BrowseEnginesRequest {}

schema!(BrowseEnginesRequest);

/// The knowledge base's engines: those its Inference document names, and the jobs it has each used for
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseEnginesResult {
    pub response: BrowseEnginesResultResponse,
}

schema!(BrowseEnginesResult);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseEnginesResultResponse {
    pub engines: Vec<EngineEntry>,
}

/// Emitted when an entity type is clicked in the browse panel
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseEntityTypeClickedEvent {
    #[serde(rename = "entityType")]
    pub entity_type: String,
}

schema!(BrowseEntityTypeClickedEvent);

/// Request to browse available entity types
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct BrowseEntityTypesRequest {}

schema!(BrowseEntityTypesRequest);

/// Result of browsing entity types
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseEntityTypesResult {
    pub response: GetEntityTypesResponse,
}

schema!(BrowseEntityTypesResult);

/// Request to browse events for a resource
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseEventsRequest {
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub r#type: Option<String>,
    #[serde(rename = "userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub user_id: Option<UserId>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub limit: Option<i64>,
}

impl BrowseEventsRequest {
    /// The `BrowseEventsRequest` that states these and nothing else.
    pub fn new(resource_id: ResourceId) -> Self {
        Self {
            resource_id,
            r#type: None,
            user_id: None,
            limit: None,
        }
    }
}

schema!(BrowseEventsRequest);

/// Result of browsing events for a resource
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct BrowseEventsResult {
    pub response: GetEventsResponse,
}

schema!(BrowseEventsResult);

/// Emitted when navigation to an external URL is requested
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseExternalNavigateEvent {
    pub url: String,
    #[serde(rename = "resourceId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resource_id: Option<ResourceId>,
}

impl BrowseExternalNavigateEvent {
    /// The `BrowseExternalNavigateEvent` that states these and nothing else.
    pub fn new(url: impl Into<String>) -> Self {
        Self {
            url: url.into(),
            resource_id: None,
        }
    }
}

schema!(BrowseExternalNavigateEvent);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct BrowseFilesResponse {
    /// The directory path that was listed, relative to project root
    pub path: String,
    pub entries: Vec<DirectoryEntry>,
}

schema!(BrowseFilesResponse);

/// Request for the knowledge base's description of itself
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct BrowseKbRequest {}

schema!(BrowseKbRequest);

/// Result of browse:kb-requested
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseKbResult {
    pub response: KbDescription,
}

schema!(BrowseKbResult);

/// Emitted when a link is clicked in the browse panel
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseLinkClickedEvent {
    pub href: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub label: Option<String>,
}

impl BrowseLinkClickedEvent {
    /// The `BrowseLinkClickedEvent` that states these and nothing else.
    pub fn new(href: impl Into<String>) -> Self {
        Self {
            href: href.into(),
            label: None,
        }
    }
}

schema!(BrowseLinkClickedEvent);

/// Emitted when a browse panel is opened
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowsePanelOpenEvent {
    pub panel: String,
    #[serde(rename = "scrollToAnnotationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub scroll_to_annotation_id: Option<AnnotationId>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub motivation: Option<Motivation>,
}

impl BrowsePanelOpenEvent {
    /// The `BrowsePanelOpenEvent` that states these and nothing else.
    pub fn new(panel: impl Into<String>) -> Self {
        Self {
            panel: panel.into(),
            scroll_to_annotation_id: None,
            motivation: None,
        }
    }
}

schema!(BrowsePanelOpenEvent);

/// Emitted when a browse panel is toggled
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowsePanelToggleEvent {
    pub panel: String,
}

schema!(BrowsePanelToggleEvent);

/// Request for the profiles of some principals: the DIDs a reply mentions. Bounded by the question: a reader that has more asks in parts.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct BrowseProfilesRequest {
    /// The principals asked after.
    pub dids: Vec<UserId>,
}

schema!(BrowseProfilesRequest);

/// The profiles of the principals asked after: each that has one, keyed by DID. A DID with no profile is absent, and is named by no one.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseProfilesResult {
    pub response: BrowseProfilesResultResponse,
}

schema!(BrowseProfilesResult);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct BrowseProfilesResultResponse {
    /// Each profile, keyed by DID.
    pub profiles: std::collections::BTreeMap<String, Profile>,
}

/// Emitted when a resource is closed in the browse panel
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseResourceCloseEvent {
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
}

schema!(BrowseResourceCloseEvent);

/// Domain intent to open a resource in the viewer: emitted locally by in-app link handlers and remotely by the launcher's tour verbs; the viewer translates it to host routing (nav:push), which never crosses the wire. Deliberately not named 'navigate' — that word and the nav:* prefix belong to the host-local framework layer.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseResourceOpenEvent {
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
}

schema!(BrowseResourceOpenEvent);

/// Emitted when resources are reordered in the browse panel
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseResourceReorderEvent {
    #[serde(rename = "oldIndex")]
    pub old_index: i64,
    #[serde(rename = "newIndex")]
    pub new_index: i64,
}

schema!(BrowseResourceReorderEvent);

/// Request to browse a single resource
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseResourceRequest {
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
}

schema!(BrowseResourceRequest);

/// A resource's descriptor, and the sequence number of the last of its events the descriptor reflects. Its annotations are not here: their number follows the document's, so they are read over HTTP (`GET /resources/{id}/annotations`).
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct BrowseResourceResult {
    pub response: BrowseResourceResultResponse,
}

schema!(BrowseResourceResult);

#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct BrowseResourceResultResponse {
    pub resource: ResourceDescriptor,
    /// The sequence number of the resource's last event. A graph read that follows a write waits for the graph projection to reach it.
    #[serde(rename = "lastSequence")]
    pub last_sequence: u64,
}

/// REPORT that a resource has loaded in a viewer — emitted on arrival by ANY means: a followed cue, an in-app link, the back button, a typed URL. Deliberately distinct from the imperative browse:resource-open: drive and report never share a channel, or the driver hears its own commands and one viewer's arrival steers another's page.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseResourceViewedEvent {
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
}

schema!(BrowseResourceViewedEvent);

/// Request to browse resources with optional filtering and pagination
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct BrowseResourcesRequest {
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub archived: Option<bool>,
    #[serde(rename = "entityType")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_type: Option<String>,
    /// How many of the resources the filters admit are passed over before the page begins.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub offset: Option<u64>,
    /// The most resources a page has.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub limit: Option<u64>,
}

schema!(BrowseResourcesRequest);

/// Result of browsing resources
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct BrowseResourcesResult {
    pub response: ListResourcesResponse,
}

schema!(BrowseResourcesResult);

/// Emitted when the browse panel requests a router navigation
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseRouterPushEvent {
    pub path: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub reason: Option<String>,
}

impl BrowseRouterPushEvent {
    /// The `BrowseRouterPushEvent` that states these and nothing else.
    pub fn new(path: impl Into<String>) -> Self {
        Self {
            path: path.into(),
            reason: None,
        }
    }
}

schema!(BrowseRouterPushEvent);

/// Request to browse registered tag schemas
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct BrowseTagSchemasRequest {}

schema!(BrowseTagSchemasRequest);

/// Result of browsing tag schemas
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BrowseTagSchemasResult {
    pub response: GetTagSchemasResponse,
}

schema!(BrowseTagSchemasResult);

/// The shared Browser: one viewer for every knowledge base the machine reaches. It belongs to no knowledge base, so its document is kept in the launcher's state home, in `stack/browser.yaml`, not in a knowledge base's repository.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct Browser {
    #[serde(rename = "apiVersion")]
    pub api_version: StackApiVersion,
    pub kind: BrowserKind,
    pub metadata: Metadata,
    /// How the Browser runs.
    pub spec: BrowserSpec,
}

impl Browser {
    /// The `Browser` that states these and nothing else.
    pub fn new(api_version: StackApiVersion, metadata: Metadata, spec: BrowserSpec) -> Self {
        Self {
            api_version,
            kind: BrowserKind::Browser,
            metadata,
            spec,
        }
    }
}

schema!(Browser);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum BrowserKind {
    #[serde(rename = "Browser")]
    Browser,
}

impl BrowserKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            BrowserKind::Browser => "Browser",
        }
    }
}

/// How the Browser runs.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct BrowserSpec {
    pub image: Image,
    pub resources: Resources,
    /// The port the Browser is published on, on this machine's loopback: where a person opens it, and the origin the issuer's realm allows its sign-in from.
    pub port: u16,
}

/// Result of publishing one event. `subscribers` is the number of observers attached to the target subject at dispatch — the GLOBAL subject for an unscoped emit, the scoped one when `scope` is set. Zero means the signal reached nobody: /bus/subscribe enforces no channel allowlist and the emit handler publishes unconditionally, so a client can emit a channel no participant subscribes to and otherwise receive a clean 202 with no way to tell. Deliberately NOT named `delivered`: this is the count at dispatch, and a subscriber may still drop the frame downstream, so the field is named after what the server can actually observe.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct BusEmitAccepted {
    /// Observers on the target subject when the event was dispatched. ABSENT means the gateway could not count: under a broker signal plane (the KnowledgeBase document's `spec.messaging.signal.type: nats`) the event is published to a fabric whose observers the gateway cannot see. The one zero a broker plane states is a registry operation's request with a `correlationId` that reached nobody, which the broker itself reports (no responders). Never defaulted: a zero here is the claim that nobody was listening, and a gateway that did not observe that never makes it.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub subscribers: Option<u64>,
}

schema!(BusEmitAccepted);

/// One event for the bus. `channel` names a channel of the bus registry (specs/src/bus/registry.json) and `payload` must match the schema the registry's `validate` names for it. `scope` publishes a resource-bound broadcast to that resource's subscribers only; everything else is unscoped. `clientId` and `correlationId` are routing facts beside the payload, never inside it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct BusEmitRequest {
    /// A channel of the bus registry.
    pub channel: String,
    /// The channel's payload, validated against the schema its registry entry names. `_userId` and `_roles` are the gateway's to write: whatever a caller puts there is replaced.
    pub payload: serde_json::Map<String, serde_json::Value>,
    /// The resource scope of a resource-bound broadcast. Publishers of those broadcasts only; a command or request never carries one.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub scope: Option<ResourceId>,
    /// The address this request's reply is delivered to: the emit claims `correlationId` for this clientId and the verified principal. Required when `channel` is a registry operation's request and a correlationId is present; ignored otherwise. An empty string counts as absent.
    #[serde(rename = "clientId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub client_id: Option<String>,
    /// Pairs a reply with its request. On a registry operation's request it claims the id: a second claim of a live id is refused with 409. Replies carry it back on the frame, never in the payload.
    #[serde(rename = "correlationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub correlation_id: Option<String>,
}

impl BusEmitRequest {
    /// The `BusEmitRequest` that states these and nothing else.
    pub fn new(
        channel: impl Into<String>,
        payload: serde_json::Map<String, serde_json::Value>,
    ) -> Self {
        Self {
            channel: channel.into(),
            payload,
            scope: None,
            client_id: None,
            correlation_id: None,
        }
    }
}

schema!(BusEmitRequest);

/// A bus frame on the stream: `event: bus-event`, an `id:` line, and one `data:` line holding the JSON-serialised BusFrame. This schema describes the message with `data` already parsed.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct BusEventMessage {
    pub event: BusEventMessageEvent,
    pub id: String,
    pub data: BusFrame,
}

impl BusEventMessage {
    /// The `BusEventMessage` that states these and nothing else.
    pub fn new(id: impl Into<String>, data: BusFrame) -> Self {
        Self {
            event: BusEventMessageEvent::BusEvent,
            id: id.into(),
            data,
        }
    }
}

schema!(BusEventMessage);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum BusEventMessageEvent {
    #[serde(rename = "bus-event")]
    BusEvent,
}

impl BusEventMessageEvent {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            BusEventMessageEvent::BusEvent => "bus-event",
        }
    }
}

/// One frame of the bus stream, as the `data` line of a `bus-event` message carries it (JSON-serialised on one line). `payload` is the channel's payload as its registry entry declares it. A frame on a scoped subscription carries the scope it was published on; a correlated reply carries the `correlationId` of the request it answers.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct BusFrame {
    /// A channel of the bus registry (specs/src/bus/registry.json).
    pub channel: String,
    /// The request this frame answers. Present on correlated replies; absent otherwise.
    #[serde(rename = "correlationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub correlation_id: Option<String>,
    /// The channel's payload. A replayed persisted event is the stored event itself, whose `metadata.sequenceNumber` the message id carries.
    pub payload: serde_json::Map<String, serde_json::Value>,
    /// The resource scope the frame was published on. Present exactly when it arrived through a `scoped` entry of the subscription.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub scope: Option<ResourceId>,
}

impl BusFrame {
    /// The `BusFrame` that states these and nothing else.
    pub fn new(
        channel: impl Into<String>,
        payload: serde_json::Map<String, serde_json::Value>,
    ) -> Self {
        Self {
            channel: channel.into(),
            correlation_id: None,
            payload,
            scope: None,
        }
    }
}

schema!(BusFrame);

/// The heartbeat: `event: ping` with an empty `data:` line. The first is written once the stream has caught up (after any replay), then one every `x-xynolog-limits.heartbeatSeconds`. It carries no id, so it never disturbs a client's last-seen ids.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct BusPingMessage {
    pub event: BusPingMessageEvent,
    pub data: String,
}

impl BusPingMessage {
    /// The `BusPingMessage` that states these and nothing else.
    pub fn new(data: impl Into<String>) -> Self {
        Self {
            event: BusPingMessageEvent::Ping,
            data: data.into(),
        }
    }
}

schema!(BusPingMessage);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum BusPingMessageEvent {
    #[serde(rename = "ping")]
    Ping,
}

impl BusPingMessageEvent {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            BusPingMessageEvent::Ping => "ping",
        }
    }
}

/// bus/reply-bounds.json: each list or map an operation's reply carries that its own schema does not bound, and what bounds it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct BusReplyBounds {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    /// Each operation, by its request's channel.
    pub replies: std::collections::BTreeMap<
        String,
        std::collections::BTreeMap<String, BusReplyBoundsRepliesValueValue>,
    >,
}

schema!(BusReplyBounds);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum BusReplyBoundsRepliesValueValue {
    By(BusReplyBoundsRepliesValueValueBy),
    Grows(BusReplyBoundsRepliesValueValueGrows),
}

/// A list or map bounded by a member of the request.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct BusReplyBoundsRepliesValueValueBy {
    /// The member of the request that bounds it: an array, or an integer with a maximum.
    pub by: String,
}

/// A list or map not yet bounded, which grows.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct BusReplyBoundsRepliesValueValueGrows {
    /// What it grows with.
    pub grows: String,
}

/// The payload of `bus:resume-gap`: a scope's `lastEventId` could not be honoured, so the client cannot trust that it has every persisted event of that scope and must refetch what it caches for it. Written by the gateway, never by a participant.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct BusResumeGap {
    /// The scope of the subscription entry whose watermark failed.
    pub scope: ResourceId,
    /// The watermark the entry carried.
    #[serde(rename = "lastSeenId")]
    pub last_seen_id: String,
    /// `unparseable-last-event-id`: the watermark is not a PersistedEventId. `scope-mismatch`: it names another scope. `retention-exceeded`: the record no longer holds the events after it (what it still holds is replayed first). `query-error`: the record could not be read.
    pub reason: BusResumeGapReason,
}

schema!(BusResumeGap);

/// `unparseable-last-event-id`: the watermark is not a PersistedEventId. `scope-mismatch`: it names another scope. `retention-exceeded`: the record no longer holds the events after it (what it still holds is replayed first). `query-error`: the record could not be read.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum BusResumeGapReason {
    #[serde(rename = "unparseable-last-event-id")]
    UnparseableLastEventId,
    #[serde(rename = "scope-mismatch")]
    ScopeMismatch,
    #[serde(rename = "retention-exceeded")]
    RetentionExceeded,
    #[serde(rename = "query-error")]
    QueryError,
}

impl BusResumeGapReason {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            BusResumeGapReason::UnparseableLastEventId => "unparseable-last-event-id",
            BusResumeGapReason::ScopeMismatch => "scope-mismatch",
            BusResumeGapReason::RetentionExceeded => "retention-exceeded",
            BusResumeGapReason::QueryError => "query-error",
        }
    }
}

/// Every message the bus stream carries. A client ignores an `event` it does not know; the gateway writes no other.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum BusStreamMessage {
    EventMessage(BusEventMessage),
    PingMessage(BusPingMessage),
}

member!(BusStreamMessage::EventMessage(BusEventMessage));
member!(BusStreamMessage::PingMessage(BusPingMessage));
schema!(BusStreamMessage);

/// Subscription matrix for the bus stream. `global` channels are delivered unscoped; each `scoped` entry subscribes the connection to one resource scope's channels, optionally resuming from that scope's last-seen persisted event id. At least one global channel or one scoped entry is required, and no scope may appear in two entries.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct BusSubscribeRequest {
    /// Unscoped channels to subscribe to.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub global: Option<Vec<String>>,
    /// Correlation ids of requests this client still awaits a reply to. The gateway writes every reply it still retains for them (for `x-xynolog-limits.replyRetentionSeconds` after it was published) as an ordinary frame with its ReplyEventId, so a reply that also arrived live dedups client-side. A client can have no more pending than it may have unanswered requests, so this bound is also the number of unanswered requests `POST /bus/emit` allows a client.
    #[serde(rename = "pendingReplies")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub pending_replies: Option<Vec<String>>,
    /// Per-resource-scope subscriptions, at most 512 on one connection. Scopes must be unique across entries.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub scoped: Option<Vec<BusSubscribeRequestScopedItem>>,
    /// Routing address for correlated replies: a UUID minted once per bus-client lifetime — per actor, not per connection, so it survives a reconnect and two overlapping connections share it. A correlated reply is delivered to a connection only when its request was emitted under the same clientId by the same principal. Not authentication — the bearer token stays that — and never echoed into any payload or broadcast frame.
    #[serde(rename = "clientId")]
    pub client_id: String,
}

impl BusSubscribeRequest {
    /// The `BusSubscribeRequest` that states these and nothing else.
    pub fn new(client_id: impl Into<String>) -> Self {
        Self {
            global: None,
            pending_replies: None,
            scoped: None,
            client_id: client_id.into(),
        }
    }
}

schema!(BusSubscribeRequest);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct BusSubscribeRequestScopedItem {
    /// Resource scope (a resourceId).
    pub scope: ResourceId,
    /// Channels to subscribe within this scope.
    pub channels: Vec<String>,
    /// This scope's last-seen PersistedEventId. The gateway replays this scope's persisted events after it — those on the entry's channels — before the live tail, and writes a scoped `bus:resume-gap` (BusResumeGap) when it cannot cover the gap.
    #[serde(rename = "lastEventId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub last_event_id: Option<String>,
}

impl BusSubscribeRequestScopedItem {
    /// The `BusSubscribeRequestScopedItem` that states these and nothing else.
    pub fn new(scope: ResourceId, channels: Vec<String>) -> Self {
        Self {
            scope,
            channels,
            last_event_id: None,
        }
    }
}

/// The client gives up on one of its requests. The launcher answers that request with control.cancelled, unless it has answered it already; a cancellation of a request it does not know is ignored.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct Cancelled {
    #[serde(rename = "requestId")]
    pub request_id: RequestId,
    /// Why, for the launcher's diagnostics.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub reason: Option<String>,
}

impl Cancelled {
    /// The `Cancelled` that states these and nothing else.
    pub fn new(request_id: RequestId) -> Self {
        Self {
            request_id,
            reason: None,
        }
    }
}

schema!(Cancelled);

/// What a worker's claiming of jobs is told: the jobs it takes, and how long it waits for what it waits on. A wait left out is client/timing.json's of the same name.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ClaimOptions {
    /// The jobs this claim takes. A job is handed over when it matches any one of them.
    pub accepts: Vec<JobFilter>,
    /// How long it waits for the answer to one claim, in milliseconds.
    #[serde(rename = "jobClaimTimeoutMs")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub job_claim_timeout_ms: Option<u64>,
    /// How long a held job may show no activity before it is called stalled, in milliseconds.
    #[serde(rename = "heldJobStallMs")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub held_job_stall_ms: Option<u64>,
    /// How often it looks at how long a held job has shown no activity, in milliseconds.
    #[serde(rename = "heldJobStallCheckMs")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub held_job_stall_check_ms: Option<u64>,
    /// How long it waits for the record to acknowledge a commit of annotations, in milliseconds.
    #[serde(rename = "markCommitTimeoutMs")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub mark_commit_timeout_ms: Option<u64>,
}

impl ClaimOptions {
    /// The `ClaimOptions` that states these and nothing else.
    pub fn new(accepts: Vec<JobFilter>) -> Self {
        Self {
            accepts,
            job_claim_timeout_ms: None,
            held_job_stall_ms: None,
            held_job_stall_check_ms: None,
            mark_commit_timeout_ms: None,
        }
    }
}

schema!(ClaimOptions);

/// The form a service account that holds a client secret posts to its issuer's token endpoint for a client-credentials grant: its client id and secret in the body (RFC 6749 §2.3.1). An account that holds a key proves itself by the client assertion of client-assertion-cases.json instead.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct ClientSecretForm {
    /// The grant, client-assertion-cases.json's grantType.
    pub grant_type: ClientSecretFormGrantType,
    /// The account's client id.
    pub client_id: String,
    /// The account's client secret.
    pub client_secret: String,
}

impl ClientSecretForm {
    /// The `ClientSecretForm` that states these and nothing else.
    pub fn new(client_id: impl Into<String>, client_secret: impl Into<String>) -> Self {
        Self {
            grant_type: ClientSecretFormGrantType::ClientCredentials,
            client_id: client_id.into(),
            client_secret: client_secret.into(),
        }
    }
}

schema!(ClientSecretForm);

/// The grant, client-assertion-cases.json's grantType.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ClientSecretFormGrantType {
    #[serde(rename = "client_credentials")]
    ClientCredentials,
}

impl ClientSecretFormGrantType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ClientSecretFormGrantType::ClientCredentials => "client_credentials",
        }
    }
}

#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct CloneResourceWithTokenResponse {
    /// Generated clone token
    pub token: String,
    /// ISO 8601 timestamp when token expires
    #[serde(rename = "expiresAt")]
    pub expires_at: String,
    pub resource: ResourceDescriptor,
}

schema!(CloneResourceWithTokenResponse);

/// Error response for failed bus commands. Replaces native Error objects on the EventBus so payloads are serializable and OpenAPI-typed.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct CommandError {
    /// Machine-readable failure class, for consumers that must BRANCH on why a command failed rather than log it. Optional and deliberately sparse: absent means 'no class declared', and every existing failure stays that way. An enum rather than a free string so the vocabulary has an owner — an unconstrained code is a mirror with no gate, and adding one should be a deliberate spec change. `message` remains the human-readable text and is unaffected. Members: `peer-unavailable` — the channel this command was sent on has no subscriber, i.e. the service that answers it has not connected yet. Transient by nature (a peer still starting), which is what distinguishes it from a refusal: retrying is the correct response. `not-found` — the resource this command addressed does not exist in this knowledge base. A verdict, not a symptom: it is emitted only where the answer comes from the event store, which is the system of record, and never from a projection that may merely be lagging. Deterministic, so unlike `peer-unavailable` retrying is pointless — and consumers may act destructively on it (the SDK deletes a restored tab). Absence is not denial: a future 'exists, but not for you' must travel as its own code, never as this one. `unauthorized` — that code: the caller is authenticated but not permitted to do what it asked. A verdict about the CALLER, not the resource, so retrying under the same credential cannot succeed and a consumer must never spin on it; emitted by `job:claim` for a caller whose token carries no worker role. `none-pending` — a declined claim, not an error: the queue holds no pending job of the requested types. Nothing went wrong; the one code a consumer PARKS on, meaning 'nothing to do until a wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying neither is unclassified — a malformed record or a missing injection — and a consumer treats it as 'log it, assume nothing'.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub code: Option<CommandErrorCode>,
    /// Human-readable error message
    pub message: String,
    /// Optional additional context (stack trace, field name, etc.)
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub details: Option<String>,
}

impl CommandError {
    /// The `CommandError` that states these and nothing else.
    pub fn new(message: impl Into<String>) -> Self {
        Self {
            code: None,
            message: message.into(),
            details: None,
        }
    }
}

schema!(CommandError);

/// Machine-readable failure class, for consumers that must BRANCH on why a command failed rather than log it. Optional and deliberately sparse: absent means 'no class declared', and every existing failure stays that way. An enum rather than a free string so the vocabulary has an owner — an unconstrained code is a mirror with no gate, and adding one should be a deliberate spec change. `message` remains the human-readable text and is unaffected. Members: `peer-unavailable` — the channel this command was sent on has no subscriber, i.e. the service that answers it has not connected yet. Transient by nature (a peer still starting), which is what distinguishes it from a refusal: retrying is the correct response. `not-found` — the resource this command addressed does not exist in this knowledge base. A verdict, not a symptom: it is emitted only where the answer comes from the event store, which is the system of record, and never from a projection that may merely be lagging. Deterministic, so unlike `peer-unavailable` retrying is pointless — and consumers may act destructively on it (the SDK deletes a restored tab). Absence is not denial: a future 'exists, but not for you' must travel as its own code, never as this one. `unauthorized` — that code: the caller is authenticated but not permitted to do what it asked. A verdict about the CALLER, not the resource, so retrying under the same credential cannot succeed and a consumer must never spin on it; emitted by `job:claim` for a caller whose token carries no worker role. `none-pending` — a declined claim, not an error: the queue holds no pending job of the requested types. Nothing went wrong; the one code a consumer PARKS on, meaning 'nothing to do until a wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying neither is unclassified — a malformed record or a missing injection — and a consumer treats it as 'log it, assume nothing'.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum CommandErrorCode {
    #[serde(rename = "peer-unavailable")]
    PeerUnavailable,
    #[serde(rename = "not-found")]
    NotFound,
    #[serde(rename = "unauthorized")]
    Unauthorized,
    #[serde(rename = "none-pending")]
    NonePending,
}

impl CommandErrorCode {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            CommandErrorCode::PeerUnavailable => "peer-unavailable",
            CommandErrorCode::NotFound => "not-found",
            CommandErrorCode::Unauthorized => "unauthorized",
            CommandErrorCode::NonePending => "none-pending",
        }
    }
}

/// What a commenting job takes: passages of the resource are marked, each with a comment the model writes.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct CommentingJobParams {
    pub motivation: CommentingJobParamsMotivation,
    /// What to look for, in the caller's words. Added to the prompt.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub instructions: Option<String>,
    /// The voice the comments are written in.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub tone: Option<CommentingJobParamsTone>,
    /// How many annotations to aim for per 2000 words of the resource.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub density: Option<f64>,
    /// The language the annotations' own text is written in. BCP 47.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub language: Option<String>,
    /// The language of the resource being read. BCP 47.
    #[serde(rename = "sourceLanguage")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub source_language: Option<String>,
}

impl Default for CommentingJobParams {
    fn default() -> Self {
        Self::new()
    }
}

impl CommentingJobParams {
    /// The `CommentingJobParams` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            motivation: CommentingJobParamsMotivation::Commenting,
            instructions: None,
            tone: None,
            density: None,
            language: None,
            source_language: None,
        }
    }
}

schema!(CommentingJobParams);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum CommentingJobParamsMotivation {
    #[serde(rename = "commenting")]
    Commenting,
}

impl CommentingJobParamsMotivation {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            CommentingJobParamsMotivation::Commenting => "commenting",
        }
    }
}

/// The voice the comments are written in.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum CommentingJobParamsTone {
    #[serde(rename = "scholarly")]
    Scholarly,
    #[serde(rename = "explanatory")]
    Explanatory,
    #[serde(rename = "conversational")]
    Conversational,
    #[serde(rename = "technical")]
    Technical,
}

impl CommentingJobParamsTone {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            CommentingJobParamsTone::Scholarly => "scholarly",
            CommentingJobParamsTone::Explanatory => "explanatory",
            CommentingJobParamsTone::Conversational => "conversational",
            CommentingJobParamsTone::Technical => "technical",
        }
    }
}

/// A request on the bus a live case expects the client to make, on this channel; `as` names its correlation id, for the backend to answer.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceBusFetch {
    /// The request's channel, a request of specs/src/bus/registry.json.
    pub fetch: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub payload: Option<serde_json::Value>,
    /// The request's correlation id, for the backend's answer.
    pub r#as: String,
}

impl ConformanceBusFetch {
    /// The `ConformanceBusFetch` that states these and nothing else.
    pub fn new(fetch: impl Into<String>, r#as: impl Into<String>) -> Self {
        Self {
            fetch: fetch.into(),
            payload: None,
            r#as: r#as.into(),
        }
    }
}

schema!(ConformanceBusFetch);

/// One case of the conformance corpus: a scenario every SDK's driver is put through, a JSON file of conformance/sdk/wire, conformance/sdk/live or conformance/worker/cases named by the case. What the client is asked to do, what the backend does around it, and the transcript a conforming client produces. conformance/sdk/README.md explains each step; the reader reads every file of the corpus through this schema.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceCase {
    /// What the case holds a client to, in a sentence.
    pub about: String,
    /// Where the protocol or the spec states it.
    pub source: String,
    /// The signal planes the case runs on. Absent, it runs on both.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub planes: Option<Vec<ConformanceCasePlanesItem>>,
    /// A live case's tier: `fleet`, what every SDK with a live layer does, or `parity`, what one that implements all of CACHE-SEMANTICS does.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub tier: Option<ConformanceCaseTier>,
    /// Run the client exporting to an OTLP receiver, and once it has exited hold what it exported to specs/src/sdk-telemetry/telemetry.json. A worker case also holds the worker to a trace of its own for each job it ran (conformance/worker/README.md).
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub telemetry: Option<bool>,
    /// The steps, run in order.
    pub steps: Vec<ConformanceStep>,
}

impl ConformanceCase {
    /// The `ConformanceCase` that states these and nothing else.
    pub fn new(
        about: impl Into<String>,
        source: impl Into<String>,
        steps: Vec<ConformanceStep>,
    ) -> Self {
        Self {
            about: about.into(),
            source: source.into(),
            planes: None,
            tier: None,
            telemetry: None,
            steps,
        }
    }
}

schema!(ConformanceCase);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ConformanceCasePlanesItem {
    #[serde(rename = "in-process")]
    InProcess,
    #[serde(rename = "nats")]
    Nats,
}

impl ConformanceCasePlanesItem {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ConformanceCasePlanesItem::InProcess => "in-process",
            ConformanceCasePlanesItem::Nats => "nats",
        }
    }
}

/// A live case's tier: `fleet`, what every SDK with a live layer does, or `parity`, what one that implements all of CACHE-SEMANTICS does.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ConformanceCaseTier {
    #[serde(rename = "fleet")]
    Fleet,
    #[serde(rename = "parity")]
    Parity,
}

impl ConformanceCaseTier {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ConformanceCaseTier::Fleet => "fleet",
            ConformanceCaseTier::Parity => "parity",
        }
    }
}

/// A line a conformance driver writes on its standard output, one JSON object each (conformance/sdk/README.md, "The driver protocol"; conformance/worker/README.md, "The worker driver"): that it is ready, an operation's outcome, or what its client observed as it happened. The suite refuses any other line.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum ConformanceDriverLine {
    Ready(ConformanceDriverLineReady),
    Ok(ConformanceDriverLineOk),
    Failed(ConformanceDriverLineFailed),
    Abandoned(ConformanceDriverLineAbandoned),
    Unsupported(ConformanceDriverLineUnsupported),
    Misuse(ConformanceDriverLineMisuse),
    State(ConformanceDriverLineState),
    Frame(ConformanceDriverLineFrame),
    ErrorStream(ConformanceDriverLineErrorStream),
    Progress(ConformanceDriverLineProgress),
    Emission(ConformanceDriverLineEmission),
    Completed(ConformanceDriverLineCompleted),
    Claimed(ConformanceDriverLineClaimed),
    Refused(ConformanceDriverLineRefused),
    Signalled(ConformanceDriverLineSignalled),
    Stalled(ConformanceDriverLineStalled),
}

schema!(ConformanceDriverLine);

/// The suite abandoned the operation, and the SDK reported nothing else.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineAbandoned {
    /// The operation's id.
    pub id: u64,
    /// It was abandoned.
    pub abandoned: bool,
}

/// A worker driver: its worker claimed a job.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineClaimed {
    /// The job, as the worker read the record.
    pub claimed: std::collections::BTreeMap<String, serde_json::Value>,
}

/// The live driver: the observer's live query completed.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineCompleted {
    /// The observer.
    pub completed: String,
}

/// The live driver: an observer was given a state.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineEmission {
    /// The emission.
    pub emission: ConformanceDriverLineEmissionEmission,
}

/// The emission.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineEmissionEmission {
    /// The observer.
    pub observer: String,
    /// The state.
    pub state: ConformanceDriverLineEmissionEmissionState,
}

/// The state.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum ConformanceDriverLineEmissionEmissionState {
    Pending(ConformanceDriverLineEmissionEmissionStatePending),
    Ready(ConformanceDriverLineEmissionEmissionStateReady),
    Failed(ConformanceDriverLineEmissionEmissionStateFailed),
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineEmissionEmissionStateFailed {
    /// The query failed.
    pub status: ConformanceDriverLineEmissionEmissionStateFailedStatus,
    /// The failure.
    pub error: ConformanceFailure,
}

impl ConformanceDriverLineEmissionEmissionStateFailed {
    /// The `ConformanceDriverLineEmissionEmissionStateFailed` that states these and nothing else.
    pub fn new(error: ConformanceFailure) -> Self {
        Self {
            status: ConformanceDriverLineEmissionEmissionStateFailedStatus::Failed,
            error,
        }
    }
}

/// The query failed.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ConformanceDriverLineEmissionEmissionStateFailedStatus {
    #[serde(rename = "failed")]
    Failed,
}

impl ConformanceDriverLineEmissionEmissionStateFailedStatus {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ConformanceDriverLineEmissionEmissionStateFailedStatus::Failed => "failed",
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineEmissionEmissionStatePending {
    /// Nothing to show yet.
    pub status: ConformanceDriverLineEmissionEmissionStatePendingStatus,
}

impl Default for ConformanceDriverLineEmissionEmissionStatePending {
    fn default() -> Self {
        Self::new()
    }
}

impl ConformanceDriverLineEmissionEmissionStatePending {
    /// The `ConformanceDriverLineEmissionEmissionStatePending` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            status: ConformanceDriverLineEmissionEmissionStatePendingStatus::Pending,
        }
    }
}

/// Nothing to show yet.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ConformanceDriverLineEmissionEmissionStatePendingStatus {
    #[serde(rename = "pending")]
    Pending,
}

impl ConformanceDriverLineEmissionEmissionStatePendingStatus {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ConformanceDriverLineEmissionEmissionStatePendingStatus::Pending => "pending",
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineEmissionEmissionStateReady {
    /// A value to show.
    pub status: ConformanceDriverLineEmissionEmissionStateReadyStatus,
    pub value: serde_json::Value,
}

impl ConformanceDriverLineEmissionEmissionStateReady {
    /// The `ConformanceDriverLineEmissionEmissionStateReady` that states these and nothing else.
    pub fn new(value: serde_json::Value) -> Self {
        Self {
            status: ConformanceDriverLineEmissionEmissionStateReadyStatus::Ready,
            value,
        }
    }
}

/// A value to show.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ConformanceDriverLineEmissionEmissionStateReadyStatus {
    #[serde(rename = "ready")]
    Ready,
}

impl ConformanceDriverLineEmissionEmissionStateReadyStatus {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ConformanceDriverLineEmissionEmissionStateReadyStatus::Ready => "ready",
        }
    }
}

/// The error stream carried a failure.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineErrorStream {
    /// The failure.
    pub error: ConformanceFailure,
}

/// The SDK failed the operation.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineFailed {
    /// The operation's id.
    pub id: u64,
    /// The failure.
    pub error: ConformanceFailure,
}

/// A frame was delivered on a channel the driver listens to.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineFrame {
    /// The frame.
    pub frame: ConformanceDriverLineFrameFrame,
}

/// The frame.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineFrameFrame {
    /// The channel.
    pub channel: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub payload: Option<serde_json::Value>,
    /// The frame's correlation id, when it has one.
    #[serde(rename = "correlationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub correlation_id: Option<String>,
    /// The frame's scope, when it has one.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub scope: Option<ResourceId>,
}

impl ConformanceDriverLineFrameFrame {
    /// The `ConformanceDriverLineFrameFrame` that states these and nothing else.
    pub fn new(channel: impl Into<String>) -> Self {
        Self {
            channel: channel.into(),
            payload: None,
            correlation_id: None,
            scope: None,
        }
    }
}

/// The suite's arguments made no sense: the suite's mistake, never the SDK's.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineMisuse {
    /// The operation's id.
    pub id: u64,
    /// What made no sense.
    pub misuse: String,
}

/// The operation succeeded.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineOk {
    /// The operation's id.
    pub id: u64,
    pub ok: serde_json::Value,
}

/// An upload reported how much of it has been sent.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineProgress {
    /// The report.
    pub progress: ConformanceDriverLineProgressProgress,
}

/// The report.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineProgressProgress {
    /// The `upload` operation's id.
    pub upload: u64,
    /// How many bytes it has sent.
    #[serde(rename = "bytesUploaded")]
    pub bytes_uploaded: u64,
    /// How many it will send.
    #[serde(rename = "totalBytes")]
    pub total_bytes: u64,
}

/// The driver can take operations.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineReady {
    /// Written once.
    pub ready: bool,
}

/// A worker driver: a claim was refused.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineRefused {
    /// The refusal: with a code when the bus refused it, with none when the worker did.
    pub refused: ConformanceFailure,
}

/// A worker driver: a held job's cancellation was signalled.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineSignalled {
    /// The job's id.
    pub signalled: String,
}

/// A worker driver: a held job stalled.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineStalled {
    /// The job's id.
    pub stalled: String,
}

/// The transport's connection state changed.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineState {
    /// The state it is in now: one a case's `state` step names (ConformanceStep.json), or another the case never waits for.
    pub state: String,
}

/// The driver has no such operation. It says so at once, before it reads its next operation.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceDriverLineUnsupported {
    /// The operation's id.
    pub id: u64,
    /// It has none.
    pub unsupported: bool,
}

/// A failure as an SDK reports it to the suite (conformance/sdk/README.md, "The driver protocol"): its code, the status when a server stated one, and a job failure's class when it has one; and the SDK's own words for it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceFailure {
    /// The SDK's code for it, from specs/src/errors/codes.json.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub code: Option<String>,
    /// The HTTP status, when a server stated one.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub status: Option<i64>,
    /// A job failure's class, when it has one.
    #[serde(rename = "failureClass")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub failure_class: Option<FailureClass>,
    /// The SDK's words, for a person; nothing compares it.
    pub detail: String,
}

impl ConformanceFailure {
    /// The `ConformanceFailure` that states these and nothing else.
    pub fn new(detail: impl Into<String>) -> Self {
        Self {
            code: None,
            status: None,
            failure_class: None,
            detail: detail.into(),
        }
    }
}

schema!(ConformanceFailure);

/// A read over HTTP a live case expects the client to make: an operation of the gateway's API by its method and path, with the values its path carries. The stand-in Archivist answers it from what the case seeded.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceHttpFetch {
    /// The operation, by its method and path.
    pub fetch: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub params: Option<serde_json::Value>,
}

impl ConformanceHttpFetch {
    /// The `ConformanceHttpFetch` that states these and nothing else.
    pub fn new(fetch: impl Into<String>) -> Self {
        Self {
            fetch: fetch.into(),
            params: None,
        }
    }
}

schema!(ConformanceHttpFetch);

/// The implementations manifest: the file a run of the conformance harness is given with --implementations, naming what the run holds to Protocol. Every service is run by the xynolog launcher, from the image the knowledge base's stack documents name (contract/LAUNCHER-CONTROL.md, service.run): an implementation is a knowledge base whose documents name its images, and another implementation is another manifest. Each SDK's drivers are programs the harness starts itself, since none is a service. There is no default manifest. The reader reads this schema in the table dialect and derives its model (Tables.Conformance_implementations), for the harness to decode a manifest by.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceImplementations {
    /// How the launcher's control API is served: the xynolog command, run with control. A command and its arguments, as the harness starts it. An argument that starts with ./ or ../ is a path, resolved against the manifest's own directory; every other is passed as written.
    pub launcher: Vec<String>,
    /// The knowledge base whose stack documents name each service's image, and whose stack runs the record and index the suites need. A relative root is resolved against the manifest's own directory.
    pub target: LocalTarget,
    /// Each SDK's drivers, by the SDK's name: the programs the SDK and worker suites talk to in its place (conformance/sdk/README.md, "The driver protocol").
    pub sdks: std::collections::BTreeMap<String, ConformanceImplementationsSdksValue>,
    /// The model catalogue the implementation supplies, by its path; a relative one is resolved against the manifest's own directory. The Librarian's and the worker service's documents name one, so a run of either suite without it refuses to start.
    #[serde(rename = "modelCatalogue")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub model_catalogue: Option<String>,
}

impl ConformanceImplementations {
    /// The `ConformanceImplementations` that states these and nothing else.
    pub fn new(
        launcher: Vec<String>,
        target: LocalTarget,
        sdks: std::collections::BTreeMap<String, ConformanceImplementationsSdksValue>,
    ) -> Self {
        Self {
            launcher,
            target,
            sdks,
            model_catalogue: None,
        }
    }
}

schema!(ConformanceImplementations);

/// One SDK's drivers.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceImplementationsSdksValue {
    /// How its wire driver is started. A command and its arguments, as the harness starts it. An argument that starts with ./ or ../ is a path, resolved against the manifest's own directory; every other is passed as written.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub wire: Option<Vec<String>>,
    /// How its live driver is started, and the tier of the live corpus the SDK is held to.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub live: Option<ConformanceImplementationsSdksValueLive>,
    /// How its worker driver is started, when the SDK has a worker's surface (conformance/worker/README.md). A command and its arguments, as the harness starts it. An argument that starts with ./ or ../ is a path, resolved against the manifest's own directory; every other is passed as written.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub worker: Option<Vec<String>>,
    /// The wire cases its driver cannot be put through, by the case's name, each with why. The suite holds an exemption as it holds a case: the driver must answer unsupported to what the case asks, or the exemption is stale.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub exempt: Option<std::collections::BTreeMap<String, String>>,
}

/// How its live driver is started, and the tier of the live corpus the SDK is held to.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceImplementationsSdksValueLive {
    /// How its live driver is started. A command and its arguments, as the harness starts it. An argument that starts with ./ or ../ is a path, resolved against the manifest's own directory; every other is passed as written.
    pub command: Vec<String>,
    /// A live case's tier: `fleet`, what every SDK with a live layer does, or `parity`, what one that implements all of CACHE-SEMANTICS does.
    pub tier: ConformanceImplementationsSdksValueLiveTier,
}

/// A live case's tier: `fleet`, what every SDK with a live layer does, or `parity`, what one that implements all of CACHE-SEMANTICS does.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ConformanceImplementationsSdksValueLiveTier {
    #[serde(rename = "fleet")]
    Fleet,
    #[serde(rename = "parity")]
    Parity,
}

impl ConformanceImplementationsSdksValueLiveTier {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ConformanceImplementationsSdksValueLiveTier::Fleet => "fleet",
            ConformanceImplementationsSdksValueLiveTier::Parity => "parity",
        }
    }
}

/// One step of a case of the conformance corpus (ConformanceCase.json): each is told apart by the member only it requires. conformance/sdk/README.md, "A case", says what each does.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum ConformanceStep {
    Let(ConformanceStepLet),
    Driver(ConformanceStepDriver),
    Abandon(ConformanceStepAbandon),
    Settles(ConformanceStepSettles),
    Wire(ConformanceStepWire),
    Carried(ConformanceStepCarried),
    Closed(ConformanceStepClosed),
    Progress(ConformanceStepProgress),
    State(ConformanceStepState),
    Stays(ConformanceStepStays),
    Frame(ConformanceStepFrame),
    Frames(ConformanceStepFrames),
    Error(ConformanceStepError),
    Backend(ConformanceStepBackend),
    Quiet(ConformanceStepQuiet),
    Observe(ConformanceStepObserve),
    Leave(ConformanceStepLeave),
    Reaches(ConformanceStepReaches),
    Holds(ConformanceStepHolds),
    Completes(ConformanceStepCompletes),
    BusFetch(ConformanceBusFetch),
    HttpFetch(ConformanceHttpFetch),
    Fetches(ConformanceStepFetches),
    Scopes(ConformanceStepScopes),
    Claimed(ConformanceStepClaimed),
    Refused(ConformanceStepRefused),
    Signalled(ConformanceStepSignalled),
    Stalled(ConformanceStepStalled),
}

member!(ConformanceStep::BusFetch(ConformanceBusFetch));
member!(ConformanceStep::HttpFetch(ConformanceHttpFetch));
schema!(ConformanceStep);

/// Abandon an operation started with `as`, as its caller would.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepAbandon {
    /// The operation.
    pub abandon: String,
}

/// The backend does something (conformance/sdk/README.md, "Backend directives").
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepBackend {
    /// The directive.
    pub backend: ConformanceStepBackendBackend,
    /// The directive's arguments.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub with: Option<std::collections::BTreeMap<String, serde_json::Value>>,
}

impl ConformanceStepBackend {
    /// The `ConformanceStepBackend` that states these and nothing else.
    pub fn new(backend: ConformanceStepBackendBackend) -> Self {
        Self {
            backend,
            with: None,
        }
    }
}

/// The directive.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ConformanceStepBackendBackend {
    #[serde(rename = "listen")]
    Listen,
    #[serde(rename = "emit")]
    Emit,
    #[serde(rename = "record")]
    Record,
    #[serde(rename = "content")]
    Content,
    #[serde(rename = "description")]
    Description,
    #[serde(rename = "annotations")]
    Annotations,
    #[serde(rename = "anchored-text")]
    AnchoredText,
    #[serde(rename = "uploaded")]
    Uploaded,
    #[serde(rename = "refuse")]
    Refuse,
    #[serde(rename = "unanswered")]
    Unanswered,
    #[serde(rename = "answer-lost")]
    AnswerLost,
    #[serde(rename = "hold")]
    Hold,
    #[serde(rename = "release")]
    Release,
    #[serde(rename = "rechunk")]
    Rechunk,
    #[serde(rename = "carry")]
    Carry,
    #[serde(rename = "cut")]
    Cut,
    #[serde(rename = "down")]
    Down,
    #[serde(rename = "up")]
    Up,
    #[serde(rename = "archivist")]
    Archivist,
}

impl ConformanceStepBackendBackend {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ConformanceStepBackendBackend::Listen => "listen",
            ConformanceStepBackendBackend::Emit => "emit",
            ConformanceStepBackendBackend::Record => "record",
            ConformanceStepBackendBackend::Content => "content",
            ConformanceStepBackendBackend::Description => "description",
            ConformanceStepBackendBackend::Annotations => "annotations",
            ConformanceStepBackendBackend::AnchoredText => "anchored-text",
            ConformanceStepBackendBackend::Uploaded => "uploaded",
            ConformanceStepBackendBackend::Refuse => "refuse",
            ConformanceStepBackendBackend::Unanswered => "unanswered",
            ConformanceStepBackendBackend::AnswerLost => "answer-lost",
            ConformanceStepBackendBackend::Hold => "hold",
            ConformanceStepBackendBackend::Release => "release",
            ConformanceStepBackendBackend::Rechunk => "rechunk",
            ConformanceStepBackendBackend::Carry => "carry",
            ConformanceStepBackendBackend::Cut => "cut",
            ConformanceStepBackendBackend::Down => "down",
            ConformanceStepBackendBackend::Up => "up",
            ConformanceStepBackendBackend::Archivist => "archivist",
        }
    }
}

/// The stream a wire step named has carried this frame to the client.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepCarried {
    /// The stream.
    pub carried: String,
    pub is: serde_json::Value,
}

/// A worker case: the next job the worker reports as claimed, as it read the record.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepClaimed {
    pub claimed: serde_json::Value,
}

/// The request a `wire` step named has ended with no answer reaching the client: the client closed it, or the proxy kept the gateway's answer from it (`answer-lost`).
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepClosed {
    /// The request.
    pub closed: String,
}

/// Live: the observer's live query completes.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepCompletes {
    /// The observer.
    pub completes: String,
}

/// Ask the driver for an operation. It must succeed, with `returns` when given, or fail with `fails`. With `as`, the step does not wait: a later `settles` step does.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepDriver {
    /// The operation (conformance/sdk/README.md, "Operations").
    pub driver: String,
    /// The operation's arguments.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub with: Option<std::collections::BTreeMap<String, serde_json::Value>>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub returns: Option<serde_json::Value>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub fails: Option<serde_json::Value>,
    /// The operation's name, for the `settles` or `abandon` step that ends it.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub r#as: Option<String>,
}

impl ConformanceStepDriver {
    /// The `ConformanceStepDriver` that states these and nothing else.
    pub fn new(driver: impl Into<String>) -> Self {
        Self {
            driver: driver.into(),
            with: None,
            returns: None,
            fails: None,
            r#as: None,
        }
    }
}

/// The next failure on the client's error stream is this one.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepError {
    pub error: serde_json::Value,
}

/// Live: the next requests the client makes of a service are these, in whatever order it makes them.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepFetches {
    /// The requests.
    pub fetches: Vec<ConformanceStepFetchesFetchesItem>,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum ConformanceStepFetchesFetchesItem {
    BusFetch(ConformanceBusFetch),
    HttpFetch(ConformanceHttpFetch),
}

member!(ConformanceStepFetchesFetchesItem::BusFetch(
    ConformanceBusFetch,
));
member!(ConformanceStepFetchesFetchesItem::HttpFetch(
    ConformanceHttpFetch,
));

/// The next frame the client delivers on this channel is this one.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepFrame {
    /// The channel.
    pub frame: String,
    pub is: serde_json::Value,
}

/// The client delivers this many more frames on this channel. What they are is held, as every frame is, to what the gateway sent.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepFrames {
    /// The channel.
    pub frames: String,
    /// How many more.
    pub count: u64,
}

/// Live: the state the observer holds now is this one.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepHolds {
    /// The observer.
    pub holds: String,
    pub state: serde_json::Value,
}

/// Live: the observer stops observing.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepLeave {
    /// The observer.
    pub leave: String,
}

/// Name values for later steps.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepLet {
    /// Each name, and the value it takes.
    pub r#let: std::collections::BTreeMap<String, serde_json::Value>,
}

/// Live: an observer, named by `as`, begins observing a live query.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepObserve {
    /// The live query.
    pub observe: ConformanceStepObserveObserve,
    /// The observer.
    pub r#as: String,
}

/// The live query.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepObserveObserve {
    /// The live query, by its name in specs/src/client/refresh.json.
    pub query: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resource: Option<serde_json::Value>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotation: Option<serde_json::Value>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub search: Option<serde_json::Value>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub filters: Option<serde_json::Value>,
}

impl ConformanceStepObserveObserve {
    /// The `ConformanceStepObserveObserve` that states these and nothing else.
    pub fn new(query: impl Into<String>) -> Self {
        Self {
            query: query.into(),
            resource: None,
            annotation: None,
            search: None,
            filters: None,
        }
    }
}

/// An upload started with `as`, and not yet settled, has reported all of it sent: every report states the same total, none states less than the one before, and the last states the total.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepProgress {
    /// The upload.
    pub progress: String,
}

/// The client puts nothing more on the wire for this many milliseconds.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepQuiet {
    /// How long, in milliseconds.
    pub quiet: u64,
}

/// Live: the observer comes to hold this state.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepReaches {
    /// The observer.
    pub reaches: String,
    pub state: serde_json::Value,
}

/// A worker case: the next refusal of a claim the worker reports.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepRefused {
    pub refused: serde_json::Value,
}

/// Live: the client's stream comes to name exactly these scopes.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepScopes {
    /// The scopes.
    pub scopes: Vec<serde_json::Value>,
}

/// An operation started with `as` settles: it succeeded, with `returns` when given; or failed with `fails`; or, `abandoned`, it ended because the case abandoned it and reported nothing.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepSettles {
    /// The operation.
    pub settles: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub returns: Option<serde_json::Value>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub fails: Option<serde_json::Value>,
    /// It ended because the case abandoned it.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub abandoned: Option<bool>,
}

impl ConformanceStepSettles {
    /// The `ConformanceStepSettles` that states these and nothing else.
    pub fn new(settles: impl Into<String>) -> Self {
        Self {
            settles: settles.into(),
            returns: None,
            fails: None,
            abandoned: None,
        }
    }
}

/// A worker case: the next held job whose cancellation the worker says was signalled.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepSignalled {
    pub signalled: serde_json::Value,
}

/// A worker case: the next held job the worker says has stalled.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepStalled {
    pub stalled: serde_json::Value,
}

/// The transport comes to report this state.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepState {
    /// The state.
    pub state: ConformanceStepStateState,
}

/// The state.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ConformanceStepStateState {
    #[serde(rename = "initial")]
    Initial,
    #[serde(rename = "connecting")]
    Connecting,
    #[serde(rename = "open")]
    Open,
    #[serde(rename = "reconnecting")]
    Reconnecting,
    #[serde(rename = "degraded")]
    Degraded,
    #[serde(rename = "unauthenticated")]
    Unauthenticated,
    #[serde(rename = "closed")]
    Closed,
}

impl ConformanceStepStateState {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ConformanceStepStateState::Initial => "initial",
            ConformanceStepStateState::Connecting => "connecting",
            ConformanceStepStateState::Open => "open",
            ConformanceStepStateState::Reconnecting => "reconnecting",
            ConformanceStepStateState::Degraded => "degraded",
            ConformanceStepStateState::Unauthenticated => "unauthenticated",
            ConformanceStepStateState::Closed => "closed",
        }
    }
}

/// The transport is in this state and has reported no other since the case last read its state.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepStays {
    /// The state.
    pub stays: ConformanceStepStaysStays,
}

/// The state.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ConformanceStepStaysStays {
    #[serde(rename = "initial")]
    Initial,
    #[serde(rename = "connecting")]
    Connecting,
    #[serde(rename = "open")]
    Open,
    #[serde(rename = "reconnecting")]
    Reconnecting,
    #[serde(rename = "degraded")]
    Degraded,
    #[serde(rename = "unauthenticated")]
    Unauthenticated,
    #[serde(rename = "closed")]
    Closed,
}

impl ConformanceStepStaysStays {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ConformanceStepStaysStays::Initial => "initial",
            ConformanceStepStaysStays::Connecting => "connecting",
            ConformanceStepStaysStays::Open => "open",
            ConformanceStepStaysStays::Reconnecting => "reconnecting",
            ConformanceStepStaysStays::Degraded => "degraded",
            ConformanceStepStaysStays::Unauthenticated => "unauthenticated",
            ConformanceStepStaysStays::Closed => "closed",
        }
    }
}

/// The next request the client put on the wire is this operation, with each field given.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConformanceStepWire {
    /// The operation of the gateway's API, by its method and path.
    pub wire: String,
    /// When it is read: on arrival, once answered (the default), or once its stream has caught up.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub at: Option<ConformanceStepWireAt>,
    /// The status it was answered with.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub status: Option<i64>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub params: Option<serde_json::Value>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub body: Option<serde_json::Value>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub token: Option<serde_json::Value>,
    /// The request's headers named here, each as a pattern; headers not named are not compared.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub headers: Option<std::collections::BTreeMap<String, serde_json::Value>>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub answer: Option<serde_json::Value>,
    /// The request's name, for a later step.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub r#as: Option<String>,
    /// A request named earlier, which was answered before this one arrived.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub follows: Option<String>,
    /// A request named earlier, answered with a Retry-After, which this one waited out.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub waited: Option<String>,
}

impl ConformanceStepWire {
    /// The `ConformanceStepWire` that states these and nothing else.
    pub fn new(wire: impl Into<String>) -> Self {
        Self {
            wire: wire.into(),
            at: None,
            status: None,
            params: None,
            body: None,
            token: None,
            headers: None,
            answer: None,
            r#as: None,
            follows: None,
            waited: None,
        }
    }
}

/// When it is read: on arrival, once answered (the default), or once its stream has caught up.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ConformanceStepWireAt {
    #[serde(rename = "arrival")]
    Arrival,
    #[serde(rename = "answer")]
    Answer,
    #[serde(rename = "live")]
    Live,
}

impl ConformanceStepWireAt {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ConformanceStepWireAt::Arrival => "arrival",
            ConformanceStepWireAt::Answer => "answer",
            ConformanceStepWireAt::Live => "live",
        }
    }
}

/// Who the knowledge base at an address says it is, asked with a token just issued, before any entry is made for it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ConnectionIdentity {
    /// The did it reports for itself.
    pub did: UserId,
    /// What it says of itself.
    pub description: KbDescription,
}

schema!(ConnectionIdentity);

/// Content format as a MIME type, optionally with parameters. The base type (everything before the first ';') MUST be a SupportedMediaType; parameters such as charset are preserved as metadata. Semantic validation happens in code at the create/yield boundary — there is deliberately no pattern here, the vocabulary lives in SupportedMediaType. Examples: text/plain, text/plain; charset=iso-8859-1, text/markdown; charset=windows-1252, image/png, application/pdf
pub type ContentFormat = String;

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct ContextualSummaryResponse {
    pub summary: String,
    /// What the summary is of: the resource the annotation is on, and the annotation's entity types.
    #[serde(rename = "relevantFields")]
    pub relevant_fields: ContextualSummaryResponseRelevantFields,
    pub context: ContextualSummaryResponseContext,
}

schema!(ContextualSummaryResponse);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct ContextualSummaryResponseContext {
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub before: Option<String>,
    pub selected: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub after: Option<String>,
}

impl ContextualSummaryResponseContext {
    /// The `ContextualSummaryResponseContext` that states these and nothing else.
    pub fn new(selected: impl Into<String>) -> Self {
        Self {
            before: None,
            selected: selected.into(),
            after: None,
        }
    }
}

/// What the summary is of: the resource the annotation is on, and the annotation's entity types.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ContextualSummaryResponseRelevantFields {
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    #[serde(rename = "resourceName")]
    pub resource_name: String,
    #[serde(rename = "entityTypes")]
    pub entity_types: Vec<String>,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct CreateAnnotationRequest {
    pub motivation: Motivation,
    pub target: AnnotationTarget,
    /// Optional body. Omit for annotations whose motivation alone is meaningful (highlighting) or whose user-supplied content is empty. Shape matches Annotation.body.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub body: Option<AnnotationBodies>,
}

impl CreateAnnotationRequest {
    /// The `CreateAnnotationRequest` that states these and nothing else.
    pub fn new(motivation: Motivation, target: AnnotationTarget) -> Self {
        Self {
            motivation,
            target,
            body: None,
        }
    }
}

schema!(CreateAnnotationRequest);

/// What creating a resource from a clone token is told: the token, the clone's name and text, and whether the source is archived once the clone exists.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct CreateFromTokenOptions {
    pub token: String,
    pub name: String,
    /// The clone's text, uploaded as its content.
    pub content: String,
    #[serde(rename = "archiveOriginal")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub archive_original: Option<bool>,
}

impl CreateFromTokenOptions {
    /// The `CreateFromTokenOptions` that states these and nothing else.
    pub fn new(
        token: impl Into<String>,
        name: impl Into<String>,
        content: impl Into<String>,
    ) -> Self {
        Self {
            token: token.into(),
            name: name.into(),
            content: content.into(),
            archive_original: None,
        }
    }
}

schema!(CreateFromTokenOptions);

/// The id of the resource an upload created. The Archivist answers it (200) once it has stored the bytes and recorded the resource, and the gateway forwards it (202), so the id is the one the record minted and its creation event is persisted. What remains asynchronous is downstream projection: graph, views and vectors settle afterwards.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct CreateResourceResponse {
    /// The id of the newly created resource, as the record minted it.
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
}

schema!(CreateResourceResponse);

/// The file a follower of the record keeps its cursors in: for each log of the record it follows, the sequence number of the last event of it taken (contract/TRANSPORT-CONTRACT.md § What repairs a passing frame). A file of the service's own disk, never of the knowledge base: a service that finds none starts each log as it starts one with no cursor, so losing it costs time and never correctness.
pub type CursorsPath = String;

/// What a device-authorization grant (RFC 8628) shows the person signing in: the code they enter, and where.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct DeviceCode {
    /// The code the person enters at the issuer.
    #[serde(rename = "userCode")]
    pub user_code: String,
    /// Where the person enters it.
    #[serde(rename = "verificationUri")]
    pub verification_uri: String,
    /// Where the person goes to sign in with the code already entered, when the issuer gives one.
    #[serde(rename = "verificationUriComplete")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub verification_uri_complete: Option<String>,
    /// How many seconds the code stays good for.
    #[serde(rename = "expiresIn")]
    pub expires_in: u64,
}

impl DeviceCode {
    /// The `DeviceCode` that states these and nothing else.
    pub fn new(
        user_code: impl Into<String>,
        verification_uri: impl Into<String>,
        expires_in: u64,
    ) -> Self {
        Self {
            user_code: user_code.into(),
            verification_uri: verification_uri.into(),
            verification_uri_complete: None,
            expires_in,
        }
    }
}

schema!(DeviceCode);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct DirEntry {
    pub r#type: DirEntryType,
    /// Entry name (basename)
    pub name: String,
    /// Path relative to project root
    pub path: String,
    /// Last modified time (ISO 8601)
    pub mtime: String,
}

impl DirEntry {
    /// The `DirEntry` that states these and nothing else.
    pub fn new(name: impl Into<String>, path: impl Into<String>, mtime: impl Into<String>) -> Self {
        Self {
            r#type: DirEntryType::Dir,
            name: name.into(),
            path: path.into(),
            mtime: mtime.into(),
        }
    }
}

schema!(DirEntry);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum DirEntryType {
    #[serde(rename = "dir")]
    Dir,
}

impl DirEntryType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            DirEntryType::Dir => "dir",
        }
    }
}

/// One entry in a directory listing: a file, which may carry the resource it was ingested as, or a subdirectory. Tell them apart by `type`, which is required on both and single-valued.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Serialize)]
#[serde(untagged)]
pub enum DirectoryEntry {
    FileEntry(FileEntry),
    DirEntry(DirEntry),
}

impl<'de> serde::Deserialize<'de> for DirectoryEntry {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("type").and_then(serde_json::Value::as_str) {
            Some("file") => serde_json::from_value(value).map(DirectoryEntry::FileEntry),
            Some("dir") => serde_json::from_value(value).map(DirectoryEntry::DirEntry),
            _ => {
                return Err(serde::de::Error::custom(
                    "a DirectoryEntry states a `type` that is one of `file`, `dir`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

member!(DirectoryEntry::FileEntry(FileEntry));
member!(DirectoryEntry::DirEntry(DirEntry));
schema!(DirectoryEntry);

/// One knowledge base the Xynolog launcher manages on this machine, as published in the discovery document (see DiscoveryDocument). Endpoints and identity only — never credentials; login remains the consumer's per-KB business.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct DiscoveredKB {
    /// Hostname the KB is reachable on from this machine (always "localhost" — local stacks bind locally and codespace KBs arrive through a local port forward)
    pub host: String,
    /// Local TCP port of the KB's API (the gateway port for a local stack; the allocated forward port for a codespace stack)
    pub port: i64,
    /// Where the stack actually runs. "local": containers on this machine. "codespace": a GitHub-hosted VM whose KB is port-forwarded here.
    pub placement: DiscoveredKBPlacement,
    /// owner/name GitHub slug — present for codespace placements, where the repo is the stack's identity
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub repo: Option<String>,
    /// The KB's did:web identifier, from its committed .xynolog/config.yaml — "did:web:" + its site.domain, verbatim. REQUIRED: a KB that declares no domain has no identity to publish, and the launcher refuses to start it rather than inventing or defaulting one. NOT unique within a document: a did names the knowledge base, not a running copy of it, so a local clone and a codespace of the same repo legitimately share one and both are published. host:port is the unique field (at most one entry per address), so consumers look up by ADDRESS and use the did to VERIFY that the copy they reached is the KB they meant — an address alone cannot say which KB is which, and an identity alone cannot say which copy.
    pub did: String,
    /// Human-readable site name from the KB's .xynolog/config.yaml (site.siteName), for display
    #[serde(rename = "siteName")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub site_name: Option<String>,
    /// The agent that owns this entry's lifecycle (the launcher writes "xynolog-launcher"). Consumers treat managed entries as authoritative for themselves — upsert on appearance, remove on disappearance — and never touch entries they did not write.
    #[serde(rename = "managedBy")]
    pub managed_by: String,
}

impl DiscoveredKB {
    /// The `DiscoveredKB` that states these and nothing else.
    pub fn new(
        host: impl Into<String>,
        port: i64,
        placement: DiscoveredKBPlacement,
        did: impl Into<String>,
        managed_by: impl Into<String>,
    ) -> Self {
        Self {
            host: host.into(),
            port,
            placement,
            repo: None,
            did: did.into(),
            site_name: None,
            managed_by: managed_by.into(),
        }
    }
}

schema!(DiscoveredKB);

/// Where the stack actually runs. "local": containers on this machine. "codespace": a GitHub-hosted VM whose KB is port-forwarded here.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum DiscoveredKBPlacement {
    #[serde(rename = "local")]
    Local,
    #[serde(rename = "codespace")]
    Codespace,
}

impl DiscoveredKBPlacement {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            DiscoveredKBPlacement::Local => "local",
            DiscoveredKBPlacement::Codespace => "codespace",
        }
    }
}

/// The launcher's KB discovery document — the schema authority for <stateDir>/discovery/kbs.json, which the Xynolog CLI (xynolog/cli) regenerates on every stack mutation and the Browser container mounts read-only at /discovery. NOT an API endpoint: a static document fetched same-origin by browsers (via the Browser's static server). An empty kbs list is meaningful ("the launcher manages nothing right now") and distinct from an absent file.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct DiscoveryDocument {
    /// Document schema version. Consumers MUST check it and ignore documents they do not understand.
    pub version: i64,
    /// Every KB the launcher currently manages, local and forwarded
    pub kbs: Vec<DiscoveredKB>,
}

impl DiscoveryDocument {
    /// The one `version` a `DiscoveryDocument` states.
    pub const VERSION: i64 = 1;

    /// The `DiscoveryDocument` that states these and nothing else.
    pub fn new(kbs: Vec<DiscoveredKB>) -> Self {
        Self {
            version: Self::VERSION,
            kbs,
        }
    }
}

schema!(DiscoveryDocument);

/// Everything the dispatcher reads at boot: nothing in it is defaulted by the dispatcher. The launcher writes it for the dispatcher it starts, from the knowledge base's stack documents, and the dispatcher reads it from the path its `--config` flag names (its image passes `/etc/xynolog/dispatcher.json`). Started without `--config`, or with a path that names no file, the dispatcher refuses to start and says which. Secrets are never values here: a field that needs one names the environment variable holding it. The dispatcher's other inputs are the environment variables specs/src/service-environment/variables.json lists for it, and the ones this document names. A document that does not validate is refused at boot, naming each failing field.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct DispatcherConfig {
    pub kb: KbIdentity,
    /// The URL the dispatcher reaches the gateway at: its only route to the bus.
    #[serde(rename = "gatewayUrl")]
    pub gateway_url: String,
    /// The issuer the dispatcher's service account signs in at.
    pub identity: ServiceIdentity,
    /// The JetStream broker holding the job queue, whose layout is specs/src/jobs/storage.json.
    pub queue: DispatcherConfigQueue,
    /// The port the dispatcher answers `/health` on.
    pub port: u16,
    /// The queue's clocks, in milliseconds. The launcher writes the values a deployment runs with; a test harness shrinks them.
    pub timing: DispatcherConfigTiming,
    #[serde(rename = "logLevel")]
    pub log_level: LogLevel,
    #[serde(rename = "logFormat")]
    pub log_format: LogFormat,
}

schema!(DispatcherConfig);

/// The JetStream broker holding the job queue, whose layout is specs/src/jobs/storage.json.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct DispatcherConfigQueue {
    /// The broker's address (`host:port`, or several, comma-separated).
    pub servers: String,
    /// The environment variable holding the broker user, when the broker requires one.
    #[serde(rename = "userEnv")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub user_env: Option<String>,
    /// The environment variable holding the broker password, when the broker requires one.
    #[serde(rename = "passwordEnv")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub password_env: Option<String>,
}

impl DispatcherConfigQueue {
    /// The `DispatcherConfigQueue` that states these and nothing else.
    pub fn new(servers: impl Into<String>) -> Self {
        Self {
            servers: servers.into(),
            user_env: None,
            password_env: None,
        }
    }
}

/// The queue's clocks, in milliseconds. The launcher writes the values a deployment runs with; a test harness shrinks them.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct DispatcherConfigTiming {
    /// How often the queue re-announces pending jobs and sweeps for dead workers. The re-announcement is insurance against a lost wake-up, not dispatch.
    #[serde(rename = "tickMs")]
    pub tick_ms: u64,
    /// How long a running job may go without progress, a checkpoint or a claim before its worker is presumed dead.
    #[serde(rename = "staleRunningMs")]
    pub stale_running_ms: u64,
    /// How long the broker waits, after this dispatcher stops renewing a job's lease, before redelivering its message.
    #[serde(rename = "ackWaitMs")]
    pub ack_wait_ms: u64,
    /// How long a concluded job is kept before it is deleted.
    #[serde(rename = "retentionMs")]
    pub retention_ms: u64,
    /// How often concluded jobs past `retentionMs` are deleted.
    #[serde(rename = "retentionSweepMs")]
    pub retention_sweep_ms: u64,
    /// The least time between two progress writes for one job; reports closer together than this are not written.
    #[serde(rename = "progressWriteIntervalMs")]
    pub progress_write_interval_ms: u64,
    /// How long the dispatcher waits at boot for the broker before it exits, so that a restart policy can retry.
    #[serde(rename = "bootDeadlineMs")]
    pub boot_deadline_ms: u64,
}

/// The dispatcher's liveness answer. It answers only once its queue has connected and its bus pumps are attached, so a 200 means it can take work.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct DispatcherHealth {
    pub status: DispatcherHealthStatus,
    /// The queue it holds.
    pub queue: DispatcherHealthQueue,
}

impl Default for DispatcherHealth {
    fn default() -> Self {
        Self::new()
    }
}

impl DispatcherHealth {
    /// The `DispatcherHealth` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            status: DispatcherHealthStatus::Ok,
            queue: DispatcherHealthQueue::Jetstream,
        }
    }
}

schema!(DispatcherHealth);

/// The queue it holds.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum DispatcherHealthQueue {
    #[serde(rename = "jetstream")]
    Jetstream,
}

impl DispatcherHealthQueue {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            DispatcherHealthQueue::Jetstream => "jetstream",
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum DispatcherHealthStatus {
    #[serde(rename = "ok")]
    Ok,
}

impl DispatcherHealthStatus {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            DispatcherHealthStatus::Ok => "ok",
        }
    }
}

/// dispatcher/messages.json: the words of the dispatcher's own refusals, and of the errors it writes into a job.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct DispatcherMessages {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    /// Each refusal the dispatcher makes itself, on the operation's failure channel.
    pub refusals: Vec<DispatcherMessagesRefusalsItem>,
    /// Each error the dispatcher writes into a job on its own, as a `job:fail` would.
    pub errors: Vec<DispatcherMessagesErrorsItem>,
}

schema!(DispatcherMessages);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct DispatcherMessagesErrorsItem {
    /// The situation's name.
    pub name: String,
    /// When it is written, and what fills each `{name}` of its text.
    pub situation: String,
    /// The `error` it writes into the job. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.
    pub error: String,
    #[serde(rename = "failureClass")]
    pub failure_class: FailureClass,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct DispatcherMessagesRefusalsItem {
    /// The situation's name.
    pub name: String,
    /// The operation it refuses: a request of bus/registry.json's operations that the dispatcher answers.
    pub operation: String,
    /// Machine-readable failure class, for consumers that must BRANCH on why a command failed rather than log it. Optional and deliberately sparse: absent means 'no class declared', and every existing failure stays that way. An enum rather than a free string so the vocabulary has an owner — an unconstrained code is a mirror with no gate, and adding one should be a deliberate spec change. `message` remains the human-readable text and is unaffected. Members: `peer-unavailable` — the channel this command was sent on has no subscriber, i.e. the service that answers it has not connected yet. Transient by nature (a peer still starting), which is what distinguishes it from a refusal: retrying is the correct response. `not-found` — the resource this command addressed does not exist in this knowledge base. A verdict, not a symptom: it is emitted only where the answer comes from the event store, which is the system of record, and never from a projection that may merely be lagging. Deterministic, so unlike `peer-unavailable` retrying is pointless — and consumers may act destructively on it (the SDK deletes a restored tab). Absence is not denial: a future 'exists, but not for you' must travel as its own code, never as this one. `unauthorized` — that code: the caller is authenticated but not permitted to do what it asked. A verdict about the CALLER, not the resource, so retrying under the same credential cannot succeed and a consumer must never spin on it; emitted by `job:claim` for a caller whose token carries no worker role. `none-pending` — a declined claim, not an error: the queue holds no pending job of the requested types. Nothing went wrong; the one code a consumer PARKS on, meaning 'nothing to do until a wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying neither is unclassified — a malformed record or a missing injection — and a consumer treats it as 'log it, assume nothing'.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub code: Option<DispatcherMessagesRefusalsItemCode>,
    /// When it is written, and what fills each `{name}` of its text.
    pub situation: String,
    /// The failure's `message`. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.
    pub message: String,
}

impl DispatcherMessagesRefusalsItem {
    /// The `DispatcherMessagesRefusalsItem` that states these and nothing else.
    pub fn new(
        name: impl Into<String>,
        operation: impl Into<String>,
        situation: impl Into<String>,
        message: impl Into<String>,
    ) -> Self {
        Self {
            name: name.into(),
            operation: operation.into(),
            code: None,
            situation: situation.into(),
            message: message.into(),
        }
    }
}

/// Machine-readable failure class, for consumers that must BRANCH on why a command failed rather than log it. Optional and deliberately sparse: absent means 'no class declared', and every existing failure stays that way. An enum rather than a free string so the vocabulary has an owner — an unconstrained code is a mirror with no gate, and adding one should be a deliberate spec change. `message` remains the human-readable text and is unaffected. Members: `peer-unavailable` — the channel this command was sent on has no subscriber, i.e. the service that answers it has not connected yet. Transient by nature (a peer still starting), which is what distinguishes it from a refusal: retrying is the correct response. `not-found` — the resource this command addressed does not exist in this knowledge base. A verdict, not a symptom: it is emitted only where the answer comes from the event store, which is the system of record, and never from a projection that may merely be lagging. Deterministic, so unlike `peer-unavailable` retrying is pointless — and consumers may act destructively on it (the SDK deletes a restored tab). Absence is not denial: a future 'exists, but not for you' must travel as its own code, never as this one. `unauthorized` — that code: the caller is authenticated but not permitted to do what it asked. A verdict about the CALLER, not the resource, so retrying under the same credential cannot succeed and a consumer must never spin on it; emitted by `job:claim` for a caller whose token carries no worker role. `none-pending` — a declined claim, not an error: the queue holds no pending job of the requested types. Nothing went wrong; the one code a consumer PARKS on, meaning 'nothing to do until a wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying neither is unclassified — a malformed record or a missing injection — and a consumer treats it as 'log it, assume nothing'.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum DispatcherMessagesRefusalsItemCode {
    #[serde(rename = "peer-unavailable")]
    PeerUnavailable,
    #[serde(rename = "not-found")]
    NotFound,
    #[serde(rename = "unauthorized")]
    Unauthorized,
    #[serde(rename = "none-pending")]
    NonePending,
}

impl DispatcherMessagesRefusalsItemCode {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            DispatcherMessagesRefusalsItemCode::PeerUnavailable => "peer-unavailable",
            DispatcherMessagesRefusalsItemCode::NotFound => "not-found",
            DispatcherMessagesRefusalsItemCode::Unauthorized => "unauthorized",
            DispatcherMessagesRefusalsItemCode::NonePending => "none-pending",
        }
    }
}

/// How a job's annotations were established as durable — the OBSERVATION, never a conclusion drawn from it. 'acknowledged': the event log confirmed the batch (mark:commit-ok). 'probe-confirmed': the acknowledgement was lost and a later read found the batch's last annotation present — true, but a weaker claim than an ack, since it rests on the log appending a batch in order and stopping at the first failure. 'probe-refused': the read returned a failure reply; note this does NOT assert the annotations are absent, because a read that failed for its own reasons answers on the same channel. 'probe-unreachable': no answer came at all, so nothing was established either way. ABSENT means the question never arose — a job that committed no annotations. Never defaulted: a manufactured value here is a claim nobody made, in a log nobody can rewrite.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum DurabilityEvidence {
    #[serde(rename = "acknowledged")]
    Acknowledged,
    #[serde(rename = "probe-confirmed")]
    ProbeConfirmed,
    #[serde(rename = "probe-refused")]
    ProbeRefused,
    #[serde(rename = "probe-unreachable")]
    ProbeUnreachable,
}

impl DurabilityEvidence {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            DurabilityEvidence::Acknowledged => "acknowledged",
            DurabilityEvidence::ProbeConfirmed => "probe-confirmed",
            DurabilityEvidence::ProbeRefused => "probe-refused",
            DurabilityEvidence::ProbeUnreachable => "probe-unreachable",
        }
    }
}

schema!(DurabilityEvidence);

/// The embedding provider a service asks for vectors, and what that kind of provider needs to be asked: one of the providers `xynolog-vectors` has, told apart by `type`. Two services that share an index name the same provider and the same model: a vector is compared only with vectors of the model that made it. A secret is never a value here: a provider's key is named by the environment variable that holds it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Serialize)]
#[serde(untagged)]
pub enum EmbeddingConfig {
    OllamaEmbeddingConfig(OllamaEmbeddingConfig),
    VoyageEmbeddingConfig(VoyageEmbeddingConfig),
}

impl<'de> serde::Deserialize<'de> for EmbeddingConfig {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("type").and_then(serde_json::Value::as_str) {
            Some("ollama") => {
                serde_json::from_value(value).map(EmbeddingConfig::OllamaEmbeddingConfig)
            }
            Some("voyage") => {
                serde_json::from_value(value).map(EmbeddingConfig::VoyageEmbeddingConfig)
            }
            _ => {
                return Err(serde::de::Error::custom(
                    "a EmbeddingConfig states a `type` that is one of `ollama`, `voyage`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

member!(EmbeddingConfig::OllamaEmbeddingConfig(
    OllamaEmbeddingConfig,
));
member!(EmbeddingConfig::VoyageEmbeddingConfig(
    VoyageEmbeddingConfig,
));
schema!(EmbeddingConfig);

/// embedding/requests.json: how a service asks its embedding provider for the vectors of many texts.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct EmbeddingRequests {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    /// How each kind of provider is asked, by its `type` (EmbeddingConfig): every kind, and no other.
    pub providers: std::collections::BTreeMap<String, EmbeddingRequestsProvidersValue>,
    /// How long each request has, counted from when it is sent and not from when its batch began. Asking a busy provider again is within it.
    #[serde(rename = "requestSeconds")]
    pub request_seconds: u64,
    /// A request for the vectors of documents that the provider answers busy is asked again, after each wait in turn, while the request's own time allows the wait. A provider busy at every asking fails the request with that status. A query is asked once.
    pub busy: EmbeddingRequestsBusy,
    /// How many times, at most, a starting service asks again a provider that answered 404, taken to be still fetching the model, or could not be reached, taken to be still starting: within the time the service has to start.
    #[serde(rename = "startAgain")]
    pub start_again: u64,
}

schema!(EmbeddingRequests);

/// A request for the vectors of documents that the provider answers busy is asked again, after each wait in turn, while the request's own time allows the wait. A provider busy at every asking fails the request with that status. A query is asked once.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct EmbeddingRequestsBusy {
    /// The statuses by which a provider says it is busy.
    pub statuses: Vec<u16>,
    /// The wait before each asking again, in order.
    #[serde(rename = "againAfterSeconds")]
    pub again_after_seconds: Vec<u64>,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct EmbeddingRequestsProvidersValue {
    /// How many texts one request carries, at most: a batch is cut into slices of this many, each one request, in the order of the texts.
    #[serde(rename = "textsPerRequest")]
    pub texts_per_request: u64,
    /// How many requests are made of the provider at once, however many resources are being indexed.
    #[serde(rename = "atOnce")]
    pub at_once: u64,
}

/// An object with no properties.
#[derive(
    Debug, Clone, Copy, PartialEq, Hash, Eq, Default, serde::Deserialize, serde::Serialize,
)]
#[serde(deny_unknown_fields)]
pub struct EmptyObject {}

/// An engine: an inference provider and a model, which software does a job or an actor's step with. An engine is not a principal: the principal that used one names it on each write it produced with it (`generator`). A person who does a job uses none.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct Engine {
    /// The inference provider: who serves the model. `anthropic`, `google`, `openai` and `together` are those companies' own APIs. `llamacpp`, `ollama` and `vllm` are servers a deployment runs or reaches, each named for the server's software.
    pub provider: EngineProvider,
    /// The model identifier, as the provider names it.
    pub model: String,
}

schema!(Engine);

/// One of the knowledge base's engines: a provider and a model its Inference document names, and the jobs the document has it used for. An engine is not a principal: whichever worker claims a job does it, under its own account, and names on each write the engine it used, if any. Carries no inference limits: the services that hold the inference credentials report those (InferenceLimitsResult).
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct EngineEntry {
    pub engine: Engine,
    /// The jobs the knowledge base's Inference document has this engine used for, as a claim names them. Absent for an engine only Librarian actors ask.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub jobs: Option<Vec<JobFilter>>,
}

impl EngineEntry {
    /// The `EngineEntry` that states these and nothing else.
    pub fn new(engine: Engine) -> Self {
        Self { engine, jobs: None }
    }
}

schema!(EngineEntry);

/// The discovered limits of one engine.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct EngineLimits {
    pub engine: Engine,
    pub limits: InferenceLimits,
}

schema!(EngineLimits);

/// The inference provider: who serves the model. `anthropic`, `google`, `openai` and `together` are those companies' own APIs. `llamacpp`, `ollama` and `vllm` are servers a deployment runs or reaches, each named for the server's software.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum EngineProvider {
    #[serde(rename = "anthropic")]
    Anthropic,
    #[serde(rename = "google")]
    Google,
    #[serde(rename = "llamacpp")]
    Llamacpp,
    #[serde(rename = "ollama")]
    Ollama,
    #[serde(rename = "openai")]
    Openai,
    #[serde(rename = "together")]
    Together,
    #[serde(rename = "vllm")]
    Vllm,
}

impl EngineProvider {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            EngineProvider::Anthropic => "anthropic",
            EngineProvider::Google => "google",
            EngineProvider::Llamacpp => "llamacpp",
            EngineProvider::Ollama => "ollama",
            EngineProvider::Openai => "openai",
            EngineProvider::Together => "together",
            EngineProvider::Vllm => "vllm",
        }
    }
}

/// Wire format for persisted events delivered over the bus SSE stream (GET /bus/subscribe). Extends StoredEventResponse with optional enrichment fields the EventStore populates from the materialized view at publish time (persistence → view → enrich → notification). Subscribers read the enrichment fields directly to update local caches without an additional fetch.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct EnrichedResourceEvent {
    /// Unique event ID (UUID)
    pub id: String,
    /// Event type (flow verb name, e.g. mark:added)
    pub r#type: String,
    /// When the event occurred
    pub timestamp: String,
    /// DID of the user who triggered the event
    #[serde(rename = "userId")]
    pub user_id: UserId,
    /// Resource this event affects (absent for system events)
    #[serde(rename = "resourceId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resource_id: Option<ResourceId>,
    /// Event schema version
    pub version: i64,
    /// Event-type-specific payload
    pub payload: serde_json::Map<String, serde_json::Value>,
    pub metadata: EventMetadata,
    /// Populated for events that mutate an annotation (mark:added, mark:body-updated, mark:removed). Carries the post-materialization annotation as it exists in the view, so subscribers can update local caches in-place without refetching. Absent for events that don't touch annotations.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotation: Option<Annotation>,
}

impl EnrichedResourceEvent {
    /// The `EnrichedResourceEvent` that states these and nothing else.
    pub fn new(
        id: impl Into<String>,
        r#type: impl Into<String>,
        timestamp: impl Into<String>,
        user_id: UserId,
        version: i64,
        payload: serde_json::Map<String, serde_json::Value>,
        metadata: EventMetadata,
    ) -> Self {
        Self {
            id: id.into(),
            r#type: r#type.into(),
            timestamp: timestamp.into(),
            user_id,
            resource_id: None,
            version,
            payload,
            metadata,
            annotation: None,
        }
    }
}

schema!(EnrichedResourceEvent);

/// Payload for mark:entity-tag-added and mark:entity-tag-removed domain events
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct EntityTagChangedPayload {
    #[serde(rename = "entityType")]
    pub entity_type: String,
}

schema!(EntityTagChangedPayload);

/// Payload for frame:entity-type-added domain event (system-level, no resourceId — fan-out is global)
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct EntityTypeAddedPayload {
    #[serde(rename = "entityType")]
    pub entity_type: String,
}

schema!(EntityTypeAddedPayload);

/// The knowledge base's entity-type vocabulary: the file `projections/__system__/entitytypes.json` under the state directory, the sum of the `frame:entity-type-added` events. Written as JSON indented by two spaces.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct EntityTypesProjection {
    /// Every entity type added, each once, sorted.
    #[serde(rename = "entityTypes")]
    pub entity_types: Vec<String>,
}

schema!(EntityTypesProjection);

/// `e-<publishId>` — the id of any other frame, given once when the frame is published: the same on every connection that carries it, through every replica, so a copy arriving on two connections (a reconnect overlap) dedups. Never a resumption watermark.
pub type EphemeralEventId = String;

/// The data of a control error: the launcher's code for the failure, one of specs/src/errors/codes.json's control group, and what a client can act on. A request's failure is never only a message.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ErrorData {
    /// Why the request failed: a code of the control group of specs/src/errors/codes.json.
    pub code: String,
    /// Whether the same request can succeed sent again unchanged, once something outside it changes: a start finishes, a runtime is installed, a stack comes up.
    pub retryable: bool,
    /// For params the contract refuses: each fault, where it is.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub fields: Option<Vec<FieldFault>>,
    /// For control.target-required and control.target-ambiguous: each target the request could have meant, to send again with one.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub choices: Option<Vec<Target>>,
    /// For control.unsupported-api-version: each version this launcher speaks.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub supported: Option<Vec<String>>,
    /// For a cancelled stack.start: whether services the start launched may still be running. The launcher stops waiting, and stops nothing.
    #[serde(rename = "mayStillRun")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub may_still_run: Option<bool>,
}

impl ErrorData {
    /// The `ErrorData` that states these and nothing else.
    pub fn new(code: impl Into<String>, retryable: bool) -> Self {
        Self {
            code: code.into(),
            retryable,
            fields: None,
            choices: None,
            supported: None,
            may_still_run: None,
        }
    }
}

schema!(ErrorData);

/// The body of every error the gateway answers, whatever the status and whatever the route — including a path it does not serve.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct ErrorResponse {
    /// What went wrong, in a sentence.
    pub error: String,
    /// A machine-readable class, when the route defines one.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub code: Option<String>,
    /// What the caller can do about it, when there is something to say.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub hint: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub details: Option<serde_json::Value>,
}

impl ErrorResponse {
    /// The `ErrorResponse` that states these and nothing else.
    pub fn new(error: impl Into<String>) -> Self {
        Self {
            error: error.into(),
            code: None,
            hint: None,
            details: None,
        }
    }
}

schema!(ErrorResponse);

/// Metadata added at persistence time. Part of every StoredEvent. Integrity is provided by git at the commit level (when gitSync is enabled), not by in-event metadata fields.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct EventMetadata {
    /// Monotonic position in the event log (ordering authority)
    #[serde(rename = "sequenceNumber")]
    pub sequence_number: i64,
}

schema!(EventMetadata);

/// What a person believed they were signing in to: the did and the name of the row they clicked, or of the entry they signed in to again.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct Expected {
    /// The did they believed it has.
    pub did: String,
    /// The name they believed it has. Absent when they had none.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub name: Option<String>,
}

impl Expected {
    /// The `Expected` that states these and nothing else.
    pub fn new(did: impl Into<String>) -> Self {
        Self {
            did: did.into(),
            name: None,
        }
    }
}

schema!(Expected);

/// A successful extraction: the anchored text plus its provenance. The 'extracted' member of ExtractionOutcome, the record the anchored-text store holds.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct ExtractedText {
    /// Reading-order text of the whole resource.
    pub text: String,
    /// Positioned runs indexing `text`, roughly one per word.
    pub items: Vec<PdfTextItem>,
    /// Discriminant — both ExtractionOutcome members carry `kind`, single-valued: the category here, the detail in `method`.
    pub kind: ExtractedTextKind,
    /// How the text was extracted.
    pub method: ExtractionMethod,
    /// PDF classification, when the source was a PDF.
    #[serde(rename = "pdfClass")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub pdf_class: Option<PdfClass>,
    /// How well the engine read the pixels, when any of this text came from OCR.
    #[serde(rename = "ocrConfidence")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub ocr_confidence: Option<OcrConfidence>,
    /// 1-indexed pages this extraction could not read — present only for partially covered documents (class C).
    #[serde(rename = "unreadPages")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub unread_pages: Option<Vec<i64>>,
}

impl ExtractedText {
    /// The `ExtractedText` that states these and nothing else.
    pub fn new(text: impl Into<String>, items: Vec<PdfTextItem>, method: ExtractionMethod) -> Self {
        Self {
            text: text.into(),
            items,
            kind: ExtractedTextKind::Extracted,
            method,
            pdf_class: None,
            ocr_confidence: None,
            unread_pages: None,
        }
    }
}

schema!(ExtractedText);

/// Discriminant — both ExtractionOutcome members carry `kind`, single-valued: the category here, the detail in `method`.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ExtractedTextKind {
    #[serde(rename = "extracted")]
    Extracted,
}

impl ExtractedTextKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ExtractedTextKind::Extracted => "extracted",
        }
    }
}

/// A named decline: extraction ran and yielded nothing, by class. A first-class, cacheable outcome — 'we ran and there was nothing' costs a full recognition pass to discover.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct ExtractionDeclined {
    /// Discriminant — both ExtractionOutcome members carry `kind`, single-valued: the category here, the detail in `declined`.
    pub kind: ExtractionDeclinedKind,
    /// Why extraction yielded nothing, by class.
    pub declined: ExtractionDeclinedReason,
}

impl ExtractionDeclined {
    /// The `ExtractionDeclined` that states these and nothing else.
    pub fn new(declined: ExtractionDeclinedReason) -> Self {
        Self {
            kind: ExtractionDeclinedKind::Declined,
            declined,
        }
    }
}

schema!(ExtractionDeclined);

/// Discriminant — both ExtractionOutcome members carry `kind`, single-valued: the category here, the detail in `declined`.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ExtractionDeclinedKind {
    #[serde(rename = "declined")]
    Declined,
}

impl ExtractionDeclinedKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ExtractionDeclinedKind::Declined => "declined",
        }
    }
}

/// Why extraction yielded nothing, by class.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ExtractionDeclinedReason {
    #[serde(rename = "no-text-layer")]
    NoTextLayer,
    #[serde(rename = "encrypted")]
    Encrypted,
    #[serde(rename = "corrupt")]
    Corrupt,
    #[serde(rename = "too-large")]
    TooLarge,
}

impl ExtractionDeclinedReason {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ExtractionDeclinedReason::NoTextLayer => "no-text-layer",
            ExtractionDeclinedReason::Encrypted => "encrypted",
            ExtractionDeclinedReason::Corrupt => "corrupt",
            ExtractionDeclinedReason::TooLarge => "too-large",
        }
    }
}

schema!(ExtractionDeclinedReason);

/// How a text was extracted: a plain text taken as it is, a PDF's text layer read, a grid written as rows, a filled form's values read, or pixels read by OCR.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ExtractionMethod {
    #[serde(rename = "text-passthrough")]
    TextPassthrough,
    #[serde(rename = "pdf-text-layer")]
    PdfTextLayer,
    #[serde(rename = "table")]
    Table,
    #[serde(rename = "form")]
    Form,
    #[serde(rename = "ocr")]
    Ocr,
}

impl ExtractionMethod {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ExtractionMethod::TextPassthrough => "text-passthrough",
            ExtractionMethod::PdfTextLayer => "pdf-text-layer",
            ExtractionMethod::Table => "table",
            ExtractionMethod::Form => "form",
            ExtractionMethod::Ocr => "ocr",
        }
    }
}

schema!(ExtractionMethod);

/// The full outcome of text extraction for one representation — the record the anchored-text store holds and the wire serves. Discriminated on `kind`: 'extracted' — the anchored text with its provenance; 'declined' — a named decline. ocrConfidence is extraction quality for operators, deliberately not anchor confidence.
#[derive(Debug, Clone, PartialEq, serde::Serialize)]
#[serde(untagged)]
pub enum ExtractionOutcome {
    ExtractedText(ExtractedText),
    ExtractionDeclined(ExtractionDeclined),
}

impl<'de> serde::Deserialize<'de> for ExtractionOutcome {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("kind").and_then(serde_json::Value::as_str) {
            Some("extracted") => {
                serde_json::from_value(value).map(ExtractionOutcome::ExtractedText)
            }
            Some("declined") => {
                serde_json::from_value(value).map(ExtractionOutcome::ExtractionDeclined)
            }
            _ => {
                return Err(serde::de::Error::custom(
                    "a ExtractionOutcome states a `kind` that is one of `extracted`, `declined`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

member!(ExtractionOutcome::ExtractedText(ExtractedText));
member!(ExtractionOutcome::ExtractionDeclined(ExtractionDeclined));
schema!(ExtractionOutcome);

/// The class of a job's failure, stated by the worker, where the failure is still typed: at the gateway it is already text, and classing a failure by its text is what this exists to avoid. A job no worker concluded, because its worker stopped reporting, is classed by the dispatcher, as 'transient'. Each value is a claim. 'transient': nothing about the request was judged (the worker's own bound ran out, the provider said not now), so another attempt may succeed. 'deterministic': the same request cannot succeed on a second attempt. 'withheld': the model's provider had the request and withheld its answer, by a refusal or a content filter, and the same request is withheld again; nothing broke. A 'deterministic' or a 'withheld' failure is not retried, whatever retry budget is left. ABSENT means the failure was not classified, which is not the claim 'transient' makes; it is retried as a transient one is. Only a failure known to be deterministic or withheld is called so: calling a transient failure either one halves reliability, where the reverse costs one wasted attempt.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum FailureClass {
    #[serde(rename = "transient")]
    Transient,
    #[serde(rename = "deterministic")]
    Deterministic,
    #[serde(rename = "withheld")]
    Withheld,
}

impl FailureClass {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            FailureClass::Transient => "transient",
            FailureClass::Deterministic => "deterministic",
            FailureClass::Withheld => "withheld",
        }
    }
}

schema!(FailureClass);

/// One fault in a request's params, named where it is.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct FieldFault {
    /// Where in the params the fault is, as a JSON pointer (RFC 6901); empty for the params as a whole.
    pub field: String,
    /// What is wrong there.
    pub message: String,
}

schema!(FieldFault);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct FileEntry {
    pub r#type: FileEntryType,
    /// Entry name (basename)
    pub name: String,
    /// Path relative to project root
    pub path: String,
    /// File size in bytes
    pub size: i64,
    /// Last modified time (ISO 8601)
    pub mtime: String,
    /// True if this file is a tracked resource in the Knowledge Base
    pub tracked: bool,
    /// Resource ID (only when tracked is true)
    #[serde(rename = "resourceId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resource_id: Option<ResourceId>,
    /// Entity types assigned to this resource (only when tracked is true)
    #[serde(rename = "entityTypes")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_types: Option<Vec<String>>,
    /// Number of annotations on this resource (only when tracked is true)
    #[serde(rename = "annotationCount")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotation_count: Option<i64>,
    /// DID of the resource's creator — the first of its derived `wasAttributedTo`, the requester as the knowledge base recorded it (only when tracked is true)
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub creator: Option<String>,
}

impl FileEntry {
    /// The `FileEntry` that states these and nothing else.
    pub fn new(
        name: impl Into<String>,
        path: impl Into<String>,
        size: i64,
        mtime: impl Into<String>,
        tracked: bool,
    ) -> Self {
        Self {
            r#type: FileEntryType::File,
            name: name.into(),
            path: path.into(),
            size,
            mtime: mtime.into(),
            tracked,
            resource_id: None,
            entity_types: None,
            annotation_count: None,
            creator: None,
        }
    }
}

schema!(FileEntry);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum FileEntryType {
    #[serde(rename = "file")]
    File,
}

impl FileEntryType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            FileEntryType::File => "file",
        }
    }
}

/// How far a follower of the record has followed it, as every follower says it at its health port (WEAVER.md § Health, SMELTER.md § Health).
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct FollowerFollowing {
    /// The latest sweep's phase: `pending` before its stream first opens, `running`, `done`, or `due` where the record could not be listed and the sweep is tried again.
    pub sweep: FollowerFollowingSweep,
    /// How many resources' logs a failed taking has stopped until the next sweep.
    pub stopped: u64,
    /// How many events it refused as recorded since it started.
    pub refused: u64,
    /// How many times its stream has dropped since it started.
    #[serde(rename = "streamDrops")]
    pub stream_drops: u64,
}

schema!(FollowerFollowing);

/// The latest sweep's phase: `pending` before its stream first opens, `running`, `done`, or `due` where the record could not be listed and the sweep is tried again.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum FollowerFollowingSweep {
    #[serde(rename = "pending")]
    Pending,
    #[serde(rename = "running")]
    Running,
    #[serde(rename = "done")]
    Done,
    #[serde(rename = "due")]
    Due,
}

impl FollowerFollowingSweep {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            FollowerFollowingSweep::Pending => "pending",
            FollowerFollowingSweep::Running => "running",
            FollowerFollowingSweep::Done => "done",
            FollowerFollowingSweep::Due => "due",
        }
    }
}

/// W3C Web Annotation FragmentSelector for media fragment identifiers (RFC 3778 for PDFs)
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct FragmentSelector {
    pub r#type: FragmentSelectorType,
    /// Media fragment identifier (e.g., 'page=1&viewrect=100,200,50,30' for PDF)
    pub value: String,
    /// URI identifying the fragment syntax specification
    #[serde(rename = "conformsTo")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub conforms_to: Option<String>,
}

impl FragmentSelector {
    /// The `FragmentSelector` that states these and nothing else.
    pub fn new(value: impl Into<String>) -> Self {
        Self {
            r#type: FragmentSelectorType::FragmentSelector,
            value: value.into(),
            conforms_to: None,
        }
    }
}

schema!(FragmentSelector);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum FragmentSelectorType {
    #[serde(rename = "FragmentSelector")]
    FragmentSelector,
}

impl FragmentSelectorType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            FragmentSelectorType::FragmentSelector => "FragmentSelector",
        }
    }
}

/// Bus command to add a new entity type to the KB's vocabulary. Carried on the `frame:add-entity-type` channel — Frame is the schema-layer flow that owns vocabulary writes.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct FrameAddEntityTypeCommand {
    pub tag: String,
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
}

impl FrameAddEntityTypeCommand {
    /// The `FrameAddEntityTypeCommand` that states these and nothing else.
    pub fn new(tag: impl Into<String>) -> Self {
        Self {
            tag: tag.into(),
            _user_id: None,
        }
    }
}

schema!(FrameAddEntityTypeCommand);

/// Bus command to register a tag schema with the KB's runtime registry. Carried on the `frame:add-tag-schema` channel — Frame is the schema-layer flow that owns vocabulary writes. Most-recent registration of a given `schema.id` wins; the projection reflects the latest content. Identical re-registrations are silent; differing content overwrites and logs a warning.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct FrameAddTagSchemaCommand {
    pub schema: TagSchema,
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
}

impl FrameAddTagSchemaCommand {
    /// The `FrameAddTagSchemaCommand` that states these and nothing else.
    pub fn new(schema: TagSchema) -> Self {
        Self {
            schema,
            _user_id: None,
        }
    }
}

schema!(FrameAddTagSchemaCommand);

/// Why a reader refused a frame, for its first fault: `lacks`, a member it lacks; `malformed`, a member that is not of its shape. A reader's rule (specs/src/bus/frame-cases.json).
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum FrameRefusalReason {
    #[serde(rename = "lacks")]
    Lacks,
    #[serde(rename = "malformed")]
    Malformed,
}

impl FrameRefusalReason {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            FrameRefusalReason::Lacks => "lacks",
            FrameRefusalReason::Malformed => "malformed",
        }
    }
}

schema!(FrameRefusalReason);

/// Everything the gateway reads at boot: nothing in it is defaulted by the gateway. The launcher writes it for the gateway it starts — from the knowledge base's committed identity and its stack documents — and a gateway started any other way is given the same document at the path its `--config` flag names (the image passes `/etc/xynolog/gateway.json`). Started without `--config`, or with a path that names no file, the gateway refuses to start and says which. Secrets are never values here: a field that needs one names the environment variable holding it. The gateway's other inputs are the environment variables specs/src/service-environment/variables.json lists for it, and the ones this document names. A document that does not validate is refused at boot — the gateway exits without serving — and the refusal names each failing field by its JSON pointer.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GatewayConfig {
    pub kb: KbIdentity,
    /// The port the gateway listens on, on every address the host has: IPv4 and IPv6.
    pub port: u16,
    /// The URL clients reach this gateway at: the `servers` entry of the OpenAPI document it serves.
    #[serde(rename = "publicUrl")]
    pub public_url: String,
    /// The issuer this knowledge base trusts.
    pub identity: GatewayConfigIdentity,
    /// Where the Archivist listens.
    pub archivist: ServiceAddress,
    /// The signal plane: `in-process`, one gateway on its own fabric; or `nats`, the fabric every replica on one broker shares, which requires `servers` and a broker with JetStream.
    pub signal: GatewayConfigSignal,
    #[serde(rename = "logLevel")]
    pub log_level: LogLevel,
    #[serde(rename = "logFormat")]
    pub log_format: LogFormat,
    /// What this gateway process can hold, from the memory its deployment gives it. `queuedBytes`: the bytes queued for all its streams together; at it, a new stream is refused with 503 (`AtCapacity`, code `capacity`) until the queues drain — each stream's own bound is `x-xynolog-limits.pendingWriteBytes`. `connections`: the connections it holds open at once; one past it is closed unanswered. The launcher derives both from the memory it gives the gateway's container.
    pub capacity: GatewayConfigCapacity,
}

schema!(GatewayConfig);

/// What this gateway process can hold, from the memory its deployment gives it. `queuedBytes`: the bytes queued for all its streams together; at it, a new stream is refused with 503 (`AtCapacity`, code `capacity`) until the queues drain — each stream's own bound is `x-xynolog-limits.pendingWriteBytes`. `connections`: the connections it holds open at once; one past it is closed unanswered. The launcher derives both from the memory it gives the gateway's container.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GatewayConfigCapacity {
    #[serde(rename = "queuedBytes")]
    pub queued_bytes: u64,
    pub connections: u64,
}

/// The issuer this knowledge base trusts.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GatewayConfigIdentity {
    /// The issuer URL, exactly as tokens carry it in `iss`.
    pub issuer: String,
    /// The claim a person's DID is built from: `did:web:<domain>:users:<its value>`.
    #[serde(rename = "subjectClaim")]
    pub subject_claim: String,
}

/// The signal plane: `in-process`, one gateway on its own fabric; or `nats`, the fabric every replica on one broker shares, which requires `servers` and a broker with JetStream.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GatewayConfigSignal {
    pub r#type: GatewayConfigSignalType,
    /// The broker's address (`host:port`, or several, comma-separated). Required for `nats`.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub servers: Option<String>,
    /// The environment variable holding the broker user, when the broker requires one.
    #[serde(rename = "userEnv")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub user_env: Option<String>,
    /// The environment variable holding the broker password, when the broker requires one.
    #[serde(rename = "passwordEnv")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub password_env: Option<String>,
}

impl GatewayConfigSignal {
    /// The `GatewayConfigSignal` that states these and nothing else.
    pub fn new(r#type: GatewayConfigSignalType) -> Self {
        Self {
            r#type,
            servers: None,
            user_env: None,
            password_env: None,
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum GatewayConfigSignalType {
    #[serde(rename = "in-process")]
    InProcess,
    #[serde(rename = "nats")]
    Nats,
}

impl GatewayConfigSignalType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            GatewayConfigSignalType::InProcess => "in-process",
            GatewayConfigSignalType::Nats => "nats",
        }
    }
}

/// gateway/media-token.json: what a media token is.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GatewayMediaToken {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    /// Its JOSE header, exactly.
    pub header: GatewayMediaTokenHeader,
    /// Its claims beside `iat` and `exp`, each filled as the table says.
    pub claims: GatewayMediaTokenClaims,
    /// `exp` less `iat`.
    #[serde(rename = "lifetimeSeconds")]
    pub lifetime_seconds: u64,
}

schema!(GatewayMediaToken);

/// Its claims beside `iat` and `exp`, each filled as the table says.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GatewayMediaTokenClaims {
    pub purpose: GatewayMediaTokenClaimsPurpose,
    pub iss: GatewayMediaTokenClaimsIss,
    pub sub: GatewayMediaTokenClaimsSub,
}

impl Default for GatewayMediaTokenClaims {
    fn default() -> Self {
        Self::new()
    }
}

impl GatewayMediaTokenClaims {
    /// The `GatewayMediaTokenClaims` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            purpose: GatewayMediaTokenClaimsPurpose::Media,
            iss: GatewayMediaTokenClaimsIss::Domain,
            sub: GatewayMediaTokenClaimsSub::ResourceId,
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum GatewayMediaTokenClaimsIss {
    #[serde(rename = "{domain}")]
    Domain,
}

impl GatewayMediaTokenClaimsIss {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            GatewayMediaTokenClaimsIss::Domain => "{domain}",
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum GatewayMediaTokenClaimsPurpose {
    #[serde(rename = "media")]
    Media,
}

impl GatewayMediaTokenClaimsPurpose {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            GatewayMediaTokenClaimsPurpose::Media => "media",
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum GatewayMediaTokenClaimsSub {
    #[serde(rename = "{resourceId}")]
    ResourceId,
}

impl GatewayMediaTokenClaimsSub {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            GatewayMediaTokenClaimsSub::ResourceId => "{resourceId}",
        }
    }
}

/// Its JOSE header, exactly.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GatewayMediaTokenHeader {
    pub alg: GatewayMediaTokenHeaderAlg,
    pub typ: GatewayMediaTokenHeaderTyp,
}

impl Default for GatewayMediaTokenHeader {
    fn default() -> Self {
        Self::new()
    }
}

impl GatewayMediaTokenHeader {
    /// The `GatewayMediaTokenHeader` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            alg: GatewayMediaTokenHeaderAlg::HS256,
            typ: GatewayMediaTokenHeaderTyp::JWT,
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum GatewayMediaTokenHeaderAlg {
    #[serde(rename = "HS256")]
    HS256,
}

impl GatewayMediaTokenHeaderAlg {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            GatewayMediaTokenHeaderAlg::HS256 => "HS256",
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum GatewayMediaTokenHeaderTyp {
    #[serde(rename = "JWT")]
    JWT,
}

impl GatewayMediaTokenHeaderTyp {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            GatewayMediaTokenHeaderTyp::JWT => "JWT",
        }
    }
}

/// gateway/messages.json: the words of the gateway's own refusals.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GatewayMessages {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    /// Each refusal the gateway makes itself.
    pub messages: Vec<GatewayMessagesMessagesItem>,
    /// Each failure frame the gateway delivers itself, on the stream of the client whose request it answers.
    pub failures: Vec<GatewayMessagesFailuresItem>,
    /// The `WWW-Authenticate` of a 401.
    pub challenges: GatewayMessagesChallenges,
}

schema!(GatewayMessages);

/// The `WWW-Authenticate` of a 401.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GatewayMessagesChallenges {
    /// For a request that presents no credential. The challenge. `{origin}` is the origin the Unauthorized response names: `http://` and the request's `Host`, or, for a request that names none, the gateway's `publicUrl`.
    #[serde(rename = "noCredential")]
    pub no_credential: String,
    /// For a request whose credential, a bearer token or a media token, is refused. The challenge. `{origin}` is the origin the Unauthorized response names: `http://` and the request's `Host`, or, for a request that names none, the gateway's `publicUrl`.
    pub refused: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GatewayMessagesFailuresItem {
    /// The situation's name.
    pub name: String,
    /// Its `code`.
    pub code: String,
    /// When the gateway answers it, and what fills each `{name}` of its texts.
    pub situation: String,
    /// Its text. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.
    pub message: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GatewayMessagesMessagesItem {
    /// The situation's name.
    pub name: String,
    pub status: HttpStatus,
    /// Its `code`, where it carries one: a LimitRefusal's, or the transport code errors/codes.json names for its status.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub code: Option<String>,
    /// When the gateway answers it, and what fills each `{name}` of its texts.
    pub situation: String,
    /// Its text. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.
    pub error: String,
    /// Its `hint`, where it carries one.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub hint: Option<String>,
}

impl GatewayMessagesMessagesItem {
    /// The `GatewayMessagesMessagesItem` that states these and nothing else.
    pub fn new(
        name: impl Into<String>,
        status: HttpStatus,
        situation: impl Into<String>,
        error: impl Into<String>,
    ) -> Self {
        Self {
            name: name.into(),
            status,
            code: None,
            situation: situation.into(),
            error: error.into(),
            hint: None,
        }
    }
}

/// gateway/response-headers.json: the headers on every response the gateway sends.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GatewayResponseHeaders {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    /// Each header every response carries, and its value.
    pub every: Vec<GatewayResponseHeadersEveryItem>,
    /// The header that names the request.
    #[serde(rename = "requestId")]
    pub request_id: String,
    /// Each header no response carries.
    pub absent: Vec<String>,
    /// How the gateway answers an `OPTIONS` request.
    pub preflight: GatewayResponseHeadersPreflight,
}

schema!(GatewayResponseHeaders);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GatewayResponseHeadersEveryItem {
    /// A header's name, as HTTP spells it; a receiver reads it in any case.
    pub name: String,
    /// Its value, exactly.
    pub value: String,
}

/// How the gateway answers an `OPTIONS` request.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GatewayResponseHeadersPreflight {
    pub status: HttpStatus,
    /// Each header it carries beside those of `every`, and its value.
    pub headers: Vec<GatewayResponseHeadersPreflightHeadersItem>,
    /// Each header it carries when the request carries the header it echoes, with that header's value.
    pub echoes: Vec<GatewayResponseHeadersPreflightEchoesItem>,
    /// The value of the `Vary` it carries when it echoes a header: the request headers it echoes.
    pub vary: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GatewayResponseHeadersPreflightEchoesItem {
    /// A header's name, as HTTP spells it; a receiver reads it in any case.
    pub name: String,
    /// The request's header whose value it carries.
    pub of: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GatewayResponseHeadersPreflightHeadersItem {
    /// A header's name, as HTTP spells it; a receiver reads it in any case.
    pub name: String,
    /// Its value, exactly.
    pub value: String,
}

/// Completion payload emitted on the gather:annotation-complete bus channel when annotation context gathering finishes.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct GatherAnnotationComplete {
    /// Branded AnnotationId of the annotation whose context was gathered
    #[serde(rename = "annotationId")]
    pub annotation_id: AnnotationId,
    /// The gathered annotation context (unified GatheredContext, focus.kind:'annotation')
    pub response: GatheredContext,
}

schema!(GatherAnnotationComplete);

/// Optional configuration for an annotation-focus gather, which windows text around a mark. Distinct from the resource-focus options (depth / maxResources / includeContent / includeSummary), which traverse the resource graph.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct GatherAnnotationOptions {
    /// Whether to include source context in the gathered result
    #[serde(rename = "includeSourceContext")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub include_source_context: Option<bool>,
    /// Whether to include target context in the gathered result
    #[serde(rename = "includeTargetContext")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub include_target_context: Option<bool>,
    /// How much of the text on each side of the annotation to include, counted in Unicode code points
    #[serde(rename = "contextWindow")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub context_window: Option<u16>,
}

schema!(GatherAnnotationOptions);

/// Request payload sent on the gather:requested bus channel to gather context for an annotation.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GatherAnnotationRequest {
    /// Branded AnnotationId of the annotation to gather context for
    #[serde(rename = "annotationId")]
    pub annotation_id: AnnotationId,
    /// Branded ResourceId of the resource the annotation belongs to
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub options: Option<GatherAnnotationOptions>,
}

impl GatherAnnotationRequest {
    /// The `GatherAnnotationRequest` that states these and nothing else.
    pub fn new(annotation_id: AnnotationId, resource_id: ResourceId) -> Self {
        Self {
            annotation_id,
            resource_id,
            options: None,
        }
    }
}

schema!(GatherAnnotationRequest);

/// The payload of `gather:failed`: a CommandError that names the annotation whose context could not be gathered.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GatherFailed {
    /// Machine-readable failure class, for consumers that must BRANCH on why a command failed rather than log it. Optional and deliberately sparse: absent means 'no class declared', and every existing failure stays that way. An enum rather than a free string so the vocabulary has an owner — an unconstrained code is a mirror with no gate, and adding one should be a deliberate spec change. `message` remains the human-readable text and is unaffected. Members: `peer-unavailable` — the channel this command was sent on has no subscriber, i.e. the service that answers it has not connected yet. Transient by nature (a peer still starting), which is what distinguishes it from a refusal: retrying is the correct response. `not-found` — the resource this command addressed does not exist in this knowledge base. A verdict, not a symptom: it is emitted only where the answer comes from the event store, which is the system of record, and never from a projection that may merely be lagging. Deterministic, so unlike `peer-unavailable` retrying is pointless — and consumers may act destructively on it (the SDK deletes a restored tab). Absence is not denial: a future 'exists, but not for you' must travel as its own code, never as this one. `unauthorized` — that code: the caller is authenticated but not permitted to do what it asked. A verdict about the CALLER, not the resource, so retrying under the same credential cannot succeed and a consumer must never spin on it; emitted by `job:claim` for a caller whose token carries no worker role. `none-pending` — a declined claim, not an error: the queue holds no pending job of the requested types. Nothing went wrong; the one code a consumer PARKS on, meaning 'nothing to do until a wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying neither is unclassified — a malformed record or a missing injection — and a consumer treats it as 'log it, assume nothing'.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub code: Option<CommandErrorCode>,
    /// Human-readable error message
    pub message: String,
    /// Optional additional context (stack trace, field name, etc.)
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub details: Option<String>,
    /// The annotation the gather was asked for.
    #[serde(rename = "annotationId")]
    pub annotation_id: AnnotationId,
}

impl GatherFailed {
    /// The `GatherFailed` that states these and nothing else.
    pub fn new(message: impl Into<String>, annotation_id: AnnotationId) -> Self {
        Self {
            code: None,
            message: message.into(),
            details: None,
            annotation_id,
        }
    }
}

schema!(GatherFailed);

/// Request for the annotations elsewhere that refer to a resource. The Librarian answers from the graph.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GatherReferencedByRequest {
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// The one motivation the annotations answered have. Every annotation that refers to the resource is answered where none is stated.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub motivation: Option<Motivation>,
}

impl GatherReferencedByRequest {
    /// The `GatherReferencedByRequest` that states these and nothing else.
    pub fn new(resource_id: ResourceId) -> Self {
        Self {
            resource_id,
            motivation: None,
        }
    }
}

schema!(GatherReferencedByRequest);

/// The annotations elsewhere that refer to a resource
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GatherReferencedByResult {
    pub response: GetReferencedByResponse,
}

schema!(GatherReferencedByResult);

/// Completion payload emitted on the gather:resource-complete bus channel when resource context gathering finishes.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct GatherResourceComplete {
    /// Branded ResourceId of the resource whose context was gathered
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// The gathered resource context (unified GatheredContext, focus.kind:'resource')
    pub response: GatheredContext,
}

schema!(GatherResourceComplete);

/// The payload of `gather:resource-failed`: a CommandError that names the resource whose context could not be gathered.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GatherResourceFailed {
    /// Machine-readable failure class, for consumers that must BRANCH on why a command failed rather than log it. Optional and deliberately sparse: absent means 'no class declared', and every existing failure stays that way. An enum rather than a free string so the vocabulary has an owner — an unconstrained code is a mirror with no gate, and adding one should be a deliberate spec change. `message` remains the human-readable text and is unaffected. Members: `peer-unavailable` — the channel this command was sent on has no subscriber, i.e. the service that answers it has not connected yet. Transient by nature (a peer still starting), which is what distinguishes it from a refusal: retrying is the correct response. `not-found` — the resource this command addressed does not exist in this knowledge base. A verdict, not a symptom: it is emitted only where the answer comes from the event store, which is the system of record, and never from a projection that may merely be lagging. Deterministic, so unlike `peer-unavailable` retrying is pointless — and consumers may act destructively on it (the SDK deletes a restored tab). Absence is not denial: a future 'exists, but not for you' must travel as its own code, never as this one. `unauthorized` — that code: the caller is authenticated but not permitted to do what it asked. A verdict about the CALLER, not the resource, so retrying under the same credential cannot succeed and a consumer must never spin on it; emitted by `job:claim` for a caller whose token carries no worker role. `none-pending` — a declined claim, not an error: the queue holds no pending job of the requested types. Nothing went wrong; the one code a consumer PARKS on, meaning 'nothing to do until a wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying neither is unclassified — a malformed record or a missing injection — and a consumer treats it as 'log it, assume nothing'.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub code: Option<CommandErrorCode>,
    /// Human-readable error message
    pub message: String,
    /// Optional additional context (stack trace, field name, etc.)
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub details: Option<String>,
    /// The resource the gather was asked for.
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
}

impl GatherResourceFailed {
    /// The `GatherResourceFailed` that states these and nothing else.
    pub fn new(message: impl Into<String>, resource_id: ResourceId) -> Self {
        Self {
            code: None,
            message: message.into(),
            details: None,
            resource_id,
        }
    }
}

schema!(GatherResourceFailed);

/// What gathering the context of a resource is told beside the resource: GatherResourceRequestOptions, each member of which a caller may leave out. client/surface.json's `gather.resource` cases state what is sent for one left out.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GatherResourceOptions {
    /// How many links out from the resource the knowledge graph reaches, nearest first: 1 is what the resource links to and what cites it, and each further link out adds what those link to and what cites them
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub depth: Option<u16>,
    /// Maximum number of related resources to include
    #[serde(rename = "maxResources")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub max_resources: Option<u16>,
    /// Whether to include resource content in the gathered result
    #[serde(rename = "includeContent")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub include_content: Option<bool>,
    /// Whether to include resource summaries in the gathered result
    #[serde(rename = "includeSummary")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub include_summary: Option<bool>,
    /// Entity types to exclude from the semantic recall built into this context (caller-supplied; e.g. a chat consumer passes ['Question'] so prior questions never ground answer generation). Optional; default none.
    #[serde(rename = "excludeEntityTypes")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub exclude_entity_types: Option<Vec<String>>,
}

schema!(GatherResourceOptions);

/// Request payload sent on the gather:resource-requested bus channel to gather context for a resource.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GatherResourceRequest {
    /// Branded ResourceId of the resource to gather context for
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    pub options: GatherResourceRequestOptions,
}

schema!(GatherResourceRequest);

/// Gathering configuration
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GatherResourceRequestOptions {
    /// How many links out from the resource the knowledge graph reaches, nearest first: 1 is what the resource links to and what cites it, and each further link out adds what those link to and what cites them
    pub depth: u16,
    /// Maximum number of related resources to include
    #[serde(rename = "maxResources")]
    pub max_resources: u16,
    /// Whether to include resource content in the gathered result
    #[serde(rename = "includeContent")]
    pub include_content: bool,
    /// Whether to include resource summaries in the gathered result
    #[serde(rename = "includeSummary")]
    pub include_summary: bool,
    /// Entity types to exclude from the semantic recall built into this context (caller-supplied; e.g. a chat consumer passes ['Question'] so prior questions never ground answer generation). Optional; default none.
    #[serde(rename = "excludeEntityTypes")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub exclude_entity_types: Option<Vec<String>>,
}

impl GatherResourceRequestOptions {
    /// The `GatherResourceRequestOptions` that states these and nothing else.
    pub fn new(
        depth: u16,
        max_resources: u16,
        include_content: bool,
        include_summary: bool,
    ) -> Self {
        Self {
            depth,
            max_resources,
            include_content,
            include_summary,
            exclude_entity_types: None,
        }
    }
}

schema!(GatherResourceRequestOptions);

/// Request to generate an AI summary of an annotation
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GatherSummaryRequest {
    #[serde(rename = "annotationId")]
    pub annotation_id: AnnotationId,
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
}

schema!(GatherSummaryRequest);

/// Context gathered for a gather.* call — consumed by yield.* (generation) and the matcher. A shared base (graph, semanticContext, metadata, inferredRelationshipSummary) plus a discriminated `focus` that names the anchor: an annotation or a whole resource.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct GatheredContext {
    /// The gather anchor. Discriminated on `kind`.
    pub focus: GatheredContextFocus,
    /// Knowledge graph backbone — resources AND annotations as typed nodes. The flattened views (connections, citedBy, siblings) are derived from this.
    pub graph: KnowledgeGraph,
    /// Semantically similar passages from across the knowledge base, found via vector search
    #[serde(rename = "semanticContext")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub semantic_context: Option<GatheredContextSemanticContext>,
    /// Context metadata about the focal anchor and its source
    pub metadata: GatheredContextMetadata,
    /// LLM-generated summary of the focal anchor's relationships in the knowledge graph
    #[serde(rename = "inferredRelationshipSummary")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub inferred_relationship_summary: Option<String>,
}

impl GatheredContext {
    /// The `GatheredContext` that states these and nothing else.
    pub fn new(
        focus: GatheredContextFocus,
        graph: KnowledgeGraph,
        metadata: GatheredContextMetadata,
    ) -> Self {
        Self {
            focus,
            graph,
            semantic_context: None,
            metadata,
            inferred_relationship_summary: None,
        }
    }
}

schema!(GatheredContext);

/// The gather anchor. Discriminated on `kind`.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum GatheredContextFocus {
    Annotation(GatheredContextFocusAnnotation),
    Resource(GatheredContextFocusResource),
}

/// Annotation-anchored focus.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct GatheredContextFocusAnnotation {
    pub kind: GatheredContextFocusAnnotationKind,
    /// The annotation this context was gathered for
    pub annotation: Annotation,
    /// The resource containing the annotation
    #[serde(rename = "sourceResource")]
    pub source_resource: ResourceDescriptor,
    /// Text context around the annotation target
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub selected: Option<GatheredContextFocusAnnotationSelected>,
    /// User-provided hint to supplement or replace the selected text for search and generation
    #[serde(rename = "userHint")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub user_hint: Option<String>,
    /// The resource the annotation links to, if it is a resolved reference. Dormant capability — produced/exposed but not yet consumed.
    #[serde(rename = "targetResource")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub target_resource: Option<ResourceDescriptor>,
    /// Context about the annotation's link target. Dormant — produced/exposed but not yet consumed.
    #[serde(rename = "targetContext")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub target_context: Option<GatheredContextFocusAnnotationTargetContext>,
}

impl GatheredContextFocusAnnotation {
    /// The `GatheredContextFocusAnnotation` that states these and nothing else.
    pub fn new(annotation: Annotation, source_resource: ResourceDescriptor) -> Self {
        Self {
            kind: GatheredContextFocusAnnotationKind::Annotation,
            annotation,
            source_resource,
            selected: None,
            user_hint: None,
            target_resource: None,
            target_context: None,
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum GatheredContextFocusAnnotationKind {
    #[serde(rename = "annotation")]
    Annotation,
}

impl GatheredContextFocusAnnotationKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            GatheredContextFocusAnnotationKind::Annotation => "annotation",
        }
    }
}

/// Text context around the annotation target
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GatheredContextFocusAnnotationSelected {
    /// Text appearing before the selected passage
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub before: Option<String>,
    /// The selected text passage (the annotation target)
    pub text: String,
    /// Text appearing after the selected passage
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub after: Option<String>,
}

impl GatheredContextFocusAnnotationSelected {
    /// The `GatheredContextFocusAnnotationSelected` that states these and nothing else.
    pub fn new(text: impl Into<String>) -> Self {
        Self {
            before: None,
            text: text.into(),
            after: None,
        }
    }
}

/// Context about the annotation's link target. Dormant — produced/exposed but not yet consumed.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GatheredContextFocusAnnotationTargetContext {
    pub content: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub summary: Option<String>,
}

impl GatheredContextFocusAnnotationTargetContext {
    /// The `GatheredContextFocusAnnotationTargetContext` that states these and nothing else.
    pub fn new(content: impl Into<String>) -> Self {
        Self {
            content: content.into(),
            summary: None,
        }
    }
}

/// Whole-resource focus.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct GatheredContextFocusResource {
    pub kind: GatheredContextFocusResourceKind,
    /// The resource this context was gathered for
    pub resource: ResourceDescriptor,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub summary: Option<String>,
    #[serde(rename = "suggestedReferences")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub suggested_references: Option<Vec<String>>,
    /// Resource content (included when requested)
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub content: Option<GatheredContextFocusResourceContent>,
}

impl GatheredContextFocusResource {
    /// The `GatheredContextFocusResource` that states these and nothing else.
    pub fn new(resource: ResourceDescriptor) -> Self {
        Self {
            kind: GatheredContextFocusResourceKind::Resource,
            resource,
            summary: None,
            suggested_references: None,
            content: None,
        }
    }
}

/// Resource content (included when requested)
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct GatheredContextFocusResourceContent {
    /// Content of the focal resource
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub main: Option<String>,
    /// Map of related resource IDs to their content
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub related: Option<std::collections::BTreeMap<String, String>>,
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum GatheredContextFocusResourceKind {
    #[serde(rename = "resource")]
    Resource,
}

impl GatheredContextFocusResourceKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            GatheredContextFocusResourceKind::Resource => "resource",
        }
    }
}

/// Context metadata about the focal anchor and its source
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct GatheredContextMetadata {
    /// Type of source resource (e.g., 'document', 'image', 'video')
    #[serde(rename = "resourceType")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resource_type: Option<String>,
    /// BCP 47 language tag of source content
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub language: Option<String>,
    /// Entity types associated with the focal anchor
    #[serde(rename = "entityTypes")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_types: Option<Vec<String>>,
    /// Global frequency counts for entity types (for IDF-like weighting). A KB-wide statistic, not a neighborhood property — kept here rather than on the graph.
    #[serde(rename = "entityTypeFrequencies")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_type_frequencies: Option<std::collections::BTreeMap<String, i64>>,
}

/// Semantically similar passages from across the knowledge base, found via vector search
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct GatheredContextSemanticContext {
    /// Passages ranked by cosine similarity to the focal text
    pub similar: Vec<SemanticMatch>,
    /// Entity types excluded from this recall — a record of how `similar` was filtered (e.g. ['Question'] so answer-generation never surfaces prior questions). Absent when no exclusion was applied.
    #[serde(rename = "excludedEntityTypes")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub excluded_entity_types: Option<Vec<String>>,
}

impl GatheredContextSemanticContext {
    /// The `GatheredContextSemanticContext` that states these and nothing else.
    pub fn new(similar: Vec<SemanticMatch>) -> Self {
        Self {
            similar,
            excluded_entity_types: None,
        }
    }
}

/// The parameters of a `yield` job: what it is asked to make (GenerationJobRequest) and the gathered context it is made from. The job's resource is derived from `context.focus` by the dispatcher (resource focus → focus.resource; annotation focus → focus.sourceResource, with the worker binding to focus.annotation), and the dispatcher refuses a parameter this schema does not name.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct GenerationJobParams {
    /// Title of the generated resource. Not empty: the gateway refuses a `job:create` whose title is.
    pub title: String,
    /// Storage URI for the generated resource's content — AUTHORITATIVE: the worker writes exactly here and never derives a location from the title. Not empty, and there is no fallback: the gateway refuses a `job:create` whose storageUri is.
    #[serde(rename = "storageUri")]
    pub storage_uri: String,
    /// Refining instruction, composed with `task` (task = what, prompt = how).
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub prompt: Option<String>,
    /// Entity-type tags to stamp on the synthesized resource. Used both as a prompt bias for the generation worker and as the `entityTypes` set on the resulting resource.
    #[serde(rename = "entityTypes")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_types: Option<Vec<String>>,
    /// Annotation/resource body locale — language the generated resource is written in (typically the user's UI locale). BCP-47.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub language: Option<String>,
    /// Source-resource locale — language of the resource being referenced, used in the prompt so the LLM understands embedded source-context snippets when source ≠ target language. BCP-47.
    #[serde(rename = "sourceLanguage")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub source_language: Option<String>,
    /// Sampling temperature forwarded to the model.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub temperature: Option<f64>,
    /// Output token budget forwarded to the model. Length never determines structure.
    #[serde(rename = "maxTokens")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub max_tokens: Option<f64>,
    /// Requested media type of the generated resource's content. Default `text/markdown` at the worker, which validates it against its supported output set and FAILS the job for anything it can't write — not a silent fallback.
    #[serde(rename = "outputMediaType")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub output_media_type: Option<SupportedMediaType>,
    /// What the model is asked to produce — the prompt's framing verb. Canonical values ('resource', 'answer', 'summary') map to the worker's tested framings; any other string is used VERBATIM as the framing instruction (loud degrade: the worker warns, never silently falls back). Unset ⇒ 'resource' (article framing).
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub task: Option<String>,
    /// How the output is internally segmented — shape for text-bearing media, subordinate to `outputMediaType` (never its peer). Canonical values: 'prose' (flowing paragraphs), 'sections' (titled sections + title), 'chat' (speaker-labeled turns); any other string becomes a freeform "organize as: …" directive (loud degrade). Unset ⇒ NO structure directive at all — the task framing and the model determine shape.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub structure: Option<String>,
    /// Ask the model to cite its sources, by the ids the gathered context labels its passages with. The model wraps the words a source supports as `[[<id>: <claim>]]`, the ids of several sources separated by commas; a bare `[[<id>]]` is replaced by the source's name. The worker checks every id against the gathered context (an id it did not show is dropped, with a warning), takes every token out of the stored content, and mints a W3C linking annotation on the new resource over exactly the words each token cites.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub cite: Option<bool>,
    /// The gathered context that grounds the generation. Its `focus` names the anchor: the DISPATCHER derives the job's resourceId from it (resource focus → focus.resource; annotation focus → focus.sourceResource, with the worker auto-binding to focus.annotation) and REJECTS a caller-supplied id — the context is authoritative. Under `cite`, the ids its embedding carries are the only valid citation targets.
    pub context: GatheredContext,
}

impl GenerationJobParams {
    /// The `GenerationJobParams` that states these and nothing else.
    pub fn new(
        title: impl Into<String>,
        storage_uri: impl Into<String>,
        context: GatheredContext,
    ) -> Self {
        Self {
            title: title.into(),
            storage_uri: storage_uri.into(),
            prompt: None,
            entity_types: None,
            language: None,
            source_language: None,
            temperature: None,
            max_tokens: None,
            output_media_type: None,
            task: None,
            structure: None,
            cite: None,
            context,
        }
    }
}

schema!(GenerationJobParams);

/// What a `yield` job is asked to make: every parameter of GenerationJobParams but its `context`, the input the resource is made from. It is what an announcement of the job carries.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct GenerationJobRequest {
    /// Title of the generated resource. Not empty: the gateway refuses a `job:create` whose title is.
    pub title: String,
    /// Storage URI for the generated resource's content — AUTHORITATIVE: the worker writes exactly here and never derives a location from the title. Not empty, and there is no fallback: the gateway refuses a `job:create` whose storageUri is.
    #[serde(rename = "storageUri")]
    pub storage_uri: String,
    /// Refining instruction, composed with `task` (task = what, prompt = how).
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub prompt: Option<String>,
    /// Entity-type tags to stamp on the synthesized resource. Used both as a prompt bias for the generation worker and as the `entityTypes` set on the resulting resource.
    #[serde(rename = "entityTypes")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_types: Option<Vec<String>>,
    /// Annotation/resource body locale — language the generated resource is written in (typically the user's UI locale). BCP-47.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub language: Option<String>,
    /// Source-resource locale — language of the resource being referenced, used in the prompt so the LLM understands embedded source-context snippets when source ≠ target language. BCP-47.
    #[serde(rename = "sourceLanguage")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub source_language: Option<String>,
    /// Sampling temperature forwarded to the model.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub temperature: Option<f64>,
    /// Output token budget forwarded to the model. Length never determines structure.
    #[serde(rename = "maxTokens")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub max_tokens: Option<f64>,
    /// Requested media type of the generated resource's content. Default `text/markdown` at the worker, which validates it against its supported output set and FAILS the job for anything it can't write — not a silent fallback.
    #[serde(rename = "outputMediaType")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub output_media_type: Option<SupportedMediaType>,
    /// What the model is asked to produce — the prompt's framing verb. Canonical values ('resource', 'answer', 'summary') map to the worker's tested framings; any other string is used VERBATIM as the framing instruction (loud degrade: the worker warns, never silently falls back). Unset ⇒ 'resource' (article framing).
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub task: Option<String>,
    /// How the output is internally segmented — shape for text-bearing media, subordinate to `outputMediaType` (never its peer). Canonical values: 'prose' (flowing paragraphs), 'sections' (titled sections + title), 'chat' (speaker-labeled turns); any other string becomes a freeform "organize as: …" directive (loud degrade). Unset ⇒ NO structure directive at all — the task framing and the model determine shape.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub structure: Option<String>,
    /// Ask the model to cite its sources, by the ids the gathered context labels its passages with. The model wraps the words a source supports as `[[<id>: <claim>]]`, the ids of several sources separated by commas; a bare `[[<id>]]` is replaced by the source's name. The worker checks every id against the gathered context (an id it did not show is dropped, with a warning), takes every token out of the stored content, and mints a W3C linking annotation on the new resource over exactly the words each token cites.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub cite: Option<bool>,
}

impl GenerationJobRequest {
    /// The `GenerationJobRequest` that states these and nothing else.
    pub fn new(title: impl Into<String>, storage_uri: impl Into<String>) -> Self {
        Self {
            title: title.into(),
            storage_uri: storage_uri.into(),
            prompt: None,
            entity_types: None,
            language: None,
            source_language: None,
            temperature: None,
            max_tokens: None,
            output_media_type: None,
            task: None,
            structure: None,
            cite: None,
        }
    }
}

schema!(GenerationJobRequest);

#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct GetAnnotationHistoryResponse {
    pub events: Vec<AttributedEvent>,
    pub total: f64,
    #[serde(rename = "annotationId")]
    pub annotation_id: AnnotationId,
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
}

schema!(GetAnnotationHistoryResponse);

#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct GetAnnotationResponse {
    pub annotation: Annotation,
    pub resource: Option<ResourceDescriptor>,
    #[serde(rename = "resolvedResource")]
    pub resolved_resource: Option<ResourceDescriptor>,
}

schema!(GetAnnotationResponse);

#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct GetAnnotationsResponse {
    pub annotations: Vec<Annotation>,
    /// Total number of annotations
    pub total: f64,
    #[serde(
        default,
        deserialize_with = "stated",
        skip_serializing_if = "Option::is_none"
    )]
    pub motivation: Option<Option<Motivation>>,
}

impl GetAnnotationsResponse {
    /// The `GetAnnotationsResponse` that states these and nothing else.
    pub fn new(annotations: Vec<Annotation>, total: f64) -> Self {
        Self {
            annotations,
            total,
            motivation: None,
        }
    }
}

schema!(GetAnnotationsResponse);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GetEntityTypesResponse {
    #[serde(rename = "entityTypes")]
    pub entity_types: Vec<String>,
}

schema!(GetEntityTypesResponse);

#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct GetEventsResponse {
    pub events: Vec<AttributedEvent>,
    pub total: f64,
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
}

schema!(GetEventsResponse);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GetReferencedByResponse {
    #[serde(rename = "referencedBy")]
    pub referenced_by: Vec<GetReferencedByResponseReferencedByItem>,
}

schema!(GetReferencedByResponse);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GetReferencedByResponseReferencedByItem {
    /// Reference annotation ID
    pub id: AnnotationId,
    /// Name of the resource containing the reference. Absent where no description of that resource is held, and where its name is empty.
    #[serde(rename = "resourceName")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resource_name: Option<String>,
    pub target: GetReferencedByResponseReferencedByItemTarget,
}

impl GetReferencedByResponseReferencedByItem {
    /// The `GetReferencedByResponseReferencedByItem` that states these and nothing else.
    pub fn new(id: AnnotationId, target: GetReferencedByResponseReferencedByItemTarget) -> Self {
        Self {
            id,
            resource_name: None,
            target,
        }
    }
}

schema!(GetReferencedByResponseReferencedByItem);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GetReferencedByResponseReferencedByItemTarget {
    /// ID of resource containing the reference
    pub source: ResourceId,
    pub selector: GetReferencedByResponseReferencedByItemTargetSelector,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GetReferencedByResponseReferencedByItemTargetSelector {
    /// The selected text that references this resource
    pub exact: String,
}

#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct GetResourceByTokenResponse {
    #[serde(rename = "sourceResource")]
    pub source_resource: ResourceDescriptor,
    /// ISO 8601 timestamp when token expires
    #[serde(rename = "expiresAt")]
    pub expires_at: String,
}

schema!(GetResourceByTokenResponse);

#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct GetResourceResponse {
    pub resource: ResourceDescriptor,
    /// All annotations for the resource (highlights, references, assessments, etc.)
    pub annotations: Vec<Annotation>,
}

schema!(GetResourceResponse);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GetTagSchemasResponse {
    #[serde(rename = "tagSchemas")]
    pub tag_schemas: Vec<TagSchema>,
}

schema!(GetTagSchemasResponse);

/// An annotation's graph presence. The node IS the annotation, so the full W3C object is required — selectors and body included, which is what lets a client place context annotations without a second fetch. Citations ride here too: an inbound reference is its linking annotation, anchored by an `annotation-of` edge to the resource it lives on and a `cites` edge to the focal resource.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GraphAnnotationNode {
    /// The AnnotationId — the same value as annotation.id
    pub id: AnnotationId,
    pub r#type: GraphAnnotationNodeType,
    /// The annotation's motivation, as a display label
    pub label: String,
    /// Entity types carried by the annotation
    #[serde(rename = "entityTypes")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_types: Option<Vec<String>>,
    pub annotation: Annotation,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub metadata: Option<std::collections::BTreeMap<String, serde_json::Value>>,
}

impl GraphAnnotationNode {
    /// The `GraphAnnotationNode` that states these and nothing else.
    pub fn new(id: AnnotationId, label: impl Into<String>, annotation: Annotation) -> Self {
        Self {
            id,
            r#type: GraphAnnotationNodeType::Annotation,
            label: label.into(),
            entity_types: None,
            annotation,
            metadata: None,
        }
    }
}

schema!(GraphAnnotationNode);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum GraphAnnotationNodeType {
    #[serde(rename = "annotation")]
    Annotation,
}

impl GraphAnnotationNodeType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            GraphAnnotationNodeType::Annotation => "annotation",
        }
    }
}

/// The graph database a service writes or reads, and what that kind of database needs to be reached: one of the kinds `xynolog-graph` has a store for, told apart by `type`. A secret is never a value here: a database's password is named by the environment variable that holds it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Serialize)]
#[serde(untagged)]
pub enum GraphConfig {
    Neo4jGraphConfig(Neo4jGraphConfig),
    JanusGraphConfig(JanusGraphConfig),
    NeptuneGraphConfig(NeptuneGraphConfig),
    MemoryGraphConfig(MemoryGraphConfig),
}

impl<'de> serde::Deserialize<'de> for GraphConfig {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("type").and_then(serde_json::Value::as_str) {
            Some("neo4j") => serde_json::from_value(value).map(GraphConfig::Neo4jGraphConfig),
            Some("janusgraph") => serde_json::from_value(value).map(GraphConfig::JanusGraphConfig),
            Some("neptune") => serde_json::from_value(value).map(GraphConfig::NeptuneGraphConfig),
            Some("memory") => serde_json::from_value(value).map(GraphConfig::MemoryGraphConfig),
            _ => {
                return Err(serde::de::Error::custom(
                    "a GraphConfig states a `type` that is one of `neo4j`, `janusgraph`, `neptune`, `memory`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

member!(GraphConfig::Neo4jGraphConfig(Neo4jGraphConfig));
member!(GraphConfig::JanusGraphConfig(JanusGraphConfig));
member!(GraphConfig::NeptuneGraphConfig(NeptuneGraphConfig));
member!(GraphConfig::MemoryGraphConfig(MemoryGraphConfig));
schema!(GraphConfig);

/// A resource's presence in the gathered knowledge graph.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct GraphResourceNode {
    /// The resource's ResourceId
    pub id: ResourceId,
    pub r#type: GraphResourceNodeType,
    /// The resource's display name — its raw id when the resource's view was missing at build time
    pub label: String,
    /// Entity types on the resource
    #[serde(rename = "entityTypes")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_types: Option<Vec<String>>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub metadata: Option<std::collections::BTreeMap<String, serde_json::Value>>,
}

impl GraphResourceNode {
    /// The `GraphResourceNode` that states these and nothing else.
    pub fn new(id: ResourceId, label: impl Into<String>) -> Self {
        Self {
            id,
            r#type: GraphResourceNodeType::Resource,
            label: label.into(),
            entity_types: None,
            metadata: None,
        }
    }
}

schema!(GraphResourceNode);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum GraphResourceNodeType {
    #[serde(rename = "resource")]
    Resource,
}

impl GraphResourceNodeType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            GraphResourceNodeType::Resource => "resource",
        }
    }
}

/// graph/schema.json: the shape of the graph a store keeps, as a reader of the store finds it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GraphSchema {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    /// Each kind of node the graph holds.
    pub nodes: GraphSchemaNodes,
    /// Each kind of relationship the graph holds.
    pub relationships: GraphSchemaRelationships,
    /// A link's target the graph has not been given yet: a node of its kind that holds its key and the marker, `true`, and nothing else. A node without the marker is no stub.
    pub stub: GraphSchemaStub,
}

schema!(GraphSchema);

/// Each kind of node the graph holds.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GraphSchemaNodes {
    /// A kind of node: its label, the codec row it holds, the property it is one of its kind by, and the properties a reader finds one by.
    pub resource: GraphSchemaNodesResource,
    /// A kind of node: its label, the codec row it holds, the property it is one of its kind by, and the properties a reader finds one by.
    pub annotation: GraphSchemaNodesAnnotation,
    /// A kind of node: its label, the codec row it holds, the property it is one of its kind by, and the properties a reader finds one by.
    #[serde(rename = "entityType")]
    pub entity_type: GraphSchemaNodesEntityType,
}

/// A kind of node: its label, the codec row it holds, the property it is one of its kind by, and the properties a reader finds one by.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GraphSchemaNodesAnnotation {
    /// Its label.
    pub label: String,
    /// The part of graph/codec-cases.json whose `properties` and `json` are the node's properties. A node without one holds its key alone.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub row: Option<String>,
    /// The property no two nodes of its kind share.
    pub key: String,
    /// The properties other than its key that a reader finds a node of its kind by.
    pub lookups: Vec<String>,
}

impl GraphSchemaNodesAnnotation {
    /// The `GraphSchemaNodesAnnotation` that states these and nothing else.
    pub fn new(label: impl Into<String>, key: impl Into<String>, lookups: Vec<String>) -> Self {
        Self {
            label: label.into(),
            row: None,
            key: key.into(),
            lookups,
        }
    }
}

/// A kind of node: its label, the codec row it holds, the property it is one of its kind by, and the properties a reader finds one by.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GraphSchemaNodesEntityType {
    /// Its label.
    pub label: String,
    /// The part of graph/codec-cases.json whose `properties` and `json` are the node's properties. A node without one holds its key alone.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub row: Option<String>,
    /// The property no two nodes of its kind share.
    pub key: String,
    /// The properties other than its key that a reader finds a node of its kind by.
    pub lookups: Vec<String>,
}

impl GraphSchemaNodesEntityType {
    /// The `GraphSchemaNodesEntityType` that states these and nothing else.
    pub fn new(label: impl Into<String>, key: impl Into<String>, lookups: Vec<String>) -> Self {
        Self {
            label: label.into(),
            row: None,
            key: key.into(),
            lookups,
        }
    }
}

/// A kind of node: its label, the codec row it holds, the property it is one of its kind by, and the properties a reader finds one by.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GraphSchemaNodesResource {
    /// Its label.
    pub label: String,
    /// The part of graph/codec-cases.json whose `properties` and `json` are the node's properties. A node without one holds its key alone.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub row: Option<String>,
    /// The property no two nodes of its kind share.
    pub key: String,
    /// The properties other than its key that a reader finds a node of its kind by.
    pub lookups: Vec<String>,
}

impl GraphSchemaNodesResource {
    /// The `GraphSchemaNodesResource` that states these and nothing else.
    pub fn new(label: impl Into<String>, key: impl Into<String>, lookups: Vec<String>) -> Self {
        Self {
            label: label.into(),
            row: None,
            key: key.into(),
            lookups,
        }
    }
}

/// Each kind of relationship the graph holds.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GraphSchemaRelationships {
    /// A kind of relationship: its type, the kind of node it goes from and the kind it goes to, and what it says.
    #[serde(rename = "belongsTo")]
    pub belongs_to: GraphSchemaRelationshipsBelongsTo,
    /// A kind of relationship: its type, the kind of node it goes from and the kind it goes to, and what it says.
    pub references: GraphSchemaRelationshipsReferences,
    /// A kind of relationship: its type, the kind of node it goes from and the kind it goes to, and what it says.
    #[serde(rename = "taggedAs")]
    pub tagged_as: GraphSchemaRelationshipsTaggedAs,
}

/// A kind of relationship: its type, the kind of node it goes from and the kind it goes to, and what it says.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GraphSchemaRelationshipsBelongsTo {
    /// Its type.
    pub r#type: String,
    /// The kind of node it goes from, by its name under `nodes`.
    pub from: String,
    /// The kind of node it goes to, by its name under `nodes`.
    pub to: String,
    /// What one says.
    pub says: String,
}

/// A kind of relationship: its type, the kind of node it goes from and the kind it goes to, and what it says.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GraphSchemaRelationshipsReferences {
    /// Its type.
    pub r#type: String,
    /// The kind of node it goes from, by its name under `nodes`.
    pub from: String,
    /// The kind of node it goes to, by its name under `nodes`.
    pub to: String,
    /// What one says.
    pub says: String,
}

/// A kind of relationship: its type, the kind of node it goes from and the kind it goes to, and what it says.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GraphSchemaRelationshipsTaggedAs {
    /// Its type.
    pub r#type: String,
    /// The kind of node it goes from, by its name under `nodes`.
    pub from: String,
    /// The kind of node it goes to, by its name under `nodes`.
    pub to: String,
    /// What one says.
    pub says: String,
}

/// A link's target the graph has not been given yet: a node of its kind that holds its key and the marker, `true`, and nothing else. A node without the marker is no stub.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct GraphSchemaStub {
    /// The kind of node a stub is, by its name under `nodes`.
    pub node: String,
    /// The property that marks a stub.
    pub marker: String,
}

/// Liveness: the process is up and serving. It asks nothing of the Archivist or the broker — a gateway that cannot reach them refuses to start, so one that answers here got past both at boot.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct HealthResponse {
    pub status: String,
    pub message: String,
    pub version: String,
    pub timestamp: String,
}

schema!(HealthResponse);

/// What a highlighting job takes: passages of the resource worth a reader's attention are marked, with no text of the job's own.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct HighlightingJobParams {
    pub motivation: HighlightingJobParamsMotivation,
    /// What to look for, in the caller's words. Added to the prompt.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub instructions: Option<String>,
    /// How many annotations to aim for per 2000 words of the resource.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub density: Option<f64>,
    /// The language of the resource being read. BCP 47.
    #[serde(rename = "sourceLanguage")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub source_language: Option<String>,
}

impl Default for HighlightingJobParams {
    fn default() -> Self {
        Self::new()
    }
}

impl HighlightingJobParams {
    /// The `HighlightingJobParams` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            motivation: HighlightingJobParamsMotivation::Highlighting,
            instructions: None,
            density: None,
            source_language: None,
        }
    }
}

schema!(HighlightingJobParams);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum HighlightingJobParamsMotivation {
    #[serde(rename = "highlighting")]
    Highlighting,
}

impl HighlightingJobParamsMotivation {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            HighlightingJobParamsMotivation::Highlighting => "highlighting",
        }
    }
}

/// Where somebody else's daemon listens.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct HostPort {
    /// A host name or address the stack's containers can reach.
    pub host: String,
    /// The port it listens on.
    pub port: u16,
}

schema!(HostPort);

/// A knowledge base reached through its gateway, over HTTP. The gateway's origin is the protocol, the host in lowercase and the port; a host that is not a host's name is refused before it is put into a URL (specs/src/session/gateway-url-cases.json).
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct HttpEndpoint {
    /// Discriminant: the endpoint is a gateway reached over HTTP.
    pub kind: HttpEndpointKind,
    /// The gateway's host, as a person or a discovery document gave it.
    pub host: String,
    /// The gateway's port.
    pub port: u16,
    /// What the gateway is reached over.
    pub protocol: HttpEndpointProtocol,
}

impl HttpEndpoint {
    /// The `HttpEndpoint` that states these and nothing else.
    pub fn new(host: impl Into<String>, port: u16, protocol: HttpEndpointProtocol) -> Self {
        Self {
            kind: HttpEndpointKind::Http,
            host: host.into(),
            port,
            protocol,
        }
    }
}

schema!(HttpEndpoint);

/// Discriminant: the endpoint is a gateway reached over HTTP.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum HttpEndpointKind {
    #[serde(rename = "http")]
    Http,
}

impl HttpEndpointKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            HttpEndpointKind::Http => "http",
        }
    }
}

/// What the gateway is reached over.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum HttpEndpointProtocol {
    #[serde(rename = "http")]
    Http,
    #[serde(rename = "https")]
    Https,
}

impl HttpEndpointProtocol {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            HttpEndpointProtocol::Http => "http",
            HttpEndpointProtocol::Https => "https",
        }
    }
}

/// An HTTP response's status code, as the tables state one. No API states it, so it is no component.
pub type HttpStatus = u16;

/// An account in a knowledge base's launcher-managed identity realm. Passwords and tokens are never included.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct IdentityUser {
    /// The account's sign-in name, normally its email address.
    pub email: String,
    /// The identity the account acts under in Xynolog.
    pub identity: String,
    /// Whether the identity provider currently allows this account to sign in.
    pub enabled: bool,
}

schema!(IdentityUser);

/// Create one account in the launcher-managed Keycloak realm for a specific local knowledge base.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct IdentityUseraddParams {
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    pub target: LocalTarget,
    /// The email address that will sign in to this knowledge base.
    pub email: String,
    /// The user's password. Secret: carried only in this local control request, never in progress, diagnostics, or persistent state.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub password: Option<String>,
    /// Generate a random password in the launcher and return it once in the result.
    #[serde(rename = "generatePassword")]
    pub generate_password: bool,
}

impl IdentityUseraddParams {
    /// The `IdentityUseraddParams` that states these and nothing else.
    pub fn new(
        api_version: ApiVersion,
        target: LocalTarget,
        email: impl Into<String>,
        generate_password: bool,
    ) -> Self {
        Self {
            api_version,
            target,
            email: email.into(),
            password: None,
            generate_password,
        }
    }
}

schema!(IdentityUseraddParams);

/// The created account's sign-in identity. A generated password is present only in this one answer and is not stored by the launcher.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct IdentityUseraddResult {
    /// The account's email address.
    pub email: String,
    /// The identity the account acts under in Xynolog.
    pub identity: String,
    /// Whether a new account was created.
    pub created: bool,
    /// The generated password, returned once so the operator can share it with the user. Absent when the operator supplied the password.
    #[serde(rename = "generatedPassword")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub generated_password: Option<String>,
}

impl IdentityUseraddResult {
    /// The `IdentityUseraddResult` that states these and nothing else.
    pub fn new(email: impl Into<String>, identity: impl Into<String>, created: bool) -> Self {
        Self {
            email: email.into(),
            identity: identity.into(),
            created,
            generated_password: None,
        }
    }
}

schema!(IdentityUseraddResult);

/// List accounts in one local knowledge base's launcher-managed Keycloak realm.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct IdentityUsersListParams {
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    pub target: LocalTarget,
}

schema!(IdentityUsersListParams);

/// Accounts in the selected knowledge base's launcher-managed identity realm.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct IdentityUsersListResult {
    /// Accounts, sorted by sign-in name.
    pub users: Vec<IdentityUser>,
}

schema!(IdentityUsersListResult);

/// The container image a service runs, as a registry names it: `ghcr.io/xynolog/xynolog-gateway:latest`.
pub type Image = String;

/// The engines a machine uses for a knowledge base: the providers it reaches, and the provider and model each job and each Librarian actor is done with. A knowledge base's repository may carry several, one for each provider, and a machine chooses one.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct Inference {
    #[serde(rename = "apiVersion")]
    pub api_version: StackApiVersion,
    pub kind: InferenceKind,
    pub metadata: Metadata,
    /// The providers, and the engine for each job and each Librarian actor.
    pub spec: InferenceSpec,
}

impl Inference {
    /// The `Inference` that states these and nothing else.
    pub fn new(api_version: StackApiVersion, metadata: Metadata, spec: InferenceSpec) -> Self {
        Self {
            api_version,
            kind: InferenceKind::Inference,
            metadata,
            spec,
        }
    }
}

schema!(Inference);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum InferenceKind {
    #[serde(rename = "Inference")]
    Inference,
}

impl InferenceKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            InferenceKind::Inference => "Inference",
        }
    }
}

/// A provider's actual ceilings for a model, discovered from the provider itself (Anthropic Models API; Ollama /api/show) — never hand-maintained constants. Semantics differ by provider shape: Anthropic reports maximum input tokens in contextTokens with a separate output ceiling in maxOutputTokens; Ollama reports the shared input+output window and mirrors it into both fields (there is no separate output ceiling), so maxOutputTokens === contextTokens signals a shared window.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct InferenceLimits {
    /// The context window in tokens. Anthropic: maximum input tokens (output has its own ceiling). Ollama: the shared input+output window.
    #[serde(rename = "contextTokens")]
    pub context_tokens: f64,
    /// Maximum output tokens per generation. Equal to contextTokens when the provider has a single shared window.
    #[serde(rename = "maxOutputTokens")]
    pub max_output_tokens: f64,
    /// Whether this engine accepts a caller-supplied sampling temperature, measured against the provider (Anthropic: an active probe at discovery, because some models reject the parameter outright and the Models API does not say; Ollama: always true). Consumers treat only an explicit false as 'hide temperature controls' — absence means no claim.
    #[serde(rename = "acceptsTemperature")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub accepts_temperature: Option<bool>,
}

impl InferenceLimits {
    /// The `InferenceLimits` that states these and nothing else.
    pub fn new(context_tokens: f64, max_output_tokens: f64) -> Self {
        Self {
            context_tokens,
            max_output_tokens,
            accepts_temperature: None,
        }
    }
}

schema!(InferenceLimits);

/// Request for the inference limits of the engines one service holds a client for. Answered on job:limits-requested by the worker, and on gather:limits-requested and match:limits-requested by the librarian: each service that holds an inference credential reports for its own engines, so no other service needs one.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct InferenceLimitsRequest {}

schema!(InferenceLimitsRequest);

/// The inference limits one service discovered for the engines it holds a client for. An engine whose discovery is currently unavailable is absent.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct InferenceLimitsResult {
    pub response: InferenceLimitsResultResponse,
}

schema!(InferenceLimitsResult);

#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct InferenceLimitsResultResponse {
    pub limits: Vec<EngineLimits>,
}

/// The providers, and the engine for each job and each Librarian actor.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct InferenceSpec {
    /// Each provider an engine names, and how it is reached.
    pub providers: std::collections::BTreeMap<String, Provider>,
    /// The engine each job is done with when software does it, and the engine each Librarian actor asks.
    pub engines: ArchivistEngines,
}

/// The tokens an issuer issued at the end of a sign-in.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct IssuedTokens {
    /// The access token: short-lived, sent as a Bearer token.
    pub access: String,
    /// The refresh token: what renews the access token without another sign-in.
    pub refresh: String,
}

schema!(IssuedTokens);

/// The issuer the launcher runs for the knowledge bases on a machine, with a realm for each, and the database it keeps their realms in. It belongs to no knowledge base, so its document is kept in the launcher's state home, in `stack/issuer.yaml`, not in a knowledge base's repository. A knowledge base trusts it by naming `shared`; one trusting somebody else's issuer names it at `external`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct Issuer {
    #[serde(rename = "apiVersion")]
    pub api_version: StackApiVersion,
    pub kind: IssuerKind,
    pub metadata: Metadata,
    /// The issuer, where it is published, and the database it keeps its realms in.
    pub spec: IssuerSpec,
}

impl Issuer {
    /// The `Issuer` that states these and nothing else.
    pub fn new(api_version: StackApiVersion, metadata: Metadata, spec: IssuerSpec) -> Self {
        Self {
            api_version,
            kind: IssuerKind::Issuer,
            metadata,
            spec,
        }
    }
}

schema!(Issuer);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum IssuerKind {
    #[serde(rename = "Issuer")]
    Issuer,
}

impl IssuerKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            IssuerKind::Issuer => "Issuer",
        }
    }
}

/// The issuer, where it is published, and the database it keeps its realms in.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct IssuerSpec {
    /// The issuer's driver: `keycloak`.
    pub r#type: String,
    pub image: Image,
    pub resources: Resources,
    /// The port the issuer is published on, on this machine: the origin of every realm's `iss`, so the one number wherever the issuer is reached.
    pub port: u16,
    /// The database the issuer keeps its realms in.
    pub database: IssuerSpecDatabase,
}

/// The database the issuer keeps its realms in.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct IssuerSpecDatabase {
    /// The database's driver: `postgres`.
    pub r#type: String,
    /// The database the issuer keeps its realms in: a lowercase PostgreSQL identifier, as PostgreSQL itself names an unquoted one. On a PostgreSQL the launcher runs, the launcher creates it; on one somebody else runs (`external`), it must already exist there.
    pub name: String,
    /// The user the issuer signs in as.
    pub user: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub image: Option<Image>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resources: Option<Resources>,
    /// The port a PostgreSQL the launcher runs is published on, on this machine, where the issuer reaches it. One somebody else runs is reached at `external`.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub port: Option<u16>,
    /// A database somebody else runs.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub external: Option<IssuerSpecDatabaseExternal>,
}

impl IssuerSpecDatabase {
    /// The `IssuerSpecDatabase` that states these and nothing else.
    pub fn new(
        r#type: impl Into<String>,
        name: impl Into<String>,
        user: impl Into<String>,
    ) -> Self {
        Self {
            r#type: r#type.into(),
            name: name.into(),
            user: user.into(),
            image: None,
            resources: None,
            port: None,
            external: None,
        }
    }
}

/// A database somebody else runs.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct IssuerSpecDatabaseExternal {
    /// A host name or address the issuer can reach.
    pub host: String,
    /// The port it listens on.
    pub port: u16,
    pub password: SecretRef,
}

/// A graph kept in a JanusGraph server, asked in Gremlin. No service has been run against one.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct JanusGraphConfig {
    pub r#type: JanusGraphConfigType,
    /// The server's host.
    pub host: String,
    /// The port its Gremlin endpoint listens on.
    pub port: u16,
}

impl JanusGraphConfig {
    /// The `JanusGraphConfig` that states these and nothing else.
    pub fn new(host: impl Into<String>, port: u16) -> Self {
        Self {
            r#type: JanusGraphConfigType::Janusgraph,
            host: host.into(),
            port,
        }
    }
}

schema!(JanusGraphConfig);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JanusGraphConfigType {
    #[serde(rename = "janusgraph")]
    Janusgraph,
}

impl JanusGraphConfigType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JanusGraphConfigType::Janusgraph => "janusgraph",
        }
    }
}

/// A job as the dispatcher holds it. Its `status` decides which timestamps and outcome fields it carries. It is what a claim returns (`job:claimed`, always `running`) and what the queue stores, inside a JobRecord.
#[derive(Debug, Clone, PartialEq, serde::Serialize)]
#[serde(untagged)]
pub enum Job {
    Pending(JobPending),
    Running(JobRunning),
    Complete(JobComplete),
    Failed(JobFailed),
    Cancelled(JobCancelled),
}

impl<'de> serde::Deserialize<'de> for Job {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("status").and_then(serde_json::Value::as_str) {
            Some("pending") => serde_json::from_value(value).map(Job::Pending),
            Some("running") => serde_json::from_value(value).map(Job::Running),
            Some("complete") => serde_json::from_value(value).map(Job::Complete),
            Some("failed") => serde_json::from_value(value).map(Job::Failed),
            Some("cancelled") => serde_json::from_value(value).map(Job::Cancelled),
            _ => {
                return Err(serde::de::Error::custom(
                    "a Job states a `status` that is one of `pending`, `running`, `complete`, `failed`, `cancelled`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

member!(Job::Pending(JobPending));
member!(Job::Running(JobRunning));
member!(Job::Complete(JobComplete));
member!(Job::Failed(JobFailed));
member!(Job::Cancelled(JobCancelled));
schema!(Job);

/// Bus command the dispatcher emits, under its own service identity, immediately after it accepts a job:claim — the correlated job:claimed reply is unchanged. The Stower persists it as job:assigned. It is the one fact only the dispatcher can vouch for: which holder took which job, and who requested it. A later write citing `jobId` is checked against the holder and its `creator` derived from the requester by reading the resource's own log, with nothing outside the record.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobAssignCommand {
    /// The dispatcher's service DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    #[serde(rename = "jobId")]
    pub job_id: JobId,
    #[serde(rename = "jobType")]
    pub job_type: JobType,
    /// The job's resource — for a generation, the source it generates from. The assignment is persisted on this resource's log.
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// DID of the claimant whose claim was accepted — the `_userId` the gateway stamped on the job:claim, restated by the dispatcher.
    pub holder: UserId,
    /// DID of the emitter of the job:create that produced this job — the `_userId` the gateway stamped on that create, restated by the dispatcher.
    pub requester: UserId,
}

impl JobAssignCommand {
    /// The `JobAssignCommand` that states these and nothing else.
    pub fn new(
        job_id: JobId,
        job_type: JobType,
        resource_id: ResourceId,
        holder: UserId,
        requester: UserId,
    ) -> Self {
        Self {
            _user_id: None,
            job_id,
            job_type,
            resource_id,
            holder,
            requester,
        }
    }
}

schema!(JobAssignCommand);

/// Payload for job:assigned — the dispatcher's own record that it accepted a claim. Emitted by the dispatcher under its service identity after a successful job:claim (the correlated job:claimed reply is unchanged). This is the one fact only the dispatcher can vouch for: which holder took which job, and who requested it. The Stower persists it beside job:started so that a write citing `jobId` can be checked against the holder and its `creator` derived from the requester with no read outside the event log.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobAssignedPayload {
    #[serde(rename = "jobId")]
    pub job_id: JobId,
    #[serde(rename = "jobType")]
    pub job_type: JobType,
    /// The job's resource — for a generation, the source it generates from. Job events are scoped here.
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// DID of the emitter whose claim the dispatcher accepted. The bus stamped it on the job:claim as `_userId`; the dispatcher restates it here under its own identity.
    pub holder: UserId,
    /// DID of the emitter of the job:create that produced this job. The dispatcher restates the `_userId` the gateway stamped on that create.
    pub requester: UserId,
}

schema!(JobAssignedPayload);

/// A worker's settling of a running job it holds whose work it has stopped for a cancellation — the queue moves the job to cancelled/. Distinct from JobCancelRequest (the client→worker REQUEST to stop): this is the worker announcing it did, so the running job is never yanked to cancelled/ out from under a live worker (the roach-motel race).
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobCancelCommand {
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    #[serde(rename = "jobId")]
    pub job_id: JobId,
    #[serde(rename = "jobType")]
    pub job_type: JobType,
    /// Annotation this job is attached to, when applicable. Lets the UI route cancellation feedback to a specific annotation.
    #[serde(rename = "annotationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotation_id: Option<AnnotationId>,
    /// The units the worker had finished when it stopped. Recorded on the cancelled job's metadata so the work already done stays visible.
    #[serde(rename = "completedUnits")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub completed_units: Option<Vec<String>>,
    /// The furthest each unit begun got, keyed by unit, with what it had counted there — the grain `completedUnits` cannot express. A unit named in `completedUnits` is stated here too, by the cursor it ended at: a later attempt skips it whole and counts it by that cursor. A cursor never says a unit is finished; only `completedUnits` does. Merged monotonically per unit, finished or not: a stale snapshot must never move a cursor backward.
    #[serde(rename = "unitCursors")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub unit_cursors: Option<std::collections::BTreeMap<String, UnitCursor>>,
}

impl JobCancelCommand {
    /// The `JobCancelCommand` that states these and nothing else.
    pub fn new(resource_id: ResourceId, job_id: JobId, job_type: JobType) -> Self {
        Self {
            _user_id: None,
            resource_id,
            job_id,
            job_type,
            annotation_id: None,
            completed_units: None,
            unit_cursors: None,
        }
    }
}

schema!(JobCancelCommand);

/// Request to cancel one job, named by its id. A pending job is cancelled immediately by the dispatcher. A running job is cancelled only by the worker that holds it: the worker stops its work and settles the job with `job:cancel` (JobCancelCommand). The queue is never made to yank a running job out from under a live worker.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobCancelRequest {
    #[serde(rename = "jobId")]
    pub job_id: JobId,
}

schema!(JobCancelRequest);

/// What a cancel did, in the `response` of `job:cancel-ok`: whether the queue acted on the job it named. A pending job is cancelled outright; a running one is left to its worker, so for it true means accepted, not stopped.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobCancelResult {
    /// True when the queue acted on the job; false when the job is unknown or already over.
    pub cancelled: bool,
}

schema!(JobCancelResult);

/// A job cancelled before it concluded.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct JobCancelled {
    pub status: JobCancelledStatus,
    pub metadata: JobMetadata,
    pub params: JobParams,
    /// When its claim was made; absent when it was cancelled while pending.
    #[serde(rename = "startedAt")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub started_at: Option<String>,
    /// When it was cancelled.
    #[serde(rename = "completedAt")]
    pub completed_at: String,
}

impl JobCancelled {
    /// The `JobCancelled` that states these and nothing else.
    pub fn new(metadata: JobMetadata, params: JobParams, completed_at: impl Into<String>) -> Self {
        Self {
            status: JobCancelledStatus::Cancelled,
            metadata,
            params,
            started_at: None,
            completed_at: completed_at.into(),
        }
    }
}

schema!(JobCancelled);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobCancelledStatus {
    #[serde(rename = "cancelled")]
    Cancelled,
}

impl JobCancelledStatus {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobCancelledStatus::Cancelled => "cancelled",
        }
    }
}

/// Command to persist a running job's completed-unit checkpoint AT unit completion. Distinct from JobFailCommand's checkpoint, which lands only on a clean failure: a worker that dies (crash/OOM/kill) never emits job:fail, so this durable, unthrottled write is what lets the janitor's stale-running recovery resume a dead worker's job rather than redo its finished units.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobCheckpointCommand {
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    #[serde(rename = "jobId")]
    pub job_id: JobId,
    /// Entity-type units whose annotations have been fully emitted so far. Unioned into the running job's metadata checkpoint; a retry after recovery skips them.
    #[serde(rename = "completedUnits")]
    pub completed_units: Vec<String>,
    /// The furthest each unit begun got, keyed by unit, with what it had counted there — the grain `completedUnits` cannot express. A unit named in `completedUnits` is stated here too, by the cursor it ended at: a later attempt skips it whole and counts it by that cursor. A cursor never says a unit is finished; only `completedUnits` does. Merged monotonically per unit, finished or not: a stale snapshot must never move a cursor backward.
    #[serde(rename = "unitCursors")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub unit_cursors: Option<std::collections::BTreeMap<String, UnitCursor>>,
}

impl JobCheckpointCommand {
    /// The `JobCheckpointCommand` that states these and nothing else.
    pub fn new(job_id: JobId, completed_units: Vec<String>) -> Self {
        Self {
            _user_id: None,
            job_id,
            completed_units,
            unit_cursors: None,
        }
    }
}

schema!(JobCheckpointCommand);

/// Claim the NEXT pending job that matches one of `accepts` (atomic: pending → running). A job:queued announcement is a WAKE-UP, not a reservation: the claimed job may differ from the announced one, and two claims after one announcement both succeed on different jobs instead of racing for one. job:claimed carries the claimed job; job:claim-failed reports that nothing matching is pending.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobClaimCommand {
    /// The jobs this claim takes. A job is handed over when it matches any one of them.
    pub accepts: Vec<JobFilter>,
    /// Authenticated claimant's DID, injected by the /bus/emit gateway. Clients do not set this. The dispatcher records it as the holder on job:assigned.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    /// The claimant's capabilities (the token's `roles`), injected by the /bus/emit gateway. Clients do not set this. The dispatcher authorizes the claim by capability — it admits the claim only when this carries the worker role — so a claimant that is not a worker for this knowledge base is refused before the queue is consulted.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _roles: Option<Vec<String>>,
}

impl JobClaimCommand {
    /// The `JobClaimCommand` that states these and nothing else.
    pub fn new(accepts: Vec<JobFilter>) -> Self {
        Self {
            accepts,
            _user_id: None,
            _roles: None,
        }
    }
}

schema!(JobClaimCommand);

/// The reply to a successful `job:claim`: the claimed job, now running under the claimant.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct JobClaimedResult {
    pub response: JobRunning,
}

schema!(JobClaimedResult);

/// A job its worker completed.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct JobComplete {
    pub status: JobCompleteStatus,
    pub metadata: JobMetadata,
    pub params: JobParams,
    /// When the claim that completed it was made.
    #[serde(rename = "startedAt")]
    pub started_at: String,
    /// When it completed.
    #[serde(rename = "completedAt")]
    pub completed_at: String,
    pub result: JobStoredResult,
}

impl JobComplete {
    /// The `JobComplete` that states these and nothing else.
    pub fn new(
        metadata: JobMetadata,
        params: JobParams,
        started_at: impl Into<String>,
        completed_at: impl Into<String>,
        result: JobStoredResult,
    ) -> Self {
        Self {
            status: JobCompleteStatus::Complete,
            metadata,
            params,
            started_at: started_at.into(),
            completed_at: completed_at.into(),
            result,
        }
    }
}

schema!(JobComplete);

/// A job's worker says the job is complete. The result it carries is its verb's: a `mark` job's counts or the resource a `yield` job made, or a decline from either. A completion whose result is the other verb's is refused where the command is admitted.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Serialize)]
#[serde(untagged)]
pub enum JobCompleteCommand {
    MarkJobCompleteCommand(MarkJobCompleteCommand),
    YieldJobCompleteCommand(YieldJobCompleteCommand),
}

impl<'de> serde::Deserialize<'de> for JobCompleteCommand {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("jobType").and_then(serde_json::Value::as_str) {
            Some("mark") => {
                serde_json::from_value(value).map(JobCompleteCommand::MarkJobCompleteCommand)
            }
            Some("yield") => {
                serde_json::from_value(value).map(JobCompleteCommand::YieldJobCompleteCommand)
            }
            _ => {
                return Err(serde::de::Error::custom(
                    "a JobCompleteCommand states a `jobType` that is one of `mark`, `yield`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

member!(JobCompleteCommand::MarkJobCompleteCommand(
    MarkJobCompleteCommand,
));
member!(JobCompleteCommand::YieldJobCompleteCommand(
    YieldJobCompleteCommand,
));
schema!(JobCompleteCommand);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobCompleteStatus {
    #[serde(rename = "complete")]
    Complete,
}

impl JobCompleteStatus {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobCompleteStatus::Complete => "complete",
        }
    }
}

/// Payload for job:completed domain event
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobCompletedPayload {
    #[serde(rename = "jobId")]
    pub job_id: JobId,
    #[serde(rename = "jobType")]
    pub job_type: JobType,
    /// Which attempt produced this event, 1-based (a first run is 1). ALWAYS present: the queue re-runs a failed job silently, so an operator reading progress or a terminal record has no other way to tell a re-run from a first run — and provider spend, already counted in xynolog_inference_tokens_total, cannot be attributed to a repeated document without it. Stated rather than inferred from absence, because 'attempt 1' is a fact the emitter always knows.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub attempt: Option<i64>,
    /// Annotation this job was attached to, when applicable
    #[serde(rename = "annotationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotation_id: Option<AnnotationId>,
    #[serde(rename = "totalSteps")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub total_steps: Option<i64>,
    /// For detection: total entities found
    #[serde(rename = "foundCount")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub found_count: Option<i64>,
    /// For generation: ID of generated resource
    #[serde(rename = "resultResourceId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub result_resource_id: Option<ResourceId>,
    /// For generation: URI of annotation that triggered generation
    #[serde(rename = "annotationUri")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotation_uri: Option<String>,
    /// Full result object for extensibility
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub result: Option<serde_json::Map<String, serde_json::Value>>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub durability: Option<DurabilityEvidence>,
}

impl JobCompletedPayload {
    /// The `JobCompletedPayload` that states these and nothing else.
    pub fn new(job_id: JobId, job_type: JobType) -> Self {
        Self {
            job_id,
            job_type,
            attempt: None,
            annotation_id: None,
            total_steps: None,
            found_count: None,
            result_resource_id: None,
            annotation_uri: None,
            result: None,
            durability: None,
        }
    }
}

schema!(JobCompletedPayload);

/// Create a job. A job description is its `jobType` and enough parameters to be well formed: a `mark` job names its resource and, in its parameters, its motivation; a `yield` job names its context.
#[derive(Debug, Clone, PartialEq, serde::Serialize)]
#[serde(untagged)]
pub enum JobCreateCommand {
    MarkJobCreateCommand(MarkJobCreateCommand),
    YieldJobCreateCommand(YieldJobCreateCommand),
}

impl<'de> serde::Deserialize<'de> for JobCreateCommand {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("jobType").and_then(serde_json::Value::as_str) {
            Some("mark") => {
                serde_json::from_value(value).map(JobCreateCommand::MarkJobCreateCommand)
            }
            Some("yield") => {
                serde_json::from_value(value).map(JobCreateCommand::YieldJobCreateCommand)
            }
            _ => {
                return Err(serde::de::Error::custom(
                    "a JobCreateCommand states a `jobType` that is one of `mark`, `yield`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

member!(JobCreateCommand::MarkJobCreateCommand(MarkJobCreateCommand));
member!(JobCreateCommand::YieldJobCreateCommand(
    YieldJobCreateCommand,
));
schema!(JobCreateCommand);

/// Result of a job:create command
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobCreatedResult {
    pub response: JobCreatedResultResponse,
}

schema!(JobCreatedResult);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobCreatedResultResponse {
    #[serde(rename = "jobId")]
    pub job_id: JobId,
}

schema!(JobCreatedResultResponse);

/// Result of a job that completed without doing its work because the resource could not be read. Distinct from a failure: nothing went wrong, there was simply no text to work with — an encrypted or damaged PDF, a scan whose text could not be recognized, or a document that yielded nothing. The reasons are the extraction vocabulary the Smelter reports on `smelt:settled`, MINUS `no-extractor`: a media type that can never yield text (a zip, an image) is a bad request rather than a decline, so a worker asked to detect over one throws and the job reports `job:fail`. Everything here is a resource-specific outcome — the same media type would have succeeded on a different document.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct JobDeclined {
    /// Always true. It is what tells a decline from the result of a job that did its work, which never carries it.
    pub declined: bool,
    /// Why the resource could not be read. A CODE, not a sentence: the client owns the wording, so a browser renders it in the user's language and the CLI renders English terminal copy from the same value. A prose `message` composed server-side would be English everywhere.
    pub reason: JobDeclinedReason,
}

schema!(JobDeclined);

/// Why the resource could not be read. A CODE, not a sentence: the client owns the wording, so a browser renders it in the user's language and the CLI renders English terminal copy from the same value. A prose `message` composed server-side would be English everywhere.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobDeclinedReason {
    #[serde(rename = "no-text-layer")]
    NoTextLayer,
    #[serde(rename = "encrypted")]
    Encrypted,
    #[serde(rename = "corrupt")]
    Corrupt,
    #[serde(rename = "too-large")]
    TooLarge,
    #[serde(rename = "empty")]
    Empty,
}

impl JobDeclinedReason {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobDeclinedReason::NoTextLayer => "no-text-layer",
            JobDeclinedReason::Encrypted => "encrypted",
            JobDeclinedReason::Corrupt => "corrupt",
            JobDeclinedReason::TooLarge => "too-large",
            JobDeclinedReason::Empty => "empty",
        }
    }
}

/// Command to mark a job as failed
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobFailCommand {
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    #[serde(rename = "jobId")]
    pub job_id: JobId,
    #[serde(rename = "jobType")]
    pub job_type: JobType,
    /// Which attempt produced this event, 1-based (a first run is 1). ALWAYS present: the queue re-runs a failed job silently, so an operator reading progress or a terminal record has no other way to tell a re-run from a first run — and provider spend, already counted in xynolog_inference_tokens_total, cannot be attributed to a repeated document without it. Stated rather than inferred from absence, because 'attempt 1' is a fact the emitter always knows.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub attempt: Option<i64>,
    /// Annotation this job is attached to, when applicable. Lets the UI route failure feedback (error toast, revert state) to a specific annotation.
    #[serde(rename = "annotationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotation_id: Option<AnnotationId>,
    pub error: String,
    /// Entity-type units whose annotations were fully emitted before this failure (checkpointed resume). The queue records them on the retried job's metadata; a retried claim skips them so completed work is neither redone nor duplicated.
    #[serde(rename = "completedUnits")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub completed_units: Option<Vec<String>>,
    /// The furthest each unit begun got, keyed by unit, with what it had counted there — the grain `completedUnits` cannot express. A unit named in `completedUnits` is stated here too, by the cursor it ended at: a later attempt skips it whole and counts it by that cursor. A cursor never says a unit is finished; only `completedUnits` does. Merged monotonically per unit, finished or not: a stale snapshot must never move a cursor backward.
    #[serde(rename = "unitCursors")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub unit_cursors: Option<std::collections::BTreeMap<String, UnitCursor>>,
    #[serde(rename = "failureClass")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub failure_class: Option<FailureClass>,
    /// Whether the queue will re-queue this job for another attempt. Computed by the worker from the SAME rule the queue applies when it takes the failure (specs/src/jobs/retry-cases.json, which every SDK and the dispatcher run) using the retry budget carried on the claimed record. FALSE (or absent) means this failure is TERMINAL: a client's job-watch stream ends here. TRUE means the work continues on a fresh attempt — the failure is an event, not the end, and a stream that terminated on it would report a recovering run as a failed one.
    #[serde(rename = "willRetry")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub will_retry: Option<bool>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub durability: Option<DurabilityEvidence>,
}

impl JobFailCommand {
    /// The `JobFailCommand` that states these and nothing else.
    pub fn new(
        resource_id: ResourceId,
        job_id: JobId,
        job_type: JobType,
        error: impl Into<String>,
    ) -> Self {
        Self {
            _user_id: None,
            resource_id,
            job_id,
            job_type,
            attempt: None,
            annotation_id: None,
            error: error.into(),
            completed_units: None,
            unit_cursors: None,
            failure_class: None,
            will_retry: None,
            durability: None,
        }
    }
}

schema!(JobFailCommand);

/// A job that failed and will not be retried.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct JobFailed {
    pub status: JobFailedStatus,
    pub metadata: JobMetadata,
    pub params: JobParams,
    /// When the last claim was made; absent when it failed without one.
    #[serde(rename = "startedAt")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub started_at: Option<String>,
    /// When it failed.
    #[serde(rename = "completedAt")]
    pub completed_at: String,
    /// The failure's message.
    pub error: String,
    #[serde(rename = "failureClass")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub failure_class: Option<FailureClass>,
}

impl JobFailed {
    /// The `JobFailed` that states these and nothing else.
    pub fn new(
        metadata: JobMetadata,
        params: JobParams,
        completed_at: impl Into<String>,
        error: impl Into<String>,
    ) -> Self {
        Self {
            status: JobFailedStatus::Failed,
            metadata,
            params,
            started_at: None,
            completed_at: completed_at.into(),
            error: error.into(),
            failure_class: None,
        }
    }
}

schema!(JobFailed);

/// Payload for the job:failed domain event — a permanent fact of the resource, not operational state. It carries the judgments the worker COMPUTED, not just its message: at the log they are otherwise unrecoverable, the only remaining witness being a flattened English string.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobFailedPayload {
    #[serde(rename = "jobId")]
    pub job_id: JobId,
    #[serde(rename = "jobType")]
    pub job_type: JobType,
    /// Which attempt produced this event, 1-based (a first run is 1). ALWAYS present: the queue re-runs a failed job silently, so an operator reading progress or a terminal record has no other way to tell a re-run from a first run — and provider spend, already counted in xynolog_inference_tokens_total, cannot be attributed to a repeated document without it. Stated rather than inferred from absence, because 'attempt 1' is a fact the emitter always knows.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub attempt: Option<i64>,
    /// Annotation this job was attached to, when applicable
    #[serde(rename = "annotationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotation_id: Option<AnnotationId>,
    pub error: String,
    #[serde(rename = "failureClass")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub failure_class: Option<FailureClass>,
    /// Whether the worker computed that the queue would re-queue this job (same predicate the queue applies, `willRetryAfter`). Absent means the worker stated nothing. Without it a reader of the log cannot tell a run recovering across several job:failed events from that many dead jobs.
    #[serde(rename = "willRetry")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub will_retry: Option<bool>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub durability: Option<DurabilityEvidence>,
}

impl JobFailedPayload {
    /// The `JobFailedPayload` that states these and nothing else.
    pub fn new(job_id: JobId, job_type: JobType, error: impl Into<String>) -> Self {
        Self {
            job_id,
            job_type,
            attempt: None,
            annotation_id: None,
            error: error.into(),
            failure_class: None,
            will_retry: None,
            durability: None,
        }
    }
}

schema!(JobFailedPayload);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobFailedStatus {
    #[serde(rename = "failed")]
    Failed,
}

impl JobFailedStatus {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobFailedStatus::Failed => "failed",
        }
    }
}

/// Some jobs, named by fields of the job description: a partial description, at the description's own paths. A job matches when every field stated here equals the job's. A `mark` filter always states its motivation.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Serialize)]
#[serde(untagged)]
pub enum JobFilter {
    MarkJobFilter(MarkJobFilter),
    YieldJobFilter(YieldJobFilter),
}

impl<'de> serde::Deserialize<'de> for JobFilter {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("jobType").and_then(serde_json::Value::as_str) {
            Some("mark") => serde_json::from_value(value).map(JobFilter::MarkJobFilter),
            Some("yield") => serde_json::from_value(value).map(JobFilter::YieldJobFilter),
            _ => {
                return Err(serde::de::Error::custom(
                    "a JobFilter states a `jobType` that is one of `mark`, `yield`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

member!(JobFilter::MarkJobFilter(MarkJobFilter));
member!(JobFilter::YieldJobFilter(YieldJobFilter));
schema!(JobFilter);

/// A job's id. 1 to 128 of the letters `A`–`Z` and `a`–`z`, the digits, `_` and `-`. It is one segment of a URL and one name in a file system, and it is held to that wherever it enters: a gateway refuses a payload that carries anything else. How one is made is no part of the rule.
#[derive(
    Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
#[serde(try_from = "String", into = "String")]
pub struct JobId(String);

impl JobId {
    /// The rule a value is held to, as the spec writes it.
    pub const PATTERN: &'static str = "^[A-Za-z0-9_-]{1,128}$";

    /// The pattern as the rule `new` holds a value to.
    const RULE: Rule = Rule {
        prefix: "",
        admitted: Admitted::Of(&[('A', 'Z'), ('a', 'z'), ('0', '9'), ('_', '_'), ('-', '-')]),
        least: 1,
        most: Some(128),
    };

    /// `value` as a `JobId`, or that it is not one.
    pub fn new(value: impl Into<String>) -> Result<JobId, InvalidIdentifier> {
        let value = value.into();
        if JobId::RULE.admits(&value) {
            Ok(JobId(value))
        } else {
            Err(InvalidIdentifier {
                kind: "JobId",
                pattern: JobId::PATTERN,
                value,
            })
        }
    }

    pub fn as_str(&self) -> &str {
        &self.0
    }
}

impl std::fmt::Display for JobId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(&self.0)
    }
}

impl std::ops::Deref for JobId {
    type Target = str;

    fn deref(&self) -> &str {
        &self.0
    }
}

impl AsRef<str> for JobId {
    fn as_ref(&self) -> &str {
        &self.0
    }
}

impl std::str::FromStr for JobId {
    type Err = InvalidIdentifier;

    fn from_str(value: &str) -> Result<JobId, InvalidIdentifier> {
        JobId::new(value)
    }
}

impl TryFrom<String> for JobId {
    type Error = InvalidIdentifier;

    fn try_from(value: String) -> Result<JobId, InvalidIdentifier> {
        JobId::new(value)
    }
}

impl From<JobId> for String {
    fn from(id: JobId) -> String {
        id.0
    }
}

impl PartialEq<str> for JobId {
    fn eq(&self, other: &str) -> bool {
        self.0 == other
    }
}

impl PartialEq<&str> for JobId {
    fn eq(&self, other: &&str) -> bool {
        self.0 == *other
    }
}

schema!(JobId);

/// What the dispatcher records about a job beside its parameters. `completedUnits` and `unitCursors` appear once a worker has checkpointed. `retryCount` counts the times the queue has put the job back to pending after a failure it classes as transient.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct JobMetadata {
    /// The job's id: `job-` followed by a version 4 UUID written as 32 lowercase hex digits, without dashes.
    pub id: JobId,
    pub r#type: JobType,
    /// The DID of the principal whose `job:create` created the job.
    #[serde(rename = "userId")]
    pub user_id: UserId,
    /// When the job was created, as an ISO 8601 timestamp.
    pub created: String,
    #[serde(rename = "retryCount")]
    pub retry_count: u64,
    /// How many transient failures the queue retries: 0 for generation, whose re-run produces different content; 1 for every other type.
    #[serde(rename = "maxRetries")]
    pub max_retries: u64,
    /// The units a worker has finished, merged across checkpoints and failures as a set.
    #[serde(rename = "completedUnits")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub completed_units: Option<Vec<String>>,
    /// The furthest each unit begun got, keyed by unit, with what it had counted there. A finished unit keeps its cursor: where it ended, and its final counts.
    #[serde(rename = "unitCursors")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub unit_cursors: Option<std::collections::BTreeMap<String, UnitCursor>>,
}

impl JobMetadata {
    /// The `JobMetadata` that states these and nothing else.
    pub fn new(
        id: JobId,
        r#type: JobType,
        user_id: UserId,
        created: impl Into<String>,
        retry_count: u64,
        max_retries: u64,
    ) -> Self {
        Self {
            id,
            r#type,
            user_id,
            created: created.into(),
            retry_count,
            max_retries,
            completed_units: None,
            unit_cursors: None,
        }
    }
}

schema!(JobMetadata);

/// A job's parameters as the Dispatcher holds them: the `params` of its `job:create`, and what the Dispatcher adds. It adds `resourceId`, the resource the job is about: a `mark` job's own, and for a `yield` job the one its context focuses on. For a tagging job it adds `schema`, the tag schema its `schemaId` names, so that whoever holds the job needs no registry. Nothing the caller sent is changed or removed.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobParams {
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// The tag schema a tagging job's `schemaId` names, as the knowledge base registered it when the job was created. On a tagging job, and on no other.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub schema: Option<TagSchema>,
    /// Every property the schema does not name, as it came.
    #[serde(flatten)]
    pub rest: serde_json::Map<String, serde_json::Value>,
}

impl JobParams {
    /// The `JobParams` that states these and nothing else.
    pub fn new(resource_id: ResourceId) -> Self {
        Self {
            resource_id,
            schema: None,
            rest: serde_json::Map::new(),
        }
    }
}

schema!(JobParams);

/// A job waiting for a worker to claim it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct JobPending {
    pub status: JobPendingStatus,
    pub metadata: JobMetadata,
    pub params: JobParams,
}

impl JobPending {
    /// The `JobPending` that states these and nothing else.
    pub fn new(metadata: JobMetadata, params: JobParams) -> Self {
        Self {
            status: JobPendingStatus::Pending,
            metadata,
            params,
        }
    }
}

schema!(JobPending);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobPendingStatus {
    #[serde(rename = "pending")]
    Pending,
}

impl JobPendingStatus {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobPendingStatus::Pending => "pending",
        }
    }
}

/// How a job's `pollUntilComplete` asks for the job's status: how long it waits between its asks, and how long it goes on asking. A member left out is client/timing.json's: `jobPollMs` and `jobPollTimeoutMs`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct JobPollOptions {
    /// How long it waits between one ask and the next, in milliseconds.
    #[serde(rename = "everyMs")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub every_ms: Option<u64>,
    /// How long it goes on asking, from its first ask, before it fails as timed out, in milliseconds.
    #[serde(rename = "withinMs")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub within_ms: Option<u64>,
}

schema!(JobPollOptions);

/// Progress report from a running job. The required field is `percentage`; `message` carries the coded phase and the rest are optional job-shape fields. This is the single progress shape for every job type — annotation workers and generation alike. Terminality is signalled on `job:complete` / `job:fail`, not here. A flow that iterates a user-chosen list (entity types for references, categories for tags) reports its position as one `current`/`processed`/`total` triple, the same shape for both, so a client never needs to know which flow it is drawing.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct JobProgress {
    /// Completion percentage (0-100)
    pub percentage: f64,
    /// What the job is doing right now, as a code plus typed params; the client renders the sentence. Optional: pure percentage heartbeats carry none, and consumers render nothing message-shaped when it is absent.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub message: Option<JobProgressMessage>,
    /// Annotation this job is attached to, when applicable. Echoed inside JobProgress (in addition to the outer command envelope) so consumers that only see the inner progress object (e.g. what `yield.delegate` returns) can still route visual feedback to a specific annotation.
    #[serde(rename = "annotationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotation_id: Option<AnnotationId>,
    /// What the run is working on right now. `kind` is a CODE the client renders a localized name for; `value` is KB data (an entity type, a tag category) shown verbatim — the same split as `requestParams`. Absent on flows that iterate nothing, such as generation.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub current: Option<JobProgressCurrent>,
    /// Items completed so far, zero-based — the item in `current` is the one after these. Paired with `total`.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub processed: Option<i64>,
    /// Items this run will process in all.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub total: Option<i64>,
    /// Entities found so far (a linking job)
    #[serde(rename = "entitiesFound")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entities_found: Option<i64>,
    /// Cumulative mentions the count-verifier priced across the pieces accepted so far — the denominator for a real progress bar (found of ~expected). Approximate by nature (the count saturates on very large pieces) and monotonically growing within a run. ABSENT when the provider does not verify detection yield, or before any piece has been priced: no claim, never zero.
    #[serde(rename = "entitiesExpected")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entities_expected: Option<i64>,
    /// Annotations emitted so far (a linking job)
    #[serde(rename = "entitiesEmitted")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entities_emitted: Option<i64>,
    /// Per-item results for the items already finished, for the UI's completed log. Generic across flows for the same reason `current` is.
    #[serde(rename = "completedItems")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub completed_items: Option<Vec<JobProgressCompletedItemsItem>>,
    /// Echoed job parameters for display in the progress UI. `label` is a CODE, not a sentence — the client owns the wording, same rule as the progress message. `value` is the user's own input (an entity-type list, their instructions) and is deliberately NOT translated: it is their words, not ours.
    #[serde(rename = "requestParams")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub request_params: Option<Vec<JobProgressRequestParamsItem>>,
}

impl JobProgress {
    /// The `JobProgress` that states these and nothing else.
    pub fn new(percentage: f64) -> Self {
        Self {
            percentage,
            message: None,
            annotation_id: None,
            current: None,
            processed: None,
            total: None,
            entities_found: None,
            entities_expected: None,
            entities_emitted: None,
            completed_items: None,
            request_params: None,
        }
    }
}

schema!(JobProgress);

/// Analyzing the content.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobProgressAnalyzing {
    pub code: JobProgressAnalyzingCode,
}

impl Default for JobProgressAnalyzing {
    fn default() -> Self {
        Self::new()
    }
}

impl JobProgressAnalyzing {
    /// The `JobProgressAnalyzing` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            code: JobProgressAnalyzingCode::Analyzing,
        }
    }
}

schema!(JobProgressAnalyzing);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobProgressAnalyzingCode {
    #[serde(rename = "analyzing")]
    Analyzing,
}

impl JobProgressAnalyzingCode {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobProgressAnalyzingCode::Analyzing => "analyzing",
        }
    }
}

/// Analyzing the content against the tag schema.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobProgressAnalyzingTags {
    pub code: JobProgressAnalyzingTagsCode,
}

impl Default for JobProgressAnalyzingTags {
    fn default() -> Self {
        Self::new()
    }
}

impl JobProgressAnalyzingTags {
    /// The `JobProgressAnalyzingTags` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            code: JobProgressAnalyzingTagsCode::AnalyzingTags,
        }
    }
}

schema!(JobProgressAnalyzingTags);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobProgressAnalyzingTagsCode {
    #[serde(rename = "analyzing-tags")]
    AnalyzingTags,
}

impl JobProgressAnalyzingTagsCode {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobProgressAnalyzingTagsCode::AnalyzingTags => "analyzing-tags",
        }
    }
}

/// Terminal success summary.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobProgressCompleteCreated {
    pub code: JobProgressCompleteCreatedCode,
    /// How many annotations were created
    pub count: i64,
    /// The motivation of the job, and so of what it created. A client words it in its own language.
    pub motivation: Motivation,
}

impl JobProgressCompleteCreated {
    /// The `JobProgressCompleteCreated` that states these and nothing else.
    pub fn new(count: i64, motivation: Motivation) -> Self {
        Self {
            code: JobProgressCompleteCreatedCode::CompleteCreated,
            count,
            motivation,
        }
    }
}

schema!(JobProgressCompleteCreated);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobProgressCompleteCreatedCode {
    #[serde(rename = "complete-created")]
    CompleteCreated,
}

impl JobProgressCompleteCreatedCode {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobProgressCompleteCreatedCode::CompleteCreated => "complete-created",
        }
    }
}

/// Generation's terminal success. Deliberately generic — the client already holds the title it typed, and the outcome (name + resource link) travels on job:complete, not on progress. `truncated` qualifies the completion: the same bit `YieldJobDone.truncated` carries, so the two surfaces cannot drift.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobProgressCompleteGenerated {
    pub code: JobProgressCompleteGeneratedCode,
    /// True when the model stopped at the maxTokens ceiling — the artifact is cut off, not complete.
    pub truncated: bool,
}

impl JobProgressCompleteGenerated {
    /// The `JobProgressCompleteGenerated` that states these and nothing else.
    pub fn new(truncated: bool) -> Self {
        Self {
            code: JobProgressCompleteGeneratedCode::CompleteGenerated,
            truncated,
        }
    }
}

schema!(JobProgressCompleteGenerated);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobProgressCompleteGeneratedCode {
    #[serde(rename = "complete-generated")]
    CompleteGenerated,
}

impl JobProgressCompleteGeneratedCode {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobProgressCompleteGeneratedCode::CompleteGenerated => "complete-generated",
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobProgressCompletedItemsItem {
    /// The item, shown verbatim.
    pub value: String,
    /// Annotations found for it.
    #[serde(rename = "foundCount")]
    pub found_count: i64,
    /// Annotations actually persisted for it — post-dedupe and post-durability-acknowledgement, so it counts what the event log holds, not what the model proposed. Beside foundCount this is the per-unit yield the sizing work is judged by. Present on flows whose units persist as they complete (a linking job); the tagging flow reports the same fact as byCategory on its result, because its annotations are built after the per-category loop.
    #[serde(rename = "persistedCount")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub persisted_count: Option<i64>,
    /// Present only when pieces of this unit were accepted at the subdivision floor while a count call said more was present. The unit completed, but incompletely — this carries the EVIDENCE (found vs counted, over how many pieces), never a judgment against any expected yield. Absent means complete: genuinely absent, not defaulted.
    #[serde(rename = "underReported")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub under_reported: Option<JobProgressCompletedItemsItemUnderReported>,
}

impl JobProgressCompletedItemsItem {
    /// The `JobProgressCompletedItemsItem` that states these and nothing else.
    pub fn new(value: impl Into<String>, found_count: i64) -> Self {
        Self {
            value: value.into(),
            found_count,
            persisted_count: None,
            under_reported: None,
        }
    }
}

/// Present only when pieces of this unit were accepted at the subdivision floor while a count call said more was present. The unit completed, but incompletely — this carries the EVIDENCE (found vs counted, over how many pieces), never a judgment against any expected yield. Absent means complete: genuinely absent, not defaulted.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobProgressCompletedItemsItemUnderReported {
    /// Floor-accepted pieces in this unit.
    pub pieces: i64,
    /// Annotations extraction did find on those pieces — every span write-time-verified.
    pub found: i64,
    /// Mentions the count calls reported across those pieces (approximate by nature).
    pub counted: i64,
}

/// Writing detected annotations back to the resource.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobProgressCreatingAnnotations {
    pub code: JobProgressCreatingAnnotationsCode,
    /// How many annotations are being created
    pub count: i64,
}

impl JobProgressCreatingAnnotations {
    /// The `JobProgressCreatingAnnotations` that states these and nothing else.
    pub fn new(count: i64) -> Self {
        Self {
            code: JobProgressCreatingAnnotationsCode::CreatingAnnotations,
            count,
        }
    }
}

schema!(JobProgressCreatingAnnotations);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobProgressCreatingAnnotationsCode {
    #[serde(rename = "creating-annotations")]
    CreatingAnnotations,
}

impl JobProgressCreatingAnnotationsCode {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobProgressCreatingAnnotationsCode::CreatingAnnotations => "creating-annotations",
        }
    }
}

/// Writing the generated resource.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobProgressCreatingResource {
    pub code: JobProgressCreatingResourceCode,
}

impl Default for JobProgressCreatingResource {
    fn default() -> Self {
        Self::new()
    }
}

impl JobProgressCreatingResource {
    /// The `JobProgressCreatingResource` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            code: JobProgressCreatingResourceCode::CreatingResource,
        }
    }
}

schema!(JobProgressCreatingResource);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobProgressCreatingResourceCode {
    #[serde(rename = "creating-resource")]
    CreatingResource,
}

impl JobProgressCreatingResourceCode {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobProgressCreatingResourceCode::CreatingResource => "creating-resource",
        }
    }
}

/// Writing detected tag annotations back to the resource.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobProgressCreatingTagAnnotations {
    pub code: JobProgressCreatingTagAnnotationsCode,
    /// How many annotations are being created
    pub count: i64,
}

impl JobProgressCreatingTagAnnotations {
    /// The `JobProgressCreatingTagAnnotations` that states these and nothing else.
    pub fn new(count: i64) -> Self {
        Self {
            code: JobProgressCreatingTagAnnotationsCode::CreatingTagAnnotations,
            count,
        }
    }
}

schema!(JobProgressCreatingTagAnnotations);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobProgressCreatingTagAnnotationsCode {
    #[serde(rename = "creating-tag-annotations")]
    CreatingTagAnnotations,
}

impl JobProgressCreatingTagAnnotationsCode {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobProgressCreatingTagAnnotationsCode::CreatingTagAnnotations => {
                "creating-tag-annotations"
            }
        }
    }
}

/// What the run is working on right now. `kind` is a CODE the client renders a localized name for; `value` is KB data (an entity type, a tag category) shown verbatim — the same split as `requestParams`. Absent on flows that iterate nothing, such as generation.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobProgressCurrent {
    /// What sort of thing `value` is. Adding a variant means adding client copy for it in every locale.
    pub kind: JobProgressCurrentKind,
    /// The item itself, shown verbatim and never translated.
    pub value: String,
}

/// What sort of thing `value` is. Adding a variant means adding client copy for it in every locale.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobProgressCurrentKind {
    #[serde(rename = "entity-type")]
    EntityType,
    #[serde(rename = "category")]
    Category,
}

impl JobProgressCurrentKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobProgressCurrentKind::EntityType => "entity-type",
            JobProgressCurrentKind::Category => "category",
        }
    }
}

/// Entity detection, one entity type at a time.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobProgressDetectingEntities {
    pub code: JobProgressDetectingEntitiesCode,
    /// Entity type currently being detected
    #[serde(rename = "entityType")]
    pub entity_type: String,
}

impl JobProgressDetectingEntities {
    /// The `JobProgressDetectingEntities` that states these and nothing else.
    pub fn new(entity_type: impl Into<String>) -> Self {
        Self {
            code: JobProgressDetectingEntitiesCode::DetectingEntities,
            entity_type: entity_type.into(),
        }
    }
}

schema!(JobProgressDetectingEntities);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobProgressDetectingEntitiesCode {
    #[serde(rename = "detecting-entities")]
    DetectingEntities,
}

impl JobProgressDetectingEntitiesCode {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobProgressDetectingEntitiesCode::DetectingEntities => "detecting-entities",
        }
    }
}

/// The model is generating the resource.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobProgressGeneratingResource {
    pub code: JobProgressGeneratingResourceCode,
}

impl Default for JobProgressGeneratingResource {
    fn default() -> Self {
        Self::new()
    }
}

impl JobProgressGeneratingResource {
    /// The `JobProgressGeneratingResource` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            code: JobProgressGeneratingResourceCode::GeneratingResource,
        }
    }
}

schema!(JobProgressGeneratingResource);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobProgressGeneratingResourceCode {
    #[serde(rename = "generating-resource")]
    GeneratingResource,
}

impl JobProgressGeneratingResourceCode {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobProgressGeneratingResourceCode::GeneratingResource => "generating-resource",
        }
    }
}

/// Loading the resource content.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobProgressLoading {
    pub code: JobProgressLoadingCode,
}

impl Default for JobProgressLoading {
    fn default() -> Self {
        Self::new()
    }
}

impl JobProgressLoading {
    /// The `JobProgressLoading` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            code: JobProgressLoadingCode::Loading,
        }
    }
}

schema!(JobProgressLoading);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobProgressLoadingCode {
    #[serde(rename = "loading")]
    Loading,
}

impl JobProgressLoadingCode {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobProgressLoadingCode::Loading => "loading",
        }
    }
}

/// What a running job is doing right now, as a code plus typed params — never a prose sentence. The producer reports what happened; each client renders it in the user's language (react-ui from its translations, the Go launcher from its English map). One named schema per code, discriminated on `code`, so generated clients get typed variants and copy-map completeness is statically checkable. The vocabulary is every report Xynolog's worker makes (contract/WORKER-SERVICE.md, D16 to D19 and Y8); extending it means adding a named variant here and copy in every client, gated by the locale-completeness check.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Serialize)]
#[serde(untagged)]
pub enum JobProgressMessage {
    Loading(JobProgressLoading),
    Analyzing(JobProgressAnalyzing),
    AnalyzingTags(JobProgressAnalyzingTags),
    GeneratingResource(JobProgressGeneratingResource),
    CreatingResource(JobProgressCreatingResource),
    CompleteGenerated(JobProgressCompleteGenerated),
    DetectingEntities(JobProgressDetectingEntities),
    CreatingAnnotations(JobProgressCreatingAnnotations),
    CreatingTagAnnotations(JobProgressCreatingTagAnnotations),
    CompleteCreated(JobProgressCompleteCreated),
}

impl<'de> serde::Deserialize<'de> for JobProgressMessage {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("code").and_then(serde_json::Value::as_str) {
            Some("loading") => serde_json::from_value(value).map(JobProgressMessage::Loading),
            Some("analyzing") => serde_json::from_value(value).map(JobProgressMessage::Analyzing),
            Some("analyzing-tags") => {
                serde_json::from_value(value).map(JobProgressMessage::AnalyzingTags)
            }
            Some("generating-resource") => {
                serde_json::from_value(value).map(JobProgressMessage::GeneratingResource)
            }
            Some("creating-resource") => {
                serde_json::from_value(value).map(JobProgressMessage::CreatingResource)
            }
            Some("complete-generated") => {
                serde_json::from_value(value).map(JobProgressMessage::CompleteGenerated)
            }
            Some("detecting-entities") => {
                serde_json::from_value(value).map(JobProgressMessage::DetectingEntities)
            }
            Some("creating-annotations") => {
                serde_json::from_value(value).map(JobProgressMessage::CreatingAnnotations)
            }
            Some("creating-tag-annotations") => {
                serde_json::from_value(value).map(JobProgressMessage::CreatingTagAnnotations)
            }
            Some("complete-created") => {
                serde_json::from_value(value).map(JobProgressMessage::CompleteCreated)
            }
            _ => {
                return Err(serde::de::Error::custom(
                    "a JobProgressMessage states a `code` that is one of `loading`, `analyzing`, `analyzing-tags`, `generating-resource`, `creating-resource`, `complete-generated`, `detecting-entities`, `creating-annotations`, `creating-tag-annotations`, `complete-created`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

member!(JobProgressMessage::Loading(JobProgressLoading));
member!(JobProgressMessage::Analyzing(JobProgressAnalyzing));
member!(JobProgressMessage::AnalyzingTags(JobProgressAnalyzingTags));
member!(JobProgressMessage::GeneratingResource(
    JobProgressGeneratingResource,
));
member!(JobProgressMessage::CreatingResource(
    JobProgressCreatingResource,
));
member!(JobProgressMessage::CompleteGenerated(
    JobProgressCompleteGenerated,
));
member!(JobProgressMessage::DetectingEntities(
    JobProgressDetectingEntities,
));
member!(JobProgressMessage::CreatingAnnotations(
    JobProgressCreatingAnnotations,
));
member!(JobProgressMessage::CreatingTagAnnotations(
    JobProgressCreatingTagAnnotations,
));
member!(JobProgressMessage::CompleteCreated(
    JobProgressCompleteCreated,
));
schema!(JobProgressMessage);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobProgressRequestParamsItem {
    /// Which parameter this is. The client renders a localized name for it.
    pub label: JobProgressRequestParamsItemLabel,
    /// The user's own input, shown verbatim.
    pub value: String,
}

/// Which parameter this is. The client renders a localized name for it.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobProgressRequestParamsItemLabel {
    #[serde(rename = "entity-types")]
    EntityTypes,
    #[serde(rename = "instructions")]
    Instructions,
    #[serde(rename = "tone")]
    Tone,
    #[serde(rename = "density")]
    Density,
}

impl JobProgressRequestParamsItemLabel {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobProgressRequestParamsItemLabel::EntityTypes => "entity-types",
            JobProgressRequestParamsItemLabel::Instructions => "instructions",
            JobProgressRequestParamsItemLabel::Tone => "tone",
            JobProgressRequestParamsItemLabel::Density => "density",
        }
    }
}

/// A pending job, announced when it is created and again at each tick while it waits. It carries the job description less the job's input, so that a party deciding whether to claim reads here what its claim would be matched against. It is a wake-up and not an offer of this job: a claim is answered with the next pending job it matches.
#[derive(Debug, Clone, PartialEq, serde::Serialize)]
#[serde(untagged)]
pub enum JobQueuedEvent {
    MarkJobQueuedEvent(MarkJobQueuedEvent),
    YieldJobQueuedEvent(YieldJobQueuedEvent),
}

impl<'de> serde::Deserialize<'de> for JobQueuedEvent {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("jobType").and_then(serde_json::Value::as_str) {
            Some("mark") => serde_json::from_value(value).map(JobQueuedEvent::MarkJobQueuedEvent),
            Some("yield") => serde_json::from_value(value).map(JobQueuedEvent::YieldJobQueuedEvent),
            _ => {
                return Err(serde::de::Error::custom(
                    "a JobQueuedEvent states a `jobType` that is one of `mark`, `yield`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

member!(JobQueuedEvent::MarkJobQueuedEvent(MarkJobQueuedEvent));
member!(JobQueuedEvent::YieldJobQueuedEvent(YieldJobQueuedEvent));
schema!(JobQueuedEvent);

/// One job as the queue stores it: the job, and when it last showed life. The dead-worker sweep reads `lastProgressAt`: a running job whose worker has reported nothing for the configured interval is presumed dead. Where the queue keeps these records is the job storage layout, specs/src/jobs/storage.json.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct JobRecord {
    pub job: Job,
    /// When the job was created, claimed, checkpointed or last reported progress, as an ISO 8601 timestamp.
    #[serde(rename = "lastProgressAt")]
    pub last_progress_at: String,
}

schema!(JobRecord);

/// Command to report progress on a job
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct JobReportProgressCommand {
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    #[serde(rename = "jobId")]
    pub job_id: JobId,
    #[serde(rename = "jobType")]
    pub job_type: JobType,
    /// Which attempt produced this event, 1-based (a first run is 1). ALWAYS present: the queue re-runs a failed job silently, so an operator reading progress or a terminal record has no other way to tell a re-run from a first run — and provider spend, already counted in xynolog_inference_tokens_total, cannot be attributed to a repeated document without it. Stated rather than inferred from absence, because 'attempt 1' is a fact the emitter always knows.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub attempt: Option<i64>,
    /// Annotation this job is attached to, when applicable. Lets the UI attach progress visuals to a specific annotation (e.g. a reference whose generation is running).
    #[serde(rename = "annotationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotation_id: Option<AnnotationId>,
    pub percentage: f64,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub progress: Option<JobProgress>,
}

impl JobReportProgressCommand {
    /// The `JobReportProgressCommand` that states these and nothing else.
    pub fn new(resource_id: ResourceId, job_id: JobId, job_type: JobType, percentage: f64) -> Self {
        Self {
            _user_id: None,
            resource_id,
            job_id,
            job_type,
            attempt: None,
            annotation_id: None,
            percentage,
            progress: None,
        }
    }
}

schema!(JobReportProgressCommand);

/// What a job reports when it concludes without failing: a `mark` job's counts, the resource a `yield` job made, or a decline from either. A result has no discriminant of its own: the job description beside it says which job it answers, and the three share no member, so each is told from the others by what it alone carries.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum JobResult {
    MarkJobDone(MarkJobDone),
    YieldJobDone(YieldJobDone),
    JobDeclined(JobDeclined),
}

member!(JobResult::MarkJobDone(MarkJobDone));
member!(JobResult::YieldJobDone(YieldJobDone));
member!(JobResult::JobDeclined(JobDeclined));
schema!(JobResult);

/// A job a worker has claimed and not yet concluded.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct JobRunning {
    pub status: JobRunningStatus,
    pub metadata: JobMetadata,
    pub params: JobParams,
    /// When the claim that holds it was made, as an ISO 8601 timestamp.
    #[serde(rename = "startedAt")]
    pub started_at: String,
    pub progress: JobStoredProgress,
}

impl JobRunning {
    /// The `JobRunning` that states these and nothing else.
    pub fn new(
        metadata: JobMetadata,
        params: JobParams,
        started_at: impl Into<String>,
        progress: JobStoredProgress,
    ) -> Self {
        Self {
            status: JobRunningStatus::Running,
            metadata,
            params,
            started_at: started_at.into(),
            progress,
        }
    }
}

schema!(JobRunning);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobRunningStatus {
    #[serde(rename = "running")]
    Running,
}

impl JobRunningStatus {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobRunningStatus::Running => "running",
        }
    }
}

/// Command to start a job
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobStartCommand {
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    #[serde(rename = "jobId")]
    pub job_id: JobId,
    #[serde(rename = "jobType")]
    pub job_type: JobType,
    /// Annotation this job is attached to, when applicable. Set for annotation-scoped jobs like generation (from a specific reference). Unset for resource-scoped jobs like bulk reference/tag/highlight detection.
    #[serde(rename = "annotationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotation_id: Option<AnnotationId>,
    /// Which attempt produced this event, 1-based (a first run is 1). ALWAYS present: the queue re-runs a failed job silently, so an operator reading progress or a terminal record has no other way to tell a re-run from a first run — and provider spend, already counted in xynolog_inference_tokens_total, cannot be attributed to a repeated document without it. Stated rather than inferred from absence, because 'attempt 1' is a fact the emitter always knows.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub attempt: Option<i64>,
}

impl JobStartCommand {
    /// The `JobStartCommand` that states these and nothing else.
    pub fn new(resource_id: ResourceId, job_id: JobId, job_type: JobType) -> Self {
        Self {
            _user_id: None,
            resource_id,
            job_id,
            job_type,
            annotation_id: None,
            attempt: None,
        }
    }
}

schema!(JobStartCommand);

/// Payload for job:started domain event
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobStartedPayload {
    #[serde(rename = "jobId")]
    pub job_id: JobId,
    #[serde(rename = "jobType")]
    pub job_type: JobType,
    /// Annotation this job is attached to, when applicable
    #[serde(rename = "annotationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotation_id: Option<AnnotationId>,
    #[serde(rename = "totalSteps")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub total_steps: Option<i64>,
}

impl JobStartedPayload {
    /// The `JobStartedPayload` that states these and nothing else.
    pub fn new(job_id: JobId, job_type: JobType) -> Self {
        Self {
            job_id,
            job_type,
            annotation_id: None,
            total_steps: None,
        }
    }
}

schema!(JobStartedPayload);

/// Request to check the status of a job
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct JobStatusRequest {
    #[serde(rename = "jobId")]
    pub job_id: JobId,
}

schema!(JobStatusRequest);

#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct JobStatusResponse {
    #[serde(rename = "jobId")]
    pub job_id: JobId,
    pub r#type: JobType,
    pub status: JobStatusResponseStatus,
    #[serde(rename = "userId")]
    pub user_id: UserId,
    pub created: String,
    #[serde(rename = "startedAt")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub started_at: Option<String>,
    #[serde(rename = "completedAt")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub completed_at: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub error: Option<String>,
    #[serde(rename = "failureClass")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub failure_class: Option<FailureClass>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub progress: Option<JobStoredProgress>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub result: Option<JobStoredResult>,
}

impl JobStatusResponse {
    /// The `JobStatusResponse` that states these and nothing else.
    pub fn new(
        job_id: JobId,
        r#type: JobType,
        status: JobStatusResponseStatus,
        user_id: UserId,
        created: impl Into<String>,
    ) -> Self {
        Self {
            job_id,
            r#type,
            status,
            user_id,
            created: created.into(),
            started_at: None,
            completed_at: None,
            error: None,
            failure_class: None,
            progress: None,
            result: None,
        }
    }
}

schema!(JobStatusResponse);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobStatusResponseStatus {
    #[serde(rename = "pending")]
    Pending,
    #[serde(rename = "running")]
    Running,
    #[serde(rename = "complete")]
    Complete,
    #[serde(rename = "failed")]
    Failed,
    #[serde(rename = "cancelled")]
    Cancelled,
}

impl JobStatusResponseStatus {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobStatusResponseStatus::Pending => "pending",
            JobStatusResponseStatus::Running => "running",
            JobStatusResponseStatus::Complete => "complete",
            JobStatusResponseStatus::Failed => "failed",
            JobStatusResponseStatus::Cancelled => "cancelled",
        }
    }
}

/// Result of a job status request
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct JobStatusResult {
    pub response: JobStatusResponse,
}

schema!(JobStatusResult);

/// A running job's progress as the dispatcher stores it: the last JobProgress its worker reported with `job:report-progress`, or an empty object before the first report.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum JobStoredProgress {
    JobProgress(JobProgress),
    Empty(EmptyObject),
}

member!(JobStoredProgress::JobProgress(JobProgress));
schema!(JobStoredProgress);

/// A completed job's result as the dispatcher stores it: the result its worker reported with `job:complete`, or an empty object when it reported none.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum JobStoredResult {
    JobResult(JobResult),
    Empty(EmptyObject),
}

member!(JobStoredResult::JobResult(JobResult));
schema!(JobStoredResult);

/// What a job does, as the verb that asks for it: `mark` annotates a resource, `yield` makes one. A job description is its `jobType` and the parameters that verb takes; a `mark` job's parameters state its motivation.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum JobType {
    #[serde(rename = "mark")]
    Mark,
    #[serde(rename = "yield")]
    Yield,
}

impl JobType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            JobType::Mark => "mark",
            JobType::Yield => "yield",
        }
    }
}

schema!(JobType);

/// jobs/budgets.json: the retry budget of each job type.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct JobsBudgets {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    /// One row for each job type.
    pub budgets: Vec<JobsBudgetsBudgetsItem>,
}

schema!(JobsBudgets);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct JobsBudgetsBudgetsItem {
    #[serde(rename = "jobType")]
    pub job_type: JobType,
    /// How many times a failed attempt of a job of this type may be retried: its record's `metadata.maxRetries`.
    #[serde(rename = "maxRetries")]
    pub max_retries: u64,
}

/// jobs/storage.json: where the job queue keeps its state on the broker.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct JobsStorage {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    /// The work-queue stream every job is published into.
    pub stream: JobsStorageStream,
    /// The durable consumer that delivers each job to the dispatcher holding its lease.
    pub consumer: JobsStorageConsumer,
    /// The KV bucket that keeps one record per job, keyed by the job's id.
    pub bucket: JobsStorageBucket,
}

schema!(JobsStorage);

/// The KV bucket that keeps one record per job, keyed by the job's id.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct JobsStorageBucket {
    pub name: String,
    /// The component schema each of the bucket's values is.
    pub record: String,
}

/// The durable consumer that delivers each job to the dispatcher holding its lease.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct JobsStorageConsumer {
    #[serde(rename = "durableName")]
    pub durable_name: String,
}

/// The work-queue stream every job is published into.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct JobsStorageStream {
    pub name: String,
    /// The root of the subjects the stream captures: a job is published on `<subjectRoot>.<jobType>`.
    #[serde(rename = "subjectRoot")]
    pub subject_root: String,
}

/// What a knowledge base says about itself, answered by the Archivist from the committed .xynolog/config.yaml and the working tree it holds. The only source clients use for a knowledge base's name and domain.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct KbDescription {
    /// The committed project.name, or the knowledge base directory's name when it commits no .xynolog/config.yaml.
    pub name: String,
    /// The committed site.domain: the knowledge base's permanent identity. Its did is 'did:web:' + this domain (kbDid in @xynolog/core). It names WHICH knowledge base this is, not which running copy: a local clone and a codespace of one repo report the same domain, so use it to verify what you connected to, never to select among copies. A knowledge base that commits no .xynolog/config.yaml declares none, and is refused with browse:kb-failed.
    pub domain: String,
    /// The working tree's current git branch. Absent when the knowledge base does not sync git (`git.sync` in its committed .xynolog/config.yaml), and when its tree is not a git checkout.
    #[serde(rename = "gitBranch")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub git_branch: Option<String>,
}

impl KbDescription {
    /// The `KbDescription` that states these and nothing else.
    pub fn new(name: impl Into<String>, domain: impl Into<String>) -> Self {
        Self {
            name: name.into(),
            domain: domain.into(),
            git_branch: None,
        }
    }
}

schema!(KbDescription);

/// A knowledge base's DID: `did:web:` and its domain. No API states one as such, so it is no component.
pub type KbDid = String;

/// How a knowledge base is reached: a gateway over HTTP, or a knowledge base the host process has loaded. Told apart by `kind`. Only what builds a transport, or signs in at an issuer, reads it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Serialize)]
#[serde(untagged)]
pub enum KbEndpoint {
    HttpEndpoint(HttpEndpoint),
    LocalEndpoint(LocalEndpoint),
}

impl<'de> serde::Deserialize<'de> for KbEndpoint {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("kind").and_then(serde_json::Value::as_str) {
            Some("http") => serde_json::from_value(value).map(KbEndpoint::HttpEndpoint),
            Some("local") => serde_json::from_value(value).map(KbEndpoint::LocalEndpoint),
            _ => {
                return Err(serde::de::Error::custom(
                    "a KbEndpoint states a `kind` that is one of `http`, `local`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

member!(KbEndpoint::HttpEndpoint(HttpEndpoint));
member!(KbEndpoint::LocalEndpoint(LocalEndpoint));
schema!(KbEndpoint);

/// A knowledge base's committed identity (`project.name` and `site.domain` in its .xynolog/config.yaml), as a service's document names the knowledge base it serves. Its telemetry names it by its DID (`xynolog.kb`, specs/src/service-telemetry/telemetry.json).
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KbIdentity {
    /// Its name. The gateway publishes it as its resource metadata's `resource_name`.
    pub name: String,
    /// Its did:web domain: its permanent identity, the source of the audience its tokens must carry, and the authority its people and agents are named under.
    pub domain: String,
}

schema!(KbIdentity);

/// A different knowledge base answers at a registered address. Both dids, because neither alone says what to do: a person has to recognise which knowledge base they registered and which one answers.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KbIdentityConflict {
    /// The did the entry records.
    #[serde(rename = "expectedDid")]
    pub expected_did: String,
    /// The did the knowledge base that answered reported.
    #[serde(rename = "observedDid")]
    pub observed_did: String,
}

schema!(KbIdentityConflict);

/// When a knowledge base last described itself, and what it said beyond its name. A client shows it as current only while a session to the knowledge base is live, and as of `at` otherwise.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct KbRead {
    /// When the description arrived.
    pub at: String,
    /// The branch of the knowledge base's working tree then. Absent when the working tree was not a git checkout.
    #[serde(rename = "gitBranch")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub git_branch: Option<String>,
}

impl KbRead {
    /// The `KbRead` that states these and nothing else.
    pub fn new(at: impl Into<String>) -> Self {
        Self {
            at: at.into(),
            git_branch: None,
        }
    }
}

schema!(KbRead);

/// What reading the active knowledge base against its entry concluded.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum KbReadKind {
    #[serde(rename = "recorded")]
    Recorded,
    #[serde(rename = "conflict")]
    Conflict,
    #[serde(rename = "no-verdict")]
    NoVerdict,
}

impl KbReadKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            KbReadKind::Recorded => "recorded",
            KbReadKind::Conflict => "conflict",
            KbReadKind::NoVerdict => "no-verdict",
        }
    }
}

schema!(KbReadKind);

/// What a knowledge base said when it was asked to describe itself, read against the entry it was asked as.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Serialize)]
#[serde(untagged)]
pub enum KbReadVerdict {
    Recorded(KbReadVerdictRecorded),
    Conflict(KbReadVerdictConflict),
    NoVerdict(KbReadVerdictNoVerdict),
}

impl<'de> serde::Deserialize<'de> for KbReadVerdict {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("kind").and_then(serde_json::Value::as_str) {
            Some("recorded") => serde_json::from_value(value).map(KbReadVerdict::Recorded),
            Some("conflict") => serde_json::from_value(value).map(KbReadVerdict::Conflict),
            Some("no-verdict") => serde_json::from_value(value).map(KbReadVerdict::NoVerdict),
            _ => {
                return Err(serde::de::Error::custom(
                    "a KbReadVerdict states a `kind` that is one of `recorded`, `conflict`, `no-verdict`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

schema!(KbReadVerdict);

/// A different knowledge base answered. Its did and the name it gave itself are here and nowhere else: the entry is as it was.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KbReadVerdictConflict {
    /// What reading the active knowledge base against its entry concluded.
    pub kind: KbReadVerdictConflictKind,
    /// The did the knowledge base that answered reported.
    #[serde(rename = "observedDid")]
    pub observed_did: String,
    /// The name the knowledge base that answered gave itself.
    #[serde(rename = "observedName")]
    pub observed_name: String,
}

impl KbReadVerdictConflict {
    /// The `KbReadVerdictConflict` that states these and nothing else.
    pub fn new(observed_did: impl Into<String>, observed_name: impl Into<String>) -> Self {
        Self {
            kind: KbReadVerdictConflictKind::Conflict,
            observed_did: observed_did.into(),
            observed_name: observed_name.into(),
        }
    }
}

/// What reading the active knowledge base against its entry concluded.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum KbReadVerdictConflictKind {
    #[serde(rename = "conflict")]
    Conflict,
}

impl KbReadVerdictConflictKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            KbReadVerdictConflictKind::Conflict => "conflict",
        }
    }
}

/// It did not answer, or could not say who it is. Evidence of nothing.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KbReadVerdictNoVerdict {
    /// What reading the active knowledge base against its entry concluded.
    pub kind: KbReadVerdictNoVerdictKind,
}

impl Default for KbReadVerdictNoVerdict {
    fn default() -> Self {
        Self::new()
    }
}

impl KbReadVerdictNoVerdict {
    /// The `KbReadVerdictNoVerdict` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            kind: KbReadVerdictNoVerdictKind::NoVerdict,
        }
    }
}

/// What reading the active knowledge base against its entry concluded.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum KbReadVerdictNoVerdictKind {
    #[serde(rename = "no-verdict")]
    NoVerdict,
}

impl KbReadVerdictNoVerdictKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            KbReadVerdictNoVerdictKind::NoVerdict => "no-verdict",
        }
    }
}

/// It answered as that entry, and its name and branch are on the entry now.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KbReadVerdictRecorded {
    /// What reading the active knowledge base against its entry concluded.
    pub kind: KbReadVerdictRecordedKind,
}

impl Default for KbReadVerdictRecorded {
    fn default() -> Self {
        Self::new()
    }
}

impl KbReadVerdictRecorded {
    /// The `KbReadVerdictRecorded` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            kind: KbReadVerdictRecordedKind::Recorded,
        }
    }
}

/// What reading the active knowledge base against its entry concluded.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum KbReadVerdictRecordedKind {
    #[serde(rename = "recorded")]
    Recorded,
}

impl KbReadVerdictRecordedKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            KbReadVerdictRecordedKind::Recorded => "recorded",
        }
    }
}

/// What the credential stored for a knowledge base says, read without asking anyone: `authenticated`, a token is stored and has not expired; `expired`, a token is stored and has expired; `signed-out`, nothing is stored.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum KbSessionStatus {
    #[serde(rename = "authenticated")]
    Authenticated,
    #[serde(rename = "expired")]
    Expired,
    #[serde(rename = "signed-out")]
    SignedOut,
}

impl KbSessionStatus {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            KbSessionStatus::Authenticated => "authenticated",
            KbSessionStatus::Expired => "expired",
            KbSessionStatus::SignedOut => "signed-out",
        }
    }
}

schema!(KbSessionStatus);

/// Where to connect to a knowledge base: an endpoint, and the labels a client keeps of it. It carries no identity: which knowledge base answers at an address is known only once it has been reached with a token and asked, so a target is what every caller can build before then, and a session's whole input. A client keeps it locally; it is never sent.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct KbTarget {
    /// The key the client stores a session's credentials under. Two sessions that share one storage have two ids, or each overwrites the other's tokens. Whoever builds the target chooses it; none is made up.
    pub id: String,
    /// What a person reads the knowledge base as. Once the knowledge base has described itself, its own name.
    pub label: String,
    pub endpoint: KbEndpoint,
}

schema!(KbTarget);

/// A registered knowledge base: a target, and what registering it took, the identity the knowledge base reported of itself when it was reached (`did`) among it. What a client's list of knowledge bases holds. A did says which knowledge base, not which running copy: a clone and a codespace of one repository are one knowledge base at two addresses and report one did. So an entry is looked up by its endpoint, and its did is what an answer is verified against; nothing selects by did. Its `label` and `lastRead` are written only from an answer that carried its did.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct KnowledgeBase {
    /// The key the client stores a session's credentials under. Two sessions that share one storage have two ids, or each overwrites the other's tokens. Whoever builds the target chooses it; none is made up.
    pub id: String,
    /// What a person reads the knowledge base as. Once the knowledge base has described itself, its own name.
    pub label: String,
    pub endpoint: KbEndpoint,
    /// The did the knowledge base reported of itself.
    pub did: String,
    /// The last time the knowledge base described itself. Absent until it has, in an answer that carried this entry's did.
    #[serde(rename = "lastRead")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub last_read: Option<KbRead>,
}

impl KnowledgeBase {
    /// The `KnowledgeBase` that states these and nothing else.
    pub fn new(
        id: impl Into<String>,
        label: impl Into<String>,
        endpoint: KbEndpoint,
        did: impl Into<String>,
    ) -> Self {
        Self {
            id: id.into(),
            label: label.into(),
            endpoint,
            did: did.into(),
            last_read: None,
        }
    }
}

schema!(KnowledgeBase);

/// One knowledge base's stack as xynolog status reads it: what it is, where it runs, and each of its own services. The services every knowledge base shares are reported once, in the snapshot's shared list.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KnowledgeBaseStatus {
    /// What the snapshot calls the knowledge base: the last segment of its DID, or the whole DID where two would share one, or its key.
    pub name: String,
    /// The knowledge base's key on this machine, which names its containers and its state.
    pub key: String,
    /// Whether a stack of it is recorded. When none is, its services are found by name.
    pub recorded: bool,
    /// Where the stack actually runs. "local": containers on this machine. "codespace": a GitHub-hosted VM whose KB is port-forwarded here.
    pub placement: KnowledgeBaseStatusPlacement,
    /// Its clone, for a local stack.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub root: Option<String>,
    /// owner/name GitHub slug — present for codespace placements, where the repo is the stack's identity
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub repo: Option<String>,
    /// The KB's did:web identifier, from its committed .xynolog/config.yaml — "did:web:" + its site.domain, verbatim. REQUIRED: a KB that declares no domain has no identity to publish, and the launcher refuses to start it rather than inventing or defaulting one. NOT unique within a document: a did names the knowledge base, not a running copy of it, so a local clone and a codespace of the same repo legitimately share one and both are published. host:port is the unique field (at most one entry per address), so consumers look up by ADDRESS and use the did to VERIFY that the copy they reached is the KB they meant — an address alone cannot say which KB is which, and an identity alone cannot say which copy.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub did: Option<String>,
    /// Human-readable site name from the KB's .xynolog/config.yaml (site.siteName), for display
    #[serde(rename = "siteName")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub site_name: Option<String>,
    /// Why its identity could not be read from its clone, when it could not.
    #[serde(rename = "identityError")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub identity_error: Option<String>,
    /// The knowledge base as the discovery document publishes it, when it does.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub kb: Option<DiscoveredKB>,
    /// The runtime its record names.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub runtime: Option<Runtime>,
    /// The base URL of its gateway, from its record.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub gateway: Option<String>,
    /// Where the values the launcher generates for it are kept, as xynolog settings secret-store describes it.
    #[serde(rename = "secretStore")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub secret_store: Option<String>,
    /// This machine's address on the network, when the stack is started with network lan.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub lan: Option<String>,
    /// Whether a xynolog start of it holds its start lock: its services are not ready, whatever they report.
    pub starting: bool,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub session: Option<Session>,
    /// Whether each of its counted services, and the issuer it signs in at, answers.
    pub healthy: bool,
    /// Its own services, group by group, then the issuer it signs in at. Empty for a codespace's, whose services its own launcher reports.
    pub services: Vec<ServiceStatus>,
    /// The ledger and job queue readings the launcher can attribute to this knowledge base. A missing reading means the Collector has not reported that metric, not that its value is zero.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub workload: Option<WorkloadStatus>,
}

impl KnowledgeBaseStatus {
    /// The `KnowledgeBaseStatus` that states these and nothing else.
    pub fn new(
        name: impl Into<String>,
        key: impl Into<String>,
        recorded: bool,
        placement: KnowledgeBaseStatusPlacement,
        starting: bool,
        healthy: bool,
        services: Vec<ServiceStatus>,
    ) -> Self {
        Self {
            name: name.into(),
            key: key.into(),
            recorded,
            placement,
            root: None,
            repo: None,
            did: None,
            site_name: None,
            identity_error: None,
            kb: None,
            runtime: None,
            gateway: None,
            secret_store: None,
            lan: None,
            starting,
            session: None,
            healthy,
            services,
            workload: None,
        }
    }
}

schema!(KnowledgeBaseStatus);

/// Where the stack actually runs. "local": containers on this machine. "codespace": a GitHub-hosted VM whose KB is port-forwarded here.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum KnowledgeBaseStatusPlacement {
    #[serde(rename = "local")]
    Local,
    #[serde(rename = "codespace")]
    Codespace,
}

impl KnowledgeBaseStatusPlacement {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            KnowledgeBaseStatusPlacement::Local => "local",
            KnowledgeBaseStatusPlacement::Codespace => "codespace",
        }
    }
}

/// Knowledge graph gathered for an LLM context — a shared backbone in which resources AND annotations are typed nodes, connected by typed (optionally bidirectional) edges. Flattened views the matcher/generation read (connections, citedBy, siblings) are derived from these nodes/edges.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct KnowledgeGraph {
    pub nodes: Vec<KnowledgeGraphNodesItem>,
    pub edges: Vec<KnowledgeGraphEdgesItem>,
    /// Whether the graph stopped taking resources at its ceiling of 200 resource nodes, so that a resource within the depth asked for is not in it. Present, and true, only then
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub truncated: Option<bool>,
}

impl KnowledgeGraph {
    /// The `KnowledgeGraph` that states these and nothing else.
    pub fn new(nodes: Vec<KnowledgeGraphNodesItem>, edges: Vec<KnowledgeGraphEdgesItem>) -> Self {
        Self {
            nodes,
            edges,
            truncated: None,
        }
    }
}

schema!(KnowledgeGraph);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct KnowledgeGraphEdgesItem {
    pub source: String,
    pub target: String,
    /// Edge kind: `annotation-of` (an annotation → the resource it lives on), `cites` (a citing linking annotation → the focal resource), or `link` (a resource → a resource it links to)
    pub r#type: String,
    /// Whether the connection goes both ways. Absent on a `link` edge found through what cites a resource, which says nothing of the way back
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub bidirectional: Option<bool>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub metadata: Option<std::collections::BTreeMap<String, serde_json::Value>>,
}

impl KnowledgeGraphEdgesItem {
    /// The `KnowledgeGraphEdgesItem` that states these and nothing else.
    pub fn new(
        source: impl Into<String>,
        target: impl Into<String>,
        r#type: impl Into<String>,
    ) -> Self {
        Self {
            source: source.into(),
            target: target.into(),
            r#type: r#type.into(),
            bidirectional: None,
            metadata: None,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Serialize)]
#[serde(untagged)]
pub enum KnowledgeGraphNodesItem {
    ResourceNode(GraphResourceNode),
    AnnotationNode(GraphAnnotationNode),
}

impl<'de> serde::Deserialize<'de> for KnowledgeGraphNodesItem {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("type").and_then(serde_json::Value::as_str) {
            Some("resource") => {
                serde_json::from_value(value).map(KnowledgeGraphNodesItem::ResourceNode)
            }
            Some("annotation") => {
                serde_json::from_value(value).map(KnowledgeGraphNodesItem::AnnotationNode)
            }
            _ => {
                return Err(serde::de::Error::custom(
                    "a KnowledgeGraphNodesItem states a `type` that is one of `resource`, `annotation`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

member!(KnowledgeGraphNodesItem::ResourceNode(GraphResourceNode));
member!(KnowledgeGraphNodesItem::AnnotationNode(GraphAnnotationNode));

/// What a knowledge base's record is indexed into, and the services that keep and read the indexes: the Weaver's graph, the Smelter's vectors and anchored text, and the Librarian that answers from them. Each can be rebuilt from the record.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KnowledgeIndex {
    #[serde(rename = "apiVersion")]
    pub api_version: StackApiVersion,
    pub kind: KnowledgeIndexKind,
    pub metadata: Metadata,
    /// The indexes, the services that keep and read them, and the knowledge base they index.
    pub spec: KnowledgeIndexSpec,
}

impl KnowledgeIndex {
    /// The `KnowledgeIndex` that states these and nothing else.
    pub fn new(api_version: StackApiVersion, metadata: Metadata, spec: KnowledgeIndexSpec) -> Self {
        Self {
            api_version,
            kind: KnowledgeIndexKind::KnowledgeIndex,
            metadata,
            spec,
        }
    }
}

schema!(KnowledgeIndex);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum KnowledgeIndexKind {
    #[serde(rename = "KnowledgeIndex")]
    KnowledgeIndex,
}

impl KnowledgeIndexKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            KnowledgeIndexKind::KnowledgeIndex => "KnowledgeIndex",
        }
    }
}

/// The indexes, the services that keep and read them, and the knowledge base they index.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KnowledgeIndexSpec {
    /// The name of the KnowledgeBase document whose record this indexes.
    #[serde(rename = "knowledgeBase")]
    pub knowledge_base: String,
    #[serde(rename = "logLevel")]
    pub log_level: LogLevel,
    /// The graph store the Weaver writes and the Librarian reads. The knowledge base's graph is in the database its DID names (specs/src/graph/database-cases.json): a Neo4j the launcher runs makes it when it first starts, and one somebody else runs must already hold it.
    pub graph: KnowledgeIndexSpecGraph,
    /// The vector store the Smelter writes and the Librarian reads: the one the launcher runs for the knowledge bases on a machine, at `shared`; one of the knowledge base's own the launcher runs, from `image` with `resources`; or somebody else's, at `external`. Exactly one of the three.
    pub vectors: KnowledgeIndexSpecVectors,
    /// The model that turns text into vectors. Vectors made by one model are not comparable with another's, so the model is the index's.
    pub embedding: KnowledgeIndexSpecEmbedding,
    /// The Librarian: it answers gathers and searches from the indexes.
    pub librarian: KnowledgeIndexSpecLibrarian,
    /// The Smelter: it writes the vectors and the anchored text.
    pub smelter: KnowledgeIndexSpecSmelter,
    /// The Weaver: it writes the graph.
    pub weaver: KnowledgeIndexSpecWeaver,
}

/// The model that turns text into vectors. Vectors made by one model are not comparable with another's, so the model is the index's.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KnowledgeIndexSpecEmbedding {
    /// Who serves the model: `ollama`, or `voyage`.
    pub r#type: String,
    /// The model, as its provider names it.
    pub model: String,
    /// How a text is cut before it is embedded.
    pub chunking: KnowledgeIndexSpecEmbeddingChunking,
    /// Where the provider's API is reached. The shared Ollama is stated by no endpoint.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub endpoint: Option<String>,
    #[serde(rename = "apiKey")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub api_key: Option<SecretRef>,
}

impl KnowledgeIndexSpecEmbedding {
    /// The `KnowledgeIndexSpecEmbedding` that states these and nothing else.
    pub fn new(
        r#type: impl Into<String>,
        model: impl Into<String>,
        chunking: KnowledgeIndexSpecEmbeddingChunking,
    ) -> Self {
        Self {
            r#type: r#type.into(),
            model: model.into(),
            chunking,
            endpoint: None,
            api_key: None,
        }
    }
}

/// How a text is cut before it is embedded.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KnowledgeIndexSpecEmbeddingChunking {
    /// The size of a piece.
    #[serde(rename = "chunkSize")]
    pub chunk_size: u64,
    /// How much of one piece the next repeats.
    pub overlap: u64,
}

/// The graph store the Weaver writes and the Librarian reads. The knowledge base's graph is in the database its DID names (specs/src/graph/database-cases.json): a Neo4j the launcher runs makes it when it first starts, and one somebody else runs must already hold it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KnowledgeIndexSpecGraph {
    /// The graph store's driver: `neo4j`.
    pub r#type: String,
    /// The user the services sign in to the store as.
    pub username: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub image: Option<Image>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resources: Option<Resources>,
    /// A graph store somebody else runs.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub external: Option<KnowledgeIndexSpecGraphExternal>,
}

impl KnowledgeIndexSpecGraph {
    /// The `KnowledgeIndexSpecGraph` that states these and nothing else.
    pub fn new(r#type: impl Into<String>, username: impl Into<String>) -> Self {
        Self {
            r#type: r#type.into(),
            username: username.into(),
            image: None,
            resources: None,
            external: None,
        }
    }
}

/// A graph store somebody else runs.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KnowledgeIndexSpecGraphExternal {
    /// Where it listens: `bolt://host:port`.
    pub uri: String,
    pub password: SecretRef,
}

/// The Librarian: it answers gathers and searches from the indexes.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KnowledgeIndexSpecLibrarian {
    pub image: Image,
    pub resources: Resources,
    /// How a gather waits.
    pub gather: KnowledgeIndexSpecLibrarianGather,
    /// What a search by meaning keeps.
    pub search: KnowledgeIndexSpecLibrarianSearch,
}

/// How a gather waits.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KnowledgeIndexSpecLibrarianGather {
    /// How long a gather waits for the Smelter to settle a resource, in milliseconds.
    #[serde(rename = "settleTimeoutMs")]
    pub settle_timeout_ms: u64,
}

/// What a search by meaning keeps.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KnowledgeIndexSpecLibrarianSearch {
    /// The least similarity a hit by meaning must have.
    #[serde(rename = "semanticFloor")]
    pub semantic_floor: f64,
}

/// The Smelter: it writes the vectors and the anchored text.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KnowledgeIndexSpecSmelter {
    pub image: Image,
    pub resources: Resources,
    /// How many PDFs it works on at once. A page of a scan held for OCR is large; one for each 2G of its memory is a reading of what fits.
    #[serde(rename = "pdfsAtOnce")]
    pub pdfs_at_once: u64,
}

/// The vector store the Smelter writes and the Librarian reads: the one the launcher runs for the knowledge bases on a machine, at `shared`; one of the knowledge base's own the launcher runs, from `image` with `resources`; or somebody else's, at `external`. Exactly one of the three.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KnowledgeIndexSpecVectors {
    /// The vector store's driver: `qdrant`.
    pub r#type: String,
    /// The vector store the launcher runs for the knowledge bases on a machine (the state home's VectorStore document). Each knowledge base keeps its index in collections of its own there, so nothing is said of it here.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub shared: Option<KnowledgeIndexSpecVectorsShared>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub image: Option<Image>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resources: Option<Resources>,
    /// A vector store somebody else runs, with the token each service presents to it: the Smelter's may make, write and delete this knowledge base's collections, and the Librarian's may read them.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub external: Option<KnowledgeIndexSpecVectorsExternal>,
}

impl KnowledgeIndexSpecVectors {
    /// The `KnowledgeIndexSpecVectors` that states these and nothing else.
    pub fn new(r#type: impl Into<String>) -> Self {
        Self {
            r#type: r#type.into(),
            shared: None,
            image: None,
            resources: None,
            external: None,
        }
    }
}

/// A vector store somebody else runs, with the token each service presents to it: the Smelter's may make, write and delete this knowledge base's collections, and the Librarian's may read them.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KnowledgeIndexSpecVectorsExternal {
    /// A host name or address the stack's containers can reach.
    pub host: String,
    /// The port its REST API listens on.
    pub port: u16,
    #[serde(rename = "smelterToken")]
    pub smelter_token: SecretRef,
    #[serde(rename = "librarianToken")]
    pub librarian_token: SecretRef,
}

/// The vector store the launcher runs for the knowledge bases on a machine (the state home's VectorStore document). Each knowledge base keeps its index in collections of its own there, so nothing is said of it here.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KnowledgeIndexSpecVectorsShared {}

/// The Weaver: it writes the graph.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct KnowledgeIndexSpecWeaver {
    pub image: Image,
    pub resources: Resources,
}

/// Where a knowledge base's stream was: for each scope, a resource's id, the id of the last recorded event delivered on it.
pub type LastEventIds = std::collections::BTreeMap<ResourceId, PersistedEventId>;

/// Everything a Librarian reads at boot: nothing in it is defaulted by the Librarian. Whoever starts a Librarian writes it, from the knowledge base's stack documents, and the Librarian reads it from the path its `--config` flag names. This schema is the contract, and a Librarian needs no launcher. Started without `--config`, or with a path that names no file, the Librarian refuses to start and says which. No secret is a value here: the graph database's password, an embedding provider's key and a model provider's key are each named by the environment variable that holds it, and the Librarian's own service account is `XYNOLOG_OIDC_CLIENT_ID` and `XYNOLOG_OIDC_CLIENT_SECRET` in its environment. A document that does not validate is refused at boot, naming each failing field.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct LibrarianConfig {
    pub kb: KbIdentity,
    /// The URL the Librarian reaches the gateway at: its route to the bus.
    #[serde(rename = "gatewayUrl")]
    pub gateway_url: String,
    /// The issuer the Librarian's service account signs in at.
    pub identity: ServiceIdentity,
    /// Where the Archivist listens. The Librarian reads a resource's bytes from it, as its service account.
    pub archivist: ServiceAddress,
    pub graph: GraphConfig,
    pub vectors: VectorsConfig,
    pub embedding: EmbeddingConfig,
    pub matcher: LibrarianEngineConfig,
    pub gatherer: LibrarianEngineConfig,
    /// The path of a model catalogue file: what each model of a provider can take, for the providers whose own APIs do not say (`google`, `openai`, `together`). A Librarian whose matcher or gatherer is of one of those providers refuses to start where the file cannot be read, and where it states nothing of that model. A Librarian with no such model does not read it.
    #[serde(rename = "modelCatalogue")]
    pub model_catalogue: String,
    /// The bound on a gather.
    pub gather: LibrarianConfigGather,
    /// The bound on a search by meaning.
    pub search: LibrarianConfigSearch,
    /// The port the Librarian answers `/health` on.
    pub port: u16,
    #[serde(rename = "logLevel")]
    pub log_level: LogLevel,
    #[serde(rename = "logFormat")]
    pub log_format: LogFormat,
}

schema!(LibrarianConfig);

/// The bound on a gather.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct LibrarianConfigGather {
    /// How long a gather around a resource waits for the Smelter's decision on it before answering without similar passages, in milliseconds.
    #[serde(rename = "settleTimeoutMs")]
    pub settle_timeout_ms: u64,
}

/// The bound on a search by meaning.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct LibrarianConfigSearch {
    /// The least similarity a hit by meaning must have.
    #[serde(rename = "semanticFloor")]
    pub semantic_floor: f64,
}

/// The engine a Librarian actor asks: which it is, and where its provider is reached.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct LibrarianEngineConfig {
    pub engine: Engine,
    /// The address the provider's API is reached at.
    #[serde(rename = "baseUrl")]
    pub base_url: String,
    /// The environment variable holding the provider's API key, when the provider requires one.
    #[serde(rename = "apiKeyEnv")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub api_key_env: Option<String>,
}

impl LibrarianEngineConfig {
    /// The `LibrarianEngineConfig` that states these and nothing else.
    pub fn new(engine: Engine, base_url: impl Into<String>) -> Self {
        Self {
            engine,
            base_url: base_url.into(),
            api_key_env: None,
        }
    }
}

schema!(LibrarianEngineConfig);

/// The Librarian's health answer (LIBRARIAN.md § Health). Its port opens last, after it has begun to take requests from the bus, so a Librarian whose health answers is answering.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct LibrarianHealth {
    pub status: LibrarianHealthStatus,
    /// The DID of the knowledge base it serves: the one its document names, which that knowledge base said it is before the Librarian reached its stores.
    pub kb: KbDid,
    /// The two actors it runs, `matcher` and `gatherer`.
    pub actors: Vec<LibrarianHealthActorsItem>,
}

impl LibrarianHealth {
    /// The `LibrarianHealth` that states these and nothing else.
    pub fn new(kb: KbDid, actors: Vec<LibrarianHealthActorsItem>) -> Self {
        Self {
            status: LibrarianHealthStatus::Ok,
            kb,
            actors,
        }
    }
}

schema!(LibrarianHealth);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum LibrarianHealthActorsItem {
    #[serde(rename = "matcher")]
    Matcher,
    #[serde(rename = "gatherer")]
    Gatherer,
}

impl LibrarianHealthActorsItem {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            LibrarianHealthActorsItem::Matcher => "matcher",
            LibrarianHealthActorsItem::Gatherer => "gatherer",
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum LibrarianHealthStatus {
    #[serde(rename = "ok")]
    Ok,
}

impl LibrarianHealthStatus {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            LibrarianHealthStatus::Ok => "ok",
        }
    }
}

#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct LibrarianPromptScore {
    pub candidate: f64,
    pub score: f64,
}

schema!(LibrarianPromptScore);

/// An ErrorResponse that names, in `code`, the limit the request met.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct LimitRefusal {
    /// What went wrong, in a sentence.
    pub error: String,
    /// `streams`: the principal already holds as many streams as its coefficient of `x-xynolog-limits.streamsPerPrincipal` allows. `emit-rate`: the principal's emits have used its bucket, whose rate and burst are its coefficient of `x-xynolog-limits.emitsPerPrincipal`, per gateway process. `unanswered-requests`: the client already awaits as many replies as `BusSubscribeRequest.pendingReplies` may name. `capacity`: the gateway holds as many queued bytes as it can. `refusal-rate`: the request's credential was refused, and the requests its holder has had refused have used their allowance; it answers only a request whose token has already failed verification, so it says what a 401 says, and a client that can renew its token renews it and sends the request again rather than waiting (contract/TRANSPORT-CONTRACT.md § A refused credential).
    pub code: LimitRefusalCode,
    /// What the caller can do about it, when there is something to say.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub hint: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub details: Option<serde_json::Value>,
}

impl LimitRefusal {
    /// The `LimitRefusal` that states these and nothing else.
    pub fn new(error: impl Into<String>, code: LimitRefusalCode) -> Self {
        Self {
            error: error.into(),
            code,
            hint: None,
            details: None,
        }
    }
}

schema!(LimitRefusal);

/// `streams`: the principal already holds as many streams as its coefficient of `x-xynolog-limits.streamsPerPrincipal` allows. `emit-rate`: the principal's emits have used its bucket, whose rate and burst are its coefficient of `x-xynolog-limits.emitsPerPrincipal`, per gateway process. `unanswered-requests`: the client already awaits as many replies as `BusSubscribeRequest.pendingReplies` may name. `capacity`: the gateway holds as many queued bytes as it can. `refusal-rate`: the request's credential was refused, and the requests its holder has had refused have used their allowance; it answers only a request whose token has already failed verification, so it says what a 401 says, and a client that can renew its token renews it and sends the request again rather than waiting (contract/TRANSPORT-CONTRACT.md § A refused credential).
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum LimitRefusalCode {
    #[serde(rename = "streams")]
    Streams,
    #[serde(rename = "emit-rate")]
    EmitRate,
    #[serde(rename = "unanswered-requests")]
    UnansweredRequests,
    #[serde(rename = "capacity")]
    Capacity,
    #[serde(rename = "refusal-rate")]
    RefusalRate,
}

impl LimitRefusalCode {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            LimitRefusalCode::Streams => "streams",
            LimitRefusalCode::EmitRate => "emit-rate",
            LimitRefusalCode::UnansweredRequests => "unanswered-requests",
            LimitRefusalCode::Capacity => "capacity",
            LimitRefusalCode::RefusalRate => "refusal-rate",
        }
    }
}

/// What a linking job takes: mentions of the named entity types are marked as references, each unresolved until it is bound to a resource.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct LinkingJobParams {
    pub motivation: LinkingJobParamsMotivation,
    /// The entity types to find mentions of. Each is one the knowledge base registers.
    #[serde(rename = "entityTypes")]
    pub entity_types: Vec<String>,
    /// Whether a description that stands for an entity ("the wily hero") counts as a mention of it, beside its name.
    #[serde(rename = "includeDescriptiveReferences")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub include_descriptive_references: Option<bool>,
    /// The language the annotations' own text is written in. BCP 47.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub language: Option<String>,
    /// The language of the resource being read. BCP 47.
    #[serde(rename = "sourceLanguage")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub source_language: Option<String>,
}

impl LinkingJobParams {
    /// The `LinkingJobParams` that states these and nothing else.
    pub fn new(entity_types: Vec<String>) -> Self {
        Self {
            motivation: LinkingJobParamsMotivation::Linking,
            entity_types,
            include_descriptive_references: None,
            language: None,
            source_language: None,
        }
    }
}

schema!(LinkingJobParams);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum LinkingJobParamsMotivation {
    #[serde(rename = "linking")]
    Linking,
}

impl LinkingJobParamsMotivation {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            LinkingJobParamsMotivation::Linking => "linking",
        }
    }
}

#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct ListResourcesResponse {
    pub resources: Vec<ResourceDescriptor>,
    pub total: f64,
    pub offset: f64,
    pub limit: f64,
}

schema!(ListResourcesResponse);

/// A knowledge base the host process has loaded and reaches through a transport with no wire.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct LocalEndpoint {
    /// Discriminant: the endpoint is in the host process.
    pub kind: LocalEndpointKind,
    /// Which loaded knowledge base, named by an id that means something to the host process alone.
    #[serde(rename = "kbId")]
    pub kb_id: String,
}

impl LocalEndpoint {
    /// The `LocalEndpoint` that states these and nothing else.
    pub fn new(kb_id: impl Into<String>) -> Self {
        Self {
            kind: LocalEndpointKind::Local,
            kb_id: kb_id.into(),
        }
    }
}

schema!(LocalEndpoint);

/// Discriminant: the endpoint is in the host process.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum LocalEndpointKind {
    #[serde(rename = "local")]
    Local,
}

impl LocalEndpointKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            LocalEndpointKind::Local => "local",
        }
    }
}

/// A local knowledge base, named explicitly: the operations that act on one local stack and never resolve one for the caller (identity administration, a service's run).
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct LocalTarget {
    /// Only a local stack.
    pub kind: LocalTargetKind,
    /// The knowledge base's clone, by its path.
    pub root: String,
}

impl LocalTarget {
    /// The `LocalTarget` that states these and nothing else.
    pub fn new(root: impl Into<String>) -> Self {
        Self {
            kind: LocalTargetKind::Local,
            root: root.into(),
        }
    }
}

schema!(LocalTarget);

/// Only a local stack.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum LocalTargetKind {
    #[serde(rename = "local")]
    Local,
}

impl LocalTargetKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            LocalTargetKind::Local => "local",
        }
    }
}

/// How each log line is written to stdout (service-telemetry/log-lines.json): `json`, one JSON object per line; or `simple`, a line of words followed by any metadata as JSON.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum LogFormat {
    #[serde(rename = "json")]
    Json,
    #[serde(rename = "simple")]
    Simple,
}

impl LogFormat {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            LogFormat::Json => "json",
            LogFormat::Simple => "simple",
        }
    }
}

schema!(LogFormat);

/// How much a service logs: the least severe level it writes, from error, the most severe, to debug.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum LogLevel {
    #[serde(rename = "error")]
    Error,
    #[serde(rename = "warn")]
    Warn,
    #[serde(rename = "info")]
    Info,
    #[serde(rename = "http")]
    Http,
    #[serde(rename = "debug")]
    Debug,
}

impl LogLevel {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            LogLevel::Error => "error",
            LogLevel::Warn => "warn",
            LogLevel::Info => "info",
            LogLevel::Http => "http",
            LogLevel::Debug => "debug",
        }
    }
}

schema!(LogLevel);

/// One line one of a stack's services wrote. The launcher removes from it each secret value the launcher generated or read; anything else the service wrote is the client's to handle. The launcher keeps no copy.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct LogRecord {
    #[serde(rename = "requestId")]
    pub request_id: RequestId,
    /// The role whose container wrote the line, as xynolog status names it.
    pub service: String,
    /// Which of the container's streams the line was on.
    pub stream: OutputStream,
    /// The line, without its newline.
    pub line: String,
    /// When the launcher read the line, in RFC 3339 with its fraction: a container's own lines carry the time it wrote them, if any.
    #[serde(rename = "receivedAt")]
    pub received_at: String,
}

schema!(LogRecord);

/// logs.follow's params.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct LogsFollowParams {
    /// The version of the control API the request is written to.
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    /// Which knowledge base's stack. Absent: the one the command line chooses, standing where the control server was started.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub target: Option<Target>,
    /// Keep to the local stacks, as --runtime does.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub runtime: Option<Runtime>,
    /// Just this service's container, as --service names it. Absent: each Xynolog service the stack runs.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub service: Option<String>,
}

impl LogsFollowParams {
    /// The `LogsFollowParams` that states these and nothing else.
    pub fn new(api_version: ApiVersion) -> Self {
        Self {
            api_version,
            target: None,
            runtime: None,
            service: None,
        }
    }
}

schema!(LogsFollowParams);

/// A follow whose every source ended on its own. A follow the client cancels is answered with control.cancelled.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct LogsFollowResult {
    /// The services that were followed.
    pub services: Vec<String>,
}

schema!(LogsFollowResult);

/// Bus command to archive a resource and optionally remove its file.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MarkArchiveCommand {
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// Optional: where the resource's bytes live, so the archive can act on the file. An instruction to this handler, not a copy of the stored fact (that lives on the primary Representation). Working-tree URI, only file:// is supported.
    #[serde(rename = "storageUri")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub storage_uri: Option<String>,
    #[serde(rename = "keepFile")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub keep_file: Option<bool>,
}

impl MarkArchiveCommand {
    /// The `MarkArchiveCommand` that states these and nothing else.
    pub fn new(resource_id: ResourceId) -> Self {
        Self {
            _user_id: None,
            resource_id,
            storage_uri: None,
            keep_file: None,
        }
    }
}

schema!(MarkArchiveCommand);

/// Bus command to persist a detection unit's annotations as one acknowledged batch. It is answered only after every annotation is in the event log, so a worker can gate unit completion on durability rather than on emission. The batch is the unit: a partial commit is reported as a failure, and the worker retries the whole unit, which is safe because annotation ids are deterministic: content-addressed, so re-emitting one is a no-op.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MarkCommitCommand {
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    /// The emitter's capabilities (the token's `roles`), injected by the /bus/emit gateway. Clients do not set this. An emitter carrying the worker role must cite the job this batch fulfils in `jobId`; the Stower refuses the batch otherwise.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _roles: Option<Vec<String>>,
    /// The job this batch fulfils. Required when the emitter carries the worker role; absent for self-initiated work (a person, or an agent acting on its own). The knowledge base derives who requested these annotations from the cited job's own events — the emitter never says who the work was for.
    #[serde(rename = "jobId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub job_id: Option<JobId>,
    /// Resource every annotation in this batch targets.
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// The unit's annotations, already built with deterministic ids. Re-committing an identical batch is a no-op rather than a duplicate.
    pub annotations: Vec<Annotation>,
}

impl MarkCommitCommand {
    /// The `MarkCommitCommand` that states these and nothing else.
    pub fn new(resource_id: ResourceId, annotations: Vec<Annotation>) -> Self {
        Self {
            _user_id: None,
            _roles: None,
            job_id: None,
            resource_id,
            annotations,
        }
    }
}

schema!(MarkCommitCommand);

/// Durability acknowledgement for a mark:commit batch: every annotation named by the command is in the event log at the moment this is emitted.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MarkCommitOk {
    /// What the commit persisted.
    pub response: MarkCommitOkResponse,
}

schema!(MarkCommitOk);

/// What the commit persisted.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MarkCommitOkResponse {
    /// Annotations the command named that are durable in the event log. Equals the batch size on success, on a first commit and on a retry alike — the commit appends only what the resource does not already hold, so a wholly-redundant retry has still succeeded and says so. Not an append tally: a caller must never have to read a 0 as 'all good'.
    pub persisted: i64,
    /// Ids the batch covers, whether appended now or already present.
    #[serde(rename = "annotationIds")]
    pub annotation_ids: Vec<AnnotationId>,
}

/// Success reply after creating an annotation, matched to the originating command by correlationId.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MarkCreateOk {
    pub response: MarkCreateOkResponse,
}

schema!(MarkCreateOk);

/// The created annotation's identity.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MarkCreateOkResponse {
    #[serde(rename = "annotationId")]
    pub annotation_id: AnnotationId,
}

schema!(MarkCreateOkResponse);

/// Raw annotation creation intent — bus handler assembles the W3C annotation
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MarkCreateRequest {
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    pub request: CreateAnnotationRequest,
}

schema!(MarkCreateRequest);

/// The payload of `mark:delegate-timeout`, a client-local signal: a delegated job went silent past its deadline, with no progress, no completion and no `job:fail`. A real job failure arrives as `job:fail` and never produces this.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MarkDelegateTimeoutEvent {
    /// The resource the job was delegated for.
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    pub motivation: Motivation,
}

schema!(MarkDelegateTimeoutEvent);

/// Bus command to delete an annotation.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MarkDeleteCommand {
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    #[serde(rename = "annotationId")]
    pub annotation_id: AnnotationId,
    #[serde(rename = "resourceId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resource_id: Option<ResourceId>,
}

impl MarkDeleteCommand {
    /// The `MarkDeleteCommand` that states these and nothing else.
    pub fn new(annotation_id: AnnotationId) -> Self {
        Self {
            _user_id: None,
            annotation_id,
            resource_id: None,
        }
    }
}

schema!(MarkDeleteCommand);

/// Success reply after deleting an annotation, matched to the originating command by correlationId.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MarkDeleteOk {
    /// The deleted annotation's identity.
    pub response: MarkDeleteOkResponse,
}

schema!(MarkDeleteOk);

/// The deleted annotation's identity.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MarkDeleteOkResponse {
    #[serde(rename = "annotationId")]
    pub annotation_id: AnnotationId,
}

/// A `mark` job's worker says the job is complete, with what a `mark` job reports.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MarkJobCompleteCommand {
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    #[serde(rename = "jobId")]
    pub job_id: JobId,
    #[serde(rename = "jobType")]
    pub job_type: MarkJobCompleteCommandJobType,
    /// Which attempt produced this event, 1-based (a first run is 1). ALWAYS present: the queue re-runs a failed job silently, so an operator reading progress or a terminal record has no other way to tell a re-run from a first run — and provider spend, already counted in xynolog_inference_tokens_total, cannot be attributed to a repeated document without it. Stated rather than inferred from absence, because 'attempt 1' is a fact the emitter always knows.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub attempt: Option<i64>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub result: Option<MarkJobResult>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub durability: Option<DurabilityEvidence>,
}

impl MarkJobCompleteCommand {
    /// The `MarkJobCompleteCommand` that states these and nothing else.
    pub fn new(resource_id: ResourceId, job_id: JobId) -> Self {
        Self {
            _user_id: None,
            resource_id,
            job_id,
            job_type: MarkJobCompleteCommandJobType::Mark,
            attempt: None,
            result: None,
            durability: None,
        }
    }
}

schema!(MarkJobCompleteCommand);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum MarkJobCompleteCommandJobType {
    #[serde(rename = "mark")]
    Mark,
}

impl MarkJobCompleteCommandJobType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            MarkJobCompleteCommandJobType::Mark => "mark",
        }
    }
}

/// Create a `mark` job: annotate one resource for one motivation.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct MarkJobCreateCommand {
    /// The emitter's verified DID, injected by the gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    /// The emitter's roles, injected by the gateway when it has any. Clients do not set this.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _roles: Option<Vec<String>>,
    #[serde(rename = "jobType")]
    pub job_type: MarkJobCreateCommandJobType,
    /// The resource to annotate.
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    pub params: MarkJobParams,
}

impl MarkJobCreateCommand {
    /// The `MarkJobCreateCommand` that states these and nothing else.
    pub fn new(resource_id: ResourceId, params: MarkJobParams) -> Self {
        Self {
            _user_id: None,
            _roles: None,
            job_type: MarkJobCreateCommandJobType::Mark,
            resource_id,
            params,
        }
    }
}

schema!(MarkJobCreateCommand);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum MarkJobCreateCommandJobType {
    #[serde(rename = "mark")]
    Mark,
}

impl MarkJobCreateCommandJobType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            MarkJobCreateCommandJobType::Mark => "mark",
        }
    }
}

/// What a `mark` job reports when it has done its work, whatever its motivation.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct MarkJobDone {
    /// What the model proposed, before anything was checked against the text.
    pub found: u64,
    /// What the log holds: the annotations committed, after the ones that could not be anchored were dropped and repeats were collapsed.
    pub persisted: u64,
    /// How many of the proposed could not be anchored in the text. Absent means none.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub errors: Option<u64>,
    /// The annotations persisted per category. A tagging job's; absent from every other.
    #[serde(rename = "byCategory")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub by_category: Option<std::collections::BTreeMap<String, i64>>,
    /// Total floor-accepted under-reported pieces across the job's units. Absent means none — the per-unit evidence rides the terminal progress frame's completedItems; this keeps the result self-describing without the progress stream.
    #[serde(rename = "underReportedPieces")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub under_reported_pieces: Option<i64>,
    /// Pieces whose yield was to be checked against a count and was not: the count failed, was cut off, or answered no count. What they found was kept unchecked. Absent means none: every piece that was to be checked was. A job whose provider checks no yield has none.
    #[serde(rename = "uncheckedPieces")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub unchecked_pieces: Option<u64>,
}

impl MarkJobDone {
    /// The `MarkJobDone` that states these and nothing else.
    pub fn new(found: u64, persisted: u64) -> Self {
        Self {
            found,
            persisted,
            errors: None,
            by_category: None,
            under_reported_pieces: None,
            unchecked_pieces: None,
        }
    }
}

schema!(MarkJobDone);

/// `mark` jobs of one motivation.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct MarkJobFilter {
    #[serde(rename = "jobType")]
    pub job_type: MarkJobFilterJobType,
    pub params: MarkJobFilterParams,
}

impl MarkJobFilter {
    /// The `MarkJobFilter` that states these and nothing else.
    pub fn new(params: MarkJobFilterParams) -> Self {
        Self {
            job_type: MarkJobFilterJobType::Mark,
            params,
        }
    }
}

schema!(MarkJobFilter);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum MarkJobFilterJobType {
    #[serde(rename = "mark")]
    Mark,
}

impl MarkJobFilterJobType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            MarkJobFilterJobType::Mark => "mark",
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct MarkJobFilterParams {
    pub motivation: Motivation,
}

/// The parameters of a `mark` job, told apart by `motivation`. Each motivation takes its own parameters and no others: a parameter a job does not take is refused where the job is created.
#[derive(Debug, Clone, PartialEq, serde::Serialize)]
#[serde(untagged)]
pub enum MarkJobParams {
    HighlightingJobParams(HighlightingJobParams),
    CommentingJobParams(CommentingJobParams),
    AssessingJobParams(AssessingJobParams),
    LinkingJobParams(LinkingJobParams),
    TaggingJobParams(TaggingJobParams),
}

impl<'de> serde::Deserialize<'de> for MarkJobParams {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("motivation").and_then(serde_json::Value::as_str) {
            Some("highlighting") => {
                serde_json::from_value(value).map(MarkJobParams::HighlightingJobParams)
            }
            Some("commenting") => {
                serde_json::from_value(value).map(MarkJobParams::CommentingJobParams)
            }
            Some("assessing") => {
                serde_json::from_value(value).map(MarkJobParams::AssessingJobParams)
            }
            Some("linking") => serde_json::from_value(value).map(MarkJobParams::LinkingJobParams),
            Some("tagging") => serde_json::from_value(value).map(MarkJobParams::TaggingJobParams),
            _ => {
                return Err(serde::de::Error::custom(
                    "a MarkJobParams states a `motivation` that is one of `highlighting`, `commenting`, `assessing`, `linking`, `tagging`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

impl MarkJobParams {
    /// The `motivation` this value states: the one its member is told apart by.
    pub(crate) const fn motivation(&self) -> Motivation {
        match self {
            MarkJobParams::HighlightingJobParams(_) => Motivation::Highlighting,
            MarkJobParams::CommentingJobParams(_) => Motivation::Commenting,
            MarkJobParams::AssessingJobParams(_) => Motivation::Assessing,
            MarkJobParams::LinkingJobParams(_) => Motivation::Linking,
            MarkJobParams::TaggingJobParams(_) => Motivation::Tagging,
        }
    }
}

member!(MarkJobParams::HighlightingJobParams(HighlightingJobParams));
member!(MarkJobParams::CommentingJobParams(CommentingJobParams));
member!(MarkJobParams::AssessingJobParams(AssessingJobParams));
member!(MarkJobParams::LinkingJobParams(LinkingJobParams));
member!(MarkJobParams::TaggingJobParams(TaggingJobParams));
schema!(MarkJobParams);

/// A pending `mark` job, announced with its parameters as it was created.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct MarkJobQueuedEvent {
    #[serde(rename = "jobId")]
    pub job_id: JobId,
    #[serde(rename = "jobType")]
    pub job_type: MarkJobQueuedEventJobType,
    /// The resource the job is about.
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// The DID of the principal whose `job:create` created the job.
    #[serde(rename = "userId")]
    pub user_id: UserId,
    pub params: MarkJobParams,
}

impl MarkJobQueuedEvent {
    /// The `MarkJobQueuedEvent` that states these and nothing else.
    pub fn new(
        job_id: JobId,
        resource_id: ResourceId,
        user_id: UserId,
        params: MarkJobParams,
    ) -> Self {
        Self {
            job_id,
            job_type: MarkJobQueuedEventJobType::Mark,
            resource_id,
            user_id,
            params,
        }
    }
}

schema!(MarkJobQueuedEvent);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum MarkJobQueuedEventJobType {
    #[serde(rename = "mark")]
    Mark,
}

impl MarkJobQueuedEventJobType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            MarkJobQueuedEventJobType::Mark => "mark",
        }
    }
}

/// What a `mark` job reports when it concludes without failing: its counts, or a decline. Neither names its kind: a decline is the one with `declined`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum MarkJobResult {
    MarkJobDone(MarkJobDone),
    JobDeclined(JobDeclined),
}

member!(MarkJobResult::MarkJobDone(MarkJobDone));
member!(MarkJobResult::JobDeclined(JobDeclined));
schema!(MarkJobResult);

/// Emitted when the user requests a new mark (annotation) on a resource
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MarkRequestedEvent {
    /// The '@id' of the resource the mark belongs to (W3C target.source). Routes the event to the right viewer/state unit when a host mounts many viewers on one session.
    pub source: ResourceId,
    /// One or more W3C selectors
    pub selector: AnnotationSelector,
    pub motivation: Motivation,
}

schema!(MarkRequestedEvent);

/// Emitted when a mark is submitted with its annotation body
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MarkSubmitEvent {
    /// The '@id' of the resource the mark belongs to (W3C target.source). Routes the submit to the state unit bound to that resource — without it, N mounted units each create the annotation (N copies on N resources).
    pub source: ResourceId,
    pub motivation: Motivation,
    /// One or more W3C selectors
    pub selector: AnnotationSelector,
    /// Optional body. Omit for annotations whose motivation alone is meaningful (e.g. highlighting) or whose user-supplied content is empty (e.g. an assessing annotation saved without comment text). Shape matches Annotation.body.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub body: Option<AnnotationBodies>,
}

impl MarkSubmitEvent {
    /// The `MarkSubmitEvent` that states these and nothing else.
    pub fn new(source: ResourceId, motivation: Motivation, selector: AnnotationSelector) -> Self {
        Self {
            source,
            motivation,
            selector,
            body: None,
        }
    }
}

schema!(MarkSubmitEvent);

/// Bus command to unarchive a previously archived resource.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MarkUnarchiveCommand {
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// Optional: where the resource's bytes are expected to be. When present the handler VERIFIES the file exists and fails loudly if it does not, rather than succeeding as a no-op. An instruction, not a copy of the stored fact (that lives on the primary Representation). Working-tree URI, only file:// is supported.
    #[serde(rename = "storageUri")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub storage_uri: Option<String>,
}

impl MarkUnarchiveCommand {
    /// The `MarkUnarchiveCommand` that states these and nothing else.
    pub fn new(resource_id: ResourceId) -> Self {
        Self {
            _user_id: None,
            resource_id,
            storage_uri: None,
        }
    }
}

schema!(MarkUnarchiveCommand);

/// Bus command to update an annotation's body with patch operations.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MarkUpdateBodyCommand {
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    #[serde(rename = "annotationId")]
    pub annotation_id: AnnotationId,
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    pub operations: Vec<BodyOperation>,
}

impl MarkUpdateBodyCommand {
    /// The `MarkUpdateBodyCommand` that states these and nothing else.
    pub fn new(
        annotation_id: AnnotationId,
        resource_id: ResourceId,
        operations: Vec<BodyOperation>,
    ) -> Self {
        Self {
            _user_id: None,
            annotation_id,
            resource_id,
            operations,
        }
    }
}

schema!(MarkUpdateBodyCommand);

/// Bus command to replace the entity types on a resource.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MarkUpdateEntityTypesCommand {
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    #[serde(rename = "currentEntityTypes")]
    pub current_entity_types: Vec<String>,
    #[serde(rename = "updatedEntityTypes")]
    pub updated_entity_types: Vec<String>,
}

impl MarkUpdateEntityTypesCommand {
    /// The `MarkUpdateEntityTypesCommand` that states these and nothing else.
    pub fn new(
        resource_id: ResourceId,
        current_entity_types: Vec<String>,
        updated_entity_types: Vec<String>,
    ) -> Self {
        Self {
            resource_id,
            _user_id: None,
            current_entity_types,
            updated_entity_types,
        }
    }
}

schema!(MarkUpdateEntityTypesCommand);

/// Which looser search found a quoted selection, stated of a span whose `anchorMethod` is `fuzzy-match` and only then. Which search finds it is reconcile's rule (specs/src/annotations/reconcile-cases.json).
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum MatchQuality {
    #[serde(rename = "normalized")]
    Normalized,
    #[serde(rename = "case-insensitive")]
    CaseInsensitive,
    #[serde(rename = "fuzzy")]
    Fuzzy,
}

impl MatchQuality {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            MatchQuality::Normalized => "normalized",
            MatchQuality::CaseInsensitive => "case-insensitive",
            MatchQuality::Fuzzy => "fuzzy",
        }
    }
}

schema!(MatchQuality);

/// Request to search the knowledge base's resources by text. The Librarian answers: it matches the text lexically, and when nothing matches, by meaning.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MatchResourcesRequest {
    /// The text to search for.
    pub search: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub archived: Option<bool>,
    #[serde(rename = "entityType")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_type: Option<String>,
    /// How many of the resources the search finds are passed over before the page begins.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub offset: Option<u64>,
    /// The most resources a page has.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub limit: Option<u16>,
}

impl MatchResourcesRequest {
    /// The `MatchResourcesRequest` that states these and nothing else.
    pub fn new(search: impl Into<String>) -> Self {
        Self {
            search: search.into(),
            archived: None,
            entity_type: None,
            offset: None,
            limit: None,
        }
    }
}

schema!(MatchResourcesRequest);

/// One page of the resources a text search found, and which kind of answer it is.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct MatchResourcesResponse {
    pub resources: Vec<ResourceDescriptor>,
    /// How many resources the search found in all, and not only on this page.
    pub total: u64,
    /// How many of the resources the search found were passed over before this page, as the request stated.
    pub offset: u64,
    /// The limit the search was made with.
    pub limit: u64,
    /// What kind of answer this is: 'lexical' — the resources matched the query text; 'semantic' — no lexical match existed, and these resources discuss the query per the vector index. Required so every producer labels its answer; a UI can render semantic results as a different kind of page ('no title matches, but these documents discuss it').
    #[serde(rename = "matchKind")]
    pub match_kind: MatchResourcesResponseMatchKind,
}

schema!(MatchResourcesResponse);

/// What kind of answer this is: 'lexical' — the resources matched the query text; 'semantic' — no lexical match existed, and these resources discuss the query per the vector index. Required so every producer labels its answer; a UI can render semantic results as a different kind of page ('no title matches, but these documents discuss it').
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum MatchResourcesResponseMatchKind {
    #[serde(rename = "lexical")]
    Lexical,
    #[serde(rename = "semantic")]
    Semantic,
}

impl MatchResourcesResponseMatchKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            MatchResourcesResponseMatchKind::Lexical => "lexical",
            MatchResourcesResponseMatchKind::Semantic => "semantic",
        }
    }
}

/// Result of searching resources by text
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct MatchResourcesResult {
    pub response: MatchResourcesResponse,
}

schema!(MatchResourcesResult);

/// The payload of `match:search-failed`: a CommandError that names the reference whose candidates could not be searched for.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MatchSearchFailed {
    /// Machine-readable failure class, for consumers that must BRANCH on why a command failed rather than log it. Optional and deliberately sparse: absent means 'no class declared', and every existing failure stays that way. An enum rather than a free string so the vocabulary has an owner — an unconstrained code is a mirror with no gate, and adding one should be a deliberate spec change. `message` remains the human-readable text and is unaffected. Members: `peer-unavailable` — the channel this command was sent on has no subscriber, i.e. the service that answers it has not connected yet. Transient by nature (a peer still starting), which is what distinguishes it from a refusal: retrying is the correct response. `not-found` — the resource this command addressed does not exist in this knowledge base. A verdict, not a symptom: it is emitted only where the answer comes from the event store, which is the system of record, and never from a projection that may merely be lagging. Deterministic, so unlike `peer-unavailable` retrying is pointless — and consumers may act destructively on it (the SDK deletes a restored tab). Absence is not denial: a future 'exists, but not for you' must travel as its own code, never as this one. `unauthorized` — that code: the caller is authenticated but not permitted to do what it asked. A verdict about the CALLER, not the resource, so retrying under the same credential cannot succeed and a consumer must never spin on it; emitted by `job:claim` for a caller whose token carries no worker role. `none-pending` — a declined claim, not an error: the queue holds no pending job of the requested types. Nothing went wrong; the one code a consumer PARKS on, meaning 'nothing to do until a wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying neither is unclassified — a malformed record or a missing injection — and a consumer treats it as 'log it, assume nothing'.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub code: Option<CommandErrorCode>,
    /// Human-readable error message
    pub message: String,
    /// Optional additional context (stack trace, field name, etc.)
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub details: Option<String>,
    /// The reference the search was asked for.
    #[serde(rename = "referenceId")]
    pub reference_id: AnnotationId,
}

impl MatchSearchFailed {
    /// The `MatchSearchFailed` that states these and nothing else.
    pub fn new(message: impl Into<String>, reference_id: AnnotationId) -> Self {
        Self {
            code: None,
            message: message.into(),
            details: None,
            reference_id,
        }
    }
}

schema!(MatchSearchFailed);

/// What a search for what a reference could refer to is told beside the reference and its context: MatchSearchRequest's other members. client/surface.json's `match.search` cases state what is sent for one left out.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct MatchSearchOptions {
    /// Maximum number of candidate results to return
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub limit: Option<u16>,
    /// Enable semantic similarity scoring in addition to keyword matching
    #[serde(rename = "useSemanticScoring")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub use_semantic_scoring: Option<bool>,
}

schema!(MatchSearchOptions);

/// Request payload sent on the match:search-request bus channel to find candidate matches.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct MatchSearchRequest {
    /// Resource ID the reference annotation belongs to. Used to scope result events on the EventBus so the events-stream delivers them to participants viewing this resource.
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// Annotation ID of the reference to search candidates for
    #[serde(rename = "referenceId")]
    pub reference_id: AnnotationId,
    /// Gathered context for the reference annotation
    pub context: GatheredContext,
    /// Maximum number of candidate results to return
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub limit: Option<u16>,
    /// Enable semantic similarity scoring in addition to keyword matching
    #[serde(rename = "useSemanticScoring")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub use_semantic_scoring: Option<bool>,
}

impl MatchSearchRequest {
    /// The `MatchSearchRequest` that states these and nothing else.
    pub fn new(
        resource_id: ResourceId,
        reference_id: AnnotationId,
        context: GatheredContext,
    ) -> Self {
        Self {
            resource_id,
            reference_id,
            context,
            limit: None,
            use_semantic_scoring: None,
        }
    }
}

schema!(MatchSearchRequest);

/// Search results payload emitted on match:search-results SSE channel.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct MatchSearchResult {
    #[serde(rename = "referenceId")]
    pub reference_id: AnnotationId,
    /// The scored candidates, best first.
    pub response: Vec<ScoredResource>,
}

schema!(MatchSearchResult);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MediaTokenRequest {
    /// The resource ID to generate a media token for
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
}

schema!(MediaTokenRequest);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct MediaTokenResponse {
    /// Short-lived media token for use as ?token= query parameter on resource URLs
    pub token: String,
}

schema!(MediaTokenResponse);

/// A graph held in the memory of the one process that is given it: for a test. It cannot be shared between processes, so a service that writes the graph for another to read, or reads what another wrote, refuses it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct MemoryGraphConfig {
    pub r#type: MemoryGraphConfigType,
}

impl Default for MemoryGraphConfig {
    fn default() -> Self {
        Self::new()
    }
}

impl MemoryGraphConfig {
    /// The `MemoryGraphConfig` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            r#type: MemoryGraphConfigType::Memory,
        }
    }
}

schema!(MemoryGraphConfig);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum MemoryGraphConfigType {
    #[serde(rename = "memory")]
    Memory,
}

impl MemoryGraphConfigType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            MemoryGraphConfigType::Memory => "memory",
        }
    }
}

/// A vector index held in the memory of the one process that is given it: for a test. It cannot be shared between processes, so a service that writes the index for another to search, or searches what another wrote, refuses it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct MemoryVectorsConfig {
    pub r#type: MemoryVectorsConfigType,
}

impl Default for MemoryVectorsConfig {
    fn default() -> Self {
        Self::new()
    }
}

impl MemoryVectorsConfig {
    /// The `MemoryVectorsConfig` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            r#type: MemoryVectorsConfigType::Memory,
        }
    }
}

schema!(MemoryVectorsConfig);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum MemoryVectorsConfigType {
    #[serde(rename = "memory")]
    Memory,
}

impl MemoryVectorsConfigType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            MemoryVectorsConfigType::Memory => "memory",
        }
    }
}

/// What names a document, as Kubernetes names an object. Documents refer to one another by `name`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct Metadata {
    /// The document's name: lower-case letters, digits and `-`, beginning and ending with a letter or digit. It names the document, never the knowledge base.
    pub name: String,
    /// The Kubernetes namespace the document belongs in. The launcher reads none.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub namespace: Option<String>,
    /// Kubernetes labels. The launcher reads none.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub labels: Option<std::collections::BTreeMap<String, String>>,
    /// Kubernetes annotations. The launcher reads none.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotations: Option<std::collections::BTreeMap<String, String>>,
}

impl Metadata {
    /// The `Metadata` that states these and nothing else.
    pub fn new(name: impl Into<String>) -> Self {
        Self {
            name: name.into(),
            namespace: None,
            labels: None,
            annotations: None,
        }
    }
}

schema!(Metadata);

/// Xynolog-supported W3C Web Annotation motivations - https://www.w3.org/TR/annotation-vocab/#motivation
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum Motivation {
    #[serde(rename = "assessing")]
    Assessing,
    #[serde(rename = "commenting")]
    Commenting,
    #[serde(rename = "highlighting")]
    Highlighting,
    #[serde(rename = "linking")]
    Linking,
    #[serde(rename = "tagging")]
    Tagging,
}

impl Motivation {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            Motivation::Assessing => "assessing",
            Motivation::Commenting => "commenting",
            Motivation::Highlighting => "highlighting",
            Motivation::Linking => "linking",
            Motivation::Tagging => "tagging",
        }
    }
}

schema!(Motivation);

/// A graph kept in a Neo4j database.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct Neo4jGraphConfig {
    pub r#type: Neo4jGraphConfigType,
    /// Where the database is reached (`bolt://host:7687`).
    pub uri: String,
    /// The user the service connects as.
    pub username: String,
    /// The environment variable holding that user's password. The password is never a value here.
    #[serde(rename = "passwordEnv")]
    pub password_env: String,
    /// Which of the server's databases holds the graph.
    pub database: String,
}

impl Neo4jGraphConfig {
    /// The `Neo4jGraphConfig` that states these and nothing else.
    pub fn new(
        uri: impl Into<String>,
        username: impl Into<String>,
        password_env: impl Into<String>,
        database: impl Into<String>,
    ) -> Self {
        Self {
            r#type: Neo4jGraphConfigType::Neo4j,
            uri: uri.into(),
            username: username.into(),
            password_env: password_env.into(),
            database: database.into(),
        }
    }
}

schema!(Neo4jGraphConfig);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum Neo4jGraphConfigType {
    #[serde(rename = "neo4j")]
    Neo4j,
}

impl Neo4jGraphConfigType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            Neo4jGraphConfigType::Neo4j => "neo4j",
        }
    }
}

/// A graph kept in Amazon Neptune, asked in Gremlin. No service has been run against one.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct NeptuneGraphConfig {
    pub r#type: NeptuneGraphConfigType,
    /// The cluster's endpoint: its host name.
    pub endpoint: String,
    /// The port its Gremlin endpoint listens on.
    pub port: u16,
}

impl NeptuneGraphConfig {
    /// The `NeptuneGraphConfig` that states these and nothing else.
    pub fn new(endpoint: impl Into<String>, port: u16) -> Self {
        Self {
            r#type: NeptuneGraphConfigType::Neptune,
            endpoint: endpoint.into(),
            port,
        }
    }
}

schema!(NeptuneGraphConfig);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum NeptuneGraphConfigType {
    #[serde(rename = "neptune")]
    Neptune,
}

impl NeptuneGraphConfigType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            NeptuneGraphConfigType::Neptune => "neptune",
        }
    }
}

/// What registering a knowledge base takes: everything a registered one holds but its id, which the client's list makes. It has a did, because registering follows a sign-in: the knowledge base has already said what it is.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct NewKnowledgeBase {
    /// What a person reads the knowledge base as. Once the knowledge base has described itself, its own name.
    pub label: String,
    pub endpoint: KbEndpoint,
    /// The did the knowledge base reported of itself.
    pub did: String,
    /// The last time the knowledge base described itself. Absent until it has, in an answer that carried this entry's did.
    #[serde(rename = "lastRead")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub last_read: Option<KbRead>,
}

impl NewKnowledgeBase {
    /// The `NewKnowledgeBase` that states these and nothing else.
    pub fn new(label: impl Into<String>, endpoint: KbEndpoint, did: impl Into<String>) -> Self {
        Self {
            label: label.into(),
            endpoint,
            did: did.into(),
            last_read: None,
        }
    }
}

schema!(NewKnowledgeBase);

/// How well an OCR engine read the pixels.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct OcrConfidence {
    /// Mean per-word confidence, 0-100.
    pub mean: f64,
    /// Words the engine was unsure of.
    #[serde(rename = "lowConfidenceWords")]
    pub low_confidence_words: i64,
    #[serde(rename = "totalWords")]
    pub total_words: i64,
}

schema!(OcrConfidence);

/// An embedding model served by an Ollama.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct OllamaEmbeddingConfig {
    pub r#type: OllamaEmbeddingConfigType,
    /// The model asked for, by the name the Ollama serves it under.
    pub model: String,
    /// The address the Ollama's API is reached at (`http://host:11434`).
    #[serde(rename = "baseUrl")]
    pub base_url: String,
}

impl OllamaEmbeddingConfig {
    /// The `OllamaEmbeddingConfig` that states these and nothing else.
    pub fn new(model: impl Into<String>, base_url: impl Into<String>) -> Self {
        Self {
            r#type: OllamaEmbeddingConfigType::Ollama,
            model: model.into(),
            base_url: base_url.into(),
        }
    }
}

schema!(OllamaEmbeddingConfig);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum OllamaEmbeddingConfigType {
    #[serde(rename = "ollama")]
    Ollama,
}

impl OllamaEmbeddingConfigType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            OllamaEmbeddingConfigType::Ollama => "ollama",
        }
    }
}

/// One Agent, or a non-empty list of them: the parties PROV-O and the Web Annotation model let a resource or an annotation name in one place, as one agent or several.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum OneOrMoreAgents {
    Agent(Agent),
    List(Vec<Agent>),
}

member!(OneOrMoreAgents::Agent(Agent));
schema!(OneOrMoreAgents);

/// One string, or a non-empty list of them: a JSON-LD term that may take one value or several.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum OneOrMoreStrings {
    Text(String),
    List(Vec<String>),
}

schema!(OneOrMoreStrings);

/// One URI, or a non-empty list of them: a JSON-LD term that may name one resource or several.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum OneOrMoreUris {
    Text(String),
    List(Vec<String>),
}

schema!(OneOrMoreUris);

/// A resource open in a knowledge base: which resource, the name it is shown by, when it was opened and its place among the others open there. A registry shows them by their places, and two in one place by when each was opened, first first.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct OpenResource {
    /// The resource.
    pub id: ResourceId,
    /// The name the resource is shown by.
    pub name: String,
    /// When the resource was opened, in milliseconds since the Unix epoch. Opening it again while it is open changes neither this nor its place.
    #[serde(rename = "openedAt")]
    pub opened_at: u64,
    /// The resource's place among those open in the knowledge base. One opened is given the place after the last taken, so a place freed by closing one is not given twice; a move gives each its place in the new order, counted from 0.
    pub order: u64,
    /// The resource's media type, which its icon is chosen by. Absent when it is not known.
    #[serde(rename = "mediaType")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub media_type: Option<String>,
    /// Where the resource is in the knowledge base's working tree, as a URI (file://docs/overview.md). Absent when it is not known.
    #[serde(rename = "storageUri")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub storage_uri: Option<String>,
}

impl OpenResource {
    /// The `OpenResource` that states these and nothing else.
    pub fn new(id: ResourceId, name: impl Into<String>, opened_at: u64, order: u64) -> Self {
        Self {
            id,
            name: name.into(),
            opened_at,
            order,
            media_type: None,
            storage_uri: None,
        }
    }
}

schema!(OpenResource);

/// Which of a container's streams a line was on.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum OutputStream {
    #[serde(rename = "stdout")]
    Stdout,
    #[serde(rename = "stderr")]
    Stderr,
}

impl OutputStream {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            OutputStream::Stdout => "stdout",
            OutputStream::Stderr => "stderr",
        }
    }
}

schema!(OutputStream);

/// The class a PDF is sorted into, which decides how its text is read. smelter/extraction-cases.json states what each class is.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum PdfClass {
    #[serde(rename = "A")]
    A,
    #[serde(rename = "B")]
    B,
    #[serde(rename = "C")]
    C,
    #[serde(rename = "D")]
    D,
    #[serde(rename = "E")]
    E,
    #[serde(rename = "F")]
    F,
    #[serde(rename = "G")]
    G,
}

impl PdfClass {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            PdfClass::A => "A",
            PdfClass::B => "B",
            PdfClass::C => "C",
            PdfClass::D => "D",
            PdfClass::E => "E",
            PdfClass::F => "F",
            PdfClass::G => "G",
        }
    }
}

schema!(PdfClass);

/// A rectangle on a page of a PDF, in PDF points, from the page's bottom-left corner with y increasing upward: what an RFC 3778 fragment selector names.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct PdfCoordinate {
    /// The page the rectangle is on.
    pub page: i64,
    /// The rectangle's x.
    pub x: f64,
    /// The rectangle's y.
    pub y: f64,
    /// The rectangle's width.
    pub width: f64,
    /// The rectangle's height.
    pub height: f64,
}

schema!(PdfCoordinate);

/// One positioned text run. Coordinates are PDF points with the origin at the bottom-left of the page, Y increasing upward; the flip to canvas pixels happens in the browser.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct PdfTextItem {
    /// Offset into AnchoredText.text, in Unicode code points from its start, inclusive.
    pub start: u64,
    /// Offset into AnchoredText.text, in Unicode code points from its start, exclusive.
    pub end: u64,
    /// 1-indexed page number.
    pub page: i64,
    pub x: f64,
    pub y: f64,
    pub width: f64,
    pub height: f64,
}

schema!(PdfTextItem);

/// The annotation a mark state unit is composing, from the selection a request asked for, until it is submitted or cancelled.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct PendingAnnotation {
    pub selector: AnnotationSelector,
    pub motivation: Motivation,
}

schema!(PendingAnnotation);

/// What a sign-in by a page redirect remembers across the trip to the issuer and back: the verifier and the state the issuer's response must match, where the person was connecting, what they believed they were connecting to, and the issuer's endpoints, so its completion asks nothing twice.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct PendingAuthorization {
    /// What the issuer's response must carry back to belong to this sign-in: random, as base64url.
    pub state: String,
    /// The PKCE code verifier (RFC 7636) the authorization code is exchanged with: random, as base64url.
    pub verifier: String,
    /// Where the issuer sends the person back to, named again when the code is exchanged.
    #[serde(rename = "redirectUri")]
    pub redirect_uri: String,
    /// Where the person was connecting.
    pub target: HttpEndpoint,
    /// The issuer the knowledge base trusts, and the endpoints of it a client uses.
    pub issuer: PendingAuthorizationIssuer,
    /// The registered knowledge base being signed in to again. Absent when it is none.
    #[serde(rename = "kbId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub kb_id: Option<String>,
    /// The did of what the person believed they clicked, checked against the answer and never assumed. Absent when they named nothing.
    #[serde(rename = "expectedDid")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub expected_did: Option<String>,
    /// The name of what the person believed they clicked. Absent when they named nothing.
    #[serde(rename = "expectedName")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub expected_name: Option<String>,
}

impl PendingAuthorization {
    /// The `PendingAuthorization` that states these and nothing else.
    pub fn new(
        state: impl Into<String>,
        verifier: impl Into<String>,
        redirect_uri: impl Into<String>,
        target: HttpEndpoint,
        issuer: PendingAuthorizationIssuer,
    ) -> Self {
        Self {
            state: state.into(),
            verifier: verifier.into(),
            redirect_uri: redirect_uri.into(),
            target,
            issuer,
            kb_id: None,
            expected_did: None,
            expected_name: None,
        }
    }
}

schema!(PendingAuthorization);

/// The issuer the knowledge base trusts, and the endpoints of it a client uses.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct PendingAuthorizationIssuer {
    /// The issuer's identifier.
    pub issuer: String,
    /// The issuer's authorization endpoint, where the person is sent.
    pub authorization: String,
    /// The issuer's token endpoint, where the code is exchanged.
    pub token: String,
    /// The issuer's device authorization endpoint (RFC 8628). Absent when the issuer has none.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub device: Option<String>,
    /// The issuer's revocation endpoint (RFC 7009). Absent when the issuer has none.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub revocation: Option<String>,
}

impl PendingAuthorizationIssuer {
    /// The `PendingAuthorizationIssuer` that states these and nothing else.
    pub fn new(
        issuer: impl Into<String>,
        authorization: impl Into<String>,
        token: impl Into<String>,
    ) -> Self {
        Self {
            issuer: issuer.into(),
            authorization: authorization.into(),
            token: token.into(),
            device: None,
            revocation: None,
        }
    }
}

/// A request was refused for lack of permission.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct PermissionDenied {
    /// The refusal's own message, untranslated; null when it gave none.
    pub detail: Option<String>,
}

schema!(PermissionDenied);

/// `p-<scope>-<sequenceNumber>` — the id of a persisted event delivered on a scoped subscription. Resumable: send it back as that scope's `lastEventId`. Stable across connections, so a client dedups by it.
pub type PersistedEventId = String;

/// Bus command saying what a principal is called. The gateway emits it when a principal ACTS, carrying the display name it just verified on its token; a principal may also emit it itself, for itself, which is how an agent, whose token carries no name, says what it is called. Either way the gateway stamps `_userId` with the sender's verified DID, so a principal names only itself. The Stower persists it as principal:profiled, and only when the name differs from the latest one recorded for that DID — so the log holds one line per name a principal has had, not one per act. A name is a fact ABOUT an identity, never part of the record of an act: no artifact carries it, and readers resolve it from the profiles projection. Emitted for a person and for an agent alike; never for a request that merely reads.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct PrincipalProfileCommand {
    /// The principal's DID, injected by the /bus/emit gateway from the verified token. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    /// The display name: from the issuer's `name` claim, as verified on the token that carried an act, or what the principal said of itself. A token with no name produces no command from the gateway — the issuer is where a person's name is set, and absence is recorded as absence.
    pub name: String,
}

impl PrincipalProfileCommand {
    /// The `PrincipalProfileCommand` that states these and nothing else.
    pub fn new(name: impl Into<String>) -> Self {
        Self {
            _user_id: None,
            name: name.into(),
        }
    }
}

schema!(PrincipalProfileCommand);

/// Payload for principal:profiled — what this principal is called, as the issuer's verified `name` claim said or as the principal said of itself, recorded once per change (system-level, no resourceId). The event's `userId` is the principal's DID; this payload is the fact about it. Provenance never reads it: every artifact joins on the DID alone, and this is projected into profiles.json for readers to resolve against. Two lines for one DID mean the name changed, and the timestamps say when — which is why no artifact ever had to freeze a copy.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct PrincipalProfiledPayload {
    /// The display name as of this event: from the issuer's verified `name` claim, or what the principal said of itself.
    pub name: String,
}

schema!(PrincipalProfiledPayload);

/// What a principal last said it is called, and when: the profile a `principal:profiled` event gives.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct Profile {
    /// The name the principal last gave.
    pub name: String,
    /// The timestamp of the event that gave it.
    pub since: String,
}

schema!(Profile);

/// What the principals of a knowledge base are called: the file `projections/__system__/profiles.json` under the state directory, the sum of the `principal:profiled` events. The Archivist writes it; the Archivist and the Librarian read it to name the principals a reply mentions. Written as JSON indented by two spaces.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ProfilesProjection {
    /// Each principal's current profile, keyed by its DID.
    pub profiles: std::collections::BTreeMap<String, Profile>,
}

schema!(ProfilesProjection);

/// One line of what an operation is doing, as the command line would tell a person, without colour. A secret value the launcher generated or read never appears in one.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct Progress {
    #[serde(rename = "requestId")]
    pub request_id: RequestId,
    /// What the line is: narration (log, note), an outcome (ok, warn, fail), a heading (banner, section), a timestamp (stamp), a runtime command about to run (command), or text the operation printed (output).
    pub kind: ProgressKind,
    /// The line.
    pub text: String,
}

schema!(Progress);

/// What the line is: narration (log, note), an outcome (ok, warn, fail), a heading (banner, section), a timestamp (stamp), a runtime command about to run (command), or text the operation printed (output).
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ProgressKind {
    #[serde(rename = "log")]
    Log,
    #[serde(rename = "note")]
    Note,
    #[serde(rename = "ok")]
    Ok,
    #[serde(rename = "warn")]
    Warn,
    #[serde(rename = "fail")]
    Fail,
    #[serde(rename = "banner")]
    Banner,
    #[serde(rename = "section")]
    Section,
    #[serde(rename = "stamp")]
    Stamp,
    #[serde(rename = "command")]
    Command,
    #[serde(rename = "output")]
    Output,
}

impl ProgressKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ProgressKind::Log => "log",
            ProgressKind::Note => "note",
            ProgressKind::Ok => "ok",
            ProgressKind::Warn => "warn",
            ProgressKind::Fail => "fail",
            ProgressKind::Banner => "banner",
            ProgressKind::Section => "section",
            ProgressKind::Stamp => "stamp",
            ProgressKind::Command => "command",
            ProgressKind::Output => "output",
        }
    }
}

/// A knowledge base's committed `.xynolog/config.yaml`: its name, whether its changes are staged in git, and its permanent identity. A deployment's documents never restate any of it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ProjectConfig {
    /// The knowledge base's name.
    pub project: ProjectConfigProject,
    /// How the knowledge base's changes reach git.
    pub git: ProjectConfigGit,
    /// The knowledge base's identity.
    pub site: ProjectConfigSite,
}

schema!(ProjectConfig);

/// How the knowledge base's changes reach git.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ProjectConfigGit {
    /// Whether changes to the working tree and the event log are staged in git as they are made.
    pub sync: bool,
}

/// The knowledge base's name.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ProjectConfigProject {
    /// The knowledge base's name, which decides where its state is kept.
    pub name: String,
    /// A version the knowledge base's author gives it. Nothing changes it.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub version: Option<String>,
}

impl ProjectConfigProject {
    /// The `ProjectConfigProject` that states these and nothing else.
    pub fn new(name: impl Into<String>) -> Self {
        Self {
            name: name.into(),
            version: None,
        }
    }
}

/// The knowledge base's identity.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ProjectConfigSite {
    /// The knowledge base's permanent identity, in did:web's colon-path form (`owner.github.io:repo`): stamped into every event it records, so never a machine's address and never changed. With no white space in it, which no DID holds (UserId.json).
    pub domain: String,
    /// The name people see for the knowledge base.
    #[serde(rename = "siteName")]
    pub site_name: String,
}

/// OAuth 2.0 Protected Resource Metadata (RFC 9728): which authorization server this knowledge base trusts, served at /.well-known/oauth-protected-resource so a client — the Browser, an MCP client — learns where to send a user to sign in without configuration. A 401 from any protected route points here in its WWW-Authenticate challenge.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ProtectedResourceMetadata {
    /// This knowledge base's resource identifier: its did:web identity resolved to an https URL (did:web:example.github.io:my-kb identifies https://example.github.io/my-kb). This is the exact value a token's aud claim must carry. It is an identifier, not an address — nothing dereferences it, and a knowledge base reached over http in local development still names itself by the https form, which is what makes the value stable across every host, port and proxy it is reached through.
    pub resource: String,
    /// Issuer identifiers whose tokens this resource accepts — the configured identity issuer.
    pub authorization_servers: Vec<String>,
    /// How a bearer token reaches this resource: the Authorization header only.
    pub bearer_methods_supported: Vec<ProtectedResourceMetadataBearerMethodsSupportedItem>,
    /// The knowledge base's name, for a client's sign-in prompt.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resource_name: Option<String>,
}

impl ProtectedResourceMetadata {
    /// The `ProtectedResourceMetadata` that states these and nothing else.
    pub fn new(
        resource: impl Into<String>,
        authorization_servers: Vec<String>,
        bearer_methods_supported: Vec<ProtectedResourceMetadataBearerMethodsSupportedItem>,
    ) -> Self {
        Self {
            resource: resource.into(),
            authorization_servers,
            bearer_methods_supported,
            resource_name: None,
        }
    }
}

schema!(ProtectedResourceMetadata);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ProtectedResourceMetadataBearerMethodsSupportedItem {
    #[serde(rename = "header")]
    Header,
}

impl ProtectedResourceMetadataBearerMethodsSupportedItem {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ProtectedResourceMetadataBearerMethodsSupportedItem::Header => "header",
        }
    }
}

/// How an inference provider is reached.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct Provider {
    /// Where the provider's API is reached. Anthropic's own API, and the shared Ollama, are stated by no baseURL.
    #[serde(rename = "baseURL")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub base_u_r_l: Option<String>,
    #[serde(rename = "apiKey")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub api_key: Option<SecretRef>,
}

schema!(Provider);

/// A vector index kept in a Qdrant server, asked over its REST API with a token.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct QdrantVectorsConfig {
    pub r#type: QdrantVectorsConfigType,
    /// The server's host.
    pub host: String,
    /// The port its REST API listens on.
    pub port: u16,
    /// The environment variable holding the token the service presents to the server on every request, which says what of the index it may read and write. The token is never a value here.
    #[serde(rename = "tokenEnv")]
    pub token_env: String,
}

impl QdrantVectorsConfig {
    /// The `QdrantVectorsConfig` that states these and nothing else.
    pub fn new(host: impl Into<String>, port: u16, token_env: impl Into<String>) -> Self {
        Self {
            r#type: QdrantVectorsConfigType::Qdrant,
            host: host.into(),
            port,
            token_env: token_env.into(),
        }
    }
}

schema!(QdrantVectorsConfig);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum QdrantVectorsConfigType {
    #[serde(rename = "qdrant")]
    Qdrant,
}

impl QdrantVectorsConfigType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            QdrantVectorsConfigType::Qdrant => "qdrant",
        }
    }
}

/// Words of a text, as a selection quotes them: the words themselves, and maybe the text just before and just after them, which tell apart the places they occur.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct QuotedText {
    /// The words quoted.
    pub exact: String,
    /// The text just before them.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub prefix: Option<String>,
    /// The text just after them.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub suffix: Option<String>,
}

impl QuotedText {
    /// The `QuotedText` that states these and nothing else.
    pub fn new(exact: impl Into<String>) -> Self {
        Self {
            exact: exact.into(),
            prefix: None,
            suffix: None,
        }
    }
}

schema!(QuotedText);

/// Where a quoted selection was found in a text, and how it was found, told apart by `anchorMethod`, one of AnchorMethod's words: a fuzzy match also names its search, `matchQuality`, and no other states one.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Serialize)]
#[serde(untagged)]
pub enum ReconciledSpan {
    UniqueMatch(ReconciledSpanUniqueMatch),
    ContextRecovered(ReconciledSpanContextRecovered),
    FirstOfMany(ReconciledSpanFirstOfMany),
    FuzzyMatch(ReconciledSpanFuzzyMatch),
}

impl<'de> serde::Deserialize<'de> for ReconciledSpan {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value
            .get("anchorMethod")
            .and_then(serde_json::Value::as_str)
        {
            Some("unique-match") => serde_json::from_value(value).map(ReconciledSpan::UniqueMatch),
            Some("context-recovered") => {
                serde_json::from_value(value).map(ReconciledSpan::ContextRecovered)
            }
            Some("first-of-many") => serde_json::from_value(value).map(ReconciledSpan::FirstOfMany),
            Some("fuzzy-match") => serde_json::from_value(value).map(ReconciledSpan::FuzzyMatch),
            _ => {
                return Err(serde::de::Error::custom(
                    "a ReconciledSpan states a `anchorMethod` that is one of `unique-match`, `context-recovered`, `first-of-many`, `fuzzy-match`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

schema!(ReconciledSpan);

/// The text has the words in more than one place, and the span is the first that fits every hint the quote gave.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ReconciledSpanContextRecovered {
    /// The offset the span starts at, in Unicode code points from the text's start.
    pub start: u64,
    /// The offset just past the span, in Unicode code points from the text's start.
    pub end: u64,
    /// The words quoted.
    pub exact: String,
    /// The text just before them.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub prefix: Option<String>,
    /// The text just after them.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub suffix: Option<String>,
    #[serde(rename = "anchorMethod")]
    pub anchor_method: ReconciledSpanContextRecoveredAnchorMethod,
}

impl ReconciledSpanContextRecovered {
    /// The `ReconciledSpanContextRecovered` that states these and nothing else.
    pub fn new(start: u64, end: u64, exact: impl Into<String>) -> Self {
        Self {
            start,
            end,
            exact: exact.into(),
            prefix: None,
            suffix: None,
            anchor_method: ReconciledSpanContextRecoveredAnchorMethod::ContextRecovered,
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ReconciledSpanContextRecoveredAnchorMethod {
    #[serde(rename = "context-recovered")]
    ContextRecovered,
}

impl ReconciledSpanContextRecoveredAnchorMethod {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ReconciledSpanContextRecoveredAnchorMethod::ContextRecovered => "context-recovered",
        }
    }
}

/// The text has the words in more than one place, and the span is the first, since the quote gave no hint or none fits.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ReconciledSpanFirstOfMany {
    /// The offset the span starts at, in Unicode code points from the text's start.
    pub start: u64,
    /// The offset just past the span, in Unicode code points from the text's start.
    pub end: u64,
    /// The words quoted.
    pub exact: String,
    /// The text just before them.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub prefix: Option<String>,
    /// The text just after them.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub suffix: Option<String>,
    #[serde(rename = "anchorMethod")]
    pub anchor_method: ReconciledSpanFirstOfManyAnchorMethod,
}

impl ReconciledSpanFirstOfMany {
    /// The `ReconciledSpanFirstOfMany` that states these and nothing else.
    pub fn new(start: u64, end: u64, exact: impl Into<String>) -> Self {
        Self {
            start,
            end,
            exact: exact.into(),
            prefix: None,
            suffix: None,
            anchor_method: ReconciledSpanFirstOfManyAnchorMethod::FirstOfMany,
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ReconciledSpanFirstOfManyAnchorMethod {
    #[serde(rename = "first-of-many")]
    FirstOfMany,
}

impl ReconciledSpanFirstOfManyAnchorMethod {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ReconciledSpanFirstOfManyAnchorMethod::FirstOfMany => "first-of-many",
        }
    }
}

/// The text has the words nowhere, and a looser search found the span: `matchQuality` names which.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ReconciledSpanFuzzyMatch {
    /// The offset the span starts at, in Unicode code points from the text's start.
    pub start: u64,
    /// The offset just past the span, in Unicode code points from the text's start.
    pub end: u64,
    /// The words quoted.
    pub exact: String,
    /// The text just before them.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub prefix: Option<String>,
    /// The text just after them.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub suffix: Option<String>,
    #[serde(rename = "anchorMethod")]
    pub anchor_method: ReconciledSpanFuzzyMatchAnchorMethod,
    #[serde(rename = "matchQuality")]
    pub match_quality: MatchQuality,
}

impl ReconciledSpanFuzzyMatch {
    /// The `ReconciledSpanFuzzyMatch` that states these and nothing else.
    pub fn new(
        start: u64,
        end: u64,
        exact: impl Into<String>,
        match_quality: MatchQuality,
    ) -> Self {
        Self {
            start,
            end,
            exact: exact.into(),
            prefix: None,
            suffix: None,
            anchor_method: ReconciledSpanFuzzyMatchAnchorMethod::FuzzyMatch,
            match_quality,
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ReconciledSpanFuzzyMatchAnchorMethod {
    #[serde(rename = "fuzzy-match")]
    FuzzyMatch,
}

impl ReconciledSpanFuzzyMatchAnchorMethod {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ReconciledSpanFuzzyMatchAnchorMethod::FuzzyMatch => "fuzzy-match",
        }
    }
}

/// The text has the words in exactly one place.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ReconciledSpanUniqueMatch {
    /// The offset the span starts at, in Unicode code points from the text's start.
    pub start: u64,
    /// The offset just past the span, in Unicode code points from the text's start.
    pub end: u64,
    /// The words quoted.
    pub exact: String,
    /// The text just before them.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub prefix: Option<String>,
    /// The text just after them.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub suffix: Option<String>,
    #[serde(rename = "anchorMethod")]
    pub anchor_method: ReconciledSpanUniqueMatchAnchorMethod,
}

impl ReconciledSpanUniqueMatch {
    /// The `ReconciledSpanUniqueMatch` that states these and nothing else.
    pub fn new(start: u64, end: u64, exact: impl Into<String>) -> Self {
        Self {
            start,
            end,
            exact: exact.into(),
            prefix: None,
            suffix: None,
            anchor_method: ReconciledSpanUniqueMatchAnchorMethod::UniqueMatch,
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ReconciledSpanUniqueMatchAnchorMethod {
    #[serde(rename = "unique-match")]
    UniqueMatch,
}

impl ReconciledSpanUniqueMatchAnchorMethod {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ReconciledSpanUniqueMatchAnchorMethod::UniqueMatch => "unique-match",
        }
    }
}

/// `e-<channel>:<correlationId>` — the id of a frame that carries a correlationId. Deterministic: the same reply has the same id on every connection, so a copy arriving on two connections (a reconnect overlap, or a replay of a retained reply) dedups. Never a resumption watermark.
pub type ReplyEventId = String;

/// A specific, byte-addressable rendition of a resource (file/asset/variant).
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct Representation {
    /// Stable ID for this representation.
    #[serde(rename = "@id")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub id: Option<String>,
    /// Type(s), e.g., schema:MediaObject.
    #[serde(rename = "@type")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub r#type: Option<OneOrMoreStrings>,
    /// MIME/media type (e.g., text/markdown, image/png).
    #[serde(rename = "mediaType")]
    pub media_type: String,
    /// Working-tree URI identifying where this rendition's bytes live. Only file:// is supported (e.g. file://docs/overview.md). The single home of the storage location: maintained across moves (yield:moved relocates it), absent when the resource has no stored bytes.
    #[serde(rename = "storageUri")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub storage_uri: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub filename: Option<String>,
    /// Size of the payload in bytes.
    #[serde(rename = "byteSize")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub byte_size: Option<u64>,
    /// The SHA-256 of the bytes, as 64 lower-case hexadecimal digits with nothing before them. Whatever compares the checksums of two representations compares this text.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub checksum: Option<String>,
    /// Compression/transfer encoding if applicable.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub encoding: Option<String>,
    /// IETF BCP 47 language tag (e.g., en, es-ES).
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub language: Option<String>,
    /// Pixels (images/video).
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub width: Option<u64>,
    /// Pixels (images/video).
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub height: Option<u64>,
    /// Seconds (audio/video).
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub duration: Option<f64>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub created: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub modified: Option<String>,
    /// Profile/shape the bytes conform to (e.g., a JSON profile or SVG profile).
    #[serde(rename = "conformsTo")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub conforms_to: Option<OneOrMoreUris>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub tags: Option<Vec<String>>,
    /// Semantics of this rendition relative to the resource (e.g., original, thumbnail, preview, derived).
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub rel: Option<RepresentationRel>,
    /// Every property the schema does not name, as it came.
    #[serde(flatten)]
    pub rest: serde_json::Map<String, serde_json::Value>,
}

impl Representation {
    /// The `Representation` that states these and nothing else.
    pub fn new(media_type: impl Into<String>) -> Self {
        Self {
            id: None,
            r#type: None,
            media_type: media_type.into(),
            storage_uri: None,
            filename: None,
            byte_size: None,
            checksum: None,
            encoding: None,
            language: None,
            width: None,
            height: None,
            duration: None,
            created: None,
            modified: None,
            conforms_to: None,
            tags: None,
            rel: None,
            rest: serde_json::Map::new(),
        }
    }
}

schema!(Representation);

/// Payload for yield:representation-added domain event
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct RepresentationAddedPayload {
    pub representation: Representation,
}

schema!(RepresentationAddedPayload);

/// The Archivist's 404 for a resource's bytes: an ErrorResponse whose `code` says which half of the lookup failed — `resource` when the record holds no such resource, `representation` when it holds the resource but not its bytes. Each reader answers the two differently.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct RepresentationNotFound {
    /// What went wrong, in a sentence.
    pub error: String,
    /// A machine-readable class, when the route defines one.
    pub code: RepresentationNotFoundCode,
    /// What the caller can do about it, when there is something to say.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub hint: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub details: Option<serde_json::Value>,
}

impl RepresentationNotFound {
    /// The `RepresentationNotFound` that states these and nothing else.
    pub fn new(error: impl Into<String>, code: RepresentationNotFoundCode) -> Self {
        Self {
            error: error.into(),
            code,
            hint: None,
            details: None,
        }
    }
}

schema!(RepresentationNotFound);

/// A machine-readable class, when the route defines one.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum RepresentationNotFoundCode {
    #[serde(rename = "resource")]
    Resource,
    #[serde(rename = "representation")]
    Representation,
}

impl RepresentationNotFoundCode {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            RepresentationNotFoundCode::Resource => "resource",
            RepresentationNotFoundCode::Representation => "representation",
        }
    }
}

/// Semantics of this rendition relative to the resource (e.g., original, thumbnail, preview, derived).
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum RepresentationRel {
    #[serde(rename = "original")]
    Original,
    #[serde(rename = "thumbnail")]
    Thumbnail,
    #[serde(rename = "preview")]
    Preview,
    #[serde(rename = "optimized")]
    Optimized,
    #[serde(rename = "derived")]
    Derived,
    #[serde(rename = "other")]
    Other,
}

impl RepresentationRel {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            RepresentationRel::Original => "original",
            RepresentationRel::Thumbnail => "thumbnail",
            RepresentationRel::Preview => "preview",
            RepresentationRel::Optimized => "optimized",
            RepresentationRel::Derived => "derived",
            RepresentationRel::Other => "other",
        }
    }
}

/// Payload for yield:representation-removed domain event
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct RepresentationRemovedPayload {
    /// Checksum of the representation to remove
    pub checksum: String,
}

schema!(RepresentationRemovedPayload);

/// The request a notification is about: the JSON-RPC id its client gave it, as the client gave it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum RequestId {
    Text(String),
    Integer(i64),
}

schema!(RequestId);

/// The annotations on one resource, as its materialized view holds them.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ResourceAnnotations {
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// Each annotation as the `mark:added` event that recorded it carried it, with the body changes recorded since applied. In the order they were first recorded.
    pub annotations: Vec<Annotation>,
    /// How many of the resource's events the view has applied.
    pub version: u64,
    /// The timestamp of the last event applied; the empty string before any.
    #[serde(rename = "updatedAt")]
    pub updated_at: String,
}

schema!(ResourceAnnotations);

/// Payload for mark:archived domain event
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct ResourceArchivedPayload {
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub reason: Option<String>,
}

schema!(ResourceArchivedPayload);

/// Payload for yield:cloned domain event
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct ResourceClonedPayload {
    pub name: String,
    pub format: ContentFormat,
    #[serde(rename = "contentChecksum")]
    pub content_checksum: String,
    #[serde(rename = "contentByteSize")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub content_byte_size: Option<i64>,
    /// Where the clone's bytes are, on the resource's primary Representation — the same single home `yield:created` writes to.
    #[serde(rename = "storageUri")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub storage_uri: Option<String>,
    #[serde(rename = "parentResourceId")]
    pub parent_resource_id: ResourceId,
    #[serde(rename = "entityTypes")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_types: Option<Vec<String>>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub language: Option<String>,
    /// Who made the clone — the emitter, derived at write time. A clone is never job-fulfilling. Absent on events written before derivation existed, whose emitter was their only party.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub creator: Option<Agent>,
    /// PROV-O wasAttributedTo, derived at write time: the cloner alone. The value the resource view carries.
    #[serde(rename = "wasAttributedTo")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub was_attributed_to: Option<OneOrMoreAgents>,
}

impl ResourceClonedPayload {
    /// The `ResourceClonedPayload` that states these and nothing else.
    pub fn new(
        name: impl Into<String>,
        format: ContentFormat,
        content_checksum: impl Into<String>,
        parent_resource_id: ResourceId,
    ) -> Self {
        Self {
            name: name.into(),
            format,
            content_checksum: content_checksum.into(),
            content_byte_size: None,
            storage_uri: None,
            parent_resource_id,
            entity_types: None,
            language: None,
            creator: None,
            was_attributed_to: None,
        }
    }
}

schema!(ResourceClonedPayload);

/// Payload for yield:created domain event
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct ResourceCreatedPayload {
    pub name: String,
    pub format: ContentFormat,
    /// SHA-256 of content
    #[serde(rename = "contentChecksum")]
    pub content_checksum: String,
    #[serde(rename = "contentByteSize")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub content_byte_size: Option<i64>,
    #[serde(rename = "entityTypes")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_types: Option<Vec<String>>,
    /// The creating instruction's URI, recorded on the event. Append-only, so this value never changes — the LOCATION the projection serves is maintained across moves and lives on the resource's primary Representation, relocated by yield:moved. Optional: a resource may have no bytes. Working-tree URI, only file:// is supported (e.g. file://docs/overview.md).
    #[serde(rename = "storageUri")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub storage_uri: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub language: Option<String>,
    #[serde(rename = "isDraft")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub is_draft: Option<bool>,
    /// The job this resource was made in fulfilment of, when its create cited one. A write that cites the same job on this resource, by the one who made it, is attributed to that job's requester: the `creator` here.
    #[serde(rename = "jobId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub job_id: Option<JobId>,
    /// What this resource was generated from: the resource, and the annotation on it when the generation was for one. The resource's descriptor names the resource as `wasDerivedFrom`.
    #[serde(rename = "generatedFrom")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub generated_from: Option<ResourceCreatedPayloadGeneratedFrom>,
    #[serde(rename = "generationPrompt")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub generation_prompt: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub generator: Option<OneOrMoreAgents>,
    /// Who requested this resource — derived by the knowledge base at write time, never sent by the emitter. For a resource created in fulfilment of a job, the requester recorded on that job's job:assigned; otherwise the emitter itself. Absent on events written before derivation existed, whose emitter was their only party.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub creator: Option<Agent>,
    /// PROV-O wasAttributedTo, derived at write time from `creator` and the executor: both parties when they differ, one when they are the same. The value the resource view carries; readers do not re-derive it.
    #[serde(rename = "wasAttributedTo")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub was_attributed_to: Option<OneOrMoreAgents>,
}

impl ResourceCreatedPayload {
    /// The `ResourceCreatedPayload` that states these and nothing else.
    pub fn new(
        name: impl Into<String>,
        format: ContentFormat,
        content_checksum: impl Into<String>,
    ) -> Self {
        Self {
            name: name.into(),
            format,
            content_checksum: content_checksum.into(),
            content_byte_size: None,
            entity_types: None,
            storage_uri: None,
            language: None,
            is_draft: None,
            job_id: None,
            generated_from: None,
            generation_prompt: None,
            generator: None,
            creator: None,
            was_attributed_to: None,
        }
    }
}

schema!(ResourceCreatedPayload);

/// What this resource was generated from: the resource, and the annotation on it when the generation was for one. The resource's descriptor names the resource as `wasDerivedFrom`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct ResourceCreatedPayloadGeneratedFrom {
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    #[serde(rename = "annotationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotation_id: Option<AnnotationId>,
}

impl ResourceCreatedPayloadGeneratedFrom {
    /// The `ResourceCreatedPayloadGeneratedFrom` that states these and nothing else.
    pub fn new(resource_id: ResourceId) -> Self {
        Self {
            resource_id,
            annotation_id: None,
        }
    }
}

/// Metadata about a resource (1:1 with its URI). JSON-LD subject is @id. Link to concrete bytes via representations.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct ResourceDescriptor {
    /// JSON-LD context; URI, object, or array of these.
    #[serde(rename = "@context")]
    pub context: ResourceDescriptorContext,
    /// The id of the resource being described.
    #[serde(rename = "@id")]
    pub id: ResourceId,
    /// Type(s) of the resource (IRIs/CURIEs via @context).
    #[serde(rename = "@type")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub r#type: Option<OneOrMoreStrings>,
    pub name: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub description: Option<String>,
    /// Persistent identifiers (e.g., DOI, URN).
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub identifier: Option<ResourceDescriptorIdentifier>,
    /// Topics (IRIs or strings).
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub about: Option<OneOrMoreStrings>,
    /// Equivalent/authoritative references.
    #[serde(rename = "sameAs")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub same_as: Option<Vec<String>>,
    #[serde(rename = "isPartOf")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub is_part_of: Option<Vec<String>>,
    #[serde(rename = "hasPart")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub has_part: Option<Vec<String>>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub license: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub version: Option<String>,
    #[serde(rename = "dateCreated")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub date_created: Option<String>,
    #[serde(rename = "dateModified")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub date_modified: Option<String>,
    /// W3C PROV: the resource, or resources, this one was derived from, each by its id
    #[serde(rename = "wasDerivedFrom")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub was_derived_from: Option<ResourceDescriptorWasDerivedFrom>,
    /// W3C PROV — every party responsible for this resource, derived by the knowledge base at creation from verified identities: `[requester, generator]` for a resource a job produced, collapsed to the one agent when the requester produced it. Never accepted from an emitter.
    #[serde(rename = "wasAttributedTo")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub was_attributed_to: Option<OneOrMoreAgents>,
    /// Software peer that produced this resource (W3C Web Annotation model). Its identity is the verified emitter of the create; the parameters are the producer's to state.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub generator: Option<OneOrMoreAgents>,
    /// Profile/shape URI this resource description conforms to.
    #[serde(rename = "conformsTo")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub conforms_to: Option<OneOrMoreUris>,
    /// Convenience set summarizing media types across representations.
    #[serde(rename = "availableFormats")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub available_formats: Option<Vec<String>>,
    /// Managed or referenced byte-level renditions of this resource.
    pub representations: ResourceDescriptorRepresentations,
    /// Application-specific: Whether this resource is archived
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub archived: Option<bool>,
    /// Application-specific: Entity types for this resource
    #[serde(rename = "entityTypes")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_types: Option<Vec<String>>,
    /// Application-specific: Whether this resource is a draft
    #[serde(rename = "isDraft")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub is_draft: Option<bool>,
    /// Application-specific: ID of annotation that triggered generation
    #[serde(rename = "sourceAnnotationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub source_annotation_id: Option<AnnotationId>,
    /// Application-specific: ID of source resource for clones/derivatives
    #[serde(rename = "sourceResourceId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub source_resource_id: Option<ResourceId>,
    /// Original URI from a source knowledge base when this resource was imported
    #[serde(rename = "originatedFrom")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub originated_from: Option<String>,
    /// Every property the schema does not name, as it came.
    #[serde(flatten)]
    pub rest: serde_json::Map<String, serde_json::Value>,
}

impl ResourceDescriptor {
    /// The `ResourceDescriptor` that states these and nothing else.
    pub fn new(
        context: ResourceDescriptorContext,
        id: ResourceId,
        name: impl Into<String>,
        representations: ResourceDescriptorRepresentations,
    ) -> Self {
        Self {
            context,
            id,
            r#type: None,
            name: name.into(),
            description: None,
            identifier: None,
            about: None,
            same_as: None,
            is_part_of: None,
            has_part: None,
            license: None,
            version: None,
            date_created: None,
            date_modified: None,
            was_derived_from: None,
            was_attributed_to: None,
            generator: None,
            conforms_to: None,
            available_formats: None,
            representations,
            archived: None,
            entity_types: None,
            is_draft: None,
            source_annotation_id: None,
            source_resource_id: None,
            originated_from: None,
            rest: serde_json::Map::new(),
        }
    }
}

schema!(ResourceDescriptor);

/// JSON-LD context; URI, object, or array of these.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum ResourceDescriptorContext {
    Text(String),
    Object(serde_json::Map<String, serde_json::Value>),
    List(Vec<ResourceDescriptorContextItem>),
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum ResourceDescriptorContextItem {
    Text(String),
    Object(serde_json::Map<String, serde_json::Value>),
}

/// Persistent identifiers (e.g., DOI, URN).
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum ResourceDescriptorIdentifier {
    Text(String),
    List(Vec<String>),
    Object(ResourceDescriptorIdentifierObject),
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct ResourceDescriptorIdentifierObject {
    #[serde(rename = "@id")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub id: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub value: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub scheme: Option<String>,
    /// Every property the schema does not name, as it came.
    #[serde(flatten)]
    pub rest: serde_json::Map<String, serde_json::Value>,
}

/// Managed or referenced byte-level renditions of this resource.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum ResourceDescriptorRepresentations {
    Representation(Representation),
    List(Vec<Representation>),
}

member!(ResourceDescriptorRepresentations::Representation(
    Representation,
));

/// W3C PROV: the resource, or resources, this one was derived from, each by its id
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum ResourceDescriptorWasDerivedFrom {
    ResourceId(ResourceId),
    List(Vec<ResourceId>),
}

/// A client-local notice that a command on a resource failed, for a UI to show: the payload of `mark:create-error`, `mark:delete-error` and `bind:body-error`. Emitted by the caller that awaited the command, which knows whose command failed on which resource. The `*-failed` wire replies are correlation plumbing and are not for this.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct ResourceErrorEvent {
    /// The resource the command addressed.
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// Human-readable error message.
    pub message: String,
}

schema!(ResourceErrorEvent);

/// A resource's id: a name, never the resource's URI or a path. 1 to 128 of the letters `A`–`Z` and `a`–`z`, the digits, `_` and `-`. It is one segment of a URL and one name in a file system, and it is held to that wherever it enters: a gateway refuses a payload that carries anything else. How one is made is no part of the rule. `__system__` is the one that names no resource: the scope events about the knowledge base itself are logged under.
#[derive(
    Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
#[serde(try_from = "String", into = "String")]
pub struct ResourceId(String);

impl ResourceId {
    /// The rule a value is held to, as the spec writes it.
    pub const PATTERN: &'static str = "^[A-Za-z0-9_-]{1,128}$";

    /// The pattern as the rule `new` holds a value to.
    const RULE: Rule = Rule {
        prefix: "",
        admitted: Admitted::Of(&[('A', 'Z'), ('a', 'z'), ('0', '9'), ('_', '_'), ('-', '-')]),
        least: 1,
        most: Some(128),
    };

    /// `value` as a `ResourceId`, or that it is not one.
    pub fn new(value: impl Into<String>) -> Result<ResourceId, InvalidIdentifier> {
        let value = value.into();
        if ResourceId::RULE.admits(&value) {
            Ok(ResourceId(value))
        } else {
            Err(InvalidIdentifier {
                kind: "ResourceId",
                pattern: ResourceId::PATTERN,
                value,
            })
        }
    }

    pub fn as_str(&self) -> &str {
        &self.0
    }
}

impl std::fmt::Display for ResourceId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(&self.0)
    }
}

impl std::ops::Deref for ResourceId {
    type Target = str;

    fn deref(&self) -> &str {
        &self.0
    }
}

impl AsRef<str> for ResourceId {
    fn as_ref(&self) -> &str {
        &self.0
    }
}

impl std::str::FromStr for ResourceId {
    type Err = InvalidIdentifier;

    fn from_str(value: &str) -> Result<ResourceId, InvalidIdentifier> {
        ResourceId::new(value)
    }
}

impl TryFrom<String> for ResourceId {
    type Error = InvalidIdentifier;

    fn try_from(value: String) -> Result<ResourceId, InvalidIdentifier> {
        ResourceId::new(value)
    }
}

impl From<ResourceId> for String {
    fn from(id: ResourceId) -> String {
        id.0
    }
}

impl PartialEq<str> for ResourceId {
    fn eq(&self, other: &str) -> bool {
        self.0 == other
    }
}

impl PartialEq<&str> for ResourceId {
    fn eq(&self, other: &&str) -> bool {
        self.0 == *other
    }
}

schema!(ResourceId);

/// Payload for yield:moved domain event
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct ResourceMovedPayload {
    /// Previous file:// URI
    #[serde(rename = "fromUri")]
    pub from_uri: String,
    /// New file:// URI
    #[serde(rename = "toUri")]
    pub to_uri: String,
}

schema!(ResourceMovedPayload);

/// What a text search for resources is told beside its text: MatchResourcesRequest's other members. client/surface.json's `match.resources` cases state what is sent for one left out.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ResourceSearchFilters {
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub archived: Option<bool>,
    #[serde(rename = "entityType")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_type: Option<String>,
    /// How many of the resources the search finds are passed over before the page begins.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub offset: Option<u64>,
    /// The most resources a page has.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub limit: Option<u16>,
}

schema!(ResourceSearchFilters);

/// Payload for mark:unarchived domain event (empty payload)
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct ResourceUnarchivedPayload {}

schema!(ResourceUnarchivedPayload);

/// Payload for yield:updated domain event
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct ResourceUpdatedPayload {
    /// SHA-256 of new content
    #[serde(rename = "contentChecksum")]
    pub content_checksum: String,
    #[serde(rename = "contentByteSize")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub content_byte_size: Option<i64>,
}

impl ResourceUpdatedPayload {
    /// The `ResourceUpdatedPayload` that states these and nothing else.
    pub fn new(content_checksum: impl Into<String>) -> Self {
        Self {
            content_checksum: content_checksum.into(),
            content_byte_size: None,
        }
    }
}

schema!(ResourceUpdatedPayload);

/// The multipart upload that creates a resource. A client sends it to the gateway's `POST /resources`; the gateway forwards it untouched to the Archivist's `POST /resources`, which stores the bytes and records the resource. One body, two hops.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct ResourceUpload {
    /// Human-readable resource name
    pub name: String,
    /// Binary content
    pub file: String,
    /// Media type of the content (e.g. text/plain, text/markdown, image/png)
    pub format: String,
    /// Where the content lives (file://... for local). Required — the client names the location; the server does not derive one.
    #[serde(rename = "storageUri")]
    pub storage_uri: String,
    /// ISO 639-1 language code
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub language: Option<String>,
    /// JSON-stringified array of entity type names
    #[serde(rename = "entityTypes")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_types: Option<String>,
    /// For AI-generated resources: the annotation that triggered generation. Nested into generatedFrom.annotationId on the persisted event.
    #[serde(rename = "sourceAnnotationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub source_annotation_id: Option<AnnotationId>,
    /// For AI-generated resources: the source resource the generating annotation lives on. Nested into generatedFrom.resourceId on the persisted event.
    #[serde(rename = "sourceResourceId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub source_resource_id: Option<ResourceId>,
    /// For AI-generated resources: the prompt that drove generation
    #[serde(rename = "generationPrompt")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub generation_prompt: Option<String>,
    /// For AI-generated resources: JSON-stringified Agent naming the model/worker that produced the content. Its identity must be the uploading agent's own — the knowledge base refuses a generator naming anyone else. `creator` and `wasAttributedTo` are never sent; the knowledge base derives them from the cited job.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub generator: Option<String>,
    /// The job this resource fulfils, when a worker is creating it. Forwarded onto yield:create; the knowledge base derives who requested the resource from the cited job's own events, and refuses a worker-role create that cites none. Absent for a person's own upload.
    #[serde(rename = "jobId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub job_id: Option<JobId>,
    /// 'true' or 'false' — whether the resource is a draft
    #[serde(rename = "isDraft")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub is_draft: Option<String>,
    /// A clone token from `yield:clone-token-requested`. With it, the resource is created as a clone of the token's source, inheriting its entity types; `language`, `entityTypes` and the generation fields are then not read.
    #[serde(rename = "cloneToken")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub clone_token: Option<String>,
    /// With `cloneToken`: 'true' archives the source once the clone exists.
    #[serde(rename = "archiveOriginal")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub archive_original: Option<String>,
}

impl ResourceUpload {
    /// The `ResourceUpload` that states these and nothing else.
    pub fn new(
        name: impl Into<String>,
        file: impl Into<String>,
        format: impl Into<String>,
        storage_uri: impl Into<String>,
    ) -> Self {
        Self {
            name: name.into(),
            file: file.into(),
            format: format.into(),
            storage_uri: storage_uri.into(),
            language: None,
            entity_types: None,
            source_annotation_id: None,
            source_resource_id: None,
            generation_prompt: None,
            generator: None,
            job_id: None,
            is_draft: None,
            clone_token: None,
            archive_original: None,
        }
    }
}

schema!(ResourceUpload);

/// A resource's materialized view: the file the Archivist writes at `resources/<ab>/<cd>/<resourceId>.json` under the knowledge base's state directory, and every reader of that file reads. It is what the resource's events add up to, and is rebuilt from the event log whenever it is missing. Written as JSON indented by two spaces, by writing a sibling temporary file and renaming it onto the path, so a reader sees a whole document or none.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ResourceView {
    pub resource: ResourceDescriptor,
    pub annotations: ResourceAnnotations,
    /// The sequence number of the last event applied. A graph read that follows a write waits for the graph projection to reach it.
    #[serde(rename = "lastSequence")]
    pub last_sequence: u64,
}

schema!(ResourceView);

/// What a container is given, in Kubernetes' spelling.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct Resources {
    /// The most a container may use.
    pub limits: ResourcesLimits,
}

schema!(Resources);

/// The most a container may use.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ResourcesLimits {
    /// The memory ceiling: a whole number of gigabytes or megabytes, `8G` or `512M`.
    pub memory: String,
}

/// One knowledge base this machine knows: a registered or running local clone, or a codespace stack recorded here. Registration, the directory, the stack and the forward are separate facts, each stated as it is.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct Root {
    /// Where the stack actually runs. "local": containers on this machine. "codespace": a GitHub-hosted VM whose KB is port-forwarded here.
    pub placement: RootPlacement,
    /// For a local root: the clone's path.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub path: Option<String>,
    /// For a local root: whether the directory exists. A registered root whose directory is gone is kept, and says so.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub present: Option<bool>,
    /// For a local root: how the control server's own directory selects it, when it does — standing in it (cwd), or XYNOLOG_ROOT.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub current: Option<RootCurrent>,
    /// Whether the registry (roots.json) records it.
    pub registered: bool,
    /// Whether a stack of it is recorded on this machine.
    pub running: bool,
    /// When a command last used it, in RFC 3339, as the registry records it.
    #[serde(rename = "lastUsed")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub last_used: Option<String>,
    /// The KB's did:web identifier, from its committed .xynolog/config.yaml — "did:web:" + its site.domain, verbatim. REQUIRED: a KB that declares no domain has no identity to publish, and the launcher refuses to start it rather than inventing or defaulting one. NOT unique within a document: a did names the knowledge base, not a running copy of it, so a local clone and a codespace of the same repo legitimately share one and both are published. host:port is the unique field (at most one entry per address), so consumers look up by ADDRESS and use the did to VERIFY that the copy they reached is the KB they meant — an address alone cannot say which KB is which, and an identity alone cannot say which copy.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub did: Option<String>,
    /// Human-readable site name from the KB's .xynolog/config.yaml (site.siteName), for display
    #[serde(rename = "siteName")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub site_name: Option<String>,
    /// Why its identity could not be read from its clone, when it could not.
    #[serde(rename = "identityError")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub identity_error: Option<String>,
    /// The Inference document a start of it runs, as the registry records it.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub config: Option<String>,
    /// For a present local root: the Inference documents its clone has, as start --config names them.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub configs: Option<Vec<String>>,
    /// owner/name GitHub slug — present for codespace placements, where the repo is the stack's identity
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub repo: Option<String>,
    /// For a codespace root: the codespace's name.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub codespace: Option<String>,
    /// For a codespace root: GitHub's word for the codespace's state (Available, Shutdown), when gh answered.
    #[serde(rename = "codespaceState")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub codespace_state: Option<String>,
    /// For a codespace root: the port on this machine its knowledge base is forwarded to, when one is recorded.
    #[serde(rename = "forwardPort")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub forward_port: Option<i64>,
    /// For a codespace root: whether the recorded forward is alive.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub forwarded: Option<bool>,
    /// For a codespace root: whether its knowledge base answers through the forward.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub reachable: Option<bool>,
}

impl Root {
    /// The `Root` that states these and nothing else.
    pub fn new(placement: RootPlacement, registered: bool, running: bool) -> Self {
        Self {
            placement,
            path: None,
            present: None,
            current: None,
            registered,
            running,
            last_used: None,
            did: None,
            site_name: None,
            identity_error: None,
            config: None,
            configs: None,
            repo: None,
            codespace: None,
            codespace_state: None,
            forward_port: None,
            forwarded: None,
            reachable: None,
        }
    }
}

schema!(Root);

/// For a local root: how the control server's own directory selects it, when it does — standing in it (cwd), or XYNOLOG_ROOT.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum RootCurrent {
    #[serde(rename = "cwd")]
    Cwd,
    #[serde(rename = "xynolog-root")]
    XynologRoot,
}

impl RootCurrent {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            RootCurrent::Cwd => "cwd",
            RootCurrent::XynologRoot => "xynolog-root",
        }
    }
}

/// Where the stack actually runs. "local": containers on this machine. "codespace": a GitHub-hosted VM whose KB is port-forwarded here.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum RootPlacement {
    #[serde(rename = "local")]
    Local,
    #[serde(rename = "codespace")]
    Codespace,
}

impl RootPlacement {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            RootPlacement::Local => "local",
            RootPlacement::Codespace => "codespace",
        }
    }
}

/// roots.forget's params.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct RootsForgetParams {
    /// The version of the control API the request is written to.
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    /// The registered root to forget: its path, or its basename when only one registered root has it.
    pub root: String,
}

schema!(RootsForgetParams);

/// A forgotten registry row. Only the row is removed: no file of the clone, and none of its persistent stack state.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct RootsForgetResult {
    /// The forgotten root's path.
    pub path: String,
    /// Whether its directory was already gone.
    #[serde(rename = "directoryMissing")]
    pub directory_missing: bool,
    /// The key whose persistent stack state remains, when some does and no surviving root shares its DID: xynolog clean --root <key> removes it.
    #[serde(rename = "persistentState")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub persistent_state: Option<String>,
}

impl RootsForgetResult {
    /// The `RootsForgetResult` that states these and nothing else.
    pub fn new(path: impl Into<String>, directory_missing: bool) -> Self {
        Self {
            path: path.into(),
            directory_missing,
            persistent_state: None,
        }
    }
}

schema!(RootsForgetResult);

/// roots.init's params: the local directory, permanent identity, and optional configuration inputs xynolog init takes.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct RootsInitParams {
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    /// Existing local directory in which to create the knowledge base.
    pub path: String,
    /// The permanent did:web domain, in colon-path form, such as owner.github.io:repo.
    pub domain: String,
    /// Project name. Absent: the directory basename.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub name: Option<String>,
    /// Human-readable site name. Absent: the project name.
    #[serde(rename = "siteName")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub site_name: Option<String>,
    /// Inference provider for the generated local stack documents.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub inference: Option<RootsInitParamsInference>,
    /// The primary model bound to roles and jobs.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub model: Option<String>,
    /// A light model example emitted in the generated config.
    #[serde(rename = "modelLight")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub model_light: Option<String>,
    /// Ollama embedding model name, without the ollama: prefix.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub embedding: Option<String>,
    /// Inference document name. Absent: the provider name.
    #[serde(rename = "configName")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub config_name: Option<String>,
    /// Anthropic API base URL.
    #[serde(rename = "anthropicEndpoint")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub anthropic_endpoint: Option<String>,
    /// Local Ollama API base URL.
    #[serde(rename = "ollamaBase")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub ollama_base: Option<String>,
    /// Ollama registry base URL.
    #[serde(rename = "ollamaRegistry")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub ollama_registry: Option<String>,
}

impl RootsInitParams {
    /// The `RootsInitParams` that states these and nothing else.
    pub fn new(
        api_version: ApiVersion,
        path: impl Into<String>,
        domain: impl Into<String>,
    ) -> Self {
        Self {
            api_version,
            path: path.into(),
            domain: domain.into(),
            name: None,
            site_name: None,
            inference: None,
            model: None,
            model_light: None,
            embedding: None,
            config_name: None,
            anthropic_endpoint: None,
            ollama_base: None,
            ollama_registry: None,
        }
    }
}

schema!(RootsInitParams);

/// Inference provider for the generated local stack documents.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum RootsInitParamsInference {
    #[serde(rename = "anthropic")]
    Anthropic,
    #[serde(rename = "ollama")]
    Ollama,
}

impl RootsInitParamsInference {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            RootsInitParamsInference::Anthropic => "anthropic",
            RootsInitParamsInference::Ollama => "ollama",
        }
    }
}

/// The local directory where xynolog init created and registered the knowledge base.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct RootsInitResult {
    pub path: String,
}

schema!(RootsInitResult);

/// roots.list's params.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct RootsListParams {
    /// The version of the control API the request is written to.
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
}

schema!(RootsListParams);

/// Every knowledge base this machine knows, as xynolog roots lists them: the local roots first, then the codespace stacks.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct RootsListResult {
    /// Each root.
    pub roots: Vec<Root>,
    /// What xynolog roots warns of without failing: an invalid XYNOLOG_ROOT, a clone whose project file is refused.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub warnings: Option<Vec<String>>,
}

impl RootsListResult {
    /// The `RootsListResult` that states these and nothing else.
    pub fn new(roots: Vec<Root>) -> Self {
        Self {
            roots,
            warnings: None,
        }
    }
}

schema!(RootsListResult);

/// A run's instance, by the name its caller gave it: unique among the target's instances that run on this machine. A second dispatcher beside the first is another instance. The launcher names the instance's container from the target's key and this name.
pub type RunInstance = String;

/// One of a knowledge base's own services, which service.run runs: the seven Xynolog services, as service-telemetry/telemetry.json names them. The reader holds the two lists to each other.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum RunService {
    #[serde(rename = "archivist")]
    Archivist,
    #[serde(rename = "dispatcher")]
    Dispatcher,
    #[serde(rename = "gateway")]
    Gateway,
    #[serde(rename = "librarian")]
    Librarian,
    #[serde(rename = "smelter")]
    Smelter,
    #[serde(rename = "weaver")]
    Weaver,
    #[serde(rename = "worker")]
    Worker,
}

impl RunService {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            RunService::Archivist => "archivist",
            RunService::Dispatcher => "dispatcher",
            RunService::Gateway => "gateway",
            RunService::Librarian => "librarian",
            RunService::Smelter => "smelter",
            RunService::Weaver => "weaver",
            RunService::Worker => "worker",
        }
    }
}

schema!(RunService);

/// Who runs a daemon: the launcher, from `image` with `resources`, or somebody else, reached at `external`. Exactly one of the two.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct Runner {}

schema!(Runner);

/// A container runtime the launcher drives, as --runtime names it: Apple container, Docker or Podman.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum Runtime {
    #[serde(rename = "container")]
    Container,
    #[serde(rename = "docker")]
    Docker,
    #[serde(rename = "podman")]
    Podman,
}

impl Runtime {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            Runtime::Container => "container",
            Runtime::Docker => "docker",
            Runtime::Podman => "podman",
        }
    }
}

schema!(Runtime);

/// One container runtime the launcher drives, and whether this machine has it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct RuntimeState {
    pub name: Runtime,
    /// Whether it is on the launcher's PATH.
    pub found: bool,
}

schema!(RuntimeState);

/// A resource returned by a search, carrying its relevance score and the reason it matched.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct ScoredResource {
    /// JSON-LD context; URI, object, or array of these.
    #[serde(rename = "@context")]
    pub context: ResourceDescriptorContext,
    /// The id of the resource being described.
    #[serde(rename = "@id")]
    pub id: ResourceId,
    /// Type(s) of the resource (IRIs/CURIEs via @context).
    #[serde(rename = "@type")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub r#type: Option<OneOrMoreStrings>,
    pub name: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub description: Option<String>,
    /// Persistent identifiers (e.g., DOI, URN).
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub identifier: Option<ResourceDescriptorIdentifier>,
    /// Topics (IRIs or strings).
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub about: Option<OneOrMoreStrings>,
    /// Equivalent/authoritative references.
    #[serde(rename = "sameAs")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub same_as: Option<Vec<String>>,
    #[serde(rename = "isPartOf")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub is_part_of: Option<Vec<String>>,
    #[serde(rename = "hasPart")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub has_part: Option<Vec<String>>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub license: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub version: Option<String>,
    #[serde(rename = "dateCreated")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub date_created: Option<String>,
    #[serde(rename = "dateModified")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub date_modified: Option<String>,
    /// W3C PROV: the resource, or resources, this one was derived from, each by its id
    #[serde(rename = "wasDerivedFrom")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub was_derived_from: Option<ResourceDescriptorWasDerivedFrom>,
    /// W3C PROV — every party responsible for this resource, derived by the knowledge base at creation from verified identities: `[requester, generator]` for a resource a job produced, collapsed to the one agent when the requester produced it. Never accepted from an emitter.
    #[serde(rename = "wasAttributedTo")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub was_attributed_to: Option<OneOrMoreAgents>,
    /// Software peer that produced this resource (W3C Web Annotation model). Its identity is the verified emitter of the create; the parameters are the producer's to state.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub generator: Option<OneOrMoreAgents>,
    /// Profile/shape URI this resource description conforms to.
    #[serde(rename = "conformsTo")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub conforms_to: Option<OneOrMoreUris>,
    /// Convenience set summarizing media types across representations.
    #[serde(rename = "availableFormats")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub available_formats: Option<Vec<String>>,
    /// Managed or referenced byte-level renditions of this resource.
    pub representations: ResourceDescriptorRepresentations,
    /// Application-specific: Whether this resource is archived
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub archived: Option<bool>,
    /// Application-specific: Entity types for this resource
    #[serde(rename = "entityTypes")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_types: Option<Vec<String>>,
    /// Application-specific: Whether this resource is a draft
    #[serde(rename = "isDraft")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub is_draft: Option<bool>,
    /// Application-specific: ID of annotation that triggered generation
    #[serde(rename = "sourceAnnotationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub source_annotation_id: Option<AnnotationId>,
    /// Application-specific: ID of source resource for clones/derivatives
    #[serde(rename = "sourceResourceId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub source_resource_id: Option<ResourceId>,
    /// Original URI from a source knowledge base when this resource was imported
    #[serde(rename = "originatedFrom")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub originated_from: Option<String>,
    /// Relevance score assigned by the matcher; higher is a better candidate.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub score: Option<f64>,
    /// Human-readable reason for the match.
    #[serde(rename = "matchReason")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub match_reason: Option<String>,
    /// Every property the schema does not name, as it came.
    #[serde(flatten)]
    pub rest: serde_json::Map<String, serde_json::Value>,
}

impl ScoredResource {
    /// The `ScoredResource` that states these and nothing else.
    pub fn new(
        context: ResourceDescriptorContext,
        id: ResourceId,
        name: impl Into<String>,
        representations: ResourceDescriptorRepresentations,
    ) -> Self {
        Self {
            context,
            id,
            r#type: None,
            name: name.into(),
            description: None,
            identifier: None,
            about: None,
            same_as: None,
            is_part_of: None,
            has_part: None,
            license: None,
            version: None,
            date_created: None,
            date_modified: None,
            was_derived_from: None,
            was_attributed_to: None,
            generator: None,
            conforms_to: None,
            available_formats: None,
            representations,
            archived: None,
            entity_types: None,
            is_draft: None,
            source_annotation_id: None,
            source_resource_id: None,
            originated_from: None,
            score: None,
            match_reason: None,
            rest: serde_json::Map::new(),
        }
    }
}

schema!(ScoredResource);

/// A secret the document names and does not hold. The launcher hands it to the service that needs it, from where the reference says it is.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SecretRef {
    /// The environment variable that holds the secret where the launcher runs. Unset, the start that needs it is refused.
    #[serde(rename = "fromEnv")]
    pub from_env: String,
}

schema!(SecretRef);

/// One W3C selector: a way of finding a segment of a resource. Tell them apart by `type`, which is required on each and single-valued.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Serialize)]
#[serde(untagged)]
pub enum Selector {
    TextPositionSelector(TextPositionSelector),
    TextQuoteSelector(TextQuoteSelector),
    SvgSelector(SvgSelector),
    FragmentSelector(FragmentSelector),
}

impl<'de> serde::Deserialize<'de> for Selector {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("type").and_then(serde_json::Value::as_str) {
            Some("TextPositionSelector") => {
                serde_json::from_value(value).map(Selector::TextPositionSelector)
            }
            Some("TextQuoteSelector") => {
                serde_json::from_value(value).map(Selector::TextQuoteSelector)
            }
            Some("SvgSelector") => serde_json::from_value(value).map(Selector::SvgSelector),
            Some("FragmentSelector") => {
                serde_json::from_value(value).map(Selector::FragmentSelector)
            }
            _ => {
                return Err(serde::de::Error::custom(
                    "a Selector states a `type` that is one of `TextPositionSelector`, `TextQuoteSelector`, `SvgSelector`, `FragmentSelector`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

member!(Selector::TextPositionSelector(TextPositionSelector));
member!(Selector::TextQuoteSelector(TextQuoteSelector));
member!(Selector::SvgSelector(SvgSelector));
member!(Selector::FragmentSelector(FragmentSelector));
schema!(Selector);

#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct SemanticMatch {
    /// The chunk text that matched
    pub text: String,
    /// Source resource ID
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// The source resource's display name, resolved from its view at gather time. Required: a match card must name its source, and corpus matches routinely come from outside the graph neighborhood, so there is no node to borrow a name from. A match whose source no longer resolves to a view is dropped by the producer rather than served nameless.
    #[serde(rename = "resourceName")]
    pub resource_name: String,
    /// Source annotation ID, if the match is from an annotation
    #[serde(rename = "annotationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotation_id: Option<AnnotationId>,
    /// Cosine similarity score (0-1)
    pub score: f64,
    /// Entity types on the matched passage
    #[serde(rename = "entityTypes")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_types: Option<Vec<String>>,
    /// True when this passage's text was recognized from pixels (OCR of a scanned page) rather than read from the document. Absent means read directly — the common case — so the flag is only present where it changes how the text should be trusted. It travels with the passage because a consumer receives the chunk with no document attached and cannot recompute how the text was obtained.
    #[serde(rename = "machineRead")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub machine_read: Option<bool>,
}

impl SemanticMatch {
    /// The `SemanticMatch` that states these and nothing else.
    pub fn new(
        text: impl Into<String>,
        resource_id: ResourceId,
        resource_name: impl Into<String>,
        score: f64,
    ) -> Self {
        Self {
            text: text.into(),
            resource_id,
            resource_name: resource_name.into(),
            annotation_id: None,
            score,
            entity_types: None,
            machine_read: None,
        }
    }
}

schema!(SemanticMatch);

/// The host and port a service listens at.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceAddress {
    pub host: String,
    pub port: u16,
}

schema!(ServiceAddress);

/// service-environment/boot-refusals.json: what a service writes when it refuses to start on its configuration document or its environment.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceEnvironmentBootRefusals {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    /// The services that refuse to start so.
    pub services: Vec<ServiceEnvironmentBootRefusalsServicesItem>,
    /// The one line the service writes to stderr, its refusal in place of `{refusal}`, before it exits.
    pub line: String,
    /// The status it exits with.
    #[serde(rename = "exitCode")]
    pub exit_code: u16,
    /// Each refusal.
    pub refusals: Vec<ServiceEnvironmentBootRefusalsRefusalsItem>,
    /// Each line of the refusal `invalid`: one for each way the document is not its schema's.
    pub members: Vec<ServiceEnvironmentBootRefusalsMembersItem>,
}

schema!(ServiceEnvironmentBootRefusals);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceEnvironmentBootRefusalsMembersItem {
    /// The situation's name.
    pub name: String,
    /// When it is written, and what fills each `{name}` of its text.
    pub situation: String,
    /// The line, filled as the row's `situation` says.
    pub line: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceEnvironmentBootRefusalsRefusalsItem {
    /// The situation's name.
    pub name: String,
    /// When it is written, and what fills each `{name}` of its text.
    pub situation: String,
    /// Its text. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.
    pub refusal: String,
}

/// A Xynolog service, by its name.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ServiceEnvironmentBootRefusalsServicesItem {
    #[serde(rename = "archivist")]
    Archivist,
    #[serde(rename = "dispatcher")]
    Dispatcher,
    #[serde(rename = "gateway")]
    Gateway,
    #[serde(rename = "librarian")]
    Librarian,
    #[serde(rename = "smelter")]
    Smelter,
    #[serde(rename = "weaver")]
    Weaver,
    #[serde(rename = "worker")]
    Worker,
}

impl ServiceEnvironmentBootRefusalsServicesItem {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ServiceEnvironmentBootRefusalsServicesItem::Archivist => "archivist",
            ServiceEnvironmentBootRefusalsServicesItem::Dispatcher => "dispatcher",
            ServiceEnvironmentBootRefusalsServicesItem::Gateway => "gateway",
            ServiceEnvironmentBootRefusalsServicesItem::Librarian => "librarian",
            ServiceEnvironmentBootRefusalsServicesItem::Smelter => "smelter",
            ServiceEnvironmentBootRefusalsServicesItem::Weaver => "weaver",
            ServiceEnvironmentBootRefusalsServicesItem::Worker => "worker",
        }
    }
}

/// service-environment/variables.json: every environment variable a Xynolog service reads, beside its configuration document.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceEnvironmentVariables {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    pub variables: Vec<ServiceEnvironmentVariablesVariablesItem>,
}

schema!(ServiceEnvironmentVariables);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceEnvironmentVariablesVariablesItem {
    /// The variable's name.
    pub name: String,
    /// The services that read it.
    pub services: Vec<ServiceEnvironmentVariablesVariablesItemServicesItem>,
    /// What reads it: the service's own code, or the OpenTelemetry SDK.
    #[serde(rename = "readBy")]
    pub read_by: ServiceEnvironmentVariablesVariablesItemReadBy,
    /// What sets it where the launcher runs the service.
    #[serde(rename = "providedBy")]
    pub provided_by: ServiceEnvironmentVariablesVariablesItemProvidedBy,
    /// Whether the service refuses to start without it.
    pub required: bool,
    /// What it does.
    pub effect: String,
}

/// What sets it where the launcher runs the service.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ServiceEnvironmentVariablesVariablesItemProvidedBy {
    #[serde(rename = "launcher")]
    Launcher,
    #[serde(rename = "image")]
    Image,
    #[serde(rename = "operator")]
    Operator,
}

impl ServiceEnvironmentVariablesVariablesItemProvidedBy {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ServiceEnvironmentVariablesVariablesItemProvidedBy::Launcher => "launcher",
            ServiceEnvironmentVariablesVariablesItemProvidedBy::Image => "image",
            ServiceEnvironmentVariablesVariablesItemProvidedBy::Operator => "operator",
        }
    }
}

/// What reads it: the service's own code, or the OpenTelemetry SDK.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ServiceEnvironmentVariablesVariablesItemReadBy {
    #[serde(rename = "service")]
    Service,
    #[serde(rename = "opentelemetry")]
    Opentelemetry,
}

impl ServiceEnvironmentVariablesVariablesItemReadBy {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ServiceEnvironmentVariablesVariablesItemReadBy::Service => "service",
            ServiceEnvironmentVariablesVariablesItemReadBy::Opentelemetry => "opentelemetry",
        }
    }
}

/// A Xynolog service, by its name.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ServiceEnvironmentVariablesVariablesItemServicesItem {
    #[serde(rename = "archivist")]
    Archivist,
    #[serde(rename = "dispatcher")]
    Dispatcher,
    #[serde(rename = "gateway")]
    Gateway,
    #[serde(rename = "librarian")]
    Librarian,
    #[serde(rename = "smelter")]
    Smelter,
    #[serde(rename = "weaver")]
    Weaver,
    #[serde(rename = "worker")]
    Worker,
}

impl ServiceEnvironmentVariablesVariablesItemServicesItem {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ServiceEnvironmentVariablesVariablesItemServicesItem::Archivist => "archivist",
            ServiceEnvironmentVariablesVariablesItemServicesItem::Dispatcher => "dispatcher",
            ServiceEnvironmentVariablesVariablesItemServicesItem::Gateway => "gateway",
            ServiceEnvironmentVariablesVariablesItemServicesItem::Librarian => "librarian",
            ServiceEnvironmentVariablesVariablesItemServicesItem::Smelter => "smelter",
            ServiceEnvironmentVariablesVariablesItemServicesItem::Weaver => "weaver",
            ServiceEnvironmentVariablesVariablesItemServicesItem::Worker => "worker",
        }
    }
}

/// A group of services, as xynolog status reports them and --group names them: a knowledge base's record and its index, the issuer that signs its accounts in, the knowledge workers where people and agents work on it, the providers of its models, and the telemetry that watches them all.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ServiceGroup {
    #[serde(rename = "record")]
    Record,
    #[serde(rename = "index")]
    Index,
    #[serde(rename = "issuer")]
    Issuer,
    #[serde(rename = "knowledge-workers")]
    KnowledgeWorkers,
    #[serde(rename = "providers")]
    Providers,
    #[serde(rename = "telemetry")]
    Telemetry,
}

impl ServiceGroup {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ServiceGroup::Record => "record",
            ServiceGroup::Index => "index",
            ServiceGroup::Issuer => "issuer",
            ServiceGroup::KnowledgeWorkers => "knowledge-workers",
            ServiceGroup::Providers => "providers",
            ServiceGroup::Telemetry => "telemetry",
        }
    }
}

schema!(ServiceGroup);

/// service.host's params.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceHostParams {
    /// The version of the control API the request is written to.
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    /// The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else the first installed one.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub runtime: Option<Runtime>,
}

impl ServiceHostParams {
    /// The `ServiceHostParams` that states these and nothing else.
    pub fn new(api_version: ApiVersion) -> Self {
        Self {
            api_version,
            runtime: None,
        }
    }
}

schema!(ServiceHostParams);

/// Where this machine and a run's instance meet, under a runtime: the address the launcher publishes an instance's ports on, and the address the instance reaches this machine's listeners at. A caller writes it into a document before the run.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceHostResult {
    pub runtime: Runtime,
    /// The host address: an IP address or a host name, as the launcher's own stack dials it under this runtime.
    pub address: String,
}

schema!(ServiceHostResult);

/// The identity provider a service's account signs in at, by its issuer.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceIdentity {
    /// The issuer URL, exactly as tokens carry it in `iss`.
    pub issuer: String,
}

schema!(ServiceIdentity);

/// notifications/serviceOutput: one line a run's instance wrote, from its start, every line, in the order of its stream, as the instance wrote it. The launcher gives an instance none of its own secrets (R2), and keeps no copy.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceOutput {
    #[serde(rename = "requestId")]
    pub request_id: RequestId,
    pub instance: RunInstance,
    pub stream: OutputStream,
    /// The line, without its newline.
    pub line: String,
}

schema!(ServiceOutput);

/// service.run's params: one instance of one of a knowledge base's own services, run once from the image the target's stack documents name, unsupervised, on the caller's document, arguments and environment. contract/LAUNCHER-CONTROL.md, R1-R8.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceRunParams {
    /// The version of the control API the request is written to.
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    /// The knowledge base whose stack documents name the service's image, and whose stack the instance belongs to: stack.stop of it removes the instance too.
    pub target: LocalTarget,
    /// The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else the first installed one.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub runtime: Option<Runtime>,
    /// The service whose image runs.
    pub service: RunService,
    pub instance: RunInstance,
    /// The configuration document's text, written as it is, at the path the image's own arguments name: it need not be JSON. Absent: no file is at that path.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub document: Option<String>,
    /// The arguments the image's program is given in place of the image's own (--config and the document's path). Absent: the image's own.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub args: Option<Vec<String>>,
    /// Every variable the instance is given beside the image's own, by name: nothing of the launcher's is added (R2). Empty: none.
    pub environment: std::collections::BTreeMap<String, String>,
    /// Directories of this machine, each mounted read-write at its own path, so that a path the document names is the same inside the instance and out (R4). Empty: none.
    pub mounts: Vec<String>,
    /// Directories put before the image's PATH, in order, each mounted at its own path. Empty: the image's PATH as it is.
    #[serde(rename = "pathFirst")]
    pub path_first: Vec<String>,
    /// The ports the instance listens on, each published at the same number on the host address (R3). Empty: none.
    pub ports: Vec<u64>,
}

impl ServiceRunParams {
    /// The `ServiceRunParams` that states these and nothing else.
    #[allow(clippy::too_many_arguments)]
    pub fn new(
        api_version: ApiVersion,
        target: LocalTarget,
        service: RunService,
        instance: RunInstance,
        environment: std::collections::BTreeMap<String, String>,
        mounts: Vec<String>,
        path_first: Vec<String>,
        ports: Vec<u64>,
    ) -> Self {
        Self {
            api_version,
            target,
            runtime: None,
            service,
            instance,
            document: None,
            args: None,
            environment,
            mounts,
            path_first,
            ports,
        }
    }
}

schema!(ServiceRunParams);

/// A run that ended: its instance exited. Sent once the instance's container has exited, after all of its output.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceRunResult {
    pub instance: RunInstance,
    /// The instance's exit status: the service's own, since nothing supervises it (R1). An instance a signal ended exits with 128 and the signal's number: 143 for SIGTERM, 137 for SIGKILL.
    #[serde(rename = "exitCode")]
    pub exit_code: u64,
    /// Milliseconds from its container's start to its exit.
    #[serde(rename = "ranMs")]
    pub ran_ms: u64,
}

schema!(ServiceRunResult);

/// service.signal's params: a signal for a run's instance.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceSignalParams {
    /// The version of the control API the request is written to.
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    /// The knowledge base whose stack documents name the service's image, and whose stack the instance belongs to: stack.stop of it removes the instance too.
    pub target: LocalTarget,
    /// The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else the first installed one.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub runtime: Option<Runtime>,
    pub instance: RunInstance,
    /// term: SIGTERM, and SIGKILL 15 seconds later if it has not exited. kill: SIGKILL, so nothing it would settle on the way out is settled.
    pub signal: ServiceSignalParamsSignal,
}

impl ServiceSignalParams {
    /// The `ServiceSignalParams` that states these and nothing else.
    pub fn new(
        api_version: ApiVersion,
        target: LocalTarget,
        instance: RunInstance,
        signal: ServiceSignalParamsSignal,
    ) -> Self {
        Self {
            api_version,
            target,
            runtime: None,
            instance,
            signal,
        }
    }
}

schema!(ServiceSignalParams);

/// term: SIGTERM, and SIGKILL 15 seconds later if it has not exited. kill: SIGKILL, so nothing it would settle on the way out is settled.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ServiceSignalParamsSignal {
    #[serde(rename = "term")]
    Term,
    #[serde(rename = "kill")]
    Kill,
}

impl ServiceSignalParamsSignal {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ServiceSignalParamsSignal::Term => "term",
            ServiceSignalParamsSignal::Kill => "kill",
        }
    }
}

/// A signal sent, or not needed. The instance's exit is its run's answer, not this one.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceSignalResult {
    /// Whether the instance still ran when the signal came. false: it has exited, and its run's answer is on its way; nothing was sent.
    pub delivered: bool,
}

schema!(ServiceSignalResult);

/// notifications/serviceStarted: a run's instance is running. Sent once, before any of its output.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceStarted {
    #[serde(rename = "requestId")]
    pub request_id: RequestId,
    pub instance: RunInstance,
    /// The runtime's name for the instance's container.
    pub container: String,
    /// Where the instance reads its document: the path the image's own arguments name. Present when the run gave a document.
    #[serde(rename = "documentPath")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub document_path: Option<String>,
    /// The host address the instance's ports are published on, as service.host names it for the run's runtime.
    pub address: String,
}

impl ServiceStarted {
    /// The `ServiceStarted` that states these and nothing else.
    pub fn new(
        request_id: RequestId,
        instance: RunInstance,
        container: impl Into<String>,
        address: impl Into<String>,
    ) -> Self {
        Self {
            request_id,
            instance,
            container: container.into(),
            document_path: None,
            address: address.into(),
        }
    }
}

schema!(ServiceStarted);

/// One service, as xynolog status reads it: where it runs, its state, and whether it answers. Nothing is reported that the launcher did not observe: an endpoint is named only when the stack's record or the descriptor names one, and a page to open only when the service answers.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceStatus {
    /// The service, as xynolog status names it.
    pub role: String,
    /// The group it belongs to.
    pub group: ServiceGroup,
    /// The product its driver names (Neo4j, Keycloak), when its record names a driver.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub product: Option<String>,
    /// Where it runs: the runtime its container runs under, external (somebody else runs it), or host (a process on this machine). Absent when nothing runs it.
    #[serde(rename = "runsOn")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub runs_on: Option<String>,
    /// running: its container runs. stopped: its container exists and does not run (containerState says how). reachable, unreachable: somebody else runs it, and its endpoint answers or does not. absent: there is no container of it. not-configured: the stack's documents ask for none.
    pub state: ServiceStatusState,
    /// The runtime's own word for a container that is not running (exited, created).
    #[serde(rename = "containerState")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub container_state: Option<String>,
    /// Whether its health endpoint answers.
    pub healthy: bool,
    /// Whether its health counts toward its knowledge base's: a service the documents ask for none of, and a telemetry backend --no-observe leaves out, do not.
    pub counted: bool,
    /// The endpoint the launcher asks its health of: an http URL, or tcp://host:port.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub probe: Option<String>,
    /// The page a person opens: the Browser, Jaeger's and Prometheus's interfaces, the collector's metrics readout. Present only when the service answers. The collector's OTLP receiver is never one.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub page: Option<String>,
    /// For the issuer the knowledge base signs in at, when it is the machine's: its realm there.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub realm: Option<String>,
    /// For a service several knowledge bases share: the name of each it serves, as knowledgeBases names them.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub serves: Option<Vec<String>>,
}

impl ServiceStatus {
    /// The `ServiceStatus` that states these and nothing else.
    pub fn new(
        role: impl Into<String>,
        group: ServiceGroup,
        state: ServiceStatusState,
        healthy: bool,
        counted: bool,
    ) -> Self {
        Self {
            role: role.into(),
            group,
            product: None,
            runs_on: None,
            state,
            container_state: None,
            healthy,
            counted,
            probe: None,
            page: None,
            realm: None,
            serves: None,
        }
    }
}

schema!(ServiceStatus);

/// running: its container runs. stopped: its container exists and does not run (containerState says how). reachable, unreachable: somebody else runs it, and its endpoint answers or does not. absent: there is no container of it. not-configured: the stack's documents ask for none.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ServiceStatusState {
    #[serde(rename = "running")]
    Running,
    #[serde(rename = "stopped")]
    Stopped,
    #[serde(rename = "reachable")]
    Reachable,
    #[serde(rename = "unreachable")]
    Unreachable,
    #[serde(rename = "absent")]
    Absent,
    #[serde(rename = "not-configured")]
    NotConfigured,
}

impl ServiceStatusState {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ServiceStatusState::Running => "running",
            ServiceStatusState::Stopped => "stopped",
            ServiceStatusState::Reachable => "reachable",
            ServiceStatusState::Unreachable => "unreachable",
            ServiceStatusState::Absent => "absent",
            ServiceStatusState::NotConfigured => "not-configured",
        }
    }
}

/// service-telemetry/log-lines.json: the lines a service writes to its log, and the line of its supervisor it counts.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceTelemetryLogLines {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    /// The lines of a service's logger.
    pub logger: ServiceTelemetryLogLinesLogger,
    /// A line of the bus log.
    pub bus: ServiceTelemetryLogLinesBus,
    /// The line the supervisor writes when it starts a service.
    pub supervisor: ServiceTelemetryLogLinesSupervisor,
}

schema!(ServiceTelemetryLogLines);

/// A line of the bus log.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceTelemetryLogLinesBus {
    /// Its head.
    pub line: String,
    /// What follows the head, in order, each where there is one.
    pub parts: Vec<ServiceTelemetryLogLinesBusPartsItem>,
    /// Each operation a line names.
    pub ops: Vec<String>,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceTelemetryLogLinesBusPartsItem {
    /// What it shows.
    pub part: String,
    /// Its text.
    pub text: String,
    /// How many characters of it are shown, from its first.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub characters: Option<u64>,
}

impl ServiceTelemetryLogLinesBusPartsItem {
    /// The `ServiceTelemetryLogLinesBusPartsItem` that states these and nothing else.
    pub fn new(part: impl Into<String>, text: impl Into<String>) -> Self {
        Self {
            part: part.into(),
            text: text.into(),
            characters: None,
        }
    }
}

/// The lines of a service's logger.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceTelemetryLogLinesLogger {
    /// The services whose document names a LogFormat.
    pub services: Vec<ServiceTelemetryLogLinesLoggerServicesItem>,
    /// A line of the `json` format.
    pub json: ServiceTelemetryLogLinesLoggerJson,
    /// A line of the `simple` format.
    pub simple: String,
}

/// A line of the `json` format.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceTelemetryLogLinesLoggerJson {
    /// Its first members, in order.
    pub first: Vec<String>,
    /// The member that names the request a line was logged while answering.
    #[serde(rename = "requestId")]
    pub request_id: String,
    /// The members that name the active trace and span, in that order.
    pub trace: Vec<String>,
    /// Its last member: the moment.
    pub last: String,
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ServiceTelemetryLogLinesLoggerServicesItem {
    #[serde(rename = "archivist")]
    Archivist,
    #[serde(rename = "dispatcher")]
    Dispatcher,
    #[serde(rename = "gateway")]
    Gateway,
}

impl ServiceTelemetryLogLinesLoggerServicesItem {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ServiceTelemetryLogLinesLoggerServicesItem::Archivist => "archivist",
            ServiceTelemetryLogLinesLoggerServicesItem::Dispatcher => "dispatcher",
            ServiceTelemetryLogLinesLoggerServicesItem::Gateway => "gateway",
        }
    }
}

/// The line the supervisor writes when it starts a service.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceTelemetryLogLinesSupervisor {
    /// The line.
    pub line: String,
    /// What a service counts the lines that hold of, for each of its lives.
    pub counted: String,
}

/// service-telemetry/telemetry.json: the telemetry each Xynolog service exports over OTLP: its spans and metrics, the services that export each, and the attributes each carries.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceTelemetryTelemetry {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    /// The services that reach the bus through an SDK, and for each the SDK transports it uses, or of a transport it uses part of, the rows it exports.
    pub sdk: std::collections::BTreeMap<String, Vec<String>>,
    pub resource: Vec<ServiceTelemetryTelemetryResourceItem>,
    pub spans: Vec<ServiceTelemetryTelemetrySpansItem>,
    pub metrics: Vec<ServiceTelemetryTelemetryMetricsItem>,
}

schema!(ServiceTelemetryTelemetry);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceTelemetryTelemetryMetricsItem {
    /// The row's name; `{channel}` in it is the bus channel, and `{jobType}` the job's type.
    pub name: String,
    /// The services that export the row.
    pub services: Vec<ServiceTelemetryTelemetryMetricsItemServicesItem>,
    /// The metric's instrument.
    pub instrument: ServiceTelemetryTelemetryMetricsItemInstrument,
    /// When the row arrives.
    pub when: ServiceTelemetryTelemetryMetricsItemWhen,
    /// The only signal planes a gateway row arrives on.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub planes: Option<Vec<ServiceTelemetryTelemetryMetricsItemPlanesItem>>,
    /// What the row says.
    pub meaning: String,
    /// The attributes the span carries.
    pub attributes: Vec<ServiceTelemetryTelemetryMetricsItemAttributesItem>,
}

impl ServiceTelemetryTelemetryMetricsItem {
    /// The `ServiceTelemetryTelemetryMetricsItem` that states these and nothing else.
    pub fn new(
        name: impl Into<String>,
        services: Vec<ServiceTelemetryTelemetryMetricsItemServicesItem>,
        instrument: ServiceTelemetryTelemetryMetricsItemInstrument,
        when: ServiceTelemetryTelemetryMetricsItemWhen,
        meaning: impl Into<String>,
        attributes: Vec<ServiceTelemetryTelemetryMetricsItemAttributesItem>,
    ) -> Self {
        Self {
            name: name.into(),
            services,
            instrument,
            when,
            planes: None,
            meaning: meaning.into(),
            attributes,
        }
    }
}

/// An attribute a row carries.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceTelemetryTelemetryMetricsItemAttributesItem {
    /// The attribute's key.
    pub key: String,
    /// When alone the attribute is carried: a row's attribute without it is carried every time.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub only: Option<String>,
    /// The only values it carries, each of the type it is carried as: a string or a boolean.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub values: Option<Vec<ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem>>,
}

impl ServiceTelemetryTelemetryMetricsItemAttributesItem {
    /// The `ServiceTelemetryTelemetryMetricsItemAttributesItem` that states these and nothing else.
    pub fn new(key: impl Into<String>) -> Self {
        Self {
            key: key.into(),
            only: None,
            values: None,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem {
    Text(String),
    Boolean(bool),
}

/// The metric's instrument.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ServiceTelemetryTelemetryMetricsItemInstrument {
    #[serde(rename = "counter")]
    Counter,
    #[serde(rename = "up-down counter")]
    UpDownCounter,
    #[serde(rename = "gauge")]
    Gauge,
    #[serde(rename = "histogram")]
    Histogram,
}

impl ServiceTelemetryTelemetryMetricsItemInstrument {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ServiceTelemetryTelemetryMetricsItemInstrument::Counter => "counter",
            ServiceTelemetryTelemetryMetricsItemInstrument::UpDownCounter => "up-down counter",
            ServiceTelemetryTelemetryMetricsItemInstrument::Gauge => "gauge",
            ServiceTelemetryTelemetryMetricsItemInstrument::Histogram => "histogram",
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ServiceTelemetryTelemetryMetricsItemPlanesItem {
    #[serde(rename = "in-process")]
    InProcess,
    #[serde(rename = "nats")]
    Nats,
}

impl ServiceTelemetryTelemetryMetricsItemPlanesItem {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ServiceTelemetryTelemetryMetricsItemPlanesItem::InProcess => "in-process",
            ServiceTelemetryTelemetryMetricsItemPlanesItem::Nats => "nats",
        }
    }
}

/// A Xynolog service, by its name.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ServiceTelemetryTelemetryMetricsItemServicesItem {
    #[serde(rename = "archivist")]
    Archivist,
    #[serde(rename = "dispatcher")]
    Dispatcher,
    #[serde(rename = "gateway")]
    Gateway,
    #[serde(rename = "librarian")]
    Librarian,
    #[serde(rename = "smelter")]
    Smelter,
    #[serde(rename = "weaver")]
    Weaver,
    #[serde(rename = "worker")]
    Worker,
}

impl ServiceTelemetryTelemetryMetricsItemServicesItem {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ServiceTelemetryTelemetryMetricsItemServicesItem::Archivist => "archivist",
            ServiceTelemetryTelemetryMetricsItemServicesItem::Dispatcher => "dispatcher",
            ServiceTelemetryTelemetryMetricsItemServicesItem::Gateway => "gateway",
            ServiceTelemetryTelemetryMetricsItemServicesItem::Librarian => "librarian",
            ServiceTelemetryTelemetryMetricsItemServicesItem::Smelter => "smelter",
            ServiceTelemetryTelemetryMetricsItemServicesItem::Weaver => "weaver",
            ServiceTelemetryTelemetryMetricsItemServicesItem::Worker => "worker",
        }
    }
}

/// When the row arrives.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ServiceTelemetryTelemetryMetricsItemWhen {
    #[serde(rename = "export")]
    Export,
    #[serde(rename = "traffic")]
    Traffic,
    #[serde(rename = "supervised")]
    Supervised,
    #[serde(rename = "fatal")]
    Fatal,
}

impl ServiceTelemetryTelemetryMetricsItemWhen {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ServiceTelemetryTelemetryMetricsItemWhen::Export => "export",
            ServiceTelemetryTelemetryMetricsItemWhen::Traffic => "traffic",
            ServiceTelemetryTelemetryMetricsItemWhen::Supervised => "supervised",
            ServiceTelemetryTelemetryMetricsItemWhen::Fatal => "fatal",
        }
    }
}

/// An attribute of the resource the services' spans and metrics are exported under.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceTelemetryTelemetryResourceItem {
    /// The attribute's key.
    pub key: String,
    /// The services that export the row.
    pub services: Vec<ServiceTelemetryTelemetryResourceItemServicesItem>,
    /// What the attribute says.
    pub meaning: String,
    /// Its value when nothing says another, with `{service}` the service's name.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub default: Option<String>,
}

impl ServiceTelemetryTelemetryResourceItem {
    /// The `ServiceTelemetryTelemetryResourceItem` that states these and nothing else.
    pub fn new(
        key: impl Into<String>,
        services: Vec<ServiceTelemetryTelemetryResourceItemServicesItem>,
        meaning: impl Into<String>,
    ) -> Self {
        Self {
            key: key.into(),
            services,
            meaning: meaning.into(),
            default: None,
        }
    }
}

/// A Xynolog service, by its name.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ServiceTelemetryTelemetryResourceItemServicesItem {
    #[serde(rename = "archivist")]
    Archivist,
    #[serde(rename = "dispatcher")]
    Dispatcher,
    #[serde(rename = "gateway")]
    Gateway,
    #[serde(rename = "librarian")]
    Librarian,
    #[serde(rename = "smelter")]
    Smelter,
    #[serde(rename = "weaver")]
    Weaver,
    #[serde(rename = "worker")]
    Worker,
}

impl ServiceTelemetryTelemetryResourceItemServicesItem {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ServiceTelemetryTelemetryResourceItemServicesItem::Archivist => "archivist",
            ServiceTelemetryTelemetryResourceItemServicesItem::Dispatcher => "dispatcher",
            ServiceTelemetryTelemetryResourceItemServicesItem::Gateway => "gateway",
            ServiceTelemetryTelemetryResourceItemServicesItem::Librarian => "librarian",
            ServiceTelemetryTelemetryResourceItemServicesItem::Smelter => "smelter",
            ServiceTelemetryTelemetryResourceItemServicesItem::Weaver => "weaver",
            ServiceTelemetryTelemetryResourceItemServicesItem::Worker => "worker",
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceTelemetryTelemetrySpansItem {
    /// The row's name; `{channel}` in it is the bus channel, and `{jobType}` the job's type.
    pub name: String,
    /// The services that export the row.
    pub services: Vec<ServiceTelemetryTelemetrySpansItemServicesItem>,
    /// The span's kind, in OTLP's words.
    pub kind: ServiceTelemetryTelemetrySpansItemKind,
    /// When the row arrives.
    pub when: ServiceTelemetryTelemetrySpansItemWhen,
    /// What the row says.
    pub meaning: String,
    /// The attributes the span carries.
    pub attributes: Vec<ServiceTelemetryTelemetrySpansItemAttributesItem>,
}

/// An attribute a row carries.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct ServiceTelemetryTelemetrySpansItemAttributesItem {
    /// The attribute's key.
    pub key: String,
    /// When alone the attribute is carried: a row's attribute without it is carried every time.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub only: Option<String>,
    /// The only values it carries, each of the type it is carried as: a string or a boolean.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub values: Option<Vec<ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem>>,
}

impl ServiceTelemetryTelemetrySpansItemAttributesItem {
    /// The `ServiceTelemetryTelemetrySpansItemAttributesItem` that states these and nothing else.
    pub fn new(key: impl Into<String>) -> Self {
        Self {
            key: key.into(),
            only: None,
            values: None,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem {
    Text(String),
    Boolean(bool),
}

/// The span's kind, in OTLP's words.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ServiceTelemetryTelemetrySpansItemKind {
    #[serde(rename = "client")]
    Client,
    #[serde(rename = "consumer")]
    Consumer,
    #[serde(rename = "internal")]
    Internal,
    #[serde(rename = "producer")]
    Producer,
    #[serde(rename = "server")]
    Server,
}

impl ServiceTelemetryTelemetrySpansItemKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ServiceTelemetryTelemetrySpansItemKind::Client => "client",
            ServiceTelemetryTelemetrySpansItemKind::Consumer => "consumer",
            ServiceTelemetryTelemetrySpansItemKind::Internal => "internal",
            ServiceTelemetryTelemetrySpansItemKind::Producer => "producer",
            ServiceTelemetryTelemetrySpansItemKind::Server => "server",
        }
    }
}

/// A Xynolog service, by its name.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ServiceTelemetryTelemetrySpansItemServicesItem {
    #[serde(rename = "archivist")]
    Archivist,
    #[serde(rename = "dispatcher")]
    Dispatcher,
    #[serde(rename = "gateway")]
    Gateway,
    #[serde(rename = "librarian")]
    Librarian,
    #[serde(rename = "smelter")]
    Smelter,
    #[serde(rename = "weaver")]
    Weaver,
    #[serde(rename = "worker")]
    Worker,
}

impl ServiceTelemetryTelemetrySpansItemServicesItem {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ServiceTelemetryTelemetrySpansItemServicesItem::Archivist => "archivist",
            ServiceTelemetryTelemetrySpansItemServicesItem::Dispatcher => "dispatcher",
            ServiceTelemetryTelemetrySpansItemServicesItem::Gateway => "gateway",
            ServiceTelemetryTelemetrySpansItemServicesItem::Librarian => "librarian",
            ServiceTelemetryTelemetrySpansItemServicesItem::Smelter => "smelter",
            ServiceTelemetryTelemetrySpansItemServicesItem::Weaver => "weaver",
            ServiceTelemetryTelemetrySpansItemServicesItem::Worker => "worker",
        }
    }
}

/// When the row arrives.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum ServiceTelemetryTelemetrySpansItemWhen {
    #[serde(rename = "export")]
    Export,
    #[serde(rename = "traffic")]
    Traffic,
    #[serde(rename = "supervised")]
    Supervised,
    #[serde(rename = "fatal")]
    Fatal,
}

impl ServiceTelemetryTelemetrySpansItemWhen {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            ServiceTelemetryTelemetrySpansItemWhen::Export => "export",
            ServiceTelemetryTelemetrySpansItemWhen::Traffic => "traffic",
            ServiceTelemetryTelemetrySpansItemWhen::Supervised => "supervised",
            ServiceTelemetryTelemetrySpansItemWhen::Fatal => "fatal",
        }
    }
}

/// The launcher's own stored sign-in for a stack (xynolog login), never Desktop's. No token is in it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct Session {
    /// valid: the stack's gateway accepts the stored token. expired: it refuses it (a refresh, or xynolog login, renews it). unverified: the stack did not answer. none: nothing is stored.
    pub state: SessionState,
    /// The email the session was signed in as, when the store records one.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub email: Option<String>,
}

impl Session {
    /// The `Session` that states these and nothing else.
    pub fn new(state: SessionState) -> Self {
        Self { state, email: None }
    }
}

schema!(Session);

/// Why a session ended: `expired`, the issuer refused to renew its token; `refused`, the gateway refused a token its issuer had just issued.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum SessionEndReason {
    #[serde(rename = "expired")]
    Expired,
    #[serde(rename = "refused")]
    Refused,
}

impl SessionEndReason {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            SessionEndReason::Expired => "expired",
            SessionEndReason::Refused => "refused",
        }
    }
}

schema!(SessionEndReason);

/// A session ended, and why.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SessionEnded {
    /// Why it ended.
    pub reason: SessionEndReason,
}

schema!(SessionEnded);

/// A participant opened a live connection to this KB — an SSE stream on /bus/subscribe. Presence is CONNECTION lifecycle, not login: a token can be minted and sit unused, so what this reports is that someone is WATCHING. One person with two tabs produces two of these, which is why connectionId is required — the DID alone cannot tell two connections apart, and a consumer that counts DIDs will undercount viewers.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct SessionJoinedEvent {
    /// DID of the authenticated principal on that connection. A person or a software agent — the bus does not distinguish.
    pub participant: UserId,
    /// Identifies this connection for its lifetime. The matching session:left carries the same value.
    #[serde(rename = "connectionId")]
    pub connection_id: String,
}

schema!(SessionJoinedEvent);

/// A participant's live connection to this KB ended — the SSE stream aborted. Carries the same connectionId as the session:joined that opened it, so a consumer tracking who is present can retire the right connection rather than assuming one per participant.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct SessionLeftEvent {
    /// DID of the authenticated principal on that connection.
    pub participant: UserId,
    /// The connectionId announced by the matching session:joined.
    #[serde(rename = "connectionId")]
    pub connection_id: String,
}

schema!(SessionLeftEvent);

/// valid: the stack's gateway accepts the stored token. expired: it refuses it (a refresh, or xynolog login, renews it). unverified: the stack did not answer. none: nothing is stored.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum SessionState {
    #[serde(rename = "valid")]
    Valid,
    #[serde(rename = "expired")]
    Expired,
    #[serde(rename = "unverified")]
    Unverified,
    #[serde(rename = "none")]
    None,
}

impl SessionState {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            SessionState::Valid => "valid",
            SessionState::Expired => "expired",
            SessionState::Unverified => "unverified",
            SessionState::None => "none",
        }
    }
}

/// One setting the launcher keeps, as xynolog settings shows it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct Setting {
    /// Its name, as xynolog settings takes it.
    pub name: String,
    /// Whether this is the machine-wide form of a knowledge-base setting (secret-store --default).
    pub default: bool,
    /// What it applies to: every knowledge base on this machine, or one.
    #[serde(rename = "appliesTo")]
    pub applies_to: SettingAppliesTo,
    /// The values in effect, one per line xynolog settings shows.
    pub values: Vec<SettingLine>,
    /// Whether settings.set and settings.unset change it.
    pub settable: bool,
    /// For one they do not: how it is changed instead.
    #[serde(rename = "changedBy")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub changed_by: Option<String>,
}

impl Setting {
    /// The `Setting` that states these and nothing else.
    pub fn new(
        name: impl Into<String>,
        default: bool,
        applies_to: SettingAppliesTo,
        values: Vec<SettingLine>,
        settable: bool,
    ) -> Self {
        Self {
            name: name.into(),
            default,
            applies_to,
            values,
            settable,
            changed_by: None,
        }
    }
}

schema!(Setting);

/// What it applies to: every knowledge base on this machine, or one.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum SettingAppliesTo {
    #[serde(rename = "machine")]
    Machine,
    #[serde(rename = "knowledge-base")]
    KnowledgeBase,
}

impl SettingAppliesTo {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            SettingAppliesTo::Machine => "machine",
            SettingAppliesTo::KnowledgeBase => "knowledge-base",
        }
    }
}

/// One value of a setting, and where it came from, as xynolog settings shows it. A secret's value is never one: a secret setting shows where the value is kept.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SettingLine {
    /// The value in effect.
    pub value: String,
    /// Where it came from: a record, a document, the default.
    pub source: String,
}

schema!(SettingLine);

/// settings.get's params.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SettingsGetParams {
    /// The version of the control API the request is written to.
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    /// The setting, as xynolog settings names it.
    pub name: String,
    /// The machine-wide form of a knowledge-base setting: --default.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub default: Option<bool>,
    /// A knowledge base's clone, by path or by the basename of a registered root, as --root takes it. Absent: the clone the control server was started in.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub root: Option<String>,
}

impl SettingsGetParams {
    /// The `SettingsGetParams` that states these and nothing else.
    pub fn new(api_version: ApiVersion, name: impl Into<String>) -> Self {
        Self {
            api_version,
            name: name.into(),
            default: None,
            root: None,
        }
    }
}

schema!(SettingsGetParams);

/// Emitted when the hover delay setting changes
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct SettingsHoverDelayChangedEvent {
    #[serde(rename = "hoverDelayMs")]
    pub hover_delay_ms: i64,
}

schema!(SettingsHoverDelayChangedEvent);

/// settings.list's params.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SettingsListParams {
    /// The version of the control API the request is written to.
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    /// A knowledge base's clone, by path or by the basename of a registered root, as --root takes it. Absent: the clone the control server was started in.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub root: Option<String>,
}

impl SettingsListParams {
    /// The `SettingsListParams` that states these and nothing else.
    pub fn new(api_version: ApiVersion) -> Self {
        Self {
            api_version,
            root: None,
        }
    }
}

schema!(SettingsListParams);

/// Every setting the launcher keeps: the machine's, then the knowledge base's.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SettingsListResult {
    /// The knowledge base whose settings are listed, when one resolved.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub root: Option<String>,
    /// Why no knowledge base resolved, when none did: its settings are not listed.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub unresolved: Option<String>,
    /// Each setting.
    pub settings: Vec<Setting>,
}

impl SettingsListResult {
    /// The `SettingsListResult` that states these and nothing else.
    pub fn new(settings: Vec<Setting>) -> Self {
        Self {
            root: None,
            unresolved: None,
            settings,
        }
    }
}

schema!(SettingsListResult);

/// Emitted when the UI locale setting changes
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct SettingsLocaleChangedEvent {
    pub locale: String,
}

schema!(SettingsLocaleChangedEvent);

/// settings.path's params.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SettingsPathParams {
    /// The version of the control API the request is written to.
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    /// Whose document: the Browser's, the worker's, the issuer's or the vector store's.
    pub document: SettingsPathParamsDocument,
}

schema!(SettingsPathParams);

/// Whose document: the Browser's, the worker's, the issuer's or the vector store's.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum SettingsPathParamsDocument {
    #[serde(rename = "browser")]
    Browser,
    #[serde(rename = "worker")]
    Worker,
    #[serde(rename = "issuer")]
    Issuer,
    #[serde(rename = "vectors")]
    Vectors,
}

impl SettingsPathParamsDocument {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            SettingsPathParamsDocument::Browser => "browser",
            SettingsPathParamsDocument::Worker => "worker",
            SettingsPathParamsDocument::Issuer => "issuer",
            SettingsPathParamsDocument::Vectors => "vectors",
        }
    }
}

/// Where a machine document is. When there is none, it is written from the launcher's catalog first, as a start writes it; one that does not hold is refused, as a start refuses it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SettingsPathResult {
    /// The document's path.
    pub path: String,
}

schema!(SettingsPathResult);

/// settings.set's params.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SettingsSetParams {
    /// The version of the control API the request is written to.
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    /// The setting, as xynolog settings names it.
    pub name: String,
    /// The machine-wide form of a knowledge-base setting: --default.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub default: Option<bool>,
    /// A knowledge base's clone, by path or by the basename of a registered root, as --root takes it. Absent: the clone the control server was started in.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub root: Option<String>,
    /// The value, checked as a start would check it.
    pub value: String,
}

impl SettingsSetParams {
    /// The `SettingsSetParams` that states these and nothing else.
    pub fn new(api_version: ApiVersion, name: impl Into<String>, value: impl Into<String>) -> Self {
        Self {
            api_version,
            name: name.into(),
            default: None,
            root: None,
            value: value.into(),
        }
    }
}

schema!(SettingsSetParams);

/// Emitted when the UI theme setting changes
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct SettingsThemeChangedEvent {
    pub theme: SettingsThemeChangedEventTheme,
}

schema!(SettingsThemeChangedEvent);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum SettingsThemeChangedEventTheme {
    #[serde(rename = "light")]
    Light,
    #[serde(rename = "dark")]
    Dark,
    #[serde(rename = "system")]
    System,
}

impl SettingsThemeChangedEventTheme {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            SettingsThemeChangedEventTheme::Light => "light",
            SettingsThemeChangedEventTheme::Dark => "dark",
            SettingsThemeChangedEventTheme::System => "system",
        }
    }
}

/// settings.unset's params.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SettingsUnsetParams {
    /// The version of the control API the request is written to.
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    /// The setting, as xynolog settings names it.
    pub name: String,
    /// The machine-wide form of a knowledge-base setting: --default.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub default: Option<bool>,
    /// A knowledge base's clone, by path or by the basename of a registered root, as --root takes it. Absent: the clone the control server was started in.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub root: Option<String>,
}

impl SettingsUnsetParams {
    /// The `SettingsUnsetParams` that states these and nothing else.
    pub fn new(api_version: ApiVersion, name: impl Into<String>) -> Self {
        Self {
            api_version,
            name: name.into(),
            default: None,
            root: None,
        }
    }
}

schema!(SettingsUnsetParams);

/// The entry a sign-in landed on, and what the person believed, so a host can set the two against each other and say when they differ. The sign-in stands either way: the knowledge base that answered is the one reached.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SignInOutcome {
    /// The entry the sign-in made or signed in to again.
    pub kb: KnowledgeBase,
    /// What the person believed they were signing in to. Absent when they named nothing.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub expected: Option<Expected>,
}

impl SignInOutcome {
    /// The `SignInOutcome` that states these and nothing else.
    pub fn new(kb: KnowledgeBase) -> Self {
        Self { kb, expected: None }
    }
}

schema!(SignInOutcome);

/// What a completed sign-in learned, as a registry is handed it to record: where it was, who the knowledge base there says it is, the tokens, and what the person believed they were signing in to.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SignedIn {
    /// Where the sign-in was.
    pub endpoint: KbEndpoint,
    /// What the knowledge base said of itself, asked with the new token.
    pub description: KbDescription,
    /// The tokens, as a registry keeps them.
    pub session: StoredSession,
    /// The registered knowledge base the person signed in to again. Absent when it is none.
    #[serde(rename = "kbId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub kb_id: Option<String>,
    /// The did of what the person believed they clicked. Absent when they named nothing.
    #[serde(rename = "expectedDid")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub expected_did: Option<String>,
    /// The name of what the person believed they clicked. Absent when they named nothing.
    #[serde(rename = "expectedName")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub expected_name: Option<String>,
}

impl SignedIn {
    /// The `SignedIn` that states these and nothing else.
    pub fn new(endpoint: KbEndpoint, description: KbDescription, session: StoredSession) -> Self {
        Self {
            endpoint,
            description,
            session,
            kb_id: None,
            expected_did: None,
            expected_name: None,
        }
    }
}

schema!(SignedIn);

/// Bus command to rebuild anchored-text artifacts by re-running extraction — every geometry-capable resource when resourceId is absent, one resource when present. Served by the Smelter, serialized (each unit can be a multi-second OCR pass), and never destructive: nothing is deleted first, stale entries are simply overwritten. Re-anchoring makes zero embedding calls — the vectors are already correct; only the derived map is re-made. Partial completion replies failed, with counts: a rebuild that quietly skipped resources would present exactly like a document with no text.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct SmeltRebuildAnchorsCommand {
    /// When present, re-anchor only this resource; otherwise every geometry-capable resource in the catalog.
    #[serde(rename = "resourceId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resource_id: Option<ResourceId>,
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
}

schema!(SmeltRebuildAnchorsCommand);

/// The payload of `smelt:settled`: the Smelter's decision for one resource's content, keyed by the checksum of the bytes it inspected. `indexed`: the content is in the vector index. `skipped`: it declined, and `reason` says why.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct SmeltSettled {
    /// The resource whose content was inspected.
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// The checksum of the bytes inspected.
    #[serde(rename = "contentChecksum")]
    pub content_checksum: String,
    pub outcome: SmeltSettledOutcome,
    /// Why the content was skipped.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub reason: Option<SmeltSettledReason>,
}

impl SmeltSettled {
    /// The `SmeltSettled` that states these and nothing else.
    pub fn new(
        resource_id: ResourceId,
        content_checksum: impl Into<String>,
        outcome: SmeltSettledOutcome,
    ) -> Self {
        Self {
            resource_id,
            content_checksum: content_checksum.into(),
            outcome,
            reason: None,
        }
    }
}

schema!(SmeltSettled);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum SmeltSettledOutcome {
    #[serde(rename = "indexed")]
    Indexed,
    #[serde(rename = "skipped")]
    Skipped,
}

impl SmeltSettledOutcome {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            SmeltSettledOutcome::Indexed => "indexed",
            SmeltSettledOutcome::Skipped => "skipped",
        }
    }
}

/// Why the content was skipped.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum SmeltSettledReason {
    #[serde(rename = "no-extractor")]
    NoExtractor,
    #[serde(rename = "empty")]
    Empty,
    #[serde(rename = "no-text-layer")]
    NoTextLayer,
    #[serde(rename = "encrypted")]
    Encrypted,
    #[serde(rename = "corrupt")]
    Corrupt,
    #[serde(rename = "too-large")]
    TooLarge,
}

impl SmeltSettledReason {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            SmeltSettledReason::NoExtractor => "no-extractor",
            SmeltSettledReason::Empty => "empty",
            SmeltSettledReason::NoTextLayer => "no-text-layer",
            SmeltSettledReason::Encrypted => "encrypted",
            SmeltSettledReason::Corrupt => "corrupt",
            SmeltSettledReason::TooLarge => "too-large",
        }
    }
}

/// The two numbers a text is cut by before it is embedded, both in tokens, a token being taken as four code points.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SmelterChunking {
    /// The size of a chunk.
    #[serde(rename = "chunkSize")]
    pub chunk_size: u64,
    /// How much of a chunk the next one repeats.
    pub overlap: u64,
}

schema!(SmelterChunking);

/// Everything a Smelter reads at boot: nothing in it is defaulted by the Smelter. Whoever starts a Smelter writes it, from the knowledge base's stack documents, and the Smelter reads it from the path its `--config` flag names. This schema is the contract, and a Smelter needs no launcher. Started without `--config`, or with a path that names no file, the Smelter refuses to start and says which. No secret is a value here: an embedding provider's key is named by the environment variable that holds it, and the Smelter's own service account is `XYNOLOG_OIDC_CLIENT_ID` and `XYNOLOG_OIDC_CLIENT_SECRET` in its environment. A document that does not validate is refused at boot, naming each failing field.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SmelterConfig {
    pub kb: KbIdentity,
    /// The URL the Smelter reaches the gateway at: its route to the bus.
    #[serde(rename = "gatewayUrl")]
    pub gateway_url: String,
    /// The issuer the Smelter's service account signs in at.
    pub identity: ServiceIdentity,
    /// Where the Archivist listens. The Smelter reads a resource's bytes from it, and keeps the anchored-text store there, as its service account.
    pub archivist: ServiceAddress,
    pub embedding: EmbeddingConfig,
    pub vectors: VectorsConfig,
    pub chunking: SmelterChunking,
    /// How many PDFs the Smelter works on at once. Each one under way holds its bytes, a page of a scan in pixels beside the OCR process reading it, and its text and vectors, so whoever starts a Smelter sizes this with the memory it gives it. Every other resource is indexed beside them.
    #[serde(rename = "pdfsAtOnce")]
    pub pdfs_at_once: u64,
    #[serde(rename = "cursorsPath")]
    pub cursors_path: CursorsPath,
    /// The port the Smelter answers `/health` on.
    pub port: u16,
    #[serde(rename = "logLevel")]
    pub log_level: LogLevel,
    #[serde(rename = "logFormat")]
    pub log_format: LogFormat,
}

schema!(SmelterConfig);

/// The Smelter's health answer (SMELTER.md § Health): seven members, each from what the Smelter holds, for it asks nothing of the gateway, its embedding provider or its vector database to answer. `status` is `ok` whenever it answers, and says what else is so in the members beside it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SmelterHealth {
    pub status: SmelterHealthStatus,
    /// The DID of the knowledge base it serves: the one its settings name, which that knowledge base said it is before the Smelter reached its index.
    pub kb: KbDid,
    /// The state of its own stream of the record, one of the seven of TRANSPORT-HTTP.md § Connection lifecycle. Events are delivered to it while it is `open`.
    pub stream: SmelterHealthStream,
    /// How far it has followed the record. Its sweep is also `due` where its start's reconcile failed.
    pub following: FollowerFollowing,
    /// How many events it has applied since it started: events of the kinds that do something, and not refused. Neither an event taken as nothing nor the work of a reconcile or a rebuild is counted.
    #[serde(rename = "eventsProcessed")]
    pub events_processed: u64,
    /// How far the latest reconcile has got: the pass's `summary` when it is done, or its `error` when it failed.
    pub reconcile: SmelterHealthReconcile,
    /// What the Smelter holds its index to, and what this start did for that.
    pub index: SmelterHealthIndex,
}

impl SmelterHealth {
    /// The `SmelterHealth` that states these and nothing else.
    pub fn new(
        kb: KbDid,
        stream: SmelterHealthStream,
        following: FollowerFollowing,
        events_processed: u64,
        reconcile: SmelterHealthReconcile,
        index: SmelterHealthIndex,
    ) -> Self {
        Self {
            status: SmelterHealthStatus::Ok,
            kb,
            stream,
            following,
            events_processed,
            reconcile,
            index,
        }
    }
}

schema!(SmelterHealth);

/// What the Smelter holds its index to, and what this start did for that.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SmelterHealthIndex {
    /// The model and the cut it makes an index by.
    pub stamp: SmelterHealthIndexStamp,
    /// Whether this start made the index again, as it does where the index stated another stamp, or none.
    #[serde(rename = "madeAnew")]
    pub made_anew: bool,
}

/// The model and the cut it makes an index by.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SmelterHealthIndexStamp {
    /// The embedding provider's kind and model.
    pub embedding: SmelterHealthIndexStampEmbedding,
    pub chunking: SmelterChunking,
}

/// The embedding provider's kind and model.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SmelterHealthIndexStampEmbedding {
    pub r#type: String,
    pub model: String,
}

/// How far the latest reconcile has got: the pass's `summary` when it is done, or its `error` when it failed.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SmelterHealthReconcile {
    pub phase: SmelterHealthReconcilePhase,
    /// What the pass came to.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub summary: Option<SmelterReconcileSummary>,
    /// Why it failed.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub error: Option<String>,
}

impl SmelterHealthReconcile {
    /// The `SmelterHealthReconcile` that states these and nothing else.
    pub fn new(phase: SmelterHealthReconcilePhase) -> Self {
        Self {
            phase,
            summary: None,
            error: None,
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum SmelterHealthReconcilePhase {
    #[serde(rename = "pending")]
    Pending,
    #[serde(rename = "running")]
    Running,
    #[serde(rename = "done")]
    Done,
    #[serde(rename = "failed")]
    Failed,
}

impl SmelterHealthReconcilePhase {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            SmelterHealthReconcilePhase::Pending => "pending",
            SmelterHealthReconcilePhase::Running => "running",
            SmelterHealthReconcilePhase::Done => "done",
            SmelterHealthReconcilePhase::Failed => "failed",
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum SmelterHealthStatus {
    #[serde(rename = "ok")]
    Ok,
}

impl SmelterHealthStatus {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            SmelterHealthStatus::Ok => "ok",
        }
    }
}

/// The state of its own stream of the record, one of the seven of TRANSPORT-HTTP.md § Connection lifecycle. Events are delivered to it while it is `open`.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum SmelterHealthStream {
    #[serde(rename = "initial")]
    Initial,
    #[serde(rename = "connecting")]
    Connecting,
    #[serde(rename = "open")]
    Open,
    #[serde(rename = "reconnecting")]
    Reconnecting,
    #[serde(rename = "degraded")]
    Degraded,
    #[serde(rename = "unauthenticated")]
    Unauthenticated,
    #[serde(rename = "closed")]
    Closed,
}

impl SmelterHealthStream {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            SmelterHealthStream::Initial => "initial",
            SmelterHealthStream::Connecting => "connecting",
            SmelterHealthStream::Open => "open",
            SmelterHealthStream::Reconnecting => "reconnecting",
            SmelterHealthStream::Degraded => "degraded",
            SmelterHealthStream::Unauthenticated => "unauthenticated",
            SmelterHealthStream::Closed => "closed",
        }
    }
}

/// smelter/messages.json: the words of the Smelter's refusals, and of the messages it logs that a reader relies on.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SmelterMessages {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    /// Each refusal of an operation, on the operation's failure channel.
    pub refusals: Vec<SmelterMessagesRefusalsItem>,
    /// Each message the Smelter logs that a reader of its output relies on.
    pub logged: Vec<SmelterMessagesLoggedItem>,
}

schema!(SmelterMessages);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SmelterMessagesLoggedItem {
    /// The situation's name.
    pub name: String,
    pub level: LogLevel,
    /// When it is written, what fills each `{name}` of its fields, and what each fact it carries says.
    pub situation: String,
    /// The line's message, word for word.
    pub message: String,
    /// The facts the line is logged with whose form is stated, by name: each a text whose `{name}` is filled as the row's `situation` says. A fact that is a number is its decimal digits.
    pub fields: std::collections::BTreeMap<String, String>,
    /// The facts the line is logged with beside `fields`, whose value the row's `situation` says and whose form is not stated. The line may carry others.
    pub carries: Vec<String>,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SmelterMessagesRefusalsItem {
    /// The situation's name.
    pub name: String,
    /// The operation it refuses: a request of bus/registry.json's operations that the Smelter answers.
    pub operation: String,
    /// When it is written, and what fills each `{name}` of its text.
    pub situation: String,
    /// The failure's `message`. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.
    pub message: String,
}

/// What a Smelter's reconcile came to (SMELTER.md § Reconcile), as its health reports a pass that is done (SmelterHealth's `reconcile.summary`). The first four add up to how many resources it set out to index, less any whose indexing was no longer wanted when its turn came.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct SmelterReconcileSummary {
    /// How many resources it set out to index were indexed.
    #[serde(rename = "resourcesEmbedded")]
    pub resources_embedded: u64,
    /// How many were skipped, by the reason each was skipped for: a reason `smelt:settled` carries (SmeltSettled).
    #[serde(rename = "resourcesSkipped")]
    pub resources_skipped: std::collections::BTreeMap<String, u64>,
    /// How many could not be read.
    #[serde(rename = "resourcesUnavailable")]
    pub resources_unavailable: u64,
    /// How many failed.
    #[serde(rename = "resourcesFailed")]
    pub resources_failed: u64,
    /// How many resources it planned to rewrite the entity types of.
    #[serde(rename = "resourcesRestamped")]
    pub resources_restamped: u64,
    /// How many resources it planned to derive the anchored text of again.
    #[serde(rename = "resourcesReanchored")]
    pub resources_reanchored: u64,
    /// How many resources it planned to take out of the index.
    #[serde(rename = "resourceVectorsDeleted")]
    pub resource_vectors_deleted: u64,
    /// How many annotations it planned to index.
    #[serde(rename = "annotationsEmbedded")]
    pub annotations_embedded: u64,
    /// How many annotations it planned to rewrite the entity types of.
    #[serde(rename = "annotationsRestamped")]
    pub annotations_restamped: u64,
    /// How many annotations it planned to take out of the index.
    #[serde(rename = "annotationVectorsDeleted")]
    pub annotation_vectors_deleted: u64,
    /// How many resources of the catalog have text.
    #[serde(rename = "resourcesEligible")]
    pub resources_eligible: u64,
    /// How many resources have points when it ends.
    #[serde(rename = "resourcesIndexed")]
    pub resources_indexed: u64,
}

schema!(SmelterReconcileSummary);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct SpecificResource {
    pub r#type: SpecificResourceType,
    /// The id of the resource this body leads to
    pub source: ResourceId,
    /// Why this body is included
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub purpose: Option<BodyPurpose>,
}

impl SpecificResource {
    /// The `SpecificResource` that states these and nothing else.
    pub fn new(source: ResourceId) -> Self {
        Self {
            r#type: SpecificResourceType::SpecificResource,
            source,
            purpose: None,
        }
    }
}

schema!(SpecificResource);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum SpecificResourceType {
    #[serde(rename = "SpecificResource")]
    SpecificResource,
}

impl SpecificResourceType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            SpecificResourceType::SpecificResource => "SpecificResource",
        }
    }
}

/// The group and version of Xynolog's kinds. The group names who defines a kind, under the domain the knowledge bases' DIDs use; which knowledge base a document is about is said inside it.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum StackApiVersion {
    #[serde(rename = "xynolog.org/v1alpha1")]
    XynologOrgV1alpha1,
}

impl StackApiVersion {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            StackApiVersion::XynologOrgV1alpha1 => "xynolog.org/v1alpha1",
        }
    }
}

schema!(StackApiVersion);

/// A knowledge base's record and the services that keep it: the Gateway, the Dispatcher, the Archivist, and the broker between them. They live and die with the knowledge base.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StackKnowledgeBase {
    #[serde(rename = "apiVersion")]
    pub api_version: StackApiVersion,
    pub kind: StackKnowledgeBaseKind,
    pub metadata: Metadata,
    /// The knowledge base's services, and how each runs.
    pub spec: StackKnowledgeBaseSpec,
}

impl StackKnowledgeBase {
    /// The `StackKnowledgeBase` that states these and nothing else.
    pub fn new(
        api_version: StackApiVersion,
        metadata: Metadata,
        spec: StackKnowledgeBaseSpec,
    ) -> Self {
        Self {
            api_version,
            kind: StackKnowledgeBaseKind::KnowledgeBase,
            metadata,
            spec,
        }
    }
}

schema!(StackKnowledgeBase);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum StackKnowledgeBaseKind {
    #[serde(rename = "KnowledgeBase")]
    KnowledgeBase,
}

impl StackKnowledgeBaseKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            StackKnowledgeBaseKind::KnowledgeBase => "KnowledgeBase",
        }
    }
}

/// The knowledge base's services, and how each runs.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StackKnowledgeBaseSpec {
    #[serde(rename = "logLevel")]
    pub log_level: LogLevel,
    /// The Gateway: where every client and every service reaches the knowledge base.
    pub gateway: StackKnowledgeBaseSpecGateway,
    /// The Dispatcher: it hands queued jobs to workers.
    pub dispatcher: StackKnowledgeBaseSpecDispatcher,
    /// The Archivist: it keeps the knowledge base's record in its working tree.
    pub archivist: StackKnowledgeBaseSpecArchivist,
    /// The broker the job queue and the signal plane share: the launcher's, run from `image`, or somebody else's, at `external`.
    pub messaging: StackKnowledgeBaseSpecMessaging,
    /// The issuer the knowledge base trusts: the one the launcher runs for the knowledge bases on a machine, at `shared`, with the knowledge base's own realm in it, or somebody else's, at `external`.
    pub issuer: StackKnowledgeBaseSpecIssuer,
}

/// The Archivist: it keeps the knowledge base's record in its working tree.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StackKnowledgeBaseSpecArchivist {
    pub image: Image,
    pub resources: Resources,
    /// Where the stack's services reach the Archivist, when that is somewhere the launcher cannot see. Absent, they reach it where the launcher places it.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub address: Option<HostPort>,
}

impl StackKnowledgeBaseSpecArchivist {
    /// The `StackKnowledgeBaseSpecArchivist` that states these and nothing else.
    pub fn new(image: Image, resources: Resources) -> Self {
        Self {
            image,
            resources,
            address: None,
        }
    }
}

/// The Dispatcher: it hands queued jobs to workers.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StackKnowledgeBaseSpecDispatcher {
    pub image: Image,
    pub resources: Resources,
}

/// The Gateway: where every client and every service reaches the knowledge base.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StackKnowledgeBaseSpecGateway {
    pub image: Image,
    pub resources: Resources,
    /// The port the Gateway is published on.
    pub port: u16,
    /// Where clients reach the Gateway: the server its API document names. A service of the stack reaches it where the launcher places it, on `port`.
    #[serde(rename = "publicURL")]
    pub public_u_r_l: String,
}

/// The issuer the knowledge base trusts: the one the launcher runs for the knowledge bases on a machine, at `shared`, with the knowledge base's own realm in it, or somebody else's, at `external`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StackKnowledgeBaseSpecIssuer {
    /// The issuer the launcher runs for the knowledge bases on a machine (the state home's Issuer document). The launcher creates the knowledge base's realm in it.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub shared: Option<StackKnowledgeBaseSpecIssuerShared>,
    /// An issuer somebody else runs.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub external: Option<StackKnowledgeBaseSpecIssuerExternal>,
    /// The claim a person's DID is built from: did:web:<site domain>:users:<its value>.
    #[serde(rename = "subjectClaim")]
    pub subject_claim: String,
}

impl StackKnowledgeBaseSpecIssuer {
    /// The `StackKnowledgeBaseSpecIssuer` that states these and nothing else.
    pub fn new(subject_claim: impl Into<String>) -> Self {
        Self {
            shared: None,
            external: None,
            subject_claim: subject_claim.into(),
        }
    }
}

/// An issuer somebody else runs.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StackKnowledgeBaseSpecIssuerExternal {
    /// `oidc`, or `keycloak`.
    pub r#type: String,
    /// The URL in its tokens' `iss` claim.
    pub url: String,
}

/// The issuer the launcher runs for the knowledge bases on a machine (the state home's Issuer document). The launcher creates the knowledge base's realm in it.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StackKnowledgeBaseSpecIssuerShared {
    /// How long a token the realm mints stays valid, in seconds: the window in which a disabled account can still act.
    #[serde(rename = "accessTokenLifespan")]
    pub access_token_lifespan: u64,
}

/// The broker the job queue and the signal plane share: the launcher's, run from `image`, or somebody else's, at `external`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StackKnowledgeBaseSpecMessaging {
    /// The Dispatcher's queue.
    pub jobs: StackKnowledgeBaseSpecMessagingJobs,
    /// The Gateway's signal plane.
    pub signal: StackKnowledgeBaseSpecMessagingSignal,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub image: Option<Image>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resources: Option<Resources>,
    /// A broker somebody else runs, serving this knowledge base alone: a second knowledge base on it would share the job queue and, on a `nats` signal plane, the frames and the gateway's record of pending replies. The launcher refuses to start a knowledge base whose `servers` another knowledge base on its machine names.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub external: Option<StackKnowledgeBaseSpecMessagingExternal>,
}

impl StackKnowledgeBaseSpecMessaging {
    /// The `StackKnowledgeBaseSpecMessaging` that states these and nothing else.
    pub fn new(
        jobs: StackKnowledgeBaseSpecMessagingJobs,
        signal: StackKnowledgeBaseSpecMessagingSignal,
    ) -> Self {
        Self {
            jobs,
            signal,
            image: None,
            resources: None,
            external: None,
        }
    }
}

/// A broker somebody else runs, serving this knowledge base alone: a second knowledge base on it would share the job queue and, on a `nats` signal plane, the frames and the gateway's record of pending replies. The launcher refuses to start a knowledge base whose `servers` another knowledge base on its machine names.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StackKnowledgeBaseSpecMessagingExternal {
    /// Where it listens: `host:port`.
    pub servers: String,
    pub user: SecretRef,
    pub password: SecretRef,
}

/// The Dispatcher's queue.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StackKnowledgeBaseSpecMessagingJobs {
    /// The queue's driver: `jetstream`.
    pub r#type: String,
}

/// The Gateway's signal plane.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StackKnowledgeBaseSpecMessagingSignal {
    /// `in-process`, one Gateway on its own fabric, or `nats`, on the broker.
    pub r#type: String,
}

/// stack.start's params: what xynolog start takes, but its help and its narration switches.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StackStartParams {
    /// The version of the control API the request is written to.
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    /// Which knowledge base's stack. Absent: the one the command line chooses, standing where the control server was started.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub target: Option<Target>,
    /// The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else every installed one.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub runtime: Option<Runtime>,
    /// The Inference document to run, as --config names it. Absent: the knowledge base's recorded preference, else the default.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub config: Option<String>,
    /// Just this one service, as --service names it.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub service: Option<String>,
    /// Just this one group of services, as --group names it.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub group: Option<ServiceGroup>,
    /// For a codespace target: which of the repository's codespaces, as --codespace names it.
    #[serde(rename = "codespaceName")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub codespace_name: Option<String>,
    /// For a codespace target being created: its VM class, as --machine names it.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub machine: Option<String>,
    /// For a codespace target being created: inactivity before it stops, as --idle-timeout takes it.
    #[serde(rename = "idleTimeout")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub idle_timeout: Option<String>,
    /// For a codespace target being created: how long a stopped codespace is kept, as --retention-period takes it.
    #[serde(rename = "retentionPeriod")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub retention_period: Option<String>,
    /// Whether to start the telemetry backends, Jaeger and Prometheus. false is --no-observe. Absent: true.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub observe: Option<bool>,
    /// Where a started Ollama keeps its models, as --ollama-cache names it. Absent: the host's ~/.ollama when there is one, else the named volume — what the command line's prompt does when nobody answers it.
    #[serde(rename = "ollamaCache")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub ollama_cache: Option<StackStartParamsOllamaCache>,
    /// Whether to run nothing, and report each runtime command a start would run as a command progress line.
    #[serde(rename = "dryRun")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub dry_run: Option<bool>,
}

impl StackStartParams {
    /// The `StackStartParams` that states these and nothing else.
    pub fn new(api_version: ApiVersion) -> Self {
        Self {
            api_version,
            target: None,
            runtime: None,
            config: None,
            service: None,
            group: None,
            codespace_name: None,
            machine: None,
            idle_timeout: None,
            retention_period: None,
            observe: None,
            ollama_cache: None,
            dry_run: None,
        }
    }
}

schema!(StackStartParams);

/// Where a started Ollama keeps its models, as --ollama-cache names it. Absent: the host's ~/.ollama when there is one, else the named volume — what the command line's prompt does when nobody answers it.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum StackStartParamsOllamaCache {
    #[serde(rename = "host")]
    Host,
    #[serde(rename = "volume")]
    Volume,
}

impl StackStartParamsOllamaCache {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            StackStartParamsOllamaCache::Host => "host",
            StackStartParamsOllamaCache::Volume => "volume",
        }
    }
}

/// A start that ran to its end: the stack as status reads it afterwards. A start that failed is an error, whatever it started before it did; its progress lines say what it did.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StackStartResult {
    /// Whether the start ran nothing.
    #[serde(rename = "dryRun")]
    pub dry_run: bool,
    /// The started knowledge base's stack, as status reads it after the start. Absent from a dry run, and from a start of services no knowledge base owns.
    #[serde(rename = "knowledgeBase")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub knowledge_base: Option<KnowledgeBaseStatus>,
    /// The shared services, as status reads them after the start. Absent from a dry run.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub shared: Option<Vec<ServiceStatus>>,
}

impl StackStartResult {
    /// The `StackStartResult` that states these and nothing else.
    pub fn new(dry_run: bool) -> Self {
        Self {
            dry_run,
            knowledge_base: None,
            shared: None,
        }
    }
}

schema!(StackStartResult);

/// stack.stop's params: what xynolog stop takes, but its help.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StackStopParams {
    /// The version of the control API the request is written to.
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    /// Which knowledge base's stack. Absent: the one the command line chooses, standing where the control server was started.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub target: Option<Target>,
    /// The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else every installed one.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub runtime: Option<Runtime>,
    /// Just this one service, as --service names it.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub service: Option<String>,
    /// Just this one group of services, as --group names it.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub group: Option<ServiceGroup>,
    /// For a codespace target: destroy the codespace, state and all, and forget its record. The command line's --delete. Refused without deleteConfirmed.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub delete: Option<bool>,
    /// That the person confirmed the deletion: delete is refused with control.confirmation-required without it.
    #[serde(rename = "deleteConfirmed")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub delete_confirmed: Option<bool>,
    /// Whether to stop nothing, and report each runtime command a stop would run as a command progress line.
    #[serde(rename = "dryRun")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub dry_run: Option<bool>,
}

impl StackStopParams {
    /// The `StackStopParams` that states these and nothing else.
    pub fn new(api_version: ApiVersion) -> Self {
        Self {
            api_version,
            target: None,
            runtime: None,
            service: None,
            group: None,
            delete: None,
            delete_confirmed: None,
            dry_run: None,
        }
    }
}

schema!(StackStopParams);

/// A stop that ran to its end: what status reads afterwards. A stop that failed is an error.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StackStopResult {
    /// Whether the stop stopped nothing.
    #[serde(rename = "dryRun")]
    pub dry_run: bool,
    /// The knowledge bases still recorded, as status reads them after the stop. Absent from a dry run.
    #[serde(rename = "knowledgeBases")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub knowledge_bases: Option<Vec<KnowledgeBaseStatus>>,
    /// The shared services, as status reads them after the stop. Absent from a dry run.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub shared: Option<Vec<ServiceStatus>>,
}

impl StackStopResult {
    /// The `StackStopResult` that states these and nothing else.
    pub fn new(dry_run: bool) -> Self {
        Self {
            dry_run,
            knowledge_bases: None,
            shared: None,
        }
    }
}

schema!(StackStopResult);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct StatusResponse {
    pub status: String,
    pub version: String,
    pub features: StatusResponseFeatures,
    pub message: String,
    #[serde(rename = "authenticatedAs")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub authenticated_as: Option<String>,
}

impl StatusResponse {
    /// The `StatusResponse` that states these and nothing else.
    pub fn new(
        status: impl Into<String>,
        version: impl Into<String>,
        features: StatusResponseFeatures,
        message: impl Into<String>,
    ) -> Self {
        Self {
            status: status.into(),
            version: version.into(),
            features,
            message: message.into(),
            authenticated_as: None,
        }
    }
}

schema!(StatusResponse);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct StatusResponseFeatures {
    #[serde(rename = "semanticContent")]
    pub semantic_content: String,
    pub collaboration: String,
}

/// status.snapshot's params.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StatusSnapshotParams {
    /// The version of the control API the request is written to.
    #[serde(rename = "apiVersion")]
    pub api_version: ApiVersion,
    /// Which knowledge base's stack. Absent: the one the command line chooses, standing where the control server was started.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub target: Option<Target>,
    /// The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else every installed one.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub runtime: Option<Runtime>,
}

impl StatusSnapshotParams {
    /// The `StatusSnapshotParams` that states these and nothing else.
    pub fn new(api_version: ApiVersion) -> Self {
        Self {
            api_version,
            target: None,
            runtime: None,
        }
    }
}

schema!(StatusSnapshotParams);

/// What xynolog status reports: each knowledge base with its own services, and each service the knowledge bases share, once, with the knowledge bases it serves.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StatusSnapshotResult {
    /// The target's stack; with no target, the stack of the knowledge base the control server stands in, else every recorded one.
    #[serde(rename = "knowledgeBases")]
    pub knowledge_bases: Vec<KnowledgeBaseStatus>,
    /// The services every knowledge base shares, group by group, and those the machine serves for the knowledge bases that name them.
    pub shared: Vec<ServiceStatus>,
}

schema!(StatusSnapshotResult);

/// One entry of the storage-uri index: the file `projections/storage-uri/<ab>/<cd>/<sha256 of the URI, hex>.json` under the state directory. It answers which resource's content is at a place in the working tree. Written as JSON indented by two spaces, `uri` first.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct StorageUriEntry {
    /// The `file://` URI of a place in the working tree, relative to the knowledge base's root.
    pub uri: String,
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
}

schema!(StorageUriEntry);

/// A persisted domain event with metadata. Flat shape — event fields and metadata are peers.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct StoredEventResponse {
    /// Unique event ID (UUID)
    pub id: String,
    /// Event type (flow verb name, e.g. mark:added)
    pub r#type: String,
    /// When the event occurred
    pub timestamp: String,
    /// DID of the user who triggered the event
    #[serde(rename = "userId")]
    pub user_id: UserId,
    /// Resource this event affects (absent for system events)
    #[serde(rename = "resourceId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resource_id: Option<ResourceId>,
    /// Event schema version
    pub version: i64,
    /// Event-type-specific payload
    pub payload: serde_json::Map<String, serde_json::Value>,
    pub metadata: EventMetadata,
}

impl StoredEventResponse {
    /// The `StoredEventResponse` that states these and nothing else.
    pub fn new(
        id: impl Into<String>,
        r#type: impl Into<String>,
        timestamp: impl Into<String>,
        user_id: UserId,
        version: i64,
        payload: serde_json::Map<String, serde_json::Value>,
        metadata: EventMetadata,
    ) -> Self {
        Self {
            id: id.into(),
            r#type: r#type.into(),
            timestamp: timestamp.into(),
            user_id,
            resource_id: None,
            version,
            payload,
            metadata,
        }
    }
}

schema!(StoredEventResponse);

/// What is kept of a sign-in: the tokens an issuer issued, the client they were issued to, and the issuer's endpoints a renewal and a sign-out need, learned once at sign-in so no session asks again. TOKENS, never a password. A stored value that lacks a member it requires is no session.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct StoredSession {
    /// The access token: short-lived, sent as a Bearer token.
    pub access: String,
    /// The refresh token: what renews the access token at the issuer without another sign-in.
    pub refresh: String,
    /// The client the tokens were issued to, which a renewal and a revocation name.
    #[serde(rename = "clientId")]
    pub client_id: String,
    /// The issuer's token endpoint, where the refresh grant is made.
    #[serde(rename = "tokenEndpoint")]
    pub token_endpoint: String,
    /// The issuer's revocation endpoint (RFC 7009), where a sign-out tells it to forget the refresh token. Absent when the issuer has none.
    #[serde(rename = "revocationEndpoint")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub revocation_endpoint: Option<String>,
    /// Who the gateway said the sign-in's person is, as the key their caches and stream position are kept under (`lastEventIdKeyPrefix`), never the did itself. Written once the gateway names the person, on the sign-in whose token it was asked about; a renewal keeps it, a new sign-in starts without it, and forgetting the sign-in, however it is forgotten, reads it first to delete what is kept under it. Absent for a sign-in whose gateway has not yet named its person.
    #[serde(rename = "personKey")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub person_key: Option<String>,
}

impl StoredSession {
    /// The `StoredSession` that states these and nothing else.
    pub fn new(
        access: impl Into<String>,
        refresh: impl Into<String>,
        client_id: impl Into<String>,
        token_endpoint: impl Into<String>,
    ) -> Self {
        Self {
            access: access.into(),
            refresh: refresh.into(),
            client_id: client_id.into(),
            token_endpoint: token_endpoint.into(),
            revocation_endpoint: None,
            person_key: None,
        }
    }
}

schema!(StoredSession);

/// Base MIME types (no parameters) admitted by Xynolog. Membership is the create/yield gate — every member is storable, nameable, and uploadable. What more the system can do with a type (render, annotate, extract text, author) is curated per type in @xynolog/core's media-type registry, which is keyed by this enum.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum SupportedMediaType {
    #[serde(rename = "text/plain")]
    TextPlain,
    #[serde(rename = "text/markdown")]
    TextMarkdown,
    #[serde(rename = "text/html")]
    TextHtml,
    #[serde(rename = "text/css")]
    TextCss,
    #[serde(rename = "text/csv")]
    TextCsv,
    #[serde(rename = "text/xml")]
    TextXml,
    #[serde(rename = "application/json")]
    ApplicationJson,
    #[serde(rename = "application/xml")]
    ApplicationXml,
    #[serde(rename = "application/yaml")]
    ApplicationYaml,
    #[serde(rename = "application/x-yaml")]
    ApplicationXYaml,
    #[serde(rename = "application/pdf")]
    ApplicationPdf,
    #[serde(rename = "application/msword")]
    ApplicationMsword,
    #[serde(rename = "application/vnd.openxmlformats-officedocument.wordprocessingml.document")]
    ApplicationVndOpenxmlformatsOfficedocumentWordprocessingmlDocument,
    #[serde(rename = "application/vnd.ms-excel")]
    ApplicationVndMsExcel,
    #[serde(rename = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")]
    ApplicationVndOpenxmlformatsOfficedocumentSpreadsheetmlSheet,
    #[serde(rename = "application/vnd.ms-powerpoint")]
    ApplicationVndMsPowerpoint,
    #[serde(rename = "application/vnd.openxmlformats-officedocument.presentationml.presentation")]
    ApplicationVndOpenxmlformatsOfficedocumentPresentationmlPresentation,
    #[serde(rename = "application/zip")]
    ApplicationZip,
    #[serde(rename = "application/gzip")]
    ApplicationGzip,
    #[serde(rename = "application/x-tar")]
    ApplicationXTar,
    #[serde(rename = "application/x-7z-compressed")]
    ApplicationX7zCompressed,
    #[serde(rename = "application/octet-stream")]
    ApplicationOctetStream,
    #[serde(rename = "application/wasm")]
    ApplicationWasm,
    #[serde(rename = "image/png")]
    ImagePng,
    #[serde(rename = "image/jpeg")]
    ImageJpeg,
    #[serde(rename = "image/gif")]
    ImageGif,
    #[serde(rename = "image/webp")]
    ImageWebp,
    #[serde(rename = "image/svg+xml")]
    ImageSvgPlusXml,
    #[serde(rename = "image/bmp")]
    ImageBmp,
    #[serde(rename = "image/tiff")]
    ImageTiff,
    #[serde(rename = "image/x-icon")]
    ImageXIcon,
    #[serde(rename = "video/mp4")]
    VideoMp4,
    #[serde(rename = "video/mpeg")]
    VideoMpeg,
    #[serde(rename = "video/webm")]
    VideoWebm,
    #[serde(rename = "video/ogg")]
    VideoOgg,
    #[serde(rename = "video/quicktime")]
    VideoQuicktime,
    #[serde(rename = "video/x-msvideo")]
    VideoXMsvideo,
    #[serde(rename = "audio/mpeg")]
    AudioMpeg,
    #[serde(rename = "audio/wav")]
    AudioWav,
    #[serde(rename = "audio/ogg")]
    AudioOgg,
    #[serde(rename = "audio/webm")]
    AudioWebm,
    #[serde(rename = "audio/aac")]
    AudioAac,
    #[serde(rename = "audio/flac")]
    AudioFlac,
    #[serde(rename = "text/javascript")]
    TextJavascript,
    #[serde(rename = "application/javascript")]
    ApplicationJavascript,
    #[serde(rename = "text/x-typescript")]
    TextXTypescript,
    #[serde(rename = "application/typescript")]
    ApplicationTypescript,
    #[serde(rename = "text/x-python")]
    TextXPython,
    #[serde(rename = "text/x-java")]
    TextXJava,
    #[serde(rename = "text/x-c")]
    TextXC,
    #[serde(rename = "text/x-c++")]
    TextXCPlusPlus,
    #[serde(rename = "text/x-csharp")]
    TextXCsharp,
    #[serde(rename = "text/x-go")]
    TextXGo,
    #[serde(rename = "text/x-rust")]
    TextXRust,
    #[serde(rename = "text/x-ruby")]
    TextXRuby,
    #[serde(rename = "text/x-php")]
    TextXPhp,
    #[serde(rename = "text/x-swift")]
    TextXSwift,
    #[serde(rename = "text/x-kotlin")]
    TextXKotlin,
    #[serde(rename = "text/x-shell")]
    TextXShell,
    #[serde(rename = "font/woff")]
    FontWoff,
    #[serde(rename = "font/woff2")]
    FontWoff2,
    #[serde(rename = "font/ttf")]
    FontTtf,
    #[serde(rename = "font/otf")]
    FontOtf,
}

impl SupportedMediaType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            SupportedMediaType::TextPlain => "text/plain",
            SupportedMediaType::TextMarkdown => "text/markdown",
            SupportedMediaType::TextHtml => "text/html",
            SupportedMediaType::TextCss => "text/css",
            SupportedMediaType::TextCsv => "text/csv",
            SupportedMediaType::TextXml => "text/xml",
            SupportedMediaType::ApplicationJson => "application/json",
            SupportedMediaType::ApplicationXml => "application/xml",
            SupportedMediaType::ApplicationYaml => "application/yaml",
            SupportedMediaType::ApplicationXYaml => "application/x-yaml",
            SupportedMediaType::ApplicationPdf => "application/pdf",
            SupportedMediaType::ApplicationMsword => "application/msword",
            SupportedMediaType::ApplicationVndOpenxmlformatsOfficedocumentWordprocessingmlDocument => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            SupportedMediaType::ApplicationVndMsExcel => "application/vnd.ms-excel",
            SupportedMediaType::ApplicationVndOpenxmlformatsOfficedocumentSpreadsheetmlSheet => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            SupportedMediaType::ApplicationVndMsPowerpoint => "application/vnd.ms-powerpoint",
            SupportedMediaType::ApplicationVndOpenxmlformatsOfficedocumentPresentationmlPresentation => "application/vnd.openxmlformats-officedocument.presentationml.presentation",
            SupportedMediaType::ApplicationZip => "application/zip",
            SupportedMediaType::ApplicationGzip => "application/gzip",
            SupportedMediaType::ApplicationXTar => "application/x-tar",
            SupportedMediaType::ApplicationX7zCompressed => "application/x-7z-compressed",
            SupportedMediaType::ApplicationOctetStream => "application/octet-stream",
            SupportedMediaType::ApplicationWasm => "application/wasm",
            SupportedMediaType::ImagePng => "image/png",
            SupportedMediaType::ImageJpeg => "image/jpeg",
            SupportedMediaType::ImageGif => "image/gif",
            SupportedMediaType::ImageWebp => "image/webp",
            SupportedMediaType::ImageSvgPlusXml => "image/svg+xml",
            SupportedMediaType::ImageBmp => "image/bmp",
            SupportedMediaType::ImageTiff => "image/tiff",
            SupportedMediaType::ImageXIcon => "image/x-icon",
            SupportedMediaType::VideoMp4 => "video/mp4",
            SupportedMediaType::VideoMpeg => "video/mpeg",
            SupportedMediaType::VideoWebm => "video/webm",
            SupportedMediaType::VideoOgg => "video/ogg",
            SupportedMediaType::VideoQuicktime => "video/quicktime",
            SupportedMediaType::VideoXMsvideo => "video/x-msvideo",
            SupportedMediaType::AudioMpeg => "audio/mpeg",
            SupportedMediaType::AudioWav => "audio/wav",
            SupportedMediaType::AudioOgg => "audio/ogg",
            SupportedMediaType::AudioWebm => "audio/webm",
            SupportedMediaType::AudioAac => "audio/aac",
            SupportedMediaType::AudioFlac => "audio/flac",
            SupportedMediaType::TextJavascript => "text/javascript",
            SupportedMediaType::ApplicationJavascript => "application/javascript",
            SupportedMediaType::TextXTypescript => "text/x-typescript",
            SupportedMediaType::ApplicationTypescript => "application/typescript",
            SupportedMediaType::TextXPython => "text/x-python",
            SupportedMediaType::TextXJava => "text/x-java",
            SupportedMediaType::TextXC => "text/x-c",
            SupportedMediaType::TextXCPlusPlus => "text/x-c++",
            SupportedMediaType::TextXCsharp => "text/x-csharp",
            SupportedMediaType::TextXGo => "text/x-go",
            SupportedMediaType::TextXRust => "text/x-rust",
            SupportedMediaType::TextXRuby => "text/x-ruby",
            SupportedMediaType::TextXPhp => "text/x-php",
            SupportedMediaType::TextXSwift => "text/x-swift",
            SupportedMediaType::TextXKotlin => "text/x-kotlin",
            SupportedMediaType::TextXShell => "text/x-shell",
            SupportedMediaType::FontWoff => "font/woff",
            SupportedMediaType::FontWoff2 => "font/woff2",
            SupportedMediaType::FontTtf => "font/ttf",
            SupportedMediaType::FontOtf => "font/otf",
        }
    }
}

schema!(SupportedMediaType);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct SvgSelector {
    pub r#type: SvgSelectorType,
    /// SVG markup defining the region (must include xmlns attribute)
    pub value: String,
}

impl SvgSelector {
    /// The `SvgSelector` that states these and nothing else.
    pub fn new(value: impl Into<String>) -> Self {
        Self {
            r#type: SvgSelectorType::SvgSelector,
            value: value.into(),
        }
    }
}

schema!(SvgSelector);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum SvgSelectorType {
    #[serde(rename = "SvgSelector")]
    SvgSelector,
}

impl SvgSelectorType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            SvgSelectorType::SvgSelector => "SvgSelector",
        }
    }
}

/// What checking one open resource against its knowledge base concluded. `gone` is the only verdict that closes it, and it means the knowledge base said the resource does not exist, not that the check failed: a failed transport, a timeout and a peer that is down are each `unknown`, and an unknown resource stays open.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Serialize)]
#[serde(untagged)]
pub enum TabCheck {
    Gone(TabCheckGone),
    Ready(TabCheckReady),
    Unknown(TabCheckUnknown),
}

impl<'de> serde::Deserialize<'de> for TabCheck {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("verdict").and_then(serde_json::Value::as_str) {
            Some("gone") => serde_json::from_value(value).map(TabCheck::Gone),
            Some("ready") => serde_json::from_value(value).map(TabCheck::Ready),
            Some("unknown") => serde_json::from_value(value).map(TabCheck::Unknown),
            _ => {
                return Err(serde::de::Error::custom(
                    "a TabCheck states a `verdict` that is one of `gone`, `ready`, `unknown`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

schema!(TabCheck);

/// The knowledge base said the resource does not exist.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct TabCheckGone {
    /// What checking an open resource against its knowledge base concluded.
    pub verdict: TabCheckGoneVerdict,
}

impl Default for TabCheckGone {
    fn default() -> Self {
        Self::new()
    }
}

impl TabCheckGone {
    /// The `TabCheckGone` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            verdict: TabCheckGoneVerdict::Gone,
        }
    }
}

/// What checking an open resource against its knowledge base concluded.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum TabCheckGoneVerdict {
    #[serde(rename = "gone")]
    Gone,
}

impl TabCheckGoneVerdict {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            TabCheckGoneVerdict::Gone => "gone",
        }
    }
}

/// The knowledge base has the resource, and said what it is called now.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct TabCheckReady {
    /// What checking an open resource against its knowledge base concluded.
    pub verdict: TabCheckReadyVerdict,
    /// The name the knowledge base gave the resource.
    pub name: String,
    /// The media type of its primary representation. Absent when it said none.
    #[serde(rename = "mediaType")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub media_type: Option<String>,
}

impl TabCheckReady {
    /// The `TabCheckReady` that states these and nothing else.
    pub fn new(name: impl Into<String>) -> Self {
        Self {
            verdict: TabCheckReadyVerdict::Ready,
            name: name.into(),
            media_type: None,
        }
    }
}

/// What checking an open resource against its knowledge base concluded.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum TabCheckReadyVerdict {
    #[serde(rename = "ready")]
    Ready,
}

impl TabCheckReadyVerdict {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            TabCheckReadyVerdict::Ready => "ready",
        }
    }
}

/// The check found out nothing.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct TabCheckUnknown {
    /// What checking an open resource against its knowledge base concluded.
    pub verdict: TabCheckUnknownVerdict,
}

impl Default for TabCheckUnknown {
    fn default() -> Self {
        Self::new()
    }
}

impl TabCheckUnknown {
    /// The `TabCheckUnknown` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            verdict: TabCheckUnknownVerdict::Unknown,
        }
    }
}

/// What checking an open resource against its knowledge base concluded.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum TabCheckUnknownVerdict {
    #[serde(rename = "unknown")]
    Unknown,
}

impl TabCheckUnknownVerdict {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            TabCheckUnknownVerdict::Unknown => "unknown",
        }
    }
}

/// What checking an open resource against its knowledge base concluded.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum TabVerdict {
    #[serde(rename = "gone")]
    Gone,
    #[serde(rename = "ready")]
    Ready,
    #[serde(rename = "unknown")]
    Unknown,
}

impl TabVerdict {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            TabVerdict::Gone => "gone",
            TabVerdict::Ready => "ready",
            TabVerdict::Unknown => "unknown",
        }
    }
}

schema!(TabVerdict);

/// A single category within a tag schema (e.g. 'Issue' in IRAC, 'distinguished' in legal-citation-treatment). Each category carries methodology-bound semantics: a name, a description, and examples used in the LLM prompt.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct TagCategory {
    pub name: String,
    pub description: String,
    pub examples: Vec<String>,
}

schema!(TagCategory);

/// A structural-analysis schema (e.g. legal-irac, scientific-imrad, argument-toulmin). Defines a methodology framework as an id, name, description, domain hint, and an ordered list of categories. KBs and their skills register schemas with the runtime registry via `frame.addTagSchema(...)` at session start.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct TagSchema {
    pub id: String,
    pub name: String,
    pub description: String,
    /// Free-form domain hint (e.g. 'legal', 'scientific', 'general'). Used in the LLM prompt to tune the model's analysis voice. KB authors choose.
    pub domain: String,
    pub tags: Vec<TagCategory>,
}

schema!(TagSchema);

/// Payload for frame:tag-schema-added domain event (system-level, no resourceId — fan-out is global to the KB).
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct TagSchemaAddedPayload {
    pub schema: TagSchema,
}

schema!(TagSchemaAddedPayload);

/// The knowledge base's tag schemas: the file `projections/__system__/tagschemas.json` under the state directory, the sum of the `frame:tag-schema-added` events. Written as JSON indented by two spaces.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct TagSchemasProjection {
    /// Every tag schema added, sorted by `id`. A schema added again under an `id` replaces the one held.
    #[serde(rename = "tagSchemas")]
    pub tag_schemas: Vec<TagSchema>,
}

schema!(TagSchemasProjection);

/// What a tagging job takes: passages of the resource are marked with categories of one tag schema.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct TaggingJobParams {
    pub motivation: TaggingJobParamsMotivation,
    /// The tag schema to tag by. It is one the knowledge base registers.
    #[serde(rename = "schemaId")]
    pub schema_id: String,
    /// The categories of that schema to tag with.
    pub categories: Vec<String>,
    /// The language the annotations' own text is written in. BCP 47.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub language: Option<String>,
    /// The language of the resource being read. BCP 47.
    #[serde(rename = "sourceLanguage")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub source_language: Option<String>,
}

impl TaggingJobParams {
    /// The `TaggingJobParams` that states these and nothing else.
    pub fn new(schema_id: impl Into<String>, categories: Vec<String>) -> Self {
        Self {
            motivation: TaggingJobParamsMotivation::Tagging,
            schema_id: schema_id.into(),
            categories,
            language: None,
            source_language: None,
        }
    }
}

schema!(TaggingJobParams);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum TaggingJobParamsMotivation {
    #[serde(rename = "tagging")]
    Tagging,
}

impl TaggingJobParamsMotivation {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            TaggingJobParamsMotivation::Tagging => "tagging",
        }
    }
}

/// Which knowledge base an operation acts on: a local clone's stack, or a codespace's. The launcher resolves it as the command line resolves --root and --repo, and refuses a choice it would have to guess.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct Target {
    /// Where the stack runs: on this machine (local), or on a GitHub codespace whose knowledge base is forwarded here (codespace).
    pub kind: TargetKind,
    /// For a local target: the knowledge base's clone, by path or by the basename of a registered root, as --root takes it. Absent: the local stack the command line chooses with --runtime, standing where the control server was started.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub root: Option<String>,
    /// For a codespace target: the GitHub repository, as --repo takes it.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub repo: Option<String>,
}

impl Target {
    /// The `Target` that states these and nothing else.
    pub fn new(kind: TargetKind) -> Self {
        Self {
            kind,
            root: None,
            repo: None,
        }
    }
}

schema!(Target);

/// Where the stack runs: on this machine (local), or on a GitHub codespace whose knowledge base is forwarded here (codespace).
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum TargetKind {
    #[serde(rename = "local")]
    Local,
    #[serde(rename = "codespace")]
    Codespace,
}

impl TargetKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            TargetKind::Local => "local",
            TargetKind::Codespace => "codespace",
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct TextPositionSelector {
    pub r#type: TextPositionSelectorType,
    /// Offset into the resource's decoded text, exactly as decoded, in Unicode code points from its start: where the selected text starts.
    pub start: u64,
    /// Offset into the resource's decoded text, exactly as decoded, in Unicode code points from its start: just past where the selected text ends.
    pub end: u64,
}

impl TextPositionSelector {
    /// The `TextPositionSelector` that states these and nothing else.
    pub fn new(start: u64, end: u64) -> Self {
        Self {
            r#type: TextPositionSelectorType::TextPositionSelector,
            start,
            end,
        }
    }
}

schema!(TextPositionSelector);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum TextPositionSelectorType {
    #[serde(rename = "TextPositionSelector")]
    TextPositionSelector,
}

impl TextPositionSelectorType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            TextPositionSelectorType::TextPositionSelector => "TextPositionSelector",
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct TextQuoteSelector {
    pub r#type: TextQuoteSelectorType,
    pub exact: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub prefix: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub suffix: Option<String>,
}

impl TextQuoteSelector {
    /// The `TextQuoteSelector` that states these and nothing else.
    pub fn new(exact: impl Into<String>) -> Self {
        Self {
            r#type: TextQuoteSelectorType::TextQuoteSelector,
            exact: exact.into(),
            prefix: None,
            suffix: None,
        }
    }
}

schema!(TextQuoteSelector);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum TextQuoteSelectorType {
    #[serde(rename = "TextQuoteSelector")]
    TextQuoteSelector,
}

impl TextQuoteSelectorType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            TextQuoteSelectorType::TextQuoteSelector => "TextQuoteSelector",
        }
    }
}

/// A span of a text: the code points from `start` up to but not including `end`, the words they are, and maybe the text just before and just after them.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct TextSpan {
    /// The offset the span starts at, in Unicode code points from the text's start.
    pub start: u64,
    /// The offset just past the span, in Unicode code points from the text's start.
    pub end: u64,
    /// The words quoted.
    pub exact: String,
    /// The text just before them.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub prefix: Option<String>,
    /// The text just after them.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub suffix: Option<String>,
}

impl TextSpan {
    /// The `TextSpan` that states these and nothing else.
    pub fn new(start: u64, end: u64, exact: impl Into<String>) -> Self {
        Self {
            start,
            end,
            exact: exact.into(),
            prefix: None,
            suffix: None,
        }
    }
}

schema!(TextSpan);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct TextualBody {
    pub r#type: TextualBodyType,
    /// The text content (e.g., entity type name)
    pub value: String,
    /// Why this body is included
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub purpose: Option<BodyPurpose>,
    /// MIME type (defaults to text/plain)
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub format: Option<String>,
    /// BCP 47 language tag
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub language: Option<String>,
}

impl TextualBody {
    /// The `TextualBody` that states these and nothing else.
    pub fn new(value: impl Into<String>) -> Self {
        Self {
            r#type: TextualBodyType::TextualBody,
            value: value.into(),
            purpose: None,
            format: None,
            language: None,
        }
    }
}

schema!(TextualBody);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum TextualBodyType {
    #[serde(rename = "TextualBody")]
    TextualBody,
}

impl TextualBodyType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            TextualBodyType::TextualBody => "TextualBody",
        }
    }
}

/// The furthest a single unit got, and what it had counted when it got there. A unit left partway is resumed from its cursor rather than redone. A finished unit keeps its cursor: `next` at the length of the text, `size` the size its last piece was cut at, and its final `found`, `emitted` and `errors`, so that an attempt that skips the unit still counts it. A cursor never says a unit is finished, wherever it stands: `completedUnits` does. A unit is an entity type for a linking job, a category for a tagging job, and the job's own motivation for every other — which is why a unit-grain checkpoint alone is too coarse: those three have exactly one unit, so nothing could be recorded until the whole document was done.
///
/// MERGE IS MONOTONE PER UNIT, not a union. `completedUnits` is a set and converges under concurrent snapshots because a set only grows; a cursor converges only if a stale snapshot can never move it backward.
///
/// IT CARRIES THE UNIT'S RUNNING TALLIES TOO, and they are required. A resumed unit counts only the chunks it actually runs, so without them a retry's terminal record reports the remainder of the document as if it were the whole — measured at a `found` of 19 where the document yielded 25. The position and the tallies are ONE observation of the same committed chunk; splitting them would let a resume take the saving and still report a number nobody can trust.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct UnitCursor {
    /// Unicode code points of the text consumed once the last COMMITTED chunk completed — the resume position, and the length of the text for a unit whose last chunk it was. Deliberately the chunk's `next`, never its `at`: the checkpoint must not lead the log, so it records where a chunk that is already durable ended, not where the in-flight one began. Recording `at` would make a resume re-run the chunk it already paid for.
    pub next: u64,
    /// The token size that last committed chunk was cut at — the calibration the attempt paid for over the chunks before it. A resume seeds from this and then takes ONE adaptive step, as if the last outcome were a failure, which it was: the job died. Seeding alone would re-cut the failing piece identically; opening at the default would discard the calibration.
    pub size: u64,
    /// Items detection has returned for this unit through the last committed chunk — the numerator a resumed attempt continues from rather than restarting at zero. Counts what the model reported, before dedupe.
    pub found: u64,
    /// Annotations actually committed for this unit through the last committed chunk, after dedupe. With `found` and `errors` it is what the job's terminal result reports, so a resumed unit seeds all three and its record describes the whole document rather than one attempt's share.
    pub emitted: u64,
    /// Items detection returned for this unit through the last committed chunk that could not be anchored in the text. Carried with the other two tallies so that a resumed job reports the whole document's, and not only its last attempt's.
    pub errors: u64,
}

schema!(UnitCursor);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct UpdateAnnotationBodyRequest {
    /// Resource ID containing the annotation (required for O(1) Layer 3 lookup)
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// Array of body modification operations to apply
    pub operations: Vec<BodyOperation>,
}

schema!(UpdateAnnotationBodyRequest);

/// What an upload reports as it goes, told apart by `phase`: its size first, then the bytes sent so far, then the resource made.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Serialize)]
#[serde(untagged)]
pub enum UploadProgress {
    Started(UploadProgressStarted),
    Progress(UploadProgressProgress),
    Finished(UploadProgressFinished),
}

impl<'de> serde::Deserialize<'de> for UploadProgress {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("phase").and_then(serde_json::Value::as_str) {
            Some("started") => serde_json::from_value(value).map(UploadProgress::Started),
            Some("progress") => serde_json::from_value(value).map(UploadProgress::Progress),
            Some("finished") => serde_json::from_value(value).map(UploadProgress::Finished),
            _ => {
                return Err(serde::de::Error::custom(
                    "a UploadProgress states a `phase` that is one of `started`, `progress`, `finished`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

schema!(UploadProgress);

/// The upload ended, and the resource is made.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct UploadProgressFinished {
    pub phase: UploadProgressFinishedPhase,
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
}

impl UploadProgressFinished {
    /// The `UploadProgressFinished` that states these and nothing else.
    pub fn new(resource_id: ResourceId) -> Self {
        Self {
            phase: UploadProgressFinishedPhase::Finished,
            resource_id,
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum UploadProgressFinishedPhase {
    #[serde(rename = "finished")]
    Finished,
}

impl UploadProgressFinishedPhase {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            UploadProgressFinishedPhase::Finished => "finished",
        }
    }
}

/// Bytes were sent.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct UploadProgressProgress {
    pub phase: UploadProgressProgressPhase,
    /// How many bytes are sent so far.
    #[serde(rename = "bytesUploaded")]
    pub bytes_uploaded: u64,
    /// How many bytes the upload is.
    #[serde(rename = "totalBytes")]
    pub total_bytes: u64,
}

impl UploadProgressProgress {
    /// The `UploadProgressProgress` that states these and nothing else.
    pub fn new(bytes_uploaded: u64, total_bytes: u64) -> Self {
        Self {
            phase: UploadProgressProgressPhase::Progress,
            bytes_uploaded,
            total_bytes,
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum UploadProgressProgressPhase {
    #[serde(rename = "progress")]
    Progress,
}

impl UploadProgressProgressPhase {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            UploadProgressProgressPhase::Progress => "progress",
        }
    }
}

/// The upload began.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct UploadProgressStarted {
    pub phase: UploadProgressStartedPhase,
    /// How many bytes the upload is.
    #[serde(rename = "totalBytes")]
    pub total_bytes: u64,
}

impl UploadProgressStarted {
    /// The `UploadProgressStarted` that states these and nothing else.
    pub fn new(total_bytes: u64) -> Self {
        Self {
            phase: UploadProgressStartedPhase::Started,
            total_bytes,
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum UploadProgressStartedPhase {
    #[serde(rename = "started")]
    Started,
}

impl UploadProgressStartedPhase {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            UploadProgressStartedPhase::Started => "started",
        }
    }
}

/// A sign-in waits for a person: open the verification page and enter the code. The code is sent here and nowhere else — in no progress line, no log record and no diagnostic.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct UserAction {
    #[serde(rename = "requestId")]
    pub request_id: RequestId,
    /// The page where the person enters the code.
    #[serde(rename = "verificationUri")]
    pub verification_uri: String,
    /// The page with the code already in it, when the issuer offers one.
    #[serde(rename = "verificationUriComplete")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub verification_uri_complete: Option<String>,
    /// The code the person enters.
    #[serde(rename = "userCode")]
    pub user_code: String,
    /// How long the code is good for, from when it was issued.
    #[serde(rename = "expiresInSeconds")]
    pub expires_in_seconds: u64,
}

impl UserAction {
    /// The `UserAction` that states these and nothing else.
    pub fn new(
        request_id: RequestId,
        verification_uri: impl Into<String>,
        user_code: impl Into<String>,
        expires_in_seconds: u64,
    ) -> Self {
        Self {
            request_id,
            verification_uri: verification_uri.into(),
            verification_uri_complete: None,
            user_code: user_code.into(),
            expires_in_seconds,
        }
    }
}

schema!(UserAction);

/// The identity of whoever did something, a person or a software agent alike: a DID (`did:web:<domain>:users:<subject>`, `did:web:<domain>:agents:<subject>`), with no whitespace in it. Never a name, an address, or a row in a table. What follows `did:` is not constrained further: a subject is the issuer's, percent-encoded, and that encoding leaves some punctuation as it is.
#[derive(
    Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
#[serde(try_from = "String", into = "String")]
pub struct UserId(String);

impl UserId {
    /// The rule a value is held to, as the spec writes it.
    pub const PATTERN: &'static str = "^did:\\S+$";

    /// The pattern as the rule `new` holds a value to.
    const RULE: Rule = Rule {
        prefix: "did:",
        admitted: Admitted::NotWhitespace,
        least: 1,
        most: None,
    };

    /// `value` as a `UserId`, or that it is not one.
    pub fn new(value: impl Into<String>) -> Result<UserId, InvalidIdentifier> {
        let value = value.into();
        if UserId::RULE.admits(&value) {
            Ok(UserId(value))
        } else {
            Err(InvalidIdentifier {
                kind: "UserId",
                pattern: UserId::PATTERN,
                value,
            })
        }
    }

    pub fn as_str(&self) -> &str {
        &self.0
    }
}

impl std::fmt::Display for UserId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(&self.0)
    }
}

impl std::ops::Deref for UserId {
    type Target = str;

    fn deref(&self) -> &str {
        &self.0
    }
}

impl AsRef<str> for UserId {
    fn as_ref(&self) -> &str {
        &self.0
    }
}

impl std::str::FromStr for UserId {
    type Err = InvalidIdentifier;

    fn from_str(value: &str) -> Result<UserId, InvalidIdentifier> {
        UserId::new(value)
    }
}

impl TryFrom<String> for UserId {
    type Error = InvalidIdentifier;

    fn try_from(value: String) -> Result<UserId, InvalidIdentifier> {
        UserId::new(value)
    }
}

impl From<UserId> for String {
    fn from(id: UserId) -> String {
        id.0
    }
}

impl PartialEq<str> for UserId {
    fn eq(&self, other: &str) -> bool {
        self.0 == other
    }
}

impl PartialEq<&str> for UserId {
    fn eq(&self, other: &&str) -> bool {
        self.0 == *other
    }
}

schema!(UserId);

/// The authenticated principal, as this knowledge base names it.
///
/// The `did` is the identity: it is what the bus stamps on every event, what resource creation is attributed to, and what a client must compare against to recognise its own work in the data. It is the only identifier: a row id would appear nowhere else in the system and correlate with nothing.
///
/// The remaining fields exist to be displayed, and all of them come from the token's own claims.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct UserResponse {
    /// The authenticated principal's DID: `did:web:<domain>:agents:<subject>` for an agent, whose token's `kind` claim is `agent`, and `did:web:<domain>:users:<subject>` for a person, where the subject is the issuer claim the knowledge base names its principals by (`identity.subjectClaim`).
    pub did: UserId,
    /// The address the token carries, when it carries one: an agent's account need not have one.
    pub email: Option<String>,
    pub name: Option<String>,
    pub image: Option<String>,
    /// The knowledge base's domain: the authority the principal is named under.
    pub domain: String,
}

schema!(UserResponse);

/// The vector store the launcher runs for the knowledge bases on a machine, each knowledge base's index in collections of its own. It belongs to no knowledge base, so its document is kept in the launcher's state home, in `stack/vectors.yaml`, not in a knowledge base's repository. A knowledge base keeps its index in it by naming `shared` at `spec.vectors`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct VectorStore {
    #[serde(rename = "apiVersion")]
    pub api_version: StackApiVersion,
    pub kind: VectorStoreKind,
    pub metadata: Metadata,
    /// The vector store, and where it is published.
    pub spec: VectorStoreSpec,
}

impl VectorStore {
    /// The `VectorStore` that states these and nothing else.
    pub fn new(api_version: StackApiVersion, metadata: Metadata, spec: VectorStoreSpec) -> Self {
        Self {
            api_version,
            kind: VectorStoreKind::VectorStore,
            metadata,
            spec,
        }
    }
}

schema!(VectorStore);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum VectorStoreKind {
    #[serde(rename = "VectorStore")]
    VectorStore,
}

impl VectorStoreKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            VectorStoreKind::VectorStore => "VectorStore",
        }
    }
}

/// The vector store, and where it is published.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct VectorStoreSpec {
    /// The vector store's driver: `qdrant`.
    pub r#type: String,
    pub image: Image,
    pub resources: Resources,
    /// The port the vector store is published on, on this machine, where every knowledge base's Smelter and Librarian reach it.
    pub port: u16,
}

/// The vector index a service writes or searches, and what that kind of index needs to be reached: one of the kinds `xynolog-vectors` has a store for, told apart by `type`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Serialize)]
#[serde(untagged)]
pub enum VectorsConfig {
    QdrantVectorsConfig(QdrantVectorsConfig),
    MemoryVectorsConfig(MemoryVectorsConfig),
}

impl<'de> serde::Deserialize<'de> for VectorsConfig {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
        let member = match value.get("type").and_then(serde_json::Value::as_str) {
            Some("qdrant") => serde_json::from_value(value).map(VectorsConfig::QdrantVectorsConfig),
            Some("memory") => serde_json::from_value(value).map(VectorsConfig::MemoryVectorsConfig),
            _ => {
                return Err(serde::de::Error::custom(
                    "a VectorsConfig states a `type` that is one of `qdrant`, `memory`",
                ));
            }
        };
        member.map_err(serde::de::Error::custom)
    }
}

member!(VectorsConfig::QdrantVectorsConfig(QdrantVectorsConfig));
member!(VectorsConfig::MemoryVectorsConfig(MemoryVectorsConfig));
schema!(VectorsConfig);

/// An embedding model served by Voyage AI. No service has been run against Voyage itself.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct VoyageEmbeddingConfig {
    pub r#type: VoyageEmbeddingConfigType,
    /// The model asked for, by Voyage's name for it.
    pub model: String,
    /// The whole address of Voyage's embeddings call (`https://api.voyageai.com/v1/embeddings`).
    pub endpoint: String,
    /// The environment variable holding the Voyage API key. The key is never a value here.
    #[serde(rename = "apiKeyEnv")]
    pub api_key_env: String,
}

impl VoyageEmbeddingConfig {
    /// The `VoyageEmbeddingConfig` that states these and nothing else.
    pub fn new(
        model: impl Into<String>,
        endpoint: impl Into<String>,
        api_key_env: impl Into<String>,
    ) -> Self {
        Self {
            r#type: VoyageEmbeddingConfigType::Voyage,
            model: model.into(),
            endpoint: endpoint.into(),
            api_key_env: api_key_env.into(),
        }
    }
}

schema!(VoyageEmbeddingConfig);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum VoyageEmbeddingConfigType {
    #[serde(rename = "voyage")]
    Voyage,
}

impl VoyageEmbeddingConfigType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            VoyageEmbeddingConfigType::Voyage => "voyage",
        }
    }
}

/// The payload of `weave:applied`: the Weaver has applied a resource's events to the graph up to this sequence number. Emitted after applying an event, or a batch's last event.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct WeaveApplied {
    /// The resource whose events were applied.
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// The resource-stream sequence of the last applied event.
    #[serde(rename = "sequenceNumber")]
    pub sequence_number: i64,
}

schema!(WeaveApplied);

/// Bus command to rebuild the graph projection from the event log — the whole graph when resourceId is absent, one resource when present. Served by the Weaver; replaces direct rebuild access, which does not survive the Weaver's container split.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct WeaveRebuildCommand {
    /// When present, rebuild only this resource; otherwise clear and rebuild the entire graph.
    #[serde(rename = "resourceId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resource_id: Option<ResourceId>,
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
}

schema!(WeaveRebuildCommand);

/// Everything a Weaver reads at boot: nothing in it is defaulted by the Weaver. The launcher writes it for the Weaver it starts, from the knowledge base's stack documents, and the Weaver reads it from the path its `--config` flag names (its image passes `/etc/xynolog/weaver.json`). Whoever starts a Weaver another way writes the same document: this schema is the contract, and a Weaver needs no launcher. Started without `--config`, or with a path that names no file, the Weaver refuses to start and says which. No secret is a value here: the graph database's password is named by the environment variable that holds it, and the Weaver's own service account is `XYNOLOG_OIDC_CLIENT_ID` and `XYNOLOG_OIDC_CLIENT_SECRET` in its environment. A document that does not validate is refused at boot, naming each failing field.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WeaverConfig {
    pub kb: KbIdentity,
    /// The URL the Weaver reaches the gateway at: its route to the bus.
    #[serde(rename = "gatewayUrl")]
    pub gateway_url: String,
    /// The issuer the Weaver's service account signs in at.
    pub identity: ServiceIdentity,
    /// Where the Archivist listens. The Weaver reads the record by position from it, and a resource's annotations, as its service account.
    pub archivist: ServiceAddress,
    pub graph: GraphConfig,
    #[serde(rename = "cursorsPath")]
    pub cursors_path: CursorsPath,
    /// The port the Weaver answers `/health` on.
    pub port: u16,
    #[serde(rename = "logLevel")]
    pub log_level: LogLevel,
    #[serde(rename = "logFormat")]
    pub log_format: LogFormat,
}

schema!(WeaverConfig);

/// The Weaver's health answer (WEAVER.md § Health). `status` is `ok` whenever the Weaver answers: it says nothing of whether the Weaver can reach the gateway or the graph.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WeaverHealth {
    pub status: WeaverHealthStatus,
    /// The DID of the knowledge base it serves: the one its settings name, which that knowledge base said it is before the Weaver connected to the graph database.
    pub kb: KbDid,
    pub following: FollowerFollowing,
    /// How far the reconcile its first sweep is followed by has got (WEAVER.md § Reconcile): the pass's `summary` when it is done, or its `error` when it failed.
    pub reconcile: WeaverHealthReconcile,
}

impl WeaverHealth {
    /// The `WeaverHealth` that states these and nothing else.
    pub fn new(kb: KbDid, following: FollowerFollowing, reconcile: WeaverHealthReconcile) -> Self {
        Self {
            status: WeaverHealthStatus::Ok,
            kb,
            following,
            reconcile,
        }
    }
}

schema!(WeaverHealth);

/// How far the reconcile its first sweep is followed by has got (WEAVER.md § Reconcile): the pass's `summary` when it is done, or its `error` when it failed.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WeaverHealthReconcile {
    pub phase: WeaverHealthReconcilePhase,
    /// What the pass found and did.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub summary: Option<WeaverHealthReconcileSummary>,
    /// Why it failed.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub error: Option<String>,
}

impl WeaverHealthReconcile {
    /// The `WeaverHealthReconcile` that states these and nothing else.
    pub fn new(phase: WeaverHealthReconcilePhase) -> Self {
        Self {
            phase,
            summary: None,
            error: None,
        }
    }
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum WeaverHealthReconcilePhase {
    #[serde(rename = "pending")]
    Pending,
    #[serde(rename = "running")]
    Running,
    #[serde(rename = "done")]
    Done,
    #[serde(rename = "failed")]
    Failed,
}

impl WeaverHealthReconcilePhase {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            WeaverHealthReconcilePhase::Pending => "pending",
            WeaverHealthReconcilePhase::Running => "running",
            WeaverHealthReconcilePhase::Done => "done",
            WeaverHealthReconcilePhase::Failed => "failed",
        }
    }
}

/// What the pass found and did.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WeaverHealthReconcileSummary {
    /// How many resources it checked.
    #[serde(rename = "resourcesChecked")]
    pub resources_checked: u64,
    /// How many of them were divergent: the graph held them otherwise than the record.
    pub divergent: u64,
    /// How many divergent resources it rebuilt.
    pub healed: u64,
    /// How many it did not heal, because the rebuild stopped at an event it could not apply.
    #[serde(rename = "healFailures")]
    pub heal_failures: u64,
    /// How many orphaned views it found: resources the catalog lists and the record holds no events for. Each is counted, and not healed.
    pub orphaned: u64,
}

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum WeaverHealthStatus {
    #[serde(rename = "ok")]
    Ok,
}

impl WeaverHealthStatus {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            WeaverHealthStatus::Ok => "ok",
        }
    }
}

/// worker/answer-formats.json: the element of the array each kind of detection asks a model for.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerAnswerFormats {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    pub formats: Vec<WorkerAnswerFormatsFormatsItem>,
}

schema!(WorkerAnswerFormats);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerAnswerFormatsFormatsItem {
    /// A motivation a `mark` job takes, or `count`.
    pub name: String,
    /// What an element is, in prose.
    pub about: String,
    pub element: serde_json::Value,
}

/// Everything a worker reads at boot: nothing in it is defaulted by the worker. The launcher writes it for the machine's worker, from the knowledge bases on that worker's list: each local knowledge base as its start places it, from its stack documents, and each added by `xynolog worker kb add`, offered the engines of the local one it was added from. The worker reads it from the path its `--config` flag names (its image passes `/etc/xynolog/worker.json`). Whoever starts a worker another way writes the same document: this schema is the contract, and a worker needs no launcher. Started without `--config`, or with a path that names no file, the worker refuses to start and says which. No secret is a value here: a provider's key is named by the environment variable that holds it, and the key the worker signs in with at every knowledge base is `XYNOLOG_OIDC_CLIENT_KEY` in its environment, an RSA private key; each knowledge base names the client that holds its public half there. A document that does not validate is refused at boot, naming each failing field.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerConfig {
    /// The knowledge bases this worker does jobs for. At each it signs in, confirms which knowledge base it reached and claims for its engines, apart from every other: one knowledge base's trouble stops that knowledge base's work alone (`contract/WORKER-SERVICE.md` § Knowledge bases). No two name one `domain`, which the worker refuses at boot.
    #[serde(rename = "knowledgeBases")]
    pub knowledge_bases: Vec<WorkerKnowledgeBaseConfig>,
    /// The path of a model catalogue file: what each model of a provider can take, for the providers whose own APIs do not say (`google`, `openai`, `together`). A worker with an engine of one of those providers refuses to start where the file cannot be read, and where it states nothing of that engine's model. A worker with no such engine does not read it.
    #[serde(rename = "modelCatalogue")]
    pub model_catalogue: String,
    /// The port the worker answers `/health` on.
    pub port: u16,
    #[serde(rename = "logLevel")]
    pub log_level: LogLevel,
    #[serde(rename = "logFormat")]
    pub log_format: LogFormat,
}

schema!(WorkerConfig);

/// One engine a worker runs: which it is, the jobs the worker claims to do with it, and where its provider is reached.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerEngineConfig {
    pub engine: Engine,
    /// The jobs the worker claims to do with this engine, as a claim names them (`job:claim`'s `accepts`): it claims with these filters and no other.
    pub jobs: Vec<JobFilter>,
    /// The address the provider's API is reached at.
    #[serde(rename = "baseUrl")]
    pub base_url: String,
    /// The environment variable holding the provider's API key, when the provider requires one.
    #[serde(rename = "apiKeyEnv")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub api_key_env: Option<String>,
}

impl WorkerEngineConfig {
    /// The `WorkerEngineConfig` that states these and nothing else.
    pub fn new(engine: Engine, jobs: Vec<JobFilter>, base_url: impl Into<String>) -> Self {
        Self {
            engine,
            jobs,
            base_url: base_url.into(),
            api_key_env: None,
        }
    }
}

schema!(WorkerEngineConfig);

/// One engine at one knowledge base: which it is, the jobs it claims, and what its claims can say of themselves (WORKER-CONTRACT V1).
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerEngineHealth {
    pub engine: Engine,
    /// The jobs it claims, as its claims state them.
    pub jobs: Vec<JobFilter>,
    /// When a `job:queued` last reached it, or null.
    #[serde(rename = "lastQueuedEventAt")]
    pub last_queued_event_at: Option<String>,
    /// When it was last handed a job, or null. A claim answered with none pending is not one.
    #[serde(rename = "lastClaimAt")]
    pub last_claim_at: Option<String>,
    /// When a job it held last settled, or null.
    #[serde(rename = "lastFinishedAt")]
    pub last_finished_at: Option<String>,
    /// When it was last active, or null.
    #[serde(rename = "lastActivityAt")]
    pub last_activity_at: Option<String>,
    /// The job it holds, or null.
    #[serde(rename = "activeJob")]
    pub active_job: Option<WorkerEngineHealthActiveJob>,
    /// How many jobs it has completed since the service started.
    #[serde(rename = "jobsCompleted")]
    pub jobs_completed: u64,
}

schema!(WorkerEngineHealth);

/// The job it holds, or null.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerEngineHealthActiveJob {
    #[serde(rename = "jobId")]
    pub job_id: JobId,
    pub r#type: JobType,
    /// When it was handed the job.
    pub since: String,
}

/// The Worker service's health answer (WORKER-SERVICE H1). It answers only once a knowledge base of its document is confirmed, so a 200 means it is working somewhere.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerHealth {
    pub status: WorkerHealthStatus,
    /// One entry for each of the document's `knowledgeBases`, in its order.
    #[serde(rename = "knowledgeBases")]
    pub knowledge_bases: Vec<WorkerKnowledgeBaseHealth>,
}

impl WorkerHealth {
    /// The `WorkerHealth` that states these and nothing else.
    pub fn new(knowledge_bases: Vec<WorkerKnowledgeBaseHealth>) -> Self {
        Self {
            status: WorkerHealthStatus::Ok,
            knowledge_bases,
        }
    }
}

schema!(WorkerHealth);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum WorkerHealthStatus {
    #[serde(rename = "ok")]
    Ok,
}

impl WorkerHealthStatus {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            WorkerHealthStatus::Ok => "ok",
        }
    }
}

/// One knowledge base a worker does jobs for: which it is, where its gateway is, the account the worker signs in as there, and the engines it offers it. The worker signs in, confirms the knowledge base and claims at each knowledge base apart from every other.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerKnowledgeBaseConfig {
    /// The knowledge base's did:web domain, as it answers `browse:kb-requested`: which knowledge base this is. The worker confirms it there before it claims, and refuses a knowledge base that answers another domain, or none.
    pub domain: String,
    /// The URL the worker reaches the knowledge base's gateway at: its route to the bus and to a resource's bytes, and the only address of the knowledge base it holds.
    #[serde(rename = "gatewayUrl")]
    pub gateway_url: String,
    /// Where the worker signs in for this knowledge base, and as which client.
    pub identity: WorkerKnowledgeBaseConfigIdentity,
    /// The engines the worker offers this knowledge base, and the jobs it does with each: its own choice, on its own providers' keys. It claims each engine's jobs there for it, so a job no engine here is used for is not claimed at this knowledge base.
    pub engines: Vec<WorkerEngineConfig>,
}

schema!(WorkerKnowledgeBaseConfig);

/// Where the worker signs in for this knowledge base, and as which client.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerKnowledgeBaseConfigIdentity {
    /// The issuer URL, exactly as tokens carry it in `iss`.
    pub issuer: String,
    /// The client the issuer holds the public half of the worker's key on: the worker's account at this knowledge base. It is also what the worker says it is called there (`principal:profile`).
    #[serde(rename = "clientId")]
    pub client_id: String,
}

/// One knowledge base the worker serves, as its health says it. `did` and `engines` are there while it is `working`, and only then.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerKnowledgeBaseHealth {
    /// The entry's `domain`.
    pub domain: String,
    /// `starting`: signing in, opening its stream, confirming it, or waiting to start again. `working`: confirmed, its engines claiming. `refused`: refused, until the service is started again.
    pub state: WorkerKnowledgeBaseHealthState,
    /// The agent's DID at this knowledge base, as its gateway named it.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub did: Option<String>,
    /// One entry for each of the entry's engines, in its order.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub engines: Option<Vec<WorkerEngineHealth>>,
}

impl WorkerKnowledgeBaseHealth {
    /// The `WorkerKnowledgeBaseHealth` that states these and nothing else.
    pub fn new(domain: impl Into<String>, state: WorkerKnowledgeBaseHealthState) -> Self {
        Self {
            domain: domain.into(),
            state,
            did: None,
            engines: None,
        }
    }
}

schema!(WorkerKnowledgeBaseHealth);

/// `starting`: signing in, opening its stream, confirming it, or waiting to start again. `working`: confirmed, its engines claiming. `refused`: refused, until the service is started again.
#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum WorkerKnowledgeBaseHealthState {
    #[serde(rename = "starting")]
    Starting,
    #[serde(rename = "working")]
    Working,
    #[serde(rename = "refused")]
    Refused,
}

impl WorkerKnowledgeBaseHealthState {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            WorkerKnowledgeBaseHealthState::Starting => "starting",
            WorkerKnowledgeBaseHealthState::Working => "working",
            WorkerKnowledgeBaseHealthState::Refused => "refused",
        }
    }
}

/// worker/messages.json: the words of a Worker service's refusals to start, of the errors it fails a job with, and of the messages it logs that a reader relies on.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerMessages {
    /// The rule the table states, in prose.
    #[serde(rename = "$comment")]
    pub _comment: String,
    /// Each refusal to start, written in service-environment/boot-refusals.json's `line`.
    pub boot: Vec<WorkerMessagesBootItem>,
    /// Each line of the `{reasons}` of `invalid`.
    pub reasons: Vec<WorkerMessagesReasonsItem>,
    /// How an error names the job, by its type, as `{job}`: `{motivation}` is a mark job's motivation.
    pub job: WorkerMessagesJob,
    /// Each error a job is failed with that is the worker's own: the `error` of its `job:fail`.
    pub errors: Vec<WorkerMessagesErrorsItem>,
    /// Each `{detail}` of `unreadable`.
    pub details: Vec<WorkerMessagesDetailsItem>,
    /// Each `{said}` of `wait-stated`.
    pub waits: Vec<WorkerMessagesWaitsItem>,
    /// Each message a Worker service logs that a reader of its output relies on.
    pub logged: Vec<WorkerMessagesLoggedItem>,
}

schema!(WorkerMessages);

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum WorkerMessagesBootItem {
    OwnBootRefusal(WorkerMessagesBootItemOwnBootRefusal),
    SharedBootRefusal(WorkerMessagesBootItemSharedBootRefusal),
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerMessagesBootItemOwnBootRefusal {
    /// The situation's name.
    pub name: String,
    /// When it is written, and what fills each `{name}` of its text.
    pub situation: String,
    /// The refusal, in place of the line's `{refusal}`. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.
    pub refusal: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerMessagesBootItemSharedBootRefusal {
    /// The situation's name.
    pub name: String,
    /// When it is written. What fills its text is the shared row's.
    pub situation: String,
    /// The `name` of the row of service-environment/boot-refusals.json's `refusals` that is this refusal, with `{service}` `worker` and `{schema}` `WorkerConfig`.
    #[serde(rename = "bootRefusal")]
    pub boot_refusal: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerMessagesDetailsItem {
    /// The situation's name.
    pub name: String,
    /// When it is written, and what fills each `{name}` of its text.
    pub situation: String,
    /// The detail. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.
    pub detail: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerMessagesErrorsItem {
    /// The situation's name.
    pub name: String,
    /// When it is written, and what fills each `{name}` of its text.
    pub situation: String,
    /// The error. `{job}` in it is the job, as `job` names it. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.
    pub error: String,
}

/// How an error names the job, by its type, as `{job}`: `{motivation}` is a mark job's motivation.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerMessagesJob {
    pub mark: String,
    pub r#yield: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerMessagesLoggedItem {
    /// The situation's name.
    pub name: String,
    pub level: LogLevel,
    /// When it is written, what fills each `{name}` of its fields, and what each fact it carries says.
    pub situation: String,
    /// The line's message, word for word.
    pub message: String,
    /// The facts the line is logged with whose form is stated, by name: each a text whose `{name}` is filled as the row's `situation` says. A fact that is a number is its decimal digits.
    pub fields: std::collections::BTreeMap<String, String>,
    /// The facts the line is logged with beside `fields`, whose value the row's `situation` says and whose form is not stated. The line may carry others.
    pub carries: Vec<String>,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerMessagesReasonsItem {
    /// The situation's name.
    pub name: String,
    /// When it is written, and what fills each `{name}` of its text.
    pub situation: String,
    /// The line, indented by two spaces. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.
    pub line: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerMessagesWaitsItem {
    /// The situation's name.
    pub name: String,
    /// When it is written, and what fills each `{name}` of its text.
    pub situation: String,
    /// The wait, as the header stated it. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.
    pub said: String,
}

/// The shared worker that does knowledge bases' jobs: its image, its memory and its log level. They are shared, not any knowledge base's, so its document is kept in the launcher's state home, in `stack/workers.yaml`, not in a knowledge base's repository. A knowledge base's jobs are done when its Inference document gives a job an engine. A worker needs only the Gateway, and an issuer's token with the worker's role.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerPool {
    #[serde(rename = "apiVersion")]
    pub api_version: StackApiVersion,
    pub kind: WorkerPoolKind,
    pub metadata: Metadata,
    /// How the worker runs.
    pub spec: WorkerPoolSpec,
}

impl WorkerPool {
    /// The `WorkerPool` that states these and nothing else.
    pub fn new(api_version: StackApiVersion, metadata: Metadata, spec: WorkerPoolSpec) -> Self {
        Self {
            api_version,
            kind: WorkerPoolKind::WorkerPool,
            metadata,
            spec,
        }
    }
}

schema!(WorkerPool);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum WorkerPoolKind {
    #[serde(rename = "WorkerPool")]
    WorkerPool,
}

impl WorkerPoolKind {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            WorkerPoolKind::WorkerPool => "WorkerPool",
        }
    }
}

/// How the worker runs.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerPoolSpec {
    #[serde(rename = "logLevel")]
    pub log_level: LogLevel,
    /// The Worker.
    pub worker: WorkerPoolSpecWorker,
}

/// The Worker.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerPoolSpecWorker {
    pub image: Image,
    pub resources: Resources,
}

/// A knowledge base's operational readings from Collector metrics. Request-tracking occupancy and queue depth are current gauges; completed and failed are worker counters since that worker process started. Missing readings are unknown, never zero.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkloadStatus {
    /// The Gateway's request tracking: correlation IDs it currently holds so replies can be routed to the app client that sent each request, and the tracking capacity.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub ledger: Option<WorkloadStatusLedger>,
    /// Current Dispatcher depth and, when the worker has emitted counters, completed and failed work since worker start. These are different measurements and time windows.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub queue: Option<WorkloadStatusQueue>,
}

schema!(WorkloadStatus);

/// The Gateway's request tracking: correlation IDs it currently holds so replies can be routed to the app client that sent each request, and the tracking capacity.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkloadStatusLedger {
    /// Number of request IDs currently held to route replies to their requesting app clients. Includes requests still waiting for a reply and recently answered requests still within the tracking window.
    pub claims: u64,
    /// The maximum number of IDs held in this Gateway's local tracking projection.
    pub capacity: u64,
}

/// Current Dispatcher depth and, when the worker has emitted counters, completed and failed work since worker start. These are different measurements and time windows.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct WorkloadStatusQueue {
    /// Jobs currently waiting for a worker.
    pub pending: u64,
    /// Jobs currently claimed by workers.
    pub running: u64,
    /// Jobs completed since worker start.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub completed: Option<u64>,
    /// Jobs finally failed since worker start.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub failed: Option<u64>,
}

impl WorkloadStatusQueue {
    /// The `WorkloadStatusQueue` that states these and nothing else.
    pub fn new(pending: u64, running: u64) -> Self {
        Self {
            pending,
            running,
            completed: None,
            failed: None,
        }
    }
}

/// Bus command to create a cloned resource from a clone token. Bytes are stored by the upload path BEFORE this command is emitted, because bytes travel over HTTP and never over the bus — the command carries the storage coordinates, never content.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct YieldCloneCreateCommand {
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    pub token: String,
    pub name: String,
    /// Where the caller already wrote the clone's bytes — an instruction, not a copy of the stored fact (that lives on the primary Representation). Bytes are stored through the byte door BEFORE this command is sent, so this names an existing file. Working-tree URI, only file:// is supported.
    #[serde(rename = "storageUri")]
    pub storage_uri: String,
    #[serde(rename = "contentChecksum")]
    pub content_checksum: String,
    #[serde(rename = "byteSize")]
    pub byte_size: i64,
    pub format: ContentFormat,
    #[serde(rename = "archiveOriginal")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub archive_original: Option<bool>,
}

impl YieldCloneCreateCommand {
    /// The `YieldCloneCreateCommand` that states these and nothing else.
    pub fn new(
        token: impl Into<String>,
        name: impl Into<String>,
        storage_uri: impl Into<String>,
        content_checksum: impl Into<String>,
        byte_size: i64,
        format: ContentFormat,
    ) -> Self {
        Self {
            _user_id: None,
            token: token.into(),
            name: name.into(),
            storage_uri: storage_uri.into(),
            content_checksum: content_checksum.into(),
            byte_size,
            format,
            archive_original: None,
        }
    }
}

schema!(YieldCloneCreateCommand);

/// Success response after creating a cloned resource.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct YieldCloneCreated {
    pub response: YieldedResource,
}

schema!(YieldCloneCreated);

/// Command: stow an already-uploaded clone's bytes and append `yield:cloned`.
///
/// The INNER half of the clone flow. `yield:clone-create` reaches the CloneTokenManager, which alone can validate the token and read the source's entity types; it then emits this so the Stower — the only appendEvent caller — writes the domain event.
///
/// Distinct from `yield:create` because a clone is a distinct operation, not a creation with an extra field. It REQUIRES a parent, and that requirement is what a separate command expresses: an optional `parentResourceId` on the create command could not say that a clone without a parent is not a clone. `ResourceClonedPayload` requires it for the same reason.
///
/// Generated resources are NOT clones: they carry provenance in `generatedFrom` and stay on `yield:create`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct YieldClonePersistCommand {
    /// Injected by the gateway from the authenticated principal; never supplied by a wire caller.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    pub name: String,
    /// The caller's instruction for WHERE the bytes are — the uploader wrote them before emitting this. The stored location lives on the clone's primary Representation, the one home of a storage URI.
    #[serde(rename = "storageUri")]
    pub storage_uri: String,
    #[serde(rename = "contentChecksum")]
    pub content_checksum: String,
    #[serde(rename = "byteSize")]
    pub byte_size: i64,
    pub format: ContentFormat,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub language: Option<String>,
    /// Inherited from the source resource by the CloneTokenManager, which is the only party that knows the token is valid.
    #[serde(rename = "entityTypes")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_types: Option<Vec<String>>,
    /// The resource this one is cloned FROM. Required: it is what makes this a clone rather than a creation.
    #[serde(rename = "parentResourceId")]
    pub parent_resource_id: ResourceId,
}

impl YieldClonePersistCommand {
    /// The `YieldClonePersistCommand` that states these and nothing else.
    pub fn new(
        name: impl Into<String>,
        storage_uri: impl Into<String>,
        content_checksum: impl Into<String>,
        byte_size: i64,
        format: ContentFormat,
        parent_resource_id: ResourceId,
    ) -> Self {
        Self {
            _user_id: None,
            name: name.into(),
            storage_uri: storage_uri.into(),
            content_checksum: content_checksum.into(),
            byte_size,
            format,
            language: None,
            entity_types: None,
            parent_resource_id,
        }
    }
}

schema!(YieldClonePersistCommand);

/// Success reply after cloning a resource, matched to the originating command by correlationId.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct YieldClonePersistOk {
    /// The clone's identity — a new resource, distinct from its parent.
    pub response: YieldedResource,
}

schema!(YieldClonePersistOk);

/// Bus command to request cloning a resource using a clone token.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct YieldCloneResourceRequest {
    pub token: String,
}

schema!(YieldCloneResourceRequest);

/// Bus command to request a clone token for a resource.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct YieldCloneTokenRequest {
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
}

schema!(YieldCloneTokenRequest);

/// Bus command to create a yielded resource in the knowledge base.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct YieldCreateCommand {
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    /// The emitter's capabilities (the token's `roles`), injected by the /bus/emit gateway. Clients do not set this. An emitter carrying the worker role must cite the job this resource fulfils in `jobId`; the Stower refuses the create otherwise.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _roles: Option<Vec<String>>,
    /// The job this resource fulfils. Required when the emitter carries the worker role; absent for self-initiated work (a person, or an agent acting on its own). The knowledge base derives who requested this resource from the cited job's own events — the emitter never says who the work was for.
    #[serde(rename = "jobId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub job_id: Option<JobId>,
    pub name: String,
    /// The caller's instruction for WHERE the bytes are — not a copy of the stored fact. The stored location lives on the resource's primary Representation (`Representation.storageUri`), which is its single home; this field is the message that puts it there. Working-tree URI, only file:// is supported (e.g. file://docs/overview.md).
    #[serde(rename = "storageUri")]
    pub storage_uri: String,
    #[serde(rename = "contentChecksum")]
    pub content_checksum: String,
    #[serde(rename = "byteSize")]
    pub byte_size: i64,
    pub format: ContentFormat,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub language: Option<String>,
    #[serde(rename = "entityTypes")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub entity_types: Option<Vec<String>>,
    #[serde(rename = "isDraft")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub is_draft: Option<bool>,
    #[serde(rename = "generatedFrom")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub generated_from: Option<YieldCreateCommandGeneratedFrom>,
    #[serde(rename = "generationPrompt")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub generation_prompt: Option<String>,
    /// The Software peer that produced the content, when software did. Its identity must be the emitter's own — the knowledge base refuses a generator naming anyone else, and supplies it from the verified emitter when omitted. `creator` and `wasAttributedTo` are never sent; the knowledge base derives them from the emitter and the cited job.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub generator: Option<OneOrMoreAgents>,
}

impl YieldCreateCommand {
    /// The `YieldCreateCommand` that states these and nothing else.
    pub fn new(
        name: impl Into<String>,
        storage_uri: impl Into<String>,
        content_checksum: impl Into<String>,
        byte_size: i64,
        format: ContentFormat,
    ) -> Self {
        Self {
            _user_id: None,
            _roles: None,
            job_id: None,
            name: name.into(),
            storage_uri: storage_uri.into(),
            content_checksum: content_checksum.into(),
            byte_size,
            format,
            language: None,
            entity_types: None,
            is_draft: None,
            generated_from: None,
            generation_prompt: None,
            generator: None,
        }
    }
}

schema!(YieldCreateCommand);

#[derive(Debug, Clone, PartialEq, Eq, Hash, Default, serde::Deserialize, serde::Serialize)]
pub struct YieldCreateCommandGeneratedFrom {
    #[serde(rename = "resourceId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resource_id: Option<ResourceId>,
    #[serde(rename = "annotationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotation_id: Option<AnnotationId>,
}

/// Success reply after creating a yielded resource, matched to the originating command by correlationId.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct YieldCreateOk {
    /// The created resource's identity.
    pub response: YieldedResource,
}

schema!(YieldCreateOk);

/// A `yield` job's worker says the job is complete, with what a `yield` job reports.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct YieldJobCompleteCommand {
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    #[serde(rename = "jobId")]
    pub job_id: JobId,
    #[serde(rename = "jobType")]
    pub job_type: YieldJobCompleteCommandJobType,
    /// Which attempt produced this event, 1-based (a first run is 1). ALWAYS present: the queue re-runs a failed job silently, so an operator reading progress or a terminal record has no other way to tell a re-run from a first run — and provider spend, already counted in xynolog_inference_tokens_total, cannot be attributed to a repeated document without it. Stated rather than inferred from absence, because 'attempt 1' is a fact the emitter always knows.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub attempt: Option<i64>,
    /// The annotation the job's context was focused on, when it was focused on one. Lets a client route the completion to that annotation.
    #[serde(rename = "annotationId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub annotation_id: Option<AnnotationId>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub result: Option<YieldJobResult>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub durability: Option<DurabilityEvidence>,
}

impl YieldJobCompleteCommand {
    /// The `YieldJobCompleteCommand` that states these and nothing else.
    pub fn new(resource_id: ResourceId, job_id: JobId) -> Self {
        Self {
            _user_id: None,
            resource_id,
            job_id,
            job_type: YieldJobCompleteCommandJobType::Yield,
            attempt: None,
            annotation_id: None,
            result: None,
            durability: None,
        }
    }
}

schema!(YieldJobCompleteCommand);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum YieldJobCompleteCommandJobType {
    #[serde(rename = "yield")]
    Yield,
}

impl YieldJobCompleteCommandJobType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            YieldJobCompleteCommandJobType::Yield => "yield",
        }
    }
}

/// Create a `yield` job: make a resource from a gathered context. It names no resource of its own: the job is about the resource its context focuses on, which the Dispatcher reads from `params.context.focus`.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct YieldJobCreateCommand {
    /// The emitter's verified DID, injected by the gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    /// The emitter's roles, injected by the gateway when it has any. Clients do not set this.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _roles: Option<Vec<String>>,
    #[serde(rename = "jobType")]
    pub job_type: YieldJobCreateCommandJobType,
    pub params: GenerationJobParams,
}

impl YieldJobCreateCommand {
    /// The `YieldJobCreateCommand` that states these and nothing else.
    pub fn new(params: GenerationJobParams) -> Self {
        Self {
            _user_id: None,
            _roles: None,
            job_type: YieldJobCreateCommandJobType::Yield,
            params,
        }
    }
}

schema!(YieldJobCreateCommand);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum YieldJobCreateCommandJobType {
    #[serde(rename = "yield")]
    Yield,
}

impl YieldJobCreateCommandJobType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            YieldJobCreateCommandJobType::Yield => "yield",
        }
    }
}

/// What a `yield` job reports when it has made its resource. The worker creates the resource first (the create round trip returns its id), then emits job:complete carrying it, so resourceId is always present on the wire.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct YieldJobDone {
    /// ID of the generated resource, obtained by the worker from the create round-trip before job:complete is emitted
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// Name of the generated resource
    #[serde(rename = "resourceName")]
    pub resource_name: String,
    /// True when the model stopped at the maxTokens ceiling — the artifact is cut off, not complete. Derived at the producer from the provider's stopReason ('max_tokens' → true); required because the worker always knows.
    pub truncated: bool,
}

schema!(YieldJobDone);

/// `yield` jobs.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(deny_unknown_fields)]
pub struct YieldJobFilter {
    #[serde(rename = "jobType")]
    pub job_type: YieldJobFilterJobType,
}

impl Default for YieldJobFilter {
    fn default() -> Self {
        Self::new()
    }
}

impl YieldJobFilter {
    /// The `YieldJobFilter` that states what it must and nothing else.
    pub fn new() -> Self {
        Self {
            job_type: YieldJobFilterJobType::Yield,
        }
    }
}

schema!(YieldJobFilter);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum YieldJobFilterJobType {
    #[serde(rename = "yield")]
    Yield,
}

impl YieldJobFilterJobType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            YieldJobFilterJobType::Yield => "yield",
        }
    }
}

/// A pending `yield` job, announced with what it is asked to make and without its `context`.
#[derive(Debug, Clone, PartialEq, serde::Deserialize, serde::Serialize)]
pub struct YieldJobQueuedEvent {
    #[serde(rename = "jobId")]
    pub job_id: JobId,
    #[serde(rename = "jobType")]
    pub job_type: YieldJobQueuedEventJobType,
    /// The resource the job is about.
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// The DID of the principal whose `job:create` created the job.
    #[serde(rename = "userId")]
    pub user_id: UserId,
    pub params: GenerationJobRequest,
}

impl YieldJobQueuedEvent {
    /// The `YieldJobQueuedEvent` that states these and nothing else.
    pub fn new(
        job_id: JobId,
        resource_id: ResourceId,
        user_id: UserId,
        params: GenerationJobRequest,
    ) -> Self {
        Self {
            job_id,
            job_type: YieldJobQueuedEventJobType::Yield,
            resource_id,
            user_id,
            params,
        }
    }
}

schema!(YieldJobQueuedEvent);

#[derive(
    Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Deserialize, serde::Serialize,
)]
pub enum YieldJobQueuedEventJobType {
    #[serde(rename = "yield")]
    Yield,
}

impl YieldJobQueuedEventJobType {
    /// The value as the wire spells it.
    pub const fn as_str(&self) -> &'static str {
        match self {
            YieldJobQueuedEventJobType::Yield => "yield",
        }
    }
}

/// What a `yield` job reports when it concludes without failing: the resource it made, or a decline. Neither names its kind: a decline is the one with `declined`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
#[serde(untagged)]
pub enum YieldJobResult {
    YieldJobDone(YieldJobDone),
    JobDeclined(JobDeclined),
}

member!(YieldJobResult::YieldJobDone(YieldJobDone));
member!(YieldJobResult::JobDeclined(JobDeclined));
schema!(YieldJobResult);

/// Bus command to update a yielded resource's storage content.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct YieldUpdateCommand {
    /// Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this.
    #[serde(rename = "_userId")]
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub _user_id: Option<UserId>,
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
    /// The caller's instruction for WHERE the bytes are — not a copy of the stored fact. The stored location lives on the resource's primary Representation (`Representation.storageUri`), which is its single home; this field is the message that puts it there. Working-tree URI, only file:// is supported (e.g. file://docs/overview.md).
    #[serde(rename = "storageUri")]
    pub storage_uri: String,
    #[serde(rename = "contentChecksum")]
    pub content_checksum: String,
    #[serde(rename = "byteSize")]
    pub byte_size: i64,
}

impl YieldUpdateCommand {
    /// The `YieldUpdateCommand` that states these and nothing else.
    pub fn new(
        resource_id: ResourceId,
        storage_uri: impl Into<String>,
        content_checksum: impl Into<String>,
        byte_size: i64,
    ) -> Self {
        Self {
            _user_id: None,
            resource_id,
            storage_uri: storage_uri.into(),
            content_checksum: content_checksum.into(),
            byte_size,
        }
    }
}

schema!(YieldUpdateCommand);

/// Success reply after updating a yielded resource, matched to the originating command by correlationId.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct YieldUpdateOk {
    /// The updated resource's identity.
    pub response: YieldedResource,
}

schema!(YieldUpdateOk);

/// The resource a yield command wrote, by its id.
#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub struct YieldedResource {
    #[serde(rename = "resourceId")]
    pub resource_id: ResourceId,
}

schema!(YieldedResource);
