
FROM node:20-bullseye
RUN apt-get update && apt-get install -y curl &&     curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" &&     chmod +x kubectl && mv kubectl /usr/local/bin/kubectl &&     rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY index.js ./
EXPOSE 8082
CMD ["node", "index.js"]
