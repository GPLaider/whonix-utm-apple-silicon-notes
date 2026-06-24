#!/usr/bin/env bash
set -euo pipefail

LC_ALL=C
export LC_ALL

die() {
  printf 'verify-bundle: %s\n' "$*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "missing required command: $1"
}

if [ "$#" -ne 1 ]; then
  die "usage: $0 /path/to/Whonix-UTM-Apple-Silicon-...developers-only....tar"
fi

bundle_tar=$1
[ -f "$bundle_tar" ] || die "bundle tar does not exist: $bundle_tar"

case "$(basename "$bundle_tar")" in
  *developers-only*.tar) ;;
  *) die "bundle tar basename must include developers-only" ;;
esac

sum_file="${bundle_tar}.SHA512SUM"
sig_file="${sum_file}.asc"
[ -f "$sum_file" ] || die "missing sidecar checksum: $sum_file"
[ -f "$sig_file" ] || die "missing sidecar checksum signature: $sig_file"

need_cmd tar
need_cmd gpg
need_cmd python3
need_cmd awk
need_cmd cmp
need_cmd sort
need_cmd mktemp

if command -v sha512sum >/dev/null 2>&1; then
  sha_check=(sha512sum -c)
elif command -v shasum >/dev/null 2>&1; then
  sha_check=(shasum -a 512 -c)
else
  die "missing sha512sum or shasum"
fi

tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/whonix-utm-verify.XXXXXX")
cleanup() {
  case "$tmpdir" in
    "${TMPDIR:-/tmp}"/whonix-utm-verify.*)
      rm -r "$tmpdir"
      ;;
    *)
      printf 'verify-bundle: refusing unexpected cleanup path: %s\n' "$tmpdir" >&2
      ;;
  esac
}
trap cleanup EXIT HUP INT TERM

bundle_abs=$(cd "$(dirname "$bundle_tar")" && pwd -P)/$(basename "$bundle_tar")
sum_abs=$(cd "$(dirname "$sum_file")" && pwd -P)/$(basename "$sum_file")
sig_abs=$(cd "$(dirname "$sig_file")" && pwd -P)/$(basename "$sig_file")

(
  cd "$(dirname "$bundle_abs")"
  "${sha_check[@]}" "$(basename "$sum_abs")" >/dev/null
) || die "outer tar SHA512 check failed"

gpg --verify "$sig_abs" "$sum_abs" >/dev/null 2>"$tmpdir/gpg-outer.log" || {
  sed -n '1,80p' "$tmpdir/gpg-outer.log" >&2
  die "outer tar SHA512 signature verification failed"
}

tar -tf "$bundle_abs" > "$tmpdir/tar-list.txt" || die "could not list bundle tar"

python3 - "$tmpdir/tar-list.txt" <<'PY' || exit 1
import pathlib
import sys

list_path = pathlib.Path(sys.argv[1])
roots = set()
for raw in list_path.read_text(encoding="utf-8").splitlines():
    if not raw:
        raise SystemExit("empty tar member name")
    p = pathlib.PurePosixPath(raw)
    if p.is_absolute():
        raise SystemExit(f"absolute tar member path: {raw}")
    if ".." in p.parts:
        raise SystemExit(f"parent traversal tar member path: {raw}")
    roots.add(p.parts[0])
if len(roots) != 1:
    raise SystemExit(f"expected one top-level bundle directory, found {sorted(roots)}")
PY

mkdir -p "$tmpdir/extract"
tar -xf "$bundle_abs" -C "$tmpdir/extract" 2>"$tmpdir/tar-extract.log" || {
  sed -n '1,80p' "$tmpdir/tar-extract.log" >&2
  die "could not extract bundle tar"
}

root_name=$(awk -F/ 'NF {print $1; exit}' "$tmpdir/tar-list.txt")
bundle_root="$tmpdir/extract/$root_name"
metadata="$bundle_root/metadata.json"
[ -f "$metadata" ] || die "metadata.json missing inside bundle tar"

python3 - "$metadata" <<'PY' || die "metadata policy check failed"
import json
import pathlib
import sys

