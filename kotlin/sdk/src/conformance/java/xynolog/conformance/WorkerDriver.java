package xynolog.conformance;

import io.opentelemetry.api.GlobalOpenTelemetry;
import io.opentelemetry.api.trace.Span;
import io.opentelemetry.api.trace.SpanKind;
import io.opentelemetry.context.Context;
import io.opentelemetry.context.Scope;
import io.opentelemetry.context.propagation.TextMapGetter;
import io.opentelemetry.sdk.OpenTelemetrySdk;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Flow;
import java.util.function.Consumer;
import java.util.function.Function;
import kotlin.Unit;
import kotlinx.coroutines.flow.StateFlowKt;
import kotlinx.serialization.json.JsonArray;
import kotlinx.serialization.json.JsonElement;
import kotlinx.serialization.json.JsonElementKt;
import kotlinx.serialization.json.JsonNull;
import kotlinx.serialization.json.JsonObject;
import kotlinx.serialization.json.JsonPrimitive;
import xynolog.XynologClient;
import xynolog.errors.XynologError;
import xynolog.http.HttpContentTransport;
import xynolog.http.HttpTransport;
import xynolog.http.Timing;
import xynolog.identifiers.ResourceId;
import xynolog.jobs.Claims;
import xynolog.jobs.HeldJob;
import xynolog.jobs.HeldMarkJob;
import xynolog.jobs.HeldYieldJob;
import xynolog.jobs.WorkerChannelsKt;
import xynolog.transport.ResourceHold;
import xynolog.types.ClaimOptions;
import xynolog.types.ClaimRefusal;
import xynolog.types.ConformanceDriverLineClaimed;
import xynolog.types.ConnectionState;
import xynolog.types.FailureClass;
import xynolog.types.HeldJobStall;
import xynolog.types.JobCheckpoint;
import xynolog.types.JobFailure;
import xynolog.types.JobReached;
import xynolog.types.TraceCarrier;
import xynolog.types.UnitCursor;

/**
 * The worker driver: a worker written on this SDK in Java, as
 * protocol/conformance/worker drives it (its README states the protocol). It
 * reaches the worker's surface only as a Java worker's author does: `job.claim`
 * on the client, the claims it returns, and the held jobs they hand out, each
 * call through its future.
 *
 * As a worker's code does, it runs each job it is handed in a span of its own,
 * `job:{jobType}` carrying the job's id as `job.id`: opened in the trace the job
 * states, where the job is handed to it, and ended once it has settled the job.
 * Everything it does for the job it does with that span current, so each
 * message the job sends continues the job's trace.
 *
 * The end of its input is not a stop: the driver then ends as a worker that is
 * killed does, closing its client and transport and saying nothing more. Only
 * `close` stops the worker, failing a job it holds first.
 */
public final class WorkerDriver {
    /** How a trace context is read from what the job states. */
    private static final TextMapGetter<Map<String, String>> CARRIED = (carrier, key) -> carrier == null ? null : carrier.get(key);

    private HttpTransport transport;
    private HttpContentTransport content;
    private XynologClient client;
    private Long jobClaimTimeoutMs;
    private Long heldJobStallMs;
    private Long heldJobStallCheckMs;
    private Long markCommitTimeoutMs;
    private Claims claims;
    private HeldJob job;
    private Span span;
    private ConnectionState reported;
    private final List<ResourceHold> holds = new ArrayList<>();
    private final List<Flow.Subscription> telling = new ArrayList<>();

    // ── What it writes ──────────────────────────────────────────────

    private static JsonElement text(String value) {
        return JsonElementKt.JsonPrimitive(value);
    }

    /** An object of these members, in this order. */
    @SafeVarargs
    private static JsonObject fields(Map.Entry<String, JsonElement>... members) {
        Map<String, JsonElement> written = new LinkedHashMap<>();
        for (Map.Entry<String, JsonElement> member : members) written.put(member.getKey(), member.getValue());
        return new JsonObject(written);
    }

    private static void say(String name, JsonElement value) {
        Say.line(fields(Map.entry(name, value)));
    }

    // ── What it reads ───────────────────────────────────────────────

    private static String text(JsonObject args, String name) {
        JsonElement value = args.get(name);
        if (!(value instanceof JsonPrimitive primitive) || !primitive.isString()) throw new Misuse(name + " must be text");
        return primitive.getContent();
    }

    private static long count(JsonObject args, String name) {
        JsonElement value = args.get(name);
        if (!(value instanceof JsonPrimitive primitive) || primitive.isString()) throw new Misuse(name + " must be a whole number");
        try {
            long counted = Long.parseLong(primitive.getContent());
            if (counted < 0) throw new Misuse(name + " must be a whole number");
            return counted;
        } catch (NumberFormatException notWhole) {
            throw new Misuse(name + " must be a whole number");
        }
    }

