---
name: onu-implementation-planning
description: Plan a technical or code change before implementation, using project knowledge and authoritative rules over existing code, to produce an implementation-ready plan with file-level detail, coverage scenarios, and validation. Use when a change needs a reviewable plan before any production edit.
license: MIT
---

# Implementation Planning

Use this skill to plan a technical or code change — a feature, fix, refactor, migration, or architecture change — before any production edit. It composes `$onu-workflow-planning` for the generic planning discipline and adds the code-specific methodology: knowledge-first over existing code, code reconnaissance with `file:line` evidence, per-file design decisions, and coverage scenarios.

## Use this skill when

- the work changes production code, tests, configuration, schema, or migrations;
- existing code patterns must be evaluated against project rules before reuse; or
- the plan must be detailed enough for an implementer to execute without re-deriving design decisions.

## Do not use this skill when

- the work is non-technical (product, business, content, operations, research) — use `$onu-workflow-planning` directly; or
- the change is a single obvious edit with no meaningful design decisions.

## Compose the generic skill

Follow `$onu-workflow-planning` for the operating contract, gate execution model, requirement decomposition, plan structure, authority-first, drafting discipline, and approval handoff. The sections below add the code-specific constraints on top of that foundation.

## Knowledge-first over existing code

Project knowledge and authorities are the only source of truth; existing code may be legacy or predate a rule, so it is validated rather than assumed correct. Read [knowledge-authority.md](references/knowledge-authority.md).

- Extract every normative rule from the applicable authorities (`AGENTS.md`, requirements/stories, ADRs, `KnowledgeBase/` topics) into a numbered inventory.
- When existing code contradicts a rule, the rule wins.
- Design each file from the rules, not from the nearest similar existing file; anchoring to existing code is the #1 planning failure mode.

## Code reconnaissance

Every code fact must rest on a `file:line` you personally read and logged. Read [code-reconnaissance.md](references/code-reconnaissance.md).

- Log the path: seed symbol → question → search hits → opened `file:line`.
- Open only files that serve a review purpose; close anything that does not.
- Stop when you have the owning component, an insertion point or explicit blocker, and a rule-mapped implementation direction.

## Per-file design decisions

For each planned file, run the design-decision checklist in [knowledge-authority.md](references/knowledge-authority.md): which rules govern it, whether any reused pattern violates a rule, what the file may or may not do, and whether any action belongs elsewhere.

## Coverage scenarios

For every file with executable behavior, enumerate coverage scenarios derived from the exact logic. Read [coverage-scenarios.md](references/coverage-scenarios.md).

## Plan output (artifact)

The methodology above is thorough; the written plan is not. Run the rule inventory, reconnaissance, per-file design, and coverage enumeration fully — but persist only the implementer-facing result in the plan. Write working evidence to three companion files next to the plan and reference them from it (read only when required), never inline:

- `<PlanningFileName>.pre-plan-evidence.md` — inputs gathered to produce the plan: numbered rule inventory, seed→question→hits log, rule-to-evidence verification rows, current-state notes, anti-anchoring notes.
- `<PlanningFileName>.post-plan-evidence.md` — execution and validation results: command outputs, build/test results, implementation outcome.
- `<PlanningFileName>.working-evidence.md` — ephemeral reasoning: self-review narrative, rejected alternatives, deferred decisions, revision history.

**Append a `## References` section** at the end of the plan (after `Open decisions`). List every companion file actually created, each with a one-line description of its contents and when to read it during implementation. Name the files `<PlanningFileName>.pre-plan-evidence.md`, `<PlanningFileName>.post-plan-evidence.md`, and `<PlanningFileName>.working-evidence.md`; never inline their content.

Cite evidence inline as `file:line` and `(rule N)`.

The artifact takes this shape, and it overrides the generic `$onu-workflow-planning` plan structure and drafting for code work:

````markdown
---
kind: implementation-plan
status: Proposed
scope: single-task|batch
change: <change-name>
task: <task-id>            # or `tasks: <ids>` for a batch
created_at: YYYY-MM-DD
plan_version: 1
---

# <Short title>

## Goal
- All measurable outcomes.

## Changes
Present each file change as its own subsection (`### path/File.cs — Action`) with
`Why (rule N)`, `Contract impact`, and `Done when` lines — never as a
`| File | Action | … |` table. When the intended shape is non-obvious, show the
concrete edit as a fenced `diff` block: lines to remove are prefixed with a
minus, lines to add with a plus.

### `path/File.cs` — Modify
**Why (rule N):** <what changes and why>
**Contract impact:** <surface/behavior that changes>
**Done when:** <coverage scenarios + expected evidence>

```diff
- <before — only when the intended shape is non-obvious>
+ <after>
```

Each symbol in a `diff` block must carry the `file:line` actually read, marked
`(verified <file:line>)`. A proposed or guessed location is marked `(proposed)`
and must never be presented as a finalized edit.

## Ordered steps
- One ordered step per material milestone, decision point, or handoff, each with a completion condition. Step count follows the change, not a fixed range (roughly 5–10 for a single-task change; a deep or multi-file change needs more and that is expected, not a violation).

## Validation
- Commands + expected evidence.

## Open decisions
- Only material items requiring approval; omit when none.

## References
- Companion evidence files created with this plan, each with a one-line description and when to read it during implementation; never inline their content:
  - `<PlanningFileName>.pre-plan-evidence.md`
  - `<PlanningFileName>.post-plan-evidence.md`
  - `<PlanningFileName>.working-evidence.md`
````

### Plan drafting and size guidance

A focused plan is one a junior developer can read and implement without re-deriving design decisions. Treat the template above as the base, not a hard limit.

- **Section allow-list:** the fixed sections above (`Goal`, `Changes`, `Ordered steps`, `Validation`, `Open decisions`, `References`) plus at most two conditional sections (e.g., `Rollback`), added only when the change is irreversible or high-risk. Any other section means working evidence leaked in.
- **Size budget is guidance, not a gate.** The plan body is sized to the change:
  - A single-task change commonly lands near ~2,500 tokens (~10 KB, roughly 150–250 lines).
  - A batch or deep change legitimately needs more; exceeding that is expected, not a violation.
  - Measure by tokens, not lines — diff blocks are line-dense.
  - Never let a number truncate implementer-facing detail; complete, implementable coverage outranks every size target.
  - When a draft grows large, move working evidence to companion files. The failure mode is dropping detail to fit a number, not exceeding one.
- **No new sections for assumptions/risks:** fold any assumption, risk, or rollback note into `Goal`, `Validation`, or a conditional `Rollback` section.
- **Coverage placement:** encode coverage scenarios in the `Done when` field or as a short list under `Validation`, not as a separate exhaustive section.
- **Implementer test:** apply one test to every section and sentence — would the implementer be blocked or misdirected without it?

## Structured interview

Route material code decisions that the repository and rules cannot resolve to `$onu-workflow-user-interview`, one focused question at a time.

## Handoff

The completed plan is an implementation contract. Hand off the plan path and covered task identities to the implementation owner; never start implementation from this skill.
