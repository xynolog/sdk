//! The first fault of a value as one of the protocol's shapes. Every SDK
//! holds what it reads to the table of what each component schema requires
//! (`SCHEMAS`, which codegen/lib/required writes, by the rules of
//! codegen/lib/required/shape.ml) before it decodes it, and
//! names the first fault it finds the same way: a member the value lacks, or
//! one that is not what its schema allows. What serde refuses that the table
//! does not state is a fault of the value itself, and nothing of serde's own
//! account is said: it shows what it was given.

use crate::types::FrameRefusalReason;
use crate::types::Schema;
use serde_json::{Map, Value};
use std::fmt;

/// A kind of JSON value, as a schema names it. An integer is a number with no
/// fractional part.
pub(crate) enum Kind {
    Object,
    Array,
    String,
    Integer,
    Number,
    Boolean,
    Null,
}

/// A value a shape lists: the value is one of them.
pub(crate) enum Listed {
    Text(&'static str),
    Number(f64),
    Boolean(bool),
}

impl Listed {
    /// Whether `value` is this one: a number is one equal to it in value.
    fn is(&self, value: &Value) -> bool {
        match (self, value) {
            (Listed::Text(one), Value::String(held)) => one == held,
            (Listed::Number(one), Value::Number(held)) => held.as_f64() == Some(*one),
            (Listed::Boolean(one), Value::Bool(held)) => one == held,
            _ => false,
        }
    }
}

/// One term of a pattern: a step or a group.
pub(crate) enum Term {
    Step(Step),
    Group(Group),
}

/// A step of a pattern: at least `min` of a text's next code points, and at
/// most `max` (none: any number), each in one of the ranges `of`, from and
/// to, both included.
pub(crate) struct Step {
    pub(crate) of: &'static [(u32, u32)],
    pub(crate) min: usize,
    pub(crate) max: Option<usize>,
}

impl Step {
    fn holds(&self, point: char) -> bool {
        self.of
            .iter()
            .any(|(from, to)| (*from..=*to).contains(&u32::from(point)))
    }
}

/// A group of a pattern: a text's next code points one of the series of terms
/// `either`, repeated at least `min` times and at most `max` (none: any
/// number), a repetition past `min` taking at least one code point.
pub(crate) struct Group {
    pub(crate) either: &'static [&'static [Term]],
    pub(crate) min: usize,
    pub(crate) max: Option<usize>,
}

/// The member whose value names the variant a union is.
pub(crate) struct Discriminator {
    pub(crate) property: &'static str,
    pub(crate) mapping: &'static [(&'static str, usize)],
}

/// What a value must be: codegen/lib/required/shape.ml states
/// what each part means. A part the table does not state is `NONE`'s: no kinds allow
/// any, and an empty list holds nothing.
pub(crate) struct Shape {
    pub(crate) reference: Option<&'static str>,
    pub(crate) kinds: Option<&'static [Kind]>,
    /// Of an object's member, the texts it is read as: one that holds a text
    /// none of these is read as absent.
    pub(crate) recognized: Option<&'static [&'static str]>,
    pub(crate) enumeration: Option<&'static [Listed]>,
    pub(crate) pattern: Option<&'static [Term]>,
    pub(crate) min_length: Option<usize>,
    pub(crate) max_length: Option<usize>,
    pub(crate) minimum: Option<f64>,
    pub(crate) maximum: Option<f64>,
    pub(crate) min_items: Option<usize>,
    pub(crate) max_items: Option<usize>,
    pub(crate) required: &'static [&'static str],
    pub(crate) members: &'static [(&'static str, Shape)],
    /// The only members an object may carry; none, where it may carry any.
    pub(crate) closed: Option<&'static [&'static str]>,
    pub(crate) items: Option<&'static Shape>,
    pub(crate) values: Option<&'static Shape>,
    pub(crate) one_of: &'static [Shape],
    pub(crate) discriminator: Option<Discriminator>,
    pub(crate) all_of: &'static [Shape],
    /// Sets of members an object does not carry all of.
    pub(crate) not_all: &'static [&'static [&'static str]],
    pub(crate) min_members: Option<usize>,
    /// What each of an object's members' names must be.
    pub(crate) names: Option<&'static Shape>,
}

