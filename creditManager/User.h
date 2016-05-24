//
//  User.h
//  zhengxin
//
//  Created by haodai on 15/9/25.
//  Copyright (c) 2015年 haodai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCopying,NSCoding>
@property (nonatomic, assign) NSInteger uid;//用户id
/**
 *  设备编号did和加密key是用户第一次启动app时根据手机设备生成的唯一编号和key
 */
@property (nonatomic, copy) NSString *did;//设备编号
@property (nonatomic, copy) NSString *secretKey;//加密key
@property (nonatomic, copy) NSString *city;//当前城市中文
@property (nonatomic, copy) NSString *city_s_EN;//当前城市英文

@property (nonatomic, copy) NSString *address;//个人中心所在城市
@property (nonatomic, copy) NSString *address_s_EN;//个人中心城市英文
@property (nonatomic, copy) NSString *address_Zone_Id;//个人中心城市id

@property (nonatomic, copy) NSString *nickname;//昵称
@property (nonatomic, copy) NSString *birthday;//生日
@property (nonatomic, assign) NSInteger sex;//性别  1男 2女 0保密
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *weixing;

@property (nonatomic, copy) NSString *telephone;//手机号
@property (nonatomic, copy) NSString *photoPath;//头像

@property (nonatomic, copy) NSString *loginTime;//暂时无用
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *id_card;//暂时无用
@property (nonatomic, assign) BOOL isLogin;//是否已经登录
@property (nonatomic, copy) NSString *is_set_passwd;//是否需要设置密码

@end
