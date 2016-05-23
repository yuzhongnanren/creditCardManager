//
//  AppFun.m
//  abc
//
//  Created by fengjia on 8/21/13.
//  Copyright (c) 2013 fengjia. All rights reserved.
//

#import "AppFun.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#include <netdb.h>
#include <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h>

@implementation AppFun

+ (id)sharedInstance {
    static AppFun *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AppFun alloc] init];
    });
    return instance;
}

- (void)dealloc {
    if (_dateTimeFormatter) {
        mSafeRelease(_dateTimeFormatter);
    }
    if (_numberFormatter) {
        mSafeRelease(_numberFormatter);
    }
    if (_reachability) {
        mSafeRelease(_reachability);
    }
    [super dealloc];
}
- (BOOL)isNull:(id)obj {
    if (!obj) {
        return YES;
    }
    if ([obj isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        if ([obj isEqualToString:@""]) {
            return YES;
        }
        if ([[obj lowercaseString] isEqualToString:@"null"]) {
            return YES;
        }
        if ([[obj lowercaseString] isEqualToString:@"<null>"]) {
            return YES;
        }
        if ([[obj lowercaseString] isEqualToString:@"(null)"]) {
            return YES;
        }
        if ([[obj lowercaseString] isEqualToString:@"[null]"]) {
            return YES;
        }
    }
    
    return NO;
}
- (NSString *)safeStringValue:(id)obj {
    if ([self isNull:obj]) {
        NSLog(@"对象是一个空值");
        return @"";
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)obj;
        return [self stringFromNumber:number];
    }
    if (![obj isKindOfClass:[NSString class]]) {
        NSLog(@"对象不是一个NSString类型");
        return @"";
    }
    return (NSString *)obj;
}
- (NSString *)convertURL:(NSString *)url {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
    return [[[NSString alloc] initWithData:data encoding:enc] autorelease];
}

- (NSString *)trim:(NSString *)str {
    if (str.length == 0) {
        return nil;
    }
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
#pragma mark - 文件路径相关
- (BOOL)copyItem:(NSString *)fromPath to:(NSString *)toPath isJudgeExist:(BOOL)isJudge {
    if (isJudge) {
        if (![mFileManager fileExistsAtPath:toPath]) {
            return [mFileManager copyItemAtPath:fromPath toPath:toPath error:nil];
        } else {
            NSLog(@"该文件已经存在: %@", toPath);
            return YES;
        }
    } else {
        return [mFileManager copyItemAtPath:fromPath toPath:toPath error:nil];
    }
}
- (BOOL)removeItemAtPath:(NSString *)itemPath {
    if (![mFileManager fileExistsAtPath:itemPath]) {
        NSLog(@"该文件不存在: %@", itemPath);
        return NO;
    }
    NSError *error = nil;
    if ([mFileManager removeItemAtPath:itemPath error:&error]) {
        return YES;
    } else {
        NSLog(@"删除文件失败: %@", error.userInfo);
        return NO;
    }
}
#pragma mark - 格式类相关
- (NSString *)convertDatetime:(long)timestamp {
    if (!_dateTimeFormatter) {
        _dateTimeFormatter = [[NSDateFormatter alloc] init];
    }
    NSDate *datetime = [NSDate dateWithTimeIntervalSince1970:timestamp];
    //比较该日期是否是当天日期
    NSDate *now = [NSDate date];
    [_dateTimeFormatter setDateFormat:DTFORMATE_SHORT1];
    NSLog(@"%@, %@", [_dateTimeFormatter stringFromDate:now], [_dateTimeFormatter stringFromDate:datetime]);
    if ([[_dateTimeFormatter stringFromDate:now] isEqualToString:[_dateTimeFormatter stringFromDate:datetime]]) {
        [_dateTimeFormatter setDateFormat:DTFORMATE_SHORT6];
    } else {
        [_dateTimeFormatter setDateFormat:DTFORMATE_MEDIUM1];
    }
    return [_dateTimeFormatter stringFromDate:datetime];
}

- (NSString *)convertDatetime:(long long)timestamp wihtFormat:(NSString *)formatter {
    if (!_dateTimeFormatter) {
        _dateTimeFormatter = [[NSDateFormatter alloc] init];
    }
    if (formatter) {
        [_dateTimeFormatter setDateFormat:formatter];
    } else {
        [_dateTimeFormatter setDateFormat:DTFORMATE_SHORT1];
    }
    NSDate *datetime = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [_dateTimeFormatter stringFromDate:datetime];
}
- (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)formatter {
    if (!_dateTimeFormatter) {
        _dateTimeFormatter = [[NSDateFormatter alloc] init];
    }
    if (formatter) {
        [_dateTimeFormatter setDateFormat:formatter];
    } else {
        [_dateTimeFormatter setDateFormat:DTFORMATE_SHORT1];
    }
    return [_dateTimeFormatter stringFromDate:date];
}
- (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)formatter {
    if (!_dateTimeFormatter) {
        _dateTimeFormatter = [[NSDateFormatter alloc] init];
    }
    if (formatter) {
        [_dateTimeFormatter setDateFormat:formatter];
    } else {
        [_dateTimeFormatter setDateFormat:DTFORMATE_SHORT1];
    }
    return [_dateTimeFormatter dateFromString:dateString];
}
- (NSString *)stringFromNumber:(NSNumber *)number {
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
    }
    _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *numberStr = [_numberFormatter stringFromNumber:number];
    return numberStr;
}