/// The shape that states nothing.
pub(crate) const NONE: Shape = Shape {
    reference: None,
    kinds: None,
    recognized: None,
    enumeration: None,
    pattern: None,
    min_length: None,
    max_length: None,
    minimum: None,
    maximum: None,
    min_items: None,
    max_items: None,
    required: &[],
    members: &[],
    closed: None,
    items: None,
    values: None,
    one_of: &[],
    discriminator: None,
    all_of: &[],
    not_all: &[],
    min_members: None,
    names: None,
};

/// The shape that is the component schema `name`.
pub(crate) const fn reference(name: &'static str) -> Shape {
    Shape {
        reference: Some(name),
        ..NONE
    }
}

/// The shape of a value of one of `kinds` that states nothing else.
pub(crate) const fn of(kinds: &'static [Kind]) -> Shape {
    Shape {
        kinds: Some(kinds),
        ..NONE
    }
}

include!("generated/required.rs");

/// The first thing wrong with a value: the way to the member it is at (the
/// names of the members it is within, and its own, joined by dots; empty for
/// the value itself), and why.
#[derive(Debug, PartialEq, Eq)]
pub(crate) struct Fault {
    pub(crate) member: String,
    pub(crate) reason: FrameRefusalReason,
}

impl Fault {
    /// The fault of a value serde refuses that has no fault the table
    /// states: the value itself is malformed.
    pub(crate) fn undecoded() -> Self {
        Fault {
            member: String::new(),
            reason: FrameRefusalReason::Malformed,
        }
    }

    /// This fault of the value at `member` of another, named by its way from
    /// that other.
    pub(crate) fn within(self, member: &str) -> Fault {
        Fault {
            member: match self.member.is_empty() {
                true => member.to_owned(),
                false => within(member, &self.member),
            },
            reason: self.reason,
        }
    }
}

/// What every SDK says of the fault.
impl fmt::Display for Fault {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self.reason {
            FrameRefusalReason::Lacks => write!(f, "it has no `{}`", self.member),
            FrameRefusalReason::Malformed if self.member.is_empty() => {
                f.write_str("it is malformed")
            }
            FrameRefusalReason::Malformed => write!(f, "its `{}` is malformed", self.member),
        }
    }
}

/// What the component schema `name` requires of a value.
pub(crate) fn schema(name: &str) -> &'static Shape {
    SCHEMAS
        .binary_search_by(|(named, _)| (*named).cmp(name))
        .map(|at| &SCHEMAS[at].1)
        .unwrap_or_else(|_| panic!("{name} is no component schema of the spec"))
}

