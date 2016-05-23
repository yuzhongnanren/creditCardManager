//
//  ZYControllerManager.m
//  creditManager
//
//  Created by haodai on 16/3/17.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "ZYControllerManager.h"
#import "ZYNavigationViewController.h"
#import "ZYTabViewController.h"
#import "MyCreditCardViewController.h"
#import "GuidePageViewController.h"
#import "CardDiscountViewController.h"
#import "CardInformationViewController.h"
#import "CardServerTableViewController.h"
#import "CardSortViewController.h"
#import "StagingCalculatorViewController.h"
#import "JCCBaseWebViewController.h"

@implementation ZYControllerManager
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static ZYControllerManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[ZYControllerManager alloc] init];
    });
    return manager;
}


- (void)goLogin:(UIViewController*)v {
    ZYNavigationViewController *login = StoryBoardDefined(@"loginNav");
    [v presentViewController:login animated:YES completion:NULL];
}

- (void)dismiss:(UIViewController*)v {
    ZYTabViewController *tab = (ZYTabViewController*)appDelegate().window.rootViewController;
    tab.selectedIndex = 2;
    [v dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)exitGoHome {
    ZYTabViewController *tab = (ZYTabViewController*)appDelegate().window.rootViewController;
    tab.selectedIndex = 0;
}

- (void)exitHomeGoLogin {
   ZYTabViewController *tab = (ZYTabViewController*)appDelegate().window.rootViewController;
    for (int i = 0; i < tab.viewControllers.count; i++) {
        ZYNavigationViewController *nav = [tab.viewControllers objectAtIndex:i];
        NSLog(@"%d",nav.viewControllers.count);
        if (nav.viewControllers.count > 1) {
            [nav popToRootViewControllerAnimated:YES];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的帐号在另一台设备上登录，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)goCreditList {
    ZYTabViewController *tab = (ZYTabViewController*)appDelegate().window.rootViewController;
//    for (int i = 0; i < tab.viewControllers.count; i++) {
//        ZYNavigationViewController *nav = [tab.viewControllers objectAtIndex:i];
//        NSLog(@"%d",nav.viewControllers.count);
//        if (nav.viewControllers.count > 1) {
//            [nav popToRootViewControllerAnimated:NO];
//        }
//    }
    if ([ZYCacheManager shareInstance].user.isLogin) {
         MyCreditCardViewController *my = StoryBoardDefined(@"MyCreditCardViewController");
        [tab.selectedViewController pushViewController:my animated:YES];
    }
}


- (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}

- (void)goGuideView:(UIWindow*)window {
    GuidePageViewController *guide = [[GuidePageViewController alloc] init];
    window.rootViewController = guide;
}

- (void)goHome:(UIWindow*)window {
     ZYTabViewController *tab = StoryBoardDefined(@"ZYTabViewController");
     window.rootViewController = tab;
}


- (void)goApplyCard {
    ZYTabViewController *tab = (ZYTabViewController*)appDelegate().window.rootViewController;
    tab.selectedIndex = 1;
}

- (void)goUserCenter {
    ZYTabViewController *tab = (ZYTabViewController*)appDelegate().window.rootViewController;
    tab.selectedIndex = 2;
}

- (void)goCardDiscount {
    ZYTabViewController *tab = (ZYTabViewController*)appDelegate().window.rootViewController;
    CardDiscountViewController *my = StoryBoardDefined(@"CardDiscountViewController");
    my.hidesBottomBarWhenPushed = YES;
    [tab.selectedViewController pushViewController:my animated:YES];
}

- (void)goCardRanking {
    ZYTabViewController *tab = (ZYTabViewController*)appDelegate().window.rootViewController;
    CardSortViewController *my = StoryBoardDefined(@"CardSortViewController");
    my.hidesBottomBarWhenPushed = YES;
    [tab.selectedViewController pushViewController:my animated:YES];
}

- (void)goCardInformation {
    ZYTabViewController *tab = (ZYTabViewController*)appDelegate().window.rootViewController;
    CardInformationViewController *my = StoryBoardDefined(@"CardInformationViewController");
    my.hidesBottomBarWhenPushed = YES;
    [tab.selectedViewController pushViewController:my animated:YES];
}

- (void)goCardService {
    ZYTabViewController *tab = (ZYTabViewController*)appDelegate().window.rootViewController;
    CardServerTableViewController *my = StoryBoardDefined(@"CardServerTableViewController");
    my.hidesBottomBarWhenPushed = YES;
    [tab.selectedViewController pushViewController:my animated:YES];
}

- (void)goStagingCalculator {
    ZYTabViewController *tab = (ZYTabViewController*)appDelegate().window.rootViewController;
    StagingCalculatorViewController *my = StoryBoardDefined(@"StagingCalculatorViewController");
    my.hidesBottomBarWhenPushed = YES;
    [tab.selectedViewController pushViewController:my animated:YES];
}

- (void)goH5WebPage:(NSDictionary*)dic {
    ZYTabViewController *tab = (ZYTabViewController*)appDelegate().window.rootViewController;
    JCCBaseWebViewController *web = [[JCCBaseWebViewController alloc] init];
    web.hidesBottomBarWhenPushed = YES;
    web.url = [dic objectForKey:@"link"];
    web.webTitle = [dic objectForKey:@"val"];
    [tab.selectedViewController pushViewController:web animated:YES];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
     ZYTabViewController *tab = (ZYTabViewController*)appDelegate().window.rootViewController;
    [self goLogin:tab];
}

@end
