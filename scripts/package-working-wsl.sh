#!/usr/bin/env bash
# Package the EXISTING working port from a mounted HOME SD-card partition.
# This deliberately does not rebuild, replace, or modify the source installation.
set -Eeuo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT"

fail() { echo "ERROR: $*" >&2; exit 1; }

for cmd in zip unzip sha256sum powershell.exe wslpath; do
  command -v "$cmd" >/dev/null 2>&1 || fail "missing command: $cmd"
done

if [ "$#" -gt 1 ]; then
  fail "Usage: bash scripts/package-working-wsl.sh [path-to-ports/stardewvalley]"
fi

SOURCE=""
if [ "$#" -eq 1 ]; then
  SOURCE=${1%/}
  [ -f "$SOURCE/stardew.sh" ] || fail "stardew.sh not found in: $SOURCE"
else
  CANDIDATES=()
  for drive in /mnt/[d-z]; do
    [ -d "$drive" ] || continue
    for candidate in "$drive/ports/stardewvalley" "$drive/HOME/ports/stardewvalley"; do
      [ -f "$candidate/stardew.sh" ] && CANDIDATES+=("$candidate")
    done
  done
  if [ "${#CANDIDATES[@]}" -gt 0 ]; then
    mapfile -t CANDIDATES < <(printf '%s\n' "${CANDIDATES[@]}" | sort -u)
  fi
  case "${#CANDIDATES[@]}" in
    0)
      fail "No working Stardew port found. Insert the device SD card in a card reader and make its HOME partition appear as a Windows drive, then run this command again. Or pass the exact port folder as an argument."
      ;;
    1) SOURCE=${CANDIDATES[0]} ;;
    *)
      echo "More than one Stardew installation was found:"
      select choice in "${CANDIDATES[@]}"; do
        [ -n "${choice:-}" ] || { echo "Choose a number."; continue; }
        SOURCE=$choice
        break
      done
      ;;
  esac
fi

SOURCE=$(cd "$SOURCE" && pwd)
[ -f "$SOURCE/mono/bin/mono" ] || fail "Mono runtime missing: $SOURCE/mono/bin/mono"
[ -f "$SOURCE/stardew.sh" ] || fail "launcher missing"
[ -f "$SOURCE/dlls/MonoGame.Framework.dll" ] || fail "MonoGame runtime missing"
[ -f "$SOURCE/gl4es/libGL.so.1" ] || fail "GL4ES libGL missing"
[ -f "$SOURCE/gl4es/libEGL.so.1" ] || fail "GL4ES libEGL missing"
[ -f "$SOURCE/lib/libopenal.so.1" ] || fail "OpenAL library missing"
[ -f "$SOURCE/lib/liblwjgl_lz4.so" ] || fail "LZ4 shim missing"

WIN_DESKTOP=$(powershell.exe -NoProfile -Command '[Environment]::GetFolderPath("Desktop")' | tr -d '\r')
[ -n "$WIN_DESKTOP" ] || fail "Could not resolve Windows Desktop"
DESKTOP=$(wslpath -u "$WIN_DESKTOP")
mkdir -p "$DESKTOP"

STAGE=$(mktemp -d)
trap 'rm -rf "$STAGE"' EXIT
mkdir -p "$STAGE/ports" "$STAGE/.local/share/applications"
PORT="$STAGE/ports/stardewvalley"

echo "Working copy: $SOURCE"
echo "Copying the existing runtime; no compilation will be performed."
cp -a "$SOURCE" "$PORT"

# Keep the user's game, generated icon, saves, and local settings on their original HOME.
# They are not copied into this transport ZIP. Extracting the archive over that same HOME
# merges the runtime update and leaves the existing gamedata directory in place.
rm -rf "$PORT/gamedata" "$PORT/Saves" "$PORT/logs"
rm -f "$PORT/icon.png" "$PORT/.language" "$PORT/env"
mkdir -p "$PORT/gamedata"
cp "$ROOT/release-template/ports/stardewvalley/gamedata/README-OWN-GAME-FILES.txt" "$PORT/gamedata/"

for notice in LICENSE.GL4ES.txt LICENSE.Mono.txt LICENSE.MonoGame.txt LICENSE.Patch.txt \
              LICENSE_lwjgl.txt LICENSE_lz4.txt LICENSE.OpenAL.txt PATENTS.TXT; do
  cp "$ROOT/LICENSES/$notice" "$PORT/$notice"
done
cp "$ROOT/THIRD_PARTY_NOTICES.md" "$STAGE/"
cp "$ROOT/LICENSE" "$STAGE/"
cp "$ROOT/README.md" "$STAGE/PROJECT-README.md"
cp "$ROOT/INSTALL-TR.md" "$STAGE/"

cp "$ROOT/release-template/.local/share/applications/stardew.puppy" \
   "$STAGE/.local/share/applications/stardew.puppy"

for required in \
  "$PORT/mono/bin/mono" "$PORT/dlls/MonoGame.Framework.dll" \
  "$PORT/gl4es/libGL.so.1" "$PORT/gl4es/libEGL.so.1" \
  "$PORT/lib/libopenal.so.1" "$PORT/lib/liblwjgl_lz4.so" \
  "$PORT/gamedata/README-OWN-GAME-FILES.txt"; do
  [ -e "$required" ] || fail "staged package missing: ${required#$STAGE/}"
done
[ ! -e "$PORT/icon.png" ] || fail "game-generated icon was not removed"
[ ! -d "$PORT/Saves" ] || fail "port-local Saves directory was not removed"
[ ! -e "$PORT/env" ] || fail "local environment overrides were not removed"
if find "$PORT/gamedata" -type f ! -name README-OWN-GAME-FILES.txt -print -quit | grep -q .; then
  fail "game data remains in staged gamedata"
fi

ZIP="$DESKTOP/Stardew-goodluckOS-working-port-test.zip"
rm -f "$ZIP" "$ZIP.sha256"
(
  cd "$STAGE"
  zip -qr "$ZIP" .
)
unzip -t "$ZIP" >/dev/null
(
  cd "$DESKTOP"
  sha256sum "$(basename "$ZIP")" > "$(basename "$ZIP").sha256"
  sha256sum -c "$(basename "$ZIP").sha256"
)

echo
echo "SUCCESS"
echo "ZIP:     $ZIP"
echo "SHA-256: $ZIP.sha256"
echo
echo "This ZIP was made from the existing working runtime; it was NOT rebuilt."
echo "It excludes gamedata, icon, saves, logs, and local overrides."
echo "To test on the same SD card, extract into its HOME root and MERGE folders."
echo "Do NOT format the card or delete the existing HOME/ports/stardewvalley/gamedata folder."
