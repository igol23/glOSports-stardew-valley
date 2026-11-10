# Release checklist

A release is published only after every blocking item below is resolved. The currently working handheld installation is the reference; it must not be modified during repository preparation.

## Before packaging

- [ ] Import and pin the GoodLuckOS source; record its exact commit.
- [ ] Compare the maintainer's working package against the pinned source; document actual local changes instead of guessing.
- [ ] Record and verify the Stardew Valley **1.6.15.24356 Steam Compatibility build (32-bit/XNA)** and the source layout used by the working package.
- [ ] Verify redistribution terms and notices for every runtime binary and helper executable.
- [ ] Ensure all pinned notices from `LICENSES/` are present beside the runtime, including Mono `PATENTS.TXT`.
- [ ] Ensure `LICENSE.OpenAL.txt` is present and matches OpenAL Soft 1.25.2 `COPYING`.
- [ ] Preserve Debian copyright metadata under `mono/share/doc/` for the extracted Mono packages.
- [ ] Confirm the LZ4 notice matches v1.10.0 `lib/LICENSE`, not the older PortMaster notice.
- [ ] Confirm no game files, game-generated icon, saves, logs, device configuration, or personal overrides are in the release staging directory.

## Build and device verification

- [ ] Build the distributable port folder from the pinned sources, or explicitly document that the tested release was assembled from the existing working runtime.
- [ ] Run the release audit script against the staged HOME tree.
- [ ] Install to a clean HOME copy or spare card, without overwriting the maintainer's working installation.
- [ ] Confirm the package contains `.local/share/applications/stardew.puppy`, matching the working Half-Life-style Puppy application layout; confirm it launches after the user supplies their own files.
- [ ] Confirm audio, controls, language handling, saving, and loading.
- [ ] Record the device model, firmware version, Stardew Valley **1.6.15.24356 (Steam Compatibility, 32-bit/XNA)** build, date, and tested functions in the release notes.

## Build a Release ZIP from the already-working package

After source and license review, the existing installed package can be used as release input. The packaging script must copy into a temporary staging directory and must never edit the supplied working directory.

```sh
bash scripts/make-release.sh \
  "/path/to/working/ports/stardewvalley" \
  "dist/stardewvalley-goodluckOS.zip"
```

The script should remove `gamedata/`, generated `icon.png`, local `env`, language state, port-local saves and logs, then add an apps.puppy.append fragment for the HOME apps.puppy file and required notices. It must run `scripts/audit-release.sh` before creating the ZIP.

## Publish

- [ ] Commit complete relevant corresponding sources and license texts.
- [ ] Build a HOME-layout ZIP with no proprietary game data.
- [ ] Run `sha256sum` and publish the checksum beside the ZIP.
- [ ] Create a GitHub Release and clearly state that the latest tested version is on the Releases page.

## Expected release archive layout

```text
apps.puppy.append
ports/stardewvalley/
  stardew.sh
  mono/
  dlls/
  gl4es/
  lib/
  gamedata/README-OWN-GAME-FILES.txt
  LICENSE.*.txt
  LICENSE.OpenAL.txt
THIRD_PARTY_NOTICES.md
THIRD_PARTY_SOURCE/openal-soft-1.25.2-source.tar.gz
```

The exact runtime file list is determined by the built port and its license review. This checklist is not permission to redistribute a binary whose terms have not been verified.
