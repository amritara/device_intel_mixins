#include frameworks/native/build/phone-xhdpi-1024-dalvik-heap.mk
PRODUCT_PROPERTY_OVERRIDES += \
	dalvik.vm.heapstartsize=8m \
	dalvik.vm.heapgrowthlimit=128m \
	dalvik.vm.heapsize=174m \
	dalvik.vm.heaptargetutilization=0.75 \
	dalvik.vm.heapminfree=512k \
	dalvik.vm.heapmaxfree=2m
