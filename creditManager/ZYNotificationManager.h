//
//  ZYNotificationManager.h
//  Shandai
//
//  Created by haodai on 15/12/28.
//  Copyright © 2015年 haodai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYNotificationManager : NSObject
+ (instancetype)shareInstance;
/**
 *  注册远程通知
 */
- (void)registerRemoteNotification;
/**
 *  检测通知
 *
 *  @param launchOptions
 */
- (void)checkLaunchingOptions:(NSDictionary *)launchOptions;
/**
 *  取消通知
 */
- (void)closeAllNotification;
/**
 *  收到远程通知
 *
 *  @param userInfo
 */
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;
/**
 *  获取通知token
 *
 *  @param deviceToken
 */
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
/**
 *  获取token失败
 *
 *  @param error
 */
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
/**
 *  注册本地通知
 */
- (void)registerLocalNotification:(NSInteger)days bankId:(NSInteger)bankId;
/**
 *  关闭某个银行的本地通知
 *
 *  @param bankId 银行id
 */
- (void)closeLocalNotificationBankId:(NSInteger)bankId;
/**
 *  接受本地通知
 */
- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

@end
