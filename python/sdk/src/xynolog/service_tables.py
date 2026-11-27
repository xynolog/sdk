# Generated from the services' tables of protocol/specs/src; do not edit.
# Regenerate: make generate (codegen/lib/python_types/python_types.ml)
# ruff: noqa: E501, I001, RUF002, RUF022, RUF100

"""The tables the services keep to, each read as its schema's model: the variables a service reads
and why it refuses to start, what it tells OpenTelemetry and logs, its messages, its jobs'
budgets, the bounds of the bus's replies, and the rest. `SERVICE_TABLES` holds each by its file.
"""

from collections.abc import Mapping
from types import MappingProxyType
from typing import Final

from xynolog.model import WireModel
from xynolog.types import (
    ArchivistDefaultEntityTypes,
    ArchivistLayout,
    ArchivistMessages,
    BusReplyBounds,
    DispatcherMessages,
    EmbeddingRequests,
    GatewayMediaToken,
    GatewayMessages,
    GatewayResponseHeaders,
    GraphSchema,
    JobsBudgets,
    JobsStorage,
    ServiceEnvironmentBootRefusals,
    ServiceEnvironmentVariables,
    ServiceTelemetryLogLines,
    ServiceTelemetryTelemetry,
    SmelterMessages,
    WorkerAnswerFormats,
    WorkerMessages,
)

__all__ = [
    "ARCHIVIST_DEFAULT_ENTITY_TYPES",
    "ARCHIVIST_LAYOUT",
    "ARCHIVIST_MESSAGES",
    "BUS_REPLY_BOUNDS",
    "DISPATCHER_MESSAGES",
    "EMBEDDING_REQUESTS",
    "GATEWAY_MEDIA_TOKEN",
    "GATEWAY_MESSAGES",
    "GATEWAY_RESPONSE_HEADERS",
    "GRAPH_SCHEMA",
    "JOBS_BUDGETS",
    "JOBS_STORAGE",
    "SERVICE_ENVIRONMENT_BOOT_REFUSALS",
    "SERVICE_ENVIRONMENT_VARIABLES",
    "SERVICE_TABLES",
    "SERVICE_TELEMETRY_LOG_LINES",
    "SERVICE_TELEMETRY_TELEMETRY",
    "SMELTER_MESSAGES",
    "WORKER_ANSWER_FORMATS",
    "WORKER_MESSAGES",
]

ARCHIVIST_DEFAULT_ENTITY_TYPES: Final = ArchivistDefaultEntityTypes.model_validate_json(
    '{"$comment":"AUTHORITY for the vocabulary an Archivist seeds at boot (ARCHIVIST.'
    "md \\u00a7 Boot and shutdown, step 8): each of `entityTypes` that the `__system__"
    "` stream has not recorded is added, in this order, as a `frame:entity-type-added"
    "` sent by the knowledge base itself (`did:web:<domain>`), before the Archivist s"
    'ubscribes to its channels; its facts are the first it publishes.","entityTypes":'
    '["Person","Organization","Location","Event","Concept","Product","Technology","Da'
    'te","Author"]}'
)
"""protocol/specs/src/archivist/default-entity-types.json, read as `ArchivistDefaultEntityTypes`."""

ARCHIVIST_LAYOUT: Final = ArchivistLayout.model_validate_json(
    '{"$comment":"AUTHORITY for where the Archivist keeps the record on disk (ARCHIVI'
    "ST.md \\u00a7 The record on disk), as far as a reader of its files needs it: each"
    " file's tree, `root` (the working tree), `stateHome` (the state directory) or `a"
    "nchoredTextDir` (the anchored-text store), and its path in that tree. A path's `"
    "{resourceId}` is the resource's id, `{uriHash}` the SHA-256 of a storage URI's U"
    "TF-8 bytes in lowercase hex, `{contentChecksum}` a content checksum, and its `{s"
    "hard}` the two-level shard, `<ab>/<cd>`, of the key the file is filed by (the re"
    "source id, the URI, or the checksum), as archivist/shard-cases.json states the a"
    "rithmetic. A stream is a directory of event files, named by `eventFile`, numbere"
    "d from `first` in `digits` decimal digits, each holding at most `maxEvents` even"
    "ts, the next event opening the next file; each line of one is a stored event, co"
    "mpact JSON ended by a single newline, as `storedEvent` names it. A resource's vi"
    "ew is JSON indented by two spaces, as `view.schema` names it, and so is each pro"
    "jection of what the `__system__` stream adds up to, as its `schema` names it, an"
    "d each entry of the storage-uri index, as `storageUriIndex.schema` names it; a p"
    "rojection file that is absent reads as empty. An anchored-text entry is compact "
    "JSON, as `anchoredTextEntry.schema` names it. The stamp its entries are taken un"
    "der is the file `anchoredTextStamp`: the stamp alone, as AnchoredTextStamp's `st"
    'amp` is, followed by a newline.","eventStream":{"tree":"root","path":".xynolog/e'
    'vents/{shard}/{resourceId}"},"systemStream":{"tree":"root","path":".xynolog/even'
    'ts/__system__"},"eventFile":{"name":"events-{number}.jsonl","digits":6,"first":1'
    ',"maxEvents":10000},"storedEvent":{"$ref":"https://xynolog.org/protocol/StoredEv'
    'entResponse.json"},"view":{"tree":"stateHome","path":"resources/{shard}/{resourc'
    'eId}.json","schema":{"$ref":"https://xynolog.org/protocol/ResourceView.json"}},"'
    'systemProjections":{"tree":"stateHome","path":"projections/__system__","files":['
    '{"name":"entitytypes.json","schema":{"$ref":"https://xynolog.org/protocol/Entity'
    'TypesProjection.json"}},{"name":"tagschemas.json","schema":{"$ref":"https://xyno'
    'log.org/protocol/TagSchemasProjection.json"}},{"name":"profiles.json","schema":{'
    '"$ref":"https://xynolog.org/protocol/ProfilesProjection.json"}}]},"storageUriInd'
    'ex":{"tree":"stateHome","path":"projections/storage-uri/{shard}/{uriHash}.json",'
    '"schema":{"$ref":"https://xynolog.org/protocol/StorageUriEntry.json"}},"anchored'
    'TextEntry":{"tree":"anchoredTextDir","path":"{shard}/{contentChecksum}.json","sc'
    'hema":{"$ref":"https://xynolog.org/protocol/AnchoredTextEntry.json"}},"anchoredT'
    'extStamp":{"tree":"anchoredTextDir","path":"STAMP"}}'
)
"""protocol/specs/src/archivist/layout.json, read as `ArchivistLayout`."""

