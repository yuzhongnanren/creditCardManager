//
//  MyCreditCardViewController.m
//  creditManager
//
//  Created by haodai on 16/3/16.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "MyCreditCardViewController.h"
#import "MyCreditCardTableViewCell.h"
#import "MyCredit.h"
#import "MJExtension.h"
#import "BangCreditTableViewController.h"
#import "ZYNotificationManager.h"
#import "ModificationTableViewController.h"

@interface MyCreditCardViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *creditNum;
@property (weak, nonatomic) IBOutlet UILabel *creditLimit;
@property (weak, nonatomic) IBOutlet UILabel *freeDay;
@property (weak, nonatomic) IBOutlet UIImageView *userIMg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation MyCreditCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的信用卡";

    [MobClick event:@"myCredit"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    [MyCredit mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
       return @{@"card_id" : @"id"};
    }];
    ViewRadius(_userIMg, _userIMg.width/2);
    if (![[ZYCacheManager shareInstance].user.photoPath isEqualToString:@""]) {
        [_userIMg sd_setImageWithURL:[NSURL URLWithString:[ZYCacheManager shareInstance].user.photoPath]];
    }
    if ([[ZYCacheManager shareInstance].user.nickname isEqualToString:@""]) {
        _name.text  = [ZYCacheManager shareInstance].user.telephone;
    }else {
        _name.text = [ZYCacheManager shareInstance].user.nickname;
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self feachData:YES];
}


- (void)feachData:(BOOL)b {
    [[HTTPClientManager manager] POST:@"UserCenter/get_bind_card_list?" dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid),@"has_list":@"1"} success:^(id responseObject) {
        _creditNum.text =  [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"count"]];
        _creditLimit.text =  [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"total_amount"]];
        _freeDay.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"free_interest_time"]];
        self.dataSource =  [MyCredit mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"items"]];
        if ([[responseObject objectForKey:@"recent_bank"] count] == 0) {
            
        }else {
            _tip.text = @"您的信用卡即将逾期，请尽快还款";
        }
        if ([[responseObject objectForKey:@"count"] integerValue] == 0) {
            _tip.text = @"您还未绑卡";
        }else {
            _tip.text = [NSString stringWithFormat:@"您已绑卡%@张",[responseObject objectForKey:@"count"]];
        }
         [self.tableView reloadData];
       
    } failure:^(NSError *error) {
        
    } view:mKeyWindow progress:b];
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        return cell;
    }
    MyCreditCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.credit = self.dataSource[indexPath.row - 1];
    cell.index = indexPath.row - 1;
    @weakify(self);
    cell.tapSwitch = ^(BOOL on, NSInteger index) {
        NSLog(@"%d -- %ld",on,(long)index);
        @strongify(self);
        [self postPayStatus:on credit:self.dataSource[index]];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 115.f;
    }
    return 190.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self addCreditCard];
    }else {
//      [self editCredit:indexPath.row];
        [self modifaiction:indexPath.row];
    }
}


- (void)postPayStatus:(BOOL)on credit:(MyCredit*)credit {
    [[HTTPClientManager manager] POST:@"UserCenter/change_bind_card_status?" dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid),@"id":credit.card_id,@"status":@(on)} success:^(id responseObject) {
        if (on) {
            [MobClick event:@"payStutasYes" attributes:@{@"bankName":credit.bank_name,@"creditId":[NSString stringWithFormat:@"%@",credit.card_id]}];
        }
        credit.status = [NSString stringWithFormat:@"%d",on];
        [self feachData:NO];
//      [[ZYNotificationManager shareInstance] closeLocalNotificationBankId:[credit.bank_id integerValue]];
    } failure:^(NSError *error) {
        [self.tableView reloadData];
    } view:mKeyWindow progress:YES];
}


- (void)addCreditCard {
    [MobClick event:@"addCredit"];
    BangCreditTableViewController *bang = StoryBoardDefined(@"BangCreditTableViewController");
    bang.type = Bang_Credit;
    [self.navigationController pushViewController:bang animated:YES];
}
//跳转详细界面
- (void)modifaiction:(NSInteger)index{
    ModificationTableViewController *modification = StoryBoardDefined(@"ModificationTableViewController");
    modification.creditCard = [self.dataSource objectAtIndex:index - 1];
    [self.navigationController pushViewController:modification animated:YES];
}
- (void)editCredit:(NSInteger)index {
    [MobClick event:@"editCredit"];
    BangCreditTableViewController *bang = StoryBoardDefined(@"BangCreditTableViewController");
    bang.type = Edit_Credit;
    bang.creditCard = [self.dataSource objectAtIndex:index - 1];
    [self.navigationController pushViewController:bang animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
