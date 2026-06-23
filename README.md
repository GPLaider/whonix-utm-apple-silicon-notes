# Whonix UTM Apple Silicon notes

Unofficial Apple Silicon UTM notes and local developers-only prototype artifact structure for Whonix testing. This is not a Whonix project artifact, not endorsed by Whonix, not for general users, and not a replacement for derivative-maker. It was tested on one Apple Silicon + UTM environment only. Some scripts and notes are AI-assisted and human-reviewed.

## What this is

This repository collects review material for Apple Silicon UTM prototype work around Whonix:

- notes on the local Gateway/Workstation UTM shape
- a verification-first flow for locally signed prototype bundles
- limitations and review risks
- a split between possible upstream documentation improvements and local-only automation
- example smoke/leak result summaries with private paths and large artifacts removed

The local prototype artifact is not published by default. It can be shared for review if useful, but this repository should not create user-facing distribution confusion.

## What this is not

- It is not a Whonix project artifact.
- It is not endorsed by Whonix.
- It is not for general users.
- It is not a replacement for derivative-maker.
- It is not a general Apple Silicon compatibility statement.
- It does not include VM disks, UTM bundles, or tar artifacts.
- It does not include private build logs, local paths, hostnames, private email addresses, or local GPG identity text.

## Current local test notes

Local notes from one Apple Silicon + UTM setup recorded:

- Gateway starts in headless form.
- Workstation starts with LXQt.
- Workstation routes through `10.152.152.10`.
- Workstation DNS points at `10.152.152.10` and `fd19:c33d:88bc::10`.
- Smoke and Whonix systemcheck leak-test evidence was collected locally.

These notes are examples for review, not a broad compatibility claim.

## Important limitations

- Not endorsed or accepted by Whonix.
- Tested on one host and one UTM version only.
- Local prototype signing key only.
- Fixed TCP port `8010` can conflict when multiple pairs run at once.
- Dynamic resize live transition was not fully measured.
- Tor Browser stable GNU/Linux aarch64 is not bundled or claimed.
- Systemcheck/leak-test evidence does not prove full security.
- UTM, QEMU, macOS, and Whonix changes may break assumptions.

## Verification-first flow

If a local prototype bundle is shared for review, verify before extraction or import:

```sh
gpg --verify Whonix-UTM-Apple-Silicon-...tar.SHA512SUM.asc \
  Whonix-UTM-Apple-Silicon-...tar.SHA512SUM
shasum -a 512 -c Whonix-UTM-Apple-Silicon-...tar.SHA512SUM
./verify-bundle.sh Whonix-UTM-Apple-Silicon-...tar
```

`verify-bundle.sh` is an example helper. It expects a tar path, a `.SHA512SUM` sidecar, and a detached `.SHA512SUM.asc` signature next to the tar. It does not download dependencies, does not run remote scripts, and has no local absolute path dependency.

## Local prototype artifact status

The local prototype artifact is not published by default. It can be shared for review if useful, but this repository should not create user-facing distribution confusion.

When shared, it should be accompanied by hash, detached signature, metadata, limitations, and review-risk notes.

## Upstreamable vs local-only material

Possible upstream documentation candidates:

- Dev/UTM Apple Silicon limitations note
- UTM prototype metadata schema idea
- verification-first documentation wording
- Tor Browser aarch64 status note
- Apple Silicon UTM tested matrix format

Local-only material:

- UTM import/export automation
- local prototype signing workflow
- bundle assembly script
- fixed TCP port cleanup checks
- local smoke/leak wrappers

## AI-assisted work note

Some scripts and documentation were drafted with AI assistance. The repository owner reviewed, tested, and verified the local outputs before publication. AI assistance is not a substitute for upstream review, cryptographic verification, or Whonix endorsement. AI-assisted content should remain disclosed.

## Review request

Please review the structure and notes, especially:

- whether the verification-first flow is clear
- whether local-only scripts are separated from upstream candidates
- whether the limitations are direct enough
- whether `REVIEW_RISKS.md` covers likely project review concerns

## License

Original notes and helper scripts in this repository are provided under the MIT License unless otherwise noted. Whonix, Tor Browser, UTM, QEMU, Debian, and related projects remain under their own licenses and are not redistributed here.
