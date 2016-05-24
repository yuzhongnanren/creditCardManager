//
//  ChangePassTableViewController.m
//  creditManager
//
//  Created by haodai on 16/5/24.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "ChangePassTableViewController.h"
#import "ReactiveCocoa.h"
#import "AES128Base64Util.h"


@interface ChangePassTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPassWord;
@property (weak, nonatomic) IBOutlet UITextField *passwd;
@property (weak, nonatomic) IBOutlet UITextField *againPassWord;

@end

@implementation ChangePassTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码修改";
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    [self.oldPassWord.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.oldPassWord resignFirstResponder];
        }
    }];
    
    [self.passwd.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.passwd resignFirstResponder];
        }
    }];
    
    [self.againPassWord.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.againPassWord resignFirstResponder];
        }
    }];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source




/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

- (IBAction)save:(id)sender {
    if (![_oldPassWord hasText]) {
        mAlertView(@"", @"请输入旧密码");
        return;
    }
    if (![_passwd hasText]) {
        mAlertView(@"", @"请输入新密码")
        return;
    }
    if (![_againPassWord hasText]) {
        mAlertView(@"", @"请再次输入新密码");
        return;
    }
    if (![_passwd.text isEqualToString:_againPassWord.text]) {
        mAlertView(@"", @"您2次输入的密码不一样");
        return;
    }
    NSString *tel = [AES128Base64Util AES128Encrypt:[ZYCacheManager shareInstance].user.telephone withKey:[ZYCacheManager shareInstance].user.secretKey withIV:AUTH_IV];
    [[HTTPClientManager manager] POST:@"UserCenter/change_password" dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid),@"mobile":tel,@"checksms":@"",@"passwd":_passwd.text,@"confirm_passwd":_againPassWord.text,@"is_check_passwd":@"1",@"old_passwd":_oldPassWord.text} success:^(id responseObject) {
        mAlertView(@"", @"密码修改成功");
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
