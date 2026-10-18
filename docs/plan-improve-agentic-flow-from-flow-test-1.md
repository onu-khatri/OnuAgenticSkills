---
kind: implementation-plan
status: Proposed
scope: batch
change: improve-agentic-flow-from-flow-test-1
task: Flow-Test-1 improvement batch
created_at: 2026-10-18
plan_version: 2
owner: flow-test-improver
---

# Improve the Agentic Flow from Flow-Test-1 Findings

## Goal

Each Flow-Test-1 recommendation is applied exactly once, in the single file that
owns the behavior, so no rule is duplicated across a skill and the agent that
routes to it. After these edits the next flow test is deterministic, resumable,
and evidence-complete:

- Entry detects OpenSpec-driven work and routes it to
  `$onu-openspec-orchestration` instead of the generic loop.
- Entry emits a machine-readable state snapshot (authorities found/missing,
  build, per-project tests, unbuildable/orphaned projects, external deps).
- The planner cannot present an unverified symbol as a finalized edit.
- A lane can be paused and resumed by `task_id` with a persisted resumption
  record; no re-specification from scratch.
- Implementers append slice evidence incrementally and self-check the traps that
  review previously caught late.
- The driver commits per review-clean slice instead of one large staged set.

## Changes

### 1. `skills/onu-workflow-development-entry/SKILL.md` — Modify (P1)

**Why:** Flow-Test-1 §1/§2.1/§3/§13 — the gate silently assumed `AGENTS.md` and
the knowledge-base index existed, hid 9 failures behind an orphaned test project
that could not compile, forced ~30 manual read/grep/bash calls, and let an
OpenSpec change fall through to the generic loop. This file is the single choke
point before any edit.

**Contract impact:** `Gate A` (inputs/Record list) and the `Required output`
handoff.

**Done when:** an entry run against the Flow-Test-1 scenario emits the snapshot
with the missing authorities marked "not-found", lists the orphaned test
project, and routes the `openspec/changes/...` target to
`$onu-openspec-orchestration`.

```diff
 ## Gate A: establish the request and evidence
 
+If the request references `openspec/changes/<name>/tasks.md` — or an
+`openspec/changes/<name>/.openspec.yaml` exists and matches the work — this is
+OpenSpec-driven work, not a plain development request. Route to
+`$onu-openspec-orchestration` (and `$onu-openspec-workflow` for the transition
+mechanics) and do not proceed as a generic development request.
+
-Read `AGENTS.md` and the knowledge-base index (via $onu-documentation-finder) first. For issue-driven work, also read the selected GitHub issue and its source story pack. For direct development requests, identify the stated outcome, acceptance behavior, target area, and requested delivery boundary.
+Read `AGENTS.md` and the knowledge-base index (via $onu-documentation-finder)
+first, and record which authorities actually exist — repo-root `AGENTS.md`,
+`agents/AGENTS.md`, the user-level vendor instruction file, and
+`KnowledgeBase/INDEX.md` — each as found or "not found"; never silently assume
+one exists. For issue-driven work, also read the selected GitHub issue and its
+source story pack. For direct development requests, identify the stated
+outcome, acceptance behavior, target area, and requested delivery boundary.
```

```diff
- - verification commands appropriate to the affected area; and
+ - verification commands appropriate to the affected area;
+ - unbuildable or orphaned test projects that cannot compile, reported as a
+   first-class signal rather than silently omitted; and
  - unresolved product, audience, entitlement, security, contract, architecture, or rollout decisions.
```

```diff
  Next action: <one safe action; for PASS, hand off to the approved implementation workflow>
  ```
+
+Append a machine-readable state snapshot so the driver never re-derives state
+with manual read/grep/bash calls:
+
+```text
+Authorities: {AGENTS.md, agents/AGENTS.md, user-level instruction file, KnowledgeBase/INDEX.md → found|not-found}
+Build: {<solution/project>: pass|fail|<n> errors}
+Tests: {<project>: <passed>/<failed>/<skipped>}
+Unbuildable/orphaned projects: <none|list>
+External deps: <feeds, services, registries, required credentials|none>
+```
```

### 2. `agents/AGENTS.md` — Modify (P1)

**Why:** Flow-Test-1 §13 — the routing table has no OpenSpec row, so a driver
holding an OpenSpec change has no signal to load the OpenSpec orchestrator. The
routing table is the single owner of route precedence.

**Contract impact:** the "Skill and agent routing" table.

**Done when:** the table gains the OpenSpec row below and
`npm run validate` passes.

```diff
 | Development code, tests, configuration, or migrations | `$onu-workflow-development-entry` first; it routes specialists but does not invoke implementers |
