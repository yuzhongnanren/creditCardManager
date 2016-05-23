//
//  CardInformationViewController.m
//  creditManager
//
//  Created by haodai on 16/3/24.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "CardInformationViewController.h"
#import "CardInformationTableViewCell.h"
#import "MJRefresh.h"
#import "JCCBaseWebViewController.h"

@interface CardInformationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign)NSInteger currentPage;

@end

@implementation CardInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"creditCardMessage"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    self.tableView.hidden = YES;
     _currentPage = 1;
    self.dataSource = [NSMutableArray arrayWithCapacity:1];
    @weakify(self);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        @strongify(self);
        [self feachData:NO];
    }];
   
    [self feachData:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)feachData:(BOOL)p {
    [[HTTPClientManager manager] POST:@"article/get_article_list?" dictionary:@{@"cate_id":@"218",@"pg_num":@(_currentPage),@"pg_size":@"10"} success:^(id responseObject) {
        self.tableView.hidden = NO;
        if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            if ([[responseObject objectForKey:@"items"] count] == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            [self.dataSource addObjectsFromArray:[responseObject objectForKey:@"items"]];
             _currentPage ++;
            [self.tableView.mj_footer endRefreshing];
        }else {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[responseObject objectForKey:@"items"]];
            _currentPage ++;
        }
        
        if (self.dataSource.count == 0) {
            [self setNoData];
        }else {
            [self setHasData];
        }
        if (self.dataSource.count < [[responseObject objectForKey:@"count"] integerValue]) {
            @weakify(self);
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                // 进入刷新状态后会自动调用这个block
                @strongify(self);
                [self feachData:NO];
            }];
        }else {
            self.tableView.mj_footer = nil;
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (StringIsNull([[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"ad_img"])) {
        return 86.f;
    }
    //66.f
    return 105.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MobClick event:@"xingyongkaZiXun"];
    JCCBaseWebViewController *web = [[JCCBaseWebViewController alloc] init];
    web.url = [NSString stringWithFormat:@"http://8.yun.haodai.com/Public/creditinfo/city/%@/id/%d",[ZYCacheManager shareInstance].user.city_s_EN,[[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue]];
    web.webTitle = @"资讯详情";
    [self.navigationController pushViewController:web animated:YES];
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
