# Week 3: Application Selection for Performance Testing

## 1. Application Selection Matrix

I have selected the following applications to represent different workload types:

| Application | Workload Type | Justification |
| :--- | :--- | :--- |
| **Nginx** | Network/Web Server | Represents a standard web server workload. Light on CPU, sensitive to network latency. |
| **PostgreSQL** | Disk I/O & Memory | Represents a database workload. Heavy on disk I/O and memory usage. |
| **Stress-ng** | CPU Intensive | Synthetic load generator to stress-test the CPU specifically. |

## 2. Installation Documentation

### Nginx
```bash
sudo apt update
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
```

### PostgreSQL
```bash
sudo apt install -y postgresql postgresql-contrib
sudo systemctl enable postgresql
sudo systemctl start postgresql
```

### Stress-ng
```bash
sudo apt install -y stress-ng
```

## 3. Expected Resource Profiles

- **Nginx:** Low CPU (<5%), Low Memory (<100MB), High Network I/O (dependent on traffic).
- **PostgreSQL:** Medium CPU (10-20%), High Memory (caching), High Disk I/O (writes).
- **Stress-ng:** High CPU (100% on all cores), Low Memory, Low Disk/Network.

## 4. Monitoring Strategy

I will use my `monitor-server.sh` script to capture snapshots of resource usage while these applications are under load.

- **Nginx:** Run `ab` (Apache Bench) from the workstation to generate traffic.
- **PostgreSQL:** Run `pgbench` to simulate database transactions.
- **Stress-ng:** Run specific CPU stressors (e.g., `stress-ng --cpu 2 --timeout 60s`).
