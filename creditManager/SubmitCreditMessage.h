//
//  SubmitCreditMessage.h
//  creditManager
//
//  Created by haodai on 16/3/15.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmitCredit.h"
#import "ZYPalceHoldTextFeild.h"

@interface SubmitCreditMessage : UITableViewCell
@property (weak, nonatomic) IBOutlet ZYPalceHoldTextFeild *education;
@property (weak, nonatomic) IBOutlet ZYPalceHoldTextFeild *house;
@property (weak, nonatomic) IBOutlet ZYPalceHoldTextFeild *creditMessage;
@property (weak, nonatomic) IBOutlet ZYPalceHoldTextFeild *work;
@property (weak, nonatomic) IBOutlet ZYPalceHoldTextFeild *companyType;
@property (weak, nonatomic) IBOutlet ZYPalceHoldTextFeild *socialSecurity;
@property (weak, nonatomic) IBOutlet ZYPalceHoldTextFeild *workIndetified;
@property (weak, nonatomic) IBOutlet UITextField *id_card;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet ZYPalceHoldTextFeild *district;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *tel;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (nonatomic, strong) SubmitCredit *creditForm;

@end
