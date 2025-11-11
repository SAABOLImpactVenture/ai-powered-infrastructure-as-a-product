# Build stage
FROM node:18-bullseye AS build
WORKDIR /app
COPY package.json yarn.lock* .npmrc* .yarnrc* ./
COPY packages ./packages
COPY plugins ./plugins
COPY custom-actions ./custom-actions
COPY tsconfig.base.json backstage.json app-config*.yaml ./
RUN yarn install --frozen-lockfile || yarn install
RUN yarn workspace app build

# Runtime stage (nginx)
FROM nginx:stable-alpine
COPY --from=build /app/packages/app/dist /usr/share/nginx/html
COPY --from=build /app/app-config*.yaml /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
