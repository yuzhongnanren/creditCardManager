//
//  ApplyCardViewController.m
//  creditManager
//
//  Created by haodai on 16/3/14.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "ApplyCardViewController.h"
#import "ImagePlayerView.h"
#import "ZYScrollView.h"
#import "CardInformationTableViewCell.h"
#import "HotBank.h"
#import "MJExtension.h"
#import "JCCBaseWebViewController.h"
#import "CreditListViewController.h"
#import "HotBankView.h"
#import "MJRefresh.h"

@interface ApplyCardViewController ()<UITableViewDataSource,UITableViewDelegate,ImagePlayerViewDelegate,ZYScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *backScr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeightLayout;
@property (weak, nonatomic) IBOutlet ImagePlayerView *adView;
@property (weak, nonatomic) IBOutlet ZYScrollView *hotBankScr;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *ads;
@property (nonatomic, strong) NSArray *hotBanks;

@end

@implementation ApplyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _hotBankScr.pagingEnabled = YES;
    _hotBankScr.delegate = self;
    _pageControl.currentPageIndicatorTintColor = mBlueColor;
    _pageControl.pageIndicatorTintColor = [UIColor colorWithHexColorString:@"ededed"];
    _pageControl.currentPage = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorInset =  UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    
    [mNotificationCenter addObserver:self selector:@selector(updateData) name:@"CityChangeUpdateData" object:nil];
    
    self.dataSource = [NSMutableArray arrayWithCapacity:1];
    @weakify(self);
    self.backScr.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        @strongify(self);
        [self feachData];
    }];
    
    [self feachData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick event:@"applyCard"];
}

- (void)updateData {
    [self feachData];
}

- (void)feachData {
    [self feathAdData];
    [self feathBankData];
    [self feachInformation];
}

- (void)dealloc {
    [mNotificationCenter removeObserver:self];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,15,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,15,0,0)];
    }
}


- (void)feathAdData {
    [[HTTPClientManager manager] POST:@"credit/get_banner_list?" dictionary:@{@"banner_type":@"1"} success:^(id responseObject) {
        self.ads = [responseObject objectForKey:@"items"];
        [_adView initWithCount:self.ads.count delegate:self];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}

- (void)feathBankData {
    [[HTTPClientManager manager] POST:@"credit/get_online_bank_list?" dictionary:@{} success:^(id responseObject) {
        self.hotBanks = [HotBank mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"items"]];
        _pageControl.numberOfPages = ceilf(self.hotBanks.count/4.f);
        [_hotBankScr initOpusViewCount:self.hotBanks.count placeholder:nil delegate:self left:0 top:0 gap:0];
        _hotBankScr.contentSize = CGSizeMake(ceilf(self.hotBanks.count/4.f)*SCREEN_WIDTH, _hotBankScr.height);
        
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}

- (void)feachInformation {
    [[HTTPClientManager manager] POST:@"article/get_article_list?" dictionary:@{@"cate_id":@"218",@"pg_num":@(1),@"pg_size":@"8"} success:^(id responseObject) {
        self.tableView.hidden = NO;
        self.dataSource = [responseObject objectForKey:@"items"];
        self.backViewHeightLayout.constant = 658.f + [self tableViewHeight];
        [self updateViewConstraints];
        [self.tableView reloadData];
        if ([self.backScr.mj_header isRefreshing]) {
            [self.backScr.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        if ([self.backScr.mj_header isRefreshing]) {
            [self.backScr.mj_header endRefreshing];
        }
    } view:self.view progress:YES];
}

- (CGFloat)tableViewHeight {
    __block CGFloat h = 0.f;
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString*img = [obj objectForKey:@"ad_img"];
        if (StringIsNull(img)) {
            h += 66.f;
        }else {
            h += 105.f;
        }
    }];
    return h;
}

#pragma mark - DataSource
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardInformationTableViewCell *cell = nil;
    if (!StringIsNull([[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"ad_img"])) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    }
    cell.dic = self.dataSource[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (StringIsNull([[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"ad_img"])) {
        return 86.f;
    }
    //66.f
    return 105.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JCCBaseWebViewController *web = [[JCCBaseWebViewController alloc] init];
    web.url = [NSString stringWithFormat:@"http://8.yun.haodai.com/Public/creditinfo/city/%@/id/%d",[ZYCacheManager shareInstance].user.city_s_EN,[[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue]];
    web.webTitle = @"资讯详情";
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
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


#pragma mark - ZYScrollViewDelegate
- (UIView*)opusView:(ZYScrollView *)opusView index:(NSInteger)index {
    HotBankView *hotView = LoadNibWithName(@"HotBankView");
    hotView.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, 114.f);
    hotView.bank = [self.hotBanks objectAtIndex:index];
    return hotView;
}

- (void)opusView:(ZYScrollView *)opusView didTapAtIndex:(NSInteger)index {
    HotBank *bank = (HotBank*)[self.hotBanks objectAtIndex:index];
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

#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _pageControl.currentPage = (scrollView.contentOffset.x + 2)/self.view.width;
}

#pragma mark - Action
- (IBAction)card_car:(id)sender {
    //进入信用卡列表
    [MobClick event:@"carUserCard"];
    CreditListViewController *list = StoryBoardDefined(@"CreditListViewController");
    list.hidesBottomBarWhenPushed = YES;
    list.currentTopic = @"0110";
    list.currentTopicName = @"车主卡";
    [self.navigationController pushViewController:list animated:YES];
}
- (IBAction)year_free:(id)sender {
    [MobClick event:@"womenCard"];
    CreditListViewController *list = StoryBoardDefined(@"CreditListViewController");
    list.hidesBottomBarWhenPushed = YES;
    list.currentTopic = @"0111";
    list.currentTopicName = @"女性卡";
    [self.navigationController pushViewController:list animated:YES];
}

- (IBAction)card_food:(id)sender {
    [MobClick event:@"shoppingCard"];
    CreditListViewController *list = StoryBoardDefined(@"CreditListViewController");
    list.hidesBottomBarWhenPushed = YES;
    list.currentTopic = @"0107";
    list.currentTopicName = @"超市/商场卡";
    [self.navigationController pushViewController:list animated:YES];
}

- (IBAction)card_bigLimit:(id)sender {
    [MobClick event:@"gaoequxianCard"];
    CreditListViewController *list = StoryBoardDefined(@"CreditListViewController");
    list.hidesBottomBarWhenPushed = YES;
    list.currentTopic = @"0108";
    list.currentTopicName = @"高额取现卡";
    [self.navigationController pushViewController:list animated:YES];
}

- (IBAction)card_katong:(id)sender {
    [MobClick event:@"kaTongCard"];
    CreditListViewController *list = StoryBoardDefined(@"CreditListViewController");
    list.hidesBottomBarWhenPushed = YES;
    list.currentTopic = @"0112";
    list.currentTopicName = @"卡通卡";
    [self.navigationController pushViewController:list animated:YES];
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
