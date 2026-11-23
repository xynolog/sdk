#!/bin/sh
# Export the compiled test libraries, without SwiftPM's dependency-sized JSON report.
set -eu
bin=$(swift build --force-resolved-versions --show-bin-path)
llvm-profdata merge -sparse .build/unit-profiles/*.profraw -o .build/unit-profiles/default.profdata
set --
for product in "$bin/"*Tests.so; do
  test -f "$product"
  set -- "$@" -object "$product"
done
test "$#" -gt 0
# The build directory, dependencies' checkouts among it, by the path its
# sources are compiled from: .build may be a link (scripts/make-target.sh).
build=$(cd .build && pwd -P)
llvm-cov export -format=lcov -instr-profile=.build/unit-profiles/default.profdata "$@" \
  -ignore-filename-regex="(/Tests/|/\.build/|^$build/|/Generated/)" > .build/coverage.lcov
test -s .build/coverage.lcov
