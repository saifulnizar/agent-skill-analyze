# System Trade-Offs & Fundamental Constraints Matrix

Ground truth architectural laws and reality checks based on first principles and distributed computing theory.

---

## 1. The CAP Theorem & PACELC Model

In any distributed data store, network partitions ($P$) are an inevitability of physical hardware.

### CAP Invariants
- **CP (Consistency + Partition Tolerance)**:
  - During a partition, the system refuses writes or returns errors if majority quorum cannot be reached to prevent split-brain and stale reads.
  - *Examples*: Raft groups, etcd, ZooKeeper, CockroachDB.
- **AP (Availability + Partition Tolerance)**:
  - During a partition, all nodes remain writable, accepting divergent branches that must be resolved later (eventual consistency, CRDTs, last-write-wins).
  - *Examples*: Dynamo, Cassandra, CouchDB.
- **CA is a Fallacy**: In distributed networks, you cannot "choose CA" because network partitions cannot be chosen away.

### PACELC Extension
- **If Partition ($P$)**: Choose Availability ($A$) or Consistency ($C$).
- **Else ($E$)**: Choose Latency ($L$) or Consistency ($C$).
  - Systems like MongoDB or Cassandra tune this via read/write concerns ($W=1$ for low latency vs $W=\text{majority}$ for strong consistency).

---

## 2. The 8 Fallacies of Distributed Computing (L. Peter Deutsch)
Every solution architecture must explicitly design for the negation of these false assumptions:
1. *The network is reliable* ➔ Networks will drop, corrupt, and reorder packets.
2. *Latency is zero* ➔ Cross-node calls take 0.5ms–100ms; in-memory calls take nanoseconds.
3. *Bandwidth is infinite* ➔ Large payload transfers saturate NICs and cause head-of-line blocking.
4. *The network is secure* ➔ All inter-service traffic must be authenticated and encrypted.
5. *Topology doesn't change* ➔ Nodes crash, scale out, or reschedule dynamically.
6. *There is one administrator* ➔ Systems cross team, cloud, and organizational boundaries.
7. *Transport cost is zero* ➔ Serialization, framing, and deserialization consume non-trivial CPU cycles.
8. *The network is homogeneous* ➔ Systems run on diverse OS kernels, NIC buffers, and MTU sizes.

---

## 3. Storage & Durability Trade-Offs

| Strategy | Durability Guarantee | Write Throughput | Failure Impact |
| :--- | :--- | :--- | :--- |
| **In-Memory Only** | Zero durability | Extreme (> 500k ops/sec) | 100% data loss on crash or OOM kill. |
| **OS Page Cache (Buffered Write)** | Process crash safe | High (~100k ops/sec) | Data lost if OS kernels crash or power fails before dirty page flush. |
| **Periodic fsync (e.g. 100ms)** | Bounded loss ($\le 100\text{ms}$) | High (~50k ops/sec) | Up to 100ms of committed client writes lost on sudden power failure. |
| **Strict fsync Per Write** | Absolute durability (RPO = 0) | Low to Medium (SSD: ~2k–10k IOPS) | Zero data loss, but throughput capped by disk write latency unless batched. |
| **Group Commit / Batching** | Absolute durability | High (~50k–100k ops/sec) | Multiple concurrent write requests combined into a single `fsync` call. |
