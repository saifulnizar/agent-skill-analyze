---
name: spec
description: Expands a single engineering task from a breakdown (T-NN) into an unambiguous, ready-to-code implementation contract. Multi-language (Rust, Go, TypeScript, Python) with modular coding rules from rules/. Decoupled from Jira.
disable-model-invocation: true
---

# Code Implementation Contract Engine (`/spec`)

Expands **one specific task card** (`T-NN`) from a project's `breakdown.md` and `trd.md` into an unambiguous, code-level **Implementation Contract & Detailing Specification** (`detailing-T-NN-{slug}.md`).

This document serves as the exact instruction manual for a software engineer or AI coding agent to implement the feature without guessing, assumptions, or missing requirements.

## When to Use

- After running `/plan`.
- When preparing an individual task (`T-01`, `T-02`, etc.) for immediate coding/implementation.
- When an engineer or LLM coder needs the exact struct layout, function signatures, error types, step-by-step logic, coding rules, and unit test code before touching the codebase.

## Input & Language Support

`/spec [path-to-breakdown.md] [T-NN] [--lang=indo|id|en]`  
or  
`/spec [T-NN] [--lang=indo|id|en]` (infers `breakdown.md` and `trd.md` in current project context).

### Language Flag (`--lang`):
- `--lang=indo` / `--lang=id` (or prompt in Indonesian): Emits narrative explanations, step-by-step logic, edge case descriptions, and implementation contracts in **clear, professional Bahasa Indonesia**. Code syntax, method names, struct fields, and commands remain in the native programming language.
- `--lang=en` (default if prompt in English): Emits in standard English.

Examples:
- `/spec workspaces/distributed-kv-store/plan.md T-01`
- `/spec workspaces/distributed-kv-store/arch.md T-02`
- `/spec T-01` (inferred from active workspace)

## Output Target (Workspace Isolation)

- **Automatic Folder Creation**: The skill automatically ensures the `{project-dir}/spec/` directory exists before writing.
- **Output File Path**: `{project-dir}/spec/spec-{T-NN}-{slug}.md`  
  (e.g., `workspaces/{project-name}/spec/spec-T-01-binary-protocol-framing.md`).

---

## Workflow Steps

When `/generic-detailing` is executed, the AI follows these 4 sequential steps, strictly applying the language and quality rules:

### Step 1: Task Extraction & TRD Anchor
- Locates the specified task card (`T-NN`) inside `breakdown.md`.
- Traces back to the corresponding sections in `trd.md` (e.g. data schemas, protocol frame layouts, ADR decisions) to ensure 100% technical fidelity.

### Step 2: Language Detection & Rulebook Ingestion
- Identifies the target programming language from the TRD or root project manifest (`Cargo.toml` → Rust, `go.mod` → Go, `package.json` → TypeScript, `pyproject.toml` → Python).
- Loads and strictly applies [`rules/common.md`](rules/common.md) and the matching language rulebook (`rules/{language}.md`).

### Step 3: Complete Type & Logic Contract Generation
- Produces complete, strongly-typed data structures, error enums, and function signatures.
- Writes step-by-step implementation logic and state transition rules.
- Enforces **Zero-TBD/TBC Policy**: All struct fields, error variants, byte offsets, and constants must be fully resolved.
- Explicitly bounds the task using `IN SCOPE`, `OUT OF SCOPE`, and `FORBIDDEN` guards.

### Step 4: Executable Test Suite & Auto-Folder Save
- Writes complete, compilable unit/integration test code testing both happy paths and failure edge cases.
- Automatically ensures `{project-dir}/detailing/` exists and saves to `{project-dir}/detailing/detailing-{T-NN}-{slug}.md` following [`template.md`](template.md).
- Adapts narrative language according to `--lang` flag (Bahasa Indonesia when `--lang=indo`, English when `--lang=en`).

---

## Modular Language Rules Catalog (`rules/`)

1. **Universal Standards**: [`rules/common.md`](rules/common.md) (Anti-Scope Creep, No TBD/TBC, Clean Error Handling).
2. **Language-Specific Idioms**:
   - Rust: [`rules/rust.md`](rules/rust.md) (`#![forbid(unsafe_code)]`, `thiserror`, no unwrap, zero-copy `bytes`, Tokio async safety).
   - Go: [`rules/go.md`](rules/go.md) (error wrapping, `context.Context` propagation, goroutine leak prevention).
   - TypeScript: [`rules/typescript.md`](rules/typescript.md) (strict types, no `any`, async/await error catching).
   - Python: [`rules/python.md`](rules/python.md) (type hints, context managers, Pydantic/dataclasses).

---

## Detailing Quality Rules

1. **Strictly NO `TBD` or `TBC`**:
   - Every file path, struct name, field type, error variant, and configuration constant must be concrete and fully resolved.
2. **Explicit Scope Enclosure**:
   - State `IN SCOPE`, `OUT OF SCOPE`, and `FORBIDDEN` actions to prevent scope creep.
3. **Executable Unit Tests Included**:
   - Must include complete, compilable test functions demonstrating expected inputs, outputs, and edge cases.
4. **Decoupled from Jira**:
   - No Jira issue keys, no Atlassian ADF formats, no Jira sync dependencies.

---

## Document Template

The full, code-level detailing contract template is maintained in a dedicated file:
👉 [**`template.md`**](template.md)

When generating `detailing-T-NN-{slug}.md`, read and strictly populate every section defined in `template.md`, applying the language idioms from `rules/{language}.md` and adapting the narrative language according to the `--lang` flag (Bahasa Indonesia when `--lang=indo`, English when `--lang=en`).
