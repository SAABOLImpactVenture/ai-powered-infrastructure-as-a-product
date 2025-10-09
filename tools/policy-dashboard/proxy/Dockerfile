# syntax=docker/dockerfile:1
FROM node:20-slim AS build
WORKDIR /srv
COPY package.json ./
RUN npm ci --omit=dev
COPY . .

FROM gcr.io/distroless/nodejs18-debian12
WORKDIR /srv
COPY --from=build /srv /srv
USER 65532:65532
EXPOSE 8090
CMD ["index.js"]
