// Package servicetables is the tables the services keep to: the variables a
// service reads and why it refuses to start, what it tells OpenTelemetry and
// logs, its messages, its jobs' budgets, the bounds of the bus's replies, the
// archivist's layout and the rest. Each is a value of package api's type of
// its own schema, read from the table as Protocol states it (tables_gen.go).
package servicetables

import (
	"bytes"
	"encoding/json"
	"fmt"
)

// read is text read as a T, refusing a member T does not name: a table is
// read once, when the package is, and one that does not read as its schema's
// type is a generator's fault, not a caller's.
func read[T any](text string) T {
	var table T
	decoder := json.NewDecoder(bytes.NewReader([]byte(text)))
	decoder.DisallowUnknownFields()
	if err := decoder.Decode(&table); err != nil {
		panic(fmt.Sprintf("a table that does not read as %T: %v", table, err))
	}
	return table
}
