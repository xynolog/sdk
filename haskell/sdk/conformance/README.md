# Haskell conformance drivers

`Main.hs` implements the shared [wire driver protocol](https://github.com/xynolog/protocol/blob/main/conformance/sdk/README.md#the-driver-protocol)
using only the public `xynolog` library. Operations run concurrently; subscriptions
register before their acknowledgements, cancellation joins abandoned work, and
EOF closes the client and its reporters. The operation census compares the actual
dispatcher with the protocol's complete operation table.

With `--worker`, it implements the shared
[worker driver protocol](https://github.com/xynolog/protocol/blob/main/conformance/worker/README.md#the-worker-driver)
over `Xynolog.Worker`. The transport subscribes to the generated worker channel
profiles. Claims, lifecycle messages, commit probes, cancellations, stalls and
vitals all use the public SDK. Each job is run in a span parented by the carrier
its claim reply brought. Explicit `close` stops the worker before its transport;
EOF exits without settling a held job, as the worker protocol requires.

`LiveMain.hs` implements the live-query protocol over the public client. It
observes all ten query families, fresh reads and invalidation, deletion and
Mark/Yield delegation. One storage survives close/reopen for persisted-cache
cases. `LiveQueries.hs` is generated from the refresh table. Both executables
share protocol decoding and reply formatting in `DriverProtocol.hs`.

Build them from the repository root:

```sh
make test-haskell
```

The target copies both executables to `conformance/bin`. Xynolog's implementations
file registers wire, worker and live drivers; the live tier is `parity`. Follow their setup for
the gateway, core package, Node dependencies and NATS. Run npm commands inside
Apple `container` locally.

A case's `timing` is read into the SDK's generated `ClientTiming` and
`TransportTiming`, and a worker's waits into its `ClaimOptions`; a name that
nothing a driver builds holds is `misuse`. The driver uses real
monotonic time, interruptible absolute waits, independent UUIDs and random jitter.
When the harness supplies `OTEL_EXPORTER_OTLP_ENDPOINT`, the driver configures
standard OpenTelemetry providers and exporters and shuts them down before exit.
That setup belongs to this executable; the SDK library uses the host's providers.
