//
//  KYContainerController.m
//  ContainerController
//
//  Created by 黄珂耀 on 2020/9/19.
//

#import "KYContainerController.h"

@interface KYContainerController () <UIGestureRecognizerDelegate, UIScrollViewDelegate>

#pragma mark - Properties Scroll
@property (nonatomic, readwrite, assign) CGAffineTransform oldTransform;

@property (nonatomic, readwrite, assign) CGFloat oldPosition;

@property (nonatomic, readwrite, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, readwrite, assign) CGFloat panBeginSavePosition;

@property (nonatomic, readwrite, assign) Orientation oldOrientation;

@property (nonatomic, readwrite, assign) BOOL isScrolling;

@property (nonatomic, readwrite, assign) BOOL scrollBordersRunContainer;

@property (nonatomic, readwrite, assign) BOOL scrollOnceBeginDragging;

@property (nonatomic, readwrite, assign) BOOL scrollOnceEnded;

@property (nonatomic, readwrite, assign) BOOL scrollBegin;

@property (nonatomic, readwrite, assign) CGFloat scrollStartPosition;

@property (nonatomic, readwrite, assign) CGAffineTransform scrollTransform;

#pragma mark - Move Animation
@property (nonatomic, readwrite, assign) CGFloat displayVelocity;

@end

@implementation KYContainerController

#pragma mark - Properties Position
- (CGFloat)topBarHeight {
    CGFloat result = 0.0;
    UINavigationController *vc = self.viewController.navigationController;
    if (vc && !vc.isNavigationBarHidden) {
        CGFloat statusBarHeight = KYContainerDevice.statusBarHeight;
        CGFloat navBarHeight = vc.navigationBar.frame.size.height;
        result = statusBarHeight + navBarHeight;
    }
    return result;
}

- (BOOL)topTranslucent {
    return self.viewController.navigationController.navigationBar.isTranslucent;
}

- (BOOL)isPortrait {
    return KYContainerDevice.isPortrait;
}

- (CGFloat)deviceHeight {
    CGFloat height = 0;
    if (self.isPortrait) {
        height = KYContainerDevice.screenMax;
    } else {
        height = KYContainerDevice.screenMin;
    }
    height -= self.topBarHeight;
    return height;
}

- (CGFloat)deviceWidth {
    CGFloat width = 0;
    if (self.isPortrait) {
        width = KYContainerDevice.screenMin;
    } else {
        width = KYContainerDevice.screenMax;
    }
    return width;
}

#pragma mark - Positions Move
- (CGFloat)positionTop {
    CGFloat top = self.layout.positions.top;
    if (!self.isPortrait) {
        if (self.layout.landscapePositions) {
            top = self.layout.landscapePositions.top;
        }
    }
    return top;
}

- (CGFloat)positionMiddle {
    CGFloat middle = self.layout.positions.middle ? : self.layout.positions.bottom;
    if (!self.isPortrait) {
        if (self.layout.landscapePositions) {
            middle = self.layout.landscapePositions.middle;
        }
    }
    return self.deviceHeight - middle;
}

- (CGFloat)positionBottom {
    CGFloat bottom = self.layout.positions.bottom;
    if (!self.isPortrait) {
        if (self.layout.landscapePositions) {
            bottom = self.layout.landscapePositions.bottom;
        }
    }
    return self.deviceHeight - bottom;
}

- (CGFloat)insetsLeft {
    CGFloat left = self.layout.insets.left;
    if (!self.isPortrait) {
        if (self.layout.landscapeInsets) {
            left = self.layout.landscapeInsets.left;
        }
    }
    return left;
}

- (CGFloat)insetsRight {
    CGFloat right = self.layout.insets.right;
    if (!self.isPortrait) {
        if (self.layout.landscapeInsets) {
            right = self.layout.landscapeInsets.right;
        }
    }
    return right;
}

- (BOOL)middleEnable {
    if (self.isPortrait) {
        return self.layout.positions.middle;
    } else {
        if (self.layout.landscapePositions) {
            return self.layout.landscapePositions.middle;
        } else {
            return self.layout.positions.middle;
        }
    }
}

#pragma mark - Init
- (instancetype)initWithViewController:(UIViewController *)viewController layout:(KYContainerLayout *)layout {
    self = [super init];
    self.viewController = viewController;
    self.layout = layout;
    
    [self createShadowButton];
    [self createContainerView];
    
    [self moveWithType:self.layout.startPosition animation:NO];
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _layout = [[KYContainerLayout alloc] init];
        _moveType = KYContainerMoveTypeHide;
        _oldMoveType = KYContainerMoveTypeHide;
        _oldTransform = CGAffineTransformIdentity;
        _oldPosition = 0.0;
        _panBeginSavePosition = 0.0;
        _oldOrientation = KYContainerDevice.orientation;
        _isScrolling = NO;
        _scrollBordersRunContainer = NO;
        _scrollOnceBeginDragging = NO;
        _scrollOnceEnded = NO;
        _scrollBegin = NO;
        _scrollStartPosition = 0.0;
        _scrollTransform = CGAffineTransformIdentity;
    }
    return self;
}

