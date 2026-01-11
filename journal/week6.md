# Week 6: Performance Evaluation and Analysis

## 1. Overview

This phase focused on evaluating how the Linux server behaves under different workloads, identifying performance bottlenecks, and applying targeted optimisations. All testing was performed in line with the methodology defined earlier in the coursework, with an emphasis on quantitative measurement and reproducibility.

Performance data was collected remotely from the workstation via SSH to ensure that monitoring activities did not distort server-side results.

---

## 2. Testing Methodology

### Tools and Approach

The following tools were used to generate load and capture system metrics:

* **Load generation:**

  * `stress-ng` for CPU and memory pressure
  * `ab` (ApacheBench) for HTTP workload simulation
* **Monitoring:**

  * `vmstat` executed remotely over SSH

### Metrics Collected

* CPU utilisation (user time)
* Available memory
* Web server throughput (requests per second)

### Command Execution (Grouped)

```bash
# CPU and memory stress test
stress-ng --cpu 2 --vm 2 --vm-bytes 128M --timeout 60s --metrics-brief

# Remote monitoring via SSH
ssh adminuser@192.168.56.6 "vmstat 1 10"

# Web server benchmarking
sudo apt install apache2-utils -y
ab -n 1000 -c 10 http://127.0.0.1/
```

![Stress-ng execution and vmstat monitoring output](https://github.com/USERNAME/REPO/blob/main/images/week6-1.png)

---

## 3. Baseline and Load Test Results

### Pre-Optimisation Results

| Metric         | Idle State | Under Load  | Observation                       |
| -------------- | ---------- | ----------- | --------------------------------- |
| CPU Usage      | ~1%        | 100%        | CPU saturation caused SSH latency |
| Free Memory    | ~380 MB    | < 50 MB     | System began swapping             |
| Web Throughput | N/A        | 850 req/sec | Initial performance ceiling       |

![ApacheBench baseline results](https://github.com/USERNAME/REPO/blob/main/images/week6-2.png)

These results established a clear baseline and highlighted performance degradation under sustained load.

---

## 4. Bottleneck Analysis

Analysis of the collected data identified two primary operating system–level bottlenecks:

1. **Aggressive memory swapping**
   The default kernel swappiness value caused premature disk I/O under memory pressure, increasing latency.

2. **Web server concurrency limits**
   The default Nginx configuration restricted the number of simultaneous connections, limiting throughput under concurrent access.

---

## 5. Performance Optimisations

Two targeted optimisations were applied to address the identified bottlenecks.

### Optimisation 1: Kernel Swappiness Tuning

* **Change:** Reduced `vm.swappiness` from 60 to 10
* **Rationale:** Encourages the kernel to prioritise RAM usage over disk swapping, reducing I/O latency and unnecessary disk activity

```bash
sudo sysctl vm.swappiness=10
sysctl vm.swappiness
```

![Swappiness value verification](https://github.com/USERNAME/REPO/blob/main/images/week6-3.png)

---

### Optimisation 2: Nginx Connection Scaling

* **Change:** Increased `worker_connections` from 768 to 2048
* **Rationale:** Enables the web server to handle higher concurrency without rejecting requests

```bash
sudo sed -i 's/768/2048/' /etc/nginx/nginx.conf
sudo nginx -t
sudo systemctl reload nginx
```

![Nginx configuration validation](https://github.com/USERNAME/REPO/blob/main/images/week6-4.png)

---

## 6. Post-Optimisation Results

After applying the optimisations, the HTTP benchmark was repeated using the same parameters.

| Metric            | Before   | After    | Improvement     |
| ----------------- | -------- | -------- | --------------- |
| Requests / Second | 2406.77  | 3935.78  | ~29% increase   |
| Time per Request  | 0.415 ms | 0.254 ms | Reduced latency |

![ApacheBench results after optimisation](https://github.com/USERNAME/REPO/blob/main/images/week6-5.png)

The results demonstrate that small, workload-aware configuration changes can significantly improve system performance.

---

## 7. Reflection and Analysis

This phase reinforced the importance of tuning default operating system configurations to match real workloads. While default settings aim for general-purpose stability, they are often suboptimal for specialised use cases such as headless web servers.

Reducing swappiness improved responsiveness while also minimising disk usage, illustrating the trade-off between memory utilisation and long-term system efficiency. Similarly, increasing Nginx concurrency highlighted how application performance is closely coupled with underlying OS resource management.

Overall, this exercise demonstrated how informed, evidence-based optimisation leads to measurable performance gains while maintaining system stability and sustainability.

---

[← Previous: Week 5](./week5.md) | [Home](./index.md) | [Next: Week 7 →](./week7.md)
