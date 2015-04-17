ifeq ($(TARGET_BOARD_PLATFORM),)
    $(error Please define TARGET_BOARD_PLATFORM in product-level Makefile)
endif

# Camera HAL (camera3hal).
PRODUCT_PACKAGES += camera.$(TARGET_BOARD_PLATFORM)

# 3A/AIQ and camera tuning files.
PRODUCT_PACKAGES += \
    libmfldadvci \
    dummy.aiqb

{{#enable_acc}}
# Acc service and client
PRODUCT_PACKAGES += \
    libacc_service \
    libacc_client

# Camera ISP Firmware
PRODUCT_PACKAGES += \
    hdr_v2_fw_css21_2401 \
    ull_v15_fw_css21_2401

{{/enable_acc}}
# Only include test apps in eng builds.
PRODUCT_PACKAGES_ENG += \
    TestingCamera \
    TestingCamera2
