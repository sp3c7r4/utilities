#!/bin/bash
set -euo pipefail

# Update system
apt update && apt upgrade -y

# Install base packages
apt install -y \
  curl \
  git \
  unzip \
  nginx \
  certbot \
  python3-certbot-nginx

# -----------------------------
# Install NVM + Node.js
# -----------------------------
sudo -u ubuntu bash <<'EOF'
export HOME="/home/ubuntu"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

nvm install 24
nvm alias default 24

# Persist nvm
grep -qxF 'export NVM_DIR="$HOME/.nvm"' ~/.bashrc || cat <<'EOT' >> ~/.bashrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
EOT
EOF

# -----------------------------
# Install Bun
# -----------------------------
sudo -u ubuntu bash <<'EOF'
export HOME="/home/ubuntu"

curl -fsSL https://bun.sh/install | bash

# Persist bun
grep -qxF 'export BUN_INSTALL="$HOME/.bun"' ~/.bashrc || cat <<'EOT' >> ~/.bashrc

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
EOT
EOF

# -----------------------------
# Install PM2 globally
# -----------------------------
sudo -u ubuntu bash <<'EOF'
export HOME="/home/ubuntu"

export NVM_DIR="$HOME/.nvm"
. "$NVM_DIR/nvm.sh"

npm install -g pm2
EOF

# -----------------------------
# Install Docker
# -----------------------------
curl -fsSL https://get.docker.com | sh

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Enable docker on boot
systemctl enable docker
systemctl start docker

echo ""
echo "=================================="
echo "Setup complete"
echo "=================================="
echo "IMPORTANT:"
echo "Reconnect SSH for docker group & bun/node to work"
echo "=================================="
