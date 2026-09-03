# Verification & Definition of Done (DoD) Standards

Rules ensuring every engineering task card has measurable, automated, and objective completion criteria.

---

## 1. Concrete Verification Commands
Every task card (`T-NN`) must specify the exact terminal command required to prove that the task functions as expected:
- **Rust**: `cargo test -p [crate-name] --test [test-file]`
- **Go**: `go test -v -race ./[package]/...`
- **TypeScript**: `npm test -- [test-file]`
- **Python**: `pytest tests/[test-file].py -v`

---

## 2. Objective Acceptance Criteria
A Definition of Done cannot be subjective (e.g. "code is clean and looks good"). It must state:
1. **Target Artifacts**: All declared structs, methods, traits, and error variants are implemented and compile without warnings.
2. **Deterministic Assertions**: Concrete assertions demonstrated in test code (e.g. "Verify 10,000 keys survive crash simulation and replay identically").
3. **Quality Gates**: Code passes linting and type checking (e.g. `clippy`, `golangci-lint`, `tsc`, `mypy`).

---

## 3. DoD Checklist Format
Each task card must conclude with a verifiable checklist:
```markdown
- **Verification & DoD**:
  - [ ] Compiles cleanly with zero compiler warnings (`cargo clippy` / `golangci-lint`).
  - [ ] Unit tests pass: `cargo test -p rustykv-protocol test_roundtrip_encode_decode`.
  - [ ] Error edge cases (corrupt checksum, bad magic byte) validated via negative assertions.
```
