module github.com/xynolog/sdk/go

// The oldest Go that builds the module, for a program that requires it.
// The toolchain line below is the Go this repository builds and tests with,
// and a requiring program ignores it.
go 1.26.0

// Pinned to the patch, not the minor: `go 1.27` alone lets CI resolve to
// whatever 1.27.x it happens to have, and a stdlib vulnerability fixed in a later patch
// then fails govulncheck on a compiler nobody chose. actions/setup-go reads
// this line from go-version-file, so the scan and the build agree on one
// compiler.
toolchain go1.27.4

require (
	github.com/google/uuid v1.6.0
	go.opentelemetry.io/otel v1.47.0
	go.opentelemetry.io/otel/metric v1.47.0
	go.opentelemetry.io/otel/trace v1.47.0
	golang.org/x/text v0.44.0
)

require (
	github.com/cespare/xxhash/v2 v2.3.0 // indirect
	github.com/go-logr/logr v1.4.4 // indirect
	github.com/go-logr/stdr v1.2.2 // indirect
	go.opentelemetry.io/auto/sdk v1.2.1 // indirect
	go.opentelemetry.io/otel/log v1.47.0 // indirect
)