ARCHIVIST_MESSAGES: Final = ArchivistMessages.model_validate_json(
    '{"$comment":"AUTHORITY for the words of the Archivist\'s own refusals and of the '
    "messages it logs that a reader of its output relies on (ARCHIVIST.md), word for "
    "word. A text's `{name}` is filled as the row's `situation` says, and nothing els"
    "e in it varies. `boot` is each refusal to start of the Archivist's own, beside t"
    "he document and account refusals of service-environment/boot-refusals.json: writ"
    "ten in that table's `line`, once, to stderr, before it exits with that table's `"
    "exitCode`; unlike those, these name what the Archivist was pointed at, the gatew"
    "ay and the working tree. `unsent` is the failure a reply that cannot be sent is "
    "answered with instead, on the operation's failure channel. `refusals` is each re"
    "fusal of an operation, the `message` of its failure, and its `code` where it car"
    "ries one; `{channel}` is the operation's request channel. `unauthorized` is the "
    "refusal of every route of the HTTP surface but `/health`. `http` is each other e"
    "rror a route answers with: its status and the body's `error`, and its `code` whe"
    "re the body carries one. `logged` is each message the Archivist logs, at its `le"
    'vel`, with the fields named in `fields`, each of the form given.","boot":[{"name'
    '":"no-project-file","situation":"The working tree commits no `.xynolog/config.ya'
    'ml`, so it declares no `site.domain` (step 3).","refusal":"The knowledge base co'
    "mmits no .xynolog/config.yaml, so declares no site.domain: it is the identity th"
    'is knowledge base acts under, and the audience it accepts tokens for"},{"name":"'
    'not-a-checkout","situation":"The project file says `git.sync` is true, and git c'
    "annot be run in the root or says it is not inside a work tree (step 6): `{root}`"
    " is the document's `root`, and `{why}` git's or the system's reason, which varie"
    's.","refusal":"The knowledge base\'s project file says git.sync is true, and {roo'
    "t} is not a git checkout ({why}). Make it one (git init), or set git.sync to fal"
    'se."},{"name":"gateway-silent","situation":"The gateway does not answer its prot'
    "ected-resource metadata (step 5): `{gateway}` is the document's `gatewayUrl`, an"
    'd `{reason}` why, which varies.","refusal":"The gateway at {gateway} did not say'
    " which knowledge base it serves (/.well-known/oauth-protected-resource): {reason"
    '}"},{"name":"gateway-elsewhere","situation":"The gateway serves another knowledg'
    "e base than the tree (step 5): `{gateway}` is the document's `gatewayUrl`, `{ser"
    "ved}` the `resource` its metadata names, `{root}` the document's `root`, `{tree}"
    "` the tree's audience (`https://<domain>`, each `:` written `/`), and `{did}` th"
    'e tree\'s DID.","refusal":"The gateway at {gateway} serves {served}, and the tree'
    ' at {root} is {tree} ({did})"}],"unsent":[{"name":"too-large","situation":"A rep'
    "ly whose JSON is larger than a bus message may be: `{bytes}` is its size in byte"
    "s, and `{maxBodyBytes}` `POST /bus/emit`'s `x-xynolog-limits.maxBodyBytes` in th"
    'e gateway\'s API.","message":"The answer could not be sent: it is {bytes} bytes, '
    'and a bus message may be {maxBodyBytes}"},{"name":"not-sent","situation":"Any ot'
    "her reply that cannot be sent, once the transport gives up: `{why}` is why, whic"
    'h varies.","message":"The answer could not be sent: {why}"}],"refusals":[{"name"'
    ':"uncited-worker","operations":["yield:create","mark:commit"],"situation":"A sen'
    'der holding the worker role whose command cites no `jobId`.","message":"{channel'
    '} refused: a worker-role emitter must cite the job it fulfils in `jobId`"},{"nam'
    'e":"unassigned-job","operations":["yield:create","mark:commit"],"situation":"A c'
    "ommand citing a job that the log of the resource it is checked against holds no "
    "`job:assigned` of, and that did not make the resource: `{jobId}` is the cited jo"
    'b, and `{resourceId}` that resource.","message":"{channel} refused: cites job {j'
    "obId}, but the log of {resourceId} holds no assignment of it, and the job did no"
    't make it"},{"name":"not-the-holder","operations":["yield:create","mark:commit"]'
    ',"situation":"A command citing a job whose recorded holder is not its sender: `{'
    "jobId}` is the cited job, `{holder}` the assignment's `holder` or the sender of "
    'the `yield:created` the job made, and `{writer}` the command\'s sender.","message'
    '":"{channel} refused: job {jobId}\'s recorded holder is {holder}, not the writer '
    '{writer}"},{"name":"sourceless-create","operations":["yield:create"],"situation"'
    ':"A `yield:create` that cites a job and names no `generatedFrom.resourceId`.","m'
    'essage":"yield:create refused: a create citing a job must name the source resour'
    'ce its job was assigned on (generatedFrom.resourceId)"},{"name":"multi-agent-cre'
    'ate","operations":["yield:create"],"situation":"A `yield:create` whose `generato'
    'r` is a list.","message":"yield:create refused: a multi-agent generator is not s'
    'upported; derivation binds one generator to the executor"},{"name":"generator-no'
    't-executor","operations":["yield:create","mark:commit"],"situation":"A supplied '
    "generator that is not the command's sender: `{generator}` is the generator's `@i"
    'd`, and `{executor}` the sender.","message":"{channel} refused: generator {gener'
    'ator} is not the executor {executor}"},{"name":"executor-not-software","operatio'
    'ns":["yield:create","mark:commit"],"situation":"A supplied generator from a send'
    'er that is not software: `{executor}` is the sender.","message":"{channel} refus'
    'ed: a generator was supplied, but the executor {executor} is not software"},{"na'
    'me":"annotation-with-creator","operations":["mark:commit"],"situation":"An annot'
    'ation that arrives with a `creator`: `{annotationId}` is its `id`.","message":"{'
    "channel} refused: `creator` on annotation {annotationId} is derived by the knowl"
    'edge base, never sent"},{"name":"multi-agent-annotation","operations":["mark:com'
    'mit"],"situation":"An annotation whose `generator` is a list: `{annotationId}` i'
    's its `id`.","message":"{channel} refused: annotation {annotationId} carries a m'
    'ulti-agent generator; derivation binds one generator to the executor"},{"name":"'
    'not-annotatable","operations":["mark:create-request"],"situation":"A target whos'
    'e resource\'s content cannot be annotated: `{mediaType}` is its media type.","mes'
    'sage":"\\"{mediaType}\\" cannot be annotated"},{"name":"storage-uri-scheme","opera'
    'tions":["yield:create","yield:clone-persist","yield:update","yield:clone-create"'
    ',"mark:archive","mark:unarchive"],"situation":"A storage URI that does not begin'
    ' `file://`: `{uri}` is the URI.","message":"Invalid storage URI (must start with'
    ' file://): {uri}"},{"name":"storage-uri-outside","operations":["yield:create","y'
    'ield:clone-persist","yield:update","yield:clone-create","mark:archive","mark:una'
    'rchive"],"situation":"A storage URI naming a place outside the working tree: `{u'
    'ri}` is the URI.","message":"Invalid storage URI (must name a file inside the wo'
    'rking tree): {uri}"},{"name":"checksum-mismatch","operations":["yield:create","y'
    'ield:clone-persist","yield:update","yield:clone-create"],"situation":"Content re'
    "gistered whose file is not the checksum expected: `{uri}` is the URI, `{expected"
    "}` the first 8 characters of the checksum expected, and `{actual}` the first 8 o"
    'f the file\'s.","message":"Checksum mismatch for {uri}: expected {expected}... bu'
    "t got {actual}...\\nThe file on disk differs from the recorded checksum. Has it b"
    'een modified since staging?"},{"name":"unarchive-without-file","operations":["ma'
    'rk:unarchive"],"situation":"A `mark:unarchive` naming a storage URI with no file'
    ' at it: `{uri}` is the URI.","message":"Cannot unarchive: file not found at {uri'
    '}"},{"name":"entity-type-not-registered","operations":["mark:update-entity-types'
    '"],"situation":"Types to add that are not in the vocabulary: `{types}` is each t'
    'hat is not, in the order the command names them, joined by `, `.","message":"Ent'
    'ity type not registered: {types}"},{"name":"resource-not-found","operations":["b'
    'rowse:resource-requested"],"code":"not-found","situation":"A resource with no ev'
    'ents.","message":"Resource not found"},{"name":"annotation-not-found","operation'
    's":["browse:annotation-requested","browse:annotation-history-requested"],"situat'
    'ion":"An annotation the resource\'s view does not hold.","message":"Annotation no'
    't found"},{"name":"path-escapes","operations":["browse:directory-requested"],"si'
    'tuation":"A path outside the working tree.","message":"path escapes project root'
    '"},{"name":"path-not-found","operations":["browse:directory-requested"],"situati'
    'on":"A path of the working tree that is not there.","message":"path not found"},'
    '{"name":"clone-source-not-found","operations":["yield:clone-token-requested"],"s'
    'ituation":"A token asked for a resource with no view.","message":"Resource not f'
    'ound"},{"name":"clone-content-not-found","operations":["yield:clone-token-reques'
    'ted"],"situation":"A token asked for a resource whose content is not in the work'
    'ing tree.","message":"Resource content not found"},{"name":"invalid-token","oper'
    'ations":["yield:clone-resource-requested","yield:clone-create"],"situation":"A t'
    'oken the Archivist did not issue, or has forgotten or spent.","message":"Invalid'
    ' or expired token"},{"name":"token-expired","operations":["yield:clone-resource-'
    'requested","yield:clone-create"],"situation":"A token issued more than fifteen m'
    'inutes before.","message":"Token expired"},{"name":"token-source-not-found","ope'
    'rations":["yield:clone-resource-requested","yield:clone-create"],"situation":"A '
    'token whose resource is no longer held.","message":"Source resource not found"}]'
    ',"unauthorized":{"status":401,"error":"unauthorized","presented":"Bearer error=\\'
    '"invalid_token\\"","absent":"Bearer"},"http":[{"name":"stream-listing-failed","me'
    'thod":"GET","route":"/events","status":500,"situation":"A listing of the log\'s s'
    'treams that failed.","error":"stream listing failed"},{"name":"events-bad-reques'
    't","method":"GET","route":"/events/{resourceId}","status":400,"situation":"A `fr'
    "omSequence` that is not an integer of at least 1 in decimal digits, or an id tha"
    't is not one.","error":"resourceId path segment and integer fromSequence >= 1 ar'
    'e required"},{"name":"event-read-failed","method":"GET","route":"/events/{resour'
    'ceId}","status":500,"situation":"A read of the stream that failed.","error":"eve'
    'nt read failed"},{"name":"content-read-failed","method":"GET","route":"/resource'
    's/{id}/content","status":500,"situation":"A file missing from the working tree."'
    ',"error":"content read failed"},{"name":"content-no-resource","method":"GET","ro'
    'ute":"/resources/{id}/content","status":404,"code":"resource","situation":"No vi'
    'ew of the resource: `{id}` is the path\'s id.","error":"Resource not found: {id}"'
    '},{"name":"content-no-representation","method":"GET","route":"/resources/{id}/co'
    'ntent","status":404,"code":"representation","situation":"A view with no storage '
    'URI: `{id}` is the path\'s id.","error":"Resource representation not found: no st'
    'orageUri for {id}"},{"name":"jsonld-not-found","method":"GET","route":"/resource'
    's/{id}/jsonld","status":404,"situation":"A resource with no events.","error":"Re'
    'source not found"},{"name":"annotations-not-found","method":"GET","route":"/reso'
    'urces/{id}/annotations","status":404,"situation":"No view of the resource, or an'
    ' id that is not one.","error":"Resource not found"},{"name":"anchored-text-read-'
    'failed","method":"GET","route":"/resources/{id}/anchored-text","status":500,"sit'
    'uation":"A read of the store that failed.","error":"anchored-text read failed"},'
    '{"name":"anchored-text-not-a-write","method":"PUT","route":"/resources/{id}/anch'
    'ored-text","status":400,"situation":"A body that is not an AnchoredTextWrite: `{'
    'why}` is why, which varies.","error":"The body is no AnchoredTextWrite: {why}"},'
    '{"name":"anchored-text-write-not-found","method":"PUT","route":"/resources/{id}/'
    'anchored-text","status":404,"situation":"No view of the resource, or an id that '
    'is not one.","error":"Resource not found"},{"name":"anchored-text-stored-not-fou'
    'nd","method":"GET","route":"/resources/{id}/anchored-text/stored","status":404,"'
    'situation":"No view of the resource, or an id that is not one.","error":"Resourc'
    'e not found"},{"name":"anchored-text-no-entry","method":"GET","route":"/resource'
    's/{id}/anchored-text/stored","status":404,"situation":"No entry stored for the r'
    'esource\'s content under the stamp stated.","error":"No entry is stored for this '
    'content"},{"name":"upload-unattributed","method":"POST","route":"/resources","st'
    'atus":400,"situation":"An upload without `Xynolog-Principal`.","error":"Xynolog-'
    'Principal is required: the record attributes every resource to someone"},{"name"'
    ':"upload-not-multipart","method":"POST","route":"/resources","status":400,"situa'
    'tion":"A body that is not `multipart/form-data`.","error":"The body is not multi'
    'part/form-data"},{"name":"upload-unsupported-media","method":"POST","route":"/re'
    'sources","status":400,"situation":"A `format` whose media type is not one Xynolo'
    'g knows: `{type}` is the media type.","error":"Unsupported media type: {type}"},'
    '{"name":"upload-key-reused","method":"POST","route":"/resources","status":422,"s'
    'ituation":"An `Idempotency-Key` whose resource was recorded from other fields or'
    " other bytes, a copy's key sent with no clone token, or a new resource's sent wi"
    'th one.","error":"This Idempotency-Key names a resource recorded from other fiel'
    'ds or other bytes"},{"name":"upload-refused","method":"POST","route":"/resources'
    '","status":500,"situation":"A record that is refused: `{refusal}` is the refusal'
    "'s message, as `refusals` states it for `yield:create`, or `yield:clone-create` "
    'with a clone token.","error":"{refusal}"}],"logged":[{"name":"not-an-event","lev'
    'el":"warn","situation":"A line of the log that is not an event, found when the v'
    "iews are rebuilt: `{path}` is its event file's path, and `{line}` its line numbe"
    'r, counted from 1.","message":"The event log holds something that is not an even'
    't","fields":{"what":"{path} line {line} is not an event"}},{"name":"generated-no'
    't-linked","level":"warn","situation":"A generated resource recorded, whose link '
    'from the annotation it was generated for could not be recorded.","message":"A ge'
    'nerated resource was not linked from its annotation","fields":{}},{"name":"compl'
    'etion-of-another-verb","level":"warn","situation":"A `job:complete` whose `jobTy'
    'pe` is not the one the stream records for the job, which is not recorded.","mess'
    'age":"job:complete of another verb than the job\'s","fields":{}}]}'
)
"""protocol/specs/src/archivist/messages.json, read as `ArchivistMessages`."""

DISPATCHER_MESSAGES: Final = DispatcherMessages.model_validate_json(
    '{"$comment":"AUTHORITY for the words of the dispatcher\'s own refusals (JOBS.md \\'
    "u00a7 Channels): for each situation it refuses an operation in itself, the opera"
    "tion, the `message` of the CommandError it replies with on the operation's failu"
    "re channel, and its `code` where it carries one, word for word. A refusal the di"
    "spatcher relays carries the relayed words, not these: a vocabulary read's failur"
    "e (for an Archivist that is not connected, gateway/messages.json's failure `peer"
    "-unavailable`), and the store's error. A text's `{name}` is filled as the row's "
    "`situation` says. `errors` is each error the dispatcher writes into a job's reco"
    'rd on its own, with its failure class.","refusals":[{"name":"create-without-user'
    '","operation":"job:create","situation":"A `job:create` with no `_userId` (check '
    "1). The gateway stamps `_userId` on every frame it accepts, so only a frame that"
    ' reached the bus around it is refused so.","message":"_userId is required (injec'
    'ted by bus gateway)"},{"name":"entity-type-not-registered","operation":"job:crea'
    'te","situation":"A `mark` linking job, or a `yield` job, naming entity types tha'
    "t are not registered (checks 2 and 5): `{types}` is each that is not, in the ord"
    'er the job names them, joined by `, `.","message":"Entity type not registered: {'
    'types}"},{"name":"tag-schema-not-registered","operation":"job:create","situation'
    '":"A `mark` tagging job whose `schemaId` names no registered tag schema (check 3'
    '): `{schemaId}` is the `schemaId`.","message":"Tag schema not registered: {schem'
    'aId}"},{"name":"yield-parameter","operation":"job:create","situation":"A `yield`'
    " job given parameters GenerationJobParams does not name (check 4): `{params}` is"
    ' each, in the order the job gives them, joined by `, `.","message":"a yield job '
    'takes no parameter {params}"},{"name":"not-a-worker","operation":"job:claim","co'
    'de":"unauthorized","situation":"A `job:claim` whose `_roles` does not hold the w'
    'orker role, checked before the queue is consulted.","message":"job:claim refused'
    ': the caller is not a worker for this knowledge base"},{"name":"none-pending","o'
    'peration":"job:claim","code":"none-pending","situation":"A `job:claim` from a wo'
    'rker that no pending job matches: a decline, not an error.","message":"No pendin'
    'g job matches the claim"},{"name":"claim-without-user","operation":"job:claim","'
    'situation":"A `job:claim` from a worker with no `_userId`, checked after the tra'
    "nsition, which leaves the job `running`. The gateway stamps `_userId` on every f"
    'rame it accepts, so only a frame that reached the bus around it is refused so.",'
    '"message":"job:claim missing _userId (gateway injection)"},{"name":"job-not-foun'
    'd","operation":"job:status-requested","situation":"A `job:status-requested` nami'
    'ng a job the queue holds no record of: never created, or deleted by retention.",'
    '"message":"Job not found"}],"errors":[{"name":"presumed-dead","situation":"The d'
    "ead-worker sweep's, for a running job with no write for `staleRunningMs`: `{minu"
    "tes}` is `staleRunningMs` divided by 60000, as the shortest decimal that reads b"
    'ack as that number, with no `.0` when it is whole.","error":"worker presumed dea'
    'd \\u2014 no progress within {minutes} minutes","failureClass":"transient"}]}'
)
"""protocol/specs/src/dispatcher/messages.json, read as `DispatcherMessages`."""

