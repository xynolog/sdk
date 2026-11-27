# Generated from protocol/specs/src/client/surface.json; do not edit.
# Regenerate: make generate (codegen/lib/discovery_url_path.ml)
# ruff: noqa: E501, I001, RUF002, RUF022, RUF100

"""Where a launcher's discovery document is."""

from typing import Final

__all__ = ["DISCOVERY_URL_PATH"]

# Where a launcher's discovery document is: its path under the state home, and the URL path a
# browser fetches it at.
DISCOVERY_URL_PATH: Final = "/discovery/kbs.json"
