//
//  HTTPRequestManager.m
//  hunchelaila
//
//  Created by zhouyong on 15-3-17.
//  Copyright (c) 2015年 百万新娘(北京)科技有限公司. All rights reserved.
//

#import "HTTPRequestManager.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "HttpCommonApi.h"
#import "AES128Base64Util.h"

NSString *const HTTPServerError = @"服务器错误";
NSString *const HTTPConnectionError = @"网络连接失败";

@implementation HTTPRequestManager

+ (instancetype)manager {
    return [[self class] new];
}

- (void)POST:(NSString*)appendString
  dictionary:(NSDictionary*)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
        view:(UIView*)view
    progress:(BOOL)p {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    if (p) {
        [hud show:YES];
    }
    hud.removeFromSuperViewOnHide = YES;
    NSError *error = NULL;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:NSJSONWritingPrettyPrinted
                                                       error:&error];
    NSString *jsonString = nil;
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    //数据加密
    jsonString = [AES128Base64Util AES128Encrypt:jsonString withKey:[ZYCacheManager shareInstance].user.secretKey withIV:AUTH_IV];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:jsonString,@"data", nil];
    NSString *url = [self createURL:appendString];
    [AFHTTPRequestOperationManager manager].responseSerializer = [AFHTTPResponseSerializer serializer];
    [[AFHTTPRequestOperationManager manager] POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",[[responseObject objectForKey:@"rs_msg"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        if ([[responseObject objectForKey:@"rs_code"] integerValue] == 1000) {
            [hud hide:YES];
            //数据解密
            NSString *jsStr = [AES128Base64Util AES128Decrypt:[responseObject objectForKey:@"details"] withKey:[ZYCacheManager shareInstance].user.secretKey withIV:AUTH_IV];
            jsStr = [jsStr stringByReplacingOccurrencesOfString:@"\0" withString:@""];
            jsStr = [jsStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            jsStr = [jsStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSData *data = [jsStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *e = nil;
            NSData *jsData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&e];
            if (e) {
                NSLog(@"%@",e);
            }
            if (success) {
                success(jsData);
            }
        }else {
            hud.mode = MBProgressHUDModeText;
            if (isNotNull([responseObject objectForKey:@"rs_msg"])) {
               hud.labelText = [responseObject objectForKey:@"rs_msg"];
            }else {
               hud.labelText = HTTPServerError;
            }
            [hud hide:YES afterDelay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = HTTPConnectionError;
        [hud hide:YES afterDelay:1];
        if (failure) {
            failure(error);
        }
    }];
}

- (void)GET:(NSString*)appendString
 dictionary:(NSDictionary*)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure
       view:(UIView*)view
   progress:(BOOL)p {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    if (p) {
        [hud show:YES];
    }
    hud.removeFromSuperViewOnHide = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"oauth2 1dd7f6eb4cf408114b1b8d1f662eda22" forHTTPHeaderField:@"Authorization"];
    [manager GET:appendString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"rs_code"] integerValue] == 1000) {
            [hud hide:YES];
            if (success) {
                success(responseObject);
            }
        }else {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = HTTPServerError;
            [hud hide:YES afterDelay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = HTTPConnectionError;
        [hud hide:YES afterDelay:1];
        if (failure) {
            failure(error);
        }
    }];
}

- (NSDictionary*)createParameter {
/*    auth_did    = 10001             //int32 客户端id
    auth_tm     = 1451100155        //int32 客户端请求时时间戳
    auth_dsig   = xxxxxxxxxxxxxxxx  //string(16) 客户端签名
    v           = 1.0               //strint 服务器端版本号 默认为0
    app_v       = 1.0               //string  保留字段 客户端版本号
    auth_uid    = 0                 //int32 默认为0 客户端登录用户id
    auth_debug  = 0                 //int32 是否开启debug模式 默认为0 debug模式1 0正常模式
 */
//    auth_tm 和 auth_key 拼接成字符串md5,转化成小写后取第8到24位
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    if (![ZYCacheManager shareInstance].user.secretKey) {
        [ZYCacheManager shareInstance].user.secretKey = Auth_Key;
    }
    if (![ZYCacheManager shareInstance].user.did) {
        [ZYCacheManager shareInstance].user.secretKey = Auth_Did;
    }
    [[ZYCacheManager shareInstance] save];
    NSString *auth_dsig = [timeSp stringByAppendingString:[ZYCacheManager shareInstance].user.secretKey];
    auth_dsig = [[AppFun sharedInstance] md5:auth_dsig];
    auth_dsig = [auth_dsig substringWithRange:NSMakeRange(8, 16)];
    NSString *auth_did = [ZYCacheManager shareInstance].user.did;
    NSDictionary *dic = @{@"auth_did":auth_did,@"auth_tms":timeSp,@"auth_dsig":auth_dsig,@"v":ServerVersion,@"app_v":mAPPVersion,@"auth_uid":@([ZYCacheManager shareInstance].user.uid),@"auth_debug":@"0"};
    return dic;
   
}

- (NSString *)createURL:(NSString *)appendString {
    NSString *url = [BaseUrl stringByAppendingPathComponent:appendString];
    NSDictionary *dic = [self createParameter];
    NSString*append  = @"";
    for (NSString *key in dic.allKeys) {
        if ([dic.allKeys indexOfObject:key] == dic.allKeys.count - 1) {
            append = [append  stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,[dic objectForKey:key]]];
        }else {
           append = [append  stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[dic objectForKey:key]]];
        }
    }
    return [NSString stringWithFormat:@"%@?%@",url,append];
}



@end
