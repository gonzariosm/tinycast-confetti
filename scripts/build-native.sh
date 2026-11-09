#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
build_dir=$(mktemp -d)
trap 'rm -rf "$build_dir"' EXIT
for arch in arm64 x86_64; do
  xcrun swiftc -O -swift-version 6 -target "$arch-apple-macosx13.0" \
    -file-prefix-map "$PWD"=. -debug-prefix-map "$PWD"=. \
    native/Confetti.swift -o "$build_dir/confetti-$arch"
done
xcrun lipo -create "$build_dir/confetti-arm64" "$build_dir/confetti-x86_64" \
  -output assets/confetti
codesign --force --sign - assets/confetti
codesign --verify --strict assets/confetti
lipo -info assets/confetti
