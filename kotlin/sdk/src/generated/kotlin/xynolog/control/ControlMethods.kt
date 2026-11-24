// Generated from protocol/specs/src/control/methods.json; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/control.ml)

package xynolog.control

import xynolog.Generated
import xynolog.types.AboutParams
import xynolog.types.AboutResult
import xynolog.types.AuthLoginParams
import xynolog.types.AuthLoginResult
import xynolog.types.AuthLogoutParams
import xynolog.types.AuthLogoutResult
import xynolog.types.Cancelled
import xynolog.types.IdentityUseraddParams
import xynolog.types.IdentityUseraddResult
import xynolog.types.IdentityUsersListParams
import xynolog.types.IdentityUsersListResult
import xynolog.types.LogRecord
import xynolog.types.LogsFollowParams
import xynolog.types.LogsFollowResult
import xynolog.types.Progress
import xynolog.types.RootsForgetParams
import xynolog.types.RootsForgetResult
import xynolog.types.RootsInitParams
import xynolog.types.RootsInitResult
import xynolog.types.RootsListParams
import xynolog.types.RootsListResult
import xynolog.types.ServiceHostParams
import xynolog.types.ServiceHostResult
import xynolog.types.ServiceOutput
import xynolog.types.ServiceRunParams
import xynolog.types.ServiceRunResult
import xynolog.types.ServiceSignalParams
import xynolog.types.ServiceSignalResult
import xynolog.types.ServiceStarted
import xynolog.types.Setting
import xynolog.types.SettingsGetParams
import xynolog.types.SettingsListParams
import xynolog.types.SettingsListResult
import xynolog.types.SettingsPathParams
import xynolog.types.SettingsPathResult
import xynolog.types.SettingsSetParams
import xynolog.types.SettingsUnsetParams
import xynolog.types.StackStartParams
import xynolog.types.StackStartResult
import xynolog.types.StackStopParams
import xynolog.types.StackStopResult
import xynolog.types.StatusSnapshotParams
import xynolog.types.StatusSnapshotResult
import xynolog.types.UserAction

/** Which side of the control API sends a notification. */
@Generated
public enum class ControlSender(
    /** The side as the table spells it. */
    public val value: String,
) {
    Client("client"),
    Launcher("launcher"),
}

/** The launcher's control API: each of its notifications, and each of its methods, with the serializers of what each carries. A request that fails carries a `ErrorData` as its error's data, and every request's params state its `ApiVersion`. */
@Generated
public object ControlMethods {
    /**
     * A line of what a request is doing.
     */
    @Generated
    @JvmField
    public val NOTIFICATIONS_PROGRESS: ControlNotification<Progress> =
        ControlNotification(
            "notifications/progress",
            ControlSender.Launcher,
            Progress.serializer(),
        )

    /**
     * A sign-in waits for a person to enter a code.
     */
    @Generated
    @JvmField
    public val NOTIFICATIONS_USERACTION: ControlNotification<UserAction> =
        ControlNotification(
            "notifications/userAction",
            ControlSender.Launcher,
            UserAction.serializer(),
        )

    /**
     * A line a followed service wrote.
     */
    @Generated
    @JvmField
    public val NOTIFICATIONS_LOG: ControlNotification<LogRecord> =
        ControlNotification(
            "notifications/log",
            ControlSender.Launcher,
            LogRecord.serializer(),
        )

    /**
     * A run's instance is running.
     */
    @Generated
    @JvmField
    public val NOTIFICATIONS_SERVICESTARTED: ControlNotification<ServiceStarted> =
        ControlNotification(
            "notifications/serviceStarted",
            ControlSender.Launcher,
            ServiceStarted.serializer(),
        )

    /**
     * A line a run's instance wrote.
     */
    @Generated
    @JvmField
    public val NOTIFICATIONS_SERVICEOUTPUT: ControlNotification<ServiceOutput> =
        ControlNotification(
            "notifications/serviceOutput",
            ControlSender.Launcher,
            ServiceOutput.serializer(),
        )

    /**
     * The client gives up on a request.
     */
    @Generated
    @JvmField
    public val NOTIFICATIONS_CANCELLED: ControlNotification<Cancelled> =
        ControlNotification(
            "notifications/cancelled",
            ControlSender.Client,
            Cancelled.serializer(),
        )

    /**
     * What the launcher is: its version, the API versions it speaks, the runtimes it detects. It reads none of the machine's state.
     */
    @Generated
    @JvmField
    public val LAUNCHER_ABOUT: ControlMethod<AboutParams, AboutResult> =
        ControlMethod(
            name = "launcher.about",
            params = AboutParams.serializer(),
            result = AboutResult.serializer(),
            exclusive = false,
            sends = emptyList(),
        )

    /**
     * Every knowledge base this machine knows: xynolog roots.
     */
    @Generated
    @JvmField
    public val ROOTS_LIST: ControlMethod<RootsListParams, RootsListResult> =
        ControlMethod(
            name = "roots.list",
            params = RootsListParams.serializer(),
            result = RootsListResult.serializer(),
            exclusive = true,
            sends = emptyList(),
        )

