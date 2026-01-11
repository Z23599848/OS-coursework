#!/bin/bash

TARGET_USER="adminuser"
TARGET_IP="192.168.56.104"

# ANSI colors
BOLD="\e[1m"
DIM="\e[2m"
RESET="\e[0m"
BLUE="\e[34m"
CYAN="\e[36m"
GREEN="\e[32m"
YELLOW="\e[33m"

LINE="────────────────────────────────────────"

clear

echo -e "${BOLD}${BLUE}${LINE}"
echo -e "  REMOTE SERVER MONITORING REPORT"
echo -e "  Target: ${CYAN}${TARGET_USER}@${TARGET_IP}${BLUE}"
echo -e "${LINE}${RESET}"
echo

# 1. Memory usage
echo -e "${BOLD}${GREEN}[1] Memory Usage${RESET}"
ssh $TARGET_USER@$TARGET_IP \
  "free -m | awk 'NR==2 {printf \"  Used: %s MB / Total: %s MB\n\", \$3, \$2}'"
echo -e "${DIM}${LINE}${RESET}"
echo

# 2. Disk usage
echo -e "${BOLD}${GREEN}[2] Disk Usage (Root Filesystem)${RESET}"
ssh $TARGET_USER@$TARGET_IP \
  "df -h / | awk 'NR==2 {printf \"  Used: %s / %s (%s)\n\", \$3, \$2, \$5}'"
echo -e "${DIM}${LINE}${RESET}"
echo

# 3. CPU load
echo -e "${BOLD}${GREEN}[3] CPU Load Average${RESET}"
ssh $TARGET_USER@$TARGET_IP \
  "uptime | awk -F'load average:' '{print \"  \" \$2}'"
echo -e "${DIM}${LINE}${RESET}"
echo

# 4. System uptime
echo -e "${BOLD}${GREEN}[4] System Uptime${RESET}"
ssh $TARGET_USER@$TARGET_IP "uptime -p | sed 's/^/  /'"
echo

echo -e "${BOLD}${BLUE}${LINE}"
echo -e "      MONITORING COMPLETE"
echo -e "${LINE}${RESET}"
