#
# Copyright (C) The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

COMMON_PATH := device/motorola/mt6835-common

# Enforce generic ramdisk allow list
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Project ID Quota
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Device uses high-density artwork where available
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# DebugFS
PRODUCT_SET_DEBUGFS_RESTRICTIONS := true

# A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)
# Stock runs compressed Virtual A/B with userspace snapshots.
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/android_t_baseline.mk)
PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

# Audio
$(call soong_config_set,android_hardware_audio,run_64bit,true)
TARGET_EXCLUDES_AUDIOFX := true

PRODUCT_PACKAGES += \
    android.hardware.audio.service \
    android.hardware.audio@7.0-impl \
    android.hardware.audio.effect@7.0-impl \

PRODUCT_PACKAGES += \
    android.hardware.bluetooth.audio-impl \

PRODUCT_PACKAGES += \
    android.hardware.soundtrigger@2.3-impl

PRODUCT_PACKAGES += \
    android.hardware.audio.common-util

PRODUCT_PACKAGES += \
    audio.bluetooth.default \
    audio.usbv2.default \
    audio_policy.stub \
    libopus.vendor \
    audioclient-types-aidl-cpp.vendor

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(COMMON_PATH)/configs/audio/,$(TARGET_COPY_OUT_VENDOR)/etc) \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml

# Bootcontrol
PRODUCT_PACKAGES += \
    com.android.hardware.boot \
    android.hardware.boot-service.default_recovery

# Init
PRODUCT_PACKAGES += \
    fstab.mt6835 \
    init_connectivity.rc \
    init.connectivity.common.rc \
    init.mmi.rc \
    init.recovery.mt6835.rc \
    init.mt6835.usb.rc \
    init.mt6835.power.rc \
    init.mt6835.rc \
    init.mtkgki.rc \
    init.oem.hw.sh \
    init.project.rc \
    init.sensor_2_0.rc \
    ueventd.mt6835.rc

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/init/fstab.mt6835:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt6835

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth-service.mediatek

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml

# Camera
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml

# Chipinfo
PRODUCT_PACKAGES += \
    chipinfo

# Cgroup and task_profiles
PRODUCT_COPY_FILES += \
    system/core/libprocessgroup/profiles/cgroups.json:$(TARGET_COPY_OUT_VENDOR)/etc/cgroups.json \
    system/core/libprocessgroup/profiles/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json

# Dalvik
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=24m \
    dalvik.vm.heapgrowthlimit=256m \
    dalvik.vm.heapsize=512m \
    dalvik.vm.heaptargetutilization=0.46 \
    dalvik.vm.heapminfree=8m \
    dalvik.vm.heapmaxfree=48m

# Dex-pre-opt exclusions
$(call add-product-dex-preopt-module-config,MotoSignatureApp,disable)

# Display
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    sys.brightness.disable_gamma_conversion=true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2023-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2023-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml

# DRM (Clearkey)
PRODUCT_PACKAGES += \
    com.android.hardware.drm.clearkey

# FastbootD
PRODUCT_PACKAGES += \
    android.hardware.fastboot-service.example_recovery \
    fastbootd

# Fingerprint
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml

# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0.vendor \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service

# GNSS
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml

# Graphics
# The MediaTek picture quality AIDL library links graphics.common V3, while
# LineageOS vendor libraries (libui, libgralloctypes, Codec2) link V7. Both
# coexist at runtime, but Soong rejects modules that depend on both, so that
# blob is extracted without generated dependencies and V3 is installed here.
PRODUCT_PACKAGES += \
    android.hardware.graphics.common-V3-ndk.vendor \
    android.hardware.graphics.composer@2.3-service \
    android.hardware.memtrack-service.mediatek

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.example \
    android.hardware.health-service.example_recovery

# Keymint
PRODUCT_PACKAGES += \
    libkeymint.vendor \
    libpuresoftkeymasterdevice.vendor

# Keystore
PRODUCT_PACKAGES += \
    android.hardware.hardware_keystore.xml \
    android.system.wifi.keystore@1.0.vendor \
    libkeystore-wifi-hidl \
    libkeystore-engine-wifi-hidl

# Light
PRODUCT_PACKAGES += \
    android.hardware.lights-service.mt6835

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Media
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(COMMON_PATH)/configs/media,$(TARGET_COPY_OUT_VENDOR)/etc)

# MM
PRODUCT_PACKAGES += \
    init.zram.rc

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/fstab.zram:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.zram

# Overlays
$(call inherit-product, hardware/mediatek/overlay/mssi.mk)

PRODUCT_ENFORCE_RRO_TARGETS := *

