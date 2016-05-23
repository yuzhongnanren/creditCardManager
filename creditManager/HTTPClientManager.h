//
//  HTTPClientManager.h
//  creditManager
//
//  Created by haodai on 16/2/29.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPClientManager : NSObject
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

/**
 *  注册设备
 *
 *  @param url     url description
 *  @param success success description
 *  @param failure failure description
 *  @param view    view description
 *  @param p       p description
 */
- (void)RegisterDevice:(NSString *)url
            dictionary:(NSDictionary*)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure
                  view:(UIView*)view
              progress:(BOOL)p;
/**
 *  图片上传
 *
 *  @param appendString <#appendString description#>
 *  @param parameters   <#parameters description#>
 *  @param data         <#data description#>
 *  @param success      <#success description#>
 *  @param failure      <#failure description#>
 *  @param view         <#view description#>
 *  @param p            <#p description#>
 */
- (void)POST:(NSString *)appendString dictionary:(NSDictionary *)parameters ImageData:(NSData*)data  success:(void (^)(id))success failure:(void (^)(NSError *))failure view:(UIView *)view progress:(BOOL)p;

@end
