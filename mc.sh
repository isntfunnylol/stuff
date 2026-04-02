#!/bin/sh

# ===== COLORS =====
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ===== HEADER =====
clear
echo "${CYAN}============================================"
echo "   Bareiron Server Installer (Optimized)"
echo "============================================${NC}"
echo ""

# ===== DISCLAIMER =====
echo "${YELLOW}⚠️  IMPORTANT NOTICE${NC}"
echo "- This software is provided AS IS"
echo "- You are responsible for tunnel setup (Playit, etc.)"
echo "- WE ARE NOT RESPONSIBLE FOR ANY DAMAGES"
echo "- USE AT YOUR OWN RISK"
echo ""

echo "${RED}By continuing, you accept full responsibility.${NC}"
echo ""

read -p "Type 'I ACCEPT' to continue: " consent

if [ "$consent" != "I ACCEPT" ]; then
  echo "${RED}[-] Setup cancelled.${NC}"
  exit 1
fi

echo "${GREEN}[+] Agreement accepted${NC}"
sleep 1

# ===== SYSTEM OPTIMIZATION =====
echo "${BLUE}[+] Optimizing system...${NC}"

# Enable swap if low RAM
if [ "$(free -m | awk '/Mem:/ {print $2}')" -lt 1024 ]; then
  echo "[+] Low RAM detected, creating swap..."
  fallocate -l 1G /swapfile 2>/dev/null || dd if=/dev/zero of=/swapfile bs=1M count=1024
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo "/swapfile none swap sw 0 0" >> /etc/fstab
fi

# ===== INSTALL DEPENDENCIES =====
echo "${BLUE}[+] Installing dependencies...${NC}"
apk update
apk add wget screen curl

# ===== SETUP SERVER =====
echo "${BLUE}[+] Setting up server directory...${NC}"
mkdir -p ~/mc
cd ~/mc || exit

echo "${BLUE}[+] Downloading Bareiron...${NC}"
wget -q -O bareiron https://github.com/p2r3/bareiron/releases/latest/download/bareiron.exe

chmod +x bareiron

# ===== START SCRIPT =====
cat > start.sh << 'EOF'
#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo "${CYAN}[+] Starting Bareiron Server...${NC}"

# Start server in background
screen -dmS mc ./bareiron

echo ""
echo "${GREEN}[+] Server is now running${NC}"
echo "${YELLOW}[!] You must run your own tunnel (Playit / Ngrok / etc.)${NC}"
echo ""
echo "Commands:"
echo "  screen -r mc   → View server"
echo "  screen -ls     → List sessions"
echo ""
EOF

chmod +x start.sh

# ===== FINAL MESSAGE =====
echo ""
echo "${GREEN}============================================${NC}"
echo "${GREEN}✅ INSTALLATION COMPLETE${NC}"
echo "${GREEN}============================================${NC}"
echo ""
echo "Run:"
echo "  ${CYAN}./start.sh${NC}"
echo ""
echo "${YELLOW}Reminder:${NC}"
echo "- Setup your own tunnel (Playit, etc.)"
echo "- Use at your own risk"
