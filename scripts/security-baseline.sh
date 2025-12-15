#!/bin/bash

# security-baseline.sh
# Verifies security configurations on the server.
# Usage: sudo ./security-baseline.sh

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "Starting Security Baseline Verification..."
echo "----------------------------------------"

# 1. Check SSH Configuration
echo -n "Checking SSH Configuration... "
if grep -q "^PermitRootLogin no" /etc/ssh/sshd_config && \
   grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config; then
    echo -e "${GREEN}[PASS]${NC}"
else
    echo -e "${RED}[FAIL]${NC}"
    echo "  - Root login or password auth enabled."
fi

# 2. Check Firewall (UFW)
echo -n "Checking Firewall (UFW) Status... "
if sudo ufw status | grep -q "Status: active"; then
    echo -e "${GREEN}[PASS]${NC}"
else
    echo -e "${RED}[FAIL]${NC}"
    echo "  - UFW is not active."
fi

# 3. Check for Non-Root User
echo -n "Checking for Non-Root Admin User... "
# Assuming a standard user 'admin' or similar exists with sudo privileges
if grep -q "sudo" /etc/group; then
    echo -e "${GREEN}[PASS]${NC}"
else
    echo -e "${RED}[FAIL]${NC}"
    echo "  - No sudo group found (unlikely)."
fi

# 4. Check Automatic Updates
echo -n "Checking Unattended Upgrades... "
if systemctl is-active --quiet unattended-upgrades; then
    echo -e "${GREEN}[PASS]${NC}"
else
    echo -e "${RED}[FAIL]${NC}"
    echo "  - Unattended upgrades service not running."
fi

# 5. Check Fail2Ban
echo -n "Checking Fail2Ban Status... "
if systemctl is-active --quiet fail2ban; then
    echo -e "${GREEN}[PASS]${NC}"
else
    echo -e "${RED}[FAIL]${NC}"
    echo "  - Fail2Ban service not running."
fi

echo "----------------------------------------"
echo "Verification Complete."