metadata = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
required_booleans = {
    "official_release": False,
    "supported_by_whonix": False,
    "not_endorsed_by_whonix": True,
    "developers_only": True,
    "bundled_tor_browser_stable": False,
    "dynamic_resolution_default_enabled": False,
    "dynamic_resolution_explicit_opt_in": True,
    "prototype": True,
    "locally_signed": True,
    "public_end_user_distribution": False,
    "review_candidate": True,
}
for key, expected in required_booleans.items():
    actual = metadata.get(key)
    if actual is not expected:
        raise SystemExit(f"{key} must be {expected!r}, got {actual!r}")
if metadata.get("signing_key_type") != "local prototype key":
    raise SystemExit("signing_key_type must be 'local prototype key'")
for key in ("name", "version", "whonix_version", "artifact_sha512", "verification_commands"):
    if key not in metadata:
        raise SystemExit(f"missing required metadata key: {key}")
PY

[ -f "$bundle_root/checksums/SHA512SUMS" ] || die "missing internal artifact checksum file"
[ -f "$bundle_root/checksums/SHA512SUMS.asc" ] || die "missing internal artifact checksum signature"
[ -f "$bundle_root/checksums/BUNDLE-SHA512SUMS" ] || die "missing internal bundle checksum file"
[ -f "$bundle_root/checksums/BUNDLE-SHA512SUMS.asc" ] || die "missing internal bundle checksum signature"
[ -f "$bundle_root/signatures/SHA512SUMS.asc" ] || die "missing signatures/SHA512SUMS.asc"
[ -f "$bundle_root/signatures/BUNDLE-SHA512SUMS.asc" ] || die "missing signatures/BUNDLE-SHA512SUMS.asc"
[ -f "$bundle_root/signatures/prototype-signing-key.asc" ] || die "missing signatures/prototype-signing-key.asc"

cmp -s "$bundle_root/checksums/SHA512SUMS.asc" "$bundle_root/signatures/SHA512SUMS.asc" || {
  die "signatures/SHA512SUMS.asc does not match checksums/SHA512SUMS.asc"
}
cmp -s "$bundle_root/checksums/BUNDLE-SHA512SUMS.asc" "$bundle_root/signatures/BUNDLE-SHA512SUMS.asc" || {
  die "signatures/BUNDLE-SHA512SUMS.asc does not match checksums/BUNDLE-SHA512SUMS.asc"
}

(
  cd "$bundle_root"
  "${sha_check[@]}" checksums/SHA512SUMS >/dev/null
) || die "internal artifact checksum verification failed"

gpg --verify "$bundle_root/checksums/SHA512SUMS.asc" "$bundle_root/checksums/SHA512SUMS" >/dev/null 2>"$tmpdir/gpg-internal.log" || {
  sed -n '1,80p' "$tmpdir/gpg-internal.log" >&2
  die "internal artifact checksum signature verification failed"
}

(
  cd "$bundle_root"
  "${sha_check[@]}" checksums/BUNDLE-SHA512SUMS >/dev/null
) || die "internal bundle checksum verification failed"

gpg --verify "$bundle_root/checksums/BUNDLE-SHA512SUMS.asc" "$bundle_root/checksums/BUNDLE-SHA512SUMS" >/dev/null 2>"$tmpdir/gpg-bundle-internal.log" || {
  sed -n '1,80p' "$tmpdir/gpg-bundle-internal.log" >&2
  die "internal bundle checksum signature verification failed"
}

python3 - "$metadata" "$bundle_root" <<'PY' || die "artifact SHA512 does not match metadata"
import hashlib
import json
import pathlib
import sys

metadata = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
root = pathlib.Path(sys.argv[2])
artifacts = metadata.get("artifacts", {})
expected = metadata.get("artifact_sha512", {})
for role in ("gateway", "workstation"):
    rel = artifacts.get(role)
    wanted = expected.get(role)
    if not rel:
        raise SystemExit(f"missing artifacts.{role}")
    if not wanted:
        raise SystemExit(f"missing artifact_sha512.{role}")
    path = root / rel
    if not path.is_file():
        raise SystemExit(f"missing artifact file for {role}: {rel}")
    digest = hashlib.sha512()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    actual = digest.hexdigest()
    if actual != wanted:
        raise SystemExit(f"{role} sha512 mismatch: {actual} != {wanted}")
PY

printf 'verification passed for unofficial developers-only prototype\n'
