# AOSP 17 device tree for moto g power 2026 (vegas26)

Plain AOSP (`android-17.0.0_r1`, release `cp2a`) device configuration for the Motorola moto g power - 2026
(XT2617V, `vegas26`, MediaTek MT6835 / Dimensity 6300). It builds the `aosp_vegas26` product
on the stock Motorola vendor blobs and the stock prebuilt GKI 5.15 kernel. It does not use vendor/lineage,
hardware/lineage or a LineageOS build system fork.

Status: experimental, userdebug only. It boots, and Wi-Fi, Bluetooth, the three cameras, fingerprint and LTE
data were seen working on one device. Calls, audio routing, GPS and suspend are not verified yet. There are no
OTA updates: you update by flashing images.

## Contents

| Path | What |
|---|---|
| `device/motorola/vegas26`, `device/motorola/mt6835-common` | Device trees, final state (copied into the AOSP tree) |
| `patches/<repo>` | Patches for `hardware/mediatek`, `hardware/motorola`, `device/mediatek/sepolicy_vndr`, `hardware/google/pixel`, `build/soong` |
| `local_manifests/vegas26-aosp17.xml` | Upstream repositories pinned to the exact revisions the patches apply to |
| `scripts/apply.sh` | Copies the device trees, applies the patches, sets up `device/mediatek/frameworks`, overlays the vendor delta |
| `scripts/gen-compat.py` | Generates three compat libraries for the stock blobs from AOSP VNDK snapshots and a stock `/vendor` (only for the extract-it-yourself path; the -extra repo already has them) |

No proprietary files are in this repository. The build gets them one of two ways:
- **Default:** jimmielin's public vendor trees (pinned in the local manifest) plus our Android 17 delta,
  [proprietary_vendor_motorola_vegas26-extra](https://github.com/awadak3davra/proprietary_vendor_motorola_vegas26-extra).
- **Alternative:** extract everything from the stock firmware of your own phone.

## Build

Requirements: a Linux machine that can build AOSP (about 400 GB free disk, 64 GB RAM recommended).

```bash
mkdir aosp17 && cd aosp17
repo init -u https://android.googlesource.com/platform/manifest -b android-17.0.0_r1 --depth=1
mkdir -p .repo/local_manifests
cp /path/to/aosp_device_motorola_vegas26/local_manifests/vegas26-aosp17.xml .repo/local_manifests/
repo sync -c -j8 --no-tags

# Keep the -extra repo OUTSIDE the AOSP tree (its Android.bp would clash with the vendor tree's).
git clone https://github.com/awadak3davra/proprietary_vendor_motorola_vegas26-extra ../vegas26-extra
/path/to/aosp_device_motorola_vegas26/scripts/apply.sh "$PWD" ../vegas26-extra

source build/envsetup.sh
lunch aosp_vegas26-cp2a-userdebug
m droid superimage
```

Alternative, blobs from your own firmware (vegas26 on vendor `W1WEOS36.48-22-3-3-4-3`; the dynamic partitions as
images, or the extracted `/vendor`, `/odm` and `/system` trees): remove the two `vendor/motorola` projects from
the local manifest, then instead of the clone and the `apply.sh` line above:

```bash
/path/to/aosp_device_motorola_vegas26/scripts/apply.sh "$PWD"
device/motorola/vegas26/extract-files.py /path/to/stock-dump
python3 /path/to/aosp_device_motorola_vegas26/scripts/gen-compat.py /path/to/stock-dump/vendor
```

Images are in `out/target/product/vegas26/`. Do not redistribute the built images: they contain Motorola's
proprietary files.

## Flash (slot A only)

Read `device/motorola/vegas26/AGENTS.md` (hard rules) first. Requirements: unlocked bootloader, slot A active and
running the stock firmware the build was made against, a full backup of every partition. Check before flashing:
the kernel in `boot.img` and the DTB in `vendor_boot.img` must be byte-identical to stock, the vbmeta rollback
index must equal stock (7), and an unsparsed `super.img` must be 11475615744 bytes with extents only on `_a`.

The flash script in the device tree does the steps below with checks. Run it from `out/target/product/vegas26`,
phone in bootloader fastboot mode:

```bash
/path/to/aosp17/device/motorola/vegas26/tools/flash-vegas26.sh
```

The same steps by hand: vbmeta first (the bootloader checks every image against the vbmeta on the device),
never `--set-active`, slot A partitions named explicitly.

```bash
fastboot flash vbmeta_a vbmeta.img
fastboot flash vbmeta_system_a vbmeta_system.img
fastboot flash boot_a boot.img
fastboot flash init_boot_a init_boot.img
fastboot flash vendor_boot_a vendor_boot.img
fastboot flash dtbo_a dtbo.img
fastboot reboot fastboot            # fastbootd, must report current-slot a
fastboot wipe-super super_empty.img
for p in system system_ext product vendor vendor_dlkm; do fastboot flash $p $p.img; done
```

Then format data yourself (required when coming from stock or another ROM): `fastboot -w`, and `fastboot reboot`.

Never flash or erase the bootloader chain or firmware partitions (`preloader*`, `lk*`, `tee*`, `gz*`, `sspm*`,
`scp*`, `vcp*`, `spmfw*`, `mcupm*`, `dpm*`, `pi_img*`, `md1img*`, `connsys_*`, `seccfg`, `proinfo`, `nvram`,
`nvdata`, `nvcfg`, `persist`, `protect*`, `efuse*`, `utags*`). That can hard-brick the phone or erase its IMEI
and calibration data. Never relock the bootloader with this build installed.

## What differs from the LineageOS trees

- Plain AOSP product `aosp_vegas26` (inherits `full_base_telephony`); the stock prebuilt kernel ships through
  `PRODUCT_COPY_FILES`.
- Compat libraries come from AOSP `prebuilts/vndk` and the stock vendor image (`gen-compat.py`), not from
  hardware/lineage/compat. The two needed shims (libbase, libprocessgroup) and the HIDL sensors 1.0 sub-HAL are
  carried in `mt6835-common`.
- The MediaTek boot jars are built from `device/mediatek/frameworks` (root namespace), and `build/soong` allows
  their packages on the bootclasspath.
- Lineage-only pieces are turned off: Lineage SDK apps (MotoActions, StylusKeyHandler, MotoExtTelephony,
  InCallService), `vendor.lineage.touch`, PowerOffAlarm, the Aperture overlay. Lineage sepolicy macros are
  expanded into plain AOSP rules.

See `NOTICE.md` for authorship and licenses.
