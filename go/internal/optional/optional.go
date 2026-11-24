// Package optional is a text member a generated type may leave out, as
// package api states one (nil), beside the "" a hand-written signature
// takes for none.
package optional

// Text is text, or nil where it is "".
func Text(text string) *string {
	if text == "" {
		return nil
	}
	return &text
}

// Said is what text states: "" where it is nil.
func Said(text *string) string {
	if text == nil {
		return ""
	}
	return *text
}