#pragma mark - Remove
- (void)remove {
    [self removeWithCompletion:^{}];
}

- (void)removeWithCompletion:(dispatch_block_t)completion {
    __weak typeof(self) weakSelf = self;
    [self moveWithType:KYContainerMoveTypeHide completion:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf.scrollView removeFromSuperview];
        [strongSelf.headerView removeFromSuperview];
        [strongSelf.footerView removeFromSuperview];
        [strongSelf.shadowButton removeFromSuperview];
        [strongSelf.view removeFromSuperview];
        
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - Rotated
- (void)rotated {
    UIDeviceOrientation orint = UIDevice.currentDevice.orientation;
    if (orint == UIDeviceOrientationFaceUp || orint == UIDeviceOrientationFaceDown || orint == UIDeviceOrientationPortraitUpsideDown) {
        return;
    }
    
    if (KYContainerDevice.orientation == self.oldOrientation) {
        return;
    }
    self.oldOrientation = KYContainerDevice.orientation;
    
    [self shadowHiddenCheck];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(containerControllerRotationWithContainerController:)]) {
        [self.delegate containerControllerRotationWithContainerController:self];
    }
    
    [self calculationViews];
    [self calculationScrollViewHeightWithPosition:-1.0 animation:NO from:KYContainerFromTypeRotation velocity:0.0 moveType:KYContainerMoveTypeCustom moveTypeOld:KYContainerMoveTypeCustom];
    
    [self moveWithType:self.moveType animation:NO velocity:0.0 from:KYContainerFromTypeRotation completion:^{}];
}

#pragma mark - Update Layout
- (void)setLayout:(KYContainerLayout * _Nonnull)layout {
    _layout = layout;
    [self calculationViews];
}

#pragma mark - Set
- (void)setMovingEnabled:(BOOL)movingEnabled {
    self.layout.movingEnabled = movingEnabled;
    self.scrollView.scrollEnabled = movingEnabled;
    self.panGesture.enabled = movingEnabled;
}

- (void)setTrackingPosition:(BOOL)trackingPosition {
    self.layout.trackingPosition = trackingPosition;
}

- (void)setFooterPadding:(CGFloat)footerPadding {
    self.layout.footerPadding = footerPadding;
    [self calculationViews];
}

#pragma mark - Scroll Insets
- (void)setScrollIndicatorTop:(CGFloat)scrollIndicatorTop {
    self.layout.scrollIndicatorInsets = UIEdgeInsetsMake(scrollIndicatorTop, 0, self.layout.scrollIndicatorInsets.bottom, 0);
    [self calculationViews];
}

- (void)setScrollIndicatorBottom:(CGFloat)scrollIndicatorBottom {
    self.layout.scrollIndicatorInsets = UIEdgeInsetsMake(self.layout.scrollIndicatorInsets.top, 0, scrollIndicatorBottom, 0);
    [self calculationViews];
}

- (void)setScrollInsetsTop:(CGFloat)scrollInsetsTop {
    self.layout.scrollInsets = UIEdgeInsetsMake(scrollInsetsTop, 0, self.layout.scrollInsets.bottom, 0);
    [self calculationViews];
}

- (void)setScrollInsetsBottom:(CGFloat)scrollInsetsBottom {
    self.layout.scrollInsets = UIEdgeInsetsMake(self.layout.scrollInsets.top, 0, scrollInsetsBottom, 0);
    [self calculationViews];
}

#pragma mark - Portrait
- (void)setTop:(CGFloat)top {
    self.layout.positions.top = top;
}

- (void)setMiddle:(CGFloat)middle {
    self.layout.positions.middle = middle;
}

- (void)setBottom:(CGFloat)bottom {
    self.layout.positions.bottom = bottom;
}

- (void)setLeft:(CGFloat)left {
    self.layout.insets.left = left;
    if (self.isPortrait) {
        [self calculationViews];
    }
}

- (void)setRight:(CGFloat)right {
    self.layout.insets.right = right;
    if (self.isPortrait) {
        [self calculationViews];
    }
}

- (void)setBackgroundShadowShow:(BOOL)backgroundShadowShow {
    self.layout.backgroundShadowShow = backgroundShadowShow;
    if (self.isPortrait) {
        [self moveWithType:self.moveType];
    }
}

