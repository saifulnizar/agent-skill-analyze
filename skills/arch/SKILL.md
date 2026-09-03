---
name: arch
description: Analyzes PRDs and generates grounded, production-grade Technical Requirements Documents (TRD) and System Designs. Uses first-principles architectural references to prevent hallucinations. Supports Systems Engines and Enterprise Microservices with interactive archetype selection.
disable-model-invocation: true
---

# Architecture & System Design Engine (`/arch`)

Creates a rigorous, defensible, and grounded **Technical Requirements Document (TRD)** and **System Architecture Specification** from any PRD or specification document without requiring Jira tickets or pre-existing repositories.

## Grounded Architecture Invariant (Anti-Hallucination)
To ensure the AI acts as a **Principal Software Architect / Solution Analyst** rather than generating superficial or ungrounded claims, every generated TRD must strictly adhere to the reference rulebooks in `references/`:
1. **No Silver Bullets**: Every technical choice must declare accepted trade-offs via formal **ADRs** (`references/common/adr-guidelines.md`).
2. **First-Principles Theory**: Validated against CAP, PACELC, and the 8 Fallacies of Distributed Computing (`references/common/tradeoff-matrix.md`).
3. **Hardware Math**: Scale targets must pass back-of-the-envelope calculations for network bandwidth, IOPS, and memory footprint (`references/common/back-of-the-envelope.md`).

---

## When to Use

- When analyzing a PRD for a **greenfield project** (no repository exists yet).
- When designing independent services or systems outside internal microservices constraints.
- When you need a deep, defensible architectural blueprint, data model, API contract, sequence diagrams, failure mode analysis, and phased roadmap.

## Input & Language Support

`/arch [path-to-prd.md] [--lang=indo|id|en]` or provide the content directly in the prompt.

### Language Flag (`--lang`):
- `--lang=indo` / `--lang=id` (or prompt in Indonesian): Emits the entire TRD narrative, executive summary, trade-off explanations, and failure scenarios in **clear, professional Bahasa Indonesia** that is easy for humans/stakeholders to understand. Identifiers, code snippets, API endpoints, and technical terms remain standard English.
- `--lang=en` (default if prompt in English): Emits in standard English.

Supported sources:
1. **Local File / Custom Path**: e.g. `workspaces/{project-name}/prd.md`, `projects/{project-name}/prd.md`, or any local path.
2. **External File / Raw Spec**: Automatically derives slug (e.g. `/Downloads/PRD-Payment-Gateway.md` $\implies$ slug: `payment-gateway`).

---

## Output Target (Workspace Isolation)

To ensure clean multi-user collaboration and zero file collisions, all artifacts for a given PRD are strictly isolated within a dedicated workspace directory:

- **Dedicated Workspace Directory**: `workspaces/{prd-slug}/`
- **Output Architecture File**: `workspaces/{prd-slug}/arch.md` (or `trd.md`)
- **Normalized PRD Archive**: If the source PRD originated outside the target folder, the skill automatically copies/saves the source PRD to `workspaces/{prd-slug}/prd.md`.

---

## Workflow Steps

### Step 0: Archetype Triage & User Confirmation (Interactive Human-in-the-Loop)
Before generating the full TRD, read the PRD, analyze its core problem domain, and present the detected archetype to the user for confirmation:

1. **Systems & High-Throughput Engine** (Storage engines, WAL, Consensus, Custom Binary Wire, Low-level I/O).
   - *References to Load*:
     - [`references/systems-engine/storage-patterns.md`](references/systems-engine/storage-patterns.md) (LSM-Tree, B-Tree, Bitcask, Compaction, Bloom Filters).
     - [`references/systems-engine/consensus-protocols.md`](references/systems-engine/consensus-protocols.md) (Raft, Paxos, Quorums, Leases, Split-Brain).
     - [`references/systems-engine/network-framing.md`](references/systems-engine/network-framing.md) (Binary framing, zero-copy, CRC32, backpressure).
2. **Enterprise Web & Microservices** (Transactional workflows, e-commerce, payment APIs, relational DBs, event-driven architecture).
   - *References to Load*:
     - [`references/enterprise-services/distributed-transactions.md`](references/enterprise-services/distributed-transactions.md) (Transactional Outbox, Sagas, Dual-write prevention).
     - [`references/enterprise-services/reliability-patterns.md`](references/enterprise-services/reliability-patterns.md) (Idempotency keys, Circuit Breakers, Rate limiting).
     - [`references/enterprise-services/data-modeling.md`](references/enterprise-services/data-modeling.md) (Postgres/MySQL indexing, Multi-tenancy, Optimistic locking).
3. **Hybrid Architecture**: Combines microservice business logic with a specialized local data/storage engine.

*The user confirms or selects the archetype, instructing the skill which reference catalog to prioritize.*

---

### Step 1: Requirements Ingestion & Hardware Reality Check
- Extract Functional Requirements (FR), Non-Functional Requirements (NFR), and constraints.
- Perform **Back-of-the-Envelope Calculations** (`references/common/back-of-the-envelope.md`):
  - Estimate QPS, Daily Storage Growth ($QPS \times payload \times 86,400$), Network Bandwidth (Mbps), and Memory requirements.
  - Flag any unrealistic expectations in the PRD (e.g. 100,000 synchronous disk writes per second on a single NVMe drive without batching).

### Step 2: Architecture Topologies & Component Decomposition
- High-level topology diagram (Mermaid `flowchart` or `graph`).
- Component boundaries, data ownership, and network tiers.
- State management: In-memory vs persistent, partition strategy, replication strategy.

### Step 3: Core Technical Deep-Dive & ADRs
- Apply the corresponding domain patterns (LSM/Raft for Systems Engine; Outbox/Saga/Postgres for Enterprise Services).
- Formulate concrete **Architecture Decision Records (ADRs)** following `references/common/adr-guidelines.md`.
- Explicitly declare the **Trade-Offs Accepted** for every major architectural choice.

### Step 4: API & Protocol Specifications
- **Systems Engine**: Custom 16-byte binary wire layout, opcodes, CRC32, zero-copy codecs.
- **Enterprise Services**: REST OpenAPI or gRPC Protobuf schemas, HTTP status codes, Idempotency-Key headers, error payloads.

### Step 5: Execution Flows & Sequence Diagrams
- Critical execution flows visualized in Mermaid `sequenceDiagram`:
  - Primary Write / Mutation Flow (including quorum or outbox).
  - Primary Read Flow (including caching or index lookup).
  - Failure Recovery Flow (Leader election or Saga compensation).

### Step 6: Failure Modes & Mitigations Matrix
- Map failure scenarios:
  - Network partition / Split-brain.
  - Process hard crash during disk write.
  - Third-party / downstream dependency degradation.
  - Thundering herd / backpressure handling.

### Step 7: Phased Implementation Roadmap
- Greenfield milestone breakdown from Phase 1 to Phase N with concrete **Definition of Done (DoD)** and test commands.

---

## Document Template

The full, instructional TRD template is maintained in a dedicated file:
👉 [**`template.md`**](template.md)

When generating the TRD, read and strictly populate every section defined in `template.md`, adapting the narrative language according to the `--lang` flag (Bahasa Indonesia when `--lang=indo`, English when `--lang=en`).
