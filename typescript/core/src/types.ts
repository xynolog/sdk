// ⚠ GENERATED FILE — do not edit.
//
// Authority:   the component schemas of protocol/specs/src/openapi.json
//              the records Protocol states in its tables (codegen/lib/table_records.ml)
//              the client types it names, of protocol/specs/src/client/types
//              the schemas of the tables it carries as values (codegen/lib/typescript_types/table_modules.ml)
//              protocol/specs/src/client/discovery-absent.json
//              protocol/specs/src/identifiers/kinds.json, for the brands
// Regenerate:  make generate  (codegen/lib/typescript_types/typescript_types.ml)

export interface components {
  schemas: {
    /** launcher.about's params. */
    AboutParams: {
      /** The version of the control API the request is written to. */
      apiVersion: components['schemas']['ApiVersion'];
    };
    /**
     * What the launcher is. A client asks this first, to learn whether it
     * speaks to the launcher it found.
     */
    AboutResult: {
      /**
       * The version stamped into the launcher at build. Absent from a
       * development build, which states none.
       */
      version?: string;
      /** Whether this is a development build: one with no version stamped. */
      development: boolean;
      /** The commit it was built from, when stamped. */
      commit?: string;
      /** When it was built, when stamped. */
      built?: string;
      /**
       * Each version of the control API it speaks. A client that speaks none of
       * them stops here.
       */
      apiVersions: string[];
      /** The registry its catalog's images come from. */
      imageRegistry: string;
      /**
       * Each container runtime it drives, in the order it prefers them, and
       * whether this machine has it.
       */
      runtimes: components['schemas']['RuntimeState'][];
    };
    /**
     * Web Annotation / W3C PROV Agent. Discriminated by @type — Person,
     * Organization, or Software (named member schemas: AgentPerson,
     * AgentOrganization, AgentSoftware). Software peers are first-class
     * participants, not a sub-class of Person.
     */
    Agent:
      | components['schemas']['AgentPerson']
      | components['schemas']['AgentOrganization']
      | components['schemas']['AgentSoftware'];
    /** An organization — the Organization branch of Agent. */
    AgentOrganization: {
      '@type': 'Organization';
      '@id'?: string;
      name: string;
      homepage?: string;
    } & { [key: string]: unknown };
    /** A human participant — the Person branch of Agent. */
    AgentPerson: {
      '@type': 'Person';
      /** DID-shaped identifier (e.g. did:web:host:users:email%40host) */
      '@id'?: string;
      /**
       * Display name. ABSENT until resolved: a Person is identified by `@id`
       * and nothing else, and what they are called is recorded once per change
       * on the knowledge base's own log and filled in when a record is read. An
       * artifact therefore never freezes a name, which is what lets a
       * correction reach every artifact its subject ever wrote. Absent also
       * means genuinely unknown — a DID this knowledge base has no profile for.
       */
      name?: string;
      nickname?: string;
      email?: string;
      email_sha1?: string;
      homepage?: string;
    } & { [key: string]: unknown };
    /**
     * A software peer, the Software branch of Agent: an agent, which is an
     * account as a person is. Its `provider` and `model` are what it says of
     * itself, attributed to it and not checked; the knowledge base reads
     * neither from its DID. Its `name` is no part of what it writes: what it
     * last said it is called is its profile, and readers fill it in, as they do
     * a person's. A generator the knowledge base supplies, for an agent that
     * supplied none, carries `@type` and `@id` alone.
     */
    AgentSoftware: {
      '@type': 'Software';
      /**
       * The agent's DID: did:web:<domain>:agents:<subject>, its account at the
       * knowledge base's issuer
       */
      '@id'?: string;
      /**
       * What the agent last said it is called. ABSENT until resolved: filled in
       * from its profile when a record is read, as a Person's name is. Absent
       * also where it has said nothing. Not parsed.
       */
      name?: string;
      /** Inference provider (e.g. ollama, anthropic) */
      provider?: string;
      /** Model identifier (e.g. gemma2:27b, claude-3-5-sonnet) */
      model?: string;
      /**
       * Inference parameters (temperature, maxTokens, systemPrompt, etc.).
       * Runtime metadata, not part of identity.
       */
      parameters?: { [key: string]: unknown };
    } & { [key: string]: unknown };
    /**
     * Where a clicked annotation's element is on the viewer's screen: its
     * rectangle in viewport pixels, as a DOM rectangle states it. A viewer's
     * own geometry: it rides a viewer's local frames, and a frame another
     * participant's screen receives carries none.
     */
    AnchorRect: {
      /** The rectangle's horizontal origin. */
      x: number;
      /** The rectangle's vertical origin. */
      y: number;
      /** The rectangle's width. */
      width: number;
      /** The rectangle's height. */
      height: number;
      /** The rectangle's top edge. */
      top: number;
      /** The rectangle's right edge. */
      right: number;
      /** The rectangle's bottom edge. */
      bottom: number;
      /** The rectangle's left edge. */
      left: number;
    };
    /**
     * Text paired with the geometry that indexes it — the minimum needed to
     * turn a range of the text, two offsets counted in Unicode code points,
     * into a selection, or a rectangle into a quote. Whole-resource: a producer
     * iterates page by page, but every consumer wants one map.
     */
    AnchoredText: {
      /** Reading-order text of the whole resource. */
      text: string;
      /** Positioned runs indexing `text`, roughly one per word. */
      items: components['schemas']['PdfTextItem'][];
    };
    /**
     * There is no coordinate map to serve, and WHY — the distinction a bare
     * null could not carry.
     *
     * One member covers all three absences because none carries a payload;
     * `kind` alone is the fact. Retryability is legible from the name,
     * deliberately: a caller must not need a lookup table to decide whether to
     * come back.
     */
    AnchoredTextAbsent: {
      /**
       * Discriminant, sharing the `kind` field with the
       * ExtractedText/ExtractionDeclined members so the whole answer is one
       * flat union.
       *
       * `not-yet` — the resource's media type has text that is derived by
       * reading its content, and the store holds no entry for this content: the
       * Smelter has not read it yet, or the entry was lost (a loss the
       * Smelter's reconcile pass re-derives). RETRY.
       *
       * `no-map` — the resource's media type has no derived text, so no entry
       * exists and none will until the type is given a reader. Decided by the
       * media type alone, and answered at once. TERMINAL.
       *
       * `unknown` — no content identity to look up: the resource is not in the
       * view store, or its primary representation carries no checksum.
       * TERMINAL.
       */
      kind: AnchoredTextAbsentKind;
    };
    /**
     * What a reader gets when it asks for a resource's coordinate map: the map,
     * a stored decline, or a named absence.
     *
     * Distinct from `ExtractionOutcome` on purpose. That type is what the STORE
     * holds and what an extractor RETURNS — neither of which can ever be 'not
     * yet'. This is the read answer, which can, so widening ExtractionOutcome
     * itself would have put an impossible state into the store's own type.
     *
     * Flat, one discriminant: every member carries `kind`, rather than nesting
     * an outcome inside a status envelope and giving the wire two `kind` fields
     * at different depths.
     */
    AnchoredTextAnswer:
      | components['schemas']['ExtractedText']
      | components['schemas']['ExtractionDeclined']
      | components['schemas']['AnchoredTextAbsent'];
    /** The bytes were declined: no text is extracted from them. */
    AnchoredTextDeclinedEntry: {
      /** The entry format. */
      v: 3;
      /**
       * The stamp the entry was derived under: the PDF reader's and the OCR
       * engine's. A reader takes the entry only when it equals the stamp the
       * Smelter last stated.
       */
      stamp: string;
      /** Why extraction yielded nothing, by class. */
      declined: components['schemas']['ExtractionDeclinedReason'];
    };
    /**
     * The keys of the entries the anchored-text store holds under the stamp
     * last stated: one checksum for each set of bytes whose text is stored, in
     * no order.
     */
    AnchoredTextEntries: {
      checksums: string[];
    };
    /**
     * One entry of the anchored-text store: the file `<ab>/<cd>/<key>.json`
     * under the store's directory, where the key is the SHA-256 of the bytes
     * the text was extracted from, in hex. The Smelter derives it and stores it
     * over the Archivist's HTTP surface (`AnchoredTextWrite`); the Archivist
     * writes it, as compact JSON with `v` and `stamp` first, to a sibling
     * temporary file renamed onto the path. The stamp the Smelter states
     * (`AnchoredTextStamp`) is kept, followed by a newline, in the file `STAMP`
     * at the store's root.
     */
    AnchoredTextEntry:
      | components['schemas']['AnchoredTextExtractedEntry']
      | components['schemas']['AnchoredTextDeclinedEntry'];
    /**
     * The text extracted from the bytes, where each word is on the page, and
     * how it was extracted.
     */
    AnchoredTextExtractedEntry: {
      /** The entry format. */
      v: 3;
      /**
       * The stamp the entry was derived under: the PDF reader's and the OCR
       * engine's. A reader takes the entry only when it equals the stamp the
       * Smelter last stated.
       */
      stamp: string;
      /** The extracted text. */
      text: string;
      /** Where each word of `text` is, line by line, in reading order. */
      lines: AnchoredTextExtractedEntryLinesItem[];
      /** How the text was extracted. */
      method: components['schemas']['ExtractionMethod'];
      /** PDF classification, when the source was a PDF. */
      pdfClass?: components['schemas']['PdfClass'];
      /**
       * How well the engine read the pixels, when any of this text came from
       * OCR.
       */
      ocrConfidence?: components['schemas']['OcrConfidence'];
      /**
       * 1-indexed pages this extraction could not read — present only for
       * partially covered documents (class C).
       */
      unreadPages?: number[];
    };
    /**
     * The stamp an anchored-text store's entries are taken under: which PDF
     * reader and which OCR engine derived them. Its writer states it before it
     * writes or lists an entry; an entry stored under another stamp is answered
     * to no reader.
     */
    AnchoredTextStamp: {
      /** The stamp: no white space, since it is held in a file of one line. */
      stamp: string;
    };
    /**
     * A write of an anchored-text entry for the bytes of one resource: what the
     * Smelter derived from them, and their checksum. The Archivist files the
     * entry under the checksum, so every resource whose bytes those are has it,
     * and refuses the write when the resource's first representation has other
     * bytes.
     */
    AnchoredTextWrite: {
      /**
       * The SHA-256 of the bytes the text was derived from, as 64 lower-case
       * hexadecimal digits: the key the entry is filed under.
       */
      contentChecksum: string;
      entry: components['schemas']['AnchoredTextEntry'];
    };
    Annotation: {
      /** W3C Web Annotation JSON-LD context */
      '@context': 'http://www.w3.org/ns/anno.jsonld';
      /** W3C Annotation type */
      type: 'Annotation';
      id: components['schemas']['AnnotationId'];
      motivation: components['schemas']['Motivation'];
      /**
       * W3C Web Annotation target: the id of the resource annotated, when the
       * whole of it is, or an object with source and optional selector
       * (fragment)
       */
      target: AnnotationTargetValue;
      /**
       * W3C Web Annotation body. Optional per the W3C spec — annotations whose
       * motivation alone is meaningful (highlighting) legitimately omit it.
       * Present values are either a single body or a non-empty array of bodies;
       * there is no empty array.
       */
      body?: components['schemas']['AnnotationBodies'];
      /**
       * Web Annotation creator — who requested the annotation. DERIVED by the
       * knowledge base at write time, never accepted from an emitter (a payload
       * carrying it is refused): the verified emitter of the write, or, when
       * the write cites a job, the verified emitter of the job:create that
       * produced it. A Person for human-requested work; a Software peer for
       * autonomous-agent work.
       */
      creator?: components['schemas']['Agent'];
      /**
       * When the annotation was MADE — the authoring moment, carried from the
       * event that created it. Not when a projection happened to write it: a
       * store that rebuilds from the log must preserve this value, never
       * restamp it.
       */
      created: string;
      modified?: string;
      /**
       * Web Annotation generator — the Software peer that produced the
       * annotation, when software did. Absent for a person's own annotation. An
       * emitter may supply it to carry the model's parameters, but its identity
       * must be the emitter's own: the knowledge base refuses a generator
       * naming anyone else, and supplies it from the verified emitter when
       * omitted. One producer per write — a write carrying the array form is
       * refused.
       */
      generator?: components['schemas']['OneOrMoreAgents'];
      /**
       * PROV-O wasAttributedTo — every party responsible for this annotation,
       * DERIVED by the knowledge base from `creator` and the verified executor
       * of the write: `[creator, generator]` when one agent requested the work
       * and software produced it; collapsed to the one agent when requester and
       * producer are the same. Never accepted from an emitter.
       */
      wasAttributedTo?: components['schemas']['OneOrMoreAgents'];
    };
    /** Payload for mark:added domain event */
    AnnotationAddedPayload: {
      annotation: components['schemas']['Annotation'];
      /** SHA-256 of resource content at annotation time */
      contentChecksum?: string;
    };
    /**
     * What an annotation's `body` holds: one body, or a non-empty list of them.
     * There is no empty list: an annotation with nothing to say has no `body`.
     */
    AnnotationBodies:
      | components['schemas']['AnnotationBody']
      | components['schemas']['AnnotationBody'][];
    /**
     * An annotation's body: a TextualBody carries text the annotation states
     * (entity tags, descriptions, comments), a SpecificResource points at what
     * it links to. Tell them apart by `type`, which is required on both and
     * single-valued — a consumer never has to probe for which fields happen to
     * be present.
     */
    AnnotationBody:
      | components['schemas']['TextualBody']
      | components['schemas']['SpecificResource'];
    /** Payload for mark:body-updated domain event */
    AnnotationBodyUpdatedPayload: {
      annotationId: components['schemas']['AnnotationId'];
      operations: components['schemas']['BodyOperation'][];
    };
    /**
     * An annotation's id: a name, never the annotation's URI. 1 to 128 of the
     * letters `A`–`Z` and `a`–`z`, the digits, `_` and `-`. It is one segment
     * of a URL and one name in a file system, and it is held to that wherever
     * it enters: a gateway refuses a payload that carries anything else. How
     * one is made is no part of the rule.
     */
    AnnotationId: string & { readonly __brand: 'AnnotationId' };
    /** Payload for mark:removed domain event */
    AnnotationRemovedPayload: {
      annotationId: components['schemas']['AnnotationId'];
    };
    /**
     * What a target's `selector` holds: one W3C selector, or several of the
     * same segment.
     */
    AnnotationSelector:
      components['schemas']['Selector'] | components['schemas']['Selector'][];
    /**
     * W3C Web Annotation target object - source is required, selector is
     * optional
     */
    AnnotationTarget: {
      /**
       * Stated by the annotation of a span: the target is a part of its source,
       * which the selector picks out. An annotation of a resource as a whole
       * states none.
       */
      type?: 'SpecificResource';
      /** The id of the resource being annotated */
      source: components['schemas']['ResourceId'];
      /**
       * Optional selector to identify a specific segment of the source resource
       */
      selector?: components['schemas']['AnnotationSelector'];
    };
    /**
     * The group and version of the control API. Every request's params state
     * it; a launcher refuses a version it does not speak with
     * control.unsupported-api-version, and names the ones it does.
     */
    ApiVersion: 'control.xynolog.org/v1alpha1';
    /**
     * Everything the Archivist reads at boot: nothing in it is defaulted by the
     * Archivist. The launcher writes it for the Archivist it starts, from the
     * knowledge base's stack documents, and the Archivist reads it from the
     * path its `--config` flag names (its image passes
     * `/etc/xynolog/archivist.json`). Started without `--config`, or with a
     * path that names no file, the Archivist refuses to start and says which.
     * No secret is a value here. What the knowledge base says of itself is not
     * here either: its name, its `site.domain` and its `git.sync` are read from
     * the committed `.xynolog/config.yaml` of the tree at `root`. The
     * Archivist's other inputs are the environment variables
     * specs/src/service-environment/variables.json lists for it. A document
     * that does not validate is refused at boot, naming each failing field.
     */
    ArchivistConfig: {
      /**
       * The URL the Archivist reaches the gateway at: its only route to the
       * bus.
       */
      gatewayUrl: string;
      /**
       * The issuer the Archivist's service account signs in at, and whose
       * tokens it admits callers of its HTTP surface by.
       */
      identity: components['schemas']['ServiceIdentity'];
      /**
       * The knowledge base's working tree: the directory holding `.xynolog/`.
       * The event log, the content and the committed config are under it.
       */
      root: string;
      /**
       * The state volume, this knowledge base's alone: the Archivist keeps the
       * knowledge base's views and projections in it, at its top.
       */
      stateHome: string;
      /**
       * The anchored-text store, which only the Archivist mounts: the Smelter
       * stores each entry in it over HTTP, and the Archivist serves it.
       */
      anchoredTextDir: string;
      engines: components['schemas']['ArchivistEngines'];
      /**
       * The port the Archivist's HTTP surface answers on, `/health` included.
       */
      port: number;
      /**
       * Whether the Archivist serves the views it finds at boot instead of
       * rebuilding them from the event log first.
       */
      skipRebuild: boolean;
      /**
       * The bounds on how far the staging driver may run behind the working
       * tree, in milliseconds. A knowledge base that does not sync git stages
       * nothing, and reads neither.
       */
      staging: ArchivistConfigStaging;
      logLevel: components['schemas']['LogLevel'];
      logFormat: components['schemas']['LogFormat'];
    };
    /**
     * The engine for each job and each Librarian actor, behind
     * `browse:engines`: a provider and a model, and no credential. It is the
     * knowledge base's Inference document's `engines` as they stand, with no
     * fallback, so a job or an actor absent here has no engine.
     */
    ArchivistEngines: {
      /**
       * The engine each job is done with when software does it, keyed as a job
       * description is: by `jobType`, and for `mark` by motivation.
       */
      jobs: ArchivistEnginesJobs;
      /** The engine each Librarian actor that calls a model asks. */
      actors: ArchivistEnginesActors;
    };
    /**
     * A page of one stream's events from one sequence number, inclusive, in log
     * order, and the sequence number of the stream's last event: the
     * Archivist's answer to `GET /events/{resourceId}`.
     */
    ArchivistEventsResponse: {
      events: components['schemas']['StoredEventResponse'][];
      /**
       * The sequence number of the stream's last event when it was read: 0 for
       * a stream with none. More events follow the page while its last event's
       * number is below it.
       */
      lastSequence: number;
    };
    /** The Archivist's liveness answer: it serves, and the actors it hosts. */
    ArchivistHealth: {
      status: 'ok';
      /**
       * The record actors this process hosts: each of the enum's, once, in the
       * order the enum lists them.
       */
      actors: ArchivistHealthActorsItem[];
    };
    /**
     * One stream of the event log, and where it stands: the resource it is of,
     * or `__system__` for the knowledge base's own, and the sequence number of
     * its last event.
     */
    ArchivistStream: {
      resourceId: components['schemas']['ResourceId'];
      /**
       * The sequence number of the stream's last event when it was read: 0 for
       * a stream with none.
       */
      lastSequence: number;
    };
    /**
     * Every stream of the event log, `__system__` among them, each with the
     * sequence number of its last event, in no order: the Archivist's answer to
     * `GET /events`.
     */
    ArchivistStreamsResponse: {
      streams: components['schemas']['ArchivistStream'][];
    };
    /**
     * What an assessing job takes: passages of the resource are marked, each
     * with an assessment the model writes.
     */
    AssessingJobParams: {
      motivation: 'assessing';
      /** What to look for, in the caller's words. Added to the prompt. */
      instructions?: string;
      /** The stance the assessments are written from. */
      tone?: AssessingJobParamsTone;
      /** How many annotations to aim for per 2000 words of the resource. */
      density?: number;
      /** The language the annotations' own text is written in. BCP 47. */
      language?: string;
      /** The language of the resource being read. BCP 47. */
      sourceLanguage?: string;
    };
    /**
     * A persisted event as a history reply carries it: the stored event, and
     * the agent its `userId` identifies. The agent is derived when the reply is
     * made — the DID read into a Person or a Software agent, and a Person's
     * name filled in from the knowledge base's profiles — and is stored
     * nowhere. A Person the record does not name carries no `name`.
     */
    AttributedEvent: components['schemas']['StoredEventResponse'] &
      AttributedEventValue;
    /** auth.login's params. */
    AuthLoginParams: {
      /** The version of the control API the request is written to. */
      apiVersion: components['schemas']['ApiVersion'];
      /**
       * Which knowledge base's stack. Absent: the one the command line chooses,
       * standing where the control server was started.
       */
      target?: components['schemas']['Target'];
      /** Keep to the local stacks, as --runtime does. */
      runtime?: components['schemas']['Runtime'];
    };
    /**
     * A completed sign-in, kept in the launcher's sign-in store. No token is in
     * it.
     */
    AuthLoginResult: {
      /** The stack's key in the sign-in store. */
      key: string;
      /** Who the gateway says is signed in: their email, else their DID. */
      who: string;
      /** The issuer the knowledge base named, where the person signed in. */
      issuer: string;
    };
    /** auth.logout's params. */
    AuthLogoutParams: {
      /** The version of the control API the request is written to. */
      apiVersion: components['schemas']['ApiVersion'];
      /**
       * Which knowledge base's stack. Absent: the one the command line chooses,
       * standing where the control server was started.
       */
      target?: components['schemas']['Target'];
      /** Keep to the local stacks, as --runtime does. */
      runtime?: components['schemas']['Runtime'];
    };
    /**
     * The launcher's session for a stack, ended. Desktop's own session is not
     * touched.
     */
    AuthLogoutResult: {
      /**
       * The stack's key in the sign-in store. Absent when no stack is recorded.
       */
      key?: string;
      /** Whether a session was stored. false: nothing was done. */
      wasSignedIn: boolean;
      /**
       * Whether the issuer revoked the session's refresh token. false with
       * wasSignedIn: the local token is forgotten, and the refresh token stays
       * valid at the issuer until it expires.
       */
      revoked: boolean;
    };
    /**
     * Emitted to draw attention to a resource: to one of its annotations, or,
     * with no annotation, to the resource as a whole. The resource is always
     * named. A focus on an annotation scrolls a viewer showing that resource to
     * it, and a viewer showing a different resource ignores it — a deliberate
     * ignore rather than a silent no-op. A focus on the resource as a whole
     * brings that resource forward, opened if it is not open, at its top.
     */
    BeckonFocusEvent: {
      annotationId?: components['schemas']['AnnotationId'];
      /**
       * The resource this focus applies to, always named. With an annotation it
       * is a guard: a viewer showing a different resource ignores the event.
       * With none it is the resource the focus brings forward.
       */
      resourceId: components['schemas']['ResourceId'];
    };
    /** Emitted when an annotation is hovered over for beckoning */
    BeckonHoverEvent: {
      annotationId: components['schemas']['AnnotationId'] | null;
    };
    /** Emitted when a sparkle effect is triggered on an annotation */
    BeckonSparkleEvent: {
      annotationId: components['schemas']['AnnotationId'];
    };
    /**
     * Bytes held whole. They can be read more than once, and sent again when an
     * upload is retried.
     */
    Binary: Blob;
    /**
     * One edit to a linking annotation's body list: add or remove a body item,
     * or replace an existing one.
     */
    BindBodyOperation: {
      /** The type of body operation */
      op: BindBodyOperationOp;
      /** Body item for add operations */
      item?: components['schemas']['AnnotationBody'];
      /** Previous body item for replace operations */
      oldItem?: components['schemas']['AnnotationBody'];
      /** Replacement body item for replace operations */
      newItem?: components['schemas']['AnnotationBody'];
    };
    /**
     * Void success reply emitted on the bind:body-updated channel after
     * bind:update-body has been applied, matched to the originating command by
     * correlationId.
     */
    BindBodyUpdated: Record<string, never>;
    /**
     * Command payload sent on the bind:initiate bus channel to start a bind
     * flow.
     */
    BindInitiateCommand: {
      /** Branded AnnotationId of the annotation being bound */
      annotationId: components['schemas']['AnnotationId'];
      /** Branded ResourceId of the resource being bound to */
      resourceId: components['schemas']['ResourceId'];
      /** Default title for the bound annotation */
      defaultTitle: string;
      /** Entity types to associate with the annotation */
      entityTypes: string[];
    };
    /**
     * Command payload sent on the bind:update-body bus channel to modify
     * annotation bodies.
     */
    BindUpdateBodyCommand: {
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
      /** Branded AnnotationId of the annotation whose body is being updated */
      annotationId: components['schemas']['AnnotationId'];
      /** Branded ResourceId of the resource the annotation belongs to */
      resourceId: components['schemas']['ResourceId'];
      /** Ordered body-list edits to apply. */
      operations: components['schemas']['BindBodyOperation'][];
    };
    /**
     * One change to an annotation's bodies: a body added, a body removed, or
     * one body replaced by another.
     */
    BodyOperation:
      | components['schemas']['BodyOperationAdd']
      | components['schemas']['BodyOperationRemove']
      | components['schemas']['BodyOperationReplace'];
    BodyOperationAdd: {
      op: 'add';
      item: components['schemas']['AnnotationBody'];
    };
    BodyOperationRemove: {
      op: 'remove';
      item: components['schemas']['AnnotationBody'];
    };
    BodyOperationReplace: {
      op: 'replace';
      oldItem: components['schemas']['AnnotationBody'];
      newItem: components['schemas']['AnnotationBody'];
    };
    /**
     * W3C Web Annotation body purpose vocabulary -
     * https://www.w3.org/TR/annotation-vocab/#motivation
     */
    BodyPurpose:
      | 'assessing'
      | 'bookmarking'
      | 'classifying'
      | 'commenting'
      | 'describing'
      | 'editing'
      | 'highlighting'
      | 'identifying'
      | 'linking'
      | 'moderating'
      | 'questioning'
      | 'replying'
      | 'tagging';
    /** Request to browse the history of an annotation */
    BrowseAnnotationHistoryRequest: {
      resourceId: components['schemas']['ResourceId'];
      annotationId: components['schemas']['AnnotationId'];
    };
    /** Result of browsing annotation history */
    BrowseAnnotationHistoryResult: {
      response: components['schemas']['GetAnnotationHistoryResponse'];
    };
    /** Request to browse a single annotation */
    BrowseAnnotationRequest: {
      resourceId: components['schemas']['ResourceId'];
      annotationId: components['schemas']['AnnotationId'];
    };
    /** Result of browsing a single annotation */
    BrowseAnnotationResult: {
      response: components['schemas']['GetAnnotationResponse'];
    };
    /**
     * An annotation was clicked — open it: the viewer selects its entry in the
     * annotations panel and relays a focus signal to scroll to it. The
     * annotation id is the whole address; it identifies exactly one annotation
     * on exactly one resource, so no resource field is carried and none is
     * needed to scope the event. Motivation is NOT on the wire either: the
     * viewer derives it from the annotation the id names, so the wire states
     * the fact once. A viewer that has not loaded that annotation finds nothing
     * and does nothing. Emitted locally by every clickable annotation surface,
     * and over the wire by a driver opening an annotation on another
     * participant's screen.
     */
    BrowseClickEvent: {
      annotationId: components['schemas']['AnnotationId'];
      anchorRect?: components['schemas']['AnchorRect'];
    };
    /**
     * The payload of `browse:directory-failed`: a CommandError that names the
     * directory that could not be read.
     */
    BrowseDirectoryFailed: components['schemas']['CommandError'] &
      BrowseDirectoryFailedValue;
    /** Request to browse a directory listing */
    BrowseDirectoryRequest: {
      path: string;
      sort?: BrowseDirectoryRequestSort;
    };
    /** Result of browsing a directory listing */
    BrowseDirectoryResult: {
      response: components['schemas']['BrowseDirectoryResultResponse'];
    };
    BrowseDirectoryResultResponse: {
      path: string;
      entries: components['schemas']['DirectoryEntry'][];
    };
    /**
     * Request for the knowledge base's engines: those its Inference document
     * names
     */
    BrowseEnginesRequest: Record<string, never>;
    /**
     * The knowledge base's engines: those its Inference document names, and the
     * jobs it has each used for
     */
    BrowseEnginesResult: {
      response: BrowseEnginesResultResponse;
    };
    /** Emitted when an entity type is clicked in the browse panel */
    BrowseEntityTypeClickedEvent: {
      entityType: string;
    };
    /** Request to browse available entity types */
    BrowseEntityTypesRequest: Record<string, never>;
    /** Result of browsing entity types */
    BrowseEntityTypesResult: {
      response: components['schemas']['GetEntityTypesResponse'];
    };
    /** Request to browse events for a resource */
    BrowseEventsRequest: {
      resourceId: components['schemas']['ResourceId'];
      type?: string;
      userId?: components['schemas']['UserId'];
      limit?: number;
    };
    /** Result of browsing events for a resource */
    BrowseEventsResult: {
      response: components['schemas']['GetEventsResponse'];
    };
    /** Emitted when navigation to an external URL is requested */
    BrowseExternalNavigateEvent: {
      url: string;
      resourceId?: components['schemas']['ResourceId'];
    };
    BrowseFilesResponse: {
      /** The directory path that was listed, relative to project root */
      path: string;
      entries: components['schemas']['DirectoryEntry'][];
    };
    /** Request for the knowledge base's description of itself */
    BrowseKbRequest: Record<string, never>;
    /** Result of browse:kb-requested */
    BrowseKbResult: {
      response: components['schemas']['KbDescription'];
    };
    /** Emitted when a link is clicked in the browse panel */
    BrowseLinkClickedEvent: {
      href: string;
      label?: string;
    };
    /** Emitted when a browse panel is opened */
    BrowsePanelOpenEvent: {
      panel: string;
      scrollToAnnotationId?: components['schemas']['AnnotationId'];
      motivation?: components['schemas']['Motivation'];
    };
    /** Emitted when a browse panel is toggled */
    BrowsePanelToggleEvent: {
      panel: string;
    };
    /**
     * Request for the profiles of some principals: the DIDs a reply mentions.
     * Bounded by the question: a reader that has more asks in parts.
     */
    BrowseProfilesRequest: {
      /** The principals asked after. */
      dids: components['schemas']['UserId'][];
    };
    /**
     * The profiles of the principals asked after: each that has one, keyed by
     * DID. A DID with no profile is absent, and is named by no one.
     */
    BrowseProfilesResult: {
      response: BrowseProfilesResultResponse;
    };
    /** Emitted when a resource is closed in the browse panel */
    BrowseResourceCloseEvent: {
      resourceId: components['schemas']['ResourceId'];
    };
    /**
     * Domain intent to open a resource in the viewer: emitted locally by in-app
     * link handlers and remotely by the launcher's tour verbs; the viewer
     * translates it to host routing (nav:push), which never crosses the wire.
     * Deliberately not named 'navigate' — that word and the nav:* prefix belong
     * to the host-local framework layer.
     */
    BrowseResourceOpenEvent: {
      resourceId: components['schemas']['ResourceId'];
    };
    /** Emitted when resources are reordered in the browse panel */
    BrowseResourceReorderEvent: {
      oldIndex: number;
      newIndex: number;
    };
    /** Request to browse a single resource */
    BrowseResourceRequest: {
      resourceId: components['schemas']['ResourceId'];
    };
    /**
     * A resource's descriptor, and the sequence number of the last of its
     * events the descriptor reflects. Its annotations are not here: their
     * number follows the document's, so they are read over HTTP (`GET
     * /resources/{id}/annotations`).
     */
    BrowseResourceResult: {
      response: BrowseResourceResultResponse;
    };
    /**
     * REPORT that a resource has loaded in a viewer — emitted on arrival by ANY
     * means: a followed cue, an in-app link, the back button, a typed URL.
     * Deliberately distinct from the imperative browse:resource-open: drive and
     * report never share a channel, or the driver hears its own commands and
     * one viewer's arrival steers another's page.
     */
    BrowseResourceViewedEvent: {
      resourceId: components['schemas']['ResourceId'];
    };
    /** Request to browse resources with optional filtering and pagination */
    BrowseResourcesRequest: {
      archived?: boolean;
      entityType?: string;
      /**
       * How many of the resources the filters admit are passed over before the
       * page begins.
       */
      offset?: number;
      /** The most resources a page has. */
      limit?: number;
    };
    /** Result of browsing resources */
    BrowseResourcesResult: {
      response: components['schemas']['ListResourcesResponse'];
    };
    /** Emitted when the browse panel requests a router navigation */
    BrowseRouterPushEvent: {
      path: string;
      reason?: string;
    };
    /** Request to browse registered tag schemas */
    BrowseTagSchemasRequest: Record<string, never>;
    /** Result of browsing tag schemas */
    BrowseTagSchemasResult: {
      response: components['schemas']['GetTagSchemasResponse'];
    };
    /**
     * The shared Browser: one viewer for every knowledge base the machine
     * reaches. It belongs to no knowledge base, so its document is kept in the
     * launcher's state home, in `stack/browser.yaml`, not in a knowledge base's
     * repository.
     */
    Browser: {
      apiVersion: components['schemas']['StackApiVersion'];
      kind: 'Browser';
      metadata: components['schemas']['Metadata'];
      /** How the Browser runs. */
      spec: BrowserSpec;
    };
    /**
     * Result of publishing one event. `subscribers` is the number of observers
     * attached to the target subject at dispatch — the GLOBAL subject for an
     * unscoped emit, the scoped one when `scope` is set. Zero means the signal
     * reached nobody: /bus/subscribe enforces no channel allowlist and the emit
     * handler publishes unconditionally, so a client can emit a channel no
     * participant subscribes to and otherwise receive a clean 202 with no way
     * to tell. Deliberately NOT named `delivered`: this is the count at
     * dispatch, and a subscriber may still drop the frame downstream, so the
     * field is named after what the server can actually observe.
     */
    BusEmitAccepted: {
      /**
       * Observers on the target subject when the event was dispatched. ABSENT
       * means the gateway could not count: under a broker signal plane (the
       * KnowledgeBase document's `spec.messaging.signal.type: nats`) the event
       * is published to a fabric whose observers the gateway cannot see. The
       * one zero a broker plane states is a registry operation's request with a
       * `correlationId` that reached nobody, which the broker itself reports
       * (no responders). Never defaulted: a zero here is the claim that nobody
       * was listening, and a gateway that did not observe that never makes it.
       */
      subscribers?: number;
    };
    /**
     * One event for the bus. `channel` names a channel of the bus registry
     * (specs/src/bus/registry.json) and `payload` must match the schema the
     * registry's `validate` names for it. `scope` publishes a resource-bound
     * broadcast to that resource's subscribers only; everything else is
     * unscoped. `clientId` and `correlationId` are routing facts beside the
     * payload, never inside it.
     */
    BusEmitRequest: {
      /** A channel of the bus registry. */
      channel: string;
      /**
       * The channel's payload, validated against the schema its registry entry
       * names. `_userId` and `_roles` are the gateway's to write: whatever a
       * caller puts there is replaced.
       */
      payload: { [key: string]: unknown };
      /**
       * The resource scope of a resource-bound broadcast. Publishers of those
       * broadcasts only; a command or request never carries one.
       */
      scope?: components['schemas']['ResourceId'];
      /**
       * The address this request's reply is delivered to: the emit claims
       * `correlationId` for this clientId and the verified principal. Required
       * when `channel` is a registry operation's request and a correlationId is
       * present; ignored otherwise. An empty string counts as absent.
       */
      clientId?: string;
      /**
       * Pairs a reply with its request. On a registry operation's request it
       * claims the id: a second claim of a live id is refused with 409. Replies
       * carry it back on the frame, never in the payload.
       */
      correlationId?: string;
    };
    /**
     * A bus frame on the stream: `event: bus-event`, an `id:` line, and one
     * `data:` line holding the JSON-serialised BusFrame. This schema describes
     * the message with `data` already parsed.
     */
    BusEventMessage: {
      event: 'bus-event';
      id: BusEventMessageId;
      data: components['schemas']['BusFrame'];
    };
    /**
     * One frame of the bus stream, as the `data` line of a `bus-event` message
     * carries it (JSON-serialised on one line). `payload` is the channel's
     * payload as its registry entry declares it. A frame on a scoped
     * subscription carries the scope it was published on; a correlated reply
     * carries the `correlationId` of the request it answers.
     */
    BusFrame: {
      /** A channel of the bus registry (specs/src/bus/registry.json). */
      channel: string;
      /**
       * The request this frame answers. Present on correlated replies; absent
       * otherwise.
       */
      correlationId?: string;
      /**
       * The channel's payload. A replayed persisted event is the stored event
       * itself, whose `metadata.sequenceNumber` the message id carries.
       */
      payload: { [key: string]: unknown };
      /**
       * The resource scope the frame was published on. Present exactly when it
       * arrived through a `scoped` entry of the subscription.
       */
      scope?: components['schemas']['ResourceId'];
    };
    /**
     * The heartbeat: `event: ping` with an empty `data:` line. The first is
     * written once the stream has caught up (after any replay), then one every
     * `x-xynolog-limits.heartbeatSeconds`. It carries no id, so it never
     * disturbs a client's last-seen ids.
     */
    BusPingMessage: {
      event: 'ping';
      data: string;
    };
    /**
     * The payload of `bus:resume-gap`: a scope's `lastEventId` could not be
     * honoured, so the client cannot trust that it has every persisted event of
     * that scope and must refetch what it caches for it. Written by the
     * gateway, never by a participant.
     */
    BusResumeGap: {
      /** The scope of the subscription entry whose watermark failed. */
      scope: components['schemas']['ResourceId'];
      /** The watermark the entry carried. */
      lastSeenId: string;
      /**
       * `unparseable-last-event-id`: the watermark is not a PersistedEventId.
       * `scope-mismatch`: it names another scope. `retention-exceeded`: the
       * record no longer holds the events after it (what it still holds is
       * replayed first). `query-error`: the record could not be read.
       */
      reason: BusResumeGapReason;
    };
    /**
     * Every message the bus stream carries. A client ignores an `event` it does
     * not know; the gateway writes no other.
     */
    BusStreamMessage:
      | components['schemas']['BusEventMessage']
      | components['schemas']['BusPingMessage'];
    /**
     * Subscription matrix for the bus stream. `global` channels are delivered
     * unscoped; each `scoped` entry subscribes the connection to one resource
     * scope's channels, optionally resuming from that scope's last-seen
     * persisted event id. At least one global channel or one scoped entry is
     * required, and no scope may appear in two entries.
     */
    BusSubscribeRequest: {
      /** Unscoped channels to subscribe to. */
      global?: string[];
      /**
       * Correlation ids of requests this client still awaits a reply to. The
       * gateway writes every reply it still retains for them (for
       * `x-xynolog-limits.replyRetentionSeconds` after it was published) as an
       * ordinary frame with its ReplyEventId, so a reply that also arrived live
       * dedups client-side. A client can have no more pending than it may have
       * unanswered requests, so this bound is also the number of unanswered
       * requests `POST /bus/emit` allows a client.
       */
      pendingReplies?: string[];
      /**
       * Per-resource-scope subscriptions, at most 512 on one connection. Scopes
       * must be unique across entries.
       */
      scoped?: BusSubscribeRequestScopedItem[];
      /**
       * Routing address for correlated replies: a UUID minted once per
       * bus-client lifetime — per actor, not per connection, so it survives a
       * reconnect and two overlapping connections share it. A correlated reply
       * is delivered to a connection only when its request was emitted under
       * the same clientId by the same principal. Not authentication — the
       * bearer token stays that — and never echoed into any payload or
       * broadcast frame.
       */
      clientId: string;
    };
    /**
     * The client gives up on one of its requests. The launcher answers that
     * request with control.cancelled, unless it has answered it already; a
     * cancellation of a request it does not know is ignored.
     */
    Cancelled: {
      requestId: components['schemas']['RequestId'];
      /** Why, for the launcher's diagnostics. */
      reason?: string;
    };
    /**
     * The form a service account that holds a client secret posts to its
     * issuer's token endpoint for a client-credentials grant: its client id and
     * secret in the body (RFC 6749 §2.3.1). An account that holds a key proves
     * itself by the client assertion of client-assertion-cases.json instead.
     */
    ClientSecretForm: {
      /** The grant, client-assertion-cases.json's grantType. */
      grant_type: 'client_credentials';
      /** The account's client id. */
      client_id: string;
      /** The account's client secret. */
      client_secret: string;
    };
    CloneResourceWithTokenResponse: {
      /** Generated clone token */
      token: string;
      /** ISO 8601 timestamp when token expires */
      expiresAt: string;
      resource: components['schemas']['ResourceDescriptor'];
    };
    /**
     * Error response for failed bus commands. Replaces native Error objects on
     * the EventBus so payloads are serializable and OpenAPI-typed.
     */
    CommandError: {
      /**
       * Machine-readable failure class, for consumers that must BRANCH on why a
       * command failed rather than log it. Optional and deliberately sparse:
       * absent means 'no class declared', and every existing failure stays that
       * way. An enum rather than a free string so the vocabulary has an owner —
       * an unconstrained code is a mirror with no gate, and adding one should
       * be a deliberate spec change. `message` remains the human-readable text
       * and is unaffected. Members: `peer-unavailable` — the channel this
       * command was sent on has no subscriber, i.e. the service that answers it
       * has not connected yet. Transient by nature (a peer still starting),
       * which is what distinguishes it from a refusal: retrying is the correct
       * response. `not-found` — the resource this command addressed does not
       * exist in this knowledge base. A verdict, not a symptom: it is emitted
       * only where the answer comes from the event store, which is the system
       * of record, and never from a projection that may merely be lagging.
       * Deterministic, so unlike `peer-unavailable` retrying is pointless — and
       * consumers may act destructively on it (the SDK deletes a restored tab).
       * Absence is not denial: a future 'exists, but not for you' must travel
       * as its own code, never as this one. `unauthorized` — that code: the
       * caller is authenticated but not permitted to do what it asked. A
       * verdict about the CALLER, not the resource, so retrying under the same
       * credential cannot succeed and a consumer must never spin on it; emitted
       * by `job:claim` for a caller whose token carries no worker role.
       * `none-pending` — a declined claim, not an error: the queue holds no
       * pending job of the requested types. Nothing went wrong; the one code a
       * consumer PARKS on, meaning 'nothing to do until a wake-up'. Emitted by
       * `job:claim` only. A `job:claim` refusal carrying neither is
       * unclassified — a malformed record or a missing injection — and a
       * consumer treats it as 'log it, assume nothing'.
       */
      code?: CommandErrorCode;
      /** Human-readable error message */
      message: string;
      /** Optional additional context (stack trace, field name, etc.) */
      details?: string;
    };
    /**
     * What a commenting job takes: passages of the resource are marked, each
     * with a comment the model writes.
     */
    CommentingJobParams: {
      motivation: 'commenting';
      /** What to look for, in the caller's words. Added to the prompt. */
      instructions?: string;
      /** The voice the comments are written in. */
      tone?: CommentingJobParamsTone;
      /** How many annotations to aim for per 2000 words of the resource. */
      density?: number;
      /** The language the annotations' own text is written in. BCP 47. */
      language?: string;
      /** The language of the resource being read. BCP 47. */
      sourceLanguage?: string;
    };
    /**
     * A request on the bus a live case expects the client to make, on this
     * channel; `as` names its correlation id, for the backend to answer.
     */
    ConformanceBusFetch: {
      /** The request's channel, a request of specs/src/bus/registry.json. */
      fetch: string;
      payload?: unknown;
      /** The request's correlation id, for the backend's answer. */
      as: string;
    };
    /**
     * One case of the conformance corpus: a scenario every SDK's driver is put
     * through, a JSON file of conformance/sdk/wire, conformance/sdk/live or
     * conformance/worker/cases named by the case. What the client is asked to
     * do, what the backend does around it, and the transcript a conforming
     * client produces. conformance/sdk/README.md explains each step; the reader
     * reads every file of the corpus through this schema.
     */
    ConformanceCase: {
      /** What the case holds a client to, in a sentence. */
      about: string;
      /** Where the protocol or the spec states it. */
      source: string;
      /** The signal planes the case runs on. Absent, it runs on both. */
      planes?: ConformanceCasePlanesItem[];
      /**
       * A live case's tier: `fleet`, what every SDK with a live layer does, or
       * `parity`, what one that implements all of CACHE-SEMANTICS does.
       */
      tier?: ConformanceCaseTier;
      /**
       * Run the client exporting to an OTLP receiver, and once it has exited
       * hold what it exported to specs/src/sdk-telemetry/telemetry.json. A
       * worker case also holds the worker to a trace of its own for each job it
       * ran (conformance/worker/README.md).
       */
      telemetry?: true;
      /** The steps, run in order. */
      steps: components['schemas']['ConformanceStep'][];
    };
    /**
     * A line a conformance driver writes on its standard output, one JSON
     * object each (conformance/sdk/README.md, "The driver protocol";
     * conformance/worker/README.md, "The worker driver"): that it is ready, an
     * operation's outcome, or what its client observed as it happened. The
     * suite refuses any other line.
     */
    ConformanceDriverLine:
      | ConformanceDriverLineReady
      | ConformanceDriverLineOk
      | ConformanceDriverLineFailed
      | ConformanceDriverLineAbandoned
      | ConformanceDriverLineUnsupported
      | ConformanceDriverLineMisuse
      | ConformanceDriverLineState
      | ConformanceDriverLineFrame
      | ConformanceDriverLineErrorStream
      | ConformanceDriverLineProgress
      | ConformanceDriverLineEmission
      | ConformanceDriverLineCompleted
      | ConformanceDriverLineClaimed
      | ConformanceDriverLineRefused
      | ConformanceDriverLineSignalled
      | ConformanceDriverLineStalled;
    /**
     * A failure as an SDK reports it to the suite (conformance/sdk/README.md,
     * "The driver protocol"): its code, the status when a server stated one,
     * and a job failure's class when it has one; and the SDK's own words for
     * it.
     */
    ConformanceFailure: {
      /** The SDK's code for it, from specs/src/errors/codes.json. */
      code?: string;
      /** The HTTP status, when a server stated one. */
      status?: number;
      /** A job failure's class, when it has one. */
      failureClass?: components['schemas']['FailureClass'];
      /** The SDK's words, for a person; nothing compares it. */
      detail: string;
    };
    /**
     * A read over HTTP a live case expects the client to make: an operation of
     * the gateway's API by its method and path, with the values its path
     * carries. The stand-in Archivist answers it from what the case seeded.
     */
    ConformanceHttpFetch: {
      /** The operation, by its method and path. */
      fetch: string;
      params?: unknown;
    };
    /**
     * The implementations manifest: the file a run of the conformance harness
     * is given with --implementations, naming what the run holds to Protocol.
     * Every service is run by the xynolog launcher, from the image the
     * knowledge base's stack documents name (contract/LAUNCHER-CONTROL.md,
     * service.run): an implementation is a knowledge base whose documents name
     * its images, and another implementation is another manifest. Each SDK's
     * drivers are programs the harness starts itself, since none is a service.
     * There is no default manifest. The reader reads this schema in the table
     * dialect and derives its model (Tables.Conformance_implementations), for
     * the harness to decode a manifest by.
     */
    ConformanceImplementations: {
      /**
       * How the launcher's control API is served: the xynolog command, run with
       * control. A command and its arguments, as the harness starts it. An
       * argument that starts with ./ or ../ is a path, resolved against the
       * manifest's own directory; every other is passed as written.
       */
      launcher: string[];
      /**
       * The knowledge base whose stack documents name each service's image, and
       * whose stack runs the record and index the suites need. A relative root
       * is resolved against the manifest's own directory.
       */
      target: components['schemas']['LocalTarget'];
      /**
       * Each SDK's drivers, by the SDK's name: the programs the SDK and worker
       * suites talk to in its place (conformance/sdk/README.md, "The driver
       * protocol").
       */
      sdks: { [key: string]: ConformanceImplementationsSdksValue };
      /**
       * The model catalogue the implementation supplies, by its path; a
       * relative one is resolved against the manifest's own directory. The
       * Librarian's and the worker service's documents name one, so a run of
       * either suite without it refuses to start.
       */
      modelCatalogue?: string;
    };
    /**
     * One step of a case of the conformance corpus (ConformanceCase.json): each
     * is told apart by the member only it requires. conformance/sdk/README.md,
     * "A case", says what each does.
     */
    ConformanceStep:
      | ConformanceStepLet
      | ConformanceStepDriver
      | ConformanceStepAbandon
      | ConformanceStepSettles
      | ConformanceStepWire
      | ConformanceStepCarried
      | ConformanceStepClosed
      | ConformanceStepProgress
      | ConformanceStepState
      | ConformanceStepStays
      | ConformanceStepFrame
      | ConformanceStepFrames
      | ConformanceStepError
      | ConformanceStepBackend
      | ConformanceStepQuiet
      | ConformanceStepObserve
      | ConformanceStepLeave
      | ConformanceStepReaches
      | ConformanceStepHolds
      | ConformanceStepCompletes
      | components['schemas']['ConformanceBusFetch']
      | components['schemas']['ConformanceHttpFetch']
      | ConformanceStepFetches
      | ConformanceStepScopes
      | ConformanceStepClaimed
      | ConformanceStepRefused
      | ConformanceStepSignalled
      | ConformanceStepStalled;
    /**
     * Content format as a MIME type, optionally with parameters. The base type
     * (everything before the first ';') MUST be a SupportedMediaType;
     * parameters such as charset are preserved as metadata. Semantic validation
     * happens in code at the create/yield boundary — there is deliberately no
     * pattern here, the vocabulary lives in SupportedMediaType. Examples:
     * text/plain, text/plain; charset=iso-8859-1, text/markdown;
     * charset=windows-1252, image/png, application/pdf
     */
    ContentFormat: string;
    ContextualSummaryResponse: {
      summary: string;
      /**
       * What the summary is of: the resource the annotation is on, and the
       * annotation's entity types.
       */
      relevantFields: ContextualSummaryResponseRelevantFields;
      context: ContextualSummaryResponseContext;
    };
    CreateAnnotationRequest: {
      motivation: components['schemas']['Motivation'];
      target: components['schemas']['AnnotationTarget'];
      /**
       * Optional body. Omit for annotations whose motivation alone is
       * meaningful (highlighting) or whose user-supplied content is empty.
       * Shape matches Annotation.body.
       */
      body?: components['schemas']['AnnotationBodies'];
    };
    /**
     * The id of the resource an upload created. The Archivist answers it (200)
     * once it has stored the bytes and recorded the resource, and the gateway
     * forwards it (202), so the id is the one the record minted and its
     * creation event is persisted. What remains asynchronous is downstream
     * projection: graph, views and vectors settle afterwards.
     */
    CreateResourceResponse: {
      /** The id of the newly created resource, as the record minted it. */
      resourceId: components['schemas']['ResourceId'];
    };
    /**
     * The file a follower of the record keeps its cursors in: for each log of
     * the record it follows, the sequence number of the last event of it taken
     * (contract/TRANSPORT-CONTRACT.md § What repairs a passing frame). A file
     * of the service's own disk, never of the knowledge base: a service that
     * finds none starts each log as it starts one with no cursor, so losing it
     * costs time and never correctness.
     */
    CursorsPath: string;
    DirEntry: {
      type: 'dir';
      /** Entry name (basename) */
      name: string;
      /** Path relative to project root */
      path: string;
      /** Last modified time (ISO 8601) */
      mtime: string;
    };
    /**
     * One entry in a directory listing: a file, which may carry the resource it
     * was ingested as, or a subdirectory. Tell them apart by `type`, which is
     * required on both and single-valued.
     */
    DirectoryEntry:
      components['schemas']['FileEntry'] | components['schemas']['DirEntry'];
    /**
     * One knowledge base the Xynolog launcher manages on this machine, as
     * published in the discovery document (see DiscoveryDocument). Endpoints
     * and identity only — never credentials; login remains the consumer's
     * per-KB business.
     */
    DiscoveredKB: {
      /**
       * Hostname the KB is reachable on from this machine (always "localhost" —
       * local stacks bind locally and codespace KBs arrive through a local port
       * forward)
       */
      host: string;
      /**
       * Local TCP port of the KB's API (the gateway port for a local stack; the
       * allocated forward port for a codespace stack)
       */
      port: number;
      /**
       * Where the stack actually runs. "local": containers on this machine.
       * "codespace": a GitHub-hosted VM whose KB is port-forwarded here.
       */
      placement: DiscoveredKBPlacement;
      /**
       * owner/name GitHub slug — present for codespace placements, where the
       * repo is the stack's identity
       */
      repo?: string;
      /**
       * The KB's did:web identifier, from its committed .xynolog/config.yaml —
       * "did:web:" + its site.domain, verbatim. REQUIRED: a KB that declares no
       * domain has no identity to publish, and the launcher refuses to start it
       * rather than inventing or defaulting one. NOT unique within a document:
       * a did names the knowledge base, not a running copy of it, so a local
       * clone and a codespace of the same repo legitimately share one and both
       * are published. host:port is the unique field (at most one entry per
       * address), so consumers look up by ADDRESS and use the did to VERIFY
       * that the copy they reached is the KB they meant — an address alone
       * cannot say which KB is which, and an identity alone cannot say which
       * copy.
       */
      did: string;
      /**
       * Human-readable site name from the KB's .xynolog/config.yaml
       * (site.siteName), for display
       */
      siteName?: string;
      /**
       * The agent that owns this entry's lifecycle (the launcher writes
       * "xynolog-launcher"). Consumers treat managed entries as authoritative
       * for themselves — upsert on appearance, remove on disappearance — and
       * never touch entries they did not write.
       */
      managedBy: string;
    };
    /**
     * The launcher's KB discovery document — the schema authority for
     * <stateDir>/discovery/kbs.json, which the Xynolog CLI (xynolog/cli)
     * regenerates on every stack mutation and the Browser container mounts
     * read-only at /discovery. NOT an API endpoint: a static document fetched
     * same-origin by browsers (via the Browser's static server). An empty kbs
     * list is meaningful ("the launcher manages nothing right now") and
     * distinct from an absent file.
     */
    DiscoveryDocument: {
      /**
       * Document schema version. Consumers MUST check it and ignore documents
       * they do not understand.
       */
      version: 1;
      /** Every KB the launcher currently manages, local and forwarded */
      kbs: components['schemas']['DiscoveredKB'][];
    };
    /**
     * Everything the dispatcher reads at boot: nothing in it is defaulted by
     * the dispatcher. The launcher writes it for the dispatcher it starts, from
     * the knowledge base's stack documents, and the dispatcher reads it from
     * the path its `--config` flag names (its image passes
     * `/etc/xynolog/dispatcher.json`). Started without `--config`, or with a
     * path that names no file, the dispatcher refuses to start and says which.
     * Secrets are never values here: a field that needs one names the
     * environment variable holding it. The dispatcher's other inputs are the
     * environment variables specs/src/service-environment/variables.json lists
     * for it, and the ones this document names. A document that does not
     * validate is refused at boot, naming each failing field.
     */
    DispatcherConfig: {
      kb: components['schemas']['KbIdentity'];
      /**
       * The URL the dispatcher reaches the gateway at: its only route to the
       * bus.
       */
      gatewayUrl: string;
      /** The issuer the dispatcher's service account signs in at. */
      identity: components['schemas']['ServiceIdentity'];
      /**
       * The JetStream broker holding the job queue, whose layout is
       * specs/src/jobs/storage.json.
       */
      queue: DispatcherConfigQueue;
      /** The port the dispatcher answers `/health` on. */
      port: number;
      /**
       * The queue's clocks, in milliseconds. The launcher writes the values a
       * deployment runs with; a test harness shrinks them.
       */
      timing: DispatcherConfigTiming;
      logLevel: components['schemas']['LogLevel'];
      logFormat: components['schemas']['LogFormat'];
    };
    /**
     * The dispatcher's liveness answer. It answers only once its queue has
     * connected and its bus pumps are attached, so a 200 means it can take
     * work.
     */
    DispatcherHealth: {
      status: 'ok';
      /** The queue it holds. */
      queue: 'jetstream';
    };
    /**
     * How a job's annotations were established as durable — the OBSERVATION,
     * never a conclusion drawn from it. 'acknowledged': the event log confirmed
     * the batch (mark:commit-ok). 'probe-confirmed': the acknowledgement was
     * lost and a later read found the batch's last annotation present — true,
     * but a weaker claim than an ack, since it rests on the log appending a
     * batch in order and stopping at the first failure. 'probe-refused': the
     * read returned a failure reply; note this does NOT assert the annotations
     * are absent, because a read that failed for its own reasons answers on the
     * same channel. 'probe-unreachable': no answer came at all, so nothing was
     * established either way. ABSENT means the question never arose — a job
     * that committed no annotations. Never defaulted: a manufactured value here
     * is a claim nobody made, in a log nobody can rewrite.
     */
    DurabilityEvidence:
      | 'acknowledged'
      | 'probe-confirmed'
      | 'probe-refused'
      | 'probe-unreachable';
    /**
     * The embedding provider a service asks for vectors, and what that kind of
     * provider needs to be asked: one of the providers `xynolog-vectors` has,
     * told apart by `type`. Two services that share an index name the same
     * provider and the same model: a vector is compared only with vectors of
     * the model that made it. A secret is never a value here: a provider's key
     * is named by the environment variable that holds it.
     */
    EmbeddingConfig:
      | components['schemas']['OllamaEmbeddingConfig']
      | components['schemas']['VoyageEmbeddingConfig'];
    /**
     * An engine: an inference provider and a model, which software does a job
     * or an actor's step with. An engine is not a principal: the principal that
     * used one names it on each write it produced with it (`generator`). A
     * person who does a job uses none.
     */
    Engine: {
      /**
       * The inference provider: who serves the model. `anthropic`, `google`,
       * `openai` and `together` are those companies' own APIs. `llamacpp`,
       * `ollama` and `vllm` are servers a deployment runs or reaches, each
       * named for the server's software.
       */
      provider: EngineProvider;
      /** The model identifier, as the provider names it. */
      model: string;
    };
    /**
     * One of the knowledge base's engines: a provider and a model its Inference
     * document names, and the jobs the document has it used for. An engine is
     * not a principal: whichever worker claims a job does it, under its own
     * account, and names on each write the engine it used, if any. Carries no
     * inference limits: the services that hold the inference credentials report
     * those (InferenceLimitsResult).
     */
    EngineEntry: {
      engine: components['schemas']['Engine'];
      /**
       * The jobs the knowledge base's Inference document has this engine used
       * for, as a claim names them. Absent for an engine only Librarian actors
       * ask.
       */
      jobs?: components['schemas']['JobFilter'][];
    };
    /** The discovered limits of one engine. */
    EngineLimits: {
      engine: components['schemas']['Engine'];
      limits: components['schemas']['InferenceLimits'];
    };
    /**
     * Wire format for persisted events delivered over the bus SSE stream (GET
     * /bus/subscribe). Extends StoredEventResponse with optional enrichment
     * fields the EventStore populates from the materialized view at publish
     * time (persistence → view → enrich → notification). Subscribers read the
     * enrichment fields directly to update local caches without an additional
     * fetch.
     */
    EnrichedResourceEvent: components['schemas']['StoredEventResponse'] &
      EnrichedResourceEventValue;
    /**
     * Payload for mark:entity-tag-added and mark:entity-tag-removed domain
     * events
     */
    EntityTagChangedPayload: {
      entityType: string;
    };
    /**
     * Payload for frame:entity-type-added domain event (system-level, no
     * resourceId — fan-out is global)
     */
    EntityTypeAddedPayload: {
      entityType: string;
    };
    /**
     * The knowledge base's entity-type vocabulary: the file
     * `projections/__system__/entitytypes.json` under the state directory, the
     * sum of the `frame:entity-type-added` events. Written as JSON indented by
     * two spaces.
     */
    EntityTypesProjection: {
      /** Every entity type added, each once, sorted. */
      entityTypes: string[];
    };
    /**
     * `e-<publishId>` — the id of any other frame, given once when the frame is
     * published: the same on every connection that carries it, through every
     * replica, so a copy arriving on two connections (a reconnect overlap)
     * dedups. Never a resumption watermark.
     */
    EphemeralEventId: string;
    /**
     * The data of a control error: the launcher's code for the failure, one of
     * specs/src/errors/codes.json's control group, and what a client can act
     * on. A request's failure is never only a message.
     */
    ErrorData: {
      /**
       * Why the request failed: a code of the control group of
       * specs/src/errors/codes.json.
       */
      code: string;
      /**
       * Whether the same request can succeed sent again unchanged, once
       * something outside it changes: a start finishes, a runtime is installed,
       * a stack comes up.
       */
      retryable: boolean;
      /** For params the contract refuses: each fault, where it is. */
      fields?: components['schemas']['FieldFault'][];
      /**
       * For control.target-required and control.target-ambiguous: each target
       * the request could have meant, to send again with one.
       */
      choices?: components['schemas']['Target'][];
      /**
       * For control.unsupported-api-version: each version this launcher speaks.
       */
      supported?: string[];
      /**
       * For a cancelled stack.start: whether services the start launched may
       * still be running. The launcher stops waiting, and stops nothing.
       */
      mayStillRun?: boolean;
    };
    /**
     * The body of every error the gateway answers, whatever the status and
     * whatever the route — including a path it does not serve.
     */
    ErrorResponse: {
      /** What went wrong, in a sentence. */
      error: string;
      /** A machine-readable class, when the route defines one. */
      code?: string;
      /** What the caller can do about it, when there is something to say. */
      hint?: string;
      details?: unknown;
    };
    /**
     * Metadata added at persistence time. Part of every StoredEvent. Integrity
     * is provided by git at the commit level (when gitSync is enabled), not by
     * in-event metadata fields.
     */
    EventMetadata: {
      /** Monotonic position in the event log (ordering authority) */
      sequenceNumber: number;
    };
    /**
     * A successful extraction: the anchored text plus its provenance. The
     * 'extracted' member of ExtractionOutcome, the record the anchored-text
     * store holds.
     */
    ExtractedText: components['schemas']['AnchoredText'] & ExtractedTextValue;
    /**
     * A named decline: extraction ran and yielded nothing, by class. A
     * first-class, cacheable outcome — 'we ran and there was nothing' costs a
     * full recognition pass to discover.
     */
    ExtractionDeclined: {
      /**
       * Discriminant — both ExtractionOutcome members carry `kind`,
       * single-valued: the category here, the detail in `declined`.
       */
      kind: 'declined';
      /** Why extraction yielded nothing, by class. */
      declined: components['schemas']['ExtractionDeclinedReason'];
    };
    /** Why extraction yielded nothing, by class. */
    ExtractionDeclinedReason:
      'no-text-layer' | 'encrypted' | 'corrupt' | 'too-large';
    /**
     * How a text was extracted: a plain text taken as it is, a PDF's text layer
     * read, a grid written as rows, a filled form's values read, or pixels read
     * by OCR.
     */
    ExtractionMethod:
      'text-passthrough' | 'pdf-text-layer' | 'table' | 'form' | 'ocr';
    /**
     * The full outcome of text extraction for one representation — the record
     * the anchored-text store holds and the wire serves. Discriminated on
     * `kind`: 'extracted' — the anchored text with its provenance; 'declined' —
     * a named decline. ocrConfidence is extraction quality for operators,
     * deliberately not anchor confidence.
     */
    ExtractionOutcome:
      | components['schemas']['ExtractedText']
      | components['schemas']['ExtractionDeclined'];
    /**
     * The class of a job's failure, stated by the worker, where the failure is
     * still typed: at the gateway it is already text, and classing a failure by
     * its text is what this exists to avoid. A job no worker concluded, because
     * its worker stopped reporting, is classed by the dispatcher, as
     * 'transient'. Each value is a claim. 'transient': nothing about the
     * request was judged (the worker's own bound ran out, the provider said not
     * now), so another attempt may succeed. 'deterministic': the same request
     * cannot succeed on a second attempt. 'withheld': the model's provider had
     * the request and withheld its answer, by a refusal or a content filter,
     * and the same request is withheld again; nothing broke. A 'deterministic'
     * or a 'withheld' failure is not retried, whatever retry budget is left.
     * ABSENT means the failure was not classified, which is not the claim
     * 'transient' makes; it is retried as a transient one is. Only a failure
     * known to be deterministic or withheld is called so: calling a transient
     * failure either one halves reliability, where the reverse costs one wasted
     * attempt.
     */
    FailureClass: 'transient' | 'deterministic' | 'withheld';
    /** One fault in a request's params, named where it is. */
    FieldFault: {
      /**
       * Where in the params the fault is, as a JSON pointer (RFC 6901); empty
       * for the params as a whole.
       */
      field: string;
      /** What is wrong there. */
      message: string;
    };
    FileEntry: {
      type: 'file';
      /** Entry name (basename) */
      name: string;
      /** Path relative to project root */
      path: string;
      /** File size in bytes */
      size: number;
      /** Last modified time (ISO 8601) */
      mtime: string;
      /** True if this file is a tracked resource in the Knowledge Base */
      tracked: boolean;
      /** Resource ID (only when tracked is true) */
      resourceId?: components['schemas']['ResourceId'];
      /** Entity types assigned to this resource (only when tracked is true) */
      entityTypes?: string[];
      /** Number of annotations on this resource (only when tracked is true) */
      annotationCount?: number;
      /**
       * DID of the resource's creator — the first of its derived
       * `wasAttributedTo`, the requester as the knowledge base recorded it
       * (only when tracked is true)
       */
      creator?: string;
    };
    /**
     * How far a follower of the record has followed it, as every follower says
     * it at its health port (WEAVER.md § Health, SMELTER.md § Health).
     */
    FollowerFollowing: {
      /**
       * The latest sweep's phase: `pending` before its stream first opens,
       * `running`, `done`, or `due` where the record could not be listed and
       * the sweep is tried again.
       */
      sweep: FollowerFollowingSweep;
      /**
       * How many resources' logs a failed taking has stopped until the next
       * sweep.
       */
      stopped: number;
      /** How many events it refused as recorded since it started. */
      refused: number;
      /** How many times its stream has dropped since it started. */
      streamDrops: number;
    };
    /**
     * W3C Web Annotation FragmentSelector for media fragment identifiers (RFC
     * 3778 for PDFs)
     */
    FragmentSelector: {
      type: 'FragmentSelector';
      /**
       * Media fragment identifier (e.g., 'page=1&viewrect=100,200,50,30' for
       * PDF)
       */
      value: string;
      /** URI identifying the fragment syntax specification */
      conformsTo?: string;
    };
    /**
     * Bus command to add a new entity type to the KB's vocabulary. Carried on
     * the `frame:add-entity-type` channel — Frame is the schema-layer flow that
     * owns vocabulary writes.
     */
    FrameAddEntityTypeCommand: {
      tag: string;
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
    };
    /**
     * Bus command to register a tag schema with the KB's runtime registry.
     * Carried on the `frame:add-tag-schema` channel — Frame is the schema-layer
     * flow that owns vocabulary writes. Most-recent registration of a given
     * `schema.id` wins; the projection reflects the latest content. Identical
     * re-registrations are silent; differing content overwrites and logs a
     * warning.
     */
    FrameAddTagSchemaCommand: {
      schema: components['schemas']['TagSchema'];
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
    };
    /**
     * Everything the gateway reads at boot: nothing in it is defaulted by the
     * gateway. The launcher writes it for the gateway it starts — from the
     * knowledge base's committed identity and its stack documents — and a
     * gateway started any other way is given the same document at the path its
     * `--config` flag names (the image passes `/etc/xynolog/gateway.json`).
     * Started without `--config`, or with a path that names no file, the
     * gateway refuses to start and says which. Secrets are never values here: a
     * field that needs one names the environment variable holding it. The
     * gateway's other inputs are the environment variables
     * specs/src/service-environment/variables.json lists for it, and the ones
     * this document names. A document that does not validate is refused at boot
     * — the gateway exits without serving — and the refusal names each failing
     * field by its JSON pointer.
     */
    GatewayConfig: {
      kb: components['schemas']['KbIdentity'];
      /**
       * The port the gateway listens on, on every address the host has: IPv4
       * and IPv6.
       */
      port: number;
      /**
       * The URL clients reach this gateway at: the `servers` entry of the
       * OpenAPI document it serves.
       */
      publicUrl: string;
      /** The issuer this knowledge base trusts. */
      identity: GatewayConfigIdentity;
      /** Where the Archivist listens. */
      archivist: components['schemas']['ServiceAddress'];
      /**
       * The signal plane: `in-process`, one gateway on its own fabric; or
       * `nats`, the fabric every replica on one broker shares, which requires
       * `servers` and a broker with JetStream.
       */
      signal: GatewayConfigSignal;
      logLevel: components['schemas']['LogLevel'];
      logFormat: components['schemas']['LogFormat'];
      /**
       * What this gateway process can hold, from the memory its deployment
       * gives it. `queuedBytes`: the bytes queued for all its streams together;
       * at it, a new stream is refused with 503 (`AtCapacity`, code `capacity`)
       * until the queues drain — each stream's own bound is
       * `x-xynolog-limits.pendingWriteBytes`. `connections`: the connections it
       * holds open at once; one past it is closed unanswered. The launcher
       * derives both from the memory it gives the gateway's container.
       */
      capacity: GatewayConfigCapacity;
    };
    /**
     * Completion payload emitted on the gather:annotation-complete bus channel
     * when annotation context gathering finishes.
     */
    GatherAnnotationComplete: {
      /** Branded AnnotationId of the annotation whose context was gathered */
      annotationId: components['schemas']['AnnotationId'];
      /**
       * The gathered annotation context (unified GatheredContext,
       * focus.kind:'annotation')
       */
      response: components['schemas']['GatheredContext'];
    };
    /**
     * Optional configuration for an annotation-focus gather, which windows text
     * around a mark. Distinct from the resource-focus options (depth /
     * maxResources / includeContent / includeSummary), which traverse the
     * resource graph.
     */
    GatherAnnotationOptions: {
      /** Whether to include source context in the gathered result */
      includeSourceContext?: boolean;
      /** Whether to include target context in the gathered result */
      includeTargetContext?: boolean;
      /**
       * How much of the text on each side of the annotation to include, counted
       * in Unicode code points
       */
      contextWindow?: number;
    };
    /**
     * Request payload sent on the gather:requested bus channel to gather
     * context for an annotation.
     */
    GatherAnnotationRequest: {
      /** Branded AnnotationId of the annotation to gather context for */
      annotationId: components['schemas']['AnnotationId'];
      /** Branded ResourceId of the resource the annotation belongs to */
      resourceId: components['schemas']['ResourceId'];
      options?: components['schemas']['GatherAnnotationOptions'];
    };
    /**
     * The payload of `gather:failed`: a CommandError that names the annotation
     * whose context could not be gathered.
     */
    GatherFailed: components['schemas']['CommandError'] & GatherFailedValue;
    /**
     * Request for the annotations elsewhere that refer to a resource. The
     * Librarian answers from the graph.
     */
    GatherReferencedByRequest: {
      resourceId: components['schemas']['ResourceId'];
      /**
       * The one motivation the annotations answered have. Every annotation that
       * refers to the resource is answered where none is stated.
       */
      motivation?: components['schemas']['Motivation'];
    };
    /** The annotations elsewhere that refer to a resource */
    GatherReferencedByResult: {
      response: components['schemas']['GetReferencedByResponse'];
    };
    /**
     * Completion payload emitted on the gather:resource-complete bus channel
     * when resource context gathering finishes.
     */
    GatherResourceComplete: {
      /** Branded ResourceId of the resource whose context was gathered */
      resourceId: components['schemas']['ResourceId'];
      /**
       * The gathered resource context (unified GatheredContext,
       * focus.kind:'resource')
       */
      response: components['schemas']['GatheredContext'];
    };
    /**
     * The payload of `gather:resource-failed`: a CommandError that names the
     * resource whose context could not be gathered.
     */
    GatherResourceFailed: components['schemas']['CommandError'] &
      GatherResourceFailedValue;
    /**
     * Request payload sent on the gather:resource-requested bus channel to
     * gather context for a resource.
     */
    GatherResourceRequest: {
      /** Branded ResourceId of the resource to gather context for */
      resourceId: components['schemas']['ResourceId'];
      options: components['schemas']['GatherResourceRequestOptions'];
    };
    /** Gathering configuration */
    GatherResourceRequestOptions: {
      /**
       * How many links out from the resource the knowledge graph reaches,
       * nearest first: 1 is what the resource links to and what cites it, and
       * each further link out adds what those link to and what cites them
       */
      depth: number;
      /** Maximum number of related resources to include */
      maxResources: number;
      /** Whether to include resource content in the gathered result */
      includeContent: boolean;
      /** Whether to include resource summaries in the gathered result */
      includeSummary: boolean;
      /**
       * Entity types to exclude from the semantic recall built into this
       * context (caller-supplied; e.g. a chat consumer passes ['Question'] so
       * prior questions never ground answer generation). Optional; default
       * none.
       */
      excludeEntityTypes?: string[];
    };
    /** Request to generate an AI summary of an annotation */
    GatherSummaryRequest: {
      annotationId: components['schemas']['AnnotationId'];
      resourceId: components['schemas']['ResourceId'];
    };
    /**
     * Context gathered for a gather.* call — consumed by yield.* (generation)
     * and the matcher. A shared base (graph, semanticContext, metadata,
     * inferredRelationshipSummary) plus a discriminated `focus` that names the
     * anchor: an annotation or a whole resource.
     */
    GatheredContext: {
      /** The gather anchor. Discriminated on `kind`. */
      focus: GatheredContextFocus;
      /**
       * Knowledge graph backbone — resources AND annotations as typed nodes.
       * The flattened views (connections, citedBy, siblings) are derived from
       * this.
       */
      graph: components['schemas']['KnowledgeGraph'];
      /**
       * Semantically similar passages from across the knowledge base, found via
       * vector search
       */
      semanticContext?: GatheredContextSemanticContext;
      /** Context metadata about the focal anchor and its source */
      metadata: GatheredContextMetadata;
      /**
       * LLM-generated summary of the focal anchor's relationships in the
       * knowledge graph
       */
      inferredRelationshipSummary?: string;
    };
    /**
     * The parameters of a `yield` job: what it is asked to make
     * (GenerationJobRequest) and the gathered context it is made from. The
     * job's resource is derived from `context.focus` by the dispatcher
     * (resource focus → focus.resource; annotation focus →
     * focus.sourceResource, with the worker binding to focus.annotation), and
     * the dispatcher refuses a parameter this schema does not name.
     */
    GenerationJobParams: components['schemas']['GenerationJobRequest'] &
      GenerationJobParamsValue;
    /**
     * What a `yield` job is asked to make: every parameter of
     * GenerationJobParams but its `context`, the input the resource is made
     * from. It is what an announcement of the job carries.
     */
    GenerationJobRequest: {
      /**
       * Title of the generated resource. Not empty: the gateway refuses a
       * `job:create` whose title is.
       */
      title: string;
      /**
       * Storage URI for the generated resource's content — AUTHORITATIVE: the
       * worker writes exactly here and never derives a location from the title.
       * Not empty, and there is no fallback: the gateway refuses a `job:create`
       * whose storageUri is.
       */
      storageUri: string;
      /**
       * Refining instruction, composed with `task` (task = what, prompt = how).
       */
      prompt?: string;
      /**
       * Entity-type tags to stamp on the synthesized resource. Used both as a
       * prompt bias for the generation worker and as the `entityTypes` set on
       * the resulting resource.
       */
      entityTypes?: string[];
      /**
       * Annotation/resource body locale — language the generated resource is
       * written in (typically the user's UI locale). BCP-47.
       */
      language?: string;
      /**
       * Source-resource locale — language of the resource being referenced,
       * used in the prompt so the LLM understands embedded source-context
       * snippets when source ≠ target language. BCP-47.
       */
      sourceLanguage?: string;
      /** Sampling temperature forwarded to the model. */
      temperature?: number;
      /**
       * Output token budget forwarded to the model. Length never determines
       * structure.
       */
      maxTokens?: number;
      /**
       * Requested media type of the generated resource's content. Default
       * `text/markdown` at the worker, which validates it against its supported
       * output set and FAILS the job for anything it can't write — not a silent
       * fallback.
       */
      outputMediaType?: components['schemas']['SupportedMediaType'];
      /**
       * What the model is asked to produce — the prompt's framing verb.
       * Canonical values ('resource', 'answer', 'summary') map to the worker's
       * tested framings; any other string is used VERBATIM as the framing
       * instruction (loud degrade: the worker warns, never silently falls
       * back). Unset ⇒ 'resource' (article framing).
       */
      task?: string;
      /**
       * How the output is internally segmented — shape for text-bearing media,
       * subordinate to `outputMediaType` (never its peer). Canonical values:
       * 'prose' (flowing paragraphs), 'sections' (titled sections + title),
       * 'chat' (speaker-labeled turns); any other string becomes a freeform
       * "organize as: …" directive (loud degrade). Unset ⇒ NO structure
       * directive at all — the task framing and the model determine shape.
       */
      structure?: string;
      /**
       * Ask the model to cite its sources, by the ids the gathered context
       * labels its passages with. The model wraps the words a source supports
       * as `[[<id>: <claim>]]`, the ids of several sources separated by commas;
       * a bare `[[<id>]]` is replaced by the source's name. The worker checks
       * every id against the gathered context (an id it did not show is
       * dropped, with a warning), takes every token out of the stored content,
       * and mints a W3C linking annotation on the new resource over exactly the
       * words each token cites.
       */
      cite?: boolean;
    };
    GetAnnotationHistoryResponse: {
      events: components['schemas']['AttributedEvent'][];
      total: number;
      annotationId: components['schemas']['AnnotationId'];
      resourceId: components['schemas']['ResourceId'];
    };
    GetAnnotationResponse: {
      annotation: components['schemas']['Annotation'];
      resource: components['schemas']['ResourceDescriptor'] | null;
      resolvedResource: components['schemas']['ResourceDescriptor'] | null;
    };
    GetAnnotationsResponse: {
      annotations: components['schemas']['Annotation'][];
      /** Total number of annotations */
      total: number;
      /** Motivation filter applied (if any) */
      motivation?: components['schemas']['Motivation'];
    };
    GetEntityTypesResponse: {
      entityTypes: string[];
    };
    GetEventsResponse: {
      events: components['schemas']['AttributedEvent'][];
      total: number;
      resourceId: components['schemas']['ResourceId'];
    };
    GetReferencedByResponse: {
      referencedBy: components['schemas']['GetReferencedByResponseReferencedByItem'][];
    };
    GetReferencedByResponseReferencedByItem: {
      /** Reference annotation ID */
      id: components['schemas']['AnnotationId'];
      /**
       * Name of the resource containing the reference. Absent where no
       * description of that resource is held, and where its name is empty.
       */
      resourceName?: string;
      target: GetReferencedByResponseReferencedByItemTarget;
    };
    GetResourceByTokenResponse: {
      sourceResource: components['schemas']['ResourceDescriptor'];
      /** ISO 8601 timestamp when token expires */
      expiresAt: string;
    };
    GetResourceResponse: {
      resource: components['schemas']['ResourceDescriptor'];
      /**
       * All annotations for the resource (highlights, references, assessments,
       * etc.)
       */
      annotations: components['schemas']['Annotation'][];
    };
    GetTagSchemasResponse: {
      tagSchemas: components['schemas']['TagSchema'][];
    };
    /**
     * An annotation's graph presence. The node IS the annotation, so the full
     * W3C object is required — selectors and body included, which is what lets
     * a client place context annotations without a second fetch. Citations ride
     * here too: an inbound reference is its linking annotation, anchored by an
     * `annotation-of` edge to the resource it lives on and a `cites` edge to
     * the focal resource.
     */
    GraphAnnotationNode: {
      /** The AnnotationId — the same value as annotation.id */
      id: components['schemas']['AnnotationId'];
      type: 'annotation';
      /** The annotation's motivation, as a display label */
      label: string;
      /** Entity types carried by the annotation */
      entityTypes?: string[];
      annotation: components['schemas']['Annotation'];
      metadata?: { [key: string]: unknown };
    };
    /**
     * The graph database a service writes or reads, and what that kind of
     * database needs to be reached: one of the kinds `xynolog-graph` has a
     * store for, told apart by `type`. A secret is never a value here: a
     * database's password is named by the environment variable that holds it.
     */
    GraphConfig:
      | components['schemas']['Neo4jGraphConfig']
      | components['schemas']['JanusGraphConfig']
      | components['schemas']['NeptuneGraphConfig']
      | components['schemas']['MemoryGraphConfig'];
    /** A resource's presence in the gathered knowledge graph. */
    GraphResourceNode: {
      /** The resource's ResourceId */
      id: components['schemas']['ResourceId'];
      type: 'resource';
      /**
       * The resource's display name — its raw id when the resource's view was
       * missing at build time
       */
      label: string;
      /** Entity types on the resource */
      entityTypes?: string[];
      metadata?: { [key: string]: unknown };
    };
    /**
     * Liveness: the process is up and serving. It asks nothing of the Archivist
     * or the broker — a gateway that cannot reach them refuses to start, so one
     * that answers here got past both at boot.
     */
    HealthResponse: {
      status: string;
      message: string;
      version: string;
      timestamp: string;
    };
    /**
     * What a highlighting job takes: passages of the resource worth a reader's
     * attention are marked, with no text of the job's own.
     */
    HighlightingJobParams: {
      motivation: 'highlighting';
      /** What to look for, in the caller's words. Added to the prompt. */
      instructions?: string;
      /** How many annotations to aim for per 2000 words of the resource. */
      density?: number;
      /** The language of the resource being read. BCP 47. */
      sourceLanguage?: string;
    };
    /** Where somebody else's daemon listens. */
    HostPort: {
      /** A host name or address the stack's containers can reach. */
      host: string;
      /** The port it listens on. */
      port: number;
    };
    /**
     * A knowledge base reached through its gateway, over HTTP. The gateway's
     * origin is the protocol, the host in lowercase and the port; a host that
     * is not a host's name is refused before it is put into a URL
     * (specs/src/session/gateway-url-cases.json).
     */
    HttpEndpoint: {
      /** Discriminant: the endpoint is a gateway reached over HTTP. */
      kind: 'http';
      /** The gateway's host, as a person or a discovery document gave it. */
      host: string;
      /** The gateway's port. */
      port: number;
      /** What the gateway is reached over. */
      protocol: HttpEndpointProtocol;
    };
    /**
     * An HTTP response's status code, as the tables state one. No API states
     * it, so it is no component.
     */
    HttpStatus: number;
    /**
     * An account in a knowledge base's launcher-managed identity realm.
     * Passwords and tokens are never included.
     */
    IdentityUser: {
      /** The account's sign-in name, normally its email address. */
      email: string;
      /** The identity the account acts under in Xynolog. */
      identity: string;
      /**
       * Whether the identity provider currently allows this account to sign in.
       */
      enabled: boolean;
    };
    /**
     * Create one account in the launcher-managed Keycloak realm for a specific
     * local knowledge base.
     */
    IdentityUseraddParams: {
      apiVersion: components['schemas']['ApiVersion'];
      target: components['schemas']['LocalTarget'];
      /** The email address that will sign in to this knowledge base. */
      email: string;
      /**
       * The user's password. Secret: carried only in this local control
       * request, never in progress, diagnostics, or persistent state.
       */
      password?: string;
      /**
       * Generate a random password in the launcher and return it once in the
       * result.
       */
      generatePassword: boolean;
    };
    /**
     * The created account's sign-in identity. A generated password is present
     * only in this one answer and is not stored by the launcher.
     */
    IdentityUseraddResult: {
      /** The account's email address. */
      email: string;
      /** The identity the account acts under in Xynolog. */
      identity: string;
      /** Whether a new account was created. */
      created: boolean;
      /**
       * The generated password, returned once so the operator can share it with
       * the user. Absent when the operator supplied the password.
       */
      generatedPassword?: string;
    };
    /**
     * List accounts in one local knowledge base's launcher-managed Keycloak
     * realm.
     */
    IdentityUsersListParams: {
      apiVersion: components['schemas']['ApiVersion'];
      target: components['schemas']['LocalTarget'];
    };
    /**
     * Accounts in the selected knowledge base's launcher-managed identity
     * realm.
     */
    IdentityUsersListResult: {
      /** Accounts, sorted by sign-in name. */
      users: components['schemas']['IdentityUser'][];
    };
    /**
     * The container image a service runs, as a registry names it:
     * `ghcr.io/xynolog/xynolog-gateway:latest`.
     */
    Image: string;
    /**
     * The engines a machine uses for a knowledge base: the providers it
     * reaches, and the provider and model each job and each Librarian actor is
     * done with. A knowledge base's repository may carry several, one for each
     * provider, and a machine chooses one.
     */
    Inference: {
      apiVersion: components['schemas']['StackApiVersion'];
      kind: 'Inference';
      metadata: components['schemas']['Metadata'];
      /**
       * The providers, and the engine for each job and each Librarian actor.
       */
      spec: InferenceSpec;
    };
    /**
     * A provider's actual ceilings for a model, discovered from the provider
     * itself (Anthropic Models API; Ollama /api/show) — never hand-maintained
     * constants. Semantics differ by provider shape: Anthropic reports maximum
     * input tokens in contextTokens with a separate output ceiling in
     * maxOutputTokens; Ollama reports the shared input+output window and
     * mirrors it into both fields (there is no separate output ceiling), so
     * maxOutputTokens === contextTokens signals a shared window.
     */
    InferenceLimits: {
      /**
       * The context window in tokens. Anthropic: maximum input tokens (output
       * has its own ceiling). Ollama: the shared input+output window.
       */
      contextTokens: number;
      /**
       * Maximum output tokens per generation. Equal to contextTokens when the
       * provider has a single shared window.
       */
      maxOutputTokens: number;
      /**
       * Whether this engine accepts a caller-supplied sampling temperature,
       * measured against the provider (Anthropic: an active probe at discovery,
       * because some models reject the parameter outright and the Models API
       * does not say; Ollama: always true). Consumers treat only an explicit
       * false as 'hide temperature controls' — absence means no claim.
       */
      acceptsTemperature?: boolean;
    };
    /**
     * Request for the inference limits of the engines one service holds a
     * client for. Answered on job:limits-requested by the worker, and on
     * gather:limits-requested and match:limits-requested by the librarian: each
     * service that holds an inference credential reports for its own engines,
     * so no other service needs one.
     */
    InferenceLimitsRequest: Record<string, never>;
    /**
     * The inference limits one service discovered for the engines it holds a
     * client for. An engine whose discovery is currently unavailable is absent.
     */
    InferenceLimitsResult: {
      response: InferenceLimitsResultResponse;
    };
    /**
     * The issuer the launcher runs for the knowledge bases on a machine, with a
     * realm for each, and the database it keeps their realms in. It belongs to
     * no knowledge base, so its document is kept in the launcher's state home,
     * in `stack/issuer.yaml`, not in a knowledge base's repository. A knowledge
     * base trusts it by naming `shared`; one trusting somebody else's issuer
     * names it at `external`.
     */
    Issuer: {
      apiVersion: components['schemas']['StackApiVersion'];
      kind: 'Issuer';
      metadata: components['schemas']['Metadata'];
      /**
       * The issuer, where it is published, and the database it keeps its realms
       * in.
       */
      spec: IssuerSpec;
    };
    /**
     * A graph kept in a JanusGraph server, asked in Gremlin. No service has
     * been run against one.
     */
    JanusGraphConfig: {
      type: 'janusgraph';
      /** The server's host. */
      host: string;
      /** The port its Gremlin endpoint listens on. */
      port: number;
    };
    /**
     * A job as the dispatcher holds it. Its `status` decides which timestamps
     * and outcome fields it carries. It is what a claim returns (`job:claimed`,
     * always `running`) and what the queue stores, inside a JobRecord.
     */
    Job:
      | components['schemas']['JobPending']
      | components['schemas']['JobRunning']
      | components['schemas']['JobComplete']
      | components['schemas']['JobFailed']
      | components['schemas']['JobCancelled'];
    /**
     * Bus command the dispatcher emits, under its own service identity,
     * immediately after it accepts a job:claim — the correlated job:claimed
     * reply is unchanged. The Stower persists it as job:assigned. It is the one
     * fact only the dispatcher can vouch for: which holder took which job, and
     * who requested it. A later write citing `jobId` is checked against the
     * holder and its `creator` derived from the requester by reading the
     * resource's own log, with nothing outside the record.
     */
    JobAssignCommand: {
      /**
       * The dispatcher's service DID, injected by the /bus/emit gateway.
       * Clients do not set this.
       */
      _userId?: components['schemas']['UserId'];
      jobId: components['schemas']['JobId'];
      jobType: components['schemas']['JobType'];
      /**
       * The job's resource — for a generation, the source it generates from.
       * The assignment is persisted on this resource's log.
       */
      resourceId: components['schemas']['ResourceId'];
      /**
       * DID of the claimant whose claim was accepted — the `_userId` the
       * gateway stamped on the job:claim, restated by the dispatcher.
       */
      holder: components['schemas']['UserId'];
      /**
       * DID of the emitter of the job:create that produced this job — the
       * `_userId` the gateway stamped on that create, restated by the
       * dispatcher.
       */
      requester: components['schemas']['UserId'];
    };
    /**
     * Payload for job:assigned — the dispatcher's own record that it accepted a
     * claim. Emitted by the dispatcher under its service identity after a
     * successful job:claim (the correlated job:claimed reply is unchanged).
     * This is the one fact only the dispatcher can vouch for: which holder took
     * which job, and who requested it. The Stower persists it beside
     * job:started so that a write citing `jobId` can be checked against the
     * holder and its `creator` derived from the requester with no read outside
     * the event log.
     */
    JobAssignedPayload: {
      jobId: components['schemas']['JobId'];
      jobType: components['schemas']['JobType'];
      /**
       * The job's resource — for a generation, the source it generates from.
       * Job events are scoped here.
       */
      resourceId: components['schemas']['ResourceId'];
      /**
       * DID of the emitter whose claim the dispatcher accepted. The bus stamped
       * it on the job:claim as `_userId`; the dispatcher restates it here under
       * its own identity.
       */
      holder: components['schemas']['UserId'];
      /**
       * DID of the emitter of the job:create that produced this job. The
       * dispatcher restates the `_userId` the gateway stamped on that create.
       */
      requester: components['schemas']['UserId'];
    };
    /**
     * A worker's settling of a running job it holds whose work it has stopped
     * for a cancellation — the queue moves the job to cancelled/. Distinct from
     * JobCancelRequest (the client→worker REQUEST to stop): this is the worker
     * announcing it did, so the running job is never yanked to cancelled/ out
     * from under a live worker (the roach-motel race).
     */
    JobCancelCommand: {
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
      resourceId: components['schemas']['ResourceId'];
      jobId: components['schemas']['JobId'];
      jobType: components['schemas']['JobType'];
      /**
       * Annotation this job is attached to, when applicable. Lets the UI route
       * cancellation feedback to a specific annotation.
       */
      annotationId?: components['schemas']['AnnotationId'];
      /**
       * The units the worker had finished when it stopped. Recorded on the
       * cancelled job's metadata so the work already done stays visible.
       */
      completedUnits?: string[];
      /**
       * The furthest each unit begun got, keyed by unit, with what it had
       * counted there — the grain `completedUnits` cannot express. A unit named
       * in `completedUnits` is stated here too, by the cursor it ended at: a
       * later attempt skips it whole and counts it by that cursor. A cursor
       * never says a unit is finished; only `completedUnits` does. Merged
       * monotonically per unit, finished or not: a stale snapshot must never
       * move a cursor backward.
       */
      unitCursors?: { [key: string]: components['schemas']['UnitCursor'] };
    };
    /**
     * Request to cancel one job, named by its id. A pending job is cancelled
     * immediately by the dispatcher. A running job is cancelled only by the
     * worker that holds it: the worker stops its work and settles the job with
     * `job:cancel` (JobCancelCommand). The queue is never made to yank a
     * running job out from under a live worker.
     */
    JobCancelRequest: {
      jobId: components['schemas']['JobId'];
    };
    /**
     * What a cancel did, in the `response` of `job:cancel-ok`: whether the
     * queue acted on the job it named. A pending job is cancelled outright; a
     * running one is left to its worker, so for it true means accepted, not
     * stopped.
     */
    JobCancelResult: {
      /**
       * True when the queue acted on the job; false when the job is unknown or
       * already over.
       */
      cancelled: boolean;
    };
    /** A job cancelled before it concluded. */
    JobCancelled: {
      status: 'cancelled';
      metadata: components['schemas']['JobMetadata'];
      params: components['schemas']['JobParams'];
      /**
       * When its claim was made; absent when it was cancelled while pending.
       */
      startedAt?: string;
      /** When it was cancelled. */
      completedAt: string;
    };
    /**
     * Command to persist a running job's completed-unit checkpoint AT unit
     * completion. Distinct from JobFailCommand's checkpoint, which lands only
     * on a clean failure: a worker that dies (crash/OOM/kill) never emits
     * job:fail, so this durable, unthrottled write is what lets the janitor's
     * stale-running recovery resume a dead worker's job rather than redo its
     * finished units.
     */
    JobCheckpointCommand: {
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
      jobId: components['schemas']['JobId'];
      /**
       * Entity-type units whose annotations have been fully emitted so far.
       * Unioned into the running job's metadata checkpoint; a retry after
       * recovery skips them.
       */
      completedUnits: string[];
      /**
       * The furthest each unit begun got, keyed by unit, with what it had
       * counted there — the grain `completedUnits` cannot express. A unit named
       * in `completedUnits` is stated here too, by the cursor it ended at: a
       * later attempt skips it whole and counts it by that cursor. A cursor
       * never says a unit is finished; only `completedUnits` does. Merged
       * monotonically per unit, finished or not: a stale snapshot must never
       * move a cursor backward.
       */
      unitCursors?: { [key: string]: components['schemas']['UnitCursor'] };
    };
    /**
     * Claim the NEXT pending job that matches one of `accepts` (atomic: pending
     * → running). A job:queued announcement is a WAKE-UP, not a reservation:
     * the claimed job may differ from the announced one, and two claims after
     * one announcement both succeed on different jobs instead of racing for
     * one. job:claimed carries the claimed job; job:claim-failed reports that
     * nothing matching is pending.
     */
    JobClaimCommand: {
      /**
       * The jobs this claim takes. A job is handed over when it matches any one
       * of them.
       */
      accepts: components['schemas']['JobFilter'][];
      /**
       * Authenticated claimant's DID, injected by the /bus/emit gateway.
       * Clients do not set this. The dispatcher records it as the holder on
       * job:assigned.
       */
      _userId?: components['schemas']['UserId'];
      /**
       * The claimant's capabilities (the token's `roles`), injected by the
       * /bus/emit gateway. Clients do not set this. The dispatcher authorizes
       * the claim by capability — it admits the claim only when this carries
       * the worker role — so a claimant that is not a worker for this knowledge
       * base is refused before the queue is consulted.
       */
      _roles?: string[];
    };
    /**
     * The reply to a successful `job:claim`: the claimed job, now running under
     * the claimant.
     */
    JobClaimedResult: {
      response: components['schemas']['JobRunning'];
    };
    /** A job its worker completed. */
    JobComplete: {
      status: 'complete';
      metadata: components['schemas']['JobMetadata'];
      params: components['schemas']['JobParams'];
      /** When the claim that completed it was made. */
      startedAt: string;
      /** When it completed. */
      completedAt: string;
      result: components['schemas']['JobStoredResult'];
    };
    /**
     * A job's worker says the job is complete. The result it carries is its
     * verb's: a `mark` job's counts or the resource a `yield` job made, or a
     * decline from either. A completion whose result is the other verb's is
     * refused where the command is admitted.
     */
    JobCompleteCommand:
      | components['schemas']['MarkJobCompleteCommand']
      | components['schemas']['YieldJobCompleteCommand'];
    /** Payload for job:completed domain event */
    JobCompletedPayload: {
      jobId: components['schemas']['JobId'];
      jobType: components['schemas']['JobType'];
      /**
       * Which attempt produced this event, 1-based (a first run is 1). ALWAYS
       * present: the queue re-runs a failed job silently, so an operator
       * reading progress or a terminal record has no other way to tell a re-run
       * from a first run — and provider spend, already counted in
       * xynolog_inference_tokens_total, cannot be attributed to a repeated
       * document without it. Stated rather than inferred from absence, because
       * 'attempt 1' is a fact the emitter always knows.
       */
      attempt?: number;
      /** Annotation this job was attached to, when applicable */
      annotationId?: components['schemas']['AnnotationId'];
      totalSteps?: number;
      /** For detection: total entities found */
      foundCount?: number;
      /** For generation: ID of generated resource */
      resultResourceId?: components['schemas']['ResourceId'];
      /** For generation: URI of annotation that triggered generation */
      annotationUri?: string;
      /** Full result object for extensibility */
      result?: { [key: string]: unknown };
      durability?: components['schemas']['DurabilityEvidence'];
    };
    /**
     * Create a job. A job description is its `jobType` and enough parameters to
     * be well formed: a `mark` job names its resource and, in its parameters,
     * its motivation; a `yield` job names its context.
     */
    JobCreateCommand:
      | components['schemas']['MarkJobCreateCommand']
      | components['schemas']['YieldJobCreateCommand'];
    /** Result of a job:create command */
    JobCreatedResult: {
      response: components['schemas']['JobCreatedResultResponse'];
    };
    JobCreatedResultResponse: {
      jobId: components['schemas']['JobId'];
    };
    /**
     * Result of a job that completed without doing its work because the
     * resource could not be read. Distinct from a failure: nothing went wrong,
     * there was simply no text to work with — an encrypted or damaged PDF, a
     * scan whose text could not be recognized, or a document that yielded
     * nothing. The reasons are the extraction vocabulary the Smelter reports on
     * `smelt:settled`, MINUS `no-extractor`: a media type that can never yield
     * text (a zip, an image) is a bad request rather than a decline, so a
     * worker asked to detect over one throws and the job reports `job:fail`.
     * Everything here is a resource-specific outcome — the same media type
     * would have succeeded on a different document.
     */
    JobDeclined: {
      /**
       * Always true. It is what tells a decline from the result of a job that
       * did its work, which never carries it.
       */
      declined: true;
      /**
       * Why the resource could not be read. A CODE, not a sentence: the client
       * owns the wording, so a browser renders it in the user's language and
       * the CLI renders English terminal copy from the same value. A prose
       * `message` composed server-side would be English everywhere.
       */
      reason: JobDeclinedReason;
    };
    /** Command to mark a job as failed */
    JobFailCommand: {
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
      resourceId: components['schemas']['ResourceId'];
      jobId: components['schemas']['JobId'];
      jobType: components['schemas']['JobType'];
      /**
       * Which attempt produced this event, 1-based (a first run is 1). ALWAYS
       * present: the queue re-runs a failed job silently, so an operator
       * reading progress or a terminal record has no other way to tell a re-run
       * from a first run — and provider spend, already counted in
       * xynolog_inference_tokens_total, cannot be attributed to a repeated
       * document without it. Stated rather than inferred from absence, because
       * 'attempt 1' is a fact the emitter always knows.
       */
      attempt?: number;
      /**
       * Annotation this job is attached to, when applicable. Lets the UI route
       * failure feedback (error toast, revert state) to a specific annotation.
       */
      annotationId?: components['schemas']['AnnotationId'];
      error: string;
      /**
       * Entity-type units whose annotations were fully emitted before this
       * failure (checkpointed resume). The queue records them on the retried
       * job's metadata; a retried claim skips them so completed work is neither
       * redone nor duplicated.
       */
      completedUnits?: string[];
      /**
       * The furthest each unit begun got, keyed by unit, with what it had
       * counted there — the grain `completedUnits` cannot express. A unit named
       * in `completedUnits` is stated here too, by the cursor it ended at: a
       * later attempt skips it whole and counts it by that cursor. A cursor
       * never says a unit is finished; only `completedUnits` does. Merged
       * monotonically per unit, finished or not: a stale snapshot must never
       * move a cursor backward.
       */
      unitCursors?: { [key: string]: components['schemas']['UnitCursor'] };
      failureClass?: components['schemas']['FailureClass'];
      /**
       * Whether the queue will re-queue this job for another attempt. Computed
       * by the worker from the SAME rule the queue applies when it takes the
       * failure (specs/src/jobs/retry-cases.json, which every SDK and the
       * dispatcher run) using the retry budget carried on the claimed record.
       * FALSE (or absent) means this failure is TERMINAL: a client's job-watch
       * stream ends here. TRUE means the work continues on a fresh attempt —
       * the failure is an event, not the end, and a stream that terminated on
       * it would report a recovering run as a failed one.
       */
      willRetry?: boolean;
      durability?: components['schemas']['DurabilityEvidence'];
    };
    /** A job that failed and will not be retried. */
    JobFailed: {
      status: 'failed';
      metadata: components['schemas']['JobMetadata'];
      params: components['schemas']['JobParams'];
      /** When the last claim was made; absent when it failed without one. */
      startedAt?: string;
      /** When it failed. */
      completedAt: string;
      /** The failure's message. */
      error: string;
      failureClass?: components['schemas']['FailureClass'];
    };
    /**
     * Payload for the job:failed domain event — a permanent fact of the
     * resource, not operational state. It carries the judgments the worker
     * COMPUTED, not just its message: at the log they are otherwise
     * unrecoverable, the only remaining witness being a flattened English
     * string.
     */
    JobFailedPayload: {
      jobId: components['schemas']['JobId'];
      jobType: components['schemas']['JobType'];
      /**
       * Which attempt produced this event, 1-based (a first run is 1). ALWAYS
       * present: the queue re-runs a failed job silently, so an operator
       * reading progress or a terminal record has no other way to tell a re-run
       * from a first run — and provider spend, already counted in
       * xynolog_inference_tokens_total, cannot be attributed to a repeated
       * document without it. Stated rather than inferred from absence, because
       * 'attempt 1' is a fact the emitter always knows.
       */
      attempt?: number;
      /** Annotation this job was attached to, when applicable */
      annotationId?: components['schemas']['AnnotationId'];
      error: string;
      failureClass?: components['schemas']['FailureClass'];
      /**
       * Whether the worker computed that the queue would re-queue this job
       * (same predicate the queue applies, `willRetryAfter`). Absent means the
       * worker stated nothing. Without it a reader of the log cannot tell a run
       * recovering across several job:failed events from that many dead jobs.
       */
      willRetry?: boolean;
      durability?: components['schemas']['DurabilityEvidence'];
    };
    /**
     * Some jobs, named by fields of the job description: a partial description,
     * at the description's own paths. A job matches when every field stated
     * here equals the job's. A `mark` filter always states its motivation.
     */
    JobFilter:
      | components['schemas']['MarkJobFilter']
      | components['schemas']['YieldJobFilter'];
    /**
     * A job's id. 1 to 128 of the letters `A`–`Z` and `a`–`z`, the digits, `_`
     * and `-`. It is one segment of a URL and one name in a file system, and it
     * is held to that wherever it enters: a gateway refuses a payload that
     * carries anything else. How one is made is no part of the rule.
     */
    JobId: string & { readonly __brand: 'JobId' };
    /**
     * What the dispatcher records about a job beside its parameters.
     * `completedUnits` and `unitCursors` appear once a worker has checkpointed.
     * `retryCount` counts the times the queue has put the job back to pending
     * after a failure it classes as transient.
     */
    JobMetadata: {
      /**
       * The job's id: `job-` followed by a version 4 UUID written as 32
       * lowercase hex digits, without dashes.
       */
      id: components['schemas']['JobId'];
      type: components['schemas']['JobType'];
      /** The DID of the principal whose `job:create` created the job. */
      userId: components['schemas']['UserId'];
      /** When the job was created, as an ISO 8601 timestamp. */
      created: string;
      retryCount: number;
      /**
       * How many transient failures the queue retries: 0 for generation, whose
       * re-run produces different content; 1 for every other type.
       */
      maxRetries: number;
      /**
       * The units a worker has finished, merged across checkpoints and failures
       * as a set.
       */
      completedUnits?: string[];
      /**
       * The furthest each unit begun got, keyed by unit, with what it had
       * counted there. A finished unit keeps its cursor: where it ended, and
       * its final counts.
       */
      unitCursors?: { [key: string]: components['schemas']['UnitCursor'] };
    };
    /**
     * A job's parameters as the Dispatcher holds them: the `params` of its
     * `job:create`, and what the Dispatcher adds. It adds `resourceId`, the
     * resource the job is about: a `mark` job's own, and for a `yield` job the
     * one its context focuses on. For a tagging job it adds `schema`, the tag
     * schema its `schemaId` names, so that whoever holds the job needs no
     * registry. Nothing the caller sent is changed or removed.
     */
    JobParams: {
      resourceId: components['schemas']['ResourceId'];
      /**
       * The tag schema a tagging job's `schemaId` names, as the knowledge base
       * registered it when the job was created. On a tagging job, and on no
       * other.
       */
      schema?: components['schemas']['TagSchema'];
    } & { [key: string]: unknown };
    /** A job waiting for a worker to claim it. */
    JobPending: {
      status: 'pending';
      metadata: components['schemas']['JobMetadata'];
      params: components['schemas']['JobParams'];
    };
    /**
     * Progress report from a running job. The required field is `percentage`;
     * `message` carries the coded phase and the rest are optional job-shape
     * fields. This is the single progress shape for every job type — annotation
     * workers and generation alike. Terminality is signalled on `job:complete`
     * / `job:fail`, not here. A flow that iterates a user-chosen list (entity
     * types for references, categories for tags) reports its position as one
     * `current`/`processed`/`total` triple, the same shape for both, so a
     * client never needs to know which flow it is drawing.
     */
    JobProgress: {
      /** Completion percentage (0-100) */
      percentage: number;
      /**
       * What the job is doing right now, as a code plus typed params; the
       * client renders the sentence. Optional: pure percentage heartbeats carry
       * none, and consumers render nothing message-shaped when it is absent.
       */
      message?: components['schemas']['JobProgressMessage'];
      /**
       * Annotation this job is attached to, when applicable. Echoed inside
       * JobProgress (in addition to the outer command envelope) so consumers
       * that only see the inner progress object (e.g. what `yield.delegate`
       * returns) can still route visual feedback to a specific annotation.
       */
      annotationId?: components['schemas']['AnnotationId'];
      /**
       * What the run is working on right now. `kind` is a CODE the client
       * renders a localized name for; `value` is KB data (an entity type, a tag
       * category) shown verbatim — the same split as `requestParams`. Absent on
       * flows that iterate nothing, such as generation.
       */
      current?: JobProgressCurrent;
      /**
       * Items completed so far, zero-based — the item in `current` is the one
       * after these. Paired with `total`.
       */
      processed?: number;
      /** Items this run will process in all. */
      total?: number;
      /** Entities found so far (a linking job) */
      entitiesFound?: number;
      /**
       * Cumulative mentions the count-verifier priced across the pieces
       * accepted so far — the denominator for a real progress bar (found of
       * ~expected). Approximate by nature (the count saturates on very large
       * pieces) and monotonically growing within a run. ABSENT when the
       * provider does not verify detection yield, or before any piece has been
       * priced: no claim, never zero.
       */
      entitiesExpected?: number;
      /** Annotations emitted so far (a linking job) */
      entitiesEmitted?: number;
      /**
       * Per-item results for the items already finished, for the UI's completed
       * log. Generic across flows for the same reason `current` is.
       */
      completedItems?: JobProgressCompletedItemsItem[];
      /**
       * Echoed job parameters for display in the progress UI. `label` is a
       * CODE, not a sentence — the client owns the wording, same rule as the
       * progress message. `value` is the user's own input (an entity-type list,
       * their instructions) and is deliberately NOT translated: it is their
       * words, not ours.
       */
      requestParams?: JobProgressRequestParamsItem[];
    };
    /** Analyzing the content. */
    JobProgressAnalyzing: {
      code: 'analyzing';
    };
    /** Analyzing the content against the tag schema. */
    JobProgressAnalyzingTags: {
      code: 'analyzing-tags';
    };
    /** Terminal success summary. */
    JobProgressCompleteCreated: {
      code: 'complete-created';
      /** How many annotations were created */
      count: number;
      /**
       * The motivation of the job, and so of what it created. A client words it
       * in its own language.
       */
      motivation: components['schemas']['Motivation'];
    };
    /**
     * Generation's terminal success. Deliberately generic — the client already
     * holds the title it typed, and the outcome (name + resource link) travels
     * on job:complete, not on progress. `truncated` qualifies the completion:
     * the same bit `YieldJobDone.truncated` carries, so the two surfaces cannot
     * drift.
     */
    JobProgressCompleteGenerated: {
      code: 'complete-generated';
      /**
       * True when the model stopped at the maxTokens ceiling — the artifact is
       * cut off, not complete.
       */
      truncated: boolean;
    };
    /** Writing detected annotations back to the resource. */
    JobProgressCreatingAnnotations: {
      code: 'creating-annotations';
      /** How many annotations are being created */
      count: number;
    };
    /** Writing the generated resource. */
    JobProgressCreatingResource: {
      code: 'creating-resource';
    };
    /** Writing detected tag annotations back to the resource. */
    JobProgressCreatingTagAnnotations: {
      code: 'creating-tag-annotations';
      /** How many annotations are being created */
      count: number;
    };
    /** Entity detection, one entity type at a time. */
    JobProgressDetectingEntities: {
      code: 'detecting-entities';
      /** Entity type currently being detected */
      entityType: string;
    };
    /** The model is generating the resource. */
    JobProgressGeneratingResource: {
      code: 'generating-resource';
    };
    /** Loading the resource content. */
    JobProgressLoading: {
      code: 'loading';
    };
    /**
     * What a running job is doing right now, as a code plus typed params —
     * never a prose sentence. The producer reports what happened; each client
     * renders it in the user's language (react-ui from its translations, the Go
     * launcher from its English map). One named schema per code, discriminated
     * on `code`, so generated clients get typed variants and copy-map
     * completeness is statically checkable. The vocabulary is every report
     * Xynolog's worker makes (contract/WORKER-SERVICE.md, D16 to D19 and Y8);
     * extending it means adding a named variant here and copy in every client,
     * gated by the locale-completeness check.
     */
    JobProgressMessage:
      | components['schemas']['JobProgressLoading']
      | components['schemas']['JobProgressAnalyzing']
      | components['schemas']['JobProgressAnalyzingTags']
      | components['schemas']['JobProgressGeneratingResource']
      | components['schemas']['JobProgressCreatingResource']
      | components['schemas']['JobProgressCompleteGenerated']
      | components['schemas']['JobProgressDetectingEntities']
      | components['schemas']['JobProgressCreatingAnnotations']
      | components['schemas']['JobProgressCreatingTagAnnotations']
      | components['schemas']['JobProgressCompleteCreated'];
    /**
     * A pending job, announced when it is created and again at each tick while
     * it waits. It carries the job description less the job's input, so that a
     * party deciding whether to claim reads here what its claim would be
     * matched against. It is a wake-up and not an offer of this job: a claim is
     * answered with the next pending job it matches.
     */
    JobQueuedEvent:
      | components['schemas']['MarkJobQueuedEvent']
      | components['schemas']['YieldJobQueuedEvent'];
    /**
     * One job as the queue stores it: the job, and when it last showed life.
     * The dead-worker sweep reads `lastProgressAt`: a running job whose worker
     * has reported nothing for the configured interval is presumed dead. Where
     * the queue keeps these records is the job storage layout,
     * specs/src/jobs/storage.json.
     */
    JobRecord: {
      job: components['schemas']['Job'];
      /**
       * When the job was created, claimed, checkpointed or last reported
       * progress, as an ISO 8601 timestamp.
       */
      lastProgressAt: string;
    };
    /** Command to report progress on a job */
    JobReportProgressCommand: {
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
      resourceId: components['schemas']['ResourceId'];
      jobId: components['schemas']['JobId'];
      jobType: components['schemas']['JobType'];
      /**
       * Which attempt produced this event, 1-based (a first run is 1). ALWAYS
       * present: the queue re-runs a failed job silently, so an operator
       * reading progress or a terminal record has no other way to tell a re-run
       * from a first run — and provider spend, already counted in
       * xynolog_inference_tokens_total, cannot be attributed to a repeated
       * document without it. Stated rather than inferred from absence, because
       * 'attempt 1' is a fact the emitter always knows.
       */
      attempt?: number;
      /**
       * Annotation this job is attached to, when applicable. Lets the UI attach
       * progress visuals to a specific annotation (e.g. a reference whose
       * generation is running).
       */
      annotationId?: components['schemas']['AnnotationId'];
      percentage: number;
      progress?: components['schemas']['JobProgress'];
    };
    /**
     * What a job reports when it concludes without failing: a `mark` job's
     * counts, the resource a `yield` job made, or a decline from either. A
     * result has no discriminant of its own: the job description beside it says
     * which job it answers, and the three share no member, so each is told from
     * the others by what it alone carries.
     */
    JobResult:
      | components['schemas']['MarkJobDone']
      | components['schemas']['YieldJobDone']
      | components['schemas']['JobDeclined'];
    /** A job a worker has claimed and not yet concluded. */
    JobRunning: {
      status: 'running';
      metadata: components['schemas']['JobMetadata'];
      params: components['schemas']['JobParams'];
      /** When the claim that holds it was made, as an ISO 8601 timestamp. */
      startedAt: string;
      progress: components['schemas']['JobStoredProgress'];
    };
    /** Command to start a job */
    JobStartCommand: {
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
      resourceId: components['schemas']['ResourceId'];
      jobId: components['schemas']['JobId'];
      jobType: components['schemas']['JobType'];
      /**
       * Annotation this job is attached to, when applicable. Set for
       * annotation-scoped jobs like generation (from a specific reference).
       * Unset for resource-scoped jobs like bulk reference/tag/highlight
       * detection.
       */
      annotationId?: components['schemas']['AnnotationId'];
      /**
       * Which attempt produced this event, 1-based (a first run is 1). ALWAYS
       * present: the queue re-runs a failed job silently, so an operator
       * reading progress or a terminal record has no other way to tell a re-run
       * from a first run — and provider spend, already counted in
       * xynolog_inference_tokens_total, cannot be attributed to a repeated
       * document without it. Stated rather than inferred from absence, because
       * 'attempt 1' is a fact the emitter always knows.
       */
      attempt?: number;
    };
    /** Payload for job:started domain event */
    JobStartedPayload: {
      jobId: components['schemas']['JobId'];
      jobType: components['schemas']['JobType'];
      /** Annotation this job is attached to, when applicable */
      annotationId?: components['schemas']['AnnotationId'];
      totalSteps?: number;
    };
    /** Request to check the status of a job */
    JobStatusRequest: {
      jobId: components['schemas']['JobId'];
    };
    JobStatusResponse: {
      jobId: components['schemas']['JobId'];
      type: components['schemas']['JobType'];
      status: JobStatusResponseStatus;
      userId: components['schemas']['UserId'];
      created: string;
      startedAt?: string;
      completedAt?: string;
      error?: string;
      failureClass?: components['schemas']['FailureClass'];
      progress?: components['schemas']['JobStoredProgress'];
      result?: components['schemas']['JobStoredResult'];
    };
    /** Result of a job status request */
    JobStatusResult: {
      response: components['schemas']['JobStatusResponse'];
    };
    /**
     * A running job's progress as the dispatcher stores it: the last
     * JobProgress its worker reported with `job:report-progress`, or an empty
     * object before the first report.
     */
    JobStoredProgress:
      components['schemas']['JobProgress'] | Record<string, never>;
    /**
     * A completed job's result as the dispatcher stores it: the result its
     * worker reported with `job:complete`, or an empty object when it reported
     * none.
     */
    JobStoredResult: components['schemas']['JobResult'] | Record<string, never>;
    /**
     * What a job does, as the verb that asks for it: `mark` annotates a
     * resource, `yield` makes one. A job description is its `jobType` and the
     * parameters that verb takes; a `mark` job's parameters state its
     * motivation.
     */
    JobType: 'mark' | 'yield';
    /**
     * What a knowledge base says about itself, answered by the Archivist from
     * the committed .xynolog/config.yaml and the working tree it holds. The
     * only source clients use for a knowledge base's name and domain.
     */
    KbDescription: {
      /**
       * The committed project.name, or the knowledge base directory's name when
       * it commits no .xynolog/config.yaml.
       */
      name: string;
      /**
       * The committed site.domain: the knowledge base's permanent identity. Its
       * did is 'did:web:' + this domain (kbDid in @xynolog/core). It names
       * WHICH knowledge base this is, not which running copy: a local clone and
       * a codespace of one repo report the same domain, so use it to verify
       * what you connected to, never to select among copies. A knowledge base
       * that commits no .xynolog/config.yaml declares none, and is refused with
       * browse:kb-failed.
       */
      domain: string;
      /**
       * The working tree's current git branch. Absent when the knowledge base
       * does not sync git (`git.sync` in its committed .xynolog/config.yaml),
       * and when its tree is not a git checkout.
       */
      gitBranch?: string;
    };
    /**
     * A knowledge base's DID: `did:web:` and its domain. No API states one as
     * such, so it is no component.
     */
    KbDid: string;
    /**
     * How a knowledge base is reached: a gateway over HTTP, or a knowledge base
     * the host process has loaded. Told apart by `kind`. Only what builds a
     * transport, or signs in at an issuer, reads it.
     */
    KbEndpoint:
      | components['schemas']['HttpEndpoint']
      | components['schemas']['LocalEndpoint'];
    /**
     * A knowledge base's committed identity (`project.name` and `site.domain`
     * in its .xynolog/config.yaml), as a service's document names the knowledge
     * base it serves. Its telemetry names it by its DID (`xynolog.kb`,
     * specs/src/service-telemetry/telemetry.json).
     */
    KbIdentity: {
      /**
       * Its name. The gateway publishes it as its resource metadata's
       * `resource_name`.
       */
      name: string;
      /**
       * Its did:web domain: its permanent identity, the source of the audience
       * its tokens must carry, and the authority its people and agents are
       * named under.
       */
      domain: string;
    };
    /**
     * When a knowledge base last described itself, and what it said beyond its
     * name. A client shows it as current only while a session to the knowledge
     * base is live, and as of `at` otherwise.
     */
    KbRead: {
      /** When the description arrived. */
      at: string;
      /**
       * The branch of the knowledge base's working tree then. Absent when the
       * working tree was not a git checkout.
       */
      gitBranch?: string;
    };
    /**
     * Where to connect to a knowledge base: an endpoint, and the labels a
     * client keeps of it. It carries no identity: which knowledge base answers
     * at an address is known only once it has been reached with a token and
     * asked, so a target is what every caller can build before then, and a
     * session's whole input. A client keeps it locally; it is never sent.
     */
    KbTarget: {
      /**
       * The key the client stores a session's credentials under. Two sessions
       * that share one storage have two ids, or each overwrites the other's
       * tokens. Whoever builds the target chooses it; none is made up.
       */
      id: string;
      /**
       * What a person reads the knowledge base as. Once the knowledge base has
       * described itself, its own name.
       */
      label: string;
      endpoint: components['schemas']['KbEndpoint'];
    };
    /**
     * A registered knowledge base: a target, and what registering it took, the
     * identity the knowledge base reported of itself when it was reached
     * (`did`) among it. What a client's list of knowledge bases holds. A did
     * says which knowledge base, not which running copy: a clone and a
     * codespace of one repository are one knowledge base at two addresses and
     * report one did. So an entry is looked up by its endpoint, and its did is
     * what an answer is verified against; nothing selects by did. Its `label`
     * and `lastRead` are written only from an answer that carried its did.
     */
    KnowledgeBase: components['schemas']['KbTarget'] &
      components['schemas']['NewKnowledgeBase'];
    /**
     * One knowledge base's stack as xynolog status reads it: what it is, where
     * it runs, and each of its own services. The services every knowledge base
     * shares are reported once, in the snapshot's shared list.
     */
    KnowledgeBaseStatus: {
      /**
       * What the snapshot calls the knowledge base: the last segment of its
       * DID, or the whole DID where two would share one, or its key.
       */
      name: string;
      /**
       * The knowledge base's key on this machine, which names its containers
       * and its state.
       */
      key: string;
      /**
       * Whether a stack of it is recorded. When none is, its services are found
       * by name.
       */
      recorded: boolean;
      /**
       * Where the stack actually runs. "local": containers on this machine.
       * "codespace": a GitHub-hosted VM whose KB is port-forwarded here.
       */
      placement: KnowledgeBaseStatusPlacement;
      /** Its clone, for a local stack. */
      root?: string;
      /**
       * owner/name GitHub slug — present for codespace placements, where the
       * repo is the stack's identity
       */
      repo?: string;
      /**
       * The KB's did:web identifier, from its committed .xynolog/config.yaml —
       * "did:web:" + its site.domain, verbatim. REQUIRED: a KB that declares no
       * domain has no identity to publish, and the launcher refuses to start it
       * rather than inventing or defaulting one. NOT unique within a document:
       * a did names the knowledge base, not a running copy of it, so a local
       * clone and a codespace of the same repo legitimately share one and both
       * are published. host:port is the unique field (at most one entry per
       * address), so consumers look up by ADDRESS and use the did to VERIFY
       * that the copy they reached is the KB they meant — an address alone
       * cannot say which KB is which, and an identity alone cannot say which
       * copy.
       */
      did?: string;
      /**
       * Human-readable site name from the KB's .xynolog/config.yaml
       * (site.siteName), for display
       */
      siteName?: string;
      /**
       * Why its identity could not be read from its clone, when it could not.
       */
      identityError?: string;
      /**
       * The knowledge base as the discovery document publishes it, when it
       * does.
       */
      kb?: components['schemas']['DiscoveredKB'];
      /** The runtime its record names. */
      runtime?: components['schemas']['Runtime'];
      /** The base URL of its gateway, from its record. */
      gateway?: string;
      /**
       * Where the values the launcher generates for it are kept, as xynolog
       * settings secret-store describes it.
       */
      secretStore?: string;
      /**
       * This machine's address on the network, when the stack is started with
       * network lan.
       */
      lan?: string;
      /**
       * Whether a xynolog start of it holds its start lock: its services are
       * not ready, whatever they report.
       */
      starting: boolean;
      session?: components['schemas']['Session'];
      /**
       * Whether each of its counted services, and the issuer it signs in at,
       * answers.
       */
      healthy: boolean;
      /**
       * Its own services, group by group, then the issuer it signs in at. Empty
       * for a codespace's, whose services its own launcher reports.
       */
      services: components['schemas']['ServiceStatus'][];
      /**
       * The ledger and job queue readings the launcher can attribute to this
       * knowledge base. A missing reading means the Collector has not reported
       * that metric, not that its value is zero.
       */
      workload?: components['schemas']['WorkloadStatus'];
    };
    /**
     * Knowledge graph gathered for an LLM context — a shared backbone in which
     * resources AND annotations are typed nodes, connected by typed (optionally
     * bidirectional) edges. Flattened views the matcher/generation read
     * (connections, citedBy, siblings) are derived from these nodes/edges.
     */
    KnowledgeGraph: {
      nodes: KnowledgeGraphNodesItem[];
      edges: KnowledgeGraphEdgesItem[];
      /**
       * Whether the graph stopped taking resources at its ceiling of 200
       * resource nodes, so that a resource within the depth asked for is not in
       * it. Present, and true, only then
       */
      truncated?: boolean;
    };
    /**
     * What a knowledge base's record is indexed into, and the services that
     * keep and read the indexes: the Weaver's graph, the Smelter's vectors and
     * anchored text, and the Librarian that answers from them. Each can be
     * rebuilt from the record.
     */
    KnowledgeIndex: {
      apiVersion: components['schemas']['StackApiVersion'];
      kind: 'KnowledgeIndex';
      metadata: components['schemas']['Metadata'];
      /**
       * The indexes, the services that keep and read them, and the knowledge
       * base they index.
       */
      spec: KnowledgeIndexSpec;
    };
    /**
     * Everything a Librarian reads at boot: nothing in it is defaulted by the
     * Librarian. Whoever starts a Librarian writes it, from the knowledge
     * base's stack documents, and the Librarian reads it from the path its
     * `--config` flag names. This schema is the contract, and a Librarian needs
     * no launcher. Started without `--config`, or with a path that names no
     * file, the Librarian refuses to start and says which. No secret is a value
     * here: the graph database's password, an embedding provider's key and a
     * model provider's key are each named by the environment variable that
     * holds it, and the Librarian's own service account is
     * `XYNOLOG_OIDC_CLIENT_ID` and `XYNOLOG_OIDC_CLIENT_SECRET` in its
     * environment. A document that does not validate is refused at boot, naming
     * each failing field.
     */
    LibrarianConfig: {
      kb: components['schemas']['KbIdentity'];
      /** The URL the Librarian reaches the gateway at: its route to the bus. */
      gatewayUrl: string;
      /** The issuer the Librarian's service account signs in at. */
      identity: components['schemas']['ServiceIdentity'];
      /**
       * Where the Archivist listens. The Librarian reads a resource's bytes
       * from it, as its service account.
       */
      archivist: components['schemas']['ServiceAddress'];
      graph: components['schemas']['GraphConfig'];
      vectors: components['schemas']['VectorsConfig'];
      embedding: components['schemas']['EmbeddingConfig'];
      matcher: components['schemas']['LibrarianEngineConfig'];
      gatherer: components['schemas']['LibrarianEngineConfig'];
      /**
       * The path of a model catalogue file: what each model of a provider can
       * take, for the providers whose own APIs do not say (`google`, `openai`,
       * `together`). A Librarian whose matcher or gatherer is of one of those
       * providers refuses to start where the file cannot be read, and where it
       * states nothing of that model. A Librarian with no such model does not
       * read it.
       */
      modelCatalogue: string;
      /** The bound on a gather. */
      gather: LibrarianConfigGather;
      /** The bound on a search by meaning. */
      search: LibrarianConfigSearch;
      /** The port the Librarian answers `/health` on. */
      port: number;
      logLevel: components['schemas']['LogLevel'];
      logFormat: components['schemas']['LogFormat'];
    };
    /**
     * The engine a Librarian actor asks: which it is, and where its provider is
     * reached.
     */
    LibrarianEngineConfig: {
      engine: components['schemas']['Engine'];
      /** The address the provider's API is reached at. */
      baseUrl: string;
      /**
       * The environment variable holding the provider's API key, when the
       * provider requires one.
       */
      apiKeyEnv?: string;
    };
    /**
     * The Librarian's health answer (LIBRARIAN.md § Health). Its port opens
     * last, after it has begun to take requests from the bus, so a Librarian
     * whose health answers is answering.
     */
    LibrarianHealth: {
      status: 'ok';
      /**
       * The DID of the knowledge base it serves: the one its document names,
       * which that knowledge base said it is before the Librarian reached its
       * stores.
       */
      kb: components['schemas']['KbDid'];
      /** The two actors it runs, `matcher` and `gatherer`. */
      actors: LibrarianHealthActorsItem[];
    };
    LibrarianPromptScore: {
      candidate: number;
      score: number;
    };
    /** An ErrorResponse that names, in `code`, the limit the request met. */
    LimitRefusal: components['schemas']['ErrorResponse'] & LimitRefusalValue;
    /**
     * What a linking job takes: mentions of the named entity types are marked
     * as references, each unresolved until it is bound to a resource.
     */
    LinkingJobParams: {
      motivation: 'linking';
      /**
       * The entity types to find mentions of. Each is one the knowledge base
       * registers.
       */
      entityTypes: string[];
      /**
       * Whether a description that stands for an entity ("the wily hero")
       * counts as a mention of it, beside its name.
       */
      includeDescriptiveReferences?: boolean;
      /** The language the annotations' own text is written in. BCP 47. */
      language?: string;
      /** The language of the resource being read. BCP 47. */
      sourceLanguage?: string;
    };
    ListResourcesResponse: {
      resources: components['schemas']['ResourceDescriptor'][];
      total: number;
      offset: number;
      limit: number;
    };
    /**
     * A knowledge base the host process has loaded and reaches through a
     * transport with no wire.
     */
    LocalEndpoint: {
      /** Discriminant: the endpoint is in the host process. */
      kind: 'local';
      /**
       * Which loaded knowledge base, named by an id that means something to the
       * host process alone.
       */
      kbId: string;
    };
    /**
     * A local knowledge base, named explicitly: the operations that act on one
     * local stack and never resolve one for the caller (identity
     * administration, a service's run).
     */
    LocalTarget: {
      /** Only a local stack. */
      kind: 'local';
      /** The knowledge base's clone, by its path. */
      root: string;
    };
    /**
     * How each log line is written to stdout
     * (service-telemetry/log-lines.json): `json`, one JSON object per line; or
     * `simple`, a line of words followed by any metadata as JSON.
     */
    LogFormat: 'json' | 'simple';
    /**
     * How much a service logs: the least severe level it writes, from error,
     * the most severe, to debug.
     */
    LogLevel: 'error' | 'warn' | 'info' | 'http' | 'debug';
    /**
     * One line one of a stack's services wrote. The launcher removes from it
     * each secret value the launcher generated or read; anything else the
     * service wrote is the client's to handle. The launcher keeps no copy.
     */
    LogRecord: {
      requestId: components['schemas']['RequestId'];
      /**
       * The role whose container wrote the line, as xynolog status names it.
       */
      service: string;
      /** Which of the container's streams the line was on. */
      stream: components['schemas']['OutputStream'];
      /** The line, without its newline. */
      line: string;
      /**
       * When the launcher read the line, in RFC 3339 with its fraction: a
       * container's own lines carry the time it wrote them, if any.
       */
      receivedAt: string;
    };
    /** logs.follow's params. */
    LogsFollowParams: {
      /** The version of the control API the request is written to. */
      apiVersion: components['schemas']['ApiVersion'];
      /**
       * Which knowledge base's stack. Absent: the one the command line chooses,
       * standing where the control server was started.
       */
      target?: components['schemas']['Target'];
      /** Keep to the local stacks, as --runtime does. */
      runtime?: components['schemas']['Runtime'];
      /**
       * Just this service's container, as --service names it. Absent: each
       * Xynolog service the stack runs.
       */
      service?: string;
    };
    /**
     * A follow whose every source ended on its own. A follow the client cancels
     * is answered with control.cancelled.
     */
    LogsFollowResult: {
      /** The services that were followed. */
      services: string[];
    };
    /** Bus command to archive a resource and optionally remove its file. */
    MarkArchiveCommand: {
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
      resourceId: components['schemas']['ResourceId'];
      /**
       * Optional: where the resource's bytes live, so the archive can act on
       * the file. An instruction to this handler, not a copy of the stored fact
       * (that lives on the primary Representation). Working-tree URI, only
       * file:// is supported.
       */
      storageUri?: string;
      keepFile?: boolean;
    };
    /**
     * Bus command to persist a detection unit's annotations as one acknowledged
     * batch. It is answered only after every annotation is in the event log, so
     * a worker can gate unit completion on durability rather than on emission.
     * The batch is the unit: a partial commit is reported as a failure, and the
     * worker retries the whole unit, which is safe because annotation ids are
     * deterministic: content-addressed, so re-emitting one is a no-op.
     */
    MarkCommitCommand: {
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
      /**
       * The emitter's capabilities (the token's `roles`), injected by the
       * /bus/emit gateway. Clients do not set this. An emitter carrying the
       * worker role must cite the job this batch fulfils in `jobId`; the Stower
       * refuses the batch otherwise.
       */
      _roles?: string[];
      /**
       * The job this batch fulfils. Required when the emitter carries the
       * worker role; absent for self-initiated work (a person, or an agent
       * acting on its own). The knowledge base derives who requested these
       * annotations from the cited job's own events — the emitter never says
       * who the work was for.
       */
      jobId?: components['schemas']['JobId'];
      /** Resource every annotation in this batch targets. */
      resourceId: components['schemas']['ResourceId'];
      /**
       * The unit's annotations, already built with deterministic ids.
       * Re-committing an identical batch is a no-op rather than a duplicate.
       */
      annotations: components['schemas']['Annotation'][];
    };
    /**
     * Durability acknowledgement for a mark:commit batch: every annotation
     * named by the command is in the event log at the moment this is emitted.
     */
    MarkCommitOk: {
      /** What the commit persisted. */
      response: MarkCommitOkResponse;
    };
    /**
     * Success reply after creating an annotation, matched to the originating
     * command by correlationId.
     */
    MarkCreateOk: {
      response: components['schemas']['MarkCreateOkResponse'];
    };
    /** The created annotation's identity. */
    MarkCreateOkResponse: {
      annotationId: components['schemas']['AnnotationId'];
    };
    /**
     * Raw annotation creation intent — bus handler assembles the W3C annotation
     */
    MarkCreateRequest: {
      resourceId: components['schemas']['ResourceId'];
      request: components['schemas']['CreateAnnotationRequest'];
    };
    /**
     * The payload of `mark:delegate-timeout`, a client-local signal: a
     * delegated job went silent past its deadline, with no progress, no
     * completion and no `job:fail`. A real job failure arrives as `job:fail`
     * and never produces this.
     */
    MarkDelegateTimeoutEvent: {
      /** The resource the job was delegated for. */
      resourceId: components['schemas']['ResourceId'];
      motivation: components['schemas']['Motivation'];
    };
    /** Bus command to delete an annotation. */
    MarkDeleteCommand: {
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
      annotationId: components['schemas']['AnnotationId'];
      resourceId?: components['schemas']['ResourceId'];
    };
    /**
     * Success reply after deleting an annotation, matched to the originating
     * command by correlationId.
     */
    MarkDeleteOk: {
      /** The deleted annotation's identity. */
      response: MarkDeleteOkResponse;
    };
    /**
     * A `mark` job's worker says the job is complete, with what a `mark` job
     * reports.
     */
    MarkJobCompleteCommand: {
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
      resourceId: components['schemas']['ResourceId'];
      jobId: components['schemas']['JobId'];
      jobType: 'mark';
      /**
       * Which attempt produced this event, 1-based (a first run is 1). ALWAYS
       * present: the queue re-runs a failed job silently, so an operator
       * reading progress or a terminal record has no other way to tell a re-run
       * from a first run — and provider spend, already counted in
       * xynolog_inference_tokens_total, cannot be attributed to a repeated
       * document without it. Stated rather than inferred from absence, because
       * 'attempt 1' is a fact the emitter always knows.
       */
      attempt?: number;
      result?: components['schemas']['MarkJobResult'];
      durability?: components['schemas']['DurabilityEvidence'];
    };
    /** Create a `mark` job: annotate one resource for one motivation. */
    MarkJobCreateCommand: {
      /**
       * The emitter's verified DID, injected by the gateway. Clients do not set
       * this.
       */
      _userId?: components['schemas']['UserId'];
      /**
       * The emitter's roles, injected by the gateway when it has any. Clients
       * do not set this.
       */
      _roles?: string[];
      jobType: 'mark';
      /** The resource to annotate. */
      resourceId: components['schemas']['ResourceId'];
      params: components['schemas']['MarkJobParams'];
    };
    /**
     * What a `mark` job reports when it has done its work, whatever its
     * motivation.
     */
    MarkJobDone: {
      /**
       * What the model proposed, before anything was checked against the text.
       */
      found: number;
      /**
       * What the log holds: the annotations committed, after the ones that
       * could not be anchored were dropped and repeats were collapsed.
       */
      persisted: number;
      /**
       * How many of the proposed could not be anchored in the text. Absent
       * means none.
       */
      errors?: number;
      /**
       * The annotations persisted per category. A tagging job's; absent from
       * every other.
       */
      byCategory?: { [key: string]: number };
      /**
       * Total floor-accepted under-reported pieces across the job's units.
       * Absent means none — the per-unit evidence rides the terminal progress
       * frame's completedItems; this keeps the result self-describing without
       * the progress stream.
       */
      underReportedPieces?: number;
      /**
       * Pieces whose yield was to be checked against a count and was not: the
       * count failed, was cut off, or answered no count. What they found was
       * kept unchecked. Absent means none: every piece that was to be checked
       * was. A job whose provider checks no yield has none.
       */
      uncheckedPieces?: number;
    };
    /** `mark` jobs of one motivation. */
    MarkJobFilter: {
      jobType: 'mark';
      params: MarkJobFilterParams;
    };
    /**
     * The parameters of a `mark` job, told apart by `motivation`. Each
     * motivation takes its own parameters and no others: a parameter a job does
     * not take is refused where the job is created.
     */
    MarkJobParams:
      | components['schemas']['HighlightingJobParams']
      | components['schemas']['CommentingJobParams']
      | components['schemas']['AssessingJobParams']
      | components['schemas']['LinkingJobParams']
      | components['schemas']['TaggingJobParams'];
    /**
     * A pending `mark` job, announced with its parameters as it was created.
     */
    MarkJobQueuedEvent: {
      jobId: components['schemas']['JobId'];
      jobType: 'mark';
      /** The resource the job is about. */
      resourceId: components['schemas']['ResourceId'];
      /** The DID of the principal whose `job:create` created the job. */
      userId: components['schemas']['UserId'];
      params: components['schemas']['MarkJobParams'];
    };
    /**
     * What a `mark` job reports when it concludes without failing: its counts,
     * or a decline. Neither names its kind: a decline is the one with
     * `declined`.
     */
    MarkJobResult:
      | components['schemas']['MarkJobDone']
      | components['schemas']['JobDeclined'];
    /** Emitted when the user requests a new mark (annotation) on a resource */
    MarkRequestedEvent: {
      /**
       * The '@id' of the resource the mark belongs to (W3C target.source).
       * Routes the event to the right viewer/state unit when a host mounts many
       * viewers on one session.
       */
      source: components['schemas']['ResourceId'];
      /** One or more W3C selectors */
      selector: components['schemas']['AnnotationSelector'];
      motivation: components['schemas']['Motivation'];
    };
    /** Emitted when a mark is submitted with its annotation body */
    MarkSubmitEvent: {
      /**
       * The '@id' of the resource the mark belongs to (W3C target.source).
       * Routes the submit to the state unit bound to that resource — without
       * it, N mounted units each create the annotation (N copies on N
       * resources).
       */
      source: components['schemas']['ResourceId'];
      motivation: components['schemas']['Motivation'];
      /** One or more W3C selectors */
      selector: components['schemas']['AnnotationSelector'];
      /**
       * Optional body. Omit for annotations whose motivation alone is
       * meaningful (e.g. highlighting) or whose user-supplied content is empty
       * (e.g. an assessing annotation saved without comment text). Shape
       * matches Annotation.body.
       */
      body?: components['schemas']['AnnotationBodies'];
    };
    /** Bus command to unarchive a previously archived resource. */
    MarkUnarchiveCommand: {
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
      resourceId: components['schemas']['ResourceId'];
      /**
       * Optional: where the resource's bytes are expected to be. When present
       * the handler VERIFIES the file exists and fails loudly if it does not,
       * rather than succeeding as a no-op. An instruction, not a copy of the
       * stored fact (that lives on the primary Representation). Working-tree
       * URI, only file:// is supported.
       */
      storageUri?: string;
    };
    /** Bus command to update an annotation's body with patch operations. */
    MarkUpdateBodyCommand: {
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
      annotationId: components['schemas']['AnnotationId'];
      resourceId: components['schemas']['ResourceId'];
      operations: components['schemas']['BodyOperation'][];
    };
    /** Bus command to replace the entity types on a resource. */
    MarkUpdateEntityTypesCommand: {
      resourceId: components['schemas']['ResourceId'];
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
      currentEntityTypes: string[];
      updatedEntityTypes: string[];
    };
    /**
     * Request to search the knowledge base's resources by text. The Librarian
     * answers: it matches the text lexically, and when nothing matches, by
     * meaning.
     */
    MatchResourcesRequest: {
      /** The text to search for. */
      search: string;
      archived?: boolean;
      entityType?: string;
      /**
       * How many of the resources the search finds are passed over before the
       * page begins.
       */
      offset?: number;
      /** The most resources a page has. */
      limit?: number;
    };
    /**
     * One page of the resources a text search found, and which kind of answer
     * it is.
     */
    MatchResourcesResponse: {
      resources: components['schemas']['ResourceDescriptor'][];
      /**
       * How many resources the search found in all, and not only on this page.
       */
      total: number;
      /**
       * How many of the resources the search found were passed over before this
       * page, as the request stated.
       */
      offset: number;
      /** The limit the search was made with. */
      limit: number;
      /**
       * What kind of answer this is: 'lexical' — the resources matched the
       * query text; 'semantic' — no lexical match existed, and these resources
       * discuss the query per the vector index. Required so every producer
       * labels its answer; a UI can render semantic results as a different kind
       * of page ('no title matches, but these documents discuss it').
       */
      matchKind: MatchResourcesResponseMatchKind;
    };
    /** Result of searching resources by text */
    MatchResourcesResult: {
      response: components['schemas']['MatchResourcesResponse'];
    };
    /**
     * The payload of `match:search-failed`: a CommandError that names the
     * reference whose candidates could not be searched for.
     */
    MatchSearchFailed: components['schemas']['CommandError'] &
      MatchSearchFailedValue;
    /**
     * Request payload sent on the match:search-request bus channel to find
     * candidate matches.
     */
    MatchSearchRequest: {
      /**
       * Resource ID the reference annotation belongs to. Used to scope result
       * events on the EventBus so the events-stream delivers them to
       * participants viewing this resource.
       */
      resourceId: components['schemas']['ResourceId'];
      /** Annotation ID of the reference to search candidates for */
      referenceId: components['schemas']['AnnotationId'];
      /** Gathered context for the reference annotation */
      context: components['schemas']['GatheredContext'];
      /** Maximum number of candidate results to return */
      limit?: number;
      /** Enable semantic similarity scoring in addition to keyword matching */
      useSemanticScoring?: boolean;
    };
    /** Search results payload emitted on match:search-results SSE channel. */
    MatchSearchResult: {
      referenceId: components['schemas']['AnnotationId'];
      /** The scored candidates, best first. */
      response: components['schemas']['ScoredResource'][];
    };
    MediaTokenRequest: {
      /** The resource ID to generate a media token for */
      resourceId: components['schemas']['ResourceId'];
    };
    MediaTokenResponse: {
      /**
       * Short-lived media token for use as ?token= query parameter on resource
       * URLs
       */
      token: string;
    };
    /**
     * A graph held in the memory of the one process that is given it: for a
     * test. It cannot be shared between processes, so a service that writes the
     * graph for another to read, or reads what another wrote, refuses it.
     */
    MemoryGraphConfig: {
      type: 'memory';
    };
    /**
     * A vector index held in the memory of the one process that is given it:
     * for a test. It cannot be shared between processes, so a service that
     * writes the index for another to search, or searches what another wrote,
     * refuses it.
     */
    MemoryVectorsConfig: {
      type: 'memory';
    };
    /**
     * What names a document, as Kubernetes names an object. Documents refer to
     * one another by `name`.
     */
    Metadata: {
      /**
       * The document's name: lower-case letters, digits and `-`, beginning and
       * ending with a letter or digit. It names the document, never the
       * knowledge base.
       */
      name: string;
      /**
       * The Kubernetes namespace the document belongs in. The launcher reads
       * none.
       */
      namespace?: string;
      /** Kubernetes labels. The launcher reads none. */
      labels?: { [key: string]: string };
      /** Kubernetes annotations. The launcher reads none. */
      annotations?: { [key: string]: string };
    };
    /**
     * Xynolog-supported W3C Web Annotation motivations -
     * https://www.w3.org/TR/annotation-vocab/#motivation
     */
    Motivation:
      'assessing' | 'commenting' | 'highlighting' | 'linking' | 'tagging';
    /** A graph kept in a Neo4j database. */
    Neo4jGraphConfig: {
      type: 'neo4j';
      /** Where the database is reached (`bolt://host:7687`). */
      uri: string;
      /** The user the service connects as. */
      username: string;
      /**
       * The environment variable holding that user's password. The password is
       * never a value here.
       */
      passwordEnv: string;
      /** Which of the server's databases holds the graph. */
      database: string;
    };
    /**
     * A graph kept in Amazon Neptune, asked in Gremlin. No service has been run
     * against one.
     */
    NeptuneGraphConfig: {
      type: 'neptune';
      /** The cluster's endpoint: its host name. */
      endpoint: string;
      /** The port its Gremlin endpoint listens on. */
      port: number;
    };
    /**
     * What registering a knowledge base takes: everything a registered one
     * holds but its id, which the client's list makes. It has a did, because
     * registering follows a sign-in: the knowledge base has already said what
     * it is.
     */
    NewKnowledgeBase: {
      /**
       * What a person reads the knowledge base as. Once the knowledge base has
       * described itself, its own name.
       */
      label: string;
      endpoint: components['schemas']['KbEndpoint'];
      /** The did the knowledge base reported of itself. */
      did: string;
      /**
       * The last time the knowledge base described itself. Absent until it has,
       * in an answer that carried this entry's did.
       */
      lastRead?: components['schemas']['KbRead'];
    };
    /** How well an OCR engine read the pixels. */
    OcrConfidence: {
      /** Mean per-word confidence, 0-100. */
      mean: number;
      /** Words the engine was unsure of. */
      lowConfidenceWords: number;
      totalWords: number;
    };
    /** An embedding model served by an Ollama. */
    OllamaEmbeddingConfig: {
      type: 'ollama';
      /** The model asked for, by the name the Ollama serves it under. */
      model: string;
      /** The address the Ollama's API is reached at (`http://host:11434`). */
      baseUrl: string;
    };
    /**
     * One Agent, or a non-empty list of them: the parties PROV-O and the Web
     * Annotation model let a resource or an annotation name in one place, as
     * one agent or several.
     */
    OneOrMoreAgents:
      components['schemas']['Agent'] | components['schemas']['Agent'][];
    /**
     * One string, or a non-empty list of them: a JSON-LD term that may take one
     * value or several.
     */
    OneOrMoreStrings: string | string[];
    /**
     * One URI, or a non-empty list of them: a JSON-LD term that may name one
     * resource or several.
     */
    OneOrMoreUris: string | string[];
    /**
     * A resource open in a knowledge base: which resource, the name it is shown
     * by, when it was opened and its place among the others open there. A
     * registry shows them by their places, and two in one place by when each
     * was opened, first first.
     */
    OpenResource: {
      /** The resource. */
      id: components['schemas']['ResourceId'];
      /** The name the resource is shown by. */
      name: string;
      /**
       * When the resource was opened, in milliseconds since the Unix epoch.
       * Opening it again while it is open changes neither this nor its place.
       */
      openedAt: number;
      /**
       * The resource's place among those open in the knowledge base. One opened
       * is given the place after the last taken, so a place freed by closing
       * one is not given twice; a move gives each its place in the new order,
       * counted from 0.
       */
      order: number;
      /**
       * The resource's media type, which its icon is chosen by. Absent when it
       * is not known.
       */
      mediaType?: string;
      /**
       * Where the resource is in the knowledge base's working tree, as a URI
       * (file://docs/overview.md). Absent when it is not known.
       */
      storageUri?: string;
    };
    /** Which of a container's streams a line was on. */
    OutputStream: 'stdout' | 'stderr';
    /**
     * The class a PDF is sorted into, which decides how its text is read.
     * smelter/extraction-cases.json states what each class is.
     */
    PdfClass: 'A' | 'B' | 'C' | 'D' | 'E' | 'F' | 'G';
    /**
     * One positioned text run. Coordinates are PDF points with the origin at
     * the bottom-left of the page, Y increasing upward; the flip to canvas
     * pixels happens in the browser.
     */
    PdfTextItem: {
      /**
       * Offset into AnchoredText.text, in Unicode code points from its start,
       * inclusive.
       */
      start: number;
      /**
       * Offset into AnchoredText.text, in Unicode code points from its start,
       * exclusive.
       */
      end: number;
      /** 1-indexed page number. */
      page: number;
      x: number;
      y: number;
      width: number;
      height: number;
    };
    /**
     * `p-<scope>-<sequenceNumber>` — the id of a persisted event delivered on a
     * scoped subscription. Resumable: send it back as that scope's
     * `lastEventId`. Stable across connections, so a client dedups by it.
     */
    PersistedEventId: string;
    /**
     * Bus command saying what a principal is called. The gateway emits it when
     * a principal ACTS, carrying the display name it just verified on its
     * token; a principal may also emit it itself, for itself, which is how an
     * agent, whose token carries no name, says what it is called. Either way
     * the gateway stamps `_userId` with the sender's verified DID, so a
     * principal names only itself. The Stower persists it as
     * principal:profiled, and only when the name differs from the latest one
     * recorded for that DID — so the log holds one line per name a principal
     * has had, not one per act. A name is a fact ABOUT an identity, never part
     * of the record of an act: no artifact carries it, and readers resolve it
     * from the profiles projection. Emitted for a person and for an agent
     * alike; never for a request that merely reads.
     */
    PrincipalProfileCommand: {
      /**
       * The principal's DID, injected by the /bus/emit gateway from the
       * verified token. Clients do not set this.
       */
      _userId?: components['schemas']['UserId'];
      /**
       * The display name: from the issuer's `name` claim, as verified on the
       * token that carried an act, or what the principal said of itself. A
       * token with no name produces no command from the gateway — the issuer is
       * where a person's name is set, and absence is recorded as absence.
       */
      name: string;
    };
    /**
     * Payload for principal:profiled — what this principal is called, as the
     * issuer's verified `name` claim said or as the principal said of itself,
     * recorded once per change (system-level, no resourceId). The event's
     * `userId` is the principal's DID; this payload is the fact about it.
     * Provenance never reads it: every artifact joins on the DID alone, and
     * this is projected into profiles.json for readers to resolve against. Two
     * lines for one DID mean the name changed, and the timestamps say when —
     * which is why no artifact ever had to freeze a copy.
     */
    PrincipalProfiledPayload: {
      /**
       * The display name as of this event: from the issuer's verified `name`
       * claim, or what the principal said of itself.
       */
      name: string;
    };
    /**
     * What a principal last said it is called, and when: the profile a
     * `principal:profiled` event gives.
     */
    Profile: {
      /** The name the principal last gave. */
      name: string;
      /** The timestamp of the event that gave it. */
      since: string;
    };
    /**
     * What the principals of a knowledge base are called: the file
     * `projections/__system__/profiles.json` under the state directory, the sum
     * of the `principal:profiled` events. The Archivist writes it; the
     * Archivist and the Librarian read it to name the principals a reply
     * mentions. Written as JSON indented by two spaces.
     */
    ProfilesProjection: {
      /** Each principal's current profile, keyed by its DID. */
      profiles: { [key: string]: components['schemas']['Profile'] };
    };
    /**
     * One line of what an operation is doing, as the command line would tell a
     * person, without colour. A secret value the launcher generated or read
     * never appears in one.
     */
    Progress: {
      requestId: components['schemas']['RequestId'];
      /**
       * What the line is: narration (log, note), an outcome (ok, warn, fail), a
       * heading (banner, section), a timestamp (stamp), a runtime command about
       * to run (command), or text the operation printed (output).
       */
      kind: ProgressKind;
      /** The line. */
      text: string;
    };
    /**
     * A knowledge base's committed `.xynolog/config.yaml`: its name, whether
     * its changes are staged in git, and its permanent identity. A deployment's
     * documents never restate any of it.
     */
    ProjectConfig: {
      /** The knowledge base's name. */
      project: ProjectConfigProject;
      /** How the knowledge base's changes reach git. */
      git: ProjectConfigGit;
      /** The knowledge base's identity. */
      site: ProjectConfigSite;
    };
    /**
     * OAuth 2.0 Protected Resource Metadata (RFC 9728): which authorization
     * server this knowledge base trusts, served at
     * /.well-known/oauth-protected-resource so a client — the Browser, an MCP
     * client — learns where to send a user to sign in without configuration. A
     * 401 from any protected route points here in its WWW-Authenticate
     * challenge.
     */
    ProtectedResourceMetadata: {
      /**
       * This knowledge base's resource identifier: its did:web identity
       * resolved to an https URL (did:web:example.github.io:my-kb identifies
       * https://example.github.io/my-kb). This is the exact value a token's aud
       * claim must carry. It is an identifier, not an address — nothing
       * dereferences it, and a knowledge base reached over http in local
       * development still names itself by the https form, which is what makes
       * the value stable across every host, port and proxy it is reached
       * through.
       */
      resource: string;
      /**
       * Issuer identifiers whose tokens this resource accepts — the configured
       * identity issuer.
       */
      authorization_servers: string[];
      /**
       * How a bearer token reaches this resource: the Authorization header
       * only.
       */
      bearer_methods_supported: 'header'[];
      /** The knowledge base's name, for a client's sign-in prompt. */
      resource_name?: string;
    };
    /** How an inference provider is reached. */
    Provider: {
      /**
       * Where the provider's API is reached. Anthropic's own API, and the
       * shared Ollama, are stated by no baseURL.
       */
      baseURL?: string;
      apiKey?: components['schemas']['SecretRef'];
    };
    /**
     * A vector index kept in a Qdrant server, asked over its REST API with a
     * token.
     */
    QdrantVectorsConfig: {
      type: 'qdrant';
      /** The server's host. */
      host: string;
      /** The port its REST API listens on. */
      port: number;
      /**
       * The environment variable holding the token the service presents to the
       * server on every request, which says what of the index it may read and
       * write. The token is never a value here.
       */
      tokenEnv: string;
    };
    /**
     * `e-<channel>:<correlationId>` — the id of a frame that carries a
     * correlationId. Deterministic: the same reply has the same id on every
     * connection, so a copy arriving on two connections (a reconnect overlap,
     * or a replay of a retained reply) dedups. Never a resumption watermark.
     */
    ReplyEventId: string;
    /**
     * A specific, byte-addressable rendition of a resource
     * (file/asset/variant).
     */
    Representation: {
      /** Stable ID for this representation. */
      '@id'?: string;
      /** Type(s), e.g., schema:MediaObject. */
      '@type'?: components['schemas']['OneOrMoreStrings'];
      /** MIME/media type (e.g., text/markdown, image/png). */
      mediaType: string;
      /**
       * Working-tree URI identifying where this rendition's bytes live. Only
       * file:// is supported (e.g. file://docs/overview.md). The single home of
       * the storage location: maintained across moves (yield:moved relocates
       * it), absent when the resource has no stored bytes.
       */
      storageUri?: string;
      filename?: string;
      /** Size of the payload in bytes. */
      byteSize?: number;
      /**
       * The SHA-256 of the bytes, as 64 lower-case hexadecimal digits with
       * nothing before them. Whatever compares the checksums of two
       * representations compares this text.
       */
      checksum?: string;
      /** Compression/transfer encoding if applicable. */
      encoding?: string;
      /** IETF BCP 47 language tag (e.g., en, es-ES). */
      language?: string;
      /** Pixels (images/video). */
      width?: number;
      /** Pixels (images/video). */
      height?: number;
      /** Seconds (audio/video). */
      duration?: number;
      created?: string;
      modified?: string;
      /**
       * Profile/shape the bytes conform to (e.g., a JSON profile or SVG
       * profile).
       */
      conformsTo?: components['schemas']['OneOrMoreUris'];
      tags?: string[];
      /**
       * Semantics of this rendition relative to the resource (e.g., original,
       * thumbnail, preview, derived).
       */
      rel?: RepresentationRel;
    } & { [key: string]: unknown };
    /** Payload for yield:representation-added domain event */
    RepresentationAddedPayload: {
      representation: components['schemas']['Representation'];
    };
    /**
     * The Archivist's 404 for a resource's bytes: an ErrorResponse whose `code`
     * says which half of the lookup failed — `resource` when the record holds
     * no such resource, `representation` when it holds the resource but not its
     * bytes. Each reader answers the two differently.
     */
    RepresentationNotFound: components['schemas']['ErrorResponse'] &
      RepresentationNotFoundValue;
    /** Payload for yield:representation-removed domain event */
    RepresentationRemovedPayload: {
      /** Checksum of the representation to remove */
      checksum: string;
    };
    /**
     * The request a notification is about: the JSON-RPC id its client gave it,
     * as the client gave it.
     */
    RequestId: string | number;
    /** The annotations on one resource, as its materialized view holds them. */
    ResourceAnnotations: {
      resourceId: components['schemas']['ResourceId'];
      /**
       * Each annotation as the `mark:added` event that recorded it carried it,
       * with the body changes recorded since applied. In the order they were
       * first recorded.
       */
      annotations: components['schemas']['Annotation'][];
      /** How many of the resource's events the view has applied. */
      version: number;
      /**
       * The timestamp of the last event applied; the empty string before any.
       */
      updatedAt: string;
    };
    /** Payload for mark:archived domain event */
    ResourceArchivedPayload: {
      reason?: string;
    };
    /** Payload for yield:cloned domain event */
    ResourceClonedPayload: {
      name: string;
      format: components['schemas']['ContentFormat'];
      contentChecksum: string;
      contentByteSize?: number;
      /**
       * Where the clone's bytes are, on the resource's primary Representation —
       * the same single home `yield:created` writes to.
       */
      storageUri?: string;
      parentResourceId: components['schemas']['ResourceId'];
      entityTypes?: string[];
      language?: string;
      /**
       * Who made the clone — the emitter, derived at write time. A clone is
       * never job-fulfilling. Absent on events written before derivation
       * existed, whose emitter was their only party.
       */
      creator?: components['schemas']['Agent'];
      /**
       * PROV-O wasAttributedTo, derived at write time: the cloner alone. The
       * value the resource view carries.
       */
      wasAttributedTo?: components['schemas']['OneOrMoreAgents'];
    };
    /** Payload for yield:created domain event */
    ResourceCreatedPayload: {
      name: string;
      format: components['schemas']['ContentFormat'];
      /** SHA-256 of content */
      contentChecksum: string;
      contentByteSize?: number;
      entityTypes?: string[];
      /**
       * The creating instruction's URI, recorded on the event. Append-only, so
       * this value never changes — the LOCATION the projection serves is
       * maintained across moves and lives on the resource's primary
       * Representation, relocated by yield:moved. Optional: a resource may have
       * no bytes. Working-tree URI, only file:// is supported (e.g.
       * file://docs/overview.md).
       */
      storageUri?: string;
      language?: string;
      isDraft?: boolean;
      /**
       * The job this resource was made in fulfilment of, when its create cited
       * one. A write that cites the same job on this resource, by the one who
       * made it, is attributed to that job's requester: the `creator` here.
       */
      jobId?: components['schemas']['JobId'];
      /**
       * What this resource was generated from: the resource, and the annotation
       * on it when the generation was for one. The resource's descriptor names
       * the resource as `wasDerivedFrom`.
       */
      generatedFrom?: ResourceCreatedPayloadGeneratedFrom;
      generationPrompt?: string;
      generator?: components['schemas']['OneOrMoreAgents'];
      /**
       * Who requested this resource — derived by the knowledge base at write
       * time, never sent by the emitter. For a resource created in fulfilment
       * of a job, the requester recorded on that job's job:assigned; otherwise
       * the emitter itself. Absent on events written before derivation existed,
       * whose emitter was their only party.
       */
      creator?: components['schemas']['Agent'];
      /**
       * PROV-O wasAttributedTo, derived at write time from `creator` and the
       * executor: both parties when they differ, one when they are the same.
       * The value the resource view carries; readers do not re-derive it.
       */
      wasAttributedTo?: components['schemas']['OneOrMoreAgents'];
    };
    /**
     * Metadata about a resource (1:1 with its URI). JSON-LD subject is @id.
     * Link to concrete bytes via representations.
     */
    ResourceDescriptor: {
      /** JSON-LD context; URI, object, or array of these. */
      '@context': ResourceDescriptorContext;
      /** The id of the resource being described. */
      '@id': components['schemas']['ResourceId'];
      /** Type(s) of the resource (IRIs/CURIEs via @context). */
      '@type'?: components['schemas']['OneOrMoreStrings'];
      name: string;
      description?: string;
      /** Persistent identifiers (e.g., DOI, URN). */
      identifier?: ResourceDescriptorIdentifier;
      /** Topics (IRIs or strings). */
      about?: components['schemas']['OneOrMoreStrings'];
      /** Equivalent/authoritative references. */
      sameAs?: string[];
      isPartOf?: string[];
      hasPart?: string[];
      license?: string;
      version?: string;
      dateCreated?: string;
      dateModified?: string;
      /**
       * W3C PROV: the resource, or resources, this one was derived from, each
       * by its id
       */
      wasDerivedFrom?: ResourceDescriptorWasDerivedFrom;
      /**
       * W3C PROV — every party responsible for this resource, derived by the
       * knowledge base at creation from verified identities: `[requester,
       * generator]` for a resource a job produced, collapsed to the one agent
       * when the requester produced it. Never accepted from an emitter.
       */
      wasAttributedTo?: components['schemas']['OneOrMoreAgents'];
      /**
       * Software peer that produced this resource (W3C Web Annotation model).
       * Its identity is the verified emitter of the create; the parameters are
       * the producer's to state.
       */
      generator?: components['schemas']['OneOrMoreAgents'];
      /** Profile/shape URI this resource description conforms to. */
      conformsTo?: components['schemas']['OneOrMoreUris'];
      /** Convenience set summarizing media types across representations. */
      availableFormats?: string[];
      /** Managed or referenced byte-level renditions of this resource. */
      representations: ResourceDescriptorRepresentations;
      /** Application-specific: Whether this resource is archived */
      archived?: boolean;
      /** Application-specific: Entity types for this resource */
      entityTypes?: string[];
      /** Application-specific: Whether this resource is a draft */
      isDraft?: boolean;
      /** Application-specific: ID of annotation that triggered generation */
      sourceAnnotationId?: components['schemas']['AnnotationId'];
      /** Application-specific: ID of source resource for clones/derivatives */
      sourceResourceId?: components['schemas']['ResourceId'];
      /**
       * Original URI from a source knowledge base when this resource was
       * imported
       */
      originatedFrom?: string;
    } & { [key: string]: unknown };
    /**
     * A client-local notice that a command on a resource failed, for a UI to
     * show: the payload of `mark:create-error`, `mark:delete-error` and
     * `bind:body-error`. Emitted by the caller that awaited the command, which
     * knows whose command failed on which resource. The `*-failed` wire replies
     * are correlation plumbing and are not for this.
     */
    ResourceErrorEvent: {
      /** The resource the command addressed. */
      resourceId: components['schemas']['ResourceId'];
      /** Human-readable error message. */
      message: string;
    };
    /**
     * A resource's id: a name, never the resource's URI or a path. 1 to 128 of
     * the letters `A`–`Z` and `a`–`z`, the digits, `_` and `-`. It is one
     * segment of a URL and one name in a file system, and it is held to that
     * wherever it enters: a gateway refuses a payload that carries anything
     * else. How one is made is no part of the rule. `__system__` is the one
     * that names no resource: the scope events about the knowledge base itself
     * are logged under.
     */
    ResourceId: string & { readonly __brand: 'ResourceId' };
    /** Payload for yield:moved domain event */
    ResourceMovedPayload: {
      /** Previous file:// URI */
      fromUri: string;
      /** New file:// URI */
      toUri: string;
    };
    /** Payload for mark:unarchived domain event (empty payload) */
    ResourceUnarchivedPayload: Record<string, never>;
    /** Payload for yield:updated domain event */
    ResourceUpdatedPayload: {
      /** SHA-256 of new content */
      contentChecksum: string;
      contentByteSize?: number;
    };
    /**
     * The multipart upload that creates a resource. A client sends it to the
     * gateway's `POST /resources`; the gateway forwards it untouched to the
     * Archivist's `POST /resources`, which stores the bytes and records the
     * resource. One body, two hops.
     */
    ResourceUpload: {
      /** Human-readable resource name */
      name: string;
      /** Binary content */
      file: components['schemas']['Binary'];
      /**
       * Media type of the content (e.g. text/plain, text/markdown, image/png)
       */
      format: string;
      /**
       * Where the content lives (file://... for local). Required — the client
       * names the location; the server does not derive one.
       */
      storageUri: string;
      /** ISO 639-1 language code */
      language?: string;
      /** JSON-stringified array of entity type names */
      entityTypes?: string;
      /**
       * For AI-generated resources: the annotation that triggered generation.
       * Nested into generatedFrom.annotationId on the persisted event.
       */
      sourceAnnotationId?: components['schemas']['AnnotationId'];
      /**
       * For AI-generated resources: the source resource the generating
       * annotation lives on. Nested into generatedFrom.resourceId on the
       * persisted event.
       */
      sourceResourceId?: components['schemas']['ResourceId'];
      /** For AI-generated resources: the prompt that drove generation */
      generationPrompt?: string;
      /**
       * For AI-generated resources: JSON-stringified Agent naming the
       * model/worker that produced the content. Its identity must be the
       * uploading agent's own — the knowledge base refuses a generator naming
       * anyone else. `creator` and `wasAttributedTo` are never sent; the
       * knowledge base derives them from the cited job.
       */
      generator?: string;
      /**
       * The job this resource fulfils, when a worker is creating it. Forwarded
       * onto yield:create; the knowledge base derives who requested the
       * resource from the cited job's own events, and refuses a worker-role
       * create that cites none. Absent for a person's own upload.
       */
      jobId?: components['schemas']['JobId'];
      /** 'true' or 'false' — whether the resource is a draft */
      isDraft?: string;
      /**
       * A clone token from `yield:clone-token-requested`. With it, the resource
       * is created as a clone of the token's source, inheriting its entity
       * types; `language`, `entityTypes` and the generation fields are then not
       * read.
       */
      cloneToken?: string;
      /**
       * With `cloneToken`: 'true' archives the source once the clone exists.
       */
      archiveOriginal?: string;
    };
    /**
     * A resource's materialized view: the file the Archivist writes at
     * `resources/<ab>/<cd>/<resourceId>.json` under the knowledge base's state
     * directory, and every reader of that file reads. It is what the resource's
     * events add up to, and is rebuilt from the event log whenever it is
     * missing. Written as JSON indented by two spaces, by writing a sibling
     * temporary file and renaming it onto the path, so a reader sees a whole
     * document or none.
     */
    ResourceView: {
      resource: components['schemas']['ResourceDescriptor'];
      annotations: components['schemas']['ResourceAnnotations'];
      /**
       * The sequence number of the last event applied. A graph read that
       * follows a write waits for the graph projection to reach it.
       */
      lastSequence: number;
    };
    /** What a container is given, in Kubernetes' spelling. */
    Resources: {
      /** The most a container may use. */
      limits: ResourcesLimits;
    };
    /**
     * A retry budget: how many `attempts` are allowed, with a backoff that
     * starts at `initialDelayMs` and doubles to `maxDelayMs`.
     */
    RetryBudget: {
      /** How many attempts the budget allows. */
      attempts: number;
      /** The delay before the second attempt, in milliseconds. */
      initialDelayMs: number;
      /** The longest delay between attempts, in milliseconds. */
      maxDelayMs: number;
    };
    /**
     * One knowledge base this machine knows: a registered or running local
     * clone, or a codespace stack recorded here. Registration, the directory,
     * the stack and the forward are separate facts, each stated as it is.
     */
    Root: {
      /**
       * Where the stack actually runs. "local": containers on this machine.
       * "codespace": a GitHub-hosted VM whose KB is port-forwarded here.
       */
      placement: RootPlacement;
      /** For a local root: the clone's path. */
      path?: string;
      /**
       * For a local root: whether the directory exists. A registered root whose
       * directory is gone is kept, and says so.
       */
      present?: boolean;
      /**
       * For a local root: how the control server's own directory selects it,
       * when it does — standing in it (cwd), or XYNOLOG_ROOT.
       */
      current?: RootCurrent;
      /** Whether the registry (roots.json) records it. */
      registered: boolean;
      /** Whether a stack of it is recorded on this machine. */
      running: boolean;
      /**
       * When a command last used it, in RFC 3339, as the registry records it.
       */
      lastUsed?: string;
      /**
       * The KB's did:web identifier, from its committed .xynolog/config.yaml —
       * "did:web:" + its site.domain, verbatim. REQUIRED: a KB that declares no
       * domain has no identity to publish, and the launcher refuses to start it
       * rather than inventing or defaulting one. NOT unique within a document:
       * a did names the knowledge base, not a running copy of it, so a local
       * clone and a codespace of the same repo legitimately share one and both
       * are published. host:port is the unique field (at most one entry per
       * address), so consumers look up by ADDRESS and use the did to VERIFY
       * that the copy they reached is the KB they meant — an address alone
       * cannot say which KB is which, and an identity alone cannot say which
       * copy.
       */
      did?: string;
      /**
       * Human-readable site name from the KB's .xynolog/config.yaml
       * (site.siteName), for display
       */
      siteName?: string;
      /**
       * Why its identity could not be read from its clone, when it could not.
       */
      identityError?: string;
      /**
       * The Inference document a start of it runs, as the registry records it.
       */
      config?: string;
      /**
       * For a present local root: the Inference documents its clone has, as
       * start --config names them.
       */
      configs?: string[];
      /**
       * owner/name GitHub slug — present for codespace placements, where the
       * repo is the stack's identity
       */
      repo?: string;
      /** For a codespace root: the codespace's name. */
      codespace?: string;
      /**
       * For a codespace root: GitHub's word for the codespace's state
       * (Available, Shutdown), when gh answered.
       */
      codespaceState?: string;
      /**
       * For a codespace root: the port on this machine its knowledge base is
       * forwarded to, when one is recorded.
       */
      forwardPort?: number;
      /** For a codespace root: whether the recorded forward is alive. */
      forwarded?: boolean;
      /**
       * For a codespace root: whether its knowledge base answers through the
       * forward.
       */
      reachable?: boolean;
    };
    /** roots.forget's params. */
    RootsForgetParams: {
      /** The version of the control API the request is written to. */
      apiVersion: components['schemas']['ApiVersion'];
      /**
       * The registered root to forget: its path, or its basename when only one
       * registered root has it.
       */
      root: string;
    };
    /**
     * A forgotten registry row. Only the row is removed: no file of the clone,
     * and none of its persistent stack state.
     */
    RootsForgetResult: {
      /** The forgotten root's path. */
      path: string;
      /** Whether its directory was already gone. */
      directoryMissing: boolean;
      /**
       * The key whose persistent stack state remains, when some does and no
       * surviving root shares its DID: xynolog clean --root <key> removes it.
       */
      persistentState?: string;
    };
    /**
     * roots.init's params: the local directory, permanent identity, and
     * optional configuration inputs xynolog init takes.
     */
    RootsInitParams: {
      apiVersion: components['schemas']['ApiVersion'];
      /** Existing local directory in which to create the knowledge base. */
      path: string;
      /**
       * The permanent did:web domain, in colon-path form, such as
       * owner.github.io:repo.
       */
      domain: string;
      /** Project name. Absent: the directory basename. */
      name?: string;
      /** Human-readable site name. Absent: the project name. */
      siteName?: string;
      /** Inference provider for the generated local stack documents. */
      inference?: RootsInitParamsInference;
      /** The primary model bound to roles and jobs. */
      model?: string;
      /** A light model example emitted in the generated config. */
      modelLight?: string;
      /** Ollama embedding model name, without the ollama: prefix. */
      embedding?: string;
      /** Inference document name. Absent: the provider name. */
      configName?: string;
      /** Anthropic API base URL. */
      anthropicEndpoint?: string;
      /** Local Ollama API base URL. */
      ollamaBase?: string;
      /** Ollama registry base URL. */
      ollamaRegistry?: string;
    };
    /**
     * The local directory where xynolog init created and registered the
     * knowledge base.
     */
    RootsInitResult: {
      path: string;
    };
    /** roots.list's params. */
    RootsListParams: {
      /** The version of the control API the request is written to. */
      apiVersion: components['schemas']['ApiVersion'];
    };
    /**
     * Every knowledge base this machine knows, as xynolog roots lists them: the
     * local roots first, then the codespace stacks.
     */
    RootsListResult: {
      /** Each root. */
      roots: components['schemas']['Root'][];
      /**
       * What xynolog roots warns of without failing: an invalid XYNOLOG_ROOT, a
       * clone whose project file is refused.
       */
      warnings?: string[];
    };
    /**
     * A run's instance, by the name its caller gave it: unique among the
     * target's instances that run on this machine. A second dispatcher beside
     * the first is another instance. The launcher names the instance's
     * container from the target's key and this name.
     */
    RunInstance: string;
    /**
     * One of a knowledge base's own services, which service.run runs: the seven
     * Xynolog services, as service-telemetry/telemetry.json names them. The
     * reader holds the two lists to each other.
     */
    RunService:
      | 'archivist'
      | 'dispatcher'
      | 'gateway'
      | 'librarian'
      | 'smelter'
      | 'weaver'
      | 'worker';
    /**
     * Who runs a daemon: the launcher, from `image` with `resources`, or
     * somebody else, reached at `external`. Exactly one of the two.
     */
    Runner: Record<string, never>;
    /**
     * A container runtime the launcher drives, as --runtime names it: Apple
     * container, Docker or Podman.
     */
    Runtime: 'container' | 'docker' | 'podman';
    /**
     * One container runtime the launcher drives, and whether this machine has
     * it.
     */
    RuntimeState: {
      name: components['schemas']['Runtime'];
      /** Whether it is on the launcher's PATH. */
      found: boolean;
    };
    /**
     * A resource returned by a search, carrying its relevance score and the
     * reason it matched.
     */
    ScoredResource: components['schemas']['ResourceDescriptor'] &
      ScoredResourceValue;
    /**
     * A secret the document names and does not hold. The launcher hands it to
     * the service that needs it, from where the reference says it is.
     */
    SecretRef: {
      /**
       * The environment variable that holds the secret where the launcher runs.
       * Unset, the start that needs it is refused.
       */
      fromEnv: string;
    };
    /**
     * One W3C selector: a way of finding a segment of a resource. Tell them
     * apart by `type`, which is required on each and single-valued.
     */
    Selector:
      | components['schemas']['TextPositionSelector']
      | components['schemas']['TextQuoteSelector']
      | components['schemas']['SvgSelector']
      | components['schemas']['FragmentSelector'];
    SemanticMatch: {
      /** The chunk text that matched */
      text: string;
      /** Source resource ID */
      resourceId: components['schemas']['ResourceId'];
      /**
       * The source resource's display name, resolved from its view at gather
       * time. Required: a match card must name its source, and corpus matches
       * routinely come from outside the graph neighborhood, so there is no node
       * to borrow a name from. A match whose source no longer resolves to a
       * view is dropped by the producer rather than served nameless.
       */
      resourceName: string;
      /** Source annotation ID, if the match is from an annotation */
      annotationId?: components['schemas']['AnnotationId'];
      /** Cosine similarity score (0-1) */
      score: number;
      /** Entity types on the matched passage */
      entityTypes?: string[];
      /**
       * True when this passage's text was recognized from pixels (OCR of a
       * scanned page) rather than read from the document. Absent means read
       * directly — the common case — so the flag is only present where it
       * changes how the text should be trusted. It travels with the passage
       * because a consumer receives the chunk with no document attached and
       * cannot recompute how the text was obtained.
       */
      machineRead?: boolean;
    };
    /** The host and port a service listens at. */
    ServiceAddress: {
      host: string;
      port: number;
    };
    /**
     * A group of services, as xynolog status reports them and --group names
     * them: a knowledge base's record and its index, the issuer that signs its
     * accounts in, the knowledge workers where people and agents work on it,
     * the providers of its models, and the telemetry that watches them all.
     */
    ServiceGroup:
      | 'record'
      | 'index'
      | 'issuer'
      | 'knowledge-workers'
      | 'providers'
      | 'telemetry';
    /** service.host's params. */
    ServiceHostParams: {
      /** The version of the control API the request is written to. */
      apiVersion: components['schemas']['ApiVersion'];
      /**
       * The container runtime to ask, as --runtime names it. Absent: the one
       * the stack's record names, else the first installed one.
       */
      runtime?: components['schemas']['Runtime'];
    };
    /**
     * Where this machine and a run's instance meet, under a runtime: the
     * address the launcher publishes an instance's ports on, and the address
     * the instance reaches this machine's listeners at. A caller writes it into
     * a document before the run.
     */
    ServiceHostResult: {
      runtime: components['schemas']['Runtime'];
      /**
       * The host address: an IP address or a host name, as the launcher's own
       * stack dials it under this runtime.
       */
      address: string;
    };
    /** The identity provider a service's account signs in at, by its issuer. */
    ServiceIdentity: {
      /** The issuer URL, exactly as tokens carry it in `iss`. */
      issuer: string;
    };
    /**
     * notifications/serviceOutput: one line a run's instance wrote, from its
     * start, every line, in the order of its stream, as the instance wrote it.
     * The launcher gives an instance none of its own secrets (R2), and keeps no
     * copy.
     */
    ServiceOutput: {
      requestId: components['schemas']['RequestId'];
      instance: components['schemas']['RunInstance'];
      stream: components['schemas']['OutputStream'];
      /** The line, without its newline. */
      line: string;
    };
    /**
     * service.run's params: one instance of one of a knowledge base's own
     * services, run once from the image the target's stack documents name,
     * unsupervised, on the caller's document, arguments and environment.
     * contract/LAUNCHER-CONTROL.md, R1-R8.
     */
    ServiceRunParams: {
      /** The version of the control API the request is written to. */
      apiVersion: components['schemas']['ApiVersion'];
      /**
       * The knowledge base whose stack documents name the service's image, and
       * whose stack the instance belongs to: stack.stop of it removes the
       * instance too.
       */
      target: components['schemas']['LocalTarget'];
      /**
       * The container runtime to ask, as --runtime names it. Absent: the one
       * the stack's record names, else the first installed one.
       */
      runtime?: components['schemas']['Runtime'];
      /** The service whose image runs. */
      service: components['schemas']['RunService'];
      instance: components['schemas']['RunInstance'];
      /**
       * The configuration document's text, written as it is, at the path the
       * image's own arguments name: it need not be JSON. Absent: no file is at
       * that path.
       */
      document?: string;
      /**
       * The arguments the image's program is given in place of the image's own
       * (--config and the document's path). Absent: the image's own.
       */
      args?: string[];
      /**
       * Every variable the instance is given beside the image's own, by name:
       * nothing of the launcher's is added (R2). Empty: none.
       */
      environment: { [key: string]: string };
      /**
       * Directories of this machine, each mounted read-write at its own path,
       * so that a path the document names is the same inside the instance and
       * out (R4). Empty: none.
       */
      mounts: string[];
      /**
       * Directories put before the image's PATH, in order, each mounted at its
       * own path. Empty: the image's PATH as it is.
       */
      pathFirst: string[];
      /**
       * The ports the instance listens on, each published at the same number on
       * the host address (R3). Empty: none.
       */
      ports: number[];
    };
    /**
     * A run that ended: its instance exited. Sent once the instance's container
     * has exited, after all of its output.
     */
    ServiceRunResult: {
      instance: components['schemas']['RunInstance'];
      /**
       * The instance's exit status: the service's own, since nothing supervises
       * it (R1). An instance a signal ended exits with 128 and the signal's
       * number: 143 for SIGTERM, 137 for SIGKILL.
       */
      exitCode: number;
      /** Milliseconds from its container's start to its exit. */
      ranMs: number;
    };
    /** service.signal's params: a signal for a run's instance. */
    ServiceSignalParams: {
      /** The version of the control API the request is written to. */
      apiVersion: components['schemas']['ApiVersion'];
      /**
       * The knowledge base whose stack documents name the service's image, and
       * whose stack the instance belongs to: stack.stop of it removes the
       * instance too.
       */
      target: components['schemas']['LocalTarget'];
      /**
       * The container runtime to ask, as --runtime names it. Absent: the one
       * the stack's record names, else the first installed one.
       */
      runtime?: components['schemas']['Runtime'];
      instance: components['schemas']['RunInstance'];
      /**
       * term: SIGTERM, and SIGKILL 15 seconds later if it has not exited. kill:
       * SIGKILL, so nothing it would settle on the way out is settled.
       */
      signal: ServiceSignalParamsSignal;
    };
    /**
     * A signal sent, or not needed. The instance's exit is its run's answer,
     * not this one.
     */
    ServiceSignalResult: {
      /**
       * Whether the instance still ran when the signal came. false: it has
       * exited, and its run's answer is on its way; nothing was sent.
       */
      delivered: boolean;
    };
    /**
     * notifications/serviceStarted: a run's instance is running. Sent once,
     * before any of its output.
     */
    ServiceStarted: {
      requestId: components['schemas']['RequestId'];
      instance: components['schemas']['RunInstance'];
      /** The runtime's name for the instance's container. */
      container: string;
      /**
       * Where the instance reads its document: the path the image's own
       * arguments name. Present when the run gave a document.
       */
      documentPath?: string;
      /**
       * The host address the instance's ports are published on, as service.host
       * names it for the run's runtime.
       */
      address: string;
    };
    /**
     * One service, as xynolog status reads it: where it runs, its state, and
     * whether it answers. Nothing is reported that the launcher did not
     * observe: an endpoint is named only when the stack's record or the
     * descriptor names one, and a page to open only when the service answers.
     */
    ServiceStatus: {
      /** The service, as xynolog status names it. */
      role: string;
      /** The group it belongs to. */
      group: components['schemas']['ServiceGroup'];
      /**
       * The product its driver names (Neo4j, Keycloak), when its record names a
       * driver.
       */
      product?: string;
      /**
       * Where it runs: the runtime its container runs under, external (somebody
       * else runs it), or host (a process on this machine). Absent when nothing
       * runs it.
       */
      runsOn?: string;
      /**
       * running: its container runs. stopped: its container exists and does not
       * run (containerState says how). reachable, unreachable: somebody else
       * runs it, and its endpoint answers or does not. absent: there is no
       * container of it. not-configured: the stack's documents ask for none.
       */
      state: ServiceStatusState;
      /**
       * The runtime's own word for a container that is not running (exited,
       * created).
       */
      containerState?: string;
      /** Whether its health endpoint answers. */
      healthy: boolean;
      /**
       * Whether its health counts toward its knowledge base's: a service the
       * documents ask for none of, and a telemetry backend --no-observe leaves
       * out, do not.
       */
      counted: boolean;
      /**
       * The endpoint the launcher asks its health of: an http URL, or
       * tcp://host:port.
       */
      probe?: string;
      /**
       * The page a person opens: the Browser, Jaeger's and Prometheus's
       * interfaces, the collector's metrics readout. Present only when the
       * service answers. The collector's OTLP receiver is never one.
       */
      page?: string;
      /**
       * For the issuer the knowledge base signs in at, when it is the
       * machine's: its realm there.
       */
      realm?: string;
      /**
       * For a service several knowledge bases share: the name of each it
       * serves, as knowledgeBases names them.
       */
      serves?: string[];
    };
    /**
     * The launcher's own stored sign-in for a stack (xynolog login), never
     * Desktop's. No token is in it.
     */
    Session: {
      /**
       * valid: the stack's gateway accepts the stored token. expired: it
       * refuses it (a refresh, or xynolog login, renews it). unverified: the
       * stack did not answer. none: nothing is stored.
       */
      state: SessionState;
      /** The email the session was signed in as, when the store records one. */
      email?: string;
    };
    /**
     * A participant opened a live connection to this KB — an SSE stream on
     * /bus/subscribe. Presence is CONNECTION lifecycle, not login: a token can
     * be minted and sit unused, so what this reports is that someone is
     * WATCHING. One person with two tabs produces two of these, which is why
     * connectionId is required — the DID alone cannot tell two connections
     * apart, and a consumer that counts DIDs will undercount viewers.
     */
    SessionJoinedEvent: {
      /**
       * DID of the authenticated principal on that connection. A person or a
       * software agent — the bus does not distinguish.
       */
      participant: components['schemas']['UserId'];
      /**
       * Identifies this connection for its lifetime. The matching session:left
       * carries the same value.
       */
      connectionId: string;
    };
    /**
     * A participant's live connection to this KB ended — the SSE stream
     * aborted. Carries the same connectionId as the session:joined that opened
     * it, so a consumer tracking who is present can retire the right connection
     * rather than assuming one per participant.
     */
    SessionLeftEvent: {
      /** DID of the authenticated principal on that connection. */
      participant: components['schemas']['UserId'];
      /** The connectionId announced by the matching session:joined. */
      connectionId: string;
    };
    /** One setting the launcher keeps, as xynolog settings shows it. */
    Setting: {
      /** Its name, as xynolog settings takes it. */
      name: string;
      /**
       * Whether this is the machine-wide form of a knowledge-base setting
       * (secret-store --default).
       */
      default: boolean;
      /** What it applies to: every knowledge base on this machine, or one. */
      appliesTo: SettingAppliesTo;
      /** The values in effect, one per line xynolog settings shows. */
      values: components['schemas']['SettingLine'][];
      /** Whether settings.set and settings.unset change it. */
      settable: boolean;
      /** For one they do not: how it is changed instead. */
      changedBy?: string;
    };
    /**
     * One value of a setting, and where it came from, as xynolog settings shows
     * it. A secret's value is never one: a secret setting shows where the value
     * is kept.
     */
    SettingLine: {
      /** The value in effect. */
      value: string;
      /** Where it came from: a record, a document, the default. */
      source: string;
    };
    /** settings.get's params. */
    SettingsGetParams: {
      /** The version of the control API the request is written to. */
      apiVersion: components['schemas']['ApiVersion'];
      /** The setting, as xynolog settings names it. */
      name: string;
      /** The machine-wide form of a knowledge-base setting: --default. */
      default?: boolean;
      /**
       * A knowledge base's clone, by path or by the basename of a registered
       * root, as --root takes it. Absent: the clone the control server was
       * started in.
       */
      root?: string;
    };
    /** Emitted when the hover delay setting changes */
    SettingsHoverDelayChangedEvent: {
      hoverDelayMs: number;
    };
    /** settings.list's params. */
    SettingsListParams: {
      /** The version of the control API the request is written to. */
      apiVersion: components['schemas']['ApiVersion'];
      /**
       * A knowledge base's clone, by path or by the basename of a registered
       * root, as --root takes it. Absent: the clone the control server was
       * started in.
       */
      root?: string;
    };
    /**
     * Every setting the launcher keeps: the machine's, then the knowledge
     * base's.
     */
    SettingsListResult: {
      /** The knowledge base whose settings are listed, when one resolved. */
      root?: string;
      /**
       * Why no knowledge base resolved, when none did: its settings are not
       * listed.
       */
      unresolved?: string;
      /** Each setting. */
      settings: components['schemas']['Setting'][];
    };
    /** Emitted when the UI locale setting changes */
    SettingsLocaleChangedEvent: {
      locale: string;
    };
    /** settings.path's params. */
    SettingsPathParams: {
      /** The version of the control API the request is written to. */
      apiVersion: components['schemas']['ApiVersion'];
      /**
       * Whose document: the Browser's, the worker's, the issuer's or the vector
       * store's.
       */
      document: SettingsPathParamsDocument;
    };
    /**
     * Where a machine document is. When there is none, it is written from the
     * launcher's catalog first, as a start writes it; one that does not hold is
     * refused, as a start refuses it.
     */
    SettingsPathResult: {
      /** The document's path. */
      path: string;
    };
    /** settings.set's params. */
    SettingsSetParams: {
      /** The version of the control API the request is written to. */
      apiVersion: components['schemas']['ApiVersion'];
      /** The setting, as xynolog settings names it. */
      name: string;
      /** The machine-wide form of a knowledge-base setting: --default. */
      default?: boolean;
      /**
       * A knowledge base's clone, by path or by the basename of a registered
       * root, as --root takes it. Absent: the clone the control server was
       * started in.
       */
      root?: string;
      /** The value, checked as a start would check it. */
      value: string;
    };
    /** Emitted when the UI theme setting changes */
    SettingsThemeChangedEvent: {
      theme: SettingsThemeChangedEventTheme;
    };
    /** settings.unset's params. */
    SettingsUnsetParams: {
      /** The version of the control API the request is written to. */
      apiVersion: components['schemas']['ApiVersion'];
      /** The setting, as xynolog settings names it. */
      name: string;
      /** The machine-wide form of a knowledge-base setting: --default. */
      default?: boolean;
      /**
       * A knowledge base's clone, by path or by the basename of a registered
       * root, as --root takes it. Absent: the clone the control server was
       * started in.
       */
      root?: string;
    };
    /**
     * Bus command to rebuild anchored-text artifacts by re-running extraction —
     * every geometry-capable resource when resourceId is absent, one resource
     * when present. Served by the Smelter, serialized (each unit can be a
     * multi-second OCR pass), and never destructive: nothing is deleted first,
     * stale entries are simply overwritten. Re-anchoring makes zero embedding
     * calls — the vectors are already correct; only the derived map is re-made.
     * Partial completion replies failed, with counts: a rebuild that quietly
     * skipped resources would present exactly like a document with no text.
     */
    SmeltRebuildAnchorsCommand: {
      /**
       * When present, re-anchor only this resource; otherwise every
       * geometry-capable resource in the catalog.
       */
      resourceId?: components['schemas']['ResourceId'];
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
    };
    /**
     * The payload of `smelt:settled`: the Smelter's decision for one resource's
     * content, keyed by the checksum of the bytes it inspected. `indexed`: the
     * content is in the vector index. `skipped`: it declined, and `reason` says
     * why.
     */
    SmeltSettled: {
      /** The resource whose content was inspected. */
      resourceId: components['schemas']['ResourceId'];
      /** The checksum of the bytes inspected. */
      contentChecksum: string;
      outcome: SmeltSettledOutcome;
      /** Why the content was skipped. */
      reason?: SmeltSettledReason;
    };
    /**
     * The two numbers a text is cut by before it is embedded, both in tokens, a
     * token being taken as four code points.
     */
    SmelterChunking: {
      /** The size of a chunk. */
      chunkSize: number;
      /** How much of a chunk the next one repeats. */
      overlap: number;
    };
    /**
     * Everything a Smelter reads at boot: nothing in it is defaulted by the
     * Smelter. Whoever starts a Smelter writes it, from the knowledge base's
     * stack documents, and the Smelter reads it from the path its `--config`
     * flag names. This schema is the contract, and a Smelter needs no launcher.
     * Started without `--config`, or with a path that names no file, the
     * Smelter refuses to start and says which. No secret is a value here: an
     * embedding provider's key is named by the environment variable that holds
     * it, and the Smelter's own service account is `XYNOLOG_OIDC_CLIENT_ID` and
     * `XYNOLOG_OIDC_CLIENT_SECRET` in its environment. A document that does not
     * validate is refused at boot, naming each failing field.
     */
    SmelterConfig: {
      kb: components['schemas']['KbIdentity'];
      /** The URL the Smelter reaches the gateway at: its route to the bus. */
      gatewayUrl: string;
      /** The issuer the Smelter's service account signs in at. */
      identity: components['schemas']['ServiceIdentity'];
      /**
       * Where the Archivist listens. The Smelter reads a resource's bytes from
       * it, and keeps the anchored-text store there, as its service account.
       */
      archivist: components['schemas']['ServiceAddress'];
      embedding: components['schemas']['EmbeddingConfig'];
      vectors: components['schemas']['VectorsConfig'];
      chunking: components['schemas']['SmelterChunking'];
      /**
       * How many PDFs the Smelter works on at once. Each one under way holds
       * its bytes, a page of a scan in pixels beside the OCR process reading
       * it, and its text and vectors, so whoever starts a Smelter sizes this
       * with the memory it gives it. Every other resource is indexed beside
       * them.
       */
      pdfsAtOnce: number;
      cursorsPath: components['schemas']['CursorsPath'];
      /** The port the Smelter answers `/health` on. */
      port: number;
      logLevel: components['schemas']['LogLevel'];
      logFormat: components['schemas']['LogFormat'];
    };
    /**
     * The Smelter's health answer (SMELTER.md § Health): seven members, each
     * from what the Smelter holds, for it asks nothing of the gateway, its
     * embedding provider or its vector database to answer. `status` is `ok`
     * whenever it answers, and says what else is so in the members beside it.
     */
    SmelterHealth: {
      status: 'ok';
      /**
       * The DID of the knowledge base it serves: the one its settings name,
       * which that knowledge base said it is before the Smelter reached its
       * index.
       */
      kb: components['schemas']['KbDid'];
      /**
       * The state of its own stream of the record, one of the seven of
       * TRANSPORT-HTTP.md § Connection lifecycle. Events are delivered to it
       * while it is `open`.
       */
      stream: SmelterHealthStream;
      /**
       * How far it has followed the record. Its sweep is also `due` where its
       * start's reconcile failed.
       */
      following: components['schemas']['FollowerFollowing'];
      /**
       * How many events it has applied since it started: events of the kinds
       * that do something, and not refused. Neither an event taken as nothing
       * nor the work of a reconcile or a rebuild is counted.
       */
      eventsProcessed: number;
      /**
       * How far the latest reconcile has got: the pass's `summary` when it is
       * done, or its `error` when it failed.
       */
      reconcile: SmelterHealthReconcile;
      /**
       * What the Smelter holds its index to, and what this start did for that.
       */
      index: SmelterHealthIndex;
    };
    /**
     * What a Smelter's reconcile came to (SMELTER.md § Reconcile), as its
     * health reports a pass that is done (SmelterHealth's `reconcile.summary`).
     * The first four add up to how many resources it set out to index, less any
     * whose indexing was no longer wanted when its turn came.
     */
    SmelterReconcileSummary: {
      /** How many resources it set out to index were indexed. */
      resourcesEmbedded: number;
      /**
       * How many were skipped, by the reason each was skipped for: a reason
       * `smelt:settled` carries (SmeltSettled).
       */
      resourcesSkipped: { [key: string]: number };
      /** How many could not be read. */
      resourcesUnavailable: number;
      /** How many failed. */
      resourcesFailed: number;
      /** How many resources it planned to rewrite the entity types of. */
      resourcesRestamped: number;
      /** How many resources it planned to derive the anchored text of again. */
      resourcesReanchored: number;
      /** How many resources it planned to take out of the index. */
      resourceVectorsDeleted: number;
      /** How many annotations it planned to index. */
      annotationsEmbedded: number;
      /** How many annotations it planned to rewrite the entity types of. */
      annotationsRestamped: number;
      /** How many annotations it planned to take out of the index. */
      annotationVectorsDeleted: number;
      /** How many resources of the catalog have text. */
      resourcesEligible: number;
      /** How many resources have points when it ends. */
      resourcesIndexed: number;
    };
    SpecificResource: {
      type: 'SpecificResource';
      /** The id of the resource this body leads to */
      source: components['schemas']['ResourceId'];
      /** Why this body is included */
      purpose?: components['schemas']['BodyPurpose'];
    };
    /**
     * The group and version of Xynolog's kinds. The group names who defines a
     * kind, under the domain the knowledge bases' DIDs use; which knowledge
     * base a document is about is said inside it.
     */
    StackApiVersion: 'xynolog.org/v1alpha1';
    /**
     * A knowledge base's record and the services that keep it: the Gateway, the
     * Dispatcher, the Archivist, and the broker between them. They live and die
     * with the knowledge base.
     */
    StackKnowledgeBase: {
      apiVersion: components['schemas']['StackApiVersion'];
      kind: 'KnowledgeBase';
      metadata: components['schemas']['Metadata'];
      /** The knowledge base's services, and how each runs. */
      spec: StackKnowledgeBaseSpec;
    };
    /**
     * stack.start's params: what xynolog start takes, but its help and its
     * narration switches.
     */
    StackStartParams: {
      /** The version of the control API the request is written to. */
      apiVersion: components['schemas']['ApiVersion'];
      /**
       * Which knowledge base's stack. Absent: the one the command line chooses,
       * standing where the control server was started.
       */
      target?: components['schemas']['Target'];
      /**
       * The container runtime to ask, as --runtime names it. Absent: the one
       * the stack's record names, else every installed one.
       */
      runtime?: components['schemas']['Runtime'];
      /**
       * The Inference document to run, as --config names it. Absent: the
       * knowledge base's recorded preference, else the default.
       */
      config?: string;
      /** Just this one service, as --service names it. */
      service?: string;
      /** Just this one group of services, as --group names it. */
      group?: components['schemas']['ServiceGroup'];
      /**
       * For a codespace target: which of the repository's codespaces, as
       * --codespace names it.
       */
      codespaceName?: string;
      /**
       * For a codespace target being created: its VM class, as --machine names
       * it.
       */
      machine?: string;
      /**
       * For a codespace target being created: inactivity before it stops, as
       * --idle-timeout takes it.
       */
      idleTimeout?: string;
      /**
       * For a codespace target being created: how long a stopped codespace is
       * kept, as --retention-period takes it.
       */
      retentionPeriod?: string;
      /**
       * Whether to start the telemetry backends, Jaeger and Prometheus. false
       * is --no-observe. Absent: true.
       */
      observe?: boolean;
      /**
       * Where a started Ollama keeps its models, as --ollama-cache names it.
       * Absent: the host's ~/.ollama when there is one, else the named volume —
       * what the command line's prompt does when nobody answers it.
       */
      ollamaCache?: StackStartParamsOllamaCache;
      /**
       * Whether to run nothing, and report each runtime command a start would
       * run as a command progress line.
       */
      dryRun?: boolean;
    };
    /**
     * A start that ran to its end: the stack as status reads it afterwards. A
     * start that failed is an error, whatever it started before it did; its
     * progress lines say what it did.
     */
    StackStartResult: {
      /** Whether the start ran nothing. */
      dryRun: boolean;
      /**
       * The started knowledge base's stack, as status reads it after the start.
       * Absent from a dry run, and from a start of services no knowledge base
       * owns.
       */
      knowledgeBase?: components['schemas']['KnowledgeBaseStatus'];
      /**
       * The shared services, as status reads them after the start. Absent from
       * a dry run.
       */
      shared?: components['schemas']['ServiceStatus'][];
    };
    /** stack.stop's params: what xynolog stop takes, but its help. */
    StackStopParams: {
      /** The version of the control API the request is written to. */
      apiVersion: components['schemas']['ApiVersion'];
      /**
       * Which knowledge base's stack. Absent: the one the command line chooses,
       * standing where the control server was started.
       */
      target?: components['schemas']['Target'];
      /**
       * The container runtime to ask, as --runtime names it. Absent: the one
       * the stack's record names, else every installed one.
       */
      runtime?: components['schemas']['Runtime'];
      /** Just this one service, as --service names it. */
      service?: string;
      /** Just this one group of services, as --group names it. */
      group?: components['schemas']['ServiceGroup'];
      /**
       * For a codespace target: destroy the codespace, state and all, and
       * forget its record. The command line's --delete. Refused without
       * deleteConfirmed.
       */
      delete?: boolean;
      /**
       * That the person confirmed the deletion: delete is refused with
       * control.confirmation-required without it.
       */
      deleteConfirmed?: boolean;
      /**
       * Whether to stop nothing, and report each runtime command a stop would
       * run as a command progress line.
       */
      dryRun?: boolean;
    };
    /**
     * A stop that ran to its end: what status reads afterwards. A stop that
     * failed is an error.
     */
    StackStopResult: {
      /** Whether the stop stopped nothing. */
      dryRun: boolean;
      /**
       * The knowledge bases still recorded, as status reads them after the
       * stop. Absent from a dry run.
       */
      knowledgeBases?: components['schemas']['KnowledgeBaseStatus'][];
      /**
       * The shared services, as status reads them after the stop. Absent from a
       * dry run.
       */
      shared?: components['schemas']['ServiceStatus'][];
    };
    StatusResponse: {
      status: string;
      version: string;
      features: StatusResponseFeatures;
      message: string;
      authenticatedAs?: string;
    };
    /** status.snapshot's params. */
    StatusSnapshotParams: {
      /** The version of the control API the request is written to. */
      apiVersion: components['schemas']['ApiVersion'];
      /**
       * Which knowledge base's stack. Absent: the one the command line chooses,
       * standing where the control server was started.
       */
      target?: components['schemas']['Target'];
      /**
       * The container runtime to ask, as --runtime names it. Absent: the one
       * the stack's record names, else every installed one.
       */
      runtime?: components['schemas']['Runtime'];
    };
    /**
     * What xynolog status reports: each knowledge base with its own services,
     * and each service the knowledge bases share, once, with the knowledge
     * bases it serves.
     */
    StatusSnapshotResult: {
      /**
       * The target's stack; with no target, the stack of the knowledge base the
       * control server stands in, else every recorded one.
       */
      knowledgeBases: components['schemas']['KnowledgeBaseStatus'][];
      /**
       * The services every knowledge base shares, group by group, and those the
       * machine serves for the knowledge bases that name them.
       */
      shared: components['schemas']['ServiceStatus'][];
    };
    /**
     * One entry of the storage-uri index: the file
     * `projections/storage-uri/<ab>/<cd>/<sha256 of the URI, hex>.json` under
     * the state directory. It answers which resource's content is at a place in
     * the working tree. Written as JSON indented by two spaces, `uri` first.
     */
    StorageUriEntry: {
      /**
       * The `file://` URI of a place in the working tree, relative to the
       * knowledge base's root.
       */
      uri: string;
      resourceId: components['schemas']['ResourceId'];
    };
    /**
     * A persisted domain event with metadata. Flat shape — event fields and
     * metadata are peers.
     */
    StoredEventResponse: {
      /** Unique event ID (UUID) */
      id: string;
      /** Event type (flow verb name, e.g. mark:added) */
      type: string;
      /** When the event occurred */
      timestamp: string;
      /** DID of the user who triggered the event */
      userId: components['schemas']['UserId'];
      /** Resource this event affects (absent for system events) */
      resourceId?: components['schemas']['ResourceId'];
      /** Event schema version */
      version: number;
      /** Event-type-specific payload */
      payload: { [key: string]: unknown };
      metadata: components['schemas']['EventMetadata'];
    };
    /**
     * Base MIME types (no parameters) admitted by Xynolog. Membership is the
     * create/yield gate — every member is storable, nameable, and uploadable.
     * What more the system can do with a type (render, annotate, extract text,
     * author) is curated per type in @xynolog/core's media-type registry, which
     * is keyed by this enum.
     */
    SupportedMediaType:
      | 'text/plain'
      | 'text/markdown'
      | 'text/html'
      | 'text/css'
      | 'text/csv'
      | 'text/xml'
      | 'application/json'
      | 'application/xml'
      | 'application/yaml'
      | 'application/x-yaml'
      | 'application/pdf'
      | 'application/msword'
      | 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
      | 'application/vnd.ms-excel'
      | 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      | 'application/vnd.ms-powerpoint'
      | 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
      | 'application/zip'
      | 'application/gzip'
      | 'application/x-tar'
      | 'application/x-7z-compressed'
      | 'application/octet-stream'
      | 'application/wasm'
      | 'image/png'
      | 'image/jpeg'
      | 'image/gif'
      | 'image/webp'
      | 'image/svg+xml'
      | 'image/bmp'
      | 'image/tiff'
      | 'image/x-icon'
      | 'video/mp4'
      | 'video/mpeg'
      | 'video/webm'
      | 'video/ogg'
      | 'video/quicktime'
      | 'video/x-msvideo'
      | 'audio/mpeg'
      | 'audio/wav'
      | 'audio/ogg'
      | 'audio/webm'
      | 'audio/aac'
      | 'audio/flac'
      | 'text/javascript'
      | 'application/javascript'
      | 'text/x-typescript'
      | 'application/typescript'
      | 'text/x-python'
      | 'text/x-java'
      | 'text/x-c'
      | 'text/x-c++'
      | 'text/x-csharp'
      | 'text/x-go'
      | 'text/x-rust'
      | 'text/x-ruby'
      | 'text/x-php'
      | 'text/x-swift'
      | 'text/x-kotlin'
      | 'text/x-shell'
      | 'font/woff'
      | 'font/woff2'
      | 'font/ttf'
      | 'font/otf';
    SvgSelector: {
      type: 'SvgSelector';
      /** SVG markup defining the region (must include xmlns attribute) */
      value: string;
    };
    /**
     * A single category within a tag schema (e.g. 'Issue' in IRAC,
     * 'distinguished' in legal-citation-treatment). Each category carries
     * methodology-bound semantics: a name, a description, and examples used in
     * the LLM prompt.
     */
    TagCategory: {
      name: string;
      description: string;
      examples: string[];
    };
    /**
     * A structural-analysis schema (e.g. legal-irac, scientific-imrad,
     * argument-toulmin). Defines a methodology framework as an id, name,
     * description, domain hint, and an ordered list of categories. KBs and
     * their skills register schemas with the runtime registry via
     * `frame.addTagSchema(...)` at session start.
     */
    TagSchema: {
      id: string;
      name: string;
      description: string;
      /**
       * Free-form domain hint (e.g. 'legal', 'scientific', 'general'). Used in
       * the LLM prompt to tune the model's analysis voice. KB authors choose.
       */
      domain: string;
      tags: components['schemas']['TagCategory'][];
    };
    /**
     * Payload for frame:tag-schema-added domain event (system-level, no
     * resourceId — fan-out is global to the KB).
     */
    TagSchemaAddedPayload: {
      schema: components['schemas']['TagSchema'];
    };
    /**
     * The knowledge base's tag schemas: the file
     * `projections/__system__/tagschemas.json` under the state directory, the
     * sum of the `frame:tag-schema-added` events. Written as JSON indented by
     * two spaces.
     */
    TagSchemasProjection: {
      /**
       * Every tag schema added, sorted by `id`. A schema added again under an
       * `id` replaces the one held.
       */
      tagSchemas: components['schemas']['TagSchema'][];
    };
    /**
     * What a tagging job takes: passages of the resource are marked with
     * categories of one tag schema.
     */
    TaggingJobParams: {
      motivation: 'tagging';
      /** The tag schema to tag by. It is one the knowledge base registers. */
      schemaId: string;
      /** The categories of that schema to tag with. */
      categories: string[];
      /** The language the annotations' own text is written in. BCP 47. */
      language?: string;
      /** The language of the resource being read. BCP 47. */
      sourceLanguage?: string;
    };
    /**
     * Which knowledge base an operation acts on: a local clone's stack, or a
     * codespace's. The launcher resolves it as the command line resolves --root
     * and --repo, and refuses a choice it would have to guess.
     */
    Target: {
      /**
       * Where the stack runs: on this machine (local), or on a GitHub codespace
       * whose knowledge base is forwarded here (codespace).
       */
      kind: TargetKind;
      /**
       * For a local target: the knowledge base's clone, by path or by the
       * basename of a registered root, as --root takes it. Absent: the local
       * stack the command line chooses with --runtime, standing where the
       * control server was started.
       */
      root?: string;
      /** For a codespace target: the GitHub repository, as --repo takes it. */
      repo?: string;
    };
    TextPositionSelector: {
      type: 'TextPositionSelector';
      /**
       * Offset into the resource's decoded text, exactly as decoded, in Unicode
       * code points from its start: where the selected text starts.
       */
      start: number;
      /**
       * Offset into the resource's decoded text, exactly as decoded, in Unicode
       * code points from its start: just past where the selected text ends.
       */
      end: number;
    };
    TextQuoteSelector: {
      type: 'TextQuoteSelector';
      exact: string;
      prefix?: string;
      suffix?: string;
    };
    TextualBody: {
      type: 'TextualBody';
      /** The text content (e.g., entity type name) */
      value: string;
      /** Why this body is included */
      purpose?: components['schemas']['BodyPurpose'];
      /** MIME type (defaults to text/plain) */
      format?: string;
      /** BCP 47 language tag */
      language?: string;
    };
    /**
     * The furthest a single unit got, and what it had counted when it got
     * there. A unit left partway is resumed from its cursor rather than redone.
     * A finished unit keeps its cursor: `next` at the length of the text,
     * `size` the size its last piece was cut at, and its final `found`,
     * `emitted` and `errors`, so that an attempt that skips the unit still
     * counts it. A cursor never says a unit is finished, wherever it stands:
     * `completedUnits` does. A unit is an entity type for a linking job, a
     * category for a tagging job, and the job's own motivation for every other
     * — which is why a unit-grain checkpoint alone is too coarse: those three
     * have exactly one unit, so nothing could be recorded until the whole
     * document was done.
     *
     * MERGE IS MONOTONE PER UNIT, not a union. `completedUnits` is a set and
     * converges under concurrent snapshots because a set only grows; a cursor
     * converges only if a stale snapshot can never move it backward.
     *
     * IT CARRIES THE UNIT'S RUNNING TALLIES TOO, and they are required. A
     * resumed unit counts only the chunks it actually runs, so without them a
     * retry's terminal record reports the remainder of the document as if it
     * were the whole — measured at a `found` of 19 where the document yielded
     * 25. The position and the tallies are ONE observation of the same
     * committed chunk; splitting them would let a resume take the saving and
     * still report a number nobody can trust.
     */
    UnitCursor: {
      /**
       * Unicode code points of the text consumed once the last COMMITTED chunk
       * completed — the resume position, and the length of the text for a unit
       * whose last chunk it was. Deliberately the chunk's `next`, never its
       * `at`: the checkpoint must not lead the log, so it records where a chunk
       * that is already durable ended, not where the in-flight one began.
       * Recording `at` would make a resume re-run the chunk it already paid
       * for.
       */
      next: number;
      /**
       * The token size that last committed chunk was cut at — the calibration
       * the attempt paid for over the chunks before it. A resume seeds from
       * this and then takes ONE adaptive step, as if the last outcome were a
       * failure, which it was: the job died. Seeding alone would re-cut the
       * failing piece identically; opening at the default would discard the
       * calibration.
       */
      size: number;
      /**
       * Items detection has returned for this unit through the last committed
       * chunk — the numerator a resumed attempt continues from rather than
       * restarting at zero. Counts what the model reported, before dedupe.
       */
      found: number;
      /**
       * Annotations actually committed for this unit through the last committed
       * chunk, after dedupe. With `found` and `errors` it is what the job's
       * terminal result reports, so a resumed unit seeds all three and its
       * record describes the whole document rather than one attempt's share.
       */
      emitted: number;
      /**
       * Items detection returned for this unit through the last committed chunk
       * that could not be anchored in the text. Carried with the other two
       * tallies so that a resumed job reports the whole document's, and not
       * only its last attempt's.
       */
      errors: number;
    };
    UpdateAnnotationBodyRequest: {
      /**
       * Resource ID containing the annotation (required for O(1) Layer 3
       * lookup)
       */
      resourceId: components['schemas']['ResourceId'];
      /** Array of body modification operations to apply */
      operations: components['schemas']['BodyOperation'][];
    };
    /**
     * A sign-in waits for a person: open the verification page and enter the
     * code. The code is sent here and nowhere else — in no progress line, no
     * log record and no diagnostic.
     */
    UserAction: {
      requestId: components['schemas']['RequestId'];
      /** The page where the person enters the code. */
      verificationUri: string;
      /** The page with the code already in it, when the issuer offers one. */
      verificationUriComplete?: string;
      /** The code the person enters. */
      userCode: string;
      /** How long the code is good for, from when it was issued. */
      expiresInSeconds: number;
    };
    /**
     * The identity of whoever did something, a person or a software agent
     * alike: a DID (`did:web:<domain>:users:<subject>`,
     * `did:web:<domain>:agents:<subject>`), with no whitespace in it. Never a
     * name, an address, or a row in a table. What follows `did:` is not
     * constrained further: a subject is the issuer's, percent-encoded, and that
     * encoding leaves some punctuation as it is.
     */
    UserId: string & { readonly __brand: 'UserId' };
    /**
     * The authenticated principal, as this knowledge base names it.
     *
     * The `did` is the identity: it is what the bus stamps on every event, what
     * resource creation is attributed to, and what a client must compare
     * against to recognise its own work in the data. It is the only identifier:
     * a row id would appear nowhere else in the system and correlate with
     * nothing.
     *
     * The remaining fields exist to be displayed, and all of them come from the
     * token's own claims.
     */
    UserResponse: {
      /**
       * The authenticated principal's DID: `did:web:<domain>:agents:<subject>`
       * for an agent, whose token's `kind` claim is `agent`, and
       * `did:web:<domain>:users:<subject>` for a person, where the subject is
       * the issuer claim the knowledge base names its principals by
       * (`identity.subjectClaim`).
       */
      did: components['schemas']['UserId'];
      /**
       * The address the token carries, when it carries one: an agent's account
       * need not have one.
       */
      email: string | null;
      name: string | null;
      image: string | null;
      /**
       * The knowledge base's domain: the authority the principal is named
       * under.
       */
      domain: string;
    };
    /**
     * The vector store the launcher runs for the knowledge bases on a machine,
     * each knowledge base's index in collections of its own. It belongs to no
     * knowledge base, so its document is kept in the launcher's state home, in
     * `stack/vectors.yaml`, not in a knowledge base's repository. A knowledge
     * base keeps its index in it by naming `shared` at `spec.vectors`.
     */
    VectorStore: {
      apiVersion: components['schemas']['StackApiVersion'];
      kind: 'VectorStore';
      metadata: components['schemas']['Metadata'];
      /** The vector store, and where it is published. */
      spec: VectorStoreSpec;
    };
    /**
     * The vector index a service writes or searches, and what that kind of
     * index needs to be reached: one of the kinds `xynolog-vectors` has a store
     * for, told apart by `type`.
     */
    VectorsConfig:
      | components['schemas']['QdrantVectorsConfig']
      | components['schemas']['MemoryVectorsConfig'];
    /**
     * An embedding model served by Voyage AI. No service has been run against
     * Voyage itself.
     */
    VoyageEmbeddingConfig: {
      type: 'voyage';
      /** The model asked for, by Voyage's name for it. */
      model: string;
      /**
       * The whole address of Voyage's embeddings call
       * (`https://api.voyageai.com/v1/embeddings`).
       */
      endpoint: string;
      /**
       * The environment variable holding the Voyage API key. The key is never a
       * value here.
       */
      apiKeyEnv: string;
    };
    /**
     * The payload of `weave:applied`: the Weaver has applied a resource's
     * events to the graph up to this sequence number. Emitted after applying an
     * event, or a batch's last event.
     */
    WeaveApplied: {
      /** The resource whose events were applied. */
      resourceId: components['schemas']['ResourceId'];
      /** The resource-stream sequence of the last applied event. */
      sequenceNumber: number;
    };
    /**
     * Bus command to rebuild the graph projection from the event log — the
     * whole graph when resourceId is absent, one resource when present. Served
     * by the Weaver; replaces direct rebuild access, which does not survive the
     * Weaver's container split.
     */
    WeaveRebuildCommand: {
      /**
       * When present, rebuild only this resource; otherwise clear and rebuild
       * the entire graph.
       */
      resourceId?: components['schemas']['ResourceId'];
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
    };
    /**
     * Everything a Weaver reads at boot: nothing in it is defaulted by the
     * Weaver. The launcher writes it for the Weaver it starts, from the
     * knowledge base's stack documents, and the Weaver reads it from the path
     * its `--config` flag names (its image passes `/etc/xynolog/weaver.json`).
     * Whoever starts a Weaver another way writes the same document: this schema
     * is the contract, and a Weaver needs no launcher. Started without
     * `--config`, or with a path that names no file, the Weaver refuses to
     * start and says which. No secret is a value here: the graph database's
     * password is named by the environment variable that holds it, and the
     * Weaver's own service account is `XYNOLOG_OIDC_CLIENT_ID` and
     * `XYNOLOG_OIDC_CLIENT_SECRET` in its environment. A document that does not
     * validate is refused at boot, naming each failing field.
     */
    WeaverConfig: {
      kb: components['schemas']['KbIdentity'];
      /** The URL the Weaver reaches the gateway at: its route to the bus. */
      gatewayUrl: string;
      /** The issuer the Weaver's service account signs in at. */
      identity: components['schemas']['ServiceIdentity'];
      /**
       * Where the Archivist listens. The Weaver reads the record by position
       * from it, and a resource's annotations, as its service account.
       */
      archivist: components['schemas']['ServiceAddress'];
      graph: components['schemas']['GraphConfig'];
      cursorsPath: components['schemas']['CursorsPath'];
      /** The port the Weaver answers `/health` on. */
      port: number;
      logLevel: components['schemas']['LogLevel'];
      logFormat: components['schemas']['LogFormat'];
    };
    /**
     * The Weaver's health answer (WEAVER.md § Health). `status` is `ok`
     * whenever the Weaver answers: it says nothing of whether the Weaver can
     * reach the gateway or the graph.
     */
    WeaverHealth: {
      status: 'ok';
      /**
       * The DID of the knowledge base it serves: the one its settings name,
       * which that knowledge base said it is before the Weaver connected to the
       * graph database.
       */
      kb: components['schemas']['KbDid'];
      following: components['schemas']['FollowerFollowing'];
      /**
       * How far the reconcile its first sweep is followed by has got (WEAVER.md
       * § Reconcile): the pass's `summary` when it is done, or its `error` when
       * it failed.
       */
      reconcile: WeaverHealthReconcile;
    };
    /**
     * Everything a worker reads at boot: nothing in it is defaulted by the
     * worker. The launcher writes it for the machine's worker, from the
     * knowledge bases on that worker's list: each local knowledge base as its
     * start places it, from its stack documents, and each added by `xynolog
     * worker kb add`, offered the engines of the local one it was added from.
     * The worker reads it from the path its `--config` flag names (its image
     * passes `/etc/xynolog/worker.json`). Whoever starts a worker another way
     * writes the same document: this schema is the contract, and a worker needs
     * no launcher. Started without `--config`, or with a path that names no
     * file, the worker refuses to start and says which. No secret is a value
     * here: a provider's key is named by the environment variable that holds
     * it, and the key the worker signs in with at every knowledge base is
     * `XYNOLOG_OIDC_CLIENT_KEY` in its environment, an RSA private key; each
     * knowledge base names the client that holds its public half there. A
     * document that does not validate is refused at boot, naming each failing
     * field.
     */
    WorkerConfig: {
      /**
       * The knowledge bases this worker does jobs for. At each it signs in,
       * confirms which knowledge base it reached and claims for its engines,
       * apart from every other: one knowledge base's trouble stops that
       * knowledge base's work alone (`contract/WORKER-SERVICE.md` § Knowledge
       * bases). No two name one `domain`, which the worker refuses at boot.
       */
      knowledgeBases: components['schemas']['WorkerKnowledgeBaseConfig'][];
      /**
       * The path of a model catalogue file: what each model of a provider can
       * take, for the providers whose own APIs do not say (`google`, `openai`,
       * `together`). A worker with an engine of one of those providers refuses
       * to start where the file cannot be read, and where it states nothing of
       * that engine's model. A worker with no such engine does not read it.
       */
      modelCatalogue: string;
      /** The port the worker answers `/health` on. */
      port: number;
      logLevel: components['schemas']['LogLevel'];
      logFormat: components['schemas']['LogFormat'];
    };
    /**
     * One engine a worker runs: which it is, the jobs the worker claims to do
     * with it, and where its provider is reached.
     */
    WorkerEngineConfig: {
      engine: components['schemas']['Engine'];
      /**
       * The jobs the worker claims to do with this engine, as a claim names
       * them (`job:claim`'s `accepts`): it claims with these filters and no
       * other.
       */
      jobs: components['schemas']['JobFilter'][];
      /** The address the provider's API is reached at. */
      baseUrl: string;
      /**
       * The environment variable holding the provider's API key, when the
       * provider requires one.
       */
      apiKeyEnv?: string;
    };
    /**
     * One engine at one knowledge base: which it is, the jobs it claims, and
     * what its claims can say of themselves (WORKER-CONTRACT V1).
     */
    WorkerEngineHealth: {
      engine: components['schemas']['Engine'];
      /** The jobs it claims, as its claims state them. */
      jobs: components['schemas']['JobFilter'][];
      /** When a `job:queued` last reached it, or null. */
      lastQueuedEventAt: string | null;
      /**
       * When it was last handed a job, or null. A claim answered with none
       * pending is not one.
       */
      lastClaimAt: string | null;
      /** When a job it held last settled, or null. */
      lastFinishedAt: string | null;
      /** When it was last active, or null. */
      lastActivityAt: string | null;
      /** The job it holds, or null. */
      activeJob: WorkerEngineHealthActiveJob | null;
      /** How many jobs it has completed since the service started. */
      jobsCompleted: number;
    };
    /**
     * The Worker service's health answer (WORKER-SERVICE H1). It answers only
     * once a knowledge base of its document is confirmed, so a 200 means it is
     * working somewhere.
     */
    WorkerHealth: {
      status: 'ok';
      /**
       * One entry for each of the document's `knowledgeBases`, in its order.
       */
      knowledgeBases: components['schemas']['WorkerKnowledgeBaseHealth'][];
    };
    /**
     * One knowledge base a worker does jobs for: which it is, where its gateway
     * is, the account the worker signs in as there, and the engines it offers
     * it. The worker signs in, confirms the knowledge base and claims at each
     * knowledge base apart from every other.
     */
    WorkerKnowledgeBaseConfig: {
      /**
       * The knowledge base's did:web domain, as it answers
       * `browse:kb-requested`: which knowledge base this is. The worker
       * confirms it there before it claims, and refuses a knowledge base that
       * answers another domain, or none.
       */
      domain: string;
      /**
       * The URL the worker reaches the knowledge base's gateway at: its route
       * to the bus and to a resource's bytes, and the only address of the
       * knowledge base it holds.
       */
      gatewayUrl: string;
      /**
       * Where the worker signs in for this knowledge base, and as which client.
       */
      identity: WorkerKnowledgeBaseConfigIdentity;
      /**
       * The engines the worker offers this knowledge base, and the jobs it does
       * with each: its own choice, on its own providers' keys. It claims each
       * engine's jobs there for it, so a job no engine here is used for is not
       * claimed at this knowledge base.
       */
      engines: components['schemas']['WorkerEngineConfig'][];
    };
    /**
     * One knowledge base the worker serves, as its health says it. `did` and
     * `engines` are there while it is `working`, and only then.
     */
    WorkerKnowledgeBaseHealth: {
      /** The entry's `domain`. */
      domain: string;
      /**
       * `starting`: signing in, opening its stream, confirming it, or waiting
       * to start again. `working`: confirmed, its engines claiming. `refused`:
       * refused, until the service is started again.
       */
      state: WorkerKnowledgeBaseHealthState;
      /** The agent's DID at this knowledge base, as its gateway named it. */
      did?: string;
      /** One entry for each of the entry's engines, in its order. */
      engines?: components['schemas']['WorkerEngineHealth'][];
    };
    /**
     * The shared worker that does knowledge bases' jobs: its image, its memory
     * and its log level. They are shared, not any knowledge base's, so its
     * document is kept in the launcher's state home, in `stack/workers.yaml`,
     * not in a knowledge base's repository. A knowledge base's jobs are done
     * when its Inference document gives a job an engine. A worker needs only
     * the Gateway, and an issuer's token with the worker's role.
     */
    WorkerPool: {
      apiVersion: components['schemas']['StackApiVersion'];
      kind: 'WorkerPool';
      metadata: components['schemas']['Metadata'];
      /** How the worker runs. */
      spec: WorkerPoolSpec;
    };
    /**
     * A knowledge base's operational readings from Collector metrics.
     * Request-tracking occupancy and queue depth are current gauges; completed
     * and failed are worker counters since that worker process started. Missing
     * readings are unknown, never zero.
     */
    WorkloadStatus: {
      /**
       * The Gateway's request tracking: correlation IDs it currently holds so
       * replies can be routed to the app client that sent each request, and the
       * tracking capacity.
       */
      ledger?: WorkloadStatusLedger;
      /**
       * Current Dispatcher depth and, when the worker has emitted counters,
       * completed and failed work since worker start. These are different
       * measurements and time windows.
       */
      queue?: WorkloadStatusQueue;
    };
    /**
     * Bus command to create a cloned resource from a clone token. Bytes are
     * stored by the upload path BEFORE this command is emitted, because bytes
     * travel over HTTP and never over the bus — the command carries the storage
     * coordinates, never content.
     */
    YieldCloneCreateCommand: {
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
      token: string;
      name: string;
      /**
       * Where the caller already wrote the clone's bytes — an instruction, not
       * a copy of the stored fact (that lives on the primary Representation).
       * Bytes are stored through the byte door BEFORE this command is sent, so
       * this names an existing file. Working-tree URI, only file:// is
       * supported.
       */
      storageUri: string;
      contentChecksum: string;
      byteSize: number;
      format: components['schemas']['ContentFormat'];
      archiveOriginal?: boolean;
    };
    /** Success response after creating a cloned resource. */
    YieldCloneCreated: {
      response: components['schemas']['YieldedResource'];
    };
    /**
     * Command: stow an already-uploaded clone's bytes and append
     * `yield:cloned`.
     *
     * The INNER half of the clone flow. `yield:clone-create` reaches the
     * CloneTokenManager, which alone can validate the token and read the
     * source's entity types; it then emits this so the Stower — the only
     * appendEvent caller — writes the domain event.
     *
     * Distinct from `yield:create` because a clone is a distinct operation, not
     * a creation with an extra field. It REQUIRES a parent, and that
     * requirement is what a separate command expresses: an optional
     * `parentResourceId` on the create command could not say that a clone
     * without a parent is not a clone. `ResourceClonedPayload` requires it for
     * the same reason.
     *
     * Generated resources are NOT clones: they carry provenance in
     * `generatedFrom` and stay on `yield:create`.
     */
    YieldClonePersistCommand: {
      /**
       * Injected by the gateway from the authenticated principal; never
       * supplied by a wire caller.
       */
      _userId?: components['schemas']['UserId'];
      name: string;
      /**
       * The caller's instruction for WHERE the bytes are — the uploader wrote
       * them before emitting this. The stored location lives on the clone's
       * primary Representation, the one home of a storage URI.
       */
      storageUri: string;
      contentChecksum: string;
      byteSize: number;
      format: components['schemas']['ContentFormat'];
      language?: string;
      /**
       * Inherited from the source resource by the CloneTokenManager, which is
       * the only party that knows the token is valid.
       */
      entityTypes?: string[];
      /**
       * The resource this one is cloned FROM. Required: it is what makes this a
       * clone rather than a creation.
       */
      parentResourceId: components['schemas']['ResourceId'];
    };
    /**
     * Success reply after cloning a resource, matched to the originating
     * command by correlationId.
     */
    YieldClonePersistOk: {
      /** The clone's identity — a new resource, distinct from its parent. */
      response: components['schemas']['YieldedResource'];
    };
    /** Bus command to request cloning a resource using a clone token. */
    YieldCloneResourceRequest: {
      token: string;
    };
    /** Bus command to request a clone token for a resource. */
    YieldCloneTokenRequest: {
      resourceId: components['schemas']['ResourceId'];
    };
    /** Bus command to create a yielded resource in the knowledge base. */
    YieldCreateCommand: {
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
      /**
       * The emitter's capabilities (the token's `roles`), injected by the
       * /bus/emit gateway. Clients do not set this. An emitter carrying the
       * worker role must cite the job this resource fulfils in `jobId`; the
       * Stower refuses the create otherwise.
       */
      _roles?: string[];
      /**
       * The job this resource fulfils. Required when the emitter carries the
       * worker role; absent for self-initiated work (a person, or an agent
       * acting on its own). The knowledge base derives who requested this
       * resource from the cited job's own events — the emitter never says who
       * the work was for.
       */
      jobId?: components['schemas']['JobId'];
      name: string;
      /**
       * The caller's instruction for WHERE the bytes are — not a copy of the
       * stored fact. The stored location lives on the resource's primary
       * Representation (`Representation.storageUri`), which is its single home;
       * this field is the message that puts it there. Working-tree URI, only
       * file:// is supported (e.g. file://docs/overview.md).
       */
      storageUri: string;
      contentChecksum: string;
      byteSize: number;
      format: components['schemas']['ContentFormat'];
      language?: string;
      entityTypes?: string[];
      isDraft?: boolean;
      generatedFrom?: YieldCreateCommandGeneratedFrom;
      generationPrompt?: string;
      /**
       * The Software peer that produced the content, when software did. Its
       * identity must be the emitter's own — the knowledge base refuses a
       * generator naming anyone else, and supplies it from the verified emitter
       * when omitted. `creator` and `wasAttributedTo` are never sent; the
       * knowledge base derives them from the emitter and the cited job.
       */
      generator?: components['schemas']['OneOrMoreAgents'];
    };
    /**
     * Success reply after creating a yielded resource, matched to the
     * originating command by correlationId.
     */
    YieldCreateOk: {
      /** The created resource's identity. */
      response: components['schemas']['YieldedResource'];
    };
    /**
     * A `yield` job's worker says the job is complete, with what a `yield` job
     * reports.
     */
    YieldJobCompleteCommand: {
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
      resourceId: components['schemas']['ResourceId'];
      jobId: components['schemas']['JobId'];
      jobType: 'yield';
      /**
       * Which attempt produced this event, 1-based (a first run is 1). ALWAYS
       * present: the queue re-runs a failed job silently, so an operator
       * reading progress or a terminal record has no other way to tell a re-run
       * from a first run — and provider spend, already counted in
       * xynolog_inference_tokens_total, cannot be attributed to a repeated
       * document without it. Stated rather than inferred from absence, because
       * 'attempt 1' is a fact the emitter always knows.
       */
      attempt?: number;
      /**
       * The annotation the job's context was focused on, when it was focused on
       * one. Lets a client route the completion to that annotation.
       */
      annotationId?: components['schemas']['AnnotationId'];
      result?: components['schemas']['YieldJobResult'];
      durability?: components['schemas']['DurabilityEvidence'];
    };
    /**
     * Create a `yield` job: make a resource from a gathered context. It names
     * no resource of its own: the job is about the resource its context focuses
     * on, which the Dispatcher reads from `params.context.focus`.
     */
    YieldJobCreateCommand: {
      /**
       * The emitter's verified DID, injected by the gateway. Clients do not set
       * this.
       */
      _userId?: components['schemas']['UserId'];
      /**
       * The emitter's roles, injected by the gateway when it has any. Clients
       * do not set this.
       */
      _roles?: string[];
      jobType: 'yield';
      params: components['schemas']['GenerationJobParams'];
    };
    /**
     * What a `yield` job reports when it has made its resource. The worker
     * creates the resource first (the create round trip returns its id), then
     * emits job:complete carrying it, so resourceId is always present on the
     * wire.
     */
    YieldJobDone: {
      /**
       * ID of the generated resource, obtained by the worker from the create
       * round-trip before job:complete is emitted
       */
      resourceId: components['schemas']['ResourceId'];
      /** Name of the generated resource */
      resourceName: string;
      /**
       * True when the model stopped at the maxTokens ceiling — the artifact is
       * cut off, not complete. Derived at the producer from the provider's
       * stopReason ('max_tokens' → true); required because the worker always
       * knows.
       */
      truncated: boolean;
    };
    /** `yield` jobs. */
    YieldJobFilter: {
      jobType: 'yield';
    };
    /**
     * A pending `yield` job, announced with what it is asked to make and
     * without its `context`.
     */
    YieldJobQueuedEvent: {
      jobId: components['schemas']['JobId'];
      jobType: 'yield';
      /** The resource the job is about. */
      resourceId: components['schemas']['ResourceId'];
      /** The DID of the principal whose `job:create` created the job. */
      userId: components['schemas']['UserId'];
      params: components['schemas']['GenerationJobRequest'];
    };
    /**
     * What a `yield` job reports when it concludes without failing: the
     * resource it made, or a decline. Neither names its kind: a decline is the
     * one with `declined`.
     */
    YieldJobResult:
      | components['schemas']['YieldJobDone']
      | components['schemas']['JobDeclined'];
    /** Bus command to update a yielded resource's storage content. */
    YieldUpdateCommand: {
      /**
       * Authenticated user's DID, injected by the /bus/emit gateway. Clients do
       * not set this.
       */
      _userId?: components['schemas']['UserId'];
      resourceId: components['schemas']['ResourceId'];
      /**
       * The caller's instruction for WHERE the bytes are — not a copy of the
       * stored fact. The stored location lives on the resource's primary
       * Representation (`Representation.storageUri`), which is its single home;
       * this field is the message that puts it there. Working-tree URI, only
       * file:// is supported (e.g. file://docs/overview.md).
       */
      storageUri: string;
      contentChecksum: string;
      byteSize: number;
    };
    /**
     * Success reply after updating a yielded resource, matched to the
     * originating command by correlationId.
     */
    YieldUpdateOk: {
      /** The updated resource's identity. */
      response: components['schemas']['YieldedResource'];
    };
    /** The resource a yield command wrote, by its id. */
    YieldedResource: {
      resourceId: components['schemas']['ResourceId'];
    };
  };
}

/**
 * The records Protocol states in its tables and the client types, which no wire
 * message carries, and what only they reach.
 */
export interface records {
  /**
   * How a quoted selection was found in a text. Which word a span is found by
   * is reconcile's rule (specs/src/annotations/reconcile-cases.json).
   */
  AnchorMethod:
    'unique-match' | 'context-recovered' | 'first-of-many' | 'fuzzy-match';
  /**
   * What starting an authorization-code grant is told: the knowledge base to
   * sign in to, where the issuer sends the person back, and, re-authenticating,
   * which registered knowledge base it is and what the person believed they
   * chose.
   */
  BeginAuthorizationOptions: {
    target: components['schemas']['HttpEndpoint'];
    /** Where the issuer sends the person back to. */
    redirectUri: string;
    /**
     * The registered knowledge base being re-authenticated, rather than a new
     * address connected to.
     */
    kbId?: string;
    /**
     * The knowledge base's DID the person believed they chose: verified after,
     * never assumed.
     */
    expectedDid?: string;
    /**
     * The knowledge base's name the person believed they chose: verified after,
     * never assumed.
     */
    expectedName?: string;
  };
  /**
   * What a worker's claiming of jobs is told: the jobs it takes, and how long
   * it waits for what it waits on. A wait left out is client/timing.json's of
   * the same name.
   */
  ClaimOptions: {
    /**
     * The jobs this claim takes. A job is handed over when it matches any one
     * of them.
     */
    accepts: components['schemas']['JobFilter'][];
    /** How long it waits for the answer to one claim, in milliseconds. */
    jobClaimTimeoutMs?: number;
    /**
     * How long a held job may show no activity before it is called stalled, in
     * milliseconds.
     */
    heldJobStallMs?: number;
    /**
     * How often it looks at how long a held job has shown no activity, in
     * milliseconds.
     */
    heldJobStallCheckMs?: number;
    /**
     * How long it waits for the record to acknowledge a commit of annotations,
     * in milliseconds.
     */
    markCommitTimeoutMs?: number;
  };
  /**
   * Who the knowledge base at an address says it is, asked with a token just
   * issued, before any entry is made for it.
   */
  ConnectionIdentity: {
    /** The did it reports for itself. */
    did: components['schemas']['UserId'];
    /** What it says of itself. */
    description: components['schemas']['KbDescription'];
  };
  /**
   * What creating a resource from a clone token is told: the token, the clone's
   * name and text, and whether the source is archived once the clone exists.
   */
  CreateFromTokenOptions: {
    token: string;
    name: string;
    /** The clone's text, uploaded as its content. */
    content: string;
    archiveOriginal?: boolean;
  };
  /**
   * What a device-authorization grant (RFC 8628) shows the person signing in:
   * the code they enter, and where.
   */
  DeviceCode: {
    /** The code the person enters at the issuer. */
    userCode: string;
    /** Where the person enters it. */
    verificationUri: string;
    /**
     * Where the person goes to sign in with the code already entered, when the
     * issuer gives one.
     */
    verificationUriComplete?: string;
    /** How many seconds the code stays good for. */
    expiresIn: number;
  };
  /**
   * One of the knowledge base's engines as a client joins it: the entry
   * `browse:engines-result` names, with the inference limits the service
   * holding its credentials reported. A client asks each such service for its
   * limits; an engine no service reported has no `limits`.
   */
  EngineWithLimits: {
    engine: components['schemas']['Engine'];
    /**
     * The jobs the knowledge base's Inference document has this engine used
     * for, as a claim names them. Absent for an engine only Librarian actors
     * ask.
     */
    jobs?: components['schemas']['JobFilter'][];
    limits?: components['schemas']['InferenceLimits'];
  };
  /**
   * The knowledge base's engines, in the order `browse:engines-result` names
   * them, each with the limits reported for it.
   */
  EnginesWithLimits: records['EngineWithLimits'][];
  /**
   * What a person believed they were signing in to: the did and the name of the
   * row they clicked, or of the entry they signed in to again.
   */
  Expected: {
    /** The did they believed it has. */
    did: string;
    /** The name they believed it has. Absent when they had none. */
    name?: string;
  };
  /**
   * Why a reader refused a frame, for its first fault: `lacks`, a member it
   * lacks; `malformed`, a member that is not of its shape. A reader's rule
   * (specs/src/bus/frame-cases.json).
   */
  FrameRefusalReason: 'lacks' | 'malformed';
  /**
   * What gathering the context of a resource is told beside the resource:
   * GatherResourceRequestOptions, each member of which a caller may leave out.
   * client/surface.json's `gather.resource` cases state what is sent for one
   * left out.
   */
  GatherResourceOptions: {
    /**
     * How many links out from the resource the knowledge graph reaches, nearest
     * first: 1 is what the resource links to and what cites it, and each
     * further link out adds what those link to and what cites them
     */
    depth?: number;
    /** Maximum number of related resources to include */
    maxResources?: number;
    /** Whether to include resource content in the gathered result */
    includeContent?: boolean;
    /** Whether to include resource summaries in the gathered result */
    includeSummary?: boolean;
    /**
     * Entity types to exclude from the semantic recall built into this context
     * (caller-supplied; e.g. a chat consumer passes ['Question'] so prior
     * questions never ground answer generation). Optional; default none.
     */
    excludeEntityTypes?: string[];
  };
  /** The tokens an issuer issued at the end of a sign-in. */
  IssuedTokens: {
    /** The access token: short-lived, sent as a Bearer token. */
    access: string;
    /**
     * The refresh token: what renews the access token without another sign-in.
     */
    refresh: string;
  };
  /**
   * How a job's `pollUntilComplete` asks for the job's status: how long it
   * waits between its asks, and how long it goes on asking. A member left out
   * is client/timing.json's: `jobPollMs` and `jobPollTimeoutMs`.
   */
  JobPollOptions: {
    /** How long it waits between one ask and the next, in milliseconds. */
    everyMs?: number;
    /**
     * How long it goes on asking, from its first ask, before it fails as timed
     * out, in milliseconds.
     */
    withinMs?: number;
  };
  /**
   * A different knowledge base answers at a registered address. Both dids,
   * because neither alone says what to do: a person has to recognise which
   * knowledge base they registered and which one answers.
   */
  KbIdentityConflict: {
    /** The did the entry records. */
    expectedDid: string;
    /** The did the knowledge base that answered reported. */
    observedDid: string;
  };
  /** What reading the active knowledge base against its entry concluded. */
  KbReadKind: 'recorded' | 'conflict' | 'no-verdict';
  /**
   * What a knowledge base said when it was asked to describe itself, read
   * against the entry it was asked as.
   */
  KbReadVerdict:
    KbReadVerdictRecorded | KbReadVerdictConflict | KbReadVerdictNoVerdict;
  /**
   * What the credential stored for a knowledge base says, read without asking
   * anyone: `authenticated`, a token is stored and has not expired; `expired`,
   * a token is stored and has expired; `signed-out`, nothing is stored.
   */
  KbSessionStatus: 'authenticated' | 'expired' | 'signed-out';
  /**
   * Where a knowledge base's stream was: for each scope, a resource's id, the
   * id of the last recorded event delivered on it.
   */
  LastEventIds: Record<
    components['schemas']['ResourceId'],
    components['schemas']['PersistedEventId']
  >;
  /**
   * Which looser search found a quoted selection, stated of a span whose
   * `anchorMethod` is `fuzzy-match` and only then. Which search finds it is
   * reconcile's rule (specs/src/annotations/reconcile-cases.json).
   */
  MatchQuality: 'normalized' | 'case-insensitive' | 'fuzzy';
  /**
   * What a search for what a reference could refer to is told beside the
   * reference and its context: MatchSearchRequest's other members.
   * client/surface.json's `match.search` cases state what is sent for one left
   * out.
   */
  MatchSearchOptions: {
    /** Maximum number of candidate results to return */
    limit?: number;
    /** Enable semantic similarity scoring in addition to keyword matching */
    useSemanticScoring?: boolean;
  };
  /**
   * A rectangle on a page of a PDF, in PDF points, from the page's bottom-left
   * corner with y increasing upward: what an RFC 3778 fragment selector names.
   */
  PdfCoordinate: {
    /** The page the rectangle is on. */
    page: number;
    /** The rectangle's x. */
    x: number;
    /** The rectangle's y. */
    y: number;
    /** The rectangle's width. */
    width: number;
    /** The rectangle's height. */
    height: number;
  };
  /**
   * The annotation a mark state unit is composing, from the selection a request
   * asked for, until it is submitted or cancelled.
   */
  PendingAnnotation: {
    selector: components['schemas']['AnnotationSelector'];
    motivation: components['schemas']['Motivation'];
  };
  /**
   * What a sign-in by a page redirect remembers across the trip to the issuer
   * and back: the verifier and the state the issuer's response must match,
   * where the person was connecting, what they believed they were connecting
   * to, and the issuer's endpoints, so its completion asks nothing twice.
   */
  PendingAuthorization: {
    /**
     * What the issuer's response must carry back to belong to this sign-in:
     * random, as base64url.
     */
    state: string;
    /**
     * The PKCE code verifier (RFC 7636) the authorization code is exchanged
     * with: random, as base64url.
     */
    verifier: string;
    /**
     * Where the issuer sends the person back to, named again when the code is
     * exchanged.
     */
    redirectUri: string;
    /** Where the person was connecting. */
    target: components['schemas']['HttpEndpoint'];
    /**
     * The issuer the knowledge base trusts, and the endpoints of it a client
     * uses.
     */
    issuer: PendingAuthorizationIssuer;
    /**
     * The registered knowledge base being signed in to again. Absent when it is
     * none.
     */
    kbId?: string;
    /**
     * The did of what the person believed they clicked, checked against the
     * answer and never assumed. Absent when they named nothing.
     */
    expectedDid?: string;
    /**
     * The name of what the person believed they clicked. Absent when they named
     * nothing.
     */
    expectedName?: string;
  };
  /** A request was refused for lack of permission. */
  PermissionDenied: {
    /** The refusal's own message, untranslated; null when it gave none. */
    detail: string | null;
  };
  /**
   * What uploading a resource is handed: its bytes, what the upload states of
   * them, and, for a clone, its token. Each member is as a caller holds it;
   * ResourceUpload is the multipart body the content transport sends of it.
   */
  PutBinaryRequest: {
    /** Human-readable resource name */
    name: string;
    /** Binary content */
    file: components['schemas']['Binary'];
    /** Media type of the content (e.g. text/plain, text/markdown, image/png) */
    format: string;
    /**
     * Where the content lives (file://... for local). Required — the client
     * names the location; the server does not derive one.
     */
    storageUri: string;
    /** ISO 639-1 language code */
    language?: string;
    entityTypes?: string[];
    sourceAnnotationId?: components['schemas']['AnnotationId'];
    sourceResourceId?: components['schemas']['ResourceId'];
    /** For AI-generated resources: the prompt that drove generation */
    generationPrompt?: string;
    /**
     * The Software peer that produced the content, when software did. Its
     * identity must be the emitter's own — the knowledge base refuses a
     * generator naming anyone else, and supplies it from the verified emitter
     * when omitted. `creator` and `wasAttributedTo` are never sent; the
     * knowledge base derives them from the emitter and the cited job.
     */
    generator?: components['schemas']['OneOrMoreAgents'];
    jobId?: components['schemas']['JobId'];
    isDraft?: boolean;
    /**
     * A clone token from `yield:clone-token-requested`. With it, the resource
     * is created as a clone of the token's source, inheriting its entity types;
     * `language`, `entityTypes` and the generation fields are then not read.
     */
    cloneToken?: string;
    archiveOriginal?: boolean;
  };
  /**
   * Words of a text, as a selection quotes them: the words themselves, and
   * maybe the text just before and just after them, which tell apart the places
   * they occur.
   */
  QuotedText: {
    /** The words quoted. */
    exact: string;
    /** The text just before them. */
    prefix?: string;
    /** The text just after them. */
    suffix?: string;
  };
  /**
   * Where a quoted selection was found in a text, and how it was found, told
   * apart by `anchorMethod`, one of AnchorMethod's words: a fuzzy match also
   * names its search, `matchQuality`, and no other states one.
   */
  ReconciledSpan:
    | ReconciledSpanUniqueMatch
    | ReconciledSpanContextRecovered
    | ReconciledSpanFirstOfMany
    | ReconciledSpanFuzzyMatch;
  /**
   * A resource's bytes as the content transport answers them, whole, with the
   * media type it answered with.
   */
  ResourceRepresentation: {
    /** The bytes, whole. */
    data: components['schemas']['Binary'];
    /** The media type the content transport answered with. */
    contentType: string;
  };
  /**
   * What a text search for resources is told beside its text:
   * MatchResourcesRequest's other members. client/surface.json's
   * `match.resources` cases state what is sent for one left out.
   */
  ResourceSearchFilters: {
    archived?: boolean;
    entityType?: string;
    /**
     * How many of the resources the search finds are passed over before the
     * page begins.
     */
    offset?: number;
    /** The most resources a page has. */
    limit?: number;
  };
  /**
   * Why a session ended: `expired`, the issuer refused to renew its token;
   * `refused`, the gateway refused a token its issuer had just issued.
   */
  SessionEndReason: 'expired' | 'refused';
  /** A session ended, and why. */
  SessionEnded: {
    /** Why it ended. */
    reason: records['SessionEndReason'];
  };
  /**
   * The entry a sign-in landed on, and what the person believed, so a host can
   * set the two against each other and say when they differ. The sign-in stands
   * either way: the knowledge base that answered is the one reached.
   */
  SignInOutcome: {
    /** The entry the sign-in made or signed in to again. */
    kb: components['schemas']['KnowledgeBase'];
    /**
     * What the person believed they were signing in to. Absent when they named
     * nothing.
     */
    expected?: records['Expected'];
  };
  /**
   * What a completed sign-in learned, as a registry is handed it to record:
   * where it was, who the knowledge base there says it is, the tokens, and what
   * the person believed they were signing in to.
   */
  SignedIn: {
    /** Where the sign-in was. */
    endpoint: components['schemas']['KbEndpoint'];
    /** What the knowledge base said of itself, asked with the new token. */
    description: components['schemas']['KbDescription'];
    /** The tokens, as a registry keeps them. */
    session: records['StoredSession'];
    /**
     * The registered knowledge base the person signed in to again. Absent when
     * it is none.
     */
    kbId?: string;
    /**
     * The did of what the person believed they clicked. Absent when they named
     * nothing.
     */
    expectedDid?: string;
    /**
     * The name of what the person believed they clicked. Absent when they named
     * nothing.
     */
    expectedName?: string;
  };
  /**
   * What is kept of a sign-in: the tokens an issuer issued, the client they
   * were issued to, and the issuer's endpoints a renewal and a sign-out need,
   * learned once at sign-in so no session asks again. TOKENS, never a password.
   * A stored value that lacks a member it requires is no session.
   */
  StoredSession: {
    /** The access token: short-lived, sent as a Bearer token. */
    access: string;
    /**
     * The refresh token: what renews the access token at the issuer without
     * another sign-in.
     */
    refresh: string;
    /**
     * The client the tokens were issued to, which a renewal and a revocation
     * name.
     */
    clientId: string;
    /** The issuer's token endpoint, where the refresh grant is made. */
    tokenEndpoint: string;
    /**
     * The issuer's revocation endpoint (RFC 7009), where a sign-out tells it to
     * forget the refresh token. Absent when the issuer has none.
     */
    revocationEndpoint?: string;
    /**
     * Who the gateway said the sign-in's person is, as the key their caches and
     * stream position are kept under (`lastEventIdKeyPrefix`), never the did
     * itself. Written once the gateway names the person, on the sign-in whose
     * token it was asked about; a renewal keeps it, a new sign-in starts
     * without it, and forgetting the sign-in, however it is forgotten, reads it
     * first to delete what is kept under it. Absent for a sign-in whose gateway
     * has not yet named its person.
     */
    personKey?: string;
  };
  /**
   * What checking one open resource against its knowledge base concluded.
   * `gone` is the only verdict that closes it, and it means the knowledge base
   * said the resource does not exist, not that the check failed: a failed
   * transport, a timeout and a peer that is down are each `unknown`, and an
   * unknown resource stays open.
   */
  TabCheck: TabCheckGone | TabCheckReady | TabCheckUnknown;
  /** What checking an open resource against its knowledge base concluded. */
  TabVerdict: 'gone' | 'ready' | 'unknown';
  /**
   * A span of a text: the code points from `start` up to but not including
   * `end`, the words they are, and maybe the text just before and just after
   * them.
   */
  TextSpan: {
    /**
     * The offset the span starts at, in Unicode code points from the text's
     * start.
     */
    start: number;
    /**
     * The offset just past the span, in Unicode code points from the text's
     * start.
     */
    end: number;
    /** The words quoted. */
    exact: string;
    /** The text just before them. */
    prefix?: string;
    /** The text just after them. */
    suffix?: string;
  };
  /**
   * What an upload reports as it goes, told apart by `phase`: its size first,
   * then the bytes sent so far, then the resource made.
   */
  UploadProgress:
    UploadProgressStarted | UploadProgressProgress | UploadProgressFinished;
  /** Why no launcher was found. */
  DiscoveryAbsentReason:
    /**
     * There is no document where it was looked for: no file, an HTTP status
     * that is not success, or a page that is not JSON.
     */
    | 'not-found'
    /** There is a document, and it is not JSON. */
    | 'not-json'
    /**
     * It is JSON, and not a discovery document: one entry that is not what the
     * schema says makes the whole document invalid, since a partial reading
     * would hide a running knowledge base without a trace.
     */
    | 'invalid'
    /**
     * It is a discovery document of a version this client does not speak, and
     * is not read in part.
     */
    | 'unsupported-version'
    /**
     * It could not be read at all: the file could not be opened or decoded, or
     * the request got no answer by its deadline.
     */
    | 'unreadable';
}

/** The tables the SDK carries as values, and what only they reach. */
export interface tables {
  /**
   * archivist/default-entity-types.json: the entity types an Archivist seeds,
   * in the order it seeds them.
   */
  ArchivistDefaultEntityTypes: {
    /** The rule the table states, in prose. */
    $comment: string;
    /** The default entity types, in seed order. */
    entityTypes: string[];
  };
  /** archivist/layout.json: where the Archivist keeps the record on disk. */
  ArchivistLayout: {
    /** The rule the table states, in prose. */
    $comment: string;
    /** A resource's event stream: a directory of event files. */
    eventStream: ArchivistLayoutEventStream;
    /**
     * The knowledge base's own stream, of the events that name no resource. It
     * is not sharded.
     */
    systemStream: ArchivistLayoutSystemStream;
    /** The files of a stream. */
    eventFile: ArchivistLayoutEventFile;
    /** The schema a stored event, one line of an event file, is. */
    storedEvent: unknown;
    /** A resource's view, in the state directory. */
    view: ArchivistLayoutView;
    /**
     * The projections of what the `__system__` stream adds up to, in the state
     * directory.
     */
    systemProjections: ArchivistLayoutSystemProjections;
    /**
     * An entry of the storage-uri index, which names the resource whose content
     * is at a storage URI.
     */
    storageUriIndex: ArchivistLayoutStorageUriIndex;
    /**
     * An entry of the anchored-text store, keyed by the checksum of the content
     * it was extracted from.
     */
    anchoredTextEntry: ArchivistLayoutAnchoredTextEntry;
    /**
     * The file holding the stamp the anchored-text store's entries are taken
     * under: the stamp, followed by a newline.
     */
    anchoredTextStamp: ArchivistLayoutAnchoredTextStamp;
  };
  /**
   * archivist/messages.json: the words of the Archivist's own refusals, and of
   * the messages it logs that a reader relies on.
   */
  ArchivistMessages: {
    /** The rule the table states, in prose. */
    $comment: string;
    /**
     * Each refusal to start of the Archivist's own, written in
     * service-environment/boot-refusals.json's `line`.
     */
    boot: ArchivistMessagesBootItem[];
    /**
     * The failure a reply that cannot be sent is answered with instead, on the
     * operation's failure channel.
     */
    unsent: ArchivistMessagesUnsentItem[];
    /** Each refusal of an operation, on the operation's failure channel. */
    refusals: ArchivistMessagesRefusalsItem[];
    /**
     * The refusal of every route of the HTTP surface but `/health`: a token
     * that is missing, or not of the knowledge base's issuer and audience, or
     * without the service role.
     */
    unauthorized: ArchivistMessagesUnauthorized;
    /** Each other error a route of the HTTP surface answers with. */
    http: ArchivistMessagesHttpItem[];
    /**
     * Each message the Archivist logs that a reader of its output relies on.
     */
    logged: ArchivistMessagesLoggedItem[];
  };
  /**
   * bus/reply-bounds.json: each list or map an operation's reply carries that
   * its own schema does not bound, and what bounds it.
   */
  BusReplyBounds: {
    /** The rule the table states, in prose. */
    $comment: string;
    /** Each operation, by its request's channel. */
    replies: {
      [key: string]: { [key: string]: BusReplyBoundsRepliesValueValue };
    };
  };
  /**
   * dispatcher/messages.json: the words of the dispatcher's own refusals, and
   * of the errors it writes into a job.
   */
  DispatcherMessages: {
    /** The rule the table states, in prose. */
    $comment: string;
    /**
     * Each refusal the dispatcher makes itself, on the operation's failure
     * channel.
     */
    refusals: DispatcherMessagesRefusalsItem[];
    /**
     * Each error the dispatcher writes into a job on its own, as a `job:fail`
     * would.
     */
    errors: DispatcherMessagesErrorsItem[];
  };
  /**
   * embedding/requests.json: how a service asks its embedding provider for the
   * vectors of many texts.
   */
  EmbeddingRequests: {
    /** The rule the table states, in prose. */
    $comment: string;
    /**
     * How each kind of provider is asked, by its `type` (EmbeddingConfig):
     * every kind, and no other.
     */
    providers: { [key: string]: EmbeddingRequestsProvidersValue };
    /**
     * How long each request has, counted from when it is sent and not from when
     * its batch began. Asking a busy provider again is within it.
     */
    requestSeconds: number;
    /**
     * A request for the vectors of documents that the provider answers busy is
     * asked again, after each wait in turn, while the request's own time allows
     * the wait. A provider busy at every asking fails the request with that
     * status. A query is asked once.
     */
    busy: EmbeddingRequestsBusy;
    /**
     * How many times, at most, a starting service asks again a provider that
     * answered 404, taken to be still fetching the model, or could not be
     * reached, taken to be still starting: within the time the service has to
     * start.
     */
    startAgain: number;
  };
  /** gateway/media-token.json: what a media token is. */
  GatewayMediaToken: {
    /** The rule the table states, in prose. */
    $comment: string;
    /** Its JOSE header, exactly. */
    header: GatewayMediaTokenHeader;
    /** Its claims beside `iat` and `exp`, each filled as the table says. */
    claims: GatewayMediaTokenClaims;
    /** `exp` less `iat`. */
    lifetimeSeconds: number;
  };
  /** gateway/messages.json: the words of the gateway's own refusals. */
  GatewayMessages: {
    /** The rule the table states, in prose. */
    $comment: string;
    /** Each refusal the gateway makes itself. */
    messages: GatewayMessagesMessagesItem[];
    /**
     * Each failure frame the gateway delivers itself, on the stream of the
     * client whose request it answers.
     */
    failures: GatewayMessagesFailuresItem[];
    /** The `WWW-Authenticate` of a 401. */
    challenges: GatewayMessagesChallenges;
  };
  /**
   * gateway/response-headers.json: the headers on every response the gateway
   * sends.
   */
  GatewayResponseHeaders: {
    /** The rule the table states, in prose. */
    $comment: string;
    /** Each header every response carries, and its value. */
    every: GatewayResponseHeadersEveryItem[];
    /** The header that names the request. */
    requestId: string;
    /** Each header no response carries. */
    absent: string[];
    /** How the gateway answers an `OPTIONS` request. */
    preflight: GatewayResponseHeadersPreflight;
  };
  /**
   * graph/schema.json: the shape of the graph a store keeps, as a reader of the
   * store finds it.
   */
  GraphSchema: {
    /** The rule the table states, in prose. */
    $comment: string;
    /** Each kind of node the graph holds. */
    nodes: GraphSchemaNodes;
    /** Each kind of relationship the graph holds. */
    relationships: GraphSchemaRelationships;
    /**
     * A link's target the graph has not been given yet: a node of its kind that
     * holds its key and the marker, `true`, and nothing else. A node without
     * the marker is no stub.
     */
    stub: GraphSchemaStub;
  };
  /** jobs/budgets.json: the retry budget of each job type. */
  JobsBudgets: {
    /** The rule the table states, in prose. */
    $comment: string;
    /** One row for each job type. */
    budgets: JobsBudgetsBudgetsItem[];
  };
  /** jobs/storage.json: where the job queue keeps its state on the broker. */
  JobsStorage: {
    /** The rule the table states, in prose. */
    $comment: string;
    /** The work-queue stream every job is published into. */
    stream: JobsStorageStream;
    /**
     * The durable consumer that delivers each job to the dispatcher holding its
     * lease.
     */
    consumer: JobsStorageConsumer;
    /** The KV bucket that keeps one record per job, keyed by the job's id. */
    bucket: JobsStorageBucket;
  };
  /**
   * retry/rules.json: what each of the four retry rules retries, as sets.
   * retry/cases.json's rows are examples of them.
   */
  RetryRules: {
    /** The rule the table states, in prose. */
    $comment: string;
    /** A boot pass or a bus request, asked about a response's status. */
    boot: RetryRulesBoot;
    /** A job's retry budget, asked about a response's status. */
    job: RetryRulesJob;
    /**
     * An HTTP client's request, asked about a response's status, the request's
     * method, and whether it carries an `Idempotency-Key`. It is retried at one
     * of `statuses` when it carries a key or its method is one of
     * `idempotentMethods`, and at no other status.
     */
    transport: RetryRulesTransport;
    /**
     * Exchanging a refresh token at its issuer, asked about the issuer's
     * answer.
     */
    refresh: RetryRulesRefresh;
  };
  /**
   * service-environment/boot-refusals.json: what a service writes when it
   * refuses to start on its configuration document or its environment.
   */
  ServiceEnvironmentBootRefusals: {
    /** The rule the table states, in prose. */
    $comment: string;
    /** The services that refuse to start so. */
    services: ServiceEnvironmentBootRefusalsServicesItem[];
    /**
     * The one line the service writes to stderr, its refusal in place of
     * `{refusal}`, before it exits.
     */
    line: string;
    /** The status it exits with. */
    exitCode: number;
    /** Each refusal. */
    refusals: ServiceEnvironmentBootRefusalsRefusalsItem[];
    /**
     * Each line of the refusal `invalid`: one for each way the document is not
     * its schema's.
     */
    members: ServiceEnvironmentBootRefusalsMembersItem[];
  };
  /**
   * service-environment/variables.json: every environment variable a Xynolog
   * service reads, beside its configuration document.
   */
  ServiceEnvironmentVariables: {
    /** The rule the table states, in prose. */
    $comment: string;
    variables: ServiceEnvironmentVariablesVariablesItem[];
  };
  /**
   * service-telemetry/log-lines.json: the lines a service writes to its log,
   * and the line of its supervisor it counts.
   */
  ServiceTelemetryLogLines: {
    /** The rule the table states, in prose. */
    $comment: string;
    /** The lines of a service's logger. */
    logger: ServiceTelemetryLogLinesLogger;
    /** A line of the bus log. */
    bus: ServiceTelemetryLogLinesBus;
    /** The line the supervisor writes when it starts a service. */
    supervisor: ServiceTelemetryLogLinesSupervisor;
  };
  /**
   * service-telemetry/telemetry.json: the telemetry each Xynolog service
   * exports over OTLP: its spans and metrics, the services that export each,
   * and the attributes each carries.
   */
  ServiceTelemetryTelemetry: {
    /** The rule the table states, in prose. */
    $comment: string;
    /**
     * The services that reach the bus through an SDK, and for each the SDK
     * transports it uses, or of a transport it uses part of, the rows it
     * exports.
     */
    sdk: { [key: string]: string[] };
    resource: ServiceTelemetryTelemetryResourceItem[];
    spans: ServiceTelemetryTelemetrySpansItem[];
    metrics: ServiceTelemetryTelemetryMetricsItem[];
  };
  /**
   * smelter/messages.json: the words of the Smelter's refusals, and of the
   * messages it logs that a reader relies on.
   */
  SmelterMessages: {
    /** The rule the table states, in prose. */
    $comment: string;
    /** Each refusal of an operation, on the operation's failure channel. */
    refusals: SmelterMessagesRefusalsItem[];
    /** Each message the Smelter logs that a reader of its output relies on. */
    logged: SmelterMessagesLoggedItem[];
  };
  /**
   * worker/answer-formats.json: the element of the array each kind of detection
   * asks a model for.
   */
  WorkerAnswerFormats: {
    /** The rule the table states, in prose. */
    $comment: string;
    formats: WorkerAnswerFormatsFormatsItem[];
  };
  /**
   * worker/messages.json: the words of a Worker service's refusals to start, of
   * the errors it fails a job with, and of the messages it logs that a reader
   * relies on.
   */
  WorkerMessages: {
    /** The rule the table states, in prose. */
    $comment: string;
    /**
     * Each refusal to start, written in
     * service-environment/boot-refusals.json's `line`.
     */
    boot: WorkerMessagesBootItem[];
    /** Each line of the `{reasons}` of `invalid`. */
    reasons: WorkerMessagesReasonsItem[];
    /**
     * How an error names the job, by its type, as `{job}`: `{motivation}` is a
     * mark job's motivation.
     */
    job: WorkerMessagesJob;
    /**
     * Each error a job is failed with that is the worker's own: the `error` of
     * its `job:fail`.
     */
    errors: WorkerMessagesErrorsItem[];
    /** Each `{detail}` of `unreadable`. */
    details: WorkerMessagesDetailsItem[];
    /** Each `{said}` of `wait-stated`. */
    waits: WorkerMessagesWaitsItem[];
    /**
     * Each message a Worker service logs that a reader of its output relies on.
     */
    logged: WorkerMessagesLoggedItem[];
  };
}

/** A resource's event stream: a directory of event files. */
export type ArchivistLayoutEventStream = {
  /**
   * The tree the file is in: `root`, the working tree, `stateHome`, the state
   * directory, or `anchoredTextDir`, the anchored-text store.
   */
  tree: ArchivistLayoutEventStreamTree;
  /** Its path in its tree, `/`-separated. */
  path: string;
};

/**
 * The tree the file is in: `root`, the working tree, `stateHome`, the state
 * directory, or `anchoredTextDir`, the anchored-text store.
 */
export type ArchivistLayoutEventStreamTree =
  'root' | 'stateHome' | 'anchoredTextDir';

/**
 * The knowledge base's own stream, of the events that name no resource. It is
 * not sharded.
 */
export type ArchivistLayoutSystemStream = {
  /**
   * The tree the file is in: `root`, the working tree, `stateHome`, the state
   * directory, or `anchoredTextDir`, the anchored-text store.
   */
  tree: ArchivistLayoutSystemStreamTree;
  /** Its path in its tree, `/`-separated. */
  path: string;
};

/**
 * The tree the file is in: `root`, the working tree, `stateHome`, the state
 * directory, or `anchoredTextDir`, the anchored-text store.
 */
export type ArchivistLayoutSystemStreamTree =
  'root' | 'stateHome' | 'anchoredTextDir';

/** The files of a stream. */
export type ArchivistLayoutEventFile = {
  /** A file's name, `{number}` its number in `digits` decimal digits. */
  name: string;
  /**
   * How many decimal digits a file's number is written in, with leading zeros.
   */
  digits: number;
  /**
   * The first file's number. It is created, empty, with the stream's directory.
   */
  first: number;
  /** The most events a file holds. */
  maxEvents: number;
};

/** A resource's view, in the state directory. */
export type ArchivistLayoutView = {
  /**
   * The tree the file is in: `root`, the working tree, `stateHome`, the state
   * directory, or `anchoredTextDir`, the anchored-text store.
   */
  tree: ArchivistLayoutViewTree;
  /** Its path in its tree, `/`-separated. */
  path: string;
  /** The schema a view is. */
  schema: unknown;
};

/**
 * The tree the file is in: `root`, the working tree, `stateHome`, the state
 * directory, or `anchoredTextDir`, the anchored-text store.
 */
export type ArchivistLayoutViewTree = 'root' | 'stateHome' | 'anchoredTextDir';

/**
 * The projections of what the `__system__` stream adds up to, in the state
 * directory.
 */
export type ArchivistLayoutSystemProjections = {
  /**
   * The tree the file is in: `root`, the working tree, `stateHome`, the state
   * directory, or `anchoredTextDir`, the anchored-text store.
   */
  tree: ArchivistLayoutSystemProjectionsTree;
  /** The directory that holds them, in its tree, `/`-separated. */
  path: string;
  /** Each projection's file. */
  files: ArchivistLayoutSystemProjectionsFilesItem[];
};

/**
 * The tree the file is in: `root`, the working tree, `stateHome`, the state
 * directory, or `anchoredTextDir`, the anchored-text store.
 */
export type ArchivistLayoutSystemProjectionsTree =
  'root' | 'stateHome' | 'anchoredTextDir';

export type ArchivistLayoutSystemProjectionsFilesItem = {
  /** The file's name. */
  name: string;
  /** The schema the projection is. */
  schema: unknown;
};

/**
 * An entry of the storage-uri index, which names the resource whose content is
 * at a storage URI.
 */
export type ArchivistLayoutStorageUriIndex = {
  /**
   * The tree the file is in: `root`, the working tree, `stateHome`, the state
   * directory, or `anchoredTextDir`, the anchored-text store.
   */
  tree: ArchivistLayoutStorageUriIndexTree;
  /** Its path in its tree, `/`-separated. */
  path: string;
  /** The schema an entry is. */
  schema: unknown;
};

/**
 * The tree the file is in: `root`, the working tree, `stateHome`, the state
 * directory, or `anchoredTextDir`, the anchored-text store.
 */
export type ArchivistLayoutStorageUriIndexTree =
  'root' | 'stateHome' | 'anchoredTextDir';

/**
 * An entry of the anchored-text store, keyed by the checksum of the content it
 * was extracted from.
 */
export type ArchivistLayoutAnchoredTextEntry = {
  /**
   * The tree the file is in: `root`, the working tree, `stateHome`, the state
   * directory, or `anchoredTextDir`, the anchored-text store.
   */
  tree: ArchivistLayoutAnchoredTextEntryTree;
  /** Its path in its tree, `/`-separated. */
  path: string;
  /** The schema an entry is. */
  schema: unknown;
};

/**
 * The tree the file is in: `root`, the working tree, `stateHome`, the state
 * directory, or `anchoredTextDir`, the anchored-text store.
 */
export type ArchivistLayoutAnchoredTextEntryTree =
  'root' | 'stateHome' | 'anchoredTextDir';

/**
 * The file holding the stamp the anchored-text store's entries are taken under:
 * the stamp, followed by a newline.
 */
export type ArchivistLayoutAnchoredTextStamp = {
  /**
   * The tree the file is in: `root`, the working tree, `stateHome`, the state
   * directory, or `anchoredTextDir`, the anchored-text store.
   */
  tree: ArchivistLayoutAnchoredTextStampTree;
  /** Its path in its tree, `/`-separated. */
  path: string;
};

/**
 * The tree the file is in: `root`, the working tree, `stateHome`, the state
 * directory, or `anchoredTextDir`, the anchored-text store.
 */
export type ArchivistLayoutAnchoredTextStampTree =
  'root' | 'stateHome' | 'anchoredTextDir';

export type ArchivistMessagesBootItem = {
  /** The situation's name. */
  name: string;
  /** When it is written, and what fills each `{name}` of its text. */
  situation: string;
  /**
   * The refusal, in place of the line's `{refusal}`. A `{name}` in it is filled
   * with what the row's `situation` names, and nothing else in it varies.
   */
  refusal: string;
};

export type ArchivistMessagesUnsentItem = {
  /** The situation's name. */
  name: string;
  /** When it is written, and what fills each `{name}` of its text. */
  situation: string;
  /**
   * The failure's `message`. A `{name}` in it is filled with what the row's
   * `situation` names, and nothing else in it varies.
   */
  message: string;
};

export type ArchivistMessagesRefusalsItem = {
  /** The situation's name. */
  name: string;
  /**
   * The operations it refuses: requests of bus/registry.json's operations that
   * the Archivist answers. `{channel}` in the message is the one refused.
   */
  operations: string[];
  /**
   * Machine-readable failure class, for consumers that must BRANCH on why a
   * command failed rather than log it. Optional and deliberately sparse: absent
   * means 'no class declared', and every existing failure stays that way. An
   * enum rather than a free string so the vocabulary has an owner — an
   * unconstrained code is a mirror with no gate, and adding one should be a
   * deliberate spec change. `message` remains the human-readable text and is
   * unaffected. Members: `peer-unavailable` — the channel this command was sent
   * on has no subscriber, i.e. the service that answers it has not connected
   * yet. Transient by nature (a peer still starting), which is what
   * distinguishes it from a refusal: retrying is the correct response.
   * `not-found` — the resource this command addressed does not exist in this
   * knowledge base. A verdict, not a symptom: it is emitted only where the
   * answer comes from the event store, which is the system of record, and never
   * from a projection that may merely be lagging. Deterministic, so unlike
   * `peer-unavailable` retrying is pointless — and consumers may act
   * destructively on it (the SDK deletes a restored tab). Absence is not
   * denial: a future 'exists, but not for you' must travel as its own code,
   * never as this one. `unauthorized` — that code: the caller is authenticated
   * but not permitted to do what it asked. A verdict about the CALLER, not the
   * resource, so retrying under the same credential cannot succeed and a
   * consumer must never spin on it; emitted by `job:claim` for a caller whose
   * token carries no worker role. `none-pending` — a declined claim, not an
   * error: the queue holds no pending job of the requested types. Nothing went
   * wrong; the one code a consumer PARKS on, meaning 'nothing to do until a
   * wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying
   * neither is unclassified — a malformed record or a missing injection — and a
   * consumer treats it as 'log it, assume nothing'.
   */
  code?: ArchivistMessagesRefusalsItemCode;
  /** When it is written, and what fills each `{name}` of its text. */
  situation: string;
  /**
   * The failure's `message`. A `{name}` in it is filled with what the row's
   * `situation` names, and nothing else in it varies.
   */
  message: string;
};

/**
 * Machine-readable failure class, for consumers that must BRANCH on why a
 * command failed rather than log it. Optional and deliberately sparse: absent
 * means 'no class declared', and every existing failure stays that way. An enum
 * rather than a free string so the vocabulary has an owner — an unconstrained
 * code is a mirror with no gate, and adding one should be a deliberate spec
 * change. `message` remains the human-readable text and is unaffected. Members:
 * `peer-unavailable` — the channel this command was sent on has no subscriber,
 * i.e. the service that answers it has not connected yet. Transient by nature
 * (a peer still starting), which is what distinguishes it from a refusal:
 * retrying is the correct response. `not-found` — the resource this command
 * addressed does not exist in this knowledge base. A verdict, not a symptom: it
 * is emitted only where the answer comes from the event store, which is the
 * system of record, and never from a projection that may merely be lagging.
 * Deterministic, so unlike `peer-unavailable` retrying is pointless — and
 * consumers may act destructively on it (the SDK deletes a restored tab).
 * Absence is not denial: a future 'exists, but not for you' must travel as its
 * own code, never as this one. `unauthorized` — that code: the caller is
 * authenticated but not permitted to do what it asked. A verdict about the
 * CALLER, not the resource, so retrying under the same credential cannot
 * succeed and a consumer must never spin on it; emitted by `job:claim` for a
 * caller whose token carries no worker role. `none-pending` — a declined claim,
 * not an error: the queue holds no pending job of the requested types. Nothing
 * went wrong; the one code a consumer PARKS on, meaning 'nothing to do until a
 * wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying neither
 * is unclassified — a malformed record or a missing injection — and a consumer
 * treats it as 'log it, assume nothing'.
 */
export type ArchivistMessagesRefusalsItemCode =
  'peer-unavailable' | 'not-found' | 'unauthorized' | 'none-pending';

/**
 * The refusal of every route of the HTTP surface but `/health`: a token that is
 * missing, or not of the knowledge base's issuer and audience, or without the
 * service role.
 */
export type ArchivistMessagesUnauthorized = {
  status: components['schemas']['HttpStatus'];
  /** The body's `error`. */
  error: string;
  /** The `WWW-Authenticate` header when a token was presented. */
  presented: string;
  /** The `WWW-Authenticate` header when none was. */
  absent: string;
};

export type ArchivistMessagesHttpItem = {
  /** The situation's name. */
  name: string;
  /** The route's method. */
  method: ArchivistMessagesHttpItemMethod;
  /** The route, as the Archivist's API names its path. */
  route: string;
  status: components['schemas']['HttpStatus'];
  /** The body's `code`, where it carries one. */
  code?: string;
  /** When it is written, and what fills each `{name}` of its text. */
  situation: string;
  /**
   * The body's `error`. A `{name}` in it is filled with what the row's
   * `situation` names, and nothing else in it varies.
   */
  error: string;
};

/** The route's method. */
export type ArchivistMessagesHttpItemMethod = 'GET' | 'PUT' | 'POST';

export type ArchivistMessagesLoggedItem = {
  /** The situation's name. */
  name: string;
  level: components['schemas']['LogLevel'];
  /** When it is written, and what fills each `{name}` of its text. */
  situation: string;
  /** The line's message, word for word. */
  message: string;
  /**
   * The fields the line is logged with whose form is stated, by name: each a
   * text whose `{name}` is filled as the row's `situation` says. The line may
   * carry others.
   */
  fields: { [key: string]: string };
};

export type BusReplyBoundsRepliesValueValue =
  BusReplyBoundsRepliesValueValueBy | BusReplyBoundsRepliesValueValueGrows;

/** A list or map bounded by a member of the request. */
export type BusReplyBoundsRepliesValueValueBy = {
  /**
   * The member of the request that bounds it: an array, or an integer with a
   * maximum.
   */
  by: string;
};

/** A list or map not yet bounded, which grows. */
export type BusReplyBoundsRepliesValueValueGrows = {
  /** What it grows with. */
  grows: string;
};

export type DispatcherMessagesRefusalsItem = {
  /** The situation's name. */
  name: string;
  /**
   * The operation it refuses: a request of bus/registry.json's operations that
   * the dispatcher answers.
   */
  operation: string;
  /**
   * Machine-readable failure class, for consumers that must BRANCH on why a
   * command failed rather than log it. Optional and deliberately sparse: absent
   * means 'no class declared', and every existing failure stays that way. An
   * enum rather than a free string so the vocabulary has an owner — an
   * unconstrained code is a mirror with no gate, and adding one should be a
   * deliberate spec change. `message` remains the human-readable text and is
   * unaffected. Members: `peer-unavailable` — the channel this command was sent
   * on has no subscriber, i.e. the service that answers it has not connected
   * yet. Transient by nature (a peer still starting), which is what
   * distinguishes it from a refusal: retrying is the correct response.
   * `not-found` — the resource this command addressed does not exist in this
   * knowledge base. A verdict, not a symptom: it is emitted only where the
   * answer comes from the event store, which is the system of record, and never
   * from a projection that may merely be lagging. Deterministic, so unlike
   * `peer-unavailable` retrying is pointless — and consumers may act
   * destructively on it (the SDK deletes a restored tab). Absence is not
   * denial: a future 'exists, but not for you' must travel as its own code,
   * never as this one. `unauthorized` — that code: the caller is authenticated
   * but not permitted to do what it asked. A verdict about the CALLER, not the
   * resource, so retrying under the same credential cannot succeed and a
   * consumer must never spin on it; emitted by `job:claim` for a caller whose
   * token carries no worker role. `none-pending` — a declined claim, not an
   * error: the queue holds no pending job of the requested types. Nothing went
   * wrong; the one code a consumer PARKS on, meaning 'nothing to do until a
   * wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying
   * neither is unclassified — a malformed record or a missing injection — and a
   * consumer treats it as 'log it, assume nothing'.
   */
  code?: DispatcherMessagesRefusalsItemCode;
  /** When it is written, and what fills each `{name}` of its text. */
  situation: string;
  /**
   * The failure's `message`. A `{name}` in it is filled with what the row's
   * `situation` names, and nothing else in it varies.
   */
  message: string;
};

/**
 * Machine-readable failure class, for consumers that must BRANCH on why a
 * command failed rather than log it. Optional and deliberately sparse: absent
 * means 'no class declared', and every existing failure stays that way. An enum
 * rather than a free string so the vocabulary has an owner — an unconstrained
 * code is a mirror with no gate, and adding one should be a deliberate spec
 * change. `message` remains the human-readable text and is unaffected. Members:
 * `peer-unavailable` — the channel this command was sent on has no subscriber,
 * i.e. the service that answers it has not connected yet. Transient by nature
 * (a peer still starting), which is what distinguishes it from a refusal:
 * retrying is the correct response. `not-found` — the resource this command
 * addressed does not exist in this knowledge base. A verdict, not a symptom: it
 * is emitted only where the answer comes from the event store, which is the
 * system of record, and never from a projection that may merely be lagging.
 * Deterministic, so unlike `peer-unavailable` retrying is pointless — and
 * consumers may act destructively on it (the SDK deletes a restored tab).
 * Absence is not denial: a future 'exists, but not for you' must travel as its
 * own code, never as this one. `unauthorized` — that code: the caller is
 * authenticated but not permitted to do what it asked. A verdict about the
 * CALLER, not the resource, so retrying under the same credential cannot
 * succeed and a consumer must never spin on it; emitted by `job:claim` for a
 * caller whose token carries no worker role. `none-pending` — a declined claim,
 * not an error: the queue holds no pending job of the requested types. Nothing
 * went wrong; the one code a consumer PARKS on, meaning 'nothing to do until a
 * wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying neither
 * is unclassified — a malformed record or a missing injection — and a consumer
 * treats it as 'log it, assume nothing'.
 */
export type DispatcherMessagesRefusalsItemCode =
  'peer-unavailable' | 'not-found' | 'unauthorized' | 'none-pending';

export type DispatcherMessagesErrorsItem = {
  /** The situation's name. */
  name: string;
  /** When it is written, and what fills each `{name}` of its text. */
  situation: string;
  /**
   * The `error` it writes into the job. A `{name}` in it is filled with what
   * the row's `situation` names, and nothing else in it varies.
   */
  error: string;
  failureClass: components['schemas']['FailureClass'];
};

export type EmbeddingRequestsProvidersValue = {
  /**
   * How many texts one request carries, at most: a batch is cut into slices of
   * this many, each one request, in the order of the texts.
   */
  textsPerRequest: number;
  /**
   * How many requests are made of the provider at once, however many resources
   * are being indexed.
   */
  atOnce: number;
};

/**
 * A request for the vectors of documents that the provider answers busy is
 * asked again, after each wait in turn, while the request's own time allows the
 * wait. A provider busy at every asking fails the request with that status. A
 * query is asked once.
 */
export type EmbeddingRequestsBusy = {
  /** The statuses by which a provider says it is busy. */
  statuses: number[];
  /** The wait before each asking again, in order. */
  againAfterSeconds: number[];
};

/** Its JOSE header, exactly. */
export type GatewayMediaTokenHeader = {
  alg: 'HS256';
  typ: 'JWT';
};

/** Its claims beside `iat` and `exp`, each filled as the table says. */
export type GatewayMediaTokenClaims = {
  purpose: 'media';
  iss: '{domain}';
  sub: '{resourceId}';
};

export type GatewayMessagesMessagesItem = {
  /** The situation's name. */
  name: string;
  status: components['schemas']['HttpStatus'];
  /**
   * Its `code`, where it carries one: a LimitRefusal's, or the transport code
   * errors/codes.json names for its status.
   */
  code?: string;
  /** When the gateway answers it, and what fills each `{name}` of its texts. */
  situation: string;
  /**
   * Its text. A `{name}` in it is filled with what the row's `situation` names,
   * and nothing else in it varies.
   */
  error: string;
  /** Its `hint`, where it carries one. */
  hint?: string;
};

export type GatewayMessagesFailuresItem = {
  /** The situation's name. */
  name: string;
  /** Its `code`. */
  code: string;
  /** When the gateway answers it, and what fills each `{name}` of its texts. */
  situation: string;
  /**
   * Its text. A `{name}` in it is filled with what the row's `situation` names,
   * and nothing else in it varies.
   */
  message: string;
};

/** The `WWW-Authenticate` of a 401. */
export type GatewayMessagesChallenges = {
  /**
   * For a request that presents no credential. The challenge. `{origin}` is the
   * origin the Unauthorized response names: `http://` and the request's `Host`,
   * or, for a request that names none, the gateway's `publicUrl`.
   */
  noCredential: string;
  /**
   * For a request whose credential, a bearer token or a media token, is
   * refused. The challenge. `{origin}` is the origin the Unauthorized response
   * names: `http://` and the request's `Host`, or, for a request that names
   * none, the gateway's `publicUrl`.
   */
  refused: string;
};

export type GatewayResponseHeadersEveryItem = {
  /** A header's name, as HTTP spells it; a receiver reads it in any case. */
  name: string;
  /** Its value, exactly. */
  value: string;
};

/** How the gateway answers an `OPTIONS` request. */
export type GatewayResponseHeadersPreflight = {
  status: components['schemas']['HttpStatus'];
  /** Each header it carries beside those of `every`, and its value. */
  headers: GatewayResponseHeadersPreflightHeadersItem[];
  /**
   * Each header it carries when the request carries the header it echoes, with
   * that header's value.
   */
  echoes: GatewayResponseHeadersPreflightEchoesItem[];
  /**
   * The value of the `Vary` it carries when it echoes a header: the request
   * headers it echoes.
   */
  vary: string;
};

export type GatewayResponseHeadersPreflightHeadersItem = {
  /** A header's name, as HTTP spells it; a receiver reads it in any case. */
  name: string;
  /** Its value, exactly. */
  value: string;
};

export type GatewayResponseHeadersPreflightEchoesItem = {
  /** A header's name, as HTTP spells it; a receiver reads it in any case. */
  name: string;
  /** The request's header whose value it carries. */
  of: string;
};

/** Each kind of node the graph holds. */
export type GraphSchemaNodes = {
  /**
   * A kind of node: its label, the codec row it holds, the property it is one
   * of its kind by, and the properties a reader finds one by.
   */
  resource: GraphSchemaNodesResource;
  /**
   * A kind of node: its label, the codec row it holds, the property it is one
   * of its kind by, and the properties a reader finds one by.
   */
  annotation: GraphSchemaNodesAnnotation;
  /**
   * A kind of node: its label, the codec row it holds, the property it is one
   * of its kind by, and the properties a reader finds one by.
   */
  entityType: GraphSchemaNodesEntityType;
};

/**
 * A kind of node: its label, the codec row it holds, the property it is one of
 * its kind by, and the properties a reader finds one by.
 */
export type GraphSchemaNodesResource = {
  /** Its label. */
  label: string;
  /**
   * The part of graph/codec-cases.json whose `properties` and `json` are the
   * node's properties. A node without one holds its key alone.
   */
  row?: string;
  /** The property no two nodes of its kind share. */
  key: string;
  /**
   * The properties other than its key that a reader finds a node of its kind
   * by.
   */
  lookups: string[];
};

/**
 * A kind of node: its label, the codec row it holds, the property it is one of
 * its kind by, and the properties a reader finds one by.
 */
export type GraphSchemaNodesAnnotation = {
  /** Its label. */
  label: string;
  /**
   * The part of graph/codec-cases.json whose `properties` and `json` are the
   * node's properties. A node without one holds its key alone.
   */
  row?: string;
  /** The property no two nodes of its kind share. */
  key: string;
  /**
   * The properties other than its key that a reader finds a node of its kind
   * by.
   */
  lookups: string[];
};

/**
 * A kind of node: its label, the codec row it holds, the property it is one of
 * its kind by, and the properties a reader finds one by.
 */
export type GraphSchemaNodesEntityType = {
  /** Its label. */
  label: string;
  /**
   * The part of graph/codec-cases.json whose `properties` and `json` are the
   * node's properties. A node without one holds its key alone.
   */
  row?: string;
  /** The property no two nodes of its kind share. */
  key: string;
  /**
   * The properties other than its key that a reader finds a node of its kind
   * by.
   */
  lookups: string[];
};

/** Each kind of relationship the graph holds. */
export type GraphSchemaRelationships = {
  /**
   * A kind of relationship: its type, the kind of node it goes from and the
   * kind it goes to, and what it says.
   */
  belongsTo: GraphSchemaRelationshipsBelongsTo;
  /**
   * A kind of relationship: its type, the kind of node it goes from and the
   * kind it goes to, and what it says.
   */
  references: GraphSchemaRelationshipsReferences;
  /**
   * A kind of relationship: its type, the kind of node it goes from and the
   * kind it goes to, and what it says.
   */
  taggedAs: GraphSchemaRelationshipsTaggedAs;
};

/**
 * A kind of relationship: its type, the kind of node it goes from and the kind
 * it goes to, and what it says.
 */
export type GraphSchemaRelationshipsBelongsTo = {
  /** Its type. */
  type: string;
  /** The kind of node it goes from, by its name under `nodes`. */
  from: string;
  /** The kind of node it goes to, by its name under `nodes`. */
  to: string;
  /** What one says. */
  says: string;
};

/**
 * A kind of relationship: its type, the kind of node it goes from and the kind
 * it goes to, and what it says.
 */
export type GraphSchemaRelationshipsReferences = {
  /** Its type. */
  type: string;
  /** The kind of node it goes from, by its name under `nodes`. */
  from: string;
  /** The kind of node it goes to, by its name under `nodes`. */
  to: string;
  /** What one says. */
  says: string;
};

/**
 * A kind of relationship: its type, the kind of node it goes from and the kind
 * it goes to, and what it says.
 */
export type GraphSchemaRelationshipsTaggedAs = {
  /** Its type. */
  type: string;
  /** The kind of node it goes from, by its name under `nodes`. */
  from: string;
  /** The kind of node it goes to, by its name under `nodes`. */
  to: string;
  /** What one says. */
  says: string;
};

/**
 * A link's target the graph has not been given yet: a node of its kind that
 * holds its key and the marker, `true`, and nothing else. A node without the
 * marker is no stub.
 */
export type GraphSchemaStub = {
  /** The kind of node a stub is, by its name under `nodes`. */
  node: string;
  /** The property that marks a stub. */
  marker: string;
};

export type JobsBudgetsBudgetsItem = {
  jobType: components['schemas']['JobType'];
  /**
   * How many times a failed attempt of a job of this type may be retried: its
   * record's `metadata.maxRetries`.
   */
  maxRetries: number;
};

/** The work-queue stream every job is published into. */
export type JobsStorageStream = {
  name: string;
  /**
   * The root of the subjects the stream captures: a job is published on
   * `<subjectRoot>.<jobType>`.
   */
  subjectRoot: string;
};

/**
 * The durable consumer that delivers each job to the dispatcher holding its
 * lease.
 */
export type JobsStorageConsumer = {
  durableName: string;
};

/** The KV bucket that keeps one record per job, keyed by the job's id. */
export type JobsStorageBucket = {
  name: string;
  /** The component schema each of the bucket's values is. */
  record: string;
};

/** A boot pass or a bus request, asked about a response's status. */
export type RetryRulesBoot = {
  /** The statuses the rule retries, in ascending order. */
  statuses: components['schemas']['HttpStatus'][];
};

/** A job's retry budget, asked about a response's status. */
export type RetryRulesJob = {
  /** The statuses the rule retries, in ascending order. */
  statuses: components['schemas']['HttpStatus'][];
  /**
   * Every status at or above this one is retried too. It is above every status
   * of `statuses`.
   */
  statusFrom: components['schemas']['HttpStatus'];
};

/**
 * An HTTP client's request, asked about a response's status, the request's
 * method, and whether it carries an `Idempotency-Key`. It is retried at one of
 * `statuses` when it carries a key or its method is one of `idempotentMethods`,
 * and at no other status.
 */
export type RetryRulesTransport = {
  /** The statuses the rule retries, in ascending order. */
  statuses: components['schemas']['HttpStatus'][];
  /**
   * The methods a repeat of which cannot cause a second effect (RFC 9110 §
   * 9.2.2), in capitals. A request's method is read in any case.
   */
  idempotentMethods: string[];
};

/**
 * Exchanging a refresh token at its issuer, asked about the issuer's answer.
 */
export type RetryRulesRefresh = {
  /** The statuses the rule retries, in ascending order. */
  statuses: components['schemas']['HttpStatus'][];
  /**
   * Every status at or above this one is retried too. It is above every status
   * of `statuses`.
   */
  statusFrom: components['schemas']['HttpStatus'];
  /** Whether the exchange is retried when the issuer gave no answer at all. */
  noResponse: boolean;
};

/** A Xynolog service, by its name. */
export type ServiceEnvironmentBootRefusalsServicesItem =
  | 'archivist'
  | 'dispatcher'
  | 'gateway'
  | 'librarian'
  | 'smelter'
  | 'weaver'
  | 'worker';

export type ServiceEnvironmentBootRefusalsRefusalsItem = {
  /** The situation's name. */
  name: string;
  /** When it is written, and what fills each `{name}` of its text. */
  situation: string;
  /**
   * Its text. A `{name}` in it is filled with what the row's `situation` names,
   * and nothing else in it varies.
   */
  refusal: string;
};

export type ServiceEnvironmentBootRefusalsMembersItem = {
  /** The situation's name. */
  name: string;
  /** When it is written, and what fills each `{name}` of its text. */
  situation: string;
  /** The line, filled as the row's `situation` says. */
  line: string;
};

export type ServiceEnvironmentVariablesVariablesItem = {
  /** The variable's name. */
  name: string;
  /** The services that read it. */
  services: ServiceEnvironmentVariablesVariablesItemServicesItem[];
  /** What reads it: the service's own code, or the OpenTelemetry SDK. */
  readBy: ServiceEnvironmentVariablesVariablesItemReadBy;
  /** What sets it where the launcher runs the service. */
  providedBy: ServiceEnvironmentVariablesVariablesItemProvidedBy;
  /** Whether the service refuses to start without it. */
  required: boolean;
  /** What it does. */
  effect: string;
};

/** A Xynolog service, by its name. */
export type ServiceEnvironmentVariablesVariablesItemServicesItem =
  | 'archivist'
  | 'dispatcher'
  | 'gateway'
  | 'librarian'
  | 'smelter'
  | 'weaver'
  | 'worker';

/** What reads it: the service's own code, or the OpenTelemetry SDK. */
export type ServiceEnvironmentVariablesVariablesItemReadBy =
  'service' | 'opentelemetry';

/** What sets it where the launcher runs the service. */
export type ServiceEnvironmentVariablesVariablesItemProvidedBy =
  'launcher' | 'image' | 'operator';

/** The lines of a service's logger. */
export type ServiceTelemetryLogLinesLogger = {
  /** The services whose document names a LogFormat. */
  services: ServiceTelemetryLogLinesLoggerServicesItem[];
  /** A line of the `json` format. */
  json: ServiceTelemetryLogLinesLoggerJson;
  /** A line of the `simple` format. */
  simple: string;
};

export type ServiceTelemetryLogLinesLoggerServicesItem =
  'archivist' | 'dispatcher' | 'gateway';

/** A line of the `json` format. */
export type ServiceTelemetryLogLinesLoggerJson = {
  /** Its first members, in order. */
  first: string[];
  /** The member that names the request a line was logged while answering. */
  requestId: string;
  /** The members that name the active trace and span, in that order. */
  trace: string[];
  /** Its last member: the moment. */
  last: string;
};

/** A line of the bus log. */
export type ServiceTelemetryLogLinesBus = {
  /** Its head. */
  line: string;
  /** What follows the head, in order, each where there is one. */
  parts: ServiceTelemetryLogLinesBusPartsItem[];
  /** Each operation a line names. */
  ops: string[];
};

export type ServiceTelemetryLogLinesBusPartsItem = {
  /** What it shows. */
  part: string;
  /** Its text. */
  text: string;
  /** How many characters of it are shown, from its first. */
  characters?: number;
};

/** The line the supervisor writes when it starts a service. */
export type ServiceTelemetryLogLinesSupervisor = {
  /** The line. */
  line: string;
  /** What a service counts the lines that hold of, for each of its lives. */
  counted: string;
};

/**
 * An attribute of the resource the services' spans and metrics are exported
 * under.
 */
export type ServiceTelemetryTelemetryResourceItem = {
  /** The attribute's key. */
  key: string;
  /** The services that export the row. */
  services: ServiceTelemetryTelemetryResourceItemServicesItem[];
  /** What the attribute says. */
  meaning: string;
  /**
   * Its value when nothing says another, with `{service}` the service's name.
   */
  default?: string;
};

/** A Xynolog service, by its name. */
export type ServiceTelemetryTelemetryResourceItemServicesItem =
  | 'archivist'
  | 'dispatcher'
  | 'gateway'
  | 'librarian'
  | 'smelter'
  | 'weaver'
  | 'worker';

export type ServiceTelemetryTelemetrySpansItem = {
  /**
   * The row's name; `{channel}` in it is the bus channel, and `{jobType}` the
   * job's type.
   */
  name: string;
  /** The services that export the row. */
  services: ServiceTelemetryTelemetrySpansItemServicesItem[];
  /** The span's kind, in OTLP's words. */
  kind: ServiceTelemetryTelemetrySpansItemKind;
  /** When the row arrives. */
  when: ServiceTelemetryTelemetrySpansItemWhen;
  /** What the row says. */
  meaning: string;
  /** The attributes the span carries. */
  attributes: ServiceTelemetryTelemetrySpansItemAttributesItem[];
};

/** A Xynolog service, by its name. */
export type ServiceTelemetryTelemetrySpansItemServicesItem =
  | 'archivist'
  | 'dispatcher'
  | 'gateway'
  | 'librarian'
  | 'smelter'
  | 'weaver'
  | 'worker';

/** The span's kind, in OTLP's words. */
export type ServiceTelemetryTelemetrySpansItemKind =
  'client' | 'consumer' | 'internal' | 'producer' | 'server';

/** When the row arrives. */
export type ServiceTelemetryTelemetrySpansItemWhen =
  'export' | 'traffic' | 'supervised' | 'fatal';

/** An attribute a row carries. */
export type ServiceTelemetryTelemetrySpansItemAttributesItem = {
  /** The attribute's key. */
  key: string;
  /**
   * When alone the attribute is carried: a row's attribute without it is
   * carried every time.
   */
  only?: string;
  /**
   * The only values it carries, each of the type it is carried as: a string or
   * a boolean.
   */
  values?: ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem[];
};

export type ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem =
  string | boolean;

export type ServiceTelemetryTelemetryMetricsItem = {
  /**
   * The row's name; `{channel}` in it is the bus channel, and `{jobType}` the
   * job's type.
   */
  name: string;
  /** The services that export the row. */
  services: ServiceTelemetryTelemetryMetricsItemServicesItem[];
  /** The metric's instrument. */
  instrument: ServiceTelemetryTelemetryMetricsItemInstrument;
  /** When the row arrives. */
  when: ServiceTelemetryTelemetryMetricsItemWhen;
  /** The only signal planes a gateway row arrives on. */
  planes?: ServiceTelemetryTelemetryMetricsItemPlanesItem[];
  /** What the row says. */
  meaning: string;
  /** The attributes the span carries. */
  attributes: ServiceTelemetryTelemetryMetricsItemAttributesItem[];
};

/** A Xynolog service, by its name. */
export type ServiceTelemetryTelemetryMetricsItemServicesItem =
  | 'archivist'
  | 'dispatcher'
  | 'gateway'
  | 'librarian'
  | 'smelter'
  | 'weaver'
  | 'worker';

/** The metric's instrument. */
export type ServiceTelemetryTelemetryMetricsItemInstrument =
  'counter' | 'up-down counter' | 'gauge' | 'histogram';

/** When the row arrives. */
export type ServiceTelemetryTelemetryMetricsItemWhen =
  'export' | 'traffic' | 'supervised' | 'fatal';

export type ServiceTelemetryTelemetryMetricsItemPlanesItem =
  'in-process' | 'nats';

/** An attribute a row carries. */
export type ServiceTelemetryTelemetryMetricsItemAttributesItem = {
  /** The attribute's key. */
  key: string;
  /**
   * When alone the attribute is carried: a row's attribute without it is
   * carried every time.
   */
  only?: string;
  /**
   * The only values it carries, each of the type it is carried as: a string or
   * a boolean.
   */
  values?: ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem[];
};

export type ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem =
  string | boolean;

export type SmelterMessagesRefusalsItem = {
  /** The situation's name. */
  name: string;
  /**
   * The operation it refuses: a request of bus/registry.json's operations that
   * the Smelter answers.
   */
  operation: string;
  /** When it is written, and what fills each `{name}` of its text. */
  situation: string;
  /**
   * The failure's `message`. A `{name}` in it is filled with what the row's
   * `situation` names, and nothing else in it varies.
   */
  message: string;
};

export type SmelterMessagesLoggedItem = {
  /** The situation's name. */
  name: string;
  level: components['schemas']['LogLevel'];
  /**
   * When it is written, what fills each `{name}` of its fields, and what each
   * fact it carries says.
   */
  situation: string;
  /** The line's message, word for word. */
  message: string;
  /**
   * The facts the line is logged with whose form is stated, by name: each a
   * text whose `{name}` is filled as the row's `situation` says. A fact that is
   * a number is its decimal digits.
   */
  fields: { [key: string]: string };
  /**
   * The facts the line is logged with beside `fields`, whose value the row's
   * `situation` says and whose form is not stated. The line may carry others.
   */
  carries: string[];
};

export type WorkerAnswerFormatsFormatsItem = {
  /** A motivation a `mark` job takes, or `count`. */
  name: string;
  /** What an element is, in prose. */
  about: string;
  /** The JSON Schema of one element of the answer. */
  element: unknown;
};

export type WorkerMessagesBootItem =
  | WorkerMessagesBootItemOwnBootRefusal
  | WorkerMessagesBootItemSharedBootRefusal;

export type WorkerMessagesBootItemOwnBootRefusal = {
  /** The situation's name. */
  name: string;
  /** When it is written, and what fills each `{name}` of its text. */
  situation: string;
  /**
   * The refusal, in place of the line's `{refusal}`. A `{name}` in it is filled
   * with what the row's `situation` names, and nothing else in it varies.
   */
  refusal: string;
};

export type WorkerMessagesBootItemSharedBootRefusal = {
  /** The situation's name. */
  name: string;
  /** When it is written. What fills its text is the shared row's. */
  situation: string;
  /**
   * The `name` of the row of service-environment/boot-refusals.json's
   * `refusals` that is this refusal, with `{service}` `worker` and `{schema}`
   * `WorkerConfig`.
   */
  bootRefusal: string;
};

export type WorkerMessagesReasonsItem = {
  /** The situation's name. */
  name: string;
  /** When it is written, and what fills each `{name}` of its text. */
  situation: string;
  /**
   * The line, indented by two spaces. A `{name}` in it is filled with what the
   * row's `situation` names, and nothing else in it varies.
   */
  line: string;
};

/**
 * How an error names the job, by its type, as `{job}`: `{motivation}` is a mark
 * job's motivation.
 */
export type WorkerMessagesJob = {
  mark: string;
  yield: string;
};

export type WorkerMessagesErrorsItem = {
  /** The situation's name. */
  name: string;
  /** When it is written, and what fills each `{name}` of its text. */
  situation: string;
  /**
   * The error. `{job}` in it is the job, as `job` names it. A `{name}` in it is
   * filled with what the row's `situation` names, and nothing else in it
   * varies.
   */
  error: string;
};

export type WorkerMessagesDetailsItem = {
  /** The situation's name. */
  name: string;
  /** When it is written, and what fills each `{name}` of its text. */
  situation: string;
  /**
   * The detail. A `{name}` in it is filled with what the row's `situation`
   * names, and nothing else in it varies.
   */
  detail: string;
};

export type WorkerMessagesWaitsItem = {
  /** The situation's name. */
  name: string;
  /** When it is written, and what fills each `{name}` of its text. */
  situation: string;
  /**
   * The wait, as the header stated it. A `{name}` in it is filled with what the
   * row's `situation` names, and nothing else in it varies.
   */
  said: string;
};

export type WorkerMessagesLoggedItem = {
  /** The situation's name. */
  name: string;
  level: components['schemas']['LogLevel'];
  /**
   * When it is written, what fills each `{name}` of its fields, and what each
   * fact it carries says.
   */
  situation: string;
  /** The line's message, word for word. */
  message: string;
  /**
   * The facts the line is logged with whose form is stated, by name: each a
   * text whose `{name}` is filled as the row's `situation` says. A fact that is
   * a number is its decimal digits.
   */
  fields: { [key: string]: string };
  /**
   * The facts the line is logged with beside `fields`, whose value the row's
   * `situation` says and whose form is not stated. The line may carry others.
   */
  carries: string[];
};

/** It answered as that entry, and its name and branch are on the entry now. */
export type KbReadVerdictRecorded = {
  kind: KbReadVerdictRecordedKind;
};

export type KbReadVerdictRecordedKind = records['KbReadKind'] & 'recorded';

/**
 * A different knowledge base answered. Its did and the name it gave itself are
 * here and nowhere else: the entry is as it was.
 */
export type KbReadVerdictConflict = {
  kind: KbReadVerdictConflictKind;
  /** The did the knowledge base that answered reported. */
  observedDid: string;
  /** The name the knowledge base that answered gave itself. */
  observedName: string;
};

export type KbReadVerdictConflictKind = records['KbReadKind'] & 'conflict';

/** It did not answer, or could not say who it is. Evidence of nothing. */
export type KbReadVerdictNoVerdict = {
  kind: KbReadVerdictNoVerdictKind;
};

export type KbReadVerdictNoVerdictKind = records['KbReadKind'] & 'no-verdict';

/**
 * The issuer the knowledge base trusts, and the endpoints of it a client uses.
 */
export type PendingAuthorizationIssuer = {
  /** The issuer's identifier. */
  issuer: string;
  /** The issuer's authorization endpoint, where the person is sent. */
  authorization: string;
  /** The issuer's token endpoint, where the code is exchanged. */
  token: string;
  /**
   * The issuer's device authorization endpoint (RFC 8628). Absent when the
   * issuer has none.
   */
  device?: string;
  /**
   * The issuer's revocation endpoint (RFC 7009). Absent when the issuer has
   * none.
   */
  revocation?: string;
};

/** The text has the words in exactly one place. */
export type ReconciledSpanUniqueMatch = {
  /**
   * The offset the span starts at, in Unicode code points from the text's
   * start.
   */
  start: number;
  /**
   * The offset just past the span, in Unicode code points from the text's
   * start.
   */
  end: number;
  /** The words quoted. */
  exact: string;
  /** The text just before them. */
  prefix?: string;
  /** The text just after them. */
  suffix?: string;
  anchorMethod: 'unique-match';
};

/**
 * The text has the words in more than one place, and the span is the first that
 * fits every hint the quote gave.
 */
export type ReconciledSpanContextRecovered = {
  /**
   * The offset the span starts at, in Unicode code points from the text's
   * start.
   */
  start: number;
  /**
   * The offset just past the span, in Unicode code points from the text's
   * start.
   */
  end: number;
  /** The words quoted. */
  exact: string;
  /** The text just before them. */
  prefix?: string;
  /** The text just after them. */
  suffix?: string;
  anchorMethod: 'context-recovered';
};

/**
 * The text has the words in more than one place, and the span is the first,
 * since the quote gave no hint or none fits.
 */
export type ReconciledSpanFirstOfMany = {
  /**
   * The offset the span starts at, in Unicode code points from the text's
   * start.
   */
  start: number;
  /**
   * The offset just past the span, in Unicode code points from the text's
   * start.
   */
  end: number;
  /** The words quoted. */
  exact: string;
  /** The text just before them. */
  prefix?: string;
  /** The text just after them. */
  suffix?: string;
  anchorMethod: 'first-of-many';
};

/**
 * The text has the words nowhere, and a looser search found the span:
 * `matchQuality` names which.
 */
export type ReconciledSpanFuzzyMatch = {
  /**
   * The offset the span starts at, in Unicode code points from the text's
   * start.
   */
  start: number;
  /**
   * The offset just past the span, in Unicode code points from the text's
   * start.
   */
  end: number;
  /** The words quoted. */
  exact: string;
  /** The text just before them. */
  prefix?: string;
  /** The text just after them. */
  suffix?: string;
  anchorMethod: 'fuzzy-match';
  matchQuality: records['MatchQuality'];
};

/** The knowledge base said the resource does not exist. */
export type TabCheckGone = {
  verdict: TabCheckGoneVerdict;
};

export type TabCheckGoneVerdict = records['TabVerdict'] & 'gone';

/** The knowledge base has the resource, and said what it is called now. */
export type TabCheckReady = {
  verdict: TabCheckReadyVerdict;
  /** The name the knowledge base gave the resource. */
  name: string;
  /** The media type of its primary representation. Absent when it said none. */
  mediaType?: string;
};

export type TabCheckReadyVerdict = records['TabVerdict'] & 'ready';

/** The check found out nothing. */
export type TabCheckUnknown = {
  verdict: TabCheckUnknownVerdict;
};

export type TabCheckUnknownVerdict = records['TabVerdict'] & 'unknown';

/** The upload began. */
export type UploadProgressStarted = {
  phase: 'started';
  /** How many bytes the upload is. */
  totalBytes: number;
};

/** Bytes were sent. */
export type UploadProgressProgress = {
  phase: 'progress';
  /** How many bytes are sent so far. */
  bytesUploaded: number;
  /** How many bytes the upload is. */
  totalBytes: number;
};

/** The upload ended, and the resource is made. */
export type UploadProgressFinished = {
  phase: 'finished';
  resourceId: components['schemas']['ResourceId'];
};

/**
 * Discriminant, sharing the `kind` field with the
 * ExtractedText/ExtractionDeclined members so the whole answer is one flat
 * union.
 *
 * `not-yet` — the resource's media type has text that is derived by reading its
 * content, and the store holds no entry for this content: the Smelter has not
 * read it yet, or the entry was lost (a loss the Smelter's reconcile pass
 * re-derives). RETRY.
 *
 * `no-map` — the resource's media type has no derived text, so no entry exists
 * and none will until the type is given a reader. Decided by the media type
 * alone, and answered at once. TERMINAL.
 *
 * `unknown` — no content identity to look up: the resource is not in the view
 * store, or its primary representation carries no checksum. TERMINAL.
 */
export type AnchoredTextAbsentKind = 'not-yet' | 'no-map' | 'unknown';

/** One line of text: the words that share a page, a baseline and a height. */
export type AnchoredTextExtractedEntryLinesItem = {
  /** The page, counted from 1. */
  p: number;
  /**
   * The line's vertical position in PDF points, from the bottom of the page.
   */
  y: number;
  /** The line's height in PDF points. */
  h: number;
  /**
   * Each word as `[x, width, start, end]`: its horizontal position and width in
   * PDF points, and the offsets of its text in `text`, which are whole numbers
   * of Unicode code points from the start of `text`.
   */
  words: number[][];
};

/**
 * W3C Web Annotation target: the id of the resource annotated, when the whole
 * of it is, or an object with source and optional selector (fragment)
 */
export type AnnotationTargetValue =
  | components['schemas']['ResourceId']
  | components['schemas']['AnnotationTarget'];

/**
 * The bounds on how far the staging driver may run behind the working tree, in
 * milliseconds. A knowledge base that does not sync git stages nothing, and
 * reads neither.
 */
export type ArchivistConfigStaging = {
  /**
   * The quiet period after the last change before pending changes are staged.
   */
  flushMs: number;
  /**
   * The longest a change waits to be staged while others keep arriving,
   * measured from the oldest pending change.
   */
  maxWaitMs: number;
};

/**
 * The engine each job is done with when software does it, keyed as a job
 * description is: by `jobType`, and for `mark` by motivation.
 */
export type ArchivistEnginesJobs = {
  /** The engine for `mark` jobs of each motivation. */
  mark?: ArchivistEnginesJobsMark;
  yield?: components['schemas']['Engine'];
};

/** The engine for `mark` jobs of each motivation. */
export type ArchivistEnginesJobsMark = {
  highlighting?: components['schemas']['Engine'];
  commenting?: components['schemas']['Engine'];
  assessing?: components['schemas']['Engine'];
  linking?: components['schemas']['Engine'];
  tagging?: components['schemas']['Engine'];
};

/** The engine each Librarian actor that calls a model asks. */
export type ArchivistEnginesActors = {
  gatherer?: components['schemas']['Engine'];
  matcher?: components['schemas']['Engine'];
};

export type ArchivistHealthActorsItem =
  'stower' | 'browser' | 'cloneTokenManager';

/** The stance the assessments are written from. */
export type AssessingJobParamsTone =
  'analytical' | 'critical' | 'balanced' | 'constructive';

export type AttributedEventValue = {
  /** Who `userId` is. */
  agent: components['schemas']['Agent'];
};

/** The type of body operation */
export type BindBodyOperationOp = 'add' | 'remove' | 'replace';

export type BrowseDirectoryFailedValue = {
  /** The path the read was asked for. */
  path: string;
};

export type BrowseDirectoryRequestSort = 'name' | 'mtime' | 'annotationCount';

export type BrowseEnginesResultResponse = {
  engines: components['schemas']['EngineEntry'][];
};

export type BrowseProfilesResultResponse = {
  /** Each profile, keyed by DID. */
  profiles: { [key: string]: components['schemas']['Profile'] };
};

export type BrowseResourceResultResponse = {
  resource: components['schemas']['ResourceDescriptor'];
  /**
   * The sequence number of the resource's last event. A graph read that follows
   * a write waits for the graph projection to reach it.
   */
  lastSequence: number;
};

/** How the Browser runs. */
export type BrowserSpec = {
  image: components['schemas']['Image'];
  resources: components['schemas']['Resources'];
  /**
   * The port the Browser is published on, on this machine's loopback: where a
   * person opens it, and the origin the issuer's realm allows its sign-in from.
   */
  port: number;
};

export type BusEventMessageId =
  | components['schemas']['PersistedEventId']
  | components['schemas']['ReplyEventId']
  | components['schemas']['EphemeralEventId'];

/**
 * `unparseable-last-event-id`: the watermark is not a PersistedEventId.
 * `scope-mismatch`: it names another scope. `retention-exceeded`: the record no
 * longer holds the events after it (what it still holds is replayed first).
 * `query-error`: the record could not be read.
 */
export type BusResumeGapReason =
  | 'unparseable-last-event-id'
  | 'scope-mismatch'
  | 'retention-exceeded'
  | 'query-error';

export type BusSubscribeRequestScopedItem = {
  /** Resource scope (a resourceId). */
  scope: components['schemas']['ResourceId'];
  /** Channels to subscribe within this scope. */
  channels: string[];
  /**
   * This scope's last-seen PersistedEventId. The gateway replays this scope's
   * persisted events after it — those on the entry's channels — before the live
   * tail, and writes a scoped `bus:resume-gap` (BusResumeGap) when it cannot
   * cover the gap.
   */
  lastEventId?: string;
};

/**
 * Machine-readable failure class, for consumers that must BRANCH on why a
 * command failed rather than log it. Optional and deliberately sparse: absent
 * means 'no class declared', and every existing failure stays that way. An enum
 * rather than a free string so the vocabulary has an owner — an unconstrained
 * code is a mirror with no gate, and adding one should be a deliberate spec
 * change. `message` remains the human-readable text and is unaffected. Members:
 * `peer-unavailable` — the channel this command was sent on has no subscriber,
 * i.e. the service that answers it has not connected yet. Transient by nature
 * (a peer still starting), which is what distinguishes it from a refusal:
 * retrying is the correct response. `not-found` — the resource this command
 * addressed does not exist in this knowledge base. A verdict, not a symptom: it
 * is emitted only where the answer comes from the event store, which is the
 * system of record, and never from a projection that may merely be lagging.
 * Deterministic, so unlike `peer-unavailable` retrying is pointless — and
 * consumers may act destructively on it (the SDK deletes a restored tab).
 * Absence is not denial: a future 'exists, but not for you' must travel as its
 * own code, never as this one. `unauthorized` — that code: the caller is
 * authenticated but not permitted to do what it asked. A verdict about the
 * CALLER, not the resource, so retrying under the same credential cannot
 * succeed and a consumer must never spin on it; emitted by `job:claim` for a
 * caller whose token carries no worker role. `none-pending` — a declined claim,
 * not an error: the queue holds no pending job of the requested types. Nothing
 * went wrong; the one code a consumer PARKS on, meaning 'nothing to do until a
 * wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying neither
 * is unclassified — a malformed record or a missing injection — and a consumer
 * treats it as 'log it, assume nothing'.
 */
export type CommandErrorCode =
  'peer-unavailable' | 'not-found' | 'unauthorized' | 'none-pending';

/** The voice the comments are written in. */
export type CommentingJobParamsTone =
  'scholarly' | 'explanatory' | 'conversational' | 'technical';

export type ConformanceCasePlanesItem = 'in-process' | 'nats';

/**
 * A live case's tier: `fleet`, what every SDK with a live layer does, or
 * `parity`, what one that implements all of CACHE-SEMANTICS does.
 */
export type ConformanceCaseTier = 'fleet' | 'parity';

/** The driver can take operations. */
export type ConformanceDriverLineReady = {
  /** Written once. */
  ready: true;
};

/** The operation succeeded. */
export type ConformanceDriverLineOk = {
  /** The operation's id. */
  id: number;
  ok: unknown;
};

/** The SDK failed the operation. */
export type ConformanceDriverLineFailed = {
  /** The operation's id. */
  id: number;
  /** The failure. */
  error: components['schemas']['ConformanceFailure'];
};

/** The suite abandoned the operation, and the SDK reported nothing else. */
export type ConformanceDriverLineAbandoned = {
  /** The operation's id. */
  id: number;
  /** It was abandoned. */
  abandoned: true;
};

/**
 * The driver has no such operation. It says so at once, before it reads its
 * next operation.
 */
export type ConformanceDriverLineUnsupported = {
  /** The operation's id. */
  id: number;
  /** It has none. */
  unsupported: true;
};

/**
 * The suite's arguments made no sense: the suite's mistake, never the SDK's.
 */
export type ConformanceDriverLineMisuse = {
  /** The operation's id. */
  id: number;
  /** What made no sense. */
  misuse: string;
};

/** The transport's connection state changed. */
export type ConformanceDriverLineState = {
  /**
   * The state it is in now: one a case's `state` step names
   * (ConformanceStep.json), or another the case never waits for.
   */
  state: string;
};

/** A frame was delivered on a channel the driver listens to. */
export type ConformanceDriverLineFrame = {
  /** The frame. */
  frame: ConformanceDriverLineFrameFrame;
};

/** The frame. */
export type ConformanceDriverLineFrameFrame = {
  /** The channel. */
  channel: string;
  payload?: unknown;
  /** The frame's correlation id, when it has one. */
  correlationId?: string;
  /** The frame's scope, when it has one. */
  scope?: components['schemas']['ResourceId'];
};

/** The error stream carried a failure. */
export type ConformanceDriverLineErrorStream = {
  /** The failure. */
  error: components['schemas']['ConformanceFailure'];
};

/** An upload reported how much of it has been sent. */
export type ConformanceDriverLineProgress = {
  /** The report. */
  progress: ConformanceDriverLineProgressProgress;
};

/** The report. */
export type ConformanceDriverLineProgressProgress = {
  /** The `upload` operation's id. */
  upload: number;
  /** How many bytes it has sent. */
  bytesUploaded: number;
  /** How many it will send. */
  totalBytes: number;
};

/** The live driver: an observer was given a state. */
export type ConformanceDriverLineEmission = {
  /** The emission. */
  emission: ConformanceDriverLineEmissionEmission;
};

/** The emission. */
export type ConformanceDriverLineEmissionEmission = {
  /** The observer. */
  observer: string;
  /** The state. */
  state: ConformanceDriverLineEmissionEmissionState;
};

/** The state. */
export type ConformanceDriverLineEmissionEmissionState =
  | ConformanceDriverLineEmissionEmissionStatePending
  | ConformanceDriverLineEmissionEmissionStateReady
  | ConformanceDriverLineEmissionEmissionStateFailed;

export type ConformanceDriverLineEmissionEmissionStatePending = {
  /** Nothing to show yet. */
  status: 'pending';
};

export type ConformanceDriverLineEmissionEmissionStateReady = {
  /** A value to show. */
  status: 'ready';
  value: unknown;
};

export type ConformanceDriverLineEmissionEmissionStateFailed = {
  /** The query failed. */
  status: 'failed';
  /** The failure. */
  error: components['schemas']['ConformanceFailure'];
};

/** The live driver: the observer's live query completed. */
export type ConformanceDriverLineCompleted = {
  /** The observer. */
  completed: string;
};

/** A worker driver: its worker claimed a job. */
export type ConformanceDriverLineClaimed = {
  /** The job, as the worker read the record. */
  claimed: { [key: string]: unknown };
};

/** A worker driver: a claim was refused. */
export type ConformanceDriverLineRefused = {
  /**
   * The refusal: with a code when the bus refused it, with none when the worker
   * did.
   */
  refused: components['schemas']['ConformanceFailure'];
};

/** A worker driver: a held job's cancellation was signalled. */
export type ConformanceDriverLineSignalled = {
  /** The job's id. */
  signalled: string;
};

/** A worker driver: a held job stalled. */
export type ConformanceDriverLineStalled = {
  /** The job's id. */
  stalled: string;
};

/** One SDK's drivers. */
export type ConformanceImplementationsSdksValue = {
  /**
   * How its wire driver is started. A command and its arguments, as the harness
   * starts it. An argument that starts with ./ or ../ is a path, resolved
   * against the manifest's own directory; every other is passed as written.
   */
  wire?: string[];
  /**
   * How its live driver is started, and the tier of the live corpus the SDK is
   * held to.
   */
  live?: ConformanceImplementationsSdksValueLive;
  /**
   * How its worker driver is started, when the SDK has a worker's surface
   * (conformance/worker/README.md). A command and its arguments, as the harness
   * starts it. An argument that starts with ./ or ../ is a path, resolved
   * against the manifest's own directory; every other is passed as written.
   */
  worker?: string[];
  /**
   * The wire cases its driver cannot be put through, by the case's name, each
   * with why. The suite holds an exemption as it holds a case: the driver must
   * answer unsupported to what the case asks, or the exemption is stale.
   */
  exempt?: { [key: string]: string };
};

/**
 * How its live driver is started, and the tier of the live corpus the SDK is
 * held to.
 */
export type ConformanceImplementationsSdksValueLive = {
  /**
   * How its live driver is started. A command and its arguments, as the harness
   * starts it. An argument that starts with ./ or ../ is a path, resolved
   * against the manifest's own directory; every other is passed as written.
   */
  command: string[];
  /**
   * A live case's tier: `fleet`, what every SDK with a live layer does, or
   * `parity`, what one that implements all of CACHE-SEMANTICS does.
   */
  tier: ConformanceImplementationsSdksValueLiveTier;
};

/**
 * A live case's tier: `fleet`, what every SDK with a live layer does, or
 * `parity`, what one that implements all of CACHE-SEMANTICS does.
 */
export type ConformanceImplementationsSdksValueLiveTier = 'fleet' | 'parity';

/** Name values for later steps. */
export type ConformanceStepLet = {
  /** Each name, and the value it takes. */
  let: { [key: string]: unknown };
};

/**
 * Ask the driver for an operation. It must succeed, with `returns` when given,
 * or fail with `fails`. With `as`, the step does not wait: a later `settles`
 * step does.
 */
export type ConformanceStepDriver = {
  /** The operation (conformance/sdk/README.md, "Operations"). */
  driver: string;
  /** The operation's arguments. */
  with?: { [key: string]: unknown };
  returns?: unknown;
  fails?: unknown;
  /** The operation's name, for the `settles` or `abandon` step that ends it. */
  as?: string;
};

/** Abandon an operation started with `as`, as its caller would. */
export type ConformanceStepAbandon = {
  /** The operation. */
  abandon: string;
};

/**
 * An operation started with `as` settles: it succeeded, with `returns` when
 * given; or failed with `fails`; or, `abandoned`, it ended because the case
 * abandoned it and reported nothing.
 */
export type ConformanceStepSettles = {
  /** The operation. */
  settles: string;
  returns?: unknown;
  fails?: unknown;
  /** It ended because the case abandoned it. */
  abandoned?: true;
};

/**
 * The next request the client put on the wire is this operation, with each
 * field given.
 */
export type ConformanceStepWire = {
  /** The operation of the gateway's API, by its method and path. */
  wire: string;
  /**
   * When it is read: on arrival, once answered (the default), or once its
   * stream has caught up.
   */
  at?: ConformanceStepWireAt;
  /** The status it was answered with. */
  status?: number;
  params?: unknown;
  body?: unknown;
  token?: unknown;
  /**
   * The request's headers named here, each as a pattern; headers not named are
   * not compared.
   */
  headers?: { [key: string]: unknown };
  answer?: unknown;
  /** The request's name, for a later step. */
  as?: string;
  /** A request named earlier, which was answered before this one arrived. */
  follows?: string;
  /**
   * A request named earlier, answered with a Retry-After, which this one waited
   * out.
   */
  waited?: string;
};

/**
 * When it is read: on arrival, once answered (the default), or once its stream
 * has caught up.
 */
export type ConformanceStepWireAt = 'arrival' | 'answer' | 'live';

/** The stream a wire step named has carried this frame to the client. */
export type ConformanceStepCarried = {
  /** The stream. */
  carried: string;
  is: unknown;
};

/**
 * The request a `wire` step named has ended with no answer reaching the client:
 * the client closed it, or the proxy kept the gateway's answer from it
 * (`answer-lost`).
 */
export type ConformanceStepClosed = {
  /** The request. */
  closed: string;
};

/**
 * An upload started with `as`, and not yet settled, has reported all of it
 * sent: every report states the same total, none states less than the one
 * before, and the last states the total.
 */
export type ConformanceStepProgress = {
  /** The upload. */
  progress: string;
};

/** The transport comes to report this state. */
export type ConformanceStepState = {
  /** The state. */
  state: ConformanceStepStateState;
};

/** The state. */
export type ConformanceStepStateState =
  | 'initial'
  | 'connecting'
  | 'open'
  | 'reconnecting'
  | 'degraded'
  | 'unauthenticated'
  | 'closed';

/**
 * The transport is in this state and has reported no other since the case last
 * read its state.
 */
export type ConformanceStepStays = {
  /** The state. */
  stays: ConformanceStepStaysStays;
};

/** The state. */
export type ConformanceStepStaysStays =
  | 'initial'
  | 'connecting'
  | 'open'
  | 'reconnecting'
  | 'degraded'
  | 'unauthenticated'
  | 'closed';

/** The next frame the client delivers on this channel is this one. */
export type ConformanceStepFrame = {
  /** The channel. */
  frame: string;
  is: unknown;
};

/**
 * The client delivers this many more frames on this channel. What they are is
 * held, as every frame is, to what the gateway sent.
 */
export type ConformanceStepFrames = {
  /** The channel. */
  frames: string;
  /** How many more. */
  count: number;
};

/** The next failure on the client's error stream is this one. */
export type ConformanceStepError = {
  error: unknown;
};

/**
 * The backend does something (conformance/sdk/README.md, "Backend directives").
 */
export type ConformanceStepBackend = {
  /** The directive. */
  backend: ConformanceStepBackendBackend;
  /** The directive's arguments. */
  with?: { [key: string]: unknown };
};

/** The directive. */
export type ConformanceStepBackendBackend =
  | 'listen'
  | 'emit'
  | 'record'
  | 'content'
  | 'description'
  | 'annotations'
  | 'anchored-text'
  | 'uploaded'
  | 'refuse'
  | 'unanswered'
  | 'answer-lost'
  | 'hold'
  | 'release'
  | 'rechunk'
  | 'carry'
  | 'cut'
  | 'down'
  | 'up'
  | 'archivist';

/** The client puts nothing more on the wire for this many milliseconds. */
export type ConformanceStepQuiet = {
  /** How long, in milliseconds. */
  quiet: number;
};

/** Live: an observer, named by `as`, begins observing a live query. */
export type ConformanceStepObserve = {
  /** The live query. */
  observe: ConformanceStepObserveObserve;
  /** The observer. */
  as: string;
};

/** The live query. */
export type ConformanceStepObserveObserve = {
  /** The live query, by its name in specs/src/client/refresh.json. */
  query: string;
  resource?: unknown;
  annotation?: unknown;
  search?: unknown;
  filters?: unknown;
};

/** Live: the observer stops observing. */
export type ConformanceStepLeave = {
  /** The observer. */
  leave: string;
};

/** Live: the observer comes to hold this state. */
export type ConformanceStepReaches = {
  /** The observer. */
  reaches: string;
  state: unknown;
};

/** Live: the state the observer holds now is this one. */
export type ConformanceStepHolds = {
  /** The observer. */
  holds: string;
  state: unknown;
};

/** Live: the observer's live query completes. */
export type ConformanceStepCompletes = {
  /** The observer. */
  completes: string;
};

/**
 * Live: the next requests the client makes of a service are these, in whatever
 * order it makes them.
 */
export type ConformanceStepFetches = {
  /** The requests. */
  fetches: ConformanceStepFetchesFetchesItem[];
};

export type ConformanceStepFetchesFetchesItem =
  | components['schemas']['ConformanceBusFetch']
  | components['schemas']['ConformanceHttpFetch'];

/** Live: the client's stream comes to name exactly these scopes. */
export type ConformanceStepScopes = {
  /** The scopes. */
  scopes: unknown[];
};

/**
 * A worker case: the next job the worker reports as claimed, as it read the
 * record.
 */
export type ConformanceStepClaimed = {
  claimed: unknown;
};

/** A worker case: the next refusal of a claim the worker reports. */
export type ConformanceStepRefused = {
  refused: unknown;
};

/**
 * A worker case: the next held job whose cancellation the worker says was
 * signalled.
 */
export type ConformanceStepSignalled = {
  signalled: unknown;
};

/** A worker case: the next held job the worker says has stalled. */
export type ConformanceStepStalled = {
  stalled: unknown;
};

/**
 * What the summary is of: the resource the annotation is on, and the
 * annotation's entity types.
 */
export type ContextualSummaryResponseRelevantFields = {
  resourceId: components['schemas']['ResourceId'];
  resourceName: string;
  entityTypes: string[];
};

export type ContextualSummaryResponseContext = {
  before?: string;
  selected: string;
  after?: string;
};

/**
 * Where the stack actually runs. "local": containers on this machine.
 * "codespace": a GitHub-hosted VM whose KB is port-forwarded here.
 */
export type DiscoveredKBPlacement = 'local' | 'codespace';

/**
 * The JetStream broker holding the job queue, whose layout is
 * specs/src/jobs/storage.json.
 */
export type DispatcherConfigQueue = {
  /** The broker's address (`host:port`, or several, comma-separated). */
  servers: string;
  /**
   * The environment variable holding the broker user, when the broker requires
   * one.
   */
  userEnv?: string;
  /**
   * The environment variable holding the broker password, when the broker
   * requires one.
   */
  passwordEnv?: string;
};

/**
 * The queue's clocks, in milliseconds. The launcher writes the values a
 * deployment runs with; a test harness shrinks them.
 */
export type DispatcherConfigTiming = {
  /**
   * How often the queue re-announces pending jobs and sweeps for dead workers.
   * The re-announcement is insurance against a lost wake-up, not dispatch.
   */
  tickMs: number;
  /**
   * How long a running job may go without progress, a checkpoint or a claim
   * before its worker is presumed dead.
   */
  staleRunningMs: number;
  /**
   * How long the broker waits, after this dispatcher stops renewing a job's
   * lease, before redelivering its message.
   */
  ackWaitMs: number;
  /** How long a concluded job is kept before it is deleted. */
  retentionMs: number;
  /** How often concluded jobs past `retentionMs` are deleted. */
  retentionSweepMs: number;
  /**
   * The least time between two progress writes for one job; reports closer
   * together than this are not written.
   */
  progressWriteIntervalMs: number;
  /**
   * How long the dispatcher waits at boot for the broker before it exits, so
   * that a restart policy can retry.
   */
  bootDeadlineMs: number;
};

/**
 * The inference provider: who serves the model. `anthropic`, `google`, `openai`
 * and `together` are those companies' own APIs. `llamacpp`, `ollama` and `vllm`
 * are servers a deployment runs or reaches, each named for the server's
 * software.
 */
export type EngineProvider =
  | 'anthropic'
  | 'google'
  | 'llamacpp'
  | 'ollama'
  | 'openai'
  | 'together'
  | 'vllm';

export type EnrichedResourceEventValue = {
  /**
   * Populated for events that mutate an annotation (mark:added,
   * mark:body-updated, mark:removed). Carries the post-materialization
   * annotation as it exists in the view, so subscribers can update local caches
   * in-place without refetching. Absent for events that don't touch
   * annotations.
   */
  annotation?: components['schemas']['Annotation'];
};

export type ExtractedTextValue = {
  /**
   * Discriminant — both ExtractionOutcome members carry `kind`, single-valued:
   * the category here, the detail in `method`.
   */
  kind: 'extracted';
  /** How the text was extracted. */
  method: components['schemas']['ExtractionMethod'];
  /** PDF classification, when the source was a PDF. */
  pdfClass?: components['schemas']['PdfClass'];
  /**
   * How well the engine read the pixels, when any of this text came from OCR.
   */
  ocrConfidence?: components['schemas']['OcrConfidence'];
  /**
   * 1-indexed pages this extraction could not read — present only for partially
   * covered documents (class C).
   */
  unreadPages?: number[];
};

/**
 * The latest sweep's phase: `pending` before its stream first opens, `running`,
 * `done`, or `due` where the record could not be listed and the sweep is tried
 * again.
 */
export type FollowerFollowingSweep = 'pending' | 'running' | 'done' | 'due';

/** The issuer this knowledge base trusts. */
export type GatewayConfigIdentity = {
  /** The issuer URL, exactly as tokens carry it in `iss`. */
  issuer: string;
  /**
   * The claim a person's DID is built from: `did:web:<domain>:users:<its
   * value>`.
   */
  subjectClaim: string;
};

/**
 * The signal plane: `in-process`, one gateway on its own fabric; or `nats`, the
 * fabric every replica on one broker shares, which requires `servers` and a
 * broker with JetStream.
 */
export type GatewayConfigSignal = {
  type: GatewayConfigSignalType;
  /**
   * The broker's address (`host:port`, or several, comma-separated). Required
   * for `nats`.
   */
  servers?: string;
  /**
   * The environment variable holding the broker user, when the broker requires
   * one.
   */
  userEnv?: string;
  /**
   * The environment variable holding the broker password, when the broker
   * requires one.
   */
  passwordEnv?: string;
};

export type GatewayConfigSignalType = 'in-process' | 'nats';

/**
 * What this gateway process can hold, from the memory its deployment gives it.
 * `queuedBytes`: the bytes queued for all its streams together; at it, a new
 * stream is refused with 503 (`AtCapacity`, code `capacity`) until the queues
 * drain — each stream's own bound is `x-xynolog-limits.pendingWriteBytes`.
 * `connections`: the connections it holds open at once; one past it is closed
 * unanswered. The launcher derives both from the memory it gives the gateway's
 * container.
 */
export type GatewayConfigCapacity = {
  queuedBytes: number;
  connections: number;
};

export type GatherFailedValue = {
  /** The annotation the gather was asked for. */
  annotationId: components['schemas']['AnnotationId'];
};

export type GatherResourceFailedValue = {
  /** The resource the gather was asked for. */
  resourceId: components['schemas']['ResourceId'];
};

/** The gather anchor. Discriminated on `kind`. */
export type GatheredContextFocus =
  GatheredContextFocusAnnotation | GatheredContextFocusResource;

/** Annotation-anchored focus. */
export type GatheredContextFocusAnnotation = {
  kind: 'annotation';
  /** The annotation this context was gathered for */
  annotation: components['schemas']['Annotation'];
  /** The resource containing the annotation */
  sourceResource: components['schemas']['ResourceDescriptor'];
  /** Text context around the annotation target */
  selected?: GatheredContextFocusAnnotationSelected;
  /**
   * User-provided hint to supplement or replace the selected text for search
   * and generation
   */
  userHint?: string;
  /**
   * The resource the annotation links to, if it is a resolved reference.
   * Dormant capability — produced/exposed but not yet consumed.
   */
  targetResource?: components['schemas']['ResourceDescriptor'];
  /**
   * Context about the annotation's link target. Dormant — produced/exposed but
   * not yet consumed.
   */
  targetContext?: GatheredContextFocusAnnotationTargetContext;
};

/** Text context around the annotation target */
export type GatheredContextFocusAnnotationSelected = {
  /** Text appearing before the selected passage */
  before?: string;
  /** The selected text passage (the annotation target) */
  text: string;
  /** Text appearing after the selected passage */
  after?: string;
};

/**
 * Context about the annotation's link target. Dormant — produced/exposed but
 * not yet consumed.
 */
export type GatheredContextFocusAnnotationTargetContext = {
  content: string;
  summary?: string;
};

/** Whole-resource focus. */
export type GatheredContextFocusResource = {
  kind: 'resource';
  /** The resource this context was gathered for */
  resource: components['schemas']['ResourceDescriptor'];
  summary?: string;
  suggestedReferences?: string[];
  /** Resource content (included when requested) */
  content?: GatheredContextFocusResourceContent;
};

/** Resource content (included when requested) */
export type GatheredContextFocusResourceContent = {
  /** Content of the focal resource */
  main?: string;
  /** Map of related resource IDs to their content */
  related?: { [key: string]: string };
};

/**
 * Semantically similar passages from across the knowledge base, found via
 * vector search
 */
export type GatheredContextSemanticContext = {
  /** Passages ranked by cosine similarity to the focal text */
  similar: components['schemas']['SemanticMatch'][];
  /**
   * Entity types excluded from this recall — a record of how `similar` was
   * filtered (e.g. ['Question'] so answer-generation never surfaces prior
   * questions). Absent when no exclusion was applied.
   */
  excludedEntityTypes?: string[];
};

/** Context metadata about the focal anchor and its source */
export type GatheredContextMetadata = {
  /** Type of source resource (e.g., 'document', 'image', 'video') */
  resourceType?: string;
  /** BCP 47 language tag of source content */
  language?: string;
  /** Entity types associated with the focal anchor */
  entityTypes?: string[];
  /**
   * Global frequency counts for entity types (for IDF-like weighting). A
   * KB-wide statistic, not a neighborhood property — kept here rather than on
   * the graph.
   */
  entityTypeFrequencies?: { [key: string]: number };
};

export type GenerationJobParamsValue = {
  /**
   * The gathered context that grounds the generation. Its `focus` names the
   * anchor: the DISPATCHER derives the job's resourceId from it (resource focus
   * → focus.resource; annotation focus → focus.sourceResource, with the worker
   * auto-binding to focus.annotation) and REJECTS a caller-supplied id — the
   * context is authoritative. Under `cite`, the ids its embedding carries are
   * the only valid citation targets.
   */
  context: components['schemas']['GatheredContext'];
};

export type GetReferencedByResponseReferencedByItemTarget = {
  /** ID of resource containing the reference */
  source: components['schemas']['ResourceId'];
  selector: GetReferencedByResponseReferencedByItemTargetSelector;
};

export type GetReferencedByResponseReferencedByItemTargetSelector = {
  /** The selected text that references this resource */
  exact: string;
};

/** What the gateway is reached over. */
export type HttpEndpointProtocol = 'http' | 'https';

/** The providers, and the engine for each job and each Librarian actor. */
export type InferenceSpec = {
  /** Each provider an engine names, and how it is reached. */
  providers: { [key: string]: components['schemas']['Provider'] };
  /**
   * The engine each job is done with when software does it, and the engine each
   * Librarian actor asks.
   */
  engines: components['schemas']['ArchivistEngines'];
};

export type InferenceLimitsResultResponse = {
  limits: components['schemas']['EngineLimits'][];
};

/**
 * The issuer, where it is published, and the database it keeps its realms in.
 */
export type IssuerSpec = {
  /** The issuer's driver: `keycloak`. */
  type: string;
  image: components['schemas']['Image'];
  resources: components['schemas']['Resources'];
  /**
   * The port the issuer is published on, on this machine: the origin of every
   * realm's `iss`, so the one number wherever the issuer is reached.
   */
  port: number;
  /** The database the issuer keeps its realms in. */
  database: IssuerSpecDatabase;
};

/** The database the issuer keeps its realms in. */
export type IssuerSpecDatabase = components['schemas']['Runner'] &
  unknown & {
    /** The database's driver: `postgres`. */
    type: string;
    /**
     * The database the issuer keeps its realms in: a lowercase PostgreSQL
     * identifier, as PostgreSQL itself names an unquoted one. On a PostgreSQL the
     * launcher runs, the launcher creates it; on one somebody else runs
     * (`external`), it must already exist there.
     */
    name: string;
    /** The user the issuer signs in as. */
    user: string;
    image?: components['schemas']['Image'];
    resources?: components['schemas']['Resources'];
    /**
     * The port a PostgreSQL the launcher runs is published on, on this machine,
     * where the issuer reaches it. One somebody else runs is reached at
     * `external`.
     */
    port?: number;
    /** A database somebody else runs. */
    external?: IssuerSpecDatabaseExternal;
  };

/** A database somebody else runs. */
export type IssuerSpecDatabaseExternal = {
  /** A host name or address the issuer can reach. */
  host: string;
  /** The port it listens on. */
  port: number;
  password: components['schemas']['SecretRef'];
};

/**
 * Why the resource could not be read. A CODE, not a sentence: the client owns
 * the wording, so a browser renders it in the user's language and the CLI
 * renders English terminal copy from the same value. A prose `message` composed
 * server-side would be English everywhere.
 */
export type JobDeclinedReason =
  'no-text-layer' | 'encrypted' | 'corrupt' | 'too-large' | 'empty';

/**
 * What the run is working on right now. `kind` is a CODE the client renders a
 * localized name for; `value` is KB data (an entity type, a tag category) shown
 * verbatim — the same split as `requestParams`. Absent on flows that iterate
 * nothing, such as generation.
 */
export type JobProgressCurrent = {
  /**
   * What sort of thing `value` is. Adding a variant means adding client copy
   * for it in every locale.
   */
  kind: JobProgressCurrentKind;
  /** The item itself, shown verbatim and never translated. */
  value: string;
};

/**
 * What sort of thing `value` is. Adding a variant means adding client copy for
 * it in every locale.
 */
export type JobProgressCurrentKind = 'entity-type' | 'category';

export type JobProgressCompletedItemsItem = {
  /** The item, shown verbatim. */
  value: string;
  /** Annotations found for it. */
  foundCount: number;
  /**
   * Annotations actually persisted for it — post-dedupe and
   * post-durability-acknowledgement, so it counts what the event log holds, not
   * what the model proposed. Beside foundCount this is the per-unit yield the
   * sizing work is judged by. Present on flows whose units persist as they
   * complete (a linking job); the tagging flow reports the same fact as
   * byCategory on its result, because its annotations are built after the
   * per-category loop.
   */
  persistedCount?: number;
  /**
   * Present only when pieces of this unit were accepted at the subdivision
   * floor while a count call said more was present. The unit completed, but
   * incompletely — this carries the EVIDENCE (found vs counted, over how many
   * pieces), never a judgment against any expected yield. Absent means
   * complete: genuinely absent, not defaulted.
   */
  underReported?: JobProgressCompletedItemsItemUnderReported;
};

/**
 * Present only when pieces of this unit were accepted at the subdivision floor
 * while a count call said more was present. The unit completed, but
 * incompletely — this carries the EVIDENCE (found vs counted, over how many
 * pieces), never a judgment against any expected yield. Absent means complete:
 * genuinely absent, not defaulted.
 */
export type JobProgressCompletedItemsItemUnderReported = {
  /** Floor-accepted pieces in this unit. */
  pieces: number;
  /**
   * Annotations extraction did find on those pieces — every span
   * write-time-verified.
   */
  found: number;
  /**
   * Mentions the count calls reported across those pieces (approximate by
   * nature).
   */
  counted: number;
};

export type JobProgressRequestParamsItem = {
  /** Which parameter this is. The client renders a localized name for it. */
  label: JobProgressRequestParamsItemLabel;
  /** The user's own input, shown verbatim. */
  value: string;
};

/** Which parameter this is. The client renders a localized name for it. */
export type JobProgressRequestParamsItemLabel =
  'entity-types' | 'instructions' | 'tone' | 'density';

export type JobStatusResponseStatus =
  'pending' | 'running' | 'complete' | 'failed' | 'cancelled';

/**
 * Where the stack actually runs. "local": containers on this machine.
 * "codespace": a GitHub-hosted VM whose KB is port-forwarded here.
 */
export type KnowledgeBaseStatusPlacement = 'local' | 'codespace';

export type KnowledgeGraphNodesItem =
  | components['schemas']['GraphResourceNode']
  | components['schemas']['GraphAnnotationNode'];

export type KnowledgeGraphEdgesItem = {
  source: string;
  target: string;
  /**
   * Edge kind: `annotation-of` (an annotation → the resource it lives on),
   * `cites` (a citing linking annotation → the focal resource), or `link` (a
   * resource → a resource it links to)
   */
  type: string;
  /**
   * Whether the connection goes both ways. Absent on a `link` edge found
   * through what cites a resource, which says nothing of the way back
   */
  bidirectional?: boolean;
  metadata?: { [key: string]: unknown };
};

/**
 * The indexes, the services that keep and read them, and the knowledge base
 * they index.
 */
export type KnowledgeIndexSpec = {
  /** The name of the KnowledgeBase document whose record this indexes. */
  knowledgeBase: string;
  logLevel: components['schemas']['LogLevel'];
  /**
   * The graph store the Weaver writes and the Librarian reads. The knowledge
   * base's graph is in the database its DID names
   * (specs/src/graph/database-cases.json): a Neo4j the launcher runs makes it
   * when it first starts, and one somebody else runs must already hold it.
   */
  graph: KnowledgeIndexSpecGraph;
  /**
   * The vector store the Smelter writes and the Librarian reads: the one the
   * launcher runs for the knowledge bases on a machine, at `shared`; one of the
   * knowledge base's own the launcher runs, from `image` with `resources`; or
   * somebody else's, at `external`. Exactly one of the three.
   */
  vectors: KnowledgeIndexSpecVectors;
  /**
   * The model that turns text into vectors. Vectors made by one model are not
   * comparable with another's, so the model is the index's.
   */
  embedding: KnowledgeIndexSpecEmbedding;
  /** The Librarian: it answers gathers and searches from the indexes. */
  librarian: KnowledgeIndexSpecLibrarian;
  /** The Smelter: it writes the vectors and the anchored text. */
  smelter: KnowledgeIndexSpecSmelter;
  /** The Weaver: it writes the graph. */
  weaver: KnowledgeIndexSpecWeaver;
};

/**
 * The graph store the Weaver writes and the Librarian reads. The knowledge
 * base's graph is in the database its DID names
 * (specs/src/graph/database-cases.json): a Neo4j the launcher runs makes it
 * when it first starts, and one somebody else runs must already hold it.
 */
export type KnowledgeIndexSpecGraph = components['schemas']['Runner'] & {
  /** The graph store's driver: `neo4j`. */
  type: string;
  /** The user the services sign in to the store as. */
  username: string;
  image?: components['schemas']['Image'];
  resources?: components['schemas']['Resources'];
  /** A graph store somebody else runs. */
  external?: KnowledgeIndexSpecGraphExternal;
};

/** A graph store somebody else runs. */
export type KnowledgeIndexSpecGraphExternal = {
  /** Where it listens: `bolt://host:port`. */
  uri: string;
  password: components['schemas']['SecretRef'];
};

/**
 * The vector store the Smelter writes and the Librarian reads: the one the
 * launcher runs for the knowledge bases on a machine, at `shared`; one of the
 * knowledge base's own the launcher runs, from `image` with `resources`; or
 * somebody else's, at `external`. Exactly one of the three.
 */
export type KnowledgeIndexSpecVectors = {
  /** The vector store's driver: `qdrant`. */
  type: string;
  /**
   * The vector store the launcher runs for the knowledge bases on a machine
   * (the state home's VectorStore document). Each knowledge base keeps its
   * index in collections of its own there, so nothing is said of it here.
   */
  shared?: Record<string, never>;
  image?: components['schemas']['Image'];
  resources?: components['schemas']['Resources'];
  /**
   * A vector store somebody else runs, with the token each service presents to
   * it: the Smelter's may make, write and delete this knowledge base's
   * collections, and the Librarian's may read them.
   */
  external?: KnowledgeIndexSpecVectorsExternal;
};

/**
 * A vector store somebody else runs, with the token each service presents to
 * it: the Smelter's may make, write and delete this knowledge base's
 * collections, and the Librarian's may read them.
 */
export type KnowledgeIndexSpecVectorsExternal = {
  /** A host name or address the stack's containers can reach. */
  host: string;
  /** The port its REST API listens on. */
  port: number;
  smelterToken: components['schemas']['SecretRef'];
  librarianToken: components['schemas']['SecretRef'];
};

/**
 * The model that turns text into vectors. Vectors made by one model are not
 * comparable with another's, so the model is the index's.
 */
export type KnowledgeIndexSpecEmbedding = {
  /** Who serves the model: `ollama`, or `voyage`. */
  type: string;
  /** The model, as its provider names it. */
  model: string;
  /** How a text is cut before it is embedded. */
  chunking: KnowledgeIndexSpecEmbeddingChunking;
  /**
   * Where the provider's API is reached. The shared Ollama is stated by no
   * endpoint.
   */
  endpoint?: string;
  apiKey?: components['schemas']['SecretRef'];
};

/** How a text is cut before it is embedded. */
export type KnowledgeIndexSpecEmbeddingChunking = {
  /** The size of a piece. */
  chunkSize: number;
  /** How much of one piece the next repeats. */
  overlap: number;
};

/** The Librarian: it answers gathers and searches from the indexes. */
export type KnowledgeIndexSpecLibrarian = {
  image: components['schemas']['Image'];
  resources: components['schemas']['Resources'];
  /** How a gather waits. */
  gather: KnowledgeIndexSpecLibrarianGather;
  /** What a search by meaning keeps. */
  search: KnowledgeIndexSpecLibrarianSearch;
};

/** How a gather waits. */
export type KnowledgeIndexSpecLibrarianGather = {
  /**
   * How long a gather waits for the Smelter to settle a resource, in
   * milliseconds.
   */
  settleTimeoutMs: number;
};

/** What a search by meaning keeps. */
export type KnowledgeIndexSpecLibrarianSearch = {
  /** The least similarity a hit by meaning must have. */
  semanticFloor: number;
};

/** The Smelter: it writes the vectors and the anchored text. */
export type KnowledgeIndexSpecSmelter = {
  image: components['schemas']['Image'];
  resources: components['schemas']['Resources'];
  /**
   * How many PDFs it works on at once. A page of a scan held for OCR is large;
   * one for each 2G of its memory is a reading of what fits.
   */
  pdfsAtOnce: number;
};

/** The Weaver: it writes the graph. */
export type KnowledgeIndexSpecWeaver = {
  image: components['schemas']['Image'];
  resources: components['schemas']['Resources'];
};

/** The bound on a gather. */
export type LibrarianConfigGather = {
  /**
   * How long a gather around a resource waits for the Smelter's decision on it
   * before answering without similar passages, in milliseconds.
   */
  settleTimeoutMs: number;
};

/** The bound on a search by meaning. */
export type LibrarianConfigSearch = {
  /** The least similarity a hit by meaning must have. */
  semanticFloor: number;
};

export type LibrarianHealthActorsItem = 'matcher' | 'gatherer';

export type LimitRefusalValue = {
  /**
   * `streams`: the principal already holds as many streams as its coefficient
   * of `x-xynolog-limits.streamsPerPrincipal` allows. `emit-rate`: the
   * principal's emits have used its bucket, whose rate and burst are its
   * coefficient of `x-xynolog-limits.emitsPerPrincipal`, per gateway process.
   * `unanswered-requests`: the client already awaits as many replies as
   * `BusSubscribeRequest.pendingReplies` may name. `capacity`: the gateway
   * holds as many queued bytes as it can. `refusal-rate`: the request's
   * credential was refused, and the requests its holder has had refused have
   * used their allowance; it answers only a request whose token has already
   * failed verification, so it says what a 401 says, and a client that can
   * renew its token renews it and sends the request again rather than waiting
   * (contract/TRANSPORT-CONTRACT.md § A refused credential).
   */
  code: LimitRefusalValueCode;
};

/**
 * `streams`: the principal already holds as many streams as its coefficient of
 * `x-xynolog-limits.streamsPerPrincipal` allows. `emit-rate`: the principal's
 * emits have used its bucket, whose rate and burst are its coefficient of
 * `x-xynolog-limits.emitsPerPrincipal`, per gateway process.
 * `unanswered-requests`: the client already awaits as many replies as
 * `BusSubscribeRequest.pendingReplies` may name. `capacity`: the gateway holds
 * as many queued bytes as it can. `refusal-rate`: the request's credential was
 * refused, and the requests its holder has had refused have used their
 * allowance; it answers only a request whose token has already failed
 * verification, so it says what a 401 says, and a client that can renew its
 * token renews it and sends the request again rather than waiting
 * (contract/TRANSPORT-CONTRACT.md § A refused credential).
 */
export type LimitRefusalValueCode =
  'streams' | 'emit-rate' | 'unanswered-requests' | 'capacity' | 'refusal-rate';

/** What the commit persisted. */
export type MarkCommitOkResponse = {
  /**
   * Annotations the command named that are durable in the event log. Equals the
   * batch size on success, on a first commit and on a retry alike — the commit
   * appends only what the resource does not already hold, so a wholly-redundant
   * retry has still succeeded and says so. Not an append tally: a caller must
   * never have to read a 0 as 'all good'.
   */
  persisted: number;
  /** Ids the batch covers, whether appended now or already present. */
  annotationIds: components['schemas']['AnnotationId'][];
};

/** The deleted annotation's identity. */
export type MarkDeleteOkResponse = {
  annotationId: components['schemas']['AnnotationId'];
};

export type MarkJobFilterParams = {
  motivation: components['schemas']['Motivation'];
};

/**
 * What kind of answer this is: 'lexical' — the resources matched the query
 * text; 'semantic' — no lexical match existed, and these resources discuss the
 * query per the vector index. Required so every producer labels its answer; a
 * UI can render semantic results as a different kind of page ('no title
 * matches, but these documents discuss it').
 */
export type MatchResourcesResponseMatchKind = 'lexical' | 'semantic';

export type MatchSearchFailedValue = {
  /** The reference the search was asked for. */
  referenceId: components['schemas']['AnnotationId'];
};

/**
 * What the line is: narration (log, note), an outcome (ok, warn, fail), a
 * heading (banner, section), a timestamp (stamp), a runtime command about to
 * run (command), or text the operation printed (output).
 */
export type ProgressKind =
  | 'log'
  | 'note'
  | 'ok'
  | 'warn'
  | 'fail'
  | 'banner'
  | 'section'
  | 'stamp'
  | 'command'
  | 'output';

/** The knowledge base's name. */
export type ProjectConfigProject = {
  /** The knowledge base's name, which decides where its state is kept. */
  name: string;
  /** A version the knowledge base's author gives it. Nothing changes it. */
  version?: string;
};

/** How the knowledge base's changes reach git. */
export type ProjectConfigGit = {
  /**
   * Whether changes to the working tree and the event log are staged in git as
   * they are made.
   */
  sync: boolean;
};

/** The knowledge base's identity. */
export type ProjectConfigSite = {
  /**
   * The knowledge base's permanent identity, in did:web's colon-path form
   * (`owner.github.io:repo`): stamped into every event it records, so never a
   * machine's address and never changed. With no white space in it, which no
   * DID holds (UserId.json).
   */
  domain: string;
  /** The name people see for the knowledge base. */
  siteName: string;
};

/**
 * Semantics of this rendition relative to the resource (e.g., original,
 * thumbnail, preview, derived).
 */
export type RepresentationRel =
  'original' | 'thumbnail' | 'preview' | 'optimized' | 'derived' | 'other';

export type RepresentationNotFoundValue = {
  code: RepresentationNotFoundValueCode;
};

export type RepresentationNotFoundValueCode = 'resource' | 'representation';

/**
 * What this resource was generated from: the resource, and the annotation on it
 * when the generation was for one. The resource's descriptor names the resource
 * as `wasDerivedFrom`.
 */
export type ResourceCreatedPayloadGeneratedFrom = {
  resourceId: components['schemas']['ResourceId'];
  annotationId?: components['schemas']['AnnotationId'];
};

/** JSON-LD context; URI, object, or array of these. */
export type ResourceDescriptorContext =
  string | { [key: string]: unknown } | ResourceDescriptorContextItem[];

export type ResourceDescriptorContextItem = string | { [key: string]: unknown };

/** Persistent identifiers (e.g., DOI, URN). */
export type ResourceDescriptorIdentifier =
  string | string[] | ResourceDescriptorIdentifierObject;

export type ResourceDescriptorIdentifierObject = {
  '@id'?: string;
  value?: string;
  scheme?: string;
} & { [key: string]: unknown };

/**
 * W3C PROV: the resource, or resources, this one was derived from, each by its
 * id
 */
export type ResourceDescriptorWasDerivedFrom =
  components['schemas']['ResourceId'] | components['schemas']['ResourceId'][];

/** Managed or referenced byte-level renditions of this resource. */
export type ResourceDescriptorRepresentations =
  | components['schemas']['Representation']
  | components['schemas']['Representation'][];

/** The most a container may use. */
export type ResourcesLimits = {
  /**
   * The memory ceiling: a whole number of gigabytes or megabytes, `8G` or
   * `512M`.
   */
  memory: string;
};

/**
 * Where the stack actually runs. "local": containers on this machine.
 * "codespace": a GitHub-hosted VM whose KB is port-forwarded here.
 */
export type RootPlacement = 'local' | 'codespace';

/**
 * For a local root: how the control server's own directory selects it, when it
 * does — standing in it (cwd), or XYNOLOG_ROOT.
 */
export type RootCurrent = 'cwd' | 'xynolog-root';

/** Inference provider for the generated local stack documents. */
export type RootsInitParamsInference = 'anthropic' | 'ollama';

export type ScoredResourceValue = {
  /** Relevance score assigned by the matcher; higher is a better candidate. */
  score?: number;
  /** Human-readable reason for the match. */
  matchReason?: string;
};

/**
 * term: SIGTERM, and SIGKILL 15 seconds later if it has not exited. kill:
 * SIGKILL, so nothing it would settle on the way out is settled.
 */
export type ServiceSignalParamsSignal = 'term' | 'kill';

/**
 * running: its container runs. stopped: its container exists and does not run
 * (containerState says how). reachable, unreachable: somebody else runs it, and
 * its endpoint answers or does not. absent: there is no container of it.
 * not-configured: the stack's documents ask for none.
 */
export type ServiceStatusState =
  | 'running'
  | 'stopped'
  | 'reachable'
  | 'unreachable'
  | 'absent'
  | 'not-configured';

/**
 * valid: the stack's gateway accepts the stored token. expired: it refuses it
 * (a refresh, or xynolog login, renews it). unverified: the stack did not
 * answer. none: nothing is stored.
 */
export type SessionState = 'valid' | 'expired' | 'unverified' | 'none';

/** What it applies to: every knowledge base on this machine, or one. */
export type SettingAppliesTo = 'machine' | 'knowledge-base';

/**
 * Whose document: the Browser's, the worker's, the issuer's or the vector
 * store's.
 */
export type SettingsPathParamsDocument =
  'browser' | 'worker' | 'issuer' | 'vectors';

export type SettingsThemeChangedEventTheme = 'light' | 'dark' | 'system';

export type SmeltSettledOutcome = 'indexed' | 'skipped';

/** Why the content was skipped. */
export type SmeltSettledReason =
  | 'no-extractor'
  | 'empty'
  | 'no-text-layer'
  | 'encrypted'
  | 'corrupt'
  | 'too-large';

/**
 * The state of its own stream of the record, one of the seven of
 * TRANSPORT-HTTP.md § Connection lifecycle. Events are delivered to it while it
 * is `open`.
 */
export type SmelterHealthStream =
  | 'initial'
  | 'connecting'
  | 'open'
  | 'reconnecting'
  | 'degraded'
  | 'unauthenticated'
  | 'closed';

/**
 * How far the latest reconcile has got: the pass's `summary` when it is done,
 * or its `error` when it failed.
 */
export type SmelterHealthReconcile = {
  phase: SmelterHealthReconcilePhase;
  /** What the pass came to. */
  summary?: components['schemas']['SmelterReconcileSummary'];
  /** Why it failed. */
  error?: string;
};

export type SmelterHealthReconcilePhase =
  'pending' | 'running' | 'done' | 'failed';

/** What the Smelter holds its index to, and what this start did for that. */
export type SmelterHealthIndex = {
  /** The model and the cut it makes an index by. */
  stamp: SmelterHealthIndexStamp;
  /**
   * Whether this start made the index again, as it does where the index stated
   * another stamp, or none.
   */
  madeAnew: boolean;
};

/** The model and the cut it makes an index by. */
export type SmelterHealthIndexStamp = {
  /** The embedding provider's kind and model. */
  embedding: SmelterHealthIndexStampEmbedding;
  chunking: components['schemas']['SmelterChunking'];
};

/** The embedding provider's kind and model. */
export type SmelterHealthIndexStampEmbedding = {
  type: string;
  model: string;
};

/** The knowledge base's services, and how each runs. */
export type StackKnowledgeBaseSpec = {
  logLevel: components['schemas']['LogLevel'];
  /**
   * The Gateway: where every client and every service reaches the knowledge
   * base.
   */
  gateway: StackKnowledgeBaseSpecGateway;
  /** The Dispatcher: it hands queued jobs to workers. */
  dispatcher: StackKnowledgeBaseSpecDispatcher;
  /**
   * The Archivist: it keeps the knowledge base's record in its working tree.
   */
  archivist: StackKnowledgeBaseSpecArchivist;
  /**
   * The broker the job queue and the signal plane share: the launcher's, run
   * from `image`, or somebody else's, at `external`.
   */
  messaging: StackKnowledgeBaseSpecMessaging;
  /**
   * The issuer the knowledge base trusts: the one the launcher runs for the
   * knowledge bases on a machine, at `shared`, with the knowledge base's own
   * realm in it, or somebody else's, at `external`.
   */
  issuer: StackKnowledgeBaseSpecIssuer;
};

/**
 * The Gateway: where every client and every service reaches the knowledge base.
 */
export type StackKnowledgeBaseSpecGateway = {
  image: components['schemas']['Image'];
  resources: components['schemas']['Resources'];
  /** The port the Gateway is published on. */
  port: number;
  /**
   * Where clients reach the Gateway: the server its API document names. A
   * service of the stack reaches it where the launcher places it, on `port`.
   */
  publicURL: string;
};

/** The Dispatcher: it hands queued jobs to workers. */
export type StackKnowledgeBaseSpecDispatcher = {
  image: components['schemas']['Image'];
  resources: components['schemas']['Resources'];
};

/** The Archivist: it keeps the knowledge base's record in its working tree. */
export type StackKnowledgeBaseSpecArchivist = {
  image: components['schemas']['Image'];
  resources: components['schemas']['Resources'];
  /**
   * Where the stack's services reach the Archivist, when that is somewhere the
   * launcher cannot see. Absent, they reach it where the launcher places it.
   */
  address?: components['schemas']['HostPort'];
};

/**
 * The broker the job queue and the signal plane share: the launcher's, run from
 * `image`, or somebody else's, at `external`.
 */
export type StackKnowledgeBaseSpecMessaging =
  components['schemas']['Runner'] & {
    /** The Dispatcher's queue. */
    jobs: StackKnowledgeBaseSpecMessagingJobs;
    /** The Gateway's signal plane. */
    signal: StackKnowledgeBaseSpecMessagingSignal;
    image?: components['schemas']['Image'];
    resources?: components['schemas']['Resources'];
    /**
     * A broker somebody else runs, serving this knowledge base alone: a second
     * knowledge base on it would share the job queue and, on a `nats` signal
     * plane, the frames and the gateway's record of pending replies. The launcher
     * refuses to start a knowledge base whose `servers` another knowledge base on
     * its machine names.
     */
    external?: StackKnowledgeBaseSpecMessagingExternal;
  };

/** The Dispatcher's queue. */
export type StackKnowledgeBaseSpecMessagingJobs = {
  /** The queue's driver: `jetstream`. */
  type: string;
};

/** The Gateway's signal plane. */
export type StackKnowledgeBaseSpecMessagingSignal = {
  /** `in-process`, one Gateway on its own fabric, or `nats`, on the broker. */
  type: string;
};

/**
 * A broker somebody else runs, serving this knowledge base alone: a second
 * knowledge base on it would share the job queue and, on a `nats` signal plane,
 * the frames and the gateway's record of pending replies. The launcher refuses
 * to start a knowledge base whose `servers` another knowledge base on its
 * machine names.
 */
export type StackKnowledgeBaseSpecMessagingExternal = {
  /** Where it listens: `host:port`. */
  servers: string;
  user: components['schemas']['SecretRef'];
  password: components['schemas']['SecretRef'];
};

/**
 * The issuer the knowledge base trusts: the one the launcher runs for the
 * knowledge bases on a machine, at `shared`, with the knowledge base's own
 * realm in it, or somebody else's, at `external`.
 */
export type StackKnowledgeBaseSpecIssuer = {
  /**
   * The issuer the launcher runs for the knowledge bases on a machine (the
   * state home's Issuer document). The launcher creates the knowledge base's
   * realm in it.
   */
  shared?: StackKnowledgeBaseSpecIssuerShared;
  /** An issuer somebody else runs. */
  external?: StackKnowledgeBaseSpecIssuerExternal;
  /**
   * The claim a person's DID is built from: did:web:<site domain>:users:<its
   * value>.
   */
  subjectClaim: string;
};

/**
 * The issuer the launcher runs for the knowledge bases on a machine (the state
 * home's Issuer document). The launcher creates the knowledge base's realm in
 * it.
 */
export type StackKnowledgeBaseSpecIssuerShared = {
  /**
   * How long a token the realm mints stays valid, in seconds: the window in
   * which a disabled account can still act.
   */
  accessTokenLifespan: number;
};

/** An issuer somebody else runs. */
export type StackKnowledgeBaseSpecIssuerExternal = {
  /** `oidc`, or `keycloak`. */
  type: string;
  /** The URL in its tokens' `iss` claim. */
  url: string;
};

/**
 * Where a started Ollama keeps its models, as --ollama-cache names it. Absent:
 * the host's ~/.ollama when there is one, else the named volume — what the
 * command line's prompt does when nobody answers it.
 */
export type StackStartParamsOllamaCache = 'host' | 'volume';

export type StatusResponseFeatures = {
  semanticContent: string;
  collaboration: string;
};

/**
 * Where the stack runs: on this machine (local), or on a GitHub codespace whose
 * knowledge base is forwarded here (codespace).
 */
export type TargetKind = 'local' | 'codespace';

/** The vector store, and where it is published. */
export type VectorStoreSpec = {
  /** The vector store's driver: `qdrant`. */
  type: string;
  image: components['schemas']['Image'];
  resources: components['schemas']['Resources'];
  /**
   * The port the vector store is published on, on this machine, where every
   * knowledge base's Smelter and Librarian reach it.
   */
  port: number;
};

/**
 * How far the reconcile its first sweep is followed by has got (WEAVER.md §
 * Reconcile): the pass's `summary` when it is done, or its `error` when it
 * failed.
 */
export type WeaverHealthReconcile = {
  phase: WeaverHealthReconcilePhase;
  /** What the pass found and did. */
  summary?: WeaverHealthReconcileSummary;
  /** Why it failed. */
  error?: string;
};

export type WeaverHealthReconcilePhase =
  'pending' | 'running' | 'done' | 'failed';

/** What the pass found and did. */
export type WeaverHealthReconcileSummary = {
  /** How many resources it checked. */
  resourcesChecked: number;
  /**
   * How many of them were divergent: the graph held them otherwise than the
   * record.
   */
  divergent: number;
  /** How many divergent resources it rebuilt. */
  healed: number;
  /**
   * How many it did not heal, because the rebuild stopped at an event it could
   * not apply.
   */
  healFailures: number;
  /**
   * How many orphaned views it found: resources the catalog lists and the
   * record holds no events for. Each is counted, and not healed.
   */
  orphaned: number;
};

/** The job it holds, or null. */
export type WorkerEngineHealthActiveJob = {
  jobId: components['schemas']['JobId'];
  type: components['schemas']['JobType'];
  /** When it was handed the job. */
  since: string;
};

/** Where the worker signs in for this knowledge base, and as which client. */
export type WorkerKnowledgeBaseConfigIdentity = {
  /** The issuer URL, exactly as tokens carry it in `iss`. */
  issuer: string;
  /**
   * The client the issuer holds the public half of the worker's key on: the
   * worker's account at this knowledge base. It is also what the worker says it
   * is called there (`principal:profile`).
   */
  clientId: string;
};

/**
 * `starting`: signing in, opening its stream, confirming it, or waiting to
 * start again. `working`: confirmed, its engines claiming. `refused`: refused,
 * until the service is started again.
 */
export type WorkerKnowledgeBaseHealthState = 'starting' | 'working' | 'refused';

/** How the worker runs. */
export type WorkerPoolSpec = {
  logLevel: components['schemas']['LogLevel'];
  /** The Worker. */
  worker: WorkerPoolSpecWorker;
};

/** The Worker. */
export type WorkerPoolSpecWorker = {
  image: components['schemas']['Image'];
  resources: components['schemas']['Resources'];
};

/**
 * The Gateway's request tracking: correlation IDs it currently holds so replies
 * can be routed to the app client that sent each request, and the tracking
 * capacity.
 */
export type WorkloadStatusLedger = {
  /**
   * Number of request IDs currently held to route replies to their requesting
   * app clients. Includes requests still waiting for a reply and recently
   * answered requests still within the tracking window.
   */
  claims: number;
  /**
   * The maximum number of IDs held in this Gateway's local tracking projection.
   */
  capacity: number;
};

/**
 * Current Dispatcher depth and, when the worker has emitted counters, completed
 * and failed work since worker start. These are different measurements and time
 * windows.
 */
export type WorkloadStatusQueue = {
  /** Jobs currently waiting for a worker. */
  pending: number;
  /** Jobs currently claimed by workers. */
  running: number;
  /** Jobs completed since worker start. */
  completed?: number;
  /** Jobs finally failed since worker start. */
  failed?: number;
};

export type YieldCreateCommandGeneratedFrom = {
  resourceId?: components['schemas']['ResourceId'];
  annotationId?: components['schemas']['AnnotationId'];
};