PRODUCT_PACKAGES += \
    FrameworkOverlayMT6835 \
    SettingsOverlayMT6835 \
    SystemUIOverlayMT6835 \
    Launcher3DeviceOverlay \
    NfcOverlayMT6835

PRODUCT_PACKAGES += \
    NcmTetheringOverlayMT6835

# Platform
TARGET_BOARD_PLATFORM := mt6835

# Power
PRODUCT_PACKAGES += \
    android.hardware.power-service.pixel-libperfmgr \
    vendor.mediatek.hardware.mtkpower@1.2-service.stub

PRODUCT_PACKAGES += \
    libmtkperf_client_vendor

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

# Properties
include hardware/mediatek/configs/properties/vendor_logtag.mk

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# Radio
$(call inherit-product, hardware/mediatek/frameworks/mediatek-frameworks.mk)

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnel_migration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnel_migration.xml \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.hardware.telephony.euicc.xml \
    $(COMMON_PATH)/configs/permissions/privapp-permissions-com.mediatek.ims.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-com.mediatek.ims.xml \
    $(COMMON_PATH)/configs/permissions/privapp-permissions-com.mediatek.telephony.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-com.mediatek.telephony.xml \
    $(COMMON_PATH)/configs/permissions/mediatek-ims-base.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/mediatek-ims-base.xml \
    $(COMMON_PATH)/configs/permissions/mediatek-ims-oem-plugin.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/mediatek-ims-oem-plugin.xml \
    $(COMMON_PATH)/configs/permissions/mediatek-ims-common.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/mediatek-ims-common.xml \
    $(COMMON_PATH)/configs/permissions/mediatek-telecom-common.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/mediatek-telecom-common.xml \
    $(COMMON_PATH)/configs/permissions/mediatek-telephony-base.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/mediatek-telephony-base.xml \
    $(COMMON_PATH)/configs/permissions/mediatek-telephony-common.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/mediatek-telephony-common.xml \
    $(COMMON_PATH)/configs/permissions/com.mediatek.ims.config.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/com.mediatek.ims.config.xml

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors-service.multihal \
    android.hardware.sensors@2.0-subhal-impl-1.0 \
    sensors.mt6835

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.dynamic.head_tracker.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.dynamic.head_tracker.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.sensor.dynamic.head_tracker.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.dynamic.head_tracker.xml

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 35
# hardware/mediatek overlay/mssi.mk (lineage-24.0) reads this during product config,
# before BoardConfigCommon.mk sets it.
BOARD_SHIPPING_API_LEVEL := 33

# HIDL
# The vendor partition (board API level 33) still serves many HALs over HIDL,
# including the gralloc allocator, the composer and GNSS. With a shipping API
# level above 34 the build no longer installs hwservicemanager and the HIDL
# memory services on its own, so they have to be requested explicitly.
PRODUCT_PACKAGES += \
    hwservicemanager \
    android.hidl.allocator@1.0-service \
    android.hidl.memory@1.0-impl \
    android.hidl.memory@1.0-impl.vendor

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(COMMON_PATH) \
    hardware/google/pixel \
    hardware/google/pixel/power-libperfmgr \
    hardware/google/pixel/pixelstats \
    hardware/google/interfaces \
    hardware/motorola \
    hardware/mediatek/libmtkperf_client \
    hardware/mediatek

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal-service.mediatek \
    pixelatoms-cpp

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/thermal_info_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json

# Touch

# USB
$(call soong_config_set_bool,mediatek_gadget,use_custom_usb_gadget_rc,true)
PRODUCT_PACKAGES += \
    android.hardware.usb-service.mediatek \
    android.hardware.usb.gadget-service.mediatek

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

# Vibrator
$(call soong_config_set_bool,mediatek_vibrator,supports_effects,true)
PRODUCT_PACKAGES += \
    android.hardware.vibrator-service.mediatek

# WiFi
$(call soong_config_set_bool,mediatek_wifi_hal,use_pre_u_qpr2_struct,true)

PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    hostapd\
    wpa_supplicant \
    libwifi-hal-wrapper \
    wlan_assistant

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(COMMON_PATH)/configs/wifi/,$(TARGET_COPY_OUT_VENDOR)/etc/wifi) \
   frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml

# Inherit the proprietary files
# Devices whose stock firmware line differs from the one the shared blobs were
# taken from point this at their own extraction of proprietary-files.txt.
MT6835_COMMON_VENDOR_PATH ?= vendor/motorola/mt6835-common
$(call inherit-product, $(MT6835_COMMON_VENDOR_PATH)/mt6835-common-vendor.mk)

# GPS: MediaTek LPPe/AGPS framework service privileged permissions
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/permissions/privapp-permissions-lppe.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-lppe.xml

# Audio: stock declares the low-latency feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml
