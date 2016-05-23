//
//  JCCDoublePickerView.h
//  JCC
//
//  Created by feng jia on 14-8-12.
//  Copyright (c) 2014年 feng jia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DoublePickerOKBlock)(NSString *content1, NSString *content2);
@interface JCCDoublePickerView : UIView

- (void)configDatasource:(NSMutableArray *)dictionary selectRow1:(NSInteger)row1 selectRow2:(NSInteger)row2 title:(NSString *)title block:(DoublePickerOKBlock)block;
- (void)show:(BOOL)animationed;
- (void)hide:(BOOL)animationed;

@end
