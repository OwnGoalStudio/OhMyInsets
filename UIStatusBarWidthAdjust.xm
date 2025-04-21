#import <notify.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import <HBLog.h>

#import "UISBWAPrefs/UISBWAUserDefaults.h"

static BOOL _gIsEnabled = NO;
static BOOL _gIsFiveColumnsEnabled = NO;

static CGFloat _gCompactLeadingInset = 0.0;
static CGFloat _gCompactTrailingInset = 0.0;
static CGFloat _gExpandedLeadingInset = 0.0;
static CGFloat _gExpandedTrailingInset = 0.0;

static CGFloat _gCCUIGlobalFontSize = 13.0;
static CGFloat _gCCUIGlobalIconScale = 0.8;
static CGFloat _gCCUIGlobalCornerRadius = 12.0;

typedef struct {
  unsigned long long width;
  unsigned long long height;
} CCUILayoutPoint;

typedef struct {
  unsigned long long width;
  unsigned long long height;
} CCUILayoutSize;

typedef struct {
    CCUILayoutPoint origin;
    CCUILayoutSize size;
} CCUILayoutRect;

@interface CCUIControlCenterPositionProviderPackingRule : NSObject
@property(nonatomic, readonly) unsigned long long packFrom;
@property(nonatomic, readonly) unsigned long long packingOrder;
@property(nonatomic, readonly) CCUILayoutSize sizeLimit;
@end

@interface CCUIStatusBar : UIView
@property(assign, nonatomic) long long orientation;
@end

@interface CCUIMutableLayoutOptions : NSObject
@property(assign, nonatomic) CGFloat itemEdgeSize;
@property(assign, nonatomic) CGFloat itemSpacing;
- (void)recalculateItemLayouts;
@end

@interface CCUIButtonModuleView : UIView
@end

@interface CCUIBaseSliderView : UIView
@end

@interface CCUILabeledRoundButton : UIView
@end

@interface CCUIConnectivityModuleViewController : UIViewController
@property(getter=isExpanded, nonatomic, readonly) BOOL expanded;
@end

@interface FCCCModuleViewController : UIViewController
@end

@interface MRUTransportButton : UIView
@end

@interface MRUMarqueeLabel : UILabel
@end

@interface MRUNowPlayingLabelView : UIView
@property(assign, nonatomic) long long layout;
@property(nonatomic, strong) UILabel *placeholderLabel;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subtitleLabel;
@property(nonatomic, strong) MRUMarqueeLabel *titleMarqueeView;
@property(nonatomic, strong) MRUMarqueeLabel *subtitleMarqueeView;
@property(nonatomic, strong) MRUMarqueeLabel *placeholderMarqueeView;
@end

@interface MRUNowPlayingHeaderView : UIView
@property(nonatomic, strong) MRUNowPlayingLabelView *labelView;
@end

@interface MRUNowPlayingRoutingButton : UIView
@end

@interface CCUIContentModuleContentContainerView : UIView
@end

@interface HACCIconViewController : UIViewController
@end

@interface MTMaterialView : UIView
@end

@interface UIView (Private)
- (CGFloat)_continuousCornerRadius;
- (CGFloat)_cornerRadius;
- (void)_setContinuousCornerRadius:(CGFloat)arg1;
- (void)_setCornerRadius:(CGFloat)arg1;
@end

static void ReloadPrefs(void) {
    _gIsEnabled = waBool(@"isEnabled");
    _gIsFiveColumnsEnabled = waBool(@"isFiveColumnsEnabled");
    _gCompactLeadingInset = waDouble(@"compactLeadingInset");
    _gCompactTrailingInset = waDouble(@"compactTrailingInset");
    _gExpandedLeadingInset = waDouble(@"expandedLeadingInset");
    _gExpandedTrailingInset = waDouble(@"expandedTrailingInset");
}

%group ControlCenterUI

%hook CCUIStatusBar

- (void)setCompactEdgeInsets:(UIEdgeInsets)insets {
    if (!_gIsEnabled || self.orientation != 1) {
        %orig;
        return;
    }

    UIEdgeInsets newCompactInsets = insets;
    newCompactInsets.left = _gCompactLeadingInset;
    newCompactInsets.right = _gCompactTrailingInset;
    %orig(newCompactInsets);
}

