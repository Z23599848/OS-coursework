# Week 2: Security Planning and Testing Methodology

## 1. Performance Testing Plan

### Methodology
I will use a "Black Box" monitoring approach where the monitoring script runs on the workstation and queries the server via SSH. This minimizes the observer effect on the server itself.

### Metrics to Monitor
- **CPU:** Usage percentage, load average.
- **Memory:** Used vs. Available RAM, Swap usage.
- **Disk:** I/O wait time, throughput.
- **Network:** Bandwidth usage, latency (ping RTT).

### Tools
- `top`, `free`, `vmstat`, `iostat` (via SSH).
- `sysbench` for generating synthetic loads.

## 2. Security Configuration Checklist

| Category | Control | Status | Justification |
| :--- | :--- | :--- | :--- |
| **SSH** | Disable Root Login | Pending | Prevents direct root access brute-forcing. |
| **SSH** | Disable Password Auth | Pending | Enforces key-based auth, mitigating dictionary attacks. |
| **Firewall** | Enable UFW | Pending | Blocks unauthorized network traffic. |
| **Firewall** | Allow SSH (Port 22) | Pending | Essential for remote administration. |
| **Users** | Create Admin User | Pending | Principle of least privilege. |
| **Updates** | Unattended Upgrades | Pending | Ensures critical security patches are applied auto. |
| **IDS** | Fail2Ban | Pending | Bans IPs after repeated failed login attempts. |

## 3. Threat Model

I have identified three key threats relevant to this server infrastructure:

### Threat 1: SSH Brute Force Attack
- **Description:** An attacker attempts to guess the password for the `root` or `admin` user.
- **Impact:** Full system compromise, data theft, botnet recruitment.
- **Mitigation:** Disable password authentication, enforce SSH keys, install Fail2Ban.

### Threat 2: Privilege Escalation
- **Description:** A compromised low-privileged user attempts to gain root access.
- **Impact:** Full control over the server.
- **Mitigation:** Restrict `sudo` access to specific users, keep kernel updated to patch local exploits.

### Threat 3: Unpatched Service Vulnerability
- **Description:** An attacker exploits a known vulnerability in an outdated service (e.g., old Nginx version).
- **Impact:** Service denial, remote code execution.
- **Mitigation:** Enable unattended upgrades to ensure software is always patched.