#pragma mark - Landscape
- (void)updateLandscapeLayout {
    if (!self.layout.landscapePositions) {
        self.layout.landscapePositions = KYContainerPosition.zero;
    }
    if (!self.layout.landscapeInsets) {
        self.layout.landscapeInsets = KYContainerInsets.zero;
    }
}

- (void)setLandscapeTop:(CGFloat)top {
    [self updateLandscapeLayout];
    self.layout.landscapePositions.top = top;
}

- (void)setLandscapeMiddle:(CGFloat)middle {
    [self updateLandscapeLayout];
    self.layout.landscapePositions.middle = middle;
}

- (void)setLandscapeBottom:(CGFloat)bottom {
    [self updateLandscapeLayout];
    self.layout.landscapePositions.bottom = bottom;
}

- (void)setLandscapeLeft:(CGFloat)left {
    [self updateLandscapeLayout];
    self.layout.landscapeInsets.left = left;
    if (!self.isPortrait) {
        [self calculationViews];
    }
}

- (void)setLandscapeRight:(CGFloat)right {
    [self updateLandscapeLayout];
    self.layout.landscapeInsets.right = right;
    if (!self.isPortrait) {
        [self calculationViews];
    }
}

- (void)setLandscapeBackgroundShadowShow:(BOOL)backgroundShadowShow {
    self.layout.landscapeBackgroundShadowShow = backgroundShadowShow;
    if (!self.isPortrait) {
        [self moveWithType:self.moveType];
    }
}

#pragma mark - Create Shadow-Button
- (void)createShadowButton {
    UIButton *shadowButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KYContainerDevice.screenMax, KYContainerDevice.screenMax)];
    shadowButton.userInteractionEnabled = NO;
    shadowButton.backgroundColor = UIColor.blackColor;
    shadowButton.alpha = 0.0;
    [shadowButton addTarget:self action:@selector(shadowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.viewController.view addSubview:shadowButton];
    self.shadowButton = shadowButton;
}

- (void)shadowButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(containerControllerShadowClickWithContainerController:)]) {
        [self.delegate containerControllerShadowClickWithContainerController:self];
    }
}

#pragma mark - Create Container-View
- (void)createContainerView {
    CGRect frame = CGRectMake(0, 0, [self deviceWidth], [self deviceHeight] * 2);
    self.view = [[KYContainerView alloc] initWithFrame:frame];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.viewController.view addSubview:self.view];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanWithGesture:)];
    self.panGesture.enabled = self.layout.movingEnabled;
    if (self.panGesture) {
        [self.view addGestureRecognizer:self.panGesture];
    }
}

#pragma mark - Add Header
- (void)removeHeaderView {
    if (_headerView) {
        [self.headerView removeFromSuperview];
    }
    _headerView = nil;
    [self calculationViews];
}

- (void)addHeaderView:(UIView *)headerView {
    [self removeHeaderView];
    self.headerView = headerView;
    [self.view.contentView addSubview:headerView];
    [self calculationViews];
}

#pragma mark - Add Footer
- (void)removeFooterView {
    if (_footerView) {
        [self.footerView removeFromSuperview];
    }
    _footerView = nil;
    [self calculationViews];
}

- (void)addFooterView:(UIView *)footerView {
    [self removeFooterView];
    self.footerView = footerView;
    [self.view.contentView addSubview:footerView];
    [self calculationViews];
}

#pragma mark - Add ScrollView
- (void)removeScrollView {
    if (_scrollView) {
        [self.scrollView removeFromSuperview];
    }
    _scrollView = nil;
    [self calculationViews];
}

- (void)addScrollView:(UIScrollView *)scrollView {
    [self removeScrollView];
    self.scrollView = scrollView;
    
    scrollView.scrollEnabled = self.layout.movingEnabled;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    scrollView.scrollEnabled = (self.moveType == KYContainerMoveTypeTop);
    
    if (!scrollView.delegate) {
        scrollView.delegate = self;
    }
    
    [self.view.contentView addSubview:scrollView];
    [self calculationViews];
}

