//
//  ZYTextField.m
//  mashangyan
//
//  Created by zhouyong on 15/10/18.
//  Copyright (c) 2015年 zbrt. All rights reserved.
//

#import "ZYTextField.h"

@implementation ZYTextField
{
    CGFloat moveHeight;
    CGFloat SuperViewOriginY;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib {
    [self setUp];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUp {
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.keyboardType = UIKeyboardTypeDefault;
    self.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif

}


- (void)setRemoveView:(UIView *)removeView {
    _removeView = removeView;
    SuperViewOriginY = _removeView.origin.y;
}


#pragma mark -
#pragma mark Notifications
- (void)keyboardWillShow:(NSNotification *)notification
{
    /* Move the toolbar to above the keyboard */
    if (self.isFirstResponder) {
        if (_enableKeyBoardHeight) {
            NSDictionary * info = [notification userInfo];
            CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
            CGFloat keyHeight = kbSize.height;
            CGRect r = [self convertRect:self.bounds toView:_removeView];
            moveHeight = keyHeight - (_removeView.frame.size.height - r.size.height - r.origin.y);
            if (moveHeight <= 0) {
                return;
            }
            [UIView animateWithDuration:0.2 animations:^{
                //偏移量
                CGFloat offset_y = 20.0f;
                [_removeView setTop: - moveHeight + SuperViewOriginY - offset_y];
            }];
            
        }
        
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    /* Move the toolbar back to bottom of the screen */
    if (self.isFirstResponder) {
        if (_enableKeyBoardHeight) {
            [UIView animateWithDuration:0.2 animations:^{
                [_removeView setTop:SuperViewOriginY + 64];
            }];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
