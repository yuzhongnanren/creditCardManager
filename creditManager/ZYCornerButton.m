//
//  ZYCornerButton.m
//  wenyifan
//
//  Created by haodai on 15/12/17.
//  Copyright (c) 2015年 zhouyong. All rights reserved.
//

#import "ZYCornerButton.h"

@implementation ZYCornerButton

- (void)awakeFromNib {
    [self.layer setCornerRadius:5.f];
    [self.layer setMasksToBounds:YES];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
