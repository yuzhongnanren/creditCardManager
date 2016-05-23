//
//  ZYLocationManager.h
//  EngineeringStructure
//
//  Created by haodai on 15/8/21.
//  Copyright (c) 2015年 haodai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>

typedef void (^LocationBlock)(BMKReverseGeoCodeResult*result);
typedef void (^LocationFailBlock)(void);

@interface ZYLocationManager : NSObject
/**
 *  单例
 *
 *  @return ZYLocationManager
 */
+ (instancetype)manager;

/**
 *  获取位置信息
 *
 *  @param success success description
 *  @param fail    fail description
 */
- (void)fetchLocationSuccess:(LocationBlock)success fail:(LocationFailBlock)fail;

/**
 *  停止定位
 */
- (void)stopLocation;



@end
