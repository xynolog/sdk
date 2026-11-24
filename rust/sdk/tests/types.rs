//! The generated protocol types decode what the wire carries: each state of a
//! job, the empty object beside a progress report or a result, the params a
//! job is held with, a job description and the three results a job reports,
//! and the registry's operations.

use serde::{Serialize, de::DeserializeOwned};
use serde_json::{Value, json};
use xynolog::bus::operation;
use xynolog::types::{
    Agent, AgentOrganization, AgentPerson, AgentSoftware, AnchoredTextAnswer,
    AnchoredTextDeclinedEntry, AnchoredTextDeclinedEntryV, AnchoredTextEntry,
    AnchoredTextExtractedEntry, BodyOperation, BodyOperationAdd, BodyOperationRemove,
    BodyOperationReplace, BusEventMessage, BusPingMessage, BusStreamMessage, ConformanceBusFetch,
    ConformanceHttpFetch, ConformanceStep, ConformanceStepFetchesFetchesItem,
    ExtractionDeclinedReason, GraphAnnotationNode, GraphResourceNode, HighlightingJobParams, Job,
    JobCancelled, JobComplete, JobCreateCommand, JobDeclined, JobDeclinedReason, JobFailed,
    JobFilter, JobPending, JobProgressAnalyzing, JobProgressAnalyzingTags,
    JobProgressCompleteCreated, JobProgressCompleteGenerated, JobProgressCreatingAnnotations,
    JobProgressCreatingResource, JobProgressCreatingTagAnnotations, JobProgressDetectingEntities,
    JobProgressGeneratingResource, JobProgressLoading, JobProgressMessage, JobQueuedEvent,
    JobResult, JobRunning, JobStoredProgress, JobStoredResult, KnowledgeGraphNodesItem,
    LinkingJobParams, MarkJobCreateCommand, MarkJobFilter, MarkJobFilterParams, MarkJobParams,
    Motivation, Signature, TaggingJobParams, YieldJobFilter,
};

fn metadata() -> Value {
    json!({
        "id": "job-0123456789abcdef0123456789abcdef",
        "type": "mark",
        "userId": "did:web:example.org:users:alice",
        "created": "2026-09-30T12:00:00.000Z",
        "retryCount": 0,
        "maxRetries": 1
    })
}

fn params() -> Value {
    json!({ "resourceId": "res-1", "motivation": "highlighting", "density": 3, "instructions": "be brief" })
}

#[test]
fn a_claimed_job_is_running_with_no_progress_yet_and_keeps_its_params() {
    let wire = json!({
        "status": "running",
        "metadata": metadata(),
        "params": params(),
        "startedAt": "2026-09-30T12:00:01.000Z",
        "progress": {}
    });
    let Job::JobRunning(job) = serde_json::from_value(wire.clone()).expect("a running job decodes")
    else {
        panic!("a running job decoded as another state");
    };
    assert!(matches!(job.progress, JobStoredProgress::Empty(_)));
    assert_eq!(job.params.resource_id, "res-1");
    assert_eq!(job.params.rest["density"], json!(3));
    assert_eq!(
        serde_json::to_value(Job::JobRunning(job)).expect("it encodes"),
        wire
    );
}

#[test]
fn a_reported_progress_is_a_report_not_the_empty_object() {
    let progress: JobStoredProgress =
        serde_json::from_value(json!({ "percentage": 40, "message": { "code": "analyzing" } }))
            .expect("a report decodes");
    assert!(matches!(progress, JobStoredProgress::JobProgress(_)));
}

#[test]
fn a_completed_job_carries_its_result_or_the_empty_object() {
    let complete = |result: Value| {
        json!({
            "status": "complete",
            "metadata": metadata(),
            "params": params(),
            "startedAt": "2026-09-30T12:00:01.000Z",
            "completedAt": "2026-09-30T12:00:02.000Z",
            "result": result
        })
    };
    let Job::JobComplete(reported) =
        serde_json::from_value(complete(json!({ "found": 2, "persisted": 2 })))
            .expect("a completed job decodes")
    else {
        panic!("a completed job decoded as another state");
    };
    assert!(matches!(
        reported.result,
        JobStoredResult::JobResult(JobResult::MarkJobDone(_))
    ));
    let Job::JobComplete(bare) = serde_json::from_value(complete(json!({}))).expect("it decodes")
    else {
        panic!("a completed job decoded as another state");
    };
    assert!(matches!(bare.result, JobStoredResult::Empty(_)));
}

