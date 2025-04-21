#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((visibility("hidden")))
@interface NSBundle (UISBWA)

@property(class, nonatomic, readonly) NSBundle *uisbwa_supportBundle;
@property(class, nonatomic, readonly) NSString *uisbwa_packageVersion;

+ (void)uisbwa_respringWithSnapshot:(BOOL)useSnapshot restartRenderServer:(BOOL)restartRenderServer;
+ (void)uisbwa_openSensitiveURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END