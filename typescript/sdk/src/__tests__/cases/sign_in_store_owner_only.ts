// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/sign-in-store/owner-only.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export type DirectoryMode = {
  value: string;
  docs: string;
};

export type DirectoryAccessList = {
  value: string;
  docs: string;
};

export type Table = {
  $comment: string;
  directoryMode: DirectoryMode;
  fileMode: DirectoryMode;
  directoryAccessList: DirectoryAccessList;
  fileAccessList: DirectoryAccessList;
};

export const table: Table = {
  "$comment": "AUTHORITY for how a writer of tokens.json keeps <stateDir> and its files to its owner (README.md, Where it is), and how the launcher keeps its state home and its own files there: a mode and an access list for a directory, and a mode and an access list for a file, which every writer gives what it makes. A mode or a list restated in each language is one that differs in one of them unseen. Go: the consumer-owned generator writes sdk/go/owneronly_gen.go and the launcher's cli/internal/launcher/owneronly_gen.go. Python: the consumer-owned generator writes sdk/python/sdk/src/xynolog/_owner_only_table.py. Rust: the consumer-owned generator writes sdk/rust/sdk/src/generated/owner_only.rs. Kotlin: the consumer-owned generator writes sdk/kotlin/sdk/src/generated/kotlin/xynolog/signin/OwnerOnlyTable.kt. Swift: the consumer-owned generator writes sdk/swift/sdk/Sources/Xynolog/Generated/Models.swift. C#: the consumer-owned generator writes sdk/csharp/sdk/src/Xynolog/Generated/ProtocolTables.g.cs. TypeScript: the consumer-owned generator writes @xynolog/core's src/sign-in.ts. Haskell: the consumer-owned generator writes sdk/haskell/sdk/generated/Xynolog/Internal/Generated/xynolog_store_policy.h. OCaml: the consumer-owned generator writes sdk/ocaml/sdk/lib/store_policy.ml and its storage probe's sdk/ocaml/sdk/probes/store_policy.ml.",
  "directoryMode": {
    "value": "0700",
    "docs": "The directory's mode, in octal, on a system that has modes: its owner reads, writes and enters it, and nobody else does."
  },
  "fileMode": {
    "value": "0600",
    "docs": "The mode, in octal, on a system that has modes, that a writer makes tokens.json's temporary file and its lock with, and the launcher its own files in its state home: its owner reads and writes each, and nobody else does."
  },
  "directoryAccessList": {
    "value": "D:PAI(A;OICI;FA;;;{owner})(A;OICI;FA;;;SY)(A;OICI;FA;;;BA)",
    "docs": "The directory's access list on Windows, where a mode keeps nobody out, in SDDL, with `{owner}` where the SID of the user the writer runs as goes (its process token's user): full access for that user, the system and the administrators, and nobody else. It is handed down to everything made in the directory, and protected, so nothing is inherited from above."
  },
  "fileAccessList": {
    "value": "D:PAI(A;;FA;;;{owner})(A;;FA;;;SY)(A;;FA;;;BA)",
    "docs": "A file's access list on Windows, which the launcher gives each file it keeps to its owner, in SDDL, with `{owner}` where the SID of the user it runs as goes: the directory's list, with nothing handed down, since a file has nothing beneath it. Full access for that user, the system and the administrators, and nobody else, protected, so nothing is inherited from above."
  }
};
