//
//  ZYCacheManager.m
//  Shandai
//
//  Created by haodai on 15/12/29.
//  Copyright © 2015年 haodai. All rights reserved.
//

#import "ZYCacheManager.h"

@implementation ZYCacheManager

+ (instancetype)shareInstance {
    static ZYCacheManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZYCacheManager alloc] init];
    });
    return manager;
}


- (BOOL)save {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *userSavePath = [path stringByAppendingPathComponent:@"creditManager_user.archiver"];
    return [NSKeyedArchiver archiveRootObject:self.user toFile:userSavePath];
}



- (User *)localUser {
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path  = [paths objectAtIndex:0];
    NSString *userSavePath = [path stringByAppendingPathComponent:@"creditManager_user.archiver"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:userSavePath]) {
        id user = [NSKeyedUnarchiver unarchiveObjectWithFile:userSavePath];
        if ([user isKindOfClass:[User class]]) {
            self.user = user;
            return user;
        }
    }else {
        self.user = [[User alloc] init];
        [self save];
    }
    return nil;
}


- (BOOL)saveRecentCity:(NSDictionary *)dic {
    if (!dic) {
        return NO;
    }
    NSArray *cities = [self getRecentCity];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:cities];
    __block BOOL flag = NO;
    __block NSInteger index = 0;
   [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if ([[obj objectForKey:@"s_EN"] isEqualToString:[dic objectForKey:@"s_EN"]]) {
           flag = YES;
           index = idx;
           *stop = YES;
       };
   }];
    if (flag) {
        [temp removeObjectAtIndex:index];
        [temp insertObject:dic atIndex:0];
    }else {
        if (temp.count >= 6) {
            [temp insertObject:dic atIndex:0];
            [temp removeObjectAtIndex:temp.count - 1];
        }else {
            [temp insertObject:dic atIndex:0];
        }
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *userSavePath = [path stringByAppendingPathComponent:@"creditManager_cities.archiver"];
    return [NSKeyedArchiver archiveRootObject:temp toFile:userSavePath];
}

- (NSArray*)getRecentCity {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *userSavePath = [path stringByAppendingPathComponent:@"creditManager_cities.archiver"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:userSavePath]) {
        id cities = [NSKeyedUnarchiver unarchiveObjectWithFile:userSavePath];
        if ([cities isKindOfClass:[NSArray class]]) {
            return cities;
        }
    }else {
        return @[];
    }
    return @[];
}


- (BOOL)saveCreditForm:(SubmitCredit*)credit {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *userSavePath = [path stringByAppendingPathComponent:@"submitCredit_user.archiver"];
    NSArray *array = [NSArray arrayWithObject:credit];
    return [NSKeyedArchiver archiveRootObject:array toFile:userSavePath];
}

- (SubmitCredit*)getCreditForm {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *userSavePath = [path stringByAppendingPathComponent:@"submitCredit_user.archiver"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:userSavePath]) {
        NSArray *credits = [NSKeyedUnarchiver unarchiveObjectWithFile:userSavePath];
        if ([credits isKindOfClass:[NSArray class]]) {
            if ([credits count] > 0 ) {
                return  [credits objectAtIndex:0];
            }
            return nil;
        }
    }else {
        return nil;
    }
    return nil;
}

- (BOOL)deleteCreditForm {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *userSavePath = [path stringByAppendingPathComponent:@"submitCredit_user.archiver"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:userSavePath]) {
       return [[NSFileManager defaultManager] removeItemAtPath:userSavePath error:NULL];
    }
    return NO;
}

- (void)saveDeviceToken:(NSString*)devicetoken {
    [[NSUserDefaults standardUserDefaults] setObject:devicetoken forKey:@"CreditManager_devicetoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)getDeviceToken {
    NSString *devicetoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"CreditManager_devicetoken"];
    if (devicetoken && ![devicetoken isEqualToString:@""]) {
        return devicetoken;
    }else {
        return @"";
    }
}

- (void)deviceTokenUploadSuccess:(BOOL)b {
    [[NSUserDefaults standardUserDefaults] setBool:b forKey:@"deviceTokenUploadSuccess"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  获取是否成功的状态
 *
 *  @return YES 成功 NO 不成功
 */
- (BOOL)getDeviceTokenSuccessStatus {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"deviceTokenUploadSuccess"];
}


@end
