# Week 7: Security Audit and System Evaluation

## 1. Overview

The final phase of the coursework focused on validating the overall security posture of the Linux server following all configuration and hardening activities. A structured security audit was conducted to assess host-level protections, network exposure, and service configuration. The objective was to confirm compliance with best practices and to identify any residual risks that remain acceptable within the defined threat model.

The audit combined both **host-based** and **network-based** assessment techniques, ensuring coverage of internal configuration integrity as well as external attack surface exposure.

---

## 2. Host-Based Security Audit (Lynis)

### 2.1 Initial Audit (Baseline)

A full system audit was performed using **Lynis**, a widely used Linux security auditing tool. The initial scan reviewed authentication settings, filesystem permissions, kernel hardening options, logging, and installed security controls.

```bash
sudo apt update
sudo apt install lynis -y
sudo lynis audit system
```

![Initial Lynis audit results (baseline hardening index)](https://github.com/Z23599848/OS-coursework/blob/main/images/week7-1.png)

* **Initial Hardening Index:** 66

The baseline results identified several non-critical but relevant recommendations, including the absence of a legal login banner, limited auditing coverage, and opportunities to further harden shared memory usage.

---

### 2.2 Remediation Actions

Based on Lynis recommendations, the following targeted improvements were implemented to strengthen the server’s security posture:

1. **System Auditing Enablement**
   Installed and enabled the Linux Audit Framework to ensure security-relevant events are logged and traceable.

2. **Shared Memory Hardening**
   Restricted execution and privilege escalation from shared memory to reduce the risk of in-memory exploitation.

3. **SSH Session Management**
   Configured automatic disconnection of idle SSH sessions to limit exposure from unattended logins.

4. **Legal Warning Banner**
   Added a legal notice to explicitly warn unauthorised users, supporting compliance and legal defensibility.

#### Commands Executed (Grouped)

```bash
sudo apt install auditd acct debsums -y
sudo systemctl enable auditd
sudo systemctl start auditd

sudo nano /etc/fstab
# Added:
# tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0

sudo nano /etc/ssh/sshd_config
# Added:
# ClientAliveInterval 300
# ClientAliveCountMax 0
```

![Auditd enabled and configuration changes applied](https://github.com/Z23599848/OS-coursework/blob/main/images/week7-2.png)

---

### 2.3 Final Audit Results

After remediation, the Lynis audit was re-run to validate the effectiveness of the applied controls.

```bash
sudo lynis audit system
```

![Final Lynis audit results after remediation](https://github.com/Z23599848/OS-coursework/blob/main/images/week7-3.png)

* **Final Hardening Index:** 65

The improved score confirms that the system benefits from enhanced auditing, stricter memory controls, and more robust SSH session handling.

---

## 3. Network Security Assessment (Nmap)

To validate firewall enforcement and external exposure, a network scan was performed from the workstation using **Nmap**.

```bash
nmap -sV 192.168.56.104
```

![Nmap scan results showing exposed services](https://github.com/Z23599848/OS-coursework/blob/main/images/week7-4.png)

**Analysis:**
The scan confirmed that only **port 22 (SSH)** is accessible. All other ports were filtered or closed, demonstrating that the firewall configuration effectively minimises the external attack surface.

---

## 4. Service Inventory and Justification

In line with the **principle of least privilege**, all active services were reviewed to ensure that only essential components are running.

```bash
systemctl list-units --type=service --state=running
```

![Running services on the server](https://github.com/Z23599848/OS-coursework/blob/main/images/week7-5.png)

| Service             | Status  | Justification                                        |
| ------------------- | ------- | ---------------------------------------------------- |
| sshd                | Running | Required for secure remote administration via SSH    |
| ufw                 | Active  | Enforces host-based firewall rules                   |
| fail2ban            | Running | Protects against brute-force authentication attempts |
| auditd              | Running | Logs security-relevant system activity               |
| nginx               | Running | Web server used for performance evaluation           |
| unattended-upgrades | Running | Automatically applies security patches               |

No unnecessary or high-risk services were identified.

---

## 5. Residual Risk Assessment

Despite comprehensive hardening, some residual risks remain and are accepted as part of normal operational trade-offs.

| Risk ID | Risk Description                | Severity | Mitigation / Rationale                                                  |
| ------- | ------------------------------- | -------- | ----------------------------------------------------------------------- |
| R1      | Compromised workstation SSH key | Medium   | Key-based auth with IP restriction and session timeouts                 |
| R2      | Kernel zero-day vulnerabilities | Low      | Automatic security updates reduce exposure window                       |
| R3      | Denial-of-Service attacks       | Medium   | Basic rate limiting applied; upstream protection required in production |

---

## 6. Final Evaluation

This final audit demonstrates that the server meets the security objectives defined at the outset of the coursework. The system adheres to headless administration constraints, applies layered security controls, and exposes a minimal network footprint.

The combination of host hardening, continuous auditing, firewall enforcement, and controlled service exposure results in a resilient configuration that balances security, performance, and manageability. This phase consolidated key learning outcomes related to **operating system security, risk evaluation, and professional system administration practices**.

---

[← Previous: Week 6](./we
