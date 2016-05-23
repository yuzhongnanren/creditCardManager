//
//  ZYSearchPOPView.m
//  creditManager
//
//  Created by haodai on 16/3/4.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "ZYSearchPOPView.h"
#import "SearchPOPTableViewCell.h"

@interface ZYSearchPOPView () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIControl *cancel;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSInteger currentSelectedIndex;

@end

@implementation ZYSearchPOPView

- (void)awakeFromNib {
    self.tableView.showsVerticalScrollIndicator = NO;
}


- (void)searchDataSource:(NSArray*)dataSource currentSelected:(NSInteger)index {
    self.dataSource = dataSource;
    self.currentSelectedIndex = index;
    [self.tableView reloadData];
}

- (void)show {
    [self dismiss];
    self.frame = CGRectMake(0, 108.f, SCREEN_WIDTH, SCREEN_HEIGHT - 108.f);
    self.cancel.frame = self.bounds;
    if (self.dataSource.count <= 6) {
        self.tableView.frame = CGRectMake(0, 0, self.width, self.dataSource.count * 44);
    }else {
        self.tableView.frame = CGRectMake(0, 0, self.width, 6 * 44);
    }
    
    [mKeyWindow addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentified = @"cell";
    SearchPOPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentified];
    if (cell == nil) {
        cell = [[SearchPOPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentified];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.content = self.dataSource[indexPath.row];
    if (indexPath.row == _currentSelectedIndex) {
        cell.isTapSelected = YES;
    }else {
        cell.isTapSelected = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _currentSelectedIndex = indexPath.row;
    [self.tableView reloadData];
    [self dismiss];
    if (self.searchIndex) {
        self.searchIndex(indexPath.row);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)cancel:(id)sender {
    [self removeFromSuperview];
    if (self.searchCancel) {
        self.searchCancel();
    }
}

@end
