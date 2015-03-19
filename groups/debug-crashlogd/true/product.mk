ifeq ($(MIXIN_DEBUG_LOGS),true)
PRODUCT_COPY_FILES += device/intel/common/debug/init.crashlogd.rc:root/init.crashlogd.rc
PRODUCT_PACKAGES += crashlogd \
	dumpstate_dropbox.sh
endif