#pragma mark - Pan Gesture
- (void)handlePanWithGesture:(UIPanGestureRecognizer *)gesture {
    [self.view.layer removeAllAnimations];
    [self.scrollView.layer removeAllAnimations];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.panBeginSavePosition = self.view.transform.ty;
            break;;
        case UIGestureRecognizerStateChanged: {
            CGAffineTransform transform = self.view.transform;
            transform.ty = self.panBeginSavePosition + [gesture translationInView:self.view].y;
            
            if (transform.ty < 0) {
                transform.ty = (self.positionTop / 2);
            } else if (transform.ty < self.positionTop) {
                transform.ty = (self.positionTop / 2) + (transform.ty / 2);
            }
            
            CGFloat position = transform.ty;
            KYContainerMoveType type = self.moveType;
            KYContainerFromType from = KYContainerFromTypePan;
            BOOL animation = NO;
            
            [self changeViewWithTransform:transform];
            [self shadowLevelAlphaWithPosition:position animation:NO];
            [self changeFooterViewWithPosition:position];
            [self calculationScrollViewHeightWithFrom:from];
            [self changeMoveWithPosition:position type:type animation:animation];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGFloat velocityY = [gesture velocityInView:self.view].y;
            KYContainerMoveType type = [self calculatePositionTypeFromWithVelocity:velocityY];
            
            [self moveWithType:type animation:YES velocity:velocityY from:KYContainerFromTypePan completion:^{}];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Calculation Views Size
- (void)calculationViews {
    [self calculationView];
    [self calculationScrollViewHeightWithPosition:-1.0 animation:NO from:KYContainerFromTypeCustom velocity:0.0 moveType:KYContainerMoveTypeCustom moveTypeOld:KYContainerMoveTypeCustom];
}

- (void)calculationView {
    if (!_view) {
        return;
    }
    
    CGFloat x = self.insetsLeft;
    CGFloat width = (self.deviceWidth - self.insetsRight - self.insetsLeft);
    CGFloat height = self.deviceHeight * 2;
    
    if (_headerView) {
        self.headerView.frame = CGRectMake(0, 0, width, height);
    }
    if (_footerView) {
        self.footerView.frame = CGRectMake(x, self.footerView.frame.origin.y, width, height);
        [self changeFooterView];
    }
}

#pragma mark - Calculation ScrollView Size
- (void)calculationScrollViewHeightWithFrom:(KYContainerFromType)from {
    [self calculationScrollViewHeightWithPosition:from animation:NO from:KYContainerFromTypeCustom velocity:0.0 moveType:KYContainerMoveTypeCustom moveTypeOld:KYContainerMoveTypeCustom];
}

- (void)calculationScrollViewHeightWithPosition:(CGFloat)position animation:(BOOL)animation from:(KYContainerFromType)from velocity:(CGFloat)velocity moveType:(KYContainerMoveType)moveType moveTypeOld:(KYContainerMoveType)moveTypeOld {
    if (!_scrollView) {
        return;
    }
    [self.scrollView.layer removeAllAnimations];
    
    CGFloat headerHeight = self.headerView.frame.size.height;
    
    CGFloat footerInsets = 0.0;
    if (_footerView) {
        footerInsets = self.deviceHeight - self.footerView.frame.origin.y;
    }
    
    CGFloat scrollInsetsBottom = KYContainerDevice.isIphoneXBottom;
    if (scrollInsetsBottom < footerInsets) {
        scrollInsetsBottom = 0.0;
    }
    
    CGFloat top = self.layout.scrollInsets.top;
    CGFloat bottom = self.layout.scrollInsets.bottom + scrollInsetsBottom;
    
    CGFloat indicatorTop = self.layout.scrollIndicatorInsets.top;
    CGFloat indicatorBottom = self.layout.scrollIndicatorInsets.bottom;
    
    CGFloat containerViewPositionY = 0.0;
    if (position == -1.0) {
        containerViewPositionY = self.view.transform.ty;
    } else {
        containerViewPositionY = position;
    }
    
    CGFloat width = (self.deviceHeight - self.insetsRight - self.insetsLeft);
    CGFloat height = (self.deviceHeight - (headerHeight + footerInsets + containerViewPositionY));
    
    if (height < 0) {
        height = 0;
    }
    
    if (animation && !self.isScrolling && !_footerView && (self.oldPosition < position) && (((moveType == KYContainerMoveTypeMiddle) && (velocity > 0)) || (moveType == KYContainerMoveTypeBottom))) {
        height = self.scrollView.frame.size.height;
    }
    
    self.scrollView.frame = CGRectMake(0, headerHeight, width, height);
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(indicatorTop, 0, indicatorBottom, 0);
    self.scrollView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
}

#pragma mark - Position-Type From Velocity
- (KYContainerMoveType)calculatePositionTypeFromWithVelocity:(CGFloat)velocity {
    KYContainerMoveType type;
    
    CGFloat position = self.view.transform.ty;
    
    if (self.middleEnable) {
        if (position < self.positionTop) {
            if (velocity > 750) {
                if (velocity > 2500) {
                    type = KYContainerMoveTypeBottom;
                } else {
                    type = KYContainerMoveTypeMiddle;
                }
            } else {
                type = KYContainerMoveTypeTop;
            }
        } else if (position > self.positionBottom) {
            if (velocity < -750) {
                if (velocity < -2000) {
                    type = KYContainerMoveTypeTop;
                } else {
                    type = KYContainerMoveTypeMiddle;
                }
            } else {
                type = KYContainerMoveTypeBottom;
            }
        } else {
            CGFloat centerMiddleTop = ((self.positionMiddle - self.positionTop) / 2) + self.positionTop;
            CGFloat centerBottomMiddle = ((self.positionBottom - self.positionMiddle) / 2) + self.positionMiddle;
            
            if (position < centerMiddleTop) {
                if (velocity > 150) {
                    if (velocity > 2500) {
                        type = KYContainerMoveTypeBottom;
                    } else {
                        type = KYContainerMoveTypeMiddle;
                    }
                } else {
                    type = KYContainerMoveTypeTop;
                }
            } else if (position < centerBottomMiddle) {
                if (velocity < 0) {
                    if (velocity < -150) {
                        type = KYContainerMoveTypeTop;
                    } else {
                        type = KYContainerMoveTypeMiddle;
                    }
                } else {
                    if (velocity > 150) {
                        type = KYContainerMoveTypeBottom;
                    } else {
                        type = KYContainerMoveTypeMiddle;
                    }
                }
            } else {
                if (velocity < -150) {
                    if (velocity < -2000) {
                        type = KYContainerMoveTypeTop;
                    } else {
                        type = KYContainerMoveTypeMiddle;
                    }
                } else {
                    type = KYContainerMoveTypeBottom;
                }
            }
        }
    } else {
        if (position < self.positionTop) {
            if (velocity > 750) {
                type = KYContainerMoveTypeBottom;
            } else {
                type = KYContainerMoveTypeTop;
            }
        } else if (position > self.positionBottom) {
            if (velocity < -750) {
                type = KYContainerMoveTypeTop;
            } else {
                type = KYContainerMoveTypeBottom;
            }
        } else {
            CGFloat centerTopBottom = ((self.positionBottom - self.positionTop) / 2) + self.positionTop;
            
            if (position < centerTopBottom) {
                if (velocity > 150) {
                    type = KYContainerMoveTypeBottom;
                } else {
                    type = KYContainerMoveTypeTop;
                }
            } else {
                if (velocity < -150) {
                    type = KYContainerMoveTypeTop;
                } else {
                    type = KYContainerMoveTypeBottom;
                }
            }
        }
    }
    return type;
}

#pragma mark - Move
- (void)moveWithType:(KYContainerMoveType)type {
    [self moveWithType:type animation:YES];
}

- (void)moveWithType:(KYContainerMoveType)type animation:(BOOL)animation {
    [self moveWithType:type animation:animation velocity:0.0 from:KYContainerFromTypeCustom completion:^{}];
}

- (void)moveWithType:(KYContainerMoveType)type velocity:(CGFloat)velocity {
    [self moveWithType:type animation:YES velocity:velocity from:KYContainerFromTypeCustom];
}

- (void)moveWithType:(KYContainerMoveType)type completion:(dispatch_block_t)completion {
    [self moveWithType:type animation:YES velocity:0.0 from:KYContainerFromTypeCustom completion:completion];
}

- (void)moveWithType:(KYContainerMoveType)type animation:(BOOL)animation velocity:(CGFloat)velocity from:(KYContainerFromType)from {
    [self moveWithType:type animation:animation velocity:velocity from:from completion:^{}];
}

- (void)moveWithType:(KYContainerMoveType)type animation:(BOOL)animation velocity:(CGFloat)velocity from:(KYContainerFromType)from completion:(dispatch_block_t)completion {
    CGFloat position = [self positionMoveFromWithType:type];
    
    [self moveWithPosition:position animation:animation type:type velocity:velocity from:from completion:completion];
}

#pragma mark - Move Position
- (CGFloat)positionMoveFromWithType:(KYContainerMoveType)type {
    switch (type) {
        case KYContainerMoveTypeTop:
            return self.positionTop;
        case KYContainerMoveTypeMiddle: {
            if (!self.middleEnable) {
                return self.positionBottom;
            } else {
                return self.positionMiddle;
            }
        }
        case KYContainerMoveTypeBottom:
            return self.positionBottom;
        case KYContainerMoveTypeHide:
            return self.deviceHeight;
        case KYContainerMoveTypeCustom:
            return 0.0;
    }
}

#pragma mark - Move Animation
- (void)moveWithPosition:(CGFloat)position animation:(BOOL)animation type:(KYContainerMoveType)type velocity:(CGFloat)velocity from:(KYContainerFromType)from completion:(dispatch_block_t)completion {
    if (self.layout.movingEnabled) {
        self.scrollView.scrollEnabled = (type == KYContainerMoveTypeTop);
    } else {
        self.scrollView.scrollEnabled = NO;
    }
    
    self.displayVelocity = velocity;
    
    self.oldMoveType = self.moveType;
    KYContainerMoveType oldMove = self.moveType;
    self.moveType = type;
    
    [self shadowLevelAlphaWithPosition:position animation:YES];
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, position);
    
    __weak typeof(self) weakSelf = self;
    dispatch_block_t animationComp = ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf changeViewWithTransform:transform];
        if (!strongSelf.layout.trackingPosition) {
            [strongSelf changeFooterViewWithPosition:position];
            [strongSelf calculationScrollViewHeightWithPosition:position animation:animation from:from velocity:velocity moveType:type moveTypeOld:oldMove];
        }
        [strongSelf changeMoveWithPosition:position type:type animation:YES];
    };
    
    if (animation) {
        [self animationSpringFromWithForce:velocity type:type animations:animationComp completion:completion];
    } else {
        [self changeFooterViewWithPosition:position];
        [self changeViewWithTransform:transform];
        [self calculationScrollViewHeightWithPosition:position animation:animation from:from velocity:velocity moveType:type moveTypeOld:oldMove];
        [self changeMoveWithPosition:position type:type animation:NO];
        
        if (completion) {
            completion();
        }
    }
}

