//
//  CreditDetailViewController.m
//  creditManager
//
//  Created by haodai on 16/3/7.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "CreditDetailViewController.h"
#import "CreditTableViewCell.h"
#import "CreditDetailCell.h"
#import "JCCBaseWebViewController.h"
#import "CreditCardFormSubmit.h"

@interface CreditDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CreditCard *creditCard;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, assign) NSInteger bank_id;

@end

@implementation CreditDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信用卡详情";
    [MobClick event:@"tapHotCreditCard" attributes:@{@"cardId":[NSString stringWithFormat:@"%ld",(long)_card_id]}];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BackgroundColor;
//  [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self feachData];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)feachData {
    [[HTTPClientManager manager] POST:[NSString stringWithFormat:@"/credit/get_card_detail?card_id=%ld",(long)_card_id] dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid)} success:^(id responseObject) {
        self.dic = responseObject;
        self.creditCard = [[CreditCard alloc] init];
        self.creditCard.name = [responseObject objectForKey:@"name"];
        self.creditCard.img = [responseObject objectForKey:@"img"];
        self.creditCard.apply_count = [[responseObject objectForKey:@"apply_count"] integerValue];
        self.creditCard.descr = [responseObject objectForKey:@"descr"];
        self.creditCard.card_id = [[responseObject objectForKey:@"card_id"] integerValue];
        self.bank_id = [[responseObject objectForKey:@"bank_id"] integerValue];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}

#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([[self.dic objectForKey:@"youhui"] count] == 0) {
        return 2;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else if(section == 1) {
        return 6;
    }else if(section == 2) {
        return 2;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CreditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            if (self.creditCard) {
                 cell.credit = self.creditCard;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            return cell;
        }else {
            CreditDetailCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
            if (cell == nil) {
                cell = [[CreditDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            [cell setPrivileg:[self.dic objectForKey:@"privileg"]];
            return cell;
        }
    }else if(indexPath.section == 1) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            return cell;
        }else if(indexPath.row == 5) {
            CreditDetailCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"RateCell"];
            if (cell == nil) {
                cell = [[CreditDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RateCell"];
            }
            [cell setRates:[self.dic objectForKey:@"stages_rate_arr"]];
            cell.contentView.backgroundColor = BackgroundColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            CreditDetailCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
            if (cell == nil) {
                cell = [[CreditDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.dic) {
                switch (indexPath.row) {
                    case 1:
                    {
                        [cell setCardTitle:@"卡等级" content:[self.dic objectForKey:@"card_level"]];
                         cell.contentView.backgroundColor = BackgroundColor;
                    }
                        break;
                    case 2:
                    {
                        [cell setCardTitle:@"卡组织" content:[self.dic objectForKey:@"card_org"]];
                         cell.contentView.backgroundColor = [UIColor whiteColor];
                    }
                        break;
                    case 3:
                    {
                        [cell setCardTitle:@"年费" content:[self.dic objectForKey:@"annual_fee"]];
                         cell.contentView.backgroundColor = BackgroundColor;
                    }
                        break;
                    case 4:
                    {
                        [cell setCardTitle:@"免息期" content:[self.dic objectForKey:@"free_accrual_days"]];
                         cell.contentView.backgroundColor = [UIColor whiteColor];
                    }
                        break;
                    default:
                        break;
                }
            }
            return cell;

        }
    }else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            CreditDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.dic) {
               [cell setDiscountCredits:[self.dic objectForKey:@"youhui"]];
            }
            @weakify(self);
            cell.tapBlock = ^(NSInteger index) {
                @strongify(self);
                JCCBaseWebViewController *web = [[JCCBaseWebViewController alloc] init];
                NSInteger _id =  [[[[self.dic objectForKey:@"youhui"] objectAtIndex:index] objectForKey:@"id"] integerValue];
                web.url = [NSString stringWithFormat:@"%@Youhui/detail/city/%@/id/%ld",HTML5_URL,@"beijing",(long)_id];
                web.webTitle = @"优惠详情";
                [self.navigationController pushViewController:web animated:YES];
            };
            return cell;
        }
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 下面这几行代码是用来设置cell的上下行线的位置
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //按照作者最后的意思还要加上下面这一段，才能做到底部线控制位置，所以这里按stackflow上的做法添加上吧。
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 103.f;
        }else if(indexPath.row == 1) {
            if ([[self.dic objectForKey:@"privileg"] count] == 0) {
                return 0;
            }
            CGFloat height = 0.f;
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
            for (int i = 0; i < [[self.dic objectForKey:@"privileg"] count]; i++) {
                CGRect rect = [[[[self.dic objectForKey:@"privileg"] objectAtIndex:i] objectForKey:@"title"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15.f - 15.f - 5.f - 4.f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil];
                height += (rect.size.height + 15.f);
            }
            return height + 15.f;
        }
    }else if(indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 44.f;
        }else if (indexPath.row == 5){
            NSArray *rates = [self.dic objectForKey:@"stages_rate_arr"];
            CGFloat h = 8 + (15+8)*ceilf(rates.count/2.f) + 30.f;
            return h;
        }else {
            return 30.f;
        }
    }else {
        if (indexPath.row == 0) {
            return 44.f;
        }else {
            return 140.f;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.f;
}

#pragma mark - Action
- (IBAction)applyCredit:(id)sender {
    [MobClick event:@"applyCredit"];
    if ([[self.dic objectForKey:@"bank_apply"] integerValue] == 1) {
        //h5
        JCCBaseWebViewController *web = [[JCCBaseWebViewController alloc] init];
        web.url = [NSString stringWithFormat:@"http://yun.haodai.com/To/c/city/%@/bank_id/%@/card_id/%@/ref/%@/loader/1",[ZYCacheManager shareInstance].user.city_s_EN,[self.dic objectForKey:@"bank_id"],[self.dic objectForKey:@"card_id"],HTTP_Ref];
        web.webTitle = [self.dic objectForKey:@"bank_name"];
        [self.navigationController pushViewController:web animated:YES];
    }else {
        CreditCardFormSubmit *submit = StoryBoardDefined(@"CreditCardFormSubmit");
        submit.card_id = _card_id;
        submit.bank_id = _bank_id;
        [self.navigationController pushViewController:submit animated:YES];
    }
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
