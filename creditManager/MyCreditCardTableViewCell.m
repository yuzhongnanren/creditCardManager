//
//  MyCreditCardTableViewCell.m
//  creditManager
//
//  Created by haodai on 16/3/16.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "MyCreditCardTableViewCell.h"
#import "ZJSwitch.h"

@interface MyCreditCardTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *bank;
@property (weak, nonatomic) IBOutlet UILabel *cardNum;
@property (weak, nonatomic) IBOutlet ZJSwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UILabel *lastRepayment;
@property (weak, nonatomic) IBOutlet UILabel *creditLimit;
@property (weak, nonatomic) IBOutlet UILabel *billDay;
@property (weak, nonatomic) IBOutlet UILabel *payDay;
@property (weak, nonatomic) IBOutlet UILabel *freeDay;

@end

@implementation MyCreditCardTableViewCell

- (void)awakeFromNib {
    // Initialization code
    ViewRadius(_backView, 5);
    _switchBtn.onTintColor = mBlueColor;
    _switchBtn.textFont = [UIFont systemFontOfSize:12];
    _switchBtn.textColor = [UIColor whiteColor];
    _switchBtn.onText = @"已还";
    _switchBtn.offText = @"未还";
    [_switchBtn addTarget:self action:@selector(touche:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setCredit:(MyCredit *)credit {
    _credit = credit;
    [_img sd_setImageWithURL:[NSURL URLWithString:credit.bank_img]];
    _bank.text = credit.bank_name;
    _cardNum.text = [NSString stringWithFormat:@"********%@", credit.bank_num];
    _lastRepayment.text = [NSString stringWithFormat:@"%@",credit.time_left_show];
    _creditLimit.text = [NSString stringWithFormat:@"%@元",credit.card_limit];
    _billDay.text = [NSString stringWithFormat:@"每月%@日",credit.statement_date];
    _payDay.text = [NSString stringWithFormat:@"每月%@日",credit.repayment_date];
    _freeDay.text = [NSString stringWithFormat:@"%ld天",(long)credit.free_interest_time];
    _switchBtn.forbiddenSendAction = YES;
    _switchBtn.on = [credit.status integerValue];
}

- (void)touche:(ZJSwitch*)sender {
    if (self.tapSwitch) {
        self.tapSwitch(sender.on,_index);
    }
}


@end
