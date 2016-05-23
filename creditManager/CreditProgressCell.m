//
//  CreditProgressCell.m
//  creditManager
//
//  Created by haodai on 16/3/2.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "CreditProgressCell.h"
@interface CreditProgressCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *tip;

@end

@implementation CreditProgressCell

- (void)setProgressDic:(NSDictionary *)progressDic {
    _progressDic = progressDic;
    if (isNotNull([_progressDic objectForKey:@"bank_img"])) {
         [_iconImg sd_setImageWithURL:[NSURL URLWithString:[_progressDic objectForKey:@"bank_img"]]];
    }
    _bankName.text = [progressDic objectForKey:@"bank_name"];
}

@end
