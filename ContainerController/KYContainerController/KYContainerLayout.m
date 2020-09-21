//
//  KYContainerLayout.m
//  ContainerController
//
//  Created by 黄珂耀 on 2020/9/19.
//

#import "KYContainerLayout.h"

@implementation KYContainerPosition

+ (KYContainerPosition *)zero {
    return [self positionWithTop:0 middle:0 bottom:0];
}

+ (KYContainerPosition *)positionWithTop:(CGFloat)top middle:(CGFloat)middle bottom:(CGFloat)bottom {
    return [[self alloc] initWithTop:top middle:middle bottom:bottom];
}

- (instancetype)initWithTop:(CGFloat)top middle:(CGFloat)middle bottom:(CGFloat)bottom {
    self = [super init];
    if (self) {
        _top = top;
        _middle = middle;
        _bottom = bottom;
    }
    return self;
}

@end

@implementation KYContainerInsets

+ (KYContainerInsets *)zero {
    return [self insetsWithLeft:0 right:0];
}

+ (KYContainerInsets *)insetsWithLeft:(CGFloat)left right:(CGFloat)right {
    return [[self alloc] initWithLeft:left right:right];
}

- (instancetype)initWithLeft:(CGFloat)left right:(CGFloat)right {
    self = [super init];
    if (self) {
        _left = left;
        _right = right;
    }
    return self;
}


@end

@implementation KYContainerLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _startPosition = KYContainerMoveTypeHide;
        _movingEnabled = YES;
        _swipeToHide = NO;
        _footerPadding = 0.0;
        _trackingPosition = NO;
        _scrollInsets = UIEdgeInsetsZero;
        _scrollIndicatorInsets = UIEdgeInsetsZero;
        _backgroundShadowShow = NO;
        _positions = KYContainerPosition.zero;
        _insets = KYContainerInsets.zero;
    }
    return self;
}

@end
