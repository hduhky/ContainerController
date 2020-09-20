//
//  KYContainerDevice.m
//  ContainerController
//
//  Created by 黄珂耀 on 2020/9/19.
//

#import "KYContainerDevice.h"

@implementation KYContainerDevice

#pragma mark - Size
+ (CGFloat)width {
    return UIScreen.mainScreen.bounds.size.width;
}

+ (CGFloat)height {
    return UIScreen.mainScreen.bounds.size.height;
}

+ (CGRect)frame {
    return CGRectMake(0, 0, [self width], [self height]);
}

#pragma mark - Max/Min
+ (CGFloat)screenMax {
    return MAX([self width], [self height]);
}

+ (CGFloat)screenMin {
    return MIN([self width], [self height]);
}

#pragma mark - Type
+ (BOOL)isIpad {
    return UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

+ (BOOL)isIphone {
    return UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

+ (BOOL)isRetina {
    return UIScreen.mainScreen.scale >= 2.0;
}

+ (BOOL)isIphone4 {
    return [self isIphone] && [self screenMax] < 568.0;
}

+ (BOOL)isIphone5 {
    return [self isIphone] && [self screenMax] == 568.0;
}

+ (BOOL)isIphone8 {
    return [self isIphone] && [self screenMax] == 667.0;
}

+ (BOOL)isIphone8P {
    return [self isIphone] && [self screenMax] == 736.0;
}

+ (BOOL)isIphone11P {
    return [self isIphone] && [self screenMax] == 812.0;
}

+ (BOOL)isIphone11 {
    return [self isIphone] && [self screenMax] == 896.0;
}

+ (BOOL)isIpad9_7 {
    return [self isIpad] && [self screenMax] == 1024.0;
}

+ (BOOL)isIpad10_2 {
    return [self isIpad] && [self screenMax] == 1080.0;
}

+ (BOOL)isIpad10_5 {
    return [self isIpad] && [self screenMax] == 1112.0;
}

+ (BOOL)isIpad11 {
    return [self isIpad] && [self screenMax] == 1194.0;
}

+ (BOOL)isIpad12_9 {
    return [self isIpad] && [self screenMax] == 1366.0;
}

+ (BOOL)isBigIphone {
    return [self isIphone] && [self screenMax] > 568.0;
}

+ (BOOL)isIphoneX {
    return [self isIphone] && [self screenMax] > 736.0;
}

#pragma mark - X Padding
+ (CGFloat)isIphoneXTop {
    return [self isIphoneX] ? 24.0 : 0.0;
}

+ (CGFloat)isIphoneXBottom {
    return [self isIphoneX] ? 34.0 : 0.0;
}

#pragma mark - StatusBar Height
+ (CGFloat)statusBarHeight {
    return 0;
}

#pragma mark - Orientation
+ (BOOL)isPortrait {
    BOOL portrait = NO;

    CGSize size = UIScreen.mainScreen.bounds.size;
    if (size.width / size.height > 1) {
        portrait = NO;
    } else {
        portrait = YES;
    }
    switch (UIDevice.currentDevice.orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            portrait = NO;
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            portrait = YES;
        default:
            break;
    }
    return portrait;
}

+ (UIInterfaceOrientation)statusBarOrientation {
    CGFloat height = 0;
    if (@available(iOS 13.0, *)) {
        height =  UIApplication.sharedApplication.keyWindow.windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
        height = UIApplication.sharedApplication.statusBarFrame.size.height;
    }
    return height;
}

+ (Orientation)orientation {
    if ([self isPortrait]) {
        return OrientationPortrait;
    } else {
        UIInterfaceOrientation statusBarOrientation = [self statusBarOrientation];
        if (statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
            return OrientationLandscapeLeft;
        } else if (statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
            return OrientationLandscapeRight;
        }
        return OrientationLandscapeLeft;
    }
}

@end