EMBEDDING_REQUESTS: Final = EmbeddingRequests.model_validate_json(
    '{"$comment":"AUTHORITY for how a service asks its embedding provider for vectors'
    " (SMELTER.md \\u00a7 The embedding provider), as `xynolog-vectors` asks for every"
    " service that embeds. `providers` states, for each kind of provider, how many te"
    "xts a request carries and how many requests are made of it at once. `requestSeco"
    "nds` is each request's own time. `busy` is which statuses say a provider is busy"
    ", and how long a request for documents waits before each asking again. `startAga"
    "in` is how many times a starting service asks again a provider that is still fet"
    'ching its model, or still starting.","providers":{"ollama":{"textsPerRequest":12'
    '8,"atOnce":1},"voyage":{"textsPerRequest":128,"atOnce":4}},"requestSeconds":15,"'
    'busy":{"statuses":[429,503],"againAfterSeconds":[1,2,4]},"startAgain":12}'
)
"""protocol/specs/src/embedding/requests.json, read as `EmbeddingRequests`."""

GATEWAY_MEDIA_TOKEN: Final = GatewayMediaToken.model_validate_json(
    '{"$comment":"AUTHORITY for the media token (the `mediaToken` scheme of the gatew'
    "ay's document): what `POST /api/tokens/media` answers, and the one credential `G"
    "ET /api/resources/{id}` takes in its `token` query parameter. It is a JSON Web T"
    "oken with `header`, signed by HS256 with the first key of the gateway's `JWT_SEC"
    "RET` ring, which signs nothing else; it is accepted under any key of the ring. I"
    "ts claims are `claims`, with `{domain}` the domain the gateway's document names "
    "and `{resourceId}` the resource it was asked for, and `iat`, the second it was m"
    "inted, and `exp`, `lifetimeSeconds` later. The gateway accepts one with no leewa"
    "y on `exp`, whose `purpose`, `iss` and `sub` are these, and `sub` the resource t"
    "he path names; anything else is refused (gateway/messages.json, `refused-media-t"
    'oken`), and anywhere else a media token is no credential.","header":{"alg":"HS25'
    '6","typ":"JWT"},"claims":{"purpose":"media","iss":"{domain}","sub":"{resourceId}'
    '"},"lifetimeSeconds":300}'
)
"""protocol/specs/src/gateway/media-token.json, read as `GatewayMediaToken`."""

GATEWAY_MESSAGES: Final = GatewayMessages.model_validate_json(
    '{"$comment":"AUTHORITY for the words of the gateway\'s own refusals (TRANSPORT-HT'
    "TP.md \\u00a7 Errors): for each situation it refuses a request in itself, the sta"
    "tus, the ErrorResponse's (or LimitRefusal's) `error`, and its `code` and `hint` "
    "where it carries them, word for word. A refusal the gateway relays from the Arch"
    "ivist carries the Archivist's words, not these, and a refusal of one of these si"
    "tuations carries no other text. A text's `{name}` is filled as the row's `situat"
    "ion` says. What the gateway logs of a refusal is its own: a refused token is tol"
    "d only that it was refused, and its log says why. `failures` is each failure fra"
    "me the gateway delivers itself on the stream of the client whose request it answ"
    "ers, in place of an answer nobody can give. `challenges` is the `WWW-Authenticat"
    "e` of each 401, in the form the Unauthorized response states; a 429 that replace"
    's a 401 carries none.","messages":[{"name":"no-credential","status":401,"situati'
    'on":"A protected operation, asked with no credential: no `Authorization` header,'
    " a scheme that is not `Bearer`, a `Bearer` with no token, or a media token anywh"
    'ere it is not accepted.","error":"Unauthorized","hint":"Authentication required:'
    " send an `Authorization: Bearer <token>` header. A raw browser navigation to a p"
    'rotected resource is unauthenticated."},{"name":"refused-token","status":401,"si'
    'tuation":"A bearer token the gateway does not accept.","error":"Invalid token"},'
    '{"name":"refused-media-token","status":401,"situation":"A media token `GET /api/'
    "resources/{id}` does not accept: expired, of another knowledge base, of another "
    'resource, or not one.","error":"Invalid media token"},{"name":"refusal-rate","st'
    'atus":429,"code":"refusal-rate","situation":"Any of the 401s above, once the ref'
    'usals its holder has had have used their allowance.","error":"The credential was'
    ' refused, and its holder\'s refused requests have used their allowance"},{"name":'
    '"not-json","status":400,"situation":"An operation whose body is JSON, given one '
    'that is not.","error":"The body is not JSON"},{"name":"no-idempotency-key","stat'
    'us":400,"situation":"An operation that requires an `Idempotency-Key`, asked with'
    'out one.","error":"The request carries no Idempotency-Key"},{"name":"idempotency'
    '-key-not-text","status":400,"situation":"An `Idempotency-Key` with a character t'
    'hat is not visible ASCII.","error":"The Idempotency-Key is not text: only visibl'
    'e ASCII characters"},{"name":"idempotency-key-length","status":400,"situation":"'
    "An `Idempotency-Key` shorter or longer than its parameter allows: `{minLength}` "
    'and `{maxLength}` are its schema\'s.","error":"The Idempotency-Key must be {minLe'
    'ngth} to {maxLength} characters"},{"name":"unknown-channel","status":400,"situat'
    'ion":"An emit on a channel the bus registry does not register: `{channel}` is th'
    'e one it named.","error":"Unknown channel: {channel}"},{"name":"invalid-payload"'
    ',"status":400,"situation":"An emit whose payload its channel\'s schema refuses: `'
    "{channel}` is the channel, and `{problems}` each refusal, as `<the member's JSON"
    ' Pointer, or root>: <the refusal>`, joined by `; `.","error":"Invalid payload fo'
    'r {channel}: {problems}"},{"name":"correlation-without-client","status":400,"sit'
    'uation":"An emit that carries a `correlationId` and no `clientId`: `{channel}` i'
    's its channel.","error":"clientId is required to emit {channel} with a correlati'
    'onId"},{"name":"no-subscription","status":400,"situation":"A subscription with n'
    'o global channel and no scoped entry.","error":"At least one global channel or s'
    'coped entry is required"},{"name":"duplicate-scope","status":400,"situation":"A '
    'subscription whose `scoped` names one scope twice: `{scope}` is that scope.","er'
    'ror":"duplicate scope \\"{scope}\\" in matrix"},{"name":"not-found","status":404,"'
    'situation":"A path the gateway does not serve, or a method a path it serves does'
    ' not take.","error":"Not found"},{"name":"resource-not-found","status":404,"situ'
    'ation":"A resource the knowledge base does not hold: an `{id}` that is no Resour'
    "ceId, one the Archivist holds no view of, or one whose bytes the Archivist answe"
    'rs it does not hold the resource of.","error":"Resource not found"},{"name":"rep'
    'resentation-not-found","status":404,"situation":"A resource the knowledge base h'
    'olds, whose bytes the Archivist answers it does not hold.","error":"Resource rep'
    'resentation not found"},{"name":"correlation-claimed","status":409,"situation":"'
    "An emit whose `correlationId` another client has claimed: `{correlationId}` is i"
    't.","error":"correlationId {correlationId} is already claimed"},{"name":"too-lar'
    'ge","status":413,"situation":"A body larger than its operation\'s `maxBodyBytes`,'
    ' which `{maxBodyBytes}` is.","error":"The body is larger than {maxBodyBytes} byt'
    'es, this operation\'s maxBodyBytes"},{"name":"idempotency-key-reused","status":42'
    '2,"code":"unprocessable","situation":"An emit sent again under its `Idempotency-'
    'Key` with another body.","error":"This Idempotency-Key was first sent with anoth'
    'er body"},{"name":"emit-rate","status":429,"code":"emit-rate","situation":"An em'
    'it past its principal\'s emit-rate bucket.","error":"This principal\'s emits have '
    'used its bucket"},{"name":"unanswered-requests","status":429,"code":"unanswered-'
    'requests","situation":"A request on the bus past its client\'s unanswered request'
    's: `{max}` is the most it may hold.","error":"client has {max} unanswered reques'
    'ts; retry when one settles"},{"name":"streams","status":429,"code":"streams","si'
    'tuation":"A subscription past the streams its principal may hold.","error":"This'
    ' principal holds as many streams as it may"},{"name":"internal","status":500,"si'
    'tuation":"A fault of the gateway\'s own; its log says what.","error":"Internal se'
    'rver error"},{"name":"content-store-unavailable","status":503,"situation":"A rea'
    "d or an upload the Archivist did not answer as its API states: it could not be r"
    "eached, it did not answer in time, it refused the gateway, or it answered what i"
    "ts API does not; or the gateway could not get its own service token to ask it wi"
    'th.","error":"Content store unavailable"},{"name":"plane-unavailable","status":5'
    '03,"situation":"An emit, or anything that reads or writes a table the replicas s'
    'hare, while the signal plane\'s broker is not connected.","error":"The signal pla'
    'ne is unavailable: its broker is not connected"},{"name":"capacity","status":503'
    ',"code":"capacity","situation":"A subscription past the queued bytes the gateway'
    ' can hold.","error":"The gateway holds as many queued bytes as it can"}],"failur'
    'es":[{"name":"peer-unavailable","code":"peer-unavailable","situation":"A request'
    " on the bus that no subscriber answers: `{channel}` is the request's channel. It"
    's payload carries no stamp.","message":"No subscriber for {channel}: the service'
    ' that answers it is not connected"}],"challenges":{"noCredential":"Bearer resour'
    'ce_metadata=\\"{origin}/.well-known/oauth-protected-resource\\"","refused":"Bearer'
    ' error=\\"invalid_token\\", resource_metadata=\\"{origin}/.well-known/oauth-protect'
    'ed-resource\\""}}'
)
"""protocol/specs/src/gateway/messages.json, read as `GatewayMessages`."""

GATEWAY_RESPONSE_HEADERS: Final = GatewayResponseHeaders.model_validate_json(
    '{"$comment":"AUTHORITY for the headers the gateway puts on every response it sen'
    "ds (TRANSPORT-HTTP.md \\u00a7 Every response): on every route, whatever its statu"
    "s, a success, an error, bytes and a stream alike. `every` is each header every r"
    "esponse carries, with its value, exactly: the security headers, and CORS that is"
    " open to every origin. `requestId` is the header that names the request: a new U"
    "UID for each request, in lower case with hyphens, which each line the gateway lo"
    "gs while it answers the request carries as its `requestId` (service-telemetry/lo"
    "g-lines.json). `absent` is each header no response carries: the API is bearer-on"
    "ly, so no origin can ride a browser's ambient credentials. `preflight` is how th"
    "e gateway answers an `OPTIONS` request, before it routes it and whatever its pat"
    "h: with its `status` and no body, every header of `every` and `requestId`, each "
    "of its `headers`, and, when the request carries the header an `echoes` entry nam"
    "es, that entry's header with the request header's value, and then a `Vary` of `v"
    'ary`.","every":[{"name":"Access-Control-Allow-Origin","value":"*"},{"name":"X-Fr'
    'ame-Options","value":"DENY"},{"name":"X-Content-Type-Options","value":"nosniff"}'
    ',{"name":"Strict-Transport-Security","value":"max-age=31536000; includeSubDomain'
    's"},{"name":"Content-Security-Policy","value":"default-src \'none\'; frame-ancesto'
    "rs 'none'; base-uri 'none'; form-action 'none'\"},{\"name\":\"X-XSS-Protection\",\"val"
    'ue":"1; mode=block"},{"name":"Referrer-Policy","value":"no-referrer"},{"name":"P'
    'ermissions-Policy","value":"camera=(), geolocation=(), microphone=(), payment=()'
    ', usb=(), interest-cohort=()"}],"requestId":"X-Request-ID","absent":["Access-Con'
    'trol-Allow-Credentials"],"preflight":{"status":204,"headers":[{"name":"Access-Co'
    'ntrol-Allow-Methods","value":"GET,HEAD,PUT,POST,DELETE,PATCH"}],"echoes":[{"name'
    '":"Access-Control-Allow-Headers","of":"Access-Control-Request-Headers"}],"vary":'
    '"Access-Control-Request-Headers"}}'
)
"""protocol/specs/src/gateway/response-headers.json, read as `GatewayResponseHeaders`."""

