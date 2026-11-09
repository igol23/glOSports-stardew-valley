# Building the port

The build workflow is based on the pinned `dev/stardew/build.sh` from alvesmaicon's GoodLuckOS repository. The imported source revision is recorded in `dev/UPSTREAM-REVISION.txt`.

## Prerequisites

- Linux or WSL2 with Docker Engine available.
- Internet access for pinned upstream source and package downloads.
- A legally obtained Stardew Valley Compatibility game directory for game-specific build steps.
- Enough free disk space for cross-compilation sources, Debian ARMHF packages, and the Docker build volume.

## Source import

For a fresh checkout only, run `bash scripts/import-upstream.sh`. It imports the pinned GoodLuckOS source and refuses to overwrite an existing `dev/stardew/` directory. The imported GoodLuckOS source is pinned to commit `b7a3ca2d1de2077557760e05655cb555ea35b98d`. This repository already contains that import; do not rerun it over the existing source directory.

## Build

Set `SDV_GAME` to the directory containing your own compatible game files. The upstream script documents a layout containing `StardewValley.exe` and `Content/`.

```sh
export SDV_GAME="/path/to/your/Stardew Valley game folder"
bash dev/stardew/build.sh          # ARMHF port runtime + project helpers
bash dev/stardew/build.sh game     # prepares your own gamedata; never commit this output
bash dev/stardew/build.sh xmlgen   # builds save serializers from your own game files
```

The build output is under `dev/out/stardew/` and is ignored by Git. It is not a public game-data directory. The build copies the OpenAL Soft `COPYING` notice from the already hash-verified source tree. It also places Debian package `copyright` metadata for the extracted Mono packages under `mono/share/doc/`. The pinned third-party notices in `LICENSES/` are copied beside the generated runtime. When assembling a release from an already-built working runtime, the release helper copies those notices and independently verifies OpenAL against the hash-pinned 1.25.2 source archive.

## Important distinctions

- The maintainer's current installed port is already reported working. Do not replace it just to run a clean build.
- `build.sh game` copies proprietary files from the path supplied in `SDV_GAME`; all output from this command must remain local.
- `build.sh xmlgen` creates serializers specific to the game assemblies. Treat those outputs as game-derived and keep them out of the public repository and release archive unless their redistribution status has been explicitly cleared.
- A build succeeding on the PC does not prove runtime compatibility on the handheld.

## Package the existing working device installation from WSL

Do not rebuild the runtime just to make a transport ZIP. Insert the device's SD card into a card reader so its HOME partition appears as a Windows drive, then run:

```sh
if [ -d "$HOME/stardew-device-test/.git" ]; then git -C "$HOME/stardew-device-test" pull --ff-only; else git clone https://github.com/igol23/glOSports-stardew-valley.git "$HOME/stardew-device-test"; fi && cd "$HOME/stardew-device-test" && bash scripts/package-working-wsl.sh
```

The script locates `ports/stardewvalley/` on the mounted SD card, streams the installed runtime without modifying the card, excludes game data, the generated icon, saves, logs, and local overrides before they enter the ZIP or WSL staging area, adds the pinned notices, and places the ZIP and SHA-256 file on the Windows Desktop. No Docker build or recompilation is performed.

The ZIP is intended to update the **same HOME partition** from which the working port was copied. Extract it into the HOME root and merge folders; do not format the card or delete the existing `ports/stardewvalley/gamedata/` directory. The archive does not contain game files, so the existing local game data stays on that HOME partition.

This is a private device-test archive, not a public release. It does not establish that all binary redistribution checks are complete. Do not publish it as a GitHub Release.
