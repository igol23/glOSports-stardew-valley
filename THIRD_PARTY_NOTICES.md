# Third-party notices

This project aggregates software with different copyright holders and licenses. The root `LICENSE` applies to the GoodLuckOS-derived project source; it does not replace the license of any third-party component.

The copies in `LICENSES/` are retained from the pinned component sources listed below. The release builder copies the relevant notices beside the runtime files.

| Component | Pinned source / version | Notice in runtime package | Notes |
|---|---|---|---|
| GL4ES | `ptitSeb/gl4es`, `ec16bedd8819c475326f4f1a3063772c6d986e06` | `LICENSE.GL4ES.txt` | MIT-style notice from the pinned GL4ES source. |
| Mono | Debian ARMHF packages `6.12.0.199+dfsg-6`; upstream notice from Mono `mono-6.12.0.199` | `LICENSE.Mono.txt`, `PATENTS.TXT` | Mono contains code under multiple licenses. The Mono notice describes included third-party components; PATENTS.TXT is the accompanying Microsoft patent promise. |
| MonoGame | PortMaster pinned file set at `49b642ae4a3699bfa3626933ed70e7b34efd14e2` | `LICENSE.MonoGame.txt` | Microsoft Public License notice plus the included Mono.Xna MIT notice. |
| JohnnyonFlame loader / patch components | PortMaster pinned file set at `49b642ae4a3699bfa3626933ed70e7b34efd14e2` | `LICENSE.Patch.txt` | Modified BSD notice. Corresponding source and exact binary provenance still need review. |
| LWJGL-related component | PortMaster pinned file set at `49b642ae4a3699bfa3626933ed70e7b34efd14e2` | `LICENSE_lwjgl.txt` | Preserve supplied notice. |
| LZ4 shim dependency | `lz4/lz4` v`1.10.0`, `lib/LICENSE` | `LICENSE_lz4.txt` | The build compiles `lib/lz4.c`; use the BSD 2-Clause license for the `lib` directory, not the old PortMaster notice. |
| OpenAL Soft | `kcat/openal-soft` 1.25.2; source archive SHA-256 recorded in `UPSTREAMS.md` | `LICENSE.OpenAL.txt` | Exact `COPYING` from the hash-pinned source archive. The corresponding source archive is included in the release staging tree. |

## Important review limits

These files establish the notices associated with the pinned upstream components. They do **not** by themselves prove that every binary currently installed on the maintainer's device was built from those exact revisions or is eligible for redistribution.

Before publishing a binary release, compare the actual runtime binaries and helper executables against the pinned sources and versions, retain any additional notices shipped by their packages, and verify all corresponding-source obligations. In particular, the Debian Mono ARMHF package copyright metadata and the provenance of PortMaster-provided managed DLLs still need to be checked against the exact runtime being packaged.

The Stardew Valley executable, game libraries, Content assets, XNB/XWB files, audio banks, user saves, and game-generated icon are excluded from public distribution.
