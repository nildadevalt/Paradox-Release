# Paradox-Release

Public release feed for Paradox. Used for both the installer and the in-app updater.

## Install

Download `Paradox-Setup.exe` and run it. It installs to
`%LOCALAPPDATA%\Paradox`, installs the missing runtimes (Web View2, .NET 8,
VC++ redistributables), creates a desktop shortcut, then downloads every file
listed in `dist/manifest.json` and verifies its SHA-256.

The old `paradox.lol/dl` endpoint is gone; the setup exe reads from
`https://raw.githubusercontent.com/nildadevalt/Paradox-Release/main/dist/`.

## In-app update feed

`version.json` at the repo root is read by Paradox on startup. The app compares
SHA-256 hashes and replaces only the changed files in its `bin` folder:

- `Module.dll` — the injected module.
- `RobloxPlayerBeta.dll` — the emulator payload.

## Layout

- `Paradox-Setup.exe` — the installer for a fresh machine.
- `version.json` — in-app updater manifest for module + emulator.
- `dist/manifest.json` — full application file manifest for the installer.
- `dist/**` — the full application payload.
- `Module.dll`, `RobloxPlayerBeta.dll` — standalone copies for the in-app updater.

## Publishing a new version

1. Build the app and copy the publish output into `dist/`, skipping `*.pdb`.
2. Regenerate `dist/manifest.json` with each file's `path`, `size` and `sha256`.
3. Replace the root `Module.dll` / `RobloxPlayerBeta.dll` with the new copies.
4. Bump `version.version`, update `notes`, and recompute their `sha256`/`size`.
5. Rebuild `Paradox-Setup.exe` and commit everything to `main`.

A truncated or corrupted download never replaces an installed file: each file is
downloaded to a temporary name, verified, and only then moved into place.
