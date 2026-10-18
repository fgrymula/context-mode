FROM docker.io/oven/bun:1.4.2 AS bun

FROM docker.io/library/node:24.22.0-bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates g++ git make python3 \
    && rm -rf /var/lib/apt/lists/* \
    && git config --system --add safe.directory '*'

COPY --from=bun /usr/local/bin/bun /usr/local/bin/bun
COPY --chmod=755 dev/entrypoint.sh /usr/local/bin/dev-entrypoint

ENTRYPOINT ["dev-entrypoint"]
