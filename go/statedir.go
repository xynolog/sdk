package xynolog

// Where the launcher's state home is: the directory that holds the sign-in
// store's tokens.json. Every program that finds that file computes it the same
// way (protocol/specs/src/sign-in-store/cases.json). The SDK reads no environment: a
// program reads its own and says what it found.

import (
	"runtime"
	"strings"

	"github.com/xynolog/sdk/go/api"
)

// ThisSystem is the system this program runs on.
func ThisSystem() api.System {
	switch runtime.GOOS {
	case "darwin":
		return api.SystemMacos
	case "windows":
		return api.SystemWindows
	}
	return api.SystemOther
}

// under is names below base, joined with system's separator, whichever system
// this program runs on: a case gives one answer on any machine.
func under(system api.System, base string, names ...string) string {
	separator := "/"
	if system == api.SystemWindows {
		separator = `\`
	}
	return strings.TrimRight(base, separator) + separator + strings.Join(names, separator)
}

// StateDir is the launcher's state home, from what system says of the
// person's directories: home is the home directory (HOME, or USERPROFILE on
// Windows), xdgStateHome is XDG_STATE_HOME and localAppData is LOCALAPPDATA,
// each "" when it is not set. False when there is no home, and so no state
// home: nothing is read or written.
func StateDir(system api.System, home, xdgStateHome, localAppData string) (string, bool) {
	switch {
	case home == "":
		return "", false
	case system == api.SystemMacos:
		return under(system, home, "Library", "Application Support", "xynolog"), true
	case system == api.SystemWindows:
		if localAppData == "" {
			localAppData = under(system, home, "AppData", "Local")
		}
		return under(system, localAppData, "xynolog"), true
	case xdgStateHome != "":
		return under(system, xdgStateHome, "xynolog"), true
	}
	return under(system, home, ".local", "state", "xynolog"), true
}
