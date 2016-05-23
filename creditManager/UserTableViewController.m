//
//  UserTableViewController.m
//  creditManager
//
//  Created by haodai on 16/3/1.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "UserTableViewController.h"
#import "MyCreditCardViewController.h"
#import "JCCBaseWebViewController.h"
#import "BangCreditTableViewController.h"

@interface UserTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *creditTip;
@property (weak, nonatomic) IBOutlet UIButton *bangCard;

@end

@implementation UserTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    ViewRadius(_userImg, _userImg.width/2);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick event:@"user"];
    [self feachData:NO];
    if (![[ZYCacheManager shareInstance].user.photoPath isEqualToString:@""]) {
        [_userImg sd_setImageWithURL:[NSURL URLWithString:[ZYCacheManager shareInstance].user.photoPath]];
    }else {
        _userImg.image = [UIImage imageNamed:@"my_head"];
    }
    if ([[ZYCacheManager shareInstance].user.nickname isEqualToString:@""]) {
        _name.text  = [ZYCacheManager shareInstance].user.telephone;
    }else {
        _name.text = [ZYCacheManager shareInstance].user.nickname;
    }
    
}

- (void)feachData:(BOOL)b {
    [[HTTPClientManager manager] POST:@"UserCenter/get_bind_card_list?" dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid),@"has_list":@"0"} success:^(id responseObject) {
        if ([[responseObject objectForKey:@"recent_bank"] count] == 0) {
           
        }else {
            _creditTip.text = @"您的信用卡即将逾期，请尽快还款";
        }
        if ([[responseObject objectForKey:@"count"] integerValue] == 0) {
            _bangCard.hidden = NO;
            _creditTip.text = @"您还未绑卡";
        }else {
            _bangCard.hidden = YES;
            _creditTip.text = [NSString stringWithFormat:@"您已绑卡%@张",[responseObject objectForKey:@"count"]];
        }
    } failure:^(NSError *error) {
        
    } view:self.view progress:b];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 140.f;
    }
    if (IS_IPHONE_6 || IS_IPHONE_6P) {
        return 70.f;
    }
    return 53.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [MobClick event:@"gerenziliao"];
    }else if(indexPath.row == 1) {
        [MobClick event:@"anquanshezhi"];
    }else if(indexPath.row == 2) {
        [MobClick event:@"yonghufankui"];
    }else if (indexPath.row == 3) {
        [MobClick event:@"pingfen"];
        [self enterScore];
    }else if (indexPath.row == 4) {
        [MobClick event:@"guanyuwomen"];
        [self enterAbout];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Action
- (IBAction)bangCredit:(id)sender {
    BangCreditTableViewController *bang = StoryBoardDefined(@"BangCreditTableViewController");
    bang.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bang animated:YES];
}


- (void)enterUserMessage {
    
}

- (void)enterSecuritySetting {
    
}

- (void)enterUserFeedback {
    
}

- (void)enterScore {
    [[AppFun sharedInstance] rateApp];
}

- (void)enterAbout {
    JCCBaseWebViewController *web = [[JCCBaseWebViewController alloc] init];
    web.url = [BaseUrl stringByAppendingPathComponent:[NSString stringWithFormat:@"Home/Index/about?version=%@",mAPPVersion]];
    web.title = @"关于我们";
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}


@end