fn resolved(shape: &'static Shape) -> &'static Shape {
    match shape.reference {
        Some(name) => resolved(schema(name)),
        None => shape,
    }
}

/// Whether `kinds` allow `value`: none allow any.
fn allows(kinds: Option<&[Kind]>, value: &Value) -> bool {
    kinds.is_none_or(|kinds| {
        kinds.iter().any(|kind| match (kind, value) {
            (Kind::Object, Value::Object(_))
            | (Kind::Array, Value::Array(_))
            | (Kind::String, Value::String(_))
            | (Kind::Number, Value::Number(_))
            | (Kind::Boolean, Value::Bool(_))
            | (Kind::Null, Value::Null) => true,
            (Kind::Integer, Value::Number(number)) => {
                number.is_i64()
                    || number.is_u64()
                    || number.as_f64().is_some_and(|n| n.fract() == 0.0)
            }
            _ => false,
        })
    })
}

fn within(way: &str, name: &str) -> String {
    if way.is_empty() {
        name.to_owned()
    } else {
        format!("{way}.{name}")
    }
}

fn malformed(way: &str) -> Fault {
    Fault {
        member: way.to_owned(),
        reason: FrameRefusalReason::Malformed,
    }
}

/// Whether `count` is at least `least` and at most `most`, where each is
/// stated.
fn counted(least: Option<usize>, count: usize, most: Option<usize>) -> bool {
    least.is_none_or(|least| count >= least) && most.is_none_or(|most| count <= most)
}

/// Whether `points`, from `at`, are of `terms`, with `rest` taking what is
/// left after them: a step takes as many points as it may and gives them back
/// one by one, and a group repeats as often as it may and gives repetitions
/// back the same way, until `rest` takes what is left.
fn series(terms: &[Term], points: &[char], at: usize, rest: &dyn Fn(usize) -> bool) -> bool {
    let Some((first, after)) = terms.split_first() else {
        return rest(at);
    };
    let next = |from: usize| series(after, points, from, rest);
    match first {
        Term::Step(step) => {
            let most = step
                .max
                .map_or(points.len(), |max| points.len().min(at + max));
            let taken = points[at..most]
                .iter()
                .take_while(|point| step.holds(**point))
                .count();
            (step.min..=taken).rev().any(|count| next(at + count))
        }
        Term::Group(group) => repeated(group, points, at, 0, &next),
    }
}

/// Whether `points`, from `at`, are of `group` repeated once more than
/// `count` times or more, then of `next`: a repetition past the group's `min`
/// takes at least one point.
fn repeated(
    group: &Group,
    points: &[char],
    at: usize,
    count: usize,
    next: &dyn Fn(usize) -> bool,
) -> bool {
    let again = |after: usize| {
        (count < group.min || after > at) && repeated(group, points, after, count + 1, next)
    };
    let once_more = group.max.is_none_or(|max| count < max)
        && group
            .either
            .iter()
            .any(|alternative| series(alternative, points, at, &again));
    once_more || (count >= group.min && next(at))
}

/// Whether `value` is one of `shape`'s values, a text is of its pattern and
/// has as many code points as it allows, a number is within its bounds, and
/// an array has as many items and an object as many members as it allows.
fn is_as_stated(shape: &Shape, value: &Value) -> bool {
    if let Some(listed) = shape.enumeration
        && !listed.iter().any(|one| one.is(value))
    {
        return false;
    }
    match value {
        Value::String(text) => {
            let points: Vec<char> = text.chars().collect();
            counted(shape.min_length, points.len(), shape.max_length)
                && shape
                    .pattern
                    .is_none_or(|terms| series(terms, &points, 0, &|at: usize| at == points.len()))
        }
        Value::Number(number) => number.as_f64().is_some_and(|number| {
            shape.minimum.is_none_or(|least| number >= least)
                && shape.maximum.is_none_or(|most| number <= most)
        }),
        Value::Array(items) => counted(shape.min_items, items.len(), shape.max_items),
        Value::Object(members) => counted(shape.min_members, members.len(), None),
        _ => true,
    }
}

/// The first fault `value` has as a value of `shape`, from `way`, each
/// member the table reads as absent left out of each object that has no
/// fault in its members.
fn fault_at(shape: &'static Shape, value: &mut Value, way: &str) -> Option<Fault> {
    let own = resolved(shape);
    if !allows(own.kinds, value) || !is_as_stated(own, value) {
        return Some(malformed(way));
    }
    if let Value::Object(object) = &mut *value
        && let Some(fault) = fault_of_members(own, object, way)
    {
        return Some(fault);
    }
    if let (Value::Array(items), Some(item)) = (&mut *value, own.items)
        && let Some(fault) = items.iter_mut().find_map(|held| fault_at(item, held, way))
    {
        return Some(fault);
    }
    if !own.one_of.is_empty()
        && let Some(fault) = fault_of_one_of(own, value, way)
    {
        return Some(fault);
    }
    own.all_of
        .iter()
        .find_map(|part| fault_at(part, value, way))
}

/// Whether `held` is a text none of `member`'s recognized texts names: a
/// member a reader reads as absent.
fn unrecognized(member: &'static Shape, held: &Value) -> bool {
    match (resolved(member).recognized, held) {
        (Some(recognized), Value::String(text)) => !recognized.contains(&text.as_str()),
        _ => false,
    }
}

/// The first fault of an object in the members `shape` requires, in what its
/// members are, in the members it may not carry, in its members' names, in
/// the sets of members it may not carry all of, and in its values. A member
/// that holds a text none of its recognized texts names is no fault: it is
/// left out of the object once the object has none.
fn fault_of_members(
    shape: &'static Shape,
    object: &mut Map<String, Value>,
    way: &str,
) -> Option<Fault> {
    for name in shape.required {
        let member = shape.members.iter().find(|(named, _)| named == name);
        let lacking = match object.get(*name) {
            None => true,
            Some(Value::Null) => {
                member.is_some_and(|(_, member)| !allows(resolved(member).kinds, &Value::Null))
            }
            Some(_) => false,
        };
        if lacking {
            return Some(Fault {
                member: within(way, name),
                reason: FrameRefusalReason::Lacks,
            });
        }
    }
    let mut unread = Vec::new();
    for (name, member) in shape.members {
        let Some(held) = object.get_mut(*name).filter(|held| !held.is_null()) else {
            continue;
        };
        if unrecognized(member, held) {
            unread.push(*name);
        } else if let Some(fault) = fault_at(member, held, &within(way, name)) {
            return Some(fault);
        }
    }
    if let Some(closed) = shape.closed
        && let Some(unnamed) = object
            .keys()
            .filter(|name| !closed.contains(&name.as_str()))
            .min()
    {
        return Some(malformed(&within(way, unnamed)));
    }
    if let Some(names) = shape.names
        && let Some(misnamed) = object
            .keys()
            .filter(|name| fault_at(names, &mut Value::String((*name).clone()), "").is_some())
            .min()
    {
        return Some(malformed(&within(way, misnamed)));
    }
    if shape
        .not_all
        .iter()
        .any(|set| set.iter().all(|name| object.contains_key(*name)))
    {
        return Some(malformed(way));
    }
    if let Some(values) = shape.values {
        let mut held: Vec<(&String, &mut Value)> = object.iter_mut().collect();
        held.sort_by(|a, b| a.0.cmp(b.0));
        if let Some(fault) = held
            .into_iter()
            .find_map(|(_, value)| fault_at(values, value, way))
        {
            return Some(fault);
        }
    }
    for name in unread {
        object.remove(name);
    }
    None
}

/// The fault `value` has as one of the variants of `shape`: the variant its
/// discriminator names, or else each variant whose kinds allow it. None when
/// one of them has none; the first one's when each has one; and a value no
/// variant allows is malformed. Each of several variants is tried on a copy
/// of `value`, and the value is what the one with none leaves of it.
fn fault_of_one_of(shape: &'static Shape, value: &mut Value, way: &str) -> Option<Fault> {
    let named = shape.discriminator.as_ref().and_then(|discriminator| {
        let stated = value.get(discriminator.property)?.as_str()?;
        discriminator
            .mapping
            .iter()
            .find(|(tag, _)| *tag == stated)
            .map(|(_, at)| &shape.one_of[*at])
    });
    let candidates: Vec<&'static Shape> = match named {
        Some(variant) => vec![variant],
        None => shape
            .one_of
            .iter()
            .filter(|variant| allows(resolved(variant).kinds, value))
            .collect(),
    };
    if let [only] = candidates.as_slice() {
        return fault_at(only, value, way);
    }
    let mut first = None;
    for candidate in &candidates {
        let mut tried = value.clone();
        match fault_at(candidate, &mut tried, way) {
            None => {
                *value = tried;
                return None;
            }
            Some(fault) => {
                first.get_or_insert(fault);
            }
        }
    }
    first.or_else(|| Some(malformed(way)))
}

