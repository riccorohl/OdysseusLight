---
name: odysseus-review-plan
description: Review planning consistency or revise affected planning documents using owner decisions and implementation evidence. Use for plan review, change impact, or milestone reconciliation; not automatic implementation or repository migration.
---

# Review or revise a plan

Read the planning index, relevant product and milestone documents, accepted decisions, and supplied implementation results. Inspect repository evidence when available. This workflow is self-contained and accepts ordinary prose summaries, diffs, demonstrations, and test output; no proprietary receipt or execution system is required.

For a review request, report findings without changing files. For a revision request, update only affected planning content and preserve unrelated decisions and user work. Do not rewrite application code or global/project instructions as a planning side effect.

Check:

- Requirements and acceptance examples agree with product intent.
- Milestones have coherent outcomes, real dependencies, and no invented session-size limits.
- Suggestions remain optional, assumptions remain unverified until supported, and consequential unresolved choices are visible.
- A handoff reader can find relevant sources and understand success without the original chat.
- Completion claims distinguish demonstrated results, reported-but-unverified results, failed checks, and unavailable evidence.
- Planning completeness, owner approval, and prerequisite readiness are distinguished. Known dependencies are not unresolved owner choices; unresolved product choices that affect acceptance prevent claiming an implementation-ready plan.
- Saved documents use usable relative source links, and the handoff distinguishes actual saved artifacts from chat-only proposals.

Investigate ordinary technical uncertainty before requesting owner input. Missing information blocks only the affected conclusion. A failed test or missing runtime does not itself justify another roadmap milestone or permission chain. Let the implementer repair within the agreed outcome; propose planning changes when discoveries materially affect product behavior, scope, cost, or consequential risk.

For revisions, summarize what changed, why, affected milestones, remaining decisions, and preserved scope. Keep unchanged approved decisions approved. Mark newly proposed material changes Draft, incorporating clearly scoped owner approval already provided. Do not ask again merely because wording, formatting, or implementation details changed.

When revision is requested, work through consequential planning gaps instead of ending with a draft and an open-decision list. Investigate discoverable facts, present concrete options with consequences and a recommendation, ask a focused question, incorporate the answer, and continue. Technical choices remain with the implementer. A review-only request may finish with findings without making revisions; clearly distinguish that review result from a completed revised plan. If the owner pauses or evidence remains unavailable, report the affected incomplete scope honestly while continuing independent work. Do not create a separate activation approval for already-approved scope.

When reconciling completion, record the evidence actually available and identify acceptance gaps. Elaborate the next milestone only when requested or included in the planning task. No automatic issue publication, milestone closure, task orchestration, model routing, or migration of existing Project OS guidance.
