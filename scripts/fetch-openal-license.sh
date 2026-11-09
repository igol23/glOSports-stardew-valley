#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  echo "Usage: $0 <port-directory> <third-party-source-directory> [repository-LICENSES-directory]" >&2
  exit 2
fi
PORT=$(cd "$1" && pwd)
SOURCE_DIR=$2
mkdir -p "$SOURCE_DIR"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
URL=https://github.com/kcat/openal-soft/archive/refs/tags/1.25.2.tar.gz
SHA=fb27e5839aa11f0e5b9d33756965291fad5d6909ab928ea1f796f4a1a6877894

curl -fsSL "$URL" -o "$TMP/openal-soft-1.25.2.tar.gz"
printf '%s  %s\n' "$SHA" "$TMP/openal-soft-1.25.2.tar.gz" | sha256sum -c -
cp "$TMP/openal-soft-1.25.2.tar.gz" "$SOURCE_DIR/openal-soft-1.25.2-source.tar.gz"
tar -xOzf "$TMP/openal-soft-1.25.2.tar.gz" --wildcards '*/COPYING' > "$PORT/LICENSE.OpenAL.txt"
[ -s "$PORT/LICENSE.OpenAL.txt" ] || { echo "Extracted OpenAL COPYING is empty" >&2; exit 1; }
if [ "$#" -eq 3 ]; then
  mkdir -p "$3"
  cp "$PORT/LICENSE.OpenAL.txt" "$3/OpenAL-Soft-COPYING.txt"
fi
echo "Added verified OpenAL Soft 1.25.2 COPYING and corresponding source archive."
