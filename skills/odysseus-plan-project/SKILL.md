---
name: odysseus-plan-project
description: Create a portable product definition and milestone roadmap from an idea, specification, or existing repository. Use for project planning; not application implementation or execution-task generation.
---

# Plan a project

Produce the smallest useful planning pack, normally in `docs/planning/`, using the templates in [assets](assets/INDEX.md). A capable agent can follow these instructions directly; no other skill, vendor mode, API, or GitHub integration is required.

## Understand before drafting

Read supplied briefs and applicable instructions. For an existing project, inspect relevant code and tests without changing the application. Distinguish intended behavior, observed implementation, assumptions, and unknowns. Reference existing authoritative documents rather than duplicating or overwriting them.

Clarify the first user, problem, main workflow, success criteria, release boundary, and non-goals. Ask only about missing decisions that materially affect the product, constraints, cost, or consequential risk. Investigate discoverable technical facts yourself. Preserve decisions already settled in the current conversation or authoritative documents.

Own the planning conversation through completion. For a consequential unresolved choice, first investigate available evidence, then present concrete options with practical consequences, a recommendation, and a focused question. Incorporate the answer and continue planning; do not merely list open decisions and hand them to the implementer. A draft is useful progress, not a completed planning request. If the owner pauses or needed evidence is unavailable, state what remains incomplete and the affected scope honestly. Continue independent work where possible.

## Produce the pack

- Use [PRODUCT.md](assets/PRODUCT.md) for the product definition and [ROADMAP.md](assets/ROADMAP.md) for outcome-level milestones.
- Use [INDEX.md](assets/INDEX.md) to explain which documents define intent and how an implementer should enter the pack. Repair template links to the actual output locations.
- Mark proposed product documents Draft. Record Approved only when the owner actually approves the relevant scope; an implementation request can supply approval when it clearly identifies that scope. No prescribed confirmation phrase or digest is needed.
- Give milestones simple stable IDs such as M01. Each milestone should deliver a demonstrable outcome or resolve a major uncertainty. State real dependencies and observable completion criteria.
- Distinguish known prerequisites from unresolved planning choices: a later milestone can have a complete plan while waiting for its named predecessor. Conversely, an unresolved product choice that changes acceptance criteria prevents claiming the affected plan is implementation-ready. Routine technical decisions remain with the implementer.
- Split milestones only for outcome-level reasons, such as independently valuable deliverables or a feasibility finding needed before committing to later scope. Do not predict model session counts or generate execution tasks.
- Identify one selected next milestone for detailed planning. Keep distant milestones light; do not invent specifications merely to fill templates.
- Record consequential decisions only when useful, with their reasons and affected scope. Routine technical choices remain with implementation.

Keep requirements, constraints (with reasons), suggestions, assumptions, and unresolved questions distinguishable. An unresolved question blocks only dependent planning; continue useful independent work. Do not invent authority, research findings, or implementation completion.

## Existing-work preservation and handoff

Read an existing destination before editing it. Preserve customized content and explain affected changes. If sources disagree, surface the specific conflict rather than silently selecting one; unaffected planning can continue. Detect legacy execution rules and explain any adoption changes needed, without rewriting global or project instructions as a side effect.

Finish a completed planning request with settled product intent, milestone boundaries, selected next milestone, and usable source links. Separate planning completeness, owner approval, and prerequisite readiness; none implies the others. Use portable relative links in saved documents and verify their destinations. Say which files were actually saved versus proposed only in chat. Never label an unsaved draft a saved pack or conceal outstanding product decisions behind a completion claim. Do not add a duplicate activation approval when existing owner approval already covers the scope. No automatic GitHub records, repository governance scaffolding, application changes, or implementation-agent orchestration.
