//
//  KYDemoTableViewController.m
//  ContainerController
//
//  Created by smb-lsp on 2020/11/3.
//

#import "KYDemoTableViewController.h"

@interface KYDemoTableViewController ()

@end

@implementation KYDemoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"No:%@", @(indexPath.row)];
    return cell;
}

@end