+| OpenSpec change implementation | `$onu-openspec-orchestration` (with `$onu-openspec-workflow` for transition mechanics) — over the generic entry path |
```

### 3. `skills/onu-orchestration-agent-improvement/references/delegation-protocol.md` — Modify (P1)

**Why:** Flow-Test-1 §4/§6/§9/§12 — the cancelled Slice 2 had to be re-specified
from scratch and an interrupt forced manual `git status` re-checking. The
protocol is the canonical lifecycle contract every agent already references, so
the pause/resume state belongs here once, not in each agent.

**Contract impact:** the `Lifecycle` table plus a new `Pause and resume` section.

**Done when:** `Paused` is a valid lifecycle state; resumption requires
`task_id` (not a re-specified manifest); every agent that references the
protocol inherits this without a local copy.

```diff
 | `Waiting for User` | Parent | A material user decision or authorization is required | `In Progress`, `Cancelled` |
+| `Paused` | Parent/agent | Work was interrupted mid-lane; a resumption record was persisted | `In Progress`, `Cancelled`, `Failed` |
 | `Completed` | Parent after acknowledgement | Agent result was received, reconciled, and accepted for the assigned scope | terminal |
```

After the `Parent acknowledgement` section, add:

```diff
+## Pause and resume
+
+When a lane is interrupted (user pause, host stop, or timeout recovery), persist
+a resumption record before the lane closes:
+
+```text
+parent_step_id, task_id, agent, slice, files_touched, next_safe_action
+```
+
+Resume the same lane by `task_id` (and `parent_step_id` when available); do not
+re-specify the slice from scratch.
```

### 4. `agents/onu-backend-implementer/AGENT.md` — Modify (P2)

**Why:** Flow-Test-1 §6/§8/§10 — evidence was reconstructed at the end, and the
reviewer caught shippable bugs (gitignore swallowing the fixture, CI failing,
healthcheck not running) that belong at implementer handoff. Resume-by-`task_id`
and one-deliverable-per-lane are already covered by change 3, so this file only
adds the two behaviors it owns.

**Contract impact:** the `Definition of done` section.

**Done when:** "done when" appends slice evidence and runs the trap self-check
before handoff; no local copy of pause/resume instructions.

```diff
  Definition of Done:
  - Execute the checks required by the approved plan; use AGENTS.md for current commands.
  - Start with the smallest meaningful build/test boundary. Run full solution or suite checks when the plan or affected boundary requires them; broaden after a failure or newly discovered risk.
  - Report passed, failed, blocked, skipped, and not-run checks separately. Distinguish clean builds from execution of existing binaries.
  - Migration or seed-data impact is stated explicitly.
+- Append this slice's evidence — files changed, commands run, actual results —
+  to the plan's post-plan evidence file as part of "done when", not at the end
+  of the whole change.
+- Before handoff, self-check the shippable traps: `.gitignore` does not swallow
+  needed artifacts; the CI container-build passes in the hosted pipeline; the
+  runtime healthcheck actually starts (not just defined); no secrets or `.env`
+  files are staged.
```

### 5. `agents/onu-frontend-implementer/AGENT.md` — Modify (P2)

**Why:** Parity with change 4 — the reviewer caught shippable bugs that belong at
implementer handoff, and evidence should be appended incrementally. Same traps,
frontend-adapted.

**Contract impact:** the `Definition of done` section.

**Done when:** "done when" appends slice evidence and runs the trap self-check
before handoff.

```diff
  Definition of Done:
  - Run the smallest proportionate checks from the frontend client project and report exactly what ran and what did not.
  - Do not claim `npm run check`, `npm run test`, or `npm run build` passed unless you ran it.
