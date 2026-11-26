//! The knowledge bases a launcher manages, as the launcher publishes them
//! (protocol/specs/src/discovery): what the document says, read whole or not at all,
//! and what changed since it was last read.
//!
//! **Absent is not empty.** `DiscoveryAbsent` is "no launcher was found", with
//! why; `DiscoveryManaged` with no knowledge bases is "the launcher is here and manages
//! nothing". A reader shows the two differently and never has to work out
//! which it has.
//!
//! **A document is read whole.** One of a version this client does not
//! speak, or with an entry that is not what the schema says, is absent: a
//! partial reading would hide a running knowledge base without a trace.
//!
//! **The address is the key.** Entries are told apart by host and port,
//! which the launcher keeps unique. A did is not unique: one knowledge base
//! running in two places is two entries with one did, and each is its own.
//! Two entries at one address cannot both be true, and are named in
//! `duplicated` for a reader to show rather than merged.
//!
//! Where the document is read from is a `DiscoveryTransport`. `text_discovery`
//! is one over any way of getting the text; the HTTP transport crate has
//! one over a URL. Discovery only describes: signing in to a knowledge base
//! it lists is a person's act.

use crate::transport::BoxFuture;
use crate::types::{
    DiscoveredKB, DiscoveryAbsent, DiscoveryAbsentReason, DiscoveryDiff, DiscoveryDocument,
    DiscoveryDocumentVersion, DiscoveryManaged, DiscoveryRead, DiscoveryState,
};
use futures_core::Stream;
use serde_json::Value;
use std::collections::HashMap;
use std::future::Future;
use std::pin::Pin;
use std::sync::Arc;
use std::task::{Context, Poll};
use std::time::Duration;
use tokio::sync::mpsc;
use tokio::task::AbortHandle;

/// How often a launcher's document is read again, unless told otherwise.
pub const DISCOVERY_INTERVAL: Duration = crate::timing::DISCOVERY_INTERVAL;

fn absent(reason: DiscoveryAbsentReason, diagnostic: impl Into<String>) -> DiscoveryState {
    DiscoveryState::DiscoveryAbsent(DiscoveryAbsent {
        diagnostic: Some(diagnostic.into()),
        ..DiscoveryAbsent::new(reason)
    })
}

fn kbs(state: &DiscoveryState) -> &[DiscoveredKB] {
    match state {
        DiscoveryState::DiscoveryManaged(managed) => &managed.kbs,
        DiscoveryState::DiscoveryAbsent(_) => &[],
    }
}

impl From<DiscoveryState> for DiscoveryRead {
    fn from(state: DiscoveryState) -> Self {
        match state {
            DiscoveryState::DiscoveryAbsent(absent) => DiscoveryRead::DiscoveryAbsent(absent),
            DiscoveryState::DiscoveryManaged(managed) => DiscoveryRead::DiscoveryManaged(managed),
        }
    }
}

/// The state a read found: none when it found that nothing changed.
fn found(read: DiscoveryRead) -> Option<DiscoveryState> {
    match read {
        DiscoveryRead::DiscoveryAbsent(absent) => Some(DiscoveryState::DiscoveryAbsent(absent)),
        DiscoveryRead::DiscoveryManaged(managed) => Some(DiscoveryState::DiscoveryManaged(managed)),
        DiscoveryRead::DiscoveryUnchanged(_) => None,
    }
}

/// Where the document is read from.
pub trait DiscoveryTransport: Send + Sync + 'static {
    fn read(&self) -> BoxFuture<'_, DiscoveryRead>;
}

/// The document's text as a state. Every reader goes through this.
pub fn parse_discovery_document(text: &str) -> DiscoveryState {
    use DiscoveryAbsentReason::{Invalid, NotJson, UnsupportedVersion};
    let parsed: Value = match serde_json::from_str(text) {
        Ok(parsed) => parsed,
        Err(error) => return absent(NotJson, error.to_string()),
    };
    if !parsed.is_object() {
        return absent(Invalid, "document is not an object");
    }
    match parsed["version"].as_i64() {
        None => return absent(Invalid, "missing numeric \"version\""),
        Some(DiscoveryDocumentVersion::VALUE) => {}
        Some(other) => {
            return absent(
                UnsupportedVersion,
                format!(
                    "discovery document version {other} is not the one this client speaks ({}); it is not read in part",
                    DiscoveryDocumentVersion::VALUE
                ),
            );
        }
    }
    let document: DiscoveryDocument = match serde_json::from_value(parsed) {
        Ok(document) => document,
        Err(error) => return absent(Invalid, error.to_string()),
    };
    if let Some(kb) = document
        .kbs
        .iter()
        .find(|kb| !(1..=65535).contains(&kb.port))
    {
        return absent(
            Invalid,
            format!(
                "kb entry at {} has port {}, which is not a port",
                kb.host, kb.port
            ),
        );
    }
    DiscoveryState::DiscoveryManaged(DiscoveryManaged::new(document.kbs))
}

struct TextDiscovery<R> {
    read: R,
}