#pragma mark - Tracking Position
- (void)animationDidUpdateWithDisplayLink:(CADisplayLink *)displayLink {
    if (!self.layout.trackingPosition) {
        return;
    }
    if (!self.view.layer.presentationLayer) {
        return;
    }
    
    CGFloat position = self.view.layer.presentationLayer.frame.origin.y;
    [self changeFooterViewWithPosition:position];
    [self calculationScrollViewHeightWithPosition:position animation:NO from:KYContainerFromTypeTracking velocity:self.displayVelocity moveType:self.moveType moveTypeOld:self.oldMoveType];
}

- (void)changeViewWithTransform:(CGAffineTransform)transform {
    self.oldPosition = self.view.frame.origin.y;
    self.oldTransform = self.view.transform;
    self.view.transform = transform;
}

- (void)changeMoveWithPosition:(CGFloat)position type:(KYContainerMoveType)type animation:(BOOL)animation {
    if (self.delegate && [self.delegate respondsToSelector:@selector(containerControllerMoveWithContainerController:position:type:animation:)]) {
        [self.delegate containerControllerMoveWithContainerController:self position:position type:type animation:animation];
    }
}

#pragma mark - Shadow Alpha Level
- (void)shadowLevelAlphaWithPosition:(CGFloat)position animation:(BOOL)animation {
    if (animation) {
        __weak typeof(self) weakSelf = self;
        [self animationSpringWithDuration:0.45 animations:^{
                    __strong typeof(self) strongSelf = weakSelf;
                    if (!strongSelf) {
                        return;
                    }
                    [strongSelf shadowLevelAlphaWithPositionY:position];
        }];
    } else {
        [self shadowLevelAlphaWithPositionY:position];
    }
}

