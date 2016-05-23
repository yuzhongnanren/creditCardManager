//
//  ZYScrollView.m
//  creditManager
//
//  Created by haodai on 16/2/29.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "ZYScrollView.h"
#define kTagOpusView  9999

@implementation ZYScrollView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

- (void)initOpusViewCount:(NSInteger)count placeholder:(UIImage *)placeholder delegate:(id<ZYScrollViewDelegate>)delegate left:(CGFloat)left top:(CGFloat)top gap:(CGFloat)gap {
    self.opusDelegate = delegate;
    for (id v in self.subviews) {
        [v removeFromSuperview];
    }
    CGFloat width = 0.f;
    for (int i = 0; i < count; i++) {
        UIView *opusView = [self.opusDelegate opusView:self index:i];
        opusView.tag = i + kTagOpusView;
        opusView.left = left + (opusView.width + gap)*i;
        opusView.top= top;
        [self addSubview:opusView];
        
        if (i == count - 1) {
            width += opusView.right;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOpusView:)];
        [opusView addGestureRecognizer:tap];
        
    }
    self.contentSize = CGSizeMake(width + gap, self.height);
}

- (void)tapOpusView:(UIGestureRecognizer*)tap {
    if ([self.opusDelegate respondsToSelector:@selector(opusView:didTapAtIndex:)]) {
        [self.opusDelegate opusView:self didTapAtIndex:tap.view.tag - kTagOpusView];
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
