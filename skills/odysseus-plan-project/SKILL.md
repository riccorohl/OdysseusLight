---
name: odysseus-plan-project
description: Create a portable product definition and milestone roadmap from an idea, specification, or existing repository. Use for project planning; not application implementation or execution-task generation.
---

# Plan a project

Produce the smallest useful planning pack, normally in `docs/planning/`, using the templates in [assets](assets/INDEX.md). A capable agent can follow these instructions directly; no other skill, vendor mode, API, or GitHub integration is required.

## Understand before drafting

Read supplied briefs and applicable instructions. For an existing project, inspect relevant code and tests without changing the application. Distinguish intended behavior, observed implementation, assumptions, and unknowns. Reference existing authoritative documents rather than duplicating or overwriting them.

Clarify the first user, problem, main workflow, success criteria, release boundary, and non-goals. Ask only about missing decisions that materially affect the product, constraints, cost, or consequential risk. Investigate discoverable technical facts yourself. Preserve decisions already settled in the current conversation or authoritative documents.

## Produce the pack

- Use [PRODUCT.md](assets/PRODUCT.md) for the product definition and [ROADMAP.md](assets/ROADMAP.md) for outcome-level milestones.
- Use [INDEX.md](assets/INDEX.md) to explain which documents define intent and how an implementer should enter the pack. Repair template links to the actual output locations.
- Mark proposed product documents Draft. Record Approved only when the owner actually approves the relevant scope; an implementation request can supply approval when it clearly identifies that scope. No prescribed confirmation phrase or digest is needed.
- Give milestones simple stable IDs such as M01. Each milestone should deliver a demonstrable outcome or resolve a major uncertainty. State real dependencies and observable completion criteria.
- Split milestones only for outcome-level reasons, such as independently valuable deliverables or a feasibility finding needed before committing to later scope. Do not predict model session counts or generate execution tasks.
- Identify one selected next milestone for detailed planning. Keep distant milestones light; do not invent specifications merely to fill templates.
- Record consequential decisions only when useful, with their reasons and affected scope. Routine technical choices remain with implementation.

Keep requirements, constraints (with reasons), suggestions, assumptions, and unresolved questions distinguishable. An unresolved question blocks only dependent planning; continue useful independent work. Do not invent authority, research findings, or implementation completion.

## Existing-work preservation and handoff

Read an existing destination before editing it. Preserve customized content and explain affected changes. If sources disagree, surface the specific conflict rather than silently selecting one; unaffected planning can continue. Detect legacy execution rules and explain any adoption changes needed, without rewriting global or project instructions as a side effect.

Finish with the product outcome, proposed milestone boundaries, selected next milestone, unresolved owner decisions, and links to the pack. No automatic GitHub records, repository governance scaffolding, application changes, or implementation-agent orchestration.
