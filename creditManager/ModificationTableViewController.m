//
//  ModificationTableViewController.m
//  creditManager
//
//  Created by 刘欢 on 16/5/23.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "ModificationTableViewController.h"
#import "PellTableViewSelect.h"
#import "BangCreditTableViewController.h"
#import "ReactiveCocoa.h"
#import "HTTPClientManager.h"
#import "ZJSwitch.h"


@interface ModificationTableViewController ()
@property (nonatomic, assign) NSInteger credit_id;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *bank;
@property (weak, nonatomic) IBOutlet UILabel *cardNum;
@property (weak, nonatomic) IBOutlet UILabel *lastRepayment;
@property (weak, nonatomic) IBOutlet UILabel *creditLimit;
@property (weak, nonatomic) IBOutlet UILabel *billDay;
@property (weak, nonatomic) IBOutlet UILabel *payDay;
@property (weak, nonatomic) IBOutlet UILabel *freeDay;
@property (weak, nonatomic) IBOutlet ZJSwitch *swithBtn;

@end

@implementation ModificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.backgroundView = nil;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTintColor:[UIColor whiteColor]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 10, -23)];
    [button setTitle:@"..." forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:25];
    [button addTarget:self action:@selector(suspension) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    _credit_id = [self.creditCard.card_id integerValue];
    [self installCell];
    [self touchesa];
}
//设置cell及赋值
-(void)installCell
{
    ViewRadius(_backView, 5);
    _swithBtn.onTintColor = mBlueColor;
    _swithBtn.textFont = [UIFont systemFontOfSize:12];
    _swithBtn.textColor = [UIColor whiteColor];
    _swithBtn.onText = @"已还";
    _swithBtn.offText = @"未还";
    [_swithBtn addTarget:self action:@selector(touche:) forControlEvents:UIControlEventValueChanged];
}
//使数据刷新
-(void)touche:(ZJSwitch *)sender
{
    
}
-(void)touchesa
{
    [_img sd_setImageWithURL:[NSURL URLWithString:self.creditCard.bank_img]];
    _bank.text = self.creditCard.bank_name;
    _cardNum.text = [NSString stringWithFormat:@"********%@", self.creditCard.bank_num];
    _lastRepayment.text = [NSString stringWithFormat:@"%@",self.creditCard.time_left_show];
    _creditLimit.text = [NSString stringWithFormat:@"%@元",self.creditCard.card_limit];
    _billDay.text = [NSString stringWithFormat:@"每月%@日",self.creditCard.statement_date];
    _payDay.text = [NSString stringWithFormat:@"每月%@日",self.creditCard.repayment_date];
    _freeDay.text = [NSString stringWithFormat:@"%ld天",(long)self.creditCard.free_interest_time];
    _swithBtn.forbiddenSendAction = YES;
    _swithBtn.on = [self.creditCard.status integerValue];

}
//侧边栏
- (void)suspension
{
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(self.view.bounds.size.width, 64, 106, 72) selectData:@[@"编辑",@"删除"] images:@[@"tk_editor.png",@"tk_delete.png"] action:^(NSInteger index) {
        if (index == 0) {
            [self edit];
        }else{
            [self deleteCard];
        }
        
    } animated:YES];
}

//编辑
- (void)edit
{
    [MobClick event:@"editCredit"];
    BangCreditTableViewController *bang = StoryBoardDefined(@"BangCreditTableViewController");
    bang.type = Edit_Credit;
    @weakify(self);
    bang.mycredit = ^(MyCredit *coedit){
        @strongify(self);
        self.creditCard = coedit;
        [self installCell];
        [self touchesa];
    };
    bang.creditCard = self.creditCard;
    [self.navigationController pushViewController:bang animated:YES];
}
//删除
- (void)deleteCard {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您确定删除吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    @weakify(self);
    [alert.rac_buttonClickedSignal  subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if ([x integerValue] == 1) {
            [self deleteCreditCard];
        }
    }];
}

- (void)deleteCreditCard {
    [[HTTPClientManager manager] POST:@"UserCenter/del_bind_card?" dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid),@"id":@(_credit_id)} success:^(id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
        mAlertView(@"", @"信用卡删除成功");
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
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
