# Skills reference

Skills are reusable operating procedures. They explain how a class of work should be researched, planned, implemented, reviewed, documented, or delivered.

The individual `SKILL.md` file is always authoritative. This page is a navigation guide, not a replacement for those instructions.

## How to use a skill

1. Identify the outcome and the affected project area.
2. Select the smallest set of skills that covers the work.
3. Read every selected `SKILL.md` completely before acting.
4. Follow the skill's required gates, inputs, outputs, and verification steps.
5. Report which skills were used and which checks were completed.

Do not select a skill only because its name sounds related. Select it when the request actually needs its procedure or decision framework.

## Quick selection guide

| If the request is about… | Start with… | Add when needed |
| --- | --- | --- |
| Any code change | `onu-workflow-development-entry` | Planning, backend/frontend, security, review, and delivery skills. |
| Ambiguous or cross-cutting work | `onu-research-deep` or `onu-implementation-planning` | Architecture, domain modeling, or user interview skills. |
| A GitHub story or issue | `onu-delivery-issues-kickoff` or `onu-delivery-user-story-kickoff` | `onu-delivery-github-issue`, then implementation and delivery skills. |
| OpenSpec work | `onu-openspec-orchestration` | `onu-openspec-workflow` and the relevant implementation skills. |
| Backend/API or persistence | `onu-backend-feature-development` | .NET patterns, EF Core, architecture, and backend security. |
| React/TypeScript UI | `onu-frontend-development` | Frontend design, guidelines, and frontend security. |
| Review of existing changes | `onu-quality-code-review` | Backend/frontend review, security, performance, or refactoring capabilities. |
| Documentation or README work | `onu-documentation-generation` | README, diagrams, documentation finder, or professional-writing skills. |
| Branch, commit, PR, or hosted delivery | `onu-git-workflows` | `onu-git-commit` and `onu-delivery-pull-request`. |

## Skill catalog

### 1. Workflow, planning, and delivery

| Skill | Purpose |
| --- | --- |
| `onu-workflow-development-entry` | Reconstruct repository state, classify the request, and route development work before code changes. |
| `onu-workflow-planning` | Sequence complex work, dependencies, decisions, and validation. |
| `onu-workflow-user-interview` | Resolve material scope or design choices with the user. |
| `onu-implementation-planning` | Produce an implementation-ready plan with evidence, affected files, risks, and tests. |
| `onu-implementation-plan-archival` | Preserve completed implementation-plan iterations as traceable project history. |
| `onu-plan-review-approval` | Review whether a plan satisfies completeness, evidence, and risk criteria. |
| `onu-openspec-orchestration` | Route OpenSpec and GitHub-driven work through the appropriate workflow. |
| `onu-openspec-workflow` | Coordinate proposal, approval, isolated implementation, verification, and closeout. |
| `onu-delivery-full-stack-feature` | Coordinate an end-to-end feature across product, frontend, backend, persistence, tests, and PR packaging. |
| `onu-delivery-issues-kickoff` | Find and prepare ready-to-implement GitHub issues for execution. |
| `onu-delivery-user-story-kickoff` | Assess and prepare approved user stories for issue handoff. |
| `onu-delivery-github-issue` | Create one traceable GitHub issue from an approved local story. |
| `onu-delivery-pull-request` | Complete branch, commit, push, PR, traceability, and verification gates. |
| `onu-git-commit` | Create small, conventional, traceable commits and safe push handoffs. |
| `onu-git-workflows` | Apply safe branch synchronization, history, conflict, and recovery workflows. |
| `onu-git-worktrees` | Create and operate isolated worktrees for parallel or clean-checkout work. |

### 2. Backend, frontend, architecture, and security

| Area | Skills | Use when… |
| --- | --- | --- |
| Backend | `onu-backend-feature-development`, `onu-backend-dotnet-architecture`, `onu-backend-dotnet-patterns`, `onu-backend-ef-core` | The change affects APIs, application behavior, .NET composition, or persistence. |
| Frontend | `onu-frontend-design`, `onu-frontend-development`, `onu-frontend-guidelines` | The change affects React, TypeScript, routes, forms, UI state, or client data. |
| Backend security | `onu-backend-security` | API, validation, authorization, persistence, or sensitive backend data is involved. |
| Frontend security | `onu-frontend-security` | Client auth flow, redirects, input handling, DOM safety, or data exposure is involved. |
| Cross-cutting security | `onu-security-management` | Security needs assessment across frontend, backend, authentication, persistence, or AI flows. |
| Architecture | `onu-architecture-adr`, `onu-architecture-domain-modeling`, `onu-architecture-review` | Boundaries, invariants, ownership, integration, or meaningful architectural trade-offs are involved. |

