# Distributed Consensus & Replication Protocols

Architecture reference for state machine replication, consensus safety invariants, and high-availability cluster coordination (derived from Ongaro & Ousterhout's Raft paper and Google Chubby/Paxos).

---

## 1. Consensus Core Concepts

Distributed consensus ensures that a cluster of $N$ nodes agrees on a sequence of state transitions, even if up to $F = \lfloor (N - 1) / 2 \rfloor$ nodes crash or partition.

| Cluster Size ($N$) | Maximum Tolerable Failures ($F$) | Majority Quorum Required |
| :---: | :---: | :---: |
| 1 | 0 | 1 |
| 3 | 1 | 2 |
| 5 | 2 | 3 |
| 7 | 3 | 4 |

---

## 2. Raft Protocol Invariants

Every sound Raft implementation must uphold these five foundational safety properties:

1. **Election Safety**: At most one leader can be elected in a given term.
2. **Leader Append-Only**: A leader never overwrites or truncates its own log entries; it only appends new entries.
3. **Log Matching Property**: If two logs contain an entry with the same index and term, they store the same command and their logs are identical in all preceding entries.
4. **Leader Completeness**: If a log entry is committed in a given term, that entry will be present in the logs of the leaders for all higher-numbered terms.
5. **State Machine Safety**: If a server has applied a log entry at a given index to its state machine, no other server will ever apply a different log entry for the same index.

---

## 3. Critical Failure Scenarios & Defenses

### A. Split-Vote Deadlock
- **Problem**: In an election with multiple candidates, votes split evenly and no candidate achieves a majority quorum ($N/2 + 1$).
- **Defense**: **Randomized Election Timeouts** (e.g. 150ms to 300ms). The node with the earliest randomized timer transitions to Candidate first and collects votes before competitors wake up.

### B. Network Partition (Split-Brain)
- **Problem**: A 5-node cluster partitions into $N_1 = \{A, B\}$ (minority) and $N_2 = \{C, D, E\}$ (majority). Node $A$ was the old leader.
- **Defense**:
  - $N_1$ leader receives writes but fails to replicate to $\ge 3$ nodes. Writes stall or reject with `NO_QUORUM`.
  - $N_2$ elects a new leader with a higher term and processes writes successfully.
  - When the partition heals, Node $A$ observes the higher term from $N_2$, steps down to Follower, and truncates uncommitted log entries.

### C. Log Compaction (Snapshots)
- In long-running clusters, logs grow unbounded.
- **Mechanism**: The state machine takes a point-in-time memory/disk snapshot. The Raft log truncates all entries prior to `last_included_index`.
- If a lagging follower requires truncated logs, the leader invokes `InstallSnapshot` RPC instead of `AppendEntries`.

---

## 4. Advanced Raft Invariants & Optimizations

### A. Dynamic Membership Changes (Joint Consensus)
- **Problem**: Changing cluster membership (e.g. from 3 nodes $C_{\text{old}}$ to 5 nodes $C_{\text{new}}$) in a single step risks two independent majorities being formed simultaneously.
- **Two-Phase Joint Consensus Mechanism**:
  1. Leader enters joint configuration $C_{\text{old,new}}$. Any decision (elections, commits) requires **independent majorities from BOTH $C_{\text{old}}$ AND $C_{\text{new}}$**.
  2. Once $C_{\text{old,new}}$ is committed in the log, the leader writes and commits the final $C_{\text{new}}$ configuration.
  3. No split-brain is possible because at no point can disjoint majorities act independently.

### B. Linearizable Reads (Read Index & Leader Leases)
- **Problem**: Serving client `GET` reads from Leader memory without going through consensus risks reading stale data if the leader was silently partitioned away.
- **Read Index Protocol (Safe & High Performance)**:
  1. Leader records its current `commit_index` as `read_index`.
  2. Leader sends a fast heartbeat round to confirm it is still the legitimate leader with majority quorum.
  3. Leader waits until its local state machine applies up to at least `read_index`, then serves the read from memory without writing a new entry to the Raft log.
- **Leader Leases**: Leader acquires a bounded time-based lease from followers; within the lease window, it serves reads locally without heartbeat overhead (requires bounded clock drift).