- (void)setExpandedEdgeInsets:(UIEdgeInsets)insets {
    if (!_gIsEnabled || self.orientation != 1) {
        %orig;
        return;
    }

    UIEdgeInsets newExpandedInsets = insets;
    newExpandedInsets.left = _gExpandedLeadingInset;
    newExpandedInsets.right = _gExpandedTrailingInset;
    %orig(newExpandedInsets);
}

%end

%hook CCUIMutableLayoutOptions

- (void)setItemEdgeSize:(CGFloat)edgeSize {
    %orig;
    [self recalculateItemLayouts];
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    %orig;
    [self recalculateItemLayouts];
}

%new
- (void)recalculateItemLayouts {
    if (!_gIsFiveColumnsEnabled) {
        return;
    }

    CGFloat edgeSize = self.itemEdgeSize;
    CGFloat itemSpacing = self.itemSpacing;
    if (edgeSize > 0 && itemSpacing > 0) {
        CGFloat totalWidth = edgeSize * 4 + itemSpacing * 3;
        CGFloat newItemSpacing = itemSpacing * _gCCUIGlobalIconScale;
        CGFloat newEdgeSize = (totalWidth - newItemSpacing * 4) / 5;
        MSHookIvar<CGFloat>(self, "_itemEdgeSize") = newEdgeSize;
        MSHookIvar<CGFloat>(self, "_itemSpacing") = newItemSpacing;
    }
}

%end

%hook CCUIControlCenterPositionProviderPackingRule

- (id)initWithPackFrom:(unsigned long long)arg1
    packingOrder:(unsigned long long)arg2
    sizeLimit:(CCUILayoutSize)arg3
{
    if (!_gIsFiveColumnsEnabled) {
        return %orig;
    }
    if (arg3.width < 10) {
        arg3.width = 5;
    }
    if (arg3.height < 10) {
        arg3.height = 4;
    }
    return %orig;
}

%end

%hook CCUIControlCenterPositionProvider

- (id)_generateRectByIdentifierWithOrderedIdentifiers:(NSArray<NSString *> *)identifiers
    orderedSizes:(NSArray<NSValue *> *)sizes
    packingOrder:(unsigned long long)arg3
    startPosition:(CCUILayoutPoint)arg4
    maximumSize:(CCUILayoutSize)arg5
    outputLayoutSize:(CCUILayoutSize *)arg6
{
    if (!_gIsFiveColumnsEnabled) {
        return %orig;
    }
    if (arg5.width < 10) {
        arg5.width = 5;
    }
    if (arg5.height < 10) {
        arg5.height = 4;
    }
    CCUILayoutSize inSize = *arg6;
    HBLogWarn(@"[UISBWA] inSize %llux%llu", inSize.width, inSize.height);
    return %orig;
}

- (void)regenerateRectsWithOrderedIdentifiers:(NSArray<NSString *> *)identifiers orderedSizes:(NSArray<NSValue *> *)sizes
{
    if (!_gIsFiveColumnsEnabled) {
        %orig;
        return;
    }

    for (int i = 0; i < identifiers.count; i++) {
        NSString *identifier = identifiers[i];
        NSValue *value = sizes[i];

        CCUILayoutSize size = {0};
        [value getValue:&size];

        HBLogDebug(@"[UISBWA] id %@ size %llux%llu", identifier, size.width, size.height);
    }

    %orig(identifiers, sizes);
}

%end

%hook CCUIButtonModuleView

- (void)didMoveToWindow {
    %orig;
    if (!_gIsFiveColumnsEnabled) {
        return;
    }

    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:%c(CCUICAPackageView)] || [subview isKindOfClass:[UIImage class]]) {
            subview.transform = CGAffineTransformMakeScale(_gCCUIGlobalIconScale, _gCCUIGlobalIconScale);
        }
    }

    UIView *highlightedView = MSHookIvar<UIView *>(self, "_highlightedBackgroundView");
    [highlightedView _setContinuousCornerRadius:_gCCUIGlobalCornerRadius];
}

