#!/bin/bash
# MyIssues MTA - Complete Deployment Script
# Run this on your RunPod instance: bash deploy.sh

set -e

echo "╔════════════════════════════════════════════╗"
echo "║  🚀 MyIssues MTA - RunPod Deployment 🚀   ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Update System
echo -e "${YELLOW}[1/10]${NC} Updating system packages..."
apt update -y > /dev/null 2>&1
apt upgrade -y > /dev/null 2>&1
apt install -y git curl ca-certificates wget > /dev/null 2>&1
echo -e "${GREEN}✅ System updated${NC}"
echo ""

# Step 2: Install Docker
echo -e "${YELLOW}[2/10]${NC} Installing Docker..."
if ! command -v docker &> /dev/null; then
  curl -fsSL https://get.docker.com -o get-docker.sh > /dev/null 2>&1
  sh get-docker.sh > /dev/null 2>&1
  echo -e "${GREEN}✅ Docker installed${NC}"
else
  echo -e "${GREEN}✅ Docker already installed${NC}"
fi
echo ""

# Step 3: Install Docker Compose
echo -e "${YELLOW}[3/10]${NC} Installing Docker Compose Plugin..."
apt install -y docker-compose-plugin > /dev/null 2>&1
systemctl enable --now docker > /dev/null 2>&1
echo -e "${GREEN}✅ Docker Compose installed${NC}"
echo ""

# Step 4: Verify Installation
echo -e "${YELLOW}[4/10]${NC} Verifying Docker installation..."
docker --version
docker compose version
echo -e "${GREEN}✅ Docker verified${NC}"
echo ""

# Step 5: Clone Repository
echo -e "${YELLOW}[5/10]${NC} Cloning MyIssues MTA repository..."
cd ~
if [ -d "myissues-mta" ]; then
  echo -e "${YELLOW}⚠️  Repository exists, pulling latest...${NC}"
  cd myissues-mta
  git pull origin main > /dev/null 2>&1
else
  git clone https://github.com/myissues247/myissues-mta.git > /dev/null 2>&1
  cd myissues-mta
fi
echo -e "${GREEN}✅ Repository ready${NC}"
echo ""

# Step 6: Start Docker Stack
echo -e "${YELLOW}[6/10]${NC} Starting Docker stack..."
docker compose up -d --build > /dev/null 2>&1
echo -e "${GREEN}✅ Containers starting...${NC}"
sleep 30
echo ""

# Step 7: Verify Containers
echo -e "${YELLOW}[7/10]${NC} Verifying containers..."
docker ps
echo -e "${GREEN}✅ Containers verified${NC}"
echo ""

# Step 8: Generate DKIM Keys
echo -e "${YELLOW}[8/10]${NC} Generating DKIM keys..."
chmod +x generate_dkim_keys.sh create_user.sh
./generate_dkim_keys.sh > /dev/null 2>&1
echo -e "${GREEN}✅ DKIM keys generated${NC}"
echo ""

# Step 9: Create Mail Users
echo -e "${YELLOW}[9/10]${NC} Creating mail users..."
./create_user.sh admin@myissuesinc.com StrongAdmin!23 > /dev/null 2>&1
./create_user.sh abdul@myissuesinc.com StrongTempPass!23 > /dev/null 2>&1
echo -e "${GREEN}✅ Users created${NC}"
echo ""

# Step 10: Get Public IP
echo -e "${YELLOW}[10/10]${NC} Getting public IP..."
PUBLIC_IP=$(curl -s ifconfig.me)
echo -e "${GREEN}✅ IP retrieved${NC}"
echo ""

# Summary
echo "╔════════════════════════════════════════════╗"
echo "║     ✅ DEPLOYMENT COMPLETE! ✅             ║"
echo "╚════════════════════════════════════════════╝"
echo ""
echo "📊 Stack Status:"
docker compose ps
echo ""
echo "🌐 Your Public IP: ${GREEN}${PUBLIC_IP}${NC}"
echo ""
echo "📋 Next Steps:"
echo "1. Get DKIM public key:"
echo "   ${YELLOW}cat config/opendkim/mail.public.txt${NC}"
echo ""
echo "2. Send DNS records to Christian:"
echo "   A    mail            ${PUBLIC_IP}"
echo "   MX   @               mail.myissuesinc.com"
echo "   TXT  @               v=spf1 mx a ip4:${PUBLIC_IP} ~all"
echo "   TXT  mail._domainkey [from DKIM output above]"
echo ""
echo "3. Monitor logs:"
echo "   ${YELLOW}docker compose logs -f${NC}"
echo ""
echo "4. Add more users:"
echo "   ${YELLOW}./create_user.sh user@myissuesinc.com Password123${NC}"
echo ""
echo "📧 Mail Server Details:"
echo "   Domain: myissuesinc.com"
echo "   Admin:  admin@myissuesinc.com"
echo "   SMTP:   25, 587"
echo "   IMAP:   993"
echo ""
