//
//  CardInformationTableViewCell.m
//  creditManager
//
//  Created by haodai on 16/3/24.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "CardInformationTableViewCell.h"
@interface CardInformationTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cardImg;
@property (weak, nonatomic) IBOutlet UILabel *informationTitle;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation CardInformationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setDic:(NSDictionary *)dic {
    if (!dic) {
        return;
    }
    _dic = dic;
    if (!StringIsNull([dic objectForKey:@"ad_img"])) {
        [_cardImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"ad_img"]] placeholderImage:[UIImage imageNamed:@"zixunPlacehold"]];
    }
    _informationTitle.text = [_dic objectForKey:@"title"];
    _time.text = [_dic objectForKey:@"desc"];
}



@end
