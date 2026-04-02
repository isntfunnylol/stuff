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
echo "By using this script, you acknowledge and accept that:"
echo "- You are fully responsible for any damage, data loss, or system issues."
echo "- This is a community-made tool, not an official product."
echo "- You must configure your own network tunnel manually."
echo "- No support or guarantees are provided."
echo ""
echo "The developers:"
echo "- Are NOT responsible for crashes, data loss, or misuse."
echo "- Do NOT guarantee uptime, stability, or compatibility."
echo ""
echo "Use at your own risk."
echo ""

# ===== FAST MIRROR =====
echo "[+] Setting fast Alpine mirror..."
echo "http://mirror1.hs-esslingen.de/pub/Mirrors/alpine/v3.23/main" > /etc/apk/repositories
echo "http://mirror1.hs-esslingen.de/pub/Mirrors/alpine/v3.23/community" >> /etc/apk/repositories

# ===== OPTIONAL OPTIMIZATION =====
echo "[+] Optional performance tweaks..."
read -p "Apply tweaks? (y/n): " opt

if [ "$opt" = "y" ]; then
  sysctl -w vm.swappiness=10 2>/dev/null
  sysctl -w fs.file-max=50000 2>/dev/null
  echo "[+] Tweaks applied"
else
  echo "[!] Skipping tweaks"
fi

# ===== INSTALL MINIMAL DEPENDENCIES =====
echo "[+] Installing minimal dependencies..."
apk update
apk add --no-cache wget screen curl

# ===== SERVER SETUP =====
echo "[+] Setting up server directory..."
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
echo "Use:"
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
echo "- This script does NOT include any tunnel."
echo "- You MUST install and configure your own tunnel manually."
echo "- Examples: Playit, Ngrok, or port forwarding."
echo ""

echo "NOTE:"
echo "- This is not fully updated."
echo "- Some features may require manual fixes."
echo ""

echo "===== TUNNEL SETUP (MANUAL) ====="
echo ""
echo "1. Install your tunnel provider (example: Playit)"
echo "2. Start the tunnel client on your server"
echo "3. Copy the tunnel address provided"
echo "4. Use it to connect to your server"
echo ""

echo "Ultra-low tips:"
echo "- Use low view-distance (4 or lower)"
echo "- Avoid heavy plugins"
echo "- Keep player count low"
echo "- Run only essential services"