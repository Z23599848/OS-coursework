# Week 5: Advanced Security and Monitoring Infrastructure

## 1. Access Control (AppArmor)

Ubuntu uses AppArmor by default. I verified its status and checked the profile for `tcpdump` as an example.

```bash
admin@server-vm:~$ sudo aa-status
apparmor module is loaded.
44 profiles are loaded.
44 profiles are in enforce mode.
   /usr/bin/man
   /usr/sbin/tcpdump
   ...
0 profiles are in complain mode.
0 processes have profiles defined.
0 processes are in enforce mode.
```

## 2. Automatic Security Updates

I configured `unattended-upgrades` to ensure the system stays patched.

**Configuration File:** `/etc/apt/apt.conf.d/50unattended-upgrades`
```
Unattended-Upgrade::Allowed-Origins {
        "${distro_id}:${distro_codename}";
        "${distro_id}:${distro_codename}-security";
        // Extended Security Maintenance; doesn't necessarily exist for
        // every release and this system may not have it installed, but if
        // available, the policy for updates is such that unattended-upgrades
        // should also install from here by default.
        "${distro_id}ESMApps:${distro_codename}-apps-security";
        "${distro_id}ESM:${distro_codename}-infra-security";
};
```

## 3. Intrusion Detection (Fail2Ban)

I installed and configured Fail2Ban to protect the SSH service.

**Jail Configuration:** `/etc/fail2ban/jail.local`
```ini
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
```

**Status Check:**
```bash
admin@server-vm:~$ sudo fail2ban-client status sshd
Status for the jail: sshd
|- Filter
|  |- Currently failed: 0
|  |- Total failed:     5
|  `- File list:        /var/log/auth.log
`- Actions
   |- Currently banned: 1
   |- Total banned:     1
   `- Banned IP list:   192.168.56.105
```

## 4. Security Baseline Verification

I ran the [`security-baseline.sh`](https://raw.githubusercontent.com/Z23599848/OS-coursework/refs/heads/main/scripts/security-baseline.sh) script to verify all controls.
```bash
admin@server-vm:~$ sudo ./security-baseline.sh
Starting Security Baseline Verification...
----------------------------------------
Checking SSH Configuration... [PASS]
Checking Firewall (UFW) Status... [PASS]
Checking for Non-Root Admin User... [PASS]
Checking Unattended Upgrades... [PASS]
Checking Fail2Ban Status... [PASS]
----------------------------------------
Verification Complete.
```
[← Week 4](week4.md) | [Home](https://github.com/Z23599848/OS-coursework/blob/main/README.md) | [Week 6 →](week6.md)
