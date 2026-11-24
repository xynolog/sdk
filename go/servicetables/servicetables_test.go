package servicetables

// Each table, written back, is the table Protocol states: nothing is lost in
// reading it as its schema's type, and nothing is made up.

import (
	"encoding/json"
	"os"
	"path/filepath"
	"reflect"
	"testing"
)

func TestEachTableWrittenBackIsItsFile(t *testing.T) {
	if len(tables) == 0 {
		t.Fatal("no tables: the test would pass for the wrong reason")
	}
	for file, table := range tables {
		stated, err := os.ReadFile(filepath.Join("..", "..", "protocol", "specs", "src", filepath.FromSlash(file)))
		if err != nil {
			t.Fatal(err)
		}
		written, err := json.Marshal(table)
		if err != nil {
			t.Fatalf("%s: %v", file, err)
		}
		var want, got any
		if err := json.Unmarshal(stated, &want); err != nil {
			t.Fatalf("%s: %v", file, err)
		}
		if err := json.Unmarshal(written, &got); err != nil {
			t.Fatalf("%s: %v", file, err)
		}
		if !reflect.DeepEqual(want, got) {
			t.Errorf("%s written back is not the file:\n%s", file, written)
		}
	}
}
