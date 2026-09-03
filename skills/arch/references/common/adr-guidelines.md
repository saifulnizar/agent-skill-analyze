# Architecture Decision Records (ADR) Guidelines

Rules for capturing technical decisions without bias or ungrounded claims.

---

## 1. The Trade-Off Mandate (Anti-Hype Rule)
In software engineering, **there are no solutions, only trade-offs**.
Every technical decision in a TRD (e.g. choosing a consensus algorithm, storage engine, database type, or communication protocol) must document:
1. **Context & Problem Statement**: What specific requirement forces this decision?
2. **Options Evaluated**: At least 2 realistic alternatives considered.
3. **Decision & Rationale**: Why the chosen option wins in this context.
4. **Negative Consequences & Accepted Trade-Offs**: What do we lose? What operational burden, latency cost, or failure risk do we knowingly accept?

> ⚠️ **Anti-Hallucination Gate**: If an architecture document presents a choice with "only advantages and zero downsides", the analysis is considered ungrounded/hallucinatory and must be revised.

---

## 2. Standard ADR Markdown Template

```markdown
### ADR-[NN]: [Decision Title]

- **Status**: Accepted
- **Context**: [The problem context and driver from PRD]
- **Options Evaluated**:
  1. *[Option A]*: [Pros & Cons]
  2. *[Option B]*: [Pros & Cons]
- **Decision**: Selected **[Option A]** because [explicit technical justification].
- **Trade-Offs Accepted**:
  - [Negative consequence 1, e.g. increased memory consumption]
  - [Negative consequence 2, e.g. background compaction latency jitter]
- **Mitigation Strategy**: [How the accepted drawback will be managed]
```
