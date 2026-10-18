# Developing this fork

This repository is a fork of [mksglu/context-mode](https://github.com/mksglu/context-mode). `CLAUDE.md` holds
context-mode's own routing rules and comes from upstream; the rules below cover development of the fork.

## Environment
- Run Node, npm, Bun, TypeScript, esbuild and Vitest only in the Podman container through `just`, never on the host.
- `just build` builds the image; run it first and after `Containerfile` changes.
- `just install` installs dependencies from `bun.lock` into the `node_modules` volume.
- `just bundle` runs `npm run build`: `tsc` into `build/`, then the bundles and their assertions.
- `just test [vitest arguments]` rebuilds the bundles, then runs Vitest. `just check` adds the type check and is the
  fork's check; the fork has no GitHub workflows.
- `just npm …` and `just shell` reach the container directly.

## Bundles
- Plugin installs clone this repository and run the committed bundles: `server.bundle.mjs`, `cli.bundle.mjs`, and
  `hooks/{session-extract,session-snapshot,session-db,security}.bundle.mjs`. `.gitignore` lists them, but they stay
  tracked.
- Commit regenerated bundles in the same change as the source that produced them.

## History
- Changes go on `main` as jj changes. `upstream` is mksglu/context-mode, and `origin` is the fork.
- Keep the fork's tooling and each fix in separate changes, so a fix can go upstream on its own.