- (void)_setGlyphImage:(UIImage *)image {
    if (!_gIsFiveColumnsEnabled) {
        %orig;
        return;
    }

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width * _gCCUIGlobalIconScale, image.size.height * _gCCUIGlobalIconScale), NO, image.scale);
    [image drawInRect:CGRectMake(0, 0, image.size.width * _gCCUIGlobalIconScale, image.size.height * _gCCUIGlobalIconScale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    %orig(scaledImage);
}

%end

%hook CCUIBaseSliderView

- (void)didMoveToWindow {
    %orig;
    if (!_gIsFiveColumnsEnabled) {
        return;
    }

    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:%c(CCUICAPackageView)]) {
            subview.transform = CGAffineTransformMakeScale(_gCCUIGlobalIconScale, _gCCUIGlobalIconScale);
        }
    }
}

%end

%hook CCUILabeledRoundButton

- (void)didMoveToWindow {
    %orig;
    if (!_gIsFiveColumnsEnabled) {
        return;
    }

    self.transform = CGAffineTransformMakeScale(_gCCUIGlobalIconScale, _gCCUIGlobalIconScale);
}

- (void)layoutSubviews {
    %orig;
    if (!_gIsFiveColumnsEnabled) {
        return;
    }

    for (UIView *subview in self.subviews) {
        subview.frame = CGRectMake(
            subview.frame.origin.x,
            subview.frame.origin.y + 3,
            subview.frame.size.width,
            subview.frame.size.height
        );
    }
}

%end

%hook CCUIContentModuleContainerViewController

- (CGFloat)_continuousCornerRadiusForCompactState {
    if (!_gIsFiveColumnsEnabled) {
        return %orig;
    }

    return _gCCUIGlobalCornerRadius;
}

%end

%hook CCUIContinuousSliderView

- (void)setContinuousSliderCornerRadius:(CGFloat)arg1 {
    if (_gIsFiveColumnsEnabled && arg1 >= 19 && arg1 <= 22) {
        arg1 = _gCCUIGlobalCornerRadius;
    }
    %orig;
}

- (void)didMoveToWindow {
    %orig;
    if (!_gIsFiveColumnsEnabled) {
        return;
    }

    UIView *backgroundView = MSHookIvar<UIView *>(self, "_backgroundView");
    [backgroundView _setContinuousCornerRadius:_gCCUIGlobalCornerRadius];
}

%end

%hook UIView

- (void)_setContinuousCornerRadius:(CGFloat)arg1 {
    if (_gIsFiveColumnsEnabled && (arg1 >= 19 && arg1 <= 22) && [self isKindOfClass:%c(MTMaterialView)]) {
        arg1 = _gCCUIGlobalCornerRadius;
    }
    %orig;
}

%end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    int _gNotifyToken;
    notify_register_dispatch(WA_NOTIFY_NAME, &_gNotifyToken, dispatch_get_main_queue(), ^(int token) {
      ReloadPrefs();
    });

    ReloadPrefs();
    %orig;
}

%end

%end // ControlCenterUI

%group ConnectivityModule

%hook CCUIConnectivityModuleViewController

- (void)viewWillLayoutSubviews {
    %orig;
    if (!_gIsFiveColumnsEnabled) {
        return;
    }

    if (!self.expanded) {
        for (UIView *subview in self.view.subviews) {
            if ([subview isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)subview).contentInset = UIEdgeInsetsMake(-6, -9, 0, 0);
            }
        }
    } else {
        for (UIView *subview in self.view.subviews) {
            if ([subview isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)subview).contentInset = UIEdgeInsetsZero;
            }
        }
    }
}

%end

%end // ConnectivityModule

%group FocusUIModule

%hook FCCCModuleViewController

- (void)viewWillLayoutSubviews {
    %orig;
    if (!_gIsFiveColumnsEnabled) {
        return;
    }

    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            label.font = [label.font fontWithSize:_gCCUIGlobalFontSize];
        }
    }
}

%end

%end // FocusUIModule

%group MediaControlsModule

