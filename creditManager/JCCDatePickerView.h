//
//  JCCDatePickerView.h
//  creditManager
//
//  Created by haodai on 16/3/21.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DatePickerViewBlock)(NSString*);
@interface JCCDatePickerView : UIView
@property (nonatomic, copy) DatePickerViewBlock dateBlock;
@property (nonatomic, strong) NSString *birthDay;

- (void)show;
- (void)hide;

@end
