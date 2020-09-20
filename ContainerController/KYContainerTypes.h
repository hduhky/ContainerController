//
//  KYContainerTypes.h
//  ContainerController
//
//  Created by 黄珂耀 on 2020/9/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    KYContainerMoveTypeTop,
    KYContainerMoveTypeMiddle,
    KYContainerMoveTypeBottom,
    KYContainerMoveTypeHide,
    KYContainerMoveTypeCustom
} KYContainerMoveType;

typedef enum : NSUInteger {
    KYContainerFromTypePan,
    KYContainerFromTypeScroll,
    KYContainerFromTypeScrollBorder,
    KYContainerFromTypeRotation,
    KYContainerFromTypeTracking,
    KYContainerFromTypeCustom
} KYContainerFromType;

@interface KYContainerTypes : NSObject

@end

NS_ASSUME_NONNULL_END
