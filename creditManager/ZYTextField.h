//
//  ZYTextField.h
//  mashangyan
//
//  Created by zhouyong on 15/10/18.
//  Copyright (c) 2015年 zbrt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYTextField : UITextField
@property(nonatomic,strong)UIView *removeView;//需要移动的View
@property(nonatomic,assign)BOOL enableKeyBoardHeight;//是否开启输入框的高度随键盘高度自动改变位置，默认是NO

@end
