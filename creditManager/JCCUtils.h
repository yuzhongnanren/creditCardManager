//
//  JCCUtils.h
//  JCC
//
//  Created by fengjun on 14-8-6.
//  Copyright (c) 2014年 feng jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface JCCUtils : NSObject {
    
    MBProgressHUD *HUD;
}

+ (id)sharedInstance;
- (void)showProgressHud:(UIView *)inView withMessage:(NSString *)message;
- (void)hideProgressHud;
- (void)showProgressHudAndHideDelay:(NSTimeInterval)delay inView:(UIView *)inView withMessage:(NSString *)message;

- (void)save:(id)obj toFile:(NSString *)fileName;
- (id)query:(NSString *)fileName;
- (void)removeFile:(NSString *)fileName;



@end
