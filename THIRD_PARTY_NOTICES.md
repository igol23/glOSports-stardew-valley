# Third-party notices

This project aggregates software with different copyright holders and licenses. The root `LICENSE` applies to the GoodLuckOS-derived project source; it does not replace the license of any third-party component.

| Component | Notice expected in the runtime package | Release requirement |
|---|---|---|
| GL4ES | `LICENSE.GL4ES.txt` | Preserve upstream copyright and permission notice. |
| Mono | `LICENSE.Mono.txt` | Preserve bundled Mono and subcomponent notices; Mono is a collection with multiple licenses. |
| MonoGame | `LICENSE.MonoGame.txt` | Preserve the Microsoft Public License notice and source attribution. |
| JohnnyonFlame loader / patch components | `LICENSE.Patch.txt` | Preserve the Modified BSD notice and disclaimer; include corresponding source where required by applicable terms. |
| LWJGL-related component | `LICENSE_lwjgl.txt` | Preserve supplied notice. |
| LZ4 | `LICENSE_lz4.txt` | Preserve applicable BSD notice. |
| OpenAL Soft 1.25.2 | `LICENSE.OpenAL.txt` | Include the exact `COPYING` file from the hash-pinned 1.25.2 source archive. |

Do not publish a binary bundle until the notices match the exact binaries and versions being shipped. A license file in a directory is not, by itself, proof that every binary in that directory is cleared for redistribution.

The Stardew Valley executable, game libraries, Content assets, XNB files, audio banks, user saves, and game-generated icon are excluded from public distribution.