GRAPH_SCHEMA: Final = GraphSchema.model_validate_json(
    '{"$comment":"AUTHORITY for the shape of the graph every store keeps (WEAVER.md \\'
    "u00a7 What the graph holds), as a reader of a store finds it: each kind of node "
    "by its label, the property it is one of its kind by (`key`) and the properties a"
    " reader finds one by (`lookups`); each kind of relationship by its type, the kin"
    "d of node it goes from and the kind it goes to; and the stub. What a node holds "
    "is its codec row, the `properties` and `json` of graph/codec-cases.json's part t"
    "hat `row` names; a node without a row holds its key alone. How a store spells a "
    "node, a list or a property is its own dialect, as graph/codec-cases.json says of"
    " a row. A link's target the graph has not been given yet is a stub: a node holdi"
    "ng its key and the marker, `true`, and nothing else. It is not a resource the gr"
    "aph holds: no read answers it, lists it, counts it or follows it. Storing the re"
    "source fills it in, and the marker goes. A store makes what else it likes of its"
    ' own, such as a second label or an index; no reader reads it.","nodes":{"resourc'
    'e":{"label":"Resource","row":"resourceStored","key":"id","lookups":["name","enti'
    'tyTypes"]},"annotation":{"label":"Annotation","row":"annotationStored","key":"id'
    '","lookups":["resourceId"]},"entityType":{"label":"EntityType","key":"name","loo'
    'kups":[]}},"relationships":{"belongsTo":{"type":"BELONGS_TO","from":"annotation"'
    ',"to":"resource","says":"The resource the annotation is on, the one its row\'s `r'
    'esourceId` names. An annotation has one."},"references":{"type":"REFERENCES","fr'
    'om":"annotation","to":"resource","says":"The resource the annotation links to, t'
    "he one its row's `source` names, held or a stub. An annotation has one where its"
    ' row has a `source`, and none where it has not."},"taggedAs":{"type":"TAGGED_AS"'
    ',"from":"annotation","to":"entityType","says":"One of the annotation\'s entity ta'
    'gs, the entity type of that name. An annotation has one to each of its tags."}},'
    '"stub":{"node":"resource","marker":"stub"}}'
)
"""protocol/specs/src/graph/schema.json, read as `GraphSchema`."""

JOBS_BUDGETS: Final = JobsBudgets.model_validate_json(
    '{"$comment":"AUTHORITY for the retry budget of each job type (JOBS.md \\u00a7 The'
    " record): the `maxRetries` the dispatcher writes into a new job's record, by its"
    " type. One row for each JobType. Whether a failed attempt is retried within the "
    'budget is jobs/retry-cases.json\'s.","budgets":[{"jobType":"mark","maxRetries":1}'
    ',{"jobType":"yield","maxRetries":0}]}'
)
"""protocol/specs/src/jobs/budgets.json, read as `JobsBudgets`."""

JOBS_STORAGE: Final = JobsStorage.model_validate_json(
    '{"$comment":"Where the job queue keeps its state on the broker: the names and su'
    "bjects every implementation of the queue must use, so that work queued by one su"
    "rvives a switch to another. The queue is JetStream. A job is published once, whe"
    "n it is created, on `<subjectRoot>.<jobType>` into the work-queue stream `stream"
    ".name`, which captures every subject under the root; the durable consumer `consu"
    "mer.durableName` delivers each message to the dispatcher that holds it as the jo"
    "b's lease. The job itself lives in the KV bucket `bucket.name`, one JobRecord pe"
    "r job keyed by the job's id, and every change to a record is a compare-and-swap "
    "on its revision. The stream is a work queue; the consumer acknowledges explicitl"
    "y, delivers from the start, and never gives a message up on its own count (the q"
    "ueue decides retries); the bucket keeps one revision per key. The dispatcher cre"
    "ates the stream, the consumer and the bucket when they are missing and never upd"
    "ates them, so a changed setting takes effect only on a broker that has not seen "
    'them.","stream":{"name":"JOBS","subjectRoot":"jobs"},"consumer":{"durableName":"'
    'dispatcher-leases"},"bucket":{"name":"jobs","record":"JobRecord"}}'
)
"""protocol/specs/src/jobs/storage.json, read as `JobsStorage`."""

SERVICE_ENVIRONMENT_BOOT_REFUSALS: Final = ServiceEnvironmentBootRefusals.model_validate_json(
    '{"$comment":"AUTHORITY for what a service that reads a configuration document wr'
    "ites when it will not start on that document or on its environment: `line`, once"
    ", to stderr, with the refusal in place of `{refusal}`, and then it exits with `e"
    "xitCode` without ever serving. `services` is each service that refuses so; each "
    "refusal is one of `refusals`, word for word, with each `{name}` filled as the ro"
    "w's `situation` says and nothing else varying. `{service}` is the service's name"
    ", as `services` writes it, and `{schema}` its document's schema: `GatewayConfig`"
    ", `ArchivistConfig` or `DispatcherConfig`. The refusals are checked in the order"
    " they are listed, and the first that fails is the one written. A refusal never c"
    "arries a value of the document or of the environment: it names members and varia"
    'bles.","services":["gateway","archivist","dispatcher"],"line":"[fatal] {refusal}'
    '","exitCode":1,"refusals":[{"name":"unnamed","situation":"Started without `--con'
    'fig <path>` or `--config=<path>` naming a path.","refusal":"The {service}\'s conf'
    'iguration document is not named: start it with --config <path>"},{"name":"unread'
    'able","situation":"The path names no file the service can read: `{path}` is the '
    'path as it was given, and `{reason}` the system\'s reason, which varies.","refusa'
    'l":"Cannot read the {service}\'s configuration document at {path} ({reason}). The'
    " launcher writes it; a {service} started another way is given one ({schema} in p"
    'rotocol/specs/)."},{"name":"not-json","situation":"The file is not JSON: `{path}'
    "` is the path as it was given, and `{reason}` the parser's reason, which varies."
    '","refusal":"{path} is not JSON: {reason}"},{"name":"invalid","situation":"The d'
    "ocument is not its schema's: `{path}` is the path as it was given, and `{members"
    '}` is one line of `members` for each way it is not, each on a line of its own.",'
    '"refusal":"{path} is not a {service} configuration document ({schema}):\\n{member'
    's}"},{"name":"no-service-account","situation":"`XYNOLOG_OIDC_CLIENT_ID` or `XYNO'
    "LOG_OIDC_CLIENT_SECRET` is unset or empty: `{missing}` is each that is, in that "
    'order, joined by ` and `.","refusal":"{missing} not set \\u2014 this {service} ha'
    "s no service account to sign in with.\\nThe launcher passes both for each service"
    " it starts; a {service} started another way needs the client its realm registers"
    ' for it (XYNOLOG_OIDC_CLIENT_ID=xynolog-{service})."},{"name":"unset","situation'
    '":"A member of the document names an environment variable that is unset or empty'
    ': `{field}` is the member\'s JSON pointer, and `{name}` the variable.","refusal":'
    '"{field} names the environment variable {name}, which is not set"}],"members":[{'
    '"name":"missing","situation":"An object without a member its schema requires: `{'
    "pointer}` is the object's JSON pointer, `/` for the document itself, and `{membe"
    'r}` the member.","line":"  {pointer} is missing {member}"},{"name":"undeclared",'
    '"situation":"An object with members its schema does not declare: `{pointer}` is '
    "the object's JSON pointer, `/` for the document itself, and `{members}` the memb"
    'ers, joined by `, `.","line":"  {pointer} does not declare {members}"},{"name":"'
    'other","situation":"Any other way a member is not its schema\'s: `{pointer}` is t'
    "he member's JSON pointer, and `{why}` the validator's words, which vary and neve"
    'r carry the member\'s value.","line":"  {pointer} {why}"}]}'
)
"""protocol/specs/src/service-environment/boot-refusals.json, read as
`ServiceEnvironmentBootRefusals`.
"""

