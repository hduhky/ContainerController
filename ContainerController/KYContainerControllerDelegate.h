//
//  KYContainerControllerDelegate.h
//  ContainerController
//
//  Created by 黄珂耀 on 2020/9/19.
//

#import <UIKit/UIKit.h>
#import "KYContainerTypes.h"

NS_ASSUME_NONNULL_BEGIN

@class KYContainerController;

@protocol KYContainerControllerDelegate <NSObject>

- (void)containerControllerRotationWithContainerController:(KYContainerController *)containerController;

- (void)containerControllerShadowClickWithContainerController:(KYContainerController *)containerController;

- (void)containerControllerMoveWithContainerController:(KYContainerController *)containerController position:(CGFloat)position type:(KYContainerMoveType)type animation:(BOOL)animation;

@end

@interface UIViewController ()

- (void)containerControllerRotationWithContainerController:(KYContainerController *)containerController;

- (void)containerControllerShadowClickWithContainerController:(KYContainerController *)containerController;

- (void)containerControllerMoveWithContainerController:(KYContainerController *)containerController position:(CGFloat)position type:(KYContainerMoveType)type animation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
