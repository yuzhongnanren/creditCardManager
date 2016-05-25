//
//  ModificationTableViewController.h
//  creditManager
//
//  Created by 刘欢 on 16/5/23.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCredit.h"

typedef NS_ENUM(NSInteger, Types) {
    Bang_Credits = 0,
    Edit_Credits,
};
@interface ModificationTableViewController : UITableViewController

@property (nonatomic, assign) Types type;
@property (nonatomic, strong) MyCredit *creditCard;
@end
