//
//  MKBadgeView.h
//  ZJT
//
//  Created by wangcy on 14-12-9.
//  Copyright (c) 2014年 zjt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKBadgeView : UIView
@property(nonatomic,strong)NSString *badgeValue;
@property (nonatomic) UIColor *badgeBGColor;
// Badge text color
@property (nonatomic) UIColor *badgeTextColor;
// Badge font
@property (nonatomic) UIFont *badgeFont;
- (void)updateBadgeValueAnimated:(BOOL)animated;

@end