/// The three results share no member, and each is closed: a result is told
/// from the others by what it alone carries, and one that mixes them, or
/// carries anything else, is none.
#[test]
fn a_result_is_one_of_three_told_apart_by_what_each_alone_carries() {
    let result = |wire: Value| serde_json::from_value::<JobResult>(wire);
    let detection = result(json!({
        "found": 7, "persisted": 5, "errors": 2, "byCategory": { "Issue": 3, "Rule": 2 }, "underReportedPieces": 1
    }))
    .expect("a mark job's counts decode");
    let JobResult::MarkJobDone(counts) = &detection else {
        panic!("counts decoded as {detection:?}");
    };
    assert_eq!(
        (
            counts.found,
            counts.persisted,
            counts.errors,
            counts.under_reported_pieces
        ),
        (7, 5, Some(2), Some(1))
    );
    assert!(matches!(
        result(json!({ "resourceId": "res-made", "resourceName": "Made", "truncated": false })),
        Ok(JobResult::YieldJobDone(_))
    ));
    assert!(matches!(
        result(json!({ "declined": true, "reason": "no-text-layer" })),
        Ok(JobResult::JobDeclined(_))
    ));

    for none in [
        json!({ "highlightsFound": 2, "highlightsCreated": 2 }),
        json!({ "kind": "highlight-annotation", "found": 2, "persisted": 2 }),
        json!({ "found": 2, "persisted": 2, "resourceId": "res-made", "resourceName": "Made", "truncated": false }),
        json!({ "found": 2, "persisted": 2, "declined": true, "reason": "empty" }),
        json!({ "found": 2 }),
    ] {
        assert!(result(none.clone()).is_err(), "{none} decoded as a result");
    }
}

/// A property that admits one value is a type of that value alone: it is
/// written as that value, and a value that states another is no value of it.
#[test]
fn a_property_of_one_value_is_written_as_it_and_read_from_it_alone() {
    let declined = JobDeclined::new(JobDeclinedReason::NoTextLayer);
    assert_eq!(
        serde_json::to_value(&declined).expect("a decline writes"),
        json!({ "declined": true, "reason": "no-text-layer" })
    );
    assert!(
        serde_json::from_value::<JobDeclined>(
            json!({ "declined": false, "reason": "no-text-layer" })
        )
        .is_err(),
        "a decline that is not declined is read"
    );
    assert!(
        serde_json::from_value::<JobDeclined>(
            json!({ "declined": "true", "reason": "no-text-layer" })
        )
        .is_err(),
        "a decline whose `declined` is text is read"
    );

    let entry = AnchoredTextDeclinedEntry::new("stamp", ExtractionDeclinedReason::NoTextLayer);
    let wire = serde_json::to_value(&entry).expect("an entry writes");
    assert_eq!(wire["v"], json!(AnchoredTextDeclinedEntryV::VALUE));
    assert_eq!(
        serde_json::from_value::<AnchoredTextDeclinedEntry>(wire.clone()).expect("an entry reads"),
        entry
    );
    let mut other = wire;
    other["v"] = json!(AnchoredTextDeclinedEntryV::VALUE + 1);
    assert!(
        serde_json::from_value::<AnchoredTextDeclinedEntry>(other).is_err(),
        "an entry of another format is read"
    );
}

/// A union whose members state several values of the property that tells
/// them apart is decoded as the one member that admits a value, and a value
/// one member names but does not admit is refused for what is wrong with it
/// as that member.
#[test]
fn a_union_is_decoded_as_the_one_member_that_admits_a_value() {
    let answer = |wire: Value| serde_json::from_value::<AnchoredTextAnswer>(wire);
    assert!(matches!(
        answer(json!({ "kind": "no-map" })),
        Ok(AnchoredTextAnswer::AnchoredTextAbsent(_))
    ));
    assert!(matches!(
        answer(json!({ "kind": "declined", "declined": "encrypted" })),
        Ok(AnchoredTextAnswer::ExtractionDeclined(_))
    ));
    let lacking = answer(json!({ "kind": "declined" }))
        .expect_err("a decline that says not why")
        .to_string();
    assert!(lacking.contains("missing field `declined`"), "{lacking}");
    let unnamed = answer(json!({ "kind": "later" }))
        .expect_err("an answer of no kind")
        .to_string();
    assert!(
        unnamed.contains("`extracted`, `declined`, `not-yet`, `no-map`, `unknown`"),
        "{unnamed}"
    );
}

