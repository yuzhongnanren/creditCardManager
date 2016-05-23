//
//  HomeTableViewCell.h
//  creditManager
//
//  Created by haodai on 16/2/29.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditCard.h"
typedef void (^BlockTapHotBank)(NSInteger);
typedef void (^BlockTapProgress)(void);
typedef void (^BlockTapCreditLookup)(void);
typedef void (^BlockTapDiscountCredit)(NSInteger);
typedef void (^BlockTapCloseTip)(void);

@interface HomeTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray *hotBanks;
@property (nonatomic, strong) CreditCard *credit;
@property (nonatomic, copy) BlockTapHotBank tapHotBlock;
@property (nonatomic, copy) BlockTapCreditLookup creditLookupBlock;
@property (nonatomic, copy) BlockTapProgress progressBlock;
@property (nonatomic, copy) BlockTapDiscountCredit tapDiscountCreditBlock;
@property (nonatomic, copy) BlockTapCloseTip tapCloseTip;
@property (nonatomic, strong) NSArray *discountCredits;

- (void)setUserImage:(NSString*)user cardNum:(NSInteger)count tip:(NSString*)str;

@end
