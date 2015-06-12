# FIXME: Modules are copied twice in the system
# - as a flat directory where all modules are. This is the method that android's insmod is expecting modules to be
# - as a tree of modules as output by the kernel build system. This is the way hald's libkmod is expecting modules to be
# on binary kernel directories/artifactory tarballs, flat directory is stored in $(ARCH)/modules, while tree directory is stored in $(ARCH)/lib/modules
# both directories contain same data

LOCAL_KERNEL_MODULE_FILES :=
ifeq ($(TARGET_PREBUILT_KERNEL),)
  # use default kernel
  LOCAL_KERNEL_PATH := {{{path}}}/$(TARGET_KERNEL_ARCH)
  LOCAL_KERNEL := $(LOCAL_KERNEL_PATH)/{{{binary_name}}}
  LOCAL_KERNEL_MODULE_TREE_PATH := $(LOCAL_KERNEL_PATH)/lib/modules
  BINARIESYAML := {{{path}}}/binaries.yml
else
  # use custom kernel. Development mode, developer should invoque make with:
  # make dist TARGET_PREBUILT_KERNEL=.. TARGET_PREBUILT_KERNEL_MODULE_PATH=.. TARGET_PREBUILT_KERNEL_MODULE_TREE_PATH=..
  LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
  ifneq ($(TARGET_PREBUILT_KERNEL_MODULE_PATH),)
    LOCAL_KERNEL_MODULE_FILES := $(wildcard $(TARGET_PREBUILT_KERNEL_MODULE_PATH)/*)
  endif
  ifneq ($(TARGET_PREBUILT_KERNEL_MODULE_TREE_PATH),)
    LOCAL_KERNEL_MODULE_TREE_PATH := $(TARGET_PREBUILT_KERNEL_MODULE_TREE_PATH)
  endif
endif

ifneq ($(LOCAL_KERNEL_MODULE_TREE_PATH),)
  # for binarydownloader kernels the version is specified in its own file, as the vmlinux may not be present
  # at Makefile parsing time
  ifneq (,$(wildcard $(LOCAL_KERNEL_PATH)_version))
    LOCAL_KERNEL_VERSION := $(shell cat $(LOCAL_KERNEL_PATH)_version)
  else
    LOCAL_KERNEL_VERSION := $(shell strings $(LOCAL_KERNEL_PATH)/vmlinux | grep -m 1 'Linux version' | awk '{print $$3}')
    ifeq ($(LOCAL_KERNEL_VERSION),)
      $(error Cannot get version for kernel '$(LOCAL_KERNEL)')
    endif
  endif

  FULL_TREE_PATH := $(LOCAL_KERNEL_MODULE_TREE_PATH)/$(LOCAL_KERNEL_VERSION)

  ifneq (,$(wildcard $(LOCAL_KERNEL_PATH)_treemodulefiles))
  		# for binarydownloader module list is specified in its own file, as they may not be present
  		# at makefile parsing time, we need to prepend the full path
        LOCAL_KERNEL_MODULE_TREE_FILES := $(shell cat $(LOCAL_KERNEL_PATH)_treemodulefiles)
        LOCAL_KERNEL_MODULE_TREE_FILES_FULLPATH := $(foreach f, $(LOCAL_KERNEL_MODULE_TREE_FILES), $(LOCAL_KERNEL_MODULE_TREE_PATH)/$(f))

  else
      # legacy version where modules are checked in git
      # Verify FULL_TREE_PATH is an existing folder
      ifneq ($(shell test -d $(FULL_TREE_PATH) && echo 1), 1)
        $(error '$(FULL_TREE_PATH)' does not exist or is not a directory)
      endif
      LOCAL_KERNEL_MODULE_TREE_FILES := $(shell cd $(LOCAL_KERNEL_MODULE_TREE_PATH) && \
                                                    find $(LOCAL_KERNEL_VERSION) -type f)
  endif
  ifneq (,$(wildcard $(LOCAL_KERNEL_PATH)_flatmodulefiles))
        LOCAL_KERNEL_MODULE_FILES :=  $(foreach f, $(shell cat $(LOCAL_KERNEL_PATH)_flatmodulefiles), $(LOCAL_KERNEL_PATH)/modules/$(f))

  else
      # legacy version where modules are checked in git
      LOCAL_KERNEL_MODULE_FILES := $(wildcard $(LOCAL_KERNEL_PATH)/modules/*)
  endif
endif

ifneq ($(BINARIESYAML),)
  ifeq ($(shell test -f $(BINARIESYAML) && echo 1), 1)
	# create targets to download the kernel binaries into the source tree

{{path}}/$(TARGET_KERNEL_ARCH): $(BINARIESYAML)
	@device/intel/binarydownloader/binarydownloader {{path}}

    # make all the kernel files depend on {{path}}/.downloaded
$(LOCAL_KERNEL) $(LOCAL_KERNEL_MODULE_FILES) $(LOCAL_KERNEL_MODULE_TREE_FILES_FULLPATH): {{path}}/$(TARGET_KERNEL_ARCH)

  endif
endif

# Copy kernel into place

PRODUCT_COPY_FILES += \
	$(LOCAL_KERNEL):kernel \
	$(foreach f, $(LOCAL_KERNEL_MODULE_FILES), $(f):system/lib/modules/$(notdir $(f))) \
  $(foreach f, $(LOCAL_KERNEL_MODULE_TREE_FILES), $(LOCAL_KERNEL_PATH)/lib/modules/$(f):system/lib/modules/$(f))
