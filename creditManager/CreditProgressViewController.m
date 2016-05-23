//
//  CreditProgressViewController.m
//  creditManager
//
//  Created by haodai on 16/3/2.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "CreditProgressViewController.h"
#import "CreditProgressCell.h"
#import "JCCBaseWebViewController.h"

@interface CreditProgressViewController ()
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation CreditProgressViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BackgroundColor;
    self.collectionView.backgroundColor = BackgroundColor;
    if (_type == 0) {
        self.title = @"进度查询";
    }else {
        self.title = @"信用卡激活";
    }
    [self feathData];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[CreditProgressCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)feathData {
    [[HTTPClientManager manager] POST:@"/credit/get_bank_list_all?" dictionary:@{} success:^(id responseObject) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:1];
        if (_type == 0) {
            for (NSDictionary *dic in [responseObject objectForKey:@"items"]) {
                if (![[dic objectForKey:@"wap_prg_url"] isEqualToString:@""]) {
                    [temp addObject:dic];
                }
            }
        }else {
            for (NSDictionary *dic in [responseObject objectForKey:@"items"]) {
                if (![[dic objectForKey:@"wap_activate_url"] isEqualToString:@""]) {
                    [temp addObject:dic];
                }
            }
        }
        self.dataSource = temp;
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}


#pragma mark <UICollectionViewDataSource>
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
};

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CreditProgressCell *cell = (CreditProgressCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.progressDic = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    JCCBaseWebViewController *web = [[JCCBaseWebViewController alloc] init];
    if (_type == 0) {
         web.url = [self.dataSource[indexPath.row] objectForKey:@"wap_prg_url"];
    }else {
         web.url = [self.dataSource[indexPath.row] objectForKey:@"wap_activate_url"];
    }
    web.webTitle = [self.dataSource[indexPath.row] objectForKey:@"bank_name"];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}



@end
