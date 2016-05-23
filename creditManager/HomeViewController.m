//
//  HomeViewController.m
//  creditManager
//
//  Created by haodai on 16/2/26.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "HomeViewController.h"
#import "ImagePlayerView.h"
#import "HomeTableViewCell.h"
#import "JCCBaseWebViewController.h"
#import "MJExtension.h"
#import "HotBank.h"
#import "CreditCard.h"
#import "CreditProgressViewController.h"
#import "CreditListViewController.h"
#import "CityViewController.h"
#import "ZYNavigationViewController.h"
#import "CreditDetailViewController.h"
#import "MJRefresh.h"
#import "CardDiscountViewController.h"
#import "ZYNotificationManager.h"
#import "MyCreditCardViewController.h"

@interface HomeViewController () <UITableViewDataSource,UITableViewDelegate,ImagePlayerViewDelegate,CityViewControllerDelegate>

@property (weak, nonatomic) IBOutlet ImagePlayerView *adView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIButton *city;
/**
 *  是否提示用户还款
 */
@property (nonatomic, assign) BOOL isAttention;
@property (nonatomic, strong) NSArray *ads;
@property (nonatomic, strong) NSArray *hotBanks;
@property (nonatomic, strong) NSArray *hotCredits;
@property (nonatomic, strong) NSArray *discountCredits;

@property (nonatomic, strong) NSDictionary *bangCardDic;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.hidden = YES;
    @weakify(self);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        @strongify(self);
        [self updateData];
    }];

    [self setUp];
    [self setRightButton];
    
    [mNotificationCenter addObserver:self selector:@selector(updateCity) name:@"UpdateHomeData" object:nil];
    [self updateData];
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [mNotificationCenter removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick event:@"home"];
    if ([ZYCacheManager shareInstance].user.isLogin) {
        [self feachCreditList];
    }else {
        _isAttention = NO;
        [self.tableView reloadData];
    }
}

- (void)setUp {
    _isAttention = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BackgroundColor;
    _adView.scrollInterval = 5;
}

