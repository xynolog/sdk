package api

import (
	"encoding/json"
	"fmt"
	"slices"
	"strings"
)

// kind is the kind of JSON value a signature admits.
type kind int

const (
	textKind kind = iota
	integerKind
	numberKind
	booleanKind
	listKind
	objectKind
	nullKind
	anyKind
)

// signature is what a member of a union admits, as its schema states it:
// what tells it from the union's other members. A nil allowed is any member;
// a nil values is any value of its kind.
type signature struct {
	kind     kind
	required []string
	allowed  []string
	fixed    []fixedValues
	values   []any
}

// fixedValues is the values a member of an object may take.
type fixedValues struct {
	property string
	values   []any
}

// stated is the values s's property may take, if s says.
func (s signature) stated(property string) ([]any, bool) {
	for _, f := range s.fixed {
		if f.property == property {
			return f.values, true
		}
	}
	return nil, false
}

// unionMember is one of a union's members: its type's name, how a value of
// it is read, and what it admits.
type unionMember struct {
	name       string
	read       func(json.RawMessage) (any, error)
	signatures []signature
}

// readAs reads raw as the member T.
func readAs[T any](raw json.RawMessage) (any, error) {
	var value T
	err := json.Unmarshal(raw, &value)
	return value, err
}

// is reports whether value, as encoding/json reads it, is the literal one
// a schema states: a text, an integer or a boolean.
func is(literal, value any) bool {
	switch l := literal.(type) {
	case int:
		n, ok := value.(float64)
		return ok && n == float64(l)
	default:
		return literal == value
	}
}

func oneOf(values []any, value any) bool {
	return slices.ContainsFunc(values, func(l any) bool { return is(l, value) })
}

func (k kind) of(value any) bool {
	switch v := value.(type) {
	case string:
		return k == textKind || k == anyKind
	case float64:
		return k == numberKind || k == anyKind || (k == integerKind && v == float64(int64(v)))
	case bool:
		return k == booleanKind || k == anyKind
	case []any:
		return k == listKind || k == anyKind
	case map[string]any:
		return k == objectKind || k == anyKind
	case nil:
		return k == nullKind || k == anyKind
	}
	return false
}

// names reports whether value is of s's kind, and states only the values s
// admits.
func (s signature) names(value any) bool {
	if !s.kind.of(value) || (s.values != nil && !oneOf(s.values, value)) {
		return false
	}
	object, _ := value.(map[string]any)
	for _, f := range s.fixed {
		if stated, ok := object[f.property]; ok && !oneOf(f.values, stated) {
			return false
		}
	}
	return true
}

// lacks is what keeps s from admitting value, which it names: a member it
// requires and value lacks, or one value carries and s does not allow; ""
// where nothing does.
func (s signature) lacks(value any) string {
	object, _ := value.(map[string]any)
	for _, property := range s.required {
		if _, ok := object[property]; !ok {
			return fmt.Sprintf("lacks the member %q", property)
		}
	}
	if s.allowed != nil {
		for property := range object {
			if !slices.Contains(s.allowed, property) {
				return fmt.Sprintf("carries the member %q", property)
			}
		}
	}
	return ""
}

// only is the index of the one of members one of whose signatures passes
// test, or -1.
func only(members []unionMember, test func(signature) bool) int {
	found := -1
	for at, m := range members {
		if slices.ContainsFunc(m.signatures, test) {
			if found >= 0 {
				return -1
			}
			found = at
		}
	}
	return found
}

// member is u read as the one of members that admits its value; a value
// none admits is refused, said of the one member that names it where one
// does.
func (u union[M]) member(name string, members []unionMember) (any, error) {
	if u.raw == nil {
		return nil, errNoMember
	}
	var value any
	if err := json.Unmarshal(u.raw, &value); err != nil {
		return nil, err
	}
	if at := only(members, func(s signature) bool { return s.names(value) && s.lacks(value) == "" }); at >= 0 {
		return members[at].read(u.raw)
	}
	if at := only(members, func(s signature) bool { return s.names(value) }); at >= 0 {
		for _, s := range members[at].signatures {
			if s.names(value) {
				return nil, fmt.Errorf("api: a %s that is a %s %s", name, members[at].name, s.lacks(value))
			}
		}
	}
	return nil, noneOf(name, members)
}

// noneOf is the error of a value of the union name that none of its members
// names: where each states its values of one property, that the value's is
// none of them.
func noneOf(name string, members []unionMember) error {
	if len(members) > 0 && len(members[0].signatures) > 0 {
	properties:
		for _, f := range members[0].signatures[0].fixed {
			property := f.property
			var stated []string
			for _, m := range members {
				for _, s := range m.signatures {
					values, ok := s.stated(property)
					if !ok {
						continue properties
					}
					for _, v := range values {
						stated = append(stated, fmt.Sprintf("%v", v))
					}
				}
			}
			return fmt.Errorf("api: a %s's %s is none of %s", name, property, strings.Join(stated, ", "))
		}
	}
	return fmt.Errorf("api: a %s that is none of its members", name)
}
