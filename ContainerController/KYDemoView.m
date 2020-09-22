//
//  KYDemoView.m
//  ContainerController
//
//  Created by smb-lsp on 2020/9/22.
//

#import "KYDemoView.h"

@interface KYDemoView ()

@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorHeight;

@end

@implementation KYDemoView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.separatorView.backgroundColor = UIColor.greenColor;
    self.separatorHeight.constant = 10;
}

- (IBAction)buttonClicked:(id)sender {
    
}


@end
