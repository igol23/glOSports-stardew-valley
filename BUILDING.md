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

The build output is under `dev/out/stardew/` and is ignored by Git. It is not a public game-data directory. The OpenAL Soft `COPYING` notice must be copied into the generated port. When assembling a release from an already-built working runtime, the release helper must obtain the same notice from the hash-pinned OpenAL Soft 1.25.2 source archive.

## Important distinctions

- The maintainer's current installed port is already reported working. Do not replace it just to run a clean build.
- `build.sh game` copies proprietary files from the path supplied in `SDV_GAME`; all output from this command must remain local.
- `build.sh xmlgen` creates serializers specific to the game assemblies. Treat those outputs as game-derived and keep them out of the public repository and release archive unless their redistribution status has been explicitly cleared.
- A build succeeding on the PC does not prove runtime compatibility on the handheld.
