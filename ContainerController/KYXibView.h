//
//  KYXibView.h
//  ContainerController
//
//  Created by smb-lsp on 2020/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYXibView : UIView

@property (nonatomic, weak) UIView *contentView;

- (void)loadedFromNib;

@end

NS_ASSUME_NONNULL_END