/// The first fault `value` has as a value of `shape`, by the rules every SDK
/// reads the table by; nothing when it has none. Each member the table reads
/// as absent is left out of `value`, so what is decoded of it is what a
/// reader reads.
pub(crate) fn fault_of(shape: &'static Shape, value: &mut Value) -> Option<Fault> {
    fault_at(shape, value, "")
}

/// What every SDK says of the first fault `body` has as the component schema
/// `T` is generated from, as it refuses it: "it has no \`member\`", "its
/// \`member\` is malformed", or "it is malformed"; `None` when it has none.
/// Each member the table reads as absent is left out of `body`, as
/// `fault_of` leaves it out.
pub fn fault_said<T: Schema>(body: &mut Value) -> Option<String> {
    fault_of(schema(T::NAME), body).map(|fault| fault.to_string())
}

#[cfg(test)]
mod tests {
    use super::{Fault, Group, Kind, NONE, Shape, Step, Term, fault_of, fault_said, of, schema};
    use crate::types::FrameRefusalReason;
    use crate::types::UserResponse;
    use serde_json::json;

    /// The step of the one code point `point`.
    macro_rules! point {
        ($point:literal) => {
            Term::Step(Step {
                of: &[($point as u32, $point as u32)],
                min: 1,
                max: Some(1),
            })
        };
    }

