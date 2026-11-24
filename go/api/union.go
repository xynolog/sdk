package api

import (
	"encoding/json"
	"errors"
	"fmt"
)

// union is a value of one of a union's members, held as the wire carries
// it. M is the union's member interface: a type is one of its members when
// it has the union's marker method, which types_gen.go writes for each.
// Every union type of package api embeds one, and so has its methods.
type union[M any] struct{ raw json.RawMessage }

// told is what a member of a union told apart by a property says of itself:
// the property, and the one value of it the member states.
type told interface {
	told() (property, value string)
}

// errNoMember is the error of writing a union that holds no member.
var errNoMember = errors.New("api: a union that holds no member")

// MarshalJSON writes the member u holds, as it was given or read.
func (u union[M]) MarshalJSON() ([]byte, error) {
	if u.raw == nil {
		return nil, errNoMember
	}
	return u.raw, nil
}

// UnmarshalJSON holds raw, to be read as one of the union's members by As.
func (u *union[M]) UnmarshalJSON(raw []byte) error {
	u.raw = append(json.RawMessage(nil), raw...)
	return nil
}

// From sets u to held, one of its members. A member that is told apart by a
// property states its value of it, whatever held says.
func (u *union[M]) From(held M) error {
	raw, err := json.Marshal(held)
	if err != nil {
		return err
	}
	if t, ok := any(held).(told); ok {
		property, value := t.told()
		if raw, err = withProperty(raw, property, value); err != nil {
			return err
		}
	}
	u.raw = raw
	return nil
}

// As reads u into into, a pointer to one of its members.
func (u union[M]) As(into M) error {
	if u.raw == nil {
		return errNoMember
	}
	return json.Unmarshal(u.raw, into)
}

// stated is the text property states in the object u holds.
func (u union[M]) stated(property string) (string, error) {
	var object map[string]json.RawMessage
	if err := json.Unmarshal(u.raw, &object); err != nil {
		return "", err
	}
	var text string
	if err := json.Unmarshal(object[property], &text); err != nil {
		return "", fmt.Errorf("api: the union's %s is no text: %w", property, err)
	}
	return text, nil
}

// withProperty is the object raw with its property set to value.
func withProperty(raw []byte, property, value string) ([]byte, error) {
	var object map[string]json.RawMessage
	if err := json.Unmarshal(raw, &object); err != nil {
		return nil, err
	}
	text, err := json.Marshal(value)
	if err != nil {
		return nil, err
	}
	object[property] = text
	return json.Marshal(object)
}
