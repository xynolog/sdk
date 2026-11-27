package xynolog.testing

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import xynolog.OptionDefaults
import xynolog.XynologClient
import xynolog.session.XynologSession
import xynolog.signin.MemorySignIn
import xynolog.signin.SignInKept
import xynolog.telemetry.futureOf
import xynolog.types.KbTarget
import java.util.concurrent.CompletableFuture
import kotlin.coroutines.CoroutineContext
import kotlin.random.Random

/**
 * What a test session is built over. What a test leaves out is made: a
 * `TestClient` of doubles that answer nothing,
 * `OptionDefaults.TESTING_CREATE_TEST_SESSION_KB`, a `MemorySignIn` that holds none, and the system's
 * random source. The session keeps its client's context and clock.
 */
public class TestSessionOptions @JvmOverloads constructor(
    /** The test client the session is over. */
    public val client: TestClient = TestClient(),
    /** The knowledge base the session is with. */
    public val kb: KbTarget = OptionDefaults.TESTING_CREATE_TEST_SESSION_KB,
    /** Where the session's sign-in is kept: a sign-in kept there is the session's at its start. */
    public val kept: SignInKept = MemorySignIn(),
    /** What the session's jitter is drawn from. */
    public val random: Random = Random.Default,
)

/** A session, and what it was built over. The token the session holds is the test's to set. */
public class TestSession internal constructor(
    public val session: XynologSession,
    public val client: XynologClient,
    public val transport: FaultyTransport,
    public val content: InMemoryContent,
    public val gateway: StubGateway,
    /** Where the session's sign-in is kept. */
    public val kept: SignInKept,
    private val tokens: MutableStateFlow<String?>,
) {
    /** Set the token the session holds, as a sign-in would: a test that needs a signed-in session sets one. */
    public fun setToken(token: String?) {
        tokens.value = token
    }
}

/**
 * A real `XynologSession` over a test client, started: it renews nothing and
 * asks nobody who it is, so it is ready as soon as it has read where its
 * sign-in is kept, and holds a token only if one was kept there. It only uses
 * its client: the caller ends the client and then the session, and whoever
 * made the transport closes it.
 */
public suspend fun createTestSession(options: TestSessionOptions): TestSession {
    val made = options.client
    val tokens = MutableStateFlow<String?>(null)
    val session = XynologSession(options.kb, made.client, tokens, options.kept, null, null, null, options.random)
    session.start()
    return TestSession(session, made.client, made.transport, made.content, made.gateway, options.kept, tokens)
}

/** `createTestSession`, for Java, on `context`. */
@JvmOverloads
public fun createTestSessionFuture(options: TestSessionOptions, context: CoroutineContext = Dispatchers.Default): CompletableFuture<TestSession> =
    CoroutineScope(context).futureOf { createTestSession(options) }
