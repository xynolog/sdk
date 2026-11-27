// Generated from protocol/specs/src/control/methods.json; do not edit.
// Regenerate: make generate (codegen/lib/rust_types/rust_types.ml)
/// `launcher.about`: What the launcher is: its version, the API versions it speaks, the runtimes it detects. It reads none of the machine's state.
pub struct LauncherAbout;
impl ControlMethod for LauncherAbout {
    const NAME: &'static str = "launcher.about";
    const EXCLUSIVE: bool = false;
    const SENDS: &'static [&'static str] = &[];
    type Params = crate::types::AboutParams;
    type Result = crate::types::AboutResult;
}

/// `roots.list`: Every knowledge base this machine knows: xynolog roots.
pub struct RootsList;
impl ControlMethod for RootsList {
    const NAME: &'static str = "roots.list";
    const EXCLUSIVE: bool = true;
    const SENDS: &'static [&'static str] = &[];
    type Params = crate::types::RootsListParams;
    type Result = crate::types::RootsListResult;
}

/// `roots.init`: Create and register a new local knowledge base: xynolog init.
pub struct RootsInit;
impl ControlMethod for RootsInit {
    const NAME: &'static str = "roots.init";
    const EXCLUSIVE: bool = true;
    const SENDS: &'static [&'static str] = &["notifications/progress"];
    type Params = crate::types::RootsInitParams;
    type Result = crate::types::RootsInitResult;
}

/// `roots.forget`: Remove one registry row, and no file: xynolog forget.
pub struct RootsForget;
impl ControlMethod for RootsForget {
    const NAME: &'static str = "roots.forget";
    const EXCLUSIVE: bool = true;
    const SENDS: &'static [&'static str] = &[];
    type Params = crate::types::RootsForgetParams;
    type Result = crate::types::RootsForgetResult;
}

/// `status.snapshot`: Each knowledge base's stack, and the services they share: xynolog status.
pub struct StatusSnapshot;
impl ControlMethod for StatusSnapshot {
    const NAME: &'static str = "status.snapshot";
    const EXCLUSIVE: bool = true;
    const SENDS: &'static [&'static str] = &[];
    type Params = crate::types::StatusSnapshotParams;
    type Result = crate::types::StatusSnapshotResult;
}

/// `stack.start`: Start a stack, or some of its services: xynolog start.
pub struct StackStart;
impl ControlMethod for StackStart {
    const NAME: &'static str = "stack.start";
    const EXCLUSIVE: bool = true;
    const SENDS: &'static [&'static str] = &[];
    type Params = crate::types::StackStartParams;
    type Result = crate::types::StackStartResult;
}

/// `stack.stop`: Stop a stack, or some of its services: xynolog stop.
pub struct StackStop;
impl ControlMethod for StackStop {
    const NAME: &'static str = "stack.stop";
    const EXCLUSIVE: bool = true;
    const SENDS: &'static [&'static str] = &[];
    type Params = crate::types::StackStopParams;
    type Result = crate::types::StackStopResult;
}

/// `auth.login`: Sign in at the issuer a stack's knowledge base trusts, by the device grant, and keep the session in the launcher's store: xynolog login. Exclusive while it finds the stack; the wait for the person is not.
pub struct AuthLogin;
impl ControlMethod for AuthLogin {
    const NAME: &'static str = "auth.login";
    const EXCLUSIVE: bool = true;
    const SENDS: &'static [&'static str] = &["notifications/userAction"];
    type Params = crate::types::AuthLoginParams;
    type Result = crate::types::AuthLoginResult;
}

/// `auth.logout`: End the launcher's session for a stack: xynolog logout.
pub struct AuthLogout;
impl ControlMethod for AuthLogout {
    const NAME: &'static str = "auth.logout";
    const EXCLUSIVE: bool = true;
    const SENDS: &'static [&'static str] = &[];
    type Params = crate::types::AuthLogoutParams;
    type Result = crate::types::AuthLogoutResult;
}

/// `identity.useradd`: Create an account in a local knowledge base's launcher-managed Keycloak realm: xynolog useradd. A supplied password is secret request data and is never narrated or persisted; a generated password is returned once in the result.
pub struct IdentityUseradd;
impl ControlMethod for IdentityUseradd {
    const NAME: &'static str = "identity.useradd";
    const EXCLUSIVE: bool = true;
    const SENDS: &'static [&'static str] = &[];
    type Params = crate::types::IdentityUseraddParams;
    type Result = crate::types::IdentityUseraddResult;
}

