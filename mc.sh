#!/bin/sh

# ===== HEADER =====
clear
echo "=================================================="
echo "  Community-made Bareiron Installer for vServer"
echo "=================================================="
echo ""

# ===== DISCLAIMER =====
echo "IMPORTANT NOTICE / DISCLAIMER"
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
echo "Use this script only if you fully understand what you are doing."
echo ""
read -p "Type 'I ACCEPT' to continue: " consent

if [ "$consent" != "I ACCEPT" ]; then
  echo "[-] Cancelled"
  exit 1
fi

echo "[+] Accepted"
sleep 1

# ===== FAST MIRROR =====
echo "[+] Setting fast Alpine mirror..."
echo "http://mirror1.hs-esslingen.de/pub/Mirrors/alpine/v3.23/main" > /etc/apk/repositories
echo "http://mirror1.hs-esslingen.de/pub/Mirrors/alpine/v3.23/community" >> /etc/apk/repositories

# ===== MANUAL OPTIMIZATION =====
echo "[+] Manual optimization (OPTIONAL)..."
read -p "Apply performance tweaks? (y/n): " opt

if [ "$opt" = "y" ]; then
  sysctl -w vm.swappiness=10 2>/dev/null
  sysctl -w fs.file-max=50000 2>/dev/null
  echo "[+] Tweaks applied"
else
  echo "[!] Skipping tweaks"
fi

# ===== INSTALL MINIMAL DEPENDENCIES =====
echo "[+] Installing minimal packages..."
apk update
apk add --no-cache wget screen curl

# ===== SERVER SETUP =====
echo "[+] Setting up server folder..."
mkdir -p ~/mc
cd ~/mc || exit

echo "[+] Downloading Bareiron..."
wget -q -O bareiron https://github.com/p2r3/bareiron/releases/latest/download/bareiron.exe

chmod +x bareiron

# ===== START SCRIPT =====
cat > start.sh << 'EOF'
#!/bin/sh

echo "[+] Starting Bareiron (Ultra-Low Mode)"

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
echo "=================================================="
echo " INSTALL COMPLETE (ULTRA LOW RAM)"
echo "=================================================="
echo ""

echo "Run:"
echo "./start.sh"
echo ""

echo "IMPORTANT:"
echo "- This script does NOT include a tunnel."
echo "- You MUST install and configure your own tunnel."
echo "- Examples: Playit, Ngrok, or port forwarding."
echo ""

echo "NOTE:"
echo "- This is not fully updated."
echo "- Some features may require manual fixes."
echo ""

echo "===== PLAYIT SETUP GUIDE ====="
echo ""
echo "1. Go to: https://playit.gg"
echo "2. Create an account and download the client"
echo "3. Run on server:"
echo "   wget https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64 -O playit"
echo "   chmod +x playit"
echo "   ./playit"
echo ""
echo "4. Copy the tunnel address they give you"
echo "5. Use it to connect to your server"
echo ""

echo "Ultra-low tips:"
echo "- Use 4 chunk view distance"
echo "- Avoid heavy plugins"
echo "- Keep players low"