//
//  BankTelTableViewController.m
//  creditManager
//
//  Created by haodai on 16/3/25.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "BankTelTableViewController.h"

@interface BankTelTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tel2;
@property (weak, nonatomic) IBOutlet UILabel *tel1;

@end

@implementation BankTelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    
    self.title = [self.dic objectForKey:@"bank_name"];
    if ([[self.dic objectForKey:@"bank_num"] count] == 1) {
        _tel1.text = [[self.dic objectForKey:@"bank_num"] objectAtIndex:0];
    }else if([[self.dic objectForKey:@"bank_num"] count] != 0){
        _tel1.text = [[self.dic objectForKey:@"bank_num"] objectAtIndex:0];
        _tel2.text = [[self.dic objectForKey:@"bank_num"] objectAtIndex:1];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        TelephoneWithNumber(mKeyWindow, _tel1.text);
    }else {
        TelephoneWithNumber(mKeyWindow, _tel2.text);
    }
}

@end
