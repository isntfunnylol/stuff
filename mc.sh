#!/bin/sh

# ===== HEADER =====
clear
echo "=================================================="
echo "   Community-made Bareiron Installer for 5136"
echo "=================================================="
echo ""

# ===== DISCLAIMER =====
echo "DISCLAIMER"
echo ""
echo "This script is provided AS IS without any warranty."
echo ""
echo "You are responsible for:"
echo "- System damage or data loss"
echo "- Performance and stability"
echo "- Security and configuration"
echo "- Installing your own tunnel"
echo ""
echo "This is a community-made script."
echo "No guarantees are provided."
echo ""

read -p "Press ENTER to continue..."

# ===== ROOT CHECK =====
echo "[+] Checking permissions..."
if [ "$(id -u)" -ne 0 ]; then
  echo "[-] Run as root"
  exit 1
fi

# ===== MIRROR =====
echo "[+] Setting Alpine mirror..."
cat > /etc/apk/repositories <<EOF
http://mirror1.hs-esslingen.de/pub/Mirrors/alpine/v3.23/main
http://mirror1.hs-esslingen.de/pub/Mirrors/alpine/v3.23/community
EOF

# ===== UPDATE =====
echo "[+] Updating..."
apk update

# ===== DEPENDENCIES =====
echo "[+] Installing dependencies..."
apk add --no-cache wget curl screen bash

# ===== DIRECTORY =====
echo "[+] Creating server folder..."
mkdir -p /root/mc
cd /root/mc || exit

# ===== DOWNLOAD SERVER =====
echo "[+] Downloading Bareiron..."
wget -q -O bareiron https://github.com/p2r3/bareiron/releases/latest/download/bareiron.exe
chmod +x bareiron

# ===== CONTROL COMMAND =====
echo "[+] Setting up control command..."

cat > /usr/local/bin/control << 'EOF'
#!/bin/sh

SESSION="mc"
SERVER_DIR="/root/mc"

start() {
  echo "[+] Starting server..."

  screen -dmS "$SESSION" sh -c "
    cd $SERVER_DIR || exit
    while true; do
      nice -n 10 ./bareiron
      echo '[!] Restarting...'
      sleep 2
    done
  "

  echo "[+] Server started"
}

stop() {
  echo "[+] Stopping server..."
  screen -S "$SESSION" -X quit 2>/dev/null
}

status() {
  screen -ls | grep "$SESSION" >/dev/null && echo "[+] Running" || echo "[-] Not running"
}

case "$1" in
  start) start ;;
  stop) stop ;;
  status) status ;;
  *)
    echo "Usage: control {start|stop|status}"
    ;;
esac
EOF

chmod +x /usr/local/bin/control

# ===== START SCRIPT =====
echo "[+] Creating start script..."

cat > start.sh << 'EOF'
#!/bin/sh

echo "[+] Starting server..."
control start

echo ""
echo "Commands:"
echo "  control start"
echo "  control stop"
echo "  control status"
echo ""
echo "Screen:"
echo "  screen -r mc"
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

echo "CONTROL COMMAND:"
echo "control start"
echo "control stop"
echo "control status"
echo ""

echo "IMPORTANT:"
echo "- No tunnel included"
echo "- You MUST install your own tunnel manually"
echo ""

echo "TUNNEL EXAMPLES:"
echo "- Playit"
echo "- Ngrok"
echo "- Port forwarding"
echo ""

echo "NOTES:"
echo "- Community-made for 5136"
echo "- Optimized for low RAM servers"
echo "- Auto restarts on crash"
echo ""

echo "Done."