### 3. Quality and review

| Skill | Purpose |
| --- | --- |
| `onu-quality-code-review` | Orchestrate a complete production-readiness review. |
| `onu-quality-ai-code-review` | Combine automated analysis with focused AI-assisted reasoning. |
| `onu-quality-code-review-be` | Review .NET backend, persistence, API, DI, messaging, and configuration changes. |
| `onu-quality-code-review-fe` | Review React/TypeScript components, hooks, forms, routing, and client integrations. |
| `onu-quality-code-review-checklist` | Apply the project-specific review checklist across functionality, security, performance, maintainability, and tests. |
| `onu-quality-production-code-review` | Review diffs and pull requests for actionable defects, contract risks, and missing evidence. |
| `onu-quality-clean-code` | Improve readability, cohesion, and maintainability during implementation or review. |
| `onu-quality-performance` | Diagnose performance issues across React/Vite, EF Core, and ASP.NET Core. |
| `onu-quality-refactoring` | Reduce technical debt while preserving behavior and scope. |

### 4. Documentation, product, and research

| Skill | Purpose |
| --- | --- |
| `onu-documentation-generation` | Create accurate, project-grounded technical documentation. |
| `onu-documentation-readme` | Create or update project, module, or feature READMEs. |
| `onu-documentation-finder` | Locate knowledge artifacts deterministically. |
| `onu-documentation-excalidraw-diagrams` | Describe architecture and workflows as diagrams. |
| `onu-documentation-professional-writing` | Turn project learnings into safe, reusable professional articles. |
| `onu-knowledge-project-builder` | Build durable project knowledge through approval-driven quality gates. |
| `onu-product-prd` | Create or maintain product requirement documents. |
| `onu-product-user-story` | Create or revise implementation-ready user stories. |
| `onu-research-deep` | Perform decision-focused research across requirements, users, code, tests, and external sources. |

### 5. Specialized and tool-specific skills

| Skill or family | Use when… |
| --- | --- |
| `onu-agent-name-picker` | A session needs an assigned agent identity. |
| `onu-content-seo` | Public or help content needs search-oriented writing. |
| `onu-frontend-presentations` | Frontend work needs a stakeholder-facing walkthrough or presentation. |
| `onu-orchestration-agent-improvement` | Existing delegation, ownership, checkpoints, or handoffs need improvement. |
| `onu-skill-discovery` | Installed skills need to be discovered or inspected. |
| `imagegen`, `documents`, `pdf`, `presentations`, `spreadsheets` | The request involves the corresponding artifact type. |
| `browser-use:browser`, `computer-use:computer-use` | Browser or desktop interaction is explicitly required. |
| `plugin-management:plugin-management` | Plugins, app permissions, or external connections are involved. |
| `sites:*` | A Sites-hosted website, preview, hosting, or MCP server is involved. |
| `template-creator:template-creator` | A reusable artifact-template skill is requested. |
| `visualize:visualize` | A diagram, simulation, chart, or interactive explanation materially improves understanding. |
| `work-pets:*` | A ChatGPT Work pet must be created, inspected, or updated. |

## Recommended compositions

### Standard feature

```text
onu-workflow-development-entry
  -> onu-implementation-planning
  -> backend or frontend implementation skills
  -> security and quality review
  -> tests and local verification
  -> onu-git-commit / onu-delivery-pull-request
```

### Documentation-only change

```text
onu-workflow-development-entry
  -> onu-documentation-generation or onu-documentation-readme
  -> link, terminology, and rendering verification
```

Keep documentation-only work limited to documentation and README files. Do not modify agent or skill definitions while documenting them.

### Multi-story delivery

```text
onu-delivery-issues-kickoff or onu-delivery-user-story-kickoff
  -> onu-story-orchestrator
  -> bounded implementation lanes
  -> coordinated review and verification
  -> onu-delivery-pull-request
```

## Guardrails

- Read selected skill instructions before taking action.
- Preserve unrelated working-tree changes.
- Do not treat a plan, label, or draft issue as implementation approval.
- Keep local validation, hosted state, pull-request state, and CI evidence separate.
- Do not push, publish, update hosted issues, or create a PR unless that delivery action is authorized and its gates are satisfied.
