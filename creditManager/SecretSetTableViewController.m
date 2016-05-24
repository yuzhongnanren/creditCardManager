//
//  SecretSetTableViewController.m
//  creditManager
//
//  Created by haodai on 16/3/24.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "SecretSetTableViewController.h"
#import "ZYControllerManager.h"
#import "UpdatePasswordTableViewController.h"
#import "ChangePassTableViewController.h"

@interface SecretSetTableViewController ()<UIAlertViewDelegate>

@end

@implementation SecretSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [MobClick event:@"mimaxiugai"];
        if ([[ZYCacheManager shareInstance].user.is_set_passwd integerValue] == 1) {
            UpdatePasswordTableViewController *pass = StoryBoardDefined(@"UpdatePasswordTableViewController");
            [self.navigationController pushViewController:pass animated:YES];
        }else {
            ChangePassTableViewController *pass = StoryBoardDefined(@"ChangePassTableViewController");
            [self.navigationController pushViewController:pass animated:YES];
        }
    }else if(indexPath.row == 1) {
        [MobClick event:@"genhuanshouji"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.f;
}

- (IBAction)exitLogin:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您确定要退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[HTTPClientManager manager] POST:@"/userLogin/logout" dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid)} success:^(id responseObject) {
            [MobClick event:@"tuichudenglu"];
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [ZYCacheManager shareInstance].user.isLogin = NO;
            [ZYCacheManager shareInstance].user.uid = 0;
            [ZYCacheManager shareInstance].user.telephone = @"";
            [ZYCacheManager shareInstance].user.photoPath = @"";
            [[ZYCacheManager shareInstance] deleteCreditForm];
            [[ZYCacheManager shareInstance] save];
            [self.navigationController popViewControllerAnimated:NO];
            [[ZYControllerManager manager] exitGoHome];
        } failure:^(NSError *error) {
            
        } view:self.view progress:YES];
    }
}

@end
