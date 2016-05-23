//
//  CreditListViewController.h
//  creditManager
//
//  Created by haodai on 16/3/3.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotBank.h"
@interface CreditListViewController : UIViewController
@property (nonatomic, strong) HotBank *bank;
/**
 *  当前主题的id
 */
@property (nonatomic, strong) NSString *currentTopic;
/**
 *  当前主题的名字
 */
@property (nonatomic, strong) NSString *currentTopicName;


@end
