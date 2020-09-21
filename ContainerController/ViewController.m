//
//  ViewController.m
//  ContainerController
//
//  Created by 黄珂耀 on 2020/9/19.
//

#import "ViewController.h"
#import "KYContainerController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

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
    self.container = container;
    container.view.cornerRadius = 15;
    [container.view addShadow];
    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    [container addScrollView:tableView];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"No:%@", @(indexPath.row)];
    return cell;
}

#pragma mark - Scroll Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.container scrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.container scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.container scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.container scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}



@end
