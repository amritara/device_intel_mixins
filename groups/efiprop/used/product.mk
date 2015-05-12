ifeq ($(TARGET_BUILD_VARIANT),user)
# For security concerns, the software scalability based on EFI
# variable is disabled on USER build.  Device MUST statically choose
# its configuration.
else
PRODUCT_PACKAGES += \
        efiprop
endif
