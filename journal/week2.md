# Week 2: Remote Administration and Secure Access

## Learning Outcomes Addressed

This week focuses on the introduction of secure remote administration and command-line system management, addressing the following learning outcomes:

* **LO3**: Apply appropriate security mechanisms for remote access and authentication.
* **LO4**: Demonstrate proficiency with command-line tools for system administration.
* **LO5**: Evaluate security and usability trade-offs in remote system access.

---

## 1. Enabling and Verifying SSH Service

The Ubuntu Server system was installed with the OpenSSH service enabled. The status of the SSH daemon was verified using the systemd service manager to confirm that remote access services were operational.

```bash
systemctl status ssh
```

![SSH service status](https://github.com/Z23599848/OS-coursework/blob/main/images/1_week2.png)

This confirms that the SSH service is running and listening for incoming connections.

---

## 2. Remote Access from Workstation

All administration of the server is performed remotely from the dedicated Linux workstation using SSH. This enforces command-line proficiency and reflects real-world system administration practices.

The workstation connects to the server over the isolated host-only network using the server’s private IP address.

```bash
ssh ali@192.168.56.101
```

![SSH login from workstation](https://github.com/Z23599848/OS-coursework/blob/main/images/2_week2.png)

Upon successful authentication, the server hostname is displayed, confirming remote access to the correct system.

---

## 3. User Identity and Privilege Verification

To ensure adherence to the principle of least privilege, administrative tasks are performed using a non-root user account with controlled escalation via `sudo`.

The following commands were executed to verify user identity, group membership, and sudo permissions:

```bash
whoami; id; groups; sudo -l
```

![User identity and sudo privileges](https://github.com/Z23599848/OS-coursework/blob/main/images/3_week2.png)

This confirms that the user operates without direct root login while retaining administrative capability through privilege escalation.

---

## 4. Network Context and SSH Exposure

The SSH service is accessible only within the private host-only network. Network configuration and active listening ports were verified to ensure SSH is the sole exposed remote access service.

```bash
ip addr; sudo ss -tulpn | grep ssh
```

![SSH listening ports](https://github.com/Z23599848/OS-coursework/blob/main/images/4_week2.png)

This configuration limits the attack surface and supports secure internal administration.

---

## Week 2 Reflection

This week established secure remote administration as the primary management approach for the server. By enforcing SSH-based access and non-root user privileges, the system balances usability with security. These foundations enable further hardening and security enhancements in subsequent weeks.

---

[Home](https://github.com/Z23599848/OS-coursework/blob/main/README.md) | [Week 3 →](week3.md)
