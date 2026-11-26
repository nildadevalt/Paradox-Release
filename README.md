# Paradox-Release

Public update feed for Paradox. The app reads `version.json` on startup and
downloads any file whose SHA-256 differs from the copy in its `bin` folder.

## Layout

- `version.json` — version code, release notes, and the file manifest (name, SHA-256, size).
- `Module.dll` — the injected module.
- `RobloxPlayerBeta.dll` — the emulator payload.

## Publishing a new version

1. Replace `Module.dll` and/or `RobloxPlayerBeta.dll`.
2. Update `version.version` and the `notes` string.
3. Recompute `sha256` and `size` for every changed file in `files`.
4. Commit and push to `main`.

The client verifies each download against the manifest before replacing a file,
so a truncated or corrupted download is discarded and the old file stays in place.
