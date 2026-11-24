//! What every SDK's reading of a value finds of it is one table,
//! protocol/specs/src/client/shape-cases.json: each case's value is held to
//! the schema it names, and its first fault is the one the case states, or
//! none. A case naming a schema the table lacks fails, and so does a table
//! with no case.

use serde_json::Value;
use xynolog::testing::schema_fault;
use xynolog::types::FrameRefusalReason;

#[test]
fn shape_cases() {
    let table: Value = serde_json::from_str(include_str!("../specs/client/shape-cases.json"))
        .expect("the table is JSON");
    let cases = table["cases"].as_array().expect("the table has cases");
    assert!(!cases.is_empty(), "shape-cases.json states no case");
    for case in cases {
        let schema = case["schema"].as_str().expect("a case names a schema");
        let fault = (case["refused"].as_bool() == Some(true)).then(|| {
            let member = case["member"]
                .as_str()
                .expect("a refused case states its member");
            let reason: FrameRefusalReason = serde_json::from_value(case["reason"].clone())
                .expect("a refused case states its reason");
            (member.to_owned(), reason)
        });
        let mut value = case["value"].clone();
        assert_eq!(
            schema_fault(schema, &mut value),
            fault,
            "{}: {} as {schema}",
            case["why"],
            case["value"]
        );
    }
}
