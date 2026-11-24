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

/// A property that was stated, whatever it stated: null is `Some(None)`.
fn stated<'de, T: serde::Deserialize<'de>, D: serde::Deserializer<'de>>(
    deserializer: D,
) -> Result<Option<Option<T>>, D::Error> {
    serde::Deserialize::deserialize(deserializer).map(Some)
}
