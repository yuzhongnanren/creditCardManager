//
//  HotBankView.m
//  creditManager
//
//  Created by haodai on 16/2/29.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "HotBankView.h"
@interface HotBankView ()
@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *applyNum;
@property (weak, nonatomic) IBOutlet UIImageView *lableImg;
@property (weak, nonatomic) IBOutlet UILabel *lableContent;

@end

@implementation HotBankView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setBank:(HotBank *)bank {
    _bank = bank;
    [_bankIcon sd_setImageWithURL:[NSURL URLWithString:bank.bank_img]];
    _bankName.text = bank.bank_name;
    _applyNum.text = [NSString stringWithFormat:@"%@人申请",bank.apply_count];
    if ([bank.label isEqualToString:@""]) {
        _lableContent.hidden = YES;
        _lableImg.hidden = YES;
    }else {
        _lableImg.hidden = NO;
        _lableContent.hidden = NO;
        _lableContent.text = bank.label;
    }
}



@end
