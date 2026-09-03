# Universal Coding Standards & Scope Guardrails

Universal best practices that apply across all programming languages when implementing detailing tasks.

---

## 1. Strict Scope Enclosure (Anti-Scope Creep)
- **Bounded Edits**: Only create or modify files explicitly declared in the task's `Target Files` section.
- **No Unapproved Dependencies**: Never introduce external packages, crates, or third-party libraries without explicit declaration in the TRD / breakdown.
- **Isolated Responsibility**: A task should solve exactly its assigned objective. Do not refactor unrelated modules or optimize prematurely outside the task scope.

---

## 2. No TBD, No Placeholders, No Guessing
- **Complete Implementations**: Never leave `TODO`, `TBD`, `TBC`, or placeholder implementations (e.g. empty functions, `unimplemented!()`, `pass`) in production code paths.
- **Unambiguous Types**: All fields, configurations, constants, timeouts, and buffer sizes must have concrete values and explicit types.

---

## 3. Production-Grade Error Handling
- **Explicit Failure Modes**: Every recoverable failure must return an explicit, strongly-typed error.
- **No Swallowed Errors**: Never catch an error/exception and silently ignore it without logging or propagating.
- **Sanitized Logging**: Ensure sensitive data (passwords, private keys, authentication tokens) is masked in log traces.

---

## 4. Testability & Verification
- **Unit Test Coverage**: Every newly created core function, encoder/decoder, state transition, or business rule must have direct unit test coverage.
- **Edge Case Coverage**: Tests must explicitly verify boundary conditions:
  - Empty inputs / empty collections.
  - Maximum payload / buffer limits.
  - Malformed data or corrupt checksums.
  - Network disconnection or timeouts.
- **Deterministic Tests**: Unit tests must not depend on external live network services or unseeded random values.
