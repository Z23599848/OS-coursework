````md
<!-- ========================================================= -->
<!--        🖥️ COMPUTER CONTEXT / SYSTEM DOCS TEMPLATE          -->
<!--        Focus: Linux Bash commands + results output         -->
<!-- ========================================================= -->

# 🐧 Linux System Documentation (Markdown Template)

> **Purpose:**  
> This document demonstrates how to write **computer-context documentation** using Markdown, with a strong focus on **Bash commands**, **terminal output**, and **system inspection**.

---

## 📑 Table of Contents
- [Environment Overview](#environment-overview)
- [System Information](#system-information)
- [Filesystem](#filesystem)
- [Networking](#networking)
- [Processes & Resources](#processes--resources)
- [Package Management](#package-management)
- [Logs & Debugging](#logs--debugging)
- [Automation Script Example](#automation-script-example)
- [Troubleshooting Notes](#troubleshooting-notes)

---

## 🧾 Environment Overview

**Host:** `server-01`  
**OS:** Ubuntu 22.04 LTS  
**Kernel:** `5.15.x`  
**Shell:** `bash`

```text
Documentation style:
- 🟦 Blue box → Command
- ⬛ Black box → Command output
````

---

## 💻 System Information

### Check OS Version

**Command**

```bash
cat /etc/os-release
```

**Output**

```text
NAME="Ubuntu"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
ID=ubuntu
ID_LIKE=debian
```

---

### Kernel & Architecture

**Command**

```bash
uname -a
```

**Output**

```text
Linux server-01 5.15.0-91-generic x86_64 GNU/Linux
```

---

## 📁 Filesystem

### Disk Usage

**Command**

```bash
df -h
```

**Output**

```text
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        50G   22G   26G  46% /
tmpfs           3.8G     0  3.8G   0% /dev/shm
```

---

### Directory Structure

**Command**

```bash
ls -lah /var/www
```

**Output**

```text
total 12K
drwxr-xr-x  3 root root 4.0K Jan 10 12:00 .
drwxr-xr-x 14 root root 4.0K Jan 10 11:55 ..
drwxr-xr-x  5 www-data www-data 4.0K Jan 10 12:01 html
```

---

## 🌐 Networking

### IP Configuration

**Command**

```bash
ip addr show
```

**Output**

```text
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP>
    inet 192.168.1.50/24 brd 192.168.1.255 scope global eth0
```

---

### Open Ports

**Command**

```bash
ss -tuln
```

**Output**

```text
Netid  State   Local Address:Port
tcp    LISTEN  0.0.0.0:22
tcp    LISTEN  0.0.0.0:80
```

---

## ⚙️ Processes & Resources

### CPU & Memory

**Command**

```bash
top -bn1 | head -n 10
```

**Output**

```text
%Cpu(s):  3.2 us,  1.1 sy,  0.0 ni, 95.1 id
MiB Mem :  7850 total,  4120 free,  2100 used
```

---

### Running Services

**Command**

```bash
systemctl status nginx
```

**Output**

```text
● nginx.service - A high performance web server
     Active: active (running)
```

---

## 📦 Package Management

### Update System

**Command**

```bash
sudo apt update
```

**Output**

```text
Reading package lists... Done
All packages are up to date.
```

---

### Installed Package Version

**Command**

```bash
nginx -v
```

**Output**

```text
nginx version: nginx/1.18.0 (Ubuntu)
```

---

## 📜 Logs & Debugging

### View System Logs

**Command**

```bash
journalctl -xe
```

**Output**

```text
Jan 10 12:34:01 server-01 systemd[1]: Started Session 42.
```

---

### Application Log

**Command**

```bash
tail -n 5 /var/log/nginx/error.log
```

**Output**

```text
2025/01/10 12:33:55 [error] 1234#1234: connect() failed (111: Connection refused)
```

---

## 🤖 Automation Script Example

### Backup Script

```bash
#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="/backup"
SRC_DIR="/var/www/html"

mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/site-$(date +%F).tar.gz" "$SRC_DIR"

echo "Backup completed successfully."
```

**Execution**

```bash
./backup.sh
```

**Result**

```text
Backup completed successfully.
```

---

## 🛠️ Troubleshooting Notes

> ⚠️ **Common Issues**
>
> * Port 80 blocked → check firewall (`ufw status`)
> * High memory usage → inspect with `htop`
> * Service not starting → `journalctl -u service-name`

---

## 🧠 Best Practices

* Always **separate commands from output**
* Never edit output blocks
* Redact secrets (`******`)
* Add timestamps to logs
* Prefer reproducible commands

---

## 🏁 End of Document

**Maintainer:** DevOps Team
**Last Updated:** `2025-01-10`

---

✅ This format is ideal for:

* DevOps runbooks
* Incident reports
* System audits
* Knowledge bases
* README.md files

Let me know if you want:

* 🔐 security hardening docs
* 🐳 Docker / Kubernetes version
* 📊 monitoring & metrics examples
