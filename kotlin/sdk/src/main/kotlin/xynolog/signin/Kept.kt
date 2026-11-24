package xynolog.signin

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import xynolog.telemetry.futureOf
import xynolog.types.StoredSession
import java.util.concurrent.CompletableFuture

/**
 * Where one knowledge base's sign-in is kept. Each suspending member has its
 * twin for Java, which returns a future: run where the member runs it, a store
 * that keeps a context running it there.
 */
public interface SignInKept {
    /** The sign-in as it is kept now, when there is one. */
    public suspend fun held(): StoredSession?

    /** Keep a sign-in, in place of whatever was kept. */
    public suspend fun keep(signIn: StoredSession)

    /**
     * Keep the tokens a renewal of `read` issued, against what is kept now:
     * the access token kept then. When what is kept no longer holds `read`'s
     * tokens, it was renewed some other way meanwhile: that stands, and its
     * access token is the one given. Null when nothing is kept: a sign-in that
     * was signed out, or ended, while it was being renewed is gone, and is not
     * written back.
     */
    public suspend fun renewed(read: StoredSession, access: String, refresh: String): String?

    /** Keep the sign-in no more. */
    public suspend fun forget()

    /**
     * Record `personKey`, the key of the person a gateway said `access` is, on
     * the sign-in kept now, as one step: only when it still holds `access` and
     * names nobody yet. True when it then names that person, recorded now or
     * before; false when nothing is kept, what is kept holds another token, or
     * names another person, or where it is kept has no place for a person.
     * What a session's caches and stream places are kept under follows it.
     */
    public suspend fun recordPersonKey(access: String, personKey: String): Boolean

    /** `held`, for Java. */
    public fun heldFuture(): CompletableFuture<StoredSession?> = CoroutineScope(Dispatchers.Unconfined).futureOf { held() }

    /** `keep`, for Java. */
    public fun keepFuture(signIn: StoredSession): CompletableFuture<Unit> = CoroutineScope(Dispatchers.Unconfined).futureOf { keep(signIn) }

    /** `renewed`, for Java. */
    public fun renewedFuture(read: StoredSession, access: String, refresh: String): CompletableFuture<String?> =
        CoroutineScope(Dispatchers.Unconfined).futureOf { renewed(read, access, refresh) }

    /** `forget`, for Java. */
    public fun forgetFuture(): CompletableFuture<Unit> = CoroutineScope(Dispatchers.Unconfined).futureOf { forget() }

    /** `recordPersonKey`, for Java. */
    public fun recordPersonKeyFuture(access: String, personKey: String): CompletableFuture<Boolean> =
        CoroutineScope(Dispatchers.Unconfined).futureOf { recordPersonKey(access, personKey) }
}

/** A sign-in kept for as long as the process lives, and no longer. */
public class MemorySignIn(signIn: StoredSession? = null) : SignInKept {
    private var signIn: StoredSession? = signIn

    override suspend fun held(): StoredSession? = synchronized(this) { signIn }

    override suspend fun keep(signIn: StoredSession): Unit = synchronized(this) { this.signIn = signIn }

    override suspend fun renewed(read: StoredSession, access: String, refresh: String): String? = synchronized(this) {
        val kept = signIn ?: return null
        if (kept.access != read.access || kept.refresh != read.refresh) return kept.access
        signIn = kept.copy(access = access, refresh = refresh)
        access
    }

    override suspend fun forget(): Unit = synchronized(this) { signIn = null }

    override suspend fun recordPersonKey(access: String, personKey: String): Boolean = synchronized(this) {
        val kept = signIn ?: return false
        if (kept.access != access) return false
        if (kept.personKey == null) signIn = kept.copy(personKey = personKey)
        kept.personKey == null || kept.personKey == personKey
    }
}