    /// `^(GET|POST) /`: a text that begins with either word, a space and a
    /// slash, the end it does not anchor a step of any code points.
    const REQUEST_LINE: Shape = Shape {
        kinds: Some(&[Kind::String]),
        pattern: Some(&[
            Term::Group(Group {
                either: &[
                    &[point!('G'), point!('E'), point!('T')],
                    &[point!('P'), point!('O'), point!('S'), point!('T')],
                ],
                min: 1,
                max: Some(1),
            }),
            point!(' '),
            point!('/'),
            Term::Step(Step {
                of: &[(0, 0x10FFFF)],
                min: 0,
                max: None,
            }),
        ]),
        ..NONE
    };

    /// `^(a|ab){2,3}$`: a repetition the next one needs given back.
    const REPEATED: Shape = Shape {
        kinds: Some(&[Kind::String]),
        pattern: Some(&[Term::Group(Group {
            either: &[&[point!('a')], &[point!('a'), point!('b')]],
            min: 2,
            max: Some(3),
        })]),
        ..NONE
    };

    /// `^(a*)*$`: a group whose alternative may take no code points.
    const REPEATED_EMPTY: Shape = Shape {
        kinds: Some(&[Kind::String]),
        pattern: Some(&[Term::Group(Group {
            either: &[&[Term::Step(Step {
                of: &[('a' as u32, 'a' as u32)],
                min: 0,
                max: None,
            })]],
            min: 0,
            max: None,
        })]),
        ..NONE
    };

    /// An object of at least one member, each named in lowercase, that does
    /// not carry both `a` and `b`, and whose `a` is a text.
    const EXCLUSIVE: Shape = Shape {
        kinds: Some(&[Kind::Object]),
        members: &[("a", of(&[Kind::String]))],
        min_members: Some(1),
        names: Some(&Shape {
            kinds: Some(&[Kind::String]),
            pattern: Some(&[Term::Step(Step {
                of: &[('a' as u32, 'z' as u32)],
                min: 1,
                max: None,
            })]),
            ..NONE
        }),
        not_all: &[&["a", "b"]],
        ..NONE
    };

    fn malformed(member: &str) -> Option<Fault> {
        Some(Fault {
            member: member.to_owned(),
            reason: FrameRefusalReason::Malformed,
        })
    }

    #[test]
    fn a_value_is_held_to_its_values_its_form_its_size_and_the_members_a_closed_object_names() {
        let cases = [
            ("BusPingMessage", json!({"event": "ping", "data": ""}), None),
            (
                "BusPingMessage",
                json!({"event": "pong", "data": ""}),
                malformed("event"),
            ),
            (
                "BusPingMessage",
                json!({"event": "ping", "data": "x"}),
                malformed("data"),
            ),
            (
                "BrowseProfilesRequest",
                json!({"dids": ["did:web:example.org"]}),
                None,
            ),
            (
                "BrowseProfilesRequest",
                json!({"dids": ["did:\u{1f600}"]}),
                None,
            ),
            (
                "BrowseProfilesRequest",
                json!({"dids": []}),
                malformed("dids"),
            ),
            (
                "BrowseProfilesRequest",
                json!({"dids": ["web:example.org"]}),
                malformed("dids"),
            ),
            (
                "BrowseProfilesRequest",
                json!({"dids": ["did:web:a b"]}),
                malformed("dids"),
            ),
            (
                "GatherAnnotationOptions",
                json!({"contextWindow": 100.0}),
                None,
            ),
            (
                "GatherAnnotationOptions",
                json!({"contextWindow": 5000}),
                None,
            ),
            (
                "GatherAnnotationOptions",
                json!({"contextWindow": 99}),
                malformed("contextWindow"),
            ),
            (
                "GatherAnnotationOptions",
                json!({"contextWindow": 5001}),
                malformed("contextWindow"),
            ),
            // A closed object: what it describes first, then the first member
            // it does not name, by code point.
            (
                "BrowseProfilesRequest",
                json!({"dids": ["did:web:example.org"], "more": 1}),
                malformed("more"),
            ),
            (
                "BrowseProfilesRequest",
                json!({"dids": [], "more": 1}),
                malformed("dids"),
            ),
            (
                "BrowseProfilesRequest",
                json!({"more": 1}),
                Some(Fault {
                    member: "dids".to_owned(),
                    reason: FrameRefusalReason::Lacks,
                }),
            ),
            (
                "BrowseProfilesRequest",
                json!({"dids": ["did:web:example.org"], "\u{1f600}": 1, "\u{ff61}": 1}),
                malformed("\u{ff61}"),
            ),
        ];
        for (name, mut value, fault) in cases {
            assert_eq!(fault_of(schema(name), &mut value), fault, "{name}: {value}");
        }
    }

