/** Validate the files promised by a publish manifest against npm's actual package inventory. */
import { globSync, statSync } from 'node:fs';
import { join, normalize } from 'node:path';
import { execFileSync } from 'node:child_process';

/**
 * @param {unknown} value
 * @returns {string[]}
 */
function targets(value) {
  if (typeof value === 'string') return [value];
  if (value && typeof value === 'object') return Object.values(value).flatMap(targets);
  return [];
}

/**
 * @typedef {object} Manifest
 * @property {string} [main]
 * @property {string} [types]
 * @property {string} [module]
 * @property {string} [style]
 * @property {unknown} [exports]
 * @property {unknown} [bin]
 * @property {string[]} [files]
 */

/**
 * @param {string} directory
 * @param {Manifest} manifest
 * @param {string} label
 */
export function verifyPublication(directory, manifest, label) {
  /** @type {(path: string, reason: string) => never} */
  const fail = (path, reason) => {
    throw new Error(`${label}/${path}: ${reason}. Build the TypeScript workspaces with make build, or see typescript/README.md for package build instructions.`);
  };
  /** @param {string} path */
  const local = (path) => {
    if (path.startsWith('/') || normalize(path).split('/').includes('..')) fail(path, 'publication path escapes the package');
    return path.replace(/^\.\//, '');
  };
  const exported = [...new Set([manifest.main, manifest.types, manifest.module, manifest.style,
    ...targets(manifest.exports), ...targets(manifest.bin)].flatMap((path) => path ? [local(path)] : []))];
  const assets = (manifest.files ?? []).filter((path) => !path.startsWith('!')).map(local);
  for (const pattern of [...exported, ...assets]) {
    if (globSync(pattern, { cwd: directory }).length === 0) fail(pattern, 'required publication input is missing');
  }
  /** @type {{ files: { path: string }[] }[]} */
  const packed = JSON.parse(execFileSync('npm', ['pack', '--dry-run', '--json', '--ignore-scripts', '--workspaces=false'], {
    cwd: directory, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'],
  }));
  const inventory = new Set(packed[0].files.map((file) => file.path));
  for (const pattern of exported) {
    for (const path of globSync(pattern, { cwd: directory })) {
      if (!statSync(join(directory, path)).isFile() || !inventory.has(path)) fail(path, 'exported file is absent from the npm package');
    }
  }
  for (const pattern of assets) {
    const matches = globSync(pattern, { cwd: directory });
    if (!matches.some((path) => [...inventory].some((file) => file === path || file.startsWith(path + '/')))) {
      fail(pattern, 'required asset is excluded from the npm package');
    }
  }
}
