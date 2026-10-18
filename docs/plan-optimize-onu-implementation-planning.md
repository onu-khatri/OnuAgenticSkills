---
kind: implementation-plan
status: Proposed
scope: batch
change: optimize-onu-implementation-planning
created_at: 2026-10-16
plan_version: 3
owner: build-agent
---

# Optimize `onu-implementation-planning` for Concise, Effective Plans

## Goal

Optimize the `onu-implementation-planning` skill so it generates concise,
actionable, implementation-ready plans with minimal token and context-window
consumption, **without compromising effectiveness**.

Effectiveness is preserved only if, after the change, the implementer still
receives every essential detail with no re-derivation:

- All measurable outcomes and acceptance criteria.
- Per-file design decisions (file, what changes and why with governing rule, contract impact).
- Per-file coverage scenarios and critical validation commands.
- Material dependencies, sequencing, and any decision requiring approval.

Overhead is reduced only for working evidence, process narrative, and archival
content — never for implementation-facing decisions.

Design decisions:

1. **Diff-style changes.** File-level changes are presented as section-subsection
   with `diff` (+/-) code blocks, never as a `| File | Action | … |` table.
   A diff states the edit directly and is copy-pasteable; a table forces the
   implementer to decode prose cells.
2. **Ordered steps bounded to 5–10.** The `Ordered steps` section holds 5–10
   steps; fewer is under-decomposed, more means working detail leaked in.
3. **Working evidence lives in three companion files**, referenced (linked) from
   the main plan and read only when required — never inlined.
4. **Budget by tokens, not sections/lines.** Sections are bounded by a fixed
   allow-list (5 + 2 conditional), not a count. A token budget is the true
   ceiling; line count is a soft smell-indicator only, because diff-style
   `Changes` are inherently line-dense.

Measurable targets:

- Plan artifacts drop from ~392 KB (≈98k tokens) to ~70–87 KB (≈18–22k tokens), a ~78% reduction.
- Each plan uses the 5 fixed sections (+2 conditional max) and 5–10 ordered steps.
- Each plan body targets ≤ ~10 KB (~2.5k tokens); line count (≈150–250) is a soft heuristic only.
- Working evidence is in companion files, not the main plan.

## Changes

### `C:\Users\anup.singh1\.agents\skills\onu-implementation-planning\SKILL.md` — Modify

Replace the prose concision rule (line 51) with the companion-file evidence
model, replace the `## Changes` table in the template (lines 71–74) with a
diff-style format, bound `Ordered steps` to 5–10, and replace the permissive
"add a section only when" paragraph (line 83) with a hard ceiling.

```diff
 ## Plan output (artifact)
- The methodology above is thorough; the written plan is not. Run the rule
- inventory, reconnaissance, per-file design, and coverage enumeration fully —
- but persist only the implementer-facing result. Working evidence, the numbered
- rule inventory, gate state, and self-review narrative stay out of the
- artifact; cite evidence inline as `file:line`.
+ The methodology above is thorough; the written plan is not. Run the rule
+ inventory, reconnaissance, per-file design, and coverage enumeration fully —
+ but persist only the implementer-facing result in the plan. Write working
+ evidence to three companion files next to the plan and reference them from it
+ (read only when required), never inline:
+
+ - `pre-plan-evidence-<PlanningFileName>.md` — inputs gathered to produce the
+   plan: numbered rule inventory, seed→question→hits log, rule-to-evidence
+   verification rows, current-state notes, anti-anchoring notes.
+ - `post-plan-evidence-<PlanningFileName>.md` — execution and validation
+   results: command outputs, build/test results, implementation outcome.
+ - `working-evidence-<PlanningFileName>.md` — ephemeral reasoning: self-review
+   narrative, rejected alternatives, deferred decisions, revision history.
+
+ Cite evidence inline as `file:line` and `(rule N)`.
+
+ ## Plan sections (allow-list)
+ Fixed sections: `Goal`, `Changes`, `Ordered steps` (5–10), `Validation`,
+ `Open decisions`. Add at most two conditional sections (e.g., `Rollback`) only
+ when the change is irreversible or high-risk. Additional sections mean working
+ evidence leaked in.
+
+ ## Size budget
+ The plan body targets ≤ ~10 KB (~2,500 tokens). Line count is a soft heuristic
+ only (roughly 150–250 lines), because diff-style `Changes` are line-dense;
+ measure by tokens, not lines. Exceeding the budget is a signal to move working
+ evidence to companion files, never to drop implementer-facing detail. If a
+ legitimate plan still exceeds it, record why in `Open decisions`. Apply one
+ test to every section and sentence: would the implementer be blocked or
+ misdirected without it?

 ## Changes
- | File | Action | What changes and why (rule) | Contract impact | Done when |
- |---|---|---|---|---|
- | path/File.cs | Modify | ... | ... | ... |
+ Present each file change as a section-subsection with a `diff` (+/-) block,
+ never as a table:
+
+ ### `path/File.cs` — Modify
+ **Why (rule N):** <what changes and why>
+ **Contract impact:** <surface/behavior that changes>
+ **Done when:** <coverage scenarios + expected evidence>
+
+ ````diff
+ - <before — only when the intended shape is non-obvious>
+ + <after>
+ ````
```

