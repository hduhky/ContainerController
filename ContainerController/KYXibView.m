//
//  KYXibView.m
//  ContainerController
//
//  Created by smb-lsp on 2020/9/22.
//

#import "KYXibView.h"

@implementation KYXibView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _contentView = [self fromNib];
        [self loadedFromNib];
    }
    return self;
}

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _contentView = [self fromNib];
        [self loadedFromNib];
    }
    return self;
}

- (void)loadedFromNib {
    
}

- (UIView *)fromNibWithoutConstraints {
    UIView *contentView = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    if (!contentView) {
        return nil;
    }

    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:contentView];
    return contentView;
}

- (UIView *)fromNib {
    UIView *contentView = [self fromNibWithoutConstraints];
    if (!contentView) {
        return nil;
    }
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    
    [self addConstraints:@[bottomConstraint, trailingConstraint, topConstraint, leadingConstraint]];
    
    return contentView;
}

@end
