ifeq ($(MIXIN_DEBUG_LOGS),true)
PRODUCT_COPY_FILES += device/intel/common/debug/init.coredump.rc:root/init.coredump.rc
endif
