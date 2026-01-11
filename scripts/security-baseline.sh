#!/bin/bash

echo "======================================"
echo "   STARTING SECURITY BASELINE AUDIT"
echo "======================================"

# 1. Firewall (UFW)
echo "[1] Checking firewall status..."
if sudo ufw status | grep -q "Status: active"; then
    echo "  [OK] UFW firewall is ACTIVE"
else
    echo "  [FAIL] UFW firewall is NOT active"
fi
echo

# 2. SSH Root Login
echo "[2] Checking SSH root login configuration..."
if sudo grep -q "^PermitRootLogin no" /etc/ssh/sshd_config; then
    echo "  [OK] Root login via SSH is DISABLED"
else
    echo "  [FAIL] Root login via SSH may be ENABLED"
fi
echo

# 3. SSH Password Authentication
echo "[3] Checking SSH password authentication..."
if sudo grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config; then
    echo "  [OK] SSH password authentication is DISABLED"
else
    echo "  [FAIL] SSH password authentication may be ENABLED"
fi
echo

# 4. AppArmor
echo "[4] Checking AppArmor status..."
if sudo aa-status --enabled >/dev/null 2>&1; then
    echo "  [OK] AppArmor is ENABLED"
else
    echo "  [FAIL] AppArmor is NOT enabled"
fi
echo

# 5. Fail2Ban
echo "[5] Checking Fail2Ban service..."
if systemctl is-active --quiet fail2ban; then
    echo "  [OK] Fail2Ban service is RUNNING"
else
    echo "  [FAIL] Fail2Ban service is NOT running"
fi
echo

# 6. Unattended Upgrades
echo "[6] Checking unattended-upgrades service..."
if systemctl is-active --quiet unattended-upgrades; then
    echo "  [OK] Unattended upgrades are ACTIVE"
else
    echo "  [FAIL] Unattended upgrades are NOT active"
fi
echo

echo "======================================"
echo "        SECURITY AUDIT COMPLETE"
echo "======================================"
