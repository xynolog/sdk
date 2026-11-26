// Generated from every schema Protocol roots (codegen/lib/roots.ml), each record its tables state, each client type every SDK generates, and protocol/specs/src/client/discovery-absent.json; do not edit.
// Regenerate: make generate (codegen/lib/required/rust.ml)
pub(crate) const SCHEMAS: &[(&str, Shape)] = &[
    (
        "AboutParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion"],
            members: &[("apiVersion", reference("ApiVersion"))],
            closed: Some(&["apiVersion"]),
            ..NONE
        },
    ),
    (
        "AboutResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["development", "apiVersions", "imageRegistry", "runtimes"],
            members: &[
                (
                    "apiVersions",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("built", of(&[Kind::String])),
                ("commit", of(&[Kind::String])),
                ("development", of(&[Kind::Boolean])),
                ("imageRegistry", of(&[Kind::String])),
                (
                    "runtimes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("RuntimeState")),
                        ..NONE
                    },
                ),
                ("version", of(&[Kind::String])),
            ],
            closed: Some(&[
                "apiVersions",
                "built",
                "commit",
                "development",
                "imageRegistry",
                "runtimes",
                "version",
            ]),
            ..NONE
        },
    ),
    (
        "AccessToken",
        Shape {
            kinds: Some(&[Kind::String]),
            min_length: Some(1),
            ..NONE
        },
    ),
    (
        "Agent",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("AgentPerson"),
                reference("AgentOrganization"),
                reference("AgentSoftware"),
            ],
            discriminator: Some(Discriminator {
                property: "@type",
                mapping: &[("Person", 0), ("Organization", 1), ("Software", 2)],
            }),
            ..NONE
        },
    ),
    (
        "AgentOrganization",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["@type", "name"],
            members: &[
                ("@id", of(&[Kind::String])),
                (
                    "@type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("Organization")]),
                        ..NONE
                    },
                ),
                ("homepage", of(&[Kind::String])),
                ("name", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "AgentPerson",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["@type"],
            members: &[
                ("@id", of(&[Kind::String])),
                (
                    "@type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("Person")]),
                        ..NONE
                    },
                ),
                ("email", of(&[Kind::String])),
                ("email_sha1", of(&[Kind::String])),
                ("homepage", of(&[Kind::String])),
                ("name", of(&[Kind::String])),
                ("nickname", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "AgentSoftware",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["@type"],
            members: &[
                ("@id", of(&[Kind::String])),
                (
                    "@type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("Software")]),
                        ..NONE
                    },
                ),
                ("model", of(&[Kind::String])),
                ("name", of(&[Kind::String])),
                ("parameters", of(&[Kind::Object])),
                ("provider", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "AnchorMethod",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("unique-match"),
                Listed::Text("context-recovered"),
                Listed::Text("first-of-many"),
                Listed::Text("fuzzy-match"),
            ]),
            ..NONE
        },
    ),
    (
        "AnchorRect",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "x", "y", "width", "height", "top", "right", "bottom", "left",
            ],
            members: &[
                ("bottom", of(&[Kind::Number])),
                ("height", of(&[Kind::Number])),
                ("left", of(&[Kind::Number])),
                ("right", of(&[Kind::Number])),
                ("top", of(&[Kind::Number])),
                ("width", of(&[Kind::Number])),
                ("x", of(&[Kind::Number])),
                ("y", of(&[Kind::Number])),
            ],
            ..NONE
        },
    ),
    (
        "AnchoredText",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["text", "items"],
            members: &[
                (
                    "items",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("PdfTextItem")),
                        ..NONE
                    },
                ),
                ("text", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "AnchoredTextAbsent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["kind"],
            members: &[(
                "kind",
                Shape {
                    kinds: Some(&[Kind::String]),
                    enumeration: Some(&[
                        Listed::Text("not-yet"),
                        Listed::Text("no-map"),
                        Listed::Text("unknown"),
                    ]),
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "AnchoredTextAnswer",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("ExtractedText"),
                reference("ExtractionDeclined"),
                reference("AnchoredTextAbsent"),
            ],
            discriminator: Some(Discriminator {
                property: "kind",
                mapping: &[
                    ("extracted", 0),
                    ("declined", 1),
                    ("not-yet", 2),
                    ("no-map", 2),
                    ("unknown", 2),
                ],
            }),
            ..NONE
        },
    ),
    (
        "AnchoredTextDeclinedEntry",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["v", "stamp", "declined"],
            members: &[
                ("declined", reference("ExtractionDeclinedReason")),
                (
                    "stamp",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "v",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        enumeration: Some(&[Listed::Number(3.0)]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["declined", "stamp", "v"]),
            ..NONE
        },
    ),
    (
        "AnchoredTextEntries",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["checksums"],
            members: &[(
                "checksums",
                Shape {
                    kinds: Some(&[Kind::Array]),
                    items: Some(&Shape {
                        kinds: Some(&[Kind::String]),
                        pattern: Some(&[Term::Step(Step {
                            of: &[(48, 57), (97, 102)],
                            min: 64,
                            max: Some(64),
                        })]),
                        ..NONE
                    }),
                    ..NONE
                },
            )],
            closed: Some(&["checksums"]),
            ..NONE
        },
    ),
    (
        "AnchoredTextEntry",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("AnchoredTextExtractedEntry"),
                reference("AnchoredTextDeclinedEntry"),
            ],
            ..NONE
        },
    ),
    (
        "AnchoredTextExtractedEntry",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["v", "stamp", "text", "lines", "method"],
            members: &[
                (
                    "lines",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&Shape {
                            kinds: Some(&[Kind::Object]),
                            required: &["p", "y", "h", "words"],
                            members: &[
                                ("h", of(&[Kind::Number])),
                                ("p", of(&[Kind::Integer])),
                                (
                                    "words",
                                    Shape {
                                        kinds: Some(&[Kind::Array]),
                                        items: Some(&Shape {
                                            kinds: Some(&[Kind::Array]),
                                            min_items: Some(4),
                                            max_items: Some(4),
                                            items: Some(&of(&[Kind::Number])),
                                            ..NONE
                                        }),
                                        ..NONE
                                    },
                                ),
                                ("y", of(&[Kind::Number])),
                            ],
                            closed: Some(&["h", "p", "words", "y"]),
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                ("method", reference("ExtractionMethod")),
                ("ocrConfidence", reference("OcrConfidence")),
                ("pdfClass", reference("PdfClass")),
                (
                    "stamp",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("text", of(&[Kind::String])),
                (
                    "unreadPages",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::Integer])),
                        ..NONE
                    },
                ),
                (
                    "v",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        enumeration: Some(&[Listed::Number(3.0)]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "lines",
                "method",
                "ocrConfidence",
                "pdfClass",
                "stamp",
                "text",
                "unreadPages",
                "v",
            ]),
            ..NONE
        },
    ),
    (
        "AnchoredTextStamp",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["stamp"],
            members: &[(
                "stamp",
                Shape {
                    kinds: Some(&[Kind::String]),
                    pattern: Some(&[Term::Step(Step {
                        of: &[
                            (0, 8),
                            (14, 31),
                            (33, 159),
                            (161, 5759),
                            (5761, 8191),
                            (8203, 8231),
                            (8234, 8238),
                            (8240, 8286),
                            (8288, 12287),
                            (12289, 65278),
                            (65280, 1114111),
                        ],
                        min: 1,
                        max: None,
                    })]),
                    min_length: Some(1),
                    ..NONE
                },
            )],
            closed: Some(&["stamp"]),
            ..NONE
        },
    ),
    (
        "AnchoredTextWrite",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["contentChecksum", "entry"],
            members: &[
                (
                    "contentChecksum",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        pattern: Some(&[Term::Step(Step {
                            of: &[(48, 57), (97, 102)],
                            min: 64,
                            max: Some(64),
                        })]),
                        ..NONE
                    },
                ),
                ("entry", reference("AnchoredTextEntry")),
            ],
            closed: Some(&["contentChecksum", "entry"]),
            ..NONE
        },
    ),
    (
        "Annotation",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["@context", "type", "id", "motivation", "target", "created"],
            members: &[
                (
                    "@context",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("http://www.w3.org/ns/anno.jsonld")]),
                        ..NONE
                    },
                ),
                ("body", reference("AnnotationBodies")),
                ("created", of(&[Kind::String])),
                ("creator", reference("Agent")),
                ("generator", reference("OneOrMoreAgents")),
                ("id", reference("AnnotationId")),
                ("modified", of(&[Kind::String])),
                ("motivation", reference("Motivation")),
                (
                    "target",
                    Shape {
                        kinds: Some(&[Kind::Object, Kind::String]),
                        one_of: &[reference("ResourceId"), reference("AnnotationTarget")],
                        ..NONE
                    },
                ),
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("Annotation")]),
                        ..NONE
                    },
                ),
                ("wasAttributedTo", reference("OneOrMoreAgents")),
            ],
            ..NONE
        },
    ),
    (
        "AnnotationAddedPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["annotation"],
            members: &[
                ("annotation", reference("Annotation")),
                ("contentChecksum", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "AnnotationBodies",
        Shape {
            kinds: Some(&[Kind::Object, Kind::Array]),
            one_of: &[
                reference("AnnotationBody"),
                Shape {
                    kinds: Some(&[Kind::Array]),
                    min_items: Some(1),
                    items: Some(&reference("AnnotationBody")),
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "AnnotationBody",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[reference("TextualBody"), reference("SpecificResource")],
            discriminator: Some(Discriminator {
                property: "type",
                mapping: &[("TextualBody", 0), ("SpecificResource", 1)],
            }),
            ..NONE
        },
    ),
    (
        "AnnotationBodyUpdatedPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["annotationId", "operations"],
            members: &[
                ("annotationId", reference("AnnotationId")),
                (
                    "operations",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("BodyOperation")),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "AnnotationId",
        Shape {
            kinds: Some(&[Kind::String]),
            pattern: Some(&[Term::Step(Step {
                of: &[(45, 45), (48, 57), (65, 90), (95, 95), (97, 122)],
                min: 1,
                max: Some(128),
            })]),
            ..NONE
        },
    ),
    (
        "AnnotationRemovedPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["annotationId"],
            members: &[("annotationId", reference("AnnotationId"))],
            ..NONE
        },
    ),
    (
        "AnnotationSelector",
        Shape {
            kinds: Some(&[Kind::Object, Kind::Array]),
            one_of: &[
                reference("Selector"),
                Shape {
                    kinds: Some(&[Kind::Array]),
                    items: Some(&reference("Selector")),
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "AnnotationTarget",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["source"],
            members: &[
                ("selector", reference("AnnotationSelector")),
                ("source", reference("ResourceId")),
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("SpecificResource")]),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "ApiVersion",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[Listed::Text("control.xynolog.org/v1alpha1")]),
            ..NONE
        },
    ),
    (
        "ArchivistConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "gatewayUrl",
                "identity",
                "root",
                "stateHome",
                "anchoredTextDir",
                "engines",
                "port",
                "skipRebuild",
                "staging",
                "logLevel",
                "logFormat",
            ],
            members: &[
                (
                    "anchoredTextDir",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("engines", reference("ArchivistEngines")),
                (
                    "gatewayUrl",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("identity", reference("ServiceIdentity")),
                ("logFormat", reference("LogFormat")),
                ("logLevel", reference("LogLevel")),
                (
                    "port",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(65535.0),
                        ..NONE
                    },
                ),
                (
                    "root",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("skipRebuild", of(&[Kind::Boolean])),
                (
                    "staging",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["flushMs", "maxWaitMs"],
                        members: &[
                            (
                                "flushMs",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(1.0),
                                    ..NONE
                                },
                            ),
                            (
                                "maxWaitMs",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(1.0),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&["flushMs", "maxWaitMs"]),
                        ..NONE
                    },
                ),
                (
                    "stateHome",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "anchoredTextDir",
                "engines",
                "gatewayUrl",
                "identity",
                "logFormat",
                "logLevel",
                "port",
                "root",
                "skipRebuild",
                "staging",
                "stateHome",
            ]),
            ..NONE
        },
    ),
    (
        "ArchivistEngines",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobs", "actors"],
            members: &[
                (
                    "actors",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        members: &[
                            ("gatherer", reference("Engine")),
                            ("matcher", reference("Engine")),
                        ],
                        closed: Some(&["gatherer", "matcher"]),
                        ..NONE
                    },
                ),
                (
                    "jobs",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        members: &[
                            (
                                "mark",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    members: &[
                                        ("assessing", reference("Engine")),
                                        ("commenting", reference("Engine")),
                                        ("highlighting", reference("Engine")),
                                        ("linking", reference("Engine")),
                                        ("tagging", reference("Engine")),
                                    ],
                                    closed: Some(&[
                                        "assessing",
                                        "commenting",
                                        "highlighting",
                                        "linking",
                                        "tagging",
                                    ]),
                                    ..NONE
                                },
                            ),
                            ("yield", reference("Engine")),
                        ],
                        closed: Some(&["mark", "yield"]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["actors", "jobs"]),
            ..NONE
        },
    ),
    (
        "ArchivistEventsResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["events", "lastSequence"],
            members: &[
                (
                    "events",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("StoredEventResponse")),
                        ..NONE
                    },
                ),
                (
                    "lastSequence",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "ArchivistHealth",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["status", "actors"],
            members: &[
                (
                    "actors",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        min_items: Some(3),
                        max_items: Some(3),
                        items: Some(&Shape {
                            kinds: Some(&[Kind::String]),
                            enumeration: Some(&[
                                Listed::Text("stower"),
                                Listed::Text("browser"),
                                Listed::Text("cloneTokenManager"),
                            ]),
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                (
                    "status",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("ok")]),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "ArchivistStream",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "lastSequence"],
            members: &[
                (
                    "lastSequence",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("resourceId", reference("ResourceId")),
            ],
            closed: Some(&["lastSequence", "resourceId"]),
            ..NONE
        },
    ),
    (
        "ArchivistStreamsResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["streams"],
            members: &[(
                "streams",
                Shape {
                    kinds: Some(&[Kind::Array]),
                    items: Some(&reference("ArchivistStream")),
                    ..NONE
                },
            )],
            closed: Some(&["streams"]),
            ..NONE
        },
    ),
    (
        "AssessingJobParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["motivation"],
            members: &[
                ("density", of(&[Kind::Number])),
                ("instructions", of(&[Kind::String])),
                ("language", of(&[Kind::String])),
                (
                    "motivation",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("assessing")]),
                        ..NONE
                    },
                ),
                ("sourceLanguage", of(&[Kind::String])),
                (
                    "tone",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("analytical"),
                            Listed::Text("critical"),
                            Listed::Text("balanced"),
                            Listed::Text("constructive"),
                        ]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "density",
                "instructions",
                "language",
                "motivation",
                "sourceLanguage",
                "tone",
            ]),
            ..NONE
        },
    ),
    (
        "AttributedEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            all_of: &[
                reference("StoredEventResponse"),
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["agent"],
                    members: &[("agent", reference("Agent"))],
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "AuthLoginParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion"],
            members: &[
                ("apiVersion", reference("ApiVersion")),
                ("runtime", reference("Runtime")),
                ("target", reference("Target")),
            ],
            closed: Some(&["apiVersion", "runtime", "target"]),
            ..NONE
        },
    ),
    (
        "AuthLoginResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["key", "who", "issuer"],
            members: &[
                ("issuer", of(&[Kind::String])),
                ("key", of(&[Kind::String])),
                ("who", of(&[Kind::String])),
            ],
            closed: Some(&["issuer", "key", "who"]),
            ..NONE
        },
    ),
    (
        "AuthLogoutParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion"],
            members: &[
                ("apiVersion", reference("ApiVersion")),
                ("runtime", reference("Runtime")),
                ("target", reference("Target")),
            ],
            closed: Some(&["apiVersion", "runtime", "target"]),
            ..NONE
        },
    ),
    (
        "AuthLogoutResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["wasSignedIn", "revoked"],
            members: &[
                ("key", of(&[Kind::String])),
                ("revoked", of(&[Kind::Boolean])),
                ("wasSignedIn", of(&[Kind::Boolean])),
            ],
            closed: Some(&["key", "revoked", "wasSignedIn"]),
            ..NONE
        },
    ),
    (
        "BeckonFocusEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId"],
            members: &[
                ("annotationId", reference("AnnotationId")),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "BeckonHoverEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["annotationId"],
            members: &[(
                "annotationId",
                Shape {
                    kinds: Some(&[Kind::String, Kind::Null]),
                    one_of: &[of(&[Kind::Null]), reference("AnnotationId")],
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "BeckonSparkleEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["annotationId"],
            members: &[("annotationId", reference("AnnotationId"))],
            ..NONE
        },
    ),
    (
        "BeginAuthorizationOptions",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["target", "redirectUri"],
            members: &[
                ("expectedDid", of(&[Kind::String])),
                ("expectedName", of(&[Kind::String])),
                ("kbId", of(&[Kind::String])),
                ("redirectUri", of(&[Kind::String])),
                ("target", reference("HttpEndpoint")),
            ],
            closed: Some(&[
                "expectedDid",
                "expectedName",
                "kbId",
                "redirectUri",
                "target",
            ]),
            ..NONE
        },
    ),
    ("Binary", of(&[Kind::String])),
    (
        "BindBodyOperation",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["op"],
            members: &[
                ("item", reference("AnnotationBody")),
                ("newItem", reference("AnnotationBody")),
                ("oldItem", reference("AnnotationBody")),
                (
                    "op",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("add"),
                            Listed::Text("remove"),
                            Listed::Text("replace"),
                        ]),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    ("BindBodyUpdated", of(&[Kind::Object])),
    (
        "BindInitiateCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["annotationId", "resourceId", "defaultTitle", "entityTypes"],
            members: &[
                ("annotationId", reference("AnnotationId")),
                ("defaultTitle", of(&[Kind::String])),
                (
                    "entityTypes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "BindUpdateBodyCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["annotationId", "resourceId", "operations"],
            members: &[
                ("_userId", reference("UserId")),
                ("annotationId", reference("AnnotationId")),
                (
                    "operations",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("BindBodyOperation")),
                        ..NONE
                    },
                ),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "BodyOperation",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("BodyOperationAdd"),
                reference("BodyOperationRemove"),
                reference("BodyOperationReplace"),
            ],
            ..NONE
        },
    ),
    (
        "BodyOperationAdd",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["op", "item"],
            members: &[
                ("item", reference("AnnotationBody")),
                (
                    "op",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("add")]),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "BodyOperationRemove",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["op", "item"],
            members: &[
                ("item", reference("AnnotationBody")),
                (
                    "op",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("remove")]),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "BodyOperationReplace",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["op", "oldItem", "newItem"],
            members: &[
                ("newItem", reference("AnnotationBody")),
                ("oldItem", reference("AnnotationBody")),
                (
                    "op",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("replace")]),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "BodyPurpose",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("assessing"),
                Listed::Text("bookmarking"),
                Listed::Text("classifying"),
                Listed::Text("commenting"),
                Listed::Text("describing"),
                Listed::Text("editing"),
                Listed::Text("highlighting"),
                Listed::Text("identifying"),
                Listed::Text("linking"),
                Listed::Text("moderating"),
                Listed::Text("questioning"),
                Listed::Text("replying"),
                Listed::Text("tagging"),
            ]),
            ..NONE
        },
    ),
    (
        "BrowseAnnotationHistoryRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "annotationId"],
            members: &[
                ("annotationId", reference("AnnotationId")),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "BrowseAnnotationHistoryResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("GetAnnotationHistoryResponse"))],
            ..NONE
        },
    ),
    (
        "BrowseAnnotationRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "annotationId"],
            members: &[
                ("annotationId", reference("AnnotationId")),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "BrowseAnnotationResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("GetAnnotationResponse"))],
            ..NONE
        },
    ),
    (
        "BrowseClickEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["annotationId"],
            members: &[
                ("anchorRect", reference("AnchorRect")),
                ("annotationId", reference("AnnotationId")),
            ],
            ..NONE
        },
    ),
    (
        "BrowseDirectoryFailed",
        Shape {
            kinds: Some(&[Kind::Object]),
            all_of: &[
                reference("CommandError"),
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["path"],
                    members: &[("path", of(&[Kind::String]))],
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "BrowseDirectoryRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["path"],
            members: &[
                ("path", of(&[Kind::String])),
                (
                    "sort",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("name"),
                            Listed::Text("mtime"),
                            Listed::Text("annotationCount"),
                        ]),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "BrowseDirectoryResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("BrowseDirectoryResultResponse"))],
            ..NONE
        },
    ),
    (
        "BrowseDirectoryResultResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["path", "entries"],
            members: &[
                (
                    "entries",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("DirectoryEntry")),
                        ..NONE
                    },
                ),
                ("path", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    ("BrowseEnginesRequest", of(&[Kind::Object])),
    (
        "BrowseEnginesResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[(
                "response",
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["engines"],
                    members: &[(
                        "engines",
                        Shape {
                            kinds: Some(&[Kind::Array]),
                            items: Some(&reference("EngineEntry")),
                            ..NONE
                        },
                    )],
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "BrowseEntityTypeClickedEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["entityType"],
            members: &[("entityType", of(&[Kind::String]))],
            ..NONE
        },
    ),
    ("BrowseEntityTypesRequest", of(&[Kind::Object])),
    (
        "BrowseEntityTypesResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("GetEntityTypesResponse"))],
            ..NONE
        },
    ),
    (
        "BrowseEventsRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId"],
            members: &[
                ("limit", of(&[Kind::Integer])),
                ("resourceId", reference("ResourceId")),
                ("type", of(&[Kind::String])),
                ("userId", reference("UserId")),
            ],
            ..NONE
        },
    ),
    (
        "BrowseEventsResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("GetEventsResponse"))],
            ..NONE
        },
    ),
    (
        "BrowseExternalNavigateEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["url"],
            members: &[
                ("resourceId", reference("ResourceId")),
                ("url", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "BrowseFilesResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["path", "entries"],
            members: &[
                (
                    "entries",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("DirectoryEntry")),
                        ..NONE
                    },
                ),
                ("path", of(&[Kind::String])),
            ],
            closed: Some(&["entries", "path"]),
            ..NONE
        },
    ),
    ("BrowseKbRequest", of(&[Kind::Object])),
    (
        "BrowseKbResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("KbDescription"))],
            ..NONE
        },
    ),
    (
        "BrowseLinkClickedEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["href"],
            members: &[
                ("href", of(&[Kind::String])),
                ("label", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "BrowsePanelOpenEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["panel"],
            members: &[
                ("motivation", reference("Motivation")),
                ("panel", of(&[Kind::String])),
                ("scrollToAnnotationId", reference("AnnotationId")),
            ],
            ..NONE
        },
    ),
    (
        "BrowsePanelToggleEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["panel"],
            members: &[("panel", of(&[Kind::String]))],
            ..NONE
        },
    ),
    (
        "BrowseProfilesRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["dids"],
            members: &[(
                "dids",
                Shape {
                    kinds: Some(&[Kind::Array]),
                    min_items: Some(1),
                    max_items: Some(500),
                    items: Some(&reference("UserId")),
                    ..NONE
                },
            )],
            closed: Some(&["dids"]),
            ..NONE
        },
    ),
    (
        "BrowseProfilesResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[(
                "response",
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["profiles"],
                    members: &[(
                        "profiles",
                        Shape {
                            kinds: Some(&[Kind::Object]),
                            values: Some(&reference("Profile")),
                            ..NONE
                        },
                    )],
                    closed: Some(&["profiles"]),
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "BrowseResourceCloseEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId"],
            members: &[("resourceId", reference("ResourceId"))],
            ..NONE
        },
    ),
    (
        "BrowseResourceOpenEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId"],
            members: &[("resourceId", reference("ResourceId"))],
            ..NONE
        },
    ),
    (
        "BrowseResourceReorderEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["oldIndex", "newIndex"],
            members: &[
                ("newIndex", of(&[Kind::Integer])),
                ("oldIndex", of(&[Kind::Integer])),
            ],
            ..NONE
        },
    ),
    (
        "BrowseResourceRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId"],
            members: &[("resourceId", reference("ResourceId"))],
            ..NONE
        },
    ),
    (
        "BrowseResourceResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[(
                "response",
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["resource", "lastSequence"],
                    members: &[
                        (
                            "lastSequence",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(1.0),
                                ..NONE
                            },
                        ),
                        ("resource", reference("ResourceDescriptor")),
                    ],
                    closed: Some(&["lastSequence", "resource"]),
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "BrowseResourceViewedEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId"],
            members: &[("resourceId", reference("ResourceId"))],
            ..NONE
        },
    ),
    (
        "BrowseResourcesRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            members: &[
                ("archived", of(&[Kind::Boolean])),
                ("entityType", of(&[Kind::String])),
                (
                    "limit",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        ..NONE
                    },
                ),
                (
                    "offset",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "BrowseResourcesResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("ListResourcesResponse"))],
            ..NONE
        },
    ),
    (
        "BrowseRouterPushEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["path"],
            members: &[
                ("path", of(&[Kind::String])),
                ("reason", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    ("BrowseTagSchemasRequest", of(&[Kind::Object])),
    (
        "BrowseTagSchemasResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("GetTagSchemasResponse"))],
            ..NONE
        },
    ),
    (
        "Browser",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion", "kind", "metadata", "spec"],
            members: &[
                ("apiVersion", reference("StackApiVersion")),
                (
                    "kind",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("Browser")]),
                        ..NONE
                    },
                ),
                ("metadata", reference("Metadata")),
                (
                    "spec",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["image", "resources", "port"],
                        members: &[
                            ("image", reference("Image")),
                            (
                                "port",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(1.0),
                                    maximum: Some(65535.0),
                                    ..NONE
                                },
                            ),
                            ("resources", reference("Resources")),
                        ],
                        closed: Some(&["image", "port", "resources"]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["apiVersion", "kind", "metadata", "spec"]),
            ..NONE
        },
    ),
    (
        "BusEmitAccepted",
        Shape {
            kinds: Some(&[Kind::Object]),
            members: &[(
                "subscribers",
                Shape {
                    kinds: Some(&[Kind::Integer]),
                    minimum: Some(0.0),
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "BusEmitRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["channel", "payload"],
            members: &[
                (
                    "channel",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("clientId", of(&[Kind::String])),
                (
                    "correlationId",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("payload", of(&[Kind::Object])),
                ("scope", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "BusEventMessage",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["event", "id", "data"],
            members: &[
                ("data", reference("BusFrame")),
                (
                    "event",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("bus-event")]),
                        ..NONE
                    },
                ),
                (
                    "id",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        one_of: &[
                            reference("PersistedEventId"),
                            reference("ReplyEventId"),
                            reference("EphemeralEventId"),
                        ],
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["data", "event", "id"]),
            ..NONE
        },
    ),
    (
        "BusFrame",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["channel", "payload"],
            members: &[
                (
                    "channel",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "correlationId",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("payload", of(&[Kind::Object])),
                ("scope", reference("ResourceId")),
            ],
            closed: Some(&["channel", "correlationId", "payload", "scope"]),
            ..NONE
        },
    ),
    (
        "BusPingMessage",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["event", "data"],
            members: &[
                (
                    "data",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        max_length: Some(0),
                        ..NONE
                    },
                ),
                (
                    "event",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("ping")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["data", "event"]),
            ..NONE
        },
    ),
    (
        "BusResumeGap",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["scope", "lastSeenId", "reason"],
            members: &[
                ("lastSeenId", of(&[Kind::String])),
                (
                    "reason",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("unparseable-last-event-id"),
                            Listed::Text("scope-mismatch"),
                            Listed::Text("retention-exceeded"),
                            Listed::Text("query-error"),
                        ]),
                        ..NONE
                    },
                ),
                ("scope", reference("ResourceId")),
            ],
            closed: Some(&["lastSeenId", "reason", "scope"]),
            ..NONE
        },
    ),
    (
        "BusStreamMessage",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[reference("BusEventMessage"), reference("BusPingMessage")],
            ..NONE
        },
    ),
    (
        "BusSubscribeRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["clientId"],
            members: &[
                (
                    "clientId",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "global",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&Shape {
                            kinds: Some(&[Kind::String]),
                            min_length: Some(1),
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                (
                    "pendingReplies",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        max_items: Some(256),
                        items: Some(&Shape {
                            kinds: Some(&[Kind::String]),
                            min_length: Some(1),
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                (
                    "scoped",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        max_items: Some(512),
                        items: Some(&Shape {
                            kinds: Some(&[Kind::Object]),
                            required: &["scope", "channels"],
                            members: &[
                                (
                                    "channels",
                                    Shape {
                                        kinds: Some(&[Kind::Array]),
                                        min_items: Some(1),
                                        items: Some(&Shape {
                                            kinds: Some(&[Kind::String]),
                                            min_length: Some(1),
                                            ..NONE
                                        }),
                                        ..NONE
                                    },
                                ),
                                ("lastEventId", of(&[Kind::String])),
                                ("scope", reference("ResourceId")),
                            ],
                            closed: Some(&["channels", "lastEventId", "scope"]),
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["clientId", "global", "pendingReplies", "scoped"]),
            ..NONE
        },
    ),
    (
        "CacheStatus",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("pending"),
                Listed::Text("ready"),
                Listed::Text("failed"),
            ]),
            ..NONE
        },
    ),
    (
        "Cancelled",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["requestId"],
            members: &[
                ("reason", of(&[Kind::String])),
                ("requestId", reference("RequestId")),
            ],
            closed: Some(&["reason", "requestId"]),
            ..NONE
        },
    ),
    (
        "ClaimOptions",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["accepts"],
            members: &[
                (
                    "accepts",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        min_items: Some(1),
                        items: Some(&reference("JobFilter")),
                        ..NONE
                    },
                ),
                (
                    "heldJobStallCheckMs",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "heldJobStallMs",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "jobClaimTimeoutMs",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "markCommitTimeoutMs",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "accepts",
                "heldJobStallCheckMs",
                "heldJobStallMs",
                "jobClaimTimeoutMs",
                "markCommitTimeoutMs",
            ]),
            ..NONE
        },
    ),
    (
        "ClaimRefusal",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["code", "message"],
            members: &[
                (
                    "code",
                    Shape {
                        kinds: Some(&[Kind::String, Kind::Null]),
                        one_of: &[
                            of(&[Kind::Null]),
                            Shape {
                                kinds: Some(&[Kind::String]),
                                enumeration: Some(&[
                                    Listed::Text("bus.timeout"),
                                    Listed::Text("bus.rejected"),
                                    Listed::Text("bus.closed"),
                                    Listed::Text("bus.not-found"),
                                    Listed::Text("bus.unsubscribed"),
                                    Listed::Text("bus.peer-unavailable"),
                                    Listed::Text("bus.unauthorized"),
                                    Listed::Text("bus.none-pending"),
                                ]),
                                ..NONE
                            },
                        ],
                        ..NONE
                    },
                ),
                ("message", of(&[Kind::String])),
            ],
            closed: Some(&["code", "message"]),
            ..NONE
        },
    ),
    (
        "ClientSecretForm",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["grant_type", "client_id", "client_secret"],
            members: &[
                ("client_id", of(&[Kind::String])),
                ("client_secret", of(&[Kind::String])),
                (
                    "grant_type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("client_credentials")]),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "CloneResourceWithTokenResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["token", "expiresAt", "resource"],
            members: &[
                ("expiresAt", of(&[Kind::String])),
                ("resource", reference("ResourceDescriptor")),
                ("token", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "CommandError",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["message"],
            members: &[
                (
                    "code",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        recognized: Some(&[
                            "peer-unavailable",
                            "not-found",
                            "unauthorized",
                            "none-pending",
                        ]),
                        ..NONE
                    },
                ),
                ("details", of(&[Kind::String])),
                ("message", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "CommentingJobParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["motivation"],
            members: &[
                ("density", of(&[Kind::Number])),
                ("instructions", of(&[Kind::String])),
                ("language", of(&[Kind::String])),
                (
                    "motivation",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("commenting")]),
                        ..NONE
                    },
                ),
                ("sourceLanguage", of(&[Kind::String])),
                (
                    "tone",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("scholarly"),
                            Listed::Text("explanatory"),
                            Listed::Text("conversational"),
                            Listed::Text("technical"),
                        ]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "density",
                "instructions",
                "language",
                "motivation",
                "sourceLanguage",
                "tone",
            ]),
            ..NONE
        },
    ),
    (
        "ConformanceBusFetch",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["fetch", "as"],
            members: &[
                (
                    "as",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        pattern: Some(&[
                            Term::Step(Step {
                                of: &[(65, 90), (97, 122)],
                                min: 1,
                                max: Some(1),
                            }),
                            Term::Step(Step {
                                of: &[(48, 57), (65, 90), (97, 122)],
                                min: 0,
                                max: None,
                            }),
                        ]),
                        ..NONE
                    },
                ),
                (
                    "fetch",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        pattern: Some(&[
                            Term::Step(Step {
                                of: &[(97, 122)],
                                min: 1,
                                max: None,
                            }),
                            Term::Step(Step {
                                of: &[(58, 58)],
                                min: 1,
                                max: Some(1),
                            }),
                            Term::Step(Step {
                                of: &[(45, 45), (97, 122)],
                                min: 1,
                                max: None,
                            }),
                        ]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["as", "fetch", "payload"]),
            ..NONE
        },
    ),
    (
        "ConformanceCase",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["about", "source", "steps"],
            members: &[
                (
                    "about",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "planes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        min_items: Some(1),
                        items: Some(&Shape {
                            kinds: Some(&[Kind::String]),
                            enumeration: Some(&[Listed::Text("in-process"), Listed::Text("nats")]),
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                (
                    "source",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "steps",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        min_items: Some(1),
                        items: Some(&reference("ConformanceStep")),
                        ..NONE
                    },
                ),
                (
                    "telemetry",
                    Shape {
                        kinds: Some(&[Kind::Boolean]),
                        enumeration: Some(&[Listed::Boolean(true)]),
                        ..NONE
                    },
                ),
                (
                    "tier",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("fleet"), Listed::Text("parity")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["about", "planes", "source", "steps", "telemetry", "tier"]),
            ..NONE
        },
    ),
    (
        "ConformanceDriverLine",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["ready"],
                    members: &[(
                        "ready",
                        Shape {
                            kinds: Some(&[Kind::Boolean]),
                            enumeration: Some(&[Listed::Boolean(true)]),
                            ..NONE
                        },
                    )],
                    closed: Some(&["ready"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["id", "ok"],
                    members: &[(
                        "id",
                        Shape {
                            kinds: Some(&[Kind::Integer]),
                            minimum: Some(1.0),
                            ..NONE
                        },
                    )],
                    closed: Some(&["id", "ok"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["id", "error"],
                    members: &[
                        ("error", reference("ConformanceFailure")),
                        (
                            "id",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(1.0),
                                ..NONE
                            },
                        ),
                    ],
                    closed: Some(&["error", "id"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["id", "abandoned"],
                    members: &[
                        (
                            "abandoned",
                            Shape {
                                kinds: Some(&[Kind::Boolean]),
                                enumeration: Some(&[Listed::Boolean(true)]),
                                ..NONE
                            },
                        ),
                        (
                            "id",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(1.0),
                                ..NONE
                            },
                        ),
                    ],
                    closed: Some(&["abandoned", "id"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["id", "unsupported"],
                    members: &[
                        (
                            "id",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(1.0),
                                ..NONE
                            },
                        ),
                        (
                            "unsupported",
                            Shape {
                                kinds: Some(&[Kind::Boolean]),
                                enumeration: Some(&[Listed::Boolean(true)]),
                                ..NONE
                            },
                        ),
                    ],
                    closed: Some(&["id", "unsupported"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["id", "misuse"],
                    members: &[
                        (
                            "id",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(1.0),
                                ..NONE
                            },
                        ),
                        ("misuse", of(&[Kind::String])),
                    ],
                    closed: Some(&["id", "misuse"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["state"],
                    members: &[("state", of(&[Kind::String]))],
                    closed: Some(&["state"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["frame"],
                    members: &[(
                        "frame",
                        Shape {
                            kinds: Some(&[Kind::Object]),
                            required: &["channel"],
                            members: &[
                                ("channel", of(&[Kind::String])),
                                ("correlationId", of(&[Kind::String])),
                                ("scope", reference("ResourceId")),
                            ],
                            closed: Some(&["channel", "correlationId", "payload", "scope"]),
                            ..NONE
                        },
                    )],
                    closed: Some(&["frame"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["error"],
                    members: &[("error", reference("ConformanceFailure"))],
                    closed: Some(&["error"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["progress"],
                    members: &[(
                        "progress",
                        Shape {
                            kinds: Some(&[Kind::Object]),
                            required: &["upload", "bytesUploaded", "totalBytes"],
                            members: &[
                                (
                                    "bytesUploaded",
                                    Shape {
                                        kinds: Some(&[Kind::Integer]),
                                        minimum: Some(0.0),
                                        ..NONE
                                    },
                                ),
                                (
                                    "totalBytes",
                                    Shape {
                                        kinds: Some(&[Kind::Integer]),
                                        minimum: Some(0.0),
                                        ..NONE
                                    },
                                ),
                                (
                                    "upload",
                                    Shape {
                                        kinds: Some(&[Kind::Integer]),
                                        minimum: Some(1.0),
                                        ..NONE
                                    },
                                ),
                            ],
                            closed: Some(&["bytesUploaded", "totalBytes", "upload"]),
                            ..NONE
                        },
                    )],
                    closed: Some(&["progress"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["emission"],
                    members: &[(
                        "emission",
                        Shape {
                            kinds: Some(&[Kind::Object]),
                            required: &["observer", "state"],
                            members: &[
                                ("observer", of(&[Kind::String])),
                                (
                                    "state",
                                    Shape {
                                        kinds: Some(&[Kind::Object]),
                                        one_of: &[
                                            Shape {
                                                kinds: Some(&[Kind::Object]),
                                                required: &["status"],
                                                members: &[(
                                                    "status",
                                                    Shape {
                                                        kinds: Some(&[Kind::String]),
                                                        enumeration: Some(&[Listed::Text(
                                                            "pending",
                                                        )]),
                                                        ..NONE
                                                    },
                                                )],
                                                closed: Some(&["status"]),
                                                ..NONE
                                            },
                                            Shape {
                                                kinds: Some(&[Kind::Object]),
                                                required: &["status", "value"],
                                                members: &[(
                                                    "status",
                                                    Shape {
                                                        kinds: Some(&[Kind::String]),
                                                        enumeration: Some(&[Listed::Text("ready")]),
                                                        ..NONE
                                                    },
                                                )],
                                                closed: Some(&["status", "value"]),
                                                ..NONE
                                            },
                                            Shape {
                                                kinds: Some(&[Kind::Object]),
                                                required: &["status", "error"],
                                                members: &[
                                                    ("error", reference("ConformanceFailure")),
                                                    (
                                                        "status",
                                                        Shape {
                                                            kinds: Some(&[Kind::String]),
                                                            enumeration: Some(&[Listed::Text(
                                                                "failed",
                                                            )]),
                                                            ..NONE
                                                        },
                                                    ),
                                                ],
                                                closed: Some(&["error", "status"]),
                                                ..NONE
                                            },
                                        ],
                                        ..NONE
                                    },
                                ),
                            ],
                            closed: Some(&["observer", "state"]),
                            ..NONE
                        },
                    )],
                    closed: Some(&["emission"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["completed"],
                    members: &[("completed", of(&[Kind::String]))],
                    closed: Some(&["completed"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["claimed"],
                    members: &[("claimed", reference("HeldJobRecord"))],
                    closed: Some(&["claimed"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["refused"],
                    members: &[("refused", reference("ConformanceFailure"))],
                    closed: Some(&["refused"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["signalled"],
                    members: &[("signalled", of(&[Kind::String]))],
                    closed: Some(&["signalled"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["stalled"],
                    members: &[("stalled", of(&[Kind::String]))],
                    closed: Some(&["stalled"]),
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "ConformanceFailure",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["detail"],
            members: &[
                ("code", of(&[Kind::String])),
                ("detail", of(&[Kind::String])),
                ("failureClass", reference("FailureClass")),
                ("status", of(&[Kind::Integer])),
            ],
            closed: Some(&["code", "detail", "failureClass", "status"]),
            ..NONE
        },
    ),
    (
        "ConformanceHttpFetch",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["fetch"],
            members: &[(
                "fetch",
                Shape {
                    kinds: Some(&[Kind::String]),
                    pattern: Some(&[
                        Term::Step(Step {
                            of: &[(71, 71)],
                            min: 1,
                            max: Some(1),
                        }),
                        Term::Step(Step {
                            of: &[(69, 69)],
                            min: 1,
                            max: Some(1),
                        }),
                        Term::Step(Step {
                            of: &[(84, 84)],
                            min: 1,
                            max: Some(1),
                        }),
                        Term::Step(Step {
                            of: &[(32, 32)],
                            min: 1,
                            max: Some(1),
                        }),
                        Term::Step(Step {
                            of: &[(47, 47)],
                            min: 1,
                            max: Some(1),
                        }),
                        Term::Step(Step {
                            of: &[(0, 1114111)],
                            min: 0,
                            max: None,
                        }),
                    ]),
                    ..NONE
                },
            )],
            closed: Some(&["fetch", "params"]),
            ..NONE
        },
    ),
    (
        "ConformanceImplementations",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["launcher", "target", "sdks"],
            members: &[
                (
                    "launcher",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        min_items: Some(1),
                        items: Some(&Shape {
                            kinds: Some(&[Kind::String]),
                            min_length: Some(1),
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                (
                    "modelCatalogue",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "sdks",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        values: Some(&Shape {
                            kinds: Some(&[Kind::Object]),
                            members: &[
                                (
                                    "exempt",
                                    Shape {
                                        kinds: Some(&[Kind::Object]),
                                        values: Some(&Shape {
                                            kinds: Some(&[Kind::String]),
                                            min_length: Some(1),
                                            ..NONE
                                        }),
                                        ..NONE
                                    },
                                ),
                                (
                                    "live",
                                    Shape {
                                        kinds: Some(&[Kind::Object]),
                                        required: &["command", "tier"],
                                        members: &[
                                            (
                                                "command",
                                                Shape {
                                                    kinds: Some(&[Kind::Array]),
                                                    min_items: Some(1),
                                                    items: Some(&Shape {
                                                        kinds: Some(&[Kind::String]),
                                                        min_length: Some(1),
                                                        ..NONE
                                                    }),
                                                    ..NONE
                                                },
                                            ),
                                            (
                                                "tier",
                                                Shape {
                                                    kinds: Some(&[Kind::String]),
                                                    enumeration: Some(&[
                                                        Listed::Text("fleet"),
                                                        Listed::Text("parity"),
                                                    ]),
                                                    ..NONE
                                                },
                                            ),
                                        ],
                                        closed: Some(&["command", "tier"]),
                                        ..NONE
                                    },
                                ),
                                (
                                    "wire",
                                    Shape {
                                        kinds: Some(&[Kind::Array]),
                                        min_items: Some(1),
                                        items: Some(&Shape {
                                            kinds: Some(&[Kind::String]),
                                            min_length: Some(1),
                                            ..NONE
                                        }),
                                        ..NONE
                                    },
                                ),
                                (
                                    "worker",
                                    Shape {
                                        kinds: Some(&[Kind::Array]),
                                        min_items: Some(1),
                                        items: Some(&Shape {
                                            kinds: Some(&[Kind::String]),
                                            min_length: Some(1),
                                            ..NONE
                                        }),
                                        ..NONE
                                    },
                                ),
                            ],
                            closed: Some(&["exempt", "live", "wire", "worker"]),
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                ("target", reference("LocalTarget")),
            ],
            closed: Some(&["launcher", "modelCatalogue", "sdks", "target"]),
            ..NONE
        },
    ),
    (
        "ConformanceStep",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["let"],
                    members: &[(
                        "let",
                        Shape {
                            kinds: Some(&[Kind::Object]),
                            min_members: Some(1),
                            ..NONE
                        },
                    )],
                    closed: Some(&["let"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["driver"],
                    members: &[
                        (
                            "as",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                pattern: Some(&[
                                    Term::Step(Step {
                                        of: &[(65, 90), (97, 122)],
                                        min: 1,
                                        max: Some(1),
                                    }),
                                    Term::Step(Step {
                                        of: &[(48, 57), (65, 90), (97, 122)],
                                        min: 0,
                                        max: None,
                                    }),
                                ]),
                                ..NONE
                            },
                        ),
                        (
                            "driver",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                min_length: Some(1),
                                ..NONE
                            },
                        ),
                        ("with", of(&[Kind::Object])),
                    ],
                    closed: Some(&["as", "driver", "fails", "returns", "with"]),
                    not_all: &[&["returns", "fails"]],
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["abandon"],
                    members: &[(
                        "abandon",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            pattern: Some(&[
                                Term::Step(Step {
                                    of: &[(65, 90), (97, 122)],
                                    min: 1,
                                    max: Some(1),
                                }),
                                Term::Step(Step {
                                    of: &[(48, 57), (65, 90), (97, 122)],
                                    min: 0,
                                    max: None,
                                }),
                            ]),
                            ..NONE
                        },
                    )],
                    closed: Some(&["abandon"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["settles"],
                    members: &[
                        (
                            "abandoned",
                            Shape {
                                kinds: Some(&[Kind::Boolean]),
                                enumeration: Some(&[Listed::Boolean(true)]),
                                ..NONE
                            },
                        ),
                        (
                            "settles",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                pattern: Some(&[
                                    Term::Step(Step {
                                        of: &[(65, 90), (97, 122)],
                                        min: 1,
                                        max: Some(1),
                                    }),
                                    Term::Step(Step {
                                        of: &[(48, 57), (65, 90), (97, 122)],
                                        min: 0,
                                        max: None,
                                    }),
                                ]),
                                ..NONE
                            },
                        ),
                    ],
                    closed: Some(&["abandoned", "fails", "returns", "settles"]),
                    not_all: &[
                        &["returns", "fails"],
                        &["returns", "abandoned"],
                        &["fails", "abandoned"],
                    ],
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["wire"],
                    members: &[
                        (
                            "as",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                pattern: Some(&[
                                    Term::Step(Step {
                                        of: &[(65, 90), (97, 122)],
                                        min: 1,
                                        max: Some(1),
                                    }),
                                    Term::Step(Step {
                                        of: &[(48, 57), (65, 90), (97, 122)],
                                        min: 0,
                                        max: None,
                                    }),
                                ]),
                                ..NONE
                            },
                        ),
                        (
                            "at",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                enumeration: Some(&[
                                    Listed::Text("arrival"),
                                    Listed::Text("answer"),
                                    Listed::Text("live"),
                                ]),
                                ..NONE
                            },
                        ),
                        (
                            "follows",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                pattern: Some(&[
                                    Term::Step(Step {
                                        of: &[(65, 90), (97, 122)],
                                        min: 1,
                                        max: Some(1),
                                    }),
                                    Term::Step(Step {
                                        of: &[(48, 57), (65, 90), (97, 122)],
                                        min: 0,
                                        max: None,
                                    }),
                                ]),
                                ..NONE
                            },
                        ),
                        ("headers", of(&[Kind::Object])),
                        ("status", of(&[Kind::Integer])),
                        (
                            "waited",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                pattern: Some(&[
                                    Term::Step(Step {
                                        of: &[(65, 90), (97, 122)],
                                        min: 1,
                                        max: Some(1),
                                    }),
                                    Term::Step(Step {
                                        of: &[(48, 57), (65, 90), (97, 122)],
                                        min: 0,
                                        max: None,
                                    }),
                                ]),
                                ..NONE
                            },
                        ),
                        (
                            "wire",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                pattern: Some(&[
                                    Term::Group(Group {
                                        either: &[
                                            &[
                                                Term::Step(Step {
                                                    of: &[(71, 71)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                                Term::Step(Step {
                                                    of: &[(69, 69)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                                Term::Step(Step {
                                                    of: &[(84, 84)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                            ],
                                            &[
                                                Term::Step(Step {
                                                    of: &[(80, 80)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                                Term::Step(Step {
                                                    of: &[(79, 79)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                                Term::Step(Step {
                                                    of: &[(83, 83)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                                Term::Step(Step {
                                                    of: &[(84, 84)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                            ],
                                            &[
                                                Term::Step(Step {
                                                    of: &[(80, 80)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                                Term::Step(Step {
                                                    of: &[(85, 85)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                                Term::Step(Step {
                                                    of: &[(84, 84)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                            ],
                                            &[
                                                Term::Step(Step {
                                                    of: &[(68, 68)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                                Term::Step(Step {
                                                    of: &[(69, 69)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                                Term::Step(Step {
                                                    of: &[(76, 76)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                                Term::Step(Step {
                                                    of: &[(69, 69)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                                Term::Step(Step {
                                                    of: &[(84, 84)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                                Term::Step(Step {
                                                    of: &[(69, 69)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                            ],
                                            &[
                                                Term::Step(Step {
                                                    of: &[(80, 80)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                                Term::Step(Step {
                                                    of: &[(65, 65)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                                Term::Step(Step {
                                                    of: &[(84, 84)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                                Term::Step(Step {
                                                    of: &[(67, 67)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                                Term::Step(Step {
                                                    of: &[(72, 72)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                            ],
                                        ],
                                        min: 1,
                                        max: Some(1),
                                    }),
                                    Term::Step(Step {
                                        of: &[(32, 32)],
                                        min: 1,
                                        max: Some(1),
                                    }),
                                    Term::Step(Step {
                                        of: &[(47, 47)],
                                        min: 1,
                                        max: Some(1),
                                    }),
                                    Term::Step(Step {
                                        of: &[(0, 1114111)],
                                        min: 0,
                                        max: None,
                                    }),
                                ]),
                                ..NONE
                            },
                        ),
                    ],
                    closed: Some(&[
                        "answer", "as", "at", "body", "follows", "headers", "params", "status",
                        "token", "waited", "wire",
                    ]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["carried", "is"],
                    members: &[(
                        "carried",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            pattern: Some(&[
                                Term::Step(Step {
                                    of: &[(65, 90), (97, 122)],
                                    min: 1,
                                    max: Some(1),
                                }),
                                Term::Step(Step {
                                    of: &[(48, 57), (65, 90), (97, 122)],
                                    min: 0,
                                    max: None,
                                }),
                            ]),
                            ..NONE
                        },
                    )],
                    closed: Some(&["carried", "is"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["closed"],
                    members: &[(
                        "closed",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            pattern: Some(&[
                                Term::Step(Step {
                                    of: &[(65, 90), (97, 122)],
                                    min: 1,
                                    max: Some(1),
                                }),
                                Term::Step(Step {
                                    of: &[(48, 57), (65, 90), (97, 122)],
                                    min: 0,
                                    max: None,
                                }),
                            ]),
                            ..NONE
                        },
                    )],
                    closed: Some(&["closed"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["progress"],
                    members: &[(
                        "progress",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            pattern: Some(&[
                                Term::Step(Step {
                                    of: &[(65, 90), (97, 122)],
                                    min: 1,
                                    max: Some(1),
                                }),
                                Term::Step(Step {
                                    of: &[(48, 57), (65, 90), (97, 122)],
                                    min: 0,
                                    max: None,
                                }),
                            ]),
                            ..NONE
                        },
                    )],
                    closed: Some(&["progress"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["state"],
                    members: &[("state", reference("ConnectionState"))],
                    closed: Some(&["state"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["stays"],
                    members: &[("stays", reference("ConnectionState"))],
                    closed: Some(&["stays"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["frame", "is"],
                    members: &[(
                        "frame",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            min_length: Some(1),
                            ..NONE
                        },
                    )],
                    closed: Some(&["frame", "is"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["frames", "count"],
                    members: &[
                        (
                            "count",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(1.0),
                                ..NONE
                            },
                        ),
                        (
                            "frames",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                min_length: Some(1),
                                ..NONE
                            },
                        ),
                    ],
                    closed: Some(&["count", "frames"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["error"],
                    closed: Some(&["error"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["backend"],
                    members: &[
                        (
                            "backend",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                enumeration: Some(&[
                                    Listed::Text("listen"),
                                    Listed::Text("emit"),
                                    Listed::Text("record"),
                                    Listed::Text("content"),
                                    Listed::Text("description"),
                                    Listed::Text("annotations"),
                                    Listed::Text("anchored-text"),
                                    Listed::Text("uploaded"),
                                    Listed::Text("refuse"),
                                    Listed::Text("unanswered"),
                                    Listed::Text("answer-lost"),
                                    Listed::Text("hold"),
                                    Listed::Text("release"),
                                    Listed::Text("rechunk"),
                                    Listed::Text("carry"),
                                    Listed::Text("cut"),
                                    Listed::Text("down"),
                                    Listed::Text("up"),
                                    Listed::Text("archivist"),
                                ]),
                                ..NONE
                            },
                        ),
                        ("with", of(&[Kind::Object])),
                    ],
                    closed: Some(&["backend", "with"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["quiet"],
                    members: &[(
                        "quiet",
                        Shape {
                            kinds: Some(&[Kind::Integer]),
                            minimum: Some(1.0),
                            ..NONE
                        },
                    )],
                    closed: Some(&["quiet"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["observe", "as"],
                    members: &[
                        (
                            "as",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                pattern: Some(&[
                                    Term::Step(Step {
                                        of: &[(65, 90), (97, 122)],
                                        min: 1,
                                        max: Some(1),
                                    }),
                                    Term::Step(Step {
                                        of: &[(48, 57), (65, 90), (97, 122)],
                                        min: 0,
                                        max: None,
                                    }),
                                ]),
                                ..NONE
                            },
                        ),
                        (
                            "observe",
                            Shape {
                                kinds: Some(&[Kind::Object]),
                                required: &["query"],
                                members: &[(
                                    "query",
                                    Shape {
                                        kinds: Some(&[Kind::String]),
                                        min_length: Some(1),
                                        ..NONE
                                    },
                                )],
                                closed: Some(&[
                                    "annotation",
                                    "filters",
                                    "query",
                                    "resource",
                                    "search",
                                ]),
                                ..NONE
                            },
                        ),
                    ],
                    closed: Some(&["as", "observe"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["leave"],
                    members: &[(
                        "leave",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            pattern: Some(&[
                                Term::Step(Step {
                                    of: &[(65, 90), (97, 122)],
                                    min: 1,
                                    max: Some(1),
                                }),
                                Term::Step(Step {
                                    of: &[(48, 57), (65, 90), (97, 122)],
                                    min: 0,
                                    max: None,
                                }),
                            ]),
                            ..NONE
                        },
                    )],
                    closed: Some(&["leave"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["reaches", "state"],
                    members: &[(
                        "reaches",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            pattern: Some(&[
                                Term::Step(Step {
                                    of: &[(65, 90), (97, 122)],
                                    min: 1,
                                    max: Some(1),
                                }),
                                Term::Step(Step {
                                    of: &[(48, 57), (65, 90), (97, 122)],
                                    min: 0,
                                    max: None,
                                }),
                            ]),
                            ..NONE
                        },
                    )],
                    closed: Some(&["reaches", "state"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["holds", "state"],
                    members: &[(
                        "holds",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            pattern: Some(&[
                                Term::Step(Step {
                                    of: &[(65, 90), (97, 122)],
                                    min: 1,
                                    max: Some(1),
                                }),
                                Term::Step(Step {
                                    of: &[(48, 57), (65, 90), (97, 122)],
                                    min: 0,
                                    max: None,
                                }),
                            ]),
                            ..NONE
                        },
                    )],
                    closed: Some(&["holds", "state"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["completes"],
                    members: &[(
                        "completes",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            pattern: Some(&[
                                Term::Step(Step {
                                    of: &[(65, 90), (97, 122)],
                                    min: 1,
                                    max: Some(1),
                                }),
                                Term::Step(Step {
                                    of: &[(48, 57), (65, 90), (97, 122)],
                                    min: 0,
                                    max: None,
                                }),
                            ]),
                            ..NONE
                        },
                    )],
                    closed: Some(&["completes"]),
                    ..NONE
                },
                reference("ConformanceBusFetch"),
                reference("ConformanceHttpFetch"),
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["fetches"],
                    members: &[(
                        "fetches",
                        Shape {
                            kinds: Some(&[Kind::Array]),
                            min_items: Some(2),
                            items: Some(&Shape {
                                kinds: Some(&[Kind::Object]),
                                one_of: &[
                                    reference("ConformanceBusFetch"),
                                    reference("ConformanceHttpFetch"),
                                ],
                                ..NONE
                            }),
                            ..NONE
                        },
                    )],
                    closed: Some(&["fetches"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["scopes"],
                    members: &[("scopes", of(&[Kind::Array]))],
                    closed: Some(&["scopes"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["claimed"],
                    closed: Some(&["claimed"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["refused"],
                    closed: Some(&["refused"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["signalled"],
                    closed: Some(&["signalled"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["stalled"],
                    closed: Some(&["stalled"]),
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "ConnectionIdentity",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["did", "description"],
            members: &[
                ("description", reference("KbDescription")),
                ("did", reference("UserId")),
            ],
            closed: Some(&["description", "did"]),
            ..NONE
        },
    ),
    (
        "ConnectionState",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("initial"),
                Listed::Text("connecting"),
                Listed::Text("open"),
                Listed::Text("reconnecting"),
                Listed::Text("degraded"),
                Listed::Text("unauthenticated"),
                Listed::Text("closed"),
            ]),
            ..NONE
        },
    ),
    ("ContentFormat", of(&[Kind::String])),
    (
        "ContextualSummaryResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["summary", "relevantFields", "context"],
            members: &[
                (
                    "context",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["selected"],
                        members: &[
                            ("after", of(&[Kind::String])),
                            ("before", of(&[Kind::String])),
                            ("selected", of(&[Kind::String])),
                        ],
                        ..NONE
                    },
                ),
                (
                    "relevantFields",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["resourceId", "resourceName", "entityTypes"],
                        members: &[
                            (
                                "entityTypes",
                                Shape {
                                    kinds: Some(&[Kind::Array]),
                                    items: Some(&of(&[Kind::String])),
                                    ..NONE
                                },
                            ),
                            ("resourceId", reference("ResourceId")),
                            ("resourceName", of(&[Kind::String])),
                        ],
                        closed: Some(&["entityTypes", "resourceId", "resourceName"]),
                        ..NONE
                    },
                ),
                ("summary", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "ControlSender",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[Listed::Text("client"), Listed::Text("launcher")]),
            ..NONE
        },
    ),
    (
        "CreateAnnotationRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["target", "motivation"],
            members: &[
                ("body", reference("AnnotationBodies")),
                ("motivation", reference("Motivation")),
                ("target", reference("AnnotationTarget")),
            ],
            ..NONE
        },
    ),
    (
        "CreateFromTokenOptions",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["token", "name", "content"],
            members: &[
                ("archiveOriginal", of(&[Kind::Boolean])),
                ("content", of(&[Kind::String])),
                ("name", of(&[Kind::String])),
                ("token", of(&[Kind::String])),
            ],
            closed: Some(&["archiveOriginal", "content", "name", "token"]),
            ..NONE
        },
    ),
    (
        "CreateResourceResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId"],
            members: &[("resourceId", reference("ResourceId"))],
            ..NONE
        },
    ),
    (
        "CursorsPath",
        Shape {
            kinds: Some(&[Kind::String]),
            min_length: Some(1),
            ..NONE
        },
    ),
    (
        "DeviceCode",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["userCode", "verificationUri", "expiresIn"],
            members: &[
                (
                    "expiresIn",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("userCode", of(&[Kind::String])),
                ("verificationUri", of(&[Kind::String])),
                ("verificationUriComplete", of(&[Kind::String])),
            ],
            closed: Some(&[
                "expiresIn",
                "userCode",
                "verificationUri",
                "verificationUriComplete",
            ]),
            ..NONE
        },
    ),
    (
        "DirEntry",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["type", "name", "path", "mtime"],
            members: &[
                ("mtime", of(&[Kind::String])),
                ("name", of(&[Kind::String])),
                ("path", of(&[Kind::String])),
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("dir")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["mtime", "name", "path", "type"]),
            ..NONE
        },
    ),
    (
        "DirectoryEntry",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[reference("FileEntry"), reference("DirEntry")],
            discriminator: Some(Discriminator {
                property: "type",
                mapping: &[("file", 0), ("dir", 1)],
            }),
            ..NONE
        },
    ),
    (
        "DiscoveredKB",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["host", "port", "placement", "did", "managedBy"],
            members: &[
                ("did", of(&[Kind::String])),
                ("host", of(&[Kind::String])),
                ("managedBy", of(&[Kind::String])),
                ("placement", reference("KbPlacement")),
                (
                    "port",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(65535.0),
                        ..NONE
                    },
                ),
                ("repo", of(&[Kind::String])),
                ("siteName", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "DiscoveryAbsent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["kind", "reason"],
            members: &[
                (
                    "diagnostic",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "kind",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("absent")]),
                        ..NONE
                    },
                ),
                (
                    "reason",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("not-found"),
                            Listed::Text("not-json"),
                            Listed::Text("invalid"),
                            Listed::Text("unsupported-version"),
                            Listed::Text("unreadable"),
                        ]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["diagnostic", "kind", "reason"]),
            ..NONE
        },
    ),
    (
        "DiscoveryAbsentReason",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("not-found"),
                Listed::Text("not-json"),
                Listed::Text("invalid"),
                Listed::Text("unsupported-version"),
                Listed::Text("unreadable"),
            ]),
            ..NONE
        },
    ),
    (
        "DiscoveryDiff",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["state", "added", "updated", "removed", "duplicated"],
            members: &[
                (
                    "added",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("DiscoveredKB")),
                        ..NONE
                    },
                ),
                (
                    "duplicated",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&Shape {
                            kinds: Some(&[Kind::String]),
                            min_length: Some(1),
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                (
                    "removed",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("DiscoveredKB")),
                        ..NONE
                    },
                ),
                ("state", reference("DiscoveryState")),
                (
                    "updated",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("DiscoveredKB")),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["added", "duplicated", "removed", "state", "updated"]),
            ..NONE
        },
    ),
    (
        "DiscoveryDocument",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["version", "kbs"],
            members: &[
                (
                    "kbs",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("DiscoveredKB")),
                        ..NONE
                    },
                ),
                (
                    "version",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        enumeration: Some(&[Listed::Number(1.0)]),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "DiscoveryManaged",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["kind", "kbs"],
            members: &[
                (
                    "kbs",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("DiscoveredKB")),
                        ..NONE
                    },
                ),
                (
                    "kind",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("managed")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["kbs", "kind"]),
            ..NONE
        },
    ),
    (
        "DiscoveryRead",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("DiscoveryAbsent"),
                reference("DiscoveryManaged"),
                reference("DiscoveryUnchanged"),
            ],
            discriminator: Some(Discriminator {
                property: "kind",
                mapping: &[("absent", 0), ("managed", 1), ("unchanged", 2)],
            }),
            ..NONE
        },
    ),
    (
        "DiscoveryState",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[reference("DiscoveryAbsent"), reference("DiscoveryManaged")],
            discriminator: Some(Discriminator {
                property: "kind",
                mapping: &[("absent", 0), ("managed", 1)],
            }),
            ..NONE
        },
    ),
    (
        "DiscoveryUnchanged",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["kind"],
            members: &[(
                "kind",
                Shape {
                    kinds: Some(&[Kind::String]),
                    enumeration: Some(&[Listed::Text("unchanged")]),
                    ..NONE
                },
            )],
            closed: Some(&["kind"]),
            ..NONE
        },
    ),
    (
        "DispatcherConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "kb",
                "gatewayUrl",
                "identity",
                "queue",
                "port",
                "timing",
                "logLevel",
                "logFormat",
            ],
            members: &[
                (
                    "gatewayUrl",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("identity", reference("ServiceIdentity")),
                ("kb", reference("KbIdentity")),
                ("logFormat", reference("LogFormat")),
                ("logLevel", reference("LogLevel")),
                (
                    "port",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(65535.0),
                        ..NONE
                    },
                ),
                (
                    "queue",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["servers"],
                        members: &[
                            (
                                "passwordEnv",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    min_length: Some(1),
                                    ..NONE
                                },
                            ),
                            (
                                "servers",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    min_length: Some(1),
                                    ..NONE
                                },
                            ),
                            (
                                "userEnv",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    min_length: Some(1),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&["passwordEnv", "servers", "userEnv"]),
                        ..NONE
                    },
                ),
                (
                    "timing",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &[
                            "tickMs",
                            "staleRunningMs",
                            "ackWaitMs",
                            "retentionMs",
                            "retentionSweepMs",
                            "progressWriteIntervalMs",
                            "bootDeadlineMs",
                        ],
                        members: &[
                            (
                                "ackWaitMs",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(1.0),
                                    ..NONE
                                },
                            ),
                            (
                                "bootDeadlineMs",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(1.0),
                                    ..NONE
                                },
                            ),
                            (
                                "progressWriteIntervalMs",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(1.0),
                                    ..NONE
                                },
                            ),
                            (
                                "retentionMs",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(1.0),
                                    ..NONE
                                },
                            ),
                            (
                                "retentionSweepMs",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(1.0),
                                    ..NONE
                                },
                            ),
                            (
                                "staleRunningMs",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(1.0),
                                    ..NONE
                                },
                            ),
                            (
                                "tickMs",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(1.0),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&[
                            "ackWaitMs",
                            "bootDeadlineMs",
                            "progressWriteIntervalMs",
                            "retentionMs",
                            "retentionSweepMs",
                            "staleRunningMs",
                            "tickMs",
                        ]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "gatewayUrl",
                "identity",
                "kb",
                "logFormat",
                "logLevel",
                "port",
                "queue",
                "timing",
            ]),
            ..NONE
        },
    ),
    (
        "DispatcherHealth",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["status", "queue"],
            members: &[
                (
                    "queue",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("jetstream")]),
                        ..NONE
                    },
                ),
                (
                    "status",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("ok")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["queue", "status"]),
            ..NONE
        },
    ),
    (
        "DurabilityEvidence",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("acknowledged"),
                Listed::Text("probe-confirmed"),
                Listed::Text("probe-refused"),
                Listed::Text("probe-unreachable"),
            ]),
            ..NONE
        },
    ),
    (
        "EmbeddingConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("OllamaEmbeddingConfig"),
                reference("VoyageEmbeddingConfig"),
            ],
            discriminator: Some(Discriminator {
                property: "type",
                mapping: &[("ollama", 0), ("voyage", 1)],
            }),
            ..NONE
        },
    ),
    (
        "Engine",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["provider", "model"],
            members: &[
                (
                    "model",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("provider", reference("InferenceProvider")),
            ],
            closed: Some(&["model", "provider"]),
            ..NONE
        },
    ),
    (
        "EngineEntry",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["engine"],
            members: &[
                ("engine", reference("Engine")),
                (
                    "jobs",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("JobFilter")),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["engine", "jobs"]),
            ..NONE
        },
    ),
    (
        "EngineLimits",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["engine", "limits"],
            members: &[
                ("engine", reference("Engine")),
                ("limits", reference("InferenceLimits")),
            ],
            closed: Some(&["engine", "limits"]),
            ..NONE
        },
    ),
    (
        "EnrichedResourceEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            all_of: &[
                reference("StoredEventResponse"),
                Shape {
                    kinds: Some(&[Kind::Object]),
                    members: &[("annotation", reference("Annotation"))],
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "EntityTagChangedPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["entityType"],
            members: &[("entityType", of(&[Kind::String]))],
            ..NONE
        },
    ),
    (
        "EntityTypeAddedPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["entityType"],
            members: &[("entityType", of(&[Kind::String]))],
            ..NONE
        },
    ),
    (
        "EntityTypesProjection",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["entityTypes"],
            members: &[(
                "entityTypes",
                Shape {
                    kinds: Some(&[Kind::Array]),
                    items: Some(&of(&[Kind::String])),
                    ..NONE
                },
            )],
            closed: Some(&["entityTypes"]),
            ..NONE
        },
    ),
    (
        "EphemeralEventId",
        Shape {
            kinds: Some(&[Kind::String]),
            pattern: Some(&[
                Term::Step(Step {
                    of: &[(101, 101)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(45, 45)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(0, 57), (59, 1114111)],
                    min: 1,
                    max: None,
                }),
            ]),
            ..NONE
        },
    ),
    (
        "ErrorData",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["code", "retryable"],
            members: &[
                (
                    "choices",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("Target")),
                        ..NONE
                    },
                ),
                (
                    "code",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("control.invalid-params"),
                            Listed::Text("control.unsupported-api-version"),
                            Listed::Text("control.invalid-request"),
                            Listed::Text("control.invalid-service"),
                            Listed::Text("control.invalid-value"),
                            Listed::Text("control.unknown-setting"),
                            Listed::Text("control.target-required"),
                            Listed::Text("control.target-ambiguous"),
                            Listed::Text("control.root-not-found"),
                            Listed::Text("control.root-not-registered"),
                            Listed::Text("control.stack-not-running"),
                            Listed::Text("control.stack-running"),
                            Listed::Text("control.start-in-progress"),
                            Listed::Text("control.runtime-unavailable"),
                            Listed::Text("control.dependency-unavailable"),
                            Listed::Text("control.unreachable"),
                            Listed::Text("control.instance-in-use"),
                            Listed::Text("control.instance-not-found"),
                            Listed::Text("control.confirmation-required"),
                            Listed::Text("control.unreadable-state"),
                            Listed::Text("control.already-signed-in"),
                            Listed::Text("control.sign-in-failed"),
                            Listed::Text("control.cancelled"),
                            Listed::Text("control.failed"),
                        ]),
                        ..NONE
                    },
                ),
                (
                    "fields",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("FieldFault")),
                        ..NONE
                    },
                ),
                ("mayStillRun", of(&[Kind::Boolean])),
                ("retryable", of(&[Kind::Boolean])),
                (
                    "supported",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "choices",
                "code",
                "fields",
                "mayStillRun",
                "retryable",
                "supported",
            ]),
            ..NONE
        },
    ),
    (
        "ErrorResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["error"],
            members: &[
                ("code", of(&[Kind::String])),
                ("error", of(&[Kind::String])),
                ("hint", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "EventMetadata",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["sequenceNumber"],
            members: &[("sequenceNumber", of(&[Kind::Integer]))],
            ..NONE
        },
    ),
    (
        "Expected",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["did"],
            members: &[("did", of(&[Kind::String])), ("name", of(&[Kind::String]))],
            closed: Some(&["did", "name"]),
            ..NONE
        },
    ),
    (
        "ExtractedText",
        Shape {
            kinds: Some(&[Kind::Object]),
            all_of: &[
                reference("AnchoredText"),
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["kind", "method"],
                    members: &[
                        (
                            "kind",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                enumeration: Some(&[Listed::Text("extracted")]),
                                ..NONE
                            },
                        ),
                        ("method", reference("ExtractionMethod")),
                        ("ocrConfidence", reference("OcrConfidence")),
                        ("pdfClass", reference("PdfClass")),
                        (
                            "unreadPages",
                            Shape {
                                kinds: Some(&[Kind::Array]),
                                items: Some(&of(&[Kind::Integer])),
                                ..NONE
                            },
                        ),
                    ],
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "ExtractionDeclined",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["kind", "declined"],
            members: &[
                ("declined", reference("ExtractionDeclinedReason")),
                (
                    "kind",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("declined")]),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "ExtractionDeclinedReason",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("no-text-layer"),
                Listed::Text("encrypted"),
                Listed::Text("corrupt"),
                Listed::Text("too-large"),
            ]),
            ..NONE
        },
    ),
    (
        "ExtractionMethod",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("text-passthrough"),
                Listed::Text("pdf-text-layer"),
                Listed::Text("table"),
                Listed::Text("form"),
                Listed::Text("ocr"),
            ]),
            ..NONE
        },
    ),
    (
        "ExtractionOutcome",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[reference("ExtractedText"), reference("ExtractionDeclined")],
            discriminator: Some(Discriminator {
                property: "kind",
                mapping: &[("extracted", 0), ("declined", 1)],
            }),
            ..NONE
        },
    ),
    (
        "FailureClass",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("transient"),
                Listed::Text("deterministic"),
                Listed::Text("withheld"),
            ]),
            ..NONE
        },
    ),
    (
        "Fault",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["member", "reason"],
            members: &[
                (
                    "member",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        pattern: Some(&[Term::Group(Group {
                            either: &[&[
                                Term::Step(Step {
                                    of: &[(65, 90), (97, 122)],
                                    min: 1,
                                    max: None,
                                }),
                                Term::Group(Group {
                                    either: &[&[
                                        Term::Step(Step {
                                            of: &[(46, 46)],
                                            min: 1,
                                            max: Some(1),
                                        }),
                                        Term::Step(Step {
                                            of: &[(65, 90), (97, 122)],
                                            min: 1,
                                            max: None,
                                        }),
                                    ]],
                                    min: 0,
                                    max: None,
                                }),
                            ]],
                            min: 0,
                            max: Some(1),
                        })]),
                        ..NONE
                    },
                ),
                ("reason", reference("FrameRefusalReason")),
            ],
            closed: Some(&["member", "reason"]),
            ..NONE
        },
    ),
    (
        "FieldFault",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["field", "message"],
            members: &[
                ("field", of(&[Kind::String])),
                ("message", of(&[Kind::String])),
            ],
            closed: Some(&["field", "message"]),
            ..NONE
        },
    ),
    (
        "FileEntry",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["type", "name", "path", "size", "mtime", "tracked"],
            members: &[
                ("annotationCount", of(&[Kind::Integer])),
                ("creator", of(&[Kind::String])),
                (
                    "entityTypes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("mtime", of(&[Kind::String])),
                ("name", of(&[Kind::String])),
                ("path", of(&[Kind::String])),
                ("resourceId", reference("ResourceId")),
                ("size", of(&[Kind::Integer])),
                ("tracked", of(&[Kind::Boolean])),
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("file")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "annotationCount",
                "creator",
                "entityTypes",
                "mtime",
                "name",
                "path",
                "resourceId",
                "size",
                "tracked",
                "type",
            ]),
            ..NONE
        },
    ),
    (
        "FollowerFollowing",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["sweep", "stopped", "refused", "streamDrops"],
            members: &[
                (
                    "refused",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "stopped",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "streamDrops",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "sweep",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("pending"),
                            Listed::Text("running"),
                            Listed::Text("done"),
                            Listed::Text("due"),
                        ]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["refused", "stopped", "streamDrops", "sweep"]),
            ..NONE
        },
    ),
    (
        "FragmentSelector",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["type", "value"],
            members: &[
                ("conformsTo", of(&[Kind::String])),
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("FragmentSelector")]),
                        ..NONE
                    },
                ),
                ("value", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "FrameAddEntityTypeCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["tag"],
            members: &[
                ("_userId", reference("UserId")),
                ("tag", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "FrameAddTagSchemaCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["schema"],
            members: &[
                ("_userId", reference("UserId")),
                ("schema", reference("TagSchema")),
            ],
            ..NONE
        },
    ),
    (
        "FrameRefusal",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["channel", "member", "reason"],
            members: &[
                (
                    "channel",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "correlationId",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "member",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        pattern: Some(&[Term::Group(Group {
                            either: &[&[
                                Term::Step(Step {
                                    of: &[(65, 90), (97, 122)],
                                    min: 1,
                                    max: None,
                                }),
                                Term::Group(Group {
                                    either: &[&[
                                        Term::Step(Step {
                                            of: &[(46, 46)],
                                            min: 1,
                                            max: Some(1),
                                        }),
                                        Term::Step(Step {
                                            of: &[(65, 90), (97, 122)],
                                            min: 1,
                                            max: None,
                                        }),
                                    ]],
                                    min: 0,
                                    max: None,
                                }),
                            ]],
                            min: 0,
                            max: Some(1),
                        })]),
                        ..NONE
                    },
                ),
                ("reason", reference("FrameRefusalReason")),
                ("scope", reference("ResourceId")),
            ],
            closed: Some(&[
                "channel",
                "correlationId",
                "member",
                "payload",
                "reason",
                "scope",
            ]),
            ..NONE
        },
    ),
    (
        "FrameRefusalReason",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[Listed::Text("lacks"), Listed::Text("malformed")]),
            ..NONE
        },
    ),
    (
        "GatewayConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "kb",
                "port",
                "publicUrl",
                "identity",
                "archivist",
                "signal",
                "logLevel",
                "logFormat",
                "capacity",
            ],
            members: &[
                ("archivist", reference("ServiceAddress")),
                (
                    "capacity",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["queuedBytes", "connections"],
                        members: &[
                            (
                                "connections",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(1.0),
                                    ..NONE
                                },
                            ),
                            (
                                "queuedBytes",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(1.0),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&["connections", "queuedBytes"]),
                        ..NONE
                    },
                ),
                (
                    "identity",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["issuer", "subjectClaim"],
                        members: &[
                            (
                                "issuer",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    min_length: Some(1),
                                    ..NONE
                                },
                            ),
                            (
                                "subjectClaim",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    min_length: Some(1),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&["issuer", "subjectClaim"]),
                        ..NONE
                    },
                ),
                ("kb", reference("KbIdentity")),
                ("logFormat", reference("LogFormat")),
                ("logLevel", reference("LogLevel")),
                (
                    "port",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(65535.0),
                        ..NONE
                    },
                ),
                (
                    "publicUrl",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "signal",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["type"],
                        members: &[
                            (
                                "passwordEnv",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    min_length: Some(1),
                                    ..NONE
                                },
                            ),
                            (
                                "servers",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    min_length: Some(1),
                                    ..NONE
                                },
                            ),
                            (
                                "type",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    enumeration: Some(&[
                                        Listed::Text("in-process"),
                                        Listed::Text("nats"),
                                    ]),
                                    ..NONE
                                },
                            ),
                            (
                                "userEnv",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    min_length: Some(1),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&["passwordEnv", "servers", "type", "userEnv"]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "archivist",
                "capacity",
                "identity",
                "kb",
                "logFormat",
                "logLevel",
                "port",
                "publicUrl",
                "signal",
            ]),
            ..NONE
        },
    ),
    (
        "GatherAnnotationComplete",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["annotationId", "response"],
            members: &[
                ("annotationId", reference("AnnotationId")),
                ("response", reference("GatheredContext")),
            ],
            ..NONE
        },
    ),
    (
        "GatherAnnotationOptions",
        Shape {
            kinds: Some(&[Kind::Object]),
            members: &[
                (
                    "contextWindow",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(100.0),
                        maximum: Some(5000.0),
                        ..NONE
                    },
                ),
                ("includeSourceContext", of(&[Kind::Boolean])),
                ("includeTargetContext", of(&[Kind::Boolean])),
            ],
            ..NONE
        },
    ),
    (
        "GatherAnnotationRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["annotationId", "resourceId"],
            members: &[
                ("annotationId", reference("AnnotationId")),
                ("options", reference("GatherAnnotationOptions")),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "GatherFailed",
        Shape {
            kinds: Some(&[Kind::Object]),
            all_of: &[
                reference("CommandError"),
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["annotationId"],
                    members: &[("annotationId", reference("AnnotationId"))],
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "GatherReferencedByRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId"],
            members: &[
                ("motivation", reference("Motivation")),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "GatherReferencedByResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("GetReferencedByResponse"))],
            ..NONE
        },
    ),
    (
        "GatherResourceComplete",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "response"],
            members: &[
                ("resourceId", reference("ResourceId")),
                ("response", reference("GatheredContext")),
            ],
            ..NONE
        },
    ),
    (
        "GatherResourceFailed",
        Shape {
            kinds: Some(&[Kind::Object]),
            all_of: &[
                reference("CommandError"),
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["resourceId"],
                    members: &[("resourceId", reference("ResourceId"))],
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "GatherResourceOptions",
        Shape {
            kinds: Some(&[Kind::Object]),
            members: &[
                (
                    "depth",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(3.0),
                        ..NONE
                    },
                ),
                (
                    "excludeEntityTypes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("includeContent", of(&[Kind::Boolean])),
                ("includeSummary", of(&[Kind::Boolean])),
                (
                    "maxResources",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(200.0),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "depth",
                "excludeEntityTypes",
                "includeContent",
                "includeSummary",
                "maxResources",
            ]),
            ..NONE
        },
    ),
    (
        "GatherResourceRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "options"],
            members: &[
                ("options", reference("GatherResourceRequestOptions")),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "GatherResourceRequestOptions",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["depth", "maxResources", "includeContent", "includeSummary"],
            members: &[
                (
                    "depth",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(3.0),
                        ..NONE
                    },
                ),
                (
                    "excludeEntityTypes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("includeContent", of(&[Kind::Boolean])),
                ("includeSummary", of(&[Kind::Boolean])),
                (
                    "maxResources",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(200.0),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "GatherSummaryRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["annotationId", "resourceId"],
            members: &[
                ("annotationId", reference("AnnotationId")),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "GatheredContext",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["focus", "graph", "metadata"],
            members: &[
                (
                    "focus",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        one_of: &[
                            Shape {
                                kinds: Some(&[Kind::Object]),
                                required: &["kind", "annotation", "sourceResource"],
                                members: &[
                                    ("annotation", reference("Annotation")),
                                    (
                                        "kind",
                                        Shape {
                                            kinds: Some(&[Kind::String]),
                                            enumeration: Some(&[Listed::Text("annotation")]),
                                            ..NONE
                                        },
                                    ),
                                    (
                                        "selected",
                                        Shape {
                                            kinds: Some(&[Kind::Object]),
                                            required: &["text"],
                                            members: &[
                                                ("after", of(&[Kind::String])),
                                                ("before", of(&[Kind::String])),
                                                ("text", of(&[Kind::String])),
                                            ],
                                            ..NONE
                                        },
                                    ),
                                    ("sourceResource", reference("ResourceDescriptor")),
                                    (
                                        "targetContext",
                                        Shape {
                                            kinds: Some(&[Kind::Object]),
                                            required: &["content"],
                                            members: &[
                                                ("content", of(&[Kind::String])),
                                                ("summary", of(&[Kind::String])),
                                            ],
                                            ..NONE
                                        },
                                    ),
                                    ("targetResource", reference("ResourceDescriptor")),
                                    ("userHint", of(&[Kind::String])),
                                ],
                                ..NONE
                            },
                            Shape {
                                kinds: Some(&[Kind::Object]),
                                required: &["kind", "resource"],
                                members: &[
                                    (
                                        "content",
                                        Shape {
                                            kinds: Some(&[Kind::Object]),
                                            members: &[
                                                ("main", of(&[Kind::String])),
                                                (
                                                    "related",
                                                    Shape {
                                                        kinds: Some(&[Kind::Object]),
                                                        values: Some(&of(&[Kind::String])),
                                                        ..NONE
                                                    },
                                                ),
                                            ],
                                            ..NONE
                                        },
                                    ),
                                    (
                                        "kind",
                                        Shape {
                                            kinds: Some(&[Kind::String]),
                                            enumeration: Some(&[Listed::Text("resource")]),
                                            ..NONE
                                        },
                                    ),
                                    ("resource", reference("ResourceDescriptor")),
                                    (
                                        "suggestedReferences",
                                        Shape {
                                            kinds: Some(&[Kind::Array]),
                                            items: Some(&of(&[Kind::String])),
                                            ..NONE
                                        },
                                    ),
                                    ("summary", of(&[Kind::String])),
                                ],
                                ..NONE
                            },
                        ],
                        ..NONE
                    },
                ),
                ("graph", reference("KnowledgeGraph")),
                ("inferredRelationshipSummary", of(&[Kind::String])),
                (
                    "metadata",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        members: &[
                            (
                                "entityTypeFrequencies",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    values: Some(&of(&[Kind::Integer])),
                                    ..NONE
                                },
                            ),
                            (
                                "entityTypes",
                                Shape {
                                    kinds: Some(&[Kind::Array]),
                                    items: Some(&of(&[Kind::String])),
                                    ..NONE
                                },
                            ),
                            ("language", of(&[Kind::String])),
                            ("resourceType", of(&[Kind::String])),
                        ],
                        ..NONE
                    },
                ),
                (
                    "semanticContext",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["similar"],
                        members: &[
                            (
                                "excludedEntityTypes",
                                Shape {
                                    kinds: Some(&[Kind::Array]),
                                    items: Some(&of(&[Kind::String])),
                                    ..NONE
                                },
                            ),
                            (
                                "similar",
                                Shape {
                                    kinds: Some(&[Kind::Array]),
                                    items: Some(&reference("SemanticMatch")),
                                    ..NONE
                                },
                            ),
                        ],
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "GenerationJobParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            all_of: &[
                reference("GenerationJobRequest"),
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["context"],
                    members: &[("context", reference("GatheredContext"))],
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "GenerationJobRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["title", "storageUri"],
            members: &[
                ("cite", of(&[Kind::Boolean])),
                (
                    "entityTypes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("language", of(&[Kind::String])),
                ("maxTokens", of(&[Kind::Number])),
                ("outputMediaType", reference("SupportedMediaType")),
                ("prompt", of(&[Kind::String])),
                ("sourceLanguage", of(&[Kind::String])),
                (
                    "storageUri",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("structure", of(&[Kind::String])),
                ("task", of(&[Kind::String])),
                ("temperature", of(&[Kind::Number])),
                (
                    "title",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "GetAnnotationHistoryResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["events", "total", "annotationId", "resourceId"],
            members: &[
                ("annotationId", reference("AnnotationId")),
                (
                    "events",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("AttributedEvent")),
                        ..NONE
                    },
                ),
                ("resourceId", reference("ResourceId")),
                ("total", of(&[Kind::Number])),
            ],
            ..NONE
        },
    ),
    (
        "GetAnnotationResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["annotation", "resource", "resolvedResource"],
            members: &[
                ("annotation", reference("Annotation")),
                (
                    "resolvedResource",
                    Shape {
                        kinds: Some(&[Kind::Object, Kind::Null]),
                        one_of: &[of(&[Kind::Null]), reference("ResourceDescriptor")],
                        ..NONE
                    },
                ),
                (
                    "resource",
                    Shape {
                        kinds: Some(&[Kind::Object, Kind::Null]),
                        one_of: &[of(&[Kind::Null]), reference("ResourceDescriptor")],
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "GetAnnotationsResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["annotations", "total"],
            members: &[
                (
                    "annotations",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("Annotation")),
                        ..NONE
                    },
                ),
                ("motivation", reference("Motivation")),
                ("total", of(&[Kind::Number])),
            ],
            ..NONE
        },
    ),
    (
        "GetEntityTypesResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["entityTypes"],
            members: &[(
                "entityTypes",
                Shape {
                    kinds: Some(&[Kind::Array]),
                    items: Some(&of(&[Kind::String])),
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "GetEventsResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["events", "total", "resourceId"],
            members: &[
                (
                    "events",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("AttributedEvent")),
                        ..NONE
                    },
                ),
                ("resourceId", reference("ResourceId")),
                ("total", of(&[Kind::Number])),
            ],
            ..NONE
        },
    ),
    (
        "GetReferencedByResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["referencedBy"],
            members: &[(
                "referencedBy",
                Shape {
                    kinds: Some(&[Kind::Array]),
                    items: Some(&reference("GetReferencedByResponseReferencedByItem")),
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "GetReferencedByResponseReferencedByItem",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["id", "target"],
            members: &[
                ("id", reference("AnnotationId")),
                (
                    "resourceName",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "target",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["source", "selector"],
                        members: &[
                            (
                                "selector",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    required: &["exact"],
                                    members: &[("exact", of(&[Kind::String]))],
                                    ..NONE
                                },
                            ),
                            ("source", reference("ResourceId")),
                        ],
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "GetResourceByTokenResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["sourceResource", "expiresAt"],
            members: &[
                ("expiresAt", of(&[Kind::String])),
                ("sourceResource", reference("ResourceDescriptor")),
            ],
            ..NONE
        },
    ),
    (
        "GetResourceResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resource", "annotations"],
            members: &[
                (
                    "annotations",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("Annotation")),
                        ..NONE
                    },
                ),
                ("resource", reference("ResourceDescriptor")),
            ],
            ..NONE
        },
    ),
    (
        "GetTagSchemasResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["tagSchemas"],
            members: &[(
                "tagSchemas",
                Shape {
                    kinds: Some(&[Kind::Array]),
                    items: Some(&reference("TagSchema")),
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "GraphAnnotationNode",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["id", "type", "label", "annotation"],
            members: &[
                ("annotation", reference("Annotation")),
                (
                    "entityTypes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("id", reference("AnnotationId")),
                ("label", of(&[Kind::String])),
                ("metadata", of(&[Kind::Object])),
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("annotation")]),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "GraphConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("Neo4jGraphConfig"),
                reference("JanusGraphConfig"),
                reference("NeptuneGraphConfig"),
                reference("MemoryGraphConfig"),
            ],
            discriminator: Some(Discriminator {
                property: "type",
                mapping: &[
                    ("neo4j", 0),
                    ("janusgraph", 1),
                    ("neptune", 2),
                    ("memory", 3),
                ],
            }),
            ..NONE
        },
    ),
    (
        "GraphResourceNode",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["id", "type", "label"],
            members: &[
                (
                    "entityTypes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("id", reference("ResourceId")),
                ("label", of(&[Kind::String])),
                ("metadata", of(&[Kind::Object])),
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("resource")]),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "HealthResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["status", "message", "version", "timestamp"],
            members: &[
                ("message", of(&[Kind::String])),
                ("status", of(&[Kind::String])),
                ("timestamp", of(&[Kind::String])),
                ("version", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "HeldJobRecord",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "jobId",
                "jobType",
                "resourceId",
                "params",
                "completedUnits",
                "unitCursors",
                "retryCount",
                "maxRetries",
            ],
            members: &[
                (
                    "completedUnits",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("jobId", reference("JobId")),
                ("jobType", reference("JobType")),
                (
                    "maxRetries",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("params", reference("JobParams")),
                ("resourceId", reference("ResourceId")),
                (
                    "retryCount",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "unitCursors",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        values: Some(&reference("UnitCursor")),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "completedUnits",
                "jobId",
                "jobType",
                "maxRetries",
                "params",
                "resourceId",
                "retryCount",
                "unitCursors",
            ]),
            ..NONE
        },
    ),
    (
        "HeldJobStall",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "jobId",
                "jobType",
                "heldSince",
                "lastActivityAt",
                "silentForMs",
                "thresholdMs",
            ],
            members: &[
                ("heldSince", of(&[Kind::String])),
                ("jobId", reference("JobId")),
                ("jobType", reference("JobType")),
                ("lastActivityAt", of(&[Kind::String])),
                (
                    "silentForMs",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "thresholdMs",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "heldSince",
                "jobId",
                "jobType",
                "lastActivityAt",
                "silentForMs",
                "thresholdMs",
            ]),
            ..NONE
        },
    ),
    (
        "HighlightingJobParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["motivation"],
            members: &[
                ("density", of(&[Kind::Number])),
                ("instructions", of(&[Kind::String])),
                (
                    "motivation",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("highlighting")]),
                        ..NONE
                    },
                ),
                ("sourceLanguage", of(&[Kind::String])),
            ],
            closed: Some(&["density", "instructions", "motivation", "sourceLanguage"]),
            ..NONE
        },
    ),
    (
        "HostPort",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["host", "port"],
            members: &[
                (
                    "host",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "port",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(65535.0),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["host", "port"]),
            ..NONE
        },
    ),
    (
        "HttpEndpoint",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["kind", "host", "port", "protocol"],
            members: &[
                ("host", of(&[Kind::String])),
                (
                    "kind",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("http")]),
                        ..NONE
                    },
                ),
                (
                    "port",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(65535.0),
                        ..NONE
                    },
                ),
                (
                    "protocol",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("http"), Listed::Text("https")]),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "HttpStatus",
        Shape {
            kinds: Some(&[Kind::Integer]),
            minimum: Some(100.0),
            maximum: Some(599.0),
            ..NONE
        },
    ),
    (
        "IdentityUser",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["email", "identity", "enabled"],
            members: &[
                ("email", of(&[Kind::String])),
                ("enabled", of(&[Kind::Boolean])),
                ("identity", of(&[Kind::String])),
            ],
            closed: Some(&["email", "enabled", "identity"]),
            ..NONE
        },
    ),
    (
        "IdentityUseraddParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion", "target", "email", "generatePassword"],
            members: &[
                ("apiVersion", reference("ApiVersion")),
                (
                    "email",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(3),
                        ..NONE
                    },
                ),
                ("generatePassword", of(&[Kind::Boolean])),
                (
                    "password",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("target", reference("LocalTarget")),
            ],
            closed: Some(&[
                "apiVersion",
                "email",
                "generatePassword",
                "password",
                "target",
            ]),
            one_of: &[
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["password"],
                    members: &[(
                        "generatePassword",
                        Shape {
                            kinds: Some(&[Kind::Boolean]),
                            enumeration: Some(&[Listed::Boolean(false)]),
                            ..NONE
                        },
                    )],
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    members: &[(
                        "generatePassword",
                        Shape {
                            kinds: Some(&[Kind::Boolean]),
                            enumeration: Some(&[Listed::Boolean(true)]),
                            ..NONE
                        },
                    )],
                    not_all: &[&["password"]],
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "IdentityUseraddResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["email", "identity", "created"],
            members: &[
                ("created", of(&[Kind::Boolean])),
                ("email", of(&[Kind::String])),
                ("generatedPassword", of(&[Kind::String])),
                ("identity", of(&[Kind::String])),
            ],
            closed: Some(&["created", "email", "generatedPassword", "identity"]),
            ..NONE
        },
    ),
    (
        "IdentityUsersListParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion", "target"],
            members: &[
                ("apiVersion", reference("ApiVersion")),
                ("target", reference("LocalTarget")),
            ],
            closed: Some(&["apiVersion", "target"]),
            ..NONE
        },
    ),
    (
        "IdentityUsersListResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["users"],
            members: &[(
                "users",
                Shape {
                    kinds: Some(&[Kind::Array]),
                    items: Some(&reference("IdentityUser")),
                    ..NONE
                },
            )],
            closed: Some(&["users"]),
            ..NONE
        },
    ),
    (
        "Image",
        Shape {
            kinds: Some(&[Kind::String]),
            min_length: Some(1),
            ..NONE
        },
    ),
    (
        "Inference",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion", "kind", "metadata", "spec"],
            members: &[
                ("apiVersion", reference("StackApiVersion")),
                (
                    "kind",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("Inference")]),
                        ..NONE
                    },
                ),
                ("metadata", reference("Metadata")),
                (
                    "spec",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["providers", "engines"],
                        members: &[
                            ("engines", reference("ArchivistEngines")),
                            (
                                "providers",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    values: Some(&reference("Provider")),
                                    min_members: Some(1),
                                    names: Some(&reference("InferenceProvider")),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&["engines", "providers"]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["apiVersion", "kind", "metadata", "spec"]),
            ..NONE
        },
    ),
    (
        "InferenceLimits",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["contextTokens", "maxOutputTokens"],
            members: &[
                ("acceptsTemperature", of(&[Kind::Boolean])),
                ("contextTokens", of(&[Kind::Number])),
                ("maxOutputTokens", of(&[Kind::Number])),
            ],
            ..NONE
        },
    ),
    ("InferenceLimitsRequest", of(&[Kind::Object])),
    (
        "InferenceLimitsResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[(
                "response",
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["limits"],
                    members: &[(
                        "limits",
                        Shape {
                            kinds: Some(&[Kind::Array]),
                            items: Some(&reference("EngineLimits")),
                            ..NONE
                        },
                    )],
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "InferenceProvider",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("anthropic"),
                Listed::Text("google"),
                Listed::Text("llamacpp"),
                Listed::Text("ollama"),
                Listed::Text("openai"),
                Listed::Text("together"),
                Listed::Text("vllm"),
            ]),
            ..NONE
        },
    ),
    (
        "IssuedTokens",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["access", "refresh"],
            members: &[
                ("access", of(&[Kind::String])),
                ("refresh", of(&[Kind::String])),
            ],
            closed: Some(&["access", "refresh"]),
            ..NONE
        },
    ),
    (
        "Issuer",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion", "kind", "metadata", "spec"],
            members: &[
                ("apiVersion", reference("StackApiVersion")),
                (
                    "kind",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("Issuer")]),
                        ..NONE
                    },
                ),
                ("metadata", reference("Metadata")),
                (
                    "spec",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["type", "image", "resources", "port", "database"],
                        members: &[
                            (
                                "database",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    required: &["type", "name", "user"],
                                    members: &[
                                        (
                                            "external",
                                            Shape {
                                                kinds: Some(&[Kind::Object]),
                                                required: &["host", "port", "password"],
                                                members: &[
                                                    (
                                                        "host",
                                                        Shape {
                                                            kinds: Some(&[Kind::String]),
                                                            min_length: Some(1),
                                                            ..NONE
                                                        },
                                                    ),
                                                    ("password", reference("SecretRef")),
                                                    (
                                                        "port",
                                                        Shape {
                                                            kinds: Some(&[Kind::Integer]),
                                                            minimum: Some(1.0),
                                                            maximum: Some(65535.0),
                                                            ..NONE
                                                        },
                                                    ),
                                                ],
                                                closed: Some(&["host", "password", "port"]),
                                                ..NONE
                                            },
                                        ),
                                        ("image", reference("Image")),
                                        (
                                            "name",
                                            Shape {
                                                kinds: Some(&[Kind::String]),
                                                pattern: Some(&[
                                                    Term::Step(Step {
                                                        of: &[(95, 95), (97, 122)],
                                                        min: 1,
                                                        max: Some(1),
                                                    }),
                                                    Term::Step(Step {
                                                        of: &[(48, 57), (95, 95), (97, 122)],
                                                        min: 0,
                                                        max: Some(62),
                                                    }),
                                                ]),
                                                ..NONE
                                            },
                                        ),
                                        (
                                            "port",
                                            Shape {
                                                kinds: Some(&[Kind::Integer]),
                                                minimum: Some(1.0),
                                                maximum: Some(65535.0),
                                                ..NONE
                                            },
                                        ),
                                        ("resources", reference("Resources")),
                                        (
                                            "type",
                                            Shape {
                                                kinds: Some(&[Kind::String]),
                                                min_length: Some(1),
                                                ..NONE
                                            },
                                        ),
                                        (
                                            "user",
                                            Shape {
                                                kinds: Some(&[Kind::String]),
                                                min_length: Some(1),
                                                ..NONE
                                            },
                                        ),
                                    ],
                                    closed: Some(&[
                                        "external",
                                        "image",
                                        "name",
                                        "port",
                                        "resources",
                                        "type",
                                        "user",
                                    ]),
                                    all_of: &[
                                        reference("Runner"),
                                        Shape {
                                            kinds: Some(&[Kind::Object]),
                                            one_of: &[
                                                Shape {
                                                    kinds: Some(&[Kind::Object]),
                                                    required: &["port"],
                                                    not_all: &[&["external"]],
                                                    ..NONE
                                                },
                                                Shape {
                                                    kinds: Some(&[Kind::Object]),
                                                    required: &["external"],
                                                    not_all: &[&["port"]],
                                                    ..NONE
                                                },
                                            ],
                                            ..NONE
                                        },
                                    ],
                                    ..NONE
                                },
                            ),
                            ("image", reference("Image")),
                            (
                                "port",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(1.0),
                                    maximum: Some(65535.0),
                                    ..NONE
                                },
                            ),
                            ("resources", reference("Resources")),
                            (
                                "type",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    min_length: Some(1),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&["database", "image", "port", "resources", "type"]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["apiVersion", "kind", "metadata", "spec"]),
            ..NONE
        },
    ),
    (
        "JanusGraphConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["type", "host", "port"],
            members: &[
                (
                    "host",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "port",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(65535.0),
                        ..NONE
                    },
                ),
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("janusgraph")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["host", "port", "type"]),
            ..NONE
        },
    ),
    (
        "Job",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("JobPending"),
                reference("JobRunning"),
                reference("JobComplete"),
                reference("JobFailed"),
                reference("JobCancelled"),
            ],
            discriminator: Some(Discriminator {
                property: "status",
                mapping: &[
                    ("pending", 0),
                    ("running", 1),
                    ("complete", 2),
                    ("failed", 3),
                    ("cancelled", 4),
                ],
            }),
            ..NONE
        },
    ),
    (
        "JobAssignCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobId", "jobType", "resourceId", "holder", "requester"],
            members: &[
                ("_userId", reference("UserId")),
                ("holder", reference("UserId")),
                ("jobId", reference("JobId")),
                ("jobType", reference("JobType")),
                ("requester", reference("UserId")),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "JobAssignedPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobId", "jobType", "resourceId", "holder", "requester"],
            members: &[
                ("holder", reference("UserId")),
                ("jobId", reference("JobId")),
                ("jobType", reference("JobType")),
                ("requester", reference("UserId")),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "JobCancelCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "jobId", "jobType"],
            members: &[
                ("_userId", reference("UserId")),
                ("annotationId", reference("AnnotationId")),
                (
                    "completedUnits",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("jobId", reference("JobId")),
                ("jobType", reference("JobType")),
                ("resourceId", reference("ResourceId")),
                (
                    "unitCursors",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        values: Some(&reference("UnitCursor")),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "JobCancelRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobId"],
            members: &[("jobId", reference("JobId"))],
            ..NONE
        },
    ),
    (
        "JobCancelResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["cancelled"],
            members: &[("cancelled", of(&[Kind::Boolean]))],
            ..NONE
        },
    ),
    (
        "JobCancelled",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["status", "metadata", "params", "completedAt"],
            members: &[
                ("completedAt", of(&[Kind::String])),
                ("metadata", reference("JobMetadata")),
                ("params", reference("JobParams")),
                ("startedAt", of(&[Kind::String])),
                (
                    "status",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("cancelled")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["completedAt", "metadata", "params", "startedAt", "status"]),
            ..NONE
        },
    ),
    (
        "JobCheckpoint",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["completedUnits"],
            members: &[
                (
                    "completedUnits",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                (
                    "unitCursors",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        values: Some(&reference("UnitCursor")),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["completedUnits", "unitCursors"]),
            ..NONE
        },
    ),
    (
        "JobCheckpointCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobId", "completedUnits"],
            members: &[
                ("_userId", reference("UserId")),
                (
                    "completedUnits",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("jobId", reference("JobId")),
                (
                    "unitCursors",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        values: Some(&reference("UnitCursor")),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "JobClaimCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["accepts"],
            members: &[
                (
                    "_roles",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("_userId", reference("UserId")),
                (
                    "accepts",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        min_items: Some(1),
                        items: Some(&reference("JobFilter")),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "JobClaimedResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("JobRunning"))],
            closed: Some(&["response"]),
            ..NONE
        },
    ),
    (
        "JobComplete",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "status",
                "metadata",
                "params",
                "startedAt",
                "completedAt",
                "result",
            ],
            members: &[
                ("completedAt", of(&[Kind::String])),
                ("metadata", reference("JobMetadata")),
                ("params", reference("JobParams")),
                ("result", reference("JobStoredResult")),
                ("startedAt", of(&[Kind::String])),
                (
                    "status",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("complete")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "completedAt",
                "metadata",
                "params",
                "result",
                "startedAt",
                "status",
            ]),
            ..NONE
        },
    ),
    (
        "JobCompleteCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("MarkJobCompleteCommand"),
                reference("YieldJobCompleteCommand"),
            ],
            discriminator: Some(Discriminator {
                property: "jobType",
                mapping: &[("mark", 0), ("yield", 1)],
            }),
            ..NONE
        },
    ),
    (
        "JobCompletedPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobId", "jobType"],
            members: &[
                ("annotationId", reference("AnnotationId")),
                ("annotationUri", of(&[Kind::String])),
                ("attempt", of(&[Kind::Integer])),
                ("durability", reference("DurabilityEvidence")),
                ("foundCount", of(&[Kind::Integer])),
                ("jobId", reference("JobId")),
                ("jobType", reference("JobType")),
                ("result", of(&[Kind::Object])),
                ("resultResourceId", reference("ResourceId")),
                ("totalSteps", of(&[Kind::Integer])),
            ],
            ..NONE
        },
    ),
    (
        "JobCreateCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("MarkJobCreateCommand"),
                reference("YieldJobCreateCommand"),
            ],
            discriminator: Some(Discriminator {
                property: "jobType",
                mapping: &[("mark", 0), ("yield", 1)],
            }),
            ..NONE
        },
    ),
    (
        "JobCreatedResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("JobCreatedResultResponse"))],
            ..NONE
        },
    ),
    (
        "JobCreatedResultResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobId"],
            members: &[("jobId", reference("JobId"))],
            ..NONE
        },
    ),
    (
        "JobDeclined",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["declined", "reason"],
            members: &[
                (
                    "declined",
                    Shape {
                        kinds: Some(&[Kind::Boolean]),
                        enumeration: Some(&[Listed::Boolean(true)]),
                        ..NONE
                    },
                ),
                (
                    "reason",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("no-text-layer"),
                            Listed::Text("encrypted"),
                            Listed::Text("corrupt"),
                            Listed::Text("too-large"),
                            Listed::Text("empty"),
                        ]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["declined", "reason"]),
            ..NONE
        },
    ),
    (
        "JobFailCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "jobId", "jobType", "error"],
            members: &[
                ("_userId", reference("UserId")),
                ("annotationId", reference("AnnotationId")),
                ("attempt", of(&[Kind::Integer])),
                (
                    "completedUnits",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("durability", reference("DurabilityEvidence")),
                ("error", of(&[Kind::String])),
                ("failureClass", reference("FailureClass")),
                ("jobId", reference("JobId")),
                ("jobType", reference("JobType")),
                ("resourceId", reference("ResourceId")),
                (
                    "unitCursors",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        values: Some(&reference("UnitCursor")),
                        ..NONE
                    },
                ),
                ("willRetry", of(&[Kind::Boolean])),
            ],
            ..NONE
        },
    ),
    (
        "JobFailed",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["status", "metadata", "params", "completedAt", "error"],
            members: &[
                ("completedAt", of(&[Kind::String])),
                ("error", of(&[Kind::String])),
                ("failureClass", reference("FailureClass")),
                ("metadata", reference("JobMetadata")),
                ("params", reference("JobParams")),
                ("startedAt", of(&[Kind::String])),
                (
                    "status",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("failed")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "completedAt",
                "error",
                "failureClass",
                "metadata",
                "params",
                "startedAt",
                "status",
            ]),
            ..NONE
        },
    ),
    (
        "JobFailedPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobId", "jobType", "error"],
            members: &[
                ("annotationId", reference("AnnotationId")),
                ("attempt", of(&[Kind::Integer])),
                ("durability", reference("DurabilityEvidence")),
                ("error", of(&[Kind::String])),
                ("failureClass", reference("FailureClass")),
                ("jobId", reference("JobId")),
                ("jobType", reference("JobType")),
                ("willRetry", of(&[Kind::Boolean])),
            ],
            ..NONE
        },
    ),
    (
        "JobFailure",
        Shape {
            kinds: Some(&[Kind::Object]),
            members: &[
                (
                    "completedUnits",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("failureClass", reference("FailureClass")),
                (
                    "unitCursors",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        values: Some(&reference("UnitCursor")),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["completedUnits", "failureClass", "unitCursors"]),
            ..NONE
        },
    ),
    (
        "JobFilter",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[reference("MarkJobFilter"), reference("YieldJobFilter")],
            discriminator: Some(Discriminator {
                property: "jobType",
                mapping: &[("mark", 0), ("yield", 1)],
            }),
            ..NONE
        },
    ),
    (
        "JobId",
        Shape {
            kinds: Some(&[Kind::String]),
            pattern: Some(&[Term::Step(Step {
                of: &[(45, 45), (48, 57), (65, 90), (95, 95), (97, 122)],
                min: 1,
                max: Some(128),
            })]),
            ..NONE
        },
    ),
    (
        "JobMetadata",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "id",
                "type",
                "userId",
                "created",
                "retryCount",
                "maxRetries",
            ],
            members: &[
                (
                    "completedUnits",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("created", of(&[Kind::String])),
                ("id", reference("JobId")),
                (
                    "maxRetries",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "retryCount",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("type", reference("JobType")),
                (
                    "unitCursors",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        values: Some(&reference("UnitCursor")),
                        ..NONE
                    },
                ),
                ("userId", reference("UserId")),
            ],
            closed: Some(&[
                "completedUnits",
                "created",
                "id",
                "maxRetries",
                "retryCount",
                "type",
                "unitCursors",
                "userId",
            ]),
            ..NONE
        },
    ),
    (
        "JobParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId"],
            members: &[
                ("resourceId", reference("ResourceId")),
                ("schema", reference("TagSchema")),
            ],
            ..NONE
        },
    ),
    (
        "JobPending",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["status", "metadata", "params"],
            members: &[
                ("metadata", reference("JobMetadata")),
                ("params", reference("JobParams")),
                (
                    "status",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("pending")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["metadata", "params", "status"]),
            ..NONE
        },
    ),
    (
        "JobPollOptions",
        Shape {
            kinds: Some(&[Kind::Object]),
            members: &[
                (
                    "everyMs",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "withinMs",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["everyMs", "withinMs"]),
            ..NONE
        },
    ),
    (
        "JobProgress",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["percentage"],
            members: &[
                ("annotationId", reference("AnnotationId")),
                (
                    "completedItems",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&Shape {
                            kinds: Some(&[Kind::Object]),
                            required: &["value", "foundCount"],
                            members: &[
                                ("foundCount", of(&[Kind::Integer])),
                                ("persistedCount", of(&[Kind::Integer])),
                                (
                                    "underReported",
                                    Shape {
                                        kinds: Some(&[Kind::Object]),
                                        required: &["pieces", "found", "counted"],
                                        members: &[
                                            ("counted", of(&[Kind::Integer])),
                                            ("found", of(&[Kind::Integer])),
                                            ("pieces", of(&[Kind::Integer])),
                                        ],
                                        ..NONE
                                    },
                                ),
                                ("value", of(&[Kind::String])),
                            ],
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                (
                    "current",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["kind", "value"],
                        members: &[
                            (
                                "kind",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    enumeration: Some(&[
                                        Listed::Text("entity-type"),
                                        Listed::Text("category"),
                                    ]),
                                    ..NONE
                                },
                            ),
                            ("value", of(&[Kind::String])),
                        ],
                        ..NONE
                    },
                ),
                ("entitiesEmitted", of(&[Kind::Integer])),
                ("entitiesExpected", of(&[Kind::Integer])),
                ("entitiesFound", of(&[Kind::Integer])),
                ("message", reference("JobProgressMessage")),
                ("percentage", of(&[Kind::Number])),
                ("processed", of(&[Kind::Integer])),
                (
                    "requestParams",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&Shape {
                            kinds: Some(&[Kind::Object]),
                            required: &["label", "value"],
                            members: &[
                                (
                                    "label",
                                    Shape {
                                        kinds: Some(&[Kind::String]),
                                        enumeration: Some(&[
                                            Listed::Text("entity-types"),
                                            Listed::Text("instructions"),
                                            Listed::Text("tone"),
                                            Listed::Text("density"),
                                        ]),
                                        ..NONE
                                    },
                                ),
                                ("value", of(&[Kind::String])),
                            ],
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                ("total", of(&[Kind::Integer])),
            ],
            ..NONE
        },
    ),
    (
        "JobProgressAnalyzing",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["code"],
            members: &[(
                "code",
                Shape {
                    kinds: Some(&[Kind::String]),
                    enumeration: Some(&[Listed::Text("analyzing")]),
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "JobProgressAnalyzingTags",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["code"],
            members: &[(
                "code",
                Shape {
                    kinds: Some(&[Kind::String]),
                    enumeration: Some(&[Listed::Text("analyzing-tags")]),
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "JobProgressCompleteCreated",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["code", "count", "motivation"],
            members: &[
                (
                    "code",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("complete-created")]),
                        ..NONE
                    },
                ),
                ("count", of(&[Kind::Integer])),
                ("motivation", reference("Motivation")),
            ],
            ..NONE
        },
    ),
    (
        "JobProgressCompleteGenerated",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["code", "truncated"],
            members: &[
                (
                    "code",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("complete-generated")]),
                        ..NONE
                    },
                ),
                ("truncated", of(&[Kind::Boolean])),
            ],
            ..NONE
        },
    ),
    (
        "JobProgressCreatingAnnotations",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["code", "count"],
            members: &[
                (
                    "code",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("creating-annotations")]),
                        ..NONE
                    },
                ),
                ("count", of(&[Kind::Integer])),
            ],
            ..NONE
        },
    ),
    (
        "JobProgressCreatingResource",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["code"],
            members: &[(
                "code",
                Shape {
                    kinds: Some(&[Kind::String]),
                    enumeration: Some(&[Listed::Text("creating-resource")]),
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "JobProgressCreatingTagAnnotations",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["code", "count"],
            members: &[
                (
                    "code",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("creating-tag-annotations")]),
                        ..NONE
                    },
                ),
                ("count", of(&[Kind::Integer])),
            ],
            ..NONE
        },
    ),
    (
        "JobProgressDetectingEntities",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["code", "entityType"],
            members: &[
                (
                    "code",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("detecting-entities")]),
                        ..NONE
                    },
                ),
                ("entityType", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "JobProgressGeneratingResource",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["code"],
            members: &[(
                "code",
                Shape {
                    kinds: Some(&[Kind::String]),
                    enumeration: Some(&[Listed::Text("generating-resource")]),
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "JobProgressLoading",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["code"],
            members: &[(
                "code",
                Shape {
                    kinds: Some(&[Kind::String]),
                    enumeration: Some(&[Listed::Text("loading")]),
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "JobProgressMessage",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("JobProgressLoading"),
                reference("JobProgressAnalyzing"),
                reference("JobProgressAnalyzingTags"),
                reference("JobProgressGeneratingResource"),
                reference("JobProgressCreatingResource"),
                reference("JobProgressCompleteGenerated"),
                reference("JobProgressDetectingEntities"),
                reference("JobProgressCreatingAnnotations"),
                reference("JobProgressCreatingTagAnnotations"),
                reference("JobProgressCompleteCreated"),
            ],
            discriminator: Some(Discriminator {
                property: "code",
                mapping: &[
                    ("loading", 0),
                    ("analyzing", 1),
                    ("analyzing-tags", 2),
                    ("generating-resource", 3),
                    ("creating-resource", 4),
                    ("complete-generated", 5),
                    ("detecting-entities", 6),
                    ("creating-annotations", 7),
                    ("creating-tag-annotations", 8),
                    ("complete-created", 9),
                ],
            }),
            ..NONE
        },
    ),
    (
        "JobQueuedEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("MarkJobQueuedEvent"),
                reference("YieldJobQueuedEvent"),
            ],
            discriminator: Some(Discriminator {
                property: "jobType",
                mapping: &[("mark", 0), ("yield", 1)],
            }),
            ..NONE
        },
    ),
    (
        "JobReached",
        Shape {
            kinds: Some(&[Kind::Object]),
            members: &[
                (
                    "completedUnits",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                (
                    "unitCursors",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        values: Some(&reference("UnitCursor")),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["completedUnits", "unitCursors"]),
            ..NONE
        },
    ),
    (
        "JobRecord",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["job", "lastProgressAt"],
            members: &[
                ("job", reference("Job")),
                ("lastProgressAt", of(&[Kind::String])),
            ],
            closed: Some(&["job", "lastProgressAt"]),
            ..NONE
        },
    ),
    (
        "JobReportProgressCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "jobId", "jobType", "percentage"],
            members: &[
                ("_userId", reference("UserId")),
                ("annotationId", reference("AnnotationId")),
                ("attempt", of(&[Kind::Integer])),
                ("jobId", reference("JobId")),
                ("jobType", reference("JobType")),
                ("percentage", of(&[Kind::Number])),
                ("progress", reference("JobProgress")),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "JobResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("MarkJobDone"),
                reference("YieldJobDone"),
                reference("JobDeclined"),
            ],
            ..NONE
        },
    ),
    (
        "JobRunning",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["status", "metadata", "params", "startedAt", "progress"],
            members: &[
                ("metadata", reference("JobMetadata")),
                ("params", reference("JobParams")),
                ("progress", reference("JobStoredProgress")),
                ("startedAt", of(&[Kind::String])),
                (
                    "status",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("running")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["metadata", "params", "progress", "startedAt", "status"]),
            ..NONE
        },
    ),
    (
        "JobStartCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "jobId", "jobType"],
            members: &[
                ("_userId", reference("UserId")),
                ("annotationId", reference("AnnotationId")),
                ("attempt", of(&[Kind::Integer])),
                ("jobId", reference("JobId")),
                ("jobType", reference("JobType")),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "JobStartedPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobId", "jobType"],
            members: &[
                ("annotationId", reference("AnnotationId")),
                ("jobId", reference("JobId")),
                ("jobType", reference("JobType")),
                ("totalSteps", of(&[Kind::Integer])),
            ],
            ..NONE
        },
    ),
    (
        "JobStatusRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobId"],
            members: &[("jobId", reference("JobId"))],
            ..NONE
        },
    ),
    (
        "JobStatusResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobId", "type", "status", "userId", "created"],
            members: &[
                ("completedAt", of(&[Kind::String])),
                ("created", of(&[Kind::String])),
                ("error", of(&[Kind::String])),
                ("failureClass", reference("FailureClass")),
                ("jobId", reference("JobId")),
                ("progress", reference("JobStoredProgress")),
                ("result", reference("JobStoredResult")),
                ("startedAt", of(&[Kind::String])),
                (
                    "status",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("pending"),
                            Listed::Text("running"),
                            Listed::Text("complete"),
                            Listed::Text("failed"),
                            Listed::Text("cancelled"),
                        ]),
                        ..NONE
                    },
                ),
                ("type", reference("JobType")),
                ("userId", reference("UserId")),
            ],
            ..NONE
        },
    ),
    (
        "JobStatusResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("JobStatusResponse"))],
            ..NONE
        },
    ),
    (
        "JobStoredProgress",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("JobProgress"),
                Shape {
                    kinds: Some(&[Kind::Object]),
                    closed: Some(&[]),
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "JobStoredResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("JobResult"),
                Shape {
                    kinds: Some(&[Kind::Object]),
                    closed: Some(&[]),
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "JobType",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[Listed::Text("mark"), Listed::Text("yield")]),
            ..NONE
        },
    ),
    (
        "KbDescription",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["name", "domain"],
            members: &[
                ("domain", of(&[Kind::String])),
                ("gitBranch", of(&[Kind::String])),
                ("name", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "KbDid",
        Shape {
            kinds: Some(&[Kind::String]),
            pattern: Some(&[
                Term::Step(Step {
                    of: &[(100, 100)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(105, 105)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(100, 100)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(58, 58)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(119, 119)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(101, 101)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(98, 98)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(58, 58)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[
                        (0, 8),
                        (14, 31),
                        (33, 159),
                        (161, 5759),
                        (5761, 8191),
                        (8203, 8231),
                        (8234, 8238),
                        (8240, 8286),
                        (8288, 12287),
                        (12289, 65278),
                        (65280, 1114111),
                    ],
                    min: 1,
                    max: None,
                }),
            ]),
            ..NONE
        },
    ),
    (
        "KbEndpoint",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[reference("HttpEndpoint"), reference("LocalEndpoint")],
            discriminator: Some(Discriminator {
                property: "kind",
                mapping: &[("http", 0), ("local", 1)],
            }),
            ..NONE
        },
    ),
    (
        "KbIdentity",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["name", "domain"],
            members: &[
                (
                    "domain",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        pattern: Some(&[Term::Step(Step {
                            of: &[
                                (0, 8),
                                (14, 31),
                                (33, 159),
                                (161, 5759),
                                (5761, 8191),
                                (8203, 8231),
                                (8234, 8238),
                                (8240, 8286),
                                (8288, 12287),
                                (12289, 65278),
                                (65280, 1114111),
                            ],
                            min: 1,
                            max: None,
                        })]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "name",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["domain", "name"]),
            ..NONE
        },
    ),
    (
        "KbIdentityConflict",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["expectedDid", "observedDid"],
            members: &[
                ("expectedDid", of(&[Kind::String])),
                ("observedDid", of(&[Kind::String])),
            ],
            closed: Some(&["expectedDid", "observedDid"]),
            ..NONE
        },
    ),
    (
        "KbPlacement",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[Listed::Text("local"), Listed::Text("codespace")]),
            ..NONE
        },
    ),
    (
        "KbRead",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["at"],
            members: &[
                ("at", of(&[Kind::String])),
                ("gitBranch", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "KbReadKind",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("recorded"),
                Listed::Text("conflict"),
                Listed::Text("no-verdict"),
            ]),
            ..NONE
        },
    ),
    (
        "KbReadVerdict",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["kind"],
                    members: &[(
                        "kind",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            enumeration: Some(&[Listed::Text("recorded")]),
                            all_of: &[reference("KbReadKind")],
                            ..NONE
                        },
                    )],
                    closed: Some(&["kind"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["kind", "observedDid", "observedName"],
                    members: &[
                        (
                            "kind",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                enumeration: Some(&[Listed::Text("conflict")]),
                                all_of: &[reference("KbReadKind")],
                                ..NONE
                            },
                        ),
                        ("observedDid", of(&[Kind::String])),
                        ("observedName", of(&[Kind::String])),
                    ],
                    closed: Some(&["kind", "observedDid", "observedName"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["kind"],
                    members: &[(
                        "kind",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            enumeration: Some(&[Listed::Text("no-verdict")]),
                            all_of: &[reference("KbReadKind")],
                            ..NONE
                        },
                    )],
                    closed: Some(&["kind"]),
                    ..NONE
                },
            ],
            discriminator: Some(Discriminator {
                property: "kind",
                mapping: &[("recorded", 0), ("conflict", 1), ("no-verdict", 2)],
            }),
            ..NONE
        },
    ),
    (
        "KbSessionStatus",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("authenticated"),
                Listed::Text("expired"),
                Listed::Text("signed-out"),
            ]),
            ..NONE
        },
    ),
    (
        "KbTarget",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["id", "label", "endpoint"],
            members: &[
                ("endpoint", reference("KbEndpoint")),
                ("id", of(&[Kind::String])),
                ("label", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "KnowledgeBase",
        Shape {
            kinds: Some(&[Kind::Object]),
            all_of: &[reference("KbTarget"), reference("NewKnowledgeBase")],
            ..NONE
        },
    ),
    (
        "KnowledgeBaseStatus",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "name",
                "key",
                "recorded",
                "placement",
                "starting",
                "healthy",
                "services",
            ],
            members: &[
                ("did", of(&[Kind::String])),
                ("gateway", of(&[Kind::String])),
                ("healthy", of(&[Kind::Boolean])),
                ("identityError", of(&[Kind::String])),
                ("kb", reference("DiscoveredKB")),
                ("key", of(&[Kind::String])),
                ("lan", of(&[Kind::String])),
                ("name", of(&[Kind::String])),
                ("placement", reference("KbPlacement")),
                ("recorded", of(&[Kind::Boolean])),
                ("repo", of(&[Kind::String])),
                ("root", of(&[Kind::String])),
                ("runtime", reference("Runtime")),
                ("secretStore", of(&[Kind::String])),
                (
                    "services",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("ServiceStatus")),
                        ..NONE
                    },
                ),
                ("session", reference("Session")),
                ("siteName", of(&[Kind::String])),
                ("starting", of(&[Kind::Boolean])),
                ("workload", reference("WorkloadStatus")),
            ],
            closed: Some(&[
                "did",
                "gateway",
                "healthy",
                "identityError",
                "kb",
                "key",
                "lan",
                "name",
                "placement",
                "recorded",
                "repo",
                "root",
                "runtime",
                "secretStore",
                "services",
                "session",
                "siteName",
                "starting",
                "workload",
            ]),
            ..NONE
        },
    ),
    (
        "KnowledgeGraph",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["nodes", "edges"],
            members: &[
                (
                    "edges",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&Shape {
                            kinds: Some(&[Kind::Object]),
                            required: &["source", "target", "type"],
                            members: &[
                                ("bidirectional", of(&[Kind::Boolean])),
                                ("metadata", of(&[Kind::Object])),
                                ("source", of(&[Kind::String])),
                                ("target", of(&[Kind::String])),
                                ("type", of(&[Kind::String])),
                            ],
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                (
                    "nodes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&Shape {
                            kinds: Some(&[Kind::Object]),
                            one_of: &[
                                reference("GraphResourceNode"),
                                reference("GraphAnnotationNode"),
                            ],
                            discriminator: Some(Discriminator {
                                property: "type",
                                mapping: &[("resource", 0), ("annotation", 1)],
                            }),
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                ("truncated", of(&[Kind::Boolean])),
            ],
            ..NONE
        },
    ),
    (
        "KnowledgeIndex",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion", "kind", "metadata", "spec"],
            members: &[
                ("apiVersion", reference("StackApiVersion")),
                (
                    "kind",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("KnowledgeIndex")]),
                        ..NONE
                    },
                ),
                ("metadata", reference("Metadata")),
                (
                    "spec",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &[
                            "knowledgeBase",
                            "logLevel",
                            "graph",
                            "vectors",
                            "embedding",
                            "librarian",
                            "smelter",
                            "weaver",
                        ],
                        members: &[
                            (
                                "embedding",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    required: &["type", "model", "chunking"],
                                    members: &[
                                        ("apiKey", reference("SecretRef")),
                                        (
                                            "chunking",
                                            Shape {
                                                kinds: Some(&[Kind::Object]),
                                                required: &["chunkSize", "overlap"],
                                                members: &[
                                                    (
                                                        "chunkSize",
                                                        Shape {
                                                            kinds: Some(&[Kind::Integer]),
                                                            minimum: Some(1.0),
                                                            ..NONE
                                                        },
                                                    ),
                                                    (
                                                        "overlap",
                                                        Shape {
                                                            kinds: Some(&[Kind::Integer]),
                                                            minimum: Some(0.0),
                                                            ..NONE
                                                        },
                                                    ),
                                                ],
                                                closed: Some(&["chunkSize", "overlap"]),
                                                ..NONE
                                            },
                                        ),
                                        (
                                            "endpoint",
                                            Shape {
                                                kinds: Some(&[Kind::String]),
                                                min_length: Some(1),
                                                ..NONE
                                            },
                                        ),
                                        (
                                            "model",
                                            Shape {
                                                kinds: Some(&[Kind::String]),
                                                min_length: Some(1),
                                                ..NONE
                                            },
                                        ),
                                        (
                                            "type",
                                            Shape {
                                                kinds: Some(&[Kind::String]),
                                                min_length: Some(1),
                                                ..NONE
                                            },
                                        ),
                                    ],
                                    closed: Some(&[
                                        "apiKey", "chunking", "endpoint", "model", "type",
                                    ]),
                                    ..NONE
                                },
                            ),
                            (
                                "graph",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    required: &["type", "username"],
                                    members: &[
                                        (
                                            "external",
                                            Shape {
                                                kinds: Some(&[Kind::Object]),
                                                required: &["uri", "password"],
                                                members: &[
                                                    ("password", reference("SecretRef")),
                                                    (
                                                        "uri",
                                                        Shape {
                                                            kinds: Some(&[Kind::String]),
                                                            min_length: Some(1),
                                                            ..NONE
                                                        },
                                                    ),
                                                ],
                                                closed: Some(&["password", "uri"]),
                                                ..NONE
                                            },
                                        ),
                                        ("image", reference("Image")),
                                        ("resources", reference("Resources")),
                                        (
                                            "type",
                                            Shape {
                                                kinds: Some(&[Kind::String]),
                                                min_length: Some(1),
                                                ..NONE
                                            },
                                        ),
                                        (
                                            "username",
                                            Shape {
                                                kinds: Some(&[Kind::String]),
                                                min_length: Some(1),
                                                ..NONE
                                            },
                                        ),
                                    ],
                                    closed: Some(&[
                                        "external",
                                        "image",
                                        "resources",
                                        "type",
                                        "username",
                                    ]),
                                    all_of: &[reference("Runner")],
                                    ..NONE
                                },
                            ),
                            (
                                "knowledgeBase",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    pattern: Some(&[
                                        Term::Step(Step {
                                            of: &[(48, 57), (97, 122)],
                                            min: 1,
                                            max: Some(1),
                                        }),
                                        Term::Group(Group {
                                            either: &[&[
                                                Term::Step(Step {
                                                    of: &[(45, 45), (48, 57), (97, 122)],
                                                    min: 0,
                                                    max: None,
                                                }),
                                                Term::Step(Step {
                                                    of: &[(48, 57), (97, 122)],
                                                    min: 1,
                                                    max: Some(1),
                                                }),
                                            ]],
                                            min: 0,
                                            max: Some(1),
                                        }),
                                    ]),
                                    ..NONE
                                },
                            ),
                            (
                                "librarian",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    required: &["image", "resources", "gather", "search"],
                                    members: &[
                                        (
                                            "gather",
                                            Shape {
                                                kinds: Some(&[Kind::Object]),
                                                required: &["settleTimeoutMs"],
                                                members: &[(
                                                    "settleTimeoutMs",
                                                    Shape {
                                                        kinds: Some(&[Kind::Integer]),
                                                        minimum: Some(1.0),
                                                        ..NONE
                                                    },
                                                )],
                                                closed: Some(&["settleTimeoutMs"]),
                                                ..NONE
                                            },
                                        ),
                                        ("image", reference("Image")),
                                        ("resources", reference("Resources")),
                                        (
                                            "search",
                                            Shape {
                                                kinds: Some(&[Kind::Object]),
                                                required: &["semanticFloor"],
                                                members: &[(
                                                    "semanticFloor",
                                                    Shape {
                                                        kinds: Some(&[Kind::Number]),
                                                        minimum: Some(0.0),
                                                        maximum: Some(1.0),
                                                        ..NONE
                                                    },
                                                )],
                                                closed: Some(&["semanticFloor"]),
                                                ..NONE
                                            },
                                        ),
                                    ],
                                    closed: Some(&["gather", "image", "resources", "search"]),
                                    ..NONE
                                },
                            ),
                            ("logLevel", reference("LogLevel")),
                            (
                                "smelter",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    required: &["image", "resources", "pdfsAtOnce"],
                                    members: &[
                                        ("image", reference("Image")),
                                        (
                                            "pdfsAtOnce",
                                            Shape {
                                                kinds: Some(&[Kind::Integer]),
                                                minimum: Some(1.0),
                                                ..NONE
                                            },
                                        ),
                                        ("resources", reference("Resources")),
                                    ],
                                    closed: Some(&["image", "pdfsAtOnce", "resources"]),
                                    ..NONE
                                },
                            ),
                            (
                                "vectors",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    required: &["type"],
                                    members: &[
                                        (
                                            "external",
                                            Shape {
                                                kinds: Some(&[Kind::Object]),
                                                required: &[
                                                    "host",
                                                    "port",
                                                    "smelterToken",
                                                    "librarianToken",
                                                ],
                                                members: &[
                                                    (
                                                        "host",
                                                        Shape {
                                                            kinds: Some(&[Kind::String]),
                                                            min_length: Some(1),
                                                            ..NONE
                                                        },
                                                    ),
                                                    ("librarianToken", reference("SecretRef")),
                                                    (
                                                        "port",
                                                        Shape {
                                                            kinds: Some(&[Kind::Integer]),
                                                            minimum: Some(1.0),
                                                            maximum: Some(65535.0),
                                                            ..NONE
                                                        },
                                                    ),
                                                    ("smelterToken", reference("SecretRef")),
                                                ],
                                                closed: Some(&[
                                                    "host",
                                                    "librarianToken",
                                                    "port",
                                                    "smelterToken",
                                                ]),
                                                ..NONE
                                            },
                                        ),
                                        ("image", reference("Image")),
                                        ("resources", reference("Resources")),
                                        (
                                            "shared",
                                            Shape {
                                                kinds: Some(&[Kind::Object]),
                                                closed: Some(&[]),
                                                ..NONE
                                            },
                                        ),
                                        (
                                            "type",
                                            Shape {
                                                kinds: Some(&[Kind::String]),
                                                min_length: Some(1),
                                                ..NONE
                                            },
                                        ),
                                    ],
                                    closed: Some(&[
                                        "external",
                                        "image",
                                        "resources",
                                        "shared",
                                        "type",
                                    ]),
                                    one_of: &[
                                        Shape {
                                            kinds: Some(&[Kind::Object]),
                                            required: &["shared"],
                                            not_all: &[&["image"], &["resources"], &["external"]],
                                            ..NONE
                                        },
                                        Shape {
                                            kinds: Some(&[Kind::Object]),
                                            required: &["image", "resources"],
                                            not_all: &[&["shared"], &["external"]],
                                            ..NONE
                                        },
                                        Shape {
                                            kinds: Some(&[Kind::Object]),
                                            required: &["external"],
                                            not_all: &[&["shared"], &["image"], &["resources"]],
                                            ..NONE
                                        },
                                    ],
                                    ..NONE
                                },
                            ),
                            (
                                "weaver",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    required: &["image", "resources"],
                                    members: &[
                                        ("image", reference("Image")),
                                        ("resources", reference("Resources")),
                                    ],
                                    closed: Some(&["image", "resources"]),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&[
                            "embedding",
                            "graph",
                            "knowledgeBase",
                            "librarian",
                            "logLevel",
                            "smelter",
                            "vectors",
                            "weaver",
                        ]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["apiVersion", "kind", "metadata", "spec"]),
            ..NONE
        },
    ),
    (
        "LastEventIds",
        Shape {
            kinds: Some(&[Kind::Object]),
            values: Some(&reference("PersistedEventId")),
            names: Some(&reference("ResourceId")),
            ..NONE
        },
    ),
    (
        "LibrarianConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "kb",
                "gatewayUrl",
                "identity",
                "archivist",
                "graph",
                "vectors",
                "embedding",
                "matcher",
                "gatherer",
                "modelCatalogue",
                "gather",
                "search",
                "port",
                "logLevel",
                "logFormat",
            ],
            members: &[
                ("archivist", reference("ServiceAddress")),
                ("embedding", reference("EmbeddingConfig")),
                (
                    "gatewayUrl",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "gather",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["settleTimeoutMs"],
                        members: &[(
                            "settleTimeoutMs",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(1.0),
                                ..NONE
                            },
                        )],
                        closed: Some(&["settleTimeoutMs"]),
                        ..NONE
                    },
                ),
                ("gatherer", reference("LibrarianEngineConfig")),
                ("graph", reference("GraphConfig")),
                ("identity", reference("ServiceIdentity")),
                ("kb", reference("KbIdentity")),
                ("logFormat", reference("LogFormat")),
                ("logLevel", reference("LogLevel")),
                ("matcher", reference("LibrarianEngineConfig")),
                (
                    "modelCatalogue",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "port",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(65535.0),
                        ..NONE
                    },
                ),
                (
                    "search",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["semanticFloor"],
                        members: &[(
                            "semanticFloor",
                            Shape {
                                kinds: Some(&[Kind::Number]),
                                minimum: Some(0.0),
                                maximum: Some(1.0),
                                ..NONE
                            },
                        )],
                        closed: Some(&["semanticFloor"]),
                        ..NONE
                    },
                ),
                ("vectors", reference("VectorsConfig")),
            ],
            closed: Some(&[
                "archivist",
                "embedding",
                "gatewayUrl",
                "gather",
                "gatherer",
                "graph",
                "identity",
                "kb",
                "logFormat",
                "logLevel",
                "matcher",
                "modelCatalogue",
                "port",
                "search",
                "vectors",
            ]),
            ..NONE
        },
    ),
    (
        "LibrarianEngineConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["engine", "baseUrl"],
            members: &[
                (
                    "apiKeyEnv",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "baseUrl",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("engine", reference("Engine")),
            ],
            closed: Some(&["apiKeyEnv", "baseUrl", "engine"]),
            ..NONE
        },
    ),
    (
        "LibrarianHealth",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["status", "kb", "actors"],
            members: &[
                (
                    "actors",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        min_items: Some(2),
                        items: Some(&Shape {
                            kinds: Some(&[Kind::String]),
                            enumeration: Some(&[Listed::Text("matcher"), Listed::Text("gatherer")]),
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                ("kb", reference("KbDid")),
                (
                    "status",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("ok")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["actors", "kb", "status"]),
            ..NONE
        },
    ),
    (
        "LibrarianPromptScore",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["candidate", "score"],
            members: &[
                ("candidate", of(&[Kind::Number])),
                ("score", of(&[Kind::Number])),
            ],
            closed: Some(&["candidate", "score"]),
            ..NONE
        },
    ),
    (
        "LimitRefusal",
        Shape {
            kinds: Some(&[Kind::Object]),
            all_of: &[
                reference("ErrorResponse"),
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["code"],
                    members: &[(
                        "code",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            enumeration: Some(&[
                                Listed::Text("streams"),
                                Listed::Text("emit-rate"),
                                Listed::Text("unanswered-requests"),
                                Listed::Text("capacity"),
                                Listed::Text("refusal-rate"),
                            ]),
                            ..NONE
                        },
                    )],
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "LinkingJobParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["motivation", "entityTypes"],
            members: &[
                (
                    "entityTypes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        min_items: Some(1),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("includeDescriptiveReferences", of(&[Kind::Boolean])),
                ("language", of(&[Kind::String])),
                (
                    "motivation",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("linking")]),
                        ..NONE
                    },
                ),
                ("sourceLanguage", of(&[Kind::String])),
            ],
            closed: Some(&[
                "entityTypes",
                "includeDescriptiveReferences",
                "language",
                "motivation",
                "sourceLanguage",
            ]),
            ..NONE
        },
    ),
    (
        "ListResourcesResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resources", "total", "offset", "limit"],
            members: &[
                ("limit", of(&[Kind::Number])),
                ("offset", of(&[Kind::Number])),
                (
                    "resources",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("ResourceDescriptor")),
                        ..NONE
                    },
                ),
                ("total", of(&[Kind::Number])),
            ],
            ..NONE
        },
    ),
    (
        "LocalEndpoint",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["kind", "kbId"],
            members: &[
                ("kbId", of(&[Kind::String])),
                (
                    "kind",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("local")]),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "LocalTarget",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["kind", "root"],
            members: &[
                (
                    "kind",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("local")]),
                        ..NONE
                    },
                ),
                (
                    "root",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["kind", "root"]),
            ..NONE
        },
    ),
    (
        "LogFormat",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[Listed::Text("json"), Listed::Text("simple")]),
            ..NONE
        },
    ),
    (
        "LogLevel",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("error"),
                Listed::Text("warn"),
                Listed::Text("info"),
                Listed::Text("http"),
                Listed::Text("debug"),
            ]),
            ..NONE
        },
    ),
    (
        "LogRecord",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["requestId", "service", "stream", "line", "receivedAt"],
            members: &[
                ("line", of(&[Kind::String])),
                (
                    "receivedAt",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("requestId", reference("RequestId")),
                ("service", of(&[Kind::String])),
                ("stream", reference("OutputStream")),
            ],
            closed: Some(&["line", "receivedAt", "requestId", "service", "stream"]),
            ..NONE
        },
    ),
    (
        "LogsFollowParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion"],
            members: &[
                ("apiVersion", reference("ApiVersion")),
                ("runtime", reference("Runtime")),
                (
                    "service",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("target", reference("Target")),
            ],
            closed: Some(&["apiVersion", "runtime", "service", "target"]),
            ..NONE
        },
    ),
    (
        "LogsFollowResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["services"],
            members: &[(
                "services",
                Shape {
                    kinds: Some(&[Kind::Array]),
                    items: Some(&of(&[Kind::String])),
                    ..NONE
                },
            )],
            closed: Some(&["services"]),
            ..NONE
        },
    ),
    (
        "MarkArchiveCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId"],
            members: &[
                ("_userId", reference("UserId")),
                ("keepFile", of(&[Kind::Boolean])),
                ("resourceId", reference("ResourceId")),
                ("storageUri", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "MarkCommitCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "annotations"],
            members: &[
                (
                    "_roles",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("_userId", reference("UserId")),
                (
                    "annotations",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("Annotation")),
                        ..NONE
                    },
                ),
                ("jobId", reference("JobId")),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "MarkCommitOk",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[(
                "response",
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["persisted", "annotationIds"],
                    members: &[
                        (
                            "annotationIds",
                            Shape {
                                kinds: Some(&[Kind::Array]),
                                items: Some(&reference("AnnotationId")),
                                ..NONE
                            },
                        ),
                        ("persisted", of(&[Kind::Integer])),
                    ],
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "MarkCreateOk",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("MarkCreateOkResponse"))],
            ..NONE
        },
    ),
    (
        "MarkCreateOkResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["annotationId"],
            members: &[("annotationId", reference("AnnotationId"))],
            ..NONE
        },
    ),
    (
        "MarkCreateRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "request"],
            members: &[
                ("request", reference("CreateAnnotationRequest")),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "MarkDelegateTimeoutEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "motivation"],
            members: &[
                ("motivation", reference("Motivation")),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "MarkDeleteCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["annotationId"],
            members: &[
                ("_userId", reference("UserId")),
                ("annotationId", reference("AnnotationId")),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "MarkDeleteOk",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[(
                "response",
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["annotationId"],
                    members: &[("annotationId", reference("AnnotationId"))],
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "MarkJobCompleteCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "jobId", "jobType"],
            members: &[
                ("_userId", reference("UserId")),
                ("attempt", of(&[Kind::Integer])),
                ("durability", reference("DurabilityEvidence")),
                ("jobId", reference("JobId")),
                (
                    "jobType",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("mark")]),
                        ..NONE
                    },
                ),
                ("resourceId", reference("ResourceId")),
                ("result", reference("MarkJobResult")),
            ],
            ..NONE
        },
    ),
    (
        "MarkJobCreateCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobType", "resourceId", "params"],
            members: &[
                (
                    "_roles",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("_userId", reference("UserId")),
                (
                    "jobType",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("mark")]),
                        ..NONE
                    },
                ),
                ("params", reference("MarkJobParams")),
                ("resourceId", reference("ResourceId")),
            ],
            closed: Some(&["_roles", "_userId", "jobType", "params", "resourceId"]),
            ..NONE
        },
    ),
    (
        "MarkJobDone",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["found", "persisted"],
            members: &[
                (
                    "byCategory",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        values: Some(&of(&[Kind::Integer])),
                        ..NONE
                    },
                ),
                (
                    "errors",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        ..NONE
                    },
                ),
                (
                    "found",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "persisted",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "uncheckedPieces",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        ..NONE
                    },
                ),
                ("underReportedPieces", of(&[Kind::Integer])),
            ],
            closed: Some(&[
                "byCategory",
                "errors",
                "found",
                "persisted",
                "uncheckedPieces",
                "underReportedPieces",
            ]),
            ..NONE
        },
    ),
    (
        "MarkJobFilter",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobType", "params"],
            members: &[
                (
                    "jobType",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("mark")]),
                        ..NONE
                    },
                ),
                (
                    "params",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["motivation"],
                        members: &[("motivation", reference("Motivation"))],
                        closed: Some(&["motivation"]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["jobType", "params"]),
            ..NONE
        },
    ),
    (
        "MarkJobParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("HighlightingJobParams"),
                reference("CommentingJobParams"),
                reference("AssessingJobParams"),
                reference("LinkingJobParams"),
                reference("TaggingJobParams"),
            ],
            discriminator: Some(Discriminator {
                property: "motivation",
                mapping: &[
                    ("highlighting", 0),
                    ("commenting", 1),
                    ("assessing", 2),
                    ("linking", 3),
                    ("tagging", 4),
                ],
            }),
            ..NONE
        },
    ),
    (
        "MarkJobQueuedEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobId", "jobType", "resourceId", "userId", "params"],
            members: &[
                ("jobId", reference("JobId")),
                (
                    "jobType",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("mark")]),
                        ..NONE
                    },
                ),
                ("params", reference("MarkJobParams")),
                ("resourceId", reference("ResourceId")),
                ("userId", reference("UserId")),
            ],
            ..NONE
        },
    ),
    (
        "MarkJobResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[reference("MarkJobDone"), reference("JobDeclined")],
            ..NONE
        },
    ),
    (
        "MarkRequestedEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["source", "selector", "motivation"],
            members: &[
                ("motivation", reference("Motivation")),
                ("selector", reference("AnnotationSelector")),
                ("source", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "MarkSubmitEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["source", "motivation", "selector"],
            members: &[
                ("body", reference("AnnotationBodies")),
                ("motivation", reference("Motivation")),
                ("selector", reference("AnnotationSelector")),
                ("source", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "MarkUnarchiveCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId"],
            members: &[
                ("_userId", reference("UserId")),
                ("resourceId", reference("ResourceId")),
                ("storageUri", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "MarkUpdateBodyCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["annotationId", "resourceId", "operations"],
            members: &[
                ("_userId", reference("UserId")),
                ("annotationId", reference("AnnotationId")),
                (
                    "operations",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("BodyOperation")),
                        ..NONE
                    },
                ),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "MarkUpdateEntityTypesCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "currentEntityTypes", "updatedEntityTypes"],
            members: &[
                ("_userId", reference("UserId")),
                (
                    "currentEntityTypes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("resourceId", reference("ResourceId")),
                (
                    "updatedEntityTypes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "MatchQuality",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("normalized"),
                Listed::Text("case-insensitive"),
                Listed::Text("fuzzy"),
            ]),
            ..NONE
        },
    ),
    (
        "MatchResourcesRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["search"],
            members: &[
                ("archived", of(&[Kind::Boolean])),
                ("entityType", of(&[Kind::String])),
                (
                    "limit",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(200.0),
                        ..NONE
                    },
                ),
                (
                    "offset",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("search", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "MatchResourcesResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resources", "total", "offset", "limit", "matchKind"],
            members: &[
                (
                    "limit",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        ..NONE
                    },
                ),
                (
                    "matchKind",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("lexical"), Listed::Text("semantic")]),
                        ..NONE
                    },
                ),
                (
                    "offset",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "resources",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("ResourceDescriptor")),
                        ..NONE
                    },
                ),
                (
                    "total",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "MatchResourcesResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("MatchResourcesResponse"))],
            ..NONE
        },
    ),
    (
        "MatchSearchFailed",
        Shape {
            kinds: Some(&[Kind::Object]),
            all_of: &[
                reference("CommandError"),
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["referenceId"],
                    members: &[("referenceId", reference("AnnotationId"))],
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "MatchSearchOptions",
        Shape {
            kinds: Some(&[Kind::Object]),
            members: &[
                (
                    "limit",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(200.0),
                        ..NONE
                    },
                ),
                ("useSemanticScoring", of(&[Kind::Boolean])),
            ],
            closed: Some(&["limit", "useSemanticScoring"]),
            ..NONE
        },
    ),
    (
        "MatchSearchRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "referenceId", "context"],
            members: &[
                ("context", reference("GatheredContext")),
                (
                    "limit",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(200.0),
                        ..NONE
                    },
                ),
                ("referenceId", reference("AnnotationId")),
                ("resourceId", reference("ResourceId")),
                ("useSemanticScoring", of(&[Kind::Boolean])),
            ],
            ..NONE
        },
    ),
    (
        "MatchSearchResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["referenceId", "response"],
            members: &[
                ("referenceId", reference("AnnotationId")),
                (
                    "response",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("ScoredResource")),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "MediaTokenRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId"],
            members: &[("resourceId", reference("ResourceId"))],
            ..NONE
        },
    ),
    (
        "MediaTokenResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["token"],
            members: &[("token", of(&[Kind::String]))],
            ..NONE
        },
    ),
    (
        "MemoryGraphConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["type"],
            members: &[(
                "type",
                Shape {
                    kinds: Some(&[Kind::String]),
                    enumeration: Some(&[Listed::Text("memory")]),
                    ..NONE
                },
            )],
            closed: Some(&["type"]),
            ..NONE
        },
    ),
    (
        "MemoryVectorsConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["type"],
            members: &[(
                "type",
                Shape {
                    kinds: Some(&[Kind::String]),
                    enumeration: Some(&[Listed::Text("memory")]),
                    ..NONE
                },
            )],
            closed: Some(&["type"]),
            ..NONE
        },
    ),
    (
        "Metadata",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["name"],
            members: &[
                (
                    "annotations",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        values: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                (
                    "labels",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        values: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                (
                    "name",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        pattern: Some(&[
                            Term::Step(Step {
                                of: &[(48, 57), (97, 122)],
                                min: 1,
                                max: Some(1),
                            }),
                            Term::Group(Group {
                                either: &[&[
                                    Term::Step(Step {
                                        of: &[(45, 45), (48, 57), (97, 122)],
                                        min: 0,
                                        max: None,
                                    }),
                                    Term::Step(Step {
                                        of: &[(48, 57), (97, 122)],
                                        min: 1,
                                        max: Some(1),
                                    }),
                                ]],
                                min: 0,
                                max: Some(1),
                            }),
                        ]),
                        max_length: Some(63),
                        ..NONE
                    },
                ),
                (
                    "namespace",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        pattern: Some(&[
                            Term::Step(Step {
                                of: &[(48, 57), (97, 122)],
                                min: 1,
                                max: Some(1),
                            }),
                            Term::Group(Group {
                                either: &[&[
                                    Term::Step(Step {
                                        of: &[(45, 45), (48, 57), (97, 122)],
                                        min: 0,
                                        max: None,
                                    }),
                                    Term::Step(Step {
                                        of: &[(48, 57), (97, 122)],
                                        min: 1,
                                        max: Some(1),
                                    }),
                                ]],
                                min: 0,
                                max: Some(1),
                            }),
                        ]),
                        max_length: Some(63),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["annotations", "labels", "name", "namespace"]),
            ..NONE
        },
    ),
    (
        "Motivation",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("assessing"),
                Listed::Text("commenting"),
                Listed::Text("highlighting"),
                Listed::Text("linking"),
                Listed::Text("tagging"),
            ]),
            ..NONE
        },
    ),
    (
        "Neo4jGraphConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["type", "uri", "username", "passwordEnv", "database"],
            members: &[
                (
                    "database",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "passwordEnv",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("neo4j")]),
                        ..NONE
                    },
                ),
                (
                    "uri",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "username",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["database", "passwordEnv", "type", "uri", "username"]),
            ..NONE
        },
    ),
    (
        "NeptuneGraphConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["type", "endpoint", "port"],
            members: &[
                (
                    "endpoint",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "port",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(65535.0),
                        ..NONE
                    },
                ),
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("neptune")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["endpoint", "port", "type"]),
            ..NONE
        },
    ),
    (
        "NewKnowledgeBase",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["label", "endpoint", "did"],
            members: &[
                ("did", of(&[Kind::String])),
                ("endpoint", reference("KbEndpoint")),
                ("label", of(&[Kind::String])),
                ("lastRead", reference("KbRead")),
            ],
            ..NONE
        },
    ),
    (
        "OcrConfidence",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["mean", "lowConfidenceWords", "totalWords"],
            members: &[
                ("lowConfidenceWords", of(&[Kind::Integer])),
                ("mean", of(&[Kind::Number])),
                ("totalWords", of(&[Kind::Integer])),
            ],
            ..NONE
        },
    ),
    (
        "OllamaEmbeddingConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["type", "model", "baseUrl"],
            members: &[
                (
                    "baseUrl",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "model",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("ollama")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["baseUrl", "model", "type"]),
            ..NONE
        },
    ),
    (
        "OneOrMoreAgents",
        Shape {
            kinds: Some(&[Kind::Object, Kind::Array]),
            one_of: &[
                reference("Agent"),
                Shape {
                    kinds: Some(&[Kind::Array]),
                    min_items: Some(1),
                    items: Some(&reference("Agent")),
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "OneOrMoreStrings",
        Shape {
            kinds: Some(&[Kind::Array, Kind::String]),
            one_of: &[
                of(&[Kind::String]),
                Shape {
                    kinds: Some(&[Kind::Array]),
                    min_items: Some(1),
                    items: Some(&of(&[Kind::String])),
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "OneOrMoreUris",
        Shape {
            kinds: Some(&[Kind::Array, Kind::String]),
            one_of: &[
                of(&[Kind::String]),
                Shape {
                    kinds: Some(&[Kind::Array]),
                    min_items: Some(1),
                    items: Some(&of(&[Kind::String])),
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "OpenResource",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["id", "name", "openedAt", "order"],
            members: &[
                ("id", reference("ResourceId")),
                ("mediaType", of(&[Kind::String])),
                ("name", of(&[Kind::String])),
                (
                    "openedAt",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "order",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("storageUri", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "OutputStream",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[Listed::Text("stdout"), Listed::Text("stderr")]),
            ..NONE
        },
    ),
    (
        "PdfClass",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("A"),
                Listed::Text("B"),
                Listed::Text("C"),
                Listed::Text("D"),
                Listed::Text("E"),
                Listed::Text("F"),
                Listed::Text("G"),
            ]),
            ..NONE
        },
    ),
    (
        "PdfCoordinate",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["page", "x", "y", "width", "height"],
            members: &[
                ("height", of(&[Kind::Number])),
                ("page", of(&[Kind::Integer])),
                ("width", of(&[Kind::Number])),
                ("x", of(&[Kind::Number])),
                ("y", of(&[Kind::Number])),
            ],
            closed: Some(&["height", "page", "width", "x", "y"]),
            ..NONE
        },
    ),
    (
        "PdfTextItem",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["start", "end", "page", "x", "y", "width", "height"],
            members: &[
                (
                    "end",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("height", of(&[Kind::Number])),
                ("page", of(&[Kind::Integer])),
                (
                    "start",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("width", of(&[Kind::Number])),
                ("x", of(&[Kind::Number])),
                ("y", of(&[Kind::Number])),
            ],
            ..NONE
        },
    ),
    (
        "PendingAnnotation",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["selector", "motivation"],
            members: &[
                ("motivation", reference("Motivation")),
                ("selector", reference("AnnotationSelector")),
            ],
            closed: Some(&["motivation", "selector"]),
            ..NONE
        },
    ),
    (
        "PendingAuthorization",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["state", "verifier", "redirectUri", "target", "issuer"],
            members: &[
                ("expectedDid", of(&[Kind::String])),
                ("expectedName", of(&[Kind::String])),
                (
                    "issuer",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["issuer", "authorization", "token"],
                        members: &[
                            ("authorization", of(&[Kind::String])),
                            ("device", of(&[Kind::String])),
                            ("issuer", of(&[Kind::String])),
                            ("revocation", of(&[Kind::String])),
                            ("token", of(&[Kind::String])),
                        ],
                        ..NONE
                    },
                ),
                ("kbId", of(&[Kind::String])),
                ("redirectUri", of(&[Kind::String])),
                ("state", of(&[Kind::String])),
                ("target", reference("HttpEndpoint")),
                ("verifier", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "PermissionDenied",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["detail"],
            members: &[("detail", of(&[Kind::String, Kind::Null]))],
            closed: Some(&["detail"]),
            ..NONE
        },
    ),
    (
        "PersistedEventId",
        Shape {
            kinds: Some(&[Kind::String]),
            pattern: Some(&[
                Term::Step(Step {
                    of: &[(112, 112)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(45, 45)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(0, 9), (11, 12), (14, 8231), (8234, 1114111)],
                    min: 1,
                    max: None,
                }),
                Term::Step(Step {
                    of: &[(45, 45)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(48, 57)],
                    min: 1,
                    max: None,
                }),
            ]),
            ..NONE
        },
    ),
    (
        "PrincipalProfileCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["name"],
            members: &[
                ("_userId", reference("UserId")),
                ("name", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "PrincipalProfiledPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["name"],
            members: &[("name", of(&[Kind::String]))],
            ..NONE
        },
    ),
    (
        "Profile",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["name", "since"],
            members: &[
                ("name", of(&[Kind::String])),
                ("since", of(&[Kind::String])),
            ],
            closed: Some(&["name", "since"]),
            ..NONE
        },
    ),
    (
        "ProfilesProjection",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["profiles"],
            members: &[(
                "profiles",
                Shape {
                    kinds: Some(&[Kind::Object]),
                    values: Some(&reference("Profile")),
                    ..NONE
                },
            )],
            closed: Some(&["profiles"]),
            ..NONE
        },
    ),
    (
        "Progress",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["requestId", "kind", "text"],
            members: &[
                (
                    "kind",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("log"),
                            Listed::Text("note"),
                            Listed::Text("ok"),
                            Listed::Text("warn"),
                            Listed::Text("fail"),
                            Listed::Text("banner"),
                            Listed::Text("section"),
                            Listed::Text("stamp"),
                            Listed::Text("command"),
                            Listed::Text("output"),
                        ]),
                        ..NONE
                    },
                ),
                ("requestId", reference("RequestId")),
                ("text", of(&[Kind::String])),
            ],
            closed: Some(&["kind", "requestId", "text"]),
            ..NONE
        },
    ),
    (
        "ProjectConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["project", "git", "site"],
            members: &[
                (
                    "git",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["sync"],
                        members: &[("sync", of(&[Kind::Boolean]))],
                        closed: Some(&["sync"]),
                        ..NONE
                    },
                ),
                (
                    "project",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["name"],
                        members: &[
                            (
                                "name",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    min_length: Some(1),
                                    ..NONE
                                },
                            ),
                            (
                                "version",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    min_length: Some(1),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&["name", "version"]),
                        ..NONE
                    },
                ),
                (
                    "site",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["domain", "siteName"],
                        members: &[
                            (
                                "domain",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    pattern: Some(&[Term::Step(Step {
                                        of: &[
                                            (0, 8),
                                            (14, 31),
                                            (33, 159),
                                            (161, 5759),
                                            (5761, 8191),
                                            (8203, 8231),
                                            (8234, 8238),
                                            (8240, 8286),
                                            (8288, 12287),
                                            (12289, 65278),
                                            (65280, 1114111),
                                        ],
                                        min: 1,
                                        max: None,
                                    })]),
                                    min_length: Some(1),
                                    ..NONE
                                },
                            ),
                            (
                                "siteName",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    min_length: Some(1),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&["domain", "siteName"]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["git", "project", "site"]),
            ..NONE
        },
    ),
    (
        "ProtectedResourceMetadata",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "resource",
                "authorization_servers",
                "bearer_methods_supported",
            ],
            members: &[
                (
                    "authorization_servers",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                (
                    "bearer_methods_supported",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&Shape {
                            kinds: Some(&[Kind::String]),
                            enumeration: Some(&[Listed::Text("header")]),
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                ("resource", of(&[Kind::String])),
                ("resource_name", of(&[Kind::String])),
            ],
            closed: Some(&[
                "authorization_servers",
                "bearer_methods_supported",
                "resource",
                "resource_name",
            ]),
            ..NONE
        },
    ),
    (
        "Provider",
        Shape {
            kinds: Some(&[Kind::Object]),
            members: &[
                ("apiKey", reference("SecretRef")),
                (
                    "baseURL",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["apiKey", "baseURL"]),
            ..NONE
        },
    ),
    (
        "QdrantVectorsConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["type", "host", "port", "tokenEnv"],
            members: &[
                (
                    "host",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "port",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(65535.0),
                        ..NONE
                    },
                ),
                (
                    "tokenEnv",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("qdrant")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["host", "port", "tokenEnv", "type"]),
            ..NONE
        },
    ),
    (
        "QuotedText",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["exact"],
            members: &[
                ("exact", of(&[Kind::String])),
                ("prefix", of(&[Kind::String])),
                ("suffix", of(&[Kind::String])),
            ],
            closed: Some(&["exact", "prefix", "suffix"]),
            ..NONE
        },
    ),
    (
        "ReconciledSpan",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["start", "end", "exact", "anchorMethod"],
                    members: &[
                        (
                            "anchorMethod",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                enumeration: Some(&[Listed::Text("unique-match")]),
                                ..NONE
                            },
                        ),
                        (
                            "end",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(0.0),
                                ..NONE
                            },
                        ),
                        ("exact", of(&[Kind::String])),
                        ("prefix", of(&[Kind::String])),
                        (
                            "start",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(0.0),
                                ..NONE
                            },
                        ),
                        ("suffix", of(&[Kind::String])),
                    ],
                    closed: Some(&["anchorMethod", "end", "exact", "prefix", "start", "suffix"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["start", "end", "exact", "anchorMethod"],
                    members: &[
                        (
                            "anchorMethod",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                enumeration: Some(&[Listed::Text("context-recovered")]),
                                ..NONE
                            },
                        ),
                        (
                            "end",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(0.0),
                                ..NONE
                            },
                        ),
                        ("exact", of(&[Kind::String])),
                        ("prefix", of(&[Kind::String])),
                        (
                            "start",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(0.0),
                                ..NONE
                            },
                        ),
                        ("suffix", of(&[Kind::String])),
                    ],
                    closed: Some(&["anchorMethod", "end", "exact", "prefix", "start", "suffix"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["start", "end", "exact", "anchorMethod"],
                    members: &[
                        (
                            "anchorMethod",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                enumeration: Some(&[Listed::Text("first-of-many")]),
                                ..NONE
                            },
                        ),
                        (
                            "end",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(0.0),
                                ..NONE
                            },
                        ),
                        ("exact", of(&[Kind::String])),
                        ("prefix", of(&[Kind::String])),
                        (
                            "start",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(0.0),
                                ..NONE
                            },
                        ),
                        ("suffix", of(&[Kind::String])),
                    ],
                    closed: Some(&["anchorMethod", "end", "exact", "prefix", "start", "suffix"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["start", "end", "exact", "anchorMethod", "matchQuality"],
                    members: &[
                        (
                            "anchorMethod",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                enumeration: Some(&[Listed::Text("fuzzy-match")]),
                                ..NONE
                            },
                        ),
                        (
                            "end",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(0.0),
                                ..NONE
                            },
                        ),
                        ("exact", of(&[Kind::String])),
                        ("matchQuality", reference("MatchQuality")),
                        ("prefix", of(&[Kind::String])),
                        (
                            "start",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(0.0),
                                ..NONE
                            },
                        ),
                        ("suffix", of(&[Kind::String])),
                    ],
                    closed: Some(&[
                        "anchorMethod",
                        "end",
                        "exact",
                        "matchQuality",
                        "prefix",
                        "start",
                        "suffix",
                    ]),
                    ..NONE
                },
            ],
            discriminator: Some(Discriminator {
                property: "anchorMethod",
                mapping: &[
                    ("unique-match", 0),
                    ("context-recovered", 1),
                    ("first-of-many", 2),
                    ("fuzzy-match", 3),
                ],
            }),
            ..NONE
        },
    ),
    (
        "ReplyEventId",
        Shape {
            kinds: Some(&[Kind::String]),
            pattern: Some(&[
                Term::Step(Step {
                    of: &[(101, 101)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(45, 45)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(0, 57), (59, 1114111)],
                    min: 1,
                    max: None,
                }),
                Term::Step(Step {
                    of: &[(58, 58)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(0, 57), (59, 1114111)],
                    min: 1,
                    max: None,
                }),
                Term::Step(Step {
                    of: &[(58, 58)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(0, 9), (11, 12), (14, 8231), (8234, 1114111)],
                    min: 1,
                    max: None,
                }),
            ]),
            ..NONE
        },
    ),
    (
        "Representation",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["mediaType"],
            members: &[
                ("@id", of(&[Kind::String])),
                ("@type", reference("OneOrMoreStrings")),
                (
                    "byteSize",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("checksum", of(&[Kind::String])),
                ("conformsTo", reference("OneOrMoreUris")),
                ("created", of(&[Kind::String])),
                (
                    "duration",
                    Shape {
                        kinds: Some(&[Kind::Number]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("encoding", of(&[Kind::String])),
                ("filename", of(&[Kind::String])),
                (
                    "height",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("language", of(&[Kind::String])),
                ("mediaType", of(&[Kind::String])),
                ("modified", of(&[Kind::String])),
                (
                    "rel",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("original"),
                            Listed::Text("thumbnail"),
                            Listed::Text("preview"),
                            Listed::Text("optimized"),
                            Listed::Text("derived"),
                            Listed::Text("other"),
                        ]),
                        ..NONE
                    },
                ),
                ("storageUri", of(&[Kind::String])),
                (
                    "tags",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                (
                    "width",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "RepresentationAddedPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["representation"],
            members: &[("representation", reference("Representation"))],
            ..NONE
        },
    ),
    (
        "RepresentationNotFound",
        Shape {
            kinds: Some(&[Kind::Object]),
            all_of: &[
                reference("ErrorResponse"),
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["code"],
                    members: &[(
                        "code",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            enumeration: Some(&[
                                Listed::Text("resource"),
                                Listed::Text("representation"),
                            ]),
                            ..NONE
                        },
                    )],
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "RepresentationRemovedPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["checksum"],
            members: &[("checksum", of(&[Kind::String]))],
            ..NONE
        },
    ),
    ("RequestId", of(&[Kind::String, Kind::Integer])),
    (
        "ResourceAnnotations",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "annotations", "version", "updatedAt"],
            members: &[
                (
                    "annotations",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("Annotation")),
                        ..NONE
                    },
                ),
                ("resourceId", reference("ResourceId")),
                ("updatedAt", of(&[Kind::String])),
                (
                    "version",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["annotations", "resourceId", "updatedAt", "version"]),
            ..NONE
        },
    ),
    (
        "ResourceArchivedPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            members: &[("reason", of(&[Kind::String]))],
            ..NONE
        },
    ),
    (
        "ResourceClonedPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["name", "format", "contentChecksum", "parentResourceId"],
            members: &[
                ("contentByteSize", of(&[Kind::Integer])),
                ("contentChecksum", of(&[Kind::String])),
                ("creator", reference("Agent")),
                (
                    "entityTypes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("format", reference("ContentFormat")),
                ("language", of(&[Kind::String])),
                ("name", of(&[Kind::String])),
                ("parentResourceId", reference("ResourceId")),
                ("storageUri", of(&[Kind::String])),
                ("wasAttributedTo", reference("OneOrMoreAgents")),
            ],
            ..NONE
        },
    ),
    (
        "ResourceCreatedPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["name", "format", "contentChecksum"],
            members: &[
                ("contentByteSize", of(&[Kind::Integer])),
                ("contentChecksum", of(&[Kind::String])),
                ("creator", reference("Agent")),
                (
                    "entityTypes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("format", reference("ContentFormat")),
                (
                    "generatedFrom",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["resourceId"],
                        members: &[
                            ("annotationId", reference("AnnotationId")),
                            ("resourceId", reference("ResourceId")),
                        ],
                        ..NONE
                    },
                ),
                ("generationPrompt", of(&[Kind::String])),
                ("generator", reference("OneOrMoreAgents")),
                ("isDraft", of(&[Kind::Boolean])),
                ("jobId", reference("JobId")),
                ("language", of(&[Kind::String])),
                ("name", of(&[Kind::String])),
                ("storageUri", of(&[Kind::String])),
                ("wasAttributedTo", reference("OneOrMoreAgents")),
            ],
            ..NONE
        },
    ),
    (
        "ResourceDescriptor",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["@context", "@id", "name", "representations"],
            members: &[
                (
                    "@context",
                    Shape {
                        kinds: Some(&[Kind::Object, Kind::Array, Kind::String]),
                        one_of: &[
                            of(&[Kind::String]),
                            of(&[Kind::Object]),
                            Shape {
                                kinds: Some(&[Kind::Array]),
                                items: Some(&Shape {
                                    kinds: Some(&[Kind::Object, Kind::String]),
                                    one_of: &[of(&[Kind::String]), of(&[Kind::Object])],
                                    ..NONE
                                }),
                                ..NONE
                            },
                        ],
                        ..NONE
                    },
                ),
                ("@id", reference("ResourceId")),
                ("@type", reference("OneOrMoreStrings")),
                ("about", reference("OneOrMoreStrings")),
                ("archived", of(&[Kind::Boolean])),
                (
                    "availableFormats",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("conformsTo", reference("OneOrMoreUris")),
                ("dateCreated", of(&[Kind::String])),
                ("dateModified", of(&[Kind::String])),
                ("description", of(&[Kind::String])),
                (
                    "entityTypes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("generator", reference("OneOrMoreAgents")),
                (
                    "hasPart",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                (
                    "identifier",
                    Shape {
                        kinds: Some(&[Kind::Object, Kind::Array, Kind::String]),
                        one_of: &[
                            of(&[Kind::String]),
                            Shape {
                                kinds: Some(&[Kind::Array]),
                                min_items: Some(1),
                                items: Some(&of(&[Kind::String])),
                                ..NONE
                            },
                            Shape {
                                kinds: Some(&[Kind::Object]),
                                members: &[
                                    ("@id", of(&[Kind::String])),
                                    ("scheme", of(&[Kind::String])),
                                    ("value", of(&[Kind::String])),
                                ],
                                ..NONE
                            },
                        ],
                        ..NONE
                    },
                ),
                ("isDraft", of(&[Kind::Boolean])),
                (
                    "isPartOf",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("license", of(&[Kind::String])),
                ("name", of(&[Kind::String])),
                ("originatedFrom", of(&[Kind::String])),
                (
                    "representations",
                    Shape {
                        kinds: Some(&[Kind::Object, Kind::Array]),
                        one_of: &[
                            reference("Representation"),
                            Shape {
                                kinds: Some(&[Kind::Array]),
                                items: Some(&reference("Representation")),
                                ..NONE
                            },
                        ],
                        ..NONE
                    },
                ),
                (
                    "sameAs",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("sourceAnnotationId", reference("AnnotationId")),
                ("sourceResourceId", reference("ResourceId")),
                ("version", of(&[Kind::String])),
                ("wasAttributedTo", reference("OneOrMoreAgents")),
                (
                    "wasDerivedFrom",
                    Shape {
                        kinds: Some(&[Kind::Array, Kind::String]),
                        one_of: &[
                            reference("ResourceId"),
                            Shape {
                                kinds: Some(&[Kind::Array]),
                                items: Some(&reference("ResourceId")),
                                ..NONE
                            },
                        ],
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "ResourceErrorEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "message"],
            members: &[
                ("message", of(&[Kind::String])),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "ResourceId",
        Shape {
            kinds: Some(&[Kind::String]),
            pattern: Some(&[Term::Step(Step {
                of: &[(45, 45), (48, 57), (65, 90), (95, 95), (97, 122)],
                min: 1,
                max: Some(128),
            })]),
            ..NONE
        },
    ),
    (
        "ResourceMovedPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["fromUri", "toUri"],
            members: &[
                ("fromUri", of(&[Kind::String])),
                ("toUri", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "ResourceSearchFilters",
        Shape {
            kinds: Some(&[Kind::Object]),
            members: &[
                ("archived", of(&[Kind::Boolean])),
                ("entityType", of(&[Kind::String])),
                (
                    "limit",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(200.0),
                        ..NONE
                    },
                ),
                (
                    "offset",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["archived", "entityType", "limit", "offset"]),
            ..NONE
        },
    ),
    ("ResourceUnarchivedPayload", of(&[Kind::Object])),
    (
        "ResourceUpdatedPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["contentChecksum"],
            members: &[
                ("contentByteSize", of(&[Kind::Integer])),
                ("contentChecksum", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "ResourceUpload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["name", "file", "format", "storageUri"],
            members: &[
                ("archiveOriginal", of(&[Kind::String])),
                ("cloneToken", of(&[Kind::String])),
                ("entityTypes", of(&[Kind::String])),
                ("file", reference("Binary")),
                ("format", of(&[Kind::String])),
                ("generationPrompt", of(&[Kind::String])),
                ("generator", of(&[Kind::String])),
                ("isDraft", of(&[Kind::String])),
                ("jobId", reference("JobId")),
                ("language", of(&[Kind::String])),
                ("name", of(&[Kind::String])),
                ("sourceAnnotationId", reference("AnnotationId")),
                ("sourceResourceId", reference("ResourceId")),
                ("storageUri", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "ResourceView",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resource", "annotations", "lastSequence"],
            members: &[
                ("annotations", reference("ResourceAnnotations")),
                (
                    "lastSequence",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        ..NONE
                    },
                ),
                ("resource", reference("ResourceDescriptor")),
            ],
            closed: Some(&["annotations", "lastSequence", "resource"]),
            ..NONE
        },
    ),
    (
        "Resources",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["limits"],
            members: &[(
                "limits",
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["memory"],
                    members: &[(
                        "memory",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            pattern: Some(&[
                                Term::Step(Step {
                                    of: &[(49, 57)],
                                    min: 1,
                                    max: Some(1),
                                }),
                                Term::Step(Step {
                                    of: &[(48, 57)],
                                    min: 0,
                                    max: None,
                                }),
                                Term::Step(Step {
                                    of: &[(71, 71), (77, 77)],
                                    min: 1,
                                    max: Some(1),
                                }),
                            ]),
                            ..NONE
                        },
                    )],
                    closed: Some(&["memory"]),
                    ..NONE
                },
            )],
            closed: Some(&["limits"]),
            ..NONE
        },
    ),
    (
        "RetryBudget",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["attempts", "initialDelayMs", "maxDelayMs"],
            members: &[
                (
                    "attempts",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        ..NONE
                    },
                ),
                (
                    "initialDelayMs",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        ..NONE
                    },
                ),
                (
                    "maxDelayMs",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["attempts", "initialDelayMs", "maxDelayMs"]),
            ..NONE
        },
    ),
    (
        "Root",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["placement", "registered", "running"],
            members: &[
                ("codespace", of(&[Kind::String])),
                ("codespaceState", of(&[Kind::String])),
                ("config", of(&[Kind::String])),
                (
                    "configs",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                (
                    "current",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("cwd"), Listed::Text("xynolog-root")]),
                        ..NONE
                    },
                ),
                ("did", of(&[Kind::String])),
                ("forwardPort", of(&[Kind::Integer])),
                ("forwarded", of(&[Kind::Boolean])),
                ("identityError", of(&[Kind::String])),
                ("lastUsed", of(&[Kind::String])),
                ("path", of(&[Kind::String])),
                ("placement", reference("KbPlacement")),
                ("present", of(&[Kind::Boolean])),
                ("reachable", of(&[Kind::Boolean])),
                ("registered", of(&[Kind::Boolean])),
                ("repo", of(&[Kind::String])),
                ("running", of(&[Kind::Boolean])),
                ("siteName", of(&[Kind::String])),
            ],
            closed: Some(&[
                "codespace",
                "codespaceState",
                "config",
                "configs",
                "current",
                "did",
                "forwardPort",
                "forwarded",
                "identityError",
                "lastUsed",
                "path",
                "placement",
                "present",
                "reachable",
                "registered",
                "repo",
                "running",
                "siteName",
            ]),
            ..NONE
        },
    ),
    (
        "RootsForgetParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion", "root"],
            members: &[
                ("apiVersion", reference("ApiVersion")),
                (
                    "root",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["apiVersion", "root"]),
            ..NONE
        },
    ),
    (
        "RootsForgetResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["path", "directoryMissing"],
            members: &[
                ("directoryMissing", of(&[Kind::Boolean])),
                ("path", of(&[Kind::String])),
                ("persistentState", of(&[Kind::String])),
            ],
            closed: Some(&["directoryMissing", "path", "persistentState"]),
            ..NONE
        },
    ),
    (
        "RootsInitParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion", "path", "domain"],
            members: &[
                (
                    "anthropicEndpoint",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("apiVersion", reference("ApiVersion")),
                (
                    "configName",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "domain",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "embedding",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "inference",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("anthropic"), Listed::Text("ollama")]),
                        ..NONE
                    },
                ),
                (
                    "model",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "modelLight",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "name",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "ollamaBase",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "ollamaRegistry",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "path",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "siteName",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "anthropicEndpoint",
                "apiVersion",
                "configName",
                "domain",
                "embedding",
                "inference",
                "model",
                "modelLight",
                "name",
                "ollamaBase",
                "ollamaRegistry",
                "path",
                "siteName",
            ]),
            ..NONE
        },
    ),
    (
        "RootsInitResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["path"],
            members: &[(
                "path",
                Shape {
                    kinds: Some(&[Kind::String]),
                    min_length: Some(1),
                    ..NONE
                },
            )],
            closed: Some(&["path"]),
            ..NONE
        },
    ),
    (
        "RootsListParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion"],
            members: &[("apiVersion", reference("ApiVersion"))],
            closed: Some(&["apiVersion"]),
            ..NONE
        },
    ),
    (
        "RootsListResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["roots"],
            members: &[
                (
                    "roots",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("Root")),
                        ..NONE
                    },
                ),
                (
                    "warnings",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["roots", "warnings"]),
            ..NONE
        },
    ),
    (
        "RunInstance",
        Shape {
            kinds: Some(&[Kind::String]),
            pattern: Some(&[
                Term::Step(Step {
                    of: &[(48, 57), (97, 122)],
                    min: 1,
                    max: None,
                }),
                Term::Group(Group {
                    either: &[&[
                        Term::Step(Step {
                            of: &[(45, 45)],
                            min: 1,
                            max: Some(1),
                        }),
                        Term::Step(Step {
                            of: &[(48, 57), (97, 122)],
                            min: 1,
                            max: None,
                        }),
                    ]],
                    min: 0,
                    max: None,
                }),
            ]),
            ..NONE
        },
    ),
    (
        "RunService",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("archivist"),
                Listed::Text("dispatcher"),
                Listed::Text("gateway"),
                Listed::Text("librarian"),
                Listed::Text("smelter"),
                Listed::Text("weaver"),
                Listed::Text("worker"),
            ]),
            ..NONE
        },
    ),
    (
        "Runner",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["image", "resources"],
                    not_all: &[&["external"]],
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["external"],
                    not_all: &[&["image"], &["resources"]],
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "Runtime",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("container"),
                Listed::Text("docker"),
                Listed::Text("podman"),
            ]),
            ..NONE
        },
    ),
    (
        "RuntimeState",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["name", "found"],
            members: &[
                ("found", of(&[Kind::Boolean])),
                ("name", reference("Runtime")),
            ],
            closed: Some(&["found", "name"]),
            ..NONE
        },
    ),
    (
        "ScoredResource",
        Shape {
            kinds: Some(&[Kind::Object]),
            all_of: &[
                reference("ResourceDescriptor"),
                Shape {
                    kinds: Some(&[Kind::Object]),
                    members: &[
                        ("matchReason", of(&[Kind::String])),
                        ("score", of(&[Kind::Number])),
                    ],
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "SecretRef",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["fromEnv"],
            members: &[(
                "fromEnv",
                Shape {
                    kinds: Some(&[Kind::String]),
                    pattern: Some(&[
                        Term::Step(Step {
                            of: &[(65, 90), (95, 95), (97, 122)],
                            min: 1,
                            max: Some(1),
                        }),
                        Term::Step(Step {
                            of: &[(48, 57), (65, 90), (95, 95), (97, 122)],
                            min: 0,
                            max: None,
                        }),
                    ]),
                    ..NONE
                },
            )],
            closed: Some(&["fromEnv"]),
            ..NONE
        },
    ),
    (
        "Selector",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("TextPositionSelector"),
                reference("TextQuoteSelector"),
                reference("SvgSelector"),
                reference("FragmentSelector"),
            ],
            discriminator: Some(Discriminator {
                property: "type",
                mapping: &[
                    ("TextPositionSelector", 0),
                    ("TextQuoteSelector", 1),
                    ("SvgSelector", 2),
                    ("FragmentSelector", 3),
                ],
            }),
            ..NONE
        },
    ),
    (
        "SemanticMatch",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["text", "resourceId", "resourceName", "score"],
            members: &[
                ("annotationId", reference("AnnotationId")),
                (
                    "entityTypes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("machineRead", of(&[Kind::Boolean])),
                ("resourceId", reference("ResourceId")),
                ("resourceName", of(&[Kind::String])),
                ("score", of(&[Kind::Number])),
                ("text", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "ServiceAddress",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["host", "port"],
            members: &[
                (
                    "host",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "port",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(65535.0),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["host", "port"]),
            ..NONE
        },
    ),
    (
        "ServiceGroup",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("record"),
                Listed::Text("index"),
                Listed::Text("issuer"),
                Listed::Text("knowledge-workers"),
                Listed::Text("providers"),
                Listed::Text("telemetry"),
            ]),
            ..NONE
        },
    ),
    (
        "ServiceHostParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion"],
            members: &[
                ("apiVersion", reference("ApiVersion")),
                ("runtime", reference("Runtime")),
            ],
            closed: Some(&["apiVersion", "runtime"]),
            ..NONE
        },
    ),
    (
        "ServiceHostResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["runtime", "address"],
            members: &[
                (
                    "address",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("runtime", reference("Runtime")),
            ],
            closed: Some(&["address", "runtime"]),
            ..NONE
        },
    ),
    (
        "ServiceIdentity",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["issuer"],
            members: &[(
                "issuer",
                Shape {
                    kinds: Some(&[Kind::String]),
                    min_length: Some(1),
                    ..NONE
                },
            )],
            closed: Some(&["issuer"]),
            ..NONE
        },
    ),
    (
        "ServiceOutput",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["requestId", "instance", "stream", "line"],
            members: &[
                ("instance", reference("RunInstance")),
                ("line", of(&[Kind::String])),
                ("requestId", reference("RequestId")),
                ("stream", reference("OutputStream")),
            ],
            closed: Some(&["instance", "line", "requestId", "stream"]),
            ..NONE
        },
    ),
    (
        "ServiceRunParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "apiVersion",
                "target",
                "service",
                "instance",
                "environment",
                "mounts",
                "pathFirst",
                "ports",
            ],
            members: &[
                ("apiVersion", reference("ApiVersion")),
                (
                    "args",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("document", of(&[Kind::String])),
                (
                    "environment",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        values: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("instance", reference("RunInstance")),
                (
                    "mounts",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&Shape {
                            kinds: Some(&[Kind::String]),
                            pattern: Some(&[
                                Term::Step(Step {
                                    of: &[(47, 47)],
                                    min: 1,
                                    max: Some(1),
                                }),
                                Term::Step(Step {
                                    of: &[(0, 1114111)],
                                    min: 0,
                                    max: None,
                                }),
                            ]),
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                (
                    "pathFirst",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&Shape {
                            kinds: Some(&[Kind::String]),
                            pattern: Some(&[
                                Term::Step(Step {
                                    of: &[(47, 47)],
                                    min: 1,
                                    max: Some(1),
                                }),
                                Term::Step(Step {
                                    of: &[(0, 1114111)],
                                    min: 0,
                                    max: None,
                                }),
                            ]),
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                (
                    "ports",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&Shape {
                            kinds: Some(&[Kind::Integer]),
                            minimum: Some(1.0),
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                ("runtime", reference("Runtime")),
                ("service", reference("RunService")),
                ("target", reference("LocalTarget")),
            ],
            closed: Some(&[
                "apiVersion",
                "args",
                "document",
                "environment",
                "instance",
                "mounts",
                "pathFirst",
                "ports",
                "runtime",
                "service",
                "target",
            ]),
            ..NONE
        },
    ),
    (
        "ServiceRunResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["instance", "exitCode", "ranMs"],
            members: &[
                (
                    "exitCode",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("instance", reference("RunInstance")),
                (
                    "ranMs",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["exitCode", "instance", "ranMs"]),
            ..NONE
        },
    ),
    (
        "ServiceSignalParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion", "target", "instance", "signal"],
            members: &[
                ("apiVersion", reference("ApiVersion")),
                ("instance", reference("RunInstance")),
                ("runtime", reference("Runtime")),
                (
                    "signal",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("term"), Listed::Text("kill")]),
                        ..NONE
                    },
                ),
                ("target", reference("LocalTarget")),
            ],
            closed: Some(&["apiVersion", "instance", "runtime", "signal", "target"]),
            ..NONE
        },
    ),
    (
        "ServiceSignalResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["delivered"],
            members: &[("delivered", of(&[Kind::Boolean]))],
            closed: Some(&["delivered"]),
            ..NONE
        },
    ),
    (
        "ServiceStarted",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["requestId", "instance", "container", "address"],
            members: &[
                (
                    "address",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "container",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "documentPath",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        pattern: Some(&[
                            Term::Step(Step {
                                of: &[(47, 47)],
                                min: 1,
                                max: Some(1),
                            }),
                            Term::Step(Step {
                                of: &[(0, 1114111)],
                                min: 0,
                                max: None,
                            }),
                        ]),
                        ..NONE
                    },
                ),
                ("instance", reference("RunInstance")),
                ("requestId", reference("RequestId")),
            ],
            closed: Some(&[
                "address",
                "container",
                "documentPath",
                "instance",
                "requestId",
            ]),
            ..NONE
        },
    ),
    (
        "ServiceStatus",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["role", "group", "state", "healthy", "counted"],
            members: &[
                ("containerState", of(&[Kind::String])),
                ("counted", of(&[Kind::Boolean])),
                ("group", reference("ServiceGroup")),
                ("healthy", of(&[Kind::Boolean])),
                ("page", of(&[Kind::String])),
                ("probe", of(&[Kind::String])),
                ("product", of(&[Kind::String])),
                ("realm", of(&[Kind::String])),
                ("role", of(&[Kind::String])),
                ("runsOn", of(&[Kind::String])),
                (
                    "serves",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                (
                    "state",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("running"),
                            Listed::Text("stopped"),
                            Listed::Text("reachable"),
                            Listed::Text("unreachable"),
                            Listed::Text("absent"),
                            Listed::Text("not-configured"),
                        ]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "containerState",
                "counted",
                "group",
                "healthy",
                "page",
                "probe",
                "product",
                "realm",
                "role",
                "runsOn",
                "serves",
                "state",
            ]),
            ..NONE
        },
    ),
    (
        "Session",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["state"],
            members: &[
                ("email", of(&[Kind::String])),
                (
                    "state",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("valid"),
                            Listed::Text("expired"),
                            Listed::Text("unverified"),
                            Listed::Text("none"),
                        ]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["email", "state"]),
            ..NONE
        },
    ),
    (
        "SessionEndReason",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[Listed::Text("expired"), Listed::Text("refused")]),
            ..NONE
        },
    ),
    (
        "SessionEnded",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["reason"],
            members: &[("reason", reference("SessionEndReason"))],
            closed: Some(&["reason"]),
            ..NONE
        },
    ),
    (
        "SessionJoinedEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["participant", "connectionId"],
            members: &[
                ("connectionId", of(&[Kind::String])),
                ("participant", reference("UserId")),
            ],
            ..NONE
        },
    ),
    (
        "SessionLeftEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["participant", "connectionId"],
            members: &[
                ("connectionId", of(&[Kind::String])),
                ("participant", reference("UserId")),
            ],
            ..NONE
        },
    ),
    (
        "Setting",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["name", "default", "appliesTo", "values", "settable"],
            members: &[
                (
                    "appliesTo",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("machine"),
                            Listed::Text("knowledge-base"),
                        ]),
                        ..NONE
                    },
                ),
                ("changedBy", of(&[Kind::String])),
                ("default", of(&[Kind::Boolean])),
                ("name", of(&[Kind::String])),
                ("settable", of(&[Kind::Boolean])),
                (
                    "values",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("SettingLine")),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "appliesTo",
                "changedBy",
                "default",
                "name",
                "settable",
                "values",
            ]),
            ..NONE
        },
    ),
    (
        "SettingLine",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["value", "source"],
            members: &[
                ("source", of(&[Kind::String])),
                ("value", of(&[Kind::String])),
            ],
            closed: Some(&["source", "value"]),
            ..NONE
        },
    ),
    (
        "SettingsGetParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion", "name"],
            members: &[
                ("apiVersion", reference("ApiVersion")),
                ("default", of(&[Kind::Boolean])),
                (
                    "name",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "root",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["apiVersion", "default", "name", "root"]),
            ..NONE
        },
    ),
    (
        "SettingsHoverDelayChangedEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["hoverDelayMs"],
            members: &[("hoverDelayMs", of(&[Kind::Integer]))],
            ..NONE
        },
    ),
    (
        "SettingsListParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion"],
            members: &[
                ("apiVersion", reference("ApiVersion")),
                (
                    "root",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["apiVersion", "root"]),
            ..NONE
        },
    ),
    (
        "SettingsListResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["settings"],
            members: &[
                ("root", of(&[Kind::String])),
                (
                    "settings",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("Setting")),
                        ..NONE
                    },
                ),
                ("unresolved", of(&[Kind::String])),
            ],
            closed: Some(&["root", "settings", "unresolved"]),
            ..NONE
        },
    ),
    (
        "SettingsLocaleChangedEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["locale"],
            members: &[("locale", of(&[Kind::String]))],
            ..NONE
        },
    ),
    (
        "SettingsPathParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion", "document"],
            members: &[
                ("apiVersion", reference("ApiVersion")),
                (
                    "document",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("browser"),
                            Listed::Text("worker"),
                            Listed::Text("issuer"),
                            Listed::Text("vectors"),
                        ]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["apiVersion", "document"]),
            ..NONE
        },
    ),
    (
        "SettingsPathResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["path"],
            members: &[("path", of(&[Kind::String]))],
            closed: Some(&["path"]),
            ..NONE
        },
    ),
    (
        "SettingsSetParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion", "name", "value"],
            members: &[
                ("apiVersion", reference("ApiVersion")),
                ("default", of(&[Kind::Boolean])),
                (
                    "name",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "root",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "value",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["apiVersion", "default", "name", "root", "value"]),
            ..NONE
        },
    ),
    (
        "SettingsThemeChangedEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["theme"],
            members: &[(
                "theme",
                Shape {
                    kinds: Some(&[Kind::String]),
                    enumeration: Some(&[
                        Listed::Text("light"),
                        Listed::Text("dark"),
                        Listed::Text("system"),
                    ]),
                    ..NONE
                },
            )],
            ..NONE
        },
    ),
    (
        "SettingsUnsetParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion", "name"],
            members: &[
                ("apiVersion", reference("ApiVersion")),
                ("default", of(&[Kind::Boolean])),
                (
                    "name",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "root",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["apiVersion", "default", "name", "root"]),
            ..NONE
        },
    ),
    (
        "SignInOutcome",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["kb"],
            members: &[
                ("expected", reference("Expected")),
                ("kb", reference("KnowledgeBase")),
            ],
            closed: Some(&["expected", "kb"]),
            ..NONE
        },
    ),
    (
        "SignedIn",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["endpoint", "description", "session"],
            members: &[
                ("description", reference("KbDescription")),
                ("endpoint", reference("KbEndpoint")),
                ("expectedDid", of(&[Kind::String])),
                ("expectedName", of(&[Kind::String])),
                ("kbId", of(&[Kind::String])),
                ("session", reference("StoredSession")),
            ],
            closed: Some(&[
                "description",
                "endpoint",
                "expectedDid",
                "expectedName",
                "kbId",
                "session",
            ]),
            ..NONE
        },
    ),
    (
        "SmeltRebuildAnchorsCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            members: &[
                ("_userId", reference("UserId")),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "SmeltSettled",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "contentChecksum", "outcome"],
            members: &[
                ("contentChecksum", of(&[Kind::String])),
                (
                    "outcome",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("indexed"), Listed::Text("skipped")]),
                        ..NONE
                    },
                ),
                (
                    "reason",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("no-extractor"),
                            Listed::Text("empty"),
                            Listed::Text("no-text-layer"),
                            Listed::Text("encrypted"),
                            Listed::Text("corrupt"),
                            Listed::Text("too-large"),
                        ]),
                        ..NONE
                    },
                ),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "SmelterChunking",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["chunkSize", "overlap"],
            members: &[
                (
                    "chunkSize",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        ..NONE
                    },
                ),
                (
                    "overlap",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["chunkSize", "overlap"]),
            ..NONE
        },
    ),
    (
        "SmelterConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "kb",
                "gatewayUrl",
                "identity",
                "archivist",
                "embedding",
                "vectors",
                "chunking",
                "pdfsAtOnce",
                "cursorsPath",
                "port",
                "logLevel",
                "logFormat",
            ],
            members: &[
                ("archivist", reference("ServiceAddress")),
                ("chunking", reference("SmelterChunking")),
                ("cursorsPath", reference("CursorsPath")),
                ("embedding", reference("EmbeddingConfig")),
                (
                    "gatewayUrl",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("identity", reference("ServiceIdentity")),
                ("kb", reference("KbIdentity")),
                ("logFormat", reference("LogFormat")),
                ("logLevel", reference("LogLevel")),
                (
                    "pdfsAtOnce",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        ..NONE
                    },
                ),
                (
                    "port",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(65535.0),
                        ..NONE
                    },
                ),
                ("vectors", reference("VectorsConfig")),
            ],
            closed: Some(&[
                "archivist",
                "chunking",
                "cursorsPath",
                "embedding",
                "gatewayUrl",
                "identity",
                "kb",
                "logFormat",
                "logLevel",
                "pdfsAtOnce",
                "port",
                "vectors",
            ]),
            ..NONE
        },
    ),
    (
        "SmelterHealth",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "status",
                "kb",
                "stream",
                "following",
                "eventsProcessed",
                "reconcile",
                "index",
            ],
            members: &[
                (
                    "eventsProcessed",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("following", reference("FollowerFollowing")),
                (
                    "index",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["stamp", "madeAnew"],
                        members: &[
                            ("madeAnew", of(&[Kind::Boolean])),
                            (
                                "stamp",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    required: &["embedding", "chunking"],
                                    members: &[
                                        ("chunking", reference("SmelterChunking")),
                                        (
                                            "embedding",
                                            Shape {
                                                kinds: Some(&[Kind::Object]),
                                                required: &["type", "model"],
                                                members: &[
                                                    (
                                                        "model",
                                                        Shape {
                                                            kinds: Some(&[Kind::String]),
                                                            min_length: Some(1),
                                                            ..NONE
                                                        },
                                                    ),
                                                    (
                                                        "type",
                                                        Shape {
                                                            kinds: Some(&[Kind::String]),
                                                            min_length: Some(1),
                                                            ..NONE
                                                        },
                                                    ),
                                                ],
                                                closed: Some(&["model", "type"]),
                                                ..NONE
                                            },
                                        ),
                                    ],
                                    closed: Some(&["chunking", "embedding"]),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&["madeAnew", "stamp"]),
                        ..NONE
                    },
                ),
                ("kb", reference("KbDid")),
                (
                    "reconcile",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["phase"],
                        members: &[
                            ("error", of(&[Kind::String])),
                            (
                                "phase",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    enumeration: Some(&[
                                        Listed::Text("pending"),
                                        Listed::Text("running"),
                                        Listed::Text("done"),
                                        Listed::Text("failed"),
                                    ]),
                                    ..NONE
                                },
                            ),
                            ("summary", reference("SmelterReconcileSummary")),
                        ],
                        closed: Some(&["error", "phase", "summary"]),
                        ..NONE
                    },
                ),
                (
                    "status",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("ok")]),
                        ..NONE
                    },
                ),
                ("stream", reference("ConnectionState")),
            ],
            closed: Some(&[
                "eventsProcessed",
                "following",
                "index",
                "kb",
                "reconcile",
                "status",
                "stream",
            ]),
            ..NONE
        },
    ),
    (
        "SmelterReconcileSummary",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "resourcesEmbedded",
                "resourcesSkipped",
                "resourcesUnavailable",
                "resourcesFailed",
                "resourcesRestamped",
                "resourcesReanchored",
                "resourceVectorsDeleted",
                "annotationsEmbedded",
                "annotationsRestamped",
                "annotationVectorsDeleted",
                "resourcesEligible",
                "resourcesIndexed",
            ],
            members: &[
                (
                    "annotationVectorsDeleted",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "annotationsEmbedded",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "annotationsRestamped",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "resourceVectorsDeleted",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "resourcesEligible",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "resourcesEmbedded",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "resourcesFailed",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "resourcesIndexed",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "resourcesReanchored",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "resourcesRestamped",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "resourcesSkipped",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        values: Some(&Shape {
                            kinds: Some(&[Kind::Integer]),
                            minimum: Some(0.0),
                            ..NONE
                        }),
                        ..NONE
                    },
                ),
                (
                    "resourcesUnavailable",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "annotationVectorsDeleted",
                "annotationsEmbedded",
                "annotationsRestamped",
                "resourceVectorsDeleted",
                "resourcesEligible",
                "resourcesEmbedded",
                "resourcesFailed",
                "resourcesIndexed",
                "resourcesReanchored",
                "resourcesRestamped",
                "resourcesSkipped",
                "resourcesUnavailable",
            ]),
            ..NONE
        },
    ),
    (
        "SpecificResource",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["type", "source"],
            members: &[
                ("purpose", reference("BodyPurpose")),
                ("source", reference("ResourceId")),
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("SpecificResource")]),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "StackApiVersion",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[Listed::Text("xynolog.org/v1alpha1")]),
            ..NONE
        },
    ),
    (
        "StackKnowledgeBase",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion", "kind", "metadata", "spec"],
            members: &[
                ("apiVersion", reference("StackApiVersion")),
                (
                    "kind",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("KnowledgeBase")]),
                        ..NONE
                    },
                ),
                ("metadata", reference("Metadata")),
                (
                    "spec",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &[
                            "logLevel",
                            "gateway",
                            "dispatcher",
                            "archivist",
                            "messaging",
                            "issuer",
                        ],
                        members: &[
                            (
                                "archivist",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    required: &["image", "resources"],
                                    members: &[
                                        ("address", reference("HostPort")),
                                        ("image", reference("Image")),
                                        ("resources", reference("Resources")),
                                    ],
                                    closed: Some(&["address", "image", "resources"]),
                                    ..NONE
                                },
                            ),
                            (
                                "dispatcher",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    required: &["image", "resources"],
                                    members: &[
                                        ("image", reference("Image")),
                                        ("resources", reference("Resources")),
                                    ],
                                    closed: Some(&["image", "resources"]),
                                    ..NONE
                                },
                            ),
                            (
                                "gateway",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    required: &["image", "resources", "port", "publicURL"],
                                    members: &[
                                        ("image", reference("Image")),
                                        (
                                            "port",
                                            Shape {
                                                kinds: Some(&[Kind::Integer]),
                                                minimum: Some(1.0),
                                                maximum: Some(65535.0),
                                                ..NONE
                                            },
                                        ),
                                        (
                                            "publicURL",
                                            Shape {
                                                kinds: Some(&[Kind::String]),
                                                min_length: Some(1),
                                                ..NONE
                                            },
                                        ),
                                        ("resources", reference("Resources")),
                                    ],
                                    closed: Some(&["image", "port", "publicURL", "resources"]),
                                    ..NONE
                                },
                            ),
                            (
                                "issuer",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    required: &["subjectClaim"],
                                    members: &[
                                        (
                                            "external",
                                            Shape {
                                                kinds: Some(&[Kind::Object]),
                                                required: &["type", "url"],
                                                members: &[
                                                    (
                                                        "type",
                                                        Shape {
                                                            kinds: Some(&[Kind::String]),
                                                            min_length: Some(1),
                                                            ..NONE
                                                        },
                                                    ),
                                                    (
                                                        "url",
                                                        Shape {
                                                            kinds: Some(&[Kind::String]),
                                                            min_length: Some(1),
                                                            ..NONE
                                                        },
                                                    ),
                                                ],
                                                closed: Some(&["type", "url"]),
                                                ..NONE
                                            },
                                        ),
                                        (
                                            "shared",
                                            Shape {
                                                kinds: Some(&[Kind::Object]),
                                                required: &["accessTokenLifespan"],
                                                members: &[(
                                                    "accessTokenLifespan",
                                                    Shape {
                                                        kinds: Some(&[Kind::Integer]),
                                                        minimum: Some(1.0),
                                                        ..NONE
                                                    },
                                                )],
                                                closed: Some(&["accessTokenLifespan"]),
                                                ..NONE
                                            },
                                        ),
                                        (
                                            "subjectClaim",
                                            Shape {
                                                kinds: Some(&[Kind::String]),
                                                min_length: Some(1),
                                                ..NONE
                                            },
                                        ),
                                    ],
                                    closed: Some(&["external", "shared", "subjectClaim"]),
                                    one_of: &[
                                        Shape {
                                            kinds: Some(&[Kind::Object]),
                                            required: &["shared"],
                                            ..NONE
                                        },
                                        Shape {
                                            kinds: Some(&[Kind::Object]),
                                            required: &["external"],
                                            ..NONE
                                        },
                                    ],
                                    ..NONE
                                },
                            ),
                            ("logLevel", reference("LogLevel")),
                            (
                                "messaging",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    required: &["jobs", "signal"],
                                    members: &[
                                        (
                                            "external",
                                            Shape {
                                                kinds: Some(&[Kind::Object]),
                                                required: &["servers", "user", "password"],
                                                members: &[
                                                    ("password", reference("SecretRef")),
                                                    (
                                                        "servers",
                                                        Shape {
                                                            kinds: Some(&[Kind::String]),
                                                            min_length: Some(1),
                                                            ..NONE
                                                        },
                                                    ),
                                                    ("user", reference("SecretRef")),
                                                ],
                                                closed: Some(&["password", "servers", "user"]),
                                                ..NONE
                                            },
                                        ),
                                        ("image", reference("Image")),
                                        (
                                            "jobs",
                                            Shape {
                                                kinds: Some(&[Kind::Object]),
                                                required: &["type"],
                                                members: &[(
                                                    "type",
                                                    Shape {
                                                        kinds: Some(&[Kind::String]),
                                                        min_length: Some(1),
                                                        ..NONE
                                                    },
                                                )],
                                                closed: Some(&["type"]),
                                                ..NONE
                                            },
                                        ),
                                        ("resources", reference("Resources")),
                                        (
                                            "signal",
                                            Shape {
                                                kinds: Some(&[Kind::Object]),
                                                required: &["type"],
                                                members: &[(
                                                    "type",
                                                    Shape {
                                                        kinds: Some(&[Kind::String]),
                                                        min_length: Some(1),
                                                        ..NONE
                                                    },
                                                )],
                                                closed: Some(&["type"]),
                                                ..NONE
                                            },
                                        ),
                                    ],
                                    closed: Some(&[
                                        "external",
                                        "image",
                                        "jobs",
                                        "resources",
                                        "signal",
                                    ]),
                                    all_of: &[reference("Runner")],
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&[
                            "archivist",
                            "dispatcher",
                            "gateway",
                            "issuer",
                            "logLevel",
                            "messaging",
                        ]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["apiVersion", "kind", "metadata", "spec"]),
            ..NONE
        },
    ),
    (
        "StackStartParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion"],
            members: &[
                ("apiVersion", reference("ApiVersion")),
                (
                    "codespaceName",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "config",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("dryRun", of(&[Kind::Boolean])),
                ("group", reference("ServiceGroup")),
                (
                    "idleTimeout",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "machine",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("observe", of(&[Kind::Boolean])),
                (
                    "ollamaCache",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("host"), Listed::Text("volume")]),
                        ..NONE
                    },
                ),
                (
                    "retentionPeriod",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("runtime", reference("Runtime")),
                (
                    "service",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("target", reference("Target")),
            ],
            closed: Some(&[
                "apiVersion",
                "codespaceName",
                "config",
                "dryRun",
                "group",
                "idleTimeout",
                "machine",
                "observe",
                "ollamaCache",
                "retentionPeriod",
                "runtime",
                "service",
                "target",
            ]),
            ..NONE
        },
    ),
    (
        "StackStartResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["dryRun"],
            members: &[
                ("dryRun", of(&[Kind::Boolean])),
                ("knowledgeBase", reference("KnowledgeBaseStatus")),
                (
                    "shared",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("ServiceStatus")),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["dryRun", "knowledgeBase", "shared"]),
            ..NONE
        },
    ),
    (
        "StackStopParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion"],
            members: &[
                ("apiVersion", reference("ApiVersion")),
                ("delete", of(&[Kind::Boolean])),
                ("deleteConfirmed", of(&[Kind::Boolean])),
                ("dryRun", of(&[Kind::Boolean])),
                ("group", reference("ServiceGroup")),
                ("runtime", reference("Runtime")),
                (
                    "service",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("target", reference("Target")),
            ],
            closed: Some(&[
                "apiVersion",
                "delete",
                "deleteConfirmed",
                "dryRun",
                "group",
                "runtime",
                "service",
                "target",
            ]),
            ..NONE
        },
    ),
    (
        "StackStopResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["dryRun"],
            members: &[
                ("dryRun", of(&[Kind::Boolean])),
                (
                    "knowledgeBases",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("KnowledgeBaseStatus")),
                        ..NONE
                    },
                ),
                (
                    "shared",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("ServiceStatus")),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["dryRun", "knowledgeBases", "shared"]),
            ..NONE
        },
    ),
    (
        "StatusResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["status", "version", "features", "message"],
            members: &[
                ("authenticatedAs", of(&[Kind::String])),
                (
                    "features",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["semanticContent", "collaboration"],
                        members: &[
                            ("collaboration", of(&[Kind::String])),
                            ("semanticContent", of(&[Kind::String])),
                        ],
                        ..NONE
                    },
                ),
                ("message", of(&[Kind::String])),
                ("status", of(&[Kind::String])),
                ("version", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "StatusSnapshotParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion"],
            members: &[
                ("apiVersion", reference("ApiVersion")),
                ("runtime", reference("Runtime")),
                ("target", reference("Target")),
            ],
            closed: Some(&["apiVersion", "runtime", "target"]),
            ..NONE
        },
    ),
    (
        "StatusSnapshotResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["knowledgeBases", "shared"],
            members: &[
                (
                    "knowledgeBases",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("KnowledgeBaseStatus")),
                        ..NONE
                    },
                ),
                (
                    "shared",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("ServiceStatus")),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["knowledgeBases", "shared"]),
            ..NONE
        },
    ),
    (
        "StorageUriEntry",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["uri", "resourceId"],
            members: &[
                ("resourceId", reference("ResourceId")),
                ("uri", of(&[Kind::String])),
            ],
            closed: Some(&["resourceId", "uri"]),
            ..NONE
        },
    ),
    (
        "StoredEventResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "id",
                "type",
                "timestamp",
                "userId",
                "version",
                "payload",
                "metadata",
            ],
            members: &[
                ("id", of(&[Kind::String])),
                ("metadata", reference("EventMetadata")),
                ("payload", of(&[Kind::Object])),
                ("resourceId", reference("ResourceId")),
                ("timestamp", of(&[Kind::String])),
                ("type", of(&[Kind::String])),
                ("userId", reference("UserId")),
                ("version", of(&[Kind::Integer])),
            ],
            ..NONE
        },
    ),
    (
        "StoredSession",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["access", "refresh", "clientId", "tokenEndpoint"],
            members: &[
                ("access", of(&[Kind::String])),
                ("clientId", of(&[Kind::String])),
                ("personKey", of(&[Kind::String])),
                ("refresh", of(&[Kind::String])),
                ("revocationEndpoint", of(&[Kind::String])),
                ("tokenEndpoint", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "SupportedMediaType",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("text/plain"),
                Listed::Text("text/markdown"),
                Listed::Text("text/html"),
                Listed::Text("text/css"),
                Listed::Text("text/csv"),
                Listed::Text("text/xml"),
                Listed::Text("application/json"),
                Listed::Text("application/xml"),
                Listed::Text("application/yaml"),
                Listed::Text("application/x-yaml"),
                Listed::Text("application/pdf"),
                Listed::Text("application/msword"),
                Listed::Text(
                    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                ),
                Listed::Text("application/vnd.ms-excel"),
                Listed::Text("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"),
                Listed::Text("application/vnd.ms-powerpoint"),
                Listed::Text(
                    "application/vnd.openxmlformats-officedocument.presentationml.presentation",
                ),
                Listed::Text("application/zip"),
                Listed::Text("application/gzip"),
                Listed::Text("application/x-tar"),
                Listed::Text("application/x-7z-compressed"),
                Listed::Text("application/octet-stream"),
                Listed::Text("application/wasm"),
                Listed::Text("image/png"),
                Listed::Text("image/jpeg"),
                Listed::Text("image/gif"),
                Listed::Text("image/webp"),
                Listed::Text("image/svg+xml"),
                Listed::Text("image/bmp"),
                Listed::Text("image/tiff"),
                Listed::Text("image/x-icon"),
                Listed::Text("video/mp4"),
                Listed::Text("video/mpeg"),
                Listed::Text("video/webm"),
                Listed::Text("video/ogg"),
                Listed::Text("video/quicktime"),
                Listed::Text("video/x-msvideo"),
                Listed::Text("audio/mpeg"),
                Listed::Text("audio/wav"),
                Listed::Text("audio/ogg"),
                Listed::Text("audio/webm"),
                Listed::Text("audio/aac"),
                Listed::Text("audio/flac"),
                Listed::Text("text/javascript"),
                Listed::Text("application/javascript"),
                Listed::Text("text/x-typescript"),
                Listed::Text("application/typescript"),
                Listed::Text("text/x-python"),
                Listed::Text("text/x-java"),
                Listed::Text("text/x-c"),
                Listed::Text("text/x-c++"),
                Listed::Text("text/x-csharp"),
                Listed::Text("text/x-go"),
                Listed::Text("text/x-rust"),
                Listed::Text("text/x-ruby"),
                Listed::Text("text/x-php"),
                Listed::Text("text/x-swift"),
                Listed::Text("text/x-kotlin"),
                Listed::Text("text/x-shell"),
                Listed::Text("font/woff"),
                Listed::Text("font/woff2"),
                Listed::Text("font/ttf"),
                Listed::Text("font/otf"),
            ]),
            ..NONE
        },
    ),
    (
        "SvgSelector",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["type", "value"],
            members: &[
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("SvgSelector")]),
                        ..NONE
                    },
                ),
                ("value", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "System",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("macos"),
                Listed::Text("windows"),
                Listed::Text("other"),
            ]),
            ..NONE
        },
    ),
    (
        "TabCheck",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["verdict"],
                    members: &[(
                        "verdict",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            enumeration: Some(&[Listed::Text("gone")]),
                            all_of: &[reference("TabVerdict")],
                            ..NONE
                        },
                    )],
                    closed: Some(&["verdict"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["verdict", "name"],
                    members: &[
                        ("mediaType", of(&[Kind::String])),
                        ("name", of(&[Kind::String])),
                        (
                            "verdict",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                enumeration: Some(&[Listed::Text("ready")]),
                                all_of: &[reference("TabVerdict")],
                                ..NONE
                            },
                        ),
                    ],
                    closed: Some(&["mediaType", "name", "verdict"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["verdict"],
                    members: &[(
                        "verdict",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            enumeration: Some(&[Listed::Text("unknown")]),
                            all_of: &[reference("TabVerdict")],
                            ..NONE
                        },
                    )],
                    closed: Some(&["verdict"]),
                    ..NONE
                },
            ],
            discriminator: Some(Discriminator {
                property: "verdict",
                mapping: &[("gone", 0), ("ready", 1), ("unknown", 2)],
            }),
            ..NONE
        },
    ),
    (
        "TabVerdict",
        Shape {
            kinds: Some(&[Kind::String]),
            enumeration: Some(&[
                Listed::Text("gone"),
                Listed::Text("ready"),
                Listed::Text("unknown"),
            ]),
            ..NONE
        },
    ),
    (
        "TagCategory",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["name", "description", "examples"],
            members: &[
                ("description", of(&[Kind::String])),
                (
                    "examples",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("name", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "TagSchema",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["id", "name", "description", "domain", "tags"],
            members: &[
                ("description", of(&[Kind::String])),
                ("domain", of(&[Kind::String])),
                ("id", of(&[Kind::String])),
                ("name", of(&[Kind::String])),
                (
                    "tags",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&reference("TagCategory")),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "TagSchemaAddedPayload",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["schema"],
            members: &[("schema", reference("TagSchema"))],
            ..NONE
        },
    ),
    (
        "TagSchemasProjection",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["tagSchemas"],
            members: &[(
                "tagSchemas",
                Shape {
                    kinds: Some(&[Kind::Array]),
                    items: Some(&reference("TagSchema")),
                    ..NONE
                },
            )],
            closed: Some(&["tagSchemas"]),
            ..NONE
        },
    ),
    (
        "TaggingJobParams",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["motivation", "schemaId", "categories"],
            members: &[
                (
                    "categories",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        min_items: Some(1),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("language", of(&[Kind::String])),
                (
                    "motivation",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("tagging")]),
                        ..NONE
                    },
                ),
                (
                    "schemaId",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("sourceLanguage", of(&[Kind::String])),
            ],
            closed: Some(&[
                "categories",
                "language",
                "motivation",
                "schemaId",
                "sourceLanguage",
            ]),
            ..NONE
        },
    ),
    (
        "Target",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["kind"],
            members: &[
                ("kind", reference("KbPlacement")),
                (
                    "repo",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        pattern: Some(&[
                            Term::Step(Step {
                                of: &[
                                    (0, 8),
                                    (14, 31),
                                    (33, 46),
                                    (48, 159),
                                    (161, 5759),
                                    (5761, 8191),
                                    (8203, 8231),
                                    (8234, 8238),
                                    (8240, 8286),
                                    (8288, 12287),
                                    (12289, 65278),
                                    (65280, 1114111),
                                ],
                                min: 1,
                                max: None,
                            }),
                            Term::Step(Step {
                                of: &[(47, 47)],
                                min: 1,
                                max: Some(1),
                            }),
                            Term::Step(Step {
                                of: &[
                                    (0, 8),
                                    (14, 31),
                                    (33, 46),
                                    (48, 159),
                                    (161, 5759),
                                    (5761, 8191),
                                    (8203, 8231),
                                    (8234, 8238),
                                    (8240, 8286),
                                    (8288, 12287),
                                    (12289, 65278),
                                    (65280, 1114111),
                                ],
                                min: 1,
                                max: None,
                            }),
                        ]),
                        ..NONE
                    },
                ),
                (
                    "root",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["kind", "repo", "root"]),
            one_of: &[
                Shape {
                    kinds: Some(&[Kind::Object]),
                    members: &[(
                        "kind",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            enumeration: Some(&[Listed::Text("local")]),
                            ..NONE
                        },
                    )],
                    not_all: &[&["repo"]],
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["repo"],
                    members: &[(
                        "kind",
                        Shape {
                            kinds: Some(&[Kind::String]),
                            enumeration: Some(&[Listed::Text("codespace")]),
                            ..NONE
                        },
                    )],
                    not_all: &[&["root"]],
                    ..NONE
                },
            ],
            ..NONE
        },
    ),
    (
        "TextPositionSelector",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["type", "start", "end"],
            members: &[
                (
                    "end",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "start",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("TextPositionSelector")]),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "TextQuoteSelector",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["type", "exact"],
            members: &[
                ("exact", of(&[Kind::String])),
                ("prefix", of(&[Kind::String])),
                ("suffix", of(&[Kind::String])),
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("TextQuoteSelector")]),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "TextSpan",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["start", "end", "exact"],
            members: &[
                (
                    "end",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("exact", of(&[Kind::String])),
                ("prefix", of(&[Kind::String])),
                (
                    "start",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("suffix", of(&[Kind::String])),
            ],
            closed: Some(&["end", "exact", "prefix", "start", "suffix"]),
            ..NONE
        },
    ),
    (
        "TextualBody",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["type", "value"],
            members: &[
                ("format", of(&[Kind::String])),
                ("language", of(&[Kind::String])),
                ("purpose", reference("BodyPurpose")),
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("TextualBody")]),
                        ..NONE
                    },
                ),
                ("value", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "TraceCarrier",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["traceparent"],
            members: &[
                (
                    "traceparent",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "tracestate",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["traceparent", "tracestate"]),
            ..NONE
        },
    ),
    (
        "UnitCursor",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["next", "size", "found", "emitted", "errors"],
            members: &[
                (
                    "emitted",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "errors",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "found",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "next",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                (
                    "size",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        ..NONE
                    },
                ),
            ],
            ..NONE
        },
    ),
    (
        "UpdateAnnotationBodyRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "operations"],
            members: &[
                (
                    "operations",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        min_items: Some(1),
                        items: Some(&reference("BodyOperation")),
                        ..NONE
                    },
                ),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "UploadProgress",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["phase", "totalBytes"],
                    members: &[
                        (
                            "phase",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                enumeration: Some(&[Listed::Text("started")]),
                                ..NONE
                            },
                        ),
                        (
                            "totalBytes",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(0.0),
                                ..NONE
                            },
                        ),
                    ],
                    closed: Some(&["phase", "totalBytes"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["phase", "bytesUploaded", "totalBytes"],
                    members: &[
                        (
                            "bytesUploaded",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(0.0),
                                ..NONE
                            },
                        ),
                        (
                            "phase",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                enumeration: Some(&[Listed::Text("progress")]),
                                ..NONE
                            },
                        ),
                        (
                            "totalBytes",
                            Shape {
                                kinds: Some(&[Kind::Integer]),
                                minimum: Some(0.0),
                                ..NONE
                            },
                        ),
                    ],
                    closed: Some(&["bytesUploaded", "phase", "totalBytes"]),
                    ..NONE
                },
                Shape {
                    kinds: Some(&[Kind::Object]),
                    required: &["phase", "resourceId"],
                    members: &[
                        (
                            "phase",
                            Shape {
                                kinds: Some(&[Kind::String]),
                                enumeration: Some(&[Listed::Text("finished")]),
                                ..NONE
                            },
                        ),
                        ("resourceId", reference("ResourceId")),
                    ],
                    closed: Some(&["phase", "resourceId"]),
                    ..NONE
                },
            ],
            discriminator: Some(Discriminator {
                property: "phase",
                mapping: &[("started", 0), ("progress", 1), ("finished", 2)],
            }),
            ..NONE
        },
    ),
    (
        "UserAction",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "requestId",
                "verificationUri",
                "userCode",
                "expiresInSeconds",
            ],
            members: &[
                (
                    "expiresInSeconds",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("requestId", reference("RequestId")),
                ("userCode", of(&[Kind::String])),
                ("verificationUri", of(&[Kind::String])),
                ("verificationUriComplete", of(&[Kind::String])),
            ],
            closed: Some(&[
                "expiresInSeconds",
                "requestId",
                "userCode",
                "verificationUri",
                "verificationUriComplete",
            ]),
            ..NONE
        },
    ),
    (
        "UserId",
        Shape {
            kinds: Some(&[Kind::String]),
            pattern: Some(&[
                Term::Step(Step {
                    of: &[(100, 100)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(105, 105)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(100, 100)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[(58, 58)],
                    min: 1,
                    max: Some(1),
                }),
                Term::Step(Step {
                    of: &[
                        (0, 8),
                        (14, 31),
                        (33, 159),
                        (161, 5759),
                        (5761, 8191),
                        (8203, 8231),
                        (8234, 8238),
                        (8240, 8286),
                        (8288, 12287),
                        (12289, 65278),
                        (65280, 1114111),
                    ],
                    min: 1,
                    max: None,
                }),
            ]),
            ..NONE
        },
    ),
    (
        "UserResponse",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["did", "email", "name", "image", "domain"],
            members: &[
                ("did", reference("UserId")),
                ("domain", of(&[Kind::String])),
                ("email", of(&[Kind::String, Kind::Null])),
                ("image", of(&[Kind::String, Kind::Null])),
                ("name", of(&[Kind::String, Kind::Null])),
            ],
            ..NONE
        },
    ),
    (
        "VectorStore",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion", "kind", "metadata", "spec"],
            members: &[
                ("apiVersion", reference("StackApiVersion")),
                (
                    "kind",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("VectorStore")]),
                        ..NONE
                    },
                ),
                ("metadata", reference("Metadata")),
                (
                    "spec",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["type", "image", "resources", "port"],
                        members: &[
                            ("image", reference("Image")),
                            (
                                "port",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(1.0),
                                    maximum: Some(65535.0),
                                    ..NONE
                                },
                            ),
                            ("resources", reference("Resources")),
                            (
                                "type",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    min_length: Some(1),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&["image", "port", "resources", "type"]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["apiVersion", "kind", "metadata", "spec"]),
            ..NONE
        },
    ),
    (
        "VectorsConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[
                reference("QdrantVectorsConfig"),
                reference("MemoryVectorsConfig"),
            ],
            discriminator: Some(Discriminator {
                property: "type",
                mapping: &[("qdrant", 0), ("memory", 1)],
            }),
            ..NONE
        },
    ),
    (
        "VoyageEmbeddingConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["type", "model", "endpoint", "apiKeyEnv"],
            members: &[
                (
                    "apiKeyEnv",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "endpoint",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "model",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "type",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("voyage")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["apiKeyEnv", "endpoint", "model", "type"]),
            ..NONE
        },
    ),
    (
        "WeaveApplied",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "sequenceNumber"],
            members: &[
                ("resourceId", reference("ResourceId")),
                ("sequenceNumber", of(&[Kind::Integer])),
            ],
            ..NONE
        },
    ),
    (
        "WeaveRebuildCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            members: &[
                ("_userId", reference("UserId")),
                ("resourceId", reference("ResourceId")),
            ],
            ..NONE
        },
    ),
    (
        "WeaverConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "kb",
                "gatewayUrl",
                "identity",
                "archivist",
                "graph",
                "cursorsPath",
                "port",
                "logLevel",
                "logFormat",
            ],
            members: &[
                ("archivist", reference("ServiceAddress")),
                ("cursorsPath", reference("CursorsPath")),
                (
                    "gatewayUrl",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("graph", reference("GraphConfig")),
                ("identity", reference("ServiceIdentity")),
                ("kb", reference("KbIdentity")),
                ("logFormat", reference("LogFormat")),
                ("logLevel", reference("LogLevel")),
                (
                    "port",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(65535.0),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "archivist",
                "cursorsPath",
                "gatewayUrl",
                "graph",
                "identity",
                "kb",
                "logFormat",
                "logLevel",
                "port",
            ]),
            ..NONE
        },
    ),
    (
        "WeaverHealth",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["status", "kb", "following", "reconcile"],
            members: &[
                ("following", reference("FollowerFollowing")),
                ("kb", reference("KbDid")),
                (
                    "reconcile",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["phase"],
                        members: &[
                            ("error", of(&[Kind::String])),
                            (
                                "phase",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    enumeration: Some(&[
                                        Listed::Text("pending"),
                                        Listed::Text("running"),
                                        Listed::Text("done"),
                                        Listed::Text("failed"),
                                    ]),
                                    ..NONE
                                },
                            ),
                            (
                                "summary",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    required: &[
                                        "resourcesChecked",
                                        "divergent",
                                        "healed",
                                        "healFailures",
                                        "orphaned",
                                    ],
                                    members: &[
                                        (
                                            "divergent",
                                            Shape {
                                                kinds: Some(&[Kind::Integer]),
                                                minimum: Some(0.0),
                                                ..NONE
                                            },
                                        ),
                                        (
                                            "healFailures",
                                            Shape {
                                                kinds: Some(&[Kind::Integer]),
                                                minimum: Some(0.0),
                                                ..NONE
                                            },
                                        ),
                                        (
                                            "healed",
                                            Shape {
                                                kinds: Some(&[Kind::Integer]),
                                                minimum: Some(0.0),
                                                ..NONE
                                            },
                                        ),
                                        (
                                            "orphaned",
                                            Shape {
                                                kinds: Some(&[Kind::Integer]),
                                                minimum: Some(0.0),
                                                ..NONE
                                            },
                                        ),
                                        (
                                            "resourcesChecked",
                                            Shape {
                                                kinds: Some(&[Kind::Integer]),
                                                minimum: Some(0.0),
                                                ..NONE
                                            },
                                        ),
                                    ],
                                    closed: Some(&[
                                        "divergent",
                                        "healFailures",
                                        "healed",
                                        "orphaned",
                                        "resourcesChecked",
                                    ]),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&["error", "phase", "summary"]),
                        ..NONE
                    },
                ),
                (
                    "status",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("ok")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["following", "kb", "reconcile", "status"]),
            ..NONE
        },
    ),
    (
        "WorkerActiveJob",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobId", "type", "since"],
            members: &[
                ("jobId", reference("JobId")),
                ("since", of(&[Kind::String])),
                ("type", reference("JobType")),
            ],
            closed: Some(&["jobId", "since", "type"]),
            ..NONE
        },
    ),
    (
        "WorkerConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "knowledgeBases",
                "modelCatalogue",
                "port",
                "logLevel",
                "logFormat",
            ],
            members: &[
                (
                    "knowledgeBases",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        min_items: Some(1),
                        items: Some(&reference("WorkerKnowledgeBaseConfig")),
                        ..NONE
                    },
                ),
                ("logFormat", reference("LogFormat")),
                ("logLevel", reference("LogLevel")),
                (
                    "modelCatalogue",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "port",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(1.0),
                        maximum: Some(65535.0),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&[
                "knowledgeBases",
                "logFormat",
                "logLevel",
                "modelCatalogue",
                "port",
            ]),
            ..NONE
        },
    ),
    (
        "WorkerEngineConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["engine", "jobs", "baseUrl"],
            members: &[
                (
                    "apiKeyEnv",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "baseUrl",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                ("engine", reference("Engine")),
                (
                    "jobs",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        min_items: Some(1),
                        items: Some(&reference("JobFilter")),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["apiKeyEnv", "baseUrl", "engine", "jobs"]),
            ..NONE
        },
    ),
    (
        "WorkerEngineHealth",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "engine",
                "jobs",
                "lastQueuedEventAt",
                "lastClaimAt",
                "lastFinishedAt",
                "lastActivityAt",
                "activeJob",
                "jobsCompleted",
            ],
            members: &[
                (
                    "activeJob",
                    Shape {
                        kinds: Some(&[Kind::Object, Kind::Null]),
                        one_of: &[of(&[Kind::Null]), reference("WorkerActiveJob")],
                        ..NONE
                    },
                ),
                ("engine", reference("Engine")),
                (
                    "jobs",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        min_items: Some(1),
                        items: Some(&reference("JobFilter")),
                        ..NONE
                    },
                ),
                (
                    "jobsCompleted",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("lastActivityAt", of(&[Kind::String, Kind::Null])),
                ("lastClaimAt", of(&[Kind::String, Kind::Null])),
                ("lastFinishedAt", of(&[Kind::String, Kind::Null])),
                ("lastQueuedEventAt", of(&[Kind::String, Kind::Null])),
            ],
            closed: Some(&[
                "activeJob",
                "engine",
                "jobs",
                "jobsCompleted",
                "lastActivityAt",
                "lastClaimAt",
                "lastFinishedAt",
                "lastQueuedEventAt",
            ]),
            ..NONE
        },
    ),
    (
        "WorkerHealth",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["status", "knowledgeBases"],
            members: &[
                (
                    "knowledgeBases",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        min_items: Some(1),
                        items: Some(&reference("WorkerKnowledgeBaseHealth")),
                        ..NONE
                    },
                ),
                (
                    "status",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("ok")]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["knowledgeBases", "status"]),
            ..NONE
        },
    ),
    (
        "WorkerKnowledgeBaseConfig",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["domain", "gatewayUrl", "identity", "engines"],
            members: &[
                (
                    "domain",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "engines",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        min_items: Some(1),
                        items: Some(&reference("WorkerEngineConfig")),
                        ..NONE
                    },
                ),
                (
                    "gatewayUrl",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "identity",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["issuer", "clientId"],
                        members: &[
                            (
                                "clientId",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    min_length: Some(1),
                                    ..NONE
                                },
                            ),
                            (
                                "issuer",
                                Shape {
                                    kinds: Some(&[Kind::String]),
                                    min_length: Some(1),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&["clientId", "issuer"]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["domain", "engines", "gatewayUrl", "identity"]),
            ..NONE
        },
    ),
    (
        "WorkerKnowledgeBaseHealth",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["domain", "state"],
            members: &[
                (
                    "did",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "domain",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        min_length: Some(1),
                        ..NONE
                    },
                ),
                (
                    "engines",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        min_items: Some(1),
                        items: Some(&reference("WorkerEngineHealth")),
                        ..NONE
                    },
                ),
                (
                    "state",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[
                            Listed::Text("starting"),
                            Listed::Text("working"),
                            Listed::Text("refused"),
                        ]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["did", "domain", "engines", "state"]),
            ..NONE
        },
    ),
    (
        "WorkerPool",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["apiVersion", "kind", "metadata", "spec"],
            members: &[
                ("apiVersion", reference("StackApiVersion")),
                (
                    "kind",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("WorkerPool")]),
                        ..NONE
                    },
                ),
                ("metadata", reference("Metadata")),
                (
                    "spec",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["logLevel", "worker"],
                        members: &[
                            ("logLevel", reference("LogLevel")),
                            (
                                "worker",
                                Shape {
                                    kinds: Some(&[Kind::Object]),
                                    required: &["image", "resources"],
                                    members: &[
                                        ("image", reference("Image")),
                                        ("resources", reference("Resources")),
                                    ],
                                    closed: Some(&["image", "resources"]),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&["logLevel", "worker"]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["apiVersion", "kind", "metadata", "spec"]),
            ..NONE
        },
    ),
    (
        "WorkerVitals",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "lastQueuedEventAt",
                "lastClaimAt",
                "lastFinishedAt",
                "lastActivityAt",
                "activeJob",
                "jobsCompleted",
            ],
            members: &[
                (
                    "activeJob",
                    Shape {
                        kinds: Some(&[Kind::Object, Kind::Null]),
                        one_of: &[of(&[Kind::Null]), reference("WorkerActiveJob")],
                        ..NONE
                    },
                ),
                (
                    "jobsCompleted",
                    Shape {
                        kinds: Some(&[Kind::Integer]),
                        minimum: Some(0.0),
                        ..NONE
                    },
                ),
                ("lastActivityAt", of(&[Kind::String, Kind::Null])),
                ("lastClaimAt", of(&[Kind::String, Kind::Null])),
                ("lastFinishedAt", of(&[Kind::String, Kind::Null])),
                ("lastQueuedEventAt", of(&[Kind::String, Kind::Null])),
            ],
            closed: Some(&[
                "activeJob",
                "jobsCompleted",
                "lastActivityAt",
                "lastClaimAt",
                "lastFinishedAt",
                "lastQueuedEventAt",
            ]),
            ..NONE
        },
    ),
    (
        "WorkloadStatus",
        Shape {
            kinds: Some(&[Kind::Object]),
            members: &[
                (
                    "ledger",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["claims", "capacity"],
                        members: &[
                            (
                                "capacity",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(1.0),
                                    ..NONE
                                },
                            ),
                            (
                                "claims",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(0.0),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&["capacity", "claims"]),
                        ..NONE
                    },
                ),
                (
                    "queue",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        required: &["pending", "running"],
                        members: &[
                            (
                                "completed",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(0.0),
                                    ..NONE
                                },
                            ),
                            (
                                "failed",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(0.0),
                                    ..NONE
                                },
                            ),
                            (
                                "pending",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(0.0),
                                    ..NONE
                                },
                            ),
                            (
                                "running",
                                Shape {
                                    kinds: Some(&[Kind::Integer]),
                                    minimum: Some(0.0),
                                    ..NONE
                                },
                            ),
                        ],
                        closed: Some(&["completed", "failed", "pending", "running"]),
                        ..NONE
                    },
                ),
            ],
            closed: Some(&["ledger", "queue"]),
            ..NONE
        },
    ),
    (
        "YieldCloneCreateCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "token",
                "name",
                "storageUri",
                "contentChecksum",
                "byteSize",
                "format",
            ],
            members: &[
                ("_userId", reference("UserId")),
                ("archiveOriginal", of(&[Kind::Boolean])),
                ("byteSize", of(&[Kind::Integer])),
                ("contentChecksum", of(&[Kind::String])),
                ("format", reference("ContentFormat")),
                ("name", of(&[Kind::String])),
                ("storageUri", of(&[Kind::String])),
                ("token", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "YieldCloneCreated",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("YieldedResource"))],
            ..NONE
        },
    ),
    (
        "YieldClonePersistCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "name",
                "storageUri",
                "contentChecksum",
                "byteSize",
                "format",
                "parentResourceId",
            ],
            members: &[
                ("_userId", reference("UserId")),
                ("byteSize", of(&[Kind::Integer])),
                ("contentChecksum", of(&[Kind::String])),
                (
                    "entityTypes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("format", reference("ContentFormat")),
                ("language", of(&[Kind::String])),
                ("name", of(&[Kind::String])),
                ("parentResourceId", reference("ResourceId")),
                ("storageUri", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "YieldClonePersistOk",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("YieldedResource"))],
            ..NONE
        },
    ),
    (
        "YieldCloneResourceRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["token"],
            members: &[("token", of(&[Kind::String]))],
            ..NONE
        },
    ),
    (
        "YieldCloneTokenRequest",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId"],
            members: &[("resourceId", reference("ResourceId"))],
            ..NONE
        },
    ),
    (
        "YieldCreateCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &[
                "name",
                "storageUri",
                "contentChecksum",
                "byteSize",
                "format",
            ],
            members: &[
                (
                    "_roles",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("_userId", reference("UserId")),
                ("byteSize", of(&[Kind::Integer])),
                ("contentChecksum", of(&[Kind::String])),
                (
                    "entityTypes",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("format", reference("ContentFormat")),
                (
                    "generatedFrom",
                    Shape {
                        kinds: Some(&[Kind::Object]),
                        members: &[
                            ("annotationId", reference("AnnotationId")),
                            ("resourceId", reference("ResourceId")),
                        ],
                        ..NONE
                    },
                ),
                ("generationPrompt", of(&[Kind::String])),
                ("generator", reference("OneOrMoreAgents")),
                ("isDraft", of(&[Kind::Boolean])),
                ("jobId", reference("JobId")),
                ("language", of(&[Kind::String])),
                ("name", of(&[Kind::String])),
                ("storageUri", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "YieldCreateOk",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("YieldedResource"))],
            ..NONE
        },
    ),
    (
        "YieldJobCompleteCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "jobId", "jobType"],
            members: &[
                ("_userId", reference("UserId")),
                ("annotationId", reference("AnnotationId")),
                ("attempt", of(&[Kind::Integer])),
                ("durability", reference("DurabilityEvidence")),
                ("jobId", reference("JobId")),
                (
                    "jobType",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("yield")]),
                        ..NONE
                    },
                ),
                ("resourceId", reference("ResourceId")),
                ("result", reference("YieldJobResult")),
            ],
            ..NONE
        },
    ),
    (
        "YieldJobCreateCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobType", "params"],
            members: &[
                (
                    "_roles",
                    Shape {
                        kinds: Some(&[Kind::Array]),
                        items: Some(&of(&[Kind::String])),
                        ..NONE
                    },
                ),
                ("_userId", reference("UserId")),
                (
                    "jobType",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("yield")]),
                        ..NONE
                    },
                ),
                ("params", reference("GenerationJobParams")),
            ],
            closed: Some(&["_roles", "_userId", "jobType", "params"]),
            ..NONE
        },
    ),
    (
        "YieldJobDone",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "resourceName", "truncated"],
            members: &[
                ("resourceId", reference("ResourceId")),
                ("resourceName", of(&[Kind::String])),
                ("truncated", of(&[Kind::Boolean])),
            ],
            closed: Some(&["resourceId", "resourceName", "truncated"]),
            ..NONE
        },
    ),
    (
        "YieldJobFilter",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobType"],
            members: &[(
                "jobType",
                Shape {
                    kinds: Some(&[Kind::String]),
                    enumeration: Some(&[Listed::Text("yield")]),
                    ..NONE
                },
            )],
            closed: Some(&["jobType"]),
            ..NONE
        },
    ),
    (
        "YieldJobQueuedEvent",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["jobId", "jobType", "resourceId", "userId", "params"],
            members: &[
                ("jobId", reference("JobId")),
                (
                    "jobType",
                    Shape {
                        kinds: Some(&[Kind::String]),
                        enumeration: Some(&[Listed::Text("yield")]),
                        ..NONE
                    },
                ),
                ("params", reference("GenerationJobRequest")),
                ("resourceId", reference("ResourceId")),
                ("userId", reference("UserId")),
            ],
            ..NONE
        },
    ),
    (
        "YieldJobResult",
        Shape {
            kinds: Some(&[Kind::Object]),
            one_of: &[reference("YieldJobDone"), reference("JobDeclined")],
            ..NONE
        },
    ),
    (
        "YieldUpdateCommand",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId", "storageUri", "contentChecksum", "byteSize"],
            members: &[
                ("_userId", reference("UserId")),
                ("byteSize", of(&[Kind::Integer])),
                ("contentChecksum", of(&[Kind::String])),
                ("resourceId", reference("ResourceId")),
                ("storageUri", of(&[Kind::String])),
            ],
            ..NONE
        },
    ),
    (
        "YieldUpdateOk",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["response"],
            members: &[("response", reference("YieldedResource"))],
            ..NONE
        },
    ),
    (
        "YieldedResource",
        Shape {
            kinds: Some(&[Kind::Object]),
            required: &["resourceId"],
            members: &[("resourceId", reference("ResourceId"))],
            ..NONE
        },
    ),
];
