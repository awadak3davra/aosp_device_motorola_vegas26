#!/bin/bash
# Install the aosp_vegas26 device trees and patches into an AOSP android-17.0.0_r1 checkout.
# Usage: scripts/apply.sh <aosp-tree-root> [<vendor-extra-repo>]
# Run it after `repo sync` (with local_manifests/vegas26-aosp17.xml). With the second argument, the vendor delta
# repo (proprietary_vendor_motorola_vegas26-extra) is copied over jimmielin's mt6835-common-vegas26 vendor tree.
set -euo pipefail
HERE=$(cd "$(dirname "$0")/.." && pwd)
T=${1:?usage: apply.sh <aosp-tree-root> [<vendor-extra-repo>]}
EXTRA=${2:-}
[ -z "$EXTRA" ] || EXTRA=$(cd "$EXTRA" && pwd)
cd "$T"
[ -f build/envsetup.sh ] || { echo "not an AOSP tree: $T" >&2; exit 1; }
GIT="git -c user.name=aosp-vegas26 -c user.email=aosp-vegas26@invalid"

# 1. Device trees.
for d in vegas26 mt6835-common; do
  mkdir -p device/motorola/$d
  rsync -a --delete --exclude=.git "$HERE/device/motorola/$d/" device/motorola/$d/
done

# 2. Patches for the HAL repos and build/soong (one directory per repo, path with / replaced by _).
for p in "$HERE"/patches/*/; do
  repo=$(basename "$p" | tr _ /)
  repo=${repo/sepolicy\/vndr/sepolicy_vndr}
  echo "== $repo"
  $GIT -C "$repo" am -q --3way "$p"*.patch
done

# 3. MediaTek boot jars: platform-bootclasspath (root namespace) cannot see modules inside the
#    hardware/mediatek namespace on plain AOSP, so they are built from device/mediatek/frameworks.
F=device/mediatek/frameworks
rm -rf $F; mkdir -p $F
for d in common telecom-common telephony-common; do
  cp -a hardware/mediatek/frameworks/$d $F/$d
  [ -f $F/$d/Android.bp.disabled-aosp ] && mv $F/$d/Android.bp.disabled-aosp $F/$d/Android.bp
done

# 4. Vendor delta on top of jimmielin's vendor tree (optional; the alternative is extracting from your own dump).
if [ -n "$EXTRA" ]; then
  V=vendor/motorola/mt6835-common-vegas26
  [ -d $V/proprietary ] || { echo "missing $V: sync the vendor repos from the local manifest" >&2; exit 1; }
  (cd "$EXTRA" && sha256sum -c --quiet files.sha256)
  rsync -a --exclude=.git --exclude=README.md --exclude=files.sha256 --exclude=removed-files.txt "$EXTRA/" $V/
  echo "Vendor delta applied. Ready to build."
else
  echo "Done. Next: extract the vendor blobs from your stock dump, then scripts/gen-compat.py (see README.md)."
fi
