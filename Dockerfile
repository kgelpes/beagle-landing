# Static landing page for Beagle, served by nginx. Designed for Coolify
# (Dockerfile build). The download URL + version are injected at container start
# from env vars (DOWNLOAD_URL, VERSION) so you can point it at your R2 domain
# without rebuilding.
FROM nginx:1.27-alpine

# Site assets
COPY site/ /usr/share/nginx/html/
# Keep a pristine template so config is re-applied on every (re)start.
RUN mkdir -p /etc/beagle \
  && mv /usr/share/nginx/html/index.html /etc/beagle/index.html.template

# nginx server config (gzip + cache headers)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# The official nginx image runs every executable in /docker-entrypoint.d/ before
# starting the server — we use that to template env vars into the HTML.
COPY docker-entrypoint.d/40-beagle-config.sh /docker-entrypoint.d/40-beagle-config.sh
RUN chmod +x /docker-entrypoint.d/40-beagle-config.sh

EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost/ >/dev/null || exit 1
