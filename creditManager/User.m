//
//  User.m
//  zhengxin
//
//  Created by haodai on 15/9/25.
//  Copyright (c) 2015年 haodai. All rights reserved.
//

#import "User.h"

#define kUidKey @"kUidKey"
#define kTelKey @"TelephoneKey"
#define kPhotoPathKey @"PhotoPathKey"
#define kLoginTimeKey @"LoginTimeKey"
#define kLatKey @"kLatKey"
#define kLngKey @"kLngKey"
#define kIsLogin @"kIsLogin"
#define kIdCard @"kIdCard"
#define kIsSetPasswd @"kIsSetPasswd"

#define kDidKey @"kDidKey"
#define kSecretKey @"kSecretKey"
#define kCityKey @"kCityKey"
#define kCityES @"kCityES"
#define kAddressKey @"kAddressKey"
#define kAddressESKey @"kAddressESKey"
#define kAddress_Zone_IdKey @"kAddress_Zone_IdKey"

#define kQQKey @"kQQKey"
#define kWeiXingKey @"kWeiXingKey"
#define kNickNameKey @"kNickNameKey"
#define kBirthdayKey @"kBirthdayKey"
#define kSexKey @"kSexKey"


@implementation User
- (id)init {
    if (self = [super init]) {
        self.telephone = @"";
        self.photoPath = @"";
        self.loginTime = @"";
        self.lat = @"0";
        self.lng = @"0";
        self.isLogin = NO;
        self.id_card = @"0";
        self.uid = 0;
        
        self.did = Auth_Did;
        self.secretKey = Auth_Key;
        self.city = @"";
        self.city_s_EN = @"beijing";
        self.address = @"";
        self.address_s_EN = @"";
        self.address_Zone_Id = @"";
        
        self.nickname = @"";
        self.sex = 0;
        self.birthday = @"";
        self.qq = @"";
        self.weixing = @"";
        self.is_set_passwd = @"";
    }
    return self;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_telephone forKey:kTelKey];
    [aCoder encodeObject:_photoPath forKey:kPhotoPathKey];
    [aCoder encodeObject:_loginTime forKey:kLoginTimeKey];
    [aCoder encodeObject:_lat forKey:kLatKey];
    [aCoder encodeObject:_lng forKey:kLngKey];
    [aCoder encodeBool:_isLogin forKey:kIsLogin];
    [aCoder encodeObject:_id_card forKey:kIdCard];
    [aCoder encodeInteger:_uid forKey:kUidKey];
    [aCoder encodeObject:_did forKey:kDidKey];
    [aCoder encodeObject:_secretKey forKey:kSecretKey];
    [aCoder encodeObject:_city forKey:kCityKey];
    [aCoder encodeObject:_city_s_EN forKey:kCityES];
    [aCoder encodeObject:_birthday forKey:kBirthdayKey];
    [aCoder encodeInteger:_sex forKey:kSexKey];
    [aCoder encodeObject:_nickname forKey:kNickNameKey];
    [aCoder encodeObject:_address forKey:kAddressKey];
    [aCoder encodeObject:_address_s_EN forKey:kAddressESKey];
    [aCoder encodeObject:_address_Zone_Id forKey:kAddress_Zone_IdKey];
    [aCoder encodeObject:_qq forKey:kQQKey];
    [aCoder encodeObject:_weixing forKey:kWeiXingKey];
    [aCoder encodeObject:_is_set_passwd forKey:kIsSetPasswd];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _telephone = [aDecoder decodeObjectForKey:kTelKey];
        _photoPath = [aDecoder decodeObjectForKey:kPhotoPathKey];
        _loginTime = [aDecoder decodeObjectForKey:kLoginTimeKey];
        _lat = [aDecoder decodeObjectForKey:kLatKey];
        _lng = [aDecoder decodeObjectForKey:kLngKey];
        _isLogin = [aDecoder decodeBoolForKey:kIsLogin];
        _id_card = [aDecoder decodeObjectForKey:kIdCard];
        _uid = [aDecoder decodeIntForKey:kUidKey];
        _did = [aDecoder decodeObjectForKey:kDidKey];
        _secretKey = [aDecoder decodeObjectForKey:kSecretKey];
        _city = [aDecoder decodeObjectForKey:kCityKey];
        _city_s_EN = [aDecoder decodeObjectForKey:kCityES];
        _nickname = [aDecoder decodeObjectForKey:kNickNameKey];
        _sex = [aDecoder decodeIntegerForKey:kSexKey];
        _birthday = [aDecoder decodeObjectForKey:kBirthdayKey];
        _address = [aDecoder decodeObjectForKey:kAddressKey];
        _address_s_EN = [aDecoder decodeObjectForKey:kAddressESKey];
        _address_Zone_Id = [aDecoder decodeObjectForKey:kAddress_Zone_IdKey];
        _qq = [aDecoder decodeObjectForKey:kQQKey];
        _weixing = [aDecoder decodeObjectForKey:kWeiXingKey];
        _is_set_passwd = [aDecoder decodeObjectForKey:kIsSetPasswd];
    }
    return self;
}

#pragma mark - NSCoping
- (id)copyWithZone:(NSZone *)zone {
    User *user = [[User allocWithZone:zone] init];
    user.telephone = self.telephone;
    user.photoPath = self.photoPath;
    user.loginTime = self.loginTime;
    user.lat = self.lat;
    user.lng = self.lng;
    user.isLogin = self.isLogin;
    user.id_card = self.id_card;
    user.uid = self.uid;
    user.did = self.did;
    user.secretKey = self.secretKey;
    user.city = self.city;
    user.city_s_EN = self.city_s_EN;
    user.birthday = self.birthday;
    user.sex = self.sex;
    user.nickname = self.nickname;
    user.address = self.address;
    user.address_s_EN = self.address_s_EN;
    user.address_Zone_Id = self.address_Zone_Id;
    user.qq = self.qq;
    user.weixing = self.weixing;
    user.is_set_passwd = self.is_set_passwd;
    return user;
}





@end
