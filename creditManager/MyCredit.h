//
//  MyCredit.h
//  creditManager
//
//  Created by haodai on 16/3/16.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCredit : NSObject

@property (nonatomic, copy) NSString *card_id;

@property (nonatomic, copy) NSString *bank_name;

@property (nonatomic, copy) NSString *last_statement_date_complete;

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, assign) NSInteger time_left;

@property (nonatomic, copy) NSString *statement_date_complete;

@property (nonatomic, copy) NSString *repayment_date;

@property (nonatomic, copy) NSString *card_limit;

@property (nonatomic, assign) NSInteger free_interest_time;

@property (nonatomic, copy) NSString *bank_id;

@property (nonatomic, copy) NSString *bank_num;

@property (nonatomic, copy) NSString *statement_date;

@property (nonatomic, copy) NSString *repayment_date_complete;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *bank_img;

@property (nonatomic, copy) NSString *time_left_show;

@end
