#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)

from extract_utils.fixups_lib import (
    lib_fixup_remove,
    lib_fixups,
    lib_fixups_user_type,
)

from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/motorola/mt6835-common',
    'hardware/mediatek',
    'hardware/mediatek/libmtkperf_client',
    'hardware/motorola',
]

def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
        'libneuron_graph_delegate.mtk',
        'libtflite_mtk',
        'vendor.mediatek.hardware.apuware.utils@2.0',
        'vendor.mediatek.hardware.videotelephony@1.0',
    ): lib_fixup_vendor_suffix,
}

blob_fixups: blob_fixups_user_type = {
    # Android 17 has its own libformatter; the stock one is renamed.
    (
        'vendor/lib64/libcodec2_mtk_vdec.so',
        'vendor/lib64/libcodec2_mtk_venc.so',
    ): blob_fixup()
        .replace_needed('libformatter.so', 'libformatter-v33.so'),
    'system_ext/priv-app/ImsService/ImsService.apk': blob_fixup()
        .apktool_patch('patches/ImsService'),
    'system_ext/priv-app/MtkGbaService/MtkGbaService.apk': blob_fixup()
        .apktool_patch('patches/GbaService'),
    (
        'system_ext/etc/init/init.vtservice.rc',
        'vendor/etc/init/android.hardware.neuralnetworks-shim-service-mtk.rc'
    ): blob_fixup()
        .regex_replace('start', 'enable'),
    'system_ext/lib64/libsource.so': blob_fixup()
        .add_needed('libui_shim.so'),
    # IRemotelyProvisionedComponent moved from the KeyMint library into
    # android.hardware.security.rkp; stock KeyMint 2.0 pairs with its version 2.
    'vendor/bin/hw/android.hardware.security.keymint@2.0-service.trustonic': blob_fixup()
        .add_needed('android.hardware.security.rkp-V2-ndk.so'),
    'vendor/bin/hw/android.hardware.media.c2@1.2-mediatek-64b': blob_fixup()
        .add_needed('libstagefright_foundation-v33.so'),
    (
        'vendor/bin/mnld',
        'vendor/lib64/hw/android.hardware.sensors@2.X-subhal-mediatek.so',
    ): blob_fixup()
        .add_needed('android.hardware.sensors@1.0-convert-shared.so')
        .replace_needed('libmnl.so', 'libmnl-v33.so'),
    'vendor/lib64/hw/mt6835/vendor.mediatek.hardware.pq_aidl-impl.so': blob_fixup()
        .add_needed('android.hardware.sensors@1.0-convert-shared.so')
        .replace_needed('libutils.so', 'libutils-v32.so'),
    'vendor/lib64/hw/audio.primary.mediatek.so': blob_fixup()
        .add_needed('libstagefright_foundation-v33.so')
        .replace_needed('libutils.so','libutils-v32.so')
        .replace_needed('libalsautils.so','libalsautils-v31.so'),
    'vendor/lib64/sensors.moto.so': blob_fixup()
        .replace_needed('libutils.so', 'libutils-v32.so')
        .add_needed('libbase_shim.so'),
    # TracFone builds publish their model and software version through
    # platform build properties, which vendor init may not set.
    'vendor/etc/init/vendor.mmi.carrier.rc': blob_fixup()
        .regex_replace(r'on (fs|property:ro\.build\.display\.id=\*) && property:ro\.boot\.carrier=tracfone\n    setprop ro\.build\.\w+ \$\{[\w.]+\}\n\n', ''),
    'vendor/lib64/mt6835/libmnl-v33.so': blob_fixup()
        .add_needed('libcutils.so'),
    'vendor/lib64/hw/hwcomposer.mtk_common.so': blob_fixup()
        .add_needed('libprocessgroup_shim.so'),
    (
        'vendor/lib64/mt6835/libneuralnetworks_sl_driver_mtk_prebuilt.so',
        'vendor/lib64/libstfactory-vendor.so',
        'vendor/lib64/libnvram.so',
        'vendor/lib64/libsysenv.so',
        'vendor/lib64/libtflite_mtk.so'
    ): blob_fixup()
        .add_needed('libbase_shim.so'),
    'system_ext/lib64/libimsma.so': blob_fixup()
        .replace_needed('libsink.so', 'libsink-mtk.so'),
    'vendor/bin/hw/mtkfusionrild': blob_fixup()
        .add_needed('libutils-v32.so'),
    (
        'vendor/lib64/librt_extamp_intf.so',
        'vendor/lib64/hw/audio.primary.mediatek.so',
        'vendor/lib64/hw/mt6835/vendor.mediatek.hardware.pq_aidl-impl.so',
        'vendor/lib64/libpqxmlparser.so',
    ): blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-legacy.so'),
}  # fmt: skip

module = ExtractUtilsModule(
    'mt6835-common',
    'motorola',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