SERVICE_ENVIRONMENT_VARIABLES: Final = ServiceEnvironmentVariables.model_validate_json(
    '{"$comment":"Every environment variable a Xynolog service reads, beside its conf'
    "iguration document (GatewayConfig, DispatcherConfig, ArchivistConfig, LibrarianC"
    "onfig, WeaverConfig, SmelterConfig, WorkerConfig) and the variables that documen"
    "t names (the gateway's signal.userEnv and signal.passwordEnv, the dispatcher's q"
    "ueue.userEnv and queue.passwordEnv, the Librarian's, the Weaver's and the Smelte"
    "r's secrets for their stores and providers, and the keys a worker's engines name"
    " by apiKeyEnv). A service, in any language, reads the rows that list it and no v"
    "ariable the table does not list for it \\u2014 beyond the standard OTEL_* variabl"
    "es an OpenTelemetry SDK reads on its own, and the options variable of the alloca"
    "tor it links (jemalloc's _RJEM_MALLOC_CONF, which it reads before any of its cod"
    "e runs), which the table neither promises nor refuses. `services` names the serv"
    "ices that read each. `readBy` says what reads it: `service`, the service's own c"
    "ode, Xynolog's SDK and libraries among it \\u2014 which, for a service written in"
    " Rust, the images repository's `scripts/check-service-environment.mjs`, which it"
    "s CI runs, scans in both directions, over its crate and every workspace and SDK "
    "crate it links: a read not listed for that service fails it, and so does a row n"
    "othing in it reads; `opentelemetry`, the OpenTelemetry SDK. `providedBy` says wh"
    "at sets each where the launcher runs the service: `launcher`, `image` (the image"
    " or its supervisor sets it; checked there), or `operator` (nothing sets it; an o"
    "perator may). A service's conformance suite sets only the rows that list it, and"
    " exercises each by name; one gateway case also sets a variable a runtime would r"
    'ead for itself (TOKIO_WORKER_THREADS), to show that it changes nothing.","variab'
    'les":[{"name":"JWT_SECRET","services":["gateway"],"readBy":"service","providedBy'
    '":"launcher","required":true,"effect":"The gateway\'s signing key ring: comma-sep'
    "arated keys of at least 32 characters, whitespace around each ignored. Media tok"
    "ens are signed with the first key, and a media token signed with any key is acce"
    "pted. Unset, or with a key shorter than 32 characters, the gateway refuses to st"
    'art."},{"name":"XYNOLOG_OIDC_CLIENT_ID","services":["gateway","dispatcher","arch'
    'ivist","librarian","weaver","smelter"],"readBy":"service","providedBy":"launcher'
    '","required":true,"effect":"The client id of the service\'s own account at the is'
    "suer, whose token the service signs in with: the gateway's reaches the Archivist"
    ", and every other service's is its bearer at the bus. Unset, the service refuses"
    ' to start."},{"name":"XYNOLOG_OIDC_CLIENT_SECRET","services":["gateway","dispatc'
    'her","archivist","librarian","weaver","smelter"],"readBy":"service","providedBy"'
    ':"launcher","required":true,"effect":"That account\'s secret. Unset, the service '
    'refuses to start, and its output never carries the value."},{"name":"XYNOLOG_OID'
    'C_CLIENT_KEY","services":["worker"],"readBy":"service","providedBy":"launcher","'
    'required":true,"effect":"The worker\'s key: an RSA private key, PEM and unencrypt'
    "ed, whose public half each knowledge base's issuer holds on the client the worke"
    "r's document names there. Each sign-in carries an assertion signed with it (priv"
    "ate_key_jwt), and no secret. Unset or empty, a key it cannot read, or one that i"
    's not RSA, the worker refuses to start (WORKER-SERVICE.md B3)."},{"name":"OTEL_E'
    'XPORTER_OTLP_ENDPOINT","services":["gateway","dispatcher","archivist","librarian'
    '","weaver","smelter","worker"],"readBy":"service","providedBy":"launcher","requi'
    'red":false,"effect":"The OTLP/HTTP collector spans and metrics are exported to. '
    'Unset, with OTEL_CONSOLE_EXPORTER not `true`, nothing is exported."},{"name":"OT'
    'EL_SERVICE_NAME","services":["gateway","dispatcher","archivist","librarian","wea'
    'ver","smelter","worker"],"readBy":"service","providedBy":"operator","required":f'
    'alse,"effect":"The `service.name` exported spans and metrics carry; `xynolog-` a'
    'nd the service\'s name, such as `xynolog-gateway`, when unset."},{"name":"OTEL_SD'
    'K_DISABLED","services":["gateway","dispatcher","archivist","librarian","weaver",'
    '"smelter","worker"],"readBy":"service","providedBy":"operator","required":false,'
    '"effect":"`true` exports nothing, whatever else is set."},{"name":"OTEL_CONSOLE_'
    'EXPORTER","services":["gateway","dispatcher","archivist","librarian","weaver","s'
    'melter","worker"],"readBy":"service","providedBy":"operator","required":false,"e'
    'ffect":"`true`, with no OTEL_EXPORTER_OTLP_ENDPOINT, writes spans and metrics to'
    ' the service\'s output instead of exporting them."},{"name":"OTEL_METRICS_EXPORTE'
    'R","services":["gateway","dispatcher","archivist","librarian","weaver","smelter"'
    ',"worker"],"readBy":"service","providedBy":"operator","required":false,"effect":'
    "\"`console` writes metrics to the service's output, while spans still go to OTEL_"
    'EXPORTER_OTLP_ENDPOINT."},{"name":"OTEL_METRIC_EXPORT_INTERVAL","services":["gat'
    'eway","dispatcher","archivist","librarian","weaver","smelter","worker"],"readBy"'
    ':"service","providedBy":"operator","required":false,"effect":"Milliseconds betwe'
    'en metric exports; 30000 when unset or not a positive integer."},{"name":"OTEL_B'
    'SP_SCHEDULE_DELAY","services":["gateway","dispatcher","archivist","librarian","w'
    'eaver","smelter","worker"],"readBy":"opentelemetry","providedBy":"operator","req'
    'uired":false,"effect":"Milliseconds a finished span waits to be exported in a ba'
    'tch; 5000 when unset."},{"name":"XYNOLOG_BUS_LOG","services":["gateway","dispatc'
    'her","archivist","librarian","weaver","smelter","worker"],"readBy":"service","pr'
    'ovidedBy":"operator","required":false,"effect":"Any non-empty value writes one `'
    "[bus <op>] <channel> \\u2026` line to the service's output for each frame it send"
    's, accepts, receives or delivers, and each content read."},{"name":"SUPERVISE_EV'
    'ENTS","services":["gateway","dispatcher","archivist","librarian","weaver","smelt'
    'er","worker"],"readBy":"service","providedBy":"image","required":false,"effect":'
    "\"The supervisor's events log, one `starting <SUPERVISE_NAME>` line per life of t"
    "he process. With SUPERVISE_NAME, the service reports `xynolog.process.restarts` "
    'from it: its lives, less one. Without either, the metric does not exist."},{"nam'
    'e":"SUPERVISE_NAME","services":["gateway","dispatcher","archivist","librarian","'
    'weaver","smelter","worker"],"readBy":"service","providedBy":"image","required":f'
    'alse,"effect":"The name the supervisor records each life under, in SUPERVISE_EVE'
    'NTS."}]}'
)
"""protocol/specs/src/service-environment/variables.json, read as `ServiceEnvironmentVariables`."""

SERVICE_TELEMETRY_LOG_LINES: Final = ServiceTelemetryLogLines.model_validate_json(
    '{"$comment":"AUTHORITY for the lines a service writes to its log, and for the su'
    "pervisor's line it reads. THE LOGGER of a service whose document names a LogForm"
    "at writes one line to stdout for each thing it logs at or above its LogLevel. A "
    "`json` line is one JSON object: its `first` members, the level's name in lower c"
    "ase and the message; then the fields the line was logged with; then `requestId`,"
    " the request's id (gateway/response-headers.json's `requestId`), on a line logge"
    "d while a request was answered; then the active trace's id and span's id in lowe"
    "r-case hex, 32 and 16 digits, on a line logged inside one; and `last`, the momen"
    "t in UTC as RFC 3339 with milliseconds. A `simple` line is `simple`, with `{time"
    "stamp}` the moment in UTC as `YYYY-MM-DD hh:mm:ss`, `{LEVEL}` the level's name i"
    "n upper case, and then, when the line has any fields, a space and the JSON objec"
    "t of them, `requestId` and the trace's among them. THE BUS LOG (EVENT-BUS.md \\u0"
    "0a7 Wire format: the bus log), switched on by XYNOLOG_BUS_LOG, writes one line f"
    "or each frame its process sends or receives: `line`, with `{op}` one of `ops` an"
    "d `{channel}` the frame's channel, or `content` for an upload or a read of bytes"
    "; then each of `parts` there is one of, with the first `characters` of it; then "
    "a space and the payload, as bus/log-cases.json says it is shown. THE SUPERVISOR "
    "writes `line` each time it starts the service, with `{time}` the moment in UTC a"
    "s `YYYY-MM-DDThh:mm:ssZ`, `{name}` SUPERVISE_NAME and `{count}` the rapid failur"
    "es so far, to the file SUPERVISE_EVENTS names; a service counts each line of tha"
    't file that holds `counted` as one of its lives.","logger":{"services":["archivi'
    'st","dispatcher","gateway"],"json":{"first":["level","message"],"requestId":"req'
    'uestId","trace":["trace_id","span_id"],"last":"timestamp"},"simple":"{timestamp}'
    ' [{LEVEL}] {message}"},"bus":{"line":"[bus {op}] {channel}","parts":[{"part":"th'
    'e frame\'s scope","text":" scope={scope}"},{"part":"the frame\'s correlationId","t'
    'ext":" cid={correlationId}","characters":8},{"part":"the active trace\'s id","tex'
    't":" trace={traceId}","characters":8}],"ops":["EMIT","RECV","SSE","PUT","GET"]},'
    '"supervisor":{"line":"[supervise {time}] starting {name} (rapid failures so far:'
    ' {count})","counted":"starting {name}"}}'
)
"""protocol/specs/src/service-telemetry/log-lines.json, read as `ServiceTelemetryLogLines`."""

