
# Copyright 2022 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
PRODUCT_SOONG_NAMESPACES += device/uwings/ok6254c

# AVB
ifeq ($(TARGET_BUILD_VARIANT), user)
TARGET_AVB_ENABLE := true
endif

# Kernel part
LOCAL_KERNEL := device/uwings/ok6254c-kernel/kernel/5.10/Image
LOCAL_DTB := device/uwings/ok6254c-kernel/kernel/5.10

PRODUCT_COPY_FILES += \
        $(LOCAL_KERNEL):kernel

# Build and run only ART
PRODUCT_RUNTIMES := runtime_libart_default
# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)
# Enforce generic ramdisk allow list
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)
DEVICE_PACKAGE_OVERLAYS := device/uwings/ok6254c/overlay

# Set Vendor SPL to match platform
VENDOR_SECURITY_PATCH = $(PLATFORM_SECURITY_PATCH)
# Set boot SPL
BOOT_SECURITY_PATCH = $(PLATFORM_SECURITY_PATCH)

# Dynamic partitions
PRODUCT_BUILD_SUPER_PARTITION := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_USE_DYNAMIC_PARTITION_SIZE := true

# Set default log size to 1M
PRODUCT_PROPERTY_OVERRIDES += \
  ro.logd.size=1M

# Use 64-bit dex2oat for better dexopt time.
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat64.enabled=true

# Enable Incremental on the device
PRODUCT_PROPERTY_OVERRIDES += \
	ro.incremental.enable=true

# Enable zygote critical window.
PRODUCT_PROPERTY_OVERRIDES += \
	zygote.critical_window.minute=10

# Add wifi-related packages
PRODUCT_PACKAGES += libwpa_client wpa_supplicant hostapd wificond wpa_cli
PRODUCT_PROPERTY_OVERRIDES += wifi.interface=wlan0 \
                              wifi.supplicant_scan_interval=15

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml

PRODUCT_PACKAGES += \
	android.hardware.fastboot@1.1 \
	android.hardware.fastboot@1.1-impl-mock \
	fastbootd

# All VNDK libraries (HAL interfaces, VNDK, VNDK-SP, LL-NDK)
PRODUCT_PACKAGES += vndk_package

# Set lowram options and enable traced by default
PRODUCT_VENDOR_PROPERTIES += \
     ro.config.low_ram=true


# Speed profile services and wifi-service to reduce RAM and storage.
PRODUCT_SYSTEM_SERVER_COMPILER_FILTER := speed-profile

# A/B support
PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_engine_sideload \
    update_verifier \
    sg_write_buffer \
    f2fs_io \
    check_f2fs

# The following modules are included in debuggable builds only.
PRODUCT_PACKAGES_DEBUG += \
    bootctl \
    update_engine_client \
    SystemUpdaterSample

# Userdata Checkpointing OTA GC
PRODUCT_PACKAGES += \
	checkpoint_gc

# Boot control
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-impl.recovery \
    android.hardware.boot@1.2-service \
    bootctrl.default

ifeq ($(TARGET_AVB_ENABLE), true)
#copy xml file to tell PackageManager that the system supports Verified Boot
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.verified_boot.xml:system/etc/permissions/android.software.verified_boot.xml
endif # eq $(TARGET_AVB_ENABLE), true

PRODUCT_SHIPPING_API_LEVEL := 31
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false
# Enforce the Product interface
PRODUCT_PRODUCT_VNDK_VERSION := current

# Power HAL
PRODUCT_PACKAGES += android.hardware.power-service.example

# Health: Install default binderized implementation to vendor.
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-service \
    android.hardware.health@2.1-impl-cuttlefish

# Health Storage
PRODUCT_PACKAGES += \
    android.hardware.health.storage-service.cuttlefish

# Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.4-service

PRODUCT_PACKAGES += \
    hwcomposer.drm

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.gralloc=am62x \
    ro.hardware.hwcomposer=drm \
    ro.hardware.egl=powervr \
    ro.hardware.vulkan=powervr

PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196610

PRODUCT_PROPERTY_OVERRIDES += \
    vendor.hwc.drm.device=/dev/dri/card0

