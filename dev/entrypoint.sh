#!/bin/sh
# Volumes start out owned by root; hand them to node, then run the command as node so file permissions apply.
set -eu
for dir in node_modules /home/node/.bun/install/cache; do
    if [ -d "$dir" ] && [ "$(stat -c %u "$dir")" != 1000 ]; then
        chown node:node "$dir"
    fi
done
export HOME=/home/node USER=node
exec setpriv --reuid=node --regid=node --init-groups -- "$@"
