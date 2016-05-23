//
//  SubmitCredit.h
//  creditManager
//
//  Created by haodai on 16/3/15.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubmitCredit : NSObject <NSCopying,NSCoding>
@property (nonatomic, strong) NSString *education;
@property (nonatomic, strong) NSString *house;
@property (nonatomic, strong) NSString *creditMessage;
@property (nonatomic, strong) NSString *work;
@property (nonatomic, strong) NSString *companyType;
@property (nonatomic, strong) NSString *socialSecurity;
@property (nonatomic, strong) NSString *workIndetified;
@property (nonatomic, strong) NSString *id_card;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *code;

@end
