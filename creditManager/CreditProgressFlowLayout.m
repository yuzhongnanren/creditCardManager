//
//  CreditProgressFlowLayout.m
//  creditManager
//
//  Created by haodai on 16/3/2.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "CreditProgressFlowLayout.h"

@implementation CreditProgressFlowLayout
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        //148 196
        self.itemSize = CGSizeMake((SCREEN_WIDTH - 1)/2, 115.0);//每个cell的大小
        self.minimumLineSpacing = 1.f;//每行的最小间距
        self.minimumInteritemSpacing = 0.5f;//每列的最小间距
//        self.sectionInset = UIEdgeInsetsMake(10,10,1,1);//网格视图的/上/左/下/右,的边距
    }
    
    return self;
}

@end
