## Week 3: Application Selection for Performance Testing

### 1. Overview

In Phase 3, I selected and implemented a suite of tools designed to simulate various types of workloads, including CPU, memory, I/O, and network. The primary factors in choosing these tools were **reproducibility**, **granularity** (precise load control), and **industry relevance**. These utilities will form the foundation for the performance analysis in Week 6.

---

### 2. Application Selection Matrix

The following applications were selected to represent different workload types, as outlined in the project requirements.

| Workload Type         | Selected Application | Rationale                                                                                                                                                                          |
| :-------------------- | :------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **CPU-Intensive**     | **stress-ng**        | A standard stress testing tool. Unlike simple loops, `stress-ng` can target specific CPU instructions (e.g., int, float, double), providing precise, reproducible load generation. |
| **RAM-Intensive**     | **stress-ng (--vm)** | This tool exercises the virtual memory subsystem, forcing page faults and swap usage, effectively testing memory pressure.                                                         |
| **Disk I/O**          | **sysbench**         | A multi-threaded benchmarking tool. Unlike `dd`, `sysbench` can simulate random read/write access patterns, more closely mimicking database behavior.                              |
| **Network-Intensive** | **iperf3**           | A widely used tool for measuring active TCP/UDP bandwidth, independent of disk performance.                                                                                        |
| **Web Server**        | **Nginx**            | A high-performance web server. I chose Nginx over Apache due to its event-driven, resource-efficient architecture, making it suitable for a lightweight, headless server.          |

---

### 3. Installation Procedure

All software was installed via SSH using the `apt` package manager on Ubuntu 24.04 LTS.

#### A. System Update

First, I ensured that the system repositories were up-to-date before installing any software:

```bash
sudo apt update; sudo apt upgrade -y;
```

![System Update](https://github.com/Z23599848/OS-coursework/blob/main/images/week3-1.png)

#### B. Tool Installation

To maintain consistency in dependencies, I installed the tools in a single operation:

```bash
sudo apt install stress-ng sysbench iperf3 nginx -y;
```

![Tool Installation](https://github.com/Z23599848/OS-coursework/blob/main/images/week3-2.png)

#### C. Service Configuration (Nginx and iperf3)

To configure Nginx and iperf3 to start automatically:

```bash
sudo systemctl enable nginx; sudo systemctl start nginx;
```

![Nginx Service Start](https://github.com/Z23599848/OS-coursework/blob/main/images/week3-3.png)

To verify successful installations and services:

```bash
stress-ng --version; systemctl status nginx; iperf3 -s;
```

![Stress-ng Verification](https://github.com/Z23599848/OS-coursework/blob/main/images/week3-4.png)
![Nginx Status](https://github.com/Z23599848/OS-coursework/blob/main/images/week3-5.png)
![Iperf3 Server](https://github.com/Z23599848/OS-coursework/blob/main/images/week3-6.png)

---

### 4. Expected Resource Impact

Based on documentation for each tool, I have projected the expected resource usage during testing in Week 6.

| Application           | Primary Resource Impact | Secondary Impact | Expected Behavior                                                                     |
| :-------------------- | :---------------------- | :--------------- | :------------------------------------------------------------------------------------ |
| **stress-ng --cpu 2** | CPU (100%)              | Thermal / Power  | The system load average will increase to ~2.0, potentially causing lag.               |
| **stress-ng --vm 2**  | RAM (>80%)              | Disk (Swap)      | High memory pressure will trigger swapping, possibly causing "thrashing" if overused. |
| **sysbench fileio**   | Disk I/O                | CPU (Wait)       | Increased "iowait" times will degrade system responsiveness due to bus saturation.    |
| **Nginx (Load Test)** | Network I/O             | CPU (Softirq)    | High network traffic with moderate CPU usage for interrupt handling.                  |

---

### 5. Monitoring Strategy

To assess the resource impact of these applications, I will employ the following monitoring strategy, capturing all data remotely from the Workstation to avoid influencing server performance.

#### A. Real-Time Monitoring (Qualitative)

**Tool:** `htop` via SSH
**Purpose:** Provides visual confirmation that the expected resource is being stressed during the test.

![htop Monitoring](https://github.com/Z23599848/OS-coursework/blob/main/images/week3-7.png)

#### B. Data Logging (Quantitative)

To gather raw performance data for analysis, I will run the following commands through a remote script (`monitor-server.sh`):

1. **CPU Metrics:** `mpstat 1 10`

   * Metric: `%usr` (user space load) vs `%sys` (kernel overhead)

2. **Memory Metrics:** `vmstat 1 10`

   * Metric: `swpd` (swap usage) and `free` (physical RAM)

3. **Disk Metrics:** `iostat -xz 1 10`

   * Metric: `r/s` (reads per second) and `%util` (device saturation)

---

### 6. Critical Reflection

Phase 3 marked a transition from system setup to experiment design, specifically the implementation of reproducible performance testing. Several key insights emerged from this phase.

#### A. Tool Selection: Build vs. Buy

Initially, I considered writing custom Python scripts to generate CPU load. However, I determined that this approach would lack scientific reproducibility due to variability in Python interpreter behavior. Therefore, I chose **`stress-ng`** and **`sysbench`**, industry-standard tools that enable precise control over CPU and memory usage, ensuring consistent results in Week 6.

#### B. Sustainability Considerations

Selecting **Nginx** over Apache was not only based on performance but also on sustainability. Nginx's asynchronous, event-driven model uses fewer resources per concurrent connection compared to Apache’s process-driven approach. This decision aligns with the goal of optimizing energy efficiency in simulated infrastructure, contributing to the reduction of data center electricity consumption.

#### C. The Observer Effect

In designing the monitoring strategy, I considered the **Observer Effect**, which is the risk that the monitoring tool itself consumes resources and skews the results. By using a dedicated Workstation for data collection, separate from the target server, I minimized this effect. The server only runs lightweight monitoring commands (`mpstat`, `iostat`), ensuring that the performance data reflects the application load, not the monitoring overhead.

---

[← Previous: Week 2](./week2.md) | [Return to Home](./index.md) | [Next: Week 4 →](./week4.md)

---

Let me know if you need further customizations or more specific formatting!
