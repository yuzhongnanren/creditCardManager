//
//  ZYCacheManager.h
//  Shandai
//
//  Created by haodai on 15/12/29.
//  Copyright © 2015年 haodai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "SubmitCredit.h"

@interface ZYCacheManager : NSObject
@property (nonatomic, strong) User *user;
+ (instancetype)shareInstance;
/**
 *  缓存用户表
 *
 *
 *  @return 返回bool
 */
- (BOOL)save;
/**
 *  获取本地缓存用户表
 *
 *  @return
 */
- (User *)localUser;

/**
 *  缓存用户的城市
 *
 *  @param dic dic description
 */
- (BOOL)saveRecentCity:(NSDictionary *)dic;
/**
 *  获取用户城市
 *
 *  @return
 */
- (NSArray*)getRecentCity;


/**
 *  缓存用户信用卡表单信息
 */
- (BOOL)saveCreditForm:(SubmitCredit*)credit;


/**
 *  获取用户信用卡表单信息
 */
- (SubmitCredit*)getCreditForm;

/**
 *  删除本地信用卡表单数据
 *
 *  @return
 */
- (BOOL)deleteCreditForm;
/**
 *  保存设备token
 *
 *  @param devicetoken
 */
- (void)saveDeviceToken:(NSString*)devicetoken;
/**
 *  获取设备token
 *
 *  @return
 */
- (NSString*)getDeviceToken;
/**
 *  token绑定是否成功
 *
 *  @param b YES 成功 NO 不成功
 */
- (void)deviceTokenUploadSuccess:(BOOL)b;
/**
 *  获取是否成功的状态
 *
 *  @return YES 成功 NO 不成功
 */
- (BOOL)getDeviceTokenSuccessStatus;

@end
