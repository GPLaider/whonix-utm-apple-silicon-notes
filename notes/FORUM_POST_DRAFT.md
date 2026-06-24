# Apple Silicon UTM prototype notes: structure and verification review

I have been experimenting with Apple Silicon UTM notes and a local developers-only prototype artifact.

Repository: https://github.com/GPLaider/whonix-utm-apple-silicon-notes

This is not a Whonix project artifact, not endorsed by Whonix, not for general users, and not a replacement for derivative-maker. The goal is narrow: review the structure, notes, verification checks, and the split between upstreamable material and local-only packaging scripts.

Current local notes:

- Gateway starts in headless form.
- Workstation starts with LXQt.
- Workstation routes through `10.152.152.10`.
- Workstation DNS points at `10.152.152.10` and `fd19:c33d:88bc::10`.
- Smoke and Whonix systemcheck leak-test evidence is included in the local notes.

Important limits:

- The prototype artifact is signed only with a local prototype key.
- It was tested on one UTM version and one Apple Silicon host.
- Tor Browser for GNU/Linux aarch64 is not bundled; my local notes only record the observed upstream metadata status at test time.
- The Gateway/Workstation pair currently uses fixed internal TCP port `8010`.
- Dynamic resolution is treated as explicit opt-in because Whonix Workstation disables automatic resizing by default to reduce resolution fingerprinting risk.
- Some AI-assisted scripts and notes were locally reviewed and tested before posting.

The local prototype artifact is not published in this repository and is not requested for review in this forum post. I do not want to create user-facing distribution confusion.

Please review the structure and notes, especially the verification-first flow and which parts should remain local-only.