    private static List<String> texts(JsonObject args, String name) {
        JsonElement value = args.get(name);
        if (!(value instanceof JsonArray listed)) throw new Misuse(name + " must be a list of text");
        List<String> read = new ArrayList<>();
        for (JsonElement each : listed) {
            if (!(each instanceof JsonPrimitive primitive) || !primitive.isString()) throw new Misuse(name + " must be a list of text");
            read.add(primitive.getContent());
        }
        return read;
    }

    private static JsonObject object(JsonObject args, String name) {
        if (!(args.get(name) instanceof JsonObject stated)) throw new Misuse(name + " must be an object");
        return stated;
    }

    private static Map<String, UnitCursor> cursors(JsonObject args) {
        return args.containsKey("unitCursors") ? Stated.cursors(args.get("unitCursors")) : null;
    }

    private static List<String> units(JsonObject args) {
        return args.containsKey("completedUnits") ? texts(args, "completedUnits") : null;
    }

    // ── Telling the suite what the worker is told ───────────────────

    /** Read every item `publisher` gives, as it gives it; the reading is ended when the driver is done. */
    private synchronized <T> void reading(Flow.Publisher<T> publisher, Consumer<T> each) {
        publisher.subscribe(new Flow.Subscriber<>() {
            @Override
            public void onSubscribe(Flow.Subscription subscription) {
                synchronized (WorkerDriver.this) {
                    telling.add(subscription);
                }
                subscription.request(Long.MAX_VALUE);
            }

            @Override
            public void onNext(T item) {
                each.accept(item);
            }

            @Override
            public void onError(Throwable error) {}

            @Override
            public void onComplete() {}
        });
    }

    private synchronized void report(ConnectionState state) {
        if (state == reported) return;
        reported = state;
        say("state", text(state.getValue()));
    }

    // ── The held job and its span ───────────────────────────────────

    private synchronized HeldJob held() {
        if (job == null || span == null) throw new Misuse("the worker has held no job");
        return job;
    }

    /** Hold `handed`, and open the span it is run in: in the trace the job states. */
    private synchronized void hold(HeldJob handed) {
        Context parent = Context.root();
        TraceCarrier trace = handed.getTrace();
        if (trace != null) {
            Map<String, String> carrier = new HashMap<>();
            carrier.put("traceparent", trace.getTraceparent());
            if (trace.getTracestate() != null) carrier.put("tracestate", trace.getTracestate());
            parent = GlobalOpenTelemetry.getPropagators().getTextMapPropagator().extract(Context.root(), carrier, CARRIED);
        }
        span = GlobalOpenTelemetry.getTracer("xynolog-conformance-driver")
                .spanBuilder("job:" + handed.getJobType().getValue())
                .setParent(parent)
                .setSpanKind(SpanKind.CONSUMER)
                .setAttribute("job.id", handed.getJobId().getValue())
                .startSpan();
        job = handed;
    }

    /** Something done for the held job, called with its span current: the job's future, settling the operation. */
    private CompletableFuture<JsonElement> working(Function<HeldJob, CompletableFuture<Unit>> call) {
        HeldJob held = held();
        Span current;
        synchronized (this) {
            current = span;
        }
        Scope inSpan = current.makeCurrent();
        try {
            return call.apply(held).thenApply(_ -> JsonNull.INSTANCE);
        } finally {
            inSpan.close();
        }
    }

    /** The held job, settled: its span ends once that is done, however it went. */
    private CompletableFuture<JsonElement> settling(Function<HeldJob, CompletableFuture<Unit>> call) {
        Span ending;
        synchronized (this) {
            ending = span;
        }
        return working(call).whenComplete((_, _) -> ending.end());
    }

    // ── The operations ──────────────────────────────────────────────

    private synchronized XynologClient opened() {
        if (client == null) throw new Misuse("no transport is open");
        return client;
    }

    private synchronized Claims claiming() {
        if (claims == null) throw new Misuse("the worker is not claiming");
        return claims;
    }

