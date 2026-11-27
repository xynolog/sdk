// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/sign-in-store (SignIn.json, owner-only.json, README.md)
// Regenerate:  make generate  (codegen/lib/sign_in/sign_in.ml)

/** One sign-in to a running stack's knowledge base, as the sign-in store keeps it: the tokens an issuer issued to the script client, and what a renewal and a sign-out need of that issuer, learned once at sign-in. TOKENS, never a password. An entry of <stateDir>/tokens.json (see README.md). */
export interface SignIn {
  /** The access token: short-lived, sent as a Bearer token. */
  token: string;
  /** The refresh token: long-lived, and what renews the access token at the issuer without another sign-in. An entry with none cannot be renewed. */
  refreshToken?: string;
  /** Who signed in: the address the access token named when the sign-in was made, which is the one the gateway answers for it. For display. Absent when the token named none. A writer that renews an entry keeps it as it was. */
  email?: string;
  /** When the access token was issued to this machine, RFC 3339 in UTC. */
  obtainedAt: string;
  /** When the access token stops working, RFC 3339 in UTC, so a reader can renew before sending a token it knows is dead. Absent when the issuer named no lifetime: the gateway's refusal is then the signal. */
  expiresAt?: string;
  /** The issuer the sign-in came from: the one the access token named when the sign-in was made. A writer that renews an entry keeps it. */
  issuer: string;
  /** The issuer's token endpoint, where the refresh grant is made. */
  tokenEndpoint: string;
  /** The issuer's revocation endpoint (RFC 7009), where a sign-out tells it to forget the refresh token. Absent when the issuer has none. */
  revocationEndpoint?: string;
}

/** The directory's mode, in octal, on a system that has modes: its owner reads, writes and enters it, and nobody else does. */
export const OWNER_ONLY_DIRECTORY_MODE = 0o700;

/** The mode, in octal, on a system that has modes, that a writer makes tokens.json's temporary file and its lock with, and the launcher its own files in its state home: its owner reads and writes each, and nobody else does. */
export const OWNER_ONLY_FILE_MODE = 0o600;

/** The directory's access list on Windows, where a mode keeps nobody out, in SDDL, with `owner` where the SID of the user the writer runs as goes (its process token's user): full access for that user, the system and the administrators, and nobody else. It is handed down to everything made in the directory, and protected, so nothing is inherited from above. */
export function ownerOnlyDirectoryAccessList(owner: string): string {
  return 'D:PAI(A;OICI;FA;;;' + owner + ')(A;OICI;FA;;;SY)(A;OICI;FA;;;BA)';
}

/** A file's access list on Windows, which the launcher gives each file it keeps to its owner, in SDDL, with `owner` where the SID of the user it runs as goes: the directory's list, with nothing handed down, since a file has nothing beneath it. Full access for that user, the system and the administrators, and nobody else, protected, so nothing is inherited from above. */
export function ownerOnlyFileAccessList(owner: string): string {
  return 'D:PAI(A;;FA;;;' + owner + ')(A;;FA;;;SY)(A;;FA;;;BA)';
}

/** The document's name in the state home: one sign-in per stack. */
export const SIGN_IN_STORE_FILE = 'tokens.json';

/** The name, beside the document, of the file every writer locks from before its read until after its rename. */
export const SIGN_IN_STORE_LOCK = 'tokens.lock';

/** On Windows, the high 32 bits of the offset of the one byte of the lock file that is locked: far past anything the file holds. */
export const SIGN_IN_STORE_WINDOWS_OFFSET_HIGH = 0x40000000;