    #[test]
    fn a_text_is_of_a_pattern_when_some_way_of_reading_it_takes_all_of_it() {
        let cases = [
            (&REQUEST_LINE, json!("GET /"), None),
            (&REQUEST_LINE, json!("POST /resources?x=1 \u{1f600}"), None),
            (&REQUEST_LINE, json!("PUT /"), malformed("")),
            (&REQUEST_LINE, json!("GETPOST /"), malformed("")),
            (&REQUEST_LINE, json!("GET/"), malformed("")),
            (&REQUEST_LINE, json!(" GET /"), malformed("")),
            (&REPEATED, json!("aa"), None),
            (&REPEATED, json!("aab"), None),
            (&REPEATED, json!("ababab"), None),
            (&REPEATED, json!("a"), malformed("")),
            (&REPEATED, json!("aaaa"), malformed("")),
            (&REPEATED, json!("abb"), malformed("")),
            (&REPEATED_EMPTY, json!(""), None),
            (&REPEATED_EMPTY, json!("aaa"), None),
            (&REPEATED_EMPTY, json!("aab"), malformed("")),
            (schema("RunInstance"), json!("web-1-a"), None),
            (schema("RunInstance"), json!("web"), None),
            (schema("RunInstance"), json!("web-"), malformed("")),
            (schema("RunInstance"), json!("web--a"), malformed("")),
        ];
        for (shape, mut value, fault) in cases {
            assert_eq!(fault_of(shape, &mut value), fault, "{value}");
        }
    }

    #[test]
    fn an_object_is_held_to_its_fewest_members_its_names_and_the_sets_it_carries_not_all_of() {
        let cases = [
            (json!({"a": "x"}), None),
            (json!({"b": 1}), None),
            (json!({}), malformed("")),
            (json!({"a": "x", "b": 1}), malformed("")),
            // A member that holds null is carried.
            (json!({"a": null, "b": 1}), malformed("")),
            (json!({"a": "x", "B": 1}), malformed("B")),
            (json!({"a": "x", "\u{e9}": 1, "C": 1}), malformed("C")),
            // What a member is comes before the sets it is in, and a name
            // before the sets too.
            (json!({"a": 1, "b": 1}), malformed("a")),
            (json!({"a": "x", "b": 1, "B": 1}), malformed("B")),
        ];
        for (mut value, fault) in cases {
            assert_eq!(fault_of(&EXCLUSIVE, &mut value), fault, "{value}");
        }
    }

    #[test]
    fn the_first_fault_of_a_body_is_said_as_every_sdk_says_it() {
        let mut user = json!({"did": "did:web:example.org:users:a", "domain": "example.org", "email": null, "name": null, "image": null});
        assert_eq!(fault_said::<UserResponse>(&mut user), None);
        assert_eq!(
            fault_said::<UserResponse>(&mut json!({"did": "did:web:example.org:users:a"}))
                .as_deref(),
            Some("it has no `email`")
        );
        assert_eq!(
            fault_said::<UserResponse>(&mut json!({"did": "web", "domain": "example.org", "email": null, "name": null, "image": null})).as_deref(),
            Some("its `did` is malformed")
        );
        assert_eq!(
            fault_said::<UserResponse>(&mut json!("a user")).as_deref(),
            Some("it is malformed")
        );
    }
}
