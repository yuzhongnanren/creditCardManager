//
//  AppFun.h
//  abc
//
//  Created by fengjia on 8/21/13.
//  Copyright (c) 2013 fengjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

typedef enum {
    TYPE_JPEG = 0,
    TYPE_PNG = 1
} ImageType;
//定义消息通知和key名
#define NetworkChangeNofication           @"NetworkChangeNofication"
#define NetworkStatusKey                  @"NetworkStatusKey"
//定义检测网络状态变化block
typedef void(^NetworkStatusBlock)(NetworkStatus status);

#define DTFORMATE_LONG1    @"yyyy-MM-dd HH:mm:ss"  // 2013-08-20 14:35:02
#define DTFORMATE_LONG2    @"M/d/yyyy H:mm:ss"     // 8/20/2012 14:35:02
#define DTFORMATE_MEDIUM1  @"yyyy-MM-dd HH:mm"   // 2013-08-20 14:35
#define DTFORMATE_MEDIUM2  @"M/d/yyyy H:mm"      // 8/20/2012 14:35
#define DTFORMATE_MEDIUM3  @"MM-dd HH:mm"        // 08-20 14:35
#define DTFORMATE_MEDIUM4  @"M/d H:mm"           // 8/20 14:35
#define DTFORMATE_SHORT1   @"yyyy-MM-dd"          // 2013-08-20
#define DTFORMATE_SHORT2   @"MM-dd"               // 08-20
#define DTFORMATE_SHORT3   @"M/d/yyyy"            // 8/20/2012
#define DTFORMATE_SHORT4   @"M/d"                 // 8/20
#define DTFORMATE_SHORT5   @"HH:mm:ss"            // 14:35:02
#define DTFORMATE_SHORT6   @"HH:mm"               // 14:35
#define DTFORMATE_SHORT7   @"M月d日"              // 4月6日
// ……
// 格式也可自行定义


@interface AppFun : NSObject {
    NSDateFormatter *_dateTimeFormatter;
    NSNumberFormatter *_numberFormatter;
    NetworkStatusBlock _networkBlock;
    
    Reachability *_reachability;
}
+ (id)sharedInstance;
//判断对象是否为空
- (BOOL)isNull:(id)obj;
//获取安全的string值，无论类型如何
- (NSString *)safeStringValue:(id)obj;
//请求url时包含中文需要对其进行转码
- (NSString *)convertURL:(NSString *)url;
- (NSString *)trim:(NSString *)str;
/*--------------------------------------文件路径相关----------------------------------------*/
//复制文件 isJudgeExist:是否判断存在，若是，如果存在不copy，不存在copy；若不是，无论存在与否都copy
- (BOOL)copyItem:(NSString *)fromPath to:(NSString *)toPath isJudgeExist:(BOOL)isJudge;
//删除指定路径的文件
- (BOOL)removeItemAtPath:(NSString *)itemPath;

/*--------------------------------------格式类相关-------------------------------------------*/
//时间日期相关
- (NSString *)convertDatetime:(long)timestamp;
- (NSString *)convertDatetime:(long long)timestamp wihtFormat:(NSString *)formatter;
- (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)formatter;
- (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)formatter;
//NSNumber格式转换
- (NSString *)stringFromNumber:(NSNumber *)number;
- (NSString *)showIntervalTime:(NSString *)datetime;
- (NSString *)showDate:(NSString *)datetime;
- (NSString *)showTime:(NSString *)datetime;

/*--------------------------------------视频图片相关------------------------------------------*/
//获取指定路径视频的缩略图
- (UIImage *)getThumbImage:(NSString *)videoURL;
//图片的裁剪
- (UIImage *)clipImage:(UIImage *)image scaleToSize:(CGSize)newSize;
- (UIImage *)clipImage:(UIImage *)image withRect:(CGRect)rect;
//将图片写入指定目录
- (BOOL)writeImage:(UIImage *)image toDirectory:(NSString *)directory withName:(NSString *)imageName type:(ImageType)type;

/*--------------------------------------程序、设备相关-----------------------------------------*/
//禁掉指定路径的back up（icloud）功能
- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)path;
//检测appstore版本号进而确定是否需要进行更新
- (void)checkAppUpdate:(void(^)(BOOL isNeedUpdate, NSString *appStoreVersion, NSString *appLocalVersion, NSString *updateInfo))block;
- (void)updateApp;
//对应用进行评价
- (BOOL)checkRateApp;
- (void)rateApp;
//获取设备的已占用和剩余空间的大小,调用方法前创建三个字符串指针作为参数用于返回数据eg.NSString *usedSpace=nil, *freeSpace=nil
- (void)usedSpaceAndFreeSpace:(NSString **)usedSpaceStr freeSpace:(NSString **)freeSpaceStr totalSpace:(NSString **)totalSpaceStr;

/*------------------网络相关(需要导入Reachability类、SystemConfiguration.framework)---------------*/
//检测网络是否连通
- (BOOL)isConnectNetwork;
//检测是否WIFI
- (BOOL)isWIFI;
//检测网络类型
- (NetworkStatus)networkStatus;
//开启网络状态变化检测
- (void)startNetworkNotify:(NetworkStatusBlock)block;
//域名解析
- (NSString *)parserDomainToStringIP:(NSString *)domainName;

- (NSString *)md5:(NSString *)key;


@end