/// A job description is told apart by a property, and a value is decoded as
/// the member that property names: what is wrong with it is said of that
/// member.
#[test]
fn a_job_description_decodes_as_the_member_its_job_type_and_motivation_name() {
    let command: JobCreateCommand = serde_json::from_value(json!({
        "jobType": "mark", "resourceId": "res-1",
        "params": { "motivation": "tagging", "schemaId": "irac", "categories": ["Issue"] },
    }))
    .expect("a mark job's description decodes");
    assert_eq!(
        command,
        MarkJobCreateCommand::new(
            "res-1".parse().expect("a resource id"),
            TaggingJobParams::new("irac", vec!["Issue".to_owned()]).into(),
        )
        .into()
    );
    assert_eq!(
        serde_json::to_value(MarkJobParams::from(HighlightingJobParams::new()))
            .expect("it encodes"),
        json!({ "motivation": "highlighting" })
    );

    let refused = |params: Value| {
        serde_json::from_value::<MarkJobParams>(params)
            .expect_err("it is no job's parameters")
            .to_string()
    };
    let not_taken =
        refused(json!({ "motivation": "linking", "entityTypes": ["Person"], "instructions": "x" }));
    assert!(
        not_taken.contains("unknown field `instructions`"),
        "{not_taken}"
    );
    let missing = refused(json!({ "motivation": "tagging", "categories": ["Issue"] }));
    assert!(missing.contains("missing field `schemaId`"), "{missing}");
    let unnamed = refused(json!({ "motivation": "bookmarking" }));
    assert!(
        unnamed.contains("`highlighting`, `commenting`, `assessing`, `linking`, `tagging`"),
        "{unnamed}"
    );
    assert!(
        serde_json::from_value::<JobCreateCommand>(json!({
            "jobType": "yield", "resourceId": "res-1", "params": {},
        }))
        .is_err()
    );
}

#[test]
fn an_announcement_and_a_filter_decode_as_the_member_their_job_type_names() {
    let announced: JobQueuedEvent = serde_json::from_value(json!({
        "jobId": "job-1", "jobType": "mark", "resourceId": "res-1",
        "userId": "did:web:example.org:users:alice",
        "params": { "motivation": "linking", "entityTypes": ["Person"] },
    }))
    .expect("an announcement decodes");
    let JobQueuedEvent::MarkJobQueuedEvent(mark) = &announced else {
        panic!("a mark job's announcement decoded as {announced:?}");
    };
    assert_eq!(
        mark.params,
        LinkingJobParams::new(vec!["Person".to_owned()]).into()
    );

    let filters: Vec<JobFilter> = serde_json::from_value(json!([
        { "jobType": "mark", "params": { "motivation": "tagging" } },
        { "jobType": "yield" },
    ]))
    .expect("filters decode");
    assert_eq!(
        filters,
        [
            MarkJobFilter::new(MarkJobFilterParams {
                motivation: Motivation::Tagging
            })
            .into(),
            YieldJobFilter::new().into(),
        ]
    );
    // A mark filter always states its motivation.
    assert!(serde_json::from_value::<JobFilter>(json!({ "jobType": "mark" })).is_err());
}

/// A value of `M`, and the union `U` that member is wherever `U` is wanted.
fn member<M, U>(wire: Value) -> (Value, U)
where
    M: DeserializeOwned + Into<U>,
{
    let made = serde_json::from_value::<M>(wire.clone())
        .unwrap_or_else(|error| panic!("{wire} is no member: {error}"))
        .into();
    (wire, made)
}

/// Each of `values` is read as the union `U` it was made, and written as it
/// came; and they are a value of each of `U`'s `members`, each its own
/// variant.
fn each_member<U>(members: &[&[Signature]], values: Vec<(Value, U)>)
where
    U: DeserializeOwned + Serialize + PartialEq + std::fmt::Debug,
{
    let mut variants = Vec::new();
    for (wire, made) in values {
        let read: U = serde_json::from_value(wire.clone())
            .unwrap_or_else(|error| panic!("{wire} is no value of the union: {error}"));
        assert_eq!(read, made, "{wire} is read as another member");
        assert_eq!(
            serde_json::to_value(&read).expect("it writes"),
            wire,
            "it is written as it came"
        );
        let variant = std::mem::discriminant(&read);
        assert!(
            !variants.contains(&variant),
            "{wire} is a variant read already"
        );
        variants.push(variant);
    }
    assert_eq!(variants.len(), members.len(), "a value of each member");
}

