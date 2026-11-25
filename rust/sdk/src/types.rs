//! The protocol's types, generated from the spec (generated/types.rs, which
//! codegen/lib/rust_types writes): every schema of the job protocol's channels, the reads a job's
//! admission makes, and the bodies of the bus transport, with every schema
//! they reach. What a schema states that a type cannot — a pattern, a length,
//! a bound — the receiving side's validators hold.
//!
//! The kinds of id are the exception (protocol/specs/src/identifiers/kinds.json):
//! `ResourceId`, `AnnotationId`, `JobId` and `UserId` are each a type of its
//! own, made only by a constructor that holds a value to its kind's rule,
//! and decoded through that constructor.
//!
//! ```
//! use xynolog::types::{AnnotationId, ResourceId};
//!
//! fn of(_resource: &ResourceId, _annotation: &AnnotationId) {}
//!
//! let resource: ResourceId = "res-one".parse()?;
//! let annotation: AnnotationId = "a-1".parse()?;
//! of(&resource, &annotation);
//! assert!("https://kb.example/resources/res-one".parse::<ResourceId>().is_err());
//! # Ok::<(), xynolog::types::InvalidIdentifier>(())
//! ```
//!
//! One kind is not taken for another: the same call with its two ids
//! exchanged does not compile.
//!
//! ```compile_fail,E0308
//! use xynolog::types::{AnnotationId, ResourceId};
//!
//! fn of(_resource: &ResourceId, _annotation: &AnnotationId) {}
//!
//! let resource: ResourceId = "res-one".parse()?;
//! let annotation: AnnotationId = "a-1".parse()?;
//! of(&annotation, &resource);
//! # Ok::<(), xynolog::types::InvalidIdentifier>(())
//! ```

#![allow(clippy::enum_variant_names, clippy::large_enum_variant)]

/// `$name` is the type of the component schema of its name. Exported for the
/// types a crate beside the SDK generates from the same spec.
#[macro_export]
macro_rules! schema {
    ($name:ident) => {
        impl $crate::types::Schema for $name {
            const NAME: &'static str = stringify!($name);
        }
    };
}

/// `$member` is the union `$union` wherever the union is wanted: its
/// variant `$variant`. Exported as `schema!` is.
#[macro_export]
macro_rules! member {
    ($union:ident :: $variant:ident ($member:ident $(,)?)) => {
        impl From<$member> for $union {
            fn from(member: $member) -> Self {
                $union::$variant(member)
            }
        }
    };
}

/// `$name` is the one value `$value` of `$kind`: written as it, and read
/// from it alone. Exported as `schema!` is.
#[macro_export]
macro_rules! constant {
    ($name:ident, $kind:ty, $value:expr) => {
        impl $name {
            /// The one value it is.
            pub const VALUE: $kind = $value;
        }

        impl serde::Serialize for $name {
            fn serialize<S: serde::Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
                serde::Serialize::serialize(&Self::VALUE, serializer)
            }
        }

        impl<'de> serde::Deserialize<'de> for $name {
            fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
                let value = <$kind as serde::Deserialize>::deserialize(deserializer)?;
                if value == Self::VALUE {
                    Ok($name)
                } else {
                    Err(serde::de::Error::custom(format_args!(
                        "{value}, where {} is {}",
                        stringify!($name),
                        Self::VALUE
                    )))
                }
            }
        }
    };
}

/// `$union` is decoded as the one of its variants, in the order of
/// `$union::MEMBERS`, that [`member`] finds: one that admits the value is
/// read as it, and one that only names it says what is wrong with it.
/// Exported as `schema!` is.
#[macro_export]
macro_rules! union {
    ($union:ident, $($variant:ident),+ $(,)?) => {
        impl<'de> serde::Deserialize<'de> for $union {
            fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
                let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
                let found = $crate::types::member(&value, $union::MEMBERS);
                let mut at = 0;
                $(
                    if found.map(|(member, _)| member) == Some(at) {
                        let read = serde_json::from_value(value).map($union::$variant);
                        return match (found, read) {
                            (Some((_, $crate::types::Found::Admitted)), Ok(member)) => Ok(member),
                            (_, Err(error)) => Err(serde::de::Error::custom(error)),
                            (_, Ok(_)) => Err(serde::de::Error::custom(format_args!(
                                "a {} its member {} does not admit",
                                stringify!($union),
                                stringify!($variant)
                            ))),
                        };
                    }
                    at += 1;
                )+
                let _ = at;
                Err(serde::de::Error::custom($crate::types::none_of(
                    stringify!($union),
                    $union::MEMBERS,
                )))
            }
        }
    };
}

/// What a member of a union admits, as its schema states it: what tells it
/// from the union's other members.
#[derive(Debug)]
pub struct Signature {
    pub kind: Kind,
    /// The members an object must carry.
    pub required: &'static [&'static str],
    /// Every member an object may carry, where its schema says.
    pub allowed: Option<&'static [&'static str]>,
    /// The values each of these members may take.
    pub fixed: &'static [(&'static str, &'static [Literal])],
    /// Every value it admits, where its schema says.
    pub values: Option<&'static [Literal]>,
}

/// The kind of JSON value a [`Signature`] admits.
#[derive(Debug)]
pub enum Kind {
    Text,
    Integer,
    Number,
    Boolean,
    List,
    Object,
    Null,
    Any,
}

/// One value a schema states.
#[derive(Debug)]
pub enum Literal {
    Text(&'static str),
    Integer(i64),
    Boolean(bool),
}

impl std::fmt::Display for Literal {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Literal::Text(text) => write!(f, "`{text}`"),
            Literal::Integer(n) => write!(f, "`{n}`"),
            Literal::Boolean(b) => write!(f, "`{b}`"),
        }
    }
}

