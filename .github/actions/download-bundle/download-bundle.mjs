import { createHash } from 'node:crypto';
import { execFileSync } from 'node:child_process';
import { appendFileSync, mkdirSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, resolve, sep } from 'node:path';

const tag = required('INPUT_TAG');
const sdkCommit = required('INPUT_COMMIT');
const protocolCommit = required('INPUT_PROTOCOL_COMMIT');
const archiveSha256 = required('INPUT_SHA256');
const languages = required('INPUT_LANGUAGES').split(',').map((value) => value.trim()).filter(Boolean).sort();
if (!/^v(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)$/.test(tag)) fail('SDK artifact release tag is not an SDK release, vX.Y.Z');
if (!/^[0-9a-f]{40}$/.test(sdkCommit) || !/^[0-9a-f]{40}$/.test(protocolCommit)) fail('SDK and Protocol commits must be full commit hashes');
if (!/^[0-9a-f]{64}$/.test(archiveSha256)) fail('Bundle SHA-256 must be a full lowercase digest');
if (languages.length === 0 || new Set(languages).size !== languages.length) fail('At least one unique SDK language is required');

const workspace = process.env.GITHUB_WORKSPACE;
if (!workspace) fail('GITHUB_WORKSPACE is not set');
const outputDir = resolve(workspace, '.local', 'sdk-artifacts', `${tag}-${sdkCommit}`);
const temporaryDir = join(tmpdir(), `xynolog-sdk-${process.pid}`);
const archive = join(temporaryDir, `xynolog-sdk-artifacts-${tag}.tar.gz`);
mkdirSync(temporaryDir, { recursive: true });
mkdirSync(outputDir, { recursive: true });

try {
  const url = `https://github.com/xynolog/sdk/releases/download/${tag}/xynolog-sdk-artifacts-${tag}.tar.gz`;
  execFileSync('curl', ['--fail', '--location', '--silent', '--show-error', url, '--output', archive], { stdio: 'inherit' });
  const actualArchiveSha256 = hash(readFileSync(archive));
  if (actualArchiveSha256 !== archiveSha256) fail(`Bundle archive checksum mismatch: expected ${archiveSha256}, got ${actualArchiveSha256}`);
  execFileSync('tar', ['-xzf', archive, '-C', outputDir], { stdio: 'inherit' });

  const bundle = outputDir;
  const manifest = JSON.parse(readFileSync(join(bundle, 'artifacts.json'), 'utf8'));
  if (manifest.schema !== 'xynolog-sdk-artifacts/v2') fail(`Unsupported bundle schema: ${manifest.schema}`);
  if (manifest.sdk.commit !== sdkCommit) fail(`SDK commit mismatch: expected ${sdkCommit}, got ${manifest.sdk.commit}`);
  if (manifest.protocol.commit !== protocolCommit) fail(`Protocol commit mismatch: expected ${protocolCommit}, got ${manifest.protocol.commit}`);
  for (const language of languages) {
    if (!manifest.languages.includes(language)) fail(`Bundle does not contain required language: ${language}`);
  }
  for (const artifact of manifest.artifacts) {
    const path = resolve(bundle, artifact.path);
    if (!path.startsWith(`${bundle}${sep}`)) fail(`Unsafe artifact path in manifest: ${artifact.path}`);
    const actual = hash(readFileSync(path));
    if (actual !== artifact.sha256) fail(`Artifact checksum mismatch: ${artifact.path}`);
  }
  if (!process.env.GITHUB_OUTPUT) fail('GITHUB_OUTPUT is not set');
  appendFileSync(process.env.GITHUB_OUTPUT, `path=${bundle}\n`);
  console.log(`Verified Xynolog SDK bundle ${tag} at ${bundle}`);
} finally {
  rmSync(temporaryDir, { recursive: true, force: true });
}

/**
 * @param {string} name
 * @returns {string}
 */
function required(name) {
  const value = process.env[name];
  if (!value) fail(`${name} is required`);
  return value;
}

/** @param {Buffer} value */
function hash(value) {
  return createHash('sha256').update(value).digest('hex');
}

/**
 * @param {string} message
 * @returns {never}
 */
function fail(message) {
  console.error(message);
  process.exit(1);
}
