# Storage Engine Patterns & Disk I/O Mechanics

Architecture reference for low-level storage engines, embedded databases, and write-ahead logging (derived from DDIA Chapter 3, LevelDB, RocksDB, and SQLite architecture).

---

## 1. Storage Engine Archetypes

### A. Log-Structured Merge-Tree (LSM-Tree)
- **Mechanics**:
  1. Writes append sequentially to an in-memory **MemTable** (concurrent SkipList or BTreeMap) and on-disk **WAL**.
  2. When MemTable reaches threshold (e.g. 16MB–64MB), it is frozen into an immutable MemTable and flushed to a sorted **SSTable** file on disk.
  3. Background **Compaction** merges overlapping SSTables, purges tombstones, and discards stale versions.
  4. Reads probe MemTable $\rightarrow$ Immutable MemTable $\rightarrow$ Bloom Filter $\rightarrow$ SSTables (newest to oldest).
- **Best For**: Write-heavy workloads, append-only sensor/log data, distributed replicated stores.
- **Accepted Trade-Offs**: Read amplification, space amplification during compaction, and periodic write stalls if compaction falls behind flushes.

### B. Page-Based B+Tree
- **Mechanics**:
  1. Fixed-size pages (typically 4 KB to 16 KB) organized as a balanced tree directly on disk.
  2. In-place updates overwrite existing pages; modified dirty pages are tracked in memory and flushed via checkpointing.
  3. Durability maintained via a circular Write-Ahead Log (WAL).
- **Best For**: Read-heavy workloads, range queries with predictable latency, embedded relational engines (SQLite, Postgres, InnoDB).
- **Accepted Trade-Offs**: Random disk writes, write amplification on small updates, high concurrency lock contention on root/internal nodes.

### C. Append-Only Bitcask (Hash Index on Log)
- **Mechanics**:
  1. Append-only data log files.
  2. Entire key index stored in in-memory Hash Table (`Key` $\rightarrow$ `[file_id, offset, length]`).
- **Best For**: Fast point lookups, simple implementation, write-heavy key-value caches.
- **Accepted Trade-Offs**: All keys MUST fit in RAM; range scans are slow/unsupported.

---

## 2. Compaction Strategies (LSM-Tree)
- **Size-Tiered Compaction**: Merges SSTables of similar size when a tier has $N$ files. Low write amplification, but high temporary space overhead (up to 100% extra disk).
- **Leveled Compaction (RocksDB style)**: Each level has a fixed maximum size (e.g. L1=10MB, L2=100MB, L3=1GB) with non-overlapping key ranges. Excellent read performance and lower space overhead, but higher write amplification.

---

## 3. Bloom Filter Optimization
- A space-efficient probabilistic data structure placed in the SSTable footer.
- **Formula for optimal bit array size ($m$)**:
  $$m = -\frac{n \ln p}{(\ln 2)^2}$$
  *(For 1% false positive rate ($p=0.01$), allocate approximately 10 bits per key with 7 hash functions).*
- **Guarantees**: If Bloom filter returns `false`, the key definitely does NOT exist in this SSTable $\implies$ saves an entire disk block seek.

---

## 4. Advanced Storage Engine Mechanics

### A. Write Stalls & Backpressure Flow Control
- **Problem**: When client ingestion rate outpaces background compaction bandwidth, L0 SSTables accumulate, causing extreme read latency degradation and memory ballooning.
- **Three-Tier Backpressure Thresholds**:
  1. *Normal*: Ingestion continues without delay.
  2. *Throttling (Soft Limit)*: When L0 SSTable count reaches threshold (e.g. 12 files), inject artificial sleep delay (e.g. 1ms) into write requests to allow the compactor to catch up.
  3. *Full Stall (Hard Limit)*: When L0 reaches critical limit (e.g. 20 files) or MemTable count reaches max limit, halt new writes completely until at least one flush/compaction completes.

### B. OS Page Cache vs Direct I/O (`O_DIRECT`)
- **OS Page Cache (Default)**: Leverages Linux kernel dirty page write-back. High throughput, but risks double-buffering (RAM consumed in both user-space MemTable and kernel page cache) and unpredicted kernel flush latency spikes.
- **Direct I/O (`O_DIRECT` / Unbuffered)**: Bypasses OS kernel page cache; application handles alignment (512B / 4KB sector bounds) and user-space block caching directly. Standard in high-performance engines (e.g. ScyllaDB, InnoDB).