/// `identity.users.list`: List accounts in one local knowledge base's launcher-managed Keycloak realm. Passwords and tokens are never returned.
pub struct IdentityUsersList;
impl ControlMethod for IdentityUsersList {
    const NAME: &'static str = "identity.users.list";
    const EXCLUSIVE: bool = true;
    const SENDS: &'static [&'static str] = &[];
    type Params = crate::types::IdentityUsersListParams;
    type Result = crate::types::IdentityUsersListResult;
}

/// `logs.follow`: Follow a stack's service logs until the client cancels or every source ends: xynolog logs. Exclusive while it finds the containers; the follow is not.
pub struct LogsFollow;
impl ControlMethod for LogsFollow {
    const NAME: &'static str = "logs.follow";
    const EXCLUSIVE: bool = true;
    const SENDS: &'static [&'static str] = &["notifications/log"];
    type Params = crate::types::LogsFollowParams;
    type Result = crate::types::LogsFollowResult;
}

/// `settings.list`: Every setting the launcher keeps: xynolog settings.
pub struct SettingsList;
impl ControlMethod for SettingsList {
    const NAME: &'static str = "settings.list";
    const EXCLUSIVE: bool = true;
    const SENDS: &'static [&'static str] = &[];
    type Params = crate::types::SettingsListParams;
    type Result = crate::types::SettingsListResult;
}

/// `settings.get`: One setting: xynolog settings <name>.
pub struct SettingsGet;
impl ControlMethod for SettingsGet {
    const NAME: &'static str = "settings.get";
    const EXCLUSIVE: bool = true;
    const SENDS: &'static [&'static str] = &[];
    type Params = crate::types::SettingsGetParams;
    type Result = crate::types::Setting;
}

/// `settings.set`: Set a setting, checked as a start would check it: xynolog settings <name> <value>.
pub struct SettingsSet;
impl ControlMethod for SettingsSet {
    const NAME: &'static str = "settings.set";
    const EXCLUSIVE: bool = true;
    const SENDS: &'static [&'static str] = &[];
    type Params = crate::types::SettingsSetParams;
    type Result = crate::types::Setting;
}

/// `settings.unset`: Return a setting to its default: xynolog settings <name> --unset.
pub struct SettingsUnset;
impl ControlMethod for SettingsUnset {
    const NAME: &'static str = "settings.unset";
    const EXCLUSIVE: bool = true;
    const SENDS: &'static [&'static str] = &[];
    type Params = crate::types::SettingsUnsetParams;
    type Result = crate::types::Setting;
}

/// `settings.path`: Where a machine document is: xynolog settings <document> --path.
pub struct SettingsPath;
impl ControlMethod for SettingsPath {
    const NAME: &'static str = "settings.path";
    const EXCLUSIVE: bool = true;
    const SENDS: &'static [&'static str] = &[];
    type Params = crate::types::SettingsPathParams;
    type Result = crate::types::SettingsPathResult;
}

/// `service.host`: Where this machine and a run's instance meet under a runtime: the host address an instance's ports are published on and its dials of this machine go to. A caller asks it before it writes an instance's document.
pub struct ServiceHost;
impl ControlMethod for ServiceHost {
    const NAME: &'static str = "service.host";
    const EXCLUSIVE: bool = false;
    const SENDS: &'static [&'static str] = &[];
    type Params = crate::types::ServiceHostParams;
    type Result = crate::types::ServiceHostResult;
}

/// `service.run`: Run one instance of a knowledge base's own service once, from the image its stack documents name, unsupervised, on the caller's document, arguments, environment and mounts, and answer when it exits: xynolog run. Exclusive until its container runs; the wait for its exit is not.
pub struct ServiceRun;
impl ControlMethod for ServiceRun {
    const NAME: &'static str = "service.run";
    const EXCLUSIVE: bool = true;
    const SENDS: &'static [&'static str] = &[
        "notifications/serviceStarted",
        "notifications/serviceOutput",
    ];
    type Params = crate::types::ServiceRunParams;
    type Result = crate::types::ServiceRunResult;
}

/// `service.signal`: Send a run's instance SIGTERM, then SIGKILL if it outlives 15 seconds, or SIGKILL at once: xynolog signal.
pub struct ServiceSignal;
impl ControlMethod for ServiceSignal {
    const NAME: &'static str = "service.signal";
    const EXCLUSIVE: bool = false;
    const SENDS: &'static [&'static str] = &[];
    type Params = crate::types::ServiceSignalParams;
    type Result = crate::types::ServiceSignalResult;
}

/// `notifications/progress`: A line of what a request is doing.
pub struct NotificationsProgress;
impl ControlNotification for NotificationsProgress {
    const NAME: &'static str = "notifications/progress";
    const FROM: ControlSender = ControlSender::Launcher;
    type Params = crate::types::Progress;
}