SERVICE_TELEMETRY_TELEMETRY: Final = ServiceTelemetryTelemetry.model_validate_json(
    '{"$comment":"The telemetry each Xynolog service exports over OTLP, in any langua'
    "ge: every span and metric, the services that export it, its kind, and the attrib"
    "utes it carries. A service exports the rows that list it and no others. Each ser"
    "vice's conformance suite holds it to this table from outside, in both directions"
    ": every span and metric its observability cases receive must be a row listing th"
    "e service, of the listed kind, carrying only listed attribute keys (and, where a"
    " row lists values, only those values); and every row listing it whose `when` is "
    "`export` or `traffic` must arrive, with every attribute not marked `only`. `when"
    "`: `export` \\u2014 whenever export is on; `traffic` \\u2014 once the service's ob"
    "servability cases' traffic has run; `supervised` \\u2014 only under the superviso"
    "r (SUPERVISE_EVENTS and SUPERVISE_NAME set), checked by the environment cases; `"
    "fatal` \\u2014 only on a fatal error, which no case causes. `planes`, where given"
    ", names the only signal planes a gateway row arrives on. `sdk` names the service"
    "s that reach the bus through an SDK, and for each the SDK transports it uses, or"
    ", of a transport it uses part of, the rows it exports, by name: such a service a"
    "lso exports the rows specs/src/sdk-telemetry/telemetry.json lists for those tran"
    "sports, and those rows, and its suite holds it to both tables as one. In a span "
    "name, `{channel}` is the bus channel. `{jobType}` is the job's type. Span kinds "
    "are OTLP's; a metric's `instrument` is `counter` (a monotonic sum), `up-down cou"
    "nter` (a non-monotonic sum), `gauge` or `histogram`. `resource` lists the attrib"
    "utes of the resource every span and metric of a service is exported under, and t"
    "he services that carry each: a service's resource carries exactly the keys liste"
    'd for it.","sdk":{"dispatcher":["bus"],"archivist":["bus"],"worker":["bus","cont'
    'ent.put","content.get","content.get_anchored_text"],"weaver":["bus"],"smelter":['
    '"bus"],"librarian":["bus","content.get_anchored_text"]},"resource":[{"key":"serv'
    'ice.name","services":["archivist","dispatcher","gateway","librarian","smelter","'
    'weaver","worker"],"meaning":"The service\'s name: what `OTEL_SERVICE_NAME` says, '
    'or, when it is unset, `default` with `{service}` the service\'s name.","default":'
    '"xynolog-{service}"},{"key":"service.version","services":["archivist","dispatche'
    'r","gateway","librarian","smelter","weaver","worker"],"meaning":"The version of '
    'Xynolog the service was built as."},{"key":"xynolog.kb","services":["gateway","d'
    'ispatcher","archivist","librarian","smelter","weaver"],"meaning":"The DID of the'
    " knowledge base the service serves: `kb_did` of its document's `kb.domain`, or, "
    "for the Archivist, which reads what the knowledge base says of itself from its t"
    "ree, of the `site.domain` its committed `.xynolog/config.yaml` names. A service "
    "that serves several knowledge bases names none in its resource, and carries `xyn"
    "olog.kb` instead on each span and data point of its own rows that list it: the D"
    'ID of the knowledge base whose job the work was."}],"spans":[{"name":"bus.dispat'
    'ch:{channel}","services":["gateway"],"kind":"server","when":"traffic","meaning":'
    "\"An emit the gateway accepted, in the caller's trace when the request carried on"
    'e.","attributes":[{"key":"bus.channel"}]},{"name":"sse.deliver:{channel}","servi'
    'ces":["gateway"],"kind":"producer","when":"traffic","meaning":"A correlated repl'
    'y written to the stream of the client whose request it answers.","attributes":[{'
    '"key":"bus.channel"},{"key":"bus.cid"},{"key":"bus.scope","only":"on a reply in '
    'a resource scope"}]},{"name":"content.get.server","services":["gateway"],"kind":'
    '"server","when":"traffic","meaning":"A read of a resource\'s bytes.","attributes"'
    ':[{"key":"resource.id"}]},{"name":"content.put.server","services":["gateway"],"k'
    'ind":"server","when":"traffic","meaning":"An upload.","attributes":[]},{"name":"'
    'archivist.resources.record","services":["gateway"],"kind":"client","when":"traff'
    'ic","meaning":"An upload forwarded to the Archivist.","attributes":[{"key":"peer'
    '.service","values":["archivist"]}]},{"name":"archivist.resources.describe","serv'
    'ices":["gateway"],"kind":"client","when":"traffic","meaning":"A JSON-LD descript'
    'ion asked of the Archivist.","attributes":[{"key":"peer.service","values":["arch'
    'ivist"]}]},{"name":"archivist.resources.annotations","services":["gateway"],"kin'
    'd":"client","when":"traffic","meaning":"A resource\'s annotations asked of the Ar'
    'chivist.","attributes":[{"key":"peer.service","values":["archivist"]}]},{"name":'
    '"archivist.resources.anchored_text","services":["gateway"],"kind":"client","when'
    '":"traffic","meaning":"A resource\'s anchored text asked of the Archivist.","attr'
    'ibutes":[{"key":"peer.service","values":["archivist"]}]},{"name":"archivist.cont'
    'ent.get","services":["gateway"],"kind":"client","when":"traffic","meaning":"Byte'
    's read from the Archivist.","attributes":[{"key":"peer.service","values":["archi'
    'vist"]}]},{"name":"archivist.events.replay","services":["gateway"],"kind":"clien'
    't","when":"traffic","meaning":"A scope\'s persisted events read from the Archivis'
    't for a replay.","attributes":[{"key":"peer.service","values":["archivist"]}]},{'
    '"name":"job:{jobType}","services":["worker"],"kind":"consumer","when":"traffic",'
    '"meaning":"A job a worker held, from the claim that handed it over to its conclu'
    'sion.","attributes":[{"key":"job.type","values":["mark","yield"]},{"key":"job.mo'
    'tivation","values":["highlighting","commenting","assessing","linking","tagging"]'
    ',"only":"on a mark job"},{"key":"job.id"},{"key":"resource.id"},{"key":"xynolog.'
    'kb"}]},{"name":"detection:prepare","services":["worker"],"kind":"internal","when'
    '":"traffic","meaning":"A mark job\'s reading of its resource: the description\'s m'
    'edia type, and the text read by it.","attributes":[{"key":"resource.id"},{"key":'
    '"media.type"},{"key":"xynolog.kb"}]},{"name":"inference:structured","services":['
    '"worker"],"kind":"internal","when":"traffic","meaning":"One generation a worker '
    "asked of its provider for an array of objects, from the request to its answer or"
    ' its time bound.","attributes":[{"key":"inference.provider","values":["anthropic'
    '","google","llamacpp","ollama","openai","together","vllm"]},{"key":"inference.mo'
    'del"},{"key":"inference.max_tokens"},{"key":"xynolog.kb"}]},{"name":"inference:t'
    'ext","services":["worker"],"kind":"internal","when":"traffic","meaning":"One gen'
    "eration a worker asked of its provider for text, from the request to its answer "
    'or its time bound.","attributes":[{"key":"inference.provider","values":["anthrop'
    'ic","google","llamacpp","ollama","openai","together","vllm"]},{"key":"inference.'
    'model"},{"key":"inference.max_tokens"},{"key":"xynolog.kb"}]}],"metrics":[{"name'
    '":"xynolog.bus.emit","services":["gateway"],"instrument":"counter","when":"traff'
    'ic","meaning":"Emits the gateway accepted.","attributes":[{"key":"bus.channel"},'
    '{"key":"bus.scope","only":"on an emit in a resource scope"}]},{"name":"xynolog.b'
    'us.reply.suppressed","services":["gateway"],"instrument":"counter","when":"traff'
    'ic","meaning":"Correlated replies withheld from a subscriber that did not ask fo'
    'r them.","attributes":[{"key":"bus.channel"}]},{"name":"xynolog.bus.resume_gap",'
    '"services":["gateway"],"instrument":"counter","when":"traffic","meaning":"Resume'
    's answered with a gap, by the gap\'s reason.","attributes":[{"key":"bus.resume_ga'
    'p.reason"}]},{"name":"xynolog.bus.unanswerable","services":["gateway"],"instrume'
    'nt":"counter","when":"traffic","meaning":"Requests no participant could answer; '
    'only a plane that can count subscribers counts them.","attributes":[{"key":"bus.'
    'channel"}],"planes":["in-process"]},{"name":"xynolog.sse.subscribers","services"'
    ':["gateway"],"instrument":"up-down counter","when":"traffic","meaning":"Open bus'
    ' streams.","attributes":[]},{"name":"xynolog.gateway.refused","services":["gatew'
    'ay"],"instrument":"counter","when":"traffic","meaning":"Requests a limit refused'
    " \\u2014 a principal's streams or emit bucket, a client's unanswered requests, th"
    "e process's queued bytes, the requests a holder has had refused \\u2014 and conne"
    'ctions closed at its connection cap.","attributes":[{"key":"refused.reason","val'
    'ues":["streams","emit-rate","unanswered-requests","capacity","refusal-rate","con'
    'nections"]}]},{"name":"xynolog.gateway.unauthenticated","services":["gateway"],"'
    'instrument":"counter","when":"traffic","meaning":"Requests answered 401, by why:'
    ' no bearer token, a bearer token refused, a media token refused.","attributes":['
    '{"key":"unauthenticated.reason","values":["missing_token","invalid_token","inval'
    'id_media_token"]}]},{"name":"xynolog.bus.correlation.size","services":["gateway"'
    '],"instrument":"gauge","when":"export","meaning":"Outstanding request claims, an'
    'd the cap on them.","attributes":[{"key":"correlation.kind","values":["claims","'
    'claims_max"]}]},{"name":"xynolog.process.start_time","services":["gateway","disp'
    'atcher","archivist","worker","weaver","smelter","librarian"],"instrument":"gauge'
    '","when":"export","meaning":"When the process started.","attributes":[]},{"name"'
    ':"xynolog.runtime.event_loop.lag","services":["gateway","dispatcher","archivist"'
    ',"worker","weaver","smelter","librarian"],"instrument":"gauge","when":"export","'
    'meaning":"Time the process could not serve anything, over the last export interv'
    'al.","attributes":[{"key":"lag.stat","values":["mean","p99","max"]}]},{"name":"x'
    'ynolog.runtime.heap","services":["gateway","dispatcher","archivist","worker","we'
    'aver","smelter","librarian"],"instrument":"gauge","when":"export","meaning":"Mem'
    'ory in use, allocated, allowed, and resident.","attributes":[{"key":"heap.stat",'
    '"values":["used","total","limit","rss"]}]},{"name":"xynolog.process.restarts","s'
    'ervices":["gateway","dispatcher","archivist","worker","weaver","smelter","librar'
    'ian"],"instrument":"gauge","when":"supervised","meaning":"Lives the supervisor r'
    'ecorded, less one.","attributes":[]},{"name":"xynolog.process.abnormal_exit","se'
    'rvices":["gateway","dispatcher","archivist","worker","weaver","smelter","librari'
    'an"],"instrument":"counter","when":"fatal","meaning":"A fatal error, just before'
    ' the process exits.","attributes":[{"key":"reason","values":["uncaughtException"'
    ',"unhandledRejection"]}]},{"name":"xynolog.job.queue.size","services":["dispatch'
    'er"],"instrument":"gauge","when":"export","meaning":"The jobs in the queue, by s'
    'tatus.","attributes":[{"key":"job.status","values":["pending","running","complet'
    'e","failed","cancelled"]}]},{"name":"xynolog.vector.index.size","services":["sme'
    'lter"],"instrument":"gauge","when":"export","meaning":"Points the vector index h'
    'olds, of resources and of annotations together.","attributes":[]},{"name":"xynol'
    'og.archivist.fact_pump.depth","services":["archivist"],"instrument":"gauge","whe'
    'n":"export","meaning":"Events appended to the record and not yet published on th'
    'e bus. Zero at rest; a rising floor means publishing is behind its transport.","'
    'attributes":[]},{"name":"xynolog.git.duration","services":["archivist"],"instrum'
    'ent":"histogram","when":"traffic","meaning":"How long each git command the stagi'
    'ng driver ran took, in milliseconds, the failing ones too.","attributes":[{"key"'
    ':"git.command","values":["add","rm","rev-parse"]}]},{"name":"xynolog.git.staging'
    '.failures","services":["archivist"],"instrument":"counter","when":"traffic","mea'
    'ning":"Staging degradations: changes recorded and not staged, by why.","attribut'
    'es":[{"key":"reason","values":["index-lock","other"]}]},{"name":"xynolog.job.out'
    'come","services":["worker"],"instrument":"counter","when":"traffic","meaning":"T'
    'he jobs a worker concluded, by how.","attributes":[{"key":"job.type","values":["'
    'mark","yield"]},{"key":"job.motivation","values":["highlighting","commenting","a'
    'ssessing","linking","tagging"],"only":"on a mark job"},{"key":"job.outcome","val'
    'ues":["completed","failed","cancelled"]},{"key":"xynolog.kb"}]},{"name":"xynolog'
    '.job.duration","services":["worker"],"instrument":"histogram","when":"traffic","'
    'meaning":"How long a worker held a job, in milliseconds.","attributes":[{"key":"'
    'job.type","values":["mark","yield"]},{"key":"job.motivation","values":["highligh'
    'ting","commenting","assessing","linking","tagging"],"only":"on a mark job"},{"ke'
    'y":"job.outcome","values":["completed","failed","cancelled"]},{"key":"xynolog.kb'
    '"}]},{"name":"xynolog.inference.calls","services":["worker","librarian"],"instru'
    'ment":"counter","when":"traffic","meaning":"The generations a service asked of i'
    'ts providers, by how each ended.","attributes":[{"key":"inference.provider","val'
    'ues":["anthropic","google","llamacpp","ollama","openai","together","vllm"]},{"ke'
    'y":"inference.model"},{"key":"inference.outcome","values":["success","error"]}]}'
    ',{"name":"xynolog.inference.duration","services":["worker","librarian"],"instrum'
    'ent":"histogram","when":"traffic","meaning":"How long each generation took, in m'
    'illiseconds, the failing ones too.","attributes":[{"key":"inference.provider","v'
    'alues":["anthropic","google","llamacpp","ollama","openai","together","vllm"]},{"'
    'key":"inference.model"},{"key":"inference.outcome","values":["success","error"]}'
    ']},{"name":"xynolog.inference.tokens","services":["worker","librarian"],"instrum'
    'ent":"counter","when":"traffic","meaning":"The tokens a provider reported for a '
    "generation, read and written. A generation whose provider reports none adds noth"
    'ing.","attributes":[{"key":"inference.provider","values":["anthropic","google","'
    'llamacpp","ollama","openai","together","vllm"]},{"key":"inference.model"},{"key"'
    ':"inference.direction","values":["input","output"]}]},{"name":"xynolog.detection'
    '.calls","services":["worker"],"instrument":"counter","when":"traffic","meaning":'
    '"The generations a mark job made, by what asked, how each ended, how many times '
    "its piece had been halved, and whether it was the second asking of a piece too s"
    'mall to halve.","attributes":[{"key":"detection.label","values":["highlight","co'
    'mment","assessment","tag","reference"]},{"key":"detection.outcome","values":["su'
    'ccess","truncated","timeout","collapsed","error"]},{"key":"detection.depth"},{"k'
    'ey":"detection.reroll","values":[true,false]},{"key":"xynolog.kb"}]},{"name":"xy'
    'nolog.detection.call.duration","services":["worker"],"instrument":"histogram","w'
    'hen":"traffic","meaning":"How long each of those generations took, in millisecon'
    'ds, the failing ones too.","attributes":[{"key":"detection.label","values":["hig'
    'hlight","comment","assessment","tag","reference"]},{"key":"detection.outcome","v'
    'alues":["success","truncated","timeout","collapsed","error"]},{"key":"detection.'
    'depth"},{"key":"detection.reroll","values":[true,false]},{"key":"xynolog.kb"}]},'
    '{"name":"xynolog.detection.call.items","services":["worker"],"instrument":"histo'
    'gram","when":"traffic","meaning":"The proposals each of those generations return'
    'ed; none, for one that failed.","attributes":[{"key":"detection.label","values":'
    '["highlight","comment","assessment","tag","reference"]},{"key":"detection.outcom'
    'e","values":["success","truncated","timeout","collapsed","error"]},{"key":"detec'
    'tion.depth"},{"key":"detection.reroll","values":[true,false]},{"key":"xynolog.kb'
    '"}]},{"name":"xynolog.detection.call.tokens","services":["worker"],"instrument":'
    '"histogram","when":"traffic","meaning":"The tokens a provider reported for each '
    "of those generations, read and written. A generation whose provider reports none"
    ' adds nothing.","attributes":[{"key":"detection.label","values":["highlight","co'
    'mment","assessment","tag","reference"]},{"key":"detection.outcome","values":["su'
    'ccess","truncated","timeout","collapsed","error"]},{"key":"detection.depth"},{"k'
    'ey":"detection.reroll","values":[true,false]},{"key":"detection.direction","valu'
    'es":["input","output"]},{"key":"xynolog.kb"}]},{"name":"xynolog.detection.anchor'
    's","services":["worker"],"instrument":"counter","when":"traffic","meaning":"The '
    'spans a mark job anchored in its text, by how each was found.","attributes":[{"k'
    'ey":"detection.label","values":["highlight","comment","assessment","tag","refere'
    'nce"]},{"key":"anchor.method","values":["unique-match","context-recovered","firs'
    't-of-many","fuzzy-match"]},{"key":"xynolog.kb"}]},{"name":"xynolog.gather.degrad'
    'ed","services":["librarian"],"instrument":"counter","when":"traffic","meaning":"'
    "Gathers that went without something, by what each went without: the graph, which"
    " did not come to hold the resource; the vector index, which failed or did not se"
    "ttle in time; or what a model failed to give, which is the summary and suggestio"
    "ns of a resource, the summary of the resource an annotation links to, or the rel"
    'ationship sentence.","attributes":[{"key":"projection","values":["graph","vector'
    's","suggestions","summary","relationship"]}]}]}'
)
"""protocol/specs/src/service-telemetry/telemetry.json, read as `ServiceTelemetryTelemetry`."""

