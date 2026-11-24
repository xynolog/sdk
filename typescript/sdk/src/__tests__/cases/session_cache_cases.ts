// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/session/cache-cases.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export type Json = null | boolean | number | string | Json[] | { [key: string]: Json };

export type KeptItem = {
  key: string;
  value: Json;
};

export type Resource = {
  name: string;
  query: 'resource';
  stored?: Json;
  storedText?: string;
  kept: KeptItem[];
};

export type AnnotationsKeptItem = {
  key: string;
  value: Json;
};

export type Annotations = {
  name: string;
  query: 'annotations';
  stored?: Json;
  storedText?: string;
  kept: AnnotationsKeptItem[];
};

export type AnnotationKeptItem = {
  key: string;
  value: Json;
};

export type Annotation = {
  name: string;
  query: 'annotation';
  stored?: Json;
  storedText?: string;
  kept: AnnotationKeptItem[];
};

export type EntityTypesKeptItem = {
  key: string;
  value: string[];
};

export type EntityTypes = {
  name: string;
  query: 'entityTypes';
  stored?: Json;
  storedText?: string;
  kept: EntityTypesKeptItem[];
};

export type TagSchemasKeptItem = {
  key: string;
  value: Json[];
};

export type TagSchemas = {
  name: string;
  query: 'tagSchemas';
  stored?: Json;
  storedText?: string;
  kept: TagSchemasKeptItem[];
};

export type CasesItem =
  | Resource
  | Annotations
  | Annotation
  | EntityTypes
  | TagSchemas;

export type HeldItem = {
  key: string;
  value: Json;
};

export type EntriesItem = {
  key: string;
  value: Json;
};

export type Written = {
  version: number;
  entries: EntriesItem[];
};

export type WritesItemResource = {
  name: string;
  query: 'resource';
  held: HeldItem[];
  written: Written;
};

export type WritesItemAnnotationsHeldItem = {
  key: string;
  value: Json;
};

export type WrittenEntriesItem = {
  key: string;
  value: Json;
};

export type WritesItemAnnotationsWritten = {
  version: number;
  entries: WrittenEntriesItem[];
};

export type WritesItemAnnotations = {
  name: string;
  query: 'annotations';
  held: WritesItemAnnotationsHeldItem[];
  written: WritesItemAnnotationsWritten;
};

export type WritesItemAnnotationHeldItem = {
  key: string;
  value: Json;
};

export type WritesItemAnnotationWrittenEntriesItem = {
  key: string;
  value: Json;
};

export type WritesItemAnnotationWritten = {
  version: number;
  entries: WritesItemAnnotationWrittenEntriesItem[];
};

export type WritesItemAnnotation = {
  name: string;
  query: 'annotation';
  held: WritesItemAnnotationHeldItem[];
  written: WritesItemAnnotationWritten;
};

export type WritesItemEntityTypesHeldItem = {
  key: string;
  value: string[];
};

export type WritesItemEntityTypesWrittenEntriesItem = {
  key: string;
  value: string[];
};

export type WritesItemEntityTypesWritten = {
  version: number;
  entries: WritesItemEntityTypesWrittenEntriesItem[];
};

export type WritesItemEntityTypes = {
  name: string;
  query: 'entityTypes';
  held: WritesItemEntityTypesHeldItem[];
  written: WritesItemEntityTypesWritten;
};

export type WritesItemTagSchemasHeldItem = {
  key: string;
  value: Json[];
};

export type WritesItemTagSchemasWrittenEntriesItem = {
  key: string;
  value: Json[];
};

export type WritesItemTagSchemasWritten = {
  version: number;
  entries: WritesItemTagSchemasWrittenEntriesItem[];
};

export type WritesItemTagSchemas = {
  name: string;
  query: 'tagSchemas';
  held: WritesItemTagSchemasHeldItem[];
  written: WritesItemTagSchemasWritten;
};

export type WritesItem =
  | WritesItemResource
  | WritesItemAnnotations
  | WritesItemAnnotation
  | WritesItemEntityTypes
  | WritesItemTagSchemas;

export type RefusedWritesItemResourceHeldItem = {
  key: string;
  value: Json;
};

export type RefusedWritesItemResourceWrittenEntriesItem = {
  key: string;
  value: Json;
};

export type RefusedWritesItemResourceWritten = {
  version: number;
  entries: RefusedWritesItemResourceWrittenEntriesItem[];
};

