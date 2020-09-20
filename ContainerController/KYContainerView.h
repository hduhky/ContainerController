//
//  KYContainerView.h
//  ContainerController
//
//  Created by 黄珂耀 on 2020/9/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYContainerView : UIView

@property (nonatomic, readwrite, strong) UIView *contentView;

@property (nonatomic, readwrite, strong) UIVisualEffectView *visualEffectView;

#pragma mark - CornerRadius
@property (nonatomic, readwrite, assign) CGFloat cornerRadius;

- (CGFloat)radius;

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame;

#pragma mark - Add Custom Shadow
- (void)addShadow;
- (void)addShadowWithOpacity:(CGFloat)opacity;

#pragma mark - Add Blur
- (void)addBlurWithDarkStyle:(BOOL)darkStyle;

- (void)addBlurWithStyle:(UIBlurEffectStyle)style;

#pragma mark - Remove Blur
- (void)removeBlur;

@end

NS_ASSUME_NONNULL_END
