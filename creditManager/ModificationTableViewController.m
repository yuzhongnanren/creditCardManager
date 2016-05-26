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
#import "CardDiscountViewController.h"
#import "ImpersonalityTableViewController.h"

@interface ModificationTableViewController ()
@property (nonatomic, assign) NSInteger credit_id;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *bank;
@property (weak, nonatomic) IBOutlet UILabel *cardNum;
@property (weak, nonatomic) IBOutlet UILabel *lastRepayment;
@property (weak, nonatomic) IBOutlet UILabel *creditLimit;
@property (weak, nonatomic) IBOutlet UILabel *billDay;
@property (weak, nonatomic) IBOutlet UILabel *payDay;
@property (weak, nonatomic) IBOutlet UILabel *freeDay;
@property (weak, nonatomic) IBOutlet ZJSwitch *swithBtn;
@property (nonatomic, strong) NSArray *tels;

@end

@implementation ModificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    
    self.title = @"我的信用卡";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:mImageByName(@"gd_dian") style:UIBarButtonItemStyleBordered target:self action:@selector(suspension)];
    [self feachData];
    
    _credit_id = [self.creditCard.card_id integerValue];
    [self installCell];
    [self updateData];
}

#pragma mark - Setting
//设置cell及赋值
- (void)installCell
{
    _swithBtn.onTintColor = mBlueColor;
    _swithBtn.textFont = [UIFont systemFontOfSize:12];
    _swithBtn.textColor = [UIColor whiteColor];
    _swithBtn.onText = @"已还";
    _swithBtn.offText = @"未还";
    [_swithBtn addTarget:self action:@selector(touche:) forControlEvents:UIControlEventValueChanged];
}

- (void)updateData
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

#pragma mark - Data
- (void)feachData {
    [[HTTPClientManager manager] POST:@"UserCenter/get_bind_card_detail?" dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid),@"id":self.creditCard.card_id} success:^(id responseObject) {
        self.tels = [responseObject objectForKey:@"bank_tel_list"];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}


//使数据刷新
-(void)touche:(ZJSwitch *)sender
{
    [self postPayStatus:_swithBtn.on credit:self.creditCard];
}

- (void)postPayStatus:(BOOL)on credit:(MyCredit*)credit {
    [[HTTPClientManager manager] POST:@"UserCenter/change_bind_card_status?" dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid),@"id":credit.card_id,@"status":@(on)} success:^(id responseObject) {
        if (on) {
            [MobClick event:@"payStutasYes" attributes:@{@"bankName":credit.bank_name,@"creditId":[NSString stringWithFormat:@"%@",credit.card_id]}];
        }
        credit.status = [NSString stringWithFormat:@"%d",on];
    } failure:^(NSError *error) {
        [self.tableView reloadData];
    } view:mKeyWindow progress:YES];
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
        [self updateData];
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        CardDiscountViewController *discount = StoryBoardDefined(@"CardDiscountViewController");
        discount.bank_id = [self.creditCard.bank_id integerValue];
        [self.navigationController pushViewController:discount animated:YES];
    }else if(indexPath.row == 1) {
        ImpersonalityTableViewController  *tel = StoryBoardDefined(@"ImpersonalityTableViewController");
        tel.tels = self.tels;
        [self.navigationController pushViewController:tel animated:YES];
    }
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
