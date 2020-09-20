//
//  KYContainerController.h
//  ContainerController
//
//  Created by 黄珂耀 on 2020/9/19.
//

#import <UIKit/UIKit.h>
#import "KYContainerView.h"
#import "KYContainerLayout.h"
#import "KYContainerControllerDelegate.h"
#import "KYContainerTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface KYContainerController : NSObject

#pragma mark - Views
@property (nonatomic, readwrite, strong) KYContainerView *view;

@property (nonatomic, readwrite, strong) UIButton *shadowButton;

@property (nonatomic, readwrite, strong) UIViewController *viewController;

@property (nonatomic, readwrite, strong) UIScrollView *scrollView;

@property (nonatomic, readwrite, strong) UIView *headerView;

@property (nonatomic, readwrite, strong) UIView *footerView;

#pragma mark - Layout
@property (nonatomic, readwrite, strong) KYContainerLayout *layout;

#pragma mark - Delegate
@property (nonatomic, weak) id<KYContainerControllerDelegate> delegate;

#pragma mark - Current Move Type
@property (nonatomic, readwrite, assign) KYContainerMoveType moveType;

@property (nonatomic, readwrite, assign) KYContainerMoveType oldMoveType;

#pragma mark - Properties Scroll

#pragma mark - Properties Position
- (CGFloat)topBarHeight;

- (BOOL)topTranslucent;

#pragma mark - Init
- (instancetype)initWithViewController:(UIViewController *)viewController layout:(KYContainerLayout *)layout;

#pragma mark - Remove
- (void)removeWithCompletion:(dispatch_block_t)completion;

#pragma mark - Rotated

#pragma mark - Update Layout
- (void)setLayout:(KYContainerLayout * _Nonnull)layout;

#pragma mark - Set
- (void)setMovingEnabled:(BOOL)movingEnabled;

- (void)setTrackingPosition:(BOOL)trackingPosition;

- (void)setFooterPadding:(CGFloat)footerPadding;

#pragma mark - Scroll Insets
- (void)setScrollIndicatorTop:(CGFloat)scrollIndicatorTop;

- (void)setScrollIndicatorBottom:(CGFloat)scrollIndicatorBottom;

- (void)setScrollInsetsTop:(CGFloat)scrollInsetsTop;

- (void)setScrollInsetsBottom:(CGFloat)scrollInsetsBottom;

#pragma mark - Portrait
- (void)setTop:(CGFloat)top;

- (void)setMiddle:(CGFloat)middle;

- (void)setBottom:(CGFloat)bottom;

- (void)setLeft:(CGFloat)left;

- (void)setRight:(CGFloat)right;

- (void)setBackgroundShadowShow:(BOOL)backgroundShadowShow;

#pragma mark - Landscape
- (void)updateLandscapeLayout;

- (void)setLandscapeTop:(CGFloat)top;

- (void)setLandscapeMiddle:(CGFloat)middle;

- (void)setLandscapeBottom:(CGFloat)bottom;

- (void)setLandscapeLeft:(CGFloat)left;

- (void)setLandscapeRight:(CGFloat)right;

- (void)setLandscapeBackgroundShadowShow:(BOOL)backgroundShadowShow;

#pragma mark - Add Header
- (void)removeHeaderView;

- (void)addHeaderView:(UIView *)headerView;

#pragma mark - Add Footer
- (void)removeFooterView;

- (void)addFooterView:(UIView *)footerView;

#pragma mark - Add ScrollView
- (void)removeScrollView;

- (void)addScrollView:(UIScrollView *)scrollView;

#pragma mark - Calculation Views Size
- (void)calculationViews;

#pragma mark - Move
- (void)moveWithType:(KYContainerMoveType)type;
- (void)moveWithType:(KYContainerMoveType)type animation:(BOOL)animation;
- (void)moveWithType:(KYContainerMoveType)type completion:(dispatch_block_t)completion;
- (void)moveWithType:(KYContainerMoveType)type animation:(BOOL)animation velocity:(CGFloat)velocity from:(KYContainerFromType)from completion:(dispatch_block_t)completion;

#pragma mark - Move Position
- (CGFloat)positionMoveFromWithType:(KYContainerMoveType)type;

#pragma mark - Move Animation
- (void)moveWithPosition:(CGFloat)position animation:(BOOL)animation type:(KYContainerMoveType)type velocity:(CGFloat)velocity from:(KYContainerFromType)from completion:(dispatch_block_t)completion;

@end

NS_ASSUME_NONNULL_END
