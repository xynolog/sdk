//! The side of an operation a service holds: each request that reaches it,
//! answered once on the operation's result or failure channel, under its
//! asker's correlation id (protocol/contract/TRANSPORT-CONTRACT.md § Requests).

use serde_json::{Map, Value, json};
use std::collections::BTreeSet;
use std::sync::Arc;
use xynolog::bus::{Bus, OPERATIONS, Questions};
use xynolog::channels::{
    BrowseDirectoryFailed, BrowseDirectoryRequested, BrowseDirectoryResult, Channel,
};
use xynolog::testing::FaultyTransport;
use xynolog::transport::{Frame, FrameRefusal};
use xynolog::types::{BrowseDirectoryResultResponse, BusFrame, FrameRefusalReason};

fn asked(world: &FaultyTransport, payload: Value, correlation_id: Option<&str>) {
    world.deliver(Frame {
        bus_frame: BusFrame {
            channel: "browse:directory-requested".to_owned(),
            payload: object(payload),
            correlation_id: correlation_id.map(str::to_owned),
            scope: None,
        },
        trace: None,
        stream_id: None,
    });
}

fn object(value: Value) -> Map<String, Value> {
    value.as_object().cloned().expect("an object")
}

fn world() -> (FaultyTransport, Questions<BrowseDirectoryRequested>) {
    let transport = FaultyTransport::new(&["browse:directory-requested"], vec![]);
    let questions = Bus::new(Arc::new(transport.clone()))
        .questions::<BrowseDirectoryRequested>()
        .expect("the requests are read");
    (transport, questions)
}

fn sent(world: &FaultyTransport, channel: &str) -> Vec<(Option<String>, Value)> {
    world
        .emitted()
        .into_iter()
        .filter(|frame| frame.bus_frame.channel == channel)
        .map(|frame| {
            (
                frame.bus_frame.correlation_id,
                Value::Object(frame.bus_frame.payload),
            )
        })
        .collect()
}

#[tokio::test]
async fn a_question_is_answered_on_its_result_channel_under_its_askers_correlation_id() {
    let (world, mut questions) = world();
    asked(&world, json!({ "path": "docs" }), Some("c-1"));

    let question = questions
        .next()
        .await
        .expect("a request")
        .expect("one of the operation's");
    assert_eq!(question.asked.payload.path, "docs");
    let path = question.asked.payload.path.clone();
    question
        .answer(Ok(xynolog::types::BrowseDirectoryResult {
            response: BrowseDirectoryResultResponse {
                path,
                entries: vec![],
            },
        }))
        .await
        .expect("the answer is sent");

    assert_eq!(
        sent(&world, BrowseDirectoryResult::NAME),
        [(
            Some("c-1".to_owned()),
            json!({ "response": { "path": "docs", "entries": [] } })
        )]
    );
}

#[tokio::test]
async fn a_failure_is_answered_on_the_failure_channel() {
    let (world, mut questions) = world();
    asked(&world, json!({ "path": "gone" }), Some("c-2"));

    let question = questions.next().await.expect("a request").expect("one");
    let failure = xynolog::types::BrowseDirectoryFailed::new("No such directory", "gone");
    question
        .answer(Err(failure))
        .await
        .expect("the answer is sent");

    assert_eq!(
        sent(&world, BrowseDirectoryFailed::NAME),
        [(
            Some("c-2".to_owned()),
            json!({ "message": "No such directory", "path": "gone" })
        )]
    );
}

#[tokio::test]
async fn a_request_that_is_not_the_operations_is_refused_and_its_asker_told_why() {
    let (world, mut questions) = world();
    // `path` is the one member the failure echoes; `sort` is the fault.
    asked(
        &world,
        json!({ "path": "docs", "sort": "sideways" }),
        Some("c-3"),
    );

    let refused = questions.next().await.expect("a request");
    assert!(
        refused.is_err(),
        "a request that is not the operation's is refused"
    );

    let told = sent(&world, BrowseDirectoryFailed::NAME);
    assert_eq!(told.len(), 1);
    let (correlation_id, failure) = &told[0];
    assert_eq!(correlation_id.as_deref(), Some("c-3"));
    assert_eq!(failure["path"], "docs");
    assert!(
        failure["message"]
            .as_str()
            .is_some_and(|message| message.contains("sort"))
    );
    assert_eq!(object(failure.clone()).len(), 2, "{failure}");
}

#[tokio::test]
async fn an_asker_is_not_told_when_its_failure_cannot_be_formed_or_sent_to_it() {
    let (world, mut questions) = world();
    // No correlation id: nobody waits for an answer.
    asked(&world, json!({ "path": 7 }), None);
    // No `path`, which the failure must echo.
    world.deliver_refusal(FrameRefusal {
        channel: BrowseDirectoryRequested::NAME.to_owned(),
        member: "payload.path".to_owned(),
        reason: FrameRefusalReason::Lacks,
        payload: Some(json!({})),
        scope: None,
        correlation_id: Some("c-4".to_owned()),
    });

    for _ in 0..2 {
        assert!(questions.next().await.expect("a request").is_err());
    }
    assert_eq!(sent(&world, BrowseDirectoryFailed::NAME), []);
}

fn members(schema: &str) -> BTreeSet<String> {
    let path = format!(
        "{}/specs/components/schemas/{schema}.json",
        env!("CARGO_MANIFEST_DIR")
    );
    let read: Value = serde_json::from_str(&std::fs::read_to_string(&path).expect("the schema"))
        .expect("the schema is JSON");
    let mut stated: BTreeSet<String> = read["properties"]
        .as_object()
        .map(|properties| properties.keys().cloned().collect())
        .unwrap_or_default();
    for part in read["allOf"].as_array().into_iter().flatten() {
        if let Some(reference) = part["$ref"].as_str() {
            let named = reference
                .rsplit('/')
                .next()
                .and_then(|file| file.strip_suffix(".json"))
                .expect("a schema's file");
            stated.extend(members(named));
        }
        if let Some(properties) = part["properties"].as_object() {
            stated.extend(properties.keys().cloned());
        }
    }
    stated
}

/// A refused request's failure is formed from the members of the request
/// that the failure states again (`Questions::next`): so every operation's
/// failure states CommandError's members and members of its request, and
/// none of its own.
#[test]
fn every_operations_failure_states_only_a_command_error_and_members_of_its_request() {
    let registry: Value =
        serde_json::from_str(include_str!("../specs/bus/registry.json")).expect("the registry");
    let schema_of = |channel: &str| -> String {
        registry["channels"]
            .as_array()
            .expect("channels")
            .iter()
            .find(|named| named["channel"] == channel)
            .and_then(|named| named["schema"].as_str())
            .unwrap_or_else(|| panic!("{channel} is carried by a schema"))
            .to_owned()
    };
    let error = members("CommandError");
    assert_eq!(
        OPERATIONS.len(),
        registry["operations"].as_array().expect("operations").len()
    );
    for operation in OPERATIONS {
        let asked = members(&schema_of(operation.request));
        let own: Vec<String> = members(&schema_of(operation.failure))
            .into_iter()
            .filter(|member| !error.contains(member) && !asked.contains(member))
            .collect();
        assert!(own.is_empty(), "{} states {own:?}", operation.failure);
    }
}
