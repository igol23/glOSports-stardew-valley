# Upstream sources and pinned revisions

This file distinguishes the origin of the work from the maintainer's own packaging changes. Revisions are pinned so a future import does not silently change the baseline.

| Component | Pinned source | Purpose / attribution |
|---|---|---|
| GoodLuckOS Stardew implementation | [`alvesmaicon/goodluckOS`](https://github.com/alvesmaicon/goodluckOS), commit `b7a3ca2d1de2077557760e05655cb555ea35b98d` (`develop` as inspected on 2026-11-09) | Build workflow, port launcher, patches, Mono/GL4ES/OpenAL/LZ4 integration. |
| Initial feasibility discussion | [`CodeZombie/goodluckOS#73`](https://github.com/CodeZombie/goodluckOS/issues/73) | Discussion of ARMHF Mono and whether Stardew could run on GA36 hardware; not a standalone implementation repository. |
| PortMaster Stardew files | [`PortsMaster/PortMaster-New`](https://github.com/PortsMaster/PortMaster-New), commit `49b642ae4a3699bfa3626933ed70e7b34efd14e2` | The upstream GoodLuckOS build script downloads a pinned selection of Stardew support files from this revision. |
| GL4ES | [`ptitSeb/gl4es`](https://github.com/ptitSeb/gl4es), revision `ec16bedd8819c475326f4f1a3063772c6d986e06` | OpenGL compatibility layer used by the port. |
| OpenAL Soft | [`kcat/openal-soft`](https://github.com/kcat/openal-soft), tag `1.25.2` (source tarball SHA-256 `fb27e5839aa11f0e5b9d33756965291fad5d6909ab928ea1f796f4a1a6877894`) | Audio library. Its `COPYING` file must accompany a distributed shared library. |
| LZ4 | [`lz4/lz4`](https://github.com/lz4/lz4), tag `v1.10.0` | Compression library used by the port's LZ4 shim and asset handling. |
| Mono | Debian package version `6.12.0.199+dfsg-6` | ARMHF Mono runtime selected by the upstream build script. Preserve package notices. |

## Attribution notes

- CodeZombie's issue comment proposed the ARMHF Mono / Compatibility-build direction and referenced an existing handheld port as feasibility evidence.
- alvesmaicon documented the practical GoodLuckOS Stardew implementation and its build process. That is the implementation baseline used here.
- The maintainer's working package has no local `.git` history. Do not infer a complete file-level authorship map from that package; compare its files against the pinned source before claiming individual modifications.
