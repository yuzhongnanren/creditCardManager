//
//  ImpersonalityTableViewCell.m
//  creditManager
//
//  Created by sks on 16/5/24.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "ImpersonalityTableViewCell.h"
@interface ImpersonalityTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *tel;

@end

@implementation ImpersonalityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDic:(NSDictionary *)dic {
    if (dic == nil) {
        return;
    }else {
        _dic = dic;
    }
    _name.text = [dic objectForKey:@"title"];
    _tel.text = [dic objectForKey:@"tel"];
}

@end
