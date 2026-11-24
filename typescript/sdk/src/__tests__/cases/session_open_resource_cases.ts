// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/session/open-resource-cases.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export type Kb = 'itself' | 'unanswered';

export type ResourcesValue = 'ready' | 'gone' | 'unanswered';

export type CasesItem = {
  why: string;
  kb: Kb;
  open: string[];
  resources: { [key: string]: ResourcesValue };
  asked: string[];
  stillOpen: string[];
};

export type Table = {
  $comment: string;
  cases: CasesItem[];
};

export const table: Table = {
  $comment:
    "AUTHORITY for what a registry of knowledge bases does with the resources open in a knowledge base when a session with it becomes active: it asks the knowledge base to describe itself, reads the answer against the entry it was asked as (specs/src/client/registry.json's KbReadVerdict), and checks each resource open in it (TabCheck). Every SDK runs every case against its own registry over a scripted knowledge base, and fails on a difference. A verdict of no verdict (the knowledge base did not answer, or could not say who it is) is evidence of nothing: every open resource is checked, exactly as when the knowledge base answered as its entry. Only a resource the knowledge base says is gone (`bus.not-found`) closes; one it describes stays, and so does one it gave no answer about, since a fault is no verdict. READING A CASE. `kb` is what the knowledge base answers when asked to describe itself: `itself`, the did of the entry it was asked as; `unanswered`, nothing. `open` is the ids of the resources open in it before the session is active. `resources` is what it answers when asked for each of them: `ready`, its description; `gone`, `bus.not-found`; `unanswered`, nothing. `asked` is the ids of the resources the registry asks for, and `stillOpen` those open once the checks are done, each compared as a set.",
  cases: [
    {
      why: 'a knowledge base that does not answer gives no verdict, and every open resource is checked all the same: the gone one closes, and the others stay',
      kb: 'unanswered',
      open: ['res-described', 'res-gone', 'res-unanswered'],
      resources: {
        'res-described': 'ready',
        'res-gone': 'gone',
        'res-unanswered': 'unanswered',
      },
      asked: ['res-described', 'res-gone', 'res-unanswered'],
      stillOpen: ['res-described', 'res-unanswered'],
    },
    {
      why: 'a knowledge base that answers as its entry has every open resource checked: the gone one closes, and the others stay',
      kb: 'itself',
      open: ['res-described', 'res-gone', 'res-unanswered'],
      resources: {
        'res-described': 'ready',
        'res-gone': 'gone',
        'res-unanswered': 'unanswered',
      },
      asked: ['res-described', 'res-gone', 'res-unanswered'],
      stillOpen: ['res-described', 'res-unanswered'],
    },
    {
      why: 'no verdict keeps nothing the knowledge base says is gone: each gone resource closes',
      kb: 'unanswered',
      open: ['res-gone', 'res-also-gone'],
      resources: {
        'res-gone': 'gone',
        'res-also-gone': 'gone',
      },
      asked: ['res-gone', 'res-also-gone'],
      stillOpen: [],
    },
  ],
};
