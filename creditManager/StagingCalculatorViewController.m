//
//  StagingCalculatorViewController.m
//  creditManager
//
//  Created by haodai on 16/3/7.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "StagingCalculatorViewController.h"
#import "JCCPickerView.h"
#import "ReactiveCocoa.h"

@interface StagingCalculatorViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startCalculateBtn;
@property (nonatomic, strong) NSArray *allBanks;
@property (nonatomic, strong) NSArray *stages_rate;
@property (nonatomic, assign) BOOL isBankSelected;
@property (nonatomic, assign) NSInteger currentBankIndex;
@property (nonatomic, assign) NSInteger  period;//期数
@property (nonatomic, assign) CGFloat rate;//利率

@property (nonatomic, strong) JCCPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *stageMoney;
@property (weak, nonatomic) IBOutlet UILabel *currentBank;
@property (weak, nonatomic) IBOutlet UILabel *stageNum;
/**
 *  每月还款
 */
@property (weak, nonatomic) IBOutlet UILabel *monthMoeny;
/**
 * 总还款金额（＋利息）
 */
@property (weak, nonatomic) IBOutlet UILabel *totalMOney;
/**
 *  总利息
 */
@property (weak, nonatomic) IBOutlet UILabel *totalInterest;
/**
 *  期数
 */
@property (weak, nonatomic) IBOutlet UILabel *stageNumDes;
/**
 *  第一期的还款
 */
@property (weak, nonatomic) IBOutlet UILabel *firstPay;


@end

@implementation StagingCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.separatorColor = [UIColor colorWithHexColorString:@"f0f0f0"];
    _isBankSelected = NO;
    ViewRadius(_startCalculateBtn, 5);
    
    [self.stageMoney.rac_textSignal subscribeNext:^(NSString *x) {
        if ([x isEqualToString:@"\n"]) {
            [self.stageMoney resignFirstResponder];
        }
        [self clearData];
    }];
    
    [self feachData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)feachData {
    [[HTTPClientManager manager] POST:@"/credit/get_bank_list_all?" dictionary:@{} success:^(id responseObject) {
        self.allBanks = [responseObject objectForKey:@"items"];
    } failure:^(NSError *error) {
        
    } view:self.view progress:YES];
}

#pragma  mark - 
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self.view endEditing:YES];
        [self chooseBank];
    }else if(indexPath.row == 2) {
        [self.view endEditing:YES];
        [self chooseStage];
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

- (void)chooseBank {
    if (!self.pickerView) {
        _pickerView = [[[NSBundle mainBundle] loadNibNamed:@"JCCPickerView" owner:self options:nil] objectAtIndex:0];
    }
    @weakify(self);
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in self.allBanks) {
        [temp addObject:[dic objectForKey:@"bank_name"]];
    }
    _currentBankIndex = [temp indexOfObject:_currentBank.text];
    [self.pickerView configDatasource:temp title:@"" selectRow:_currentBankIndex block:^(NSString *content,NSInteger index) {
        @strongify(self);
        if (content != nil) {
            _currentBankIndex = [temp indexOfObject:content];
            self.currentBank.text = content;
             _stageNum.text = @"请选择分期期数";
            _isBankSelected = YES;
            [self clearData];
        }
    }];
    [self.pickerView show];
    
}

- (void)chooseStage {
    if (!_isBankSelected) {
        mAlertView(@"", @"请先选择银行");
        return;
    }
    if (!self.pickerView) {
        _pickerView = [[[NSBundle mainBundle] loadNibNamed:@"JCCPickerView" owner:self options:nil] objectAtIndex:0];
    }
    @weakify(self);
    NSArray *v = [[self.allBanks objectAtIndex:_currentBankIndex] objectForKey:@"stages_rate_arr"];
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:1];
    if (v.count != 0) {
        self.stages_rate = v;
        [self.stages_rate enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [keys addObject:[NSString stringWithFormat:@"%@期",obj.allKeys.firstObject]];
        }];
    }else {
        mAlertView(@"", @"该银行暂无分期信息");
        return;
    }
    NSInteger rate_index = [keys indexOfObject:_stageNum.text];
    [self.pickerView configDatasource:keys title:@"" selectRow:rate_index block:^(NSString *content,NSInteger index) {
        @strongify(self);
        if (content != nil) {
            self.stageNum.text = content;
            _period = [content integerValue];
            NSString *s = [[self.stages_rate objectAtIndex:index] objectForKey:[content stringByReplacingOccurrencesOfString:@"期" withString:@""]];
            _rate = [s floatValue]/100;
            [self clearData];
        }
    }];
    [self.pickerView show];
}

