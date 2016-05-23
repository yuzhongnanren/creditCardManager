//
//  ZYTabViewController.m
//  EngineeringStructure
//
//  Created by haodai on 15/9/16.
//  Copyright (c) 2015年 haodai. All rights reserved.
//

#import "ZYTabViewController.h"
#import "UserTableViewController.h"
#import "ZYNavigationViewController.h"
#import "ZYControllerManager.h"

@interface ZYTabViewController ()<UITabBarControllerDelegate>

@end

@implementation ZYTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [UIColor colorWithHexColorString:@"f0f0f0"].CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    
    UITabBarItem *hotItem    = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *allItem    = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *personItem = [self.tabBar.items objectAtIndex:2];
    self.delegate = self;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)  {
        self.tabBar.translucent = NO;
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10],NSFontAttributeName, nil] forState:UIControlStateNormal];
//
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexColorString:@"00aaee"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexColorString:@"808080"],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        
        hotItem.image = [[UIImage imageNamed:@"homel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        hotItem.selectedImage = [[UIImage imageNamed:@"homeh"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        allItem.image = [[UIImage imageNamed:@"cardl"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        allItem.selectedImage = [[UIImage imageNamed:@"cardh"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        personItem.image = [[UIImage imageNamed:@"myl"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        personItem.selectedImage = [[UIImage imageNamed:@"myh"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([((ZYNavigationViewController*)viewController).viewControllers.firstObject isKindOfClass:[UserTableViewController class]]) {
        UITabBarItem *user = [tabBarController.tabBar.items objectAtIndex:2];
        user.badgeValue = nil;
        if ([ZYCacheManager shareInstance].user.isLogin) {
            return YES;
        }else {
            [[ZYControllerManager manager] goLogin:self];
            return NO;
        }
    }
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
