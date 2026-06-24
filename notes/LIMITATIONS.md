# Limitations

- This work is not endorsed or accepted by Whonix.
- It was tested on one host and one UTM version only.
- It uses a local prototype key only.
- Fixed TCP port `8010` can create conflicts if multiple Gateway/Workstation pairs run at once.
- Dynamic resolution is explicit opt-in and should not be presented as default-on behavior.
- Dynamic resize live transition evidence is still limited.
- Tor Browser stable GNU/Linux aarch64 is not bundled or claimed.
- Systemcheck/leak-test evidence does not prove full security.
- UTM, QEMU, macOS, and Whonix changes may break assumptions.
- The local prototype artifact is not published by default.
- This repository intentionally excludes VM disks, UTM bundles, local private logs, and private builder state.
- The public repository is intended to be reviewed without importing VM images or using a local prototype bundle.
