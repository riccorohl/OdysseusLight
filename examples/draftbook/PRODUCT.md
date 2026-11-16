# Draftbook product

Status: Draft — synthetic example.

## User and problem

A writer needs to preserve an unfinished draft and resume editing after closing the application.

## Required behavior and success

Save a draft's title and body, reopen them unchanged, and show a failed save without discarding the currently edited text.

## Release boundary and non-goals

The first release supports one local draft. Sharing, synchronization, accounts, version history, and formatting are excluded.

## Constraints

Draft content stays on the user's device because remote storage is outside the release boundary.

## Evidence, assumptions, and suggestions

No application has been implemented. Assumption: one local draft satisfies the initial workflow; validate with the owner before extending scope. Suggestion: reuse an existing local storage facility if the application has one.

## Open decisions

None for this demonstration. Its scope remains proposed, not owner-approved.
