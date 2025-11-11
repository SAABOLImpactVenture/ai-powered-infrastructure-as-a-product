FROM node:18-bullseye AS build
WORKDIR /app
COPY package.json yarn.lock* .npmrc* .yarnrc* ./
COPY packages ./packages
COPY plugins ./plugins
COPY custom-actions ./custom-actions
COPY tsconfig.base.json backstage.json app-config*.yaml ./
RUN yarn install --frozen-lockfile || yarn install
RUN yarn workspace backend build

FROM gcr.io/distroless/nodejs18-debian12
WORKDIR /app
ENV NODE_ENV=production
COPY --from=build /app/app-config*.yaml ./
COPY --from=build /app/packages/backend/dist ./dist
COPY --from=build /app/packages/backend/package.json ./package.json
EXPOSE 7007
CMD ["dist/index.cjs.js"]
