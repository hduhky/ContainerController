//
//  KYContainerDevice.h
//  ContainerController
//
//  Created by 黄珂耀 on 2020/9/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    OrientationPortrait,
    OrientationLandscapeLeft,
    OrientationLandscapeRight,
} Orientation;

@interface KYContainerDevice : NSObject

#pragma mark - Size
+ (CGFloat)width;
+ (CGFloat)height;

+ (CGRect)frame;

#pragma mark - Max/Min
+ (CGFloat)screenMax;
+ (CGFloat)screenMin;

#pragma mark - Type
+ (BOOL)isIpad;
+ (BOOL)isIphone;
+ (BOOL)isRetina;

+ (BOOL)isIphone4;
+ (BOOL)isIphone5;
+ (BOOL)isIphone8;
+ (BOOL)isIphone8P;
+ (BOOL)isIphone11P;
+ (BOOL)isIphone11;

+ (BOOL)isIpad9_7;
+ (BOOL)isIpad10_2;
+ (BOOL)isIpad10_5;
+ (BOOL)isIpad11;
+ (BOOL)isIpad12_9;

+ (BOOL)isBigIphone;
+ (BOOL)isIphoneX;

#pragma mark - X Padding
+ (CGFloat)isIphoneXTop;
+ (CGFloat)isIphoneXBottom;

#pragma mark - StatusBar Height
+ (CGFloat)statusBarHeight;

#pragma mark - Orientation
+ (BOOL)isPortrait;
+ (UIInterfaceOrientation)statusBarOrientation;
+ (Orientation)orientation;

@end

NS_ASSUME_NONNULL_END
