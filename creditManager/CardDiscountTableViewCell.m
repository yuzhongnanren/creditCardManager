//
//  CardDiscountTableViewCell.m
//  creditManager
//
//  Created by haodai on 16/3/11.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "CardDiscountTableViewCell.h"
@interface CardDiscountTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *bank;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightConstant;

@end

@implementation CardDiscountTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _lineHeightConstant.constant = 0.5;
    _img.contentMode = UIViewContentModeScaleAspectFill;
    _img.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setCardDiscount:(CardDiscount *)cardDiscount {
    if (cardDiscount == nil) {
        return;
    }
    _cardDiscount = cardDiscount;
    [_img sd_setImageWithURL:[NSURL URLWithString:cardDiscount.thumbnail] placeholderImage:[UIImage imageNamed:@"zixunPlacehold"]];
    _title.text = cardDiscount.title;
    if ([cardDiscount.ended_at integerValue] <= 0) {
        _endTime.text = @"长期有效";
    }else {
        _endTime.text = [NSString stringWithFormat:@"结束时间:%@", [NSString timeNumberConvertTime:cardDiscount.ended_at]];
    }
    _bank.text = cardDiscount.bank_name;
    
}

@end