SMELTER_MESSAGES: Final = SmelterMessages.model_validate_json(
    '{"$comment":"AUTHORITY for the words of the Smelter\'s refusals and of the messag'
    "es it logs that a reader of its output relies on (SMELTER.md), word for word. A "
    "text's `{name}` is filled as the row's `situation` says, and nothing else in it "
    "varies. `refusals` is each refusal of an operation, the `message` of its failure"
    ". `logged` is each message the Smelter logs, at its `level`, with the facts name"
    "d in `fields`, each of the form given, and the facts named in `carries` beside t"
    'hem.","refusals":[{"name":"rebuild-incomplete","operation":"smelt:rebuild-anchor'
    's","situation":"A rebuild of anchored text that could not do every resource it s'
    "et out to (SMELTER.md \\u00a7 Rebuild): `{failed}` is how many it could not do, a"
    'nd `{total}` how many it set out to do, each in decimal digits.","message":"{fai'
    'led} of {total} resources failed to re-anchor: see the Smelter\'s log"}],"logged"'
    ':[{"name":"not-indexed","level":"warn","situation":"A resource the Smelter decid'
    "ed not to index (SMELTER.md \\u00a7 What it decides): `{resourceId}` is the resou"
    "rce, `{reason}` the `reason` its `smelt:settled` carries, `{mediaType}` the medi"
    'a type its bytes were read as, and `{checksum}` the checksum of those bytes.","m'
    'essage":"Smelter did not index resource","fields":{"resourceId":"{resourceId}","'
    'reason":"{reason}","contentType":"{mediaType}","contentChecksum":"{checksum}"},"'
    'carries":[]},{"name":"content-unread","level":"warn","situation":"A resource who'
    "se bytes the Smelter could not read (SMELTER.md \\u00a7 What it decides): `{resou"
    'rceId}` is the resource. `error` says why.","message":"Smelter could not read re'
    'source content","fields":{"resourceId":"{resourceId}"},"carries":["error"]},{"na'
    'me":"event-failed","level":"error","situation":"An event the Smelter could not a'
    "pply because its embedding provider failed a request (SMELTER.md \\u00a7 The embe"
    "dding provider): `{resourceId}` is the event's resource, `{provider}` the provid"
    "er's `type` (EmbeddingConfig), `{model}` the model it was asked for, and `{statu"
    "s}` the status it answered with. `slice` is which request of the batch it was, a"
    'nd `error` says why.","message":"Smelter failed to process event","fields":{"res'
    'ourceId":"{resourceId}","provider":"{provider}","model":"{model}","status":"{sta'
    'tus}"},"carries":["slice","error"]}]}'
)
"""protocol/specs/src/smelter/messages.json, read as `SmelterMessages`."""

WORKER_ANSWER_FORMATS: Final = WorkerAnswerFormats.model_validate_json(
    '{"$comment":"AUTHORITY for what a Worker service asks a model to answer in (WORK'
    "ER-SERVICE.md \\u00a7 The request, \\u00a7 The five kinds of mark job): the JSON S"
    "chema of one element of the array a detection asks for. `formats` has one row fo"
    "r each motivation a `mark` job takes (MarkJobParams), named by it, and `count`, "
    "the count a linking job asks of each piece beside its extraction. A request asks"
    ' for an array of `element`: on an Ollama engine as `format`, `{\\"type\\": \\"array'
    '\\", \\"items\\": <element>}` (D1), and on an Anthropic one as `output_config`, `{\\'
    '"format\\": {\\"type\\": \\"json_schema\\", \\"schema\\": {\\"type\\": \\"array\\", \\"items'
    '\\": <element>}}}` (D20), the element written as it is here, member for member. A'
    ' generation (a `yield` job) asks for no format: its answer is the document.","fo'
    'rmats":[{"name":"highlighting","about":"A highlight: the passage, and up to 64 c'
    'haracters before and after it (K1).","element":{"type":"object","properties":{"e'
    'xact":{"type":"string"},"prefix":{"type":"string"},"suffix":{"type":"string"}},"'
    'required":["exact"],"additionalProperties":false}},{"name":"commenting","about":'
    '"A comment: the passage, the comment, and what stands before and after (K2).","e'
    'lement":{"type":"object","properties":{"exact":{"type":"string"},"comment":{"typ'
    'e":"string"},"prefix":{"type":"string"},"suffix":{"type":"string"}},"required":['
    '"exact","comment"],"additionalProperties":false}},{"name":"assessing","about":"A'
    "n assessment: the passage, the assessment, and what stands before and after (K3)"
    '.","element":{"type":"object","properties":{"exact":{"type":"string"},"assessmen'
    't":{"type":"string"},"prefix":{"type":"string"},"suffix":{"type":"string"}},"req'
    'uired":["exact","assessment"],"additionalProperties":false}},{"name":"linking","'
    'about":"A mention: the passage, the entity type it is a mention of, and what sta'
    'nds before and after (K4).","element":{"type":"object","properties":{"exact":{"t'
    'ype":"string"},"entityType":{"type":"string"},"prefix":{"type":"string"},"suffix'
    '":{"type":"string"}},"required":["exact","entityType"],"additionalProperties":fa'
    'lse}},{"name":"tagging","about":"A passage of the category asked for, and what s'
    'tands before and after (K7).","element":{"type":"object","properties":{"exact":{'
    '"type":"string"},"prefix":{"type":"string"},"suffix":{"type":"string"}},"require'
    'd":["exact"],"additionalProperties":false}},{"name":"count","about":"The count a'
    " linking job asks of a piece beside its extraction: how many mentions of the typ"
    'e it holds (K4).","element":{"type":"object","properties":{"count":{"type":"inte'
    'ger"}},"required":["count"],"additionalProperties":false}}]}'
)
"""protocol/specs/src/worker/answer-formats.json, read as `WorkerAnswerFormats`."""

WORKER_MESSAGES: Final = WorkerMessages.model_validate_json(
    '{"$comment":"AUTHORITY for the words of a Worker service\'s refusals to start, of'
    " the errors it fails a job with, and of the messages it logs that a reader of it"
    "s output relies on (WORKER-SERVICE.md), word for word. A text's `{name}` is fill"
    "ed as the row's `situation` says, and nothing else in it varies; a hole whose wo"
    "rds the situation says vary is some text on one line. `boot` is each refusal to "
    "start, written in service-environment/boot-refusals.json's `line`, once, to stde"
    "rr, before the service exits with that table's `exitCode`: a row that names `boo"
    "tRefusal` is that table's refusal of that name, its `{service}` `worker` and its"
    " `{schema}` `WorkerConfig`; any other row is the worker's own. `reasons` is each"
    " line of the `{reasons}` of `invalid`. `job` is how an error names the job, by i"
    "ts type, as `{job}`. `errors` is each error a job is failed with whose words a c"
    "lause of WORKER-SERVICE.md names; an error no clause names is the implementation"
    "'s to word; an error that repeats what another said (the record's refusal of a r"
    "esource or of a commit, the claim's of a job the worker stopped holding) is that"
    " one's words, not these. `logged` is each message a Worker service logs, at its "
    "`level`, with the facts named in `fields`, each of the form given, and the facts"
    ' named in `carries` beside them.","boot":[{"name":"unnamed","situation":"Started'
    ' without `--config <path>` or `--config=<path>` naming a path.","bootRefusal":"u'
    'nnamed"},{"name":"unreadable","situation":"The path names no file the service ca'
    'n read.","bootRefusal":"unreadable"},{"name":"not-json","situation":"The file is'
    ' not JSON.","bootRefusal":"not-json"},{"name":"invalid","situation":"The documen'
    "t is not a WorkerConfig: `{path}` is the path as it was given, and `{reasons}` o"
    'ne line of `reasons`, for the first way it is not.","refusal":"{path} is not a w'
    'orker configuration document (WorkerConfig):\\n{reasons}"},{"name":"key-unset","s'
    'ituation":"`XYNOLOG_OIDC_CLIENT_KEY` is unset or empty.","refusal":"XYNOLOG_OIDC'
    "_CLIENT_KEY is not set in the worker's environment: a worker signs in as a servi"
    'ce account"},{"name":"key-unreadable","situation":"`XYNOLOG_OIDC_CLIENT_KEY` is '
    'not a PEM private key the service can read without a passphrase.","refusal":"XYN'
    "OLOG_OIDC_CLIENT_KEY in the worker's environment is not an unencrypted PEM priva"
    'te key"},{"name":"key-not-rsa","situation":"`XYNOLOG_OIDC_CLIENT_KEY` is a priva'
    'te key that is not RSA.","refusal":"XYNOLOG_OIDC_CLIENT_KEY in the worker\'s envi'
    'ronment is not an RSA key: a worker signs its assertions with RS256"},{"name":"a'
    'pi-key-unset","situation":"An engine names, by its `apiKeyEnv`, a variable that '
    "is unset or empty: `{knowledgeBase}` is the index of its knowledge base in `know"
    "ledgeBases`, and `{engine}` its index in that one's `engines`, each in decimal d"
    'igits.","refusal":"knowledgeBases[{knowledgeBase}].engines[{engine}].apiKeyEnv n'
    'ames a variable that is not set in the worker\'s environment"},{"name":"domain-tw'
    'ice","situation":"Two of `knowledgeBases` name one `domain`: `{later}` is the in'
    'dex of the later, and `{earlier}` of the earlier, each in decimal digits.","refu'
    'sal":"knowledgeBases[{later}].domain is the domain of knowledgeBases[{earlier}]:'
    ' a worker serves a knowledge base once"},{"name":"none-admits","situation":"Ever'
    'y knowledge base refused the service before any was confirmed.","refusal":"No kn'
    'owledge base admits this worker: each of its knowledgeBases refused it"},{"name"'
    ':"cannot-listen","situation":"The service cannot listen on its `port`: `{port}` '
    "is the port, in decimal digits, and `{why}` the system's reason, which varies.\","
    '"refusal":"Cannot listen on port {port}: {why}"}],"reasons":[{"name":"missing","'
    'situation":"An object without a member its schema requires: `{member}` is the me'
    'mber\'s name.","line":"  Missing required property: {member}"},{"name":"other","s'
    'ituation":"Any other way the document is not its schema\'s: `{member}` is the nam'
    "es on the way from the document to the member, joined by `.`, with no index of a"
    'n array.","line":"  {member}: is not what the schema states"}],"job":{"mark":"ma'
    'rk ({motivation})","yield":"yield"},"errors":[{"name":"unextractable","situation'
    '":"A job on a resource whose media type has no text the worker can read: `{resou'
    'rceId}` is the resource, and `{mediaType}` its media type.","error":"Cannot run '
    "{job} on resource {resourceId}: media type '{mediaType}' has no extractable text"
    ' to analyze"},{"name":"not-settled","situation":"A job on a resource whose ancho'
    'red text the Smelter has not yet settled: `{resourceId}` is the resource.","erro'
    'r":"Anchored text not yet derived for resource {resourceId} \\u2014 Smelter has n'
    'ot settled; retrying"},{"name":"anchored-declined","situation":"A job on a resou'
    "rce the anchored-text consult declines: `{resourceId}` is the resource, and `{de"
    'clined}` what the consult answered, `no-map` or `unknown`.","error":"Cannot run '
    "{job} on resource {resourceId}: anchored-text consult returned '{declined}'\"},{\""
    'name":"not-served","situation":"A job of a motivation the engine that took it do'
    'es not serve.","error":"Worker not configured for job: {job}"},{"name":"no-proce'
    'ssor","situation":"A tagging job handed over without the schema it names.","erro'
    'r":"No processor for job: {job}"},{"name":"window-too-small","situation":"A mode'
    "l whose window leaves a piece 64 tokens or fewer: `{contextTokens}` is the windo"
    "w, `{scaffoldTokens}` the tokens of the prompt without its piece, and `{inputBud"
    'get}` what is left, each in decimal digits.","error":"Inference window too small'
    " for detection: context {contextTokens} tokens minus scaffold {scaffoldTokens} l"
    "eaves an input budget of {inputBudget} (need > 64). Use a model with a larger co"
    'ntext window or reduce the prompt scaffold."},{"name":"ollama-refused","situatio'
    'n":"An Ollama engine\'s generation refused: `{status}` is the status, and `{body}'
    '` the body, as it was sent.","error":"Ollama API error ({status}): {body}"},{"na'
    'me":"anthropic-refused","situation":"An Anthropic engine\'s request refused: `{sa'
    "id}` is what its client says of the refusal, which varies, and carries the refus"
    'al\'s status and the words of its body\'s `error.message`.","error":"{said}"},{"na'
    'me":"unreadable","situation":"An answer that cannot be read: `{detail}` is one o'
    "f `details`, and `{stopReason}` why the model stopped, `end_turn` where an Ollam"
    'a engine\'s says `stop`.","error":"Structured response could not be read: {detail'
    '} (stop_reason: {stopReason})"},{"name":"wait-stated","situation":"A refusal who'
    "se stated wait is over 120 seconds: `{failure}` is the refusal's error, `anthrop"
    'ic-refused` or `anthropic-limits-refused`, and `{said}` one of `waits`.","error"'
    ':"{failure}; the provider said to wait ({said}), which is longer than the 120 se'
    'conds this driver waits"},{"name":"withheld","situation":"An answer the provider'
    " withheld: `{why}` is ` ({category})` where it states a category and `: {explana"
    "tion}` where it states an explanation, in that order, each left out where it sta"
    'tes none.","error":"The provider withheld its answer: refusal{why}"},{"name":"no'
    '-structured-outputs","situation":"A mark job on an Anthropic model the Models AP'
    'I does not report strict structured outputs for: `{model}` is the model.","error'
    "\":\"Model '{model}' does not report support for strict structured outputs (Models"
    " API capabilities.structured_outputs). It is refused: a generation the provider "
    "does not hold to the schema can come back unreadable. Give the agent that does t"
    'his work a model that reports supported: true."},{"name":"ollama-limits-refused"'
    ',"situation":"`/api/show` refused: `{model}` is the model, `{status}` the status'
    ', and `{said}` the body, as it was sent.","error":"Failed to discover model limi'
    "ts for '{model}' from Ollama's /api/show: refused with status {status}: {said}\"}"
    ',{"name":"anthropic-limits-refused","situation":"The Models API refused: `{model'
    "}` is the model, `{status}` the status, and `{said}` what `anthropic-refused` sa"
    'ys of the refusal.","error":"Failed to discover model limits for \'{model}\' from '
    'the Models API: refused with status {status}: {said}"},{"name":"no-context-lengt'
    'h","situation":"`/api/show` answered with no context length: `{model}` is the mo'
    'del.","error":"/api/show reports no context length for \'{model}\'"},{"name":"unsu'
    'pported-output","situation":"A yield job for a media type the worker does not ge'
    "nerate: `{mediaType}` is the job's `outputMediaType`, and `{generatable}` each m"
    "edia type media-types/registry.json says is generatable, in its order, joined by"
    ' ` or `.","error":"Unsupported outputMediaType for generation: {mediaType}. Gene'
    'ration produces {generatable}."},{"name":"over-window","situation":"A yield job '
    "whose prompt and length are together over its model's window: `{promptTokens}` i"
    "s the tokens of the prompt, `{maxTokens}` the job's `maxTokens`, `{model}` the m"
    'odel, and `{contextTokens}` its window, each number in decimal digits.","error":'
    '"The prompt (~{promptTokens} tokens) and the {maxTokens} tokens asked for are to'
    "gether over the context window of '{model}' ({contextTokens} tokens)\"}],\"details"
    '":[{"name":"not-json","situation":"An answer that is not JSON.","detail":"respon'
    'se is not valid JSON"},{"name":"not-array","situation":"An answer that is JSON a'
    "nd not an array: `{kind}` is what it is, `object`, `string`, `number`, `boolean`"
    ' or `null`.","detail":"parsed to {kind}, not an array"},{"name":"empty","situati'
    'on":"An answer with no text.","detail":"response is empty"}],"waits":[{"name":"s'
    'econds","situation":"A `retry-after` of `{seconds}`, as it was sent.","said":"re'
    'try-after: {seconds}"},{"name":"milliseconds","situation":"A `retry-after-ms` of'
    ' `{milliseconds}`, as it was sent.","said":"retry-after-ms: {milliseconds}"}],"l'
    'ogged":[{"name":"confirmed","level":"info","situation":"A knowledge base confirm'
    'ed: `{domain}` is its domain, and `{did}` the DID it names the worker by.","mess'
    'age":"Knowledge base confirmed","fields":{"domain":"{domain}","did":"{did}"},"ca'
    'rries":[]},{"name":"refused","level":"error","situation":"A knowledge base that '
    'refused the worker: `{domain}` is its domain. `reason` says why.","message":"Kno'
    'wledge base refused the worker","fields":{"domain":"{domain}"},"carries":["reaso'
    'n"]},{"name":"trouble","level":"warn","situation":"A knowledge base in trouble, '
    "which the worker starts again: `{domain}` is its domain. `error` says what the t"
    'rouble was, and `waitMs` how long it waits, in milliseconds.","message":"Knowled'
    'ge base in trouble \\u2014 starting it again","fields":{"domain":"{domain}"},"car'
    'ries":["error","waitMs"]}]}'
)
"""protocol/specs/src/worker/messages.json, read as `WorkerMessages`."""

