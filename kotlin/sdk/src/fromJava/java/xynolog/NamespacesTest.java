package xynolog;

import static java.util.concurrent.TimeUnit.SECONDS;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Flow;
import java.util.stream.Stream;
import kotlin.time.TimeSource;
import kotlinx.coroutines.Dispatchers;
import kotlinx.serialization.json.Json;
import kotlinx.serialization.json.JsonElementKt;
import kotlinx.serialization.json.JsonObject;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import xynolog.bus.Typed;
import xynolog.errors.XynologError;
import xynolog.channels.Channels;
import xynolog.channels.ChannelsKt;
import xynolog.identifiers.AnnotationId;
import xynolog.identifiers.JobId;
import xynolog.identifiers.ResourceId;
import xynolog.testing.ContentCall;
import xynolog.testing.FaultyTransport;
import xynolog.testing.GetAnchoredText;
import xynolog.testing.GetBinary;
import xynolog.testing.GetBinaryStream;
import xynolog.testing.GetResourceGraph;
import xynolog.testing.InMemoryContent;
import xynolog.testing.RequestLogEntry;
import xynolog.testing.StubGateway;
import xynolog.testing.TestClient;
import xynolog.transport.Carried;
import xynolog.transport.Delivered;
import xynolog.transport.Events;
import xynolog.transport.Frame;
import xynolog.transport.Heard;
import xynolog.types.AnnotationTarget;
import xynolog.types.BeckonSparkleEvent;
import xynolog.types.BindInitiateCommand;
import xynolog.types.BrowseDirectoryRequestSort;
import xynolog.types.CreateAnnotationRequest;
import xynolog.types.GatherResourceOptions;
import xynolog.types.GatheredContext;
import xynolog.types.JobFailCommand;
import xynolog.types.JobPollOptions;
import xynolog.types.JobQueuedEvent;
import xynolog.types.JobReportProgressCommand;
import xynolog.types.MarkJobQueuedEvent;
import xynolog.types.MarkSubmitEvent;
import xynolog.types.MatchSearchRequest;
import xynolog.types.Motivation;
import xynolog.types.ResourceErrorEvent;
import xynolog.types.TagSchema;
import xynolog.types.TextQuoteSelector;

/**
 * Every method of every namespace, called as a Java program calls it, over
 * the testing module's doubles: what each asks of the knowledge base, reads
 * of its content or its gateway, sends over the wire, or says on the
 * client's own bus. A request nobody scripted is refused, which is enough to
 * show what was asked.
 */
final class NamespacesTest {
    private static final ResourceId RESOURCE = new ResourceId("res-1");
    private static final AnnotationId ANNOTATION = new AnnotationId("ann-1");
    private static final JobId JOB = new JobId("job-1");
    private static final String CONTEXT = "{\"focus\":{\"kind\":\"resource\",\"resource\":{\"@context\":\"https://schema.org\",\"@id\":\"res-1\",\"name\":\"A resource\","
            + "\"representations\":[]}},\"graph\":{\"nodes\":[],\"edges\":[]},\"metadata\":{}}";

    /** A full client's channels, and what is queued, which `job.queued()` reads. */
    private static final List<String> CHANNELS = Stream.concat(ChannelsKt.getBRIDGED_CHANNELS().stream(), Stream.of(Channels.JOB_QUEUED.getName())).toList();

    private final FaultyTransport transport = new FaultyTransport(CHANNELS);
    private final InMemoryContent content = new InMemoryContent();
    private final StubGateway gateway = new StubGateway();
    private final XynologClient client = new TestClient(Dispatchers.getDefault(), TimeSource.Monotonic.INSTANCE, transport, content, gateway).getClient();

    @AfterEach
    void close() {
        client.close();
        transport.close();
    }

    private static JsonObject json(String text) {
        return JsonElementKt.getJsonObject(Json.Default.parseToJsonElement(text));
    }

    private static <T> CompletableFuture<T> first(Flow.Publisher<T> publisher) {
        CompletableFuture<T> first = new CompletableFuture<>();
        publisher.subscribe(new Flow.Subscriber<>() {
            @Override
            public void onSubscribe(Flow.Subscription subscription) {
                subscription.request(1);
            }

            @Override
            public void onNext(T item) {
                first.complete(item);
            }

            @Override
            public void onError(Throwable error) {
                first.completeExceptionally(error);
            }

            @Override
            public void onComplete() {}
        });
        return first;
    }

