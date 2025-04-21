#import <UIKit/UIKit.h>

#define waBool(key) [[UISBWAUserDefaults standardUserDefaults] boolForKey:key]
#define waDouble(key) [[UISBWAUserDefaults standardUserDefaults] doubleForKey:key]

#define WA_NOTIFY_NAME "com.82flex.ohmyinsets.reload-prefs"

NS_ASSUME_NONNULL_BEGIN

__attribute__((visibility("hidden")))
@interface UISBWAUserDefaults : NSUserDefaults

@property(class, readonly, strong) UISBWAUserDefaults *standardUserDefaults;

- (void)beginUpdates;
- (void)endUpdates;

- (void)resetToDefaultValues;
- (void)darwinNotify;

@end

NS_ASSUME_NONNULL_END