+- Append this slice's evidence — files changed, commands run, actual results —
+  to the plan's post-plan evidence file as part of "done when", not at the end
+  of the whole change.
+- Before handoff, self-check the shippable traps: `.gitignore` does not swallow
+  needed artifacts; the CI lint/typecheck/build passes in the hosted pipeline;
+  the app actually serves in the dev/build runtime (not just compiles); no
+  secrets or `.env` files are staged.
```

### 6. `skills/onu-implementation-planning/SKILL.md` — Modify (P2)

**Why:** Flow-Test-1 §7/§11 — the planner handed the implementer concrete-but-
wrong guesses (`MaxExportBatchSize` vs the real key, benchmark namespaces). The
skill already states "code facts must rest on a `file:line` you read"; the gap is
that the artifact template does not enforce it. The rule stays here, not in the
planner agent (which routes to this skill).

**Contract impact:** the `Plan output (artifact)` template's `diff` block.

**Done when:** a produced plan marks every diff-block symbol `(verified
<file:line>)` or `(proposed)`, and never presents a proposed symbol as final.

```diff
 ```diff
 - <before — only when the intended shape is non-obvious>
 + <after>
 ```
+
+Each symbol in a `diff` block must carry the `file:line` actually read, marked
+`(verified <file:line>)`. A proposed or guessed location is marked `(proposed)`
+and must never be presented as a finalized edit.
```

### 7. `agents/onu-autonomous-developer/AGENT.md` — Modify (P2)

**Why:** Flow-Test-1 §1/§5 — the driver re-derived state with ~30 manual calls
and staged 52 files in one batch after the plan itself said "commit after each
step". The interrupt checkpoint and worktree rules are already owned by change 3
and `$onu-openspec-workflow`, so only these two driver behaviors change.

**Contract impact:** the `Entry` and `Deliver` steps of the loop.

**Done when:** the driver consumes the entry snapshot and commits per
review-clean slice.

```diff
-1. **Entry** — run `$onu-workflow-development-entry` to reconstruct state,
-   classify the delivery shape, and obtain a PASS/BLOCKED route. It returns the
-   primary implementation skill and any bounded specialist inputs.
+1. **Entry** — run `$onu-workflow-development-entry` to reconstruct state,
+   classify the delivery shape, and obtain a PASS/BLOCKED route plus the
+   machine-readable state snapshot. Delegate only the recon the snapshot leaves
+   unresolved to a specialist agent in parallel; do not re-derive state with a
+   long series of manual read/grep/bash calls.
```

```diff
-7. **Deliver** — only after user approval, `$onu-git-commit` for commit
-   boundaries and messages, then `$onu-delivery-pull-request` for PR delivery.
-   Distinguish local change, verification, commit, push, and hosted-PR state.
+7. **Deliver** — only after user approval, commit each review-clean slice with
+   `$onu-git-commit` as its own boundary (one coherent, reviewable commit per
+   slice), then `$onu-delivery-pull-request` for PR delivery. Do not accumulate
+   the whole change into one staged set. Distinguish local change, verification,
+   commit, push, and hosted-PR state.
```

### 8. Frontmatter normalization — every `SKILL.md` and `AGENT.md` (P3)

**Why:** A full structural review of frontmatter found three inconsistencies that
`npm run validate` does not flag (it checks only `name`/`description` presence,
the name pattern, and agent field types). Normalizing them makes the artifacts
portable across the four vendors and predictable for the installer.

**Contract impact:** YAML frontmatter only; no body text changes.

**Findings and edits:**

**(a) `license` on skills.** The repo is MIT (LICENSE + `package.json`), but only
`onu-workflow-development-entry/SKILL.md` declares `license: MIT`; the other ~45
skills omit it. Add `license: MIT` to every `SKILL.md` frontmatter.

```diff
 ---
 name: onu-<skill>
 description: <...>
+license: MIT
 ---
