package gmig

import (
	"testing"

	"github.com/go-yaml/yaml"
)

var one = `
up: >
  going up
# comment for down
down: >
  going down
`

func TestParseMigration(t *testing.T) {
	var m Migration
	if err := yaml.Unmarshal([]byte(one), &m); err != nil {
		t.Error(err)
	}
	if got, want := m.Up, "going up\n"; got != want {
		t.Errorf("got [%v] want [%v]", got, want)
	}
	if got, want := m.Down, "going down\n"; got != want {
		t.Errorf("got [%v] want [%v]", got, want)
	}
}
