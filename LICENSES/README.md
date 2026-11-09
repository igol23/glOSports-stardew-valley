# Third-party license files

This directory contains license texts and notices copied from the pinned upstream sources documented in [THIRD_PARTY_NOTICES.md](../THIRD_PARTY_NOTICES.md).

- GL4ES, Mono, MonoGame, Patch, and LWJGL notices are retained from the pinned PortMaster Stardew support file set.
- `LICENSE_lz4.txt` is taken from LZ4 v1.10.0's `lib/LICENSE`, because the build compiles the library source from the `lib` directory.
- `LICENSE.OpenAL.txt` is the `COPYING` file from OpenAL Soft 1.25.2.
- `PATENTS.TXT` is the Mono 6.12.0.199 upstream patent promise referenced by the Mono license notice.

Do not replace a component's original license with the repository's root GPL-2.0 license. Preserve copyright headers and any required source attribution.

The presence of a license text does not establish the provenance or redistribution status of an arbitrary binary. Before publishing a binary release, compare every included binary with its source/version and verify its license and corresponding-source obligations. The exact Debian Mono package copyright metadata and the provenance of the bundled PortMaster DLLs remain part of that review.