- (void)setRightButton {
     _city = [UIButton buttonWithType:UIButtonTypeCustom];
    [_city setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [_city setTitle:@"北京" forState:0];
    [_city setTitleColor:[UIColor whiteColor] forState:0];
    [_city setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [_city setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_city addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
     _city.titleLabel.font = [UIFont systemFontOfSize:13];
     _city.frame = CGRectMake(0, 0, 88, 44);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_city];
}

- (void)feachCreditList {
    [[HTTPClientManager manager] POST:@"UserCenter/get_bind_card_list?" dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid),@"has_list":@"0"} success:^(id responseObject) {
        self.bangCardDic = responseObject;
        if ([self.bangCardDic  objectForKey:@"count"] == 0) {
            _isAttention = YES;
        }else if([[self.bangCardDic objectForKey:@"recent_bank"] count] == 0) {
            _isAttention = NO;
        }else {
            _isAttention = YES;
        }
//        if ([[self.bangCardDic objectForKey:@"recent_bank"] count] != 0) {
//            NSInteger days = [[[self.bangCardDic objectForKey:@"recent_bank"] objectForKey:@"time_left"] integerValue];
//            NSInteger bankId = [[[self.bangCardDic objectForKey:@"recent_bank"] objectForKey:@"bank_id"] integerValue];
//            [[ZYNotificationManager shareInstance] registerLocalNotification:days bankId:bankId];
//        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view progress:NO];
}

- (void)updateCity {
     [_city setTitle:[ZYCacheManager shareInstance].user.city forState:0];
}

- (void)updateData {
    [self feathAdData];
    [self feathBankData];
    [self feathHotCredit];
    [self feathDiscountCredit];
    self.tableView.hidden = NO;
}

#pragma mark - Data
- (void)feathAdData { 
    [[HTTPClientManager manager] POST:@"credit/get_banner_list?" dictionary:@{} success:^(id responseObject) {
         self.ads = [responseObject objectForKey:@"items"];
        [_adView initWithCount:self.ads.count delegate:self];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}

- (void)feathBankData {
    [[HTTPClientManager manager] POST:@"credit/get_online_bank_list?" dictionary:@{} success:^(id responseObject) {
        self.hotBanks = [HotBank mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"items"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}

- (void)feathHotCredit {
    [[HTTPClientManager manager] POST:@"credit/get_card_list?page_size=2&sugest=1&" dictionary:@{} success:^(id responseObject) {
        self.hotCredits = [CreditCard mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"items"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}

- (void)feathDiscountCredit {
    [[HTTPClientManager manager] POST:@"credit/get_youhui_list?page_size=10&" dictionary:@{} success:^(id responseObject) {
        self.discountCredits = [responseObject objectForKey:@"items"];
        [self.tableView reloadData];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
    } view:self.view progress:YES];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isAttention) {
        return 5;
    }else  {
        return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isAttention) {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 1;
                break;
            case 2:
                return 1;
                break;
            case 3:
                return 3;
                break;
            case 4:
                return 2;
                break;
            default:
                break;
        }
    }else {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 1;
                break;
            case 2:
                return 3;
                break;
            case 3:
                return 2;
                break;
            default:
                break;
        }
    }
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = nil;
    if (_isAttention) {
        switch (indexPath.section) {
            case 0:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
                @weakify(self);
                cell.tapCloseTip = ^() {
                   @strongify(self);
                    [self closeTip];
                };
                if ([ZYCacheManager shareInstance].user.isLogin) {
                    if ([[self.bangCardDic objectForKey:@"recent_bank"] count] == 0) {
                        [cell setUserImage:[ZYCacheManager shareInstance].user.photoPath cardNum:[[self.bangCardDic  objectForKey:@"count"] integerValue] tip:@""];
                    }else {
                        [cell setUserImage:[ZYCacheManager shareInstance].user.photoPath cardNum:[[self.bangCardDic  objectForKey:@"count"] integerValue] tip:[[self.bangCardDic objectForKey:@"recent_bank"] objectForKey:@"bank_name"]];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            }
            case 1:
            {
                cell  = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
                cell.hotBanks = self.hotBanks;
                @weakify(self);
                cell.tapHotBlock = ^(NSInteger index) {
                    @strongify(self);
                    [self enterHotBank:index];
                };
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            }
            case 2:
            {
                cell  = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
                @weakify(self);
                cell.progressBlock = ^() {
                    @strongify(self);
                    [self enterProgressLookup];
                };
                cell.creditLookupBlock = ^ () {
                    @strongify(self);
                    [self enterCreditLookup];
                };
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            }
            case 3:
            {
                if (indexPath.row == 0) {
                    cell  = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else {
                    cell  = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
                    cell.credit = [self.hotCredits objectAtIndex:indexPath.row - 1];
                }
                break;
            }
            case 4:
            {
                if (indexPath.row == 0) {
                    cell  = [tableView dequeueReusableCellWithIdentifier:@"cell6"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if(indexPath.row == 1) {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"cell7"];
                    cell.discountCredits = self.discountCredits;
                    @weakify(self);
                    cell.tapDiscountCreditBlock = ^ (NSInteger index) {
                        @strongify(self);
                        [self enterDiscountCredit:index];
                    };
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                break;
            }
            default:
                break;
        }
    }else {
        switch (indexPath.section) {
            case 0:
            {
                cell  = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.hotBanks = self.hotBanks;
                @weakify(self);
                cell.tapHotBlock = ^(NSInteger index) {
                    @strongify(self);
                    [self enterHotBank:index];
                };
                break;
            }
            case 1:
            {
                cell  = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
                @weakify(self);
                cell.progressBlock = ^() {
                     @strongify(self);
                     [self enterProgressLookup];
                };
                cell.creditLookupBlock = ^ () {
                     @strongify(self);
                     [self enterCreditLookup];
                };
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            }
            case 2:
            {
                if (indexPath.row == 0) {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
                    cell.credit = [self.hotCredits objectAtIndex:indexPath.row - 1];
                }
                break;
            }
            case 3:
            {
                if (indexPath.row == 0) {
                    cell  = [tableView dequeueReusableCellWithIdentifier:@"cell6"];
                }else if(indexPath.row == 1) {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"cell7"];
                    cell.discountCredits = self.discountCredits;
                    @weakify(self);
                    cell.tapDiscountCreditBlock = ^ (NSInteger index) {
                        @strongify(self);
                         [self enterDiscountCredit:index];
                    };
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            }
            default:
                break;
        }
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isAttention) {
        if (indexPath.section == 0) {
            [MobClick event:@"TaphomeTip"];
            MyCreditCardViewController *my = StoryBoardDefined(@"MyCreditCardViewController");
            [self.navigationController pushViewController:my animated:YES];
        }else if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                CreditListViewController *list = StoryBoardDefined(@"CreditListViewController");
                list.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:list animated:YES];
                return;
            }
            CreditDetailViewController *detail = StoryBoardDefined(@"CreditDetailViewController");
            detail.hidesBottomBarWhenPushed = YES;
            detail.card_id = ((CreditCard*)[self.hotCredits objectAtIndex:indexPath.row - 1]).card_id;
            [self.navigationController pushViewController:detail animated:YES];
        }else if(indexPath.section == 4) {
            if (indexPath.row == 0) {
                CardDiscountViewController *card = StoryBoardDefined(@"CardDiscountViewController");
                card.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:card animated:YES];
            }
        }
    }else {
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                CreditListViewController *list = StoryBoardDefined(@"CreditListViewController");
                list.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:list animated:YES];
                return;
            }
            CreditDetailViewController *detail = StoryBoardDefined(@"CreditDetailViewController");
            detail.hidesBottomBarWhenPushed = YES;
            detail.card_id = ((CreditCard*)[self.hotCredits objectAtIndex:indexPath.row - 1]).card_id;
            [self.navigationController pushViewController:detail animated:YES];
        }else if(indexPath.section == 3) {
            if (indexPath.row == 0) {
                CardDiscountViewController *card = StoryBoardDefined(@"CardDiscountViewController");
                card.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:card animated:YES];
            }
        }

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isAttention) {
        switch (indexPath.section) {
                case 0:
                return 70.f;
                break;
            case 1:
                return 164.f;
                break;
            case 2:
                return 91.f;
                break;
            case 3:
                if (indexPath.row == 0) {
                    return 48.f;
                }else {
                    return 100.f;
                }
                break;
            case 4:
                if (indexPath.row == 0) {
                    return 48.f;
                }else {
                    return 140.f;
                }
                break;
            default:
                break;
        }
    }else {
        switch (indexPath.section) {
            case 0:
                return 164.f;
                break;
            case 1:
                return 91.f;
                break;
            case 2:
                if (indexPath.row == 0) {
                    return 48.f;
                }else {
                    return 100.f;
                }
                break;
            case 3:
                if (indexPath.row == 0) {
                    return 48.f;
                }else {
                    return 140.f;
                }
                break;
            default:
                break;
        }
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 15.f;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - 
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index {
    [imageView sd_setImageWithURL:[NSURL URLWithString:[[self.ads objectAtIndex:index] objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"bannerPlacehold"]];
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index {
    NSInteger is_h5 = [[[self.ads objectAtIndex:index] objectForKey:@"is_h5"] integerValue];
    [MobClick event:@"ad"];
    if (is_h5 == 1) {
        JCCBaseWebViewController *web = [[JCCBaseWebViewController alloc] init];
        web.url = [[self.ads objectAtIndex:index] objectForKey:@"url"];
        web.webTitle = [[self.ads objectAtIndex:index] objectForKey:@"title"];
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
    }else {
        //进入信用卡列表
        CreditListViewController *list = StoryBoardDefined(@"CreditListViewController");
        HotBank *bank = [[HotBank alloc] init];
        bank.bank_id = [[[self.ads objectAtIndex:index] objectForKey:@"url"] integerValue];
        bank.bank_name = [[self.ads objectAtIndex:index] objectForKey:@"bank_name"];
        list.bank = bank;
        list.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:list animated:YES];
    }
}

#pragma mark - Action 
- (void)chooseCity:(id)sendr {
    CityViewController *addressPicker = [[CityViewController alloc] init];
    addressPicker.hidesBottomBarWhenPushed = YES;
    addressPicker.delegate = self;
    [self.navigationController pushViewController:addressPicker animated:YES];
}

- (void)closeTip {
    _isAttention = NO;
    [MobClick event:@"closeHomeTip"];
    [self.tableView reloadData];
}

- (void)enterHotBank:(NSInteger)index {
    HotBank *bank = (HotBank*)[self.hotBanks objectAtIndex:index];
    NSLog(@"%ld",(long)bank.bank_id);
    [MobClick event:@"hotbank" attributes:@{@"bankName":bank.bank_name,@"bankId":[NSString stringWithFormat:@"%ld",(long)bank.bank_id]}];
    if (bank.is_h5) {
        JCCBaseWebViewController *web = [[JCCBaseWebViewController alloc] init];
        web.url = [NSString stringWithFormat:@"http://yun.haodai.com/To/c/bank_id/%ld/ref/%@/loader/1/card_id/0",(long)bank.bank_id,HTTP_Ref];
        web.hidesBottomBarWhenPushed = YES;
        web.webTitle = bank.bank_name;
        [self.navigationController pushViewController:web animated:YES];
    }else {
        //进入信用卡列表
        CreditListViewController *list = StoryBoardDefined(@"CreditListViewController");
        list.bank = bank;
        list.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:list animated:YES];
    }
}

- (void)enterProgressLookup {
    [MobClick event:@"progressLookup"];
    CreditProgressViewController *credit = StoryBoardDefined(@"CreditProgressViewController");
    credit.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:credit animated:YES];
}

- (void)enterCreditLookup  {
    [MobClick event:@"creditLookup"];
    JCCBaseWebViewController *web = [[JCCBaseWebViewController alloc] init];
    web.url = @"http://www.kuaicha.info/creditCB.action?appKey=43c77046550741f4b80e2ccdc09d642b&appName=%e5%a5%bd%e8%b4%b7%e4%bf%a1%e7%94%a8%e5%8d%a1%e7%ae%a1%e5%ae%b6&loginType=IDCARD_PASSWORD&callBackURL=http://api.haodai.com/";
    web.hidesBottomBarWhenPushed = YES;
    web.off_Y = -40;
    web.webTitle = @"征信查询";
    web.type = 1;
    [self.navigationController pushViewController:web animated:YES];
}


- (void)enterDiscountCredit:(NSInteger)index {
    JCCBaseWebViewController *web = [[JCCBaseWebViewController alloc] init];
    NSInteger _id =  [[self.discountCredits[index] objectForKey:@"id"] integerValue];
    web.url = [NSString stringWithFormat:@"%@Youhui/detail/city/%@/id/%ld",HTML5_URL,[ZYCacheManager shareInstance].user.city_s_EN,(long)_id];
    web.hidesBottomBarWhenPushed = YES;
    web.webTitle = @"优惠详情";
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark - 
- (void)citySelectedUpdateData {
    [self updateData];
    [mNotificationCenter postNotificationName:@"CityChangeUpdateData" object:nil];
    [_city setTitle:[ZYCacheManager shareInstance].user.city forState:0];
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
