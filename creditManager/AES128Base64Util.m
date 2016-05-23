//
//  AES128Base64Util.m
//  cipher
//
//  Created by Yomix on 15/12/2.
//  Copyright © 2015年 www.ixinyong.net. All rights reserved.
//

#import "AES128Base64Util.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation AES128Base64Util

+ ( NSString*) AES128Encrypt:(NSString *)plainText withKey:(NSString *)key withIV:(NSString*)iv
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    int diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    unsigned long newSize = dataLength;
    
    if( diff > 0 && kCCKeySizeAES128 != diff)
    {
        newSize = dataLength + diff;
    }
    
    
    char *dataPtr = malloc(newSize);
    
    memset(dataPtr, 0, newSize);
    memcpy(dataPtr, [data bytes], [data length]);
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    NSString * cryptStr = nil;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,               //No padding //need to check 
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          ivPtr,
                                          dataPtr,
                                          newSize,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    free(dataPtr);
    
    if (cryptStatus == kCCSuccess) {
       
        NSData * resultData = [NSData dataWithBytes:buffer length:numBytesCrypted];
        cryptStr =  [[NSString alloc] initWithData:[resultData base64EncodedDataWithOptions:0] encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    
    return cryptStr;
}

+ ( NSString*) AES128Decrypt:(NSString *)encryptText withKey:(NSString *)key withIV:(NSString*)iv;
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [[NSData alloc] initWithBase64EncodedString:encryptText options:0];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    NSString * dcryptStr = nil;
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData * resultData = [NSData dataWithBytes:buffer length:numBytesCrypted];
        dcryptStr = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    
    free(buffer);
    return dcryptStr;
}

@end
