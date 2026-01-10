## Week 2: Security Planning and Testing Methodology

### 1. Overview

Following the infrastructure deployment completed in Week 1, the emphasis for this phase is on defining a consistent security baseline and a repeatable performance validation framework. The objective is to ensure that all future system changes are deliberate, auditable, and aligned with contemporary **Security-by-Design** principles.

---

### 2. Threat Modeling

To secure a remotely administered, headless Linux server, three primary threat categories have been identified. These threats reflect common risks associated with SSH-accessible systems. Each threat is mapped to mitigation controls scheduled for implementation during Weeks 4 and 5.

| ID     | Threat Vector                  | Description                                                                 | Severity                                        | Planned Mitigations                                                                                                       |
| ------ | ------------------------------ | --------------------------------------------------------------------------- | ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| **T1** | **SSH Brute-Force Attempts**   | Automated scripts repeatedly attempting credential guesses on Port 22.      | **Critical:** Potential full system compromise. | Disable password-based authentication; enforce SSH key-only access; deploy Fail2Ban; restrict SSH to a single trusted IP. |
| **T2** | **Privilege Escalation**       | Exploitation of misconfigurations or vulnerabilities to obtain root access. | **High:** Complete OS-level control.            | Disable remote root login; require `sudo` for privileged actions; apply AppArmor confinement policies.                    |
| **T3** | **Outdated Software Exposure** | Exploitation of known CVEs in unpatched services or kernels.                | **High:** RCE or denial-of-service risk.        | Enable unattended security updates; reduce installed packages to a minimal footprint.                                     |

---

### 3. Security Configuration Baseline

This section defines the target “golden configuration” for the server. Compliance with these settings will later be validated through automated auditing.

#### A. Network and Firewall Configuration (UFW)

* Default behavior: deny all inbound traffic; allow all outbound traffic.
* SSH access limited to Port 22 from workstation IP `192.168.56.6` only.
* Firewall logging enabled at low verbosity.
* ICMP echo requests permitted for internal diagnostics.

#### B. SSH Service Hardening (`/etc/ssh/sshd_config`)

* Enforce SSH Protocol version 2.
* Disable direct root authentication.
* Disable password-based authentication entirely.
* Reject empty passwords.
* Limit authentication attempts to three per session.

#### C. Identity, Privilege, and Access Control

* Lock the root account password using:

  ```
  passwd -l root;
  ```

* **Screenshot placeholder (root account locked):**
  `https://github.com/Z23599848/OS-coursework/blob/main/images/week2-1.png`

* Create a dedicated administrative user (`adminuser`) with sudo privileges.

* Ensure AppArmor is enabled and configured to start at boot.

* Configure sudo to require password re-entry for sensitive administrative commands.

#### D. System Update and Maintenance Policy

* Install and enable unattended security updates.
* Restrict automatic updates to security repositories only.
* Configure automated reboot at 03:00 AM when kernel updates require it.

---

### 4. Performance Testing Methodology

#### A. Test States

Performance measurements will be captured under two operating conditions:

1. **Idle Baseline:** Minimal services active (SSH and core system services).
2. **Stress Condition:** Artificial CPU, memory, or application load applied.

#### B. Remote Monitoring Model

All monitoring is performed remotely from the workstation via SSH to avoid measurement distortion caused by local tooling.

**Selected Toolchain**

* Metrics collection: Custom Bash script leveraging `vmstat; mpstat; free`
* Load generation: `stress-ng` for CPU/RAM; `ab` (ApacheBench) for network throughput
* Live visualization (demonstration only): `htop`

#### C. Performance Indicators

| Metric          | Command Set               | Purpose                                       |
| --------------- | ------------------------- | --------------------------------------------- |
| CPU utilization | `mpstat 1 5;`             | Distinguishes user vs. system CPU consumption |
| Memory usage    | `free -m;`                | Tracks RAM and swap pressure                  |
| Disk I/O        | `iostat -xz 1 5;`         | Identifies storage-related bottlenecks        |
| Network latency | `ping -c 5 192.168.56.6;` | Measures RTT between server and workstation   |

---

### 5. Initial Security Posture Assessment

#### A. Firewall State Verification

The following command sequence confirms the firewall is not active in the default configuration:

```
sudo ufw status verbose;
```

* **Screenshot placeholder (UFW inactive):**
  `https://placeholder.example/screenshots/ufw-status-inactive.png`

The output confirms that UFW is disabled, exposing all listening services on the network.

---

#### B. Exposed Network Services

To enumerate open ports and listening interfaces:

```
ss -tuln;
```

* **Screenshot placeholder (open SSH port):**
  `https://placeholder.example/screenshots/ss-port-22-listen.png`

The results indicate SSH (Port 22) is bound to all interfaces (`0.0.0.0`), making it the primary external attack surface.

---

#### C. SSH Configuration Weaknesses

Default SSH settings were reviewed using:

```
grep -nE "PermitRootLogin|PasswordAuthentication" /etc/ssh/sshd_config;
```

* **Screenshot placeholder (default sshd_config):**
  `https://placeholder.example/screenshots/sshd-config-default.png`

The configuration confirms that both root login and password authentication are enabled by default, presenting a high-risk condition.

---

### 6. Reflection and Key Takeaways

Developing the threat model clarified the importance of layered defenses. Relying on a single control, such as firewall rules, is insufficient on its own. If perimeter restrictions fail, secondary controls—specifically SSH key-based authentication and privilege separation—become critical containment mechanisms. This phase marked a shift from basic functionality toward an intentional, defense-in-depth security mindset.

---

[←Week 1](./week1.md) | [Home]([./index.md](https://github.com/Z23599848/OS-coursework/blob/main/README.md)) | [Week 3 →](./week3.md)

