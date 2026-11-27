package xynolog

// What the conformance suite's telemetry case cannot see: the trace a frame
// brings, taken off its payload, and the trace the work done for it
// continues, with no provider installed, and with and without a propagator.
// The spans and the count are the suite's to hold, from what a driver exports.

import (
	"context"
	"encoding/json"
	"net/http"
	"reflect"
	"testing"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/propagation"
	"go.opentelemetry.io/otel/trace"

	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/bus"
)

const (
	aTraceparent = "00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-01"
	aTracestate  = "congo=t61rcWkgMzE"
)

// aTrace is a trace with a tracestate, as a frame brings one.
func aTrace() *api.TraceCarrier {
	tracestate := aTracestate
	return &api.TraceCarrier{Traceparent: aTraceparent, Tracestate: &tracestate}
}

func TestAFrameWithNoTraceKeepsItsPayloadAsItCame(t *testing.T) {
	payload := json.RawMessage(`{"annotationId":"a-1","note":{"_trace":"inside a value, not the frame's"}}`)
	rest, sentUnder := withoutTrace(payload)
	if string(rest) != string(payload) || sentUnder != nil {
		t.Fatalf("got %s, %+v: a payload with no trace of its own is the frame's as it came", rest, sentUnder)
	}
}

func TestAPayloadThatIsNoObjectCarriesNoTraceAndKeepsItsPayloadAsItCame(t *testing.T) {
	payload := json.RawMessage(`["_trace"]`)
	rest, sentUnder := withoutTrace(payload)
	if string(rest) != string(payload) || sentUnder != nil {
		t.Fatalf("got %s, %+v: a payload that is not an object has no trace member, and is passed on as it came", rest, sentUnder)
	}
}

func TestAFramesTraceIsTakenOffItsPayload(t *testing.T) {
	payload := json.RawMessage(`{"annotationId":"a-1","_trace":{"traceparent":"` + aTraceparent + `","tracestate":"` + aTracestate + `"}}`)
	rest, sentUnder := withoutTrace(payload)
	if string(rest) != `{"annotationId":"a-1"}` {
		t.Fatalf("the payload delivered is %s: it carries the trace still, or lost a field", rest)
	}
	if !reflect.DeepEqual(sentUnder, aTrace()) {
		t.Fatalf("the trace read is %+v", sentUnder)
	}
}

func TestATraceTheRequiredTableRefusesIsNoTraceAndIsStillTakenOff(t *testing.T) {
	for _, carried := range []string{
		`{"tracestate":"` + aTracestate + `"}`,
		`{"traceparent":"` + aTraceparent + `","tracestate":""}`,
	} {
		rest, sentUnder := withoutTrace(json.RawMessage(`{"annotationId":"a-1","_trace":` + carried + `}`))
		if string(rest) != `{"annotationId":"a-1"}` || sentUnder != nil {
			t.Errorf("a frame whose trace is %s: got %s, %+v", carried, rest, sentUnder)
		}
	}
}

// propagating installs propagator as the process's for the test, as an
// application installs its OpenTelemetry, and leaves none installed after.
func propagating(t *testing.T, propagator propagation.TextMapPropagator) {
	t.Helper()
	otel.SetTextMapPropagator(propagator)
	t.Cleanup(func() { otel.SetTextMapPropagator(propagation.NewCompositeTextMapPropagator()) })
}

func TestWorkContinuingATraceIsInThatTrace(t *testing.T) {
	propagating(t, propagation.TraceContext{})
	sent := aTrace()
	if got := activeTrace(Continuing(context.Background(), sent)); !reflect.DeepEqual(got, sent) {
		t.Fatalf("work continuing %+v is in %+v", sent, got)
	}
	if got := activeTrace(Continuing(context.Background(), nil)); got != nil {
		t.Fatalf("work continuing no trace is in %+v", got)
	}
	header := http.Header{}
	carryTrace(Continuing(context.Background(), sent), header)
	if header.Get("traceparent") != aTraceparent {
		t.Errorf("a request made in a trace carries %q", header.Get("traceparent"))
	}
}

// Which propagator carries a trace is the application's to say: with none
// installed, no trace travels, and a frame keeps the one it brought.
func TestWithNoPropagatorNoTraceTravels(t *testing.T) {
	propagating(t, propagation.NewCompositeTextMapPropagator())
	sent := aTrace()
	if got := activeTrace(Continuing(context.Background(), sent)); got != nil {
		t.Errorf("with no propagator, work continuing a trace is in %+v", got)
	}
	// Work that is in a trace, however it came to be: still none travels.
	traceID, _ := trace.TraceIDFromHex("0af7651916cd43dd8448eb211c80319c")
	spanID, _ := trace.SpanIDFromHex("b7ad6b7169203331")
	inTrace := trace.ContextWithRemoteSpanContext(context.Background(), trace.NewSpanContext(trace.SpanContextConfig{
		TraceID: traceID, SpanID: spanID, TraceFlags: trace.FlagsSampled, Remote: true,
	}))
	if got := activeTrace(inTrace); got != nil {
		t.Errorf("with no propagator, work in a trace says it is in %+v", got)
	}
	header := http.Header{}
	carryTrace(inTrace, header)
	if len(header) != 0 {
		t.Errorf("with no propagator, a request made in a trace carries %v", header)
	}
	if got := received(bus.Channel("beckon:focus"), api.ResourceId{}, sent); !reflect.DeepEqual(got, sent) {
		t.Errorf("with no propagator, a frame sent under %+v is continued in %+v, not what it brought", sent, got)
	}
}

func TestWithNoProviderAFrameIsContinuedInTheTraceItBrought(t *testing.T) {
	propagating(t, propagation.TraceContext{})
	scope, err := api.ParseResourceId("r-1")
	if err != nil {
		t.Fatal(err)
	}
	sent := aTrace()
	if got := received(bus.Channel("beckon:focus"), scope, sent); !reflect.DeepEqual(got, sent) {
		t.Fatalf("a frame sent under %+v is continued in %+v", sent, got)
	}
	if got := received(bus.Channel("beckon:focus"), api.ResourceId{}, nil); got != nil {
		t.Fatalf("a frame sent under no trace is continued in %+v", got)
	}
}
