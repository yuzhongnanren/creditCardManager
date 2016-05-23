//
//  HTTPRequestManager.h
//  hunchelaila
//
//  Created by zhouyong on 15-3-17.
//  Copyright (c) 2015年 百万新娘(北京)科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
extern  NSString *const HTTPServerError;
extern  NSString *const HTTPConnectionError;
/**
 *  加密请求
 */
@interface HTTPRequestManager : NSObject
+ (instancetype)manager;
- (void)POST:(NSString*)appendString
  dictionary:(NSDictionary*)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
        view:(UIView*)view
    progress:(BOOL)p;

- (void)GET:(NSString*)appendString
 dictionary:(NSDictionary*)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure
       view:(UIView*)view
   progress:(BOOL)p;

@end
