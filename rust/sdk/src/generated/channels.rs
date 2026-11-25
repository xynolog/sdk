// Generated from protocol/specs/src/bus/registry.json; do not edit.
// Regenerate: make generate (codegen/lib/bus/rust.ml)
/// The channels a full client hears globally, which it gives its transport: every operation's result and failure, and the events sent to every client.
pub const BRIDGED_CHANNELS: &[&str] = &[
    "bind:body-updated",
    "bind:body-update-failed",
    "browse:resource-result",
    "browse:resource-failed",
    "browse:resources-result",
    "browse:resources-failed",
    "browse:annotation-result",
    "browse:annotation-failed",
    "browse:annotation-history-result",
    "browse:annotation-history-failed",
    "browse:events-result",
    "browse:events-failed",
    "browse:entity-types-result",
    "browse:entity-types-failed",
    "browse:tag-schemas-result",
    "browse:tag-schemas-failed",
    "browse:engines-result",
    "browse:engines-failed",
    "browse:profiles-result",
    "browse:profiles-failed",
    "browse:kb-result",
    "browse:kb-failed",
    "browse:directory-result",
    "browse:directory-failed",
    "frame:entity-type-add-ok",
    "frame:entity-type-add-failed",
    "frame:tag-schema-add-ok",
    "frame:tag-schema-add-failed",
    "gather:complete",
    "gather:failed",
    "gather:resource-complete",
    "gather:resource-failed",
    "gather:summary-result",
    "gather:summary-failed",
    "gather:referenced-by-result",
    "gather:referenced-by-failed",
    "gather:limits-result",
    "gather:limits-failed",
    "job:created",
    "job:create-failed",
    "job:status-result",
    "job:status-failed",
    "job:limits-result",
    "job:limits-failed",
    "job:cancel-ok",
    "job:cancel-failed",
    "job:claimed",
    "job:claim-failed",
    "mark:create-ok",
    "mark:create-failed",
    "mark:commit-ok",
    "mark:commit-failed",
    "mark:delete-ok",
    "mark:delete-failed",
    "mark:archive-ok",
    "mark:archive-failed",
    "mark:unarchive-ok",
    "mark:unarchive-failed",
    "mark:update-entity-types-ok",
    "mark:update-entity-types-failed",
    "match:search-results",
    "match:search-failed",
    "match:resources-result",
    "match:resources-failed",
    "match:limits-result",
    "match:limits-failed",
    "weave:rebuild-ok",
    "weave:rebuild-failed",
    "smelt:rebuild-anchors-ok",
    "smelt:rebuild-anchors-failed",
    "yield:create-ok",
    "yield:create-failed",
    "yield:clone-persist-ok",
    "yield:clone-persist-failed",
    "yield:update-ok",
    "yield:update-failed",
    "yield:clone-created",
    "yield:clone-create-failed",
    "yield:clone-resource-result",
    "yield:clone-resource-failed",
    "yield:clone-token-generated",
    "yield:clone-token-failed",
    "job:report-progress",
    "job:complete",
    "job:fail",
    "smelt:settled",
    "frame:entity-type-added",
    "frame:tag-schema-added",
    "yield:created",
    "yield:updated",
    "yield:cloned",
    "yield:moved",
    "beckon:focus",
    "beckon:sparkle",
    "bus:resume-gap",
    "browse:resource-open",
    "browse:resource-viewed",
    "session:joined",
    "session:left",
    "browse:click",
];
/// The channels a resource's scope carries: what holding a resource adds to a client's stream.
pub const RESOURCE_SCOPED_CHANNELS: &[&str] = &[
    "mark:body-updated",
    "yield:representation-added",
    "yield:representation-removed",
    "mark:added",
    "mark:removed",
    "mark:entity-tag-added",
    "mark:entity-tag-removed",
    "mark:archived",
    "mark:unarchived",
    "job:started",
    "job:assigned",
    "job:completed",
    "job:failed",
];
/// The field of a relayed frame's payload that carries the trace the frame was published under: a client/types/TraceCarrier.json: W3C's `traceparent` and, when it has one, `tracestate`. A frame the gateway relays over the stream has no headers of its own, so the gateway writes the field on its payload, and a receiver takes it off before the payload is delivered and continues the trace from it. No payload schema declares it, and no subscriber sees it. An emit carries its trace in its request's `traceparent` header, and its payload carries no such field.
pub const TRACE_FIELD: &str = "_trace";
/// The member a gateway stamps a payload's emitter under: no part of what was asked.
pub const USER_FIELD: &str = "_userId";
/// Where a channel sits relative to the hub.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ChannelDirection {
    /// Emitted toward it: an operation's request, or a command.
    Outbound,
    /// Delivered from it: a reply, or an event of an audience.
    Inbound,
    /// Never on the wire.
    InProcess,
}

/// What a subscriber is promised about a frame on a channel when its stream drops (protocol/contract/TRANSPORT-CONTRACT.md § Delivery).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ChannelDelivery {
    /// A recorded event on its resource's scope: what a subscriber missed is sent again.
    Positioned,
    /// The reply to a request, routed to the client that asked, and sent again while it is retained.
    Correlated,
    /// Every other frame. Nothing replays it.
    Passing,
}

/// A channel's attributes.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ChannelAttributes {
    /// The event log keeps it: it is an event of the record.
    pub recorded: bool,
    pub direction: ChannelDirection,
    /// Whether emitting it changes the knowledge base, or only asks it something; absent on a channel nobody emits.
    pub writes: Option<bool>,
    /// Absent exactly when the channel never crosses the wire.
    pub delivery: Option<ChannelDelivery>,
}

