#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <staged-HOME-directory>" >&2
  exit 2
fi
ROOT=$(cd "$1" && pwd)
PORT="$ROOT/ports/stardewvalley"
ERRORS=0

fail() { echo "BLOCK: $*" >&2; ERRORS=$((ERRORS + 1)); }
need() { [ -e "$1" ] || fail "missing required file: ${1#$ROOT/}"; }

need "$ROOT/.local/share/applications/stardew.puppy"
need "$PORT/stardew.sh"
need "$PORT/mono/bin/mono"
need "$PORT/dlls/MonoGame.Framework.dll"
need "$PORT/gl4es/libGL.so.1"
need "$PORT/gl4es/libEGL.so.1"
need "$PORT/lib/libopenal.so.1"
need "$PORT/lib/liblwjgl_lz4.so"

for f in LICENSE.GL4ES.txt LICENSE.Mono.txt LICENSE.MonoGame.txt LICENSE.Patch.txt \
         LICENSE_lwjgl.txt LICENSE_lz4.txt LICENSE.OpenAL.txt PATENTS.TXT; do
  need "$PORT/$f"
done
need "$ROOT/THIRD_PARTY_NOTICES.md"
OPENAL_SRC="$ROOT/THIRD_PARTY_SOURCE/openal-soft-1.25.2-source.tar.gz"
need "$OPENAL_SRC"
if [ -f "$OPENAL_SRC" ]; then
  expected=fb27e5839aa11f0e5b9d33756965291fad5d6909ab928ea1f796f4a1a6877894
  actual=$(sha256sum "$OPENAL_SRC" | awk '{print $1}')
  [ "$actual" = "$expected" ] || fail "OpenAL source archive SHA-256 mismatch"
  if [ -f "$PORT/LICENSE.OpenAL.txt" ]; then
    tmp_license=$(mktemp)
    if tar -xOzf "$OPENAL_SRC" --wildcards '*/COPYING' > "$tmp_license"; then
      cmp -s "$tmp_license" "$PORT/LICENSE.OpenAL.txt" || fail "OpenAL notice does not match pinned source COPYING"
    else
      fail "could not extract OpenAL COPYING from source archive"
    fi
    rm -f "$tmp_license"
  fi
fi

if [ -d "$PORT/gamedata" ]; then
  while IFS= read -r -d '' f; do
    rel=${f#"$PORT/gamedata/"}
    [ "$rel" = "README-OWN-GAME-FILES.txt" ] || fail "unreviewed file under gamedata/: $rel"
  done < <(find "$PORT/gamedata" -type f -print0)
fi

while IFS= read -r -d '' f; do
  base=${f##*/}
  case "$base" in
    StardewValley.exe|"Stardew Valley.exe"|Wave\ Bank*.xwb|*.xnb|StardewValley.GameData.dll|StardewValley.XmlSerializers*.dll|*.sav|SaveGameInfo)
      fail "possible proprietary game or personal data: ${f#$ROOT/}" ;;
  esac
done < <(find "$ROOT" -type f -print0)

[ ! -e "$PORT/icon.png" ] || fail "icon.png may be generated from user's game; do not ship it"
[ ! -d "$PORT/Saves" ] || fail "Saves directory found"
[ ! -e "$PORT/env" ] || fail "local env overrides found"

if [ "$ERRORS" -ne 0 ]; then
  echo "Release audit failed: $ERRORS blocking issue(s)." >&2
  exit 1
fi

echo "Release audit passed: required runtime and notices are present; no known game data or user saves found."
echo "This audit checks file layout; it is not a legal opinion or substitute for component license review."