impl Literal {
    fn is(&self, value: &serde_json::Value) -> bool {
        match self {
            Literal::Text(text) => value.as_str() == Some(text),
            Literal::Integer(n) => value.as_i64() == Some(*n),
            Literal::Boolean(b) => value.as_bool() == Some(*b),
        }
    }
}

impl Kind {
    fn of(&self, value: &serde_json::Value) -> bool {
        match self {
            Kind::Text => value.is_string(),
            Kind::Integer => value.is_i64() || value.is_u64(),
            Kind::Number => value.is_number(),
            Kind::Boolean => value.is_boolean(),
            Kind::List => value.is_array(),
            Kind::Object => value.is_object(),
            Kind::Null => value.is_null(),
            Kind::Any => true,
        }
    }
}

impl Signature {
    /// Whether `value` is of its kind, and states only the values it admits.
    fn names(&self, value: &serde_json::Value) -> bool {
        let one_of = |values: &[Literal], value| values.iter().any(|v| v.is(value));
        self.kind.of(value)
            && self.values.is_none_or(|values| one_of(values, value))
            && value.as_object().is_none_or(|object| {
                self.fixed.iter().all(|(property, values)| {
                    object.get(*property).is_none_or(|v| one_of(values, v))
                })
            })
    }

    /// Whether it admits `value`: [`Signature::names`] it, and an object
    /// carries every member it requires and none it does not allow.
    fn admits(&self, value: &serde_json::Value) -> bool {
        self.names(value)
            && value.as_object().is_none_or(|object| {
                self.required.iter().all(|p| object.contains_key(*p))
                    && self
                        .allowed
                        .is_none_or(|allowed| object.keys().all(|k| allowed.contains(&k.as_str())))
            })
    }
}

/// How [`member`] found a union's member.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Found {
    /// It admits the value.
    Admitted,
    /// It admits no value of the union's members, and only it names it.
    Named,
}

/// The one of a union's `members`, each its signatures, that admits `value`;
/// or, none admitting it, the one that names it, whose decoding says what is
/// wrong with it.
pub fn member(value: &serde_json::Value, members: &[&[Signature]]) -> Option<(usize, Found)> {
    let only = |test: &dyn Fn(&Signature) -> bool| {
        let mut found = members
            .iter()
            .enumerate()
            .filter(|(_, signatures)| signatures.iter().any(test))
            .map(|(at, _)| at);
        match (found.next(), found.next()) {
            (Some(at), None) => Some(at),
            _ => None,
        }
    };
    only(&|s| s.admits(value))
        .map(|at| (at, Found::Admitted))
        .or_else(|| only(&|s| s.names(value)).map(|at| (at, Found::Named)))
}

/// What is wrong with a value of `union` that none of its `members` names:
/// where each states its values of one property, that the value's is none of
/// them.
pub fn none_of(union: &str, members: &[&[Signature]]) -> String {
    let stated = |property: &str| -> Option<Vec<&Literal>> {
        let mut values = Vec::new();
        for signature in members.iter().flat_map(|signatures| signatures.iter()) {
            let (_, of) = signature.fixed.iter().find(|(p, _)| *p == property)?;
            values.extend(of.iter());
        }
        Some(values)
    };
    let told_apart = members
        .first()
        .and_then(|signatures| signatures.first())
        .into_iter()
        .flat_map(|signature| signature.fixed.iter())
        .find_map(|(property, _)| stated(property).map(|values| (property, values)));
    match told_apart {
        Some((property, values)) => {
            let values: Vec<String> = values.iter().map(|v| v.to_string()).collect();
            format!(
                "a {union} states a `{property}` that is one of {}",
                values.join(", ")
            )
        }
        None => format!("a {union} that is none of its members"),
    }
}

include!("generated/types.rs");

/// A type generated from a component schema, which it names.
pub trait Schema {
    /// The component schema's name.
    const NAME: &'static str;
}

/// A string that is not an id of the kind it was to be.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct InvalidIdentifier {
    /// The kind it was to be.
    pub kind: &'static str,
    /// The rule of that kind, as the spec writes it.
    pub pattern: &'static str,
    pub value: String,
}

impl std::fmt::Display for InvalidIdentifier {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{:?} is not a {}: it does not match {}",
            self.value, self.kind, self.pattern
        )
    }
}

impl std::error::Error for InvalidIdentifier {}

/// A kind of id's pattern as the check a value is held to: text every value
/// begins with, then characters of one set, a number of them within bounds.
/// The generator refuses a pattern of any other form, rather than link a
/// regular-expression engine into every client for a few rules.
struct Rule {
    prefix: &'static str,
    admitted: Admitted,
    least: usize,
    most: Option<usize>,
}

/// The characters a rule admits after its prefix.
enum Admitted {
    /// `\S`: any but whitespace.
    NotWhitespace,
    /// A set, as its ranges: a single character is a range of one.
    Of(&'static [(char, char)]),
}

impl Rule {
    /// Whether `value` passes the rule.
    fn admits(&self, value: &str) -> bool {
        let Some(value) = value.strip_prefix(self.prefix) else {
            return false;
        };
        let count = value.chars().count();
        count >= self.least
            && self.most.is_none_or(|most| count <= most)
            && value.chars().all(|c| match self.admitted {
                Admitted::NotWhitespace => !c.is_whitespace(),
                Admitted::Of(ranges) => ranges.iter().any(|&(low, high)| (low..=high).contains(&c)),
            })
    }
}