    /** What a typed read heard, as the frame it is: a refusal fails the test. */
    private static <P> Delivered<P> delivered(Heard<P> heard) {
        if (heard instanceof Delivered<P> frame) {
            return frame;
        }
        throw new AssertionError("refused: " + heard);
    }

    /** Wait for `call` to settle: with a value, or refused with a failure the SDK names. */
    private static void settle(CompletableFuture<?> call) throws Exception {
        try {
            call.get(10, SECONDS);
        } catch (ExecutionException refused) {
            assertInstanceOf(XynologError.class, refused.getCause());
        }
    }

    /** The channel `call` asked on, once it has settled either way. */
    private String asked(CompletableFuture<?> call) throws Exception {
        settle(call);
        List<RequestLogEntry> log = transport.getRequestLog();
        assertFalse(log.isEmpty(), "nothing was asked");
        return log.get(log.size() - 1).getChannel();
    }

    /** What `call` read of the content, once it has settled either way. */
    private ContentCall read(CompletableFuture<?> call) throws Exception {
        settle(call);
        List<ContentCall> calls = content.getCalls();
        return calls.get(calls.size() - 1);
    }

    /** The gateway's operation `call` called, once it has settled either way. */
    private String called(CompletableFuture<?> call) throws Exception {
        settle(call);
        List<String> calls = gateway.getCalls();
        return calls.get(calls.size() - 1);
    }

    /** The frame `signal` says on the client's own bus. */
    private Frame said(String channel, Runnable signal) throws Exception {
        try (Events<Carried> frames = client.getBus().framesAmong(List.of(channel))) {
            CompletableFuture<Carried> said = first(frames.asPublisher());
            signal.run();
            return assertInstanceOf(Frame.class, said.get(10, SECONDS));
        }
    }

    /** Whether a frame on `channel` has gone over the wire, waiting up to ten seconds for it. */
    private boolean sent(String channel) throws InterruptedException {
        long until = System.currentTimeMillis() + 10_000;
        while (System.currentTimeMillis() < until) {
            if (transport.getEmitted().stream().anyMatch(frame -> frame.getChannel().equals(channel))) return true;
            Thread.sleep(10);
        }
        return false;
    }

    private GatheredContext gathered() throws Exception {
        transport.queueReply("gather:requested", List.of(json(CONTEXT)));
        return client.getGather().annotation(RESOURCE, ANNOTATION).awaitFuture().get(10, SECONDS).getResponse();
    }

    private static TextQuoteSelector quote() {
        return TextQuoteSelector.builder("hello").build();
    }

    @Test
    void frameAddsEntityTypesAndATagSchema() throws Exception {
        assertEquals("frame:add-entity-type", asked(client.getFrame().addEntityTypesFuture(List.of("Person", "Place"))));
        assertEquals("frame:add-tag-schema", asked(client.getFrame().addTagSchemaFuture(TagSchema.builder("s1", "A schema", "Its tags", "law", List.of()).build())));
    }

    @Test
    void browseAsksForEachLiveQuery() throws Exception {
        assertEquals("browse:resource-requested", asked(client.getBrowse().resource(RESOURCE).freshFuture()));
        assertEquals("browse:resources-requested", asked(client.getBrowse().resources().freshFuture()));
        assertEquals("browse:annotation-requested", asked(client.getBrowse().annotation(RESOURCE, ANNOTATION).freshFuture()));
        // The engines are asked for beside each holder's limits, in no order.
        asked(client.getBrowse().engines().freshFuture());
        assertTrue(transport.getRequestLog().stream().anyMatch(entry -> entry.getChannel().equals("browse:engines-requested")));
        assertEquals("browse:events-requested", asked(client.getBrowse().events(RESOURCE).freshFuture()));
    }

    @Test
    void browseAsksOnceForWhatIsReadOnce() throws Exception {
        assertEquals("browse:events-requested", asked(client.getBrowse().resourceEventsFuture(RESOURCE)));
        assertEquals("browse:annotation-history-requested", asked(client.getBrowse().annotationHistoryFuture(RESOURCE, ANNOTATION)));
        assertEquals("browse:directory-requested", asked(client.getBrowse().filesFuture("/", BrowseDirectoryRequestSort.Name)));
        assertEquals("browse:kb-requested", asked(client.getBrowse().kbFuture()));
    }

