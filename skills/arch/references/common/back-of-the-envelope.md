# Back-of-the-Envelope Calculations & System Constants

Mathematical sanity checks and latency constants (derived from Jeff Dean / Peter Norvig numbers) to ground performance claims in hardware reality.

---

## 1. Latency Numbers Every Engineer Should Know

| Hardware Operation | Approximate Latency | Comparison Scale |
| :--- | :--- | :--- |
| **L1 CPU Cache Reference** | 0.5 ns | 1 second |
| **Branch Mispredict** | 5 ns | 10 seconds |
| **L2 CPU Cache Reference** | 7 ns | 14 seconds |
| **Mutex Lock / Unlock** | 25 ns | 50 seconds |
| **Main Memory (RAM) Access** | 100 ns | 3.3 minutes |
| **Compress 1KB with Snappy** | 2,000 ns (2 µs) | 1 hour |
| **Send 1KB over 10Gbps Network**| 10,000 ns (10 µs) | 5.5 hours |
| **Read 1MB Sequentially from RAM**| 250,000 ns (250 µs)| 5.7 days |
| **Read 1MB Sequentially from NVMe SSD**| 1,000,000 ns (1 ms)| 3 weeks |
| **Read 1MB Sequentially from HDD**| 20,000,000 ns (20 ms)| 1.2 years |
| **Cross-Datacenter RTT (e.g. US to EU)**| 150,000,000 ns (150 ms)| 9.5 years |

---

## 2. Standard Capacity & Scaling Formulas

### A. Throughput & Storage Volume
$$\text{Storage Per Day} = \text{QPS} \times \text{Average Payload Size (Bytes)} \times 86,400\text{ seconds}$$

*Example*:
- 1,000 writes/sec with 1 KB payload:
  $$1,000 \times 1,024 \times 86,400 \approx 88.4\text{ GB / day} \approx 32.2\text{ TB / year}$$
- Plus 3x replication factor = **~96.6 TB raw storage / year**.

### B. Memory (RAM) Sizing for Caches (80/20 Rule)
- 80% of read requests target 20% of the active dataset.
$$\text{Target Cache RAM} = 0.20 \times \text{Daily Active Working Set}$$

### C. Concurrent Connection Memory Overhead
- Each idle TCP socket typically consumes:
  - Linux kernel socket buffers (`rmem`/`wmem`): 4 KB to 64 KB.
  - Tokio task / Go goroutine stack: 2 KB to 8 KB.
  - $\implies 100,000$ concurrent idle connections $\approx 600\text{ MB to } 2\text{ GB}$ of RAM overhead alone.

---

## 3. Anti-Hallucination Sanity Checklist
When a PRD states scale targets, the TRD must perform these sanity checks:
1. **Network Saturation Check**: Does $\text{Target QPS} \times \text{Payload Size}$ exceed standard 1 Gbps (125 MB/s) or 10 Gbps NIC limits?
2. **Disk IOPS Check**: Does the synchronous write rate exceed NVMe SSD random write limits (50k–100k IOPS) without write batching/group commit?
3. **Bandwidth Headroom**: Account for 2x–3x amplification from replication and gossip heartbeats.
