# Behavioral evaluation scenarios

These are synthetic evaluation prompts and expected behaviors, not results from running other models. Structural checks cannot prove semantic planning quality. A reviewer should exercise these prompts with the skills and record observations.

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

All examples are newly written synthetic material. No private conversations, production data, historic execution receipts, or personal account contents are copied into fixtures.
