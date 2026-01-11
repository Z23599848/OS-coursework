#!/bin/bash

TARGET_USER="adminuser"
TARGET_IP="192.168.56.6"

echo "======================================"
echo "  REMOTE SERVER MONITORING REPORT"
echo "  Target: $TARGET_USER@$TARGET_IP"
echo "======================================"
echo

# 1. Memory usage
echo "[1] Memory usage:"
ssh $TARGET_USER@$TARGET_IP "free -m | awk 'NR==2 {print \"Used:\", \$3 \"MB / Total:\", \$2 \"MB\"}'"
echo

# 2. Disk usage
echo "[2] Disk usage (root filesystem):"
ssh $TARGET_USER@$TARGET_IP "df -h / | awk 'NR==2 {print \"Used:\", \$3 \"/\" \$2 \" (\" \$5 \")\"}'"
echo

# 3. CPU load
echo "[3] CPU load average:"
ssh $TARGET_USER@$TARGET_IP "uptime | awk -F'load average:' '{print \$2}'"
echo

# 4. System uptime
echo "[4] System uptime:"
ssh $TARGET_USER@$TARGET_IP "uptime -p"
echo

echo "======================================"
echo "      MONITORING COMPLETE"
echo "======================================"
