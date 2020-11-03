//
//  ViewController.m
//  ContainerController
//
//  Created by 黄珂耀 on 2020/9/19.
//

#import "ViewController.h"
#import "KYContainerController.h"
#import "KYDemoView.h"
#import "KYDemoTableViewController.h"
#import "KYDemoTableViewController+KYContainerHelper.h"

@interface ViewController ()

@property (nonatomic, readwrite, strong) KYContainerController *container;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KYDemoView *view = [[KYDemoView alloc] init];
    view.frame = CGRectMake(0, 200, KYContainerDevice.width, 200);
    [self.view addSubview:view];
    
    KYContainerLayout *layout = [[KYContainerLayout alloc] init];
    layout.startPosition = KYContainerMoveTypeHide;
    layout.backgroundShadowShow = YES;
    layout.positions = [KYContainerPosition positionWithTop:50 middle:250 bottom:70];

    KYContainerController *container = [[KYContainerController alloc] initWithViewController:self layout:layout];
    self.container = container;
    container.view.cornerRadius = 15;
    [container.view addShadow];
    
    KYDemoTableViewController *tableViewController = [[KYDemoTableViewController alloc] init];
    tableViewController.container = self.container;
    [self addChildViewController:tableViewController];
    [container addScrollView:tableViewController.tableView];

    UIButton *header = [UIButton buttonWithType:UIButtonTypeSystem];
    header.frame = CGRectMake(0, 0, 375, 60);
    [header setBackgroundColor:[UIColor greenColor]];
    [container addHeaderView:header];

    UIButton *footer = [UIButton buttonWithType:UIButtonTypeSystem];
    footer.frame = CGRectMake(0, 0, 375, 60);
    [footer setBackgroundColor:[UIColor greenColor]];
    [container addFooterView:footer];

    [container moveWithType:KYContainerMoveTypeTop];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.container remove];
    self.container = nil;
}

@end