/// Each channel's attributes, by its name.
pub const CHANNEL_ATTRIBUTES: &[(&str, ChannelAttributes)] = &[
    (
        "yield:created",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "yield:cloned",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "yield:updated",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "yield:moved",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "yield:representation-added",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Positioned),
        },
    ),
    (
        "yield:representation-removed",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Positioned),
        },
    ),
    (
        "yield:create",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "yield:clone-persist",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "yield:update",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "yield:clone",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "yield:clone-token-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "yield:clone-resource-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "yield:clone-create",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "yield:create-ok",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "yield:create-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "yield:clone-persist-ok",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "yield:clone-persist-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "yield:update-ok",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "yield:update-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "yield:clone-token-generated",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "yield:clone-token-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "yield:clone-resource-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "yield:clone-resource-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "yield:clone-created",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "yield:clone-create-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "mark:added",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Positioned),
        },
    ),
    (
        "mark:removed",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Positioned),
        },
    ),
    (
        "mark:body-updated",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Positioned),
        },
    ),
    (
        "mark:entity-tag-added",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Positioned),
        },
    ),
    (
        "mark:entity-tag-removed",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Positioned),
        },
    ),
    (
        "mark:archived",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Positioned),
        },
    ),
    (
        "mark:unarchived",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Positioned),
        },
    ),
    (
        "mark:create-request",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "mark:delete",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "mark:update-body",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "mark:archive",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "mark:unarchive",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "mark:update-entity-types",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "mark:create-ok",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "mark:create-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "mark:commit",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "mark:commit-ok",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "mark:commit-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "mark:delete-ok",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "mark:delete-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "mark:archive-ok",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "mark:archive-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "mark:unarchive-ok",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "mark:unarchive-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "mark:update-entity-types-ok",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "mark:update-entity-types-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "mark:body-update-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "mark:requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "mark:submit",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "mark:delegate-timeout",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "mark:create-error",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "mark:delete-error",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "bind:body-error",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "frame:entity-type-added",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "frame:tag-schema-added",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "frame:add-entity-type",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "frame:add-tag-schema",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "frame:entity-type-add-ok",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "frame:entity-type-add-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "frame:tag-schema-add-ok",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "frame:tag-schema-add-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "principal:profiled",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "principal:profile",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "bind:initiate",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "bind:update-body",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "bind:body-updated",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "bind:body-update-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "match:search-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "match:search-results",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "match:search-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "match:resources-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "match:resources-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "match:resources-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "match:limits-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "match:limits-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "match:limits-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "gather:requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "gather:complete",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "gather:failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "gather:resource-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "gather:resource-complete",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "gather:resource-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "gather:summary-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "gather:summary-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "gather:summary-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "gather:referenced-by-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "gather:referenced-by-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "gather:referenced-by-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "gather:limits-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "gather:limits-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "gather:limits-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:resource-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "browse:resource-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:resource-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:resources-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "browse:resources-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:resources-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:annotation-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "browse:annotation-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:annotation-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:events-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "browse:events-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:events-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:annotation-history-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "browse:annotation-history-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:annotation-history-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:entity-types-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "browse:entity-types-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:entity-types-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:tag-schemas-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "browse:tag-schemas-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:tag-schemas-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:engines-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "browse:engines-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:engines-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:profiles-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "browse:profiles-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:profiles-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:kb-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "browse:kb-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:kb-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:directory-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "browse:directory-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:directory-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "browse:click",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "browse:resource-open",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "browse:resource-viewed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "browse:entity-type-clicked",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "panel:toggle",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "panel:open",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "panel:close",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "shell:sidebar-toggle",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "tabs:close",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "tabs:reorder",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "nav:link-clicked",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "nav:push",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "nav:external",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "beckon:hover",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "beckon:focus",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "beckon:sparkle",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "job:started",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Positioned),
        },
    ),
    (
        "job:assigned",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Positioned),
        },
    ),
    (
        "job:completed",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Positioned),
        },
    ),
    (
        "job:failed",
        ChannelAttributes {
            recorded: true,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Positioned),
        },
    ),
    (
        "job:start",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "job:assign",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "job:report-progress",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "job:complete",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "job:fail",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "job:checkpoint",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "job:queued",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "job:cancel-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "job:cancel",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "job:limits-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "job:limits-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "job:limits-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "job:status-requested",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(false),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "job:create",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "job:claim",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "job:status-result",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "job:status-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "job:created",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "job:create-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "job:claimed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "job:claim-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "job:cancel-ok",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "job:cancel-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "weave:applied",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "smelt:settled",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "weave:rebuild",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "weave:rebuild-ok",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "weave:rebuild-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "smelt:rebuild-anchors",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Outbound,
            writes: Some(true),
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "smelt:rebuild-anchors-ok",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "smelt:rebuild-anchors-failed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Correlated),
        },
    ),
    (
        "settings:theme-changed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "settings:line-numbers-toggled",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "settings:locale-changed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "settings:hover-delay-changed",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::InProcess,
            writes: None,
            delivery: None,
        },
    ),
    (
        "bus:resume-gap",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "session:joined",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
    (
        "session:left",
        ChannelAttributes {
            recorded: false,
            direction: ChannelDirection::Inbound,
            writes: None,
            delivery: Some(ChannelDelivery::Passing),
        },
    ),
];
/// `yield:created`
pub struct YieldCreated;
impl Channel for YieldCreated {
    const NAME: &'static str = "yield:created";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Unscoped for YieldCreated {}
impl Recorded for YieldCreated {
    type Event = crate::types::ResourceCreatedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `yield:cloned`
pub struct YieldCloned;
impl Channel for YieldCloned {
    const NAME: &'static str = "yield:cloned";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Unscoped for YieldCloned {}
impl Recorded for YieldCloned {
    type Event = crate::types::ResourceClonedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `yield:updated`
pub struct YieldUpdated;
impl Channel for YieldUpdated {
    const NAME: &'static str = "yield:updated";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Unscoped for YieldUpdated {}
impl Recorded for YieldUpdated {
    type Event = crate::types::ResourceUpdatedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `yield:moved`
pub struct YieldMoved;
impl Channel for YieldMoved {
    const NAME: &'static str = "yield:moved";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Unscoped for YieldMoved {}
impl Recorded for YieldMoved {
    type Event = crate::types::ResourceMovedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `yield:representation-added`
pub struct YieldRepresentationAdded;
impl Channel for YieldRepresentationAdded {
    const NAME: &'static str = "yield:representation-added";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Scoped for YieldRepresentationAdded {}
impl Recorded for YieldRepresentationAdded {
    type Event = crate::types::RepresentationAddedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `yield:representation-removed`
pub struct YieldRepresentationRemoved;
impl Channel for YieldRepresentationRemoved {
    const NAME: &'static str = "yield:representation-removed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Scoped for YieldRepresentationRemoved {}
impl Recorded for YieldRepresentationRemoved {
    type Event = crate::types::RepresentationRemovedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `yield:create`
pub struct YieldCreate;
impl Channel for YieldCreate {
    const NAME: &'static str = "yield:create";
    const STAMPS: &'static [&'static str] = &["_roles", "_userId"];
    type Payload = crate::types::YieldCreateCommand;
}
impl Unscoped for YieldCreate {}
/// `yield:clone-persist`
pub struct YieldClonePersist;
impl Channel for YieldClonePersist {
    const NAME: &'static str = "yield:clone-persist";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::YieldClonePersistCommand;
}
impl Unscoped for YieldClonePersist {}
/// `yield:update`
pub struct YieldUpdate;
impl Channel for YieldUpdate {
    const NAME: &'static str = "yield:update";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::YieldUpdateCommand;
}
impl Unscoped for YieldUpdate {}
/// `yield:clone`
pub struct YieldClone;
impl Channel for YieldClone {
    const NAME: &'static str = "yield:clone";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = Empty;
}
impl Unscoped for YieldClone {}
/// `yield:clone-token-requested`
pub struct YieldCloneTokenRequested;
impl Channel for YieldCloneTokenRequested {
    const NAME: &'static str = "yield:clone-token-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::YieldCloneTokenRequest;
}
impl Unscoped for YieldCloneTokenRequested {}
/// `yield:clone-resource-requested`
pub struct YieldCloneResourceRequested;
impl Channel for YieldCloneResourceRequested {
    const NAME: &'static str = "yield:clone-resource-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::YieldCloneResourceRequest;
}
impl Unscoped for YieldCloneResourceRequested {}
/// `yield:clone-create`
pub struct YieldCloneCreate;
impl Channel for YieldCloneCreate {
    const NAME: &'static str = "yield:clone-create";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::YieldCloneCreateCommand;
}
impl Unscoped for YieldCloneCreate {}
/// `yield:create-ok`
pub struct YieldCreateOk;
impl Channel for YieldCreateOk {
    const NAME: &'static str = "yield:create-ok";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::YieldCreateOk;
}
impl Unscoped for YieldCreateOk {}
/// `yield:create-failed`
pub struct YieldCreateFailed;
impl Channel for YieldCreateFailed {
    const NAME: &'static str = "yield:create-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for YieldCreateFailed {}
/// `yield:clone-persist-ok`
pub struct YieldClonePersistOk;
impl Channel for YieldClonePersistOk {
    const NAME: &'static str = "yield:clone-persist-ok";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::YieldClonePersistOk;
}
impl Unscoped for YieldClonePersistOk {}
/// `yield:clone-persist-failed`
pub struct YieldClonePersistFailed;
impl Channel for YieldClonePersistFailed {
    const NAME: &'static str = "yield:clone-persist-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for YieldClonePersistFailed {}
/// `yield:update-ok`
pub struct YieldUpdateOk;
impl Channel for YieldUpdateOk {
    const NAME: &'static str = "yield:update-ok";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::YieldUpdateOk;
}
impl Unscoped for YieldUpdateOk {}
/// `yield:update-failed`
pub struct YieldUpdateFailed;
impl Channel for YieldUpdateFailed {
    const NAME: &'static str = "yield:update-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for YieldUpdateFailed {}
/// `yield:clone-token-generated`
pub struct YieldCloneTokenGenerated;
impl Channel for YieldCloneTokenGenerated {
    const NAME: &'static str = "yield:clone-token-generated";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = Response<crate::types::CloneResourceWithTokenResponse>;
}
impl Unscoped for YieldCloneTokenGenerated {}
/// `yield:clone-token-failed`
pub struct YieldCloneTokenFailed;
impl Channel for YieldCloneTokenFailed {
    const NAME: &'static str = "yield:clone-token-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for YieldCloneTokenFailed {}
/// `yield:clone-resource-result`
pub struct YieldCloneResourceResult;
impl Channel for YieldCloneResourceResult {
    const NAME: &'static str = "yield:clone-resource-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = Response<crate::types::GetResourceByTokenResponse>;
}
impl Unscoped for YieldCloneResourceResult {}
/// `yield:clone-resource-failed`
pub struct YieldCloneResourceFailed;
impl Channel for YieldCloneResourceFailed {
    const NAME: &'static str = "yield:clone-resource-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for YieldCloneResourceFailed {}
/// `yield:clone-created`
pub struct YieldCloneCreated;
impl Channel for YieldCloneCreated {
    const NAME: &'static str = "yield:clone-created";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::YieldCloneCreated;
}
impl Unscoped for YieldCloneCreated {}
/// `yield:clone-create-failed`
pub struct YieldCloneCreateFailed;
impl Channel for YieldCloneCreateFailed {
    const NAME: &'static str = "yield:clone-create-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for YieldCloneCreateFailed {}
/// `mark:added`
pub struct MarkAdded;
impl Channel for MarkAdded {
    const NAME: &'static str = "mark:added";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::EnrichedResourceEvent;
}
impl Scoped for MarkAdded {}
impl Recorded for MarkAdded {
    type Event = crate::types::AnnotationAddedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `mark:removed`
pub struct MarkRemoved;
impl Channel for MarkRemoved {
    const NAME: &'static str = "mark:removed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Scoped for MarkRemoved {}
impl Recorded for MarkRemoved {
    type Event = crate::types::AnnotationRemovedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `mark:body-updated`
pub struct MarkBodyUpdated;
impl Channel for MarkBodyUpdated {
    const NAME: &'static str = "mark:body-updated";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::EnrichedResourceEvent;
}
impl Scoped for MarkBodyUpdated {}
impl Recorded for MarkBodyUpdated {
    type Event = crate::types::AnnotationBodyUpdatedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `mark:entity-tag-added`
pub struct MarkEntityTagAdded;
impl Channel for MarkEntityTagAdded {
    const NAME: &'static str = "mark:entity-tag-added";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Scoped for MarkEntityTagAdded {}
impl Recorded for MarkEntityTagAdded {
    type Event = crate::types::EntityTagChangedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `mark:entity-tag-removed`
pub struct MarkEntityTagRemoved;
impl Channel for MarkEntityTagRemoved {
    const NAME: &'static str = "mark:entity-tag-removed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Scoped for MarkEntityTagRemoved {}
impl Recorded for MarkEntityTagRemoved {
    type Event = crate::types::EntityTagChangedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `mark:archived`
pub struct MarkArchived;
impl Channel for MarkArchived {
    const NAME: &'static str = "mark:archived";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Scoped for MarkArchived {}
impl Recorded for MarkArchived {
    type Event = crate::types::ResourceArchivedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `mark:unarchived`
pub struct MarkUnarchived;
impl Channel for MarkUnarchived {
    const NAME: &'static str = "mark:unarchived";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Scoped for MarkUnarchived {}
impl Recorded for MarkUnarchived {
    type Event = crate::types::ResourceUnarchivedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `mark:create-request`
pub struct MarkCreateRequest;
impl Channel for MarkCreateRequest {
    const NAME: &'static str = "mark:create-request";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::MarkCreateRequest;
}
impl Unscoped for MarkCreateRequest {}
/// `mark:delete`
pub struct MarkDelete;
impl Channel for MarkDelete {
    const NAME: &'static str = "mark:delete";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::MarkDeleteCommand;
}
impl Unscoped for MarkDelete {}
/// `mark:update-body`
pub struct MarkUpdateBody;
impl Channel for MarkUpdateBody {
    const NAME: &'static str = "mark:update-body";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::MarkUpdateBodyCommand;
}
impl Unscoped for MarkUpdateBody {}
/// `mark:archive`
pub struct MarkArchive;
impl Channel for MarkArchive {
    const NAME: &'static str = "mark:archive";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::MarkArchiveCommand;
}
impl Unscoped for MarkArchive {}
/// `mark:unarchive`
pub struct MarkUnarchive;
impl Channel for MarkUnarchive {
    const NAME: &'static str = "mark:unarchive";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::MarkUnarchiveCommand;
}
impl Unscoped for MarkUnarchive {}
/// `mark:update-entity-types`
pub struct MarkUpdateEntityTypes;
impl Channel for MarkUpdateEntityTypes {
    const NAME: &'static str = "mark:update-entity-types";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::MarkUpdateEntityTypesCommand;
}
impl Unscoped for MarkUpdateEntityTypes {}
/// `mark:create-ok`
pub struct MarkCreateOk;
impl Channel for MarkCreateOk {
    const NAME: &'static str = "mark:create-ok";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::MarkCreateOk;
}
impl Unscoped for MarkCreateOk {}
/// `mark:create-failed`
pub struct MarkCreateFailed;
impl Channel for MarkCreateFailed {
    const NAME: &'static str = "mark:create-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for MarkCreateFailed {}
/// `mark:commit`
pub struct MarkCommit;
impl Channel for MarkCommit {
    const NAME: &'static str = "mark:commit";
    const STAMPS: &'static [&'static str] = &["_roles", "_userId"];
    type Payload = crate::types::MarkCommitCommand;
}
impl Unscoped for MarkCommit {}
/// `mark:commit-ok`
pub struct MarkCommitOk;
impl Channel for MarkCommitOk {
    const NAME: &'static str = "mark:commit-ok";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::MarkCommitOk;
}
impl Unscoped for MarkCommitOk {}
/// `mark:commit-failed`
pub struct MarkCommitFailed;
impl Channel for MarkCommitFailed {
    const NAME: &'static str = "mark:commit-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for MarkCommitFailed {}
/// `mark:delete-ok`
pub struct MarkDeleteOk;
impl Channel for MarkDeleteOk {
    const NAME: &'static str = "mark:delete-ok";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::MarkDeleteOk;
}
impl Unscoped for MarkDeleteOk {}
/// `mark:delete-failed`
pub struct MarkDeleteFailed;
impl Channel for MarkDeleteFailed {
    const NAME: &'static str = "mark:delete-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for MarkDeleteFailed {}
/// `mark:archive-ok`
pub struct MarkArchiveOk;
impl Channel for MarkArchiveOk {
    const NAME: &'static str = "mark:archive-ok";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = Empty;
}
impl Unscoped for MarkArchiveOk {}
/// `mark:archive-failed`
pub struct MarkArchiveFailed;
impl Channel for MarkArchiveFailed {
    const NAME: &'static str = "mark:archive-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for MarkArchiveFailed {}
/// `mark:unarchive-ok`
pub struct MarkUnarchiveOk;
impl Channel for MarkUnarchiveOk {
    const NAME: &'static str = "mark:unarchive-ok";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = Empty;
}
impl Unscoped for MarkUnarchiveOk {}
/// `mark:unarchive-failed`
pub struct MarkUnarchiveFailed;
impl Channel for MarkUnarchiveFailed {
    const NAME: &'static str = "mark:unarchive-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for MarkUnarchiveFailed {}
/// `mark:update-entity-types-ok`
pub struct MarkUpdateEntityTypesOk;
impl Channel for MarkUpdateEntityTypesOk {
    const NAME: &'static str = "mark:update-entity-types-ok";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = Empty;
}
impl Unscoped for MarkUpdateEntityTypesOk {}
/// `mark:update-entity-types-failed`
pub struct MarkUpdateEntityTypesFailed;
impl Channel for MarkUpdateEntityTypesFailed {
    const NAME: &'static str = "mark:update-entity-types-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for MarkUpdateEntityTypesFailed {}
/// `mark:body-update-failed`
pub struct MarkBodyUpdateFailed;
impl Channel for MarkBodyUpdateFailed {
    const NAME: &'static str = "mark:body-update-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for MarkBodyUpdateFailed {}
/// `mark:requested`
pub struct MarkRequested;
impl Channel for MarkRequested {
    const NAME: &'static str = "mark:requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::MarkRequestedEvent;
}
impl Unscoped for MarkRequested {}
/// `mark:submit`
pub struct MarkSubmit;
impl Channel for MarkSubmit {
    const NAME: &'static str = "mark:submit";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::MarkSubmitEvent;
}
impl Unscoped for MarkSubmit {}
/// `mark:delegate-timeout`
pub struct MarkDelegateTimeout;
impl Channel for MarkDelegateTimeout {
    const NAME: &'static str = "mark:delegate-timeout";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::MarkDelegateTimeoutEvent;
}
impl Unscoped for MarkDelegateTimeout {}
/// `mark:create-error`
pub struct MarkCreateError;
impl Channel for MarkCreateError {
    const NAME: &'static str = "mark:create-error";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::ResourceErrorEvent;
}
impl Unscoped for MarkCreateError {}
/// `mark:delete-error`
pub struct MarkDeleteError;
impl Channel for MarkDeleteError {
    const NAME: &'static str = "mark:delete-error";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::ResourceErrorEvent;
}
impl Unscoped for MarkDeleteError {}
/// `bind:body-error`
pub struct BindBodyError;
impl Channel for BindBodyError {
    const NAME: &'static str = "bind:body-error";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::ResourceErrorEvent;
}
impl Unscoped for BindBodyError {}
/// `frame:entity-type-added`
pub struct FrameEntityTypeAdded;
impl Channel for FrameEntityTypeAdded {
    const NAME: &'static str = "frame:entity-type-added";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Unscoped for FrameEntityTypeAdded {}
impl Recorded for FrameEntityTypeAdded {
    type Event = crate::types::EntityTypeAddedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `frame:tag-schema-added`
pub struct FrameTagSchemaAdded;
impl Channel for FrameTagSchemaAdded {
    const NAME: &'static str = "frame:tag-schema-added";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Unscoped for FrameTagSchemaAdded {}
impl Recorded for FrameTagSchemaAdded {
    type Event = crate::types::TagSchemaAddedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `frame:add-entity-type`
pub struct FrameAddEntityType;
impl Channel for FrameAddEntityType {
    const NAME: &'static str = "frame:add-entity-type";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::FrameAddEntityTypeCommand;
}
impl Unscoped for FrameAddEntityType {}
/// `frame:add-tag-schema`
pub struct FrameAddTagSchema;
impl Channel for FrameAddTagSchema {
    const NAME: &'static str = "frame:add-tag-schema";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::FrameAddTagSchemaCommand;
}
impl Unscoped for FrameAddTagSchema {}
/// `frame:entity-type-add-ok`
pub struct FrameEntityTypeAddOk;
impl Channel for FrameEntityTypeAddOk {
    const NAME: &'static str = "frame:entity-type-add-ok";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = Empty;
}
impl Unscoped for FrameEntityTypeAddOk {}
/// `frame:entity-type-add-failed`
pub struct FrameEntityTypeAddFailed;
impl Channel for FrameEntityTypeAddFailed {
    const NAME: &'static str = "frame:entity-type-add-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for FrameEntityTypeAddFailed {}
/// `frame:tag-schema-add-ok`
pub struct FrameTagSchemaAddOk;
impl Channel for FrameTagSchemaAddOk {
    const NAME: &'static str = "frame:tag-schema-add-ok";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = Empty;
}
impl Unscoped for FrameTagSchemaAddOk {}
/// `frame:tag-schema-add-failed`
pub struct FrameTagSchemaAddFailed;
impl Channel for FrameTagSchemaAddFailed {
    const NAME: &'static str = "frame:tag-schema-add-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for FrameTagSchemaAddFailed {}
/// `principal:profiled`
pub struct PrincipalProfiled;
impl Channel for PrincipalProfiled {
    const NAME: &'static str = "principal:profiled";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Unscoped for PrincipalProfiled {}
impl Recorded for PrincipalProfiled {
    type Event = crate::types::PrincipalProfiledPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `principal:profile`
pub struct PrincipalProfile;
impl Channel for PrincipalProfile {
    const NAME: &'static str = "principal:profile";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::PrincipalProfileCommand;
}
impl Unscoped for PrincipalProfile {}
/// `bind:initiate`
pub struct BindInitiate;
impl Channel for BindInitiate {
    const NAME: &'static str = "bind:initiate";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BindInitiateCommand;
}
impl Unscoped for BindInitiate {}
/// `bind:update-body`
pub struct BindUpdateBody;
impl Channel for BindUpdateBody {
    const NAME: &'static str = "bind:update-body";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::BindUpdateBodyCommand;
}
impl Unscoped for BindUpdateBody {}
/// `bind:body-updated`
pub struct BindBodyUpdated;
impl Channel for BindBodyUpdated {
    const NAME: &'static str = "bind:body-updated";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BindBodyUpdated;
}
impl Unscoped for BindBodyUpdated {}
/// `bind:body-update-failed`
pub struct BindBodyUpdateFailed;
impl Channel for BindBodyUpdateFailed {
    const NAME: &'static str = "bind:body-update-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for BindBodyUpdateFailed {}
/// `match:search-requested`
pub struct MatchSearchRequested;
impl Channel for MatchSearchRequested {
    const NAME: &'static str = "match:search-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::MatchSearchRequest;
}
impl Unscoped for MatchSearchRequested {}
/// `match:search-results`
pub struct MatchSearchResults;
impl Channel for MatchSearchResults {
    const NAME: &'static str = "match:search-results";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::MatchSearchResult;
}
impl Unscoped for MatchSearchResults {}
/// `match:search-failed`
pub struct MatchSearchFailed;
impl Channel for MatchSearchFailed {
    const NAME: &'static str = "match:search-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::MatchSearchFailed;
}
impl Unscoped for MatchSearchFailed {}
/// `match:resources-requested`
pub struct MatchResourcesRequested;
impl Channel for MatchResourcesRequested {
    const NAME: &'static str = "match:resources-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::MatchResourcesRequest;
}
impl Unscoped for MatchResourcesRequested {}
/// `match:resources-result`
pub struct MatchResourcesResult;
impl Channel for MatchResourcesResult {
    const NAME: &'static str = "match:resources-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::MatchResourcesResult;
}
impl Unscoped for MatchResourcesResult {}
/// `match:resources-failed`
pub struct MatchResourcesFailed;
impl Channel for MatchResourcesFailed {
    const NAME: &'static str = "match:resources-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for MatchResourcesFailed {}
/// `match:limits-requested`
pub struct MatchLimitsRequested;
impl Channel for MatchLimitsRequested {
    const NAME: &'static str = "match:limits-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::InferenceLimitsRequest;
}
impl Unscoped for MatchLimitsRequested {}
/// `match:limits-result`
pub struct MatchLimitsResult;
impl Channel for MatchLimitsResult {
    const NAME: &'static str = "match:limits-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::InferenceLimitsResult;
}
impl Unscoped for MatchLimitsResult {}
/// `match:limits-failed`
pub struct MatchLimitsFailed;
impl Channel for MatchLimitsFailed {
    const NAME: &'static str = "match:limits-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for MatchLimitsFailed {}
/// `gather:requested`
pub struct GatherRequested;
impl Channel for GatherRequested {
    const NAME: &'static str = "gather:requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::GatherAnnotationRequest;
}
impl Unscoped for GatherRequested {}
/// `gather:complete`
pub struct GatherComplete;
impl Channel for GatherComplete {
    const NAME: &'static str = "gather:complete";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::GatherAnnotationComplete;
}
impl Unscoped for GatherComplete {}
/// `gather:failed`
pub struct GatherFailed;
impl Channel for GatherFailed {
    const NAME: &'static str = "gather:failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::GatherFailed;
}
impl Unscoped for GatherFailed {}
/// `gather:resource-requested`
pub struct GatherResourceRequested;
impl Channel for GatherResourceRequested {
    const NAME: &'static str = "gather:resource-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::GatherResourceRequest;
}
impl Unscoped for GatherResourceRequested {}
/// `gather:resource-complete`
pub struct GatherResourceComplete;
impl Channel for GatherResourceComplete {
    const NAME: &'static str = "gather:resource-complete";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::GatherResourceComplete;
}
impl Unscoped for GatherResourceComplete {}
/// `gather:resource-failed`
pub struct GatherResourceFailed;
impl Channel for GatherResourceFailed {
    const NAME: &'static str = "gather:resource-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::GatherResourceFailed;
}
impl Unscoped for GatherResourceFailed {}
/// `gather:summary-requested`
pub struct GatherSummaryRequested;
impl Channel for GatherSummaryRequested {
    const NAME: &'static str = "gather:summary-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::GatherSummaryRequest;
}
impl Unscoped for GatherSummaryRequested {}
/// `gather:summary-result`
pub struct GatherSummaryResult;
impl Channel for GatherSummaryResult {
    const NAME: &'static str = "gather:summary-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = Response<crate::types::ContextualSummaryResponse>;
}
impl Unscoped for GatherSummaryResult {}
/// `gather:summary-failed`
pub struct GatherSummaryFailed;
impl Channel for GatherSummaryFailed {
    const NAME: &'static str = "gather:summary-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for GatherSummaryFailed {}
/// `gather:referenced-by-requested`
pub struct GatherReferencedByRequested;
impl Channel for GatherReferencedByRequested {
    const NAME: &'static str = "gather:referenced-by-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::GatherReferencedByRequest;
}
impl Unscoped for GatherReferencedByRequested {}
/// `gather:referenced-by-result`
pub struct GatherReferencedByResult;
impl Channel for GatherReferencedByResult {
    const NAME: &'static str = "gather:referenced-by-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::GatherReferencedByResult;
}
impl Unscoped for GatherReferencedByResult {}
/// `gather:referenced-by-failed`
pub struct GatherReferencedByFailed;
impl Channel for GatherReferencedByFailed {
    const NAME: &'static str = "gather:referenced-by-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for GatherReferencedByFailed {}
/// `gather:limits-requested`
pub struct GatherLimitsRequested;
impl Channel for GatherLimitsRequested {
    const NAME: &'static str = "gather:limits-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::InferenceLimitsRequest;
}
impl Unscoped for GatherLimitsRequested {}
/// `gather:limits-result`
pub struct GatherLimitsResult;
impl Channel for GatherLimitsResult {
    const NAME: &'static str = "gather:limits-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::InferenceLimitsResult;
}
impl Unscoped for GatherLimitsResult {}
/// `gather:limits-failed`
pub struct GatherLimitsFailed;
impl Channel for GatherLimitsFailed {
    const NAME: &'static str = "gather:limits-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for GatherLimitsFailed {}
/// `browse:resource-requested`
pub struct BrowseResourceRequested;
impl Channel for BrowseResourceRequested {
    const NAME: &'static str = "browse:resource-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseResourceRequest;
}
impl Unscoped for BrowseResourceRequested {}
/// `browse:resource-result`
pub struct BrowseResourceResult;
impl Channel for BrowseResourceResult {
    const NAME: &'static str = "browse:resource-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseResourceResult;
}
impl Unscoped for BrowseResourceResult {}
/// `browse:resource-failed`
pub struct BrowseResourceFailed;
impl Channel for BrowseResourceFailed {
    const NAME: &'static str = "browse:resource-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for BrowseResourceFailed {}
/// `browse:resources-requested`
pub struct BrowseResourcesRequested;
impl Channel for BrowseResourcesRequested {
    const NAME: &'static str = "browse:resources-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseResourcesRequest;
}
impl Unscoped for BrowseResourcesRequested {}
/// `browse:resources-result`
pub struct BrowseResourcesResult;
impl Channel for BrowseResourcesResult {
    const NAME: &'static str = "browse:resources-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseResourcesResult;
}
impl Unscoped for BrowseResourcesResult {}
/// `browse:resources-failed`
pub struct BrowseResourcesFailed;
impl Channel for BrowseResourcesFailed {
    const NAME: &'static str = "browse:resources-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for BrowseResourcesFailed {}
/// `browse:annotation-requested`
pub struct BrowseAnnotationRequested;
impl Channel for BrowseAnnotationRequested {
    const NAME: &'static str = "browse:annotation-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseAnnotationRequest;
}
impl Unscoped for BrowseAnnotationRequested {}
/// `browse:annotation-result`
pub struct BrowseAnnotationResult;
impl Channel for BrowseAnnotationResult {
    const NAME: &'static str = "browse:annotation-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseAnnotationResult;
}
impl Unscoped for BrowseAnnotationResult {}
/// `browse:annotation-failed`
pub struct BrowseAnnotationFailed;
impl Channel for BrowseAnnotationFailed {
    const NAME: &'static str = "browse:annotation-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for BrowseAnnotationFailed {}
/// `browse:events-requested`
pub struct BrowseEventsRequested;
impl Channel for BrowseEventsRequested {
    const NAME: &'static str = "browse:events-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseEventsRequest;
}
impl Unscoped for BrowseEventsRequested {}
/// `browse:events-result`
pub struct BrowseEventsResult;
impl Channel for BrowseEventsResult {
    const NAME: &'static str = "browse:events-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseEventsResult;
}
impl Unscoped for BrowseEventsResult {}
/// `browse:events-failed`
pub struct BrowseEventsFailed;
impl Channel for BrowseEventsFailed {
    const NAME: &'static str = "browse:events-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for BrowseEventsFailed {}
/// `browse:annotation-history-requested`
pub struct BrowseAnnotationHistoryRequested;
impl Channel for BrowseAnnotationHistoryRequested {
    const NAME: &'static str = "browse:annotation-history-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseAnnotationHistoryRequest;
}
impl Unscoped for BrowseAnnotationHistoryRequested {}
/// `browse:annotation-history-result`
pub struct BrowseAnnotationHistoryResult;
impl Channel for BrowseAnnotationHistoryResult {
    const NAME: &'static str = "browse:annotation-history-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseAnnotationHistoryResult;
}
impl Unscoped for BrowseAnnotationHistoryResult {}
/// `browse:annotation-history-failed`
pub struct BrowseAnnotationHistoryFailed;
impl Channel for BrowseAnnotationHistoryFailed {
    const NAME: &'static str = "browse:annotation-history-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for BrowseAnnotationHistoryFailed {}
/// `browse:entity-types-requested`
pub struct BrowseEntityTypesRequested;
impl Channel for BrowseEntityTypesRequested {
    const NAME: &'static str = "browse:entity-types-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseEntityTypesRequest;
}
impl Unscoped for BrowseEntityTypesRequested {}
/// `browse:entity-types-result`
pub struct BrowseEntityTypesResult;
impl Channel for BrowseEntityTypesResult {
    const NAME: &'static str = "browse:entity-types-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseEntityTypesResult;
}
impl Unscoped for BrowseEntityTypesResult {}
/// `browse:entity-types-failed`
pub struct BrowseEntityTypesFailed;
impl Channel for BrowseEntityTypesFailed {
    const NAME: &'static str = "browse:entity-types-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for BrowseEntityTypesFailed {}
/// `browse:tag-schemas-requested`
pub struct BrowseTagSchemasRequested;
impl Channel for BrowseTagSchemasRequested {
    const NAME: &'static str = "browse:tag-schemas-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseTagSchemasRequest;
}
impl Unscoped for BrowseTagSchemasRequested {}
/// `browse:tag-schemas-result`
pub struct BrowseTagSchemasResult;
impl Channel for BrowseTagSchemasResult {
    const NAME: &'static str = "browse:tag-schemas-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseTagSchemasResult;
}
impl Unscoped for BrowseTagSchemasResult {}
/// `browse:tag-schemas-failed`
pub struct BrowseTagSchemasFailed;
impl Channel for BrowseTagSchemasFailed {
    const NAME: &'static str = "browse:tag-schemas-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for BrowseTagSchemasFailed {}
/// `browse:engines-requested`
pub struct BrowseEnginesRequested;
impl Channel for BrowseEnginesRequested {
    const NAME: &'static str = "browse:engines-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseEnginesRequest;
}
impl Unscoped for BrowseEnginesRequested {}
/// `browse:engines-result`
pub struct BrowseEnginesResult;
impl Channel for BrowseEnginesResult {
    const NAME: &'static str = "browse:engines-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseEnginesResult;
}
impl Unscoped for BrowseEnginesResult {}
/// `browse:engines-failed`
pub struct BrowseEnginesFailed;
impl Channel for BrowseEnginesFailed {
    const NAME: &'static str = "browse:engines-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for BrowseEnginesFailed {}
/// `browse:profiles-requested`
pub struct BrowseProfilesRequested;
impl Channel for BrowseProfilesRequested {
    const NAME: &'static str = "browse:profiles-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseProfilesRequest;
}
impl Unscoped for BrowseProfilesRequested {}
/// `browse:profiles-result`
pub struct BrowseProfilesResult;
impl Channel for BrowseProfilesResult {
    const NAME: &'static str = "browse:profiles-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseProfilesResult;
}
impl Unscoped for BrowseProfilesResult {}
/// `browse:profiles-failed`
pub struct BrowseProfilesFailed;
impl Channel for BrowseProfilesFailed {
    const NAME: &'static str = "browse:profiles-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for BrowseProfilesFailed {}
/// `browse:kb-requested`
pub struct BrowseKbRequested;
impl Channel for BrowseKbRequested {
    const NAME: &'static str = "browse:kb-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseKbRequest;
}
impl Unscoped for BrowseKbRequested {}
/// `browse:kb-result`
pub struct BrowseKbResult;
impl Channel for BrowseKbResult {
    const NAME: &'static str = "browse:kb-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseKbResult;
}
impl Unscoped for BrowseKbResult {}
/// `browse:kb-failed`
pub struct BrowseKbFailed;
impl Channel for BrowseKbFailed {
    const NAME: &'static str = "browse:kb-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for BrowseKbFailed {}
/// `browse:directory-requested`
pub struct BrowseDirectoryRequested;
impl Channel for BrowseDirectoryRequested {
    const NAME: &'static str = "browse:directory-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseDirectoryRequest;
}
impl Unscoped for BrowseDirectoryRequested {}
/// `browse:directory-result`
pub struct BrowseDirectoryResult;
impl Channel for BrowseDirectoryResult {
    const NAME: &'static str = "browse:directory-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseDirectoryResult;
}
impl Unscoped for BrowseDirectoryResult {}
/// `browse:directory-failed`
pub struct BrowseDirectoryFailed;
impl Channel for BrowseDirectoryFailed {
    const NAME: &'static str = "browse:directory-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseDirectoryFailed;
}
impl Unscoped for BrowseDirectoryFailed {}
/// `browse:click`
pub struct BrowseClick;
impl Channel for BrowseClick {
    const NAME: &'static str = "browse:click";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseClickEvent;
}
impl Unscoped for BrowseClick {}
/// `browse:resource-open`
pub struct BrowseResourceOpen;
impl Channel for BrowseResourceOpen {
    const NAME: &'static str = "browse:resource-open";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseResourceOpenEvent;
}
impl Unscoped for BrowseResourceOpen {}
/// `browse:resource-viewed`
pub struct BrowseResourceViewed;
impl Channel for BrowseResourceViewed {
    const NAME: &'static str = "browse:resource-viewed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseResourceViewedEvent;
}
impl Unscoped for BrowseResourceViewed {}
/// `browse:entity-type-clicked`
pub struct BrowseEntityTypeClicked;
impl Channel for BrowseEntityTypeClicked {
    const NAME: &'static str = "browse:entity-type-clicked";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseEntityTypeClickedEvent;
}
impl Unscoped for BrowseEntityTypeClicked {}
/// `panel:toggle`
pub struct PanelToggle;
impl Channel for PanelToggle {
    const NAME: &'static str = "panel:toggle";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowsePanelToggleEvent;
}
impl Unscoped for PanelToggle {}
/// `panel:open`
pub struct PanelOpen;
impl Channel for PanelOpen {
    const NAME: &'static str = "panel:open";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowsePanelOpenEvent;
}
impl Unscoped for PanelOpen {}
/// `panel:close`
pub struct PanelClose;
impl Channel for PanelClose {
    const NAME: &'static str = "panel:close";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = Empty;
}
impl Unscoped for PanelClose {}
/// `shell:sidebar-toggle`
pub struct ShellSidebarToggle;
impl Channel for ShellSidebarToggle {
    const NAME: &'static str = "shell:sidebar-toggle";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = Empty;
}
impl Unscoped for ShellSidebarToggle {}
/// `tabs:close`
pub struct TabsClose;
impl Channel for TabsClose {
    const NAME: &'static str = "tabs:close";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseResourceCloseEvent;
}
impl Unscoped for TabsClose {}
/// `tabs:reorder`
pub struct TabsReorder;
impl Channel for TabsReorder {
    const NAME: &'static str = "tabs:reorder";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseResourceReorderEvent;
}
impl Unscoped for TabsReorder {}
/// `nav:link-clicked`
pub struct NavLinkClicked;
impl Channel for NavLinkClicked {
    const NAME: &'static str = "nav:link-clicked";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseLinkClickedEvent;
}
impl Unscoped for NavLinkClicked {}
/// `nav:push`
pub struct NavPush;
impl Channel for NavPush {
    const NAME: &'static str = "nav:push";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseRouterPushEvent;
}
impl Unscoped for NavPush {}
/// `nav:external`
pub struct NavExternal;
impl Channel for NavExternal {
    const NAME: &'static str = "nav:external";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BrowseExternalNavigateEvent;
}
impl Unscoped for NavExternal {}
/// `beckon:hover`
pub struct BeckonHover;
impl Channel for BeckonHover {
    const NAME: &'static str = "beckon:hover";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BeckonHoverEvent;
}
impl Unscoped for BeckonHover {}
/// `beckon:focus`
pub struct BeckonFocus;
impl Channel for BeckonFocus {
    const NAME: &'static str = "beckon:focus";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BeckonFocusEvent;
}
impl Unscoped for BeckonFocus {}
/// `beckon:sparkle`
pub struct BeckonSparkle;
impl Channel for BeckonSparkle {
    const NAME: &'static str = "beckon:sparkle";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BeckonSparkleEvent;
}
impl Unscoped for BeckonSparkle {}
/// `job:started`
pub struct JobStarted;
impl Channel for JobStarted {
    const NAME: &'static str = "job:started";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Scoped for JobStarted {}
impl Recorded for JobStarted {
    type Event = crate::types::JobStartedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `job:assigned`
pub struct JobAssigned;
impl Channel for JobAssigned {
    const NAME: &'static str = "job:assigned";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Scoped for JobAssigned {}
impl Recorded for JobAssigned {
    type Event = crate::types::JobAssignedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `job:completed`
pub struct JobCompleted;
impl Channel for JobCompleted {
    const NAME: &'static str = "job:completed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Scoped for JobCompleted {}
impl Recorded for JobCompleted {
    type Event = crate::types::JobCompletedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `job:failed`
pub struct JobFailed;
impl Channel for JobFailed {
    const NAME: &'static str = "job:failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::StoredEventResponse;
}
impl Scoped for JobFailed {}
impl Recorded for JobFailed {
    type Event = crate::types::JobFailedPayload;
    fn event(stored: &Self::Payload) -> Result<Self::Event, serde_json::Error> {
        own(Self::NAME, &stored.r#type, &stored.id, &stored.payload)
    }
}
/// `job:start`
pub struct JobStart;
impl Channel for JobStart {
    const NAME: &'static str = "job:start";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::JobStartCommand;
}
impl Unscoped for JobStart {}
/// `job:assign`
pub struct JobAssign;
impl Channel for JobAssign {
    const NAME: &'static str = "job:assign";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::JobAssignCommand;
}
impl Unscoped for JobAssign {}
/// `job:report-progress`
pub struct JobReportProgress;
impl Channel for JobReportProgress {
    const NAME: &'static str = "job:report-progress";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::JobReportProgressCommand;
}
impl Unscoped for JobReportProgress {}
/// `job:complete`
pub struct JobComplete;
impl Channel for JobComplete {
    const NAME: &'static str = "job:complete";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::JobCompleteCommand;
}
impl Unscoped for JobComplete {}
/// `job:fail`
pub struct JobFail;
impl Channel for JobFail {
    const NAME: &'static str = "job:fail";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::JobFailCommand;
}
impl Unscoped for JobFail {}
/// `job:checkpoint`
pub struct JobCheckpoint;
impl Channel for JobCheckpoint {
    const NAME: &'static str = "job:checkpoint";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::JobCheckpointCommand;
}
impl Unscoped for JobCheckpoint {}
/// `job:queued`
pub struct JobQueued;
impl Channel for JobQueued {
    const NAME: &'static str = "job:queued";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::JobQueuedEvent;
}
impl Unscoped for JobQueued {}
/// `job:cancel-requested`
pub struct JobCancelRequested;
impl Channel for JobCancelRequested {
    const NAME: &'static str = "job:cancel-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::JobCancelRequest;
}
impl Unscoped for JobCancelRequested {}
/// `job:cancel`
pub struct JobCancel;
impl Channel for JobCancel {
    const NAME: &'static str = "job:cancel";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::JobCancelCommand;
}
impl Unscoped for JobCancel {}
/// `job:limits-requested`
pub struct JobLimitsRequested;
impl Channel for JobLimitsRequested {
    const NAME: &'static str = "job:limits-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::InferenceLimitsRequest;
}
impl Unscoped for JobLimitsRequested {}
/// `job:limits-result`
pub struct JobLimitsResult;
impl Channel for JobLimitsResult {
    const NAME: &'static str = "job:limits-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::InferenceLimitsResult;
}
impl Unscoped for JobLimitsResult {}
/// `job:limits-failed`
pub struct JobLimitsFailed;
impl Channel for JobLimitsFailed {
    const NAME: &'static str = "job:limits-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for JobLimitsFailed {}
/// `job:status-requested`
pub struct JobStatusRequested;
impl Channel for JobStatusRequested {
    const NAME: &'static str = "job:status-requested";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::JobStatusRequest;
}
impl Unscoped for JobStatusRequested {}
/// `job:create`
pub struct JobCreate;
impl Channel for JobCreate {
    const NAME: &'static str = "job:create";
    const STAMPS: &'static [&'static str] = &["_roles", "_userId"];
    type Payload = crate::types::JobCreateCommand;
}
impl Unscoped for JobCreate {}
/// `job:claim`
pub struct JobClaim;
impl Channel for JobClaim {
    const NAME: &'static str = "job:claim";
    const STAMPS: &'static [&'static str] = &["_roles", "_userId"];
    type Payload = crate::types::JobClaimCommand;
}
impl Unscoped for JobClaim {}
/// `job:status-result`
pub struct JobStatusResult;
impl Channel for JobStatusResult {
    const NAME: &'static str = "job:status-result";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::JobStatusResult;
}
impl Unscoped for JobStatusResult {}
/// `job:status-failed`
pub struct JobStatusFailed;
impl Channel for JobStatusFailed {
    const NAME: &'static str = "job:status-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for JobStatusFailed {}
/// `job:created`
pub struct JobCreated;
impl Channel for JobCreated {
    const NAME: &'static str = "job:created";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::JobCreatedResult;
}
impl Unscoped for JobCreated {}
/// `job:create-failed`
pub struct JobCreateFailed;
impl Channel for JobCreateFailed {
    const NAME: &'static str = "job:create-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for JobCreateFailed {}
/// `job:claimed`
pub struct JobClaimed;
impl Channel for JobClaimed {
    const NAME: &'static str = "job:claimed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::JobClaimedResult;
}
impl Unscoped for JobClaimed {}
/// `job:claim-failed`
pub struct JobClaimFailed;
impl Channel for JobClaimFailed {
    const NAME: &'static str = "job:claim-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for JobClaimFailed {}
/// `job:cancel-ok`
pub struct JobCancelOk;
impl Channel for JobCancelOk {
    const NAME: &'static str = "job:cancel-ok";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = Response<crate::types::JobCancelResult>;
}
impl Unscoped for JobCancelOk {}
/// `job:cancel-failed`
pub struct JobCancelFailed;
impl Channel for JobCancelFailed {
    const NAME: &'static str = "job:cancel-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for JobCancelFailed {}
/// `weave:applied`
pub struct WeaveApplied;
impl Channel for WeaveApplied {
    const NAME: &'static str = "weave:applied";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::WeaveApplied;
}
impl Unscoped for WeaveApplied {}
/// `smelt:settled`
pub struct SmeltSettled;
impl Channel for SmeltSettled {
    const NAME: &'static str = "smelt:settled";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::SmeltSettled;
}
impl Unscoped for SmeltSettled {}
/// `weave:rebuild`
pub struct WeaveRebuild;
impl Channel for WeaveRebuild {
    const NAME: &'static str = "weave:rebuild";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::WeaveRebuildCommand;
}
impl Unscoped for WeaveRebuild {}
/// `weave:rebuild-ok`
pub struct WeaveRebuildOk;
impl Channel for WeaveRebuildOk {
    const NAME: &'static str = "weave:rebuild-ok";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = Empty;
}
impl Unscoped for WeaveRebuildOk {}
/// `weave:rebuild-failed`
pub struct WeaveRebuildFailed;
impl Channel for WeaveRebuildFailed {
    const NAME: &'static str = "weave:rebuild-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for WeaveRebuildFailed {}
/// `smelt:rebuild-anchors`
pub struct SmeltRebuildAnchors;
impl Channel for SmeltRebuildAnchors {
    const NAME: &'static str = "smelt:rebuild-anchors";
    const STAMPS: &'static [&'static str] = &["_userId"];
    type Payload = crate::types::SmeltRebuildAnchorsCommand;
}
impl Unscoped for SmeltRebuildAnchors {}
/// `smelt:rebuild-anchors-ok`
pub struct SmeltRebuildAnchorsOk;
impl Channel for SmeltRebuildAnchorsOk {
    const NAME: &'static str = "smelt:rebuild-anchors-ok";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = Empty;
}
impl Unscoped for SmeltRebuildAnchorsOk {}
/// `smelt:rebuild-anchors-failed`
pub struct SmeltRebuildAnchorsFailed;
impl Channel for SmeltRebuildAnchorsFailed {
    const NAME: &'static str = "smelt:rebuild-anchors-failed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::CommandError;
}
impl Unscoped for SmeltRebuildAnchorsFailed {}
/// `settings:theme-changed`
pub struct SettingsThemeChanged;
impl Channel for SettingsThemeChanged {
    const NAME: &'static str = "settings:theme-changed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::SettingsThemeChangedEvent;
}
impl Unscoped for SettingsThemeChanged {}
/// `settings:line-numbers-toggled`
pub struct SettingsLineNumbersToggled;
impl Channel for SettingsLineNumbersToggled {
    const NAME: &'static str = "settings:line-numbers-toggled";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = Empty;
}
impl Unscoped for SettingsLineNumbersToggled {}
/// `settings:locale-changed`
pub struct SettingsLocaleChanged;
impl Channel for SettingsLocaleChanged {
    const NAME: &'static str = "settings:locale-changed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::SettingsLocaleChangedEvent;
}
impl Unscoped for SettingsLocaleChanged {}
/// `settings:hover-delay-changed`
pub struct SettingsHoverDelayChanged;
impl Channel for SettingsHoverDelayChanged {
    const NAME: &'static str = "settings:hover-delay-changed";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::SettingsHoverDelayChangedEvent;
}
impl Unscoped for SettingsHoverDelayChanged {}
/// `bus:resume-gap`
pub struct BusResumeGap;
impl Channel for BusResumeGap {
    const NAME: &'static str = "bus:resume-gap";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::BusResumeGap;
}
impl Unscoped for BusResumeGap {}
/// `session:joined`
pub struct SessionJoined;
impl Channel for SessionJoined {
    const NAME: &'static str = "session:joined";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::SessionJoinedEvent;
}
impl Unscoped for SessionJoined {}
/// `session:left`
pub struct SessionLeft;
impl Channel for SessionLeft {
    const NAME: &'static str = "session:left";
    const STAMPS: &'static [&'static str] = &[];
    type Payload = crate::types::SessionLeftEvent;
}
impl Unscoped for SessionLeft {}
impl Request for BindUpdateBody {
    type Result = BindBodyUpdated;
    type Failure = BindBodyUpdateFailed;
}
impl Request for BrowseResourceRequested {
    type Result = BrowseResourceResult;
    type Failure = BrowseResourceFailed;
}
impl Request for BrowseResourcesRequested {
    type Result = BrowseResourcesResult;
    type Failure = BrowseResourcesFailed;
}
impl Request for BrowseAnnotationRequested {
    type Result = BrowseAnnotationResult;
    type Failure = BrowseAnnotationFailed;
}
impl Request for BrowseAnnotationHistoryRequested {
    type Result = BrowseAnnotationHistoryResult;
    type Failure = BrowseAnnotationHistoryFailed;
}
impl Request for BrowseEventsRequested {
    type Result = BrowseEventsResult;
    type Failure = BrowseEventsFailed;
}
impl Request for BrowseEntityTypesRequested {
    type Result = BrowseEntityTypesResult;
    type Failure = BrowseEntityTypesFailed;
}
impl Request for BrowseTagSchemasRequested {
    type Result = BrowseTagSchemasResult;
    type Failure = BrowseTagSchemasFailed;
}
impl Request for BrowseEnginesRequested {
    type Result = BrowseEnginesResult;
    type Failure = BrowseEnginesFailed;
}
impl Request for BrowseProfilesRequested {
    type Result = BrowseProfilesResult;
    type Failure = BrowseProfilesFailed;
}
impl Request for BrowseKbRequested {
    type Result = BrowseKbResult;
    type Failure = BrowseKbFailed;
}
impl Request for BrowseDirectoryRequested {
    type Result = BrowseDirectoryResult;
    type Failure = BrowseDirectoryFailed;
}
impl Request for FrameAddEntityType {
    type Result = FrameEntityTypeAddOk;
    type Failure = FrameEntityTypeAddFailed;
}
impl Request for FrameAddTagSchema {
    type Result = FrameTagSchemaAddOk;
    type Failure = FrameTagSchemaAddFailed;
}
impl Request for GatherRequested {
    type Result = GatherComplete;
    type Failure = GatherFailed;
}
impl Request for GatherResourceRequested {
    type Result = GatherResourceComplete;
    type Failure = GatherResourceFailed;
}
impl Request for GatherSummaryRequested {
    type Result = GatherSummaryResult;
    type Failure = GatherSummaryFailed;
}
impl Request for GatherReferencedByRequested {
    type Result = GatherReferencedByResult;
    type Failure = GatherReferencedByFailed;
}
impl Request for GatherLimitsRequested {
    type Result = GatherLimitsResult;
    type Failure = GatherLimitsFailed;
}
impl Request for JobCreate {
    type Result = JobCreated;
    type Failure = JobCreateFailed;
}
impl Request for JobStatusRequested {
    type Result = JobStatusResult;
    type Failure = JobStatusFailed;
}
impl Request for JobLimitsRequested {
    type Result = JobLimitsResult;
    type Failure = JobLimitsFailed;
}
impl Request for JobCancelRequested {
    type Result = JobCancelOk;
    type Failure = JobCancelFailed;
}
impl Request for JobClaim {
    type Result = JobClaimed;
    type Failure = JobClaimFailed;
}
impl Request for MarkCreateRequest {
    type Result = MarkCreateOk;
    type Failure = MarkCreateFailed;
}
impl Request for MarkCommit {
    type Result = MarkCommitOk;
    type Failure = MarkCommitFailed;
}
impl Request for MarkDelete {
    type Result = MarkDeleteOk;
    type Failure = MarkDeleteFailed;
}
impl Request for MarkArchive {
    type Result = MarkArchiveOk;
    type Failure = MarkArchiveFailed;
}
impl Request for MarkUnarchive {
    type Result = MarkUnarchiveOk;
    type Failure = MarkUnarchiveFailed;
}
impl Request for MarkUpdateEntityTypes {
    type Result = MarkUpdateEntityTypesOk;
    type Failure = MarkUpdateEntityTypesFailed;
}
impl Request for MatchSearchRequested {
    type Result = MatchSearchResults;
    type Failure = MatchSearchFailed;
}
impl Request for MatchResourcesRequested {
    type Result = MatchResourcesResult;
    type Failure = MatchResourcesFailed;
}
impl Request for MatchLimitsRequested {
    type Result = MatchLimitsResult;
    type Failure = MatchLimitsFailed;
}
impl Request for WeaveRebuild {
    type Result = WeaveRebuildOk;
    type Failure = WeaveRebuildFailed;
}
impl Request for SmeltRebuildAnchors {
    type Result = SmeltRebuildAnchorsOk;
    type Failure = SmeltRebuildAnchorsFailed;
}
impl Request for YieldCreate {
    type Result = YieldCreateOk;
    type Failure = YieldCreateFailed;
}
impl Request for YieldClonePersist {
    type Result = YieldClonePersistOk;
    type Failure = YieldClonePersistFailed;
}
impl Request for YieldUpdate {
    type Result = YieldUpdateOk;
    type Failure = YieldUpdateFailed;
}
impl Request for YieldCloneCreate {
    type Result = YieldCloneCreated;
    type Failure = YieldCloneCreateFailed;
}
impl Request for YieldCloneResourceRequested {
    type Result = YieldCloneResourceResult;
    type Failure = YieldCloneResourceFailed;
}
impl Request for YieldCloneTokenRequested {
    type Result = YieldCloneTokenGenerated;
    type Failure = YieldCloneTokenFailed;
}
/// What a payload on each channel must be, by the channel's name, as
/// `crate::required` holds a payload to it.
pub(crate) fn payload_shape(channel: &str) -> &'static crate::required::Shape {
    use crate::required::{Kind, NONE, Shape};
    match channel {
        "yield:created" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "yield:cloned" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "yield:updated" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "yield:moved" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "yield:representation-added" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "yield:representation-removed" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "yield:create" => &Shape {
            reference: Some("YieldCreateCommand"),
            ..NONE
        },
        "yield:clone-persist" => &Shape {
            reference: Some("YieldClonePersistCommand"),
            ..NONE
        },
        "yield:update" => &Shape {
            reference: Some("YieldUpdateCommand"),
            ..NONE
        },
        "yield:clone" => &Shape {
            kinds: Some(&[Kind::Object]),
            ..NONE
        },
        "yield:clone-token-requested" => &Shape {
            reference: Some("YieldCloneTokenRequest"),
            ..NONE
        },
        "yield:clone-resource-requested" => &Shape {
            reference: Some("YieldCloneResourceRequest"),
            ..NONE
        },
        "yield:clone-create" => &Shape {
            reference: Some("YieldCloneCreateCommand"),
            ..NONE
        },
        "yield:create-ok" => &Shape {
            reference: Some("YieldCreateOk"),
            ..NONE
        },
        "yield:create-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "yield:clone-persist-ok" => &Shape {
            reference: Some("YieldClonePersistOk"),
            ..NONE
        },
        "yield:clone-persist-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "yield:update-ok" => &Shape {
            reference: Some("YieldUpdateOk"),
            ..NONE
        },
        "yield:update-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "yield:clone-token-generated" => &Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[(
                "response",
                Shape {
                    reference: Some("CloneResourceWithTokenResponse"),
                    ..NONE
                },
            )],
            ..NONE
        },
        "yield:clone-token-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "yield:clone-resource-result" => &Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[(
                "response",
                Shape {
                    reference: Some("GetResourceByTokenResponse"),
                    ..NONE
                },
            )],
            ..NONE
        },
        "yield:clone-resource-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "yield:clone-created" => &Shape {
            reference: Some("YieldCloneCreated"),
            ..NONE
        },
        "yield:clone-create-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "mark:added" => &Shape {
            reference: Some("EnrichedResourceEvent"),
            ..NONE
        },
        "mark:removed" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "mark:body-updated" => &Shape {
            reference: Some("EnrichedResourceEvent"),
            ..NONE
        },
        "mark:entity-tag-added" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "mark:entity-tag-removed" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "mark:archived" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "mark:unarchived" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "mark:create-request" => &Shape {
            reference: Some("MarkCreateRequest"),
            ..NONE
        },
        "mark:delete" => &Shape {
            reference: Some("MarkDeleteCommand"),
            ..NONE
        },
        "mark:update-body" => &Shape {
            reference: Some("MarkUpdateBodyCommand"),
            ..NONE
        },
        "mark:archive" => &Shape {
            reference: Some("MarkArchiveCommand"),
            ..NONE
        },
        "mark:unarchive" => &Shape {
            reference: Some("MarkUnarchiveCommand"),
            ..NONE
        },
        "mark:update-entity-types" => &Shape {
            reference: Some("MarkUpdateEntityTypesCommand"),
            ..NONE
        },
        "mark:create-ok" => &Shape {
            reference: Some("MarkCreateOk"),
            ..NONE
        },
        "mark:create-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "mark:commit" => &Shape {
            reference: Some("MarkCommitCommand"),
            ..NONE
        },
        "mark:commit-ok" => &Shape {
            reference: Some("MarkCommitOk"),
            ..NONE
        },
        "mark:commit-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "mark:delete-ok" => &Shape {
            reference: Some("MarkDeleteOk"),
            ..NONE
        },
        "mark:delete-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "mark:archive-ok" => &Shape {
            kinds: Some(&[Kind::Object]),
            ..NONE
        },
        "mark:archive-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "mark:unarchive-ok" => &Shape {
            kinds: Some(&[Kind::Object]),
            ..NONE
        },
        "mark:unarchive-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "mark:update-entity-types-ok" => &Shape {
            kinds: Some(&[Kind::Object]),
            ..NONE
        },
        "mark:update-entity-types-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "mark:body-update-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "mark:requested" => &Shape {
            reference: Some("MarkRequestedEvent"),
            ..NONE
        },
        "mark:submit" => &Shape {
            reference: Some("MarkSubmitEvent"),
            ..NONE
        },
        "mark:delegate-timeout" => &Shape {
            reference: Some("MarkDelegateTimeoutEvent"),
            ..NONE
        },
        "mark:create-error" => &Shape {
            reference: Some("ResourceErrorEvent"),
            ..NONE
        },
        "mark:delete-error" => &Shape {
            reference: Some("ResourceErrorEvent"),
            ..NONE
        },
        "bind:body-error" => &Shape {
            reference: Some("ResourceErrorEvent"),
            ..NONE
        },
        "frame:entity-type-added" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "frame:tag-schema-added" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "frame:add-entity-type" => &Shape {
            reference: Some("FrameAddEntityTypeCommand"),
            ..NONE
        },
        "frame:add-tag-schema" => &Shape {
            reference: Some("FrameAddTagSchemaCommand"),
            ..NONE
        },
        "frame:entity-type-add-ok" => &Shape {
            kinds: Some(&[Kind::Object]),
            ..NONE
        },
        "frame:entity-type-add-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "frame:tag-schema-add-ok" => &Shape {
            kinds: Some(&[Kind::Object]),
            ..NONE
        },
        "frame:tag-schema-add-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "principal:profiled" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "principal:profile" => &Shape {
            reference: Some("PrincipalProfileCommand"),
            ..NONE
        },
        "bind:initiate" => &Shape {
            reference: Some("BindInitiateCommand"),
            ..NONE
        },
        "bind:update-body" => &Shape {
            reference: Some("BindUpdateBodyCommand"),
            ..NONE
        },
        "bind:body-updated" => &Shape {
            reference: Some("BindBodyUpdated"),
            ..NONE
        },
        "bind:body-update-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "match:search-requested" => &Shape {
            reference: Some("MatchSearchRequest"),
            ..NONE
        },
        "match:search-results" => &Shape {
            reference: Some("MatchSearchResult"),
            ..NONE
        },
        "match:search-failed" => &Shape {
            reference: Some("MatchSearchFailed"),
            ..NONE
        },
        "match:resources-requested" => &Shape {
            reference: Some("MatchResourcesRequest"),
            ..NONE
        },
        "match:resources-result" => &Shape {
            reference: Some("MatchResourcesResult"),
            ..NONE
        },
        "match:resources-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "match:limits-requested" => &Shape {
            reference: Some("InferenceLimitsRequest"),
            ..NONE
        },
        "match:limits-result" => &Shape {
            reference: Some("InferenceLimitsResult"),
            ..NONE
        },
        "match:limits-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "gather:requested" => &Shape {
            reference: Some("GatherAnnotationRequest"),
            ..NONE
        },
        "gather:complete" => &Shape {
            reference: Some("GatherAnnotationComplete"),
            ..NONE
        },
        "gather:failed" => &Shape {
            reference: Some("GatherFailed"),
            ..NONE
        },
        "gather:resource-requested" => &Shape {
            reference: Some("GatherResourceRequest"),
            ..NONE
        },
        "gather:resource-complete" => &Shape {
            reference: Some("GatherResourceComplete"),
            ..NONE
        },
        "gather:resource-failed" => &Shape {
            reference: Some("GatherResourceFailed"),
            ..NONE
        },
        "gather:summary-requested" => &Shape {
            reference: Some("GatherSummaryRequest"),
            ..NONE
        },
        "gather:summary-result" => &Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[(
                "response",
                Shape {
                    reference: Some("ContextualSummaryResponse"),
                    ..NONE
                },
            )],
            ..NONE
        },
        "gather:summary-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "gather:referenced-by-requested" => &Shape {
            reference: Some("GatherReferencedByRequest"),
            ..NONE
        },
        "gather:referenced-by-result" => &Shape {
            reference: Some("GatherReferencedByResult"),
            ..NONE
        },
        "gather:referenced-by-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "gather:limits-requested" => &Shape {
            reference: Some("InferenceLimitsRequest"),
            ..NONE
        },
        "gather:limits-result" => &Shape {
            reference: Some("InferenceLimitsResult"),
            ..NONE
        },
        "gather:limits-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "browse:resource-requested" => &Shape {
            reference: Some("BrowseResourceRequest"),
            ..NONE
        },
        "browse:resource-result" => &Shape {
            reference: Some("BrowseResourceResult"),
            ..NONE
        },
        "browse:resource-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "browse:resources-requested" => &Shape {
            reference: Some("BrowseResourcesRequest"),
            ..NONE
        },
        "browse:resources-result" => &Shape {
            reference: Some("BrowseResourcesResult"),
            ..NONE
        },
        "browse:resources-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "browse:annotation-requested" => &Shape {
            reference: Some("BrowseAnnotationRequest"),
            ..NONE
        },
        "browse:annotation-result" => &Shape {
            reference: Some("BrowseAnnotationResult"),
            ..NONE
        },
        "browse:annotation-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "browse:events-requested" => &Shape {
            reference: Some("BrowseEventsRequest"),
            ..NONE
        },
        "browse:events-result" => &Shape {
            reference: Some("BrowseEventsResult"),
            ..NONE
        },
        "browse:events-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "browse:annotation-history-requested" => &Shape {
            reference: Some("BrowseAnnotationHistoryRequest"),
            ..NONE
        },
        "browse:annotation-history-result" => &Shape {
            reference: Some("BrowseAnnotationHistoryResult"),
            ..NONE
        },
        "browse:annotation-history-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "browse:entity-types-requested" => &Shape {
            reference: Some("BrowseEntityTypesRequest"),
            ..NONE
        },
        "browse:entity-types-result" => &Shape {
            reference: Some("BrowseEntityTypesResult"),
            ..NONE
        },
        "browse:entity-types-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "browse:tag-schemas-requested" => &Shape {
            reference: Some("BrowseTagSchemasRequest"),
            ..NONE
        },
        "browse:tag-schemas-result" => &Shape {
            reference: Some("BrowseTagSchemasResult"),
            ..NONE
        },
        "browse:tag-schemas-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "browse:engines-requested" => &Shape {
            reference: Some("BrowseEnginesRequest"),
            ..NONE
        },
        "browse:engines-result" => &Shape {
            reference: Some("BrowseEnginesResult"),
            ..NONE
        },
        "browse:engines-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "browse:profiles-requested" => &Shape {
            reference: Some("BrowseProfilesRequest"),
            ..NONE
        },
        "browse:profiles-result" => &Shape {
            reference: Some("BrowseProfilesResult"),
            ..NONE
        },
        "browse:profiles-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "browse:kb-requested" => &Shape {
            reference: Some("BrowseKbRequest"),
            ..NONE
        },
        "browse:kb-result" => &Shape {
            reference: Some("BrowseKbResult"),
            ..NONE
        },
        "browse:kb-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "browse:directory-requested" => &Shape {
            reference: Some("BrowseDirectoryRequest"),
            ..NONE
        },
        "browse:directory-result" => &Shape {
            reference: Some("BrowseDirectoryResult"),
            ..NONE
        },
        "browse:directory-failed" => &Shape {
            reference: Some("BrowseDirectoryFailed"),
            ..NONE
        },
        "browse:click" => &Shape {
            reference: Some("BrowseClickEvent"),
            ..NONE
        },
        "browse:resource-open" => &Shape {
            reference: Some("BrowseResourceOpenEvent"),
            ..NONE
        },
        "browse:resource-viewed" => &Shape {
            reference: Some("BrowseResourceViewedEvent"),
            ..NONE
        },
        "browse:entity-type-clicked" => &Shape {
            reference: Some("BrowseEntityTypeClickedEvent"),
            ..NONE
        },
        "panel:toggle" => &Shape {
            reference: Some("BrowsePanelToggleEvent"),
            ..NONE
        },
        "panel:open" => &Shape {
            reference: Some("BrowsePanelOpenEvent"),
            ..NONE
        },
        "panel:close" => &Shape {
            kinds: Some(&[Kind::Object]),
            ..NONE
        },
        "shell:sidebar-toggle" => &Shape {
            kinds: Some(&[Kind::Object]),
            ..NONE
        },
        "tabs:close" => &Shape {
            reference: Some("BrowseResourceCloseEvent"),
            ..NONE
        },
        "tabs:reorder" => &Shape {
            reference: Some("BrowseResourceReorderEvent"),
            ..NONE
        },
        "nav:link-clicked" => &Shape {
            reference: Some("BrowseLinkClickedEvent"),
            ..NONE
        },
        "nav:push" => &Shape {
            reference: Some("BrowseRouterPushEvent"),
            ..NONE
        },
        "nav:external" => &Shape {
            reference: Some("BrowseExternalNavigateEvent"),
            ..NONE
        },
        "beckon:hover" => &Shape {
            reference: Some("BeckonHoverEvent"),
            ..NONE
        },
        "beckon:focus" => &Shape {
            reference: Some("BeckonFocusEvent"),
            ..NONE
        },
        "beckon:sparkle" => &Shape {
            reference: Some("BeckonSparkleEvent"),
            ..NONE
        },
        "job:started" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "job:assigned" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "job:completed" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "job:failed" => &Shape {
            reference: Some("StoredEventResponse"),
            ..NONE
        },
        "job:start" => &Shape {
            reference: Some("JobStartCommand"),
            ..NONE
        },
        "job:assign" => &Shape {
            reference: Some("JobAssignCommand"),
            ..NONE
        },
        "job:report-progress" => &Shape {
            reference: Some("JobReportProgressCommand"),
            ..NONE
        },
        "job:complete" => &Shape {
            reference: Some("JobCompleteCommand"),
            ..NONE
        },
        "job:fail" => &Shape {
            reference: Some("JobFailCommand"),
            ..NONE
        },
        "job:checkpoint" => &Shape {
            reference: Some("JobCheckpointCommand"),
            ..NONE
        },
        "job:queued" => &Shape {
            reference: Some("JobQueuedEvent"),
            ..NONE
        },
        "job:cancel-requested" => &Shape {
            reference: Some("JobCancelRequest"),
            ..NONE
        },
        "job:cancel" => &Shape {
            reference: Some("JobCancelCommand"),
            ..NONE
        },
        "job:limits-requested" => &Shape {
            reference: Some("InferenceLimitsRequest"),
            ..NONE
        },
        "job:limits-result" => &Shape {
            reference: Some("InferenceLimitsResult"),
            ..NONE
        },
        "job:limits-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "job:status-requested" => &Shape {
            reference: Some("JobStatusRequest"),
            ..NONE
        },
        "job:create" => &Shape {
            reference: Some("JobCreateCommand"),
            ..NONE
        },
        "job:claim" => &Shape {
            reference: Some("JobClaimCommand"),
            ..NONE
        },
        "job:status-result" => &Shape {
            reference: Some("JobStatusResult"),
            ..NONE
        },
        "job:status-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "job:created" => &Shape {
            reference: Some("JobCreatedResult"),
            ..NONE
        },
        "job:create-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "job:claimed" => &Shape {
            reference: Some("JobClaimedResult"),
            ..NONE
        },
        "job:claim-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "job:cancel-ok" => &Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[(
                "response",
                Shape {
                    reference: Some("JobCancelResult"),
                    ..NONE
                },
            )],
            ..NONE
        },
        "job:cancel-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "weave:applied" => &Shape {
            reference: Some("WeaveApplied"),
            ..NONE
        },
        "smelt:settled" => &Shape {
            reference: Some("SmeltSettled"),
            ..NONE
        },
        "weave:rebuild" => &Shape {
            reference: Some("WeaveRebuildCommand"),
            ..NONE
        },
        "weave:rebuild-ok" => &Shape {
            kinds: Some(&[Kind::Object]),
            ..NONE
        },
        "weave:rebuild-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "smelt:rebuild-anchors" => &Shape {
            reference: Some("SmeltRebuildAnchorsCommand"),
            ..NONE
        },
        "smelt:rebuild-anchors-ok" => &Shape {
            kinds: Some(&[Kind::Object]),
            ..NONE
        },
        "smelt:rebuild-anchors-failed" => &Shape {
            reference: Some("CommandError"),
            ..NONE
        },
        "settings:theme-changed" => &Shape {
            reference: Some("SettingsThemeChangedEvent"),
            ..NONE
        },
        "settings:line-numbers-toggled" => &Shape {
            kinds: Some(&[Kind::Object]),
            ..NONE
        },
        "settings:locale-changed" => &Shape {
            reference: Some("SettingsLocaleChangedEvent"),
            ..NONE
        },
        "settings:hover-delay-changed" => &Shape {
            reference: Some("SettingsHoverDelayChangedEvent"),
            ..NONE
        },
        "bus:resume-gap" => &Shape {
            reference: Some("BusResumeGap"),
            ..NONE
        },
        "session:joined" => &Shape {
            reference: Some("SessionJoinedEvent"),
            ..NONE
        },
        "session:left" => &Shape {
            reference: Some("SessionLeftEvent"),
            ..NONE
        },
        other => panic!("{other} is no channel of the registry"),
    }
}
/// The stamps each channel's payload type declares (`Channel::STAMPS`), by
/// the channel's name.
pub(crate) fn payload_stamps(channel: &str) -> &'static [&'static str] {
    match channel {
        "yield:created" => <YieldCreated as Channel>::STAMPS,
        "yield:cloned" => <YieldCloned as Channel>::STAMPS,
        "yield:updated" => <YieldUpdated as Channel>::STAMPS,
        "yield:moved" => <YieldMoved as Channel>::STAMPS,
        "yield:representation-added" => <YieldRepresentationAdded as Channel>::STAMPS,
        "yield:representation-removed" => <YieldRepresentationRemoved as Channel>::STAMPS,
        "yield:create" => <YieldCreate as Channel>::STAMPS,
        "yield:clone-persist" => <YieldClonePersist as Channel>::STAMPS,
        "yield:update" => <YieldUpdate as Channel>::STAMPS,
        "yield:clone" => <YieldClone as Channel>::STAMPS,
        "yield:clone-token-requested" => <YieldCloneTokenRequested as Channel>::STAMPS,
        "yield:clone-resource-requested" => <YieldCloneResourceRequested as Channel>::STAMPS,
        "yield:clone-create" => <YieldCloneCreate as Channel>::STAMPS,
        "yield:create-ok" => <YieldCreateOk as Channel>::STAMPS,
        "yield:create-failed" => <YieldCreateFailed as Channel>::STAMPS,
        "yield:clone-persist-ok" => <YieldClonePersistOk as Channel>::STAMPS,
        "yield:clone-persist-failed" => <YieldClonePersistFailed as Channel>::STAMPS,
        "yield:update-ok" => <YieldUpdateOk as Channel>::STAMPS,
        "yield:update-failed" => <YieldUpdateFailed as Channel>::STAMPS,
        "yield:clone-token-generated" => <YieldCloneTokenGenerated as Channel>::STAMPS,
        "yield:clone-token-failed" => <YieldCloneTokenFailed as Channel>::STAMPS,
        "yield:clone-resource-result" => <YieldCloneResourceResult as Channel>::STAMPS,
        "yield:clone-resource-failed" => <YieldCloneResourceFailed as Channel>::STAMPS,
        "yield:clone-created" => <YieldCloneCreated as Channel>::STAMPS,
        "yield:clone-create-failed" => <YieldCloneCreateFailed as Channel>::STAMPS,
        "mark:added" => <MarkAdded as Channel>::STAMPS,
        "mark:removed" => <MarkRemoved as Channel>::STAMPS,
        "mark:body-updated" => <MarkBodyUpdated as Channel>::STAMPS,
        "mark:entity-tag-added" => <MarkEntityTagAdded as Channel>::STAMPS,
        "mark:entity-tag-removed" => <MarkEntityTagRemoved as Channel>::STAMPS,
        "mark:archived" => <MarkArchived as Channel>::STAMPS,
        "mark:unarchived" => <MarkUnarchived as Channel>::STAMPS,
        "mark:create-request" => <MarkCreateRequest as Channel>::STAMPS,
        "mark:delete" => <MarkDelete as Channel>::STAMPS,
        "mark:update-body" => <MarkUpdateBody as Channel>::STAMPS,
        "mark:archive" => <MarkArchive as Channel>::STAMPS,
        "mark:unarchive" => <MarkUnarchive as Channel>::STAMPS,
        "mark:update-entity-types" => <MarkUpdateEntityTypes as Channel>::STAMPS,
        "mark:create-ok" => <MarkCreateOk as Channel>::STAMPS,
        "mark:create-failed" => <MarkCreateFailed as Channel>::STAMPS,
        "mark:commit" => <MarkCommit as Channel>::STAMPS,
        "mark:commit-ok" => <MarkCommitOk as Channel>::STAMPS,
        "mark:commit-failed" => <MarkCommitFailed as Channel>::STAMPS,
        "mark:delete-ok" => <MarkDeleteOk as Channel>::STAMPS,
        "mark:delete-failed" => <MarkDeleteFailed as Channel>::STAMPS,
        "mark:archive-ok" => <MarkArchiveOk as Channel>::STAMPS,
        "mark:archive-failed" => <MarkArchiveFailed as Channel>::STAMPS,
        "mark:unarchive-ok" => <MarkUnarchiveOk as Channel>::STAMPS,
        "mark:unarchive-failed" => <MarkUnarchiveFailed as Channel>::STAMPS,
        "mark:update-entity-types-ok" => <MarkUpdateEntityTypesOk as Channel>::STAMPS,
        "mark:update-entity-types-failed" => <MarkUpdateEntityTypesFailed as Channel>::STAMPS,
        "mark:body-update-failed" => <MarkBodyUpdateFailed as Channel>::STAMPS,
        "mark:requested" => <MarkRequested as Channel>::STAMPS,
        "mark:submit" => <MarkSubmit as Channel>::STAMPS,
        "mark:delegate-timeout" => <MarkDelegateTimeout as Channel>::STAMPS,
        "mark:create-error" => <MarkCreateError as Channel>::STAMPS,
        "mark:delete-error" => <MarkDeleteError as Channel>::STAMPS,
        "bind:body-error" => <BindBodyError as Channel>::STAMPS,
        "frame:entity-type-added" => <FrameEntityTypeAdded as Channel>::STAMPS,
        "frame:tag-schema-added" => <FrameTagSchemaAdded as Channel>::STAMPS,
        "frame:add-entity-type" => <FrameAddEntityType as Channel>::STAMPS,
        "frame:add-tag-schema" => <FrameAddTagSchema as Channel>::STAMPS,
        "frame:entity-type-add-ok" => <FrameEntityTypeAddOk as Channel>::STAMPS,
        "frame:entity-type-add-failed" => <FrameEntityTypeAddFailed as Channel>::STAMPS,
        "frame:tag-schema-add-ok" => <FrameTagSchemaAddOk as Channel>::STAMPS,
        "frame:tag-schema-add-failed" => <FrameTagSchemaAddFailed as Channel>::STAMPS,
        "principal:profiled" => <PrincipalProfiled as Channel>::STAMPS,
        "principal:profile" => <PrincipalProfile as Channel>::STAMPS,
        "bind:initiate" => <BindInitiate as Channel>::STAMPS,
        "bind:update-body" => <BindUpdateBody as Channel>::STAMPS,
        "bind:body-updated" => <BindBodyUpdated as Channel>::STAMPS,
        "bind:body-update-failed" => <BindBodyUpdateFailed as Channel>::STAMPS,
        "match:search-requested" => <MatchSearchRequested as Channel>::STAMPS,
        "match:search-results" => <MatchSearchResults as Channel>::STAMPS,
        "match:search-failed" => <MatchSearchFailed as Channel>::STAMPS,
        "match:resources-requested" => <MatchResourcesRequested as Channel>::STAMPS,
        "match:resources-result" => <MatchResourcesResult as Channel>::STAMPS,
        "match:resources-failed" => <MatchResourcesFailed as Channel>::STAMPS,
        "match:limits-requested" => <MatchLimitsRequested as Channel>::STAMPS,
        "match:limits-result" => <MatchLimitsResult as Channel>::STAMPS,
        "match:limits-failed" => <MatchLimitsFailed as Channel>::STAMPS,
        "gather:requested" => <GatherRequested as Channel>::STAMPS,
        "gather:complete" => <GatherComplete as Channel>::STAMPS,
        "gather:failed" => <GatherFailed as Channel>::STAMPS,
        "gather:resource-requested" => <GatherResourceRequested as Channel>::STAMPS,
        "gather:resource-complete" => <GatherResourceComplete as Channel>::STAMPS,
        "gather:resource-failed" => <GatherResourceFailed as Channel>::STAMPS,
        "gather:summary-requested" => <GatherSummaryRequested as Channel>::STAMPS,
        "gather:summary-result" => <GatherSummaryResult as Channel>::STAMPS,
        "gather:summary-failed" => <GatherSummaryFailed as Channel>::STAMPS,
        "gather:referenced-by-requested" => <GatherReferencedByRequested as Channel>::STAMPS,
        "gather:referenced-by-result" => <GatherReferencedByResult as Channel>::STAMPS,
        "gather:referenced-by-failed" => <GatherReferencedByFailed as Channel>::STAMPS,
        "gather:limits-requested" => <GatherLimitsRequested as Channel>::STAMPS,
        "gather:limits-result" => <GatherLimitsResult as Channel>::STAMPS,
        "gather:limits-failed" => <GatherLimitsFailed as Channel>::STAMPS,
        "browse:resource-requested" => <BrowseResourceRequested as Channel>::STAMPS,
        "browse:resource-result" => <BrowseResourceResult as Channel>::STAMPS,
        "browse:resource-failed" => <BrowseResourceFailed as Channel>::STAMPS,
        "browse:resources-requested" => <BrowseResourcesRequested as Channel>::STAMPS,
        "browse:resources-result" => <BrowseResourcesResult as Channel>::STAMPS,
        "browse:resources-failed" => <BrowseResourcesFailed as Channel>::STAMPS,
        "browse:annotation-requested" => <BrowseAnnotationRequested as Channel>::STAMPS,
        "browse:annotation-result" => <BrowseAnnotationResult as Channel>::STAMPS,
        "browse:annotation-failed" => <BrowseAnnotationFailed as Channel>::STAMPS,
        "browse:events-requested" => <BrowseEventsRequested as Channel>::STAMPS,
        "browse:events-result" => <BrowseEventsResult as Channel>::STAMPS,
        "browse:events-failed" => <BrowseEventsFailed as Channel>::STAMPS,
        "browse:annotation-history-requested" => {
            <BrowseAnnotationHistoryRequested as Channel>::STAMPS
        }
        "browse:annotation-history-result" => <BrowseAnnotationHistoryResult as Channel>::STAMPS,
        "browse:annotation-history-failed" => <BrowseAnnotationHistoryFailed as Channel>::STAMPS,
        "browse:entity-types-requested" => <BrowseEntityTypesRequested as Channel>::STAMPS,
        "browse:entity-types-result" => <BrowseEntityTypesResult as Channel>::STAMPS,
        "browse:entity-types-failed" => <BrowseEntityTypesFailed as Channel>::STAMPS,
        "browse:tag-schemas-requested" => <BrowseTagSchemasRequested as Channel>::STAMPS,
        "browse:tag-schemas-result" => <BrowseTagSchemasResult as Channel>::STAMPS,
        "browse:tag-schemas-failed" => <BrowseTagSchemasFailed as Channel>::STAMPS,
        "browse:engines-requested" => <BrowseEnginesRequested as Channel>::STAMPS,
        "browse:engines-result" => <BrowseEnginesResult as Channel>::STAMPS,
        "browse:engines-failed" => <BrowseEnginesFailed as Channel>::STAMPS,
        "browse:profiles-requested" => <BrowseProfilesRequested as Channel>::STAMPS,
        "browse:profiles-result" => <BrowseProfilesResult as Channel>::STAMPS,
        "browse:profiles-failed" => <BrowseProfilesFailed as Channel>::STAMPS,
        "browse:kb-requested" => <BrowseKbRequested as Channel>::STAMPS,
        "browse:kb-result" => <BrowseKbResult as Channel>::STAMPS,
        "browse:kb-failed" => <BrowseKbFailed as Channel>::STAMPS,
        "browse:directory-requested" => <BrowseDirectoryRequested as Channel>::STAMPS,
        "browse:directory-result" => <BrowseDirectoryResult as Channel>::STAMPS,
        "browse:directory-failed" => <BrowseDirectoryFailed as Channel>::STAMPS,
        "browse:click" => <BrowseClick as Channel>::STAMPS,
        "browse:resource-open" => <BrowseResourceOpen as Channel>::STAMPS,
        "browse:resource-viewed" => <BrowseResourceViewed as Channel>::STAMPS,
        "browse:entity-type-clicked" => <BrowseEntityTypeClicked as Channel>::STAMPS,
        "panel:toggle" => <PanelToggle as Channel>::STAMPS,
        "panel:open" => <PanelOpen as Channel>::STAMPS,
        "panel:close" => <PanelClose as Channel>::STAMPS,
        "shell:sidebar-toggle" => <ShellSidebarToggle as Channel>::STAMPS,
        "tabs:close" => <TabsClose as Channel>::STAMPS,
        "tabs:reorder" => <TabsReorder as Channel>::STAMPS,
        "nav:link-clicked" => <NavLinkClicked as Channel>::STAMPS,
        "nav:push" => <NavPush as Channel>::STAMPS,
        "nav:external" => <NavExternal as Channel>::STAMPS,
        "beckon:hover" => <BeckonHover as Channel>::STAMPS,
        "beckon:focus" => <BeckonFocus as Channel>::STAMPS,
        "beckon:sparkle" => <BeckonSparkle as Channel>::STAMPS,
        "job:started" => <JobStarted as Channel>::STAMPS,
        "job:assigned" => <JobAssigned as Channel>::STAMPS,
        "job:completed" => <JobCompleted as Channel>::STAMPS,
        "job:failed" => <JobFailed as Channel>::STAMPS,
        "job:start" => <JobStart as Channel>::STAMPS,
        "job:assign" => <JobAssign as Channel>::STAMPS,
        "job:report-progress" => <JobReportProgress as Channel>::STAMPS,
        "job:complete" => <JobComplete as Channel>::STAMPS,
        "job:fail" => <JobFail as Channel>::STAMPS,
        "job:checkpoint" => <JobCheckpoint as Channel>::STAMPS,
        "job:queued" => <JobQueued as Channel>::STAMPS,
        "job:cancel-requested" => <JobCancelRequested as Channel>::STAMPS,
        "job:cancel" => <JobCancel as Channel>::STAMPS,
        "job:limits-requested" => <JobLimitsRequested as Channel>::STAMPS,
        "job:limits-result" => <JobLimitsResult as Channel>::STAMPS,
        "job:limits-failed" => <JobLimitsFailed as Channel>::STAMPS,
        "job:status-requested" => <JobStatusRequested as Channel>::STAMPS,
        "job:create" => <JobCreate as Channel>::STAMPS,
        "job:claim" => <JobClaim as Channel>::STAMPS,
        "job:status-result" => <JobStatusResult as Channel>::STAMPS,
        "job:status-failed" => <JobStatusFailed as Channel>::STAMPS,
        "job:created" => <JobCreated as Channel>::STAMPS,
        "job:create-failed" => <JobCreateFailed as Channel>::STAMPS,
        "job:claimed" => <JobClaimed as Channel>::STAMPS,
        "job:claim-failed" => <JobClaimFailed as Channel>::STAMPS,
        "job:cancel-ok" => <JobCancelOk as Channel>::STAMPS,
        "job:cancel-failed" => <JobCancelFailed as Channel>::STAMPS,
        "weave:applied" => <WeaveApplied as Channel>::STAMPS,
        "smelt:settled" => <SmeltSettled as Channel>::STAMPS,
        "weave:rebuild" => <WeaveRebuild as Channel>::STAMPS,
        "weave:rebuild-ok" => <WeaveRebuildOk as Channel>::STAMPS,
        "weave:rebuild-failed" => <WeaveRebuildFailed as Channel>::STAMPS,
        "smelt:rebuild-anchors" => <SmeltRebuildAnchors as Channel>::STAMPS,
        "smelt:rebuild-anchors-ok" => <SmeltRebuildAnchorsOk as Channel>::STAMPS,
        "smelt:rebuild-anchors-failed" => <SmeltRebuildAnchorsFailed as Channel>::STAMPS,
        "settings:theme-changed" => <SettingsThemeChanged as Channel>::STAMPS,
        "settings:line-numbers-toggled" => <SettingsLineNumbersToggled as Channel>::STAMPS,
        "settings:locale-changed" => <SettingsLocaleChanged as Channel>::STAMPS,
        "settings:hover-delay-changed" => <SettingsHoverDelayChanged as Channel>::STAMPS,
        "bus:resume-gap" => <BusResumeGap as Channel>::STAMPS,
        "session:joined" => <SessionJoined as Channel>::STAMPS,
        "session:left" => <SessionLeft as Channel>::STAMPS,
        other => panic!("{other} is no channel of the registry"),
    }
}
