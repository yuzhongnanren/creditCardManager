//
//  MyCreditCardTableViewCell.h
//  creditManager
//
//  Created by haodai on 16/3/16.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCredit.h"
typedef void (^BlockTapSwitch)(BOOL,NSInteger);

@interface MyCreditCardTableViewCell : UITableViewCell
@property (nonatomic, strong) MyCredit *credit;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) BlockTapSwitch tapSwitch;


@end
