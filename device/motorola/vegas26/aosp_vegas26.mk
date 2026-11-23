#
# SPDX-FileCopyrightText: The Android Open Source Project
# SPDX-License-Identifier: Apache-2.0
#
# Plain AOSP product for the moto g power - 2026 (vegas26), laid out like the AOSP Pixel products.

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_product.mk)

# Not generic_system.mk: the device adds files and its framework compatibility matrix to /system.
$(call inherit-product, device/motorola/vegas26/device.mk)

PRODUCT_NAME := aosp_vegas26
PRODUCT_DEVICE := vegas26
PRODUCT_MANUFACTURER := motorola
PRODUCT_BRAND := motorola
PRODUCT_MODEL := moto g power - 2026
