//
//  CreditTableViewCell.m
//  creditManager
//
//  Created by haodai on 16/3/3.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "CreditTableViewCell.h"
@interface CreditTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *creditImg;
@property (weak, nonatomic) IBOutlet UILabel *cardName;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *applyNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightConstant;

@end
@implementation CreditTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _lineHeightConstant.constant = 0.5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCredit:(CreditCard *)credit {
    if (credit == nil) {
        return;
    }
    _credit = credit;
    [_creditImg sd_setImageWithURL:[NSURL URLWithString:credit.img] placeholderImage:[UIImage imageNamed:@"creditPlacehold"]];
    _cardName.text = credit.name;
    _desc.text = credit.descr;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld人申请",(long)_credit.apply_count]];
    NSRange range = [[NSString stringWithFormat:@"%ld人申请",(long)_credit.apply_count] rangeOfString:[NSString stringWithFormat:@"%ld人",(long)_credit.apply_count]];
    [string addAttribute:NSForegroundColorAttributeName  value:[UIColor colorWithHexColorString:@"f7636e"] range:range];
    _applyNum.attributedText = string;
}

@end
