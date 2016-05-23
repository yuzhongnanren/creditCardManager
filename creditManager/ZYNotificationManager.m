//
//  ZYNotificationManager.m
//  Shandai
//
//  Created by haodai on 15/12/28.
//  Copyright © 2015年 haodai. All rights reserved.
//

#import "ZYNotificationManager.h"
#import "ZYControllerManager.h"

@implementation ZYNotificationManager
+ (instancetype)shareInstance {
    static ZYNotificationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self class] new];
    });
    return manager;
}

- (void)registerRemoteNotification {
    if([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
//        if(![[UIApplication sharedApplication] isRegisteredForRemoteNotifications])
//        {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
//        }
//        else{
//            // do nothing now
//        }
    }
    else{
        // need avoid send always
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge];
    }
}

- (void)checkLaunchingOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSDictionary* localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(remoteNotification)
    {
        NSLog(@" start %@",remoteNotification);
    }
    else {
        NSLog(@"null");
        // not start
    }
    if (localNotification) {
        
    }else {
        
    }
}


-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSLog(@" 收到推送消息 ： %@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    if (userInfo) {
        NSInteger type = [[userInfo objectForKey:@"type"] integerValue];
        NSInteger menu = [[userInfo objectForKey:@"menu"] integerValue];
        if (type == 2) {
            [[ZYControllerManager manager] goH5WebPage:userInfo];
        }else if(type == 3) {
            switch (menu) {
                case 1:
                    break;
                case 2:
                    [[ZYControllerManager manager] goApplyCard];
                    break;
                case 3:
                    [[ZYControllerManager manager] goUserCenter];
                    break;
                case 4:
                    break;
                case 5:
                    break;
                case 6:
                    [[ZYControllerManager manager] goCardDiscount];
                    break;
                case 7:
                    [[ZYControllerManager manager] goCardRanking];
                    break;
                case 8:
                    [[ZYControllerManager manager] goCardInformation];
                    break;
                case 9:
                    [[ZYControllerManager manager] goCardService];
                    break;
                case 10:
                    [[ZYControllerManager manager] goStagingCalculator];
                    break;
                case 11:
                    [[ZYControllerManager manager] goCreditList];
                    break;
                case 12:
                    break;
                case 13:
                    break;
                case 14:
                    break;
                default:
                    break;
            }
        }
    }
}


-(void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    NSInteger length = [token length];
    token = [token substringWithRange:NSMakeRange(1, length - 2)];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[ZYCacheManager shareInstance] saveDeviceToken:token];
}


-(void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // need to do
    // need to get devicetoken again
    NSString * errorStr = [NSString stringWithFormat:@"error: %@",error];
    NSLog(@"get devicetoken error %@",errorStr);
}

- (void)registerLocalNotification:(NSInteger)days bankId:(NSInteger)bankId{
    if (days < 0) {
        return;
    }
    // 初始化本地通知对象
    [self closeAllNotification];
    
    for (int i = 0; i <= days + 3; i ++) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        if (notification) {
            // 设置通知的提醒时间
            NSDate *date = [NSDate date];//获取当前时间
            if (i == 0) {
                /**
                 *  判断今天提醒不提醒
                 */
                if (date.hour > 10) {
                    continue;
                }else if (date.hour == 10  && date.minute > 0) {
                    continue;
                }else if(date.hour == 10 && date.minute == 0 && date.seconds > 0) {
                    continue;
                }
            }
            NSDate *nextDate = [date dateByAddingDays:i];
    
            NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
            NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
            
            NSDateComponents * component=[calendar components:unitFlags fromDate:nextDate];
            NSInteger year = component.year;
            NSInteger month = component.month;
            NSInteger day = component.day;

            
            notification.timeZone = [NSTimeZone localTimeZone]; // 使用本地时区
            NSDate *firedate = [NSDate dateWithString:[NSString stringWithFormat:@"%04ld%02ld%02ld%@%02d%02d",(long)year,(long)month,(long)day,@"10",0,0] format:@"yyyyMMddHHmmss"];
            NSDate *localeDate = firedate;
            notification.fireDate = localeDate;
            
            // 设置提醒的文字内容
            if (i < days) {
                notification.alertBody   = [NSString stringWithFormat:@"您的信用卡还有%d天就要逾期了，请尽快还款",days - i];
                notification.alertAction = NSLocalizedString(@"确定", nil);
            }else {
                if (i - days == 0) {
                    notification.alertBody   = @"您的信用卡已到期，请尽快还款~";
                }else {
                    notification.alertBody   = [NSString stringWithFormat:@"您的信用卡已经逾期%d天了",i - days];
                }
                notification.alertAction = NSLocalizedString(@"确定", nil);
            }
           
            // 通知提示音 使用默认的
            notification.soundName= UILocalNotificationDefaultSoundName;
            
            // 设置应用程序右上角的提醒个数
            notification.applicationIconBadgeNumber++;
            
            // 设定通知的userInfo，用来标识该通知
            NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
            [aUserInfo setObject:@(bankId) forKey:@"key"];
            notification.userInfo = aUserInfo;
            
            // 将通知添加到系统中
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
    NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"%@",[[UIApplication sharedApplication] scheduledLocalNotifications]);
}


- (void)didReceiveLocalNotification:(UILocalNotification *)notification {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
    if(notification) {
        [[ZYControllerManager manager] goCreditList];
    }
}

- (void)closeLocalNotificationBankId:(NSInteger)bankId {
    NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (array.count == 0) {
        return;
    }
    UILocalNotification *notification = [array objectAtIndex:0];
    if ([[notification.userInfo objectForKey:@"key"] integerValue] == bankId) {
        [self closeAllNotification];
    }
}


- (void)closeAllNotification {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
