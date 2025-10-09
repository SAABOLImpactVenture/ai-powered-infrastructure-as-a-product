
FROM node:20-bullseye

# Install Terraform
RUN apt-get update && apt-get install -y wget gnupg software-properties-common &&     wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg &&     echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(. /etc/os-release && echo $VERSION_CODENAME) main" > /etc/apt/sources.list.d/hashicorp.list &&     apt-get update && apt-get install -y terraform &&     rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package.json index.js ./

EXPOSE 8080
CMD ["node", "index.js"]