BUS_REPLY_BOUNDS: Final = BusReplyBounds.model_validate_json(
    '{"$comment":"AUTHORITY for how large each answer on the bus can be. A bus messag'
    "e is bounded by its question: an answer whose size follows a document or a colle"
    "ction is read over HTTP. Every list or map an operation's reply carries is bound"
    "ed by its own schema (`maxItems`, `maxProperties`), or is named here: `by` a mem"
    "ber of the request (an array, so the answer is no larger than what was asked, or"
    " an integer with a `maximum`), or as one that `grows`, saying with what. A `grow"
    "s` entry is an answer not yet bounded. Lists inside a resource's descriptor or a"
    "n annotation are the record's, bounded by the write that made them, and are not "
    "walked. The reader in reader/ holds the registry to this table both ways: a list"
    " it names that is gone or bounded fails, and so does a reply's list it does not "
    'name.","replies":{"browse:resources-requested":{"response.resources":{"grows":"w'
    'ith the knowledge base: a page whose `limit` states no maximum"}},"browse:annota'
    'tion-history-requested":{"response.events":{"grows":"with the annotation\'s histo'
    'ry"}},"browse:events-requested":{"response.events":{"grows":"with the resource\'s'
    ' history: the request\'s `limit` states no maximum"}},"browse:entity-types-reques'
    'ted":{"response.entityTypes":{"grows":"with the knowledge base\'s entity types"}}'
    ',"browse:tag-schemas-requested":{"response.tagSchemas":{"grows":"with the knowle'
    'dge base\'s tag schemas"}},"browse:engines-requested":{"response.engines":{"grows'
    '":"with the knowledge base\'s engines"}},"browse:profiles-requested":{"response.p'
    'rofiles":{"by":"dids"}},"browse:directory-requested":{"response.entries":{"grows'
    '":"with one directory of the working tree"}},"gather:requested":{"response.focus'
    '.suggestedReferences":{"grows":"with the focus\'s neighbourhood in the graph"},"r'
    'esponse.focus.content.related":{"grows":"with the focus\'s neighbourhood in the g'
    'raph"},"response.graph.nodes":{"grows":"with the focus\'s neighbourhood in the gr'
    'aph"},"response.graph.edges":{"grows":"with the focus\'s neighbourhood in the gra'
    'ph"},"response.semanticContext.similar":{"grows":"with the passages the recall r'
    'anks"},"response.semanticContext.excludedEntityTypes":{"grows":"with the entity '
    'types the recall excluded"},"response.metadata.entityTypes":{"grows":"with the f'
    'ocal anchor\'s entity types"},"response.metadata.entityTypeFrequencies":{"grows":'
    '"with the knowledge base\'s entity types"}},"gather:resource-requested":{"respons'
    'e.focus.suggestedReferences":{"grows":"with the focus\'s neighbourhood in the gra'
    'ph"},"response.focus.content.related":{"grows":"with the focus\'s neighbourhood i'
    'n the graph"},"response.graph.nodes":{"grows":"with the focus\'s neighbourhood in'
    ' the graph"},"response.graph.edges":{"grows":"with the focus\'s neighbourhood in '
    'the graph"},"response.semanticContext.similar":{"grows":"with the passages the r'
    'ecall ranks"},"response.semanticContext.excludedEntityTypes":{"grows":"with the '
    'entity types the recall excluded"},"response.metadata.entityTypes":{"grows":"wit'
    'h the focal anchor\'s entity types"},"response.metadata.entityTypeFrequencies":{"'
    'grows":"with the knowledge base\'s entity types"}},"gather:referenced-by-requeste'
    'd":{"response.referencedBy":{"grows":"with the annotations elsewhere that refer '
    'to the resource"}},"gather:limits-requested":{"response.limits":{"grows":"with t'
    'he engines the service holds a client for"}},"job:limits-requested":{"response.l'
    'imits":{"grows":"with the engines the service holds a client for"}},"match:limit'
    's-requested":{"response.limits":{"grows":"with the engines the service holds a c'
    'lient for"}},"job:status-requested":{"response.progress.completedItems":{"grows"'
    ':"with the items the job has finished"},"response.progress.requestParams":{"grow'
    's":"with the job\'s parameters"},"response.result.byCategory":{"grows":"with the '
    'tagging job\'s categories"}},"job:claim":{"response.metadata.completedUnits":{"gr'
    'ows":"with the units the job has finished"},"response.metadata.unitCursors":{"gr'
    'ows":"with the units the job has begun"},"response.params.schema.tags":{"grows":'
    '"with the tag schema\'s tags"},"response.progress.completedItems":{"grows":"with '
    'the items the job has finished"},"response.progress.requestParams":{"grows":"wit'
    'h the job\'s parameters"}},"mark:commit":{"response.annotationIds":{"by":"annotat'
    'ions"}},"match:search-requested":{"response":{"by":"limit"}},"match:resources-re'
    'quested":{"response.resources":{"by":"limit"}}}}'
)
"""protocol/specs/src/bus/reply-bounds.json, read as `BusReplyBounds`."""

# Every table, by its file under protocol/specs/src.
SERVICE_TABLES: Final[Mapping[str, WireModel]] = MappingProxyType(
    {
        "archivist/default-entity-types.json": ARCHIVIST_DEFAULT_ENTITY_TYPES,
        "archivist/layout.json": ARCHIVIST_LAYOUT,
        "archivist/messages.json": ARCHIVIST_MESSAGES,
        "dispatcher/messages.json": DISPATCHER_MESSAGES,
        "embedding/requests.json": EMBEDDING_REQUESTS,
        "gateway/media-token.json": GATEWAY_MEDIA_TOKEN,
        "gateway/messages.json": GATEWAY_MESSAGES,
        "gateway/response-headers.json": GATEWAY_RESPONSE_HEADERS,
        "graph/schema.json": GRAPH_SCHEMA,
        "jobs/budgets.json": JOBS_BUDGETS,
        "jobs/storage.json": JOBS_STORAGE,
        "service-environment/boot-refusals.json": SERVICE_ENVIRONMENT_BOOT_REFUSALS,
        "service-environment/variables.json": SERVICE_ENVIRONMENT_VARIABLES,
        "service-telemetry/log-lines.json": SERVICE_TELEMETRY_LOG_LINES,
        "service-telemetry/telemetry.json": SERVICE_TELEMETRY_TELEMETRY,
        "smelter/messages.json": SMELTER_MESSAGES,
        "worker/answer-formats.json": WORKER_ANSWER_FORMATS,
        "worker/messages.json": WORKER_MESSAGES,
        "bus/reply-bounds.json": BUS_REPLY_BOUNDS,
    }
)
