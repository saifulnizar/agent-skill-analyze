# ⚡ Agent Skill Analyze

> **Grounded, High-Fidelity Architecture & Engineering Workflow Skills for AI Coding Agents** (Antigravity IDE, Cursor, Gemini, Claude Code).

Transform any raw Product Requirements Document (**PRD**) into production-ready software architecture (**Arch**), topologically sorted task backlogs (**Plan**), and concrete, ready-to-compile implementation contracts (**Spec**) — completely decoupled from proprietary Jira tickets or internal enterprise constraints.

---

## 🚀 Quick Install (One-Liner)

Install all generic analysis and engineering skills globally to your workstation in seconds:

```bash
# Direct execution from local repo:
bash agent-skill-analyze/install-skills.sh

# Or remote one-liner installation from GitHub:
curl -fsSL https://raw.githubusercontent.com/Lionparcel/agent-knowledge-workflow/main/agent-skill-analyze/install-skills.sh | bash
```

### Supported AI Agent Environments:
- **Google Antigravity IDE / Gemini Agent**: Automatically installed to `~/.gemini/config/skills/`.
- **Cursor IDE**: Automatically installed to `~/.cursor/skills/`.
- **Local Project Workspace**: Automatically linked to `./.agents/skills/`.

---

## 🛠 The 3-Stage Engineering Pipeline

```
┌────────────────────────────────────────────────────────┐
│                   Raw Product Spec                     │
│               (PRD-My-Feature.md / URL)                │
└───────────────────────────┬────────────────────────────┘
                            │  /arch [--lang=indo]
                            ▼
┌────────────────────────────────────────────────────────┐
│        Technical Requirements Document (TRD)           │
│  - First-Principles Scale & Back-of-the-Envelope Math  │
│  - Architecture Decision Records (ADRs with Trade-offs)│
│  - CAP / PACELC & Failure Modes Matrix                 │
│  - 16-Byte Wire Protocols / OpenAPI Specifications     │
└───────────────────────────┬────────────────────────────┘
                            │  /plan [--lang=indo]
                            ▼
┌────────────────────────────────────────────────────────┐
│             Engineering Task Breakdown                 │
│  - Directed Acyclic Graph (DAG) Execution Order        │
│  - Atomic Work Units (INVEST Slicing: T-01, T-02, ...) │
│  - 100% TRD Traceability & Concrete Verification DoD   │
└───────────────────────────┬────────────────────────────┘
                            │  /spec T-NN [--lang=indo]
                            ▼
┌────────────────────────────────────────────────────────┐
│            Task Implementation Contract                │
│  - Strongly-Typed Structs, Interfaces & Error Enums    │
│  - Step-by-Step State Mutation & Algorithmic Logic     │
│  - Language Idioms (Rust, Go, TypeScript, Python)      │
│  - Compilable Unit & Integration Test Suites           │
└───────────────────────────┬────────────────────────────┘
                            │  /implement or Manual Coding
                            ▼
┌────────────────────────────────────────────────────────┐
│             Clean, Production-Ready Code               │
└───────────────────────────┬────────────────────────────┘
```

---

## 📖 Available Commands & Usage

### 1. `/arch` — Architecture & System Design Blueprint
Analyzes a PRD and produces an exhaustive, battle-tested Technical Architecture Document.

```bash
/arch [path/to/prd.md] [--lang=indo]
```
- **Interactive Archetype Triage (Step 0)**: Detects whether your project is a **Systems Engine** (Storage, DB, Consensus, KV store) or **Enterprise Microservices** (Web API, Payment, E-Commerce, Sagas) and loads matching domain knowledge.
- **Output**: `workspaces/{prd-slug}/arch.md`

### 2. `/plan` — Task Decomposition & DAG
Transforms an architecture document (`arch.md`) into an atomic, dependency-ordered engineering backlog.

```bash
/plan [path/to/arch.md] [--lang=indo]
# or simply:
/plan
```
- **Rules Applied**: Strict bottom-up DAG (Types $\rightarrow$ Engine $\rightarrow$ Network $\rightarrow$ Consensus $\rightarrow$ CLI), INVEST task sizing (2–5 files per task), 100% Architecture coverage.
- **Output**: `workspaces/{prd-slug}/plan.md`

