//
//  CardServerTableViewController.m
//  creditManager
//
//  Created by haodai on 16/3/25.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "CardServerTableViewController.h"
#import "CreditProgressViewController.h"
#import "JCCBaseWebViewController.h"
#import "StagingCalculatorViewController.h"
#import "MyCreditCardViewController.h"
#import "ZYControllerManager.h"

@interface CardServerTableViewController ()

@end

@implementation CardServerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"creditCardServer"];
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
        if ([ZYCacheManager shareInstance].user.isLogin) {
            MyCreditCardViewController *my = StoryBoardDefined(@"MyCreditCardViewController");
            [self.navigationController pushViewController:my animated:YES];
        }else {
            [[ZYControllerManager  manager] goLogin:self];
        }
    }else if (indexPath.row == 1) {
        CreditProgressViewController *credit = StoryBoardDefined(@"CreditProgressViewController");
        credit.type = 0;
        [self.navigationController pushViewController:credit animated:YES];
    }else if(indexPath.row == 2) {
        JCCBaseWebViewController *web = [[JCCBaseWebViewController alloc] init];
        web.url = @"http://www.kuaicha.info/creditCB.action?appKey=43c77046550741f4b80e2ccdc09d642b&appName=%e5%a5%bd%e8%b4%b7%e4%bf%a1%e7%94%a8%e5%8d%a1%e7%ae%a1%e5%ae%b6&loginType=IDCARD_PASSWORD&callBackURL=http://api.haodai.com/";
        web.hidesBottomBarWhenPushed = YES;
        web.off_Y = -40;
        web.webTitle = @"征信查询";
        web.type = 1;
        [self.navigationController pushViewController:web animated:YES];
    }else if(indexPath.row == 3) {
        CreditProgressViewController *credit = StoryBoardDefined(@"CreditProgressViewController");
        credit.type = 1;
        [self.navigationController pushViewController:credit animated:YES];
    }else if(indexPath.row == 4) {
        StagingCalculatorViewController *stage = StoryBoardDefined(@"StagingCalculatorViewController");
        [self.navigationController pushViewController:stage animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IPHONE_6P || IS_IPHONE_6) {
        return 70.f;
    }
    return 50.f;
}



@end
