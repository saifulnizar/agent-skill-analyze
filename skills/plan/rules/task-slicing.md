# Task Slicing & Granularity Standards

Rules governing the scope, sizing, and atomicity of engineering task cards.

---

## 1. The Atomic Work Unit Rule
Every task card (`T-NN`) must represent a **single, reviewable, and testable unit of software engineering**:
- **One Cohesive Objective**: A task must focus on completing one logical capability (e.g. "Implement WAL append and replay recovery", NOT "Implement WAL, TCP network, and CLI").
- **Single PR / Session Scope**: A task should be small enough to be implemented and verified in one focused development session or git commit set, but substantial enough to carry meaningful behavior.

---

## 2. Anti-Patterns in Task Sizing

### ❌ Anti-Pattern A: The Monolith Task (Too Big)
- **Bad Example**: *"T-01: Build Raft Distributed Consensus Engine"*.
- **Why it fails**: Too many sub-problems (terms, elections, log replication, snapshotting, RPC). An engineer or AI coder will easily miss edge cases, exceed context windows, and create unreviewable code.
- **Remedy**: Slice into sequential atomic tasks:
  - `T-12: Raft State Machine, Terms & Randomized Election`
  - `T-13: Quorum AppendEntries & Commit Advancement`
  - `T-14: Raft Snapshotting & Log Truncation`

### ❌ Anti-Pattern B: The Microscopic Task (Too Small)
- **Bad Example**: *"T-01: Create OpCode enum with 5 variants"*.
- **Why it fails**: Trivial, creates backlog bloat, and cannot be meaningfully verified with an automated integration test on its own.
- **Remedy**: Bundle related structural definitions into a complete codec task (e.g. `T-01: Binary Protocol Framing, OpCode & Codec`).

---

## 3. INVEST Criteria for Tasks
- **Independent**: As loosely coupled as possible from parallel tasks.
- **Negotiable**: Clear technical parameters that can adapt during detailing.
- **Valuable**: Delivers functional progress or a necessary foundational building block.
- **Estimable**: Complexity is clear (Low, Medium, High).
- **Small**: Focused file count (typically 2–5 related files per task).
- **Testable**: Must have clear inputs, outputs, and an automated verification command.
