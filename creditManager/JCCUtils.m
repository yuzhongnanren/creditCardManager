//
//  JCCUtils.m
//  JCC
//
//  Created by fengjun on 14-8-6.
//  Copyright (c) 2014年 feng jia. All rights reserved.
//

#import "JCCUtils.h"

@implementation JCCUtils

+ (id)sharedInstance {
    static JCCUtils *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)showProgressHud:(UIView *)inView withMessage:(NSString *)message {
    [self hideProgressHud];
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:inView];
        HUD.labelText = message;
//      HUD.dimBackground = YES;
        [inView addSubview:HUD];
        [HUD show:YES];
    }
}

- (void)hideProgressHud {
    if (HUD) {
        [HUD removeFromSuperview];
        HUD = nil;
  }
}

- (void)showProgressHudAndHideDelay:(NSTimeInterval)delay inView:(UIView *)inView withMessage:(NSString *)message {
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:inView];
        HUD.detailsLabelText = message;
        HUD.mode = MBProgressHUDModeText;
        [inView addSubview:HUD];
        [HUD show:YES];
        [self performSelector:@selector(hideDelayed) withObject:nil afterDelay:delay];
    }
}
- (void)hideDelayed {
    if (HUD) {
        [HUD hide:YES];
        [HUD removeFromSuperview];
        HUD = nil;
        
    }
}

- (void)save:(id)obj toFile:(NSString *)fileName {
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
    if ([NSKeyedArchiver archiveRootObject:obj toFile:path]) {
        NSLog(@"%@归档成功", fileName);
    }
}
- (id)query:(NSString *)fileName {
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (void)removeFile:(NSString *)fileName {
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}


@end
