/**
 * Every TypeScript and JavaScript file the repository tracks under `typescript/`
 * and `.github/` is in some tsconfig's file list, so each is typechecked: a new
 * script or config that no tsconfig names fails here instead of going unchecked.
 */
import { dirname, join, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import ts from 'typescript';
import { repositoryFiles } from './repository-files.mjs';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
const CHECKED = /^(typescript|\.github)\/.*\.(ts|tsx|mts|cts|js|mjs|cjs)$/;
// The base every tsconfig extends names no files of its own.
const BASE = 'typescript/tsconfig.base.json';

const files = repositoryFiles(root);
const configs = files.filter((file) => /^typescript\/(.*\/)?tsconfig[^/]*\.json$/.test(file) && file !== BASE);

/** @type {Set<string>} */
const listed = new Set();
for (const config of configs) {
  const parsed = ts.getParsedCommandLineOfConfigFile(join(root, config), {}, {
    ...ts.sys,
    onUnRecoverableConfigFileDiagnostic: (diagnostic) => {
      throw new Error(`${config}: ${ts.flattenDiagnosticMessageText(diagnostic.messageText, '\n')}`);
    },
  });
  if (!parsed) throw new Error(`${config}: not a tsconfig TypeScript can read`);
  for (const file of parsed.fileNames) listed.add(relative(root, file));
}

const unlisted = files.filter((file) => CHECKED.test(file) && !listed.has(file));
if (unlisted.length > 0) {
  console.error('In no tsconfig, so never typechecked:');
  for (const file of unlisted) console.error(`  ${file}`);
  process.exit(1);
}
console.log(`Every one of the ${files.filter((file) => CHECKED.test(file)).length} TypeScript and JavaScript files is in a tsconfig (${configs.length} tsconfigs).`);
