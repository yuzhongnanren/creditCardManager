//
//  BankMessageTableViewController.m
//  creditManager
//
//  Created by haodai on 16/3/25.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "BankMessageTableViewController.h"
#import "BankTelTableViewController.h"

@interface BankMessageTableViewController ()
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation BankMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    
    [self feachData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)feachData {
    [[HTTPClientManager manager] POST:@"credit/get_bank_info?" dictionary:@{} success:^(id responseObject) {
        self.dataSource = [responseObject objectForKey:@"items"];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *tit = [cell viewWithTag:1000];
    tit.text = [self.dataSource[indexPath.row] objectForKey:@"bank_name"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BankTelTableViewController *tel = StoryBoardDefined(@"BankTelTableViewController");
    tel.dic = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:tel animated:YES];
}



@end
