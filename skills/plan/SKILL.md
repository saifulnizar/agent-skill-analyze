---
name: plan
description: Slices an architecture TRD into actionable engineering task cards (T-01, T-02, ...) grouped by module or milestone. Uses modular rules from rules/ for task sizing, DAG ordering, TRD coverage, and DoD. Decoupled from Jira.
disable-model-invocation: true
---

# Task Planning & DAG Decomposition Engine (`/plan`)

Breaks down a **Technical Requirements Document (TRD)** into a clean, structured set of engineering task cards (`breakdown.md`). It bridges the gap between high-level architectural design and hands-on code implementation without requiring Jira tickets, Atlassian MCP, or pre-existing repositories.

## When to Use

- After generating a TRD using `/arch`.
- When slicing system architecture and milestones into concrete, developer-ready work items.
- For greenfield projects where tasks define new files, modules, and tests from scratch.
- For standalone repositories where work items are tracked locally or in GitHub Issues / Markdown.

## Input & Language Support

`/plan [path-to-trd.md] [--lang=indo|id|en]`

### Language Flag (`--lang`):
- `--lang=indo` / `--lang=id` (or prompt in Indonesian): Emits the task descriptions, objectives, steps, and verification notes in **clear, professional Bahasa Indonesia**. Structs, code blocks, target file paths, and terminal commands remain standard.
- `--lang=en` (default if prompt in English): Emits in standard English.

Supported inputs:
1. Explicit path to Architecture file: e.g. `workspaces/{project-name}/arch.md` (or `trd.md`).
2. Project workspace folder: e.g. `workspaces/{project-name}/`.
3. Inferred automatically from current active project context.

## Output Target (Workspace Isolation)

- **Output File**: Writes directly alongside the source architecture document at `{arch-dir}/plan.md`  
  (e.g., `workspaces/{project-name}/plan.md` or `breakdown.md`).

---

## Workflow Steps

When `/generic-breakdown` is executed, the AI follows these 4 sequential steps, strictly applying all 4 modular rules:

### Step 1: TRD Ingestion & 100% Coverage Mapping
- Reads `trd.md`, extracts all architectural components, NFRs, and roadmap phases.
- **Rule Applied**: [`rules/coverage-ssot.md`](rules/coverage-ssot.md) (ensures 100% TRD coverage, zero missing components, and zero invented scope).

### Step 2: Atomic Task Slicing (`T-01` to `T-NN`)
- Breaks each TRD phase into discrete, focused task cards.
- **Rule Applied**: [`rules/task-slicing.md`](rules/task-slicing.md) (applies INVEST principles; ensures 1 task = 1 reviewable, testable work unit; eliminates monoliths and trivial tasks).

### Step 3: Layered Dependency DAG Construction
- Orders all tasks in strict bottom-up architectural sequence (Types/Protocols $\rightarrow$ Core Storage $\rightarrow$ Transport $\rightarrow$ Coordination $\rightarrow$ Tooling).
- Validates that dependencies are strictly acyclic (no circular references).
- **Rule Applied**: [`rules/dependency-dag.md`](rules/dependency-dag.md) (builds the interactive Mermaid `graph TD` dependency graph).

### Step 4: Output Generation with Verifiable DoD
- Writes the final output to `{project-dir}/breakdown.md` following [`template.md`](template.md).
- **Rule Applied**: [`rules/verification-dod.md`](rules/verification-dod.md) (ensures every task has concrete, executable test commands and clear DoD checklists).
- Adapts narrative language according to `--lang` flag (Bahasa Indonesia when `--lang=indo`, English when `--lang=en`).

---

## Modular Breakdown Rules Catalog (`rules/`)

1. **Task Sizing & Granularity**: [`rules/task-slicing.md`](rules/task-slicing.md)
2. **Dependency & DAG Sequencing**: [`rules/dependency-dag.md`](rules/dependency-dag.md)
3. **TRD Coverage & SSOT Invariants**: [`rules/coverage-ssot.md`](rules/coverage-ssot.md)
4. **Verification & Definition of Done**: [`rules/verification-dod.md`](rules/verification-dod.md)

---

## Document Template

The full, structured breakdown template is maintained in a dedicated file:
👉 [**`template.md`**](template.md)
