# Week 7: Security Audit and System Evaluation

## 1. Security Audit Report

### Lynis Security Scan
I performed a full system audit using `lynis`.

**Command:**
```bash
sudo lynis audit system
```

**Results:**
- **Hardening Index:** 82/100
- **Critical Findings:** 0
- **Warnings:** 2 (Related to USB storage and Firewire, which are disabled in VirtualBox anyway).

### Network Security Assessment (Nmap)
I scanned the server from the workstation to verify firewall rules.

**Command:**
```bash
nmap -p- 192.168.56.10
```

**Output:**
```
Starting Nmap 7.80 ( https://nmap.org )
Nmap scan report for 192.168.56.10
Host is up (0.00042s latency).
Not shown: 65534 filtered ports
PORT   STATE SERVICE
22/tcp open  ssh
MAC Address: 08:00:27:4C:A2:B3 (Oracle VirtualBox virtual NIC)

Nmap done: 1 IP address (1 host up) scanned in 4.52 seconds
```
**Analysis:** Only port 22 is open, confirming the UFW configuration is correct.

## 2. Service Inventory

| Service | Status | Justification |
| :--- | :--- | :--- |
| `sshd` | Active | Required for remote administration. |
| `nginx` | Active | Web server application (Coursework requirement). |
| `postgresql` | Active | Database application (Coursework requirement). |
| `cron` | Active | System maintenance tasks. |
| `systemd-journald` | Active | Logging service. |
| `fail2ban` | Active | Intrusion detection. |
| `unattended-upgrades` | Active | Automatic security updates. |

## 3. Critical Evaluation and Trade-offs

### Security vs. Usability
Implementing **Key-based Authentication** and disabling password login significantly improved security but increased the complexity of accessing the server from different machines. I had to securely transfer the private key to my backup laptop to maintain access.

### Performance vs. Resource Constraints
Running **PostgreSQL** on a VM with limited RAM (4GB) required careful tuning. The default configuration was too aggressive with memory caching, leading to swapping. Reducing `shared_buffers` and `maintenance_work_mem` improved stability but slightly reduced peak transaction throughput.

### Automation vs. Control
Using **Unattended Upgrades** ensures security but carries the risk of an update breaking a running service. I mitigated this by configuring the system to email me (simulated) on update failure, striking a balance between automation and oversight.

## 4. Final Conclusion
The server infrastructure is now robust, secure, and optimized. The dual-system architecture successfully demonstrated the importance of remote administration skills. The security hardening measures (UFW, Fail2Ban, AppArmor) provide a strong defense-in-depth posture, while the performance tuning ensured efficient resource utilization.

[← Week 6](week6.md) | [Home](https://github.com/Z23599848/OS-coursework/blob/main/README.md)

