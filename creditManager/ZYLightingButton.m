//
//  ZYLightingButton.m
//  creditManager
//
//  Created by haodai on 16/3/8.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "ZYLightingButton.h"

@implementation ZYLightingButton

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithHexColorString:@"eeeeee"];
    }else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

/* 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
