//
//  JCCDatePickerView.m
//  creditManager
//
//  Created by haodai on 16/3/21.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "JCCDatePickerView.h"
#import "UUDatePicker.h"
@interface JCCDatePickerView ()
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *certainBtn;
@property (nonatomic, strong) UUDatePicker *dataPicker;
@property (strong, nonatomic) UIControl *maskView;


@end

@implementation JCCDatePickerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUp];
    }
    return self;
}

- (void)setUp {
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    toolView.backgroundColor = [UIColor colorWithHexColorString:@"dddddd"];
    [self addSubview:toolView];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setTitleColor:Gray136 forState:0];
    [_cancelBtn setTitle:@"取消" forState:0];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _cancelBtn.frame = CGRectMake(0, 0, 80, 35);
    [self addSubview:_cancelBtn];
    
    
    _certainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_certainBtn addTarget:self action:@selector(clickOk) forControlEvents:UIControlEventTouchUpInside];
    [_certainBtn setTitleColor:Gray136 forState:0];
    [_certainBtn setTitle:@"存储" forState:0];
    _certainBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _certainBtn.frame = CGRectMake(self.width - 80, 0, 80, 35);
    [self addSubview:_certainBtn];
    
    @weakify(self);
    _dataPicker = [[UUDatePicker alloc] initWithframe:CGRectMake(0, 35, self.width, 216.f) PickerStyle:UUDateStyle_YearMonthDay didSelected:^(NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        @strongify(self);
        self.birthDay = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    }];
    _dataPicker.maxLimitDate = [NSDate date];
    _dataPicker.minLimitDate = [NSDate dateWithDaysBeforeNow:100*365];
    [self addSubview:_dataPicker];
  
}

#pragma mark -
- (void)clickCancel {
     [self hide];
}

- (void)clickOk {
    if (self.dateBlock) {
        self.dateBlock(self.birthDay);
    }
    [self hide];
}

- (void)show {
    if (self.birthDay) {
        _dataPicker.ScrollToDate = [NSDate dateWithString:self.birthDay format:@"yyyy-MM-dd"];
    }else {
        _dataPicker.ScrollToDate = [NSDate dateWithString:@"19800101" format:@"yyyyMMdd"];
        self.birthDay  = @"1980-01-01";
    }
    
    if (!self.maskView) {
        _maskView = [[UIControl alloc] initWithFrame:mKeyWindow.bounds];
        self.maskView.backgroundColor = [UIColor blackColor];
        self.maskView.alpha = 0.5;
        [self.maskView addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    [mKeyWindow addSubview:self.maskView];
    
    __block CGRect frame = self.frame;
    frame.origin.y = CGRectGetHeight(mKeyWindow.frame);
    frame.size.width = CGRectGetWidth(mKeyWindow.frame);
    self.frame = frame;
    frame.origin.y -= 260;
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
