//
//  JCCPickView.m
//  JCC
//
//  Created by feng jia on 14-8-10.
//  Copyright (c) 2014年 feng jia. All rights reserved.
//

#import "JCCPickerView.h"

@interface JCCPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *tPickerView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) NSMutableArray *datasource;

@property (copy, nonatomic) NSString *curSelectContent;
@property (strong, nonatomic) UIControl *maskView;

@property (copy, nonatomic) PickerViewOKBlock okBlock;
@property (nonatomic, assign) NSInteger index;

- (IBAction)clickOK:(id)sender;
- (IBAction)clickCancel:(id)sender;
@end

@implementation JCCPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)clickOK:(id)sender {
    self.okBlock(self.curSelectContent,_index);
    [self hide];
}

- (IBAction)clickCancel:(id)sender {
    self.okBlock(nil,_index);
    [self hide];
}

- (void)configDatasource:(NSArray *)datasource title:(NSString *)title selectRow:(NSInteger)row block:(PickerViewOKBlock)block {
    self.okBlock = block;
    self.lbTitle.text = title;
    if (!self.datasource) {
        self.datasource = [NSMutableArray array];
    } else {
        [self.datasource removeAllObjects];
    }
    [self.datasource addObjectsFromArray:datasource];
    [self.tPickerView reloadAllComponents];
    if (row == NSNotFound) {
        [self.tPickerView selectRow:0 inComponent:0 animated:NO];
        self.curSelectContent = [datasource objectAtIndex:0];
         _index = 0;
    } else {
        [self.tPickerView selectRow:row inComponent:0 animated:NO];
        self.curSelectContent = [datasource objectAtIndex:row];
         _index = row;
    }
}

- (void)show {
    if (!self.maskView) {
        _maskView = [[UIControl alloc] initWithFrame:mKeyWindow.bounds];
        self.maskView.backgroundColor = [UIColor blackColor];
        self.maskView.alpha = 0.5;
        [self.maskView addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    [mKeyWindow addSubview:self.maskView];
    
    __block CGRect frame = self.frame;
    frame.origin.y = CGRectGetHeight(mKeyWindow.frame);
    frame.size.width = CGRectGetWidth(mKeyWindow.frame);
    self.frame = frame;
    frame.origin.y -= 202;
    [mKeyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)hide {
     __block CGRect frame = self.frame;
    [UIView animateWithDuration:0.3 animations:^{
        frame.origin.y = CGRectGetHeight(mKeyWindow.frame);
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
#pragma mark - UIPickerData Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.datasource count];
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return [self.datasource objectAtIndex:row];
//}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel  *mycom1 = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, 30.0f)];
    mycom1.text = [self.datasource objectAtIndex:row];
    [mycom1 setFont:[UIFont boldSystemFontOfSize:20]];
    mycom1.adjustsFontSizeToFitWidth = YES;
    mycom1.textAlignment = NSTextAlignmentCenter;
    mycom1.backgroundColor = [UIColor clearColor];
    return mycom1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.curSelectContent = [self.datasource objectAtIndex:row];
    _index = row;
}

@end
