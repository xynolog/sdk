//! The transport in a process that installed no telemetry: no trace context
//! leaves it, and a frame's own is handed on as it came. Its own binary,
//! because what a process installed is the process's.

mod telemetry_gateway;

use serde_json::json;
use telemetry_gateway::{Gateway, SENT, sparkle};
use xynolog::transport::{Envelope, Transport};
use xynolog::types::TraceCarrier;

const SENDER: &str = "00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-01";

#[tokio::test]
async fn with_no_telemetry_installed_no_trace_leaves_and_a_frames_own_is_handed_on() {
    let gateway = Gateway::start().await;
    let transport = gateway.client().await;

    transport
        .emit(SENT, sparkle(), Envelope::default())
        .await
        .expect("the emit is accepted");
    assert_eq!(gateway.traceparents(), [None]);

    let frame = gateway
        .deliver(&transport, json!({ "traceparent": SENDER }))
        .await;
    assert_eq!(
        frame.trace,
        Some(TraceCarrier {
            traceparent: SENDER.to_owned(),
            tracestate: None,
        })
    );
    assert!(
        !frame.bus_frame.payload.contains_key("_trace"),
        "the payload carries no trace"
    );
}

#[tokio::test]
async fn a_trace_the_required_table_refuses_is_no_trace_and_is_taken_off_the_payload_all_the_same()
{
    let gateway = Gateway::start().await;
    let transport = gateway.client().await;

    let frame = gateway
        .deliver(
            &transport,
            json!({ "traceparent": SENDER, "tracestate": "" }),
        )
        .await;
    assert_eq!(frame.trace, None);
    assert!(
        !frame.bus_frame.payload.contains_key("_trace"),
        "the payload carries no trace"
    );
}
