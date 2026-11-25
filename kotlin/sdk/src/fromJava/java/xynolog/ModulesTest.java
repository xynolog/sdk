package xynolog;

import static java.nio.charset.StandardCharsets.UTF_8;
import static java.util.concurrent.TimeUnit.SECONDS;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.Base64;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Flow;
import java.util.concurrent.atomic.AtomicInteger;
import kotlin.jvm.internal.StringCompanionObject;
import kotlinx.serialization.builtins.BuiltinSerializersKt;
import org.junit.jupiter.api.Test;
import xynolog.annotations.AnnotationsKt;
import xynolog.bus.BusKt;
import xynolog.discovery.DiscoveryDiff;
import xynolog.discovery.DiscoveryKt;
import xynolog.discovery.DiscoveryRead;
import xynolog.discovery.Unchanged;
import xynolog.errors.BusRequestError;
import xynolog.errors.IdentityUnverifiableError;
import xynolog.errors.IdentityUnverifiableReason;
import xynolog.http.AuthorizationKt;
import xynolog.http.ConnectKt;
import xynolog.http.EndpointKt;
import xynolog.http.HttpSessionFactory;
import xynolog.http.SessionsKt;
import xynolog.identifiers.ResourceId;
import xynolog.identifiers.UserId;
import xynolog.registry.KeepingKt;
import xynolog.registry.SessionFactoryOptions;
import xynolog.registry.StoredKeysKt;
import xynolog.registry.XynologBrowser;
import xynolog.registry.XynologBrowserConfig;
import xynolog.retry.RetryKt;
import xynolog.session.SessionSignals;
import xynolog.session.TokensKt;
import xynolog.storage.MemoryStorage;
import xynolog.storage.StoragePersister;
import xynolog.transport.Events;
import xynolog.transport.TransportKt;
import xynolog.types.AgentSoftware;
import xynolog.types.AnchorMethod;
import xynolog.types.Annotation;
import xynolog.types.AnnotationSelector;
import xynolog.types.BeginAuthorizationOptions;
import xynolog.types.ConnectionIdentity;
import xynolog.types.Expected;
import xynolog.types.HttpEndpoint;
import xynolog.types.HttpEndpointProtocol;
import xynolog.types.KbDescription;
import xynolog.types.KnowledgeBase;
import xynolog.types.LocalEndpoint;
import xynolog.types.MatchQuality;
import xynolog.types.Motivation;
import xynolog.types.PendingAuthorization;
import xynolog.types.PendingAuthorizationIssuer;
import xynolog.types.QuotedText;
import xynolog.types.ReconciledSpan;
import xynolog.types.ReconciledSpanFuzzyMatch;
import xynolog.types.RetryBudget;
import xynolog.types.SignInOutcome;
import xynolog.types.SignedIn;
import xynolog.types.StoredSession;

/**
 * The modules a Java program reaches past the client: an annotation's
 * readers, the bus's vocabulary, discovery, a host's name, a redirect
 * sign-in, the registry's keeping, retrying, a cache's persistence and a
 * token's claims.
 */
final class ModulesTest {
    private static final ResourceId RESOURCE = new ResourceId("res-1");
    /** A gateway's endpoint, as a sign-in names it. */
    private static HttpEndpoint endpointOf(Gateway gateway) {
        return HttpEndpoint.builder("127.0.0.1", gateway.port(), HttpEndpointProtocol.Http).build();
    }

