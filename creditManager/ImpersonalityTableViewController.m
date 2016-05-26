//
//  ImpersonalityTableViewController.m
//  creditManager
//
//  Created by sks on 16/5/24.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "ImpersonalityTableViewController.h"
#import "ImpersonalityTableViewCell.h"
#import "UIViewController+DataNull.h"

@interface ImpersonalityTableViewController ()
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation ImpersonalityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电话信息";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self feachData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTels:(NSArray *)tels {
    if (tels) {
        _tels = tels;
        if ([_tels count] == 0) {
            [self setNoData];
        }else {
            [self setHasData];
            self.dataSource = tels;
            [self.tableView reloadData];
        }
    }
}

#pragma mark - Data
- (void)feachData {
    [[HTTPClientManager manager] POST:@"" dictionary:@{} success:^(id responseObject) {
        self.dataSource = [responseObject objectForKey:@"items"];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImpersonalityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.dic = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TelephoneWithNumber(self.view, [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"tel"]);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
