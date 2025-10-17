#!/bin/bash
# Full Deployment Script for MyIssues MTA on RunPod
set -e

echo "========================================"
echo "🚀 MyIssues MTA - Full Deployment"
echo "========================================"
echo ""

# Step 1: Update System
echo "📦 Step 1: Updating system packages..."
apt update -y && apt upgrade -y
apt install -y git curl ca-certificates wget
echo "✅ System updated"
echo ""

# Step 2: Install Docker
echo "🐳 Step 2: Installing Docker..."
if ! command -v docker &> /dev/null; then
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  echo "✅ Docker installed"
else
  echo "✅ Docker already installed"
fi
echo ""

# Step 3: Install Docker Compose Plugin
echo "🔧 Step 3: Installing Docker Compose Plugin..."
if ! docker compose version &> /dev/null; then
  apt install -y docker-compose-plugin
  echo "✅ Docker Compose installed"
else
  echo "✅ Docker Compose already installed"
fi
systemctl enable --now docker
echo ""

# Step 4: Verify Installation
echo "✔️ Step 4: Verifying installation..."
docker --version
docker compose version
echo ""

# Step 5: Clone Repository
echo "📥 Step 5: Cloning MyIssues MTA repository..."
cd ~
if [ -d "myissues-mta" ]; then
  echo "⚠️  Directory exists, updating..."
  cd myissues-mta
  git pull origin main
else
  git clone https://github.com/myissues247/myissues-mta.git
  cd myissues-mta
fi
echo "✅ Repository ready"
echo ""

# Step 6: Start Docker Stack
echo "🚀 Step 6: Starting Docker stack..."
docker compose up -d --build
echo "✅ Containers starting..."
sleep 30
echo ""

# Step 7: Verify Containers
echo "✔️ Step 7: Verifying containers..."
docker ps
echo ""

# Step 8: Generate DKIM Keys
echo "🔐 Step 8: Generating DKIM keys..."
chmod +x generate_dkim_keys.sh create_user.sh
./generate_dkim_keys.sh
echo ""

# Step 9: Create Default Users
echo "👤 Step 9: Creating mail users..."
./create_user.sh admin@myissuesinc.com StrongAdmin!23
./create_user.sh abdul@myissuesinc.com StrongTempPass!23
echo "✅ Users created"
echo ""

# Step 10: Display Public IP
echo "🌐 Step 10: Getting public IP..."
PUBLIC_IP=$(curl -s ifconfig.me)
echo "📌 Your Public IP: $PUBLIC_IP"
echo ""

# Step 11: Summary
echo "========================================"
echo "✅ DEPLOYMENT COMPLETE!"
echo "========================================"
echo ""
echo "📊 Stack Status:"
docker compose ps
echo ""
echo "📋 Next Steps:"
echo "1. Send this IP to Christian for DNS setup:"
echo "   IP: $PUBLIC_IP"
echo ""
echo "2. DNS Records needed:"
echo "   A    mail            $PUBLIC_IP"
echo "   MX   @               mail.myissuesinc.com"
echo "   TXT  @               v=spf1 mx a ip4:$PUBLIC_IP ~all"
echo "   TXT  mail._domainkey [from config/opendkim/mail.public.txt]"
echo ""
echo "3. Monitor logs:"
echo "   docker compose logs -f"
echo ""
echo "4. Add more users:"
echo "   ./create_user.sh user@myissuesinc.com Password123"
echo ""
echo "========================================"
