#import "NSBundle+UISBWAPrefs.h"
#import "FBSSystemService.h"
#import "SBSRelaunchAction.h"

#ifdef THEOS_PACKAGE_SCHEME_ROOTHIDE
#import <roothide.h>
#else
#import <rootless.h>
#endif

FOUNDATION_EXTERN int SBSOpenSensitiveURLAndUnlock(CFURLRef url, char flags);

@implementation NSBundle (UISBWA)

+ (NSBundle *)uisbwa_supportBundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      NSString *tweakBundlePath = [[NSBundle mainBundle] pathForResource:@"UISBWAPrefs" ofType:@"bundle"];
      NSString *aliasBundlePath;
#ifdef THEOS_PACKAGE_SCHEME_ROOTHIDE
      aliasBundlePath = jbroot(@"/Library/PreferenceBundles/UISBWAPrefs.bundle");
#else
      aliasBundlePath = ROOT_PATH_NS(@"/Library/PreferenceBundles/UISBWAPrefs.bundle");
#endif
      bundle = [NSBundle bundleWithPath:tweakBundlePath ?: aliasBundlePath];
    });
    return bundle;
}

+ (NSString *)uisbwa_packageVersion {
    return @PACKAGE_VERSION;
}

+ (void)uisbwa_respringWithSnapshot:(BOOL)useSnapshot restartRenderServer:(BOOL)restartRenderServer {

    SBSRelaunchActionOptions options = (useSnapshot
                                        ? SBSRelaunchActionOptionsSnapshotTransition
                                        : SBSRelaunchActionOptionsFadeToBlackTransition);

    if (restartRenderServer) {
        options |= SBSRelaunchActionOptionsRestartRenderServer;
    }

    SBSRelaunchAction *relaunchAction = [SBSRelaunchAction
                                         actionWithReason:@""
                                         options:options
                                         targetURL:[NSURL URLWithString:@"prefs:root=Oh%20My%20Insets"]];

    [[FBSSystemService sharedService] sendActions:[NSSet setWithObject:relaunchAction] withResult:nil];

}

+ (void)uisbwa_openSensitiveURL:(NSURL *)url {
    if (!url) {
        return;
    }

    SBSOpenSensitiveURLAndUnlock((__bridge CFURLRef)url, 0);
}

@end