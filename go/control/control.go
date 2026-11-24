// Package control is the launcher's control API
// (protocol/contract/LAUNCHER-CONTROL.md): JSON-RPC 2.0, one message per line,
// over the standard input and output of `xynolog control`. Every method and
// notification of protocol/specs/src/control/methods.json is a value of
// methods_gen.go, typed by package api's types of its schemas. A request
// states api.ApiVersion, and one that failed carries api.ErrorData, whose code
// is a xynolog.ControlErrorCode.
package control

// Method is a method of the control API: a request whose params are P,
// answered with a result R.
type Method[P, R any] struct {
	// Name is the method as a request names it.
	Name string
	// Exclusive is whether a request of it waits for every other exclusive
	// request to end, and holds the others off until it does.
	Exclusive bool
	// Sends is the notifications a request of it may send besides progress,
	// which any may.
	Sends []string
}

// Notification is a notification of the control API, whose params are P.
type Notification[P any] struct {
	// Name is the notification as its message names it.
	Name string
	// From is who sends it.
	From Sender
}
