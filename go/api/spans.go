package api

import "encoding/json"

// TextSpan is the span u holds, without how it was found: what an annotation
// of it is built from. Each member of ReconciledSpan is a TextSpan's members
// and how it was found, so the span is read off whichever member u holds.
func (u ReconciledSpan) TextSpan() (TextSpan, error) {
	if _, err := u.Member(); err != nil {
		return TextSpan{}, err
	}
	var span TextSpan
	if err := json.Unmarshal(u.raw, &span); err != nil {
		return TextSpan{}, err
	}
	return span, nil
}
