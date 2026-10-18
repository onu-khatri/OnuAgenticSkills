# Workflow and human gates

This is the developer-facing lifecycle. The agent may continue through mechanical steps, but it must stop when a decision changes scope, intended behavior, authorization, or hosted state.

```text
intake -> repository entry gate -> story/issue readiness -> plan approval
       -> isolated implementation -> review loop -> verification
       -> delivery -> hosted read-back -> closeout
```

## Stages

| Stage | Expected evidence | Input needed from the user |
| --- | --- | --- |
| Intake and entry | Repository, branch, worktree, policy, and request scope are known. | Clarify material ambiguity in outcome or scope. |
| User-story readiness | Story has acceptance criteria, dependencies, and an implementation-ready status. | Confirm the story is approved/ready. Draft, proposed, or labelled-only status is not approval. |
| GitHub issue handoff | A traceable issue exists and links back to the source story. | Confirm the issue is created and has the required ready-to-implement status before implementation continues. |
| Planning/OpenSpec | Plan or proposal lists files, behavior, risks, tests, and validation. | Approve the plan/spec when the workflow requires approval. Planning output alone does not authorize code changes. |
| Implementation | Changes are limited to the approved scope and include focused tests/docs. | Resolve product, API, data, UX, or compatibility choices that repository evidence cannot determine. |
| Review and correction | Findings are classified; fixes are re-reviewed. | Accept, fix, or defer a material security, compatibility, quality, or operational risk. |
| Verification | Local checks and unavailable checks are reported separately. | Decide how to proceed when a required check is blocked or fails for an environment reason. A blocked check is not a pass. |
| Delivery | Commit, branch, push, PR, links, and hosted read-back are recorded separately. | Authorize hosted mutations not already included in the request, such as push, PR, issue updates, or publication. |
| Closeout | Final story, issue, PR, CI, risks, and remaining work are recorded. | Confirm final status: complete, in review, deferred, or blocked. |

## Status rules

- A user story must be explicitly implementation-ready before implementation starts.
- A GitHub issue must exist, be traceable to the story, and have the required repository status before issue-driven implementation starts.
- A plan marked proposed, draft, or ready for review still needs the required approval.
- Unanswered or cancelled user input is not approval; preserve the checkpoint and report what is waiting.
- “Ready to implement” is a readiness signal, not permission to change code unless the project workflow explicitly treats it as approval.

## Request template

Include:

- repository and story/issue identifier;
- intended outcome and acceptance criteria;
- allowed files or scope, including documentation-only constraints;
- whether the request is planning, implementation, review, or delivery;
- whether push, PR, issue updates, publication, or other hosted actions are authorized.

## Handoff checklist

Report these independently:

1. Files changed and unrelated changes preserved.
2. Local build, tests, linting, and structural checks.
3. Checks that were unavailable or failed, with the reason.
4. Branch and commit state.
5. Push, PR, issue read-back, and CI evidence, if performed.
6. Remaining decisions, risks, or blockers.

For documentation-only requests, modify only documentation or README files. Do not alter agent or skill definitions while explaining them.
