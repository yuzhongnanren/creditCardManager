//
//  JCCPickView.h
//  JCC
//
//  Created by feng jia on 14-8-10.
//  Copyright (c) 2014年 feng jia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PickerViewOKBlock)(NSString *content,NSInteger index);
@interface JCCPickerView : UIView

- (void)configDatasource:(NSArray *)datasource title:(NSString *)title selectRow:(NSInteger)row block:(PickerViewOKBlock)block;

- (void)show;
- (void)hide;
@end
