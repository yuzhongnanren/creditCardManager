//
//  WidthView.m
//  creditManager
//
//  Created by haodai on 16/3/29.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "WidthView.h"

@implementation WidthView
- (void)awakeFromNib {
    [self.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.firstAttribute == NSLayoutAttributeWidth) {
            obj.constant = 0.5;
            *stop = YES;
        }
    }];
}

@end
