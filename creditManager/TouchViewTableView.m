//
//  TouchViewTableView.m
//  creditManager
//
//  Created by haodai on 16/5/26.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "TouchViewTableView.h"

@implementation TouchViewTableView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
