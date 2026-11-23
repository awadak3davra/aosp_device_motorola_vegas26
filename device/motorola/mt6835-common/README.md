# Common tree for Motorola MT6835 devices

Shared LineageOS 23.2 configuration for Motorola phones on the MediaTek MT6835
(Dimensity 6300) with the Google GKI 5.15 kernel and a stock vendor frozen at
board API level 33:

| Device | Codename | Tree |
|---|---|---|
| moto g power - 2025 (XT2515V) | `vegas` | `device/motorola/vegas` |
| moto g power - 2026 (XT2617V) | `vegas26` | `device/motorola/vegas26` |

It is forked from `mt6855-common` (moto g power 5G 2024), which carries the
Motorola MBM bootloader, Trustonic TEE and MediaTek HAL work.

## Proprietary files

`proprietary-files.txt` lists the blobs both phones share. Each device
extracts it from its own stock firmware: the stock firmware lines differ in
kernel modules, Trustonic trustlets and several HALs, which must match the
TEE and modem firmware on the phone. A device selects its extraction with
`MT6835_COMMON_VENDOR_PATH` (default `vendor/motorola/mt6835-common`, the
vegas extraction); vegas26 uses `vendor/motorola/mt6835-common-vegas26`.
Files whose names or locations differ between the phones live in the device
lists.

## Tools

`tools/copy-firmware-to-other-slot.sh` copies the running slot's firmware
(lk, tee, modem and the other bootloader-chain images, not the preloader) to
the other slot, verifying every write. These phones ship with one slot
empty; run it as root after installing (for example from LineageOS recovery's
adb shell), so a bootloader fallback to the other slot reaches fastboot.
