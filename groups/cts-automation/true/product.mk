# Build for automated CTS
ifeq ($(BUILD_FOR_CTS_AUTOMATION),true)
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += persist.sys.usb.config=mtp,adb
PRODUCT_COPY_FILES += device/intel/common/usb-gadget/adb_keys:root/adb_keys
endif
