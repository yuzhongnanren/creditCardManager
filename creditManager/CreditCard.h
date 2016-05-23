//
//  CreditCard.h
//  creditManager
//
//  Created by haodai on 16/3/1.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreditCard : NSObject
/**
 * 卡id
 */
@property (nonatomic, assign) NSInteger card_id;
/**
 *  卡图片
 */
@property (nonatomic, copy) NSString *img;
/**
 *  卡名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  卡描述
 */
@property (nonatomic, copy) NSString *descr;
/**
 *  卡申请量
 */
@property (nonatomic, assign) NSInteger apply_count;

@end
