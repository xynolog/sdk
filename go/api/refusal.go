package api

// Error is what the refusal said: a ClaimRefusal is the error a worker's
// claims give where a job would have been.
func (r *ClaimRefusal) Error() string { return r.Message }
