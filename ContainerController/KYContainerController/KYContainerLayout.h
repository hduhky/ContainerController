//
//  KYContainerLayout.h
//  ContainerController
//
//  Created by 黄珂耀 on 2020/9/19.
//

#import <UIKit/UIKit.h>
#import "KYContainerTypes.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Position
@interface KYContainerPosition : NSObject

@property (nonatomic, readwrite, assign) CGFloat top;
@property (nonatomic, readwrite, assign) CGFloat middle;
@property (nonatomic, readwrite, assign) CGFloat bottom;
+ (KYContainerPosition *)zero;
+ (KYContainerPosition *)positionWithTop:(CGFloat)top middle:(CGFloat)middle bottom:(CGFloat)bottom;
- (instancetype)initWithTop:(CGFloat)top middle:(CGFloat)middle bottom:(CGFloat)bottom;

@end

#pragma mark - Insets

@interface KYContainerInsets : NSObject

@property (nonatomic, readwrite, assign) CGFloat left;
@property (nonatomic, readwrite, assign) CGFloat right;
+ (KYContainerInsets *)zero;
+ (KYContainerInsets *)insetsWithLeft:(CGFloat)left right:(CGFloat)right;
- (instancetype)initWithLeft:(CGFloat)left right:(CGFloat)right;

@end

#pragma mark - Layout
@interface KYContainerLayout : NSObject

@property (nonatomic, readwrite, assign) KYContainerMoveType startPosition;

@property (nonatomic, readwrite, assign) BOOL movingEnabled;

@property (nonatomic, readwrite, assign) BOOL swipeToHide;

@property (nonatomic, readwrite, assign) CGFloat footerPadding;

@property (nonatomic, readwrite, assign) BOOL trackingPosition;

@property (nonatomic, readwrite, assign) UIEdgeInsets scrollInsets;

@property (nonatomic, readwrite, assign) UIEdgeInsets scrollIndicatorInsets;

@property (nonatomic, readwrite, assign) BOOL backgroundShadowShow;

@property (nonatomic, readwrite, strong) KYContainerPosition *positions;

@property (nonatomic, readwrite, strong) KYContainerInsets *insets;

@property (nonatomic, readwrite, assign) BOOL landscapeBackgroundShadowShow;

@property (nonatomic, readwrite, strong) KYContainerPosition *landscapePositions;

@property (nonatomic, readwrite, strong) KYContainerInsets *landscapeInsets;

@end

NS_ASSUME_NONNULL_END
