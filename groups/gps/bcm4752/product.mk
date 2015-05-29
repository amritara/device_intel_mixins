PRODUCT_PACKAGES += \
    gps.conf \
    gps.xml \
    gps.cer \
    gps.$(TARGET_BOARD_PLATFORM) \
    gpsd \

PRODUCT_PROPERTY_OVERRIDES += \
        ro.spid.gps.FrqPlan={{{FrqPlan}}}\
        ro.spid.gps.RfType={{{RfType}}}
        ro.spid.gps.pmm=disabled

PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \

