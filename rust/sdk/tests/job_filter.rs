//! Whether a job matches a filter is one table,
//! protocol/specs/src/jobs/filter-cases.json, which every implementation runs: the
//! dispatcher's claims and each SDK's reading of an announcement answer
//! through this crate's `job_matches_filter`.

use serde_json::Value;
use xynolog::job_filter::job_matches_filter;
use xynolog::types::JobFilter;

fn cases() -> Vec<Value> {
    let table: Value = serde_json::from_str(include_str!("../specs/jobs/filter-cases.json"))
        .expect("the table is JSON");
    table["cases"]
        .as_array()
        .expect("the table has cases")
        .clone()
}

#[test]
fn the_table_asks_both_ways() {
    let mut answers: Vec<bool> = cases()
        .iter()
        .map(|case| case["matches"].as_bool().expect("matches"))
        .collect();
    answers.sort();
    answers.dedup();
    assert_eq!(answers, [false, true], "the table has cases of one answer");
}

/// A held job is compared as its `jobType` and its `params` (`HeldJob::accepted`),
/// and the table's descriptions state those and nothing else.
#[test]
fn a_job_description_is_its_type_and_its_parameters() {
    let mut members: Vec<String> = cases()
        .iter()
        .flat_map(|case| {
            case["job"]
                .as_object()
                .expect("a case's job is an object")
                .keys()
                .cloned()
                .collect::<Vec<_>>()
        })
        .collect();
    members.sort();
    members.dedup();
    assert_eq!(members, ["jobType", "params"]);
}

#[test]
fn filter_cases() {
    for case in cases() {
        let filter: JobFilter =
            serde_json::from_value(case["filter"].clone()).expect("a case's filter is a JobFilter");
        assert_eq!(
            job_matches_filter(&filter, &case["job"]),
            case["matches"].as_bool().expect("matches"),
            "{}",
            case["why"]
        );
    }
}
