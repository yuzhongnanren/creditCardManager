//
//  AES128Base64Util.h
//  cipher
//
//  Created by Yomix on 15/12/2.
//  Copyright © 2015年 www.ixinyong.net. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AES128Base64Util : NSObject


+ ( NSString*) AES128Encrypt:(NSString *)plainText withKey:(NSString *)key withIV:(NSString*)iv;

+ ( NSString*) AES128Decrypt:(NSString *)encryptText withKey:(NSString *)key withIV:(NSString*)iv;


@end
