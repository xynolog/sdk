//! The launcher's control API (`xynolog control`, contract/LAUNCHER-CONTROL.md):
//! each method and each notification as a marker whose associated types are
//! what it carries, and the tables a side that serves them reads by name. A
//! failed request's error data is `crate::types::ErrorData`, and its code a
//! `crate::errors::ControlErrorCode`.

use serde::Serialize;
use serde::de::DeserializeOwned;

/// A method of the control API.
pub trait ControlMethod: 'static {
    /// The method's name on the wire.
    const NAME: &'static str;
    /// Whether a request waits for every other exclusive request to end, and
    /// holds the others off until it does.
    const EXCLUSIVE: bool;
    /// The notifications a request may send besides `notifications/progress`,
    /// which any may.
    const SENDS: &'static [&'static str];
    type Params: Serialize + DeserializeOwned;
    type Result: Serialize + DeserializeOwned;
}

/// A notification of the control API.
pub trait ControlNotification: 'static {
    /// The notification's name on the wire.
    const NAME: &'static str;
    /// Which side sends it.
    const FROM: ControlSender;
    type Params: Serialize + DeserializeOwned;
}

/// A method, by name: what a side that serves the control API reads.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ControlMethodRow {
    pub name: &'static str,
    pub exclusive: bool,
    pub sends: &'static [&'static str],
}

/// A notification, by name.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ControlNotificationRow {
    pub name: &'static str,
    pub from: ControlSender,
}

/// The method named `name`, when the control API has one.
pub fn control_method(name: &str) -> Option<&'static ControlMethodRow> {
    CONTROL_METHODS.iter().find(|method| method.name == name)
}

include!("generated/control.rs");
