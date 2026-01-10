# Week 1: System Planning and Distribution Selection



This week establishes the foundational system architecture, addressing the following learning outcomes:

* **1**: Initial security considerations through service minimisation, headless server deployment, and restricted SSH-based access.
* **2**: Baseline use of command-line tools for system verification and inspection (`uname`, `free`, `df`, `ip`).
* **3**: Evaluation of operating system design trade-offs through structured Linux distribution comparison and justification.

---

## 1. System Architecture Diagram

The following diagram illustrates the planned dual-system architecture consisting of a headless Linux server and a separate administrative workstation. This design enforces command-line proficiency while maintaining strong isolation between systems.

```mermaid
graph TD
    subgraph PhysicalHost ["PHYSICAL HOST MACHINE"]
        direction TB
        
        subgraph VirtualBox ["ORACLE VIRTUALBOX"]
            direction TB

            subgraph VM_Client ["Workstation VM (Client)"]
                direction LR
                Tools["<b>Tools</b><br/>SSH, htop, nmap"]
                OS_Client["<b>OS</b><br/>Ubuntu Desktop 22.04 LTS"]
            end

            VSwitch{{"Virtual Switch"}}

            subgraph VM_Server ["Server VM (Target)"]
                direction LR
                OS_Server["<b>OS</b><br/>Ubuntu Server 22.04 LTS (Headless)"]
                Services["<b>Services</b><br/>SSHD :22, UFW, AppArmor"]
            end

            VM_Client <==>|"Host-Only Traffic"| VSwitch
            VSwitch <==> VM_Server
        end
    end
```

---

## 2. Distribution Selection Justification

The selected server operating system is **Ubuntu Server 22.04 LTS (Jammy Jellyfish)**.

| Feature                | Ubuntu Server 22.04 LTS | CentOS Stream 9  | Debian 11 (Bullseye) | Justification                                                                           |
| ---------------------- | ----------------------- | ---------------- | -------------------- | --------------------------------------------------------------------------------------- |
| **Stability**          | High (LTS until 2027)   | Medium (Rolling) | Very High            | Ubuntu LTS balances long-term stability with modern packages.                           |
| **Package Management** | `apt`                   | `dnf` / `rpm`    | `apt`                | Extensive documentation and familiarity with `apt`.                                     |
| **Security**           | AppArmor enabled        | SELinux enabled  | Manual configuration | AppArmor provides effective mandatory access control with lower configuration overhead. |
| **Community Support**  | Extensive               | Good             | Good                 | Large Ubuntu community simplifies troubleshooting and learning.                         |

**Conclusion:** Ubuntu Server 22.04 LTS provides an optimal balance of stability, security, usability, and support for a headless server environment.

---

## 3. Workstation Configuration

**Selected Option:** Linux Desktop Virtual Machine

* **Operating System:** Ubuntu Desktop 22.04 LTS
* **Purpose:** Administrative access and monitoring

Using a dedicated Linux workstation ensures environmental consistency with the server, isolates coursework tooling from the host system, and enables realistic client–server interaction within VirtualBox.

**single-command (one-liner) solutions** for **each VM**, using PowerShell.
Each command: **creates the VM + disk + network + attaches the ISO**.

---
Powershell command (run as administrator)
---

###  Install **VirtualBox 7.0.14 (stable)**

```powershell
winget install --id Oracle.VirtualBox --version 7.0.14
```

* Accept driver prompts
* Reboot after install

---

###  Verify installation

```powershell
cd "C:\Program Files\Oracle\VirtualBox"
.\VBoxManage.exe --version
```

Expected: `7.0.14r*****`

---

## Ubuntu **Server** VM (all-in-one)

```powershell
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" createvm --name ubuntu-server --ostype Ubuntu_64 --register; & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm ubuntu-server --memory 2048 --cpus 2 --nic1 hostonly --hostonlyadapter1 "VirtualBox Host-Only Ethernet Adapter"; & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" createhd --filename "$env:USERPROFILE\VirtualBox VMs\ubuntu-server.vdi" --size 25000; & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storagectl ubuntu-server --name "SATA" --add sata --controller IntelAhci; & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storageattach ubuntu-server --storagectl "SATA" --port 0 --device 0 --type hdd --medium "$env:USERPROFILE\VirtualBox VMs\ubuntu-server.vdi"; & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storageattach ubuntu-server --storagectl "SATA" --port 1 --device 0 --type dvddrive --medium "C:\Users\ali_x\OneDrive\Desktop\os\ubuntu-22.04.5-live-server-amd64.iso"
```

---

## Ubuntu **Workstation** VM (all-in-one)

```powershell
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" createvm --name ubuntu-workstation --ostype Ubuntu_64 --register; & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm ubuntu-workstation --memory 4096 --cpus 2 --vram 128 --graphicscontroller vmsvga --accelerate3d on --nic1 hostonly --hostonlyadapter1 "VirtualBox Host-Only Ethernet Adapter"; & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" createhd --filename "$env:USERPROFILE\VirtualBox VMs\ubuntu-workstation.vdi" --size 40000; & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storagectl ubuntu-workstation --name "SATA" --add sata --controller IntelAhci; & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storageattach ubuntu-workstation --storagectl "SATA" --port 0 --device 0 --type hdd --medium "$env:USERPROFILE\VirtualBox VMs\ubuntu-workstation.vdi"; & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storageattach ubuntu-workstation --storagectl "SATA" --port 1 --device 0 --type dvddrive --medium "C:\Users\ali_x\OneDrive\Desktop\os\ubuntu-22.04.5-desktop-amd64.iso"
```

---

## Start the VMs (when ready)

```powershell
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm ubuntu-server
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm ubuntu-workstation
```





---

## 4. Network Configuration

A VirtualBox **Host-Only Adapter** is used to create a fully isolated private network. This prevents unintended external exposure while allowing controlled inter-VM communication.

* **Server IP:** `192.168.56.101`
* **Workstation IP:** `192.168.56.102`


This configuration supports secure administration and controlled testing throughout the coursework.

---

## 5. Baseline System Verification

Initial system verification confirms correct installation and network configuration using standard command-line utilities:

```bash
uname -a; free -h; df -h; lsb_release -a; ip addr
```

![System verification output](https://github.com/Z23599848/OS-coursework/blob/main/images/BaselineSystemVerification_week1.png)
![System verification output](https://github.com/Z23599848/OS-coursework/blob/main/images/BaselineSystemVerification1_week1.png)

---

## Sustainability Considerations

Deploying a headless server configuration eliminates unnecessary graphical overhead, reducing CPU and memory consumption. Virtualisation improves hardware utilisation by consolidating workloads, supporting lower energy usage per system. Selecting an LTS distribution further reduces frequent upgrade cycles, extending system lifespan and contributing to reduced operational waste.

---

## Initial Security Assumptions

* The server operates within a trusted, isolated network.
* SSH is the sole remote access mechanism.
* Only essential services are enabled.
* Firewall and mandatory access control policies will be progressively hardened in later weeks.

---

## Week 1 Reflection

This week focused on architectural planning and foundational system decisions. The resulting environment prioritises isolation, sustainability, and security, providing a controlled baseline for subsequent hardening, performance analysis, and automation tasks.

---

[Home](https://github.com/Z23599848/OS-coursework/blob/main/README.md) | [Week 2 →](week2.md)
