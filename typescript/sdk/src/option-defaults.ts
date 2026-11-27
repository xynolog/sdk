// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/client/option-defaults.json
// Regenerate:  make generate  (codegen/lib/option_defaults/typescript.ml)

import type { KbTarget } from '@xynolog/core';

/** The directory listed: the knowledge base's root. */
export const BROWSE_FILES_DIR_PATH = '.';

/** How the listing is ordered: by name. */
export const BROWSE_FILES_SORT = 'name';

/** How many links out from the resource the graph reaches. */
export const GATHER_RESOURCE_DEPTH = 2;

/** The most resources the context holds. */
export const GATHER_RESOURCE_MAX_RESOURCES = 10;

/** Whether the context carries the resources' text. */
export const GATHER_RESOURCE_INCLUDE_CONTENT = true;

/** Whether the context carries a summary of the resource. */
export const GATHER_RESOURCE_INCLUDE_SUMMARY = false;

/** The most candidates the search answers. */
export const MATCH_SEARCH_LIMIT = 10;

/** Whether a session opened over a kept sign-in asks the gateway who its token is. */
export const KEPT_SIGN_IN_SESSION_FROM_KEPT_VALIDATE = true;

/** The knowledge base a test session is with: test-kb, at http://localhost:4000. */
export const TESTING_CREATE_TEST_SESSION_KB: KbTarget = {
  id: 'test-kb',
  label: 'Test KB',
  endpoint: {
    kind: 'http',
    host: 'localhost',
    port: 4000,
    protocol: 'http',
  },
};
