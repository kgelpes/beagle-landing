#!/bin/sh
# Inject runtime config into index.html on container start. Best-effort: never
# aborts nginx startup (no `set -e`), so the site always serves.
ROOT="${ROOT:-/usr/share/nginx/html}"

# Where the "Download for Mac" buttons point. Default to the R2 stable alias.
DOWNLOAD_URL="${DOWNLOAD_URL:-https://dl.gelpes.com/updates/Beagle-latest-arm64.dmg}"
VERSION="${VERSION:-latest}"

# escape sed replacement metacharacters (& / \)
esc() { printf '%s' "$1" | sed -e 's/[&/\\]/\\&/g'; }

if [ -f "$ROOT/index.html" ]; then
  sed -i \
    -e "s/__DOWNLOAD_URL__/$(esc "$DOWNLOAD_URL")/g" \
    -e "s/__VERSION__/$(esc "$VERSION")/g" \
    "$ROOT/index.html" 2>/dev/null || true
fi

echo "beagle-landing: DOWNLOAD_URL=$DOWNLOAD_URL VERSION=$VERSION"