### 3. `/spec` — Code-Level Implementation Contract
Expands a single task card (`T-NN`) into an unambiguous implementation manual.

```bash
/spec [T-NN] [--lang=indo]
# Example:
/spec T-01 --lang=indo
```
- **Zero TBD/TBC Policy**: Concrete types, error enums, byte offsets, and ready-to-run unit tests.
- **Output**: `workspaces/{prd-slug}/spec/spec-{T-NN}-{slug}.md`

---

## 🌐 Multi-User Workspace Isolation Pattern

When multiple team members work on different PRDs simultaneously, all artifacts are strictly sandboxed under a dedicated workspace directory named after the skill pipeline:

```text
workspaces/
│
├── distributed-kv-store/              # Isolated Project 1
│   ├── prd.md                         # Normalized source PRD archive
│   ├── arch.md                        # Architecture Blueprint (via /arch)
│   ├── plan.md                        # Task DAG Backlog (via /plan)
│   └── spec/                          # Implementation contracts (via /spec)
│       ├── spec-T-01-binary-protocol.md
│       └── spec-T-02-wal-engine.md
│
├── payment-gateway/                   # Isolated Project 2
│   ├── prd.md
│   ├── arch.md
│   ├── plan.md
│   └── spec/
│       └── spec-T-01-idempotency-filter.md
│
└── live-streaming-chat/               # Isolated Project 3
    ├── prd.md
    ├── arch.md
    ├── plan.md
    └── spec/
```

---

## 🇮🇩 Dwi-Bahasa / Bilingual Support (`--lang=indo`)

All three skills support native English (default for public open-source repos) and **Bahasa Indonesia Profesional**:

- Add `--lang=indo` or prompt in Indonesian:
  - Executive summaries, architectural trade-offs, step-by-step logic, and failure scenarios are emitted in **clear, professional Bahasa Indonesia**.
  - Code syntax, struct identifiers, API endpoints, and terminal commands remain in standard technical English.

---

## 📚 Grounded Knowledge Base (Anti-Hallucination)

The skills are anchored in gold-standard computer science literature and industry RFCs:

| Reference Area | Key Sources & Seminal Papers |
| :--- | :--- |
| **System Scale & Constraints** | *Designing Data-Intensive Applications (DDIA)* by Martin Kleppmann; *Latency Numbers Every Programmer Should Know* by Jeff Dean & Peter Norvig. |
| **Storage & Engines** | *LSM-Tree* (O'Neil), *Google Bigtable* (Ghemawat & Dean), *Bitcask* (Sheehy & Smith). |
| **Consensus & Protocols** | *Raft Consensus Algorithm* (Diego Ongaro & John Ousterhout, Stanford University USENIX 2014). |
| **Enterprise Reliability** | *Microservices Patterns* (Chris Richardson), *IETF Idempotency-Key Header*, *Circuit Breakers* (Michael Nygard). |
| **Language Idioms** | *Rust API Guidelines* & Tokio Tutorials, *Uber Go Style Guide*, *Google TypeScript Style Guide*, *PEP 8 / PEP 484 Python*. |

---

## 📦 Directory Structure

```text
agent-skill-analyze/
├── README.md                          # Documentation (this file)
├── install-skills.sh                  # One-liner installation script
└── skills/                            # Skill definitions & rulebooks
    ├── arch/                          # TRD architecture generation engine (/arch)
    │   ├── SKILL.md
    │   ├── template.md
    │   └── references/                # Systems & Enterprise reference books
    ├── plan/                          # Task slicing & DAG engine (/plan)
    │   ├── SKILL.md
    │   ├── template.md
    │   └── rules/                     # Slicing, DAG, SSOT, and DoD rules
    └── spec/                          # Implementation contract generator (/spec)
        ├── SKILL.md
        ├── template.md
        └── rules/                     # Rust, Go, TS, and Python idiom rules
```

---

## 📄 License
MIT License. Free for internal team collaboration and open-source projects.
