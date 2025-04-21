export PACKAGE_VERSION := 1.2

ARCHS := arm64 arm64e
TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES := SpringBoard

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += UISBWAPrefs

include $(THEOS_MAKE_PATH)/aggregate.mk

TWEAK_NAME := UIStatusBarWidthAdjust

UIStatusBarWidthAdjust_USE_MODULES := 0

UIStatusBarWidthAdjust_FILES += UIStatusBarWidthAdjust.xm
UIStatusBarWidthAdjust_FILES += UISBWAPrefs/UISBWAUserDefaults.mm

UIStatusBarWidthAdjust_CFLAGS += -fobjc-arc
UIStatusBarWidthAdjust_CFLAGS += -I.
UIStatusBarWidthAdjust_CFLAGS += -IUISBWAPrefs
UIStatusBarWidthAdjust_CFLAGS += -DPACKAGE_VERSION=\"$(PACKAGE_VERSION)\"

UIStatusBarWidthAdjust_CCFLAGS += -Wno-unused-variable
UIStatusBarWidthAdjust_CCFLAGS += -Wno-unused-function

UIStatusBarWidthAdjust_FRAMEWORKS += CoreGraphics
UIStatusBarWidthAdjust_FRAMEWORKS += UIKit

include $(THEOS_MAKE_PATH)/tweak.mk