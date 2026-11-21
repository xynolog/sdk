"""Exercise compiler inventory and type refusals; this is not a surface-completeness gate."""

import json
import subprocess
import tempfile
from pathlib import Path
from typing import TypedDict

root = Path(__file__).resolve().parents[1]


class Inventory(TypedDict):
    """What probes/api_inventory.exe prints for one compiled interface, as far as this reads it."""

    entries: list[dict[str, object]]


def run(*args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(args, cwd=root, text=True, capture_output=True)


def checked(*args: str) -> str:
    result = run(*args)
    if result.returncode:
        raise RuntimeError(result.stderr)
    return result.stdout


checked("dune", "build", "@install", "probes/api_inventory.exe")
installed = root / "_build/install/default/lib/xynolog"
inventory = root / "_build/default/probes/api_inventory.exe"


def inspect(path: Path, includes: list[Path]) -> Inventory:
    inspected: Inventory = json.loads(checked(str(inventory), str(path), *map(str, includes)))
    return inspected


sdk = inspect(installed / "xynolog.cmi", [installed])
assert sdk == inspect(installed / "xynolog.cmi", [installed]), "inventory is not deterministic"
sdk_entries = {entry["path"]: entry for entry in sdk["entries"]}
assert sdk_entries["Xynolog.Identifiers.Resource_id.t"]["representation"] == "abstract"
assert "Xynolog.Pattern" not in sdk_entries

source = """
module Id : sig type t val parse : string -> t end
module Alias = Id
include sig val included : string end
module Nested : sig
  type phase = Open | Closed
  type state = { count : int; phase : phase }
  type event = Idle | Progress of { completed : int } | Failure of string
  type resource
  type annotation
  type 's scope
  type (_, _) op = Read : (resource, string) op | Write : (annotation, int) op
  val resource_scope : resource scope
  val annotation_scope : annotation scope
  val run : 's scope -> ('s, 'a) op -> 'a
end
module type Input = sig type t val value : t end
module Make (X : Input) : sig val value : X.t end
"""
with tempfile.TemporaryDirectory() as temporary:
    directory = Path(temporary)
    interface = directory / "probe_surface.mli"

    def build(contents: str) -> Inventory:
        interface.write_text(contents)
        checked("dune", "exec", "--", "ocamlc", "-color", "never", "-c", str(interface))
        return inspect(interface.with_suffix(".cmi"), [directory])

    baseline = build(source)
    entries = {entry["path"]: entry for entry in baseline["entries"]}
    assert entries["Probe_surface.Alias.t"]["representation"] == "abstract"
    assert entries["Probe_surface.Alias.parse"]["kind"] == "value"
    assert entries["Probe_surface.included"]["kind"] == "value"
    assert entries["Probe_surface.Nested.state"]["fields"] == ["count", "phase"]
    assert entries["Probe_surface.Nested.op"]["constructors"] == ["Read", "Write"]
    assert entries["Probe_surface.Nested.event"]["variants"] == [
        {"name": "Idle", "fields": [], "unit": True},
        {"name": "Progress", "fields": ["completed"], "unit": False},
        {"name": "Failure", "fields": [], "unit": False},
    ]
    declaration = entries["Probe_surface.Make.result.value"]["declaration"]
    assert isinstance(declaration, str)
    assert "X.t" in declaration

    mutations = {
        "missing member": source.replace("val included : string", ""),
        "extra export": source + "\nval surprise : int\n",
        "renamed field": source.replace("count : int", "renamed : int"),
        "extra enum case": source.replace("Open | Closed", "Open | Closed | Unknown"),
        "duplicate alias": source + "\nmodule Duplicate = Id\n",
        "revealed constructor": source.replace("sig type t val parse", "sig type t = Exposed of string val parse"),
    }
    for name, changed in mutations.items():
        assert build(changed) != baseline, f"inventory missed {name}"
        print(f"compiler inventory detects {name}")
    assert build(source) == baseline

    def consume(name: str, contents: str) -> subprocess.CompletedProcess[str]:
        path = directory / (name + ".ml")
        path.write_text(contents)
        return run("dune", "exec", "--", "ocamlc", "-color", "never", "-I", str(directory), "-c", str(path))

    valid = consume(
        "valid",
        """
open Probe_surface.Nested
let text : string = run resource_scope Read
let number : int = run annotation_scope Write
""",
    )
    assert valid.returncode == 0, valid.stderr
    for name, contents in {
        "wrong_scope": "open Probe_surface.Nested\nlet text = run annotation_scope Read",
        "wrong_result": "open Probe_surface.Nested\nlet number : int = run resource_scope Read",
        "unchecked_scope": "open Probe_surface.Nested\nlet scope : resource scope = ()",
    }.items():
        refused = consume(name, contents)
        assert refused.returncode != 0, f"{name}: {refused.stderr}"
        assert "Error:" in refused.stderr, f"{name}: {refused.stderr}"
        print(f"GADT consumer refuses {name}")
print(f"installed compiler inventory: {len(sdk_entries)} reachable entries")