    /**
     * Create and register a new local knowledge base: xynolog init.
     */
    @Generated
    @JvmField
    public val ROOTS_INIT: ControlMethod<RootsInitParams, RootsInitResult> =
        ControlMethod(
            name = "roots.init",
            params = RootsInitParams.serializer(),
            result = RootsInitResult.serializer(),
            exclusive = true,
            sends = listOf(NOTIFICATIONS_PROGRESS),
        )

    /**
     * Remove one registry row, and no file: xynolog forget.
     */
    @Generated
    @JvmField
    public val ROOTS_FORGET: ControlMethod<RootsForgetParams, RootsForgetResult> =
        ControlMethod(
            name = "roots.forget",
            params = RootsForgetParams.serializer(),
            result = RootsForgetResult.serializer(),
            exclusive = true,
            sends = emptyList(),
        )

    /**
     * Each knowledge base's stack, and the services they share: xynolog status.
     */
    @Generated
    @JvmField
    public val STATUS_SNAPSHOT: ControlMethod<StatusSnapshotParams, StatusSnapshotResult> =
        ControlMethod(
            name = "status.snapshot",
            params = StatusSnapshotParams.serializer(),
            result = StatusSnapshotResult.serializer(),
            exclusive = true,
            sends = emptyList(),
        )

    /**
     * Start a stack, or some of its services: xynolog start.
     */
    @Generated
    @JvmField
    public val STACK_START: ControlMethod<StackStartParams, StackStartResult> =
        ControlMethod(
            name = "stack.start",
            params = StackStartParams.serializer(),
            result = StackStartResult.serializer(),
            exclusive = true,
            sends = emptyList(),
        )

    /**
     * Stop a stack, or some of its services: xynolog stop.
     */
    @Generated
    @JvmField
    public val STACK_STOP: ControlMethod<StackStopParams, StackStopResult> =
        ControlMethod(
            name = "stack.stop",
            params = StackStopParams.serializer(),
            result = StackStopResult.serializer(),
            exclusive = true,
            sends = emptyList(),
        )

    /**
     * Sign in at the issuer a stack's knowledge base trusts, by the device grant, and keep the session in the launcher's store: xynolog login. Exclusive while it finds the stack; the wait for the person is not.
     */
    @Generated
    @JvmField
    public val AUTH_LOGIN: ControlMethod<AuthLoginParams, AuthLoginResult> =
        ControlMethod(
            name = "auth.login",
            params = AuthLoginParams.serializer(),
            result = AuthLoginResult.serializer(),
            exclusive = true,
            sends = listOf(NOTIFICATIONS_USERACTION),
        )

    /**
     * End the launcher's session for a stack: xynolog logout.
     */
    @Generated
    @JvmField
    public val AUTH_LOGOUT: ControlMethod<AuthLogoutParams, AuthLogoutResult> =
        ControlMethod(
            name = "auth.logout",
            params = AuthLogoutParams.serializer(),
            result = AuthLogoutResult.serializer(),
            exclusive = true,
            sends = emptyList(),
        )

    /**
     * Create an account in a local knowledge base's launcher-managed Keycloak realm: xynolog useradd. A supplied password is secret request data and is never narrated or persisted; a generated password is returned once in the result.
     */
    @Generated
    @JvmField
    public val IDENTITY_USERADD: ControlMethod<IdentityUseraddParams, IdentityUseraddResult> =
        ControlMethod(
            name = "identity.useradd",
            params = IdentityUseraddParams.serializer(),
            result = IdentityUseraddResult.serializer(),
            exclusive = true,
            sends = emptyList(),
        )

    /**
     * List accounts in one local knowledge base's launcher-managed Keycloak realm. Passwords and tokens are never returned.
     */
    @Generated
    @JvmField
    public val IDENTITY_USERS_LIST: ControlMethod<IdentityUsersListParams, IdentityUsersListResult> =
        ControlMethod(
            name = "identity.users.list",
            params = IdentityUsersListParams.serializer(),
            result = IdentityUsersListResult.serializer(),
            exclusive = true,
            sends = emptyList(),
        )

    /**
     * Follow a stack's service logs until the client cancels or every source ends: xynolog logs. Exclusive while it finds the containers; the follow is not.
     */
    @Generated
    @JvmField
    public val LOGS_FOLLOW: ControlMethod<LogsFollowParams, LogsFollowResult> =
        ControlMethod(
            name = "logs.follow",
            params = LogsFollowParams.serializer(),
            result = LogsFollowResult.serializer(),
            exclusive = true,
            sends = listOf(NOTIFICATIONS_LOG),
        )

    /**
     * Every setting the launcher keeps: xynolog settings.
     */
    @Generated
    @JvmField
    public val SETTINGS_LIST: ControlMethod<SettingsListParams, SettingsListResult> =
        ControlMethod(
            name = "settings.list",
            params = SettingsListParams.serializer(),
            result = SettingsListResult.serializer(),
            exclusive = true,
            sends = emptyList(),
        )