impl<R, Fut> DiscoveryTransport for TextDiscovery<R>
where
    R: Fn() -> Fut + Send + Sync + 'static,
    Fut: Future<Output = Result<Option<String>, String>> + Send + 'static,
{
    fn read(&self) -> BoxFuture<'_, DiscoveryRead> {
        let reading = (self.read)();
        Box::pin(async move {
            match reading.await {
                Err(why) => absent(DiscoveryAbsentReason::Unreadable, why).into(),
                Ok(None) => DiscoveryAbsent::new(DiscoveryAbsentReason::NotFound).into(),
                Ok(Some(text)) => parse_discovery_document(&text).into(),
            }
        })
    }
}

/// A transport over any way of getting the document's text: `read` gives
/// the text, nothing when there is no document, or why it could not be read.
/// Reading the launcher's file is one line in whoever has a file system.
pub fn text_discovery<R, Fut>(read: R) -> impl DiscoveryTransport
where
    R: Fn() -> Fut + Send + Sync + 'static,
    Fut: Future<Output = Result<Option<String>, String>> + Send + 'static,
{
    TextDiscovery { read }
}

fn address(kb: &DiscoveredKB) -> String {
    format!("{}:{}", kb.host, kb.port)
}

/// What changed between `last`, the state last told of, and `next`: `None`
/// when nothing did.
fn diff(last: Option<&DiscoveryState>, next: DiscoveryState) -> Option<DiscoveryDiff> {
    let before_kbs = last.map(kbs).unwrap_or_default();
    let before: HashMap<String, &DiscoveredKB> =
        before_kbs.iter().map(|kb| (address(kb), kb)).collect();
    let after: HashMap<String, &DiscoveredKB> =
        kbs(&next).iter().map(|kb| (address(kb), kb)).collect();

    let mut duplicated: Vec<String> = Vec::new();
    let mut seen: Vec<String> = Vec::new();
    for kb in kbs(&next) {
        let at = address(kb);
        if seen.contains(&at) && !duplicated.contains(&at) {
            duplicated.push(at.clone());
        }
        seen.push(at);
    }

    let added: Vec<DiscoveredKB> = kbs(&next)
        .iter()
        .filter(|kb| !before.contains_key(&address(kb)))
        .cloned()
        .collect();
    let removed: Vec<DiscoveredKB> = before_kbs
        .iter()
        .filter(|kb| !after.contains_key(&address(kb)))
        .cloned()
        .collect();
    let updated: Vec<DiscoveredKB> = kbs(&next)
        .iter()
        .filter(|kb| before.get(&address(kb)).is_some_and(|was| was != kb))
        .cloned()
        .collect();

    let state_changed = match (last, &next) {
        (None, _) => true,
        (Some(DiscoveryState::DiscoveryManaged(_)), DiscoveryState::DiscoveryManaged(_)) => false,
        (Some(DiscoveryState::DiscoveryAbsent(was)), DiscoveryState::DiscoveryAbsent(is)) => {
            was.reason != is.reason
        }
        _ => true,
    };
    (state_changed || !added.is_empty() || !updated.is_empty() || !removed.is_empty()).then_some(
        DiscoveryDiff {
            state: next,
            added,
            updated,
            removed,
            duplicated,
        },
    )
}

/// The changes to a launcher's document, as `subscribe_discovery` reads
/// them. Reading stops when this is dropped.
pub struct DiscoveryDiffs {
    diffs: mpsc::UnboundedReceiver<DiscoveryDiff>,
    reading: AbortHandle,
}

impl DiscoveryDiffs {
    /// The next change; `None` once reading has stopped.
    pub async fn next(&mut self) -> Option<DiscoveryDiff> {
        self.diffs.recv().await
    }
}

impl Stream for DiscoveryDiffs {
    type Item = DiscoveryDiff;

    fn poll_next(mut self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Option<Self::Item>> {
        self.diffs.poll_recv(cx)
    }
}

impl Drop for DiscoveryDiffs {
    fn drop(&mut self) {
        self.reading.abort();
    }
}

/// Read a launcher's document now and then every `interval`, and tell of
/// each change. The first read is always told of. After it, a read that
/// changed nothing is not: only an entry added, changed or removed, and a
/// change of state, which carries every entry it brought or took away. Each
/// call reads on its own. Called inside a Tokio runtime.
pub fn subscribe_discovery(
    transport: Arc<dyn DiscoveryTransport>,
    interval: Duration,
) -> DiscoveryDiffs {
    let (tell, diffs) = mpsc::unbounded_channel();
    let reading = tokio::spawn(async move {
        let mut last: Option<DiscoveryState> = None;
        loop {
            if let Some(state) = found(transport.read().await)
                && let Some(change) = diff(last.as_ref(), state)
            {
                last = Some(change.state.clone());
                if tell.send(change).is_err() {
                    return;
                }
            }
            tokio::time::sleep(interval).await;
        }
    });
    DiscoveryDiffs {
        diffs,
        reading: reading.abort_handle(),
    }
}
