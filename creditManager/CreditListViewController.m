//
//  CreditListViewController.m
//  creditManager
//
//  Created by haodai on 16/3/3.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "CreditListViewController.h"
#import "CreditTableViewCell.h"
#import "MJExtension.h"
#import "ZYSearchPOPView.h"
#import "MJRefresh.h"
#import "CreditDetailViewController.h"

@interface CreditListViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSString *currentLevel;
@property (nonatomic, assign) NSInteger currentBank;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSArray *allBanks;
@property (nonatomic, strong) NSArray *topics;
@property (nonatomic, strong) NSArray *levels;

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) ZYSearchPOPView *popView;
@property (nonatomic, strong) UIButton *city;



@end

@implementation CreditListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"hotCreditCardList"];
    self.title = @"信用卡列表";
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    self.tableView.hidden = YES;
//    [self setRightButton];
    
    [self setUp];

    [self feathBankData];
    [self feathTagsData];
    [self feathData:YES];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUp {
    _currentPage = 1;
    _currentBank = self.bank.bank_id;
    self.currentIndex = 0;
    _currentLevel = @"";
    if (_currentTopic == nil) {
        _currentTopic = @"";
    }
    _dataSource = [NSMutableArray arrayWithCapacity:0];
    
    UILabel *title = [_topView viewWithTag:1000];
    if (self.bank.bank_name && ![self.bank.bank_name isEqualToString:@""]) {
        title.text = self.bank.bank_name;
    }
    
    UILabel *topic = [_topView viewWithTag:1001];
    if (self.currentTopicName && ![self.currentTopicName isEqualToString:@""]) {
        topic.text = self.currentTopicName;
    }
    
    if (_popView == nil) {
        _popView = LoadNibWithName(@"ZYSearchPOPView");
        @weakify(self);
        _popView.searchIndex = ^(NSInteger index) {
            @strongify(self);
            [self chooseSearchIndex:index];
        };
        _popView.searchCancel = ^() {
            @strongify(self);
            [self cancelSearch];

        };
    }
    
    @weakify(self);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        @strongify(self);
        [self feathData:NO];
    }];
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


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_popView) {
        [_popView removeFromSuperview];
    }
}

#pragma mark - Data 
- (void)feathBankData {
    [[HTTPClientManager manager] POST:@"credit/get_bank_list?" dictionary:@{} success:^(id responseObject) {
        self.allBanks = [responseObject objectForKey:@"items"];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}

- (void)feathTagsData {
    [[HTTPClientManager manager] POST:@"credit/get_card_tags?" dictionary:@{} success:^(id responseObject) {
        for (int i = 0; i < [[responseObject objectForKey:@"items"] count]; i++) {
            NSString *tag_id = [[[responseObject objectForKey:@"items"] objectAtIndex:i]objectForKey:@"tag_id"];
            if ([tag_id isEqualToString:@"01"]) {
                self.topics = [[[responseObject objectForKey:@"items"] objectAtIndex:i] objectForKey:@"options"];
            }
            if ([tag_id isEqualToString:@"04"]) {
                self.levels = [[[responseObject objectForKey:@"items"] objectAtIndex:i] objectForKey:@"options"];
                
            }
        }
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}

- (void)feathData:(BOOL)p {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
    if (![_currentLevel isEqualToString:@""]) {
        [temp addObject:_currentLevel];
    }
    if(![_currentTopic isEqualToString:@""]) {
        [temp addObject:_currentTopic];
    }
    NSString *str = [temp componentsJoinedByString:@","];
    NSString *url = [NSString stringWithFormat:@"credit/get_card_list?page=%d&bank_id=%d&tag_ids=%@&page_size=10&",_currentPage,_currentBank,str];
    [[HTTPClientManager manager] POST:url dictionary:@{} success:^(id responseObject) {
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
                [self feathData:NO];
            }];
        }else {
            self.tableView.mj_footer = nil;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view progress:p];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.credit = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  103.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CreditDetailViewController *detail = StoryBoardDefined(@"CreditDetailViewController");
    detail.card_id = ((CreditCard*)self.dataSource[indexPath.row]).card_id;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -
#pragma mark - Action
- (IBAction)chooseBank:(id)sender {
    if (self.allBanks.count == 0) {
        return;
    }
    NSMutableArray *temp1 = [NSMutableArray arrayWithCapacity:1];
    [temp1 addObject:@"不限"];
    NSMutableArray *temp2 = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in self.allBanks) {
        [temp1 addObject:[dic objectForKey:@"bank_name"]];
        [temp2 addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"bank_id"]]];
    }
    NSInteger index = 0;
    if ([temp2 indexOfObject:[NSString stringWithFormat:@"%d",_currentBank]] <= temp2.count - 1) {
        index = [temp2 indexOfObject:[NSString stringWithFormat:@"%d",_currentBank]] + 1;
    }
    NSLog(@"%d----%d",_currentBank,index);
    [_popView searchDataSource:temp1 currentSelected:index];
    [_popView show];
     self.currentIndex = 1;
}

- (IBAction)chooseTopic:(id)sender {
    if (self.topics.count == 0) {
        return;
    }
    NSMutableArray *temp1 = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *temp2 = [NSMutableArray arrayWithCapacity:0];
    [temp1 addObject:@"不限"];
    for (NSDictionary *dic in self.topics) {
        [temp1 addObject:[dic objectForKey:@"tag_name"]];
        [temp2 addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"tag_id"]]];
    }
    
    NSLog(@"%d",[temp2 indexOfObject:_currentTopic]);
    NSInteger index = 0;
    if ([temp2 indexOfObject:_currentTopic] <= temp2.count - 1) {
        index = [temp2 indexOfObject:_currentTopic] + 1;
    }
    [_popView searchDataSource:temp1 currentSelected:index];
    [_popView show];
     self.currentIndex = 2;
}

