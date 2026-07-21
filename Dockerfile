# Static landing page for Beagle, served by nginx. Designed for Coolify
# (Dockerfile build). The download URL + version are injected at container start
# from env vars (DOWNLOAD_URL, VERSION) via nginx's docker-entrypoint.d hook.
FROM nginx:1.27-alpine

# Site assets (index.html keeps __DOWNLOAD_URL__/__VERSION__ tokens; the entrypoint
# replaces them in-place on start using the env — best-effort, never blocks nginx).
COPY site/ /usr/share/nginx/html/

# nginx server config (gzip + cache headers)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Templating hook (official nginx image runs /docker-entrypoint.d/*.sh before start)
COPY docker-entrypoint.d/40-beagle-config.sh /docker-entrypoint.d/40-beagle-config.sh
RUN chmod +x /docker-entrypoint.d/40-beagle-config.sh

EXPOSE 80
