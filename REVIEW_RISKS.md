# Review risks and mitigations

This document lists possible upstream review concerns for these unofficial Apple Silicon UTM prototype notes and the related local developers-only prototype artifact.

The goal is to reduce user confusion, avoid unsupported claims, separate local-only material from possible upstream documentation improvements, and avoid creating support burden for the Whonix project.

## 1. Does this replace derivative-maker?

Concern:
A packaged VM artifact could make it look as if local UTM packaging replaces Whonix derivative-maker.

Mitigation:
The notes state that derivative-maker remains the image-construction base. Local work is limited to UTM packaging shape, local signing, verification wrappers, and review notes.

Remaining risk:
Reviewers still need to inspect the local patch and confirm that image construction remains derivative-maker based.

## 2. Does this bypass verification?

Concern:
Readers could import the UTM artifacts before checking hashes and detached signatures.

Mitigation:
The README, metadata, and checklist put verification first. `verify-bundle.sh` checks the outer tar sidecar hash, detached signature, tar member paths, metadata policy fields, artifact hashes, and bundle-level hashes.

Remaining risk:
Documentation cannot force every downstream reader to verify before importing.

## 3. Does this look like an official Whonix artifact?

Concern:
A signed tarball with Whonix in the name could create user-confusion risk.

Mitigation:
The bundle name, README, metadata, and checklist all keep the wording `unofficial`, `developers-only`, `prototype`, locally signed, and not endorsed by Whonix. Metadata includes `official_release=false` and `not_endorsed_by_whonix=true`.

Remaining risk:
Third-party reposts, screenshots, or shortened descriptions could strip that context.

## 4. Can users confuse this with accepted Apple Silicon UTM maintenance?

Concern:
A working local prototype can be mistaken for accepted Apple Silicon UTM maintenance.

Mitigation:
The notes describe this as review material only and keep `supported_by_whonix=false` in metadata.

Remaining risk:
Users may still ask Whonix channels for help if the artifact circulates without context.

## 5. Does this create support burden for Whonix?

Concern:
Forum readers may treat local test results as an invitation to request help from Whonix maintainers.

Mitigation:
The forum draft asks for review of structure and notes only. It does not ask people to use the bundle.

Remaining risk:
Any public mention of a working prototype can still attract support questions.

## 6. Is the local prototype signing key meaningful?

Concern:
A local signing key can be misunderstood as a Whonix trust anchor.

Mitigation:
The metadata and README call it a `local prototype key`. The key is useful only for checking whether this local bundle changed after signing.

Remaining risk:
Readers may still overvalue the signature unless the trust boundary is repeated near any download link.

## 7. Is Tor Browser stable for GNU/Linux aarch64 bundled or implied?

Concern:
Readers may assume the Workstation includes a stable Tor Browser bundle for GNU/Linux aarch64.

Mitigation:
The metadata keeps `bundled_tor_browser_stable=false`. The notes say no non-alpha GNU/Linux aarch64 Tor Browser bundle is included or implied.

Remaining risk:
Tor Project metadata can change, so the status note needs a fresh check before any new publication.

## 8. Is this maintainable across UTM, QEMU, macOS, and Whonix changes?

Concern:
Local packaging that works once may break after UTM, QEMU, macOS, Debian, or Whonix updates.

Mitigation:
The limitations document lists the tested host and tool versions and avoids broad compatibility claims.

Remaining risk:
Ongoing maintenance would require repeated rebuilds, imports, smoke checks, leak-test checks, and documentation updates.

## 9. Can this be split into small upstreamable documentation changes?

Concern:
A large artifact bundle is difficult to review upstream.

Mitigation:
`notes/UPSTREAM_NOTES.md` separates small documentation candidates from local-only packaging work.

Remaining risk:
Even small documentation notes may need rewording or rejection by upstream maintainers.

## 10. Are local-only scripts clearly separated from upstream candidates?

Concern:
Local UTM scripts may be mistaken for proposed upstream maintenance burden.

Mitigation:
The notes classify import/export automation, local signing, bundle assembly, and smoke/leak wrappers as standalone local repository items.

Remaining risk:
Script names and generated logs need occasional review so they do not drift back into upstream-style wording.

## 11. Does AI assistance create review risk?

Concern:
AI-assisted scripts or notes could create trust, authorship, or review concerns if hidden.

Mitigation:
Some scripts and notes were drafted with AI assistance. The repository owner reviewed, tested, and verified the local outputs before publication. AI assistance is not a substitute for upstream review, cryptographic verification, or Whonix endorsement. Any AI-assisted content should remain clearly disclosed.

Remaining risk:
Upstream reviewers may still prefer smaller patches with minimal generated prose.

## 12. Are test results overstated?

Concern:
Smoke and leak-test results can sound broader than the actual checks.

Mitigation:
The README and limitations describe the results as local evidence from one Apple Silicon UTM setup.

Remaining risk:
Short summaries may still lose the single-host, single-version, prototype context.

## 13. What does systemcheck/leak-test evidence not prove?

Concern:
Passing checks could be misunderstood as a complete anonymity or security assurance.

Mitigation:
The limitations note that the checks do not prove broad anonymity properties, future compatibility, or suitability for general users.

Remaining risk:
The phrase "leak test" may still be read too broadly without the detailed evidence nearby.

## 14. Does fixed TCP port 8010 create conflicts?

Concern:
Multiple Gateway/Workstation pairs may collide or connect incorrectly if they use the same local TCP port.

Mitigation:
The README, metadata, and limitations warn that the tested pair uses fixed internal TCP port `8010`.

Remaining risk:
A cleaner per-pair socket or port allocation design is needed before broader testing.

## 15. Is dynamic resolution fully proven?

Concern:
The Workstation resize helper may be present without proving live resize behavior across host window changes. Automatic resizing can also expose unusual screen dimensions, so presenting it as default-on behavior would conflict with the Whonix Workstation privacy default.

Mitigation:
The notes state that dynamic resolution is explicit opt-in. Metadata keeps `dynamic_resolution_default_enabled=false` and `dynamic_resolution_explicit_opt_in=true`. Local testing may enable it with `configure-dynamic-resolution`, but public notes should keep the privacy default clear.

Remaining risk:
Dynamic resolution needs a repeatable live resize test and privacy review before it is presented as more than local prototype behavior.
