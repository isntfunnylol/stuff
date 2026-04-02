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
echo "${CYAN}=================================================="
echo "  Community-made Bareiron Installer for vServer"
echo "==================================================${NC}"
echo ""

# ===== DISCLAIMER =====
echo "${YELLOW}⚠️  IMPORTANT NOTICE / DISCLAIMER${NC}"
echo ""
echo "This script is provided 'AS IS' without any warranty."
echo ""
echo "By using this script, you agree that:"
echo "- You are fully responsible for any damage, data loss, or system issues."
echo "- You understand this is a community-made tool, not an official product."
echo "- You will configure and manage your own network tunnel (Playit, Ngrok, etc.)."
echo "- You accept all risks associated with running servers on your system."
echo ""
echo "The developer(s) of this script:"
echo "- Are NOT responsible for server crashes, data loss, or performance issues."
echo "- Are NOT responsible for misuse of this script."
echo "- Provide no guarantee of uptime, stability, or compatibility."
echo ""
echo "⚠️ Use this script only if you fully understand what you are doing."
echo ""
echo "${RED}Type 'I ACCEPT' to continue.${NC}"
read -p "> " consent

if [ "$consent" != "I ACCEPT" ]; then
  echo "${RED}[-] Cancelled${NC}"
  exit 1
fi

echo "${GREEN}[+] Accepted${NC}"
sleep 1

# ===== FAST MIRROR =====
echo "${BLUE}[+] Setting fast Alpine mirror...${NC}"
echo "http://mirror1.hs-esslingen.de/pub/Mirrors/alpine/v3.23/main" > /etc/apk/repositories
echo "http://mirror1.hs-esslingen.de/pub/Mirrors/alpine/v3.23/community" >> /etc/apk/repositories

# ===== MANUAL OPTIMIZATION =====
echo "${BLUE}[+] Manual optimization (OPTIONAL)...${NC}"
read -p "Apply performance tweaks? (y/n): " opt

if [ "$opt" = "y" ]; then
  sysctl -w vm.swappiness=10 2>/dev/null
  sysctl -w fs.file-max=50000 2>/dev/null
  echo "${GREEN}[+] Tweaks applied${NC}"
else
  echo "${YELLOW}[!] Skipping tweaks${NC}"
fi

# ===== INSTALL MINIMAL DEPENDENCIES =====
echo "${BLUE}[+] Installing minimal packages...${NC}"
apk update
apk add --no-cache wget screen curl

# ===== SERVER SETUP =====
echo "${BLUE}[+] Setting up server folder...${NC}"
mkdir -p ~/mc
cd ~/mc || exit

echo "${BLUE}[+] Downloading Bareiron...${NC}"
wget -q -O bareiron https://github.com/p2r3/bareiron/releases/latest/download/bareiron.exe

chmod +x bareiron

# ===== START SCRIPT =====
cat > start.sh << 'EOF'
#!/bin/sh

echo "[+] Starting Bareiron (Ultra-Low Mode)"

# Ultra-low CPU priority
nice -n 10 screen -dmS mc ./bareiron

echo ""
echo "[+] Server running"
echo "Commands:"
echo "  screen -r mc"
echo "  screen -ls"
echo ""
EOF

chmod +x start.sh

# ===== FINAL MESSAGE =====
echo ""
echo "${GREEN}==================================================${NC}"
echo "${GREEN} INSTALL COMPLETE (ULTRA LOW RAM)${NC}"
echo "${GREEN}==================================================${NC}"
echo ""

echo "Run:"
echo "  ${CYAN}./start.sh${NC}"
echo ""

echo "${RED}IMPORTANT:${NC}"
echo "- This script does NOT include a tunnel."
echo "- You MUST install and configure your own tunnel."
echo "- Examples: Playit, Ngrok, or port forwarding."
echo ""

echo "${YELLOW}⚠️ NOTE:${NC}"
echo "- This is not fully updated."
echo "- Some features may require manual fixes."
echo ""

echo "${BLUE}===== PLAYIT SETUP GUIDE =====${NC}"
echo ""
echo "1. Go to: https://playit.gg"
echo "2. Create an account and download the client"
echo "3. Run Playit on your server:"
echo "   wget https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64 -O playit"
echo "   chmod +x playit"
echo "   ./playit"
echo ""
echo "4. Copy the tunnel address they give you"
echo "5. Use it to connect to your server"
echo ""

echo "${YELLOW}Ultra-low tips:${NC}"
echo "- Use 4 chunk view distance"
echo "- Avoid heavy plugins"
echo "- Keep players low"sleep 1

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
