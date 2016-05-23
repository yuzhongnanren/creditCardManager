//
//  ZYControllerManager.h
//  creditManager
//
//  Created by haodai on 16/3/17.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYControllerManager : NSObject
+ (instancetype)manager;
/**
 *  去登录
 *
 *  @param v
 */
- (void)goLogin:(UIViewController*)v;
/**
 *  退出登录 跳到个人中心
 *
 *  @param v v description
 */
- (void)dismiss:(UIViewController*)v;

/**
 *  退出到首页
 */
- (void)exitGoHome;

/**
 *  退出到主界面在登录
 */
- (void)exitHomeGoLogin;

/**
 *  进入引导页
 */
- (void)goGuideView:(UIWindow*)window;
/**
 *  首页做root
 */
- (void)goHome:(UIWindow*)window;

/**
 *  跳到h5页面
 */
- (void)goH5WebPage:(NSDictionary*)dic;

/**
 *  获取推送通知进入界面
 */
- (void)goCreditList;
- (void)goApplyCard;
- (void)goUserCenter;
- (void)goCardDiscount;
- (void)goCardRanking;
- (void)goCardInformation;
- (void)goCardService;
- (void)goStagingCalculator;



@end
