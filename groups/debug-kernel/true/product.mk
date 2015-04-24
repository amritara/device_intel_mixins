ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_COPY_FILES += device/intel/common/debug/init.kernel.rc:root/init.kernel.rc
endif
