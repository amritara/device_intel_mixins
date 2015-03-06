ifeq ($(MIXIN_DEBUG_LOGS),true)
ADDITIONAL_DEFAULT_PROPERTIES += persist.service.apklogfs.enable=1
BOARD_SEPOLICY_UNION += logsvc.te
endif
