ifeq ($(MIXIN_DEBUG_LOGS),true)
BOARD_SEPOLICY_DIRS += device/intel/common/sepolicy/crashlogd

BOARD_SEPOLICY_UNION += \
	crashlogd.te \
	dumpstate_dropbox.te \
	system_server.te \
	file_contexts

CRASHLOGD_LOGS_PATH := "/data/logs"
CRASHLOGD_APLOG := true
CRASHLOGD_FULL_REPORT := true
CRASHLOGD_MODULE_MODEM ?= true
CRASHLOGD_MODULE_BTDUMP := true
CRASHLOGD_USE_SD := false
endif
