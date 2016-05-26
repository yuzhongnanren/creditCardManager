//
//  CardDiscountViewController.m
//  creditManager
//
//  Created by haodai on 16/3/11.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "CardDiscountViewController.h"
#import "CardDiscount.h"
#import "CardDiscountTableViewCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "JCCPickerView.h"
#import "JCCBaseWebViewController.h"

@interface CardDiscountViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIButton *bank;
@property (nonatomic, strong) JCCPickerView *pickerView;
@property (nonatomic, strong) NSArray *allBanks;

@end

@implementation CardDiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"卡优惠";
    [MobClick event:@"creditCardDiscount"];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    
    [self setRightButton];
    [self setUp];
    [self feathData:YES];
    [self fecthBanks];
    // Do any additional setup after loading the view.
}

- (void)setUp {
    _currentPage = 1;

    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [CardDiscount mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"discount_id" : @"id"};
    }];
    
    @weakify(self);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        @strongify(self);
            [self feathData:NO];
    }];

}

- (void)setRightButton {
    _bank = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bank setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [_bank setTitle:@"全部银行" forState:0];
    [_bank setTitleColor:[UIColor whiteColor] forState:0];
    [_bank setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [_bank setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_bank addTarget:self action:@selector(chooseBank:) forControlEvents:UIControlEventTouchUpInside];
    _bank.titleLabel.font = [UIFont systemFontOfSize:13];
    _bank.frame = CGRectMake(0, 0, 88, 44);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_bank];
}

#pragma mark -
- (void)feathData:(BOOL)p {
    NSString *url = [NSString stringWithFormat:@"/credit/get_youhui_list?page=%ld&page_size=10&bank_id=%ld",(long)_currentPage,(long)_bank_id];
    [[HTTPClientManager manager] POST:url dictionary:@{} success:^(id responseObject) {
        self.tableView.hidden = NO;
        if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            if ([[responseObject objectForKey:@"items"] count] == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            [self.dataSource addObjectsFromArray:[CardDiscount mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"items"]]];
            _currentPage ++;
            [self.tableView.mj_footer endRefreshing];
        }else {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[CardDiscount mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"items"]]];
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
                [self feathData:NO];
            }];
        }else {
            self.tableView.mj_footer = nil;
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view progress:p];
}


- (void)fecthBanks {
    [[HTTPClientManager manager] POST:@"credit/get_bank_list_all?" dictionary:@{} success:^(id responseObject) {
        self.allBanks = [responseObject objectForKey:@"items"];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardDiscountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.cardDiscount = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 103.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MobClick event:@"tapDiscountCard"];
    JCCBaseWebViewController *web = [[JCCBaseWebViewController alloc] init];
    web.url = [NSString stringWithFormat:@"%@Youhui/detail/city/%@/id/%@",HTML5_URL,[ZYCacheManager shareInstance].user.city_s_EN,@(((CardDiscount*)[self.dataSource objectAtIndex:indexPath.row]).discount_id)];
    web.title = @"优惠详情";
    [self.navigationController pushViewController:web animated:YES];
}


- (void)chooseBank:(id)sender {
    if (self.allBanks.count == 0) {
        return;
    }
    if (!self.pickerView) {
        _pickerView = [[[NSBundle mainBundle] loadNibNamed:@"JCCPickerView" owner:self options:nil] objectAtIndex:0];
    }
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [temp addObject:@"全部银行"];
    [self.allBanks enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [temp addObject:[obj objectForKey:@"bank_name"]];
    }];
    @weakify(self);
    [self.pickerView configDatasource:temp title:@"" selectRow:0 block:^(NSString *content,NSInteger index) {
        @strongify(self);
        if (content != nil) {
            if ([temp indexOfObject:content] == 0) {
                _currentPage = 1;
                _bank_id = 0;
                 [_bank setTitle:content forState:0];
                [self feathData:YES];
            }else {
                _bank_id = [[[self.allBanks objectAtIndex:[temp indexOfObject:content] - 1] objectForKey:@"bank_id"] integerValue];
                [_bank setTitle:content forState:0];
                _currentPage = 1;
                [self feathData:YES];
            }
        }
    }];
    [self.pickerView show];
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
