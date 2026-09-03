# Dependency & Directed Acyclic Graph (DAG) Rules

Rules governing task sequencing, architecture layering, and dependency relationships.

---

## 1. Strictly Acyclic Dependencies (No Cycles)
- All tasks in `breakdown.md` must form a **Directed Acyclic Graph (DAG)**.
- **Forbidden**: Circular dependencies (e.g. `T-02` depends on `T-03`, but `T-03` depends on `T-02`).
- A task can only declare predecessor tasks that must be merged/committed before this task can compile or function.

---

## 2. Layered Architecture Sequence (Foundation First)
Tasks must follow an ascending architectural dependency order:

```
[Level 1: Protocols, Types & Data Models]
                     │
                     ▼
[Level 2: Core Storage Engine / State Machine]
                     │
                     ▼
[Level 3: Transport, Network & Async Loop]
                     │
                     ▼
[Level 4: High-Level Coordination, Replication & Consensus]
                     │
                     ▼
[Level 5: Horizontal Sharding, SDK & CLI Tooling]
```

### Ordering Rules:
1. **Types & Protocols First**: You cannot write networking or storage logic before frame layouts, error types, or core entities exist.
2. **Core Logic Before Network**: The storage engine or state machine should be tested locally in memory/disk before hooking it up to TCP/HTTP listeners.
3. **Single-Node Before Distributed**: Establish single-node persistence and crash recovery before adding multi-node replication or Raft quorums.
4. **Tooling Last**: Client SDKs, CLI binaries, and high-level integration benchmarks belong at the end of the pipeline.

---

## 3. Mandatory Mermaid DAG Visualization
Every `breakdown.md` must render an interactive Mermaid graph (`graph TD`) mapping:
- Nodes representing tasks `T-01`, `T-02`, etc.
- Directed arrows `-->` representing hard compilation or execution prerequisites.
- Subgraph boundaries indicating milestones or architectural phases.
