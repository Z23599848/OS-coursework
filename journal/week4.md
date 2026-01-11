# Week 4: Initial System Configuration & Security Implementation

## 1. Overview

This week marks the transition from planning to execution. The security strategies designed earlier were implemented directly on the server, with a strong emphasis on minimising the attack surface. The primary objectives were to enforce least-privilege access, remove password-based authentication, and restrict remote access exclusively to the administrator’s workstation.

**Administrative Constraint:** All configuration changes were carried out remotely via SSH, in full compliance with the assessment requirements.

---

## 2. User and Privilege Management

To align with the Principle of Least Privilege, administrative responsibilities were separated from default system accounts by introducing a dedicated administrator user.

### Actions Performed

* Created a new administrative user to clearly distinguish human administration from system processes.
* Granted this user controlled elevation rights via the `sudo` group.
* Prevented routine use of the root account, ensuring all privileged actions are auditable.

### Command Execution (grouped)

```bash
sudo adduser adminuser;
sudo usermod -aG sudo adminuser
```

**Security Rationale:** Disabling direct root usage significantly reduces the likelihood of successful brute-force attacks and improves accountability through logged privilege escalation.

**Screenshot evidence:**

![User creation and sudo assignment](https://github.com/Z23599848/OS-coursework/blob/main/images/week4-1.png)


A single terminal capture showing both commands executed sequentially, following the screenshot style used throughout the repository.

---

## 3. SSH Configuration and Hardening

### 3.1 Key-Based Authentication

Password authentication was replaced with public key authentication to eliminate credential guessing attacks. An Ed25519 key pair was selected due to its modern cryptographic strength and efficiency.

### Command Execution (grouped)

```bash
ssh-keygen -t ed25519 -C "admin_access";
ssh-copy-id -i ~/.ssh/id_ed25519.pub adminuser@192.168.56.104;
ssh adminuser@192.168.56.104
```

**Outcome:** Successful login using the private key confirmed that password-based access was no longer required.


![SSH key-based login](https://github.com/Z23599848/OS-coursework/blob/main/images/week4-2.png)
![SSH key-based login](https://github.com/Z23599848/OS-coursework/blob/main/images/week4-3.png)
![SSH key-based login](https://github.com/Z23599848/OS-coursework/blob/main/images/week4-4.png)


One screenshot capturing the full authentication workflow.

---

### 3.2 SSH Daemon Hardening (Before and After)

The SSH daemon configuration was tightened to explicitly disable insecure defaults.

| Directive              | Previous State    | Updated State | Justification                       |
| ---------------------- | ----------------- | ------------- | ----------------------------------- |
| PermitRootLogin        | Enabled (default) | Disabled      | Removes a high-value attack target  |
| PasswordAuthentication | Enabled           | Disabled      | Forces cryptographic authentication |
| PubkeyAuthentication   | Enabled           | Enabled       | Maintains secure access mechanism   |

### Verification and Deployment

```bash
sudo grep -E "PermitRootLogin|PasswordAuthentication" /etc/ssh/sshd_config;
sudo systemctl restart ssh
```

**Screenshot evidence:**


![SSH configuration before and after](https://github.com/Z23599848/OS-coursework/blob/main/images/week4-5.png)


A single screenshot showing the configuration verification and SSH service restart.

---

## 4. Firewall Configuration (UFW)

A default-deny firewall posture was implemented using Uncomplicated Firewall (UFW). Only SSH traffic originating from the administrator workstation IP was permitted.

### Firewall Policy

* Incoming traffic: Denied by default
* Outgoing traffic: Allowed
* Explicit allow rule: SSH from workstation IP only

### Command Execution (grouped)

```bash
sudo ufw default deny incoming;
sudo ufw default allow outgoing;
sudo ufw allow from 192.168.56.104 to any port 22;
sudo ufw enable;
sudo ufw status numbered
```

**Security Impact:** This configuration ensures that even if a service is accidentally exposed, it remains unreachable from unauthorised hosts.

**Screenshot evidence:**


![UFW firewall ruleset](https://github.com/Z23599848/OS-coursework/blob/main/images/week4-6.png)


One screenshot displaying the enabled firewall and the final numbered ruleset.

---

## 5. Risk Management and Operational Reflection

Applying security controls over an SSH-only connection introduces the risk of accidental lockout. This was mitigated through staged validation: SSH key authentication was confirmed in a separate session before disabling password access, and firewall rules were verified prior to enabling enforcement.

This process reinforced a key operational principle used in professional environments: validate access paths before committing restrictive controls. The experience highlighted the importance of redundancy and cautious sequencing when administering headless systems.

---

[←Week 3](./week3.md) | [Home](https://github.com/Z23599848/OS-coursework/blob/main/README.md) | [Week 5 →](./week5.md)
