//
//  CityViewController.h
//  creditManager
//
//  Created by haodai on 16/3/7.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CityViewController;
@protocol CityViewControllerDelegate <NSObject>

- (void)citySelectedUpdateData;

@end

@interface CityViewController : UIViewController
@property (nonatomic,  assign)id delegate;
/**
 *  当为0时表示首页定位的位置，1表示自己个人资料所在位置
 */
@property (nonatomic, assign) NSInteger type;

@end
