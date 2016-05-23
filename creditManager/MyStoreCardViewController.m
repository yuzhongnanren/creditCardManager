//
//  MyStoreCardViewController.m
//  creditManager
//
//  Created by haodai on 16/3/18.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "MyStoreCardViewController.h"
#import "CreditTableViewCell.h"
#import "CreditCard.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "CreditDetailViewController.h"
@interface MyStoreCardViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation MyStoreCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"wantCredit"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _currentPage = 1;
    self.tableView.hidden = YES;
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
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
    [[HTTPClientManager manager] POST:@"credit/get_my_card_list?" dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid),@"page":@(_currentPage),@"page_size":@"10"} success:^(id responseObject) {
        self.tableView.hidden = NO;
        if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            if ([[responseObject objectForKey:@"items"] count] == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            [self.dataSource addObjectsFromArray:[CreditCard mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"items"]]];
            _currentPage ++;
            [self.tableView.mj_footer endRefreshing];
        }else {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[CreditCard mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"items"]]];
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
        
    } view:self.view progress:p];
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.credit = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CreditDetailViewController *detail = StoryBoardDefined(@"CreditDetailViewController");
    detail.card_id = ((CreditCard*)self.dataSource[indexPath.row]).card_id;
    [self.navigationController pushViewController:detail animated:YES];

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