    @Test
    void browseReadsAResourceThroughTheContent() throws Exception {
        assertEquals(RESOURCE, assertInstanceOf(GetResourceGraph.class, read(client.getBrowse().resourceGraphFuture(RESOURCE))).getResourceId());
        assertEquals(RESOURCE, assertInstanceOf(GetAnchoredText.class, read(client.getBrowse().resourceAnchoredTextFuture(RESOURCE))).getResourceId());
        assertEquals(RESOURCE, assertInstanceOf(GetBinary.class, read(client.getBrowse().resourceRepresentationFuture(RESOURCE))).getResourceId());
        assertEquals(RESOURCE, assertInstanceOf(GetBinaryStream.class, read(client.getBrowse().resourceRepresentationStreamFuture(RESOURCE))).getResourceId());
    }

    @Test
    void browseSignalsThisViewerAndReportsWhatItViews() throws Exception {
        assertEquals("browse:click", said("browse:click", () -> client.getBrowse().click(ANNOTATION)).getChannel());
        assertEquals("browse:resource-open", said("browse:resource-open", () -> client.getBrowse().openResource(RESOURCE)).getChannel());
        client.getBrowse().resourceViewed(RESOURCE);
        assertTrue(sent("browse:resource-viewed"));
    }

    @Test
    void markAsksForEachChangeOfAnAnnotationOrAResource() throws Exception {
        CreateAnnotationRequest request = CreateAnnotationRequest.builder(Motivation.Highlighting, AnnotationTarget.builder(RESOURCE).build()).build();
        assertEquals("mark:create-request", asked(client.getMark().annotationFuture(request)));
        assertEquals("mark:delete", asked(client.getMark().deleteFuture(RESOURCE, ANNOTATION)));
        assertEquals("mark:archive", asked(client.getMark().archiveFuture(RESOURCE)));
        assertEquals("mark:unarchive", asked(client.getMark().unarchiveFuture(RESOURCE)));
        assertEquals("mark:update-entity-types", asked(client.getMark().updateEntityTypesFuture(RESOURCE, List.of("Person"), List.of())));
    }

    @Test
    void markSignalsThisViewer() throws Exception {
        assertEquals("mark:requested", said("mark:requested", () -> client.getMark().request(RESOURCE, quote(), Motivation.Highlighting)).getChannel());
        assertEquals("mark:submit", said("mark:submit", () -> client.getMark().submit(MarkSubmitEvent.builder(RESOURCE, Motivation.Highlighting, quote()).build())).getChannel());
        assertEquals("mark:delete-error", said("mark:delete-error", () -> client.getMark().reportDeleteError(ResourceErrorEvent.builder(RESOURCE, "it failed").build())).getChannel());
    }

    @Test
    void bindAsksForABodyAndSignalsThisViewer() throws Exception {
        assertEquals("bind:update-body", asked(client.getBind().bodyFuture(RESOURCE, ANNOTATION, List.of())));
        assertEquals("bind:initiate", said("bind:initiate", () -> client.getBind().initiate(BindInitiateCommand.builder(ANNOTATION, RESOURCE, "A title", List.of()).build())).getChannel());
        assertEquals("bind:body-error", said("bind:body-error", () -> client.getBind().reportBodyError(ResourceErrorEvent.builder(RESOURCE, "it failed").build())).getChannel());
    }

    @Test
    void gatherAsksForAResourcesContextAndWhatRefersToIt() throws Exception {
        assertEquals("gather:resource-requested", asked(client.getGather().resourceFuture(RESOURCE, GatherResourceOptions.builder().depth(1L).maxResources(1L).includeContent(false).includeSummary(false).build())));
        assertEquals("gather:referenced-by-requested", asked(client.getGather().referencedBy(RESOURCE).freshFuture()));
    }

    @Test
    void matchSearchesAndSignalsASearch() throws Exception {
        GatheredContext context = gathered();
        assertEquals("match:search-requested", asked(client.getMatch().search(RESOURCE, ANNOTATION, context).awaitFuture()));
        assertEquals("match:resources-requested", asked(client.getMatch().resources("paris").freshFuture()));
        Frame requested = said("match:search-requested", () -> client.getMatch().requestSearch(MatchSearchRequest.builder(RESOURCE, ANNOTATION, context).build(), "search-1"));
        assertEquals("search-1", requested.getCorrelationId());
    }

