#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
REPO=https://github.com/alvesmaicon/goodluckOS.git
COMMIT=b7a3ca2d1de2077557760e05655cb555ea35b98d
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

if [ -e "$ROOT/dev/stardew" ]; then
  echo "Refusing to overwrite existing dev/stardew. Move or back it up first." >&2
  exit 1
fi

git clone --filter=blob:none --no-checkout "$REPO" "$TMP/goodluckOS"
git -C "$TMP/goodluckOS" checkout --detach "$COMMIT"

mkdir -p "$ROOT/dev"
cp -a "$TMP/goodluckOS/dev/stardew" "$ROOT/dev/stardew"
cp "$TMP/goodluckOS/dev/README.md" "$ROOT/dev/README-upstream.md"

cat > "$ROOT/dev/UPSTREAM-REVISION.txt" <<EOF
Repository: alvesmaicon/goodluckOS
Commit: $COMMIT
Imported: dev/stardew/ and dev/README.md (renamed dev/README-upstream.md)
EOF

echo "Imported alvesmaicon/goodluckOS at $COMMIT."
echo "Review the imported source and license requirements before building or releasing."
