# The make targets for both projects are identical
# (e.g. camera.gmin.so), so the Android.mk's wrap themselves in tests
# for these.  Set only one.  And we'll just ignore the inconsistent _.
USE_CAMERA_HAL2 := false
USE_CAMERA_HAL_3 := true

# camera3hal won't build if this isn't true
USE_SHARED_IA_FACE = true

# Intel camera extras (HDR, face detection, panorama, red-eye detection etc.).
USE_INTEL_CAMERA_EXTRAS := false

# Selects which subdirectory to pick in libmfldadvci/ia_imaging/ia_panorama/
IA_PANORAMA_VERSION := 1.0

USE_INTEL_JPEG := false
ifeq ($(UFO_ENABLE_GEN), gen8)
ifeq ($(USE_MEDIASDK), true)
# CHT/GEN8 has hardware JPEG encoder via Media SDK.
USE_INTEL_JPEG := true
endif
endif

# Must be "false" (NOT simply unset!) or else lots of camera
# depencencies will remove themselves from the build...
USE_CAMERA_STUB := false

# USB Camera Support
BOARD_CAMERA_USB_SUPPORT := true
BOARD_CAMERA_USB_STANDALONE := true
