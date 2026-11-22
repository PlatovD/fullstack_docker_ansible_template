FROM node:20-alpine AS builder
WORKDIR /workspace

COPY front/package*.json ./
RUN npm ci

COPY front/ .
RUN npm run build

FROM nginx:1.27-alpine AS runtime
WORKDIR /app

RUN addgroup -g 1000 -S frontgroup \
    && adduser -u 1000 -S frontuser -G frontgroup

RUN chown -R frontuser:frontgroup /usr/share/nginx/html /var/cache/nginx /var/log/nginx /etc/nginx/conf.d \
    && touch /var/run/nginx.pid \
    && chown frontuser:frontgroup /var/run/nginx.pid

COPY --from=builder --chown=frontuser:frontgroup /workspace/dist /usr/share/nginx/html
COPY --chown=frontuser:frontgroup front/nginx.conf /app/nginx.conf
COPY --chown=frontuser:frontgroup front/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

USER frontuser

EXPOSE 8080

ENTRYPOINT ["/app/entrypoint.sh"]
