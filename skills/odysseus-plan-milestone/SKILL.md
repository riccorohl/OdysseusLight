---
name: odysseus-plan-milestone
description: Detail one selected milestone into portable requirements, acceptance examples, and a model-neutral handoff. Use before implementation; leave execution-task decomposition to the implementing system.
---

# Plan a milestone

Read the product, roadmap, selected milestone, relevant decisions, and applicable repository instructions. Inspect existing implementation where available. Use [the milestone template](assets/MILESTONE.md), normally under `docs/planning/milestones/`, adapting links and retaining existing project terminology.

## Define the outcome

State the user-visible result or uncertainty to resolve, requirements, failure behavior, non-goals, real dependencies, and observable completion criteria. Use acceptance examples that distinguish success from plausible failure. Include known integration or data boundaries when consequential, without prescribing speculative technical machinery.

Label requirements, constraints with reasons, suggestions, assumptions, and open questions separately. Preserve accepted architectural decisions. Do not require the owner to choose routine implementation details or supply information discoverable in the repository.

Own consequential planning choices through resolution. Investigate available facts first; then present concrete options, practical consequences, a recommendation, and a focused owner question. Incorporate the answer and continue refining the specification. Do not finish by handing a list of product decisions to the implementer or calling a draft a complete plan. If the owner pauses or evidence is unavailable, identify the affected unresolved scope and describe progress truthfully. Continue independent specification work meanwhile.

Distinguish known prerequisites from blocking uncertainties. A milestone can be fully planned while awaiting a known predecessor; record that dependency rather than inventing an activation decision. An unresolved product choice that changes behavior or acceptance criteria prevents calling the affected specification implementation-ready. A routine technical unknown can become an investigation inside the milestone; it does not automatically require another issue, approval, or milestone. Stop only the affected action when it would cross a consequential authorization boundary.

## Size by outcome

Keep a coherent milestone intact by default. Recommend a roadmap split only for distinct valuable outcomes or major prerequisite uncertainty, explaining the product-level reason. The implementer decides whether execution needs smaller changes after examining the code. Do not split based on context windows, estimated sessions, model selection, or arbitrary task counts.

## Handoff

Provide relevant source links, the intended outcome, acceptance criteria, meaningful constraints, open decisions, and expected completion evidence. The implementer may choose tools, technical plan, task ordering, and debugging steps. An ordinary failure calls for investigation and repair within scope, not a new authorization contract. A material product or consequential-risk change returns to the owner.

Mark new or materially revised scope Draft until approved; retain approval for unchanged settled scope. Existing approval in the conversation counts when its scope is clear. Do not demand a special phrase, artifact hash, or second approval for the same decision.

Review the document for contradictions, unsupported claims, usable relative links to actual source locations, and accidental implementation mandates. Report planning completeness, owner approval, and prerequisite readiness separately. Existing scoped approval does not need a duplicate activation approval. Explain whether the specification was saved to a named file or exists only in chat; do not claim a saved artifact or completed planning when either is untrue. Do not generate implementation issues, publish milestones, change application code, or require vendor-specific modes.
