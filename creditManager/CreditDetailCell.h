//
//  CreditDetailCell.h
//  creditManager
//
//  Created by haodai on 16/3/8.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TapDiscountCreditBlock)(NSInteger);

@interface CreditDetailCell : UITableViewCell
@property (nonatomic, copy) TapDiscountCreditBlock tapBlock;
@property (nonatomic, strong) NSArray *discountCredits;

- (void)setCardTitle:(NSString *)title content:(NSString*)content;
- (void)setPrivileg:(NSArray*)privileg;
- (void)setRates:(NSArray*)rates;

@end
