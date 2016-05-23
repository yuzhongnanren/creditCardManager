//
//  CardSortViewController.m
//  creditManager
//
//  Created by haodai on 16/3/10.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "CardSortViewController.h"
#import "CreditCard.h"
#import "CreditTableViewCell.h"
#import "MJExtension.h"
#import "CreditDetailViewController.h"

@interface CardSortViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) NSMutableArray *dataSource1;
@property (nonatomic, strong) NSMutableArray *dataSource2;
@property (nonatomic, strong) NSMutableArray *dataSource3;
@property (nonatomic, assign) NSInteger index;


@end

@implementation CardSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"creditCardSort"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    self.title = @"卡排行";
    
    self.index = 0;
    _dataSource1 = [NSMutableArray arrayWithCapacity:0];
    _dataSource2 = [NSMutableArray arrayWithCapacity:0];
    _dataSource3 = [NSMutableArray arrayWithCapacity:0];
    
    [self feachData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)feachData {
    [[HTTPClientManager manager] POST:@"/credit/get_ranking_list?" dictionary:@{} success:^(id responseObject) {
        [_dataSource1 addObjectsFromArray:[CreditCard mj_objectArrayWithKeyValuesArray:[[[responseObject objectForKey:@"items"] objectAtIndex:0] objectForKey:@"ranking_list"]]];
        [_dataSource2 addObjectsFromArray:[CreditCard mj_objectArrayWithKeyValuesArray:[[[responseObject objectForKey:@"items"] objectAtIndex:1] objectForKey:@"ranking_list"]]];
        [_dataSource3 addObjectsFromArray:[CreditCard mj_objectArrayWithKeyValuesArray:[[[responseObject objectForKey:@"items"] objectAtIndex:2] objectForKey:@"ranking_list"]]];
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}


#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_index == 0) {
        return _dataSource1.count;
    }else if(_index == 1) {
        return _dataSource2.count;
    }
    return _dataSource3.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (_index == 0) {
        cell.credit = [_dataSource1 objectAtIndex:indexPath.row];
    }else if(_index == 1) {
        cell.credit = [_dataSource2 objectAtIndex:indexPath.row];
    }else {
        cell.credit = [_dataSource3 objectAtIndex:indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 103.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     CreditDetailViewController *detail = StoryBoardDefined(@"CreditDetailViewController");
    if (_index == 0) {
        detail.card_id = ((CreditCard*)self.dataSource1[indexPath.row]).card_id;
    }else if(_index == 1) {
        detail.card_id = ((CreditCard*)self.dataSource2[indexPath.row]).card_id;
    }else {
        detail.card_id = ((CreditCard*)self.dataSource3[indexPath.row]).card_id;
    }
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - 
- (IBAction)sort1:(id)sender {
    self.index = 0;
    [self.tableView reloadData];
}

- (IBAction)sort2:(id)sender {
     self.index = 1;
    [self.tableView reloadData];
}

- (IBAction)sort3:(id)sender {
     self.index = 2;
    [self.tableView reloadData];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    for (int i = 0; i < 3; i++) {
        UILabel *title = (UILabel*)[self.topView viewWithTag:1000 + i];
        if (i == _index) {
            title.textColor = [UIColor colorWithHexColorString:@"00aaee"];
        }else
            title.textColor = [UIColor colorWithHexColorString:@"666666"];
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
