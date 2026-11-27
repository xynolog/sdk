//! SearchState, JobEvent and CacheState are generic, so they are written by
//! hand; this census holds each to its schema in
//! protocol/specs/src/client/types. The
//! compiler holds each list below to the type, through a pattern that names
//! every member and every variant, and the test holds the list to the
//! schema, so a member or a branch either side gains or loses fails.

use serde_json::Value;
use std::collections::BTreeSet;
use xynolog::cache::CacheState;
use xynolog::namespaces::JobEvent;
use xynolog::state::SearchState;

const SEARCH_STATE: [&str; 2] = ["results", "isSearching"];

#[allow(dead_code)]
fn search_state_members<T>(state: SearchState<T>) -> [&'static str; 2] {
    let SearchState {
        results: _,
        is_searching: _,
    } = state;
    SEARCH_STATE
}

const JOB_EVENT: [&str; 5] = ["created", "progress", "failed", "refused", "complete"];
const REFUSED: [&str; 3] = ["channel", "member", "reason"];

#[allow(dead_code)]
fn job_event_kind<C>(event: &JobEvent<C>) -> &'static str {
    match event {
        JobEvent::Created(_) => JOB_EVENT[0],
        JobEvent::Progress(_) => JOB_EVENT[1],
        JobEvent::Failed(_) => JOB_EVENT[2],
        JobEvent::Refused {
            channel: _,
            member: _,
            reason: _,
        } => JOB_EVENT[3],
        JobEvent::Complete(_) => JOB_EVENT[4],
    }
}

const CACHE_STATE: [(&str, &[&str]); 3] = [
    ("pending", &["status"]),
    ("ready", &["status", "value"]),
    ("failed", &["status", "error"]),
];

#[allow(dead_code)]
fn cache_state_branch<T>(state: &CacheState<T>) -> (&'static str, &'static [&'static str]) {
    match state {
        CacheState::Pending => CACHE_STATE[0],
        CacheState::Ready(_) => CACHE_STATE[1],
        CacheState::Failed(_) => CACHE_STATE[2],
    }
}

fn schema(name: &str) -> Value {
    let path = format!(
        "{}/specs/client/types/{name}.json",
        env!("CARGO_MANIFEST_DIR")
    );
    serde_json::from_str(&std::fs::read_to_string(&path).expect(&path)).expect(&path)
}

fn names(object: &Value) -> BTreeSet<String> {
    object["properties"]
        .as_object()
        .expect("an object schema states its properties")
        .keys()
        .cloned()
        .collect()
}

fn set(names: &[&str]) -> BTreeSet<String> {
    names.iter().map(|name| (*name).to_owned()).collect()
}

#[test]
fn search_state_has_the_schemas_members() {
    assert_eq!(names(&schema("SearchState")), set(&SEARCH_STATE));
}

#[test]
fn job_event_has_the_schemas_branches_each_of_its_members() {
    let job_event = schema("JobEvent");
    let branches = job_event["oneOf"].as_array().expect("JobEvent is a union");
    let kinds: BTreeSet<String> = branches
        .iter()
        .map(|branch| {
            branch["properties"]["kind"]["enum"][0]
                .as_str()
                .expect("a branch is told by its kind")
                .to_owned()
        })
        .collect();
    assert_eq!(kinds, set(&JOB_EVENT));
    for branch in branches {
        assert_eq!(names(branch), set(&["kind", "data"]));
    }
    let refused = branches
        .iter()
        .find(|branch| branch["properties"]["kind"]["enum"][0] == "refused")
        .expect("JobEvent has a refused branch");
    assert_eq!(names(&refused["properties"]["data"]), set(&REFUSED));
}

#[test]
fn cache_state_has_the_schemas_branches_each_of_its_members() {
    let cache_state = schema("CacheState");
    let branches = cache_state["oneOf"]
        .as_array()
        .expect("CacheState is a union");
    let told: BTreeSet<(String, BTreeSet<String>)> = branches
        .iter()
        .map(|branch| {
            let status = branch["properties"]["status"]["enum"][0]
                .as_str()
                .expect("a branch is told by its status");
            (status.to_owned(), names(branch))
        })
        .collect();
    let held: BTreeSet<(String, BTreeSet<String>)> = CACHE_STATE
        .iter()
        .map(|(status, members)| ((*status).to_owned(), set(members)))
        .collect();
    assert_eq!(told, held);
}
