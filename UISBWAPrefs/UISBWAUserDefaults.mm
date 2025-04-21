#import "UISBWAUserDefaults.h"

#ifdef THEOS_PACKAGE_SCHEME_ROOTHIDE
#import <roothide.h>
#else
#import <rootless.h>
#endif

#import <notify.h>

static NSString *const kDefaultsSuiteName = @"com.82flex.ohmyinsets";

@implementation UISBWAUserDefaults {
    NSInteger _updateCount;
}

+ (UISBWAUserDefaults *)standardUserDefaults {
    static dispatch_once_t onceToken;
    static UISBWAUserDefaults *defaults = nil;
    dispatch_once(&onceToken, ^{
      defaults = [[self alloc] initWithSuiteName:kDefaultsSuiteName];
      [defaults registerDefaults];
    });
    return defaults;
}

- (void)registerDefaults {
    [self registerDefaults:@{
        @"isEnabled" : @NO,
        @"isFiveColumnsEnabled" : @NO,
        @"compactLeadingInset" : @69,
        @"compactTrailingInset" : @0,
        @"expandedLeadingInset" : @30,
        @"expandedTrailingInset" : @30,
    }];
}

- (void)beginUpdates {
    _updateCount++;
}

- (void)endUpdates {
    if (_updateCount > 0) {
        _updateCount--;
    }
    if (_updateCount == 0) {
        [self darwinNotify];
    }
}

- (void)setObject:(id)value forKey:(NSString *)key {
    [self beginUpdates];
    [super setObject:value forKey:key];
    [self endUpdates];
}

- (void)resetToDefaultValues {
    [self beginUpdates];
    for (NSString *key in self.dictionaryRepresentation.allKeys) {
        if ([key hasPrefix:@"_"]) {
            continue;
        }
        [self removeObjectForKey:key];
    }
    [self endUpdates];
}

- (void)darwinNotify {
    notify_post(WA_NOTIFY_NAME);
}

@end