    /** Wait for `future` to fail, and give what it failed with. */
    private static Throwable failure(CompletableFuture<?> future) {
        return assertThrows(ExecutionException.class, () -> future.get(10, SECONDS)).getCause();
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

    @Test
    void anAnnotationIsReadFromJava() {
        String text = "Ada Lovelace wrote the first algorithm.";
        ReconciledSpan found = AnnotationsKt.reconcile(text, QuotedText.builder("Lovelace").build());
        assertNotNull(found);
        Annotation highlight = AnnotationsKt.annotationOfSpan(text, AnnotationsKt.toTextSpan(found), RESOURCE, Motivation.Highlighting, AgentSoftware.builder().name("gemma3").build());
        assertTrue(AnnotationsKt.isHighlight(highlight));
        assertFalse(AnnotationsKt.isReference(highlight));
        assertFalse(AnnotationsKt.isAssessment(highlight));
        assertFalse(AnnotationsKt.isComment(highlight));
        assertFalse(AnnotationsKt.isTag(highlight));
        assertFalse(AnnotationsKt.isStubReference(highlight));
        assertFalse(AnnotationsKt.isResolvedReference(highlight));
        assertNull(AnnotationsKt.commentText(highlight));
        assertEquals(List.of(), AnnotationsKt.entityTypes(highlight));
        assertNull(AnnotationsKt.tagCategory(highlight));
        assertNull(AnnotationsKt.tagSchemaId(highlight));
        assertFalse(AnnotationsKt.isBodyResolved(highlight.getBody()));
        // A reader that gives an id gives Java its text: Kotlin exposes no typed form of an id a function only returns.
        assertNull(AnnotationsKt.bodySource(highlight.getBody()));
        assertEquals("res-1", AnnotationsKt.targetSource(highlight.getTarget()));
        AnnotationSelector selector = AnnotationsKt.targetSelector(highlight.getTarget());
        assertEquals("Lovelace", AnnotationsKt.textQuoteSelector(selector).getExact());
        assertEquals("Lovelace", AnnotationsKt.exactText(selector));

        Annotation tag = AnnotationsKt.annotationOfResource(RESOURCE, Motivation.Tagging);
        assertTrue(AnnotationsKt.isTag(tag));
        assertEquals("res-1", AnnotationsKt.targetSource(tag.getTarget()));
        ReconciledSpanFuzzyMatch fuzzy = ReconciledSpanFuzzyMatch.builder(0, 3, "Ada", MatchQuality.Fuzzy).build();
        assertEquals(AnchorMethod.FuzzyMatch.getValue(), fuzzy.getAnchorMethod().getValue());
        assertEquals(MatchQuality.Fuzzy, fuzzy.getMatchQuality());
    }

    @Test
    void theBussVocabularyIsReadFromJava() {
        BusRequestError refused = TransportKt.unsubscribed("job:queued");
        assertEquals("bus.unsubscribed", refused.getCode());
        assertTrue(BusKt.getPERSISTED_EVENT_TYPES().contains("mark:added"));
    }

    @Test
    void aLaunchersDocumentIsWatchedFromJava() throws Exception {
        assertTrue(DiscoveryKt.DISCOVERY_INTERVAL > 0);
        assertNotNull(xynolog.http.DiscoveryKt.httpDiscovery("http://127.0.0.1:9"));
        assertInstanceOf(DiscoveryRead.class, Unchanged.INSTANCE);
        try (Events<DiscoveryDiff> diffs = DiscoveryKt.subscribeDiscovery(DiscoveryKt.textDiscovery(() -> "{\"version\":1,\"kbs\":[]}"), 10)) {
            DiscoveryDiff first = first(diffs.asPublisher()).get(10, SECONDS);
            assertEquals(List.of(), first.getAdded());
        }
    }

    @Test
    void aHostsNameIsCheckedFromJava() {
        assertTrue(EndpointKt.isValidHostname("kb.example"));
        assertFalse(EndpointKt.isValidHostname("not a host"));
    }

    @Test
    void aRedirectSignInIsBegunAndCompletedFromJava() throws Exception {
        MemoryStorage storage = new MemoryStorage();
        try (Gateway gateway = new Gateway()) {
            HttpEndpoint target = endpointOf(gateway);
            // The knowledge base names no issuer, so the sign-in cannot begin.
            assertNotNull(failure(AuthorizationKt.beginAuthorizationFuture(BeginAuthorizationOptions.builder(target, "kb-a").build(), storage)));
            assertNull(storage.get(StoredKeysKt.PENDING_AUTHORIZATION_KEY));
            // Nothing was begun, so there is nothing to complete.
            assertNotNull(failure(AuthorizationKt.completeAuthorizationFuture("http://app.example/callback?code=c&state=s", storage)));
            // The knowledge base says what it is, and its did is made from the domain it states.
            gateway.answer = body -> body.contains("\"channel\":\"browse:kb-requested\"")
                    ? "{\"channel\":\"browse:kb-result\",\"payload\":{\"response\":{\"name\":\"A KB\",\"domain\":\"kb.example\"}},\"correlationId\":\"" + Gateway.correlationOf(body) + "\"}"
                    : null;
            ConnectionIdentity described = ConnectKt.describeConnectionFuture(target, "a-token").get(10, SECONDS);
            assertEquals(new UserId("did:web:kb.example"), described.getDid());
            assertEquals("A KB", described.getDescription().getName());
        }

        PendingAuthorizationIssuer issuer = PendingAuthorizationIssuer.builder("https://issuer.example", "https://issuer.example/auth", "https://issuer.example/token").build();
        PendingAuthorization pending = PendingAuthorization.builder("a-state", "a-verifier", "http://app.example/callback",
                HttpEndpoint.builder("kb.example", 443, HttpEndpointProtocol.Https).build(), issuer).kbId("kb-a").build();
        assertEquals("kb-a", pending.getKbId());
        assertEquals("unreachable", new IdentityUnverifiableError(IdentityUnverifiableReason.Unreachable, "nothing answered").getReason().getCode());
    }

    @Test
    void whatTheRegistryKeepsIsReadAndWrittenFromJava() throws Exception {
        MemoryStorage storage = new MemoryStorage();
        KnowledgeBase kb = KnowledgeBase.builder("kb-a", "A KB", LocalEndpoint.builder("kb-a").build(), "did:web:kb.example").build();
        KeepingKt.saveKnowledgeBases(storage, List.of(kb));
        assertEquals(List.of(kb), KeepingKt.loadKnowledgeBases(storage));
        assertNotNull(storage.get(StoredKeysKt.KNOWLEDGE_BASES_KEY));
        assertNull(storage.get(StoredKeysKt.ACTIVE_KEY));
        assertNull(storage.get(StoredKeysKt.OPEN_RESOURCES_BY_KB_KEY));
        assertNull(storage.get(StoredKeysKt.LAST_VIEWED_RESOURCE_BY_KB_KEY));
        assertNotNull(KeepingKt.keptIn(storage, "kb-a"));

        StoredSession session = new StoredSession("an-access-token", "a-refresh-token", "xynolog-browser", "https://issuer.example/token", null, null);
        SignedIn signedIn = SignedIn.builder(kb.getEndpoint(), KbDescription.builder("A KB", "kb.example").build(), session).build();
        assertEquals(session, signedIn.getSession());
        SignInOutcome outcome = new SignInOutcome(kb, new Expected("did:web:kb.example", "A KB"));
        assertEquals("A KB", outcome.getExpected().getName());
        try (SessionSignals signals = new SessionSignals()) {
            SessionFactoryOptions made = new SessionFactoryOptions(kb, storage, signals);
            assertEquals(kb, made.getKb());
            assertEquals(storage, made.getStorage());
            assertEquals(signals, made.getSignals());
        }

        try (Gateway gateway = new Gateway(); XynologBrowser browser = new XynologBrowser(new XynologBrowserConfig(storage, new HttpSessionFactory()))) {
            assertNotNull(failure(SessionsKt.beginSignInFuture(browser, BeginAuthorizationOptions.builder(endpointOf(gateway), "kb-a").build())));
            assertNotNull(failure(SessionsKt.completeSignInFuture(browser, "http://app.example/callback?code=c&state=s")));
        }
    }

    @Test
    void aRetryIsRunFromJava() throws Exception {
        AtomicInteger attempts = new AtomicInteger();
        // What is retried is a failure the SDK names: here, a stream that cannot deliver a channel.
        String done = RetryKt.retryWithBackoffFuture(new RetryBudget(3, 1, 2), failed -> failed instanceof BusRequestError, () -> attempts.incrementAndGet() == 1
                ? CompletableFuture.<String>failedFuture(TransportKt.unsubscribed("job:queued"))
                : CompletableFuture.completedFuture("done")).get(10, SECONDS);
        assertEquals("done", done);
        assertEquals(2, attempts.get());
    }

    @Test
    void aCachesValuesAreKeptFromJava() {
        MemoryStorage storage = new MemoryStorage();
        StoragePersister<String, String> persister = new StoragePersister<>(storage, "a-cache",
                BuiltinSerializersKt.serializer(StringCompanionObject.INSTANCE), BuiltinSerializersKt.serializer(StringCompanionObject.INSTANCE), 1, 1_000_000);
        persister.save(Map.of("res-1", "its value"));
        assertEquals(Map.of("res-1", "its value"), persister.load());
    }

    @Test
    void aTokensClaimsAreReadFromJava() {
        Base64.Encoder encoder = Base64.getUrlEncoder().withoutPadding();
        String token = encoder.encodeToString("{\"alg\":\"none\"}".getBytes(UTF_8)) + "."
                + encoder.encodeToString("{\"sub\":\"u-1\",\"iat\":1000,\"exp\":2000}".getBytes(UTF_8)) + ".";
        assertEquals("u-1", TokensKt.textClaim(token, "sub"));
        assertEquals(2000.0, TokensKt.tokenExpiry(token));
        assertTrue(TokensKt.isTokenExpired(token, 2500));
        assertFalse(TokensKt.isTokenExpired(token, 1500));
        assertTrue(TokensKt.renewalDelay(1000, 1000) > 0);
        assertNotNull(TokensKt.refreshDelay(token, 1500));
    }
}
