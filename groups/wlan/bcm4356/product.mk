PRODUCT_COPY_FILES += \
    device/intel/common/wlan/wpa_supplicant-common.conf:system/etc/wifi/wpa_supplicant.conf \
    device/intel/common/wlan/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml

PRODUCT_PACKAGES += wpa_supplicant \
    fw_bcmdhd_4356a2_pcie.bin \
    nvram_pcie_4356_a2.cal