- (NSString *)showIntervalTime:(NSString *)datetime {
    NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *  senddate=[NSDate date];
    //结束时间
    NSDate *endDate = [dateFormatter dateFromString:datetime];
    //当前时间
    NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
    //得到相差秒数
    NSTimeInterval time=[senderDate timeIntervalSinceDate:endDate];
    
    int days = ((int)time)/(3600*24);
    NSString *showtime;
    NSLog(@"%d", days);
    if (days == 0) {
        int hour = ((int)time)/3600;
        if (hour == 0 ) {
            showtime = [NSString stringWithFormat:@"%d分钟前", ((int)time)/60];
        } else {
            showtime = [NSString stringWithFormat:@"%d小时前", hour];
        }
    } else {
        if (days <= 10) {
            showtime = [NSString stringWithFormat:@"%d天前", days];
        } else {
            showtime = datetime.length >= 10 ? [datetime substringToIndex:10] : @"";
        }
    }
    return showtime;
}

- (NSString *)showDate:(NSString *)datetime {
    NSString * showtime = datetime.length >= 10 ? [datetime substringToIndex:10] : @"";
    return showtime;
}
- (NSString *)showTime:(NSString *)datetime {
    NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //结束时间
    NSDate *endDate = [dateFormatter dateFromString:datetime];
    
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *showtime = [dateFormatter stringFromDate:endDate];
    return showtime;
}

#pragma mark - 视频、图片相关
- (UIImage *)getThumbImage:(NSString *)videoURL {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *assetImageGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    [asset release];
    assetImageGen.appliesPreferredTrackTransform = YES;
    //获取第0贞的缩略图
    CMTime time = CMTimeMakeWithSeconds(0.0, 60);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetImageGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    [assetImageGen release];
    if (!image) {
        NSLog(@"获取缩略图失败");
        return nil;
    }
    if (error) {
        NSLog(@"获取缩略图失败: %@", error.userInfo);
        CGImageRelease(image);
        return nil;
    }
    UIImage *thumbImage = [[[UIImage alloc] initWithCGImage:image] autorelease];
    CGImageRelease(image);
    return thumbImage;
}
- (UIImage *)clipImage:(UIImage *)image scaleToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();    
    // End the context
    UIGraphicsEndImageContext();    
    // Return the new image.
    return newImage;
}
- (UIImage *)clipImage:(UIImage *)image withRect:(CGRect)rect {
    CGImageRef cgimage = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *clipImage = [UIImage imageWithCGImage:cgimage];
    CGImageRelease(cgimage);
    return clipImage;
}
- (BOOL)writeImage:(UIImage *)image toDirectory:(NSString *)directory withName:(NSString *)imageName type:(ImageType)type {
    BOOL isDirectory = YES;
    if (![mFileManager fileExistsAtPath:directory isDirectory:&isDirectory]) {
        NSError *error = nil;
        if ([mFileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"创建新目录成功: %@", directory);
        } else {
            NSLog(@"创建目录失败 :%@", error.userInfo);
            return NO;
        }
    } else {
        NSLog(@"目录存在无需创建");
    }
    NSData *imageDate = nil;
    NSString *tmpPath = nil;
    if (type == TYPE_JPEG) {
        imageDate = UIImageJPEGRepresentation(image, 0.8);
        tmpPath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageName]];
    } else if (type == TYPE_PNG) {
        imageDate = UIImagePNGRepresentation(image);
        tmpPath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]];
    } else {
        NSLog(@"参数错误: type必须为TYPE_JPEG或者TYPE_PNG");
        return NO;
    }
    return [imageDate writeToFile:tmpPath atomically:YES];
}

