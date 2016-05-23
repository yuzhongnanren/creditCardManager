//
//  UIViewController+DataNull.h
//  creditManager
//
//  Created by haodai on 16/3/26.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DataNull)
@property (nonatomic, readonly) UILabel *placeholderLabel;
@property (nonatomic, readonly) UIImageView *noDataImage;

- (void)setNoData;
- (void)setHasData;

@end
