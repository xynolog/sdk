package api

import "fmt"

// Error is what the refusal said: a ClaimRefusal is the error a worker's
// claims give where a job would have been.
func (r *ClaimRefusal) Error() string { return r.Message }

// String is what every SDK says of the fault.
func (f Fault) String() string {
	switch {
	case f.Reason == FrameRefusalReasonLacks:
		return fmt.Sprintf("it has no `%s`", f.Member)
	case f.Member == "":
		return "it is malformed"
	default:
		return fmt.Sprintf("its `%s` is malformed", f.Member)
	}
}

// Error is what every SDK says of a frame its channel's reader is given a
// refusal of: a FrameRefusal is the error a channel's readers are given in
// the refused frame's place.
func (r *FrameRefusal) Error() string {
	return fmt.Sprintf("a frame on %s is not that channel's: %s", r.Channel, Fault{Member: r.Member, Reason: r.Reason})
}
