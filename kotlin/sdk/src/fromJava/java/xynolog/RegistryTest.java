package xynolog;

import static java.util.concurrent.TimeUnit.SECONDS;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Flow;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import org.junit.jupiter.api.Test;
import xynolog.discovery.DiscoveryKt;
import xynolog.discovery.DiscoveryTransport;
import xynolog.http.AuthorizationKt;
import xynolog.http.HttpSessionFactory;
import xynolog.identifiers.ResourceId;
import xynolog.registry.KeepingKt;
import xynolog.registry.OpenKt;
import xynolog.registry.StoredKeysKt;
import xynolog.registry.StoredKt;
import xynolog.registry.XynologBrowser;
import xynolog.registry.XynologBrowserConfig;
import xynolog.session.SessionSignals;
import xynolog.storage.MemoryStorage;
import xynolog.storage.SessionStorage;
import xynolog.testing.ScriptedSessions;
import xynolog.testing.SharedStorage;
import xynolog.types.DiscoveryAbsent;
import xynolog.types.DiscoveryAbsentReason;
import xynolog.types.DiscoveryManaged;
import xynolog.types.KbReadVerdictNoVerdict;
import xynolog.types.KbSessionStatus;
import xynolog.types.KnowledgeBase;
import xynolog.types.LocalEndpoint;
import xynolog.types.OpenResource;
import xynolog.types.SessionEndReason;
import xynolog.types.SessionEnded;
import xynolog.types.StoredSession;
import xynolog.types.TabCheckGone;
import xynolog.types.TabCheckReady;

/**
 * The registry of knowledge bases, discovery and a redirect sign-in as a Java
 * program calls them: a registry held and read, what may be nothing read as
 * an Optional, what closing it throws, what it keeps, what is open, the
 * session's signals, a launcher's document, and the challenge a sign-in sends.
 */
final class RegistryTest {
    /** The first thing `publisher` gives. */
    private static <T> CompletableFuture<T> first(Flow.Publisher<T> publisher) {
        CompletableFuture<T> given = new CompletableFuture<>();
        publisher.subscribe(new Flow.Subscriber<>() {
            private Flow.Subscription subscription;

            @Override
            public void onSubscribe(Flow.Subscription subscription) {
                this.subscription = subscription;
                subscription.request(1);
            }

            @Override
            public void onNext(T item) {
                given.complete(item);
                subscription.cancel();
            }

            @Override
            public void onError(Throwable failure) {
                given.completeExceptionally(failure);
            }

            @Override
            public void onComplete() {
                given.completeExceptionally(new AssertionError("ended with nothing given"));
            }
        });
        return given;
    }

    @Test
    void aRegistryIsHeldAndReadFromJava() throws Exception {
        try (XynologBrowser browser = new XynologBrowser(new XynologBrowserConfig(new MemoryStorage(), new HttpSessionFactory()))) {
            assertEquals(List.of(), browser.getKbs().getValue());
            assertNull(browser.getActiveKbId().getValue());
            // A value that may be nothing reaches Java as an Optional.
            assertEquals(Optional.empty(), first(browser.getActiveKbId().asPublisher()).get(10, SECONDS));
            browser.setIdentityToken("an-identity-token");
            assertEquals(Optional.of("an-identity-token"), first(browser.getIdentityToken().asPublisher()).get(10, SECONDS));
            assertEquals(KbSessionStatus.SignedOut, browser.kbSessionStatus("kb-a"));
            // Nothing is opened without a live session, and with none there is nothing to ask.
            browser.addOpenResource(new ResourceId("res-1"), "One");
            assertEquals(List.of(), browser.getOpenResources().getValue());
            assertInstanceOf(KbReadVerdictNoVerdict.class, browser.readActiveKbFuture().get(10, SECONDS));
        }
    }

