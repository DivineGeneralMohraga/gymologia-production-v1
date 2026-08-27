# ──────────────────────────────────────────────────────────────────────
#  Gymologia API — production image
#
#  Multi-stage so the shipped layer carries no TypeScript, no dev
#  dependencies and no source: just compiled JS, production modules and
#  the generated Prisma client.
# ──────────────────────────────────────────────────────────────────────

# ── Stage 1: install everything and generate the Prisma client ────────
FROM node:24-alpine AS deps
WORKDIR /app

# Prisma's query engine is linked against OpenSSL; without it the client
# fails at runtime with a cryptic "unable to detect libssl" error.
RUN apk add --no-cache openssl

COPY package.json package-lock.json ./
COPY prisma ./prisma
RUN npm ci --no-audit --no-fund
RUN npx prisma generate

# ── Stage 2: compile ──────────────────────────────────────────────────
FROM node:24-alpine AS build
WORKDIR /app
RUN apk add --no-cache openssl

COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# ── Stage 3: production dependencies only ─────────────────────────────
FROM node:24-alpine AS prod-deps
WORKDIR /app
RUN apk add --no-cache openssl

COPY package.json package-lock.json ./
COPY prisma ./prisma
RUN npm ci --omit=dev --no-audit --no-fund
# The client has to be regenerated here: the dev tree was pruned away.
RUN npx prisma generate

# ── Stage 4: the image that actually ships ────────────────────────────
FROM node:24-alpine AS runner
WORKDIR /app

RUN apk add --no-cache openssl wget

ENV NODE_ENV=production
ENV PORT=3000

# Never run as root. node:alpine ships an unprivileged `node` user.
COPY --from=prod-deps --chown=node:node /app/node_modules ./node_modules
COPY --from=build     --chown=node:node /app/dist         ./dist
COPY --chown=node:node prisma       ./prisma
COPY --chown=node:node package.json ./

USER node
EXPOSE 3000

# Matches the readiness endpoint, so an unhealthy database marks the
# container unhealthy rather than letting it serve 500s.
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:3000/api/v1/health || exit 1

CMD ["node", "dist/main.js"]