- (IBAction)startCalculate:(id)sender {
    [self.view endEditing:YES];
    if (![_stageMoney hasText]) {
        mAlertView(@"", @"请输入分期金额");
        return;
    }
    NSString *str = [_stageMoney.text stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(str.length > 0)
    {
        mAlertView(@"", @"请输入合法的分期金额");
        return;
    }
    if (!_isBankSelected) {
        mAlertView(@"", @"请先选择银行");
        return;
    }
    if ([_stageNum.text isEqualToString:@"请选择分期期数"]) {
        mAlertView(@"", @"请选择分期期数");
        return;
    }
    if ([_stageMoney.text floatValue] < [[[self.allBanks objectAtIndex:_currentBankIndex] objectForKey:@"stages_rate_min"] floatValue]) {
        mAlertView(@"", @"您的金额低于最低分期金额");
        return;
    }
    [self calculate];
}

- (void)calculate {
//    招行提供3期、6期、10期、12期、18期和24期，对应的每期手续费率为0.9%、0.75%、0.7%、0.66%、0.68%、0.68% ，手续费一次性收取。
//    分12期，第一期还款=4000/12+4000*12*0.66%=650.13，后11期每期还款333.33；
//    张振利  15:57:32
//    账单分期与单笔分期金额达20001元及以上，手续费分期收取；20000元及以下，手续费一次性收取。分期业务申请成功后，手续费将根据对应的收取方式分期或一次性计入持卡人信用卡账户，一经收取，不予退还。
//    手续费支付方式(1、一次性支付，2、分期收取，3、阶梯收取(中信银行)，0、暂时无法计算）
    NSString *stages_rate_t = [[self.allBanks objectAtIndex:_currentBankIndex] objectForKey:@"stages_rate_t"];
    if ([stages_rate_t integerValue] == 0) {
        mAlertView(@"", @"暂时无法计算");
        return;
    }else if([stages_rate_t integerValue] == 1) {
        _firstPay.text = [NSString stringWithFormat:@"%.2f",[_stageMoney.text floatValue]/_period + [_stageMoney.text floatValue]*_period*_rate];
        _monthMoeny.text = [NSString stringWithFormat:@"%.2f",[_stageMoney.text floatValue]/_period];
        _totalMOney.text = [NSString stringWithFormat:@"%.2f",[_firstPay.text floatValue] + [_monthMoeny.text floatValue]*(_period - 1)];
        _totalInterest.text = [NSString stringWithFormat:@"%.2f",[_stageMoney.text floatValue]*_period*_rate];
        _stageNumDes.text = _stageNum.text;
    }else if([stages_rate_t integerValue] == 2) {
        _firstPay.text = [NSString stringWithFormat:@"%.2f",[_stageMoney.text floatValue]/_period + [_stageMoney.text floatValue]*_rate];
        _monthMoeny.text = _firstPay.text;
        _totalMOney.text = [NSString stringWithFormat:@"%.2f",[_firstPay.text floatValue] *_period];
        _totalInterest.text = [NSString stringWithFormat:@"%.2f",[_stageMoney.text floatValue]*_period*_rate];
        _stageNumDes.text = _stageNum.text;
    }else if([stages_rate_t integerValue] == 3) {
        if ([_stageMoney.text floatValue] <= [[[self.allBanks objectAtIndex:_currentBankIndex] objectForKey:@"stages_rate_ladder"] floatValue]) {
            _firstPay.text = [NSString stringWithFormat:@"%.2f",[_stageMoney.text floatValue]/_period + [_stageMoney.text floatValue]*_period*_rate];
            _monthMoeny.text = [NSString stringWithFormat:@"%.2f",[_stageMoney.text floatValue]/_period];
            _totalMOney.text = [NSString stringWithFormat:@"%.2f",[_firstPay.text floatValue] + [_monthMoeny.text floatValue]*(_period - 1)];
            _totalInterest.text = [NSString stringWithFormat:@"%.2f",[_stageMoney.text floatValue]*_period*_rate];
            _stageNumDes.text = _stageNum.text;
        }else {
            _firstPay.text = [NSString stringWithFormat:@"%.2f",[_stageMoney.text floatValue]/_period + [_stageMoney.text floatValue]*_rate];
            _monthMoeny.text = _firstPay.text;
            _totalMOney.text = [NSString stringWithFormat:@"%.2f",[_firstPay.text floatValue] *_period];
            _totalInterest.text = [NSString stringWithFormat:@"%.2f",[_stageMoney.text floatValue]*_period*_rate];
            _stageNumDes.text = _stageNum.text;
        }
    }
}

- (void)clearData {
    _firstPay.text = @"";
    _monthMoeny.text = @"";
    _totalMOney.text = @"";
    _totalInterest.text = @"";
    _stageNumDes.text = @"";
 
}



@end
