#!/bin/sh
# Render index.html from the template, injecting runtime config.
# Runs on every container start (via nginx's /docker-entrypoint.d hook).
set -e

ROOT="${ROOT:-/usr/share/nginx/html}"
TEMPLATE="${TEMPLATE:-/etc/beagle/index.html.template}"

# Where the "Download for Mac" buttons point. Default to the R2 stable alias.
DOWNLOAD_URL="${DOWNLOAD_URL:-https://dl.gelpes.com/updates/Beagle-latest-arm64.dmg}"
VERSION="${VERSION:-latest}"

# escape sed replacement metacharacters (& / \)
esc() { printf '%s' "$1" | sed -e 's/[&/\\]/\\&/g'; }

sed \
  -e "s/__DOWNLOAD_URL__/$(esc "$DOWNLOAD_URL")/g" \
  -e "s/__VERSION__/$(esc "$VERSION")/g" \
  "$TEMPLATE" > "$ROOT/index.html"

echo "beagle-landing: DOWNLOAD_URL=$DOWNLOAD_URL VERSION=$VERSION"
