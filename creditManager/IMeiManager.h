//
//  IMeiManager.h
//  Shandai
//
//  Created by haodai on 15/12/29.
//  Copyright © 2015年 haodai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMeiManager : NSObject
+ (instancetype)shareInstance;
- (NSString* )feathIMEI;

@end