- (void)animationSpringWithDuration:(CGFloat)duration animations:(dispatch_block_t)animations {
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:6.0 options:UIViewAnimationOptionAllowUserInteraction animations:animations completion:nil];
}

- (void)shadowHiddenCheck {
    if (self.isPortrait) {
        self.shadowButton.hidden = !self.layout.backgroundShadowShow;
    } else {
        if (self.layout.landscapeBackgroundShadowShow) {
            self.shadowButton.hidden = !self.layout.landscapeBackgroundShadowShow;
        } else {
            self.shadowButton.hidden = !self.layout.backgroundShadowShow;
        }
    }
}

- (void)shadowLevelAlphaWithPositionY:(CGFloat)positionY {
    [self shadowHiddenCheck];
    
    CGFloat alphaMax = 0.45;
    if (positionY < self.positionTop) {
        self.shadowButton.alpha = alphaMax;
    } else if (positionY < self.positionMiddle) {
        CGFloat m = self.positionMiddle - self.positionTop;
        CGFloat p = positionY - self.positionTop;
        CGFloat percent = (1.0 - (p / m));
        CGFloat result = percent * alphaMax;
        
        self.shadowButton.alpha = result;
    } else {
        self.shadowButton.alpha = 0.0;
    }
}

#pragma mark - Change FooterView Position
- (void)changeFooterView {
    [self changeFooterViewWithPosition:0];
}