/// `notifications/userAction`: A sign-in waits for a person to enter a code.
pub struct NotificationsUserAction;
impl ControlNotification for NotificationsUserAction {
    const NAME: &'static str = "notifications/userAction";
    const FROM: ControlSender = ControlSender::Launcher;
    type Params = crate::types::UserAction;
}

/// `notifications/log`: A line a followed service wrote.
pub struct NotificationsLog;
impl ControlNotification for NotificationsLog {
    const NAME: &'static str = "notifications/log";
    const FROM: ControlSender = ControlSender::Launcher;
    type Params = crate::types::LogRecord;
}

/// `notifications/serviceStarted`: A run's instance is running.
pub struct NotificationsServiceStarted;
impl ControlNotification for NotificationsServiceStarted {
    const NAME: &'static str = "notifications/serviceStarted";
    const FROM: ControlSender = ControlSender::Launcher;
    type Params = crate::types::ServiceStarted;
}

/// `notifications/serviceOutput`: A line a run's instance wrote.
pub struct NotificationsServiceOutput;
impl ControlNotification for NotificationsServiceOutput {
    const NAME: &'static str = "notifications/serviceOutput";
    const FROM: ControlSender = ControlSender::Launcher;
    type Params = crate::types::ServiceOutput;
}

/// `notifications/cancelled`: The client gives up on a request.
pub struct NotificationsCancelled;
impl ControlNotification for NotificationsCancelled {
    const NAME: &'static str = "notifications/cancelled";
    const FROM: ControlSender = ControlSender::Client;
    type Params = crate::types::Cancelled;
}

pub const CONTROL_METHODS: &[ControlMethodRow] = &[
    ControlMethodRow {
        name: "launcher.about",
        exclusive: false,
        sends: &[],
    },
    ControlMethodRow {
        name: "roots.list",
        exclusive: true,
        sends: &[],
    },
    ControlMethodRow {
        name: "roots.init",
        exclusive: true,
        sends: &["notifications/progress"],
    },
    ControlMethodRow {
        name: "roots.forget",
        exclusive: true,
        sends: &[],
    },
    ControlMethodRow {
        name: "status.snapshot",
        exclusive: true,
        sends: &[],
    },
    ControlMethodRow {
        name: "stack.start",
        exclusive: true,
        sends: &[],
    },
    ControlMethodRow {
        name: "stack.stop",
        exclusive: true,
        sends: &[],
    },
    ControlMethodRow {
        name: "auth.login",
        exclusive: true,
        sends: &["notifications/userAction"],
    },
    ControlMethodRow {
        name: "auth.logout",
        exclusive: true,
        sends: &[],
    },
    ControlMethodRow {
        name: "identity.useradd",
        exclusive: true,
        sends: &[],
    },
    ControlMethodRow {
        name: "identity.users.list",
        exclusive: true,
        sends: &[],
    },
    ControlMethodRow {
        name: "logs.follow",
        exclusive: true,
        sends: &["notifications/log"],
    },
    ControlMethodRow {
        name: "settings.list",
        exclusive: true,
        sends: &[],
    },
    ControlMethodRow {
        name: "settings.get",
        exclusive: true,
        sends: &[],
    },
    ControlMethodRow {
        name: "settings.set",
        exclusive: true,
        sends: &[],
    },
    ControlMethodRow {
        name: "settings.unset",
        exclusive: true,
        sends: &[],
    },
    ControlMethodRow {
        name: "settings.path",
        exclusive: true,
        sends: &[],
    },
    ControlMethodRow {
        name: "service.host",
        exclusive: false,
        sends: &[],
    },
    ControlMethodRow {
        name: "service.run",
        exclusive: true,
        sends: &[
            "notifications/serviceStarted",
            "notifications/serviceOutput",
        ],
    },
    ControlMethodRow {
        name: "service.signal",
        exclusive: false,
        sends: &[],
    },
];

pub const CONTROL_NOTIFICATIONS: &[ControlNotificationRow] = &[
    ControlNotificationRow {
        name: "notifications/progress",
        from: ControlSender::Launcher,
    },
    ControlNotificationRow {
        name: "notifications/userAction",
        from: ControlSender::Launcher,
    },
    ControlNotificationRow {
        name: "notifications/log",
        from: ControlSender::Launcher,
    },
    ControlNotificationRow {
        name: "notifications/serviceStarted",
        from: ControlSender::Launcher,
    },
    ControlNotificationRow {
        name: "notifications/serviceOutput",
        from: ControlSender::Launcher,
    },
    ControlNotificationRow {
        name: "notifications/cancelled",
        from: ControlSender::Client,
    },
];
