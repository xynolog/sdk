#!/usr/bin/env node
/**
 * Stamp a version across every workspace package.json that version.json
 * lists (the `version` field + internal cross-dep pins). Run by publish.sh on
 * its staged copy, with the version that build gives the packages
 * (scripts/sdk_version.py typescript).
 *
 * Internal `@xynolog/*` / `xynolog-*` deps are declared `"*"` in source and
 * rewritten to the exact version here via the shared stampInternalDeps — the
 * single publish-time pin normalization (see https://github.com/xynolog/docs/blob/main/contributor/DEPENDENCIES.md#how-the-sdks-packages-depend-on-each-other).
 *
 * Usage: node typescript/scripts/stamp-versions.mjs <version>
 */
import { readFileSync, writeFileSync } from 'fs';
import { resolve, dirname } from 'path';
import { fileURLToPath } from 'url';
import { stampInternalDeps } from './stamp-internal-deps.mjs';

const rootDir = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
const version = process.argv[2];
if (!version) {
  console.error('Usage: node typescript/scripts/stamp-versions.mjs <version>');
  process.exit(1);
}

/** @param {string} p */
const read = (p) => JSON.parse(readFileSync(resolve(rootDir, p), 'utf-8'));
/**
 * @param {string} p
 * @param {unknown} data
 */
const write = (p, data) => writeFileSync(resolve(rootDir, p), JSON.stringify(data, null, 2) + '\n');

const versionJson = read('version.json');

// Stamp every package.json in version.json, published or not, so the
// workspace stays version-coherent.
for (const pkg of Object.values(versionJson.packages)) {
  const path = pkg.dir + '/package.json';
  const json = read(path);
  json.version = version;
  stampInternalDeps(json, version);
  write(path, json);
  console.log('  ' + json.name + ' -> ' + version);
}
