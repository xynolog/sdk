// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/client/shape-cases.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export type Json = null | boolean | number | string | Json[] | { [key: string]: Json };

export type ShapeAccepted = {
  why: string;
  schema: string;
  value: Json;
};

export type FrameRefusalReason =
  | 'lacks'
  | 'malformed';

export type ShapeRefused = {
  why: string;
  schema: string;
  value: Json;
  refused: true;
  member: string;
  reason: FrameRefusalReason;
};

export type CasesItem =
  | ShapeAccepted
  | ShapeRefused;

export type Table = {
  $comment: string;
  cases: CasesItem[];
};

export const table: Table = {
  "$comment": "What every SDK's reading of a value finds of it, as a value of a schema Protocol states, as every SDK's reader must. A reader holds a value to what its schema requires of it before it reads it, by the table of each schema's shape the consumer-owned generator derives from the schemas, and finds its first fault as every SDK finds one: a member it lacks (`lacks`), or a value that is not what its schema allows (`malformed`). THE RULE. A value its schema allows is read. One it does not allow is refused for its first fault, named by its way from the value (`member`: the names of the members it is within, and its own, joined by dots; empty for the value itself). What a schema states of an object's members together is held as the table states it: a set of members the object may not carry whole (a `not` of `required`), each member carried that holds null among them; the fewest members it carries (`minProperties`); and what each member's name must be (`propertyNames`), a name that is not being a fault of that member. A pattern is read as ECMA-262 reads it, its groups and alternatives among it. A value of a union none of whose variants it is has the first variant's fault. A CASE is a value read as the schema `schema` names, the stem of its file under specs/src: one that is read, or one `refused`: true, with its first fault's `member` and `reason`. Protocol's own validator holds each case: a case that is read is a value the schema allows, and one that is refused a value it does not.",
  "cases": [
    {
      "why": "a runner that is somebody else's names where it is reached, and nothing the launcher runs it from",
      "schema": "Runner",
      "value": {
        "external": "db.example.org:5432"
      }
    },
    {
      "why": "a runner the launcher runs names its image and its resources, and no external",
      "schema": "Runner",
      "value": {
        "image": "postgres:16",
        "resources": {}
      }
    },
    {
      "why": "a runner that names its image, its resources and an external carries a set it may not carry whole: the runner is malformed",
      "schema": "Runner",
      "value": {
        "image": "postgres:16",
        "resources": {},
        "external": "db.example.org:5432"
      },
      "refused": true,
      "member": "",
      "reason": "malformed"
    },
    {
      "why": "a member that holds null is carried: a runner of an image and resources whose external is null is malformed",
      "schema": "Runner",
      "value": {
        "image": "postgres:16",
        "resources": {},
        "external": null
      },
      "refused": true,
      "member": "",
      "reason": "malformed"
    },
    {
      "why": "a runner of an image alone is none of its variants, and its fault is its first variant's: it lacks its resources",
      "schema": "Runner",
      "value": {
        "image": "postgres:16"
      },
      "refused": true,
      "member": "resources",
      "reason": "lacks"
    },
    {
      "why": "a local target names a root and no repository",
      "schema": "Target",
      "value": {
        "kind": "local",
        "root": "/srv/kb"
      }
    },
    {
      "why": "a codespace target names its repository and no root",
      "schema": "Target",
      "value": {
        "kind": "codespace",
        "repo": "acme/kb"
      }
    },
    {
      "why": "a local target that names a repository carries what its variant may not: it is malformed",
      "schema": "Target",
      "value": {
        "kind": "local",
        "repo": "acme/kb"
      },
      "refused": true,
      "member": "",
      "reason": "malformed"
    },
    {
      "why": "a codespace target that names no repository is none of its variants, and its fault is its first variant's, whose kind is local",
      "schema": "Target",
      "value": {
        "kind": "codespace"
      },
      "refused": true,
      "member": "kind",
      "reason": "malformed"
    },
    {
      "why": "a repository is an owner and a name, with no slash in either",
      "schema": "Target",
      "value": {
        "kind": "codespace",
        "repo": "acme/kb/x"
      },
      "refused": true,
      "member": "repo",
      "reason": "malformed"
    },
    {
      "why": "a name of one letter or digit is of its pattern, whose group is optional",
      "schema": "Metadata",
      "value": {
        "name": "a"
      }
    },
    {
      "why": "a name whose group takes hyphens, letters and digits, and ends in a letter or digit, is of its pattern",
      "schema": "Metadata",
      "value": {
        "name": "kb-one-2"
      }
    },
    {
      "why": "a name that ends in a hyphen is of no reading of its pattern",
      "schema": "Metadata",
      "value": {
        "name": "kb-"
      },
      "refused": true,
      "member": "name",
      "reason": "malformed"
    },
    {
      "why": "a name that begins with a hyphen is of no reading of its pattern",
      "schema": "Metadata",
      "value": {
        "name": "-kb"
      },
      "refused": true,
      "member": "name",
      "reason": "malformed"
    },
    {
      "why": "a request id is a text",
      "schema": "RequestId",
      "value": "r-1"
    },
    {
      "why": "a request id is an integer",
      "schema": "RequestId",
      "value": 7
    },
    {
      "why": "a request id is no number with a fractional part",
      "schema": "RequestId",
      "value": 1.5,
      "refused": true,
      "member": "",
      "reason": "malformed"
    },
    {
      "why": "a request id is no boolean",
      "schema": "RequestId",
      "value": true,
      "refused": true,
      "member": "",
      "reason": "malformed"
    },
    {
      "why": "an inference document names each provider it reaches by a provider's name",
      "schema": "Inference",
      "value": {
        "apiVersion": "xynolog.org/v1alpha1",
        "kind": "Inference",
        "metadata": {
          "name": "local"
        },
        "spec": {
          "providers": {
            "ollama": {
              "baseURL": "http://localhost:11434"
            }
          },
          "engines": {
            "jobs": {},
            "actors": {}
          }
        }
      }
    },
    {
      "why": "an inference document reaches at least one provider: its providers are malformed",
      "schema": "Inference",
      "value": {
        "apiVersion": "xynolog.org/v1alpha1",
        "kind": "Inference",
        "metadata": {
          "name": "local"
        },
        "spec": {
          "providers": {},
          "engines": {
            "jobs": {},
            "actors": {}
          }
        }
      },
      "refused": true,
      "member": "spec.providers",
      "reason": "malformed"
    },
    {
      "why": "a provider is named by a provider's name: a member of another name is malformed",
      "schema": "Inference",
      "value": {
        "apiVersion": "xynolog.org/v1alpha1",
        "kind": "Inference",
        "metadata": {
          "name": "local"
        },
        "spec": {
          "providers": {
            "ollama": {},
            "acme": {}
          },
          "engines": {
            "jobs": {},
            "actors": {}
          }
        }
      },
      "refused": true,
      "member": "spec.providers.acme",
      "reason": "malformed"
    },
    {
      "why": "a provider's name is held before what the provider is",
      "schema": "Inference",
      "value": {
        "apiVersion": "xynolog.org/v1alpha1",
        "kind": "Inference",
        "metadata": {
          "name": "local"
        },
        "spec": {
          "providers": {
            "acme": {},
            "ollama": {
              "baseURL": ""
            }
          },
          "engines": {
            "jobs": {},
            "actors": {}
          }
        }
      },
      "refused": true,
      "member": "spec.providers.acme",
      "reason": "malformed"
    },
    {
      "why": "what is lacked is found before a name that is wrong",
      "schema": "Inference",
      "value": {
        "apiVersion": "xynolog.org/v1alpha1",
        "kind": "Inference",
        "metadata": {
          "name": "local"
        },
        "spec": {
          "providers": {
            "acme": {}
          }
        }
      },
      "refused": true,
      "member": "spec.engines",
      "reason": "lacks"
    }
  ]
};