export type RefusedWritesItemResource = {
  name: string;
  query: 'resource';
  held: RefusedWritesItemResourceHeldItem[];
  written: RefusedWritesItemResourceWritten;
};

export type RefusedWritesItemAnnotationsHeldItem = {
  key: string;
  value: Json;
};

export type RefusedWritesItemAnnotationsWrittenEntriesItem = {
  key: string;
  value: Json;
};

export type RefusedWritesItemAnnotationsWritten = {
  version: number;
  entries: RefusedWritesItemAnnotationsWrittenEntriesItem[];
};

export type RefusedWritesItemAnnotations = {
  name: string;
  query: 'annotations';
  held: RefusedWritesItemAnnotationsHeldItem[];
  written: RefusedWritesItemAnnotationsWritten;
};

export type RefusedWritesItemAnnotationHeldItem = {
  key: string;
  value: Json;
};

export type RefusedWritesItemAnnotationWrittenEntriesItem = {
  key: string;
  value: Json;
};

export type RefusedWritesItemAnnotationWritten = {
  version: number;
  entries: RefusedWritesItemAnnotationWrittenEntriesItem[];
};

export type RefusedWritesItemAnnotation = {
  name: string;
  query: 'annotation';
  held: RefusedWritesItemAnnotationHeldItem[];
  written: RefusedWritesItemAnnotationWritten;
};

export type RefusedWritesItemEntityTypesHeldItem = {
  key: string;
  value: string[];
};

export type RefusedWritesItemEntityTypesWrittenEntriesItem = {
  key: string;
  value: string[];
};

export type RefusedWritesItemEntityTypesWritten = {
  version: number;
  entries: RefusedWritesItemEntityTypesWrittenEntriesItem[];
};

export type RefusedWritesItemEntityTypes = {
  name: string;
  query: 'entityTypes';
  held: RefusedWritesItemEntityTypesHeldItem[];
  written: RefusedWritesItemEntityTypesWritten;
};

export type RefusedWritesItemTagSchemasHeldItem = {
  key: string;
  value: Json[];
};

export type RefusedWritesItemTagSchemasWrittenEntriesItem = {
  key: string;
  value: Json[];
};

export type RefusedWritesItemTagSchemasWritten = {
  version: number;
  entries: RefusedWritesItemTagSchemasWrittenEntriesItem[];
};

export type RefusedWritesItemTagSchemas = {
  name: string;
  query: 'tagSchemas';
  held: RefusedWritesItemTagSchemasHeldItem[];
  written: RefusedWritesItemTagSchemasWritten;
};

export type RefusedWritesItem =
  | RefusedWritesItemResource
  | RefusedWritesItemAnnotations
  | RefusedWritesItemAnnotation
  | RefusedWritesItemEntityTypes
  | RefusedWritesItemTagSchemas;

export type PlacesItem = {
  name: string;
  stored?: Json;
  storedText?: string;
  kept: { [key: string]: string };
};

export type Table = {
  $comment: string;
  cases: CasesItem[];
  writes: WritesItem[];
  refusedWrites: RefusedWritesItem[];
  places: PlacesItem[];
};

