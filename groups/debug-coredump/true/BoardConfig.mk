ifeq ($(MIXIN_DEBUG_LOGS),true)
# Enable core dump for eng builds
ifeq ($(TARGET_BUILD_VARIANT),eng)
ADDITIONAL_DEFAULT_PROPERTIES += persist.core.enabled=1
else
ADDITIONAL_DEFAULT_PROPERTIES += persist.core.enabled=0
endif
CRASHLOGD_COREDUMP := true
endif
