#!/system/bin/sh
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Copy the firmware of the running slot onto the other slot. Run as root on
# the phone (LineageOS recovery's adb shell, or a rooted adb shell).
#
# Motorola MT6835 phones (vegas, vegas26) ship with only one slot populated:
# the other slot's lk, tee and remaining firmware partitions are empty, yet
# that slot can still be marked bootable. If the bootloader ever falls back
# to it, the preloader finds no LK, and these phones have no known BROM
# rescue. With the running slot's firmware copied over, a fallback reaches
# LK and fastboot instead, and A/B updates that switch slots get firmware
# that matches.
#
# Each copy reads the source, writes the target, reads the target back and
# compares checksums; the script stops at the first failure. Targets that
# already match are left alone. Set DRY_RUN=1 to only report what would be
# written.
#
# Deliberately not copied:
#   preloader  lives on the UFS boot LUs; the phone boots the active LU, and
#              rewriting a boot LU is the riskiest write there is.
#   tzapp      tzapp_a is the live Trustonic trustlet store on both slots.
#   boot, init_boot, vendor_boot, dtbo, vbmeta, vbmeta_system
#              OS images; the OS installed on the other slot brings its own.

set -e
PARTS="lk tee gz sspm spmfw mcupm dpm scp vcp pi_img md1img connsys_bt connsys_gnss connsys_wifi logo mcf_ota"

[ "$(id -u)" = 0 ] || { echo "ABORT: run as root"; exit 1; }
case "$(getprop ro.boot.slot_suffix)" in
    _a) from=_a to=_b ;;
    _b) from=_b to=_a ;;
    *) echo "ABORT: unknown slot suffix"; exit 1 ;;
esac
echo "Copying firmware from slot ${from#_} to slot ${to#_}${DRY_RUN:+ (dry run)}"

for name in $PARTS; do
    src=/dev/block/by-name/$name$from dst=/dev/block/by-name/$name$to
    [ -e "$src" ] && [ -e "$dst" ] || { echo "SKIP $name (no such partition)"; continue; }
    rsrc=$(readlink -f "$src") rdst=$(readlink -f "$dst")
    [ "$rsrc" != "$rdst" ] || { echo "ABORT $name: source and target are the same device"; exit 1; }
    if grep -q "^$rdst " /proc/mounts || grep -q "^$dst " /proc/mounts; then
        echo "ABORT $name: $dst is mounted"; exit 1
    fi
    len=$(blockdev --getsize64 "$rsrc")
    [ "$(blockdev --getsize64 "$rdst")" = "$len" ] || { echo "ABORT $name: slot sizes differ"; exit 1; }
    want=$(sha256sum < "$src" | cut -d' ' -f1)
    [ "$(sha256sum < "$dst" | cut -d' ' -f1)" = "$want" ] && { echo "SAME $name"; continue; }
    [ -n "$DRY_RUN" ] && { echo "WOULD WRITE $name ($len bytes) $rsrc -> $rdst"; continue; }
    # Partitions are read-only at runtime (BLKROSET); lift that on the target
    # only, and only for this write.
    ro=$(blockdev --getro "$rdst")
    blockdev --setrw "$rdst"
    if ! dd if="$src" of="$dst" bs=1048576 conv=fsync 2> /dev/null; then
        [ "$ro" = 1 ] && blockdev --setro "$rdst"
        echo "ABORT $name: write failed"; exit 1
    fi
    sync
    blockdev --flushbufs "$rdst"
    [ "$ro" = 1 ] && blockdev --setro "$rdst"
    echo 3 > /proc/sys/vm/drop_caches
    [ "$(sha256sum < "$dst" | cut -d' ' -f1)" = "$want" ] || { echo "ABORT $name: readback mismatch"; exit 1; }
    echo "OK $name"
done
echo ALL_DONE
