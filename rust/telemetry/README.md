# xynolog-telemetry

[![crates.io](https://img.shields.io/crates/v/xynolog-telemetry.svg)](https://crates.io/crates/xynolog-telemetry)
[![docs.rs](https://img.shields.io/docsrs/xynolog-telemetry)](https://docs.rs/xynolog-telemetry)
[![CI](https://github.com/xynolog/sdk/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/xynolog/sdk/actions/workflows/ci.yml?query=branch%3Amain)
[![License](https://img.shields.io/crates/l/xynolog-telemetry.svg)](https://github.com/xynolog/sdk/blob/v0.8.2/LICENSE)
[![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=rust-telemetry)](https://app.codecov.io/gh/xynolog/sdk/components)

The traces and counts of the [Xynolog Rust SDK](https://github.com/xynolog/sdk/blob/v0.8.2/rust/sdk/README.md), as
[OpenTelemetry](https://opentelemetry.io). When a Xynolog client sends to a
knowledge base or receives from it, the transport says so through this
crate, and this crate reports it to whatever OpenTelemetry the application
installed.

It exports nothing itself. With no OpenTelemetry installed, nothing is
recorded and no trace context leaves the process.

## Install

```bash
cargo add xynolog-telemetry
```

Below 1.0 the minor number is the break, and the requirement `cargo add`
writes into `Cargo.toml` takes the releases up to the next minor and no
further.

It is built with `opentelemetry` 0.33. Every function is documented on
[docs.rs](https://docs.rs/xynolog-telemetry).

## Do you need it?

- **To see the client's traces in your own telemetry**, you install your
  OpenTelemetry as usual. [`xynolog-http-transport`](https://github.com/xynolog/sdk/blob/v0.8.2/rust/http-transport/README.md)
  already depends on this crate, so its spans appear with yours. See
  [Turning it on](#turning-it-on).
- **To write a transport** for the SDK, you report through the functions
  below. See [Writing a transport](#writing-a-transport).

## Turning it on

An application installs its own OpenTelemetry as the process's, once:

```rust
// A tracer provider, a meter provider and the W3C propagator, as the
// process's: what this crate, and so the transport, reports to.
global::set_text_map_propagator(TraceContextPropagator::new());
global::set_tracer_provider(tracer_provider);
global::set_meter_provider(meter_provider.clone());
// The bus log's `trace=` field is the active span's trace.
xynolog::bus_log::set_trace_id_provider(xynolog_telemetry::active_trace_id);
```

- The application's `opentelemetry` is the version this crate is built with.
  OpenTelemetry's global registry belongs to one version of its crate: a
  provider installed through another version is one this crate never sees,
  and nothing says so.
- The tracer, the meter and the propagator are taken from
  `opentelemetry::global` at each use, so what is installed after a client
  opened is reported to all the same.
- With a tracer provider and no propagator, spans are recorded and no trace
  context travels.

## What is reported

The spans and the count are the rows of the SDK telemetry table
([telemetry.json](https://github.com/xynolog/protocol/blob/main/specs/src/sdk-telemetry/telemetry.json)), which
every Xynolog SDK reports the same way.

| Name | Kind | When |
|---|---|---|
| `bus.emit:{channel}` | producer span | The client sends on a channel |
| `xynolog.bus.sent` | counter | The same, counted |
| `bus.recv:{channel}` | consumer span | A frame arrives, continuing the trace it was sent under |
| `content.put` | client span | A resource's bytes are uploaded |
| `content.get` | client span | A resource's bytes are read |
| `content.get_graph` | client span | A resource's linked-data description is read |
| `content.get_anchored_text` | client span | A resource's anchored text is read |

A trace travels with what is sent, as the W3C `traceparent` and
`tracestate`, so one request can be followed from the application through
the gateway and the services behind it.

## Writing a transport

One function per row of the table. A transport says what happened, in
Xynolog's terms, and names no span, kind or attribute of its own:

| Function | Row |
|---|---|
| `bus_emit(channel, scope, send)` | `bus.emit:{channel}`, and the count |
| `bus_recv(channel, scope, sent_under)` | `bus.recv:{channel}` |
| `content_put(format, size_bytes, upload)` | `content.put` |
| `content_get(resource_id, stream, read)` | `content.get` |
| `content_get_graph(resource_id, read)` | `content.get_graph` |
| `content_get_anchored_text(resource_id, read)` | `content.get_anchored_text` |

```rust
// The span's name, its kind and its attributes are the table's.
let created = content_put("image/png", 256, upload).await;
```

`active_trace()` is the trace context of the span that is running, as the
SDK's `TraceCarrier`: what a transport puts on what it sends. `bus_recv`
answers the trace that the work done for a frame continues.

A transport depends on this crate and on no OpenTelemetry crate.

## Writing a service

Xynolog's own services state spans of their own, the rows of the service
telemetry table
([telemetry.json](https://github.com/xynolog/protocol/blob/main/specs/src/service-telemetry/telemetry.json)), over
four more functions:

| Function | |
|---|---|
| `in_span`, `in_span_now` | Run work in a span |
| `continued` | A caller's trace, as the parent of what is done for it |
| `continuing` | Run work in the trace a frame arrived in |
| `on_the_bus` | The attributes a span or a count of the bus carries |

## The other crates

| Crate | |
|---|---|
| [`xynolog`](https://github.com/xynolog/sdk/blob/v0.8.2/rust/sdk/README.md) | The SDK's client. |
| [`xynolog-http-transport`](https://github.com/xynolog/sdk/blob/v0.8.2/rust/http-transport/README.md) | The transport over a gateway, which reports through this crate. |

## License

Apache-2.0. See [LICENSE](https://github.com/xynolog/sdk/blob/v0.8.2/LICENSE).

Working on the SDK itself? See [CONTRIBUTING.md](https://github.com/xynolog/sdk/blob/main/CONTRIBUTING.md).
