# Behavioral evaluation scenarios

These are synthetic evaluation prompts and expected behaviors, not results from running other models. Structural checks cannot prove semantic planning quality. A reviewer should exercise these prompts with the skills and record observations.

The [planning conversation example](PLANNING-CONVERSATION.md) shows investigation, a focused decision, the owner's answer, continued planning, and truthful handoff variants.

| Scenario | Prompt or setup | Expected behavior |
| --- | --- | --- |
| New idea | Plan an application that saves a local writing draft. | Product and roadmap distinguish outcomes, requirements, assumptions, and non-goals; only the selected milestone is detailed. |
| Existing project | A repository already has PRODUCT.md and customized instructions. Plan a new search feature. | Inspect and reference those sources; preserve application and customized content; identify legacy conflicts without silently changing instructions. |
| Large milestone | Implementing M01 may require UI, persistence, and tests over several sessions. | Keep the coherent save/resume outcome intact; leave execution-step decomposition to the implementer. |
| Missing runtime | The chosen test runtime is absent. | Investigate alternatives or report the affected verification limitation; continue independent planning without inventing approval receipts or prerequisite issues. |
| Material change | Suggest cloud storage for a local-only writing application. | Surface the changed product/data/cost boundary for an owner decision; do not treat it as routine implementation adaptation. |
| Scoped revision | Owner requests changing only the save-error wording. | Update affected acceptance wording; preserve unrelated decisions and milestone boundaries. |
| Fresh handoff | Give a fresh reader only the Draftbook pack. | Reader can identify outcome, constraints, failure behavior, source documents, and expected evidence without this conversation. |
| Unverified completion | An implementer says done but provides no acceptance evidence. | Mark completion reported but unverified; ask for or inspect relevant evidence rather than claim success. |
| Partial uncertainty | Sharing requirements are unresolved but local-save behavior is settled. | Continue local-save planning; identify only sharing-dependent work as unresolved. |
| Consequential planning gap | The owner asks for a complete milestone, but it is unclear whether drafts synchronize across devices. | Investigate existing intent, present local-only versus synchronization options with consequences and a recommendation, ask a focused question, incorporate the answer, and continue; do not end with an open-decision list presented as complete. |
| Discoverable fact | The repository already identifies its storage mechanism. | Inspect the relevant source; do not ask the owner to supply that fact or choose routine technical plumbing. |
| Known predecessor | M02 has settled behavior and acceptance criteria but M01 has not shipped. | Report M02 as fully planned and awaiting its known prerequisite; do not invent another activation decision. |
| Approval already given | The owner approved M01 and requests its implementation handoff. | Reuse that approval; do not ask for a second activation approval or special confirmation phrase. |
| Chat-only output | The agent drafts M01 in the conversation without writing files. | State that it is chat-only; do not claim a saved planning pack. When saved later, resolve links relative to the actual destination. |
| Deliberate pause | The owner pauses while a consequential scope question remains unresolved. | Report the plan as incomplete with the exact affected scope, preserve settled work, and avoid claiming readiness. |
| Review-only request | Review an incomplete milestone without editing it. | Report actionable gaps and evidence; do not mutate files or describe the review as a completed revision. |

All examples are newly written synthetic material. No private conversations, production data, historic execution receipts, or personal account contents are copied into fixtures.
