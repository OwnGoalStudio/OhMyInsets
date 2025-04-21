ARCHS := arm64 arm64e
TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES := Preferences

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME := UISBWAPrefs

UISBWAPrefs_FILES += $(wildcard *.mm)
UISBWAPrefs_FILES += $(wildcard *.swift)

UISBWAPrefs_CFLAGS += -fobjc-arc
UISBWAPrefs_CFLAGS += -DPACKAGE_VERSION=\"$(PACKAGE_VERSION)\"
UISBWAPrefs_CFLAGS += -Iinclude

# swift-create-xcframework --no-debug-symbols --static-library --platform ios --xc-setting ARCHS="arm64 arm64e" --clean SwiftUIIntrospect

UISBWAPrefs_LDFLAGS += -FLibrary
UISBWAPrefs_LDFLAGS += -FLibrary/SwiftUIIntrospect.xcframework/ios-arm64_arm64e -framework SwiftUIIntrospect
UISBWAPrefs_SWIFTFLAGS += -FLibrary/SwiftUIIntrospect.xcframework/ios-arm64_arm64e -framework SwiftUIIntrospect

UISBWAPrefs_FRAMEWORKS += UIKit
UISBWAPrefs_PRIVATE_FRAMEWORKS += Preferences
UISBWAPrefs_PRIVATE_FRAMEWORKS += FrontBoardServices
UISBWAPrefs_PRIVATE_FRAMEWORKS += SpringBoardServices

UISBWAPrefs_SWIFT_BRIDGING_HEADER += UISBWAPrefs-Bridging-Header.h
UISBWAPrefs_INSTALL_PATH += /Library/PreferenceBundles

include $(THEOS_MAKE_PATH)/bundle.mk