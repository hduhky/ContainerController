//
//  ViewController.m
//  ContainerController
//
//  Created by 黄珂耀 on 2020/9/19.
//

#import "ViewController.h"
#import "KYContainerController.h"

@interface ViewController () <KYContainerControllerDelegate>

@property (nonatomic, readwrite, strong) KYContainerController *container;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KYContainerLayout *layout = [[KYContainerLayout alloc] init];
    layout.startPosition = KYContainerMoveTypeHide;
    layout.backgroundShadowShow = YES;
    layout.positions = [KYContainerPosition positionWithTop:70 middle:250 bottom:70];
    
    KYContainerController *container = [[KYContainerController alloc] initWithViewController:self layout:layout];
    container.view.cornerRadius = 15;
    [container.view addShadow];
    [container moveWithType:KYContainerMoveTypeTop];
    container.delegate = self;
    container.shadowButton.userInteractionEnabled = YES;
    self.container = container;
}

- (void)containerControllerShadowClickWithContainerController:(KYContainerController *)containerController {
    [containerController removeWithCompletion:^{}];
}

@end
