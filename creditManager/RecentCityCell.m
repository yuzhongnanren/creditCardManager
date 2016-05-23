//
//  RecentCityCell.m
//  creditManager
//
//  Created by haodai on 16/3/8.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "RecentCityCell.h"
#import "ZYLightingButton.h"

@implementation RecentCityCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setRecentCitys:(NSArray *)recentCitys {
    if (recentCitys.count == 0) {
        return;
    }
    _recentCitys = recentCitys;
   [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       [obj removeFromSuperview];
   }];
   
    for (int i = 0; i < recentCitys.count; i ++) {
        ZYLightingButton *btn = [ZYLightingButton buttonWithType:UIButtonTypeCustom];
        if (i < 3) {
            btn.frame = CGRectMake(15.f + (80.f + 15.f)*i, 9.f, 80.f, 25.f);
        }else {
            btn.frame = CGRectMake(15.f + (80.f + 15.f)*(i - 3), 9.f + 25.f + 9.f, 80.f, 25.f);
        }
        [btn addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 2000 + i;
        [btn setTitle:[[recentCitys objectAtIndex:i] objectForKey:@"CN"] forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor colorWithHexColorString:@"47494f"] forState:0];
        ViewBorderRadius(btn, 1, 1, BackgroundColor);
        [self.contentView addSubview:btn];
    }
    
}

- (void)chooseCity:(UIButton*)sender {
    if (self.cityBlock) {
        self.cityBlock(sender.tag - 2000);
    }
}




@end