- (void)changeFooterViewWithPosition:(CGFloat)position {
    if (!_footerView) {
        return;
    }
    
    CGFloat pos = position ? : [self positionMoveFromWithType:self.moveType];
    
    CGFloat header = self.headerView.frame.size.height;
    CGFloat rr = self.deviceHeight - header - self.footerView.frame.size.height;
    CGFloat result = ((rr - pos) - self.layout.footerPadding);
    
    CGFloat footerViewPositionDefault = (self.deviceHeight - self.footerView.frame.size.height);
    
    CGFloat originY;
    if (result < 0) {
        originY = footerViewPositionDefault + (result * (-1));
    } else {
        originY = footerViewPositionDefault;
    }
    self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, originY, self.footerView.frame.size.width, self.footerView.frame.size.height);
}

#pragma mark - Animation Spring + Force
- (void)animationSpringFromWithForce:(CGFloat)force type:(KYContainerMoveType)type animations:(dispatch_block_t)animations completion:(dispatch_block_t)completion {
    CGFloat velocity = 0;
    CGFloat transformY = self.view.transform.ty;
    
    if (type == KYContainerMoveTypeTop) {
        if (force < 0) {
            velocity = force * (-1);
        }
    } else if (type == KYContainerMoveTypeBottom) {
        velocity = force;
    } else if (type == KYContainerMoveTypeMiddle) {
        if (force < 0) {
            velocity = force * (-1);
        } else {
            velocity = force;
        }
    }
    
    velocity = velocity / 10000;
    velocity = velocity * 300;
    
    if (type == KYContainerMoveTypeTop) {
        if ((transformY - self.positionTop) < 0) {
            velocity = velocity * (-1);
        }
    } else if (type == KYContainerMoveTypeBottom) {
        if ((transformY - self.positionBottom) > 0) {
            velocity = velocity * (-1);
        }
    }
    
    CGFloat positionY = 0;
    
    if (type == KYContainerMoveTypeTop) {
        positionY = transformY - self.positionTop;
    } else if (type == KYContainerMoveTypeBottom) {
        positionY = transformY - self.positionBottom;
    } else if (type == KYContainerMoveTypeMiddle) {
        positionY = transformY - self.positionMiddle;
    } else if (type == KYContainerMoveTypeHide) {
        positionY = transformY - self.deviceHeight;
    }
    
    if (positionY < 0) {
        positionY = positionY * (-1);
    }
    
    CGFloat damping = 0.75;
    CGFloat duration = 0.65;
    
    CGFloat percent = (1.0 - (transformY / self.deviceHeight));
    
    if (positionY > 350) {
        velocity = (velocity * percent) / 3.5;
        if (velocity > 6.5 && velocity < 13.5) {
            if (velocity < 9.0) {
                velocity = 6.5;
            } else {
                velocity = 13.5;
            }
        }
        
        damping = 0.8;
        duration = 0.45;
    } else if (positionY > 200) {
        velocity = (velocity * percent) / 2.0;
        if (velocity > 6.5 && velocity < 13.5) {
            if (velocity < 9.0) {
                velocity = 6.5;
            } else {
                velocity = 13.5;
            }
        }
        
        damping = 0.8;
        duration = 0.45;
    } else if (positionY > 150) {
        damping = 0.7;
        duration = 0.55;
        
        velocity = (velocity * percent) / 2.5;
        
        if (velocity > 4.7 && velocity < 8.6) {
            if (velocity < 6.5) {
                velocity = 8.6;
            } else {
                velocity = 4.7;
            }
        }
    } else if (positionY > 100) {
        velocity = (velocity * percent) / 2.0;
    } else if (positionY > 50) {
        velocity = velocity / 1.5;
    } else if (positionY > 25) {
//        velocity = velocity * 1.5;
    } else if (positionY > 10) {
        velocity = velocity * 1.5;
    } else {
        velocity = velocity * 3.0;
    }
    
    if (duration == 0.65 && damping == 0.75) {
        if (velocity > 4.3 && velocity < 7.4) {
            if (velocity < 5.85) {
                velocity = 7.4;
            } else {
                velocity = 4.3;
            }
        }
    }
    
    CADisplayLink *displayLink;
    if (self.layout.trackingPosition) {
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationDidUpdateWithDisplayLink:)];
        if (@available(iOS 10.0, *)) {
            displayLink.preferredFramesPerSecond = 60;
        } else {
            // Fallback on earlier versions
        }
        [displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSDefaultRunLoopMode];
    }
    
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:damping initialSpringVelocity:velocity options:UIViewAnimationOptionAllowUserInteraction animations:animations completion:^(BOOL finished) {
            if (displayLink) {
                [displayLink invalidate];
            }
            if (completion) {
                completion();
            }
    }];
}

#pragma mark - Gesture Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}
#pragma mark - Table Delegate

#pragma mark - Table DataSource

#pragma mark - Collection Delegate

#pragma mark - Collection DataSource

#pragma mark - Collection DelegateFlowLayout

