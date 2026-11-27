//! What the SDK states of protocol/specs/src/errors/codes.json and
//! protocol/specs/src/control/methods.json, held to the tables: every
//! vocabulary is an enum of its codes, and every method and notification of
//! the control API is a marker of what it carries.

use serde_json::Value;
use xynolog::control::{
    CONTROL_METHODS, CONTROL_NOTIFICATIONS, ControlMethod, ControlNotification, LauncherAbout,
    NotificationsCancelled, RootsInit, control_method,
};
use xynolog::errors::{
    BusRequestErrorCode, ControlErrorCode, IdentityUnverifiableReason, JobErrorCode,
    SessionErrorCode, SignInErrorCode, SpanRefusal, TransportErrorCode,
};
use xynolog::types::{AboutParams, ApiVersion, Cancelled, ControlSender, RootsInitResult};

fn table(text: &str) -> Value {
    serde_json::from_str(text).expect("the table is JSON")
}

fn codes(vocabulary: &Value) -> Vec<&str> {
    vocabulary["codes"]
        .as_array()
        .expect("a vocabulary's codes")
        .iter()
        .map(|code| code["code"].as_str().expect("a code"))
        .collect()
}

/// Every vocabulary of the table, and the codes the SDK's enum of it states:
/// a vocabulary the table gains is not one of these, and fails.
#[test]
fn every_vocabulary_is_an_enum_of_its_codes() {
    let table = table(include_str!("../specs/errors/codes.json"));
    let vocabularies = table.as_object().expect("the table is an object");
    for (member, vocabulary) in vocabularies {
        if member.starts_with('$') {
            continue;
        }
        let stated: Vec<&str> = match member.as_str() {
            "busRequest" => BusRequestErrorCode::ALL
                .iter()
                .map(|c| c.as_str())
                .collect(),
            "transport" => TransportErrorCode::ALL.iter().map(|c| c.as_str()).collect(),
            "job" => JobErrorCode::ALL.iter().map(|c| c.as_str()).collect(),
            "session" => SessionErrorCode::ALL.iter().map(|c| c.as_str()).collect(),
            "signIn" => SignInErrorCode::ALL.iter().map(|c| c.as_str()).collect(),
            "kbIdentity" => IdentityUnverifiableReason::ALL
                .iter()
                .map(|c| c.as_str())
                .collect(),
            "spanRefusal" => SpanRefusal::ALL.iter().map(|c| c.as_str()).collect(),
            "control" => ControlErrorCode::ALL.iter().map(|c| c.as_str()).collect(),
            other => panic!("errors/codes.json states the vocabulary {other}, which no enum does"),
        };
        assert_eq!(stated, codes(vocabulary), "{member}");
    }
}

/// Every method and notification of the table, by name, as the table states
/// it.
#[test]
fn every_method_and_notification_is_the_tables() {
    let table = table(include_str!("../specs/control/methods.json"));
    let methods: Vec<(String, bool, Vec<String>)> = table["methods"]
        .as_array()
        .expect("methods")
        .iter()
        .map(|method| {
            (
                method["name"].as_str().expect("a name").to_owned(),
                method["exclusive"].as_bool().expect("exclusive"),
                serde_json::from_value(method["sends"].clone()).expect("sends"),
            )
        })
        .collect();
    let stated: Vec<(String, bool, Vec<String>)> = CONTROL_METHODS
        .iter()
        .map(|method| {
            (
                method.name.to_owned(),
                method.exclusive,
                method.sends.iter().map(|sent| (*sent).to_owned()).collect(),
            )
        })
        .collect();
    assert_eq!(stated, methods);

    let notifications: Vec<(String, String)> = table["notifications"]
        .as_array()
        .expect("notifications")
        .iter()
        .map(|notification| {
            (
                notification["name"].as_str().expect("a name").to_owned(),
                notification["from"].as_str().expect("from").to_owned(),
            )
        })
        .collect();
    let stated: Vec<(String, String)> = CONTROL_NOTIFICATIONS
        .iter()
        .map(|notification| {
            (
                notification.name.to_owned(),
                notification.from.as_str().to_owned(),
            )
        })
        .collect();
    assert_eq!(stated, notifications);
}

fn carries<M: ControlMethod<Params = P, Result = R>, P, R>() {}
fn notifies<N: ControlNotification<Params = P>, P>() {}

#[test]
fn a_methods_marker_carries_its_params_and_result_types() {
    carries::<LauncherAbout, AboutParams, xynolog::types::AboutResult>();
    carries::<RootsInit, xynolog::types::RootsInitParams, RootsInitResult>();
    notifies::<NotificationsCancelled, Cancelled>();
    assert_eq!(RootsInit::SENDS, ["notifications/progress"]);
    assert_eq!(
        CONTROL_METHODS
            .iter()
            .find(|method| method.name == LauncherAbout::NAME)
            .map(|method| method.exclusive),
        Some(LauncherAbout::EXCLUSIVE)
    );
    assert_eq!(NotificationsCancelled::FROM, ControlSender::Client);
    assert_eq!(
        control_method("roots.init").map(|method| method.sends),
        Some(RootsInit::SENDS)
    );
    assert_eq!(control_method("roots.nothing"), None);
    let written = serde_json::to_value(AboutParams {
        api_version: ApiVersion::ControlXynologOrgV1alpha1,
    })
    .expect("params");
    assert_eq!(written["apiVersion"], "control.xynolog.org/v1alpha1");
}