    private JsonElement open(JsonObject args) {
        synchronized (this) {
            if (client != null) throw new Misuse("a transport is already open");
        }
        Timing known = new Timing();
        long reconnectMs = known.getReconnectMs();
        long lazyRemoveMs = known.getLazyRemoveMs();
        long lingerMs = known.getLingerMs();
        if (args.containsKey("timing")) {
            JsonObject stated = object(args, "timing");
            for (String name : stated.keySet()) {
                switch (name) {
                    case "reconnectMs" -> reconnectMs = count(stated, name);
                    case "lazyRemoveMs" -> lazyRemoveMs = count(stated, name);
                    case "lingerMs" -> lingerMs = count(stated, name);
                    case "jobClaimTimeoutMs" -> jobClaimTimeoutMs = count(stated, name);
                    case "heldJobStallMs" -> heldJobStallMs = count(stated, name);
                    case "heldJobStallCheckMs" -> heldJobStallCheckMs = count(stated, name);
                    case "markCommitTimeoutMs" -> markCommitTimeoutMs = count(stated, name);
                    default -> throw new Misuse("this driver cannot override " + name);
                }
            }
        }
        boolean commits = false;
        if (args.containsKey("commits")) {
            if (!(args.get("commits") instanceof JsonPrimitive stated) || stated.isString() || !Set.of("true", "false").contains(stated.getContent())) {
                throw new Misuse("commits must be a boolean");
            }
            commits = Boolean.parseBoolean(stated.getContent());
        }
        // What a worker's stream names for its claims, and for its commits when it will make any, and no more.
        List<String> channels = new ArrayList<>(WorkerChannelsKt.getJOB_CLAIM_CHANNELS());
        if (commits) channels.addAll(WorkerChannelsKt.getJOB_COMMIT_CHANNELS());
        HttpTransport made = new HttpTransport(text(args, "baseUrl"), StateFlowKt.MutableStateFlow(text(args, "token")), channels, new Timing(reconnectMs, lazyRemoveMs, lingerMs));
        // Taken at once, so every failure from the first request on is heard.
        reading(made.failures().asPublisher(), (XynologError error) -> say("error", ProtocolKt.failure(error)));
        reading(made.getState().asPublisher(), (Optional<ConnectionState> state) -> state.ifPresent(this::report));
        synchronized (this) {
            transport = made;
            content = new HttpContentTransport(made);
            client = new XynologClient(made, content, made);
        }
        return JsonNull.INSTANCE;
    }

    /** A worker that stops: a job it still holds is failed first. */
    private JsonElement close() {
        XynologClient opened = opened();
        Claims stopping;
        synchronized (this) {
            stopping = claims;
        }
        if (stopping != null) stopping.stopFuture().join();
        dispose(opened);
        return JsonNull.INSTANCE;
    }

    private JsonElement subscribeResource(JsonObject args) {
        HttpTransport opened;
        synchronized (this) {
            opened = transport;
        }
        if (opened == null) throw new Misuse("no transport is open");
        ResourceId resource;
        try {
            resource = new ResourceId(text(args, "resource"));
        } catch (IllegalArgumentException notAnId) {
            throw new Misuse("resource is not a resource's id: " + notAnId.getMessage());
        }
        ResourceHold hold = opened.subscribeToResource(resource);
        synchronized (this) {
            holds.add(hold);
        }
        return JsonNull.INSTANCE;
    }

    /** Begin claiming, and say what the claims hand out and tell. */
    private JsonElement claim(JsonObject args) {
        synchronized (this) {
            if (claims != null) throw new Misuse("the worker is already claiming");
        }
        ClaimOptions options = ClaimOptions.builder(Stated.filters(args.get("accepts")))
                .jobClaimTimeoutMs(jobClaimTimeoutMs)
                .heldJobStallMs(heldJobStallMs)
                .heldJobStallCheckMs(heldJobStallCheckMs)
                .markCommitTimeoutMs(markCommitTimeoutMs)
                .build();
        Claims made = opened().getJob().claim(options);
        synchronized (this) {
            claims = made;
        }
        reading(made.refused().asPublisher(), (ClaimRefusal refused) -> {
            Map<String, JsonElement> said = new LinkedHashMap<>();
            if (refused.getCode() != null) said.put("code", text(refused.getCode().getCode()));
            said.put("detail", text(refused.getMessage()));
            say("refused", new JsonObject(said));
        });
        reading(made.stalled().asPublisher(), (HeldJobStall stall) -> say("stalled", text(stall.getJobId().getValue())));
        Thread reader = new Thread(() -> handOut(made), "claims");
        reader.setDaemon(true);
        reader.start();
        return JsonNull.INSTANCE;
    }

    /** Each job the claims hand out, held and said, until they end. */
    private void handOut(Claims made) {
        while (true) {
            HeldJob handed;
            try {
                handed = made.nextFuture().join();
            } catch (RuntimeException ended) {
                return;
            }
            if (handed == null) return;
            hold(handed);
            reading(handed.getCancelled().asPublisher(), (Optional<Boolean> cancelled) -> {
                if (cancelled.orElse(false)) say("signalled", text(handed.getJobId().getValue()));
            });
            Say.line(Stated.written(ConformanceDriverLineClaimed.builder(handed.getRecord()).build()));
        }
    }

    private CompletableFuture<JsonElement> start() {
        return working(HeldJob::startFuture);
    }