# Public Libraries
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/public.libraries.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt

# Vulkan
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
	frameworks/native/data/etc/android.software.vulkan.deqp.level-2021-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml \
	frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
	frameworks/native/data/etc/android.software.opengles.deqp.level-2021-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml

# Audio:
# NOTE: each product should also add audio.primary.$(TARGET_DEVICE) to its PRODUCT_PACKAGES
PRODUCT_PACKAGES += \
    audio.r_submix.default \
    android.hardware.audio.service \
    android.hardware.audio@6.0-impl \
    android.hardware.audio.effect@6.0-impl

PRODUCT_PACKAGES += audio.primary.ok6254c

# Audio USB HAL
PRODUCT_PACKAGES += \
    audio.usb.default

# audio policy configuration
USE_XML_AUDIO_POLICY_CONF := 1
PRODUCT_COPY_FILES += \
    device/uwings/ok6254c/audio_hal_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.ok6254c.xml \
    device/uwings/ok6254c/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/media/libeffects/data/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml

# Low level audio tools for debugging
PRODUCT_PACKAGES_DEBUG += \
    tinyplay \
    tinycap \
    tinymix \
    tinypcminfo \
    cplay

# USB HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.2-service.generic

PRODUCT_COPY_FILES += \
    hardware/uwings/ok6254c/usb/1.2/init.gadgethal.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.gadgethal.sh

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

# Security
PRODUCT_PACKAGES += \
        android.hardware.drm@1.4-service.clearkey \
        android.hardware.gatekeeper@1.0-service.software \
        android.hardware.keymaster@3.0-impl \
        android.hardware.keymaster@3.0-service

# Copy hardware config file(s)
PRODUCT_COPY_FILES += \
        device/linaro/hikey/etc/permissions/android.hardware.screen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.xml \
        device/linaro/hikey/etc/permissions/android.software.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.xml \
        frameworks/native/data/etc/android.software.cts.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.cts.xml \
        frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
        frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
        frameworks/native/data/etc/android.software.voice_recognizers.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.voice_recognizers.xml \
        frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
        frameworks/native/data/etc/android.software.device_admin.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_admin.xml

PRODUCT_COPY_FILES += \
        device/uwings/ok6254c/init.ok6254c.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.ok6254c.rc \
        device/uwings/ok6254c/init.ok6254c.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.ok6254c.usb.rc \
        device/uwings/ok6254c/ueventd.ok6254c.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc

# fstab
ifeq ($(TARGET_AVB_ENABLE), true)
PRODUCT_COPY_FILES += \
    device/uwings/ok6254c/fstab.ok6254c.avb:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.ok6254c \
    device/uwings/ok6254c/fstab.ok6254c.avb:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.ok6254c
else
PRODUCT_COPY_FILES += \
    device/uwings/ok6254c/fstab.ok6254c:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.ok6254c \
    device/uwings/ok6254c/fstab.ok6254c:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.ok6254c
endif

# RecoveryOS
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.recovery.ok6254c.rc:recovery/root/vendor/etc/init/init.recovery.ok6254c.rc

# Media
PRODUCT_COPY_FILES += \
        device/uwings/ok6254c/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
        frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
        frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml

# Media configuration
PRODUCT_COPY_FILES += \
        device/uwings/ok6254c/ok6254c.media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml

# Enable USB Camera
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-impl
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-external-service
PRODUCT_COPY_FILES += \
    device/uwings/ok6254c/camera/external_camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/external_camera_config.xml

PRODUCT_COPY_FILES +=  \
    frameworks/native/data/etc/android.hardware.camera.concurrent.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.concurrent.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml
PRODUCT_PACKAGES += \
        Launcher3QuickStep \
        WallpaperPicker

# Wifi configuration files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifi/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf \
    $(LOCAL_PATH)/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
    $(LOCAL_PATH)/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf

# Include hardware projects (HALs)
$(call inherit-product-if-exists, hardware/uwings/ok6254c/ok6254c.mk)

# Include vendor binaries
$(call inherit-product-if-exists, vendor/uwings/ok6254c/ok6254c.mk)
