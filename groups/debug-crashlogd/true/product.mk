ifeq ($(MIXIN_DEBUG_LOGS),true)
PRODUCT_COPY_FILES += \
	device/intel/common/debug/init.crashlogd.rc:root/init.crashlogd.rc \
	$(call add-to-product-copy-files-if-exists,$(LOCAL_PATH)/../ingredients.conf:system/etc/ingredients.conf)
PRODUCT_PACKAGES += crashlogd \
	dumpstate_dropbox.sh
endif