export const table: Table = {
  "$comment": "AUTHORITY for what a client keeps of its queries and of its stream in a SessionStorage, and what it keeps of what another client wrote there: the queries specs/src/client/refresh.json marks `persisted`, and specs/src/session/stored.json's `wholeKey`, `cacheDocument` and `lastEventIds`, case by case. Every SDK runs every case through its own persister for the case's query, under the key stored.json gives it for a knowledge base and a person of the runner's choosing (`cacheKeyPrefix`, the knowledge base's id, `.`, the person's key, `.`, the query's name; `lastEventIdKeyPrefix`, the knowledge base's id, `.` and the person's key), and fails on a difference. `cases` are loads: `stored` is kept under the query's key as its JSON text, or `storedText` as it is; `kept` is every entry the load keeps, each its `key` as the document writes it and its `value`, compared as a map, as the entries' order is no part of the rule. `writes`: `held` is what the query's cache holds once its answers came, each entry its `key` and its `value`; `written` is the document the save writes, its `version` and its `entries`, each entry stated by its `key` and its `value` and compared as a map, and each entry the save writes ends with its stamp, an integer of at least 0 (which one is the clock's, no part of the rule). `refusedWrites` are writes as `writes` are, over a storage that refuses the first write of the query's document: the cache still owes its save after it, and disposal's flush, which the storage takes, writes `written`. `places` are loads of `lastEventIds`: `stored` or `storedText` as for `cases`, and `kept` the places the load keeps. Every value is a wire value its query's `value` in refresh.json holds, except where a case's name says it is not the query's.",
  "cases": [
    {
      "name": "a resource's document",
      "query": "resource",
      "stored": {
        "version": 1,
        "entries": [
          [
            "res-1",
            {
              "@context": "https://schema.org/",
              "@id": "res-1",
              "name": "One",
              "representations": []
            },
            1000
          ],
          [
            "res-2",
            {
              "@context": "https://schema.org/",
              "@id": "res-2",
              "name": "Two",
              "representations": []
            },
            2000
          ]
        ]
      },
      "kept": [
        {
          "key": "res-1",
          "value": {
            "@context": "https://schema.org/",
            "@id": "res-1",
            "name": "One",
            "representations": []
          }
        },
        {
          "key": "res-2",
          "value": {
            "@context": "https://schema.org/",
            "@id": "res-2",
            "name": "Two",
            "representations": []
          }
        }
      ]
    },
    {
      "name": "an annotations document",
      "query": "annotations",
      "stored": {
        "version": 1,
        "entries": [
          [
            "res-1",
            {
              "annotations": [
                {
                  "@context": "http://www.w3.org/ns/anno.jsonld",
                  "type": "Annotation",
                  "id": "ann-1",
                  "motivation": "highlighting",
                  "target": {
                    "source": "res-1"
                  },
                  "created": "2026-01-01T00:00:00.000Z"
                }
              ],
              "total": 1
            },
            1000
          ]
        ]
      },
      "kept": [
        {
          "key": "res-1",
          "value": {
            "annotations": [
              {
                "@context": "http://www.w3.org/ns/anno.jsonld",
                "type": "Annotation",
                "id": "ann-1",
                "motivation": "highlighting",
                "target": {
                  "source": "res-1"
                },
                "created": "2026-01-01T00:00:00.000Z"
              }
            ],
            "total": 1
          }
        }
      ]
    },
    {
      "name": "an annotation's document",
      "query": "annotation",
      "stored": {
        "version": 1,
        "entries": [
          [
            "ann-1",
            {
              "@context": "http://www.w3.org/ns/anno.jsonld",
              "type": "Annotation",
              "id": "ann-1",
              "motivation": "highlighting",
              "target": {
                "source": "res-1"
              },
              "created": "2026-01-01T00:00:00.000Z"
            },
            1000
          ],
          [
            "ann-2",
            {
              "@context": "http://www.w3.org/ns/anno.jsonld",
              "type": "Annotation",
              "id": "ann-2",
              "motivation": "highlighting",
              "target": {
                "source": "res-1"
              },
              "created": "2026-01-01T00:00:00.000Z"
            },
            1000
          ]
        ]
      },
      "kept": [
        {
          "key": "ann-1",
          "value": {
            "@context": "http://www.w3.org/ns/anno.jsonld",
            "type": "Annotation",
            "id": "ann-1",
            "motivation": "highlighting",
            "target": {
              "source": "res-1"
            },
            "created": "2026-01-01T00:00:00.000Z"
          }
        },
        {
          "key": "ann-2",
          "value": {
            "@context": "http://www.w3.org/ns/anno.jsonld",
            "type": "Annotation",
            "id": "ann-2",
            "motivation": "highlighting",
            "target": {
              "source": "res-1"
            },
            "created": "2026-01-01T00:00:00.000Z"
          }
        }
      ]
    },
    {
      "name": "the entity types' document",
      "query": "entityTypes",
      "stored": {
        "version": 1,
        "entries": [
          [
            "_",
            [
              "Person",
              "Place"
            ],
            1000
          ]
        ]
      },
      "kept": [
        {
          "key": "_",
          "value": [
            "Person",
            "Place"
          ]
        }
      ]
    },
    {
      "name": "the tag schemas' document",
      "query": "tagSchemas",
      "stored": {
        "version": 1,
        "entries": [
          [
            "_",
            [
              {
                "id": "kinds",
                "name": "Kinds",
                "description": "What kind of claim a passage makes.",
                "domain": "general",
                "tags": [
                  {
                    "name": "Claim",
                    "description": "A statement put forward as true.",
                    "examples": [
                      "The bridge opened in spring."
                    ]
                  }
                ]
              }
            ],
            1000
          ]
        ]
      },
      "kept": [
        {
          "key": "_",
          "value": [
            {
              "id": "kinds",
              "name": "Kinds",
              "description": "What kind of claim a passage makes.",
              "domain": "general",
              "tags": [
                {
                  "name": "Claim",
                  "description": "A statement put forward as true.",
                  "examples": [
                    "The bridge opened in spring."
                  ]
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "name": "an empty document",
      "query": "resource",
      "stored": {
        "version": 1,
        "entries": []
      },
      "kept": []
    },
    {
      "name": "a member the document does not state is no part of it",
      "query": "resource",
      "stored": {
        "version": 1,
        "writtenAt": 1000,
        "entries": [
          [
            "res-1",
            {
              "@context": "https://schema.org/",
              "@id": "res-1",
              "name": "One",
              "representations": []
            },
            1000
          ]
        ]
      },
      "kept": [
        {
          "key": "res-1",
          "value": {
            "@context": "https://schema.org/",
            "@id": "res-1",
            "name": "One",
            "representations": []
          }
        }
      ]
    },
    {
      "name": "text that is no JSON",
      "query": "resource",
      "storedText": "{\"version\":1,\"entries\":[",
      "kept": []
    },
    {
      "name": "a document that is no object",
      "query": "resource",
      "stored": [
        [
          "res-1",
          {
            "@context": "https://schema.org/",
            "@id": "res-1",
            "name": "One",
            "representations": []
          },
          1000
        ]
      ],
      "kept": []
    },
    {
      "name": "a document of another version",
      "query": "resource",
      "stored": {
        "version": 2,
        "entries": [
          [
            "res-1",
            {
              "@context": "https://schema.org/",
              "@id": "res-1",
              "name": "One",
              "representations": []
            },
            1000
          ]
        ]
      },
      "kept": []
    },
    {
      "name": "a document with no version",
      "query": "resource",
      "stored": {
        "entries": [
          [
            "res-1",
            {
              "@context": "https://schema.org/",
              "@id": "res-1",
              "name": "One",
              "representations": []
            },
            1000
          ]
        ]
      },
      "kept": []
    },
    {
      "name": "a version that is text",
      "query": "resource",
      "stored": {
        "version": "1",
        "entries": [
          [
            "res-1",
            {
              "@context": "https://schema.org/",
              "@id": "res-1",
              "name": "One",
              "representations": []
            },
            1000
          ]
        ]
      },
      "kept": []
    },
    {
      "name": "entries that are no list",
      "query": "resource",
      "stored": {
        "version": 1,
        "entries": {
          "res-1": {
            "@context": "https://schema.org/",
            "@id": "res-1",
            "name": "One",
            "representations": []
          }
        }
      },
      "kept": []
    },
    {
      "name": "an entry that is no list drops the document",
      "query": "resource",
      "stored": {
        "version": 1,
        "entries": [
          [
            "res-1",
            {
              "@context": "https://schema.org/",
              "@id": "res-1",
              "name": "One",
              "representations": []
            },
            1000
          ],
          {
            "key": "res-2",
            "value": {
              "@context": "https://schema.org/",
              "@id": "res-2",
              "name": "Two",
              "representations": []
            },
            "at": 2000
          }
        ]
      },
      "kept": []
    },
    {
      "name": "an entry of two items drops the document",
      "query": "resource",
      "stored": {
        "version": 1,
        "entries": [
          [
            "res-1",
            {
              "@context": "https://schema.org/",
              "@id": "res-1",
              "name": "One",
              "representations": []
            },
            1000
          ],
          [
            "res-2",
            {
              "@context": "https://schema.org/",
              "@id": "res-2",
              "name": "Two",
              "representations": []
            }
          ]
        ]
      },
      "kept": []
    },
    {
      "name": "an entry of four items drops the document",
      "query": "resource",
      "stored": {
        "version": 1,
        "entries": [
          [
            "res-1",
            {
              "@context": "https://schema.org/",
              "@id": "res-1",
              "name": "One",
              "representations": []
            },
            1000
          ],
          [
            "res-2",
            {
              "@context": "https://schema.org/",
              "@id": "res-2",
              "name": "Two",
              "representations": []
            },
            2000,
            3000
          ]
        ]
      },
      "kept": []
    },
    {
      "name": "a stamp that is text drops the document",
      "query": "resource",
      "stored": {
        "version": 1,
        "entries": [
          [
            "res-1",
            {
              "@context": "https://schema.org/",
              "@id": "res-1",
              "name": "One",
              "representations": []
            },
            1000
          ],
          [
            "res-2",
            {
              "@context": "https://schema.org/",
              "@id": "res-2",
              "name": "Two",
              "representations": []
            },
            "2000"
          ]
        ]
      },
      "kept": []
    },
    {
      "name": "a negative stamp drops the document",
      "query": "resource",
      "stored": {
        "version": 1,
        "entries": [
          [
            "res-1",
            {
              "@context": "https://schema.org/",
              "@id": "res-1",
              "name": "One",
              "representations": []
            },
            1000
          ],
          [
            "res-2",
            {
              "@context": "https://schema.org/",
              "@id": "res-2",
              "name": "Two",
              "representations": []
            },
            -1
          ]
        ]
      },
      "kept": []
    },
    {
      "name": "a stamp that is no whole number drops the document",
      "query": "resource",
      "stored": {
        "version": 1,
        "entries": [
          [
            "res-1",
            {
              "@context": "https://schema.org/",
              "@id": "res-1",
              "name": "One",
              "representations": []
            },
            1000
          ],
          [
            "res-2",
            {
              "@context": "https://schema.org/",
              "@id": "res-2",
              "name": "Two",
              "representations": []
            },
            2000.5
          ]
        ]
      },
      "kept": []
    },
    {
      "name": "a value that is not the query's is skipped",
      "query": "resource",
      "stored": {
        "version": 1,
        "entries": [
          [
            "res-1",
            {
              "name": "One"
            },
            1000
          ],
          [
            "res-2",
            {
              "@context": "https://schema.org/",
              "@id": "res-2",
              "name": "Two",
              "representations": []
            },
            2000
          ]
        ]
      },
      "kept": [
        {
          "key": "res-2",
          "value": {
            "@context": "https://schema.org/",
            "@id": "res-2",
            "name": "Two",
            "representations": []
          }
        }
      ]
    },
    {
      "name": "a null value is skipped",
      "query": "resource",
      "stored": {
        "version": 1,
        "entries": [
          [
            "res-1",
            null,
            1000
          ],
          [
            "res-2",
            {
              "@context": "https://schema.org/",
              "@id": "res-2",
              "name": "Two",
              "representations": []
            },
            2000
          ]
        ]
      },
      "kept": [
        {
          "key": "res-2",
          "value": {
            "@context": "https://schema.org/",
            "@id": "res-2",
            "name": "Two",
            "representations": []
          }
        }
      ]
    },
    {
      "name": "a key that is no resource's id is skipped",
      "query": "resource",
      "stored": {
        "version": 1,
        "entries": [
          [
            "not an id!",
            {
              "@context": "https://schema.org/",
              "@id": "res-1",
              "name": "One",
              "representations": []
            },
            1000
          ],
          [
            "res-2",
            {
              "@context": "https://schema.org/",
              "@id": "res-2",
              "name": "Two",
              "representations": []
            },
            2000
          ]
        ]
      },
      "kept": [
        {
          "key": "res-2",
          "value": {
            "@context": "https://schema.org/",
            "@id": "res-2",
            "name": "Two",
            "representations": []
          }
        }
      ]
    },
    {
      "name": "a key that is no annotation's id is skipped",
      "query": "annotation",
      "stored": {
        "version": 1,
        "entries": [
          [
            {
              "resource": "res-1",
              "annotation": "ann-1"
            },
            {
              "@context": "http://www.w3.org/ns/anno.jsonld",
              "type": "Annotation",
              "id": "ann-1",
              "motivation": "highlighting",
              "target": {
                "source": "res-1"
              },
              "created": "2026-01-01T00:00:00.000Z"
            },
            1000
          ],
          [
            "ann-2",
            {
              "@context": "http://www.w3.org/ns/anno.jsonld",
              "type": "Annotation",
              "id": "ann-2",
              "motivation": "highlighting",
              "target": {
                "source": "res-1"
              },
              "created": "2026-01-01T00:00:00.000Z"
            },
            1000
          ]
        ]
      },
      "kept": [
        {
          "key": "ann-2",
          "value": {
            "@context": "http://www.w3.org/ns/anno.jsonld",
            "type": "Annotation",
            "id": "ann-2",
            "motivation": "highlighting",
            "target": {
              "source": "res-1"
            },
            "created": "2026-01-01T00:00:00.000Z"
          }
        }
      ]
    },
    {
      "name": "the annotation list alone is not what annotations keeps",
      "query": "annotations",
      "stored": {
        "version": 1,
        "entries": [
          [
            "res-1",
            [
              {
                "@context": "http://www.w3.org/ns/anno.jsonld",
                "type": "Annotation",
                "id": "ann-1",
                "motivation": "highlighting",
                "target": {
                  "source": "res-1"
                },
                "created": "2026-01-01T00:00:00.000Z"
              }
            ],
            1000
          ]
        ]
      },
      "kept": []
    },
    {
      "name": "a query per nothing keeps its entry under the whole key alone",
      "query": "entityTypes",
      "stored": {
        "version": 1,
        "entries": [
          [
            {},
            [
              "Person",
              "Place"
            ],
            1000
          ]
        ]
      },
      "kept": []
    },
    {
      "name": "an entry of a query per nothing under another text is skipped",
      "query": "entityTypes",
      "stored": {
        "version": 1,
        "entries": [
          [
            "_",
            [
              "Person",
              "Place"
            ],
            1000
          ],
          [
            "x",
            [
              "Place"
            ],
            1000
          ]
        ]
      },
      "kept": [
        {
          "key": "_",
          "value": [
            "Person",
            "Place"
          ]
        }
      ]
    },
    {
      "name": "a number is its value: a version written 1.0 and a stamp written 1e3",
      "query": "entityTypes",
      "storedText": "{\"version\":1.0,\"entries\":[[\"_\",[\"Person\",\"Place\"],1e3]]}",
      "kept": [
        {
          "key": "_",
          "value": [
            "Person",
            "Place"
          ]
        }
      ]
    },
    {
      "name": "a stamp written with a zero fraction is a whole number",
      "query": "resource",
      "storedText": "{\"version\": 1, \"entries\": [[\"res-1\", {\"@context\": \"https://schema.org/\", \"@id\": \"res-1\", \"name\": \"One\", \"representations\": []}, 1000.0]]}",
      "kept": [
        {
          "key": "res-1",
          "value": {
            "@context": "https://schema.org/",
            "@id": "res-1",
            "name": "One",
            "representations": []
          }
        }
      ]
    },
    {
      "name": "tag schemas that are not the query's are skipped",
      "query": "tagSchemas",
      "stored": {
        "version": 1,
        "entries": [
          [
            "_",
            [
              {
                "id": "kinds"
              }
            ],
            1000
          ]
        ]
      },
      "kept": []
    }
  ],
  "writes": [
    {
      "name": "a resource",
      "query": "resource",
      "held": [
        {
          "key": "res-1",
          "value": {
            "@context": "https://schema.org/",
            "@id": "res-1",
            "name": "One",
            "representations": []
          }
        },
        {
          "key": "res-2",
          "value": {
            "@context": "https://schema.org/",
            "@id": "res-2",
            "name": "Two",
            "representations": []
          }
        }
      ],
      "written": {
        "version": 1,
        "entries": [
          {
            "key": "res-1",
            "value": {
              "@context": "https://schema.org/",
              "@id": "res-1",
              "name": "One",
              "representations": []
            }
          },
          {
            "key": "res-2",
            "value": {
              "@context": "https://schema.org/",
              "@id": "res-2",
              "name": "Two",
              "representations": []
            }
          }
        ]
      }
    },
    {
      "name": "a resource's annotations",
      "query": "annotations",
      "held": [
        {
          "key": "res-1",
          "value": {
            "annotations": [
              {
                "@context": "http://www.w3.org/ns/anno.jsonld",
                "type": "Annotation",
                "id": "ann-1",
                "motivation": "highlighting",
                "target": {
                  "source": "res-1"
                },
                "created": "2026-01-01T00:00:00.000Z"
              }
            ],
            "total": 1
          }
        }
      ],
      "written": {
        "version": 1,
        "entries": [
          {
            "key": "res-1",
            "value": {
              "annotations": [
                {
                  "@context": "http://www.w3.org/ns/anno.jsonld",
                  "type": "Annotation",
                  "id": "ann-1",
                  "motivation": "highlighting",
                  "target": {
                    "source": "res-1"
                  },
                  "created": "2026-01-01T00:00:00.000Z"
                }
              ],
              "total": 1
            }
          }
        ]
      }
    },
    {
      "name": "an annotation",
      "query": "annotation",
      "held": [
        {
          "key": "ann-1",
          "value": {
            "@context": "http://www.w3.org/ns/anno.jsonld",
            "type": "Annotation",
            "id": "ann-1",
            "motivation": "highlighting",
            "target": {
              "source": "res-1"
            },
            "created": "2026-01-01T00:00:00.000Z"
          }
        }
      ],
      "written": {
        "version": 1,
        "entries": [
          {
            "key": "ann-1",
            "value": {
              "@context": "http://www.w3.org/ns/anno.jsonld",
              "type": "Annotation",
              "id": "ann-1",
              "motivation": "highlighting",
              "target": {
                "source": "res-1"
              },
              "created": "2026-01-01T00:00:00.000Z"
            }
          }
        ]
      }
    },
    {
      "name": "the entity types",
      "query": "entityTypes",
      "held": [
        {
          "key": "_",
          "value": [
            "Person",
            "Place"
          ]
        }
      ],
      "written": {
        "version": 1,
        "entries": [
          {
            "key": "_",
            "value": [
              "Person",
              "Place"
            ]
          }
        ]
      }
    },
    {
      "name": "the tag schemas",
      "query": "tagSchemas",
      "held": [
        {
          "key": "_",
          "value": [
            {
              "id": "kinds",
              "name": "Kinds",
              "description": "What kind of claim a passage makes.",
              "domain": "general",
              "tags": [
                {
                  "name": "Claim",
                  "description": "A statement put forward as true.",
                  "examples": [
                    "The bridge opened in spring."
                  ]
                }
              ]
            }
          ]
        }
      ],
      "written": {
        "version": 1,
        "entries": [
          {
            "key": "_",
            "value": [
              {
                "id": "kinds",
                "name": "Kinds",
                "description": "What kind of claim a passage makes.",
                "domain": "general",
                "tags": [
                  {
                    "name": "Claim",
                    "description": "A statement put forward as true.",
                    "examples": [
                      "The bridge opened in spring."
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }
    }
  ],
  "refusedWrites": [
    {
      "name": "the entity types, whose first write the storage refuses",
      "query": "entityTypes",
      "held": [
        {
          "key": "_",
          "value": [
            "Person",
            "Place"
          ]
        }
      ],
      "written": {
        "version": 1,
        "entries": [
          {
            "key": "_",
            "value": [
              "Person",
              "Place"
            ]
          }
        ]
      }
    },
    {
      "name": "a resource, whose first write the storage refuses",
      "query": "resource",
      "held": [
        {
          "key": "res-1",
          "value": {
            "@context": "https://schema.org/",
            "@id": "res-1",
            "name": "One",
            "representations": []
          }
        }
      ],
      "written": {
        "version": 1,
        "entries": [
          {
            "key": "res-1",
            "value": {
              "@context": "https://schema.org/",
              "@id": "res-1",
              "name": "One",
              "representations": []
            }
          }
        ]
      }
    }
  ],
  "places": [
    {
      "name": "places",
      "stored": {
        "res-1": "p-res-1-47",
        "res-2": "p-res-2-3"
      },
      "kept": {
        "res-1": "p-res-1-47",
        "res-2": "p-res-2-3"
      }
    },
    {
      "name": "a place that is no persisted event's id is skipped",
      "stored": {
        "res-1": "e-res-1-47",
        "res-2": "p-res-2-3"
      },
      "kept": {
        "res-2": "p-res-2-3"
      }
    },
    {
      "name": "a place that is no text is skipped",
      "stored": {
        "res-1": 47,
        "res-2": "p-res-2-3"
      },
      "kept": {
        "res-2": "p-res-2-3"
      }
    },
    {
      "name": "a scope that is no resource's id is skipped",
      "stored": {
        "not an id!": "p-x-1",
        "res-2": "p-res-2-3"
      },
      "kept": {
        "res-2": "p-res-2-3"
      }
    },
    {
      "name": "places that are no object are none",
      "stored": [
        "res-1",
        "p-res-1-47"
      ],
      "kept": {}
    },
    {
      "name": "text that is no JSON is no places",
      "storedText": "{\"res-1\":",
      "kept": {}
    }
  ]
};
