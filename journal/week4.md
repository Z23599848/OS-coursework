# Week 4: Initial System Configuration & Security Implementation

## 1. User Management

I created a new administrative user to avoid using `root` directly.

```bash
sudo adduser admin
sudo usermod -aG sudo admin
```

## 2. SSH Hardening

I modified `/etc/ssh/sshd_config` to secure remote access.

### Before
```
PermitRootLogin yes
PasswordAuthentication yes
```

### After
```
PermitRootLogin no
PasswordAuthentication no
```

**Evidence of successful connection:**
```bash
$ ssh -i ~/.ssh/id_rsa admin@192.168.56.10
Welcome to Ubuntu 22.04.3 LTS (GNU/Linux 5.15.0-91-generic x86_64)
...
admin@server-vm:~$
```

## 3. Firewall Configuration (UFW)

I configured the Uncomplicated Firewall (UFW) to only allow SSH from my workstation.

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from 192.168.56.20 to any port 22 proto tcp
sudo ufw enable
```

**Status Output:**
```bash
admin@server-vm:~$ sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    192.168.56.20
```

## 4. Remote Administration Evidence

I executed the following command from my workstation to verify the server's uptime remotely:

```bash
$ ssh admin@192.168.56.10 "uptime"
 14:30:15 up 2 days,  4:12,  1 user,  load average: 0.00, 0.01, 0.00
```
