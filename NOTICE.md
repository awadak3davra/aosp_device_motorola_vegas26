# Authorship and licenses

All code here is Apache License 2.0 (see `LICENSE`), as are the upstream sources it is derived from. The
original copyright headers and SPDX tags in each file are kept.

## Upstream

| Part | Origin | Revision |
|---|---|---|
| `device/motorola/vegas26` | [jimmielin/android_device_motorola_vegas26](https://github.com/jimmielin/android_device_motorola_vegas26) (LineageOS 23.2 tree, forked from `device/motorola/vegas`) | `2f272f6001fe50e41449dba42c88d4f8f7d6c793` |
| `device/motorola/mt6835-common` | [jimmielin/android_device_motorola_mt6835-common](https://github.com/jimmielin/android_device_motorola_mt6835-common) | `7165604e8239615da71cb0133c5e71f84738b2cf` |
| `mt6835-common/compat/libbase`, `compat/libprocessgroup` | [LineageOS/android_hardware_lineage_compat](https://github.com/LineageOS/android_hardware_lineage_compat) | `0dec3d5ab188c36125930cdaa9a57a225f298fea` |
| `mt6835-common/sensors/subhal-1.0` | [LineageOS/android_hardware_lineage_interfaces](https://github.com/LineageOS/android_hardware_lineage_interfaces) `sensors/` | `4f6225db0d3c8cda1f59641fe0d7e53bd5e6449a` |
| `mt6835-common/sepolicy/libperfmgr` | [LineageOS/android_device_lineage_sepolicy](https://github.com/LineageOS/android_device_lineage_sepolicy) `libperfmgr/vendor` | `dbf2ed7498761fbe4313875ba47a70418703e94d` |
| `mt6835-common/overlay/NcmTetheringOverlayMT6835` | `overlay/rro_packages/NcmTetheringOverlay` from [PixelOS-AOSP/android_vendor_lineage](https://github.com/PixelOS-AOSP/android_vendor_lineage) (LineageOS vendor/lineage), renamed | `2904d731d438cf6aa12f9ee39670ad0d0907c96a` |
| Patched repos (`patches/`) | LineageOS `hardware/mediatek`, `hardware/motorola`, `device/mediatek/sepolicy_vndr`; PixelOS-AOSP `hardware/google/pixel`; AOSP `build/soong` | see `local_manifests/vegas26-aosp17.xml` |

## Ours

On top of the upstream revisions above:
- the Android 17 fixes in both device trees;
- the plain AOSP layer: the `aosp_vegas26` product, the kernel copy rule, the removal of Lineage-only modules,
  the sepolicy macro expansion and the first-boot sepolicy fixes;
- everything in `patches/`, `scripts/` and `local_manifests/`, and this documentation.

The Motorola and MediaTek proprietary files the build needs are not part of this repository and are not
covered by its license.
