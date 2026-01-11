#!/bin/bash

# ANSI colors
BOLD="\e[1m"
DIM="\e[2m"
RESET="\e[0m"
BLUE="\e[34m"
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
CYAN="\e[36m"

LINE="────────────────────────────────────────"

clear

echo -e "${BOLD}${BLUE}${LINE}"
echo -e "   STARTING SECURITY BASELINE AUDIT"
echo -e "${LINE}${RESET}"
echo

# 1. Firewall (UFW)
echo -e "${BOLD}${CYAN}[1] Firewall (UFW) Status${RESET}"
if sudo ufw status | grep -q "Status: active"; then
    echo -e "  ${GREEN}[OK]${RESET} UFW firewall is ACTIVE"
else
    echo -e "  ${RED}[FAIL]${RESET} UFW firewall is NOT active"
fi
echo -e "${DIM}${LINE}${RESET}"
echo

# 2. SSH Root Login
echo -e "${BOLD}${CYAN}[2] SSH Root Login Configuration${RESET}"
if sudo grep -q "^PermitRootLogin no" /etc/ssh/sshd_config; then
    echo -e "  ${GREEN}[OK]${RESET} Root login via SSH is DISABLED"
else
    echo -e "  ${RED}[FAIL]${RESET} Root login via SSH may be ENABLED"
fi
echo -e "${DIM}${LINE}${RESET}"
echo

# 3. SSH Password Authentication
echo -e "${BOLD}${CYAN}[3] SSH Password Authentication${RESET}"
if sudo grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config; then
    echo -e "  ${GREEN}[OK]${RESET} SSH password authentication is DISABLED"
else
    echo -e "  ${RED}[FAIL]${RESET} SSH password authentication may be ENABLED"
fi
echo -e "${DIM}${LINE}${RESET}"
echo

# 4. AppArmor
echo -e "${BOLD}${CYAN}[4] AppArmor Status${RESET}"
if sudo aa-status --enabled >/dev/null 2>&1; then
    echo -e "  ${GREEN}[OK]${RESET} AppArmor is ENABLED"
else
    echo -e "  ${RED}[FAIL]${RESET} AppArmor is NOT enabled"
fi
echo -e "${DIM}${LINE}${RESET}"
echo

# 5. Fail2Ban
echo -e "${BOLD}${CYAN}[5] Fail2Ban Service${RESET}"
if systemctl is-active --quiet fail2ban; then
    echo -e "  ${GREEN}[OK]${RESET} Fail2Ban service is RUNNING"
else
    echo -e "  ${RED}[FAIL]${RESET} Fail2Ban service is NOT running"
fi
echo -e "${DIM}${LINE}${RESET}"
echo

# 6. Unattended Upgrades
echo -e "${BOLD}${CYAN}[6] Unattended Upgrades${RESET}"
if systemctl is-active --quiet unattended-upgrades; then
    echo -e "  ${GREEN}[OK]${RESET} Unattended upgrades are ACTIVE"
else
    echo -e "  ${RED}[FAIL]${RESET} Unattended upgrades are NOT active"
fi
echo

echo -e "${BOLD}${BLUE}${LINE}"
echo -e "        SECURITY AUDIT COMPLETE"
echo -e "${LINE}${RESET}"
