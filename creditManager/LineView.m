//
//  LineView.m
//  creditManager
//
//  Created by haodai on 16/3/25.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "LineView.h"

@implementation LineView

- (void)awakeFromNib {
   [self.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if (obj.firstAttribute == NSLayoutAttributeHeight) {
           obj.constant = 0.5;
           *stop = YES;
       }
   }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
