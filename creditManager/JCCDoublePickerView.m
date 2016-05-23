//
//  JCCDoublePickerView.m
//  JCC
//
//  Created by feng jia on 14-8-12.
//  Copyright (c) 2014年 feng jia. All rights reserved.
//

#import "JCCDoublePickerView.h"

@interface JCCDoublePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) NSMutableArray *datasource;

@property (copy, nonatomic) DoublePickerOKBlock okBlock;
@property NSInteger selectRow1;
@property NSInteger selectRow2;
@property NSString *content1;
@property NSString *content2;

@property (strong, nonatomic) UIControl *maskView;
- (IBAction)clickOK:(id)sender;
- (IBAction)clickCancel:(id)sender;

@end

@implementation JCCDoublePickerView

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
    self.okBlock(self.content1, self.content2);
    [self hide:YES];
}
- (IBAction)clickCancel:(id)sender {
    self.okBlock(nil, nil);
    [self hide:YES];
}

- (void)configDatasource:(NSMutableArray *)dictionary selectRow1:(NSInteger)row1 selectRow2:(NSInteger)row2 title:(NSString *)title block:(DoublePickerOKBlock)block {
    self.datasource = [NSMutableArray arrayWithArray:dictionary];
//    self.selectRow1 = row1;
//    self.selectRow2 = row2;
    self.lbTitle.text = title;
    self.okBlock = nil;
    self.okBlock = block;
    if (!self.content1) {
        self.content1 = [[[self.datasource objectAtIndex:row1] allKeys] objectAtIndex:0];
    }
    if (!self.content2) {
        NSString *key = [[[self.datasource objectAtIndex:row1] allKeys] objectAtIndex:0];
        self.content2 = [[[self.datasource objectAtIndex:row1] objectForKey:key] objectAtIndex:0];
    }
}

- (void)show:(BOOL)animationed {
    if (!self.maskView) {
        _maskView = [[UIControl alloc] initWithFrame:mKeyWindow.bounds];
        self.maskView.backgroundColor = [UIColor blackColor];
        self.maskView.alpha = 0.5;
        [self.maskView addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    [mKeyWindow addSubview:self.maskView];
    if (animationed) {
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
    } else {
        CGRect frame = self.frame;
        frame.origin.y = CGRectGetHeight(mKeyWindow.frame);
        frame.size.width = CGRectGetWidth(mKeyWindow.frame);
        self.frame = frame;
        frame.origin.y -= 202;
        self.frame = frame;
        [mKeyWindow addSubview:self];
    }
}
- (void)hide:(BOOL)animationed {
    if (animationed) {
        __block CGRect frame = self.frame;
        [UIView animateWithDuration:0.3 animations:^{
            frame.origin.y = CGRectGetHeight(mKeyWindow.frame);
            self.frame = frame;
        } completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
            [self removeFromSuperview];
        }];
    } else {
        CGRect frame = self.frame;
        frame.origin.y = CGRectGetHeight(mKeyWindow.frame);
        self.frame = frame;
        [self.maskView removeFromSuperview];
    }
}

#pragma mark - UIPickerData Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [self.datasource count];
    } else {
        NSString *key = [[[self.datasource objectAtIndex:self.selectRow1] allKeys] objectAtIndex:0];
        return [[[self.datasource objectAtIndex:self.selectRow1] objectForKey:key] count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [[[self.datasource objectAtIndex:row] allKeys] objectAtIndex:0];
    } else {
        NSString *key = [[[self.datasource objectAtIndex:self.selectRow1] allKeys] objectAtIndex:0];
        return [[[self.datasource objectAtIndex:self.selectRow1] objectForKey:key] objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectRow1 = row;
        self.content1 =  [[[self.datasource objectAtIndex:row] allKeys] objectAtIndex:0];
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        self.selectRow2 = 0;
        self.content2 = [[[self.datasource objectAtIndex:row] objectForKey:self.content1] objectAtIndex:0];
    } else {
        self.selectRow2 = row;
        NSString *key = [[[self.datasource objectAtIndex:self.selectRow1] allKeys] objectAtIndex:0];
        self.content2 = [[[self.datasource objectAtIndex:self.selectRow1] objectForKey:key] objectAtIndex:row];
    }
}

@end
