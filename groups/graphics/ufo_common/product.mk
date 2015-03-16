#
# Hardware Accelerated Graphics
#
PRODUCT_PACKAGES += \
    libdrm \
    libdrm_intel \

#
# Color conversion library
#
PRODUCT_PACKAGES += \
    libI420colorconvert

ifneq ($(BOARD_HAVE_GEN_GFX_SRC),true)
    # UFO prebuilts
    PRODUCT_PACKAGES += ufo_prebuilts
    ifneq ($(TARGET_2ND_ARCH),)
        PRODUCT_PACKAGES += ufo_prebuilts_32
    endif

else # ufo packages when building from source
    PRODUCT_PACKAGES += ufo
    PRODUCT_PACKAGES += ufo_test
endif

PRODUCT_PROPERTY_OVERRIDES += ro.opengles.version = 196609

