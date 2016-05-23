//
//  JCCBaseViewController.h
//  JCC
//
//  Created by feng jia on 14-12-26.
//  Copyright (c) 2014年 jucaicun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JCCShowMode) {
    JCCPush = 1,
    JCCPresent
};

@interface JCCBaseViewController : UIViewController
@property(nonatomic,assign) JCCShowMode showMode;
@property(nonatomic,assign) BOOL hiddenBackBtn;//NO

- (void)clickBack:(id)sender;

@end