    @Test
    void systemAndAuthCallTheGatewaysOwnOperations() throws Exception {
        assertEquals("healthCheck", called(client.getSystem().healthCheckFuture()));
        assertEquals("getStatus", called(client.getSystem().statusFuture()));
        assertEquals("getCurrentUser", called(client.getAuth().meFuture()));
        assertEquals("getMediaToken res-1", called(client.getAuth().mediaTokenFuture(RESOURCE)));
        assertEquals("getProtectedResourceMetadata", called(client.getAuth().protectedResourceMetadataFuture()));
    }

    @Test
    void yieldAsksForACloneAndSignalsOne() throws Exception {
        assertEquals("yield:clone-token-requested", asked(client.getYield().cloneTokenFuture(RESOURCE)));
        assertEquals("yield:clone-resource-requested", asked(client.getYield().fromTokenFuture("tok-1")));
        assertEquals("yield:clone", said("yield:clone", () -> client.getYield().clone()).getChannel());
    }

    @Test
    void beckonDrivesTheOthersAndSparklesHere() throws Exception {
        client.getBeckon().attentionFuture(RESOURCE).get(10, SECONDS);
        assertTrue(sent("beckon:focus"));
        client.getBeckon().clickFuture(ANNOTATION).get(10, SECONDS);
        assertTrue(sent("browse:click"));
        client.getBeckon().openResourceFuture(RESOURCE).get(10, SECONDS);
        assertTrue(sent("browse:resource-open"));
        client.getBeckon().sparkleAllFuture(ANNOTATION).get(10, SECONDS);
        assertTrue(sent("beckon:sparkle"));
        assertEquals("beckon:sparkle", said("beckon:sparkle", () -> client.getBeckon().sparkle(ANNOTATION)).getChannel());
    }

    @Test
    void theWireSendsAChannelsPayload() throws Exception {
        client.getWire().emitFuture(Channels.BECKON_SPARKLE, BeckonSparkleEvent.builder(ANNOTATION).build(), null, null).get(10, SECONDS);
        assertTrue(sent("beckon:sparkle"));
    }

    @Test
    void jobAsksOfAJob() throws Exception {
        assertEquals("job:status-requested", asked(client.getJob().statusFuture(JOB)));
        List<Object> statuses = new ArrayList<>();
        assertEquals("job:status-requested", asked(client.getJob().pollUntilCompleteFuture(JOB)));
        assertEquals("job:status-requested", asked(client.getJob().pollUntilCompleteFuture(JOB, JobPollOptions.builder().everyMs(10L).withinMs(1_000L).build(), statuses::add)));
        // The first ask was refused, so no status was told.
        assertEquals(List.of(), statuses);
        assertEquals("job:cancel-requested", asked(client.getJob().cancelFuture(JOB)));
    }

    @Test
    void jobReadsWhatIsQueuedReportedAndFailed() throws Exception {
        try (Typed<JobQueuedEvent> queued = client.getJob().queued();
                Typed<JobReportProgressCommand> progress = client.getJob().progress();
                Typed<JobFailCommand> failed = client.getJob().fail()) {
            CompletableFuture<Heard<JobQueuedEvent>> announced = first(queued.asPublisher());
            CompletableFuture<Heard<JobReportProgressCommand>> reported = first(progress.asPublisher());
            CompletableFuture<Heard<JobFailCommand>> failure = first(failed.asPublisher());
            transport.deliver(new Frame("job:queued", json("{\"jobId\":\"job-1\",\"jobType\":\"mark\",\"resourceId\":\"res-1\",\"userId\":\"did:web:kb.example:users:u\","
                    + "\"params\":{\"motivation\":\"highlighting\"}}"), null, (ResourceId) null, null));
            transport.deliver(new Frame("job:report-progress", json("{\"resourceId\":\"res-1\",\"jobId\":\"job-1\",\"jobType\":\"mark\",\"percentage\":50}"), null, (ResourceId) null, null));
            transport.deliver(new Frame("job:fail", json("{\"resourceId\":\"res-1\",\"jobId\":\"job-1\",\"jobType\":\"mark\",\"error\":\"it broke\"}"), null, (ResourceId) null, null));
            assertEquals(JOB, assertInstanceOf(MarkJobQueuedEvent.class, delivered(announced.get(10, SECONDS)).getPayload()).getJobId());
            assertEquals(50.0, delivered(reported.get(10, SECONDS)).getPayload().getPercentage());
            assertEquals("it broke", delivered(failure.get(10, SECONDS)).getPayload().getError());
        }
    }
}