#pragma mark -  程序、设备相关
- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)path {
    NSURL *URL = [NSURL fileURLWithPath:path];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.1) {
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.1) {
//        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
//        
//        const char* filePath = [[URL path] fileSystemRepresentation];
//        
//        const char* attrName = "com.apple.MobileBackup";
//        u_int8_t attrValue = 1;
        
//        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
//        return result == 0;
    }
    return 0;
}
- (void)checkAppUpdate:(void(^)(BOOL isNeedUpdate, NSString *appStoreVersion, NSString *appLocalVersion, NSString *updateInfo))block {
    
    NSURL *storeURL = [NSURL URLWithString:mAppUpdate];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if ( [data length] > 0 && !error ) { // Success            
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{                
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];                
                if ( ![versionsInAppStore count] ) { // No versions of app in AppStore
                    block(NO, @"", mAPPVersion, nil);
                    return;                    
                } else {                    
                    NSString *appStoreVersion = [versionsInAppStore objectAtIndex:0];
                    NSString *updateInfo = [[[appData valueForKey:@"results"] valueForKey:@"releaseNotes"] objectAtIndex:0];
                    if (![mAPPVersion isEqualToString:appStoreVersion]) {
                        block(YES, appStoreVersion, mAPPVersion, updateInfo);
                    } else {
                        block(NO, appStoreVersion, mAPPVersion, nil);
                    }
                }
            });
        }        
    }];
}

- (void)updateApp {
    NSURL *iTunesURL = [NSURL URLWithString:(Target_iOS7 == YES) ? mRateUrl_iOS7 : mAppUrl];
    [[UIApplication sharedApplication] openURL:iTunesURL];
}

- (BOOL)checkRateApp {
    BOOL isRateApp = NO;
    NSUserDefaults *mDefault = [NSUserDefaults standardUserDefaults];
    int rateCount = [mDefault integerForKey:@"rateCount"];
    if (rateCount >= 7) {
        rateCount = 0;
        isRateApp = YES;
    } else {
        rateCount++;
    }
    [mDefault setInteger:rateCount forKey:@"rateCount"];
    [mDefault synchronize];
    return isRateApp;
}
- (void)rateApp {
    NSURL *iTunesURL = [NSURL URLWithString:mRateUrl];
    if (Target_iOS7) {
        iTunesURL = [NSURL URLWithString:mRateUrl_iOS7];
    }
    [[UIApplication sharedApplication] openURL:iTunesURL];
}
- (void)usedSpaceAndFreeSpace:(NSString **)usedSpaceStr freeSpace:(NSString **)freeSpaceStr totalSpace:(NSString **)totalSpaceStr {
    NSDictionary *fileSysAttributes = [mFileManager attributesOfFileSystemForPath:mDocumentsDir error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    *freeSpaceStr = [NSString stringWithFormat:@"%0.2fG", [freeSpace longLongValue]/1024.0/1024.0/1024.0];
    *totalSpaceStr = [NSString stringWithFormat:@"%0.2fG", [totalSpace longLongValue]/1024.0/1024.0/1024.0];
    *usedSpaceStr = [NSString stringWithFormat:@"%0.2fG", ([totalSpace longLongValue] - [freeSpace longLongValue])/1024.0/1024.0/1024.0];
}
#pragma mark - 网络相关
- (BOOL)isConnectNetwork {
    Reachability *curReach= [Reachability reachabilityWithHostName:@"www.ablesky.com"];
    NetworkStatus status = [curReach currentReachabilityStatus];
    return (status == NotReachable) ? NO : YES;
}
- (BOOL)isWIFI {
    Reachability *curReach= [Reachability reachabilityWithHostName:@"www.ablesky.com"];
    NetworkStatus status = [curReach currentReachabilityStatus];
    return  status == ReachableViaWiFi;
}
- (NetworkStatus)networkStatus {
    Reachability *curReach= [Reachability reachabilityWithHostName:@"www.ablesky.com"];
    return  [curReach currentReachabilityStatus];
}
- (void)startNetworkNotify:(NetworkStatusBlock)block {
    [_networkBlock release];
    _networkBlock = [block copy];
    [mNotificationCenter removeObserver:self name:kReachabilityChangedNotification object:nil];
    [mNotificationCenter addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    _reachability= [[Reachability reachabilityWithHostName:@"www.ablesky.com"] retain];
    [_reachability startNotifier];
}
//当网络状态发生变化时调用此方法
- (void)reachabilityChanged:(NSNotification* )notify
{
    Reachability* curReach = [notify object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    _networkBlock(status);
    [mNotificationCenter postNotificationName:NetworkChangeNofication object:[NSNumber numberWithInt:status] userInfo:nil];
}

- (NSString *)parserDomainToStringIP:(NSString *)domainName {
    // Get host entry info for given host
    struct hostent *remoteHostEnt = gethostbyname([domainName UTF8String]);
    if (!remoteHostEnt) {
        return nil;
    }
    
    // Get address info from host entry
    struct in_addr *remoteInAddr = (struct in_addr *) remoteHostEnt->h_addr_list[0];
    if (!remoteHostEnt) {
        return nil;
    }
    // Convert numeric addr to ASCII string
    char *sRemoteInAddr = inet_ntoa(*remoteInAddr);
    
    return [NSString stringWithUTF8String:sRemoteInAddr];
}

- (NSString *)md5:(NSString *)key
{
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *strMd5 = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return strMd5;
}

@end