    /**
     * One setting: xynolog settings <name>.
     */
    @Generated
    @JvmField
    public val SETTINGS_GET: ControlMethod<SettingsGetParams, Setting> =
        ControlMethod(
            name = "settings.get",
            params = SettingsGetParams.serializer(),
            result = Setting.serializer(),
            exclusive = true,
            sends = emptyList(),
        )

    /**
     * Set a setting, checked as a start would check it: xynolog settings <name> <value>.
     */
    @Generated
    @JvmField
    public val SETTINGS_SET: ControlMethod<SettingsSetParams, Setting> =
        ControlMethod(
            name = "settings.set",
            params = SettingsSetParams.serializer(),
            result = Setting.serializer(),
            exclusive = true,
            sends = emptyList(),
        )

    /**
     * Return a setting to its default: xynolog settings <name> --unset.
     */
    @Generated
    @JvmField
    public val SETTINGS_UNSET: ControlMethod<SettingsUnsetParams, Setting> =
        ControlMethod(
            name = "settings.unset",
            params = SettingsUnsetParams.serializer(),
            result = Setting.serializer(),
            exclusive = true,
            sends = emptyList(),
        )

    /**
     * Where a machine document is: xynolog settings <document> --path.
     */
    @Generated
    @JvmField
    public val SETTINGS_PATH: ControlMethod<SettingsPathParams, SettingsPathResult> =
        ControlMethod(
            name = "settings.path",
            params = SettingsPathParams.serializer(),
            result = SettingsPathResult.serializer(),
            exclusive = true,
            sends = emptyList(),
        )

    /**
     * Where this machine and a run's instance meet under a runtime: the host address an instance's ports are published on and its dials of this machine go to. A caller asks it before it writes an instance's document.
     */
    @Generated
    @JvmField
    public val SERVICE_HOST: ControlMethod<ServiceHostParams, ServiceHostResult> =
        ControlMethod(
            name = "service.host",
            params = ServiceHostParams.serializer(),
            result = ServiceHostResult.serializer(),
            exclusive = false,
            sends = emptyList(),
        )

    /**
     * Run one instance of a knowledge base's own service once, from the image its stack documents name, unsupervised, on the caller's document, arguments, environment and mounts, and answer when it exits: xynolog run. Exclusive until its container runs; the wait for its exit is not.
     */
    @Generated
    @JvmField
    public val SERVICE_RUN: ControlMethod<ServiceRunParams, ServiceRunResult> =
        ControlMethod(
            name = "service.run",
            params = ServiceRunParams.serializer(),
            result = ServiceRunResult.serializer(),
            exclusive = true,
            sends = listOf(NOTIFICATIONS_SERVICESTARTED, NOTIFICATIONS_SERVICEOUTPUT),
        )

    /**
     * Send a run's instance SIGTERM, then SIGKILL if it outlives 15 seconds, or SIGKILL at once: xynolog signal.
     */
    @Generated
    @JvmField
    public val SERVICE_SIGNAL: ControlMethod<ServiceSignalParams, ServiceSignalResult> =
        ControlMethod(
            name = "service.signal",
            params = ServiceSignalParams.serializer(),
            result = ServiceSignalResult.serializer(),
            exclusive = false,
            sends = emptyList(),
        )

    /**
     * Every notification, by its name: for code that is given a name and not a constant.
     */
    @Generated
    @JvmField
    public val NOTIFICATIONS: Map<String, ControlNotification<*>> =
        mapOf(
            "notifications/progress" to NOTIFICATIONS_PROGRESS,
            "notifications/userAction" to NOTIFICATIONS_USERACTION,
            "notifications/log" to NOTIFICATIONS_LOG,
            "notifications/serviceStarted" to NOTIFICATIONS_SERVICESTARTED,
            "notifications/serviceOutput" to NOTIFICATIONS_SERVICEOUTPUT,
            "notifications/cancelled" to NOTIFICATIONS_CANCELLED,
        )

    /**
     * Every method, by its name: for code that is given a name and not a constant.
     */
    @Generated
    @JvmField
    public val METHODS: Map<String, ControlMethod<*, *>> =
        mapOf(
            "launcher.about" to LAUNCHER_ABOUT,
            "roots.list" to ROOTS_LIST,
            "roots.init" to ROOTS_INIT,
            "roots.forget" to ROOTS_FORGET,
            "status.snapshot" to STATUS_SNAPSHOT,
            "stack.start" to STACK_START,
            "stack.stop" to STACK_STOP,
            "auth.login" to AUTH_LOGIN,
            "auth.logout" to AUTH_LOGOUT,
            "identity.useradd" to IDENTITY_USERADD,
            "identity.users.list" to IDENTITY_USERS_LIST,
            "logs.follow" to LOGS_FOLLOW,
            "settings.list" to SETTINGS_LIST,
            "settings.get" to SETTINGS_GET,
            "settings.set" to SETTINGS_SET,
            "settings.unset" to SETTINGS_UNSET,
            "settings.path" to SETTINGS_PATH,
            "service.host" to SERVICE_HOST,
            "service.run" to SERVICE_RUN,
            "service.signal" to SERVICE_SIGNAL,
        )
}
