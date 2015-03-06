ifeq ($(MIXIN_DEBUG_LOGS),true)
ADDITIONAL_DEFAULT_PROPERTIES += persist.core.enabled=1
CRASHLOGD_COREDUMP := true
endif