%hook MRUTransportButton

- (void)didMoveToWindow {
    %orig;
    if (!_gIsFiveColumnsEnabled) {
        return;
    }

    self.transform = CGAffineTransformMakeScale(_gCCUIGlobalIconScale, _gCCUIGlobalIconScale);
}

%end

%hook MRUNowPlayingLabelView

- (void)layoutSubviews {
    %orig;
    if (!_gIsFiveColumnsEnabled) {
        return;
    }

    if (self.layout == 0) {
        UILabel *label;

        if ([self respondsToSelector:@selector(placeholderLabel)]) {
            label = (UILabel *)self.placeholderLabel;
            label.font = [label.font fontWithSize:_gCCUIGlobalFontSize];
        } else if ([self respondsToSelector:@selector(placeholderMarqueeView)]) {
            MRUMarqueeLabel *marquee = (MRUMarqueeLabel *)self.placeholderMarqueeView;
            marquee.font = [marquee.font fontWithSize:_gCCUIGlobalFontSize];
        }

        if ([self respondsToSelector:@selector(titleLabel)]) {
            label = (UILabel *)self.titleLabel;
            label.font = [label.font fontWithSize:_gCCUIGlobalFontSize];
        } else if ([self respondsToSelector:@selector(titleMarqueeView)]) {
            MRUMarqueeLabel *marquee = (MRUMarqueeLabel *)self.titleMarqueeView;
            marquee.font = [marquee.font fontWithSize:_gCCUIGlobalFontSize];
        }

        if ([self respondsToSelector:@selector(subtitleLabel)]) {
            label = (UILabel *)self.subtitleLabel;
            label.font = [label.font fontWithSize:_gCCUIGlobalFontSize];
        } else if ([self respondsToSelector:@selector(subtitleMarqueeView)]) {
            MRUMarqueeLabel *marquee = (MRUMarqueeLabel *)self.subtitleMarqueeView;
            marquee.font = [marquee.font fontWithSize:_gCCUIGlobalFontSize];
        }
    }
}

%end

%hook MRUNowPlayingRoutingButton

- (void)didMoveToWindow {
    %orig;
    if (!_gIsFiveColumnsEnabled) {
        return;
    }

    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:%c(CCUICAPackageView)]) {
            subview.transform = CGAffineTransformMakeScale(_gCCUIGlobalIconScale, _gCCUIGlobalIconScale);
        }
    }
}

%end

%hook MRUNowPlayingHeaderView

- (void)layoutSubviews {
    %orig;
    if (!_gIsFiveColumnsEnabled) {
        return;
    }

    self.labelView.frame = CGRectMake(
        self.labelView.frame.origin.x,
        self.labelView.frame.origin.y + 6,
        self.labelView.frame.size.width,
        self.labelView.frame.size.height
    );
}

%end

%end // MediaControlsModule

%group HearingAidsModule

%hook HACCIconViewController

- (void)viewDidLoad {
    %orig;
    if (!_gIsFiveColumnsEnabled) {
        return;
    }

    self.view.transform = CGAffineTransformMakeScale(_gCCUIGlobalIconScale, _gCCUIGlobalIconScale);
}

%end

%end // HearingAidsModule

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    if ([((__bridge NSDictionary *)userInfo)[NSLoadedClasses] containsObject:@"CCUIConnectivityModuleViewController"]) {
        %init(ConnectivityModule);
    }
    else if ([((__bridge NSDictionary *)userInfo)[NSLoadedClasses] containsObject:@"FCCCModuleViewController"]) {
        %init(FocusUIModule);
    }
    else if ([((__bridge NSDictionary *)userInfo)[NSLoadedClasses] containsObject:@"HACCIconViewController"]) {
        %init(HearingAidsModule);
    }
}

%ctor {
    %init(ControlCenterUI);
    %init(MediaControlsModule);

    CFNotificationCenterAddObserver(
        CFNotificationCenterGetLocalCenter(), NULL, notificationCallback,
        (CFStringRef)NSBundleDidLoadNotification, NULL,
        CFNotificationSuspensionBehaviorCoalesce);
}
