#!/bin/bash

echo "Creating directory structure..."
mkdir -p .github/workflows infrastructure website

echo "Generating deploy-infra.yml..."
cat << 'EOF' > .github/workflows/deploy-infra.yml
name: Deploy GCP Infrastructure
on:
  workflow_dispatch:
jobs:
  deploy-vm:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4
      - name: Authenticate to Google Cloud
        uses: google-github-actions/auth@v2
        with:
          credentials_json: '${{ secrets.GCP_CREDENTIALS }}'
      - name: Set up Cloud SDK
        uses: google-github-actions/setup-gcloud@v2
        with:
          project_id: '${{ secrets.GCP_PROJECT_ID }}'
      - name: Deploy e2-micro VM
        run: |
          if gcloud compute instances describe www-ryanrothwell-ca --zone=us-east1-b > /dev/null 2>&1; then
            echo "VM already exists. If you want to rebuild, delete it in GCP first."
          else
            echo "Creating new Rocky Linux VM..."
            gcloud compute instances create www-ryanrothwell-ca \
              --zone=us-east1-b \
              --machine-type=e2-micro \
              --subnet=default \
              --tags=http-server,https-server \
              --stack-type=IPV4_IPV6 \
              --image-family=rocky-linux-9-optimized-gcp \
              --image-project=rocky-linux-cloud \
              --metadata-from-file=user-data=infrastructure/cloud-init.yaml
          fi
EOF

echo "Generating deploy-website.yml..."
cat << 'EOF' > .github/workflows/deploy-website.yml
name: Deploy Website Updates
on:
  push:
    branches:
      - main
    paths:
      - 'website/**'
  workflow_dispatch:
jobs:
  deploy-site:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4
      - name: Copy Website Files to VM via SSH
        uses: appleboy/scp-action@v0.1.7
        with:
          host: ${{ secrets.VM_IP }}
          username: ryan
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          port: 22
          source: "website/*"
          target: "/usr/share/nginx/html/"
          strip_components: 1
EOF

echo "Generating cloud-init.yaml..."
cat << 'EOF' > infrastructure/cloud-init.yaml
#cloud-config
users:
  - name: ryan
    groups: [wheel]
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    lock_passwd: false
    passwd: '$6$tspU12IF1gAnoagy$Wit5znedzH/5UVP2Atqh3b6ZxOdQihjShuiJMKecJwFmm1zElFQLIXSYDJdCTWSmxiAPfjXVwrn7J5mThEnlK0'
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFqDX9cCyisQ2R34wJzelFCCfUQEfENEtlSUTjCxFZR/ ryan@ryanrothwell.ca

packages:
  - nginx
  - epel-release
  - policycoreutils-python-utils
  - certbot
  - python3-certbot-nginx

write_files:
  - path: /etc/ssh/sshd_config.d/99-hardened.conf
    content: |
      PasswordAuthentication no
      PermitRootLogin no
      AllowUsers ryan
      PubkeyAcceptedAlgorithms +ssh-rsa,rsa-sha2-256,rsa-sha2-512
  
  - path: /etc/nginx/conf.d/ryanrothwell.ca.conf
    content: |
      server {
          listen 80;
          listen [::]:80;
          server_name ryanrothwell.ca www.ryanrothwell.ca;

          add_header X-Frame-Options "SAMEORIGIN" always;
          add_header X-XSS-Protection "1; mode=block" always;
          add_header X-Content-Type-Options "nosniff" always;
          add_header Referrer-Policy "no-referrer-when-downgrade" always;

          root /usr/share/nginx/html;
          index index.html;

          location / {
              try_files $uri $uri/ =404;
          }
          
          location ~ /\. {
              deny all;
          }
      }

runcmd:
  - chown -R ryan:ryan /usr/share/nginx/html
  - systemctl restart sshd
  - systemctl enable --now nginx
EOF

echo "Generating index.html..."
cat << 'EOF' > website/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Ryan Rothwell</title>
    <style>
        body { font-family: sans-serif; text-align: center; margin-top: 50px; }
    </style>
</head>
<body>
    <h1>It Works</h1>
    <p>Deployed automatically via GitHub Actions.</p>
</body>
</html>
EOF

echo "File generation complete!"
echo "Adding files to Git..."
git add .
echo "Status of files to be committed:"
git status
