// Code generated from protocol/specs/src/control/methods.json and the schemas it names — DO NOT EDIT.
//
// Regenerate: make generate (codegen/lib/go_types/control.ml)

package control

import "github.com/xynolog/sdk/go/api"

// Sender is who sends a notification.
type Sender string

const (
	SenderClient   Sender = "client"
	SenderLauncher Sender = "launcher"
)

var (
	// LauncherAbout: What the launcher is: its version, the API versions it
	// speaks, the runtimes it detects. It reads none of the machine's state.
	LauncherAbout = Method[api.AboutParams, api.AboutResult]{Name: "launcher.about", Exclusive: false, Sends: []string{}}

	// RootsList: Every knowledge base this machine knows: xynolog roots.
	RootsList = Method[api.RootsListParams, api.RootsListResult]{Name: "roots.list", Exclusive: true, Sends: []string{}}

	// RootsInit: Create and register a new local knowledge base: xynolog init.
	RootsInit = Method[api.RootsInitParams, api.RootsInitResult]{Name: "roots.init", Exclusive: true, Sends: []string{"notifications/progress"}}

	// RootsForget: Remove one registry row, and no file: xynolog forget.
	RootsForget = Method[api.RootsForgetParams, api.RootsForgetResult]{Name: "roots.forget", Exclusive: true, Sends: []string{}}

	// StatusSnapshot: Each knowledge base's stack, and the services they share:
	// xynolog status.
	StatusSnapshot = Method[api.StatusSnapshotParams, api.StatusSnapshotResult]{Name: "status.snapshot", Exclusive: true, Sends: []string{}}

	// StackStart: Start a stack, or some of its services: xynolog start.
	StackStart = Method[api.StackStartParams, api.StackStartResult]{Name: "stack.start", Exclusive: true, Sends: []string{}}

	// StackStop: Stop a stack, or some of its services: xynolog stop.
	StackStop = Method[api.StackStopParams, api.StackStopResult]{Name: "stack.stop", Exclusive: true, Sends: []string{}}

	// AuthLogin: Sign in at the issuer a stack's knowledge base trusts, by the
	// device grant, and keep the session in the launcher's store: xynolog login.
	// Exclusive while it finds the stack; the wait for the person is not.
	AuthLogin = Method[api.AuthLoginParams, api.AuthLoginResult]{Name: "auth.login", Exclusive: true, Sends: []string{"notifications/userAction"}}

	// AuthLogout: End the launcher's session for a stack: xynolog logout.
	AuthLogout = Method[api.AuthLogoutParams, api.AuthLogoutResult]{Name: "auth.logout", Exclusive: true, Sends: []string{}}

	// IdentityUseradd: Create an account in a local knowledge base's
	// launcher-managed Keycloak realm: xynolog useradd. A supplied password is
	// secret request data and is never narrated or persisted; a generated
	// password is returned once in the result.
	IdentityUseradd = Method[api.IdentityUseraddParams, api.IdentityUseraddResult]{Name: "identity.useradd", Exclusive: true, Sends: []string{}}

	// IdentityUsersList: List accounts in one local knowledge base's
	// launcher-managed Keycloak realm. Passwords and tokens are never returned.
	IdentityUsersList = Method[api.IdentityUsersListParams, api.IdentityUsersListResult]{Name: "identity.users.list", Exclusive: true, Sends: []string{}}

	// LogsFollow: Follow a stack's service logs until the client cancels or
	// every source ends: xynolog logs. Exclusive while it finds the containers;
	// the follow is not.
	LogsFollow = Method[api.LogsFollowParams, api.LogsFollowResult]{Name: "logs.follow", Exclusive: true, Sends: []string{"notifications/log"}}

	// SettingsList: Every setting the launcher keeps: xynolog settings.
	SettingsList = Method[api.SettingsListParams, api.SettingsListResult]{Name: "settings.list", Exclusive: true, Sends: []string{}}

	// SettingsGet: One setting: xynolog settings <name>.
	SettingsGet = Method[api.SettingsGetParams, api.Setting]{Name: "settings.get", Exclusive: true, Sends: []string{}}

	// SettingsSet: Set a setting, checked as a start would check it: xynolog
	// settings <name> <value>.
	SettingsSet = Method[api.SettingsSetParams, api.Setting]{Name: "settings.set", Exclusive: true, Sends: []string{}}

	// SettingsUnset: Return a setting to its default: xynolog settings <name>
	// --unset.
	SettingsUnset = Method[api.SettingsUnsetParams, api.Setting]{Name: "settings.unset", Exclusive: true, Sends: []string{}}

	// SettingsPath: Where a machine document is: xynolog settings <document>
	// --path.
	SettingsPath = Method[api.SettingsPathParams, api.SettingsPathResult]{Name: "settings.path", Exclusive: true, Sends: []string{}}

	// ServiceHost: Where this machine and a run's instance meet under a runtime:
	// the host address an instance's ports are published on and its dials of
	// this machine go to. A caller asks it before it writes an instance's
	// document.
	ServiceHost = Method[api.ServiceHostParams, api.ServiceHostResult]{Name: "service.host", Exclusive: false, Sends: []string{}}

	// ServiceRun: Run one instance of a knowledge base's own service once, from
	// the image its stack documents name, unsupervised, on the caller's
	// document, arguments, environment and mounts, and answer when it exits:
	// xynolog run. Exclusive until its container runs; the wait for its exit is
	// not.
	ServiceRun = Method[api.ServiceRunParams, api.ServiceRunResult]{Name: "service.run", Exclusive: true, Sends: []string{"notifications/serviceStarted", "notifications/serviceOutput"}}

	// ServiceSignal: Send a run's instance SIGTERM, then SIGKILL if it outlives
	// 15 seconds, or SIGKILL at once: xynolog signal.
	ServiceSignal = Method[api.ServiceSignalParams, api.ServiceSignalResult]{Name: "service.signal", Exclusive: false, Sends: []string{}}
)

var (
	// NotificationsProgress: A line of what a request is doing.
	NotificationsProgress = Notification[api.Progress]{Name: "notifications/progress", From: SenderLauncher}

	// NotificationsUserAction: A sign-in waits for a person to enter a code.
	NotificationsUserAction = Notification[api.UserAction]{Name: "notifications/userAction", From: SenderLauncher}

	// NotificationsLog: A line a followed service wrote.
	NotificationsLog = Notification[api.LogRecord]{Name: "notifications/log", From: SenderLauncher}

	// NotificationsServiceStarted: A run's instance is running.
	NotificationsServiceStarted = Notification[api.ServiceStarted]{Name: "notifications/serviceStarted", From: SenderLauncher}

	// NotificationsServiceOutput: A line a run's instance wrote.
	NotificationsServiceOutput = Notification[api.ServiceOutput]{Name: "notifications/serviceOutput", From: SenderLauncher}

	// NotificationsCancelled: The client gives up on a request.
	NotificationsCancelled = Notification[api.Cancelled]{Name: "notifications/cancelled", From: SenderClient}
)