    @Test
    void aWriteTheStorageRefusedInTheBackgroundIsThrownByClosingFromJava() throws Exception {
        SharedStorage beneath = new SharedStorage();
        KeepingKt.saveKnowledgeBases(beneath, List.of(KnowledgeBase.builder("kb-a", "KB A", LocalEndpoint.builder("kb-a").build(), "did:web:example.org:kb-a").build()));
        String open = "{\"kb-a\":[{\"id\":\"res-1\",\"name\":\"One\",\"openedAt\":1,\"order\":0}]}";
        beneath.set(StoredKeysKt.OPEN_RESOURCES_BY_KB_KEY, open);
        CompletableFuture<Void> refused = new CompletableFuture<>();
        // A storage written in Java that takes no update: it fails unchecked, as a Java store does.
        SessionStorage refusing = new SessionStorage() {
            @Override
            public String get(String key) {
                return beneath.get(key);
            }

            @Override
            public void set(String key, String value) {
                beneath.set(key, value);
            }

            @Override
            public void delete(String key) {
                beneath.delete(key);
            }

            @Override
            public void update(String key, Function1<? super String, String> change) {
                change.invoke(beneath.get(key));
                refused.complete(null);
                throw new UncheckedIOException(new IOException("the storage is full"));
            }

            @Override
            public AutoCloseable subscribe(Function2<? super String, ? super String, Unit> onChange) {
                return beneath.subscribe(onChange);
            }
        };

        // The session's arrival checks what is open and writes what it found: the storage refuses it, and closing throws it.
        UncheckedIOException thrown = assertThrows(UncheckedIOException.class, () -> {
            try (XynologBrowser browser = new XynologBrowser(new XynologBrowserConfig(refusing, new ScriptedSessions()))) {
                refused.get(10, SECONDS);
                // What is open is shown as it was.
                assertEquals(List.of("One"), browser.getOpenResources().getValue().stream().map(OpenResource::getName).toList());
            }
        });
        assertEquals("the storage is full", thrown.getCause().getMessage());
        assertEquals(open, beneath.get(StoredKeysKt.OPEN_RESOURCES_BY_KB_KEY));
    }

    @Test
    void whatARegistryKeepsIsWrittenAndReadFromJava() {
        MemoryStorage storage = new MemoryStorage();
        StoredSession session = new StoredSession("an-access-token", "a-refresh-token", "xynolog-browser", "https://issuer.test/token", null, null);
        KeepingKt.storeSession(storage, "kb-a", session);
        assertEquals(session, KeepingKt.storedSession(storage, "kb-a"));
        assertEquals("kb-a", StoredKt.kbOfSessionKey(StoredKt.sessionKey("kb-a")));
        KeepingKt.clearStoredSession(storage, "kb-a");
        assertNull(KeepingKt.storedSession(storage, "kb-a"));
    }

    @Test
    void whatIsOpenIsOrderedAndCheckedFromJava() {
        OpenResource later = OpenResource.builder(new ResourceId("later"), "Later", 20, 1).mediaType("text/plain").build();
        OpenResource first = OpenResource.builder(new ResourceId("first"), "First", 30, 0).build();
        List<OpenResource> ordered = OpenKt.sortOpenResources(List.of(later, first));
        assertEquals(List.of(first, later), ordered);
        List<OpenResource> kept = OpenKt.applyTabChecks(ordered, Map.of(
                new ResourceId("first"), TabCheckGone.builder().build(),
                new ResourceId("later"), TabCheckReady.builder("Its name now").build()));
        assertEquals(1, kept.size());
        assertEquals("Its name now", kept.get(0).getName());
        assertEquals("text/plain", kept.get(0).getMediaType());
    }

    @Test
    void theSessionsSignalsAreReadFromJava() throws Exception {
        try (SessionSignals signals = new SessionSignals()) {
            assertEquals(Optional.empty(), first(signals.getSessionEnded().asPublisher()).get(10, SECONDS));
            signals.notifySessionEnded(SessionEndReason.Expired);
            assertEquals(Optional.of(new SessionEnded(SessionEndReason.Expired)), first(signals.getSessionEnded().asPublisher()).get(10, SECONDS));
            signals.acknowledgeSessionEnded();
            assertNull(signals.getSessionEnded().getValue());
        }
    }

    @Test
    void aLaunchersDocumentIsReadFromJava() throws Exception {
        assertEquals(DiscoveryManaged.builder(List.of()).build(), DiscoveryKt.parseDiscoveryDocument("{\"version\":1,\"kbs\":[]}"));
        DiscoveryAbsent absent = assertInstanceOf(DiscoveryAbsent.class, DiscoveryKt.parseDiscoveryDocument("not json"));
        assertEquals(DiscoveryAbsentReason.NotJson, absent.getReason());
        assertEquals(DiscoveryAbsent.builder(DiscoveryAbsentReason.NotFound).build(), DiscoveryAbsent.builder(DiscoveryAbsentReason.NotFound).diagnostic(null).build());
        DiscoveryTransport text = DiscoveryKt.textDiscovery(() -> "{\"version\":1,\"kbs\":[]}");
        assertEquals(DiscoveryManaged.builder(List.of()).build(), text.readFuture().get(10, SECONDS));
    }

    @Test
    void aSignInsChallengeIsMadeFromJava() {
        assertEquals("E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM", AuthorizationKt.codeChallenge("dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk"));
    }
}
