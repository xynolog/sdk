// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/jobs/filter-cases.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export type Json = null | boolean | number | string | Json[] | { [key: string]: Json };

export type JobType =
  | 'mark'
  | 'yield';

export type Motivation =
  | 'assessing'
  | 'commenting'
  | 'highlighting'
  | 'linking'
  | 'tagging';

export type Params = {
  motivation?: Motivation;
  schemaId?: string;
  categories?: string[];
  title?: string;
  storageUri?: string;
  outputMediaType?: string;
  tone?: string;
  language?: string;
  entityTypes?: string[];
  resourceId?: string;
};

export type Job = {
  jobType: JobType;
  params: Params;
};

export type CasesItem = {
  why: string;
  filter: Json;
  job: Job;
  matches: boolean;
};

export type Table = {
  $comment: string;
  cases: CasesItem[];
};

export const table: Table = {
  "$comment": "Whether a job matches a filter, as every implementation must answer it: the Dispatcher choosing the next job a claim takes, and a party checking an announcement against its own claim before it asks. A filter is a partial job description (JobFilter). A job matches when every field the filter states equals the job's at the same path; what the filter leaves out is not compared. `job` is the description as it is announced or held: its `jobType` and its `params`. Each implementation runs every case and fails on a difference. Add a case here before changing any of them.",
  "cases": [
    {
      "why": "a mark filter takes a mark job of its motivation",
      "filter": {
        "jobType": "mark",
        "params": {
          "motivation": "tagging"
        }
      },
      "job": {
        "jobType": "mark",
        "params": {
          "motivation": "tagging",
          "schemaId": "irac",
          "categories": [
            "Issue"
          ]
        }
      },
      "matches": true
    },
    {
      "why": "a mark filter takes no mark job of another motivation",
      "filter": {
        "jobType": "mark",
        "params": {
          "motivation": "tagging"
        }
      },
      "job": {
        "jobType": "mark",
        "params": {
          "motivation": "highlighting"
        }
      },
      "matches": false
    },
    {
      "why": "a mark filter takes no yield job",
      "filter": {
        "jobType": "mark",
        "params": {
          "motivation": "tagging"
        }
      },
      "job": {
        "jobType": "yield",
        "params": {
          "title": "Ouranos",
          "storageUri": "file://generated/ouranos.md"
        }
      },
      "matches": false
    },
    {
      "why": "a yield filter takes every yield job, whatever it is asked to make",
      "filter": {
        "jobType": "yield"
      },
      "job": {
        "jobType": "yield",
        "params": {
          "title": "Ouranos",
          "storageUri": "file://generated/ouranos.md",
          "outputMediaType": "application/pdf"
        }
      },
      "matches": true
    },
    {
      "why": "a yield filter takes no mark job",
      "filter": {
        "jobType": "yield"
      },
      "job": {
        "jobType": "mark",
        "params": {
          "motivation": "commenting"
        }
      },
      "matches": false
    },
    {
      "why": "a filter's parameter the job does not state is no match",
      "filter": {
        "jobType": "mark",
        "params": {
          "motivation": "tagging"
        }
      },
      "job": {
        "jobType": "mark",
        "params": {}
      },
      "matches": false
    },
    {
      "why": "a parameter the filter does not state is not compared",
      "filter": {
        "jobType": "mark",
        "params": {
          "motivation": "commenting"
        }
      },
      "job": {
        "jobType": "mark",
        "params": {
          "motivation": "commenting",
          "tone": "scholarly",
          "language": "de"
        }
      },
      "matches": true
    },
    {
      "why": "what the Dispatcher adds to a job it holds is not compared",
      "filter": {
        "jobType": "mark",
        "params": {
          "motivation": "linking"
        }
      },
      "job": {
        "jobType": "mark",
        "params": {
          "motivation": "linking",
          "entityTypes": [
            "Person"
          ],
          "resourceId": "res-1"
        }
      },
      "matches": true
    }
  ]
};
