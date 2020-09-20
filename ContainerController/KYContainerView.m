//
//  KYContainerView.m
//  ContainerController
//
//  Created by 黄珂耀 on 2020/9/19.
//

#import "KYContainerView.h"

@implementation KYContainerView

#pragma mark - CornerRadius
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    CGFloat r = self.radius;
    self.layer.cornerRadius = r;
    self.contentView.layer.cornerRadius = r;
    self.contentView.clipsToBounds = YES;
    self.visualEffectView.layer.cornerRadius = r;
}

- (CGFloat)radius {
    CGFloat minSize = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat radius = (((minSize / 2) < self.cornerRadius) ? (minSize / 2) : self.cornerRadius);
    return radius;
}

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        contentView.backgroundColor = UIColor.clearColor;
        contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:contentView];
        self.contentView = contentView;
    }
    return self;
}

#pragma mark - Add Custom Shadow
- (void)addShadow {
    [self addShadowWithOpacity:0.1];
}

- (void)addShadowWithOpacity:(CGFloat)opacity {
    self.layer.shadowOpacity = opacity;
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowRadius = 3;
}

#pragma mark - Add Blur
- (void)addBlurWithDarkStyle:(BOOL)darkStyle {
    UIBlurEffectStyle style;
    if (@available(iOS 13.0, *)) {
        style = darkStyle ? UIBlurEffectStyleSystemThinMaterialDark : UIBlurEffectStyleSystemChromeMaterialLight;
    } else {
        style = darkStyle ? UIBlurEffectStyleDark : UIBlurEffectStyleLight;
    }
    self.backgroundColor = UIColor.clearColor;
    [self addBlurWithStyle:style];
}

- (void)addBlurWithStyle:(UIBlurEffectStyle)style {
    if (!_visualEffectView) {
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:style]];
        [self insertSubview:blurView atIndex:0];
        self.visualEffectView = blurView;
    }
    if (!_visualEffectView) {
        return;
    }
    self.visualEffectView.effect = [UIBlurEffect effectWithStyle:style];
    self.visualEffectView.bounds = self.bounds;
    self.visualEffectView.frame = CGRectMake(0, 0, self.visualEffectView.frame.size.width, self.visualEffectView.frame.size.height);
    self.visualEffectView.layer.cornerRadius = self.radius;
    self.visualEffectView.layer.masksToBounds = YES;
    self.visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
}

#pragma mark - Remove Blur
- (void)removeBlur {
    if (_visualEffectView) {
        [self.visualEffectView removeFromSuperview];
    }
    _visualEffectView = nil;
}

@end