- (IBAction)chooseLevel:(id)sender {
    if (self.levels.count == 0) {
        return;
    }
    NSMutableArray *temp1 = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *temp2 = [NSMutableArray arrayWithCapacity:0];
    [temp1 addObject:@"不限"];
    for (NSDictionary *dic in self.levels) {
        [temp1 addObject:[dic objectForKey:@"tag_name"]];
        [temp2 addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"tag_id"]]];
    }
    
    NSLog(@"%d",[temp2 indexOfObject:_currentLevel]);
    NSInteger index = 0;
    if ([temp2 indexOfObject:_currentLevel] <= temp2.count - 1) {
         index = [temp2 indexOfObject:_currentLevel] + 1;
    }
    [_popView searchDataSource:temp1 currentSelected:index];
    [_popView show];
     self.currentIndex = 3;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    for (int i = 0; i < 3; i++) {
        UIImageView *arrow = (UIImageView*)[self.topView viewWithTag:100 + i];
        UILabel *title = (UILabel*)[self.topView viewWithTag:1000+i];
        if (currentIndex == 0) {
            arrow.image = [UIImage imageNamed:@"cardarrowl"];
            title.textColor = [UIColor colorWithHexColorString:@"666666"];
        }else {
            if (i == currentIndex - 1) {
                arrow.image = [UIImage imageNamed:@"cardarrowh"];
                title.textColor = [UIColor colorWithHexColorString:@"00aaee"];
            }else {
                arrow.image = [UIImage imageNamed:@"cardarrowl"];
                title.textColor = [UIColor colorWithHexColorString:@"666666"];
            }
        }
    }
}

- (void)chooseSearchIndex:(NSInteger)index {
    if (_currentIndex == 1) {
        if (index == 0) {
            _currentBank = 0;
            UILabel *title = [_topView viewWithTag:1000];
            title.text = @"全部银行";
        }else {
            _currentBank = [[[self.allBanks objectAtIndex:index - 1] objectForKey:@"bank_id"] integerValue];
            UILabel *title = [_topView viewWithTag:1000];
            title.text = [[self.allBanks objectAtIndex:index - 1] objectForKey:@"bank_name"];
        }
    }else if(_currentIndex == 2) {
        if (index == 0) {
            _currentTopic = @"";
            UILabel *title = [_topView viewWithTag:1001];
            title.text = @"主题";
        }else {
            _currentTopic = [NSString stringWithFormat:@"%@",[[self.topics objectAtIndex:index - 1] objectForKey:@"tag_id"]];
            UILabel *title = [_topView viewWithTag:1001];
            title.text = [[self.topics objectAtIndex:index - 1] objectForKey:@"tag_name"];
        }
    }else if(_currentIndex == 3) {
        if (index == 0) {
            _currentLevel = @"";
            UILabel *title = [_topView viewWithTag:1002];
            title.text = @"等级";
        }else {
            _currentLevel = [NSString stringWithFormat:@"%@",[[self.levels objectAtIndex:index - 1] objectForKey:@"tag_id"]];
            UILabel *title = [_topView viewWithTag:1002];
            title.text = [[self.levels objectAtIndex:index - 1] objectForKey:@"tag_name"];
        }
    }
    _currentPage = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self feathData:YES];
    self.currentIndex = 0;
}

- (void)cancelSearch {
    self.currentIndex = 0;
}

- (void)chooseCity:(id)sender {
    
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
