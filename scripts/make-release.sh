#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <built-port-directory> <output-zip>" >&2
  exit 2
fi
ROOT=$(cd "$(dirname "$0")/.." && pwd)
BUILT=$(cd "$1" && pwd)
OUT=$2
case "$OUT" in /*) ;; *) OUT="$ROOT/$OUT" ;; esac
OUT=$(dirname "$OUT")/$(basename "$OUT")
STAGE=$(mktemp -d)
trap 'rm -rf "$STAGE"' EXIT

mkdir -p "$STAGE/ports"
cp -a "$BUILT" "$STAGE/ports/stardewvalley"
PORT="$STAGE/ports/stardewvalley"

# Never ship user game data, game-generated icon, or local-only settings.
rm -rf "$PORT/gamedata" "$PORT/icon.png" "$PORT/Saves" "$PORT/logs"
rm -f "$PORT/.language" "$PORT/env"
mkdir -p "$PORT/gamedata" "$STAGE/.local/share/applications"
cp "$ROOT/release-template/ports/stardewvalley/gamedata/README-OWN-GAME-FILES.txt" "$PORT/gamedata/"
cp "$ROOT/release-template/.local/share/applications/stardew.puppy" "$STAGE/.local/share/applications/"
cp "$ROOT/THIRD_PARTY_NOTICES.md" "$STAGE/"
cp "$ROOT/LICENSE" "$STAGE/LICENSE"
cp "$ROOT/README.md" "$STAGE/PROJECT-README.md"
cp "$ROOT/INSTALL-TR.md" "$STAGE/INSTALL-TR.md"

# Copy the reviewed, pinned notices beside the binaries. OpenAL is then
# independently verified against the hash-pinned source archive below.
for notice in LICENSE.GL4ES.txt LICENSE.Mono.txt LICENSE.MonoGame.txt LICENSE.Patch.txt \
              LICENSE_lwjgl.txt LICENSE_lz4.txt LICENSE.OpenAL.txt PATENTS.TXT; do
  cp "$ROOT/LICENSES/$notice" "$PORT/$notice"
done

# Include the exact OpenAL source archive and verify that its COPYING matches.
bash "$ROOT/scripts/fetch-openal-license.sh" "$PORT" "$STAGE/THIRD_PARTY_SOURCE" "$ROOT/LICENSES"

bash "$ROOT/scripts/audit-release.sh" "$STAGE"

mkdir -p "$(dirname "$OUT")"
rm -f "$OUT" "$OUT.sha256"
(
  cd "$STAGE"
  zip -qr "$OUT" .
)
sha256sum "$OUT" > "$OUT.sha256"
echo "Created: $OUT"
echo "Checksum: $OUT.sha256"
