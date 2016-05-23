//
//  GuideView.m
//  creditManager
//
//  Created by haodai on 16/4/5.
//  Copyright © 2016年 haodai. All rights reserved.
//

#import "GuideView.h"

@interface GuideView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *pageLable;
@end

@implementation GuideView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initPageView];
        [self initButton];
    }
    return self;
}

- (void)initPageView {
    UIScrollView *scr = [[UIScrollView alloc] initWithFrame:self.bounds];
    scr.showsHorizontalScrollIndicator = NO;
    scr.showsVerticalScrollIndicator = NO;
    scr.delegate = self;
    scr.bounces = YES;
    scr.pagingEnabled = YES;
    [self addSubview:scr];

    
    for (int i = 0; i < 3; i++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.width, 0, self.width, self.height)];
        if (IS_IPHONE_4_OR_LESS) {
            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_4.png",i+1]];
        }else if(IS_IPHONE_5) {
            NSLog(@"%@",[NSString stringWithFormat:@"%d_5.png",i+1]);
            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_5.png",i+1]];
        }else if(IS_IPHONE_6) {
            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_6.png",i+1]];
        }else if (IS_IPHONE_6P) {
            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_6p.png",i+1]];
        }
        [scr addSubview:img];
    }
    scr.contentSize = CGSizeMake(self.width*3, self.height);
   
}

- (void)initButton {
    UIImageView *page  = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 60 - 21.f, 17.f, 21.f, 21.f)];
    page.image = [UIImage imageNamed:@"guidePage"];
    [self addSubview:page];
    
    _pageLable = [[UILabel alloc] initWithFrame:page.bounds];
    _pageLable.backgroundColor = [UIColor clearColor];
    _pageLable.textAlignment = NSTextAlignmentCenter;
    _pageLable.font = [UIFont systemFontOfSize:17.f];
    _pageLable.textColor = [UIColor whiteColor];
    _pageLable.text = @"1";
    [page addSubview:_pageLable];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.width - 60, 17.f, 60, 21.f);
    [btn setTitle:@"跳过>>" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(removePageView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat f = (scrollView.contentOffset.x+2)/self.width;
    int i = (int)f + 1;
    _pageLable.text = [NSString stringWithFormat:@"%d",i];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > 2*self.width + 10) {
        if (self.exit) {
            self.exit();
        }
    }
}

- (void)removePageView {
    if (self.exit) {
        self.exit();
    }
}



@end
