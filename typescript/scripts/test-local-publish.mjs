import { test } from 'node:test';
import assert from 'node:assert/strict';
import { cpSync, existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
function fixture() {
  const directory = mkdtempSync(join(tmpdir(), 'xynolog-local-publication-'));
  const source = join(directory, 'source');
  const stage = join(directory, 'stage');
  /**
   * @param {string} path
   * @param {string} text
   */
  const put = (path, text) => { mkdirSync(dirname(join(source, path)), { recursive: true }); writeFileSync(join(source, path), text); };
  const version = JSON.parse(readFileSync(join(root, 'version.json'), 'utf8'));
  put('version.json', JSON.stringify(version));
  put('LICENSE', 'fixture license');
  put('package-lock.json', 'dirty lockfile bytes');
  cpSync(join(root, 'typescript/scripts'), join(source, 'typescript/scripts'), { recursive: true });
  for (const entry of Object.values(version.packages)) {
    put(`${entry.dir}/package.json`, readFileSync(join(root, entry.dir, 'package.json'), 'utf8'));
    if (entry.publish && !entry.stage) {
      /** @type {{ main?: string, types?: string, exports?: unknown, bin?: unknown, files: string[] }} */
      const manifest = JSON.parse(readFileSync(join(root, entry.dir, 'package.json'), 'utf8'));
      /** @type {(value: unknown) => string[]} */
      const strings = (value) => typeof value === 'string' ? [value] : value && typeof value === 'object' ? Object.values(value).flatMap(strings) : [];
      for (const path of [manifest.main, manifest.types, ...strings(manifest.exports), ...strings(manifest.bin)].flatMap((path) => path ? [path] : [])) {
        put(`${entry.dir}/${path.replaceAll('*', 'fixture')}`, 'built artifact');
      }
      for (const path of manifest.files.filter((path) => !path.startsWith('!'))) {
        const input = path.includes('*') ? path.replaceAll('*', 'fixture') : path;
        put(`${entry.dir}/${input}${input.includes('.') ? '' : '/fixture.txt'}`, 'packaged asset');
      }
    }
  }
  /** @param {string[]} args */
  const run = (...args) => spawnSync(process.execPath, [join(source, 'typescript/scripts/stage-local-publish.mjs'), ...args], { encoding: 'utf8' });
  return { directory, source, stage, run, version };
}

test('publication stamping is confined to the complete isolated npm input set', () => {
  const f = fixture();
  try {
    const manifests = Object.values(f.version.packages).map((entry) => `${entry.dir}/package.json`);
    const paths = ['version.json', 'package-lock.json', ...manifests];
    const before = paths.map((path) => readFileSync(join(f.source, path)));
    const result = f.run('stage', f.stage);
    assert.equal(result.status, 0, result.stderr);
    const stamp = spawnSync(process.execPath, [join(f.stage, 'typescript/scripts/stamp-versions.mjs'), '0.8.0-dev.20261116000000.gfixture'], { encoding: 'utf8' });
    assert.equal(stamp.status, 0, stamp.stderr);
    paths.forEach((path, index) => assert.deepEqual(readFileSync(join(f.source, path)), before[index], path));
    for (const entry of Object.values(f.version.packages).filter((entry) => entry.publish)) {
      assert.equal(existsSync(join(f.stage, entry.dir, 'package.json')), true);
    }
  } finally { rmSync(f.directory, { recursive: true, force: true }); }
});


for (const [name, path] of [
  ['exported JavaScript subpath', 'typescript/core/dist/openapi.js'],
  ['exported type declaration', 'typescript/core/dist/testing/issuer.d.ts'],
  ['exported CSS', 'typescript/react-ui/src/styles/variables.css'],
  ['required asset directory', 'typescript/react-ui/public'],
]) {
  test(`${name} must exist before registry replacement`, () => {
    const f = fixture();
    try {
      rmSync(join(f.source, path), { recursive: true });
      const result = f.run('stage', f.stage);
      assert.notEqual(result.status, 0);
      assert.match(result.stderr, /publication input is missing/);
      assert.equal(existsSync(f.stage), false);
    } finally { rmSync(f.directory, { recursive: true, force: true }); }
  });
}

test('an export excluded by npm packaging is rejected', () => {
  const f = fixture();
  try {
    const file = join(f.source, 'typescript/core/package.json');
    const manifest = JSON.parse(readFileSync(file, 'utf8'));
    manifest.files = ['dist/index.js', 'dist/index.d.ts', 'README.md'];
    writeFileSync(file, JSON.stringify(manifest));
    const result = f.run('verify');
    assert.notEqual(result.status, 0);
    assert.match(result.stderr, /exported file is absent from the npm package/);
  } finally { rmSync(f.directory, { recursive: true, force: true }); }
});

test('all nested export conditions and wildcard exports are checked', () => {
  const f = fixture();
  try {
    const file = join(f.source, 'typescript/core/package.json');
    const manifest = JSON.parse(readFileSync(file, 'utf8'));
    manifest.exports['./nested'] = { node: { types: './dist/nested.d.ts' }, default: null };
    writeFileSync(file, JSON.stringify(manifest));
    let result = f.run('verify');
    assert.notEqual(result.status, 0);
    assert.match(result.stderr, /nested.d.ts/);
    writeFileSync(join(f.source, 'typescript/core/dist/nested.d.ts'), 'export {};');
    rmSync(join(f.source, 'typescript/react-ui/translations/fixture.json'));
    result = f.run('verify');
    assert.notEqual(result.status, 0);
    assert.match(result.stderr, /translations\/\*\.json/);
  } finally { rmSync(f.directory, { recursive: true, force: true }); }
});
