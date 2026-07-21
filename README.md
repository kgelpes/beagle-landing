# Beagle — Landing Page

A self-contained static marketing site for Beagle, served by nginx and built for
one-click deploys on **Coolify**. The "Download for Mac" buttons and the version
label are injected at container start from env vars, so the same image points at
whatever download host you configure (the Cloudflare R2 domain).

```
landing/
  site/                     the static site (index.html, style.css, assets/)
  nginx.conf                gzip + cache headers
  Dockerfile                nginx image
  docker-entrypoint.d/      renders env vars into the HTML on start
```

## Runtime configuration

| Env var        | Default                                                     | Purpose                        |
| -------------- | ----------------------------------------------------------- | ------------------------------ |
| `DOWNLOAD_URL` | `https://dl.sealkit.dev/updates/Beagle-latest-arm64.dmg`    | Target of the download buttons |
| `VERSION`      | `latest`                                                    | Version shown under the CTA    |

`DOWNLOAD_URL` should point at the stable alias published to R2 by
`scripts/publish-r2.sh` (`…/updates/Beagle-latest-arm64.dmg`), served from the R2
custom domain `dl.sealkit.dev`.

## Local preview

```bash
# plain static (no templating)
cd landing/site && python3 -m http.server 8080   # → http://localhost:8080

# or the real container
docker build -t beagle-landing ./landing
docker run --rm -p 8080:80 \
  -e DOWNLOAD_URL="https://dl.sealkit.dev/updates/Beagle-latest-arm64.dmg" \
  -e VERSION="0.1.0" beagle-landing
```

## Deploy on Coolify

1. **New Resource → Application** → connect this Git repository.
2. **Build Pack:** `Dockerfile`. Set **Base Directory** to `/landing` (so Coolify
   builds `landing/Dockerfile`).
3. **Port:** `80`.
4. **Environment variables:** set `DOWNLOAD_URL=https://dl.sealkit.dev/updates/Beagle-latest-arm64.dmg`
   and `VERSION`.
5. **Domain:** set the app's domain to `https://beagle.sealkit.dev`; Coolify provisions HTTPS.
6. **Deploy.** Re-deploys on every push to the tracked branch.

The container is stateless — updating `DOWNLOAD_URL`/`VERSION` and restarting
re-renders the page (no rebuild needed).

See [`../DISTRIBUTION.md`](../DISTRIBUTION.md) for the full release flow (building
the app, publishing to R2, and how auto-updates find the feed).
