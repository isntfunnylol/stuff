#!/bin/sh

# ===== HEADER =====
clear
echo "=================================================="
echo "   Community-made Bareiron Installer for 5136"
echo "=================================================="
echo ""

# ===== DISCLAIMER =====
echo "IMPORTANT NOTICE / DISCLAIMER"
echo ""
echo "This script is provided AS IS without warranty."
echo ""
echo "By using this script, you accept full responsibility for:"
echo "- Any system damage, crashes, or data loss"
echo "- Performance issues or instability"
echo "- Security and network configuration"
echo "- Installing and managing your own tunnel"
echo ""
echo "This is a community-made tool."
echo "No guarantees, support, or uptime are provided."
echo ""

read -p "Press ENTER to continue..."

# ===== ROOT CHECK =====
echo "[+] Checking permissions..."
if [ "$(id -u)" -ne 0 ]; then
  echo "[-] Please run as root"
  exit 1
fi

# ===== SYSTEM INFO =====
echo "[+] System detected:"
uname -a

# ===== MIRROR =====
echo "[+] Setting fast mirror..."
cat > /etc/apk/repositories <<EOF
http://mirror1.hs-esslingen.de/pub/Mirrors/alpine/v3.23/main
http://mirror1.hs-esslingen.de/pub/Mirrors/alpine/v3.23/community
EOF

# ===== UPDATE =====
echo "[+] Updating packages..."
apk update

# ===== DEPENDENCIES =====
echo "[+] Installing dependencies..."
apk add --no-cache wget curl screen bash

# ===== DIRECTORY =====
echo "[+] Setting up server directory..."
mkdir -p /root/mc
cd /root/mc || exit

# ===== DOWNLOAD =====
echo "[+] Downloading Bareiron..."
wget -q -O bareiron https://github.com/p2r3/bareiron/releases/latest/download/bareiron.exe
chmod +x bareiron

# ===== CONTROL SYSTEM =====
echo "[+] Creating control system..."

cat > control.sh << 'EOF'
#!/bin/sh

SESSION="mc"

start() {
  echo "[+] Starting server..."

  screen -dmS $SESSION bash -c "
    while true; do
      nice -n 10 ./bareiron
      echo '[!] Crash detected, restarting...'
      sleep 2
    done
  "

  echo "[+] Server started."
}

stop() {
  echo "[+] Stopping server..."
  screen -S $SESSION -X quit
}

status() {
  screen -ls | grep $SESSION && echo "[+] Running" || echo "[-] Not running"
}

case "$1" in
  start) start ;;
  stop) stop ;;
  status) status ;;
  *)
    echo "Usage: $0 {start|stop|status}"
    ;;
esac
EOF

chmod +x control.sh

# ===== START SCRIPT =====
echo "[+] Creating start script..."

cat > start.sh << 'EOF'
#!/bin/sh

cd /root/mc || exit
./control.sh start

echo ""
echo "============================"
echo " Server is running"
echo "============================"
echo ""
echo "Commands:"
echo "  screen -r mc"
echo "  ./control.sh stop"
echo "  ./control.sh status"
echo ""
EOF

chmod +x start.sh

# ===== FINAL =====
echo ""
echo "=================================================="
echo " INSTALL COMPLETE"
echo "=================================================="
echo ""

echo "Run:"
echo "./start.sh"
echo ""

echo "IMPORTANT:"
echo "- This script does NOT include any tunnel."
echo "- You MUST install and configure your own tunnel."
echo "- Examples: Playit, Ngrok, or Port Forwarding."
echo ""

echo "AFTER SETUP:"
echo "1. Install tunnel client"
echo "2. Run tunnel"
echo "3. Use the tunnel address to connect"
echo ""

echo "NOTES:"
echo "- Community-made for 5136"
echo "- Lightweight for low RAM servers"
echo "- Auto-restarts on crash"
echo "- Uses screen for background running"
echo ""

echo "Done."