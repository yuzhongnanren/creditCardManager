//
//  GuideView.h
//  creditManager
//
//  Created by haodai on 16/4/5.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BlockExit)(void);

@interface GuideView : UIView
@property (nonatomic, copy) BlockExit exit;

@end
