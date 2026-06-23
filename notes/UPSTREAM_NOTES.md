# Upstream notes

This file separates possible upstream documentation candidates from local-only repository material. The goal is to keep review small and avoid presenting local prototype automation as Whonix maintenance work.

## Upstream candidates

- Dev/UTM Apple Silicon limitations note.
- UTM prototype metadata schema idea.
- Verification-first documentation wording.
- Tor Browser aarch64 status note.
- Apple Silicon UTM tested matrix format.

## Local-only material

- UTM import/export automation.
- Local prototype signing workflow.
- Bundle assembly script.
- Fixed TCP port cleanup checks.
- Local smoke/leak wrappers.

## Suggested review order

1. Review the notes without importing any VM artifact.
2. Review `metadata.example.json` and safety fields.
3. Review `verify-bundle.sh` as an example helper.
4. Review `REVIEW_RISKS.md`.
5. Decide which notes are small enough for upstream discussion.