/// A member a union names is its variant of the member's own name, and the
/// union wherever the union is wanted: a value of each is read as the union
/// it was made, and written as it came.
#[test]
fn each_member_of_a_union_is_read_and_written_as_itself() {
    let job = |status: &str, more: Value| {
        let mut wire = json!({ "status": status, "metadata": metadata(), "params": params() });
        wire.as_object_mut()
            .expect("an object")
            .extend(more.as_object().expect("an object").clone());
        wire
    };
    let started = "2026-09-30T12:00:01.000Z";
    let ended = "2026-09-30T12:00:02.000Z";
    each_member::<Job>(
        Job::MEMBERS,
        vec![
            member::<JobPending, _>(job("pending", json!({}))),
            member::<JobRunning, _>(job(
                "running",
                json!({ "startedAt": started, "progress": {} }),
            )),
            member::<JobComplete, _>(job(
                "complete",
                json!({ "startedAt": started, "completedAt": ended, "result": {} }),
            )),
            member::<JobFailed, _>(job(
                "failed",
                json!({ "completedAt": ended, "error": "broken" }),
            )),
            member::<JobCancelled, _>(job("cancelled", json!({ "completedAt": ended }))),
        ],
    );
    each_member::<JobProgressMessage>(
        JobProgressMessage::MEMBERS,
        vec![
            member::<JobProgressLoading, _>(json!({ "code": "loading" })),
            member::<JobProgressAnalyzing, _>(json!({ "code": "analyzing" })),
            member::<JobProgressAnalyzingTags, _>(json!({ "code": "analyzing-tags" })),
            member::<JobProgressGeneratingResource, _>(json!({ "code": "generating-resource" })),
            member::<JobProgressCreatingResource, _>(json!({ "code": "creating-resource" })),
            member::<JobProgressCompleteGenerated, _>(
                json!({ "code": "complete-generated", "truncated": false }),
            ),
            member::<JobProgressDetectingEntities, _>(
                json!({ "code": "detecting-entities", "entityType": "Person" }),
            ),
            member::<JobProgressCreatingAnnotations, _>(
                json!({ "code": "creating-annotations", "count": 2 }),
            ),
            member::<JobProgressCreatingTagAnnotations, _>(
                json!({ "code": "creating-tag-annotations", "count": 2 }),
            ),
            member::<JobProgressCompleteCreated, _>(
                json!({ "code": "complete-created", "count": 2, "motivation": "tagging" }),
            ),
        ],
    );
    let body = |value: &str| json!({ "type": "TextualBody", "value": value });
    each_member::<BodyOperation>(
        BodyOperation::MEMBERS,
        vec![
            member::<BodyOperationAdd, _>(json!({ "op": "add", "item": body("new") })),
            member::<BodyOperationRemove, _>(json!({ "op": "remove", "item": body("old") })),
            member::<BodyOperationReplace, _>(
                json!({ "op": "replace", "oldItem": body("old"), "newItem": body("new") }),
            ),
        ],
    );
    each_member::<Agent>(
        Agent::MEMBERS,
        vec![
            member::<AgentPerson, _>(json!({ "@type": "Person", "name": "Alice" })),
            member::<AgentOrganization, _>(json!({ "@type": "Organization", "name": "Acme" })),
            member::<AgentSoftware, _>(json!({ "@type": "Software", "name": "worker" })),
        ],
    );
    each_member::<BusStreamMessage>(
        BusStreamMessage::MEMBERS,
        vec![
            member::<BusEventMessage, _>(json!({
                "event": "bus-event", "id": "e-1",
                "data": { "channel": "mark:added", "payload": {} },
            })),
            member::<BusPingMessage, _>(json!({ "event": "ping", "data": "" })),
        ],
    );
    let bus_fetch = json!({ "fetch": "browse:kb", "as": "kb" });
    let http_fetch = json!({ "fetch": "GET /resources" });
    each_member::<ConformanceStepFetchesFetchesItem>(
        ConformanceStepFetchesFetchesItem::MEMBERS,
        vec![
            member::<ConformanceBusFetch, _>(bus_fetch.clone()),
            member::<ConformanceHttpFetch, _>(http_fetch.clone()),
        ],
    );
    for (wire, made) in [
        member::<ConformanceBusFetch, ConformanceStep>(bus_fetch),
        member::<ConformanceHttpFetch, ConformanceStep>(http_fetch),
    ] {
        assert_eq!(
            serde_json::from_value::<ConformanceStep>(wire.clone()).ok(),
            Some(made),
            "{wire}"
        );
    }
    each_member::<KnowledgeGraphNodesItem>(
        KnowledgeGraphNodesItem::MEMBERS,
        vec![
            member::<GraphResourceNode, _>(
                json!({ "id": "res-1", "type": "resource", "label": "One" }),
            ),
            member::<GraphAnnotationNode, _>(json!({
                "id": "a-1", "type": "annotation", "label": "A note",
                "annotation": {
                    "@context": "http://www.w3.org/ns/anno.jsonld",
                    "type": "Annotation",
                    "id": "a-1",
                    "motivation": "highlighting",
                    "target": { "source": "res-1" },
                    "created": "2026-10-01T12:00:00.000Z",
                },
            })),
        ],
    );
    each_member::<AnchoredTextEntry>(
        AnchoredTextEntry::MEMBERS,
        vec![
            member::<AnchoredTextExtractedEntry, _>(json!({
                "v": 3, "stamp": "s", "text": "a", "method": "ocr",
                "lines": [{ "p": 1, "y": 0.5, "h": 0.25, "words": [[0.0, 0.5]] }],
            })),
            member::<AnchoredTextDeclinedEntry, _>(
                json!({ "v": 3, "stamp": "s", "declined": "encrypted" }),
            ),
        ],
    );
}