### `C:\Users\anup.singh1\.agents\skills\onu-implementation-planning\references\knowledge-authority.md` — Modify

Append an output-destination line routing the rules inventory to the pre-plan
evidence file.

```diff
 ## Compliance over availability
 
 When a rule assigns a responsibility to a component, place it there — even if
 that component does not yet expose the capability. "It already has the
 dependencies" or "a similar file does it this way" is not a reason to place
 logic elsewhere.
+
+ ## Output destination
+
+ The numbered rules inventory is working evidence, not plan content. Write it
+ to `pre-plan-evidence-<PlanningFileName>.md`; persist only `(rule N)` citations
+ inline in the plan's `Changes` section.
```

### `C:\Users\anup.singh1\.agents\skills\onu-implementation-planning\references\code-reconnaissance.md` — Modify

Append an output-destination line routing the reconnaissance trail to the
pre-plan evidence file.

```diff
 Absolute rules: no `file:line` without a logged search; no user interview
 until reconnaissance is closed; the log is the only proof — if it is not
 logged, it did not happen.
+
+ ## Output destination
+
+ The seed→question→hits log and rule-to-evidence verification rows are working
+ evidence. Write them to `pre-plan-evidence-<PlanningFileName>.md`; persist only
+ `file:line` citations inline in the plan.
```

### `C:\Users\anup.singh1\.agents\skills\onu-implementation-planning\references\coverage-scenarios.md` — Modify

Append an output-destination line so coverage scenarios stay inline in
`Done when` / `Validation`, not a standalone section.

```diff
 ## Where coverage lives
 
 Represent unit-test planning only through the coverage scenarios in each file
 detail. Do not add unit-test files or operations to the plan unless the user
 explicitly asks for a broader test-delivery plan.
+
+ ## Output destination
+
+ Enumerate coverage scenarios in working memory; persist them only as a compact
+ list in the file's `Done when` field or as a short bullet list under
+ `Validation`. Do not add a standalone `## Coverage scenarios` section.
```

### `C:\Users\anup.singh1\.agents\skills\onu-plan-review-approval\SKILL.md` — Modify

Add one line under the review criteria so the reviewer accepts inline evidence
and companion-file evidence instead of a full inlined ledger.

```diff
 - dependencies, sequencing, and external prerequisites;
 - breaking changes, compatibility, rollout, rollback, and migration impact;
 - missing steps, decisions, risks, ownership, or handoff evidence.
+
+ Inline `file:line` citations, concise assumptions, and referenced
+ `*-evidence-<PlanningFileName>.md` companion files satisfy the evidence
+ requirement. The absence of an inlined evidence ledger, numbered rule
+ inventory, or self-review narrative is not a gap in a code plan produced by
+ `$onu-implementation-planning`.
```

### `C:\Users\anup.singh1\.agents\skills\onu-workflow-planning\SKILL.md` — Modify (optional, P3-support)

Scope the "keep an evidence ledger" drafting rule to non-code work.

```diff
- - Keep an evidence ledger (source, date/version, observation, interpretation,
-   confidence) so every claim is traceable.
+ - Keep an evidence ledger (source, date/version, observation, interpretation,
+   confidence) so every claim is traceable — for non-code work. Code work
+   defers to `$onu-implementation-planning`, which persists evidence in
+   companion files and cites only `file:line` inline.
```

## Ordered steps

1. Edit `onu-implementation-planning/SKILL.md` — companion-file evidence model, allow-list + ceiling, diff-style `Changes` template, 5–10 ordered steps (P1).
2. Edit the three `references/*.md` — add "output destination" lines routing evidence to companion files (P2, P6).
3. Edit `onu-plan-review-approval/SKILL.md` — accept inline + companion-file evidence (P3).
4. Edit `onu-workflow-planning/SKILL.md` — scope the evidence-ledger rule (P3-support).
5. Validate: re-plan one existing batch (session-module) and confirm ≤6 sections / ~150 lines / 5–10 steps, diff-style changes, and three companion evidence files created and referenced (not inlined).

## Validation

- `session-module-batch.md` re-planned from the updated skill uses the 5 fixed sections (+2 conditional max) with 5–10 ordered steps, has a body within the ~2.5k-token budget, presents changes as section-subsection + `diff` blocks, and retains every per-file decision, coverage scenario, and validation command.
- Three companion files (`pre-plan-`, `post-plan-`, `working-evidence-`) are created next to the main plan and referenced from it; working evidence is not inlined.
- The allow-list in `SKILL.md` names every item that currently bloats the artifacts.
- The reviewer skill no longer treats a missing inlined evidence ledger as a gap.

## Open decisions

- Confirm the three companion-file names below (or propose better):
  - `pre-plan-evidence-<PlanningFileName>.md`
  - `post-plan-evidence-<PlanningFileName>.md`
  - `working-evidence-<PlanningFileName>.md`
- Confirm the budget model: 5 fixed sections + 2 conditional; ~2.5k-token body budget; line count (≈150–250) as a soft heuristic only; 5–10 ordered steps.

## Next safe action

Agree to this plan; do not implement until approved. After agreement, hand off
to the build agent to implement P1–P6 in the order above.
