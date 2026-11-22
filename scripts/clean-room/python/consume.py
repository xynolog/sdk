"""The installed distribution is the bundle's, and its client imports."""

import os
from importlib.metadata import version

from xynolog.client import XynologClient

installed = version("xynolog")
if installed != os.environ["VERSION"]:
    raise SystemExit(f"installed xynolog {installed}, not {os.environ['VERSION']}")
print(f"xynolog {installed}: {XynologClient.__name__}")
