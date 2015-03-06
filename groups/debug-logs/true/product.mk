{{#eng_only}}
ifeq ($(TARGET_BUILD_VARIANT),userdebug)
ifeq ($(BUILD_FOR_CTS_AUTOMATION),true)
MIXIN_DEBUG_LOGS := true
endif
endif
ifeq ($(TARGET_BUILD_VARIANT),eng)
MIXIN_DEBUG_LOGS := true
endif
{{/eng_only}}
{{^eng_only}}
ifneq ($(TARGET_BUILD_VARIANT),user)
MIXIN_DEBUG_LOGS := true
endif
{{/eng_only}}

ifeq ($(MIXIN_DEBUG_LOGS),true)
PRODUCT_COPY_FILES += device/intel/common/debug/init.logs.rc:root/init.logs.rc
PRODUCT_PACKAGES += \
    logcatext \
    start_log_srv.sh \
    logcat_ep.sh
endif