```

**(b) Description quoting on skills.** Three styles are in use: unquoted, single-
quoted (6 skills), and double-quoted (2 skills). Normalize to the YAML rule
"unquoted unless the value contains `: ` (colon+space), then double-quote".
Convert the 6 single-quoted descriptions (`onu-agent-name-picker`,
`onu-documentation-finder`, `onu-openspec-orchestration`,
`onu-quality-code-review-be`, `onu-quality-code-review`,
`onu-quality-code-review-fe`) to unquoted; keep `onu-content-seo` and
`onu-documentation-generation` double-quoted (they contain `: `).

```diff
- description: 'Assign fun identity names ... (Mahabharat, Ramayan, ...).'
+ description: Assign fun identity names ... (Mahabharat, Ramayan, ...).
```

**(c) `mode` on agents.** `onu-autonomous-developer` declares `mode: primary`;
the other 7 agents omit it (defaults to `all`). Add an explicit `mode`:
`subagent` for the six delegated lanes, and a decision for the coordinator
(see Open decisions).

```diff
 ---
 name: onu-backend-implementer
 description: <...>
 reasoningEffort: medium
+mode: subagent
 sandboxMode: workspace-write
 ---
```

**Done when:** every `SKILL.md` carries `license: MIT`; no description is
single-quoted and only colon-space descriptions are double-quoted; every
`AGENT.md` declares an explicit `mode`; `npm run validate` still passes.

## Deliberately not changed

These recommendations are already owned elsewhere; adding a second copy would
duplicate instruction:

- **Checkout/worktree invariant** (report §13.3): `$onu-openspec-workflow`
  already requires implementation in the approved canonical worktree; once entry
  routes OpenSpec work correctly, that rule applies.
- **Planner self-review of `file:line`** (report §7): the planner agent routes to
  `$onu-implementation-planning`, which now enforces it (change 5). The agent's
  existing self-review already says "verify every planned file and symbol against
  repository evidence".
- **`docs/autonomous-workflow.md`**: it points to `agents/AGENTS.md` as the
  routing brain and to the delegation protocol as canonical; it does not
  contradict any change here, so no edit is required.

## Ordered steps

1. Edit `skills/onu-workflow-development-entry/SKILL.md` — OpenSpec detection, authority detection, unbuildable-test signal, state snapshot (P1).
2. Edit `agents/AGENTS.md` — OpenSpec routing row (P1).
3. Edit `skills/onu-orchestration-agent-improvement/references/delegation-protocol.md` — `Paused` state + resume-by-`task_id` (P1).
4. Edit `agents/onu-backend-implementer/AGENT.md` — incremental evidence + trap self-check (P2).
5. Edit `agents/onu-frontend-implementer/AGENT.md` — incremental evidence + trap self-check (P2).
6. Edit `skills/onu-implementation-planning/SKILL.md` — verified `file:line` in diff template (P2).
7. Edit `agents/onu-autonomous-developer/AGENT.md` — snapshot entry + per-slice commit (P2).
8. Normalize frontmatter across all `SKILL.md`/`AGENT.md` — `license`, description quoting, `mode` (P3).
9. Validate: `npm run validate`, then re-run the Flow-Test-1 scenario and confirm each "Done when" is observed.

## Validation

- `npm run validate` passes (skill/agent schema cross-check).
- Re-running entry on the Flow-Test-1 scenario routes the OpenSpec change to
  `$onu-openspec-orchestration` (not the generic loop), emits the snapshot with
  missing authorities marked "not-found", and lists the orphaned test project.
- The delegation protocol contains the `Paused` row and a `Pause and resume`
  section; no agent carries a local copy of it.
- A produced plan's `diff` blocks carry `(verified <file:line>)` or `(proposed)`;
  no proposed symbol appears as final.
- The backend implementer returns with slice evidence already appended and the
  trap self-check performed.
- Delivery produces one commit per review-clean slice, not one 52-file staged set.
- Every `SKILL.md` carries `license: MIT`, descriptions follow the quoting rule,
  and every `AGENT.md` declares an explicit `mode`.

## Open decisions

- Agent `mode` for `onu-story-orchestrator` (change 8c): it is a coordinator, not
  a delegated lane. Set `mode: all` (default) or `mode: primary` — confirm which.

## References

- `Agentic-Flow-Test-Reports/Flow-Test-1.md` — source report; read §3–§6 and the
  "Agent recommendation for improvements" list (including §13) before
  implementing.
