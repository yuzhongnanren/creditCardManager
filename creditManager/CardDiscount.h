//
//  CardDiscount.h
//  creditManager
//
//  Created by haodai on 16/3/11.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardDiscount : NSObject
@property (nonatomic, assign) NSInteger bank_id;
@property (nonatomic, copy) NSString *bank_name;
@property (nonatomic, copy) NSString *ended_at;
@property (nonatomic, assign) NSInteger discount_id;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *title;

@end
