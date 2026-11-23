#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/motorola/vegas26

# Kernel (stock GKI, prebuilt)
PRODUCT_COPY_FILES += device/motorola/vegas26-kernels/5.15/Image.gz:kernel

# Fingerprint
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/idc/uinput-fpc.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/uinput-fpc.idc \
    $(DEVICE_PATH)/configs/idc/uinput-goodix.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/uinput-goodix.idc \
    $(DEVICE_PATH)/configs/keylayout/uinput-fpc.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/uinput-fpc.kl \
    $(DEVICE_PATH)/configs/keylayout/uinput_nav.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/uinput_nav.kl

# Init
PRODUCT_PACKAGES += \
    init.mmi.overlay.rc \
    init.oem.fingerprint.sh

# NFC (NXP SN220)
PRODUCT_PACKAGES += \
    android.hardware.nfc-service.nxp \
    com.android.nfc_extras \
    Tag

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.uicc.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml

# Overlays
PRODUCT_PACKAGES += \
    FrameworkOverlayVegas26 \
    NfcOverlayVegas26 \
    SystemUIOverlayVegas26

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

# Inherit from mt6835-common, with the common blobs extracted from vegas26 stock
MT6835_COMMON_VENDOR_PATH := vendor/motorola/mt6835-common-vegas26
# Ship APEXes uncompressed: decompressing 27 capex on the first boot kept apexd busy
# for 133 s and system_server hit the watchdog in ArtManagerLocal.onBoot.
# Costs about 212 MB on system (141 MB capex -> 353 MB apex); super has ~6 GB free.
PRODUCT_COMPRESSED_APEX := false

$(call inherit-product, device/motorola/mt6835-common/mt6835.mk)

# Inherit the proprietary files
$(call inherit-product, vendor/motorola/vegas26/vegas26-vendor.mk)
