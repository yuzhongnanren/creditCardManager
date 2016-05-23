//
//  BangCreditTableViewController.h
//  creditManager
//
//  Created by haodai on 16/3/22.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCredit.h"

typedef NS_ENUM(NSInteger, Type) {
    Bang_Credit = 0,
    Edit_Credit,
};

@interface BangCreditTableViewController : UITableViewController
@property (nonatomic, assign) Type type;
@property (nonatomic, strong) MyCredit *creditCard;

@end
