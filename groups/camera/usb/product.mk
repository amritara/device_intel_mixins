ifeq ($(TARGET_BOARD_PLATFORM),)
    $(error Please define TARGET_BOARD_PLATFORM in product-level Makefile)
endif

# Camera HAL (camera3hal).
PRODUCT_PACKAGES += camera.$(TARGET_BOARD_PLATFORM)


# Only include test apps in eng builds.
PRODUCT_PACKAGES_ENG += \
    TestingCamera \
    TestingCamera2
