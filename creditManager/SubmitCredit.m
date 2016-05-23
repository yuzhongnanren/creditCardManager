//
//  SubmitCredit.m
//  creditManager
//
//  Created by haodai on 16/3/15.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "SubmitCredit.h"

@implementation SubmitCredit
- (id)init {
    self = [super init];
    if (self) {
        self.education = @"";
        self.house = @"";
        self.creditMessage = @"";
        self.work = @"";
        self.companyType = @"";
        self.socialSecurity = @"";
        self.workIndetified = @"";
        self.id_card = @"";
        self.name = @"";
        self.district = @"";
        self.address = @"";
        self.tel = @"";
        self.code = @"";
    }
    return self;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_education forKey:@"education"];
    [aCoder encodeObject:_house forKey:@"house"];
    [aCoder encodeObject:_creditMessage forKey:@"creditMessage"];
    [aCoder encodeObject:_work forKey:@"work"];
    [aCoder encodeObject:_companyType forKey:@"companyType"];
    [aCoder encodeObject:_socialSecurity forKey:@"socialSecurity"];
    [aCoder encodeObject:_workIndetified forKey:@"workIndetified"];
    [aCoder encodeObject:_id_card forKey:@"id_card"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_district forKey:@"district"];
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeObject:_tel forKey:@"tel"];
    [aCoder encodeObject:_code forKey:@"code"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _education = [aDecoder decodeObjectForKey:@"education"];
        _house = [aDecoder decodeObjectForKey:@"house"];
        _creditMessage = [aDecoder decodeObjectForKey:@"creditMessage"];
        _work = [aDecoder decodeObjectForKey:@"work"];
        _companyType = [aDecoder decodeObjectForKey:@"companyType"];
        _socialSecurity = [aDecoder decodeObjectForKey:@"socialSecurity"];
        _workIndetified = [aDecoder decodeObjectForKey:@"workIndetified"];
        _id_card = [aDecoder decodeObjectForKey:@"id_card"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _district = [aDecoder decodeObjectForKey:@"district"];
        _address = [aDecoder decodeObjectForKey:@"address"];
        _tel = [aDecoder decodeObjectForKey:@"tel"];
        _code = [aDecoder decodeObjectForKey:@"code"];
    }
    return self;
}

#pragma mark - NSCoping
- (id)copyWithZone:(NSZone *)zone {
    SubmitCredit *form = [[SubmitCredit allocWithZone:zone] init];
    form.education = self.education;
    form.house = self.house;
    form.creditMessage = self.creditMessage;
    form.work = self.work;
    form.companyType = self.companyType;
    form.socialSecurity = self.socialSecurity;
    form.workIndetified = self.workIndetified;
    form.id_card = self.id_card;
    form.name = self.name;
    form.district = self.district;
    form.address = self.address;
    form.tel = self.tel;
    form.code = self.code;
    return form;
}

@end
