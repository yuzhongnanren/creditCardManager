//
//  CityViewController.m
//  creditManager
//
//  Created by haodai on 16/3/7.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "CityViewController.h"
#import "RecentCityCell.h"

@interface CityViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSDictionary *cities;//
@property (nonatomic, strong) NSMutableArray *allCities;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSArray *recentCities;


@end

@implementation CityViewController
{
    UITableView *_tableView;
    UISearchBar *_searchBar;
    UISearchDisplayController *_displayController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"定位";
    
    [self feachData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - init
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - NavigationBarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor grayColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    _tableView.sectionIndexColor = mBlueColor;
    [self.view addSubview:_tableView];
}

- (void)initSearchBar{
    _resultArray = [[NSMutableArray alloc] init];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    _searchBar.placeholder = @"输入城市名或拼音";
    _searchBar.delegate = self;
    _searchBar.layer.borderColor = [[UIColor clearColor] CGColor];
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _displayController.delegate = self;
    _displayController.searchResultsDataSource = self;
    _displayController.searchResultsDelegate = self;
    [self.view addSubview:_searchBar];
}

#pragma mark -
#pragma mark - Data
- (void)feachData {
    [[HTTPClientManager manager] POST:@"xindai/get_xindai_zones_all?" dictionary:@{@"letter":@"1"} success:^(id responseObject) {
        self.cities = [responseObject objectForKey:@"items"];
        self.titleArray = [responseObject objectForKey:@"letters"];
        self.allCities = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < self.titleArray.count; i ++) {
            [_allCities addObjectsFromArray:[self.cities objectForKey:[self.titleArray objectAtIndex:i]]];
        }
        [self initSearchBar];
        [self initTableView];
        
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}


#pragma mark - 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return [self.titleArray count] + 1;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        if (section == 0) {
            return 1;
        }
        NSString *cityKey = [self.titleArray objectAtIndex:section - 1];
        NSArray *array = [self.cities objectForKey:cityKey];
        return [array count];

    }else{
        return [_resultArray count];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"Cell";
    if (tableView == _tableView) {
        if (indexPath.section == 0){
            //最近访问城市
            RecentCityCell *recentCityCell = [tableView dequeueReusableCellWithIdentifier:@"recentCellIndentifier"];
            if (recentCityCell == nil) {
                recentCityCell = [[RecentCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recentCellIndentifier"];
            }
            recentCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            recentCityCell.recentCitys = [[ZYCacheManager shareInstance] getRecentCity];
            @weakify(self);
            recentCityCell.cityBlock = ^ (NSInteger index) {
                @strongify(self);
                if (_type == 1) {
                    [ZYCacheManager shareInstance].user.address = [[[[ZYCacheManager shareInstance] getRecentCity] objectAtIndex:index] objectForKey:@"CN"];
                    [ZYCacheManager shareInstance].user.address_s_EN = [[[[ZYCacheManager shareInstance] getRecentCity] objectAtIndex:index] objectForKey:@"s_EN"];
                    [ZYCacheManager shareInstance].user.address_Zone_Id = [[[[ZYCacheManager shareInstance] getRecentCity] objectAtIndex:index] objectForKey:@"zone_id"];
                    [[ZYCacheManager shareInstance] save];
                }else {
                    [ZYCacheManager shareInstance].user.city = [[[[ZYCacheManager shareInstance] getRecentCity] objectAtIndex:index] objectForKey:@"CN"];
                    [ZYCacheManager shareInstance].user.city_s_EN = [[[[ZYCacheManager shareInstance] getRecentCity] objectAtIndex:index] objectForKey:@"s_EN"];
                    [[ZYCacheManager shareInstance] save];
                    [[ZYCacheManager shareInstance] saveRecentCity:[[[ZYCacheManager shareInstance] getRecentCity] objectAtIndex:index]];
                }
                if ([self.delegate respondsToSelector:@selector(citySelectedUpdateData)]) {
                    [self.delegate citySelectedUpdateData];
                }
                [self.navigationController popViewControllerAnimated:YES];
            };
            return recentCityCell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.textLabel.text = [[[self.cities objectForKey:[self.titleArray objectAtIndex:indexPath.section - 1]] objectAtIndex:indexPath.row] objectForKey:@"zone_name"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor colorWithHexColorString:@"47494f"];
            
            return cell;
        }
    }else{
        static NSString *Identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [[_resultArray objectAtIndex:indexPath.row] objectForKey:@"zone_name"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithHexColorString:@"47494f"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tableView == tableView) {
        if (indexPath.section == 0) {
            NSArray *citys = [[ZYCacheManager shareInstance] getRecentCity];
            if (citys.count > 3) {
                return 9.f + 9.f + 25.f + 25.f + 9.f;
            }
            return 9.f + 9.f + 25.f;
        }
        return 44.f;
    }
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _tableView) {
        if (indexPath.section != 0) {
            if (_type == 1) {
                [ZYCacheManager shareInstance].user.address = [[[self.cities objectForKey:[self.titleArray objectAtIndex:indexPath.section - 1]] objectAtIndex:indexPath.row] objectForKey:@"CN"];
                [ZYCacheManager shareInstance].user.address_s_EN = [[[self.cities objectForKey:[self.titleArray objectAtIndex:indexPath.section - 1]] objectAtIndex:indexPath.row] objectForKey:@"s_EN"];
                [ZYCacheManager shareInstance].user.address_Zone_Id = [[[self.cities objectForKey:[self.titleArray objectAtIndex:indexPath.section - 1]] objectAtIndex:indexPath.row] objectForKey:@"zone_id"];
                [[ZYCacheManager shareInstance] save];
            }else {
                [[ZYCacheManager shareInstance] saveRecentCity:[[self.cities objectForKey:[self.titleArray objectAtIndex:indexPath.section - 1]] objectAtIndex:indexPath.row]];
                [ZYCacheManager shareInstance].user.city = [[[self.cities objectForKey:[self.titleArray objectAtIndex:indexPath.section - 1]] objectAtIndex:indexPath.row] objectForKey:@"CN"];
                [ZYCacheManager shareInstance].user.city_s_EN = [[[self.cities objectForKey:[self.titleArray objectAtIndex:indexPath.section - 1]] objectAtIndex:indexPath.row] objectForKey:@"s_EN"];
                [[ZYCacheManager shareInstance] save];
            }
            if ([self.delegate respondsToSelector:@selector(citySelectedUpdateData)]) {
                [self.delegate citySelectedUpdateData];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
        if (_type == 1) {
            [ZYCacheManager shareInstance].user.address =  [[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"CN"];
            [ZYCacheManager shareInstance].user.address_s_EN = [[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"s_EN"];
             [ZYCacheManager shareInstance].user.address_Zone_Id = [[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"zone_id"];
            [[ZYCacheManager shareInstance] save];
        }else {
            [[ZYCacheManager shareInstance] saveRecentCity:[self.resultArray objectAtIndex:indexPath.row]];
            [ZYCacheManager shareInstance].user.city = [[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"CN"];
            [ZYCacheManager shareInstance].user.city_s_EN = [[self.resultArray objectAtIndex:indexPath.row] objectForKey:@"s_EN"];
            [[ZYCacheManager shareInstance] save];
        }
        [self.searchDisplayController setActive:NO animated:YES];
        [self searchBarCancelButtonClicked:_searchBar];
        if ([self.delegate respondsToSelector:@selector(citySelectedUpdateData)]) {
            [self.delegate citySelectedUpdateData];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        headerView.backgroundColor = BackgroundColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, 32)];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textColor = [UIColor colorWithHexColorString:@"8e979a"];
        [headerView addSubview:label];
        if (section == 0) {
            label.text = @"历史定位";
        }else {
            label.text = [self.titleArray objectAtIndex:section - 1];
        }
        return headerView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView) {
        return 32.f;
    }else{
        return 0.01;
    }
}


//右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
        NSMutableArray *titleSectionArray = [NSMutableArray arrayWithObjects:@"最近", nil];
        for (int i = 0; i < [_titleArray count]; i++) {
            NSString *title = [NSString stringWithFormat:@"    %@",[_titleArray objectAtIndex:i]];
            [titleSectionArray addObject:title];
        }
        return titleSectionArray;
    }else{
        return nil;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}


#pragma mark - 
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        [UIView animateWithDuration:0.25 animations:^{
            [self.view setBackgroundColor:RGBACOLOR(198, 198, 203, 1.0)];
            for (UIView *subview in self.view.subviews){
                subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
            }
        }];
    }
    return YES;
}



/**
 *  搜索结束回调用于更新UI
 *
 *  @param searchBar
 *
 *  @return
 */
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        [UIView animateWithDuration:0.25 animations:^{
//            for (UIView *subview in self.view.subviews){
//                subview.transform = CGAffineTransformMakeTranslation(0, 0);
//            }
//        } completion:^(BOOL finished) {
//            [self.view setBackgroundColor:[UIColor whiteColor]];
//        }];
//    }
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews){
                subview.transform = CGAffineTransformMakeTranslation(0, 0);
            }
        } completion:^(BOOL finished) {
            [self.view setBackgroundColor:[UIColor whiteColor]];
        }];
    }
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [_resultArray removeAllObjects];
        for (int i = 0; i < _allCities.count; i++) {
            if ([[[_allCities[i] objectForKey:@"EN"] uppercaseString] hasPrefix:[searchString uppercaseString]] || [[_allCities[i] objectForKey:@"zone_name"] hasPrefix:searchString]) {
                [_resultArray addObject:_allCities[i]];
            }
        }
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self searchDisplayController:controller shouldReloadTableForSearchString:_searchBar.text];
    return YES;
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView setContentInset:UIEdgeInsetsZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
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