#pragma mark - Scroll Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UIPanGestureRecognizer *gesture = scrollView.panGestureRecognizer;
    
    CGFloat inViewVelocityY = [gesture velocityInView:self.view].y;
    CGFloat inViewTranslationY = [gesture translationInView:self.view].y;
    
    if (gesture.state != UIGestureRecognizerStatePossible && scrollView.contentOffset.y <= 0) {
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    } else {
        scrollView.showsVerticalScrollIndicator = YES;
    }
    
    if (scrollView.contentOffset.y == 0 && inViewVelocityY > 0) {
        self.scrollBordersRunContainer = YES;
    } else {
        self.scrollBordersRunContainer = NO;
    }
    
    self.scrollTransform = self.view.transform;
    
    CGFloat top = self.positionTop;
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.scrollOnceBeginDragging = NO;
    }
    
    if (self.scrollBordersRunContainer) {
        [self.view.layer removeAllAnimations];
        
        self.scrollOnceEnded = NO;
        self.scrollOnceBeginDragging = NO;
        
        CGFloat ty = ((top - self.scrollStartPosition) + inViewTranslationY);
        
        if (ty < top) {
            ty = top;
            CGAffineTransform transform;
            transform.a = self.scrollTransform.a;
            transform.b = self.scrollTransform.b;
            transform.c = self.scrollTransform.c;
            transform.d = self.scrollTransform.d;
            transform.tx = self.scrollTransform.tx;
            transform.ty = ty;
            self.scrollTransform = transform;
        }
        
        if (self.scrollBegin) {
            __weak typeof(self) weakSelf = self;
            [self animationSpringWithDuration:0.325 animations:^{
                            __strong typeof(self) strongSelf = weakSelf;
                            if (!strongSelf) {
                                return;
                            }
                            [strongSelf changeViewWithTransform:strongSelf.scrollTransform];
            }];
            
            self.scrollBegin = NO;
        } else {
            [self changeViewWithTransform:self.scrollTransform];
        }
        
        CGFloat position = self.scrollTransform.ty;
        KYContainerMoveType type = KYContainerMoveTypeTop;
        KYContainerFromType from = KYContainerFromTypeScrollBorder;
        BOOL animation = NO;
        
        [self shadowLevelAlphaWithPosition:position animation:NO];
        [self changeFooterViewWithPosition:position];
        [self calculationScrollViewHeightWithFrom:from];
        [self changeMoveWithPosition:position type:type animation:animation];
        
        if (gesture.state == UIGestureRecognizerStateEnded) {
            [self moveWithType:ty animation:YES velocity:inViewVelocityY from:from];
        }
    } else {
        if (top == self.scrollTransform.ty && !self.scrollOnceBeginDragging) {
            self.scrollOnceBeginDragging = YES;
        }
        
        if (top < self.scrollTransform.ty) {
            if (inViewVelocityY < 0.0) {
                if (self.moveType == KYContainerMoveTypeTop) {
                    scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
                }
                
                self.scrollTransform = self.view.transform;
                CGFloat ty = ((top - self.scrollStartPosition) + inViewTranslationY);
                
                if (ty < top) {
                    ty = top;
                    CGAffineTransform transform;
                    transform.a = self.scrollTransform.a;
                    transform.b = self.scrollTransform.b;
                    transform.c = self.scrollTransform.c;
                    transform.d = self.scrollTransform.d;
                    transform.tx = self.scrollTransform.tx;
                    transform.ty = ty;
                    self.scrollTransform = transform;
                }
                
                CGFloat position = self.scrollTransform.ty;
                KYContainerMoveType type = KYContainerMoveTypeTop;
                KYContainerFromType from = KYContainerFromTypeScroll;
                BOOL animation = NO;
                
                [self changeViewWithTransform:self.scrollTransform];
                [self shadowLevelAlphaWithPosition:position animation:NO];
                [self changeFooterViewWithPosition:position];
                [self calculationScrollViewHeightWithFrom:from];
                [self changeMoveWithPosition:position type:type animation:animation];
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isScrolling = YES;
    
    self.scrollStartPosition = scrollView.contentOffset.y;
    
    self.scrollBegin = YES;
    
    if (self.scrollStartPosition < 0) {
        self.scrollStartPosition = 0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isScrolling = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.isScrolling = NO;
    }
    
    UIPanGestureRecognizer *gesture = scrollView.panGestureRecognizer;
    
    CGFloat inViewVelocityY = [gesture velocityInView:self.view].y;
    
    if (!self.scrollOnceEnded) {
        self.scrollOnceEnded = YES;
        
        KYContainerMoveType type = [self calculatePositionTypeFromWithVelocity:inViewVelocityY];
        
        [self moveWithType:type velocity:inViewVelocityY];
    }
}

@end