    private CompletableFuture<JsonElement> progress(JsonObject args) {
        Map<String, JsonElement> stated = new LinkedHashMap<>();
        for (String name : List.of("percentage", "message")) {
            if (args.containsKey(name)) stated.put(name, args.get(name));
        }
        var progress = Stated.progress(new JsonObject(stated));
        return working(job -> job.progressFuture(progress));
    }

    private CompletableFuture<JsonElement> checkpoint(JsonObject args) {
        JobCheckpoint checkpoint = JobCheckpoint.builder(texts(args, "completedUnits")).unitCursors(cursors(args)).build();
        return working(job -> job.checkpointFuture(checkpoint));
    }

    /** The held job commits for itself: it cites its own id, and remembers what the commit observed for its settle. */
    private CompletableFuture<JsonElement> commit(JsonObject args) {
        ResourceId resource;
        try {
            resource = new ResourceId(text(args, "resourceId"));
        } catch (IllegalArgumentException notAnId) {
            throw new Misuse("resourceId is not a resource's id: " + notAnId.getMessage());
        }
        var annotations = Stated.annotations(args.get("annotations"));
        return working(job -> job.commitFuture(resource, annotations));
    }

    /** A completion is its verb's, so the verb is read before the result is given. */
    private CompletableFuture<JsonElement> complete(JsonObject args) {
        JsonObject result = object(args, "result");
        return settling(job -> job instanceof HeldMarkJob mark
                ? mark.completeFuture(Stated.markResult(result))
                : ((HeldYieldJob) job).completeFuture(Stated.yieldResult(result)));
    }

    private CompletableFuture<JsonElement> fail(JsonObject args) {
        String error = text(args, "error");
        FailureClass failureClass = args.containsKey("failureClass") ? Stated.failureClass(args.get("failureClass")) : null;
        JobFailure failure = JobFailure.builder().completedUnits(units(args)).unitCursors(cursors(args)).failureClass(failureClass).build();
        return settling(job -> job.failFuture(error, failure));
    }

    private CompletableFuture<JsonElement> cancel(JsonObject args) {
        JobReached reached = JobReached.builder().completedUnits(units(args)).unitCursors(cursors(args)).build();
        return settling(job -> job.cancelFuture(reached));
    }

    private JsonElement vitals() {
        return Stated.written(claiming().vitals());
    }

    /** Close the client and the transport, telling the suite nothing more: what a stop does after its failing, and all a killed worker does. */
    private void dispose(XynologClient opened) {
        List<Flow.Subscription> told;
        List<ResourceHold> held;
        synchronized (this) {
            told = new ArrayList<>(telling);
            held = new ArrayList<>(holds);
            telling.clear();
            holds.clear();
        }
        for (Flow.Subscription subscription : told) subscription.cancel();
        for (ResourceHold hold : held) hold.close();
        opened.close();
        content.close();
        transport.close();
    }

    /** The suite is done with this worker, and it ends as a worker that is killed ends: the claims are not stopped. */
    private void finish() {
        XynologClient opened;
        synchronized (this) {
            opened = client;
        }
        if (opened != null) dispose(opened);
    }

    /** An operation done at once: its answer, settled. */
    private static JavaOperation now(Function<JsonObject, JsonElement> work) {
        return args -> CompletableFuture.completedFuture(work.apply(args));
    }

    /** An operation settled by what it began. */
    private static JavaOperation later(Function<JsonObject, CompletableFuture<JsonElement>> work) {
        return work::apply;
    }

    private Map<String, JavaOperation> operations() {
        Map<String, JavaOperation> operations = new LinkedHashMap<>();
        operations.put("open", now(this::open));
        operations.put("close", now(args -> close()));
        operations.put("subscribe-resource", now(this::subscribeResource));
        operations.put("claim", now(this::claim));
        operations.put("start", later(args -> start()));
        operations.put("progress", later(this::progress));
        operations.put("checkpoint", later(this::checkpoint));
        // Not in turn: a commit settles when the record answers it, and the suite asks other things of the worker until then.
        operations.put("commit", later(this::commit));
        operations.put("complete", later(this::complete));
        operations.put("fail", later(this::fail));
        operations.put("cancel", later(this::cancel));
        operations.put("vitals", now(args -> vitals()));
        // Answered after everything the worker reported before it.
        operations.put("sync", now(args -> JsonNull.INSTANCE));
        return operations;
    }

    public static void main(String[] args) {
        OpenTelemetrySdk exporting = ExportingKt.exporting();
        try {
            WorkerDriver driver = new WorkerDriver();
            Map<String, JavaOperation> operations = driver.operations();
            Set<String> inTurn = new java.util.HashSet<>(operations.keySet());
            inTurn.remove("commit");
            ProtocolKt.serveJava(operations, inTurn, driver::finish);
        } finally {
            if (exporting != null) exporting.close();
        }
    }
}
