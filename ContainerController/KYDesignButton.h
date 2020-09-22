//
//  KYDesignButton.h
//  ContainerController
//
//  Created by smb-lsp on 2020/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface KYDesignButton : UIButton

@property (nonatomic, readwrite, assign) IBInspectable BOOL hideAnimation;

@property (nonatomic, readwrite, strong) IBInspectable UIColor *fillColor;

@property (nonatomic, readwrite, strong) IBInspectable UIColor *gradientColor;
@property (nonatomic, readwrite, assign) IBInspectable CGPoint gradientOffset;

@property (nonatomic, readwrite, assign) IBInspectable CGFloat cornerRadius;

@property (nonatomic, readwrite, strong) IBInspectable UIColor *shadowColor;
@property (nonatomic, readwrite, assign) IBInspectable CGSize shadowOffset;
@property (nonatomic, readwrite, assign) IBInspectable CGFloat shadowRadius;
@property (nonatomic, readwrite, assign) IBInspectable CGFloat shadowOpacity;

@property (nonatomic, readwrite, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, readwrite, assign) IBInspectable CGFloat borderWidth;

@end

NS_ASSUME_NONNULL_END
