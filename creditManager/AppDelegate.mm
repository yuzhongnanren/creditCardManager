//
//  AppDelegate.m
//  creditManager
//
//  Created by haodai on 16/2/17.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "AppDelegate.h"
#import "ZYNotificationManager.h"
#import "IMeiManager.h"
#import "SDiPhoneVersion.h"
#import "ZYLocationManager.h"
#import "MBProgressHUD.h"
#import "MobClick.h"
#import "ZYControllerManager.h"
#import "ZYTabViewController.h"

@interface AppDelegate ()<BMKGeneralDelegate>
@property (nonatomic, strong) BMKMapManager *mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
     self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.window makeKeyWindow];
    
    //是否第一次启动
    [self isFirstLaunch];
    
    //友盟统计
    [MobClick startWithAppkey:YouMeng_Key reportPolicy:SEND_INTERVAL   channelId:@"AppStore"];
    // 获取本地数据
    [[ZYCacheManager shareInstance] localUser];
    
    // 推送
    [[ZYNotificationManager shareInstance] registerRemoteNotification];
    [[ZYNotificationManager shareInstance] checkLaunchingOptions:launchOptions];
    
    // 定位
    self.mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定
    BOOL ret = [self.mapManager start:@"syPHKdZ38Gsis1RrnFEPGdk2"  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [[ZYLocationManager manager] fetchLocationSuccess:^(BMKReverseGeoCodeResult *result) {
        [ZYCacheManager shareInstance].user.lat = [NSString stringWithFormat:@"%f",result.location.latitude];
        [ZYCacheManager shareInstance].user.lng = [NSString stringWithFormat:@"%f",result.location.longitude];
        [[ZYCacheManager shareInstance] save];
        [self registerIMEI];
    } fail:^{
        [self registerIMEI];
    }];
    return YES;
}


//  曾经运行过程序
- (void)everLaunch
{
   [[ZYControllerManager manager] goHome:self.window];
}

//  第一次启动
- (void)firstLaunch {
    [[ZYControllerManager manager] goGuideView:self.window];
}

//  是否第一次启动
- (void)isFirstLaunch
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"] isEqualToString:currentVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"firstLaunch"];
        [self firstLaunch];
    }else {
        [self everLaunch];
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
     [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
     [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[ZYNotificationManager shareInstance] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}




-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[ZYNotificationManager shareInstance] didFailToRegisterForRemoteNotificationsWithError:error];
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState ==  UIApplicationStateActive) {
        ZYTabViewController *tab = (ZYTabViewController*)self.window.rootViewController;
        UITabBarItem *personItem = [tab.tabBar.items objectAtIndex:2];
        personItem.badgeValue = @"1";
        return;
    }
    [[ZYNotificationManager shareInstance] didReceiveRemoteNotification:userInfo];
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[ZYNotificationManager shareInstance] didReceiveLocalNotification:notification];
}

- (void)registerIMEI {
    //A5089E63-E683-4275-991F-F9AA1D540B3A
//    38.0874790000,114.5050290000
    NSString *imei = [[IMeiManager shareInstance] feathIMEI];
    NSLog(@"%@--%@",[ZYCacheManager shareInstance].user.did,[ZYCacheManager shareInstance].user.secretKey);
    if ([[ZYCacheManager shareInstance].user.did isEqualToString:Auth_Did] && [[ZYCacheManager shareInstance].user.secretKey isEqualToString:Auth_Key]) {
        NSDictionary *dic = @{@"os_type":@"2",@"imei":imei,@"name":[UIDevice currentDevice].name,@"app_v":mAPPVersion,@"sys_v":[UIDevice currentDevice].systemVersion,@"latitude":[ZYCacheManager shareInstance].user.lat,@"longitude":[ZYCacheManager shareInstance].user.lng};
        [[HTTPClientManager manager] RegisterDevice:@"/sys/register_device?" dictionary:dic success:^(id responseObject) {
            [ZYCacheManager shareInstance].user.did = [NSString stringWithFormat:@"%@" ,[responseObject objectForKey:@"did"]];
            [ZYCacheManager shareInstance].user.secretKey = [responseObject objectForKey:@"key"];
            [ZYCacheManager shareInstance].user.city_s_EN = [[responseObject objectForKey:@"city"] objectForKey:@"s_EN"];
            [ZYCacheManager shareInstance].user.city = [[responseObject objectForKey:@"city"] objectForKey:@"CN"];
            [[ZYCacheManager shareInstance] save];
            [[ZYCacheManager shareInstance] saveRecentCity:@{@"CN":[[responseObject objectForKey:@"city"]objectForKey:@"CN"],@"s_EN":[[responseObject objectForKey:@"city"]objectForKey:@"s_EN"],@"zone_id":[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"city"]objectForKey:@"zone_id"]]}];
            [self uploadDeviceToken];
            [mNotificationCenter postNotificationName:@"UpdateHomeData" object:nil];
        } failure:^(NSError *error) {
            [mNotificationCenter postNotificationName:@"UpdateHomeData" object:nil];
        } view:self.window progress:YES];
    }else {
            [mNotificationCenter postNotificationName:@"UpdateHomeData" object:nil];
    }
}

- (void)uploadDeviceToken {
    if ([[ZYCacheManager shareInstance] getDeviceTokenSuccessStatus]) {
        //如果绑定成功了就返回
        return;
    }
    if ([[[ZYCacheManager shareInstance] getDeviceToken] isEqualToString:@""]) {
        return;
    }
    [[HTTPClientManager manager] POST:@"/sys/up_push_code?" dictionary:@{@"pushcode":[[ZYCacheManager shareInstance] getDeviceToken],@"is_enterprise":@"0"} success:^(id responseObject) {
        [[ZYCacheManager shareInstance] deviceTokenUploadSuccess:YES];
    } failure:^(NSError *error) {
        [[ZYCacheManager shareInstance] deviceTokenUploadSuccess:NO];
    } view:self.window progress:NO];
}

@end
