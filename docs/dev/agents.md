# Agents

Agents are role-focused workers. Give an agent a concrete outcome, repository scope, story or issue reference, and delivery boundary. The agent should inspect current repository state before acting.

## Available agents

| Agent | Best used for |
| --- | --- |
| `onu-autonomous-developer` | Driving one request through entry checks, planning, implementation, review, verification, and delivery. |
| `onu-backend-implementer` | Minimal APIs, validators, Mediator handlers, persistence, and backend tests. |
| `onu-frontend-implementer` | React/TypeScript features, forms, routes, typed client data, and focused verification. |
| `onu-implementation-planner` | Evidence-backed, approval-gated plans with affected files, dependencies, risks, and validation. |
| `onu-code-reviewer` | Defect-first review of backend, frontend, and architecture-sensitive changes. |
| `onu-security-auditor` | OWASP-oriented review of features, APIs, and sensitive flows. |
| `onu-knowledge-researcher` | Architecture, feature, test, and repository tracing before implementation. |
| `onu-story-orchestrator` | Readiness, dependency ordering, parallel lanes, and handoff for multiple stories. |

## Selection rules

- Start with `onu-autonomous-developer` for one coherent request whose outcome includes implementation.
- Start with `onu-story-orchestrator` for a batch of stories or cross-story dependencies.
- Start with `onu-implementation-planner` when requirements, design, dependencies, or validation are not yet settled.
- Use the backend or frontend implementer for a bounded implementation lane.
- Add `onu-knowledge-researcher` when repository evidence is needed before making a design choice.
- Add `onu-code-reviewer` and `onu-security-auditor` when the change needs independent quality or security review.

Agents may delegate to skills and specialist lanes, but delegation does not remove approval or delivery gates.
