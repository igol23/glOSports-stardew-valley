# Project plan

**Project:** `glOSports-stardew-valley`  
**Status:** Repository and release preparation  
**Last updated:** 2026-11-09

## Goal

Publish and document the already-working Stardew Valley setup for GA36-family handhelds running goodluckOS. This is a packaging, attribution, and release project—not a claim that the maintainer independently created the original port.

The existing working installation is the reference build. Repository preparation must not modify or replace that installation.

## Scope

- Preserve the GoodLuckOS-derived build sources and identify their exact upstream revision.
- Document the roles of CodeZombie, alvesmaicon, PortMaster, JohnnyonFlame, and the maintainer accurately.
- Keep the ARMHF runtime and launcher separate from the user's proprietary Stardew Valley game files.
- Preserve third-party license texts and verify notices against the components actually shipped.
- Produce a HOME-layout ZIP and SHA-256 checksum only after release checks pass.
- Document the device, firmware, game build, and functions actually tested.

## Repository layout

- `README.md` — public overview, supported target, requirements, test status, credits, and release links.
- `PROJECT-PLAN.md` — project goals, stages, and release blockers.
- `CHANGELOG.md` — user-visible changes for each published release.
- `INSTALL-TR.md` — Turkish end-user installation guide.
- `BUILDING.md` — contributor build instructions and game-data warnings.
- `RELEASING.md` — release checklist, packaging command, audit, and archive layout.
- `UPSTREAMS.md` — pinned repositories, commits, versions, and attribution.
- `THIRD_PARTY_NOTICES.md` and `LICENSES/` — component license and copyright notices.
- `LICENSE` — upstream GoodLuckOS-derived source license; third-party components retain their own terms.
- `scripts/` — source import, OpenAL notice retrieval, release packaging, and release audit scripts.
- `dev/stardew/` — imported build and patch sources; never store proprietary game assets here.
- `dev/UPSTREAM-REVISION.txt` — exact imported GoodLuckOS and PortMaster revisions.
- `release-template/` — HOME menu entry and an instruction-only placeholder for user-provided game files.
- `docs/images/` — maintainer-captured screenshots for documentation; never copy them into the install ZIP without separate review.
- `dist/` — generated release ZIP and checksum; never commit this directory.

## Release stages

### 1. Preserve the working reference

Keep the current installed port untouched. Record its file inventory and hashes. Do not rebuild over it and do not use its `gamedata/`, saves, local environment overrides, or game-generated icon as repository content.

### 2. Trace upstream sources

Keep the imported GoodLuckOS source pinned to the commit recorded in `dev/UPSTREAM-REVISION.txt`. Keep PortMaster and library revisions recorded in `UPSTREAMS.md`. Compare the working package with these sources before describing local changes as original maintainer work.

### 3. Finish binary and license review

For every runtime binary and helper included in a public ZIP, record its source, version or revision, license, and required notice. Preserve upstream license files. A notice file alone does not prove that an arbitrary binary is cleared for redistribution. Do not publish a binary bundle while a required redistribution or corresponding-source obligation remains unresolved.

### 4. Assemble a clean release

Use `scripts/make-release.sh` with the existing working `ports/stardewvalley` directory as input. The script must stage a copy, remove game data, generated `icon.png`, saves, logs, and local overrides, add the HOME menu entry and notices, and run `scripts/audit-release.sh` before creating the ZIP.

The release must not contain `StardewValley.exe`, the game's `Content/` directory, XNB/XWB assets, game DLLs, save files, or other proprietary game data. Users provide their own legally obtained compatible game files.

### 5. Test without risking the reference installation

Install the ZIP to a separate HOME copy or spare card. Verify that the menu entry appears and the user's own game files launch. Test controls, audio, language handling, saving, and loading. Record only tests actually performed.

### 6. Publish

Commit reviewed source and documentation. Create a versioned GitHub Release with the clean HOME-layout ZIP, SHA-256 checksum, device/firmware/game-build details, and known limitations. The README's latest-release link should point to that release page.

## Release blockers

- The working package has been compared against pinned upstream sources sufficiently to support accurate attribution.
- The exact Stardew Valley Compatibility build used for testing is recorded.
- Redistribution terms and corresponding-source requirements for every shipped binary are reviewed.
- All required third-party notices are present and match shipped components.
- The release audit passes and the archive contains no game assets, saves, logs, or local-only settings.
- A clean installation has been tested on the target device without overwriting the maintainer's working setup.
- The published checksum matches the release ZIP.

## Reporting rules

Do not describe the package as universally compatible with every GA36 variant. Do not invent performance figures. Do not claim a clean rebuild was tested when the release was assembled from the existing working runtime. Clearly distinguish upstream work from the maintainer's packaging and testing.
