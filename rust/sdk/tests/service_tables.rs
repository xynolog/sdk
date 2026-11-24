//! The tables the services keep to, each read as its schema's type and
//! written again as the file states it.

use serde_json::Value;
use xynolog::archivist_http::{ArchivistMethod, PUT_RESOURCE_ANCHORED_TEXT};
use xynolog::service_tables::{SERVICE_TABLE_FILES, jobs_budgets, service_table};

fn file(table: &str) -> Value {
    let path = format!("{}/specs/{table}", env!("CARGO_MANIFEST_DIR"));
    serde_json::from_str(&std::fs::read_to_string(&path).expect("the table"))
        .expect("the table is JSON")
}

#[test]
fn every_table_reads_as_its_schemas_type_and_writes_as_its_file() {
    assert!(!SERVICE_TABLE_FILES.is_empty());
    for table in SERVICE_TABLE_FILES {
        let read = service_table(table)
            .unwrap_or_else(|| panic!("{table} is a service table"))
            .unwrap_or_else(|fault| panic!("{table}: {fault}"));
        assert_eq!(read, file(table), "{table}");
    }
    assert!(service_table("jobs/nothing.json").is_none());
}

#[test]
fn a_table_is_read_by_the_function_named_as_its_type_is() {
    let budgets = jobs_budgets().expect("jobs/budgets.json");
    assert_eq!(
        serde_json::to_value(budgets).expect("written"),
        file("jobs/budgets.json")
    );
}

#[test]
fn an_archivist_route_holds_its_method_and_path() {
    assert_eq!(PUT_RESOURCE_ANCHORED_TEXT.method, ArchivistMethod::Put);
    assert_eq!(
        PUT_RESOURCE_ANCHORED_TEXT.path,
        "/resources/{id}/anchored-text"
    );
}
