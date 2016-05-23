//
//  BangCreditTableViewController.m
//  creditManager
//
//  Created by haodai on 16/3/22.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "BangCreditTableViewController.h"
#import "ReactiveCocoa.h"

@interface BangCreditTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *bank;
@property (weak, nonatomic) IBOutlet UITextField *cardNumber;
@property (weak, nonatomic) IBOutlet UITextField *totalCost;
@property (weak, nonatomic) IBOutlet UITextField *billDay;
@property (weak, nonatomic) IBOutlet UITextField *payDay;
@property (nonatomic, strong) NSArray *banks;
@property (nonatomic, strong) NSArray *bankNames;
@property (nonatomic, strong) NSMutableArray *days;
@property (nonatomic, assign) NSInteger credit_id;
@property (nonatomic, assign) NSInteger billDay_Int;
@property (nonatomic, assign) NSInteger payDay_Int;
@property (weak, nonatomic) IBOutlet UIButton *bangBtn;

@end

@implementation BangCreditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _bank.enabled = NO;
    _billDay.enabled = NO;
    _payDay.enabled = NO;
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    
    self.days = [NSMutableArray arrayWithCapacity:1];
    if (_type == Bang_Credit) {
        _credit_id = 0;
        self.title = @"绑定信用卡";
        [_bangBtn setTitle:@"绑定" forState:0];
    }else if (_type == Edit_Credit) {
        /**
         *  银行和卡号禁止编辑
         */
        self.title = @"编辑信用卡";
        [_bangBtn setTitle:@"保存" forState:0];
        _credit_id = [self.creditCard.card_id integerValue];
        _bank.text = self.creditCard.bank_name;
        _bank.enabled = NO;
        _bank.textColor = TextColorTip;
        _cardNumber.enabled = NO;
        _cardNumber.textColor = TextColorTip;
        _cardNumber.text = self.creditCard.bank_num;
        _totalCost.text = self.creditCard.card_limit;
        _billDay.text = [NSString stringWithFormat:@"每月%@日",self.creditCard.statement_date];
        _payDay.text = [NSString stringWithFormat:@"每月%@日",self.creditCard.repayment_date];
        _billDay_Int = [self.creditCard.statement_date integerValue];
        _payDay_Int = [self.creditCard.repayment_date integerValue];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteCard)];
        self.navigationItem.rightBarButtonItem = right;

    }
    for (int i = 1; i <= 28; i++) {
        [self.days addObject:[NSString stringWithFormat:@"每月%d日",i]];
    }
    [self.cardNumber.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.cardNumber resignFirstResponder];
        }
    }];
    
    [self.totalCost.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.totalCost resignFirstResponder];
        }
    }];
    
    [self feachData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)feachData {
    [[HTTPClientManager manager] POST:@"/credit/get_bank_list_all?" dictionary:@{} success:^(id responseObject) {
        self.banks = [responseObject objectForKey:@"items"];
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:1];
        [self.banks enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [temp addObject:[obj objectForKey:@"bank_name"]];
        }];
        self.bankNames = temp;
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}

#pragma mark - 
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if (_type == Edit_Credit) {
            return;
        }
        UIAlertView *alert = [[UIAlertView alloc] init];
         [self.bankNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             [alert addButtonWithTitle:obj];
         }];
        [alert show];
        @weakify(self);
        [alert.rac_buttonClickedSignal  subscribeNext:^(NSNumber *x) {
            @strongify(self);
            self.bank.text = [self.bankNames objectAtIndex:[x integerValue]];
        }];
    }else if (indexPath.row == 3) {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [self.days enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [alert addButtonWithTitle:obj];
        }];
        [alert show];
        @weakify(self);
        [alert.rac_buttonClickedSignal  subscribeNext:^(NSNumber *x) {
            @strongify(self);
            _billDay_Int = [x integerValue] + 1;
            self.billDay.text = [self.days objectAtIndex:[x integerValue]];
        }];

    }else if (indexPath.row == 4) {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [self.days enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [alert addButtonWithTitle:obj];
        }];
        [alert show];
        @weakify(self);
        [alert.rac_buttonClickedSignal  subscribeNext:^(NSNumber *x) {
            @strongify(self);
            _payDay_Int = [x integerValue] + 1;
            self.payDay.text = [self.days objectAtIndex:[x integerValue]];
        }];
    }
}

- (IBAction)save:(id)sender {
    if (![_bank hasText]) {
        mAlertView(@"", @"请选择银行");
        return;
    }
    if (![_cardNumber hasText]) {
        mAlertView(@"", @"请输入卡后4位");
        return;
    }
    if (![_totalCost hasText]) {
        mAlertView(@"", @"请输入总额度");
        return;
    }
    if (![_billDay hasText]) {
        mAlertView(@"", @"请选择账单日");
        return;
    }
    if (![_payDay hasText]) {
        mAlertView(@"", @"请选择还款日");
        return;
    }
    BOOL b =  [NSString validateBankCardLastNumber:_cardNumber.text];
    if (!b) {
        mAlertView(@"", @"请输入正确的信用卡后4位");
        return;
    }
    NSScanner* scan = [NSScanner scannerWithString:_totalCost.text];
    int val;
    BOOL p  = [scan scanInt:&val] && [scan isAtEnd];
    if (!p) {
        mAlertView(@"", @"总额度必须是纯数字");
        return;
    }
    [[HTTPClientManager manager] POST:@"UserCenter/bind_card?" dictionary:@{@"uid":@([ZYCacheManager shareInstance].user.uid),@"id":@(_credit_id),@"bank_id":[[self.banks objectAtIndex:[self.bankNames indexOfObject:_bank.text]] objectForKey:@"bank_id"],@"bank_num":_cardNumber.text,@"card_limit":_totalCost.text,@"statement_date":@(_billDay_Int),@"repayment_date":@(_payDay_Int)} success:^(id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