#[test]
fn each_state_decodes_as_itself() {
    let base = |status: &str, extra: Value| {
        let mut job = json!({ "status": status, "metadata": metadata(), "params": params() });
        job.as_object_mut()
            .expect("an object")
            .extend(extra.as_object().expect("an object").clone());
        serde_json::from_value::<Job>(job).expect("the job decodes")
    };
    assert!(matches!(base("pending", json!({})), Job::JobPending(_)));
    assert!(matches!(
        base(
            "failed",
            json!({ "completedAt": "2026-09-30T12:00:02.000Z", "error": "broken" })
        ),
        Job::JobFailed(_)
    ));
    assert!(matches!(
        base(
            "cancelled",
            json!({ "completedAt": "2026-09-30T12:00:02.000Z" })
        ),
        Job::JobCancelled(_)
    ));
}

#[test]
fn a_job_of_a_state_the_protocol_does_not_have_does_not_decode() {
    let wire = json!({ "status": "claimed", "metadata": metadata(), "params": params() });
    assert!(serde_json::from_value::<Job>(wire).is_err());
}

#[test]
fn the_registry_names_each_operation_its_reply_and_its_failure() {
    let claim = operation("job:claim").expect("job:claim is an operation");
    assert_eq!(
        (claim.result, claim.failure),
        ("job:claimed", "job:claim-failed")
    );
    assert!(
        operation("job:complete").is_none(),
        "job:complete is not answered"
    );
}

#[test]
fn a_value_is_read_as_its_schema_held_to_what_the_table_states() {
    use xynolog::read_as;
    use xynolog::types::{BrowseDirectoryRequest, WorkerHealth};

    assert_eq!(
        read_as::<BrowseDirectoryRequest>(serde_json::json!({ "path": "docs" })),
        Ok(BrowseDirectoryRequest::new("docs"))
    );
    assert_eq!(
        read_as::<BrowseDirectoryRequest>(serde_json::json!({})),
        Err("it has no `path`".to_owned())
    );
    assert_eq!(
        read_as::<WorkerHealth>(serde_json::json!({ "status": "healthy" })),
        Err("it has no `knowledgeBases`".to_owned())
    );
}

#[test]
fn a_members_bounds_are_the_tables() {
    use xynolog::types::MatchSearchRequest;
    use xynolog::{Bounds, bounds_of};

    assert_eq!(
        bounds_of::<MatchSearchRequest>("limit"),
        Some(Bounds {
            minimum: Some(1.0),
            maximum: Some(200.0),
            ..Bounds::default()
        })
    );
    assert_eq!(bounds_of::<MatchSearchRequest>("nothing"), None);
}
