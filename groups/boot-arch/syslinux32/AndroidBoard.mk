SYSLINUX_BIN := $(HOST_OUT_EXECUTABLES)/syslinux
SYSLINUX_BASE := $(HOST_OUT)/usr/lib/syslinux

SYSLINUX_MK_IMG := external/syslinux/utils/android-image.sh

# TARGET_SYSLINUX_FILES - any splash screens, com32 modules
# TARGET_SYSLINUX_CONFIG - file to use as syslinux.cfg
# These should be defined in BoardConfig.mk per-product

ifdef TARGET_SYSLINUX_IMAGE_EXTRA_SPACE
        SYSLINUX_EXTRA_SPACE_PARAM := --extra-size $(TARGET_SYSLINUX_IMAGE_EXTRA_SPACE)
endif

# (pulled from build/core/Makefile as this gets defined much later)
# Pick a reasonable string to use to identify files.
ifneq "" "$(filter eng.%,$(BUILD_NUMBER))"
# BUILD_NUMBER has a timestamp in it, which means that
# it will change every time.  Pick a stable value.
FILE_NAME_TAG := eng.$(USER)
else
FILE_NAME_TAG := $(BUILD_NUMBER)
endif

intermediates := $(call intermediates-dir-for,PACKAGING,bootloader_zip)
bootloader_zip := $(intermediates)/bootloader.zip
$(bootloader_zip): intermediates := $(intermediates)
$(bootloader_zip): syslinux_root := $(intermediates)/root
$(bootloader_zip): \
		$(TARGET_DEVICE_DIR)/AndroidBoard.mk \
		$(TARGET_SYSLINUX_FILES) \
		$(TARGET_SYSLINUX_CONFIG) \
		| $(ACP) \

	$(hide) rm -rf $(syslinux_root)
	$(hide) rm -f $@
	$(hide) mkdir -p $(syslinux_root)
	$(hide) $(ACP) $(TARGET_SYSLINUX_FILES) $(syslinux_root)/
	$(hide) $(ACP) $(TARGET_SYSLINUX_CONFIG) $(syslinux_root)/syslinux.cfg
	$(hide) (cd $(syslinux_root) && zip -qry ../$(notdir $@) .)

bootloader_metadata := $(intermediates)/bootloader-size.txt
$(bootloader_metadata):
	$(hide) mkdir -p $(dir $@)
	$(hide) echo $(BOARD_BOOTLOADER_PARTITION_SIZE) > $@

INSTALLED_RADIOIMAGE_TARGET += $(BOARD_GPT_INI) $(BOARD_MBR_BLOCK_BIN) $(bootloader_zip) $(bootloader_metadata)

bootloader_bin := $(PRODUCT_OUT)/bootloader
$(bootloader_bin): \
		$(TARGET_SYSLINUX_FILES) \
		$(TARGET_SYSLINUX_CONFIG) \
		$(SYSLINUX_BIN) \
		$(SYSLINUX_MK_IMG) \

	$(call pretty, "Target SYSLINUX image: $@")
	$(SYSLINUX_MK_IMG) $(SYSLINUX_EXTRA_SPACE_PARAM) \
		--syslinux $(SYSLINUX_BIN) \
	        --tmpdir $(call intermediates-dir-for,EXECUTABLES,syslinux-img)/syslinux-img \
		--config $(TARGET_SYSLINUX_CONFIG) \
		--output $@ \
		$(TARGET_SYSLINUX_FILES)

droidcore: $(bootloader_bin)

.PHONY: bootloader
bootloader: $(bootloader_bin)

$(call dist-for-goals,droidcore,$(bootloader_bin):$(TARGET_PRODUCT)-bootloader-$(FILE_NAME_TAG))


fastboot_usb_root := $(PRODUCT_OUT)/fastboot-usb
fastboot_usb_bin := $(PRODUCT_OUT)/fastboot-usb.img
fastboot_bin := $(PRODUCT_OUT)/fastboot.img
$(fastboot_usb_bin): \
		$(INSTALLED_KERNEL_TARGET) \
		$(PRODUCT_OUT)/userfastboot/ramdisk-fastboot.img.gz \
		$(TARGET_SYSLINUX_FILES) \
		$(TARGET_SYSLINUX_USB_CONFIG) \
		$(HOST_OUT_EXECUTABLES)/isohybrid \
		| $(ACP) \

	$(hide) rm -rf $(fastboot_usb_root)
	$(hide) mkdir -p $(fastboot_usb_root)
	$(hide) $(ACP) -f $(PRODUCT_OUT)/userfastboot/ramdisk-fastboot.img.gz $(fastboot_usb_root)/ramdisk.img
	$(hide) $(ACP) -f $(INSTALLED_KERNEL_TARGET) $(fastboot_usb_root)/kernel
	$(hide) mkdir -p $(fastboot_usb_root)/isolinux
	$(hide) $(ACP) -f $(TARGET_SYSLINUX_FILES) $(fastboot_usb_root)/isolinux
	$(hide) $(ACP) -f $(TARGET_SYSLINUX_USB_CONFIG) $(fastboot_usb_root)/isolinux/isolinux.cfg
	$(hide) genisoimage -vJURT -b isolinux/isolinux.bin -c isolinux/boot.cat \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		-input-charset utf-8 -V "Fastboot USB" \
		-o $@ $(fastboot_usb_root)
	$(hide) $(HOST_OUT_EXECUTABLES)/isohybrid $@

droidcore: $(fastboot_bin) $(fastboot_usb_bin)

.PHONY: userfastboot-usb
userfastboot-usb: $(fastboot_usb_bin)

$(call dist-for-goals,droidcore,$(fastboot_usb_bin):$(TARGET_PRODUCT)-fastboot-usb-$(FILE_NAME_TAG).img)

INSTALLED_RADIOIMAGE_TARGET += $(PRODUCT_OUT)/fastboot.img

