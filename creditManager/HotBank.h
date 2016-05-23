//
//  HotBank.h
//  creditManager
//
//  Created by haodai on 16/2/29.


//  Copyright © 2016年 haodai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotBank : NSObject
/**
 *  是否是H5
 */
@property (nonatomic, assign) NSInteger is_h5;
/**
 *  银行标签
 */
@property (nonatomic, copy) NSString *label;
/**
 *  银行名称
 */
@property (nonatomic, copy) NSString *bank_name;
/**
 *  银行图片
 */
@property (nonatomic, copy) NSString *bank_img;
/**
 *  银行id
 */
@property (nonatomic, assign) NSInteger bank_id;
/**
 *  声请数量
 */
@property (nonatomic, strong) NSString *apply_count;

@end
