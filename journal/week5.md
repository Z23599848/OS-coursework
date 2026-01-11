# Week 5: Advanced Security & Monitoring Infrastructure

## 1. Overview

This phase extends the baseline security controls implemented previously by introducing **mandatory access control**, **automated patch management**, and **active intrusion detection**. In parallel, automation scripts were developed to verify security posture and to monitor system health remotely, reinforcing repeatability and operational assurance.

---

## 2. Advanced Security Controls

### 2.1 Mandatory Access Control – AppArmor

AppArmor was enabled and verified to constrain application behaviour beyond traditional discretionary access control (DAC). This ensures that even if a service is compromised, its ability to access the wider filesystem remains tightly restricted.

### Command Execution (grouped)

```bash
sudo apt update;
sudo apt install apparmor-utils -y;
sudo aa-status
```

![AppArmor status and enforced profiles](https://github.com/Z23599848/OS-coursework/blob/main/images/week5-1.png)
![AppArmor status and enforced profiles](https://github.com/Z23599848/OS-coursework/blob/main/images/week5-2.png)

**Security Impact:** Enforced AppArmor profiles provide containment at the application level, reducing lateral movement and post-exploitation impact.

---

### 2.2 Automated Security Updates

To address the risk of unpatched vulnerabilities, unattended security updates were configured. This ensures timely installation of security fixes without manual intervention.

**Policy Configuration:**

* Automatic installation of security updates
* Controlled automatic reboot scheduling for kernel updates

### Command Execution (grouped)

```bash
sudo apt install unattended-upgrades -y;
sudo dpkg-reconfigure --priority=low unattended-upgrades;
systemctl status unattended-upgrades
```

![Unattended upgrades active status](https://github.com/Z23599848/OS-coursework/blob/main/images/week5-3.png)

**Operational Benefit:** This significantly reduces exposure windows for known vulnerabilities while maintaining system stability.

---

### 2.3 Intrusion Detection – Fail2Ban

Fail2Ban was deployed to actively monitor authentication logs and dynamically block sources exhibiting malicious behaviour.

**Enforcement Policy:**

* Trigger: 5 failed SSH login attempts within 10 minutes
* Response: Temporary IP ban (1 hour)
* Configuration persistence via `jail.local`

### Command Execution (grouped)

```bash
# Install fail2ban (if not installed)
sudo apt install fail2ban -y;
# Copy jail.conf to jail.local (for local configuration)
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local;
# Restart the fail2ban service
sudo systemctl restart fail2ban;
# Check the status of the Fail2Ban service
sudo systemctl status fail2ban;
# If needed, check the status of the sshd jail
sudo fail2ban-client status sshd;
```

![Fail2Ban SSH jail status](https://github.com/Z23599848/OS-coursework/blob/main/images/week5-4.png)

**Security Impact:** Automated banning reduces brute-force attack effectiveness and log noise.

---

## 3. Automation and Monitoring

### 3.1 Security Baseline Verification Script (`security-baseline.sh`)

A server-side Bash script was created to validate the continued presence of critical security controls introduced in Weeks 4 and 5. This script acts as a lightweight compliance check and supports configuration drift detection.

### Script Deployment and Execution

```bash
nano ~/security-baseline.sh;
chmod +x ~/security-baseline.sh;
./security-baseline.sh
```

![Security baseline script execution](https://github.com/Z23599848/OS-coursework/blob/main/images/week5-5.png)

**Value:** Security checks become repeatable, fast, and less prone to human error.

---

### 3.2 Remote Monitoring Script (`monitor-server.sh`)

A client-side monitoring script was developed to collect essential performance metrics via SSH, enabling visibility into server health without maintaining an active terminal session.

### Script Execution

```bash
nano ./monitor-server.sh;
chmod +x ./monitor-server.sh;
./monitor-server.sh
```

![Remote monitoring script output](https://github.com/Z23599848/OS-coursework/blob/main/images/week5-6.png)


**Operational Benefit:** This approach supports scalable monitoring and forms the foundation for future automation or alerting.

---

## 4. Reflection and Key Takeaways

Developing automated verification and monitoring reinforced the importance of treating infrastructure as code. Instead of relying on manual checks, the system can now self-report deviations from its intended security state. This significantly improves reliability and highlights how automation reduces both operational overhead and configuration drift risk.

---

[← Previous: Week 4](./week4.md) | [Return to Home](./index.md) | [Next: Week 6 →](./week6.md)
