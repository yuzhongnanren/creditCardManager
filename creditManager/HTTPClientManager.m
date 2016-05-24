//
//  HTTPClientManager.m
//  creditManager
//
//  Created by haodai on 16/2/29.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "HTTPClientManager.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "HttpCommonApi.h"
#import "ZYControllerManager.h"

@interface HTTPClientManager()
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation HTTPClientManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static HTTPClientManager *clientManager = nil;
    dispatch_once(&onceToken, ^{
        clientManager = [[HTTPClientManager alloc] init];
    });
    return clientManager;
}

- (AFHTTPRequestOperationManager*)manager {
    if (_manager == nil) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}

- (void)POST:(NSString *)appendString dictionary:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure view:(UIView *)view progress:(BOOL)p {
    
    if ([[ZYCacheManager shareInstance].user.did isEqualToString:Auth_Did] && [[ZYCacheManager shareInstance].user.secretKey isEqualToString:Auth_Key]) {
        [appDelegate() registerIMEI];
        return;
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    if (p) {
        [hud show:YES];
    }
    hud.removeFromSuperViewOnHide = YES;
    [self.manager.requestSerializer setValue:HTTP_HeadValue_Oauth2 forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [mutableDic addEntriesFromDictionary:[self createPostParameter]];
    NSLog(@"%@",[self createGetParameter:[BaseUrl stringByAppendingPathComponent:appendString]]);
    [self.manager POST:[self createGetParameter:[BaseUrl stringByAppendingPathComponent:appendString]] parameters:mutableDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if (!isNotNull([responseObject objectForKey:@"rs_code"])) {
            hud.mode = MBProgressHUDModeText;
            if (isNotNull([responseObject objectForKey:@"rs_msg"])) {
                hud.labelText = [responseObject objectForKey:@"rs_msg"];
            }else {
                hud.labelText = HTTPServerError;
            }
            [hud hide:YES afterDelay:1];
            if (failure) {
                failure(NULL);
            }
            return;
        }
        if ([[responseObject objectForKey:@"rs_code"] integerValue] == 1000) {
            [hud hide:YES];
            if (success) {
                success(responseObject);
            }
        }else {
            hud.mode = MBProgressHUDModeText;
            if (isNotNull([responseObject objectForKey:@"rs_msg"])) {
                 hud.labelText = [responseObject objectForKey:@"rs_msg"];
            }else {
                 hud.labelText = HTTPServerError;
            }
            [hud hide:YES afterDelay:1];
            if ([[responseObject objectForKey:@"rs_code"] integerValue] == 9023) {
                [[ZYControllerManager manager] exitHomeGoLogin];
            }
            if (failure) {
                failure(NULL);
            }
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
    [self.manager.requestSerializer setValue:HTTP_HeadValue_Oauth2 forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [mutableDic addEntriesFromDictionary:[self createPostParameter]];
    [self.manager GET:[self createGetParameter:[BaseUrl stringByAppendingPathComponent:appendString]] parameters:mutableDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if (!isNotNull([responseObject objectForKey:@"rs_code"])) {
            hud.mode = MBProgressHUDModeText;
            if (isNotNull([responseObject objectForKey:@"rs_msg"])) {
                hud.labelText = [responseObject objectForKey:@"rs_msg"];
            }else {
                hud.labelText = HTTPServerError;
            }
            [hud hide:YES afterDelay:1];
            if (failure) {
                failure(NULL);
            }
            return;
        }
        if ([[responseObject objectForKey:@"rs_code"] integerValue] == 1000) {
            [hud hide:YES];
            if (success) {
                success(responseObject);
            }
        }else {
            hud.mode = MBProgressHUDModeText;
            if (isNotNull([responseObject objectForKey:@"rs_msg"])) {
                hud.labelText = [responseObject objectForKey:@"rs_msg"];
            }else {
                hud.labelText = HTTPServerError;
            }
            [hud hide:YES afterDelay:1];
            if ([[responseObject objectForKey:@"rs_code"] integerValue] == 9023) {
                [[ZYControllerManager manager] exitHomeGoLogin];
            }
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

- (void)RegisterDevice:(NSString *)url
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
    [self.manager.operationQueue cancelAllOperations];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager.requestSerializer setValue:HTTP_HeadValue_Oauth2 forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [mutableDic addEntriesFromDictionary:[self createPostParameter]];
    NSLog(@"%@",[self createGetParameter:[BaseUrl stringByAppendingPathComponent:url]]);
    [self.manager POST:[self createGetParameter:[BaseUrl stringByAppendingPathComponent:url]] parameters:mutableDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if (!isNotNull([responseObject objectForKey:@"rs_code"])) {
            hud.mode = MBProgressHUDModeText;
            if (isNotNull([responseObject objectForKey:@"rs_msg"])) {
                hud.labelText = [responseObject objectForKey:@"rs_msg"];
            }else {
                hud.labelText = HTTPServerError;
            }
            [hud hide:YES afterDelay:1];
            if (failure) {
                failure(NULL);
            }
            return;
        }
        if ([[responseObject objectForKey:@"rs_code"] integerValue] == 1000) {
            [hud hide:YES];
            if (success) {
                success(responseObject);
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

- (void)POST:(NSString *)url dictionary:(NSDictionary *)parameters ImageData:(NSData*)data  success:(void (^)(id))success failure:(void (^)(NSError *))failure view:(UIView *)view progress:(BOOL)p {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    if (p) {
        [hud show:YES];
    }
    hud.removeFromSuperViewOnHide = YES;
    AFHTTPRequestOperationManager *imagePost = [AFHTTPRequestOperationManager manager];
    imagePost.responseSerializer = [AFJSONResponseSerializer serializer];
    [imagePost.requestSerializer setValue:HTTP_HeadValue_Oauth2 forHTTPHeaderField:@"Authorization"];
    [imagePost.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [mutableDic addEntriesFromDictionary:[self createPostParameter]];
    NSLog(@"%@",[self createGetParameter:[BaseUrl stringByAppendingPathComponent:url]]);
    [imagePost POST:[self createGetParameter:[BaseUrl stringByAppendingPathComponent:url]] parameters:mutableDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if (!isNotNull([responseObject objectForKey:@"rs_code"])) {
            hud.mode = MBProgressHUDModeText;
            if (isNotNull([responseObject objectForKey:@"rs_msg"])) {
                hud.labelText = [responseObject objectForKey:@"rs_msg"];
            }else {
                hud.labelText = HTTPServerError;
            }
            [hud hide:YES afterDelay:1];
            if (failure) {
                failure(NULL);
            }
            return;
        }
        if ([[responseObject objectForKey:@"rs_code"] integerValue] == 1000) {
            [hud hide:YES];
            if (success) {
                success(responseObject);
            }
        }else {
            hud.mode = MBProgressHUDModeText;
            if (isNotNull([responseObject objectForKey:@"rs_msg"])) {
                hud.labelText = [responseObject objectForKey:@"rs_msg"];
            }else {
                hud.labelText = HTTPServerError;
            }
            [hud hide:YES afterDelay:1];
            if (failure) {
                failure(NULL);
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = HTTPConnectionError;
        [hud hide:YES afterDelay:1];
        if (failure) {
            failure(error);
        }
    }];
    
}

- (NSString *)createGetParameter:(NSString*)url {
    NSString *Url = nil;
    if ([[url  substringFromIndex:url.length-1] isEqualToString:@"?"]) {
          Url = [NSString stringWithFormat:@"%@source=%@&auth=%@&ref=%@&city=%@",url,HTTP_Source,HTTP_Auth, HTTP_Ref,[ZYCacheManager shareInstance].user.city_s_EN];
    }else {
        if ([url rangeOfString:@"?"].length) {
            Url = [NSString stringWithFormat:@"%@&source=%@&auth=%@&ref=%@&city=%@",url,HTTP_Source,HTTP_Auth, HTTP_Ref,[ZYCacheManager shareInstance].user.city_s_EN];
        }else {
            Url = [NSString stringWithFormat:@"%@?source=%@&auth=%@&ref=%@&city=%@",url,HTTP_Source,HTTP_Auth, HTTP_Ref,[ZYCacheManager shareInstance].user.city_s_EN];
        }
    }
    return Url;
}


- (NSDictionary*)createPostParameter {
    /*    auth_did    = 10001        //int32 客户端id
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
        [ZYCacheManager shareInstance].user.did = Auth_Did;
    }
    [[ZYCacheManager shareInstance] save];
    NSString *auth_dsig = [timeSp stringByAppendingString:[ZYCacheManager shareInstance].user.secretKey];
    auth_dsig = [[AppFun sharedInstance] md5:auth_dsig];
    auth_dsig = [auth_dsig substringWithRange:NSMakeRange(8, 16)];
    //auth_did=10002，key='Eb953db38ae22be0',appid=1,os_type=2)
    NSDictionary *dic = @{@"auth_did":[ZYCacheManager shareInstance].user.did,@"auth_tms":timeSp,@"auth_dsig":auth_dsig,@"v":ServerVersion,@"app_v":mAPPVersion,@"auth_uid":@([ZYCacheManager shareInstance].user.uid),@"auth_debug":@"0"};
    return dic;
}



@end
