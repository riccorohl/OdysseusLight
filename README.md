# OdysseusLight

A standalone planning suite for turning ideas and existing projects into understandable product definitions, roadmaps, and milestone specifications. Inspired by Project OS's planning practices; its execution framework is not required.

## Use it

Choose a skill, or give its Markdown instructions directly to a capable agent:

- [Plan a project](skills/odysseus-plan-project/SKILL.md): establish the product and roadmap from an idea, brief, or existing repository.
- [Plan a milestone](skills/odysseus-plan-milestone/SKILL.md): detail the next selected outcome and prepare its implementation handoff.
- [Review a plan](skills/odysseus-review-plan/SKILL.md): check consistency or revise planning from new decisions and implementation evidence.

Example requests:

> Use OdysseusLight to plan this project. Inspect what exists, ask about consequential unknowns, and draft the product definition and roadmap.

> Detail M01 for implementation. Preserve its outcome; leave execution decomposition to the implementer.

> Review this implementation summary against M01. Distinguish demonstrated completion from unverified claims and propose only the necessary planning updates.

Output defaults to `docs/planning/`. Existing authoritative documents can remain where they are and be referenced. The [synthetic example](examples/draftbook/INDEX.md) demonstrates a complete small handoff.

## Responsibility boundary

The planner decides milestone boundaries around demonstrable outcomes or major uncertainties. The implementer examines the actual repository and decides whether smaller execution steps are useful. Session length, context window size, and a preferred model are not reasons for inventing roadmap milestones.

The planner also owns resolving consequential product questions: investigate discoverable facts, explain concrete choices and a recommendation, ask the owner, incorporate the answer, and continue. A draft with unresolved product choices is progress, not a completed implementation-ready plan. Technical decisions stay with the implementer. Planning completeness, owner approval, and readiness of known prerequisites are separate facts; an approved milestone does not need a duplicate activation approval. Handoffs distinguish saved documents from chat-only proposals and use portable relative links in saved packs.

Requirements and consequential constraints remain stable until the owner changes them. Suggestions and routine technical approaches can evolve as evidence arrives. Ask the owner about meaningful product, cost, or risk changes; investigate ordinary technical questions and continue independent work.

Planning does not generate implementation issues, publish GitHub milestones, run delivery agents, install application dependencies, or alter application code. A planning pack requires no runtime, API key, GitHub account, or vendor-specific mode to read. Compatibility means portable documents, not a guarantee of equal results or tested support for every model.

## Existing projects

Inspect relevant instructions and source evidence first. Separate implemented behavior from desired behavior. Preserve application files and unrelated work. If legacy Project OS instructions impose an execution process, identify the exact conflict and propose a scoped adoption change; generating a plan does not silently remove those instructions.

## Development

Run `npm test` on Windows with Node.js 18+ and Windows PowerShell to check document structure and installation fixtures. There are no npm dependencies to install. Behavioral review uses the [synthetic scenarios](examples/SCENARIOS.md); structural checks do not prove model behavior.

## Install and restore on Windows

Installation replaces the five Project OS skill folders in the user's skill directory and only its marked global instruction block, preserving unrelated guidance. It backs up original content before making changes. Existing application repositories are not migrated.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/manage-installation.ps1
```

Save the returned backup path. To restore that installation's original state:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/manage-installation.ps1 -Action Restore -BackupPath '<returned-backup-path>'
```

Start a fresh agent session after installation so discovery uses the newly installed skills. Do not assume existing chats have discarded their earlier instructions.

To update an existing OdysseusLight installation, use its current backup path:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/manage-installation.ps1 -Action Update -PreviousBackupPath '<current-installation-backup-path>'
```

Keep the new backup path returned by a successful update. Restore using that new path to return to the preceding installed version; retain the original installation backup if you later want to return to Project OS. Repeating the same update is a no-op. Updates refuse to overwrite locally edited managed skills or guidance and preserve unrelated global instructions. Review any reported conflict before retrying.

`skills/` contains the reusable instructions and templates; `examples/` contains synthetic planning evidence. Templates are drafting aids, not application runtime contracts. Tests and installation utilities belong to this suite and are not copied into planned applications.

Private development only. The original Project OS repository and existing application repositories remain unchanged by creating this suite.
