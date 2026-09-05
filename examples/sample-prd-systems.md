# PRD: Distributed Persistent Key-Value Store (FlashKV)

## 1. Executive Summary & Objective
Build a lightweight, highly-available, distributed embedded Key-Value (KV) storage engine designed for ultra-low latency write throughput and linearizable reads across a cluster of 3 to 5 nodes.

## 2. Target Users & Use Cases
- High-throughput telemetry and session cache storage.
- Embedded data layer for edge microservices requiring crash-safety without external database dependencies.

## 3. Core Functional Requirements
1. **Key-Value Storage Operations**:
   - `PUT(key: string, value: bytes) -> Result<Ok, Error>`
   - `GET(key: string) -> Result<Option<bytes>, Error>`
   - `DELETE(key: string) -> Result<Ok, Error>`
   - `SCAN(start_key: string, end_key: string, limit: u32) -> Result<Vec<(string, bytes)>, Error>`
2. **Durability & Crash Recovery**:
   - Append-Only Write-Ahead Log (WAL) with configurable `fsync` policies (`Always`, `Batch(ms)`, `Periodic(s)`).
   - In-memory MemTable backed by SkipList or LSM-Tree design with background SSTable compaction.
3. **Consensus & Replication**:
   - Leader-based Raft consensus for multi-node linearizable reads and atomic state machine replication.
   - Heartbeat intervals, randomized election timeouts, and dynamic cluster membership changes.
4. **Wire Protocol & Client SDK**:
   - High-performance binary protocol over TCP with CRC32 frame checksums.
   - Optional gRPC / Protobuf interface for polyglot client connectivity.

## 4. Non-Functional Requirements & Scale
- **Write Latency**: P99 < 5ms under 50,000 writes/sec per node.
- **Read Latency**: P99 < 1ms for in-memory / cached keys.
- **Data Size**: Up to 500GB storage footprint per node.
- **Consistency Model**: Sequential consistency for standard reads, Strict Linearizability for critical paths.
