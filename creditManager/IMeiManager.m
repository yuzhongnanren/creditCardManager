//
//  IMeiManager.m
//  Shandai
//
//  Created by haodai on 15/12/29.
//  Copyright © 2015年 haodai. All rights reserved.
//

#import "IMeiManager.h"
#import "SFHFKeychainUtils.h"

@implementation IMeiManager
+ (instancetype)shareInstance {
    static IMeiManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self class] new];
    });
    return manager;
}

- (NSString*)feathIMEI {
   NSString *imei = [SFHFKeychainUtils getPasswordForUsername:@"IMEI" andServiceName:@"com.haodai.CreditManager" error:nil];
    if (imei) {
        return imei;
    }else {
        [self saveIMei];
        NSString *imei = [SFHFKeychainUtils getPasswordForUsername:@"IMEI" andServiceName:@"com.haodai.CreditManager" error:nil];
        return imei;
    }
}

- (void)saveIMei {
    NSString*imei = uuid();
    [SFHFKeychainUtils storeUsername:@"IMEI" andPassword:imei forServiceName:@"com.haodai.CreditManager" updateExisting:YES error:nil];
}


@end
