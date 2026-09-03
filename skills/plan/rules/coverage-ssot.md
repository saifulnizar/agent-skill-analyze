# TRD Coverage & Single Source of Truth (SSOT) Invariants

Rules ensuring full alignment between the architectural TRD and the engineering tasks.

---

## 1. Zero Missing Architecture (100% TRD Coverage)
- **Component Tracing**: Every component identified in the TRD's architecture diagram and component decomposition must be created or modified by at least one task.
- **Milestone Completeness**: Every Phase and milestone in the TRD roadmap must correspond to a cohesive set of task cards in the breakdown.
- **NFR & Edge Case Inclusion**: Non-functional requirements (e.g. crash recovery, Bloom filters, timeouts, graceful shutdown, chaos tests) must have explicit tasks assigned to them rather than being left as implicit assumptions.

---

## 2. No Invented Scope (Anti-Feature Creep)
- **Strict Boundary**: Tasks must not introduce features, dependencies, or architectural tiers that were not specified or justified in the TRD.
- **No Premature Complexity**: If the TRD explicitly scoped out multi-datacenter replication or distributed transactions, the breakdown must not include exploratory tasks for them.

---

## 3. Discrepancy Resolution Protocol
- If a breakdown analysis discovers an architectural gap in the TRD (e.g. missing error response frame in protocol spec):
  - **Do NOT invent a silent fix** inside a task card without documenting it.
  - Document the missing assumption under the task's notes or update the TRD before proceeding.
