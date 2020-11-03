//
//  KYDemoTableViewController+KYContainerHelper.h
//  ContainerController
//
//  Created by smb-lsp on 2020/11/3.
//

#import "KYDemoTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class KYContainerController;
@interface KYDemoTableViewController (KYContainer)

@property (nonatomic, readwrite, strong) KYContainerController *container;

@end
NS_ASSUME_NONNULL_END
