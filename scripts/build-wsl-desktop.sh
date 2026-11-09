#!/usr/bin/env bash
# One-command WSL build: compile the ARMHF runtime, create a game-free HOME ZIP,
# verify it, and copy the ZIP plus SHA-256 file to the Windows Desktop.
set -Eeuo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT"

echo "== Checking WSL / Docker prerequisites"
command -v docker >/dev/null || { echo "ERROR: Docker CLI not found in WSL." >&2; exit 1; }
docker info >/dev/null 2>&1 || {
  echo "ERROR: Docker Engine is not running or not accessible from WSL." >&2
  exit 1
}
docker image inspect goodluck-dev >/dev/null 2>&1 || {
  echo "ERROR: Docker image 'goodluck-dev' is missing. The Stardew Dockerfile uses it as its base image." >&2
  echo "Build/restore your existing goodluck-dev image first; this script will not guess its source." >&2
  exit 1
}
for cmd in zip unzip sha256sum; do
  command -v "$cmd" >/dev/null || { echo "ERROR: missing WSL command: $cmd" >&2; exit 1; }
done
command -v powershell.exe >/dev/null || {
  echo "ERROR: powershell.exe is unavailable. Enable WSL Windows interop to locate Desktop." >&2
  exit 1
}

WIN_DESKTOP=$(powershell.exe -NoProfile -Command '[Environment]::GetFolderPath("Desktop")' | tr -d '\r')
[ -n "$WIN_DESKTOP" ] || { echo "ERROR: Could not resolve Windows Desktop." >&2; exit 1; }
DESKTOP=$(wslpath -u "$WIN_DESKTOP")
mkdir -p "$DESKTOP"

echo "== Building ARMHF Stardew runtime (no game files)"
JOBS="${JOBS:-2}" bash "$ROOT/dev/stardew/build.sh"

BUILT="$ROOT/dev/out/stardew/stardewvalley"
[ -x "$BUILT/mono/bin/mono" ] || { echo "ERROR: build output is incomplete: $BUILT" >&2; exit 1; }

ZIP="$DESKTOP/Stardew-goodluckOS-device-test.zip"
echo "== Creating clean HOME archive"
bash "$ROOT/scripts/make-release.sh" "$BUILT" "$ZIP"

echo "== Verifying archive and checksum"
unzip -t "$ZIP"
(
  cd "$DESKTOP"
  sha256sum -c "$(basename "$ZIP").sha256"
)

echo
echo "SUCCESS"
echo "ZIP:      $ZIP"
echo "SHA-256:  $ZIP.sha256"
echo
echo "This archive contains the ARMHF runtime and a 'Stardew Runtime Test' Puppy entry."
echo "It deliberately does NOT contain Stardew Valley game files."
echo "Install into the HOME partition, then launch 'Stardew Runtime Test' first."
