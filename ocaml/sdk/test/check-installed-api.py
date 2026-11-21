"""Compile consumers against the installed interfaces, outside the library."""

import argparse
import subprocess
import tempfile
from pathlib import Path

root = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument("--installed", type=Path)
options = parser.parse_args()
if options.installed is None:
    subprocess.run(["dune", "build", "@opam", "@install"], cwd=root, check=True)
    interface = root / "_build/install/default/lib/xynolog"
    compiler = ["dune", "exec", "--", "ocamlc"]
else:
    interface = options.installed
    compiler = ["ocamlc"]
with tempfile.TemporaryDirectory() as temporary:
    directory = Path(temporary)

    def compile_consumer(name: str, source: str) -> subprocess.CompletedProcess[str]:
        path = directory / (name + ".ml")
        path.write_text(source)
        return subprocess.run(
            [*compiler, "-color", "never", "-I", str(interface), "-c", str(path)], cwd=root, text=True, capture_output=True
        )

    valid = compile_consumer(
        "valid",
        """
module I = Xynolog.Identifiers
let resource : I.Resource_id.t = Result.get_ok (I.Resource_id.of_string "resource-1")
let text = I.Resource_id.to_string resource
module B = Xynolog.Bus_registry
let reply : _ B.channel = B.result B.Operations.browse_resource_requested
let user : I.User_id.t = Result.get_ok (I.User_id.of_string "did:web:example:alice")
""",
    )
    if valid.returncode:
        raise SystemExit(valid.stderr)

    for name, source, diagnostic in [
        ("unchecked", 'let id : Xynolog.Identifiers.Resource_id.t = "unchecked"', "string"),
        (
            "wrong_kind",
            """
let annotation = Result.get_ok (Xynolog.Identifiers.Annotation_id.of_string "a")
let resource : Xynolog.Identifiers.Resource_id.t = annotation
""",
            "Annotation_id.t",
        ),
        (
            "wrong_operation_channel",
            """
module B = Xynolog.Bus_registry
let same_payload (left : 'a B.channel) (right : 'a B.channel) = ()
let () =
  same_payload (B.request B.Operations.browse_resource_requested)
    (B.result B.Operations.browse_resource_requested)
""",
            "channel",
        ),
        ("private_pattern", "let matches = Xynolog.Pattern.matches", "Unbound module"),
        ("private_compilation_unit", "let matches = Xynolog__Pattern.matches", "Unbound module"),
    ]:
        refused = compile_consumer(name, source)
        if refused.returncode == 0 or diagnostic not in refused.stderr:
            raise SystemExit(f"{name}: expected interface refusal, got {refused.stderr}")
        print(f"{name}: refused by installed interface")
print("installed consumer: accepted")
