export CONTEXT_MODE_ROOT := justfile_directory()
export CONTEXT_MODE_JJ_REPO := shell('cd "$1/.jj" && if [ -f repo ]; then cd "$(cat repo)"; else cd repo; fi && pwd -P', justfile_directory())

dev := "docker compose run --rm dev"

default:
    @just --list

# Build the development image; run it before the first command and after Containerfile changes.
build:
    {{ env("IMAGE_BUILD_COMMAND", "toolz build") }}

# Install dependencies from bun.lock into the node_modules volume; skipped while bun.lock and package.json are unchanged.
install:
    {{ dev }} sh -c 'set -eu; checksum=$(sha256sum bun.lock package.json); if [ "$checksum" = "$(cat node_modules/.bun-lock.sha256 2>/dev/null || true)" ]; then echo "install: bun.lock unchanged, skipping bun install"; else bun install --frozen-lockfile && printf "%s\n" "$checksum" > node_modules/.bun-lock.sha256; fi'

typecheck: install
    {{ dev }} npm run typecheck

# Rebuild build/ and the committed bundles (server.bundle.mjs, cli.bundle.mjs, hooks/*.bundle.mjs).
bundle: install
    {{ dev }} npm run build

# Rebuild the bundles, then run Vitest with the given arguments.
[positional-arguments]
test *args: bundle
    {{ dev }} npx vitest run "$@"

check: typecheck test

[positional-arguments]
npm *args: install
    {{ dev }} npm "$@"

shell:
    {{ dev }} bash
